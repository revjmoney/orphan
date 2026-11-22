`timescale 1ns / 1ps
// Orphan Games: the Sega Master System and Game Gear as an Orphan FPGA block.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-3.0-or-later (this file).
// Inside: the T80 Z80 and the SMS VDP + video timing from MiSTer's SMS core (GPL), turned into Verilog by GHDL
// (games-work/ghdl_convert.sh), and jt89 (Jose Tejada, GPL-3) for the SN76489 sound chip. This file is the glue
// that MiSTer's system.vhd does: memory map, Sega mapper, I/O ports, pads, plus Orphan's picture/sound/upload path.
//
// Clock: 53.714 MHz (MMCM 100 x 11.75 / 21.875; the real master clock is 53.693), with clock enables like MiSTer's
// SMS.sv: Z80 + PSG every 15th clock (3.58 MHz), VDP every 5th, pixels every 10th, sprites every 2nd.
//
// The ARM's view (word index in the slot), the same shape as the NES / Game Boy blocks:
//   0 CTRL      [0] run  [1] freeze  [2] Game Gear mode
//   1 PADS      [7:0] bit 0 button 2, 1 button 1, 2 -, 3 Start/Pause, 4 Up, 5 Down, 6 Left, 7 Right (the page's
//               NES order: A = button 2, B = button 1)   [15:8] pad 2
//   2 CART      [3:0] ROM banks - 1 (16 KB banks, max 8 = 128 KB)
//   3 UP_ADDR   write: next ROM byte address; read: uploads done
//   4 FB_ADDR   5 AU_ADDR   6 STATUS [15:0] frames [27:16] audio write pointer [28] frozen   7 ID "SMS1"
//   512..767    write: 4 ROM bytes; read: frame buffer word. Master System: 256 x 192, 5 pixels of 6 bits
//               (BBGGRR, pixel 0 in [5:0], 9831 words); Game Gear: 160 x 144, 2 pixels of 12 bits (BGR 4-4-4,
//               pixel 0 in [11:0], 11520 words)
//   768..1023   read: audio word: {right, left} signed 16-bit, 48.0 kHz
module orphan_sms_block #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output wire [7:0]  level
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- console clock + clock enables
    wire fb_o, fb_i, s_o, sclk, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(11.75), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(21.875)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(s_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_bs (.I(s_o), .O(sclk));
    reg [4:0] clkd = 5'd0;
    reg ce_cpu = 0, ce_vdp = 0, ce_pix = 0, ce_sp = 0;
    always @(posedge sclk) begin
        ce_sp <= clkd[0]; ce_vdp <= 1'b0; ce_pix <= 1'b0; ce_cpu <= 1'b0;
        clkd <= clkd + 1'b1;
        case (clkd)
            5'd29: begin clkd <= 5'd0; ce_vdp <= 1'b1; ce_pix <= 1'b1; end
            5'd24: begin ce_cpu <= 1'b1; ce_vdp <= 1'b1; end
            5'd19: begin ce_vdp <= 1'b1; ce_pix <= 1'b1; end
            5'd14: ce_vdp <= 1'b1;
            5'd9:  begin ce_cpu <= 1'b1; ce_vdp <= 1'b1; ce_pix <= 1'b1; end
            5'd4:  ce_vdp <= 1'b1;
            default: ;
        endcase
    end

    // ---------------------------------------------------------------- bus side registers
    reg [2:0]  ctrl = 3'd0;
    reg [15:0] pads = 16'd0;
    reg [3:0]  cart = 4'd0;
    reg [16:0] up_addr = 17'd0, up_a = 17'd0;
    reg [31:0] up_data = 32'd0;
    reg        up_req = 1'b0;
    reg [15:0] up_count = 16'd0;
    reg [13:0] fb_rd = 14'd0;
    reg [10:0] au_rd = 11'd0;

    // ---------------------------------------------------------------- console side
    reg [2:0] ctrl_s1 = 0, ctrl_s2 = 0;
    reg [15:0] pads_s1 = 0, pads_s2 = 0;
    reg [3:0] cart_s1 = 0, cart_s2 = 0;
    reg up_r1 = 0, up_r2 = 0, up_r3 = 0;
    always @(posedge sclk) begin
        ctrl_s1 <= ctrl; ctrl_s2 <= ctrl_s1; pads_s1 <= pads; pads_s2 <= pads_s1;
        cart_s1 <= cart; cart_s2 <= cart_s1; up_r1 <= up_req; up_r2 <= up_r1; up_r3 <= up_r2;
    end
    reg reset_n = 1'b0;
    always @(posedge sclk) reset_n <= ctrl_s2[0] & locked;
    wire freeze = ctrl_s2[1];
    wire gg = ctrl_s2[2];
    wire [7:0] p1 = pads_s2[7:0], p2 = pads_s2[15:8];

    // ---------------------------------------------------------------- Z80
    wire        m1_n, mreq_n, iorq_n, rd_n, wr_n, rfsh_n, halt_n, busak_n;
    wire [15:0] A;
    wire [7:0]  cpu_do;
    reg  [7:0]  cpu_di;
    wire        vdp_irq_n;
    wire [229:0] z80_reg;
    wire [1:0]  z80_iset;
    wire        nmi_n = gg | !p1[3];                       // Master System: Pause = NMI; Game Gear: Start is a port
    T80s u_z80 (.RESET_n(reset_n), .CLK(sclk), .CEN(ce_cpu), .WAIT_n(1'b1), .INT_n(vdp_irq_n), .NMI_n(nmi_n),
                .BUSRQ_n(1'b1), .OUT0(1'b0), .DI(cpu_di), .DIRSet(1'b0), .DIR(230'd0), .M1_n(m1_n), .MREQ_n(mreq_n),
                .IORQ_n(iorq_n), .RD_n(rd_n), .WR_n(wr_n), .RFSH_n(rfsh_n), .HALT_n(halt_n), .BUSAK_n(busak_n),
                .A(A), .DO(cpu_do), .REG(z80_reg), .ISet_out(z80_iset));

    // ---------------------------------------------------------------- video timing + VDP
    wire [8:0] x, y;
    wire [7:0] vcounter_cpu;
    wire hsync, vsync, hblank, vblank, mask_column, y1;
    wire sm1, sm2, sm3, sm4;
    wire [21:0] vstate;
    video u_video (.clk(sclk), .ce_pix(ce_pix), .pal(1'b0), .border(1'b0), .ggres(gg), .mask_column(mask_column),
                   .cut_mask(1'b0), .smode_M1(sm1), .smode_M2(sm2), .smode_M3(sm3), .smode_M4(sm4),
                   .video_state_in(22'd0), .video_state_set(1'b0), .video_state_out(vstate), .x(x), .y(y),
                   .vcounter_cpu(vcounter_cpu), .hsync(hsync), .vsync(vsync), .hblank(hblank), .vblank(vblank));
    wire io = !iorq_n && m1_n;
    wire vdp_rd_n = (io && (A[7:6] == 2'b01 || A[7:6] == 2'b10)) ? rd_n : 1'b1;
    wire vdp_wr_n = (io && A[7:6] == 2'b10) ? wr_n : 1'b1;
    wire psg_wr_n = (io && A[7:6] == 2'b01) ? wr_n : 1'b1;
    wire [7:0] vdp_do;
    wire [11:0] color;
    wire [127:0] ss_regs;
    wire [383:0] ss_cram;
    wire [7:0] ss_vram;
    vdp u_vdp (.clk_sys(sclk), .ce_vdp(ce_vdp), .ce_pix(ce_pix), .ce_sp(ce_sp), .gg(gg), .ggres(gg), .se_bank(1'b0),
               .sp64(1'b0), .HL(1'b0), .mask_line_irq(1'b0), .capture_cpu_edges(1'b0), .legacy_ext_nt(1'b0),
               .RD_n(vdp_rd_n), .WR_n(vdp_wr_n), .WR_direct(1'b0), .A_direct(A[13:8]), .A(A[7:0]), .D_in(cpu_do),
               .x(x), .y(y), .vcounter_cpu(vcounter_cpu), .palettemode(1'b0), .black_column(1'b0), .ysj_quirk(1'b0),
               .reset_n(reset_n), .ss_regs_in(128'd0), .ss_regs_set(1'b0), .ss_cram_wr(1'b0), .ss_cram_A(5'd0),
               .ss_cram_D(12'd0), .ss_vram_en(1'b0), .ss_vram_A(15'd0), .ss_vram_WE(1'b0), .ss_vram_WA(15'd0),
               .ss_vram_WD(8'd0), .IRQ_n(vdp_irq_n), .D_out(vdp_do), .color(color), .y1(y1), .mask_column(mask_column),
               .smode_M1(sm1), .smode_M2(sm2), .smode_M3(sm3), .smode_M4(sm4), .ss_regs_out(ss_regs),
               .ss_cram_out(ss_cram), .ss_vram_D(ss_vram));

    // ---------------------------------------------------------------- sound (SN76489, stereo on the Game Gear)
    reg  [7:0] psg_mux = 8'hFF;
    always @(posedge sclk) if (!reset_n) psg_mux <= 8'hFF; else if (io && gg && A[7:0] == 8'h06 && !wr_n) psg_mux <= cpu_do;
    wire signed [10:0] snd_l, snd_r;
    wire psg_ready, psg_quiet;
    wire [55:0] psg_ss; wire [95:0] psg_ssx; wire [3:0] psg_div;
    jt89 u_psg (.clk(sclk), .clk_en(ce_cpu), .rst(!reset_n), .wr_n(psg_wr_n), .din(cpu_do), .mux(gg ? psg_mux : 8'hFF),
                .soundL(snd_l), .soundR(snd_r), .ready(psg_ready), .ss_out(psg_ss), .ss_set(1'b0), .ss_in(56'd0),
                .ss_ext_out(psg_ssx), .ss_ext_in(96'd0), .ss_ext_set(1'b0), .ss_div_out(psg_div), .ss_div_in(4'd0),
                .ss_quiescent(psg_quiet));

    // ---------------------------------------------------------------- cartridge (Sega mapper) + work RAM
    reg [2:0] bank0 = 3'd0, bank1 = 3'd1, bank2 = 3'd2;
    wire mem = !mreq_n;
    always @(posedge sclk) begin
        if (!reset_n) begin bank0 <= 3'd0; bank1 <= 3'd1; bank2 <= 3'd2; end
        else if (mem && !wr_n && A[15:2] == 14'h3FFF) case (A[1:0])     // $FFFD..$FFFF
            2'd1: bank0 <= cpu_do[2:0] & cart_s2[2:0];
            2'd2: bank1 <= cpu_do[2:0] & cart_s2[2:0];
            2'd3: bank2 <= cpu_do[2:0] & cart_s2[2:0];
            default: ;
        endcase
    end
    wire [2:0]  bank = (A[15:10] == 6'd0) ? 3'd0 : (A[15:14] == 2'd0) ? bank0 : (A[15:14] == 2'd1) ? bank1 : bank2;
    wire [16:0] rom_a = {bank, A[13:0]};
    // uploads (held in reset): 4 bytes per request
    reg [2:0]  up_step = 3'd0;
    reg [31:0] up_word = 32'd0;
    reg [16:0] up_wa = 17'd0;
    reg        up_ack = 1'b0;
    always @(posedge sclk) begin
        if (up_r3 != up_r2) begin up_word <= up_data; up_wa <= up_a; up_step <= 3'd4; end
        else if (up_step != 3'd0) begin
            up_word <= {8'd0, up_word[31:8]}; up_wa <= up_wa + 1'b1; up_step <= up_step - 1'b1;
            if (up_step == 3'd1) up_ack <= ~up_ack;
        end
    end
    wire        up_we = (up_step != 3'd0);
    wire [16:0] ra = up_we ? up_wa : rom_a;
    (* ram_style = "block" *) reg [7:0] rom0 [0:32767];
    (* ram_style = "block" *) reg [7:0] rom1 [0:32767];
    (* ram_style = "block" *) reg [7:0] rom2 [0:32767];
    (* ram_style = "block" *) reg [7:0] rom3 [0:32767];
    (* ram_style = "block" *) reg [7:0] wram [0:8191];
    reg [7:0] q0 = 0, q1 = 0, q2 = 0, q3 = 0, qw = 0;
    reg [1:0] qsel = 2'd0;
    always @(posedge sclk) begin if (up_we && ra[16:15] == 2'd0) rom0[ra[14:0]] <= up_word[7:0]; q0 <= rom0[ra[14:0]]; end
    always @(posedge sclk) begin if (up_we && ra[16:15] == 2'd1) rom1[ra[14:0]] <= up_word[7:0]; q1 <= rom1[ra[14:0]]; end
    always @(posedge sclk) begin if (up_we && ra[16:15] == 2'd2) rom2[ra[14:0]] <= up_word[7:0]; q2 <= rom2[ra[14:0]]; end
    always @(posedge sclk) begin if (up_we && ra[16:15] == 2'd3) rom3[ra[14:0]] <= up_word[7:0]; q3 <= rom3[ra[14:0]]; end
    always @(posedge sclk) begin
        if (mem && !wr_n && A[15:14] == 2'b11) wram[A[12:0]] <= cpu_do;
        qw <= wram[A[12:0]];
        qsel <= ra[16:15];
    end
    wire [7:0] rom_q = (qsel == 2'd0) ? q0 : (qsel == 2'd1) ? q1 : (qsel == 2'd2) ? q2 : q3;

    // ---------------------------------------------------------------- the CPU's data in: memory or ports
    // pads are active low: DC = {P2 down, P2 up, P1 TR (button 2), P1 TL (button 1), right, left, down, up}
    wire [7:0] port_dc = ~{p2[5], p2[4], p1[0], p1[1], p1[7], p1[6], p1[5], p1[4]};
    wire [7:0] port_dd = ~{4'b0000, p2[0], p2[1], p2[7], p2[6]};       // TH, reset button: not pressed
    wire [7:0] gg_port = (A[2:0] == 3'd0) ? {!p1[3], 1'b1, 6'd0} : (A[2:0] == 3'd5) ? 8'h00 : 8'hFF;
    always @* begin
        if (io) begin
            if (A[7:6] == 2'b11) cpu_di = A[0] ? port_dd : port_dc;
            else if (A[7:6] == 2'b00) cpu_di = (gg && A[7:3] == 5'd0) ? gg_port : 8'hFF;
            else cpu_di = vdp_do;
        end else
            cpu_di = (A[15:14] == 2'b11) ? qw : rom_q;
    end

    // ---------------------------------------------------------------- picture: freeze-able frame buffer
    (* ram_style = "block" *) reg [31:0] fb [0:12287];
    reg [13:0] fb_wa = 14'd0;
    reg [29:0] pix = 30'd0;
    reg [2:0]  npix = 3'd0;
    reg        cap = 1'b1, frozen = 1'b0, vb_last = 1'b0;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [31:0] fb_wd = 32'd0;
    wire [5:0] c6 = {color[11:10], color[7:6], color[3:2]};
    always @(posedge sclk) begin
        fb_we <= 1'b0;
        if (ce_pix) begin
            vb_last <= vblank;
            if (vblank && !vb_last) begin                          // the visible picture just ended
                frames <= frames + 1'b1; fb_wa <= 14'd0; npix <= 3'd0; cap <= !freeze; frozen <= freeze;
            end else if (!hblank && !vblank && cap) begin
                if (gg) begin                                     // 2 pixels of 12 bits
                    if (npix[0]) begin fb_wd <= {4'd0, color, pix[11:0]}; fb_we <= 1'b1; npix <= 3'd0; end
                    else begin pix[11:0] <= color; npix <= 3'd1; end
                end else begin                                    // 5 pixels of 6 bits
                    if (npix == 3'd4) begin fb_wd <= {2'd0, c6, pix[29:6]}; fb_we <= 1'b1; npix <= 3'd0; end
                    else begin pix <= {c6, pix[29:6]}; npix <= npix + 1'b1; end
                end
            end
        end
        if (fb_we && fb_wa != 14'd12287) fb_wa <= fb_wa + 1'b1;
    end
    always @(posedge sclk) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [31:0] fbq = 32'd0;
    always @(posedge clk) fbq <= fb[fb_rd];

    // ---------------------------------------------------------------- sound: average over 1119 clocks (48.0 kHz)
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [10:0] au_n = 11'd0;
    reg signed [22:0] acc_l = 0, acc_r = 0;
    reg        au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    wire signed [15:0] sl = acc_l[20:5], sr = acc_r[20:5];    // sum of 1119 x 11 bits, scaled to 16 bits
    always @(posedge sclk) begin
        au_we <= 1'b0;
        if (au_n == 11'd1118) begin
            au_n <= 11'd0; acc_l <= snd_l; acc_r <= snd_r;
            au_wd <= {sr, sl}; au_we <= 1'b1;
            lvl <= lvl - (lvl >> 6) + ((sl[15] ? -sl : sl) >> 6);
        end else begin
            au_n <= au_n + 1'b1; acc_l <= acc_l + snd_l; acc_r <= acc_r + snd_r;
        end
        if (au_we) au_wa <= au_wa + 1'b1;
    end
    always @(posedge sclk) if (au_we) au[au_wa] <= au_wd;
    reg [31:0] auq = 32'd0;
    always @(posedge clk) auq <= au[au_rd];
    assign level = lvl[14:7];

    // ---------------------------------------------------------------- console -> bus
    function [15:0] g16(input [15:0] b); g16 = b ^ (b >> 1); endfunction
    function [15:0] b16(input [15:0] g); integer i; begin b16[15] = g[15];
        for (i = 14; i >= 0; i = i - 1) b16[i] = b16[i + 1] ^ g[i]; end endfunction
    reg [15:0] fr_g = 0, aw_g = 0;
    always @(posedge sclk) begin fr_g <= g16(frames); aw_g <= g16({5'd0, au_wa}); end
    reg [15:0] fr_s1 = 0, fr_s2 = 0, aw_s1 = 0, aw_s2 = 0;
    reg ack_s1 = 0, ack_s2 = 0, frz_s1 = 0, frz_s2 = 0, ack_last = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1;
        ack_s1 <= up_ack; ack_s2 <= ack_s1; frz_s1 <= frozen; frz_s2 <= frz_s1;
        ack_last <= ack_s2; if (ack_s2 != ack_last) up_count <= up_count + 1'b1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);
    wire [13:0] fb_last = ctrl[2] ? 14'd11519 : 14'd9830;

    always @(posedge clk) begin
        if (!rstn) ctrl <= 3'd0;
        else if (bus_we && sel) begin
            if (idx[9]) begin
                if (!idx[8]) begin up_data <= bus_wdata; up_a <= up_addr; up_addr <= up_addr + 17'd4; up_req <= ~up_req; end
            end else case (idx)
                10'd0: ctrl <= bus_wdata[2:0];
                10'd1: pads <= bus_wdata[15:0];
                10'd2: cart <= bus_wdata[3:0];
                10'd3: up_addr <= bus_wdata[16:0];
                10'd4: fb_rd <= bus_wdata[13:0];
                10'd5: au_rd <= bus_wdata[10:0];
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b10) begin bus_rdata <= fbq; fb_rd <= (fb_rd == fb_last) ? 14'd0 : fb_rd + 1'b1; end
            else if (idx[9:8] == 2'b11) begin bus_rdata <= auq; au_rd <= au_rd + 1'b1; end
            else case (idx)
                10'd0: bus_rdata <= {29'd0, ctrl};
                10'd1: bus_rdata <= {16'd0, pads};
                10'd2: bus_rdata <= {28'd0, cart};
                10'd3: bus_rdata <= {16'd0, up_count};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h534D5331;                  // "SMS1"
                10'd8: bus_rdata <= {16'd0, lvl};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
