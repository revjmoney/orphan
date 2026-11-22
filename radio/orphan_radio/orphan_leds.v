`timescale 1ns / 1ps
// orphan_leds: hardware PWM for the 4 FPGA LEDs D5..D8 (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
// Drop on the ardzy_bus at slot 14. ~1.5 kHz PWM, 8-bit level with gamma (level^2), LEDs are active LOW.
// Each LED picks its own source, so light shows run in hardware with no CPU load.
//
// Registers (word index):
//   0 ID      "LED1" (0x4C454431)
//   1 SOURCE  4 bits per LED ([3:0] = LED0 ... [15:12] = LED3):
//             0 manual level   1 flash (level decays by DECAY every ms)   2 auto[i] (host design, e.g. voice envelopes)
//             3 VU bar (LED i lights above 25 % * i)   4 LFO   5 LFO inverted   6 VU (all)   7 off
//   2..5      LEVEL of LED 0..3 (0..255; in flash mode a write re-triggers the flash)
//   6 DECAY   flash fade per ms (default 4: full to dark in ~64 ms)
module orphan_leds #(parameter [3:0] SLOT = 4'd14) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    input  wire [31:0] auto_lvl,         // 4 x 8 bit from the host design
    input  wire [7:0]  vu,
    input  wire [7:0]  lfo,
    output reg  [3:0]  leds_n = 4'hF
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    reg [15:0] source = 16'h0000;
    reg [7:0]  lvl [0:3];
    reg [7:0]  decay = 8'd4;
    integer i;
    initial for (i = 0; i < 4; i = i + 1) lvl[i] = 8'd0;

    // 1 ms tick for flash decay
    reg [16:0] ms = 17'd0;
    wire tick = (ms == 17'd99_999);
    always @(posedge clk) ms <= tick ? 17'd0 : ms + 1'b1;

    // level per LED from its source
    function [7:0] bar(input [7:0] v, input [1:0] n);
        reg [9:0] x;
        begin
            x = {2'b00, v} - {2'b00, n, 6'd0};               // v - 64 n
            bar = x[9] ? 8'd0 : (x[7:6] != 2'b00 || x[8]) ? 8'd255 : {x[5:0], 2'b11};
        end
    endfunction
    reg [7:0] eff [0:3];
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            case (source[i*4 +: 4])
                4'd0, 4'd1: eff[i] = lvl[i];
                4'd2: eff[i] = auto_lvl[i*8 +: 8];
                4'd3: eff[i] = bar(vu, i[1:0]);
                4'd4: eff[i] = lfo;
                4'd5: eff[i] = ~lfo;
                4'd6: eff[i] = vu;
                default: eff[i] = 8'd0;
            endcase
        end
    end

    // PWM with gamma
    reg [15:0] cnt = 16'd0;
    always @(posedge clk) begin
        cnt <= cnt + 1'b1;
        for (i = 0; i < 4; i = i + 1)
            leds_n[i] <= ~(cnt[15:8] < ((eff[i] * eff[i]) >> 8) || eff[i] == 8'd255);
    end

    always @(posedge clk) begin
        if (tick)
            for (i = 0; i < 4; i = i + 1)
                if (source[i*4 +: 4] == 4'd1) lvl[i] <= (lvl[i] > decay) ? lvl[i] - decay : 8'd0;
        if (!rstn) source <= 16'h0000;
        else if (bus_we && sel) begin
            case (idx)
                10'd1: source <= bus_wdata[15:0];
                10'd2: lvl[0] <= bus_wdata[7:0];
                10'd3: lvl[1] <= bus_wdata[7:0];
                10'd4: lvl[2] <= bus_wdata[7:0];
                10'd5: lvl[3] <= bus_wdata[7:0];
                10'd6: decay <= bus_wdata[7:0];
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else case (idx)
                10'd0: bus_rdata <= 32'h4C454431;
                10'd1: bus_rdata <= {16'd0, source};
                10'd2: bus_rdata <= {24'd0, eff[0]};
                10'd3: bus_rdata <= {24'd0, eff[1]};
                10'd4: bus_rdata <= {24'd0, eff[2]};
                10'd5: bus_rdata <= {24'd0, eff[3]};
                10'd6: bus_rdata <= {24'd0, decay};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
