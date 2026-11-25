`timescale 1ns / 1ps
// A real NES pad for the testbenches: a 4021 (LATCH high loads, DATA = A, CLOCK rising edge shifts, serial in = GND).
module nes_pad_model (input wire latch, input wire clock, input wire [7:0] pressed, output wire data);
    reg [7:0] r = 8'hFF;
    always @(posedge clock) if (!latch) r <= {1'b0, r[7:1]};      // serial in tied to GND on a real pad
    always @(*) if (latch) r = ~pressed;                         // parallel load while LATCH is high
    assign data = r[0];
endmodule
