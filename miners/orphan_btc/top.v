// [orphan] Orphan BTC: a real Stratum Bitcoin miner built on Ardzy's 13_sha256 lab (by chryso, GPL-3.0,
// https://github.com/chrysovalantischryso/ardzy). This hardware file is Ardzy's, unchanged except where marked.
// Modified by Orphan (JMSCNC, 2026-11-22): orphan_fan added at slot 15.
`timescale 1ns / 1ps
// 13 SHA-256 miner: slot 0 info (project "SHA2"), slot 1 the miner (see sha_miner.v)
//   LED 0 blinks while mining, LED 1 lights when a hash with enough zero bits was found;
//   LEDs 2 and 3 are the info block's (the ARM can set them).
module top (
    output wire       fan_pwm,       // Orphan: fan control
    input  wire [5:0] fan_tach,
    output wire [3:0] leds
);
    wire [31:0] rd_fan;                // Orphan: orphan_fan read data
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_sha;
    wire [3:0]  wstrb, info_leds_n;
    wire        mining, found;
    reg  [24:0] blink = 25'd0;
    always @(posedge clk) blink <= blink + 1'b1;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_fan | rd_info | rd_sha));
    ardzy_info #(.SLOT(0), .PROJECT("SHA2"), .VERSION(1)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n(info_leds_n));
    sha_miner #(.SLOT(1), .NU(3)) u_sha (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_sha), .mining_led(mining), .found_led(found));
    assign leds = {info_leds_n[3:2], ~found, ~(mining & blink[24])};      // active low
    // Orphan: fan control in every design (orphan_fan, slot 15; the Orphan menu's Cooling page drives it)
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
endmodule
