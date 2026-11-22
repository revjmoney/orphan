`timescale 1ns / 1ps
// Orphan Synth project: slot 0 info ("SYN3"), slot 1 the 8-voice synth, slot 14 LED PWM light show,
// slot 15 fan control (in every Orphan design).
// I2S out on J3 like Ardzy's audio project: pin 5 MCLK, 11 BCLK, 12 DOUT, 15 LRCLK (PCM5102A: SCK to GND).
module top (
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
    wire [31:0] wdata, rd_info, rd_syn, rd_led, rd_fan;
    wire [3:0]  wstrb;
    wire [31:0] led_voice;
    wire [7:0]  led_vu, led_lfo;
    ardzy_bus u_bus (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_wstrb(wstrb),
                     .bus_we(we), .bus_re(re), .bus_rdata(rd_info | rd_syn | rd_led | rd_fan));
    ardzy_info #(.SLOT(0), .PROJECT("SYN3"), .VERSION(3)) u_info (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_info), .leds_n());
    orphan_synth #(.SLOT(1)) u_syn (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_syn), .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout),
        .led_voice(led_voice), .led_vu(led_vu), .led_lfo(led_lfo));
    orphan_leds #(.SLOT(14)) u_leds (                 // D5..D8 hardware PWM + light show sources
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_led), .auto_lvl(led_voice), .vu(led_vu), .lfo(led_lfo), .leds_n(leds));
    orphan_fan #(.SLOT(15)) u_fan (                   // fan control in every Orphan design (slot 15, "FAN1")
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rd_fan), .fan_pwm(fan_pwm), .fan_tach(fan_tach));
endmodule
