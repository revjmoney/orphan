`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: self-checking testbench for the orphan_fan rules (a "second" is 1000 clocks here).
//   iverilog -g2005 -o tb_fan.vvp sim/tb_fan.v orphan_fan.v && vvp tb_fan.vvp
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module tb_fan;
    reg clk = 0, rstn = 0;
    always #5 clk = ~clk;
    reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
    wire [31:0] rdata;
    wire pwm;
    orphan_fan #(.SLOT(15), .SEC(27'd999)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata),
                                                .bus_we(we), .bus_re(re), .bus_rdata(rdata), .fan_pwm(pwm), .fan_tach(6'd0));
    integer pass = 0, total = 0;
    reg [31:0] rv;
    task wr(input [9:0] i, input [31:0] v);
        begin @(negedge clk); addr = {4'd15, i, 2'b00}; wdata = v; we = 1; @(negedge clk); we = 0; repeat (40) @(negedge clk); end
    endtask
    task rd(input [9:0] i);
        begin @(negedge clk); addr = {4'd15, i, 2'b00}; re = 1; @(negedge clk); re = 0; @(negedge clk); rv = rdata; end
    endtask
    task expect_applied(input [6:0] want, input [8*48-1:0] name);
        begin
            rd(14); total = total + 1;
            if (rv[6:0] == want) begin pass = pass + 1; $display("ok   %0s", name); end
            else $display("FAIL %0s: applied %0d, want %0d", name, rv[6:0], want);
        end
    endtask
    initial begin
        repeat (10) @(negedge clk); rstn = 1;
        // rules off: other Orphan designs
        wr(1, 10); expect_applied(20, "rules off, duty 10 -> 20");
        wr(1, 0);  expect_applied(0,  "rules off, duty 0 -> 0");
        wr(1, 55); expect_applied(55, "rules off, duty 55 -> 55");
        // H4SHR-CH3KR rules, auto
        wr(9, 3); wr(11, 0); expect_applied(20, "not powered -> 20");
        wr(11, 1);
        wr(10, 40); expect_applied(20,  "powered, 40 C -> 20");
        wr(10, 57); expect_applied(58,  "powered, 57 C -> 58");
        wr(10, 75); expect_applied(100, "powered, 75 C -> 100");
        wr(10, 30); expect_applied(20,  "powered, 30 C -> 20");
        // watchdog: no temperature for 10 "seconds"
        repeat (11000) @(negedge clk);
        expect_applied(100, "no temperature for 10 s -> 100");
        rd(15); total = total + 1; if (rv[0]) begin pass = pass + 1; $display("ok   watchdog flag"); end
        else $display("FAIL watchdog flag");
        // manual with the floor
        wr(10, 50); wr(9, 2); wr(1, 15); expect_applied(20, "manual 15 -> 20");
        wr(1, 70); expect_applied(70, "manual 70 -> 70");
        if (pass == total) $display("PASS %0d/%0d", pass, total); else $display("FAIL %0d/%0d", pass, total);
        $finish;
    end
endmodule
