module top(output wire [3:0] leds,output wire fan_pwm,input wire [5:0] fan_tach);
 wire clk,rstn,we,re,gen;
 wire [15:0] addr;
 wire [31:0] wd,ri,rl,rg,rf;
 wire [3:0] ws,info_leds;
 ardzy_bus bus(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_wstrb(ws),.bus_we(we),.bus_re(re),.bus_rdata(ri|rl|rg|rf));
 ardzy_info #(.PROJECT("TOY1")) info(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(ri),.leds_n(info_leds));
 life u_life(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(rl),.gen_led(gen));
 toy_graphics graphics(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(rg));
 orphan_fan fan(.clk(clk),.rstn(rstn),.bus_addr(addr),.bus_wdata(wd),.bus_we(we),.bus_re(re),.bus_rdata(rf),.fan_pwm(fan_pwm),.fan_tach(fan_tach));
 assign leds={info_leds[3:1],~gen};
endmodule
