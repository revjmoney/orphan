`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: 8N1 UART receiver and transmitter for the hashboard chain (moved out of hashr.v).
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.

// 8N1 receiver, samples mid-bit (same scheme as INTERSEKTOR's ik_uart_rx).
module hr_uart_rx (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] cpb,
    input  wire        line,
    output reg         v = 1'b0,
    output reg  [7:0]  d = 8'd0,
    output reg         ferr = 1'b0
);
    localparam IDLE = 3'd0, START = 3'd1, DATA = 3'd2, STOP = 3'd3, WAITH = 3'd4;
    reg [2:0]  st = IDLE;
    reg [15:0] c = 16'd0;
    reg [2:0]  n = 3'd0;
    reg [7:0]  sh = 8'd0;
    always @(posedge clk) begin
        v <= 1'b0;
        if (rst) st <= IDLE;
        else case (st)
            IDLE:  if (!line) begin c <= {1'b0, cpb[15:1]} - 1'b1; st <= START; end
            START: if (c != 16'd0) c <= c - 1'b1;
                   else if (line) st <= IDLE;
                   else begin c <= cpb - 1'b1; n <= 3'd0; st <= DATA; end
            DATA:  if (c != 16'd0) c <= c - 1'b1;
                   else begin sh <= {line, sh[7:1]}; c <= cpb - 1'b1; n <= n + 1'b1; if (n == 3'd7) st <= STOP; end
            STOP:  if (c != 16'd0) c <= c - 1'b1;
                   else begin v <= 1'b1; d <= sh; ferr <= !line; st <= line ? IDLE : WAITH; end
            default: if (line) st <= IDLE;
        endcase
    end
endmodule

// 8N1 transmitter, idle high.
module hr_uart_tx (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] cpb,
    input  wire        start,
    input  wire [7:0]  d,
    output reg         line = 1'b1,
    output wire        busy
);
    reg [3:0]  n = 4'd0;
    reg [15:0] c = 16'd0;
    reg [9:0]  sh = 10'h3FF;
    reg        run = 1'b0;
    assign busy = run;
    always @(posedge clk) begin
        if (rst) begin run <= 1'b0; line <= 1'b1; end
        else if (!run) begin
            line <= 1'b1;
            if (start) begin sh <= {1'b1, d, 1'b0}; n <= 4'd0; c <= cpb - 1'b1; run <= 1'b1; line <= 1'b0; end
        end else if (c != 16'd0) c <= c - 1'b1;
        else if (n == 4'd9) run <= 1'b0;                       // stop bit has had its full time
        else begin n <= n + 1'b1; c <= cpb - 1'b1; line <= sh[n + 1]; end
    end
endmodule
