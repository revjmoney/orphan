`timescale 1ns / 1ps
// Orphan Games: the Atari 7800 (MiSTer's Atari7800 core by Jamie Blanks, MIT: SALLY 6502, MARIA, TIA sound, RIOT,
// the 7800 cart mappers and POKEY; turned into plain Verilog with sv2v, see games/a78_vlog) as an Orphan FPGA block.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-3.0-or-later (this file; the core is MIT).
//
// Clocks: the bus at 100 MHz (clk); c14 = 100 x 9.875 / 69 = 14.312 MHz (the 7800's 14.318 MHz, 0.05 % slow).
// No BIOS: the core skips it (bypass_bios) and puts the BIOS's loader into RIOT RAM itself. 7800 carts only (2600
// carts play on orphan_a26). The cart (up to 128 KB) is in block RAM, written by the ARM after the .a78 header.
//
// The ARM's view (word index in the slot):
//   0 CTRL      [0] run (0 = held in reset)   [1] freeze the frame buffer at the next frame end
//   1 PADS      [7:0] joystick 1, [15:8] joystick 2 as NES bits: 0 A = fire 1 (left), 1 B = fire 2 (right),
//               2 Select = SELECT, 3 Start = RESET, 4 Up, 5 Down, 6 Left, 7 Right
//   2 CART      [15:0] the .a78 header's cart flags (bytes 53-54), [23:16] XM byte (63), [31:24] mapper (64, v4)
//   3 UP_ADDR   write: byte address of the next cart word (0 .. 128 KB), +4 per word written at 512
//   4 FB_ADDR   frame buffer read pointer      5 AU_ADDR  audio read pointer
//   6 STATUS    [15:0] frames, [27:16] audio write pointer, [28] frozen     7 ID "A781"     8 LEVEL
//   9..11       real NES pads (orphan_nespad.v), as the other consoles
//  12 SIZE      [17:0] the cart's size in bytes (after the header)
//  13 SWITCH    [0] PAUSE held  [1] left difficulty A  [2] right difficulty A
//  15 SHAPE     read: [9:0] dots in the last visible line, [25:16] visible lines
//   512..767    write: 4 cart bytes at UP_ADDR, +4;  read: frame buffer word, +1: 4 dots of 8 bits (MARIA's colour
//               code {hue, lum}), dot 0 in [7:0]; 240 lines x 80 words (320 dots)
//   768..1023   read: audio word, +1: {right, left} signed 16-bit, 48.03 kHz
module orphan_a78_block #(parameter [3:0] SLOT = 4'd1) (
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
    output reg  [8:0]  hw_never = 9'h000
);
    localparam FBW = 19200;                          // 240 lines x 80 words
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- clock
    wire fb_o, fb_i, c14_o, c14, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(9.875), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(69.0)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(c14_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_b14 (.I(c14_o), .O(c14));

    // ---------------------------------------------------------------- bus side registers
    reg [1:0]  ctrl = 2'd0;
    reg [15:0] pads = 16'd0;
    reg [31:0] cart = 32'd0;
    reg [17:0] size = 18'd0;
    reg [2:0]  sw = 3'd0;
    reg [16:0] up_addr = 17'd0;
    reg [14:0] fb_rd = 15'd0;
    reg [10:0] au_rd = 11'd0;
    reg        up_we = 1'b0;
    reg [16:0] up_wa = 17'd0;
    reg [31:0] up_wd = 32'd0;
    reg [15:0] pads_all = 16'd0;
    always @(posedge clk) pads_all <= pads | hw_pads;

    // ---------------------------------------------------------------- console side
    reg [1:0]  ctrl_s1 = 0, ctrl_s2 = 0;
    reg [15:0] pads_s1 = 0, pads_s2 = 0;
    reg [31:0] cart_s1 = 0, cart_s2 = 0;
    reg [17:0] size_s1 = 0, size_s2 = 0;
    reg [2:0]  sw_s1 = 0, sw_s2 = 0;
    always @(posedge c14) begin
        ctrl_s1 <= ctrl; ctrl_s2 <= ctrl_s1; pads_s1 <= pads_all; pads_s2 <= pads_s1;
        cart_s1 <= cart; cart_s2 <= cart_s1; size_s1 <= size; size_s2 <= size_s1; sw_s1 <= sw; sw_s2 <= sw_s1;
    end
    reg rst_a = 1'b1;
    always @(posedge c14) rst_a <= !(ctrl_s2[0] && locked);
    wire freeze = ctrl_s2[1];
    wire [7:0] ja = pads_s2[7:0], jb = pads_s2[15:8];

    // joysticks and console switches, as MiSTer's Atari7800.sv wires them (7800 mode)
    wire [7:0] PAin = {~ja[7], ~ja[6], ~ja[5], ~ja[4], ~jb[7], ~jb[6], ~jb[5], ~jb[4]};   // R L D U, stick 1 then 2
    wire [1:0] ilatch = {~(jb[0] | jb[1]), ~(ja[0] | ja[1])};                         // fire (one-button sense)
    wire [3:0] idump = {jb[0], jb[1], ja[0], ja[1]};                                  // two-button sticks
    wire [7:0] PAout, PBout;
    wire [7:0] PBin = {~sw_s2[2], ~sw_s2[1], PBout[5], PBout[4], ~sw_s2[0], PBout[2], ~(ja[2] | jb[2]), ~(ja[3] | jb[3])};

    wire [7:0]  red, green, blue;
    wire        hsync, vsync, hblank, vblank, ce_pix;
    wire [15:0] audio_l, audio_r;
    wire [24:0] cart_addr;
    wire [17:0] cartram_addr;
    wire        cartram_wr;
    wire [7:0]  cartram_wrdata, cart_q, cartram_q;
    Atari7800 u_a78 (
        .clk_sys(c14), .reset(rst_a), .pause(1'b0),
        .RED(red), .GREEN(green), .BLUE(blue), .HSync(hsync), .VSync(vsync), .HBlank(hblank), .VBlank(vblank),
        .VBlank_orig(), .ce_pix(ce_pix), .PAL(1'b0), .pal_temp(2'd0), .hsc_en(1'b0), .hsc_ram_cs(), .hsc_ram_dout(8'd0),
        .dout(), .cpu_ce(), .AUDIO_R(audio_r), .AUDIO_L(audio_l), .show_border(1'b0), .show_overscan(1'b0),
        .bypass_bios(1'b1), .cart_present(1'b1), .tia_mode(1'b0), .cpu_driver(1'b1), .cart_xm(cart_s2[23:16]),
        .cart_read(), .cart_out(cart_q), .bios_out(8'd0), .AB(), .cart_addr_out(cart_addr), .cart_flags(cart_s2[15:0]),
        .cart_mapper(cart_s2[31:24]), .cart_save(8'd0), .cart_size({14'd0, size_s2}), .cart_din(), .RW(), .loading(rst_a),
        .cartram_addr(cartram_addr), .cartram_wr(cartram_wr), .cartram_rd(), .cartram_wrdata(cartram_wrdata),
        .cartram_data(cartram_q),
        .clk_arm(c14), .arm_reset(1'b1), .mapper_load_start(1'b0), .mapper_load_addr(25'd0), .mapper_load_valid(1'b0),
        .mapper_load_data(8'd0), .mapper_load_end(1'b0), .mapper_load_wait(), .mapper_init_busy(),
        .fa2_nvram_request(), .fa2_nvram_write(), .fa2_nvram_addr(), .fa2_nvram_wdata(), .fa2_nvram_rdata(8'd0),
        .fa2_nvram_ready(1'b0), .fa2_nvram_dirty(),
        .ddram_clk(), .ddram_addr(), .ddram_burstcnt(), .ddram_busy(1'b0), .ddram_dout(64'd0), .ddram_dout_ready(1'b0),
        .ddram_rd(), .ddram_din(), .ddram_be(), .ddram_we(),
        .idump(idump), .i_out(), .ilatch(ilatch), .tia_stab(1'b0), .tia_f1(), .tia_pal(), .tia_en(),
        .PAin(PAin), .PBin(PBin), .PAout(PAout), .PBout(PBout), .PAread(),
        .force_bs(6'd0), .mapper_revision(3'd0), .cdf_ldx(1'b0), .cdf_ldy(1'b0), .cdf_fetch_offset_enable(1'b0),
        .cdf_fetch_offset(8'd0), .cdfj_entry(32'd0), .cdfj_stack(32'd0), .arm_audio_size_addr(16'd0), .sc(1'b0),
        .clearval(8'd0), .random(8'd0), .tape_in(2'd0), .fix_sc_cs(1'b0), .tia_hsync(),
        .comp(), .comp_tog(), .comp_hs(), .comp_vs(), .comp_hb(), .comp_vb(), .comp_burst_start(), .comp_burst_len(),
        .use_stereo(1'b0), .ps2_key(11'd0), .pokey_irq(1'b0), .minnie_en(1'b0), .minnie_alt(1'b0), .decomb(1'b0),
        .mapper(6'd0), .pal_load(1'b0), .pal_addr(10'd0), .pal_wr(1'b0), .pal_data(8'd0), .blend(1'b0), .i_read());

    // ---------------------------------------------------------------- cart ROM (128 KB) + cart RAM (16 KB)
    wire up_cart = up_we;
    a78_lanes #(.AW(17)) u_cart (.bclk(clk), .bwe(up_cart), .ba(up_wa[16:2]), .bd(up_wd),
        .cclk(c14), .cwe(1'b0), .ca(cart_addr[16:0]), .cd(8'd0), .cq(cart_q));
    (* ram_style = "block" *) reg [7:0] cram [0:16383];
    reg [7:0] crq = 8'd0;
    always @(posedge c14) begin
        if (cartram_wr) cram[cartram_addr[13:0]] <= cartram_wrdata;
        crq <= cram[cartram_addr[13:0]];
    end
    assign cartram_q = crq;

    // ---------------------------------------------------------------- picture: 320 dots x 240 lines of colour codes
    (* ram_style = "block" *) reg [31:0] fb [0:FBW - 1];
    reg [8:0]  row = 9'd0, rows = 9'd0;
    reg [9:0]  x = 10'd0, wl = 10'd0;
    reg [23:0] pix = 24'd0;
    reg        cap = 1'b1, frozen = 1'b0, hb_last = 1'b1, vb_last = 1'b1;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [31:0] fb_wd = 32'd0;
    reg [14:0] fb_wa = 15'd0, row_base = 15'd0;
    always @(posedge c14) begin
        fb_we <= 1'b0;
        if (ce_pix) begin
            hb_last <= hblank; vb_last <= vblank;
            if (hblank && !hb_last && !vblank) begin                  // a line ended: set up the next one
                wl <= x; x <= 10'd0;
                if (row != 9'h1FF) row <= row + 1'b1;
                row_base <= row_base + 15'd80;
            end
            if (vblank && !vb_last) begin                            // the visible picture ended
                frames <= frames + 1'b1; rows <= row; row <= 9'd0; row_base <= 15'd0; x <= 10'd0;
                cap <= !freeze; frozen <= freeze;
            end
            if (!hblank && !vblank) begin
                if (x != 10'h3FF) x <= x + 1'b1;
                if (x < 10'd320 && row < 9'd240) begin
                    if (x[1:0] == 2'd3) begin
                        if (cap) begin fb_wd <= {red, pix}; fb_wa <= row_base + x[9:2]; fb_we <= 1'b1; end
                    end else pix <= {red, pix[23:8]};
                end
            end
        end
    end
    always @(posedge c14) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [31:0] fbq = 32'd0;
    always @(posedge clk) fbq <= fb[fb_rd];

    // ---------------------------------------------------------------- sound: TIA + POKEY, one sample per 298 clocks
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [8:0]  au_n = 9'd0;
    reg        au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    wire signed [15:0] sl = {1'b0, audio_l[15:1]} - 16'sh2000, sr = {1'b0, audio_r[15:1]} - 16'sh2000;
    always @(posedge c14) begin
        au_we <= 1'b0;
        if (au_n == 9'd297) begin
            au_n <= 9'd0; au_wd <= {sr, sl}; au_we <= 1'b1;
            lvl <= lvl - (lvl >> 6) + ((sl[15] ? -sl : sl) >> 6);
        end else au_n <= au_n + 1'b1;
        if (au_we) au_wa <= au_wa + 1'b1;
    end
    always @(posedge c14) if (au_we) au[au_wa] <= au_wd;
    reg [31:0] auq = 32'd0;
    always @(posedge clk) auq <= au[au_rd];
    assign level = lvl[14:7];

    // ---------------------------------------------------------------- console -> bus
    function [15:0] g16(input [15:0] b); g16 = b ^ (b >> 1); endfunction
    function [15:0] b16(input [15:0] g); integer i; begin b16[15] = g[15];
        for (i = 14; i >= 0; i = i - 1) b16[i] = b16[i + 1] ^ g[i]; end endfunction
    reg [15:0] fr_g = 0, aw_g = 0;
    always @(posedge c14) begin fr_g <= g16(frames); aw_g <= g16({5'd0, au_wa}); end
    reg [15:0] fr_s1 = 0, fr_s2 = 0, aw_s1 = 0, aw_s2 = 0;
    reg [25:0] sh_s1 = 0, sh_s2 = 0;
    reg frz_s1 = 0, frz_s2 = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1; frz_s1 <= frozen; frz_s2 <= frz_s1;
        sh_s1 <= {rows, 6'd0, wl}; sh_s2 <= sh_s1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        up_we <= 1'b0;
        if (!rstn) begin ctrl <= 2'd0; hw_enable <= 1'b0; hw_port1 <= 4'd1; hw_port2 <= 4'd2; hw_never <= 9'h000; end
        else if (bus_we && sel) begin
            if (idx[9]) begin
                if (!idx[8]) begin up_wd <= bus_wdata; up_wa <= up_addr; up_we <= 1'b1; up_addr <= up_addr + 17'd4; end
            end else case (idx)
                10'd0: ctrl <= bus_wdata[1:0];
                10'd1: pads <= bus_wdata[15:0];
                10'd2: cart <= bus_wdata;
                10'd3: up_addr <= {bus_wdata[16:2], 2'b00};
                10'd4: fb_rd <= bus_wdata[14:0];
                10'd5: au_rd <= bus_wdata[10:0];
                10'd9: begin hw_enable <= bus_wdata[0];
                             hw_port1 <= (bus_wdata[7:4] >= 4'd1 && bus_wdata[7:4] <= 4'd9) ? bus_wdata[7:4] : 4'd1;
                             hw_port2 <= (bus_wdata[11:8] >= 4'd1 && bus_wdata[11:8] <= 4'd9) ? bus_wdata[11:8] : 4'd2; end
                10'd11: hw_never <= bus_wdata[8:0];
                10'd12: size <= bus_wdata[17:0];
                10'd13: sw <= bus_wdata[2:0];
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b10) begin bus_rdata <= fbq; fb_rd <= (fb_rd == FBW - 1) ? 15'd0 : fb_rd + 1'b1; end
            else if (idx[9:8] == 2'b11) begin bus_rdata <= auq; au_rd <= au_rd + 1'b1; end
            else case (idx)
                10'd0: bus_rdata <= {30'd0, ctrl};
                10'd1: bus_rdata <= {16'd0, pads};
                10'd2: bus_rdata <= cart;
                10'd3: bus_rdata <= {15'd0, up_addr};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h41373831;                  // "A781"
                10'd8: bus_rdata <= {16'd0, lvl};
                10'd9: bus_rdata <= {7'd0, hw_enable, 6'd0, hw_drive, hw_pads};
                10'd10: bus_rdata <= {24'd0, hw_port2, hw_port1};
                10'd11: bus_rdata <= {23'd0, hw_never};
                10'd12: bus_rdata <= {14'd0, size};
                10'd13: bus_rdata <= {29'd0, sw};
                10'd15: bus_rdata <= {6'd0, sh_s2};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule

// A byte-wide memory of 2^AW bytes as four byte lanes (as orphan_a2's a2_lanes): the bus writes a whole 32-bit
// word in one clock, the console reads one byte per clock.
module a78_lanes #(parameter AW = 17) (
    input  wire          bclk,
    input  wire          bwe,
    input  wire [AW-3:0] ba,
    input  wire [31:0]   bd,
    input  wire          cclk,
    input  wire          cwe,
    input  wire [AW-1:0] ca,
    input  wire [7:0]    cd,
    output wire [7:0]    cq
);
    reg [1:0] lane_d = 2'd0;
    genvar g;
    generate for (g = 0; g < 4; g = g + 1) begin : lane
        (* ram_style = "block" *) reg [7:0] m [0:(1 << (AW - 2)) - 1];
        reg [7:0] q = 8'd0;
        always @(posedge bclk) if (bwe) m[ba] <= bd[8 * g +: 8];
        always @(posedge cclk) q <= m[ca[AW-1:2]];
    end endgenerate
    always @(posedge cclk) lane_d <= ca[1:0];
    assign cq = lane_d == 2'd0 ? lane[0].q : lane_d == 2'd1 ? lane[1].q : lane_d == 2'd2 ? lane[2].q : lane[3].q;
endmodule
