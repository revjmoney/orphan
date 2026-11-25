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

// The 9 hashboard connectors around the reader: picks pad 1 / pad 2 by connector number and decides, per connector,
// whether its LATCH (RST) and CLOCK (TXD) pins are driven. A connector is driven only while ALL of these hold:
// real pads are enabled, it is pad 1's or pad 2's connector, the reader is reading that pad, and the connector's
// OWN PLUG pin reads low right now (synchronised per connector), and it is not in the NEVER mask. So switching
// connectors can never drive one whose PLUG is high, even for the rest of a scan, and a protected connector (a
// hashboard's, e.g. J6) is never driven or read whatever the other settings say.
module orphan_nespad_ports #(parameter DIV = 600) (
    input  wire        clk,
    input  wire        enable,
    input  wire [3:0]  port1,          // 1..9 = J1..J9 (the register keeps them in range)
    input  wire [3:0]  port2,
    input  wire [8:0]  plug,           // every connector's PLUG pin
    input  wire [8:0]  rxd,            // every connector's RXD pin (pad DATA)
    input  wire [8:0]  never,          // per connector: 1 = never drive it (hashboard connectors)
    output wire        latch,          // value for the RST pins
    output wire        pclk,           // value for the TXD pins
    output wire [8:0]  oe,             // per connector: 1 = drive RST and TXD
    output wire [15:0] buttons,
    output wire [1:0]  drive
);
    reg [8:0] plug_s1 = 9'h1FF, plug_s2 = 9'h1FF;
    always @(posedge clk) begin plug_s1 <= plug; plug_s2 <= plug_s1; end
    wire [3:0] k1 = port1 - 4'd1, k2 = port2 - 4'd1;
    wire [8:0] plug_ok = plug | never;          // a protected connector looks empty to the reader
    orphan_nespad #(.N(2), .DIV(DIV)) u_rd (.clk(clk), .enable(enable), .plug({plug_ok[k2], plug_ok[k1]}),
        .data({rxd[k2], rxd[k1]}), .latch(latch), .pclk(pclk), .drive(drive), .buttons(buttons), .present());
    genvar g;
    generate for (g = 0; g < 9; g = g + 1) begin : gate
        assign oe[g] = enable && !never[g] && !plug_s2[g] && ((drive[0] && k1 == g) || (drive[1] && k2 == g));
    end endgenerate
endmodule
