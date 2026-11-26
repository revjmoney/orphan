`timescale 1ns / 1ps
// Orphan Games: Atari 2600. Slot 0 info ("A261"), slot 1 the console (orphan_a26_block), slot 14 LEDs, slot 15 fans.
// The picture, sound and pads go through the ARM (browser / CYD); no video pins. Real NES pads can also plug into
// any hashboard connector J1..J9 through a small adapter (orphan_nespad.v has the wiring); register HWPADS picks
// which connector is pad 1 and pad 2 (J1 and J2 after reset). Only a picked connector whose own PLUG pin is
// grounded by an adapter is ever driven (orphan_nespad_ports), and never one in the optional HWNEVER mask; every
// other header pin stays an input. DISCONNECT EVERY HASHBOARD before loading this core.
// Real pad 1 is joystick 1, pad 2 joystick 2 (A or B fire, Select = GAME SELECT, Start = GAME RESET).
// by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later (built together with A2601 by Retromaster, GPL-3).
module top (
    output wire [3:0] leds,
    output wire       fan_pwm,
    input  wire [5:0] fan_tach,
    inout  wire [8:0] j_plug,        // J1..J9 pin 5  (PLUG: the adapter ties it to GND), input only
    inout  wire [8:0] j_rxd,         // J1..J9 pin 12 (RXD) <- pad DATA, input only
    inout  wire [8:0] j_txd,         // J1..J9 pin 11 (TXD) -> pad CLOCK
    inout  wire [8:0] j_rst          // J1..J9 pin 15 (RST) -> pad LATCH
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_a26, rd_led, rd_fan;
    wire [3:0]  wstrb;
    wire [7:0]  lvl;
    wire [15:0] hw_pads;
    wire [1:0]  hw_drive;
    wire        hw_en, p_latch, p_clock;
    wire [8:0]  plug_in, rxd_in, pad_oe;
    wire [3:0]  port1, port2;
    wire [8:0]  never;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_a26 | rd_led | rd_fan));
    ardzy_info #(.SLOT(0), .PROJECT("A261"), .VERSION(1)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n());
    orphan_a26_block #(.SLOT(1)) u_a26 (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_a26),
        .level(lvl), .hw_pads(hw_pads), .hw_drive(hw_drive), .hw_enable(hw_en), .hw_port1(port1), .hw_port2(port2), .hw_never(never));

    // ---------------------------------------------------------------- real NES pads on the hashboard connectors
    orphan_nespad_ports u_pads (.clk(clk), .enable(hw_en), .port1(port1), .port2(port2), .plug(plug_in), .rxd(rxd_in), .never(never),
        .latch(p_latch), .pclk(p_clock), .oe(pad_oe), .buttons(hw_pads), .drive(hw_drive));
    // IOBUFs like MIMIK's (proven on the board with PULLTYPE PULLUP): PLUG and RXD never drive (T = 1)
    genvar g;
    generate for (g = 0; g < 9; g = g + 1) begin : pad_io
        IOBUF u_p (.I(1'b0), .T(1'b1), .O(plug_in[g]), .IO(j_plug[g]));
        IOBUF u_d (.I(1'b0), .T(1'b1), .O(rxd_in[g]), .IO(j_rxd[g]));
        IOBUF u_c (.I(p_clock), .T(!pad_oe[g]), .O(), .IO(j_txd[g]));
        IOBUF u_l (.I(p_latch), .T(!pad_oe[g]), .O(), .IO(j_rst[g]));
    end endgenerate
    orphan_leds #(.SLOT(14)) u_leds (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_led),
        .auto_lvl({lvl, lvl, lvl, lvl}), .vu(lvl), .lfo(lvl), .leds_n(leds));
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
endmodule
