`timescale 1ns / 1ps
// Test of orphan_nespad against a model of a real NES pad (a 4021: LATCH loads, DATA = A, CLOCK rising shifts).
//   iverilog -o tb_nespad.vvp tb_nespad.v ../orphan_nes/orphan_nespad.v && vvp tb_nespad.vvp
module nes_pad_model (input wire latch, input wire clock, input wire [7:0] pressed, output wire data);
    reg [7:0] r = 8'hFF;
    always @(posedge clock) if (!latch) r <= {1'b0, r[7:1]};      // serial in tied to GND on a real pad
    always @(*) if (latch) r = ~pressed;                         // parallel load while LATCH is high
    assign data = r[0];
endmodule

module tb_nespad;
    reg clk = 0;
    always #5 clk = ~clk;                                        // 100 MHz
    reg        enable = 1;
    reg  [1:0] plug = 2'b11;
    reg  [7:0] press0 = 8'h00, press1 = 8'h00;
    wire       latch, pclk;
    wire [1:0] drive;
    wire [15:0] buttons;
    // what each port sees: driven only when the reader drives it, else the pins float up (pull-ups)
    wire l0 = drive[0] ? latch : 1'b1, c0 = drive[0] ? pclk : 1'b1;
    wire l1 = drive[1] ? latch : 1'b1, c1 = drive[1] ? pclk : 1'b1;
    wire d0_pad, d1_pad;
    nes_pad_model pad0 (.latch(l0), .clock(c0), .pressed(press0), .data(d0_pad));
    nes_pad_model pad1 (.latch(l1), .clock(c1), .pressed(press1), .data(d1_pad));
    reg  stuck0 = 0;                                             // DATA held low (no pad, something pulling down)
    wire d0 = stuck0 ? 1'b0 : plug[0] ? 1'b1 : d0_pad;           // no adapter: DATA floats up = released
    wire d1 = plug[1] ? 1'b1 : d1_pad;
    orphan_nespad #(.N(2), .DIV(4)) dut (.clk(clk), .enable(enable), .plug(plug), .data({d1, d0}),
        .latch(latch), .pclk(pclk), .drive(drive), .buttons(buttons), .present());

    integer pass = 0, fail = 0;
    task check(input [15:0] want_b, input [1:0] want_d, input [8*40:1] what);
        begin
            if (buttons === want_b && drive === want_d) pass = pass + 1;
            else begin fail = fail + 1; $display("FAIL %0s: buttons %h (want %h) drive %b (want %b)", what, buttons, want_b, drive, want_d); end
        end
    endtask
    task scans(input integer n); begin repeat (n * 167 * 4 + 50) @(posedge clk); end endtask

    // a port that is not driven must never see LATCH or CLOCK move
    reg moved1 = 0;
    always @(posedge clk) if (!drive[1] && (l1 !== 1'b1 || c1 !== 1'b1)) moved1 <= 1;

    initial begin
        plug = 2'b10; press0 = 8'b1010_0101;                    // pad on port 0, nothing on port 1
        scans(3); check(16'h00A5, 2'b01, "pad 1 A, Select, Down, Right");
        if (moved1) begin fail = fail + 1; $display("FAIL port 1 was driven without an adapter"); end else pass = pass + 1;
        press0 = 8'h01; scans(2); check(16'h0001, 2'b01, "pad 1 A only");
        press0 = 8'h80; scans(2); check(16'h0080, 2'b01, "pad 1 Right only");
        press0 = 8'hFF; scans(2); check(16'h0000, 2'b01, "pad 1 all eight held: impossible, ignored");
        press0 = 8'h5F; scans(2); check(16'h005F, 2'b01, "pad 1 A, B, Select, Start, Up, Left");
        press0 = 8'h0B; scans(2); check(16'h000B, 2'b01, "pad 1 A, B, Start (bit order)");
        press0 = 8'h64; scans(2); check(16'h0064, 2'b01, "pad 1 Select, Down, Left (bit order)");
        plug = 2'b00; press1 = 8'h1C; press0 = 8'h00; scans(2); check(16'h1C00, 2'b11, "pad 2 Select, Start, Up");
        press0 = 8'h43; scans(2); check(16'h1C43, 2'b11, "both pads");
        enable = 0; scans(2); check(16'h0000, 2'b00, "disabled: nothing read, nothing driven");
        enable = 1; plug = 2'b01; scans(2); check(16'h1C00, 2'b10, "pad 1 unplugged");
        plug = 2'b00; stuck0 = 1; scans(2); check(16'h1C00, 2'b11, "pad 1 PLUG low + DATA stuck low: no buttons");
        stuck0 = 0; press0 = 8'h30; scans(2); check(16'h1C00, 2'b11, "pad 1 Up + Down rejected");
        press0 = 8'h90; scans(2); check(16'h1C90, 2'b11, "pad 1 Up + Right accepted");
        $display("tb_nespad: %0d passed, %0d failed", pass, fail);
        $finish;
    end
endmodule
