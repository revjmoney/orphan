// Full-row 64x64 nibble transform. One row enters the pipeline every clock.
module kas_matrix(input wire clk,rstn,start,input wire [255:0] hash_in,
 input wire wr_en,input wire [8:0] wr_addr,input wire [31:0] wr_data,
 input wire [3:0] wr_strb,output reg [255:0] result=0,output reg done=0);
 reg active=0;
 reg [6:0] issued=0;
 wire [5:0] row_addr=issued[5:0];
 reg [255:0] row_data;
 wire [255:0] vector;
 genvar g;
 generate for(g=0;g<32;g=g+1)begin: nibbles
   assign vector[g*8 +:8]={hash_in[g*8 +:4],hash_in[g*8+4 +:4]};
 end endgenerate
 generate for(g=0;g<8;g=g+1)begin: banks
   (* ram_style="block" *) reg [31:0] mem[0:63];
   integer b;
   always @(posedge clk)begin
     if(wr_en && wr_addr[2:0]==g)
       for(b=0;b<4;b=b+1)if(wr_strb[b])mem[wr_addr[8:3]][b*8 +:8]<=wr_data[b*8 +:8];
     row_data[g*32 +:32]<=mem[row_addr];
   end
 end endgenerate
 reg vr=0,vp=0,vs=0,vd=0,vt=0;
 reg [5:0] tr=0,tp=0,ts=0,td=0,tt=0;
 reg [7:0] products[0:63];
 reg [9:0] sums16[0:15];
 reg [11:0] sums4[0:3];
 reg [13:0] total=0;
 // Valid bits track the useful rows. The data registers can advance every clock,
 // keeping one shared clock-enable signal off each wide register group.
 generate for(g=0;g<64;g=g+1)begin: multiply
   always @(posedge clk)products[g]<=row_data[g*4 +:4]*vector[g*4 +:4];
 end endgenerate
 generate for(g=0;g<16;g=g+1)begin: reduce16
   always @(posedge clk)sums16[g]<=({2'b0,products[g*4]}+{2'b0,products[g*4+1]})
                                +({2'b0,products[g*4+2]}+{2'b0,products[g*4+3]});
 end endgenerate
 generate for(g=0;g<4;g=g+1)begin: reduce4
   always @(posedge clk)sums4[g]<=({2'b0,sums16[g*4]}+{2'b0,sums16[g*4+1]})
                               +({2'b0,sums16[g*4+2]}+{2'b0,sums16[g*4+3]});
 end endgenerate
 // Each row writes a fixed nibble. All 64 nibbles are overwritten before done.
 generate for(g=0;g<64;g=g+1)begin: store_row
   localparam integer RESULT_BIT=(g/2)*8+((g%2)==0 ? 4 : 0);
   always @(posedge clk)if(rstn && vt && tt==g)result[RESULT_BIT +:4]<=total[13:10];
 end endgenerate
 always @(posedge clk)begin
   done<=0;
   vr<=active && issued<64;vp<=vr;vs<=vp;vd<=vs;vt<=vd;
   tr<=row_addr;tp<=tr;ts<=tp;td<=ts;tt<=td;
   total<=({2'b0,sums4[0]}+{2'b0,sums4[1]})+({2'b0,sums4[2]}+{2'b0,sums4[3]});
   if(!rstn)begin active<=0;vr<=0;vp<=0;vs<=0;vd<=0;vt<=0;end
   else if(start && !active)begin
     active<=1;issued<=0;vr<=0;vp<=0;vs<=0;vd<=0;vt<=0;
   end else begin
     if(active && issued<64)issued<=issued+1'b1;
     if(vt && tt==63)begin active<=0;done<=1;end
   end
 end
endmodule
