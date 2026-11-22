`timescale 1ns / 1ps
// Orphan Games: the Game Boy (VerilogBoy by Wenting Zhang, OHDL 1.0) as an Orphan FPGA block.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-2.0-or-later (this file).
//
// Clocks: the bus at 100 MHz (clk); the Game Boy at 4.1958 MHz (gclk = 100 x 12 / 35.75 / 8: an MMCM can not go
// below ~4.7 MHz, so its 33.57 MHz output is divided by 8 in a flip-flop and put on a BUFG, as VerilogBoy's own
// board port does). 0.04 % off a real Game Boy's 4.1943 MHz. Crossings: toggle handshakes and gray counters.
//
// The ARM's view (word index in the slot), the same shape as the NES block:
//   0 CTRL      [0] run (0 = held in reset)   [1] freeze the frame buffer at the next frame end
//   1 PADS      [7:0] bit 0 A, 1 B, 2 Select, 3 Start, 4 Up, 5 Down, 6 Left, 7 Right (the NES page's order)
//   2 CART      [1:0] mapper 0 none, 1 MBC1, 2 MBC5, 3 MBC3 (no clock)  [6:4] ROM banks - 1 (16 KB banks, max 8)
//               [9:8] RAM banks - 1 (8 KB banks, max 4)
//   3 UP_ADDR   write: next ROM byte address (0 .. 128 KB); read: uploads done
//   4 FB_ADDR   frame buffer read pointer      5 AU_ADDR  audio read pointer
//   6 STATUS    [15:0] frames, [27:16] audio write pointer, [28] frozen     7 ID "GB01"     8 LEVEL
//   512..767    write: 4 ROM bytes at UP_ADDR, +4;  read: frame buffer word, +1: 16 pixels of 2 bits, pixel 0 in
//               [1:0]; 160 x 144 = 1440 words; 0 = lightest
//   768..1023   read: audio word, +1: {right, left} signed 16-bit, 48.23 kHz
module orphan_gb_block #(parameter [3:0] SLOT = 4'd1) (
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

    // ---------------------------------------------------------------- Game Boy clock
    wire fb_o, fb_i, c33_o, c33, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(12.0), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(35.75)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(c33_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_b33 (.I(c33_o), .O(c33));
    reg [1:0] div = 2'd0;
    reg       graw = 1'b0;
    always @(posedge c33) begin div <= div + 1'b1; if (div == 2'd3) graw <= ~graw; end
    wire gclk;
    BUFG u_bg (.I(graw), .O(gclk));

    // ---------------------------------------------------------------- bus side registers
    reg [1:0]  ctrl = 2'd0;
    reg [7:0]  pads = 8'd0;
    reg [9:0]  cart = 10'd0;
    reg [16:0] up_addr = 17'd0, up_a = 17'd0;
    reg [31:0] up_data = 32'd0;
    reg        up_req = 1'b0;
    reg [15:0] up_count = 16'd0;
    reg [10:0] fb_rd = 11'd0;
    reg [10:0] au_rd = 11'd0;

    // ---------------------------------------------------------------- Game Boy side
    reg [1:0] ctrl_s1 = 0, ctrl_s2 = 0;
    reg [7:0] pads_s1 = 0, pads_s2 = 0;
    reg [9:0] cart_s1 = 0, cart_s2 = 0;
    reg up_r1 = 0, up_r2 = 0, up_r3 = 0;
    always @(posedge gclk) begin
        ctrl_s1 <= ctrl; ctrl_s2 <= ctrl_s1; pads_s1 <= pads; pads_s2 <= pads_s1;
        cart_s1 <= cart; cart_s2 <= cart_s1; up_r1 <= up_req; up_r2 <= up_r1; up_r3 <= up_r2;
    end
    reg rst_gb = 1'b1;
    always @(posedge gclk) rst_gb <= !(ctrl_s2[0] && locked);
    wire freeze = ctrl_s2[1];
    wire [1:0] mbc = cart_s2[1:0];
    wire [2:0] rom_mask = cart_s2[6:4];
    wire [1:0] ram_mask = cart_s2[9:8];
    // keypad: VerilogBoy's key[7:4] = {Down, Up, Left, Right}, key[3:0] = {Start, Select, B, A}
    wire [7:0] key = {pads_s2[5], pads_s2[4], pads_s2[6], pads_s2[7], pads_s2[3:0]};

    wire [15:0] a;
    wire [7:0]  dout;
    reg  [7:0]  din;
    wire        wr, rd, hs, vs, cpl, valid, done, fault, phi;
    wire [1:0]  pixel;
    wire [15:0] left, right;
    boy u_boy (.rst(rst_gb), .clk(gclk), .phi(phi), .a(a), .dout(dout), .din(din), .wr(wr), .rd(rd), .key(key),
               .hs(hs), .vs(vs), .cpl(cpl), .pixel(pixel), .valid(valid), .left(left), .right(right),
               .done(done), .fault(fault));

    // ---------------------------------------------------------------- cartridge: mapper + block RAM
    reg [6:0] rom_bank = 7'd1;
    reg [1:0] ram_bank = 2'd0;
    reg       ram_en = 1'b0, wr_last = 1'b0;
    always @(posedge gclk) begin
        wr_last <= wr;
        if (rst_gb) begin rom_bank <= 7'd1; ram_bank <= 2'd0; ram_en <= 1'b0; end
        else if (wr && !wr_last && !a[15]) begin
            case (a[14:13])
                2'b00: ram_en <= (dout[3:0] == 4'hA);
                2'b01: begin
                    if (mbc == 2'd2) begin if (!a[12]) rom_bank <= dout[6:0]; end                   // MBC5 low byte
                    else if (mbc == 2'd1) rom_bank <= (dout[4:0] == 5'd0) ? 7'd1 : {2'b00, dout[4:0]};   // MBC1
                    else if (mbc == 2'd3) rom_bank <= (dout[6:0] == 7'd0) ? 7'd1 : dout[6:0];           // MBC3
                end
                2'b10: ram_bank <= dout[1:0];
                default: ;
            endcase
        end
    end
    wire [2:0]  bank_eff = a[14] ? (rom_bank[2:0] & rom_mask) : 3'd0;
    wire [16:0] rom_a = {bank_eff, a[13:0]};
    wire [14:0] cram_a = {ram_bank & ram_mask, a[12:0]};
    wire        is_cram = (a[15:13] == 3'b101);

    // uploads (held in reset): 4 bytes per request
    reg [2:0]  up_step = 3'd0;
    reg [31:0] up_word = 32'd0;
    reg [16:0] up_wa = 17'd0;
    reg        up_ack = 1'b0;
    always @(posedge gclk) begin
        if (up_r3 != up_r2) begin up_word <= up_data; up_wa <= up_a; up_step <= 3'd4; end
        else if (up_step != 3'd0) begin
            up_word <= {8'd0, up_word[31:8]}; up_wa <= up_wa + 1'b1; up_step <= up_step - 1'b1;
            if (up_step == 3'd1) up_ack <= ~up_ack;
        end
    end
    wire        up_we = (up_step != 3'd0);
    wire [16:0] ra = up_we ? up_wa : rom_a;
    // ROM: four 32 KB block RAMs (a deeper memory would chain block RAMs, which nextpnr can not route)
    (* ram_style = "block" *) reg [7:0] rom0 [0:32767];
    (* ram_style = "block" *) reg [7:0] rom1 [0:32767];
    (* ram_style = "block" *) reg [7:0] rom2 [0:32767];
    (* ram_style = "block" *) reg [7:0] rom3 [0:32767];
    (* ram_style = "block" *) reg [7:0] cram [0:32767];
    reg [7:0] q0 = 0, q1 = 0, q2 = 0, q3 = 0, qc = 0;
    reg [1:0] qsel = 2'd0;
    always @(posedge gclk) begin if (up_we && ra[16:15] == 2'd0) rom0[ra[14:0]] <= up_word[7:0]; q0 <= rom0[ra[14:0]]; end
    always @(posedge gclk) begin if (up_we && ra[16:15] == 2'd1) rom1[ra[14:0]] <= up_word[7:0]; q1 <= rom1[ra[14:0]]; end
    always @(posedge gclk) begin if (up_we && ra[16:15] == 2'd2) rom2[ra[14:0]] <= up_word[7:0]; q2 <= rom2[ra[14:0]]; end
    always @(posedge gclk) begin if (up_we && ra[16:15] == 2'd3) rom3[ra[14:0]] <= up_word[7:0]; q3 <= rom3[ra[14:0]]; end
    always @(posedge gclk) begin
        if (wr && is_cram && ram_en) cram[cram_a] <= dout;
        qc <= cram[cram_a];
        qsel <= ra[16:15];
    end
    wire [7:0] rom_q = (qsel == 2'd0) ? q0 : (qsel == 2'd1) ? q1 : (qsel == 2'd2) ? q2 : q3;
    always @* din = !a[15] ? rom_q : (is_cram && ram_en) ? qc : 8'hFF;

    // ---------------------------------------------------------------- picture: 16 pixels per word, freeze-able
    (* ram_style = "block" *) reg [31:0] fb [0:1439];
    reg [10:0] fb_wa = 11'd0;
    reg [31:0] pix = 32'd0;
    reg [3:0]  npix = 4'd0;
    reg        cap = 1'b1, frozen = 1'b0, vs_last = 1'b0;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [31:0] fb_wd = 32'd0;
    always @(posedge gclk) begin
        fb_we <= 1'b0;
        vs_last <= vs;
        if (vs && !vs_last) begin                                   // the visible picture just ended
            frames <= frames + 1'b1; fb_wa <= 11'd0; npix <= 4'd0; cap <= !freeze; frozen <= freeze;
        end else if (valid && cap) begin
            if (npix == 4'd15) begin fb_wd <= {pixel, pix[31:2]}; fb_we <= 1'b1; npix <= 4'd0; end
            else begin pix <= {pixel, pix[31:2]}; npix <= npix + 1'b1; end
        end
        if (fb_we && fb_wa != 11'd1439) fb_wa <= fb_wa + 1'b1;
    end
    always @(posedge gclk) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [31:0] fbq = 32'd0;
    always @(posedge clk) fbq <= fb[fb_rd];

    // ---------------------------------------------------------------- sound: average over 87 clocks (48.23 kHz)
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [6:0]  au_n = 7'd0;
    reg signed [23:0] acc_l = 0, acc_r = 0;
    reg        au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    wire signed [15:0] sl = acc_l[22:7], sr = acc_r[22:7];
    always @(posedge gclk) begin
        au_we <= 1'b0;
        if (au_n == 7'd86) begin
            au_n <= 7'd0; acc_l <= $signed(left); acc_r <= $signed(right);
            au_wd <= {sr, sl}; au_we <= 1'b1;
            lvl <= lvl - (lvl >> 6) + ((sl[15] ? -sl : sl) >> 6);
        end else begin
            au_n <= au_n + 1'b1; acc_l <= acc_l + $signed(left); acc_r <= acc_r + $signed(right);
        end
        if (au_we) au_wa <= au_wa + 1'b1;
    end
    always @(posedge gclk) if (au_we) au[au_wa] <= au_wd;
    reg [31:0] auq = 32'd0;
    always @(posedge clk) auq <= au[au_rd];
    assign level = lvl[14:7];

    // ---------------------------------------------------------------- Game Boy -> bus: gray-coded counters
    function [15:0] g16(input [15:0] b); g16 = b ^ (b >> 1); endfunction
    function [15:0] b16(input [15:0] g); integer i; begin b16[15] = g[15];
        for (i = 14; i >= 0; i = i - 1) b16[i] = b16[i + 1] ^ g[i]; end endfunction
    reg [15:0] fr_g = 0, aw_g = 0;
    always @(posedge gclk) begin fr_g <= g16(frames); aw_g <= g16({5'd0, au_wa}); end
    reg [15:0] fr_s1 = 0, fr_s2 = 0, aw_s1 = 0, aw_s2 = 0;
    reg ack_s1 = 0, ack_s2 = 0, frz_s1 = 0, frz_s2 = 0, ack_last = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1;
        ack_s1 <= up_ack; ack_s2 <= ack_s1; frz_s1 <= frozen; frz_s2 <= frz_s1;
        ack_last <= ack_s2; if (ack_s2 != ack_last) up_count <= up_count + 1'b1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        if (!rstn) ctrl <= 2'd0;
        else if (bus_we && sel) begin
            if (idx[9]) begin
                if (!idx[8]) begin up_data <= bus_wdata; up_a <= up_addr; up_addr <= up_addr + 17'd4; up_req <= ~up_req; end
            end else case (idx)
                10'd0: ctrl <= bus_wdata[1:0];
                10'd1: pads <= bus_wdata[7:0];
                10'd2: cart <= bus_wdata[9:0];
                10'd3: up_addr <= bus_wdata[16:0];
                10'd4: fb_rd <= bus_wdata[10:0];
                10'd5: au_rd <= bus_wdata[10:0];
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b10) begin bus_rdata <= fbq; fb_rd <= (fb_rd == 11'd1439) ? 11'd0 : fb_rd + 1'b1; end
            else if (idx[9:8] == 2'b11) begin bus_rdata <= auq; au_rd <= au_rd + 1'b1; end
            else case (idx)
                10'd0: bus_rdata <= {30'd0, ctrl};
                10'd1: bus_rdata <= {24'd0, pads};
                10'd2: bus_rdata <= {22'd0, cart};
                10'd3: bus_rdata <= {16'd0, up_count};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h47423031;                  // "GB01"
                10'd8: bus_rdata <= {16'd0, lvl};
                10'd9: bus_rdata <= {30'd0, fault, done};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
