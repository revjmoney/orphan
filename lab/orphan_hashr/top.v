`timescale 1ns / 1ps
// [orphan] ORPHAN H4SHR-CH3KR (code name HASHR): S9 hashboard tester and miner. Slot 0 info ("HSR1"), slot 1 HASHR
// (hashr.v: pins, RST, EN, I2C), slot 2 the chain dispatcher (hr_disp.v: UARTs, paced jobs, replies), slot 3 the work
// builder (hr_build.v, its job memory is slot 4; it feeds the chains in builder mode), slot 5 the LED scanner
// (orphan_larson.v: a breathing scanner on the 4 LEDs while mining), slot 15 the fans.
// All 9 hashboard headers J1..J9 (pins 5, 11, 12, 15 of each = 36 pins) come in through IOBUFs; HASHR drives a
// header's TXD and RST only after GO and that header's EN. The two hashboard I2C buses are open drain.
//   LED D5 lights while a header is driven (while not mining; mining runs the scanner on all 4).
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
// Built on Ardzy (by chryso, GPL-3.0): ardzy_bus, ardzy_info.
module top (
    inout  wire [35:0] hdr,                 // J1.5 J1.11 J1.12 J1.15, J2.5 .. J9.15
    inout  wire        i2c1_scl,
    inout  wire        i2c1_sda,
    inout  wire        i2c2_scl,
    inout  wire        i2c2_sda,
    output wire [3:0]  leds,
    output wire        fan_pwm,
    input  wire [5:0]  fan_tach
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_hr, rd_disp, rd_build, rd_fan, rd_led, b_word;
    wire        b_valid, b_take, b_clean;
    wire [3:0]  b_idx;
    wire [8:0]  chain_tx, chain_rx;
    wire [3:0]  wstrb, info_leds_n;
    wire [35:0] pin_in, pin_o, pin_oe;
    wire        act;
    wire        s1o, d1o, s1i, d1i, s2o, d2o, s2i, d2i;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_hr | rd_disp | rd_build | rd_fan | rd_led));
    ardzy_info #(.SLOT(0), .PROJECT("HSR1"), .VERSION(1)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n(info_leds_n));
    hashr #(.SLOT(1)) u_hr (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_hr),
        .pin_in(pin_in), .pin_o(pin_o), .pin_oe(pin_oe),
        .i2c1_scl_oe(s1o), .i2c1_sda_oe(d1o), .i2c1_scl_in(s1i), .i2c1_sda_in(d1i),
        .i2c2_scl_oe(s2o), .i2c2_sda_oe(d2o), .i2c2_scl_in(s2i), .i2c2_sda_in(d2i),
        .active(act), .chain_tx(chain_tx), .chain_rx(chain_rx));
    hr_disp #(.SLOT(2)) u_disp (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_disp),
        .tx_line(chain_tx), .rx_line(chain_rx),
        .w_valid(b_valid), .w_idx(b_idx), .w_word(b_word), .w_take(b_take), .clean(b_clean));
    hr_build #(.SLOT(3)) u_build (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_build),
        .w_valid(b_valid), .w_idx(b_idx), .w_word(b_word), .w_take(b_take), .clean(b_clean));
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
    genvar g;
    generate for (g = 0; g < 36; g = g + 1) begin : io
        IOBUF u (.I(pin_o[g]), .T(!pin_oe[g]), .O(pin_in[g]), .IO(hdr[g]));
    end endgenerate
    IOBUF u_s1 (.I(1'b0), .T(!s1o), .O(s1i), .IO(i2c1_scl));
    IOBUF u_d1 (.I(1'b0), .T(!d1o), .O(d1i), .IO(i2c1_sda));
    IOBUF u_s2 (.I(1'b0), .T(!s2o), .O(s2i), .IO(i2c2_scl));
    IOBUF u_d2 (.I(1'b0), .T(!d2o), .O(d2i), .IO(i2c2_sda));
    orphan_larson #(.SLOT(5)) u_led (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_led), .active(1'b0), .idle_n({info_leds_n[3:1], ~act}), .leds_n(leds));
endmodule
