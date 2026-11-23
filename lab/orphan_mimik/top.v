`timescale 1ns / 1ps
// [orphan] MIMIK: the chip emulator. Slot 0 info ("MMK1"), slot 1 the MIMIK I2C target engine (mimik_i2c.v),
// slot 2 Ardzy's I2C master on the board's own I2C bus (the built-in self-test: MIMIK answers it over the real
// pins), slot 15 the fans.
//   The target's SCL / SDA can be any of the 36 hashboard header pins (J1..J9 pins 5, 11, 12, 15) or the board's
//   own I2C bus (W18 / W19, 1 kohm pull-ups on the board, out on pins 3 / 4 of J1..J8). All are open drain.
//   LED D5 lights while a bus master is talking to the emulated chip.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
// Built on Ardzy (by chryso, GPL-3.0): ardzy_bus, ardzy_info, ardzy_i2c. I2C bus engine: Alex Forencich's
// verilog-i2c i2c_slave.v (MIT).
module top (
    inout  wire [35:0] hdr,                 // J1.5 J1.11 J1.12 J1.15, J2.5 .. J9.15
    inout  wire        i2c_scl,             // the board's I2C bus
    inout  wire        i2c_sda,
    output wire [3:0]  leds,
    output wire        fan_pwm,
    input  wire [5:0]  fan_tach
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_mmk, rd_i2c, rd_fan;
    wire [3:0]  wstrb, info_leds_n;
    wire [37:0] pin_in, pin_low;
    wire        m_scl_low, m_sda_low, active;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_mmk | rd_i2c | rd_fan));
    ardzy_info #(.SLOT(0), .PROJECT("MMK1"), .VERSION(1)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n(info_leds_n));
    mimik_i2c #(.SLOT(1)) u_mmk (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_mmk),
        .pins_in(pin_in), .pins_low(pin_low), .led_active(active));
    ardzy_i2c #(.SLOT(2)) u_i2c (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_i2c),
        .scl_low(m_scl_low), .sda_low(m_sda_low), .scl_in(pin_in[36]), .sda_in(pin_in[37]));
    orphan_fan #(.SLOT(15)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
    genvar g;
    generate for (g = 0; g < 36; g = g + 1) begin : io
        IOBUF u (.I(1'b0), .T(!pin_low[g]), .O(pin_in[g]), .IO(hdr[g]));
    end endgenerate
    IOBUF u_scl (.I(1'b0), .T(!(pin_low[36] | m_scl_low)), .O(pin_in[36]), .IO(i2c_scl));
    IOBUF u_sda (.I(1'b0), .T(!(pin_low[37] | m_sda_low)), .O(pin_in[37]), .IO(i2c_sda));
    assign leds = {info_leds_n[3:2], 1'b1, ~active};
endmodule
