`timescale 1ns / 1ps
// [orphan] Orphan TinyLM: slot 0 info ("TLM1"), slot 1 the int8 matrix-vector engine (tlm_gemv.v, its weights in DDR),
// slot 15 the fans. Runs at 75 MHz like Ardzy's AI Studio (100 MHz was too fast for the DDR paths on the chip).
//   LED 0 lights while a matrix runs.
// by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later. Built on Ardzy (by chryso, GPL-3.0): ardzy_bus_ddr, ardzy_info.
module top (
    output wire [3:0] leds,
    output wire       fan_pwm,
    input  wire [5:0] fan_tach
);
    wire clk, rstn, we, re;
    wire [15:0] addr;
    wire [31:0] wdata, rd_info, rd_lm, rd_fan;
    wire [3:0]  wstrb, info_leds_n;
    wire        busy;
    wire [159:0] dr_araddr;
    wire [19:0]  dr_arlen;
    wire [4:0]   dr_arvalid, dr_arready, dr_rvalid, dr_rlast, dr_rready;
    wire [319:0] dr_rdata;
    wire [9:0]   dr_rresp;
    ardzy_bus_ddr #(.CLK_DIV(12)) u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
        .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_lm | rd_fan),
        .dr_araddr(dr_araddr), .dr_arlen(dr_arlen), .dr_arvalid(dr_arvalid), .dr_arready(dr_arready), .dr_rdata(dr_rdata),
        .dr_rvalid(dr_rvalid), .dr_rlast(dr_rlast), .dr_rresp(dr_rresp), .dr_rready(dr_rready));
    ardzy_info #(.SLOT(0), .PROJECT("TLM4"), .VERSION(1), .CLOCK_HZ(75_000_000)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n(info_leds_n));
    tlm_gemv #(.SLOT(1)) u_lm (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_lm), .busy_led(busy),
        .dr_araddr(dr_araddr), .dr_arlen(dr_arlen), .dr_arvalid(dr_arvalid), .dr_arready(dr_arready), .dr_rdata(dr_rdata),
        .dr_rvalid(dr_rvalid), .dr_rlast(dr_rlast), .dr_rresp(dr_rresp), .dr_rready(dr_rready));
    orphan_fan #(.SLOT(15), .CLK_HZ(75_000_000)) u_fan (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
    assign leds = {info_leds_n[3:1], ~busy};
endmodule
