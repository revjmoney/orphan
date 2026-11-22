`timescale 1ns / 1ps
// Orphan Games: NES. Slot 0 info ("NES1"), slot 1 the console (orphan_nes_block), slot 14 LEDs, slot 15 fans.
// The picture, sound and pads go through the ARM (browser / CYD); no video pins.
// by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later (built together with fpganes, GPL-2).
module top (
    output wire [3:0] leds,
    output wire       fan_pwm,
    input  wire [5:0] fan_tach
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_nes, rd_led, rd_fan;
    wire [3:0]  wstrb;
    wire [7:0]  lvl;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_nes | rd_led | rd_fan));
    ardzy_info #(.SLOT(0), .PROJECT("NES1"), .VERSION(1)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n());
    orphan_nes_block #(.SLOT(1)) u_nes (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_nes),
        .level(lvl));
    orphan_leds #(.SLOT(14)) u_leds (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_led),
        .auto_lvl({lvl, lvl, lvl, lvl}), .vu(lvl), .lfo(lvl), .leds_n(leds));
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
endmodule
