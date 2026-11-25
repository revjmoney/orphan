`timescale 1ns / 1ps
// Orphan Games: NES. Slot 0 info ("NES1"), slot 1 the console (orphan_nes_block), slot 14 LEDs, slot 15 fans.
// The picture, sound and pads go through the ARM (browser / CYD); no video pins. Real NES pads can also plug into
// any hashboard connector J1..J9 through a small adapter (orphan_nespad.v has the wiring); register HWPADS picks
// which connector is pad 1 and pad 2 (J1 and J2 after reset). Only a picked connector with its PLUG pin grounded
// by an adapter is ever driven.
// by JMSCNC, makers of RotatoCAM. GPL-2.0-or-later (built together with fpganes, GPL-2).
module top (
    output wire [3:0] leds,
    output wire       fan_pwm,
    input  wire [5:0] fan_tach,
    input  wire [8:0] j_plug,        // J1..J9 pin 5  (PLUG: the adapter ties it to GND)
    input  wire [8:0] j_rxd,         // J1..J9 pin 12 (RXD) <- pad DATA
    inout  wire [8:0] j_txd,         // J1..J9 pin 11 (TXD) -> pad CLOCK
    inout  wire [8:0] j_rst          // J1..J9 pin 15 (RST) -> pad LATCH
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_nes, rd_led, rd_fan;
    wire [3:0]  wstrb;
    wire [7:0]  lvl;
    wire [15:0] hw_pads;
    wire [1:0]  hw_drive;
    wire        hw_en, p_latch, p_clock;
    wire [3:0]  port1, port2;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_nes | rd_led | rd_fan));
    ardzy_info #(.SLOT(0), .PROJECT("NES1"), .VERSION(1)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n());
    orphan_nes_block #(.SLOT(1)) u_nes (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_nes),
        .level(lvl), .hw_pads(hw_pads), .hw_drive(hw_drive), .hw_enable(hw_en), .hw_port1(port1), .hw_port2(port2));

    // ---------------------------------------------------------------- real NES pads on the hashboard connectors
    wire [3:0]  k1 = port1 - 4'd1, k2 = port2 - 4'd1;        // 0..8
    orphan_nespad #(.N(2)) u_pads (.clk(clk), .enable(hw_en), .plug({j_plug[k2], j_plug[k1]}),
        .data({j_rxd[k2], j_rxd[k1]}), .latch(p_latch), .pclk(p_clock), .drive(hw_drive), .buttons(hw_pads), .present());
    genvar g;
    generate for (g = 0; g < 9; g = g + 1) begin : pad_io
        wire on = (hw_drive[0] && k1 == g) || (hw_drive[1] && k2 == g);
        IOBUF u_c (.I(p_clock), .T(!on), .O(), .IO(j_txd[g]));
        IOBUF u_l (.I(p_latch), .T(!on), .O(), .IO(j_rst[g]));
    end endgenerate
    orphan_leds #(.SLOT(14)) u_leds (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_led),
        .auto_lvl({lvl, lvl, lvl, lvl}), .vu(lvl), .lfo(lvl), .leds_n(leds));
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
endmodule
