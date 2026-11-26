`timescale 1ns / 1ps
// [orphan] Orphan: the 4 board LEDs as a slow breathing scanner while mining (Rev, 2026-11-26). Used by H4SHR-CH3KR,
// orphan_kas and orphan_btc.
// One soft "eye" glides LED 0 -> LED 3 -> LED 0 (about 1.5 s each way at 100 MHz); every LED's brightness falls off
// with its distance from the eye (reaching zero 1.5 LEDs away), squared for an even-looking fade, and drawn with PWM.
// It runs while MODE is 1 (hashrd sets it while either miner runs) or while the core's own `active` signal is high
// (orphan_kas / orphan_btc wire in their engine's busy flag), held HOLD clocks (2 s) past the last activity so the
// short gaps between nonce ranges do not restart the eye. Otherwise the LEDs show the design's own status (idle_n).
// Registers (word index):  0 ID "LRS1" (0x4C525331)   1 MODE [0] scanner on
// LEDs are active low (0 = lit), like the S9 board's D5..D8.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module orphan_larson #(parameter [3:0] SLOT = 4'd5, parameter [17:0] STEP = 18'd195312,
                       parameter integer PWM_BITS = 16, parameter [27:0] HOLD = 28'd200_000_000) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    input  wire        active,                     // the core's busy flag (tie 0 where software sets MODE)
    input  wire [3:0]  idle_n,
    output wire [3:0]  leds_n
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    reg mode = 1'b0;
    always @(posedge clk) begin
        if (!rstn) mode <= 1'b0;
        else if (bus_we && sel && idx == 10'd1) mode <= bus_wdata[0];
    end
    reg [27:0] hold = 28'd0;                       // counts down after the core goes idle
    always @(posedge clk) begin
        if (!rstn)       hold <= 28'd0;
        else if (active) hold <= HOLD;
        else if (hold != 28'd0) hold <= hold - 1'b1;
    end
    wire on = mode | active | (hold != 28'd0);

    always @(posedge clk) begin
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else case (idx)
                10'd0:   bus_rdata <= 32'h4C525331;
                10'd1:   bus_rdata <= {31'd0, mode};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end

    // the eye: pos 0..768 (256 per LED), bouncing at both ends
    reg [17:0] tick = 18'd0;
    reg [9:0]  pos = 10'd0;
    reg        up = 1'b1;
    always @(posedge clk) begin
        if (!on) begin
            tick <= 18'd0; pos <= 10'd0; up <= 1'b1;      // every scan starts on LED 0
        end else if (tick == STEP - 1'b1) begin
            tick <= 18'd0;
            if (up) begin if (pos == 10'd767) up <= 1'b0; pos <= pos + 1'b1; end
            else    begin if (pos == 10'd1)   up <= 1'b1; pos <= pos - 1'b1; end
        end else tick <= tick + 1'b1;
    end

    reg [PWM_BITS-1:0] pwm = {PWM_BITS{1'b0}};
    always @(posedge clk) pwm <= pwm + 1'b1;

    // per LED: distance to the eye -> 0..255 -> squared -> PWM compare
    reg [3:0] lit = 4'd0;
    genvar g;
    generate for (g = 0; g < 4; g = g + 1) begin : led
        wire [10:0] c = g * 256;
        wire [10:0] d = ({1'b0, pos} > c) ? ({1'b0, pos} - c) : (c - {1'b0, pos});
        wire [8:0]  b = (d >= 11'd384) ? 9'd0 : 9'd384 - d[8:0];      // 0..384
        wire [16:0] b170 = b * 8'd170;
        wire [7:0]  b8 = b170[15:8];                                    // 0..255
        reg  [15:0] sq = 16'd0;
        always @(posedge clk) begin
            sq <= b8 * b8;
            lit[g] <= (pwm < sq[15 -: PWM_BITS]);
        end
    end endgenerate

    assign leds_n = on ? ~lit : idle_n;
endmodule
