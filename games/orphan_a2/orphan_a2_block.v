`timescale 1ns / 1ps
// Orphan Games: the Apple IIe (MiSTer's Apple-II core of 2024: Stephen A. Edwards' apple2fpga with the //e work by
// Gyorgy Szombathelyi, R65C02 CPU; turned into Verilog with GHDL, see games/a2_vhdl) as an Orphan FPGA block.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-3.0-or-later.
//
// Clocks: the bus at 100 MHz (clk); c14 = 100 x 9.875 / 69 = 14.312 MHz (the Apple's 14.318 MHz, 0.05 % slow).
// Apple's ROMs are NOT in this design: the ARM uploads them (the board owner's own files) after every load.
//
// The ARM's view (word index in the slot):
//   0 CTRL      [0] run (0 = held in reset; a reset with [2] = 0 also clears $3F4, so the ROM cold-starts)
//               [1] freeze the frame buffer at the next frame end   [2] warm reset (keep $3F4: like Ctrl-Reset)
//   1 PADS      [7:0] joystick 1 as NES bits (0 A, 1 B, 4 Up, 5 Down, 6 Left, 7 Right): paddle 0/1 + buttons 0/1
//   2 KEY       write: [6:0] ASCII, [8] a key is held (AKD), [9] toggle = a new key press (sets the strobe)
//               read:  [7:0] the keyboard latch (bit 7 = strobe), [8] AKD
//   3 UP_ADDR   write: byte address of the next upload word (multiple of 4), +4 per word written at 512
//               0x20000 ROM C000-FFFF 16K, 0x24000 video ROM 8K,
//               0x26000 Disk II boot ROM 256 bytes, 0x28000 the drive's track buffer (6656 bytes of nibbles)
//   4 FB_ADDR   frame buffer read pointer      5 AU_ADDR  audio read pointer
//   6 STATUS    [15:0] frames, [27:16] audio write pointer, [28] frozen     7 ID "A2E1"     8 LEVEL
//   9..11       real NES pads (orphan_nespad.v), as the other consoles
//  12 DISK      write: [0] a disk is in drive 1, [13:8] the track now in the track buffer (the drive only reads
//               while the head is on that track, so a stale track is never seen)
//               read:  [5:0] the head's track (0..34), [8] motor on, [16] disk in, [29:24] loaded track
//               Disks are write-protected (no write-back yet).
//  15 LINES     read: [8:0] lines in the last frame (262 NTSC)
//   512..767    write: 4 bytes at UP_ADDR, +4;  read: frame buffer word, +1
//               192 rows x 18 words: 560 dots (bit x % 32 of word x / 32, 1 = lit), word 17 bit 31 = colour line
//               (graphics: the browser decodes NTSC colour from the dot pattern; text lines stay white)
//   768..1023   read: audio word, +1: {right, left} signed 16-bit (the same), 48.03 kHz (the speaker averaged)
module orphan_a2_block #(parameter [3:0] SLOT = 4'd1) (
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
    localparam FBW = 3456;                           // 192 rows x 18 words
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- clock
    wire fb_o, fb_i, c14_o, c14, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(9.875), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(69.0)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(c14_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_b14 (.I(c14_o), .O(c14));

    // ---------------------------------------------------------------- bus side registers
    reg [2:0]  ctrl = 3'd0;
    reg [15:0] pads = 16'd0;
    reg [9:0]  key = 10'd0;
    reg [13:0] disk = 14'd0;
    reg [17:0] up_addr = 18'd0;
    reg [14:0] fb_rd = 15'd0;
    reg [10:0] au_rd = 11'd0;
    reg [15:0] pads_all = 16'd0;
    always @(posedge clk) pads_all <= pads | hw_pads;
    // uploads: one 32-bit word straight into the four byte lanes of the chosen memory (bus clock write port)
    reg        up_we = 1'b0;
    reg [17:0] up_wa = 18'd0;
    reg [31:0] up_wd = 32'd0;
    wire up_rom  = up_we && up_wa[17:14] == 4'b1000;
    wire up_vrom = up_we && up_wa[17:13] == 5'b10010;
    wire up_drom = up_we && up_wa[17:13] == 5'b10011;
    wire up_trk  = up_we && up_wa[17:15] == 3'b101;

    // ---------------------------------------------------------------- console side
    reg [2:0]  ctrl_s1 = 0, ctrl_s2 = 0;
    reg [15:0] pads_s1 = 0, pads_s2 = 0;
    reg [9:0]  key_s1 = 0, key_s2 = 0;
    reg [13:0] disk_s1 = 0, disk_s2 = 0;
    always @(posedge c14) begin
        ctrl_s1 <= ctrl; ctrl_s2 <= ctrl_s1; pads_s1 <= pads_all; pads_s2 <= pads_s1;
        key_s1 <= key; key_s2 <= key_s1; disk_s1 <= disk; disk_s2 <= disk_s1;
    end
    reg rst_a = 1'b1, cold = 1'b1;
    always @(posedge c14) begin rst_a <= !(ctrl_s2[0] && locked); cold <= !ctrl_s2[0] && !ctrl_s2[2]; end
    wire freeze = ctrl_s2[1];
    wire [7:0] j1 = pads_s2[7:0];

    wire [17:0] ram_addr;
    wire [7:0]  ram_di, rom_d, vrom_d, drom_d, trk_q, track_di;
    wire        ram_we, ram_aux, video, color_line, text_mode, hbl, vbl, read_key, pdl_strobe, clk2m, speaker;
    wire        d1_active, track_we;
    wire [13:0] rom_a;
    wire [12:0] vrom_a, track_addr;
    wire [7:0]  drom_a;
    wire [5:0]  track;
    reg  [15:0] ram_do;
    reg  [7:0]  kbd = 8'd0;
    reg  [7:0]  gameport = 8'd0;
    a2core u_a2 (
        .CLK_14M(c14), .reset(rst_a), .ram_addr(ram_addr), .ram_di(ram_di), .ram_do(ram_do), .ram_we(ram_we),
        .ram_aux(ram_aux), .rom_a(rom_a), .rom_d(rom_d), .vrom_a(vrom_a), .vrom_d(vrom_d), .drom_a(drom_a),
        .drom_d(drom_d), .VIDEO(video), .COLOR_LINE(color_line), .TEXT_MODE(text_mode), .HBL(hbl), .VBL(vbl),
        .K(kbd), .READ_KEY(read_key), .AKD(key_s2[8]), .GAMEPORT(gameport), .PDL_STROBE(pdl_strobe),
        .CLK_2M(clk2m), .speaker(speaker), .DISK_READY(disk_s2[0] && track == disk_s2[13:8]), .D1_WP(1'b1), .D1_ACTIVE(d1_active),
        .TRACK1(track), .TRACK1_ADDR(track_addr), .TRACK1_DI(track_di), .TRACK1_DO(trk_q), .TRACK1_WE(track_we));

    // ---------------------------------------------------------------- keyboard latch: a new press sets the strobe
    reg key_t = 1'b0;
    always @(posedge c14) begin
        key_t <= key_s2[9];
        if (key_t != key_s2[9]) kbd <= {1'b1, key_s2[6:0]};
        else if (read_key) kbd[7] <= 1'b0;
    end

    // ---------------------------------------------------------------- game port: two paddles from the joystick
    // PREAD counts ~11 CPU cycles per step: 22 ticks of the 2 MHz Q3 clock per paddle unit (0..255), as apple2_top
    reg [12:0] px = 13'd0, py = 13'd0;
    reg        c2_last = 1'b0;
    wire [7:0] jx = j1[6] ? 8'd0 : j1[7] ? 8'd255 : 8'd128;
    wire [7:0] jy = j1[4] ? 8'd0 : j1[5] ? 8'd255 : 8'd128;
    always @(posedge c14) begin
        c2_last <= clk2m;
        if (pdl_strobe) begin px <= jx * 5'd22; py <= jy * 5'd22; end
        else if (clk2m && !c2_last) begin
            if (px != 0) px <= px - 1'b1;
            if (py != 0) py <= py - 1'b1;
        end
        gameport <= {2'b00, py != 0, px != 0, 1'b0, j1[1], j1[0], 1'b0};
    end

    // ---------------------------------------------------------------- memories: four byte lanes each
    // main + aux RAM: the console's port reads both banks at once (ram_do = {aux, main}); a write returns its data
    wire [15:0] ca = cold ? 16'h03F4 : ram_addr[15:0];
    wire        cwe0 = cold ? 1'b1 : (ram_we && !ram_aux);
    wire        cwe1 = !cold && ram_we && ram_aux;
    wire [7:0]  cdi = cold ? 8'd0 : ram_di;
    wire [7:0]  m0q, m1q;
    a2_lanes #(.AW(16), .BUS(0)) u_ram0 (.bclk(clk), .bwe(1'b0), .ba(up_wa[15:2]), .bd(up_wd),
        .cclk(c14), .cwe(cwe0), .ca(ca), .cd(cdi), .cq(m0q));
    a2_lanes #(.AW(16), .BUS(0)) u_ram1 (.bclk(clk), .bwe(1'b0), .ba(up_wa[15:2]), .bd(up_wd),
        .cclk(c14), .cwe(cwe1), .ca(ca), .cd(cdi), .cq(m1q));
    reg       w0_d = 1'b0, w1_d = 1'b0;
    reg [7:0] di_d = 8'd0;
    always @(posedge c14) begin w0_d <= cwe0; w1_d <= cwe1; di_d <= cdi; end
    always @(*) ram_do = {w1_d ? di_d : m1q, w0_d ? di_d : m0q};
    a2_lanes #(.AW(14)) u_rom (.bclk(clk), .bwe(up_rom), .ba(up_wa[13:2]), .bd(up_wd),
        .cclk(c14), .cwe(1'b0), .ca(rom_a), .cd(8'd0), .cq(rom_d));
    a2_lanes #(.AW(13)) u_vrom (.bclk(clk), .bwe(up_vrom), .ba(up_wa[12:2]), .bd(up_wd),
        .cclk(c14), .cwe(1'b0), .ca(vrom_a), .cd(8'd0), .cq(vrom_d));
    a2_lanes #(.AW(8)) u_drom (.bclk(clk), .bwe(up_drom), .ba(up_wa[7:2]), .bd(up_wd),
        .cclk(c14), .cwe(1'b0), .ca(drom_a), .cd(8'd0), .cq(drom_d));
    a2_lanes #(.AW(13)) u_trk (.bclk(clk), .bwe(up_trk), .ba(up_wa[12:2]), .bd(up_wd),
        .cclk(c14), .cwe(1'b0), .ca(track_addr), .cd(8'd0), .cq(trk_q));

    // ---------------------------------------------------------------- picture: 560 dots x 192 lines, freeze-able
    // A line's 560 dots start DX clocks after HBL falls (the video shift register runs behind the timing).
    localparam [5:0] DX = 6'd11;
    (* ram_style = "block" *) reg [31:0] fb [0:4095];
    reg [8:0]  row = 9'd0, line = 9'd0, lines = 9'd0;
    reg [9:0]  x = 10'd560;
    reg [5:0]  dly = 6'd0;
    reg [31:0] sh = 32'd0;
    reg        cap = 1'b1, frozen = 1'b0, hbl_last = 1'b1, vbl_last = 1'b1, armed = 1'b0, cl = 1'b0;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [31:0] fb_wd = 32'd0;
    reg [11:0] fb_wa = 12'd0, row_base = 12'd0;
    always @(posedge c14) begin
        fb_we <= 1'b0;
        hbl_last <= hbl; vbl_last <= vbl;
        if (hbl && !hbl_last) line <= line + 1'b1;
        if (vbl && !vbl_last) begin                                     // the visible frame ended
            frames <= frames + 1'b1; cap <= !freeze; frozen <= freeze;
        end
        // the next frame's rows count from where its visible part starts (the last line of the frame before is
        // still being shifted out, DX clocks late, when VBL rises)
        if (!vbl && vbl_last) begin lines <= line + (hbl && !hbl_last); line <= 9'd0; row <= 9'd0; end
        if (hbl_last && !hbl && !vbl && row < 9'd192) begin armed <= 1'b1; dly <= DX; cl <= color_line; end
        if (armed) begin
            if (dly != 0) dly <= dly - 1'b1;
            else begin armed <= 1'b0; x <= 10'd0; row_base <= row * 5'd18; end
        end
        if (x != 10'd560) begin
            x <= x + 1'b1;
            sh <= {video, sh[31:1]};
            if (cap && x[4:0] == 5'd31) begin fb_wd <= {video, sh[31:1]}; fb_wa <= row_base + x[9:5]; fb_we <= 1'b1; end
            if (x == 10'd559) begin
                if (cap) begin fb_wd <= {cl, 15'd0, video, sh[31:17]}; fb_wa <= row_base + 5'd17; fb_we <= 1'b1; end
                row <= row + 1'b1;
            end
        end
    end
    always @(posedge c14) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [31:0] fbq = 32'd0;
    always @(posedge clk) fbq <= fb[fb_rd[11:0]];

    // ---------------------------------------------------------------- sound: the speaker bit averaged over 298 clocks
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [8:0]  au_n = 9'd0, ones = 9'd0;
    reg        au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    reg [15:0] dc = 16'd0;
    wire signed [15:0] s = ($signed({7'd0, ones}) - 16'sd149) * 16'sd160;
    always @(posedge c14) begin
        au_we <= 1'b0;
        if (au_n == 9'd297) begin
            au_n <= 9'd0; ones <= {8'd0, speaker};
            au_wd <= {s, s}; au_we <= 1'b1;
            lvl <= lvl - (lvl >> 6) + ((s[15] ? -s : s) >> 6);
        end else begin
            au_n <= au_n + 1'b1; ones <= ones + speaker;
        end
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
    reg [8:0]  ln_s1 = 0, ln_s2 = 0;
    reg [7:0]  kb_s1 = 0, kb_s2 = 0;
    reg [7:0]  tr_s1 = 0, tr_s2 = 0;
    reg frz_s1 = 0, frz_s2 = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1; ln_s1 <= lines; ln_s2 <= ln_s1;
        frz_s1 <= frozen; frz_s2 <= frz_s1; kb_s1 <= kbd; kb_s2 <= kb_s1;
        tr_s1 <= {1'b0, d1_active, track}; tr_s2 <= tr_s1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        up_we <= 1'b0;
        if (!rstn) begin ctrl <= 3'd0; hw_enable <= 1'b0; hw_port1 <= 4'd1; hw_port2 <= 4'd2; hw_never <= 9'h000; end
        else if (bus_we && sel) begin
            if (idx[9]) begin
                if (!idx[8]) begin up_wd <= bus_wdata; up_wa <= up_addr; up_we <= 1'b1; up_addr <= up_addr + 18'd4; end
            end else case (idx)
                10'd0: ctrl <= bus_wdata[2:0];
                10'd1: pads <= bus_wdata[15:0];
                10'd2: key <= bus_wdata[9:0];
                10'd3: up_addr <= {bus_wdata[17:2], 2'b00};
                10'd4: fb_rd <= bus_wdata[14:0];
                10'd5: au_rd <= bus_wdata[10:0];
                10'd9: begin hw_enable <= bus_wdata[0];
                             hw_port1 <= (bus_wdata[7:4] >= 4'd1 && bus_wdata[7:4] <= 4'd9) ? bus_wdata[7:4] : 4'd1;
                             hw_port2 <= (bus_wdata[11:8] >= 4'd1 && bus_wdata[11:8] <= 4'd9) ? bus_wdata[11:8] : 4'd2; end
                10'd11: hw_never <= bus_wdata[8:0];
                10'd12: disk <= {bus_wdata[13:8], 7'd0, bus_wdata[0]};
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b10) begin bus_rdata <= fbq; fb_rd <= (fb_rd == FBW - 1) ? 15'd0 : fb_rd + 1'b1; end
            else if (idx[9:8] == 2'b11) begin bus_rdata <= auq; au_rd <= au_rd + 1'b1; end
            else case (idx)
                10'd0: bus_rdata <= {29'd0, ctrl};
                10'd1: bus_rdata <= {16'd0, pads};
                10'd2: bus_rdata <= {23'd0, key[8], kb_s2};
                10'd3: bus_rdata <= {14'd0, up_addr};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h41324531;                  // "A2E1"
                10'd8: bus_rdata <= {16'd0, lvl};
                10'd9: bus_rdata <= {7'd0, hw_enable, 6'd0, hw_drive, hw_pads};
                10'd10: bus_rdata <= {24'd0, hw_port2, hw_port1};
                10'd11: bus_rdata <= {23'd0, hw_never};
                10'd12: bus_rdata <= {2'd0, disk[13:8], 7'd0, disk[0], 7'd0, tr_s2[6], 2'd0, tr_s2[5:0]};
                10'd15: bus_rdata <= {23'd0, ln_s2};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule

// A byte-wide memory of 2^AW bytes as four byte lanes (byte address bits [1:0] pick the lane): the bus writes a
// whole 32-bit word (bytes 4n..4n+3) in one clock, the console reads (and may write) one byte per clock.
// BUS = 0: no bus port (the RAM: a second clock's write port does not map onto the block RAM).
module a2_lanes #(parameter AW = 14, parameter BUS = 1) (
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
        if (BUS) begin : bp
            always @(posedge bclk) if (bwe) m[ba] <= bd[8 * g +: 8];
        end
        always @(posedge cclk) begin
            if (cwe && ca[1:0] == g) m[ca[AW-1:2]] <= cd;
            q <= m[ca[AW-1:2]];
        end
    end endgenerate
    always @(posedge cclk) lane_d <= ca[1:0];
    assign cq = lane_d == 2'd0 ? lane[0].q : lane_d == 2'd1 ? lane[1].q : lane_d == 2'd2 ? lane[2].q : lane[3].q;
endmodule
