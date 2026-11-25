`timescale 1ns / 1ps
// Orphan Games: real NES controllers on the S9's hashboard connectors.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money. GPL-2.0-or-later (built together with fpganes).
//
// A NES pad is a 4021 shift register: LATCH high copies the 8 buttons in, then DATA shows A and every CLOCK
// rising edge shifts out the next one (A, B, Select, Start, Up, Down, Left, Right), low = pressed.
// This reader polls every port about 1000 times a second with NES timing (12 us latch, 6 us clock halves), so a
// game always sees a fresh pad no matter when it strobes $4016.
//
// One port per hashboard connector (2x9, 3.3 V, NOT 5 V tolerant):
//   pin 15 RST  -> pad LATCH     pin 11 TXD -> pad CLOCK     pin 12 RXD <- pad DATA
//   pin 16 3.3V -> pad power     GND (pin 1/2/9/10/13/14) -> pad GND
//   pin 5 PLUG  -> tie to GND in the adapter: "a pad is here". Only a picked port with PLUG low is driven;
//                 with PLUG high (an empty port with the FPGA pull-up) LATCH and CLOCK stay inputs.
//                 Do not pick a connector that has a hashboard on it: its PLUG level is not checked yet.
// Inputs need the FPGA's weak pull-ups (PULLTYPE PULLUP in pins.xdc): the board has no pull-ups on these lines
// (measured), but the populated J6..J8 have resistors fitted nearby that are not measured yet. A read that no
// real pad can give (Up + Down, Left + Right, or all 8 held, e.g. a DATA line held low) counts as no buttons.
module orphan_nespad #(parameter N = 2, parameter DIV = 600) (   // DIV: clocks per 6 us at 100 MHz
    input  wire           clk,
    input  wire           enable,
    input  wire [N-1:0]   plug,        // PLUG pins (low = adapter present)
    input  wire [N-1:0]   data,        // DATA pins (low = button pressed)
    output reg            latch = 1'b0,
    output reg            pclk = 1'b0,
    output reg  [N-1:0]   drive = 0,   // per port: 1 = drive LATCH and CLOCK (else both pins float)
    output reg  [8*N-1:0] buttons = 0, // per port 8 bits, NES order, 1 = pressed (0 when the port is off)
    output wire [N-1:0]   present
);
    reg [N-1:0] plug_s1 = {N{1'b1}}, plug_s2 = {N{1'b1}}, data_s1 = {N{1'b1}}, data_s2 = {N{1'b1}};
    always @(posedge clk) begin
        plug_s1 <= plug; plug_s2 <= plug_s1;
        data_s1 <= data; data_s2 <= data_s1;
    end
    assign present = ~plug_s2;

    reg [15:0] div = 16'd0;
    reg [7:0]  step = 8'd0;                  // 0..166: one scan every 167 x 6 us = 1.002 ms
    wire       tick = (div == DIV - 1);
    reg [8*N-1:0] sh = 0;
    integer p;
    // bits: 0 A, 1 B, 2 Select, 3 Start, 4 Up, 5 Down, 6 Left, 7 Right; a D-pad can not press opposite sides
    function impossible(input [7:0] b);
        impossible = (b[4] & b[5]) | (b[6] & b[7]);
    endfunction
    always @(posedge clk) begin
        div <= tick ? 16'd0 : div + 1'b1;
        if (tick) begin
            step <= (step == 8'd166) ? 8'd0 : step + 1'b1;
            if (step == 8'd0) begin
                drive <= enable ? present : {N{1'b0}};   // a port is driven for a whole scan or not at all
                latch <= 1'b1;
            end
            if (step == 8'd2) latch <= 1'b0;
            // bit 0 (A) is on DATA after the latch; bit i appears at the clock's rising edge at step 2 + 2i
            // and is read 6 us later, when the clock goes low again (step 3 + 2i)
            if (step >= 8'd4 && step <= 8'd16 && !step[0]) pclk <= 1'b1;
            if (step >= 8'd3 && step <= 8'd17 && step[0]) begin
                pclk <= 1'b0;
                for (p = 0; p < N; p = p + 1)
                    sh[8*p + ((step - 8'd3) >> 1)] <= ~data_s2[p];
            end
            if (step == 8'd18)
                for (p = 0; p < N; p = p + 1)
                    buttons[8*p +: 8] <= (drive[p] && !impossible(sh[8*p +: 8])) ? sh[8*p +: 8] : 8'd0;
        end
    end
endmodule
