`timescale 1ns / 1ps
// Icarus wrapper: 100 MHz clock, prints every scripted read as "LOG <hex>", ends when the script does.
module tb_run;
    reg clk = 1'b0;
    always #5 clk = !clk;
    wire        log_v, done;
    wire [31:0] log_d;
    tb_mimik u (.clk(clk), .log_v(log_v), .log_d(log_d), .done(done));
    always @(posedge clk) begin
        if (log_v) $display("LOG %08x", log_d);
        if (done) begin $display("DONE"); $finish; end
    end
    integer i;
    initial for (i = 0; i < 32768; i = i + 1) begin u.u_t.mem[i] = 8'h00; u.u_t.ro_mem[i] = 1'b0; end   // block RAM starts at 0
    initial begin #20000000; $display("TIMEOUT"); $finish; end
endmodule
