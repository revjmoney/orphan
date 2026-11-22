`timescale 1ns / 1ps
// [orphan] Orphan TinyLM: the int8 matrix-vector engine for a tiny Llama, its weights streamed from the board's DDR.
// by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later.
// Roots: the DDR streamers, the page table and the FIFO are Ardzy's mlp_ddr (project 19 AI Studio, by chryso,
// GPL-3.0, https://github.com/chrysovalantischryso/ardzy), cut to 2 HP ports. The lanes and the layout are new.
//
//   out_b[r] = sat16( (sum_c W[r][c] * x_b[c]) >> SHIFT )     b = 0..3: FOUR stories at once (a batch)
//   W, x signed int8, the sum exact in 32 bits; the ARM multiplies back by 2^SHIFT and the scales.
//
// 64 lanes = 16 rows x 4 stories: every clock one column arrives (8 bytes from HP0 = rows 0..7, 8 bytes from HP2 =
// rows 8..15) and each weight is multiplied with the 4 stories' x_b[c] (one DSP per lane). The DDR stream is read
// ONCE for all 4 stories: 4 x the work for the same memory traffic. Stream layout per port: for each group of 16
// rows, for each column c, one 64-bit word = the 8 rows' weights W[16g + lane][c].
//
// Registers (word index, slot SLOT):
//   0 CTRL   write 1: run             1 STATUS [0] busy [1] done
//   2 ROWS   multiple of 16, <= 4096   3 COLS 1 .. 2047
//   4 OFS    the matrix's first byte in every port's region (multiple of 128)
//   5 LEN    its bytes per port (rows / 16 * cols * 8, rounded up to 128)
//   6 REGION bytes per port region (multiple of 4096)
//   7 PTADDR, 8 PTDATA  the page table (physical page numbers, 16384 pages = 64 MB: several models at once)
//   9 OUTPTR write: where the next out read starts: 0 = bank 0 (stories 0 + 1), 4096 = bank 1 (stories 2 + 3)
//  10 CYCLES  11 STALLS  12 ERRORS  13 COUNT   14..17 debug: first word of each port
//  18 XSEL   which story's x the window 512..767 writes (0..3)     19 SHIFT  0..15
//  20 XBASE  word offset of the window in that story's x (x longer than 1024 bytes is written in pieces)
//  127 ID "TLM4"
//  512..767   write: x of story XSEL, words XBASE + 0..255 (x[4i] in the low byte; up to 2048 bytes per story)
//  768..1023  read: the next out word: bank 0 = {story 1, story 0}, bank 1 = {story 3, story 2} (16 bits each)
module tlm_gemv #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output wire        busy_led,
    output wire [5 * 32 - 1:0] dr_araddr, output wire [5 * 4 - 1:0] dr_arlen, output wire [4:0] dr_arvalid,
    input  wire [4:0] dr_arready, input wire [5 * 64 - 1:0] dr_rdata, input wire [4:0] dr_rvalid,
    input  wire [4:0] dr_rlast, input wire [9:0] dr_rresp, output wire [4:0] dr_rready
);
    localparam NP = 2;
    reg [15:0] a_r = 16'd0;
    reg [31:0] wd = 32'd0;
    reg        we_r = 1'b0, re_r = 1'b0;
    always @(posedge clk) begin a_r <= bus_addr; wd <= bus_wdata; we_r <= bus_we; re_r <= bus_re; end
    wire sel = (a_r[15:12] == SLOT);
    wire [9:0] idx = a_r[11:2];
    wire wr = we_r && sel;

    // ---- registers
    reg  [12:0] rows = 13'd16;
    reg  [10:0] cols = 11'd1;
    reg  [31:0] r_ofs = 32'd0, r_len = 32'd128, r_region = 32'd4096;
    reg  [31:0] cycles = 32'd0, stalls = 32'd0, errors = 32'd0, count = 32'd0, clk_count = 32'd0;
    reg  [14:0] ptw = 15'd0;
    reg  [19:0] pt [0:16383];
    reg         done = 1'b0;
    reg  [1:0]  xsel = 2'd0;
    reg  [3:0]  shift = 4'd0;
    reg  [8:0]  xbase = 9'd0;
    wire start = wr && idx == 10'd0 && wd[0];
    always @(posedge clk) if (wr) begin
        if (idx == 10'd2) rows <= wd[12:0];
        if (idx == 10'd3) cols <= wd[10:0];
        if (idx == 10'd4) r_ofs <= wd;
        if (idx == 10'd5) r_len <= wd;
        if (idx == 10'd6) r_region <= wd;
        if (idx == 10'd7) ptw <= wd[14:0];
        if (idx == 10'd8) begin pt[ptw[13:0]] <= wd[19:0]; ptw <= ptw + 1'b1; end
        if (idx == 10'd18) xsel <= wd[1:0];
        if (idx == 10'd19) shift <= wd[3:0];
        if (idx == 10'd20) xbase <= wd[8:0];
    end

    // ---- x: 4 stories x 2048 bytes in block RAM (one 512 x 32 per story), written a word at a time (story XSEL,
    // word XBASE + i). The lanes read a column AHEAD (cn = the column popped next), so x[c] is there on the pop.

    // ---- the two streamers (Ardzy's mlp_ddr, NP = 2: HP0 and HP2), bursts of 128 bytes into a FIFO each
    reg st_go = 1'b0;
    wire [1:0] f_dv;
    wire [127:0] f_do;
    wire pop_now;
    wire [1:0] pt_req, s_idle;
    wire [27:0] pt_page;
    reg  [1:0] pt_gnt = 2'd0;
    reg  [19:0] pt_q = 20'd0;
    wire [1:0] pt_want = pt_req & ~pt_gnt;
    wire [1:0] pt_pick = pt_want[0] ? 2'b01 : pt_want[1] ? 2'b10 : 2'b00;
    wire [13:0] pt_a = pt_want[0] ? pt_page[13:0] : pt_page[27:14];
    always @(posedge clk) begin pt_gnt <= pt_pick; pt_q <= pt[pt_a]; end
    // unused dr_ ports: ACP (0), HP1 (2), HP3 (4)
    assign dr_araddr[31:0] = 32'd0;   assign dr_arlen[3:0] = 4'd0;   assign dr_arvalid[0] = 1'b0; assign dr_rready[0] = 1'b1;
    assign dr_araddr[64 +: 32] = 32'd0; assign dr_arlen[8 +: 4] = 4'd0; assign dr_arvalid[2] = 1'b0; assign dr_rready[2] = 1'b1;
    assign dr_araddr[128 +: 32] = 32'd0; assign dr_arlen[16 +: 4] = 4'd0; assign dr_arvalid[4] = 1'b0; assign dr_rready[4] = 1'b1;
    genvar p;
    generate for (p = 0; p < NP; p = p + 1) begin : stream
        localparam integer D = 2 * p + 1;              // dr_ port 1 = HP0, 3 = HP2
        reg [31:0] pos = 32'd0;
        reg        active = 1'b0;
        reg [13:0] cur = 14'h3FFF;
        reg [19:0] pfn = 20'd0;
        reg        pfn_ok = 1'b0;
        reg [31:0] ar_a = 32'd0;
        reg        ar_v = 1'b0;
        reg [9:0]  infl = 10'd0;
        assign s_idle[p] = infl == 10'd0 && !ar_v;
        wire [31:0] v = (p == 0 ? 32'd0 : r_region) + r_ofs + pos;
        wire need = active && pos < r_len;
        wire [9:0] used;
        assign pt_req[p] = need && !(pfn_ok && v[25:12] == cur);
        assign pt_page[14 * p +: 14] = v[25:12];
        always @(posedge clk) begin
            if (pt_gnt[p]) begin pfn <= pt_q; cur <= v[25:12]; pfn_ok <= 1'b1; end
            if (ar_v && dr_arready[D]) ar_v <= 1'b0;
            infl <= infl + ((ar_v && dr_arready[D]) ? 10'd16 : 10'd0) - (dr_rvalid[D] ? 10'd1 : 10'd0);
            if (st_go) begin pos <= 32'd0; active <= 1'b1; pfn_ok <= 1'b0; end
            else if (need && pfn_ok && v[25:12] == cur && !ar_v && used + infl + 10'd16 <= 10'd512) begin
                ar_a <= {pfn, v[11:0]};
                ar_v <= 1'b1;
                pos <= pos + 32'd128;
            end
        end
        assign dr_araddr[32 * D +: 32] = ar_a;
        assign dr_arlen[4 * D +: 4] = 4'd15;
        assign dr_arvalid[D] = ar_v;
        assign dr_rready[D] = 1'b1;
        tlm_fifo u_f (.clk(clk), .clr(st_go), .din(dr_rdata[64 * D +: 64]), .wr(dr_rvalid[D]),
                      .dout(f_do[64 * p +: 64]), .dv(f_dv[p]), .pop(pop_now), .used(used));
    end endgenerate
    always @(posedge clk) if (st_go) errors <= 32'd0;
        else if ((dr_rvalid[1] && |dr_rresp[3:2]) || (dr_rvalid[3] && |dr_rresp[7:6])) errors <= errors + 1'b1;

    // ---- the state machine: one column per clock while both FIFOs have a word
    localparam S_IDLE = 3'd0, S_FLUSH = 3'd1, S_RUN = 3'd2, S_DRAIN = 3'd3, S_GO = 3'd4;
    reg [2:0]  state = S_IDLE;
    reg [127:0] first = 128'd0;                      // debug: the first word of each port in the last run
    reg [10:0] c = 11'd0;
    reg [8:0]  g = 9'd0;                               // group of 16 rows
    wire [8:0] last_g = rows[12:4] - 1'b1;
    reg [4:0]  drain = 5'd0;
    wire all_dv = &f_dv;
    assign pop_now = all_dv && state == S_RUN;
    // pipeline flags: 0 = pop, 1 = weights + x registered, 2 = products, 3 = accumulated
    reg v1 = 0, f1 = 0, l1 = 0, v2 = 0, f2 = 0, l2 = 0, d3 = 0;
    reg [8:0] g1 = 0, g2 = 0, g3 = 0;
    reg [127:0] w1 = 128'd0;
    reg  [31:0] x1 = 32'd0;                            // the 4 stories' x[c], story b in bits 8b
    wire [31:0] xr;
    wire [10:0] cn = !pop_now ? c : (c == cols - 1'b1) ? 11'd0 : c + 1'b1;   // the column popped next
    reg  [1:0]  cs = 2'd0;
    always @(posedge clk) cs <= cn[1:0];
    genvar xb;
    generate for (xb = 0; xb < 4; xb = xb + 1) begin : xread
        (* ram_style = "block" *) reg [31:0] xm [0:511];
        reg [31:0] xw = 32'd0;
        always @(posedge clk) begin
            if (wr && idx[9:8] == 2'b10 && xsel == xb) xm[xbase + idx[7:0]] <= wd;
            xw <= xm[cn[10:2]];
        end
        assign xr[8 * xb +: 8] = xw[8 * cs +: 8];
    end endgenerate
    // the serializer: 16 finished rows go into the two banks one per clock (4 stories x 16 bits per row)
    reg  [31:0] outm0 [0:4095], outm1 [0:4095];
    reg  [4:0]  ser = 5'd16;                            // 16 = idle
    reg  [8:0]  sg = 9'd0;
    wire [1023:0] sat;                                   // 64 lanes' results, shifted + saturated to 16 bits
    reg  [1023:0] hold = 1024'd0;
    always @(posedge clk) begin
        st_go <= 1'b0;
        if (state != S_IDLE) clk_count <= clk_count + 1'b1;
        v1 <= pop_now; f1 <= (c == 11'd0); l1 <= (c == cols - 1'b1); g1 <= g;
        if (pop_now) begin w1 <= f_do; x1 <= xr; end
        if (pop_now && c == 11'd0 && g == 9'd0) first <= f_do;
        v2 <= v1; f2 <= f1; l2 <= l1; g2 <= g1;
        d3 <= v2 && l2; g3 <= g2;                       // acc took its last product this clock
        // capture at d3: on the same edge the next group's first product may already overwrite acc
        if (d3) begin hold <= sat; sg <= g3; ser <= 5'd0; end
        else if (ser != 5'd16) ser <= ser + 1'b1;
        // row ser: lane (row, story b) sits at 16 * (4 * row + b)
        if (ser != 5'd16) begin
            outm0[{sg, ser[3:0]}] <= hold[64 * ser[3:0] +: 32];
            outm1[{sg, ser[3:0]}] <= hold[64 * ser[3:0] + 32 +: 32];
        end
        if (!rstn) state <= S_IDLE;
        else case (state)
            S_IDLE: if (start) begin state <= S_FLUSH; done <= 1'b0; clk_count <= 32'd1; stalls <= 32'd0; end
            S_FLUSH: if (&s_idle) begin st_go <= 1'b1; c <= 11'd0; g <= 9'd0; state <= S_GO; end
            // the FIFOs clear on this edge: only then may RUN pop (else a word left from the last run is column 0)
            S_GO: state <= S_RUN;
            S_RUN: if (pop_now) begin
                if (c == cols - 1'b1) begin
                    c <= 11'd0;
                    if (g == last_g) begin state <= S_DRAIN; drain <= 5'd28; end
                    g <= g + 1'b1;
                end else c <= c + 1'b1;
            end else stalls <= stalls + 1'b1;
            S_DRAIN: if (drain != 5'd0) drain <= drain - 1'b1;
                else begin state <= S_IDLE; done <= 1'b1; cycles <= clk_count; count <= count + 1'b1; end
        endcase
    end

    // ---- the 64 lanes: 16 rows x 4 stories
    genvar ln, bt;
    generate for (ln = 0; ln < 16; ln = ln + 1) begin : row
        wire signed [7:0] w = w1[8 * ln +: 8];          // rows 0..7 from HP0's word, 8..15 from HP2's
        for (bt = 0; bt < 4; bt = bt + 1) begin : story
            reg signed [15:0] prod = 16'sd0;
            reg signed [31:0] acc = 32'sd0;
            wire signed [7:0] x = x1[8 * bt +: 8];
            always @(posedge clk) begin
                if (v1) prod <= w * x;
                if (v2) acc <= f2 ? prod : acc + prod;
            end
            wire signed [31:0] sh = acc >>> shift;
            assign sat[16 * (4 * ln + bt) +: 16] = (sh > 32'sd32767) ? 16'h7FFF : (sh < -32'sd32768) ? 16'h8000 : sh[15:0];
        end
    end endgenerate

    // ---- bus reads (out[] pops from 768..1023)
    // out[] pops: the next word is fetched on the same clock (orp_n), so back-to-back pops (the ARM's burst
    // reads of a block) stay in order
    reg [12:0] orp = 13'd0;
    reg [31:0] q0 = 32'd0, q1 = 32'd0;
    reg        bank = 1'b0;
    wire pop_rd = re_r && sel && idx[9:8] == 2'b11;
    wire [12:0] orp_n = (wr && idx == 10'd9) ? wd[12:0] : pop_rd ? orp + 1'b1 : orp;
    always @(posedge clk) begin orp <= orp_n; q0 <= outm0[orp_n[11:0]]; q1 <= outm1[orp_n[11:0]]; bank <= orp_n[12]; end
    wire [31:0] oq = bank ? q1 : q0;
    always @(posedge clk) begin
        if (re_r) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b11) bus_rdata <= oq;
            else case (idx)
                10'd1: bus_rdata <= {30'd0, done, state != S_IDLE};
                10'd2: bus_rdata <= {19'd0, rows};
                10'd3: bus_rdata <= {21'd0, cols};
                10'd4: bus_rdata <= r_ofs;
                10'd5: bus_rdata <= r_len;
                10'd6: bus_rdata <= r_region;
                10'd10: bus_rdata <= cycles;
                10'd11: bus_rdata <= stalls;
                10'd12: bus_rdata <= errors;
                10'd13: bus_rdata <= count;
                10'd14: bus_rdata <= first[31:0];
                10'd15: bus_rdata <= first[63:32];
                10'd16: bus_rdata <= first[95:64];
                10'd17: bus_rdata <= first[127:96];
                10'd18: bus_rdata <= {30'd0, xsel};
                10'd19: bus_rdata <= {28'd0, shift};
                10'd20: bus_rdata <= {23'd0, xbase};
                10'd127: bus_rdata <= 32'h544C4D34;      // "TLM4"
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
    assign busy_led = state != S_IDLE;
endmodule

// Ardzy's mlp_fifo: first-word-fall-through, 512 x 64 bits (block RAM).
module tlm_fifo (input wire clk, input wire clr, input wire [63:0] din, input wire wr, output reg [63:0] dout = 64'd0,
                 output reg dv = 1'b0, input wire pop, output wire [9:0] used);
    reg [63:0] mem [0:511];
    reg [8:0] wp = 9'd0, rp = 9'd0;
    reg [9:0] n = 10'd0;
    wire rd = n != 10'd0 && (!dv || pop);
    always @(posedge clk) begin
        if (clr) begin wp <= 9'd0; rp <= 9'd0; n <= 10'd0; dv <= 1'b0; end
        else begin
            if (wr) begin mem[wp] <= din; wp <= wp + 1'b1; end
            if (rd) begin dout <= mem[rp]; rp <= rp + 1'b1; end
            dv <= rd ? 1'b1 : (pop ? 1'b0 : dv);
            n <= n + (wr ? 10'd1 : 10'd0) - (rd ? 10'd1 : 10'd0);
        end
    end
    assign used = n + dv;
endmodule
