// Orphan KAS search with overlapping Keccak and matrix work.
// Slot 1, configuration is writable only while idle. Matrix = 512 packed u32 words.
module kas_engine #(parameter [3:0] SLOT=1)(
 input wire clk, rstn, input wire [15:0] bus_addr,
 input wire [31:0] bus_wdata, input wire [3:0] bus_wstrb,
 input wire bus_we, bus_re, output reg [31:0] bus_rdata=0,
 output wire active);  // Orphan 2026-11-26: busy, for the LED scanner
 wire sel=bus_addr[15:12]==SLOT;
 assign active=busy;
 wire [9:0] idx=bus_addr[11:2];
 wire command=bus_we && sel && idx==1 && bus_wstrb[0];
 reg stop=0,start=0,clear=0;
 always @(posedge clk) begin
   stop<=command && bus_wdata[1];
   start<=command && bus_wdata[0];
   clear<=command && bus_wdata[2];
 end
 reg [255:0] seed=0, target=0;
 reg [63:0] timestamp=0, nonce_start=0, nonce_end=0;
 reg [63:0] issue_nonce=0, retire_nonce=0, last_nonce=0, hashes=0, cycles=0;
 reg [255:0] last_hash=0, matrix_hash=0;
 reg busy=0, found=0, exhausted=0, stopped=0, bad_config=0;
 // Two single-entry buffers link the stages. Each stage processes consecutive
 // nonces in order, so no nonce tags or wide indexed registers are needed.
 reg [255:0] pow_buffer=0, heavy_buffer=0;
 reg pow_ready=0, heavy_ready=0;
 reg issue_finished=0, keccak_running=0, keccak_heavy=0, matrix_running=0;
 reg check_pending=0;
 wire launch_heavy=!keccak_running && !check_pending && heavy_ready;
 reg matrix_start=0;
 wire matrix_done;
 wire [255:0] mixed;
 // Constants are cSHAKE256 domain states, including fixed message padding.
 // Generated from the upstream Kaspa constants; see generate_states.py.
