`timescale 1ns / 1ps
// Orphan Games: the NES console (fpganes by Ludvig Strigeus) as an Orphan FPGA block.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-2.0-or-later (this file), so it can be
// built together with fpganes (GPL-2). The NES core itself: Copyright (c) 2012-2013 Ludvig Strigeus, GPL-2.
//
// Clocks: the bus runs at 100 MHz (clk); the console runs on its own 21.48 MHz clock (nclk, an MMCM: 100 x 10.5 /
// 48.875, 0.03 % off a real NES's 21.477 MHz), one CPU/PPU step every 4th nclk, exactly like fpganes on its board.
// Everything that crosses between the two clocks goes through synchronizers (toggle handshakes, gray counters).
//
// The ARM's view (word index in the slot):
//   0 CTRL      [0] run (0 = console held in reset)   [1] freeze the frame buffer at the next frame start
//   1 PADS      [7:0] pad 1, [15:8] pad 2; bit 0 A, 1 B, 2 Select, 3 Start, 4 Up, 5 Down, 6 Left, 7 Right
//   2 MAPPER    iNES mapper flags (see games.py): {has_chr_ram, mirroring, chr_size, prg_size, mapper}
//   3 UP_ADDR   write: next cart byte address ([16] = 1 for CHR, else PRG; [15:0] byte); read: upload done count
//   4 FB_ADDR   write: frame buffer read pointer (word)        5 AU_ADDR  write: audio read pointer (word)
//   6 STATUS    read: [15:0] frames finished, [27:16] audio write pointer (words of 2 samples), [28] frozen
//   7 ID        "NES1"
//   8 LEVEL     read: average audio level (for meters / LEDs)
//   9 HWPADS    real NES pads on hashboard connectors (orphan_nespad.v)
//               write: [0] enable, [7:4] pad 1's connector, [11:8] pad 2's connector (1..9 = J1..J9)
//                      after reset: OFF (main.py turns it on), pad 1 on J1, pad 2 on J2
//               read:  [15:0] their buttons (PADS layout), [17:16] pads being read (adapter present),
//                      [24] enable
//  10 HWPADS2   read: [3:0] pad 1 connector, [7:4] pad 2 connector
//  11 HWNEVER   write/read: [8:0] connectors (bit n-1 = Jn) that are never driven or read, whatever else is set.
//               After the FPGA loads: J6 protected (bit 5), the first hashboard position on a stock S9.
//               The console sees PADS | these buttons, so browser and real pads work together.
//   512..767    write: 4 cart bytes (little endian) at UP_ADDR, UP_ADDR += 4  (wait for UP_ADDR read == writes)
//   512..767    read:  frame buffer word at FB_ADDR, FB_ADDR += 1: 5 pixels of 6 bits, pixel 0 in [5:0]
//                      (256 x 240 pixels = 12288 words, NES palette index; the panel turns it into colour)
//   768..1023   read:  audio word at AU_ADDR, AU_ADDR += 1: 2 signed 16-bit samples, 47.95 kHz, older in [15:0]
module orphan_nes_block #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output wire [7:0]  level,
    input  wire [15:0] hw_pads,     // buttons from real pads (orphan_nespad), bus clock
    input  wire [1:0]  hw_drive,    // pads being read
    output reg         hw_enable = 1'b0,
    output reg  [3:0]  hw_port1 = 4'd1,
    output reg  [3:0]  hw_port2 = 4'd2,
    output reg  [8:0]  hw_never = 9'h020     // J6 protected from the moment the FPGA loads
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- console clock
    wire fb_o, fb_i, n_o, nclk, locked;
    MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(10.5), .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(48.875)) u_mmcm (
        .CLKIN1(clk), .CLKFBIN(fb_i), .CLKFBOUT(fb_o), .RST(1'b0), .PWRDWN(1'b0), .CLKOUT0(n_o), .LOCKED(locked));
    BUFG u_bfb (.I(fb_o), .O(fb_i));
    BUFG u_bn (.I(n_o), .O(nclk));

    // ---------------------------------------------------------------- bus side registers
    reg [1:0]  ctrl = 2'd0;
    reg [15:0] pads = 16'd0;
    reg [31:0] mapper_flags = 32'd0;
    reg [16:0] up_addr = 17'd0;
    reg [31:0] up_data = 32'd0;
    reg [16:0] up_a = 17'd0;
    reg        up_req = 1'b0;
    reg [15:0] up_count = 16'd0;            // uploads the console side has finished (bus clock copy)
    reg [13:0] fb_rd = 14'd0;
    reg [10:0] au_rd = 11'd0;

    // ---------------------------------------------------------------- console side: inputs from the bus
    reg [1:0] ctrl_s1 = 0, ctrl_s2 = 0;
    reg [15:0] pads_s1 = 0, pads_s2 = 0;
    reg [15:0] pads_all = 16'd0;                  // browser pads | real pads, registered in clk before crossing
    always @(posedge clk) pads_all <= pads | hw_pads;
    reg [31:0] mf_s1 = 0, mf_s2 = 0;
    reg up_r1 = 0, up_r2 = 0, up_r3 = 0;
    always @(posedge nclk) begin
        ctrl_s1 <= ctrl; ctrl_s2 <= ctrl_s1;
        pads_s1 <= pads_all; pads_s2 <= pads_s1;
        mf_s1 <= mapper_flags; mf_s2 <= mf_s1;
        up_r1 <= up_req; up_r2 <= up_r1; up_r3 <= up_r2;
    end
    wire run = ctrl_s2[0] & locked;
    wire freeze = ctrl_s2[1];

    // ---------------------------------------------------------------- the console
    reg  [1:0] nes_ce = 2'd0;
    always @(posedge nclk) nes_ce <= nes_ce + 1'b1;
    wire reset_nes = !run;
    wire run_mem = (nes_ce == 2'd0) && !reset_nes;
    wire run_nes = (nes_ce == 2'd3) && !reset_nes;

    wire [8:0]  cycle, scanline;
    wire [15:0] sample;
    wire [5:0]  color;
    wire        joypad_strobe;
    wire [1:0]  joypad_clock;
    wire [21:0] memory_addr;
    wire        memory_read_cpu, memory_read_ppu, memory_write;
    wire [7:0]  memory_dout;
    reg  [7:0]  memory_din_cpu = 8'd0, memory_din_ppu = 8'd0;
    reg  [7:0]  joypad_bits = 8'd0, joypad_bits2 = 8'd0;
    reg  [1:0]  last_joypad_clock = 2'd0;
    wire [31:0] dbgadr;
    wire [1:0]  dbgctr;
    always @(posedge nclk) begin
        if (joypad_strobe) begin joypad_bits <= pads_s2[7:0]; joypad_bits2 <= pads_s2[15:8]; end
        if (!joypad_clock[0] && last_joypad_clock[0]) joypad_bits <= {1'b0, joypad_bits[7:1]};
        if (!joypad_clock[1] && last_joypad_clock[1]) joypad_bits2 <= {1'b0, joypad_bits2[7:1]};
        last_joypad_clock <= joypad_clock;
    end
    NES nes(nclk, reset_nes, run_nes, mf_s2, sample, color, joypad_strobe, joypad_clock,
            {joypad_bits2[0], joypad_bits[0]}, 5'b11111, memory_addr, memory_read_cpu, memory_din_cpu,
            memory_read_ppu, memory_din_ppu, memory_write, memory_dout, cycle, scanline, dbgadr, dbgctr);

    // ---------------------------------------------------------------- cart + console memory (block RAM)
    // PRG ROM 64 KB, CHR ROM/RAM 32 KB, and one 16 KB RAM for VRAM (2 KB), CPU RAM (2 KB), cart RAM (8 KB).
    // The core's 22-bit address: [21] = 0 PRG; [21:20] = 10 CHR; 11 + [19:18] = 00 VRAM, 10 CPU RAM, 11 cart RAM.
    // PRG is two 32 KB halves: a 64K-deep memory would chain block RAMs (cascade), which nextpnr can not route
    (* ram_style = "block" *) reg [7:0] prg_lo [0:32767];
    (* ram_style = "block" *) reg [7:0] prg_hi [0:32767];
    (* ram_style = "block" *) reg [7:0] chr [0:32767];
    (* ram_style = "block" *) reg [7:0] ram [0:16383];
    // uploads (console in reset): 4 bytes per request, one per clock
    reg [2:0]  up_step = 3'd0;
    reg [31:0] up_word = 32'd0;
    reg [16:0] up_wa = 17'd0;
    reg        up_ack = 1'b0;
    wire       up_go = (up_r3 != up_r2);
    always @(posedge nclk) begin
        if (up_go) begin up_word <= up_data; up_wa <= up_a; up_step <= 3'd4; end
        else if (up_step != 3'd0) begin
            up_word <= {8'd0, up_word[31:8]};
            up_wa <= up_wa + 1'b1;
            up_step <= up_step - 1'b1;
            if (up_step == 3'd1) up_ack <= ~up_ack;
        end
    end
    wire        up_we = (up_step != 3'd0);
    wire        is_prg = !memory_addr[21];
    wire        is_chr = memory_addr[21:20] == 2'b10;
    wire [13:0] ram_a = (memory_addr[19:18] == 2'b00) ? {3'b000, memory_addr[10:0]} :
                        (memory_addr[19:18] == 2'b10) ? {3'b001, memory_addr[10:0]} : {1'b1, memory_addr[12:0]};
    wire        nes_we = run_mem && memory_write;
    wire [15:0] prg_a = up_we ? up_wa[15:0] : memory_addr[15:0];
    wire [14:0] chr_a = up_we ? up_wa[14:0] : memory_addr[14:0];
    reg  [7:0]  q_lo = 8'd0, q_hi = 8'd0, q_chr = 8'd0, q_ram = 8'd0;
    reg         prg_half = 1'b0;
    always @(posedge nclk) begin
        if (up_we && !up_wa[16] && !prg_a[15]) prg_lo[prg_a[14:0]] <= up_word[7:0];
        q_lo <= prg_lo[prg_a[14:0]];
    end
    always @(posedge nclk) begin
        if (up_we && !up_wa[16] && prg_a[15]) prg_hi[prg_a[14:0]] <= up_word[7:0];
        q_hi <= prg_hi[prg_a[14:0]];
        prg_half <= prg_a[15];
    end
    wire [7:0] q_prg = prg_half ? q_hi : q_lo;
    always @(posedge nclk) begin
        if ((up_we && up_wa[16]) || (nes_we && is_chr)) chr[chr_a] <= up_we ? up_word[7:0] : memory_dout;
        q_chr <= chr[chr_a];
    end
    always @(posedge nclk) begin
        if (nes_we && !is_prg && !is_chr) ram[ram_a] <= memory_dout;
        q_ram <= ram[ram_a];
    end
    // the read issued at run_mem is in q_* one clock later; latch it for the CPU or the PPU (held until the next)
    reg rd_cpu = 1'b0, rd_ppu = 1'b0;
    reg [1:0] rd_src = 2'd0;
    always @(posedge nclk) begin
        rd_cpu <= run_mem && memory_read_cpu;
        rd_ppu <= run_mem && memory_read_ppu;
        rd_src <= is_prg ? 2'd0 : is_chr ? 2'd1 : 2'd2;
        if (rd_cpu) memory_din_cpu <= rd_src == 2'd0 ? q_prg : rd_src == 2'd1 ? q_chr : q_ram;
        if (rd_ppu) memory_din_ppu <= rd_src == 2'd0 ? q_prg : rd_src == 2'd1 ? q_chr : q_ram;
    end

    // ---------------------------------------------------------------- picture: 5 pixels per word, freeze-able
    (* ram_style = "block" *) reg [29:0] fb [0:12287];
    reg [13:0] fb_wa = 14'd0;
    reg [29:0] pix = 30'd0;
    reg [2:0]  npix = 3'd0;
    reg        cap = 1'b1, frozen = 1'b0;
    reg [15:0] frames = 16'd0;
    reg        fb_we = 1'b0;
    reg [29:0] fb_wd = 30'd0;
    always @(posedge nclk) begin
        fb_we <= 1'b0;
        if (run_nes) begin
            if (scanline == 9'd240 && cycle == 9'd0) begin          // the visible picture just ended
                frames <= frames + 1'b1;
                fb_wa <= 14'd0; npix <= 3'd0; cap <= !freeze; frozen <= freeze;
            end
            if (scanline < 9'd240 && cycle >= 9'd1 && cycle <= 9'd256 && cap) begin
                if (npix == 3'd4) begin
                    fb_wd <= {color, pix[29:6]}; fb_we <= 1'b1; npix <= 3'd0;
                end else begin
                    pix <= {color, pix[29:6]}; npix <= npix + 1'b1;
                end
            end
        end
        if (fb_we) fb_wa <= fb_wa + 1'b1;
    end
    always @(posedge nclk) if (fb_we) fb[fb_wa] <= fb_wd;
    reg [29:0] fbq = 30'd0;
    always @(posedge clk) fbq <= fb[fb_rd];

    // ---------------------------------------------------------------- sound: average over 448 clocks (47.95 kHz)
    (* ram_style = "block" *) reg [31:0] au [0:2047];
    reg [8:0]  au_n = 9'd0;
    reg [24:0] au_acc = 25'd0;
    reg [15:0] au_lo = 16'd0;
    reg        au_half = 1'b0, au_we = 1'b0;
    reg [31:0] au_wd = 32'd0;
    reg [10:0] au_wa = 11'd0;
    reg [15:0] lvl = 16'd0;
    wire signed [15:0] s16 = {~au_acc[24], au_acc[23:9]};       // unsigned mix -> signed, sum / 512
    always @(posedge nclk) begin
        au_we <= 1'b0;
        if (au_n == 9'd447) begin
            au_n <= 9'd0; au_acc <= {9'd0, sample};
            if (au_half) begin au_wd <= {s16, au_lo}; au_we <= 1'b1; end else au_lo <= s16;
            au_half <= ~au_half;
            lvl <= lvl - (lvl >> 6) + ((s16[15] ? -s16 : s16) >> 6);
        end else begin
            au_n <= au_n + 1'b1; au_acc <= au_acc + sample;
        end
        if (au_we) au_wa <= au_wa + 1'b1;
    end
    always @(posedge nclk) if (au_we) au[au_wa] <= au_wd;
    reg [31:0] auq = 32'd0;
    always @(posedge clk) auq <= au[au_rd];
    assign level = lvl[14:7];

    // ---------------------------------------------------------------- console -> bus: gray-coded counters
    function [15:0] g16(input [15:0] b); g16 = b ^ (b >> 1); endfunction
    function [15:0] b16(input [15:0] g); integer i; begin b16[15] = g[15];
        for (i = 14; i >= 0; i = i - 1) b16[i] = b16[i + 1] ^ g[i]; end endfunction
    reg [15:0] fr_g = 0, aw_g = 0;
    always @(posedge nclk) begin fr_g <= g16(frames); aw_g <= g16({5'd0, au_wa}); end
    reg [15:0] fr_s1 = 0, fr_s2 = 0, aw_s1 = 0, aw_s2 = 0;
    reg ack_s1 = 0, ack_s2 = 0, frz_s1 = 0, frz_s2 = 0;
    always @(posedge clk) begin
        fr_s1 <= fr_g; fr_s2 <= fr_s1; aw_s1 <= aw_g; aw_s2 <= aw_s1;
        ack_s1 <= up_ack; ack_s2 <= ack_s1; frz_s1 <= frozen; frz_s2 <= frz_s1;
    end
    wire [15:0] fr_b = b16(fr_s2), aw_b = b16(aw_s2);
    reg ack_last = 1'b0;
    always @(posedge clk) begin ack_last <= ack_s2; if (ack_s2 != ack_last) up_count <= up_count + 1'b1; end

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        if (!rstn) begin ctrl <= 2'd0; hw_enable <= 1'b0; hw_port1 <= 4'd1; hw_port2 <= 4'd2; hw_never <= 9'h020; end
        else if (bus_we && sel) begin
            if (idx[9]) begin
                if (!idx[8]) begin up_data <= bus_wdata; up_a <= up_addr; up_addr <= up_addr + 17'd4; up_req <= ~up_req; end
            end else case (idx)
                10'd0: ctrl <= bus_wdata[1:0];
                10'd1: pads <= bus_wdata[15:0];
                10'd2: mapper_flags <= bus_wdata;
                10'd3: up_addr <= bus_wdata[16:0];
                10'd4: fb_rd <= bus_wdata[13:0];
                10'd5: au_rd <= bus_wdata[10:0];
                10'd9: begin hw_enable <= bus_wdata[0];
                             hw_port1 <= (bus_wdata[7:4] >= 4'd1 && bus_wdata[7:4] <= 4'd9) ? bus_wdata[7:4] : 4'd1;
                             hw_port2 <= (bus_wdata[11:8] >= 4'd1 && bus_wdata[11:8] <= 4'd9) ? bus_wdata[11:8] : 4'd2; end
                10'd11: hw_never <= bus_wdata[8:0];
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9:8] == 2'b10) begin bus_rdata <= {2'b00, fbq}; fb_rd <= (fb_rd == 14'd12287) ? 14'd0 : fb_rd + 1'b1; end
            else if (idx[9:8] == 2'b11) begin bus_rdata <= auq; au_rd <= au_rd + 1'b1; end
            else case (idx)
                10'd0: bus_rdata <= {30'd0, ctrl};
                10'd1: bus_rdata <= {16'd0, pads};
                10'd2: bus_rdata <= mapper_flags;
                10'd3: bus_rdata <= {16'd0, up_count};
                10'd6: bus_rdata <= {3'd0, frz_s2, aw_b[11:0], fr_b};
                10'd7: bus_rdata <= 32'h4E455331;                 // "NES1"
                10'd8: bus_rdata <= {16'd0, lvl};
                10'd9: bus_rdata <= {7'd0, hw_enable, 6'd0, hw_drive, hw_pads};
                10'd10: bus_rdata <= {24'd0, hw_port2, hw_port1};
                10'd11: bus_rdata <= {23'd0, hw_never};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
