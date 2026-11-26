`timescale 1ns / 1ps
// orphan_fan: fan control for EVERY Orphan FPGA design (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
// Drop it on the ardzy_bus at slot 15 so the Orphan menu / orphan-fan tool can always find the fans,
// whatever project is loaded.  Pins (add to pins.xdc, see orphan_fan.xdc):
//   fan_pwm J18 (shared by all 6 headers, HIGH = full speed), fan_tach[0..5] F19 G18 F20 J20 G17 H20.
//
// Registers (word index):
//   0 ID      "FAN1" (0x46414E31)
//   1 DUTY    0..100 percent (reset 0 = fans idle: quiet by default)
//   2..7      TACH0..5: rising edges counted in the last 1 s window (rpm = count * 60 / 2)
//   8 WINDOWS completed 1 s windows
//   9 MODE    [0] auto curve, [1] H4SHR-CH3KR rules (reset 0: designs that never write it behave as before)
//  10 TEMP    hottest hashboard temperature in C (written by hashrd); each write restarts the 10 s watchdog
//  11 POWERED [0] a hashboard is powered      12 CURVE_LO (40 C)      13 CURVE_HI (75 C)
//  14 APPLIED (r) the duty actually driven     15 WATCHDOG (r) [0] fired (no temperature for 10 s while powered)
// Rules (Rev, 2026-11-23): the fans do not turn below 20 %, so a duty of 1..19 always becomes 20. With [1] set:
// not powered -> 20 (fans low); powered and the watchdog fired -> 100; auto -> 20 % up to CURVE_LO, a straight
// line to 100 % at CURVE_HI; manual -> DUTY, at least 20.
module orphan_fan #(parameter [3:0] SLOT = 4'd15, parameter [26:0] SEC = 27'd99_999_999) (
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

    reg [6:0]  duty = 7'd0;                           // DUTY as written (manual)
    reg [6:0]  applied = 7'd0;                        // what the fans get
    reg [11:0] pwm_cnt = 12'd0;                       // 4000 clocks = 25 kHz at 100 MHz
    wire [11:0] high = applied * 12'd40;
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
        if (gate == SEC) begin
            gate <= 27'd0;
            windows <= windows + 1'b1;
            for (i = 0; i < 6; i = i + 1) begin val[i] <= cnt[i]; cnt[i] <= 16'd0; end
        end else begin
            gate <= gate + 1'b1;
            for (i = 0; i < 6; i = i + 1) if (s2[i] & ~s3[i]) cnt[i] <= cnt[i] + 1'b1;
        end
    end

    // ---------------- H4SHR-CH3KR rules
    reg [1:0]  mode = 2'd0;
    reg [7:0]  temp = 8'd0, lo = 8'd40, hi = 8'd75;
    reg        powered = 1'b0;
    reg [3:0]  wd = 4'd0;                             // seconds since the last TEMP write (stops at 10)
    wire       wd_fired = (wd == 4'd10);
    wire       sec = (gate == SEC);
    // curve: 20 + (temp - lo) * 80 / (hi - lo), worked out bit by bit after every TEMP/CURVE write
    reg [14:0] num = 15'd0, rem = 15'd0;
    reg [7:0]  den = 8'd1;
    reg [6:0]  quo = 7'd0, curve = 7'd20;
    reg [3:0]  dstep = 4'd0;
    reg        dbusy = 1'b0, dstart = 1'b0;
    always @(posedge clk) begin
        dstart <= 1'b0;
        if (!rstn) begin
            duty <= 7'd0; mode <= 2'd0; temp <= 8'd0; lo <= 8'd40; hi <= 8'd75; powered <= 1'b0; wd <= 4'd0;
        end else begin
            if (sec && wd != 4'd10) wd <= wd + 1'b1;
            if (bus_we && sel) case (idx)
                10'd1:  duty <= (bus_wdata[6:0] > 7'd100) ? 7'd100 : bus_wdata[6:0];
                10'd9:  mode <= bus_wdata[1:0];
                10'd10: begin temp <= bus_wdata[7:0]; wd <= 4'd0; dstart <= 1'b1; end
                10'd11: powered <= bus_wdata[0];
                10'd12: begin lo <= bus_wdata[7:0]; dstart <= 1'b1; end
                10'd13: begin hi <= bus_wdata[7:0]; dstart <= 1'b1; end
                default: ;
            endcase
        end
        // restoring division, 15 steps
        if (dstart) begin
            if (temp <= lo) begin curve <= 7'd20; dbusy <= 1'b0; end
            else if (temp >= hi || hi <= lo) begin curve <= 7'd100; dbusy <= 1'b0; end
            else begin
                num <= (temp - lo) * 15'd80; den <= hi - lo; rem <= 15'd0; quo <= 7'd0; dstep <= 4'd15; dbusy <= 1'b1;
            end
        end else if (dbusy) begin
            if ({rem[13:0], num[14]} >= {7'd0, den}) begin
                rem <= {rem[13:0], num[14]} - {7'd0, den};
                quo <= {quo[5:0], 1'b1};
            end else begin
                rem <= {rem[13:0], num[14]};
                quo <= {quo[5:0], 1'b0};
            end
            num <= {num[13:0], 1'b0};
            dstep <= dstep - 1'b1;
            if (dstep == 4'd1) dbusy <= 1'b0;
        end else if (!dbusy && dstep == 4'd0 && !(temp <= lo) && !(temp >= hi || hi <= lo)) curve <= 7'd20 + quo;
        // the duty actually driven
        if (!mode[1])           applied <= (duty != 7'd0 && duty < 7'd20) ? 7'd20 : duty;
        else if (!powered)      applied <= 7'd20;
        else if (wd_fired)      applied <= 7'd100;
        else if (mode[0])       applied <= curve;
        else                    applied <= (duty < 7'd20) ? 7'd20 : duty;
    end

    always @(posedge clk) begin
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
                10'd9: bus_rdata <= {30'd0, mode};
                10'd10: bus_rdata <= {24'd0, temp};
                10'd11: bus_rdata <= {31'd0, powered};
                10'd12: bus_rdata <= {24'd0, lo};
                10'd13: bus_rdata <= {24'd0, hi};
                10'd14: bus_rdata <= {25'd0, applied};
                10'd15: bus_rdata <= {31'd0, wd_fired};
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
