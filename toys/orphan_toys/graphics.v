// Orphan graphics toys. Ray stepping, wall projection and pixel shading run in PL.
// 160x120 RGB565 capture buffer; ARM only transports/scales completed frames.
module toy_graphics(input wire clk,rstn,input wire [15:0] bus_addr,
 input wire [31:0] bus_wdata,input wire bus_we,bus_re,output reg [31:0] bus_rdata=0);
 wire ctl=bus_addr[15:12]==2;
 wire vec=bus_addr[15:12]==3;
 wire [9:0] idx=bus_addr[11:2];
 reg [1:0] mode=0;
 reg [15:0] cam_x=16'd1920,cam_y=16'd1408;
 reg [7:0] phase=0;
 reg busy=0,done=0;
 reg [31:0] frames=0,cycles=0;
 reg [2:0] state=0;
 reg [7:0] column=0;
 reg [6:0] y=0;
 reg [15:0] px=0,py=0;
 reg [7:0] distance=0,wall_height=0;
 (* ram_style="block" *) reg [31:0] rays[0:159];
 reg [31:0] ray=0;
 (* ram_style="block" *) reg [15:0] fb_lo[0:9599];
 (* ram_style="block" *) reg [15:0] fb_hi[0:9599];
 wire [14:0] pixel_index=y*15'd160+column;
 wire [13:0] read_index=bus_addr[15:2]-14'd4096;
 wire is_frame=bus_addr>=16'h4000 && bus_addr<16'hd600;
 reg [31:0] frame_data=0,control_data=0;
 reg read_pending=0,frame_pending=0;
 wire [15:0] wall_row;
 toy_map map(.y(py[11:8]),.row(wall_row));
 wire hit=(px[15:12]!=0 || py[15:12]!=0 || wall_row[px[11:8]]);
 wire [7:0] projected_height;
 toy_projection projection(.distance(distance),.height(projected_height));
 wire [6:0] top_edge=(8'd120-wall_height)>>1;
 wire [7:0] bottom_edge=top_edge+wall_height;
 wire [7:0] ax=column+phase,ay={y,1'b0}+phase,az=column+{1'b0,y}-phase;
 wire [7:0] wave_x=ax[7]?~{ax[6:0],1'b0}:{ax[6:0],1'b0};
 wire [7:0] wave_y=ay[7]?~{ay[6:0],1'b0}:{ay[6:0],1'b0};
 wire [7:0] wave_z=az[7]?~{az[6:0],1'b0}:{az[6:0],1'b0};
 reg [15:0] pixel;
 wire [4:0] shade=5'd31-{1'b0,distance[7:4]};
 wire checker=y[3]^column[3];
 always @* begin
   if(mode==1) pixel={wave_x[7:3],wave_y[7:2],wave_z[7:3]};
   else if(mode==2) pixel={ax[4:0]^ay[4:0],ax[5:0]^az[5:0],ay[4:0]^az[4:0]};
   else if(y<top_edge) pixel=16'h0863;
   else if(y>=bottom_edge) pixel=y[3]^column[4]?16'h1945:16'h2127;
   else if(checker) pixel={shade,shade,1'b0,5'd5};
   else pixel={5'd4,shade,1'b0,shade};
 end
 always @(posedge clk) begin
   if(bus_we && vec && idx<160 && !busy) rays[idx]<=bus_wdata;
   ray<=rays[column];
   if(busy && state==3) begin
     if(pixel_index[0])fb_hi[pixel_index[14:1]]<=pixel;
     else fb_lo[pixel_index[14:1]]<=pixel;
   end
   if(is_frame) frame_data<={fb_hi[read_index],fb_lo[read_index]};
   read_pending<=bus_re;
   if(bus_re) begin
     frame_pending<=is_frame;
     control_data<=0;
     if(ctl)case(idx)
       0:control_data<=32'h544f5931;
       1:control_data<={30'd0,done,busy};
       2:control_data<={30'd0,mode};
       3:control_data<=frames;
       4:control_data<=cycles;
       5:control_data<={16'd0,cam_x};
       6:control_data<={16'd0,cam_y};
       7:control_data<={24'd0,phase};
       default:control_data<=0;
     endcase
   end
   if(read_pending)bus_rdata<=frame_pending?frame_data:control_data;
 end
 always @(posedge clk) begin
   if(!rstn) begin busy<=0;done<=0;state<=0; end
   else begin
     if(busy)cycles<=cycles+1'b1;
     if(bus_we && ctl && !busy)case(idx)
       2:mode<=bus_wdata[1:0];5:cam_x<=bus_wdata[15:0];6:cam_y<=bus_wdata[15:0];7:phase<=bus_wdata[7:0];
       default:;
     endcase
     case(state)
       0:if(bus_we && ctl && idx==1 && bus_wdata[0])begin
         column<=0;y<=0;cycles<=0;busy<=1;done<=0;state<=1;
       end
       1:begin px<=cam_x;py<=cam_y;distance<=0;y<=0;state<=mode==0?2:3;end
       2:if(hit || distance==255)begin wall_height<=projected_height;y<=0;state<=3;end
         else begin px<=px+ray[15:0];py<=py+ray[31:16];distance<=distance+1'b1;end
       3:if(y==119)begin
         if(column==159)begin busy<=0;done<=1;frames<=frames+1'b1;state<=0;end
         else begin column<=column+1'b1;state<=4;end
       end else y<=y+1'b1;
       4:state<=1; // synchronous view-vector read settles before tracing
       default:state<=0;
     endcase
   end
 end
endmodule
