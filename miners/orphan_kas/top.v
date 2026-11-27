module top(output wire [3:0] leds, output wire fan_pwm, input wire [5:0] fan_tach);
 wire clk,rstn,we,re;
 wire [15:0] addr;
 wire [31:0] wd,ri,rk,rf,rl;
 wire [3:0] info_n;
 wire busy;
 wire [3:0] ws;
 ardzy_bus bus(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_wstrb(ws),.bus_we(we),.bus_re(re),.bus_rdata(ri|rk|rf|rl));
 ardzy_info #(.PROJECT("KAS1")) info(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(ri),.leds_n(info_n));
 kas_engine core(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_wstrb(ws),.bus_we(we),.bus_re(re),.bus_rdata(rk),.active(busy));
 orphan_fan fan(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(rf),.fan_pwm(fan_pwm),.fan_tach(fan_tach));
 // Orphan 2026-11-26: the 4 LEDs breathe in a slow scanner while the engine searches (slot 5, orphan_larson.v)
 orphan_larson #(.SLOT(5)) scan(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(rl),.active(busy),.idle_n(info_n),.leds_n(leds));
endmodule