// BEGIN STATES
localparam [1599:0] POW_STATE=1600'h02b97c786f8243835d1129cf82afa5bcb1fcce9ce78b527248b09427a8742edb89ca4e849bcecf4ad102574105095f8dba1de5e4451668e4c1a2021d563bb1420f06dd1c7a2f851a3485549064a36a46b21a601f85b4b223e6c85d8f82e9da89ec70f1a425b1371544e367875b2991520f96070540f14a0a2e651c3c43285ff0f8ebf13388663140776bf60c789bc29c183a981ead415b104aef61d629dce2467b2fafca875e2d651ba5a4a3f59869a01e5f2e720efb44d229bf8855b7027e3c113cff0da1f6d83d;
localparam [1599:0] HEAVY_STATE=1600'h1619327d10b9da35549ae0312f9fc61592bb399db5290c0a47c39f675112c22ec776c5048481b957b992f2d37b34ca58ea8fdb80bac46d397e8f1db17765cc0707e961b036bc9416774c86835434f2b04ef74b3a99cdb0442ec65bd3562493e46c6b7d01a769cc3dd31f4cc354c18c3ff431c05dd0a9a226a0bcaa9f792a3d0c8039f9a60dcf6a485e219040250fc462c100ff2a938935ba72c7d82e14f34069e720e0df44eeceda11a75f4c800564987a14ff4816c7f8ee79629b0e2f9f42163ad74c52b2248509;
// END STATES
 reg [1599:0] kin=0;
 reg kstart=0;
 reg [7:0] cmp_less=0,cmp_equal=0;
 reg meets_target;
 integer cidx;
 always @* begin
   meets_target=1'b1;
   for(cidx=0;cidx<8;cidx=cidx+1)
     meets_target=cmp_less[cidx] | (cmp_equal[cidx] & meets_target);
 end
 wire [1599:0] kout;
 wire kdone;
 wire work_resetn=rstn && busy && !stop && !clear;
 kas_keccak u_k(.clk(clk), .rstn(work_resetn),
   .start(kstart), .state_in(kin), .state_out(kout), .done(kdone));
 kas_matrix matrix(
   .clk(clk),.rstn(work_resetn),.start(matrix_start),.hash_in(matrix_hash),
   .wr_en(bus_we && sel && idx[9] && !busy),.wr_addr(idx[8:0]),
   .wr_data(bus_wdata),.wr_strb(bus_wstrb),.result(mixed),.done(matrix_done));
 integer j;
 always @(posedge clk) begin
   kstart<=0; matrix_start<=0;
   if(!rstn || clear || stop) begin
     busy<=0; found<=0; exhausted<=0; stopped<=stop; bad_config<=0;
     if(!stop) begin hashes<=0; cycles<=0; last_hash<=0; last_nonce<=0; end
   end else begin
     if(busy) cycles<=cycles+1'b1;
     if(bus_we && sel && !busy && !idx[9]) begin
       for(j=0;j<4;j=j+1) if(bus_wstrb[j]) begin
         if(idx[9:3]==7'd8) seed[{idx[2:0],j[1:0],3'b000} +:8]<=bus_wdata[8*j +:8];
         if(idx[9:1]==9'd36) timestamp[{idx[0],j[1:0],3'b000} +:8]<=bus_wdata[8*j +:8];
         if(idx[9:1]==9'd37) nonce_start[{idx[0],j[1:0],3'b000} +:8]<=bus_wdata[8*j +:8];
         if(idx[9:1]==9'd38) nonce_end[{idx[0],j[1:0],3'b000} +:8]<=bus_wdata[8*j +:8];
         if(idx[9:3]==7'd10) target[{idx[2:0],j[1:0],3'b000} +:8]<=bus_wdata[8*j +:8];
       end
     end
     if(!busy) begin
       if(start) begin
         found<=0; exhausted<=0; stopped<=0; hashes<=0; cycles<=0; last_hash<=0;
         bad_config<=nonce_start>nonce_end || seed==0;
         if(nonce_start<=nonce_end && seed!=0) begin
           busy<=1;
           issue_nonce<=nonce_start;retire_nonce<=nonce_start;
           pow_ready<=0;heavy_ready<=0;
           issue_finished<=0;keccak_running<=0;matrix_running<=0;check_pending<=0;
         end
       end
     end else begin
       if(check_pending) begin
         check_pending<=0;
         if(meets_target) begin found<=1;busy<=0;end
         else if(retire_nonce==nonce_end)begin exhausted<=1;busy<=0;end
         else retire_nonce<=retire_nonce+1'b1;
       end
       if(matrix_done && matrix_running)begin
         heavy_buffer<=mixed ^ matrix_hash;heavy_ready<=1;matrix_running<=0;
       end else if(!matrix_running && pow_ready && (!heavy_ready || launch_heavy))begin
         matrix_hash<=pow_buffer;pow_ready<=0;
         matrix_start<=1;matrix_running<=1;
       end
       if(kdone && keccak_running) begin
         keccak_running<=0;
         if(keccak_heavy) begin
           last_hash<=kout[255:0];last_nonce<=retire_nonce;hashes<=hashes+1'b1;
           check_pending<=1;
           for(j=0;j<8;j=j+1) begin
             cmp_less[j]<=kout[j*32 +:32]<target[j*32 +:32];
             cmp_equal[j]<=kout[j*32 +:32]==target[j*32 +:32];
           end
         end else begin
           pow_buffer<=kout[255:0];pow_ready<=1;
         end
       end else if(!keccak_running)begin
         if(launch_heavy)begin
           kin<=HEAVY_STATE ^ {1344'd0,heavy_buffer};
           heavy_ready<=0;keccak_heavy<=1;kstart<=1;keccak_running<=1;
         end else if(!issue_finished && !pow_ready)begin
           kin<=POW_STATE ^ {960'd0,issue_nonce,256'd0,timestamp,seed};
           if(issue_nonce==nonce_end)issue_finished<=1;
           else issue_nonce<=issue_nonce+1'b1;
           keccak_heavy<=0;kstart<=1;keccak_running<=1;
         end
       end
     end
   end
 end
 // Two-cycle read response, as supported by ardzy_bus. Small independent muxes
 // keep the high-fanout address decode off the combined result path.
 reg [31:0] rd_control=0,rd_hash=0,rd_seed=0,rd_config=0,rd_target=0;
 reg read_pending=0;
 always @(posedge clk) begin
   read_pending<=bus_re;
   if(read_pending) bus_rdata<=rd_control|rd_hash|rd_seed|rd_config|rd_target;
   if(bus_re) begin
     rd_control<=0; rd_hash<=0; rd_seed<=0; rd_config<=0; rd_target<=0;
     if(sel) begin
       case(idx)
         0: rd_control<=32'h4b415331;
         2: rd_control<={27'd0,bad_config,stopped,exhausted,found,busy};
         3: rd_control<=hashes[31:0]; 4: rd_control<=hashes[63:32];
         5: rd_control<=cycles[31:0]; 6: rd_control<=cycles[63:32];
         7: rd_control<=last_nonce[31:0]; 8: rd_control<=last_nonce[63:32];
         17: rd_control<=32'd1;
       endcase
       case(idx)
         10'd9: rd_hash<=last_hash[0 +:32];
         10'd10: rd_hash<=last_hash[32 +:32];
         10'd11: rd_hash<=last_hash[64 +:32];
         10'd12: rd_hash<=last_hash[96 +:32];
         10'd13: rd_hash<=last_hash[128 +:32];
         10'd14: rd_hash<=last_hash[160 +:32];
         10'd15: rd_hash<=last_hash[192 +:32];
         10'd16: rd_hash<=last_hash[224 +:32];
       endcase
       case(idx)
         10'd64: rd_seed<=seed[0 +:32];
         10'd65: rd_seed<=seed[32 +:32];
         10'd66: rd_seed<=seed[64 +:32];
         10'd67: rd_seed<=seed[96 +:32];
         10'd68: rd_seed<=seed[128 +:32];
         10'd69: rd_seed<=seed[160 +:32];
         10'd70: rd_seed<=seed[192 +:32];
         10'd71: rd_seed<=seed[224 +:32];
       endcase
       case(idx)
         10'd80: rd_target<=target[0 +:32];
         10'd81: rd_target<=target[32 +:32];
         10'd82: rd_target<=target[64 +:32];
         10'd83: rd_target<=target[96 +:32];
         10'd84: rd_target<=target[128 +:32];
         10'd85: rd_target<=target[160 +:32];
         10'd86: rd_target<=target[192 +:32];
         10'd87: rd_target<=target[224 +:32];
       endcase
       case(idx)
         10'd72: rd_config<=timestamp[0 +:32];
         10'd73: rd_config<=timestamp[32 +:32];
         10'd74: rd_config<=nonce_start[0 +:32];
         10'd75: rd_config<=nonce_start[32 +:32];
         10'd76: rd_config<=nonce_end[0 +:32];
         10'd77: rd_config<=nonce_end[32 +:32];
       endcase
     end
   end
 end
endmodule
