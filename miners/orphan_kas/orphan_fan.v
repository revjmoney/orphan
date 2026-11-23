`timescale 1ns / 1ps
// orphan_fan: fan control for EVERY Orphan FPGA design (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
// Drop it on the ardzy_bus at slot 15 so the Orphan menu / orphan-fan tool can always find the fans,
// whatever project is loaded.  Pins (add to pins.xdc, see orphan_fan.xdc):
//   fan_pwm J18 (shared by all 6 headers, HIGH = full speed), fan_tach[0..5] F19 G18 F20 J20 G17 H20.
//
// Registers (word index):
//   0 ID      "FAN1" (0x46414E31)
//   1 DUTY    0..100 percent (reset 0 = fans off / idle; Rev wants the fans quiet by default)
//   2..7      TACH0..5: rising edges counted in the last 1 s window (rpm = count * 60 / 2)
//   8 WINDOWS completed 1 s windows
module orphan_fan #(parameter [3:0] SLOT = 4'd15) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output reg         fan_pwm = 1'b0,
    input  wire [5:0]  fan_tach
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    reg [6:0]  duty = 7'd0;
    reg [11:0] pwm_cnt = 12'd0;                       // 4000 clocks = 25 kHz at 100 MHz
    wire [11:0] high = duty * 12'd40;
    always @(posedge clk) begin
        pwm_cnt <= (pwm_cnt == 12'd3999) ? 12'd0 : pwm_cnt + 1'b1;
        fan_pwm <= (pwm_cnt < high);
    end

    // tach edge counters, 1 s gate
    reg [5:0]  s1 = 6'd0, s2 = 6'd0, s3 = 6'd0;
    reg [26:0] gate = 27'd0;
    reg [15:0] cnt [0:5];
    reg [15:0] val [0:5];
    reg [31:0] windows = 32'd0;
    integer i;
    initial for (i = 0; i < 6; i = i + 1) begin cnt[i] = 16'd0; val[i] = 16'd0; end
    always @(posedge clk) begin
        s1 <= fan_tach; s2 <= s1; s3 <= s2;
        if (gate == 27'd99_999_999) begin
            gate <= 27'd0;
            windows <= windows + 1'b1;
            for (i = 0; i < 6; i = i + 1) begin val[i] <= cnt[i]; cnt[i] <= 16'd0; end
        end else begin
            gate <= gate + 1'b1;
            for (i = 0; i < 6; i = i + 1) if (s2[i] & ~s3[i]) cnt[i] <= cnt[i] + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (!rstn) duty <= 7'd0;
        else if (bus_we && sel && idx == 10'd1) duty <= (bus_wdata[6:0] > 7'd100) ? 7'd100 : bus_wdata[6:0];
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else case (idx)
                10'd0: bus_rdata <= 32'h46414E31;
                10'd1: bus_rdata <= {25'd0, duty};
                10'd2: bus_rdata <= {16'd0, val[0]};
                10'd3: bus_rdata <= {16'd0, val[1]};
                10'd4: bus_rdata <= {16'd0, val[2]};
                10'd5: bus_rdata <= {16'd0, val[3]};
                10'd6: bus_rdata <= {16'd0, val[4]};
                10'd7: bus_rdata <= {16'd0, val[5]};
                10'd8: bus_rdata <= windows;
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
