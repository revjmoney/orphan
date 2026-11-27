`timescale 1ns / 1ps
// Orphan Games: the Atari 2600 (A2601 by Retromaster, MiSTer port, GPL-3; turned into Verilog with GHDL, see
// games/a26_vhdl) as an Orphan FPGA block.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-3.0-or-later (this file, built with A2601).
//
// Clocks: the bus at 100 MHz (clk); c28 = 100 x 9.875 / 34.5 = 28.62 MHz (8 x the NTSC colour clock, 0.05 % off);
// the console at tclk = c28 / 8 = 3.578 MHz (an MMCM output can not go below ~4.7 MHz, so a flip-flop divides it and
// a BUFG carries it, as on the Game Boy). One tclk = one colour clock = one pixel; the CPU runs at tclk / 3.
// The cart ROM (32 KB block RAM) is read on c28, so its data is there well before the CPU takes it.
//
// The ARM's view (word index in the slot), the same shape as the other consoles:
//   0 CTRL      [0] run (0 = held in reset)   [1] freeze the frame buffer at the next frame end
//   1 PADS      [7:0] joystick 1, [15:8] joystick 2: bit 0 A, 1 B, 2 Select, 3 Start, 4 Up, 5 Down, 6 Left, 7 Right
//               (A or B = fire, Select = GAME SELECT switch, Start = GAME RESET switch)
//   2 CART      [3:0] bank switching (A2601: 0 by size, 1 F8, 2 F6, 3 FE, 4 E0, 5 3F, 6 F4, 7 DPC, 8 FA, 9 CV,
//               10 2K, 11 UA, 12 E7, 13 F0)  [4] Superchip RAM   [24:8] ROM size in bytes
//   3 UP_ADDR   write: next ROM byte address (0 .. 32 KB); read: uploads done
//   4 FB_ADDR   frame buffer read pointer      5 AU_ADDR  audio read pointer
//   6 STATUS    [15:0] frames, [27:16] audio write pointer, [28] frozen     7 ID "A261"     8 LEVEL
//   9 HWPADS    real NES pads on hashboard connectors (orphan_nespad.v), the same as the NES block
//               write: [0] enable, [7:4] pad 1's connector, [11:8] pad 2's connector (1..9 = J1..J9)
//               read:  [15:0] their buttons (pad 1 [7:0], pad 2 [15:8]), [17:16] pads being read, [24] enable
//               Joystick 1 = PADS[7:0] | pad 1, joystick 2 = PADS[15:8] | pad 2.
//  10 HWPADS2   read: [3:0] pad 1 connector, [7:4] pad 2 connector
//  11 HWNEVER   write/read: [8:0] connectors (bit n-1 = Jn) never driven or read. After the FPGA loads: none.
//  13 SWITCH    [0] TV TYPE black and white  [1] LEFT DIFFICULTY A  [2] RIGHT DIFFICULTY A  [3] PAL colours
//  14 YSTART    [8:0] first line kept after VSYNC (default 30); 240 lines are kept from there
//  15 LINES     read: [8:0] lines in the last frame (262 on a well-behaved NTSC game)
//   512..767    write: 4 ROM bytes at UP_ADDR, +4;  read: frame buffer word, +1: 4 pixels of 8 bits (the TIA colour
//               {hue, lum} 0..127, 0 = black), pixel 0 in [7:0]; 160 x 240 = 9600 words per frame, TWO frames:
//               words 0..9599 the even frames, 9600..19199 the odd ones (many 2600 games flicker: they draw
//               half their objects on each frame, so the ARM merges the two)
//   768..1023   read: audio word, +1: {right, left} signed 16-bit (the same), 48.35 kHz
module orphan_a26_block #(parameter [3:0] SLOT = 4'd1) (
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
    localparam FBW = 19200;                          // two frames of 9600 words
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- clocks
    wire fb_o, fb_i, c28_o, c28, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(9.875), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(34.5)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(c28_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_b28 (.I(c28_o), .O(c28));
    reg [1:0] div = 2'd0;
    reg       traw = 1'b0;
    always @(posedge c28) begin div <= div + 1'b1; if (div == 2'd3) traw <= ~traw; end
    wire tclk;
    BUFG u_bt (.I(traw), .O(tclk));

    // ---------------------------------------------------------------- bus side registers
    reg [1:0]  ctrl = 2'd0;
    reg [15:0] pads = 16'd0;
    reg [24:0] cart = 25'd0;
    reg [3:0]  sw = 4'd0;
    reg [8:0]  ystart = 9'd30;
    reg [14:0] up_addr = 15'd0, up_a = 15'd0;
    reg [31:0] up_data = 32'd0;
    reg        up_req = 1'b0;
    reg [15:0] up_count = 16'd0;
    reg [14:0] fb_rd = 15'd0;
    reg [10:0] au_rd = 11'd0;
    reg [15:0] pads_all = 16'd0;                  // browser | real pads, registered in clk before crossing
    always @(posedge clk) pads_all <= pads | hw_pads;

    // ---------------------------------------------------------------- console side
    reg [1:0]  ctrl_s1 = 0, ctrl_s2 = 0;
    reg [15:0] pads_s1 = 0, pads_s2 = 0;
    reg [24:0] cart_s1 = 0, cart_s2 = 0;
    reg [3:0]  sw_s1 = 0, sw_s2 = 0;
    reg [8:0]  ys_s1 = 0, ys_s2 = 0;
    always @(posedge tclk) begin
        ctrl_s1 <= ctrl; ctrl_s2 <= ctrl_s1; pads_s1 <= pads_all; pads_s2 <= pads_s1;
        cart_s1 <= cart; cart_s2 <= cart_s1; sw_s1 <= sw; sw_s2 <= sw_s1; ys_s1 <= ystart; ys_s2 <= ys_s1;
    end
    reg rst_a = 1'b1;
    always @(posedge tclk) rst_a <= !(ctrl_s2[0] && locked);
    wire freeze = ctrl_s2[1];
    wire [7:0] j1 = pads_s2[7:0], j2 = pads_s2[15:8];

    wire [15:0] rom_a;
    wire [7:0]  rom_q;
    wire [3:0]  aud0, aud1;
    wire        vsyn, hsyn, hblank, vblank;
    wire [6:0]  colu;
    A2601top u_a26 (
        .reset(rst_a), .clk(tclk), .vid_clk(tclk),
        .p1_l(!j1[6]), .p1_r(!j1[7]), .p1_u(!j1[4]), .p1_d(!j1[5]), .p1_f(!(j1[0] | j1[1])), .p1_f2(1'b1),
        .p2_l(!j2[6]), .p2_r(!j2[7]), .p2_u(!j2[4]), .p2_d(!j2[5]), .p2_f(!(j2[0] | j2[1])), .p2_f2(1'b1),
        .p_1(1'b1), .paddle_1(8'd0), .p_2(1'b1), .paddle_2(8'd0), .p_3(1'b1), .paddle_3(8'd0), .p_4(1'b1), .paddle_4(8'd0),
        .p_type(2'd0), .p_start(!(j1[3] | j2[3])), .p_select(!(j1[2] | j2[2])), .p_color(!sw_s2[0]),
        .sc(cart_s2[4]), .force_bs(cart_s2[3:0]), .rom_do(rom_q), .rom_size(cart_s2[24:8]),
        .pause(1'b0), .pal(sw_s2[3]), .p_dif(sw_s2[2:1]), .decomb(1'b0),
        .aud0(aud0), .aud1(aud1), .O_VSYNC(vsyn), .O_HSYNC(hsyn), .O_HBLANK(hblank), .O_VBLANK(vblank),
        .O_VIDEO_R(), .O_VIDEO_G(), .O_VIDEO_B(), .O_COLU(colu), .rom_a(rom_a));

    // ---------------------------------------------------------------- cartridge ROM: 32 KB block RAM on c28
    reg up_r1 = 0, up_r2 = 0, up_r3 = 0;
    always @(posedge c28) begin up_r1 <= up_req; up_r2 <= up_r1; up_r3 <= up_r2; end
    reg [2:0]  up_step = 3'd0;
    reg [31:0] up_word = 32'd0;
    reg [14:0] up_wa = 15'd0;
    reg        up_ack = 1'b0;
    always @(posedge c28) begin
        if (up_r3 != up_r2) begin up_word <= up_data; up_wa <= up_a; up_step <= 3'd4; end
        else if (up_step != 3'd0) begin
            up_word <= {8'd0, up_word[31:8]}; up_wa <= up_wa + 1'b1; up_step <= up_step - 1'b1;
            if (up_step == 3'd1) up_ack <= ~up_ack;
        end
    end
    wire up_we = (up_step != 3'd0);
    (* ram_style = "block" *) reg [7:0] rom [0:32767];
    reg [7:0] rq = 8'd0;
    always @(posedge c28) begin
        if (up_we) rom[up_wa] <= up_word[7:0];
        rq <= rom[up_we ? up_wa : rom_a[14:0]];
    end
    assign rom_q = rq;

    // ---------------------------------------------------------------- picture: 4 pixels per word, freeze-able
    (* ram_style = "block" *) reg [31:0] fb [0:FBW - 1];
    reg [8:0]  line = 9'd0, lines = 9'd0;
    reg [7:0]  x = 8'd160;
    reg [23:0] pix = 24'd0;
    reg        cap = 1'b1, frozen = 1'b0, vs_last = 1'b0, hs_last = 1'b0, hb_last = 1'b1;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [31:0] fb_wd = 32'd0;
    reg [14:0] fb_wa = 15'd0, row_base = 15'd0;
    wire [8:0] row = line - ys_s2;
    wire       keep = (line >= ys_s2) && (row < 9'd240) && cap;
    // the TIA's colour output runs 2 clocks ahead of its HBLANK: delay it so a line's 160 pixels line up
    reg [6:0]  colu_d1 = 7'd0, colu_d2 = 7'd0;
    always @(posedge tclk) begin colu_d1 <= colu; colu_d2 <= colu_d1; end
    wire [7:0] p = vblank ? 8'd0 : {1'b0, colu_d2};
    always @(posedge tclk) begin
        fb_we <= 1'b0;
        vs_last <= vsyn; hs_last <= hsyn; hb_last <= hblank;
        if (vsyn && !vs_last) begin                                     // a new frame starts
            frames <= frames + 1'b1; lines <= line; line <= 9'd0; cap <= !freeze; frozen <= freeze;
        end else if (hsyn && !hs_last) begin
            if (line != 9'h1FF) line <= line + 1'b1;
        end
        if (hb_last && !hblank) begin x <= 8'd0; row_base <= row * 8'd40 + (frames[0] ? 15'd9600 : 15'd0); end   // the visible part of a line starts
        else if (x != 8'd160) begin                                     // then exactly 160 pixels
            x <= x + 1'b1;
            if (keep) begin
                if (x[1:0] == 2'd3) begin fb_wd <= {p, pix}; fb_wa <= row_base + x[7:2]; fb_we <= 1'b1; end
                else pix <= {p, pix[23:8]};
            end
        end
    end
    always @(posedge tclk) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [31:0] fbq = 32'd0;
    always @(posedge clk) fbq <= fb[fb_rd];

    // ---------------------------------------------------------------- sound: two 4-bit channels, average over 74 clocks
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [6:0]  au_n = 7'd0;
    reg [11:0] acc = 12'd0;
    reg        au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    wire signed [15:0] s = ($signed({4'd0, acc}) - 16'sd1110) * 16'sd14;
    wire [4:0] mix = aud0 + aud1;
    always @(posedge tclk) begin
        au_we <= 1'b0;
        if (au_n == 7'd73) begin
            au_n <= 7'd0; acc <= mix;
            au_wd <= {s, s}; au_we <= 1'b1;
            lvl <= lvl - (lvl >> 6) + ((s[15] ? -s : s) >> 6);
        end else begin
            au_n <= au_n + 1'b1; acc <= acc + mix;
        end
        if (au_we) au_wa <= au_wa + 1'b1;
    end
    always @(posedge tclk) if (au_we) au[au_wa] <= au_wd;
    reg [31:0] auq = 32'd0;
    always @(posedge clk) auq <= au[au_rd];
    assign level = lvl[14:7];

    // ---------------------------------------------------------------- console -> bus: gray-coded counters
    function [15:0] g16(input [15:0] b); g16 = b ^ (b >> 1); endfunction
    function [15:0] b16(input [15:0] g); integer i; begin b16[15] = g[15];
        for (i = 14; i >= 0; i = i - 1) b16[i] = b16[i + 1] ^ g[i]; end endfunction
    reg [15:0] fr_g = 0, aw_g = 0;
    always @(posedge tclk) begin fr_g <= g16(frames); aw_g <= g16({5'd0, au_wa}); end
    reg [15:0] fr_s1 = 0, fr_s2 = 0, aw_s1 = 0, aw_s2 = 0;
    reg [8:0]  ln_s1 = 0, ln_s2 = 0;
    reg ack_s1 = 0, ack_s2 = 0, frz_s1 = 0, frz_s2 = 0, ack_last = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1; ln_s1 <= lines; ln_s2 <= ln_s1;
        ack_s1 <= up_ack; ack_s2 <= ack_s1; frz_s1 <= frozen; frz_s2 <= frz_s1;
        ack_last <= ack_s2; if (ack_s2 != ack_last) up_count <= up_count + 1'b1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        if (!rstn) begin ctrl <= 2'd0; hw_enable <= 1'b0; hw_port1 <= 4'd1; hw_port2 <= 4'd2; hw_never <= 9'h000; end
        else if (bus_we && sel) begin
            if (idx[9]) begin
                if (!idx[8]) begin up_data <= bus_wdata; up_a <= up_addr; up_addr <= up_addr + 15'd4; up_req <= ~up_req; end
            end else case (idx)
                10'd0: ctrl <= bus_wdata[1:0];
                10'd1: pads <= bus_wdata[15:0];
                10'd2: cart <= bus_wdata[24:0];
                10'd3: up_addr <= bus_wdata[14:0];
                10'd4: fb_rd <= bus_wdata[14:0];
                10'd5: au_rd <= bus_wdata[10:0];
                10'd9: begin hw_enable <= bus_wdata[0];
                             hw_port1 <= (bus_wdata[7:4] >= 4'd1 && bus_wdata[7:4] <= 4'd9) ? bus_wdata[7:4] : 4'd1;
                             hw_port2 <= (bus_wdata[11:8] >= 4'd1 && bus_wdata[11:8] <= 4'd9) ? bus_wdata[11:8] : 4'd2; end
                10'd11: hw_never <= bus_wdata[8:0];
                10'd13: sw <= bus_wdata[3:0];
                10'd14: ystart <= bus_wdata[8:0];
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
                10'd2: bus_rdata <= {7'd0, cart};
                10'd3: bus_rdata <= {16'd0, up_count};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h41323631;                  // "A261"
                10'd8: bus_rdata <= {16'd0, lvl};
                10'd9: bus_rdata <= {7'd0, hw_enable, 6'd0, hw_drive, hw_pads};
                10'd10: bus_rdata <= {24'd0, hw_port2, hw_port1};
                10'd11: bus_rdata <= {23'd0, hw_never};
                10'd13: bus_rdata <= {28'd0, sw};
                10'd14: bus_rdata <= {23'd0, ystart};
                10'd15: bus_rdata <= {23'd0, ln_s2};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
