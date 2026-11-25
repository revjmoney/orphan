`timescale 1ns / 1ps
// Test of orphan_nespad_ports: the 9-connector crossbar around the reader. The rule under test: a connector's RST
// and TXD are driven only while it is pad 1's or pad 2's connector AND its own PLUG pin is low, also while
// connectors are switched in the middle of a scan.
//   iverilog -g2012 -o tb_ports.vvp tb_nespad_ports.v nes_pad_model.v ../orphan_nes/orphan_nespad.v
module tb_nespad_ports;
    reg clk = 0;
    always #5 clk = ~clk;
    reg        enable = 0;
    reg  [3:0] port1 = 4'd1, port2 = 4'd2;
    reg  [8:0] plug = 9'h1FF;                 // all high: nothing plugged in
    reg  [7:0] press = 8'h00;
    reg  [8:0] never = 9'h020;                // J6 protected, as after the FPGA loads
    wire       latch, pclk;
    wire [8:0] oe;
    wire [15:0] buttons;
    wire [1:0] drive;
    // one real pad on J7 (index 6); every other connector's RXD floats up
    wire l7 = oe[6] ? latch : 1'b1, c7 = oe[6] ? pclk : 1'b1;
    wire d7;
    nes_pad_model pad (.latch(l7), .clock(c7), .pressed(press), .data(d7));
    wire [8:0] rxd = {2'b11, plug[6] ? 1'b1 : d7, 6'h3F};
    orphan_nespad_ports #(.DIV(4)) dut (.clk(clk), .enable(enable), .port1(port1), .port2(port2), .plug(plug), .rxd(rxd), .never(never),
        .latch(latch), .pclk(pclk), .oe(oe), .buttons(buttons), .drive(drive));

    integer pass = 0, fail = 0;
    task ok(input c, input [8*48:1] what); begin if (c) pass = pass + 1; else begin fail = fail + 1; $display("FAIL %0s (oe %b buttons %h)", what, oe, buttons); end end endtask
    task scans(input integer n); begin repeat (n * 167 * 4 + 50) @(posedge clk); end endtask
    // the safety rule, checked on every clock: a driven connector always has PLUG low (synchronised: allow 2 clocks)
    reg [8:0] plug_d1 = 9'h1FF, plug_d2 = 9'h1FF;
    integer bad = 0;
    always @(posedge clk) begin
        plug_d1 <= plug; plug_d2 <= plug_d1;
        if (|(oe & plug_d2 & plug_d1 & plug)) bad = bad + 1;
        if (!enable && |oe) bad = bad + 1;
        if (|(oe & never)) bad = bad + 1;
    end

    initial begin
        scans(2); ok(oe == 9'd0, "disabled after reset: nothing driven");
        enable = 1; scans(2); ok(oe == 9'd0, "J1/J2 picked, nothing plugged: nothing driven");
        plug[6] = 1'b0; port1 = 4'd7; port2 = 4'd8; press = 8'h09; scans(3);
        ok(buttons == 16'h0009, "pad on J7 read as pad 1 (A + Start)");
        ok(drive == 2'b01, "only pad 1 is read (J8 empty)");
        // a hashboard-like connector: PLUG high on J6; switch pad 1 there in the middle of a scan
        repeat (167 * 4 / 3) @(posedge clk);
        port1 = 4'd6; scans(3);
        ok(oe[5] == 1'b0 && oe[6] == 1'b0, "switched to J6 (PLUG high): neither J6 nor J7 driven");
        ok(buttons[7:0] == 8'h00, "nothing read from J6");
        port1 = 4'd7; scans(3); ok(buttons == 16'h0009, "back on J7: read again");
        port2 = 4'd7; scans(3); ok(buttons == 16'h0909, "both pads on J7: same buttons, no contention");
        plug[6] = 1'b1; scans(3); ok(oe == 9'd0 && buttons == 16'h0000, "J7 adapter pulled: nothing driven or read");
        // a hashboard on J6 that pulls PLUG LOW, and pad 1 picked there: the mask must still keep J6 alone
        plug[6] = 1'b0; plug[5] = 1'b0; port1 = 4'd6; port2 = 4'd7; scans(3);
        ok(oe[5] == 1'b0, "J6 protected: not driven even with PLUG low and picked");
        ok(buttons == 16'h0900, "J6 protected: nothing read from it; pad 2 on J7 still works");
        never = 9'h060; scans(3); ok(oe == 9'd0 && buttons == 16'h0000, "J7 added to the mask: nothing driven at all");
        ok(bad == 0, "never drove a protected connector, one with PLUG high, or while disabled");
        $display("tb_nespad_ports: %0d passed, %0d failed", pass, fail);
        $finish;
    end
endmodule
