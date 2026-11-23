`timescale 1ns / 1ps
// [orphan] ORPHAN LOGIC LAB: SPEKTOR / INJEKTOR 3000. Slot 0 info ("SPK1"), slot 1 SPEKTOR (spektor.v),
// slot 2 INTERSEKTOR, the UART man-in-the-middle bridge (intersektor.v), slot 15 the fans.
// All 9 hashboard headers J1..J9 (pins 5, 11, 12, 15 of each = 36 pins) come in; SPEKTOR's channel map picks which
// 16 of them are CH0..CH15. INTERSEKTOR drives only its two transmit pins, and only after GO; SPEKTOR still sees
// every pin (the pad is read back), so it can capture both sides of the bridge.
//   LED D5 lights while armed, D6 when triggered.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
// Built on Ardzy (by chryso, GPL-3.0): ardzy_bus, ardzy_info.
module top (
    inout  wire [35:0] hdr,                 // J1.5 J1.11 J1.12 J1.15, J2.5 .. J9.15
    output wire [3:0]  leds,
    output wire        fan_pwm,
    input  wire [5:0]  fan_tach
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_spk, rd_ik, rd_fan;
    wire [3:0]  wstrb, info_leds_n;
    wire [35:0] pin_in, pin_o, pin_oe;
    wire        armed, trig, ik_act;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_spk | rd_ik | rd_fan));
    ardzy_info #(.SLOT(0), .PROJECT("SPK1"), .VERSION(2)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n(info_leds_n));
    spektor #(.SLOT(1)) u_spk (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_spk),
        .pins(pin_in), .led_armed(armed), .led_trig(trig));
    intersektor #(.SLOT(2)) u_ik (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_ik),
        .pins_in(pin_in), .pins_o(pin_o), .pins_oe(pin_oe), .led_act(ik_act));
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
    genvar g;
    generate for (g = 0; g < 36; g = g + 1) begin : io
        IOBUF u (.I(pin_o[g]), .T(!pin_oe[g]), .O(pin_in[g]), .IO(hdr[g]));
    end endgenerate
    assign leds = {info_leds_n[3:2], ~trig, ~(armed | ik_act)};
endmodule
