module top(output wire [3:0] leds, output wire fan_pwm, input wire [5:0] fan_tach);
 wire clk,rstn,we,re;
 wire [15:0] addr;
 wire [31:0] wd,ri,rk,rf;
 wire [3:0] ws;
 ardzy_bus bus(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_wstrb(ws),.bus_we(we),.bus_re(re),.bus_rdata(ri|rk|rf));
 ardzy_info #(.PROJECT("KAS1")) info(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(ri),.leds_n(leds));
 kas_engine core(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_wstrb(ws),.bus_we(we),.bus_re(re),.bus_rdata(rk));
 orphan_fan fan(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(rf),.fan_pwm(fan_pwm),.fan_tach(fan_tach));
endmodule
