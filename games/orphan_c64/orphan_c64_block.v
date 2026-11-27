`timescale 1ns / 1ps
// Orphan Games: the Commodore 64 (MiSTer's C64 core: FPGA64 by Peter Wendrich with the MiSTer work, T65 CPU, VIC-II,
// CIAs, SID; turned into Verilog with GHDL + sv2v, see games/c64_vhdl) as an Orphan FPGA block. No disk drive: the
// ARM puts .prg programs straight into RAM.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-3.0-or-later.
//
// Clocks: the bus at 100 MHz (clk); c32 = 100 x 11.125 / 34 = 32.72 MHz (the NTSC C64's 32.727 MHz).
// Commodore's ROMs are NOT in this design: the ARM uploads them (the owner's own files) after every load.
//
// The ARM's view (word index in the slot):
//   0 CTRL      [0] run (0 = held in reset)   [1] freeze the frame buffer at the next frame end
//   1 PADS      [7:0] joystick in port 2, [15:8] joystick in port 1, as NES bits (0 A / 1 B = fire, 4 Up, 5 Down,
//               6 Left, 7 Right)
//   2 KEY       [10:0] a PS/2 key event as MiSTer's ps2_key: [10] toggles per event, [9] pressed, [8] extended,
//               [7:0] set-2 scan code
//   3 UP_ADDR   write: byte address of the next upload word, +4 per word written at 512:
//               0x00000 BASIC + KERNAL (16 KB: $A000-$BFFF then $E000-$FFFF), 0x04000 character ROM (4 KB),
//               0x10000 RAM (64 KB, written between the C64's own RAM cycles, so programs go in while it runs)
//               (any byte address); read: words taken so far (each word is 1..4 byte writes on the C64's clock)
//  12 UP_LEN    [2:0] bytes of each upload word to write (1..4; 0 = 4)
//   4 FB_ADDR   frame buffer read pointer      5 AU_ADDR  audio read pointer
//   6 STATUS    [15:0] frames, [27:16] audio write pointer, [28] frozen     7 ID "C641"     8 LEVEL
//   9..11       real NES pads (orphan_nespad.v), as the other consoles
//  13 XSTART    [9:0] first dot kept after HSYNC (8 MHz dots)    14 YSTART [8:0] first line kept after VSYNC
//  15 SHAPE     read: [9:0] dots in the last line, [24:16] lines in the last frame
//   512..767    write: 4 bytes at UP_ADDR, +4;  read: frame buffer word, +1: 8 dots of 4 bits (the VIC-II colour
//               0..15), dot 0 in [3:0]; 240 lines x 48 words (384 dots)
//   768..1023   read: audio word, +1: {right, left} signed 16-bit (the SID), 48.05 kHz
module orphan_c64_block #(parameter [3:0] SLOT = 4'd1) (
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
    localparam FBW = 11520;                          // 240 lines x 48 words
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- clock
    wire fb_o, fb_i, c32_o, c32, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(11.125), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(34.0)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(c32_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_b32 (.I(c32_o), .O(c32));

    // ---------------------------------------------------------------- bus side registers
    reg [1:0]  ctrl = 2'd0;
    reg [15:0] pads = 16'd0;
    reg [10:0] key = 11'd0;
    reg [9:0]  xstart = 10'd100;
    reg [8:0]  ystart = 9'd16;
    reg [16:0] up_addr = 17'd0, up_a = 17'd0;
    reg [31:0] up_data = 32'd0;
    reg [2:0]  up_len = 3'd4;
    reg        up_req = 1'b0;
    reg [15:0] up_count = 16'd0;
    reg [13:0] fb_rd = 14'd0;
    reg [10:0] au_rd = 11'd0;
    reg [15:0] pads_all = 16'd0;
    always @(posedge clk) pads_all <= pads | hw_pads;

    // ---------------------------------------------------------------- console side
    reg [1:0]  ctrl_s1 = 0, ctrl_s2 = 0;
    reg [15:0] pads_s1 = 0, pads_s2 = 0;
    reg [10:0] key_s1 = 0, key_s2 = 0;
    reg [9:0]  xs_s1 = 0, xs_s2 = 0;
    reg [8:0]  ys_s1 = 0, ys_s2 = 0;
    always @(posedge c32) begin
        ctrl_s1 <= ctrl; ctrl_s2 <= ctrl_s1; pads_s1 <= pads_all; pads_s2 <= pads_s1; key_s1 <= key; key_s2 <= key_s1;
        xs_s1 <= xstart; xs_s2 <= xs_s1; ys_s1 <= ystart; ys_s2 <= ys_s1;
    end
    reg rstn_c = 1'b0;
    always @(posedge c32) rstn_c <= ctrl_s2[0] && locked;
    wire freeze = ctrl_s2[1];
    wire [7:0] p2 = pads_s2[7:0], p1 = pads_s2[15:8];
    // MiSTer joystick bits: 0 right, 1 left, 2 down, 3 up, 4 fire
    wire [6:0] joyB = {2'b00, p2[0] | p2[1], p2[4], p2[5], p2[6], p2[7]};
    wire [6:0] joyA = {2'b00, p1[0] | p1[1], p1[4], p1[5], p1[6], p1[7]};

    // uploads: one 32-bit word = 4 byte writes on c32 (ROM port, or RAM between the C64's own cycles)
    reg up_r1 = 0, up_r2 = 0, up_r3 = 0;
    always @(posedge c32) begin up_r1 <= up_req; up_r2 <= up_r1; up_r3 <= up_r2; end
    reg [2:0]  up_step = 3'd0;
    reg [31:0] up_word = 32'd0;
    reg [16:0] up_wa = 17'd0;
    reg        up_ack = 1'b0;

    wire [15:0] ram_addr;
    wire [7:0]  ram_dout, rd_r;
    wire        ram_ce, ram_we, hsync, vsync;
    wire [17:0] audio_l, audio_r;
    reg  [7:0]  ram_q;
    wire        rom_wr = (up_step != 3'd0) && !up_wa[16];
    wire        inj = (up_step != 3'd0) && up_wa[16] && !ram_ce;    // a RAM write in a free slot
    always @(posedge c32) begin
        if (up_r3 != up_r2) begin up_word <= up_data; up_wa <= up_a; up_step <= (up_len == 3'd0 || up_len > 3'd4) ? 3'd4 : up_len; end
        else if (up_step != 3'd0 && (rom_wr || inj)) begin
            up_word <= {8'd0, up_word[31:8]}; up_wa <= up_wa + 1'b1; up_step <= up_step - 1'b1;
            if (up_step == 3'd1) up_ack <= ~up_ack;
        end
    end

    fpga64_sid_iec u_c64 (
        .clk32(c32), .reset_n(rstn_c), .bios(2'b00), .pause(1'b0), .ps2_key(key_s2), .kbd_reset(1'b0), .shift_mod(2'b00),
        .ramDin(ram_q), .cia_mode(1'b0), .turbo_mode(2'b00), .turbo_speed(2'b00), .vic_variant(2'b00), .ntscMode(1'b1),
        .palette(3'd0), .game(1'b1), .exrom(1'b1), .io_rom(1'b0), .io_ext(1'b0), .io_data(8'hFF), .irq_n(1'b1),
        .nmi_n(1'b1), .dma_req(1'b0), .dma_addr(16'd0), .dma_dout(8'd0), .dma_we(1'b0), .irq_ext_n(1'b1),
        .joyA(joyA), .joyB(joyB), .pot1(8'hFF), .pot2(8'hFF), .pot3(8'hFF), .pot4(8'hFF),
        .sid_filter(2'b11), .sid_ver(2'b00), .sid_mode(3'd0), .sid_cfg(4'd0), .sid_fc_off_l(13'd0), .sid_fc_off_r(13'd0),
        .sid_ld_clk(c32), .sid_ld_addr(12'd0), .sid_ld_data(16'd0), .sid_ld_wr(1'b0), .sid_digifix(1'b0),
        .pb_i(8'hFF), .pa2_i(1'b1), .flag2_n_i(1'b1), .sp2_i(1'b1), .sp1_i(1'b1), .cnt2_i(1'b1), .cnt1_i(1'b1),
        .iec_data_i(1'b1), .iec_clk_i(1'b1),
        .c64rom_addr(up_wa[13:0]), .c64rom_data(up_word[7:0]), .c64rom_wr(rom_wr), .c64rom_char(up_wa[14]),
        .cass_sense(1'b1), .cass_read(1'b1),
        .pause_out(), .ramAddr(ram_addr), .ramDout(ram_dout), .ramCE(ram_ce), .ramWE(ram_we), .io_cycle(), .ext_cycle(),
        .refresh(), .hsync(hsync), .vsync(vsync), .r(rd_r), .g(), .b(), .nmi_ack(), .romL(), .romH(), .UMAXromH(),
        .IOE(), .IOF(), .freeze_key(), .mod_key(), .tape_play(), .tape_rew(), .tape_stop(), .tape_ff(),
        .tape_reset_counter(), .dma_cycle(), .dma_din(), .audio_l(audio_l), .audio_r(audio_r), .pb_o(), .pa2_o(),
        .pc2_n_o(), .sp2_o(), .sp1_o(), .cnt2_o(), .cnt1_o(), .iec_data_o(), .iec_clk_o(), .iec_atn_o(),
        .cass_motor(), .cass_write());

    // ---------------------------------------------------------------- RAM: 64 KB, one port shared with the injector
    // (an injector clock does not disturb what the C64 reads: it keeps seeing the last byte of its own address)
    // (two 32 KB halves: a 64K-deep block RAM would cascade, which the built-in toolchain can not route)
    (* ram_style = "block" *) reg [7:0] ram_lo [0:32767];
    (* ram_style = "block" *) reg [7:0] ram_hi [0:32767];
    wire [15:0] ra = inj ? up_wa[15:0] : ram_addr;
    wire        rwe = inj || (ram_ce && ram_we);
    wire [7:0]  rwd = inj ? up_word[7:0] : ram_dout;
    reg  [7:0]  q_lo = 8'd0, q_hi = 8'd0, hold = 8'd0;
    reg         hi_d = 1'b0, inj_d = 1'b0;
    always @(posedge c32) begin
        if (rwe && !ra[15]) ram_lo[ra[14:0]] <= rwd;
        q_lo <= ram_lo[ra[14:0]];
    end
    always @(posedge c32) begin
        if (rwe && ra[15]) ram_hi[ra[14:0]] <= rwd;
        q_hi <= ram_hi[ra[14:0]];
    end
    always @(posedge c32) hi_d <= ra[15];
    wire [7:0] bq = hi_d ? q_hi : q_lo;
    always @(posedge c32) begin inj_d <= inj; if (!inj_d) hold <= bq; end
    always @(*) ram_q = inj_d ? hold : bq;

    // ---------------------------------------------------------------- picture: 384 dots x 240 lines, 4 bits a dot
    // VIC-II dots come at c32 / 4 (8 MHz); the dot phase restarts at every HSYNC.
    (* ram_style = "block" *) reg [31:0] fb [0:FBW - 1];
    reg [1:0]  ph = 2'd0;
    reg [9:0]  hx = 10'd0, hl = 10'd0;
    reg [8:0]  vy = 9'd0, vl = 9'd0;
    reg [31:0] pix = 32'd0;
    reg        cap = 1'b1, frozen = 1'b0, hs_last = 1'b0, vs_last = 1'b0;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [31:0] fb_wd = 32'd0;
    reg [13:0] fb_wa = 14'd0;
    wire [9:0] cx = hx - xs_s2;
    wire [8:0] cy = vy - ys_s2;
    wire       inwin = hx >= xs_s2 && cx < 10'd384 && vy >= ys_s2 && cy < 9'd240;
    always @(posedge c32) begin
        fb_we <= 1'b0;
        hs_last <= hsync; vs_last <= vsync;
        if (hsync && !hs_last) begin ph <= 2'd0; hl <= hx; hx <= 10'd0; if (vy != 9'h1FF) vy <= vy + 1'b1; end
        else begin
            ph <= ph + 1'b1;
            if (ph == 2'd3) begin
                if (hx != 10'h3FF) hx <= hx + 1'b1;
                if (inwin) begin
                    pix <= {rd_r[3:0], pix[31:4]};
                    if (cx[2:0] == 3'd7 && cap) begin fb_wd <= {rd_r[3:0], pix[31:4]}; fb_wa <= cy * 6'd48 + cx[9:3]; fb_we <= 1'b1; end
                end
            end
        end
        if (vsync && !vs_last) begin
            frames <= frames + 1'b1; vl <= vy; vy <= 9'd0; cap <= !freeze; frozen <= freeze;
        end
    end
    always @(posedge c32) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [31:0] fbq = 32'd0;
    always @(posedge clk) fbq <= fb[fb_rd];

    // ---------------------------------------------------------------- sound: the SID, one sample per 681 clocks
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [9:0]  au_n = 10'd0;
    reg        au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    wire signed [15:0] sl = audio_l[17:2], sr = audio_r[17:2];
    always @(posedge c32) begin
        au_we <= 1'b0;
        if (au_n == 10'd680) begin
            au_n <= 10'd0; au_wd <= {sr, sl}; au_we <= 1'b1;
            lvl <= lvl - (lvl >> 6) + ((sl[15] ? -sl : sl) >> 6);
        end else au_n <= au_n + 1'b1;
        if (au_we) au_wa <= au_wa + 1'b1;
    end
    always @(posedge c32) if (au_we) au[au_wa] <= au_wd;
    reg [31:0] auq = 32'd0;
    always @(posedge clk) auq <= au[au_rd];
    assign level = lvl[14:7];

    // ---------------------------------------------------------------- console -> bus
    function [15:0] g16(input [15:0] b); g16 = b ^ (b >> 1); endfunction
    function [15:0] b16(input [15:0] g); integer i; begin b16[15] = g[15];
        for (i = 14; i >= 0; i = i - 1) b16[i] = b16[i + 1] ^ g[i]; end endfunction
    reg [15:0] fr_g = 0, aw_g = 0;
    always @(posedge c32) begin fr_g <= g16(frames); aw_g <= g16({5'd0, au_wa}); end
    reg [15:0] fr_s1 = 0, fr_s2 = 0, aw_s1 = 0, aw_s2 = 0;
    reg [24:0] sh_s1 = 0, sh_s2 = 0;
    reg ack_s1 = 0, ack_s2 = 0, ack_last = 0, frz_s1 = 0, frz_s2 = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1; frz_s1 <= frozen; frz_s2 <= frz_s1;
        sh_s1 <= {vl, 6'd0, hl}; sh_s2 <= sh_s1;
        ack_s1 <= up_ack; ack_s2 <= ack_s1; ack_last <= ack_s2; if (ack_s2 != ack_last) up_count <= up_count + 1'b1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        if (!rstn) begin ctrl <= 2'd0; hw_enable <= 1'b0; hw_port1 <= 4'd1; hw_port2 <= 4'd2; hw_never <= 9'h000; end
        else if (bus_we && sel) begin
            if (idx[9]) begin
                if (!idx[8]) begin up_data <= bus_wdata; up_a <= up_addr; up_addr <= up_addr + 17'd4; up_req <= ~up_req; end
            end else case (idx)
                10'd0: ctrl <= bus_wdata[1:0];
                10'd1: pads <= bus_wdata[15:0];
                10'd2: key <= bus_wdata[10:0];
                10'd3: up_addr <= bus_wdata[16:0];
                10'd12: up_len <= bus_wdata[2:0];
                10'd4: fb_rd <= bus_wdata[13:0];
                10'd5: au_rd <= bus_wdata[10:0];
                10'd9: begin hw_enable <= bus_wdata[0];
                             hw_port1 <= (bus_wdata[7:4] >= 4'd1 && bus_wdata[7:4] <= 4'd9) ? bus_wdata[7:4] : 4'd1;
                             hw_port2 <= (bus_wdata[11:8] >= 4'd1 && bus_wdata[11:8] <= 4'd9) ? bus_wdata[11:8] : 4'd2; end
                10'd11: hw_never <= bus_wdata[8:0];
                10'd13: xstart <= bus_wdata[9:0];
                10'd14: ystart <= bus_wdata[8:0];
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b10) begin bus_rdata <= fbq; fb_rd <= (fb_rd == FBW - 1) ? 14'd0 : fb_rd + 1'b1; end
            else if (idx[9:8] == 2'b11) begin bus_rdata <= auq; au_rd <= au_rd + 1'b1; end
            else case (idx)
                10'd0: bus_rdata <= {30'd0, ctrl};
                10'd1: bus_rdata <= {16'd0, pads};
                10'd2: bus_rdata <= {21'd0, key};
                10'd3: bus_rdata <= {16'd0, up_count};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h43363431;                  // "C641"
                10'd8: bus_rdata <= {16'd0, lvl};
                10'd9: bus_rdata <= {7'd0, hw_enable, 6'd0, hw_drive, hw_pads};
                10'd10: bus_rdata <= {24'd0, hw_port2, hw_port1};
                10'd11: bus_rdata <= {23'd0, hw_never};
                10'd13: bus_rdata <= {22'd0, xstart};
                10'd14: bus_rdata <= {23'd0, ystart};
                10'd15: bus_rdata <= {7'd0, sh_s2};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
