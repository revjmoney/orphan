`timescale 1ns / 1ps
// Orphan Radio project: slot 0 info ("RAD1"), slot 1 the AM receiver, slot 14 LEDs, slot 15 fans.
// J8: pin 12 = receiver input (wire antenna / loopback), pin 5 = test transmitter, pin 15 = RC feedback.
// I2S out on J3 like Ardzy's audio project: pin 5 MCLK, 11 BCLK, 12 DOUT, 15 LRCLK (PCM5102A: SCK to GND).
module top (
    inout  wire       rx_io,
    output wire       tx_out,
    output wire       fb_out,
    output wire       mclk,
    output wire       bclk,
    output wire       dout,
    output wire       lrclk,
    output wire [3:0] leds,
    output wire       fan_pwm,
    input  wire [5:0] fan_tach
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_rad, rd_led, rd_fan;
    wire [3:0]  wstrb;
    wire rx_in, pull_low;
    wire [7:0] lvl, aud;
    IOBUF u_rx (.I(1'b0), .T(~pull_low), .O(rx_in), .IO(rx_io));
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_rad | rd_led | rd_fan));
    ardzy_info #(.SLOT(0), .PROJECT("RAD1"), .VERSION(1)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n());
    orphan_radio #(.SLOT(1)) u_rad (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_rad),
        .rx_in(rx_in), .rx_pull_low(pull_low), .fb_out(fb_out), .tx_out(tx_out),
        .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout), .led_level(lvl), .led_audio(aud));
    orphan_leds #(.SLOT(14)) u_leds (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_led),
        .auto_lvl({aud, lvl, aud, lvl}), .vu(lvl), .lfo(aud), .leds_n(leds));
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
endmodule
