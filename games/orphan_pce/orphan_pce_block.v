`timescale 1ns / 1ps
// Orphan Games: the PC Engine / TurboGrafx-16 (MiSTer's TurboGrafx16 core: HuC6280 CPU + PSG, HuC6270 VDC, HuC6260
// VCE; turned into Verilog with GHDL, see games/pce_vhdl) as an Orphan FPGA block. HuCards only (no CD-ROM).
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-3.0-or-later.
//
// Clocks: the bus at 100 MHz (clk); c43 = 100 x 9.875 / 23 = 42.93 MHz (the PC Engine's 42.95 MHz, 0.04 % slow), the
// console and its DDR read port (HP2) both run on it.
// THE HUCARD lives in the board's DDR (main.py: locked memory + this page table, like the NES2 core), up to 4 MB,
// read through the PS's HP2 port into a 32 KB cache of 32-byte lines (direct mapped on ROM A14..5). On a miss the
// CPU waits (the core's ROM_RDY = the HuC6280's WAIT), about 1 us, until the line is in.
//
// The ARM's view (word index in the slot):
//   0 CTRL      [0] run (0 = held in reset; the cache tags are cleared meanwhile)  [1] freeze the frame at its end
//               [2] frame DMA: every finished picture is copied over HP3 into slot 0 / slot 1 in turn (OCM)
//   1 PADS      [7:0] pad 1 as NES bits (0 A = I, 1 B = II, 2 Select, 3 Start = Run, 4 Up, 5 Down, 6 Left, 7 Right)
//   2 CART      [11:0] the HuCard's size in 4 KB units (the core's ROM_SZ: 128K, 256K, 384K, 512K, 768K and 2.5M
//               cards get their chip mapping from it)
//   4 FB_ADDR   frame buffer read pointer      5 AU_ADDR  audio read pointer
//   6 STATUS    [15:0] frames, [27:16] audio write pointer, [28] frozen     7 ID "PCE1"     8 LEVEL
//   9..11       real NES pads (orphan_nespad.v), as the other consoles
//  12 SHAPE     read: [9:0] dots in the last visible line (270, 360 or 540: the dot clock), [25:16] visible lines
//  13 PTADDR    write: [9:0] next page table entry     14 PTDATA  write: [19:0] physical 4 KB page, PTADDR += 1
//  15 PROBE     write: [21:0] cart offset: the FPGA reads those 8 bytes; read: [0] flips when done; 16 / 17 the bytes
//  18 CACHE     read: [0] tags cleared since CTRL[0] went to 0       19 MISSES  cache misses in the last frame
//  20 WAITS     console clocks spent waiting in the last frame        21 ERRORS DDR read errors   22 TOTAL misses
//  23 / 24     DMA_SLOT0 / DMA_SLOT1: where the copies go (physical, 128-byte aligned; main.py: the OCM)
//  25 DMA      read: [15:0] copies done, [16] the slot of the last one, [17] copying, [31:24] write errors
//  26 DMA_CLKS read: bus clocks the last copy took (it must end inside the 1.4 ms vertical blank)
//   512..767    read: frame buffer word, +1: 3 dots of 9 bits (GGGRRRBBB as the VCE gives them), dot 0 in [8:0];
//               240 lines x 86 words, 256 dots a line (the middle 256 of 270; 360 / 540-dot lines scaled to 256)
//   768..1023   read: audio word, +1: {right, left} signed 16-bit, 47.92 kHz
module orphan_pce_block #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output wire [7:0]  level,
    input  wire [15:0] hw_pads,
    input  wire [1:0]  hw_drive,
    output reg         hw_enable = 1'b0,
    output reg  [3:0]  hw_port1 = 4'd1,
    output reg  [3:0]  hw_port2 = 4'd2,
    output reg  [8:0]  hw_never = 9'h000,
    // the HuCard's DDR read port (AXI3 read channels of the PS's HP2), clocked by hp_clk = the console clock
    output wire        hp_clk,
    output reg  [31:0] hp_araddr = 32'd0,
    output reg  [3:0]  hp_arlen = 4'd0,
    output reg         hp_arvalid = 1'b0,
    input  wire        hp_arready,
    input  wire [63:0] hp_rdata,
    input  wire        hp_rvalid,
    input  wire        hp_rlast,
    input  wire [1:0]  hp_rresp,
    output wire        hp_rready,
    // the frame DMA's write port (AXI3 write channels of the PS's HP3), on the bus clock: 16-beat bursts of 64 bits
    output reg  [31:0] hpw_awaddr = 32'd0,
    output wire [3:0]  hpw_awlen,
    output reg         hpw_awvalid = 1'b0,
    input  wire        hpw_awready,
    output reg  [63:0] hpw_wdata = 64'd0,
    output reg         hpw_wlast = 1'b0,
    output reg         hpw_wvalid = 1'b0,
    input  wire        hpw_wready,
    input  wire [1:0]  hpw_bresp,
    input  wire        hpw_bvalid,
    output wire        hpw_bready
);
    localparam FBW = 20640;                          // 240 lines x 86 words
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- clock
    wire fb_o, fb_i, c43_o, c43, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(9.875), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(23.0)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(c43_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_b43 (.I(c43_o), .O(c43));
    assign hp_clk = c43;
    assign hp_rready = 1'b1;                         // a read is only asked for when there is room for it

    // ---------------------------------------------------------------- bus side registers
    reg [2:0]  ctrl = 3'd0;
    reg [15:0] pads = 16'd0;
    reg [11:0] cart = 12'd0;
    reg [14:0] fb_rd = 15'd0;
    reg        dma_use = 1'b0;                       // the frame DMA owns the frame buffer's read port
    reg [14:0] dma_ra = 15'd0;
    reg [10:0] au_rd = 11'd0;
    reg [9:0]  ptw = 10'd0;
    reg [21:0] probe_off = 22'd0;
    reg        probe_req = 1'b0;
    reg [15:0] pads_all = 16'd0;
    always @(posedge clk) pads_all <= pads | hw_pads;

    // ---------------------------------------------------------------- console side
    reg [1:0]  ctrl_s1 = 0, ctrl_s2 = 0;
    reg [15:0] pads_s1 = 0, pads_s2 = 0;
    reg [11:0] cart_s1 = 0, cart_s2 = 0;
    reg        pr_r1 = 0, pr_r2 = 0, pr_r3 = 0;
    always @(posedge c43) begin
        ctrl_s1 <= ctrl[1:0]; ctrl_s2 <= ctrl_s1; pads_s1 <= pads_all; pads_s2 <= pads_s1; cart_s1 <= cart; cart_s2 <= cart_s1;
        pr_r1 <= probe_req; pr_r2 <= pr_r1; pr_r3 <= pr_r2;
    end
    // a start (CTRL[0] 0 -> 1) is a cold start: RESET and COLD_RESET stay on 32768 more clocks, the time the core
    // needs to clear its video RAM and work RAM (CLR port)
    reg rst_a = 1'b1, cold = 1'b1;
    reg [15:0] cold_n = 16'd0;
    always @(posedge c43) begin
        if (!(ctrl_s2[0] && locked)) cold_n <= 16'd0;
        else if (!cold_n[15]) cold_n <= cold_n + 1'b1;
        rst_a <= !cold_n[15]; cold <= !cold_n[15];
    end
    wire freeze = ctrl_s2[1];
    wire [7:0] j1 = pads_s2[7:0];

    // the pad: the CPU picks a nibble with SEL (joy_out[0]); CLR (joy_out[1]) reads 0. Active low.
    wire [1:0]  joy_out;
    wire [7:0]  joy_data = ~{j1[6], j1[5], j1[7], j1[4], j1[3], j1[2], j1[1], j1[0]};   // {L D R U} {Run Sel II I}
    reg  [3:0]  joy_latch = 4'hF;
    always @(posedge c43) joy_latch <= joy_out[1] ? 4'h0 : joy_out[0] ? joy_data[7:4] : joy_data[3:0];

    wire        rom_rd, video_ce, video_vs, video_hs, video_hbl, video_vbl;
    wire [21:0] rom_a;
    wire [2:0]  vr, vg, vb;
    wire [15:0] psg_l, psg_r;
    reg         rom_rdy = 1'b1;
    wire [7:0]  rom_do;
    pce_top u_pce (
        .RESET(rst_a), .COLD_RESET(cold), .CLK(c43),
        .ROM_RD(rom_rd), .ROM_RDY(rom_rdy), .ROM_A(rom_a), .ROM_DO(rom_do), .ROM_SZ(cart_s2), .ROM_POP(1'b0), .ROM_CLKEN(),
        .BRM_A(), .BRM_DI(), .BRM_DO(8'hFF), .BRM_WE(),
        .GG_EN(1'b0), .GG_CODE(129'd0), .GG_RESET(1'b0), .GG_AVAIL(), .SP64(1'b0), .SGX(1'b0),
        .JOY_OUT(joy_out), .JOY_IN(joy_latch),
        .CD_EN(1'b0), .CD_RAM_A(), .CD_RAM_DO(), .CD_RAM_DI(8'hFF), .CD_RAM_RD(), .CD_RAM_WR(), .AC_EN(1'b0),
        .CD_STAT(8'd0), .CD_MSG(8'd0), .CD_STAT_GET(1'b0), .CD_COMM(), .CD_COMM_SEND(), .CD_DOUT_REQ(1'b0), .CD_DOUT(),
        .CD_DOUT_SEND(), .CD_REGION(1'b0), .CD_RESET(), .CD_DATA(8'd0), .CD_DATA_WR(1'b0), .CD_AUDIO_WR(1'b0),
        .CD_SUBCD_WR(1'b0), .CD_DATA_END(), .CD_DM(1'b0), .CDDA_SL(), .CDDA_SR(), .ADPCM_S(),
        .PSG_SL(psg_l), .PSG_SR(psg_r),
        .BG_EN(1'b1), .SPR_EN(1'b1), .GRID_EN(2'd0), .CPU_PAUSE_EN(1'b0), .BORDER_EN(1'b0), .ReducedVBL(1'b0),
        .VIDEO_R(vr), .VIDEO_G(vg), .VIDEO_B(vb), .VIDEO_BW(), .VIDEO_CE(video_ce), .VIDEO_CE_FS(),
        .VIDEO_VS(video_vs), .VIDEO_HS(video_hs), .VIDEO_HBL(video_hbl), .VIDEO_VBL(video_vbl));

    // ---------------------------------------------------------------- the HuCard: DDR + a 32 KB cache
    // Every clock the cache is looked up at ROM_A; one clock later its data and tag are in. ROM_RDY stays high only
    // when that answer belongs to the address the CPU still holds and the line is there.
    (* ram_style = "block" *) reg [63:0] cd [0:4095];        // 1024 lines x 4 words
    (* ram_style = "block" *) reg [7:0]  ct [0:1023];        // tag: valid + ROM A21..15
    (* ram_style = "block" *) reg [19:0] pt [0:1023];        // cart page -> physical page (written by the bus clock)
    reg  [63:0] cq = 64'd0;
    reg  [7:0]  tq = 8'd0;
    reg  [21:0] la = 22'd0;
    reg         d_we = 1'b0, t_we = 1'b0;
    reg  [11:0] d_wa = 12'd0;
    reg  [63:0] d_wd = 64'd0;
    reg  [9:0]  t_wa = 10'd0;
    reg  [7:0]  t_wd = 8'd0;
    always @(posedge c43) begin
        if (d_we) cd[d_wa] <= d_wd;
        cq <= cd[rom_a[14:3]];
    end
    always @(posedge c43) begin
        if (t_we) ct[t_wa] <= t_wd;
        tq <= ct[rom_a[14:5]];
    end
    always @(posedge c43) la <= rom_a;
    wire hit = (tq == {1'b1, la[21:15]});
    assign rom_do = cq[{la[2:0], 3'b000} +: 8];
    localparam F_IDLE = 3'd0, F_PT = 3'd1, F_PT2 = 3'd2, F_AR = 3'd3, F_R = 3'd4, F_TAG = 3'd5;
    reg  [2:0]  fst = F_IDLE;
    wire        miss = rom_rd && la == rom_a && !hit && fst == F_IDLE;
    always @(*) rom_rdy = !rom_rd || (la == rom_a && hit);
    reg         f_probe = 1'b0;
    reg  [16:0] f_line = 17'd0;
    reg  [21:0] f_off = 22'd0;
    reg  [1:0]  f_beat = 2'd0;
    reg  [19:0] pt_q = 20'd0;
    reg  [63:0] probe_q = 64'd0;
    reg         probe_ack = 1'b0, probe_pend = 1'b0, clean = 1'b0;
    reg  [10:0] sweep = 11'd0;
    reg  [31:0] errors = 32'd0, total = 32'd0;
    always @(posedge c43) pt_q <= pt[f_off[21:12]];
    always @(posedge c43) begin
        d_we <= 1'b0; t_we <= 1'b0;
        if (pr_r3 != pr_r2) probe_pend <= 1'b1;
        if (hp_rvalid && hp_rresp != 2'b00) errors <= errors + 1'b1;
        if (!ctrl_s2[0]) begin                       // held: sweep the tags to 0 (clean after one whole sweep)
            if (fst == F_IDLE) begin
                t_we <= 1'b1; t_wa <= sweep[9:0]; t_wd <= 8'd0;
                if (!sweep[10]) sweep <= sweep + 1'b1;
                clean <= sweep[10];
            end else begin sweep <= 11'd0; clean <= 1'b0; end
        end else sweep <= 11'd0;
        case (fst)
            F_IDLE: if (miss) begin
                f_probe <= 1'b0; f_line <= la[21:5]; f_off <= {la[21:5], 5'd0}; total <= total + 1'b1; fst <= F_PT;
            end else if (probe_pend) begin
                probe_pend <= 1'b0; f_probe <= 1'b1; f_off <= {probe_off[21:3], 3'd0}; fst <= F_PT;
            end
            F_PT: fst <= F_PT2;                      // pt_q follows f_off
            F_PT2: begin
                hp_araddr <= {pt_q, f_off[11:0]}; hp_arlen <= f_probe ? 4'd0 : 4'd3; hp_arvalid <= 1'b1;
                f_beat <= 2'd0; fst <= F_AR;
            end
            F_AR: if (hp_arready) begin hp_arvalid <= 1'b0; fst <= F_R; end
            F_R: if (hp_rvalid) begin
                if (f_probe) probe_q <= hp_rdata;
                else begin d_we <= 1'b1; d_wa <= {f_line[9:0], f_beat}; d_wd <= hp_rdata; end
                f_beat <= f_beat + 1'b1;
                if (hp_rlast) begin
                    if (f_probe) begin probe_ack <= ~probe_ack; fst <= F_IDLE; end
                    else fst <= F_TAG;
                end
            end
            F_TAG: begin t_we <= 1'b1; t_wa <= f_line[9:0]; t_wd <= {1'b1, f_line[16:10]}; fst <= F_IDLE; end
            default: fst <= F_IDLE;
        endcase
    end

    // ---------------------------------------------------------------- picture: 256 x 240, 3 dots of 9 bits a word
    // A line's dots come on VIDEO_CE while HBL is low (the VCE's window is 2160 clocks: 270 dots at 5.37 MHz, 360 at
    // 7.16, 540 at 10.7). Up to 280 dots: the middle 256 are kept; wider lines are scaled down by keeping every dot
    // where (n x 256 / width) steps. The width is the one measured on the line before.
    (* ram_style = "block" *) reg [26:0] fb [0:FBW - 1];
    reg [8:0]  row = 9'd0, rows = 9'd0;
    reg [9:0]  dots = 10'd0, wl = 10'd256;
    reg [10:0] acc = 11'd0;
    reg [7:0]  x = 8'd0;
    reg        xfull = 1'b0;
    reg [17:0] pix = 18'd0;
    reg [1:0]  np = 2'd0;
    reg        cap = 1'b1, frozen = 1'b0, hbl_last = 1'b1, vbl_last = 1'b1;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [26:0] fb_wd = 27'd0;
    reg [14:0] fb_wa = 15'd0, row_base = 15'd0;
    reg [15:0] m_n = 16'd0, ml = 16'd0;
    reg [23:0] w_n = 24'd0, wlast = 24'd0;
    wire [8:0] dot = {vg, vr, vb};
    wire       wide = wl > 10'd280;
    reg  [4:0] skip = 5'd0;
    wire       keep = wide ? (acc + 11'd256 >= {1'b0, wl}) : (skip == 0);
    always @(posedge c43) begin
        fb_we <= 1'b0;
        if (miss) m_n <= m_n + 1'b1;
        if (!rom_rdy) w_n <= w_n + 1'b1;
        if (video_ce) begin
            hbl_last <= video_hbl; vbl_last <= video_vbl;
            // a line ends: keep its width, flush its last word, and set up the next line (so its first dot, on the
            // CE where HBL falls, already finds clean counters)
            if (video_hbl && !hbl_last && !video_vbl) begin
                wl <= dots;
                if (np != 0 && cap && row < 9'd240) begin                  // the last word of the line
                    fb_wd <= {9'd0, pix} >> (9 * (2 - np)); fb_wa <= row_base + 7'd85; fb_we <= 1'b1;
                end
                if (row != 9'h1FF) row <= row + 1'b1;
                row_base <= row_base + 7'd86;
                skip <= (dots <= 10'd280 && dots > 10'd256) ? dots[5:1] : 5'd0;      // (width - 256) / 2
                x <= 8'd0; xfull <= 1'b0; dots <= 10'd0; acc <= 11'd0; np <= 2'd0;
            end
            if (video_vbl && !vbl_last) begin                       // the visible picture ended
                frames <= frames + 1'b1; rows <= row; row <= 9'd0; row_base <= 15'd0; cap <= !freeze; frozen <= freeze;
                ml <= m_n; m_n <= 16'd0; wlast <= w_n; w_n <= 24'd0;
                x <= 8'd0; xfull <= 1'b0; dots <= 10'd0; acc <= 11'd0; np <= 2'd0;
            end
            if (!video_hbl && !video_vbl) begin
                dots <= dots + 1'b1;
                acc <= keep && wide ? acc + 11'd256 - wl : acc + 11'd256;
                if (skip != 0) skip <= skip - 1'b1;
                if (keep && !xfull && row < 9'd240) begin
                    x <= x + 1'b1; if (x == 8'd255) xfull <= 1'b1;
                    if (np == 2'd2) begin
                        np <= 2'd0;
                        if (cap) begin fb_wd <= {dot, pix}; fb_wa <= row_base + x / 2'd3; fb_we <= 1'b1; end
                    end else begin np <= np + 1'b1; pix <= {dot, pix[17:9]}; end
                end
            end
        end
    end
    always @(posedge c43) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [26:0] fbq = 27'd0;
    always @(posedge clk) fbq <= fb[dma_use ? dma_ra : fb_rd];

    // ---------------------------------------------------------------- sound: the PSG averaged over 896 clocks
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [9:0]  au_n = 10'd0;
    reg signed [25:0] sl = 26'sd0, sr = 26'sd0;
    reg        au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    wire signed [15:0] ol = sl >>> 10, or_ = sr >>> 10;
    always @(posedge c43) begin
        au_we <= 1'b0;
        if (au_n == 10'd895) begin
            au_n <= 10'd0; sl <= $signed(psg_l); sr <= $signed(psg_r);
            au_wd <= {or_, ol}; au_we <= 1'b1;
            lvl <= lvl - (lvl >> 6) + ((ol[15] ? -ol : ol) >> 6);
        end else begin
            au_n <= au_n + 1'b1; sl <= sl + $signed(psg_l); sr <= sr + $signed(psg_r);
        end
        if (au_we) au_wa <= au_wa + 1'b1;
    end
    always @(posedge c43) if (au_we) au[au_wa] <= au_wd;
    reg [31:0] auq = 32'd0;
    always @(posedge clk) auq <= au[au_rd];
    assign level = lvl[14:7];

    // ---------------------------------------------------------------- console -> bus
    function [15:0] g16(input [15:0] b); g16 = b ^ (b >> 1); endfunction
    function [15:0] b16(input [15:0] g); integer i; begin b16[15] = g[15];
        for (i = 14; i >= 0; i = i - 1) b16[i] = b16[i + 1] ^ g[i]; end endfunction
    reg [15:0] fr_g = 0, aw_g = 0;
    always @(posedge c43) begin fr_g <= g16(frames); aw_g <= g16({5'd0, au_wa}); end
    reg [15:0] fr_s1 = 0, fr_s2 = 0, aw_s1 = 0, aw_s2 = 0;
    reg [25:0] sh_s1 = 0, sh_s2 = 0;
    reg frz_s1 = 0, frz_s2 = 0, pa_s1 = 0, pa_s2 = 0, cl_s1 = 0, cl_s2 = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1; frz_s1 <= frozen; frz_s2 <= frz_s1;
        sh_s1 <= {rows, 6'd0, wl}; sh_s2 <= sh_s1; pa_s1 <= probe_ack; pa_s2 <= pa_s1; cl_s1 <= clean; cl_s2 <= cl_s1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);
    // page table writes (bus clock; the console is held while main.py writes it)
    reg        pt_we = 1'b0;
    reg [9:0]  pt_wa = 10'd0;
    reg [19:0] pt_wd = 20'd0;
    always @(posedge clk) if (pt_we) pt[pt_wa] <= pt_wd;

    // ---------------------------------------------------------------- frame DMA (CTRL[2]) over HP3
    // When a picture ends (the frame count moves) the whole frame buffer goes out as 645 bursts of 16 x 64 bits
    // (two words a beat, the lower word first) into the slot not copied last; then the slot and the count change,
    // so the ARM always reads a finished picture. The console writes no dots in the vertical blank (1.4 ms).
    assign hpw_awlen = 4'd15;
    assign hpw_bready = 1'b1;
    localparam D_IDLE = 3'd0, D_AW = 3'd1, D_R0 = 3'd2, D_R1 = 3'd3, D_R2 = 3'd4, D_R3 = 3'd5, D_W = 3'd6, D_B = 3'd7;
    reg [2:0]  dst = D_IDLE;
    reg [31:0] dma_base0 = 32'hFFFC0000, dma_base1 = 32'hFFFD8000, daddr = 32'd0, dlo = 32'd0;
    reg [15:0] dma_cnt = 16'd0, fr_seen = 16'd0;
    reg        dma_slot = 1'b1, wslot = 1'b0;
    reg [7:0]  dma_err = 8'd0;
    reg [23:0] dma_clks = 24'd0, clk_n = 24'd0;
    reg [14:0] dwa = 15'd0;
    reg [3:0]  dbn = 4'd0;
    always @(posedge clk) begin
        if (!rstn) begin dst <= D_IDLE; hpw_awvalid <= 1'b0; hpw_wvalid <= 1'b0; hpw_wlast <= 1'b0; dma_use <= 1'b0; end
        else begin
            if (dst != D_IDLE && !clk_n[23]) clk_n <= clk_n + 1'b1;
            case (dst)
                D_IDLE: begin
                    dma_use <= 1'b0;
                    if (fr_s2 != fr_seen) begin                  // the gray-coded frame count moved (no decode: short path)
                        fr_seen <= fr_s2;
                        if (ctrl[2]) begin
                            wslot <= !dma_slot; daddr <= dma_slot ? dma_base0 : dma_base1;
                            dwa <= 15'd0; clk_n <= 24'd0; dma_use <= 1'b1; dst <= D_AW;
                        end
                    end
                end
                D_AW: if (!hpw_awvalid) begin hpw_awaddr <= daddr; hpw_awvalid <= 1'b1; end
                      else if (hpw_awready) begin hpw_awvalid <= 1'b0; dbn <= 4'd0; dst <= D_R0; end
                D_R0: begin dma_ra <= dwa; dst <= D_R1; end
                D_R1: begin dma_ra <= dwa + 1'b1; dst <= D_R2; end
                D_R2: begin dlo <= {5'd0, fbq}; dst <= D_R3; end                       // fb[dwa]
                D_R3: begin hpw_wdata <= {5'd0, fbq, dlo}; hpw_wvalid <= 1'b1;          // fb[dwa + 1]
                            hpw_wlast <= (dbn == 4'd15); dst <= D_W; end
                D_W: if (hpw_wready) begin
                         hpw_wvalid <= 1'b0; hpw_wlast <= 1'b0; dwa <= dwa + 2'd2; dbn <= dbn + 1'b1;
                         dst <= (dbn == 4'd15) ? D_B : D_R0;
                     end
                D_B: if (hpw_bvalid) begin
                         if (hpw_bresp != 2'b00 && dma_err != 8'hFF) dma_err <= dma_err + 1'b1;
                         daddr <= daddr + 32'd128;
                         if (dwa >= FBW) begin
                             dma_slot <= wslot; dma_cnt <= dma_cnt + 1'b1; dma_clks <= clk_n; dma_use <= 1'b0; dst <= D_IDLE;
                         end else dst <= D_AW;
                     end
            endcase
        end
    end

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        pt_we <= 1'b0;
        if (!rstn) begin ctrl <= 3'd0; hw_enable <= 1'b0; hw_port1 <= 4'd1; hw_port2 <= 4'd2; hw_never <= 9'h000; end
        else if (bus_we && sel) begin
            case (idx)
                10'd0: ctrl <= bus_wdata[2:0];
                10'd1: pads <= bus_wdata[15:0];
                10'd2: cart <= bus_wdata[11:0];
                10'd4: fb_rd <= bus_wdata[14:0];
                10'd5: au_rd <= bus_wdata[10:0];
                10'd9: begin hw_enable <= bus_wdata[0];
                             hw_port1 <= (bus_wdata[7:4] >= 4'd1 && bus_wdata[7:4] <= 4'd9) ? bus_wdata[7:4] : 4'd1;
                             hw_port2 <= (bus_wdata[11:8] >= 4'd1 && bus_wdata[11:8] <= 4'd9) ? bus_wdata[11:8] : 4'd2; end
                10'd11: hw_never <= bus_wdata[8:0];
                10'd13: ptw <= bus_wdata[9:0];
                10'd14: begin pt_we <= 1'b1; pt_wa <= ptw; pt_wd <= bus_wdata[19:0]; ptw <= ptw + 1'b1; end
                10'd15: begin probe_off <= bus_wdata[21:0]; probe_req <= ~probe_req; end
                10'd23: dma_base0 <= {bus_wdata[31:7], 7'd0};
                10'd24: dma_base1 <= {bus_wdata[31:7], 7'd0};
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b10) begin bus_rdata <= {5'd0, fbq}; fb_rd <= (fb_rd == FBW - 1) ? 15'd0 : fb_rd + 1'b1; end
            else if (idx[9:8] == 2'b11) begin bus_rdata <= auq; au_rd <= au_rd + 1'b1; end
            else case (idx)
                10'd0: bus_rdata <= {29'd0, ctrl};
                10'd1: bus_rdata <= {16'd0, pads};
                10'd2: bus_rdata <= {20'd0, cart};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h50434531;                  // "PCE1"
                10'd8: bus_rdata <= {16'd0, lvl};
                10'd9: bus_rdata <= {7'd0, hw_enable, 6'd0, hw_drive, hw_pads};
                10'd10: bus_rdata <= {24'd0, hw_port2, hw_port1};
                10'd11: bus_rdata <= {23'd0, hw_never};
                10'd12: bus_rdata <= {6'd0, sh_s2};
                10'd15: bus_rdata <= {31'd0, pa_s2};
                10'd16: bus_rdata <= probe_q[31:0];
                10'd17: bus_rdata <= probe_q[63:32];
                10'd18: bus_rdata <= {31'd0, cl_s2};
                10'd19: bus_rdata <= {16'd0, ml};
                10'd20: bus_rdata <= {8'd0, wlast};
                10'd21: bus_rdata <= errors;
                10'd22: bus_rdata <= total;
                10'd23: bus_rdata <= dma_base0;
                10'd24: bus_rdata <= dma_base1;
                10'd25: bus_rdata <= {dma_err, 6'd0, dst != D_IDLE, dma_slot, dma_cnt};
                10'd26: bus_rdata <= {8'd0, dma_clks};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
