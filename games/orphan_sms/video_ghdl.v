// [orphan] Orphan Games: the Sega Master System / Game Gear core for the S9 control board FPGA.
// This file is MACHINE-GENERATED Verilog: GHDL 4.1 synthesized it from the VHDL of the MiSTer SMS core
// (https://github.com/MiSTer-devel/SMS_MiSTer, GPL-2.0-or-later; patched copies in games/sms_vhdl,
// converter games/ghdl_convert.sh). Its licence follows the VHDL it was made from. See LICENSES.md here.
// GHDL escaped names (a backslash name such as u0 reg) were renamed for Yosys (*_esc). by JMSCNC, makers of RotatoCAM (the glue).
//
// The SMS video timing from the MiSTer SMS core (GPL-2.0-or-later).

module video
  (input  clk,
   input  ce_pix,
   input  pal,
   input  border,
   input  ggres,
   input  mask_column,
   input  cut_mask,
   input  smode_M1,
   input  smode_M2,
   input  smode_M3,
   input  smode_M4,
   input  [21:0] video_state_in,
   input  video_state_set,
   output [21:0] video_state_out,
   output [8:0] x,
   output [8:0] y,
   output [7:0] vcounter_cpu,
   output hsync,
   output vsync,
   output hblank,
   output vblank);
  reg [8:0] hcount;
  reg [8:0] vcount;
  reg [8:0] vcounter_cpu_reg;
  reg hsync_reg;
  reg vsync_reg;
  reg hblank_reg;
  reg vblank_reg;
  wire [8:0] vbl_st;
  wire [8:0] vbl_end;
  wire [8:0] hbl_st;
  wire [8:0] hbl_end;
  wire [8:0] n18_o;
  wire [8:0] n19_o;
  wire n20_o;
  wire n21_o;
  wire [8:0] n22_o;
  wire n24_o;
  wire [8:0] n25_o;
  wire n27_o;
  wire n28_o;
  wire n29_o;
  wire [8:0] n30_o;
  wire n32_o;
  wire [8:0] n33_o;
  wire [8:0] n35_o;
  wire [8:0] n37_o;
  wire n38_o;
  wire [8:0] n39_o;
  wire n41_o;
  wire [8:0] n42_o;
  wire [8:0] n44_o;
  wire [8:0] n46_o;
  wire [8:0] n47_o;
  wire n49_o;
  wire [8:0] n50_o;
  wire [8:0] n52_o;
  wire [8:0] n54_o;
  wire [8:0] n55_o;
  wire [8:0] n56_o;
  wire n57_o;
  wire [8:0] n58_o;
  wire n60_o;
  wire [8:0] n61_o;
  wire [8:0] n63_o;
  wire [8:0] n65_o;
  wire n66_o;
  wire [8:0] n67_o;
  wire n69_o;
  wire [8:0] n70_o;
  wire [8:0] n72_o;
  wire [8:0] n74_o;
  wire [8:0] n75_o;
  wire n77_o;
  wire [8:0] n78_o;
  wire [8:0] n80_o;
  wire [8:0] n82_o;
  wire [8:0] n83_o;
  wire [8:0] n84_o;
  wire [8:0] n85_o;
  wire [8:0] n86_o;
  wire [8:0] n87_o;
  wire n89_o;
  wire n90_o;
  wire n92_o;
  wire [8:0] n94_o;
  wire [8:0] n96_o;
  wire n97_o;
  wire n99_o;
  wire [8:0] n101_o;
  wire [8:0] n103_o;
  wire n105_o;
  wire [8:0] n107_o;
  wire [8:0] n109_o;
  wire [8:0] n110_o;
  wire [8:0] n111_o;
  wire n112_o;
  wire n114_o;
  wire [8:0] n116_o;
  wire [8:0] n118_o;
  wire n119_o;
  wire n121_o;
  wire [8:0] n123_o;
  wire [8:0] n125_o;
  wire n127_o;
  wire [8:0] n129_o;
  wire [8:0] n131_o;
  wire [8:0] n132_o;
  wire [8:0] n133_o;
  wire [8:0] n134_o;
  wire [8:0] n135_o;
  wire n137_o;
  wire [8:0] n139_o;
  wire n140_o;
  wire n142_o;
  wire n144_o;
  wire n146_o;
  wire n148_o;
  wire n150_o;
  wire [8:0] n152_o;
  wire n153_o;
  wire n154_o;
  wire n156_o;
  wire n158_o;
  wire n160_o;
  wire n162_o;
  wire n164_o;
  wire [8:0] n166_o;
  wire n167_o;
  wire n169_o;
  wire n171_o;
  wire n173_o;
  wire n175_o;
  wire n177_o;
  wire [8:0] n179_o;
  wire n180_o;
  wire [8:0] n181_o;
  wire n182_o;
  wire [8:0] n183_o;
  wire n184_o;
  wire n185_o;
  wire n187_o;
  wire n189_o;
  wire n191_o;
  wire n193_o;
  wire n195_o;
  wire [8:0] n197_o;
  wire n198_o;
  wire n199_o;
  wire n201_o;
  wire n203_o;
  wire n205_o;
  wire n207_o;
  wire n209_o;
  wire [8:0] n211_o;
  wire n212_o;
  wire n214_o;
  wire n216_o;
  wire n218_o;
  wire n220_o;
  wire n222_o;
  wire [8:0] n224_o;
  wire n225_o;
  wire [8:0] n226_o;
  wire n227_o;
  wire [8:0] n228_o;
  wire n229_o;
  wire [8:0] n230_o;
  wire n231_o;
  wire [8:0] n232_o;
  wire n233_o;
  wire [8:0] n235_o;
  wire n237_o;
  wire [8:0] n239_o;
  wire n241_o;
  wire n243_o;
  wire n245_o;
  wire n247_o;
  wire [8:0] n248_o;
  wire n249_o;
  wire n250_o;
  wire n251_o;
  wire n252_o;
  wire [8:0] n253_o;
  wire [8:0] n254_o;
  wire [8:0] n255_o;
  wire n256_o;
  wire n257_o;
  wire [7:0] n264_o;
  wire [17:0] n265_o;
  wire [18:0] n266_o;
  wire [19:0] n267_o;
  wire [20:0] n268_o;
  wire [21:0] n269_o;
  wire n271_o;
  wire n272_o;
  wire [8:0] n273_o;
  wire n275_o;
  wire [8:0] n276_o;
  wire n278_o;
  wire [8:0] n279_o;
  wire n281_o;
  wire n282_o;
  wire [8:0] n283_o;
  wire [8:0] n285_o;
  wire n287_o;
  wire [8:0] n288_o;
  wire n291_o;
  wire [8:0] n292_o;
  wire n294_o;
  wire n295_o;
  wire n296_o;
  wire n297_o;
  wire n298_o;
  wire n299_o;
  wire n300_o;
  wire [8:0] n301_o;
  wire n303_o;
  wire n304_o;
  wire [8:0] n305_o;
  wire [8:0] n307_o;
  wire n310_o;
  wire n311_o;
  wire [8:0] n312_o;
  wire n314_o;
  wire n315_o;
  wire [8:0] n316_o;
  wire n319_o;
  wire n320_o;
  wire [8:0] n321_o;
  wire n323_o;
  wire n324_o;
  wire n325_o;
  wire n326_o;
  wire [8:0] n327_o;
  wire n329_o;
  wire n330_o;
  wire [8:0] n331_o;
  wire n336_o;
  wire n337_o;
  wire n338_o;
  wire n339_o;
  wire n341_o;
  wire n343_o;
  wire n344_o;
  wire n345_o;
  wire n347_o;
  wire n349_o;
  wire n350_o;
  wire n351_o;
  wire n352_o;
  wire n353_o;
  reg [8:0] n357_q;
  reg [8:0] n358_q;
  reg [8:0] n359_q;
  reg n360_q;
  reg n361_q;
  reg n362_q;
  reg n363_q;
  assign video_state_out = n269_o;
  assign x = hcount;
  assign y = vcount;
  assign vcounter_cpu = n264_o;
  assign hsync = hsync_reg;
  assign vsync = vsync_reg;
  assign hblank = hblank_reg;
  assign vblank = vblank_reg;
  /* ./video.vhd:35:16  */
  always @*
    hcount = n357_q; // (isignal)
  initial
    hcount = 9'b000000000;
  /* ./video.vhd:36:16  */
  always @*
    vcount = n358_q; // (isignal)
  initial
    vcount = 9'b000000000;
  /* ./video.vhd:41:16  */
  always @*
    vcounter_cpu_reg = n359_q; // (isignal)
  initial
    vcounter_cpu_reg = 9'b000000000;
  /* ./video.vhd:43:16  */
  always @*
    hsync_reg = n360_q; // (isignal)
  initial
    hsync_reg = 1'b0;
  /* ./video.vhd:44:16  */
  always @*
    vsync_reg = n361_q; // (isignal)
  initial
    vsync_reg = 1'b0;
  /* ./video.vhd:45:16  */
  always @*
    hblank_reg = n362_q; // (isignal)
  initial
    hblank_reg = 1'b0;
  /* ./video.vhd:46:16  */
  always @*
    vblank_reg = n363_q; // (isignal)
  initial
    vblank_reg = 1'b0;
  /* ./video.vhd:48:16  */
  assign vbl_st = n273_o; // (signal)
  /* ./video.vhd:48:23  */
  assign vbl_end = n292_o; // (signal)
  /* ./video.vhd:49:16  */
  assign hbl_st = n312_o; // (signal)
  /* ./video.vhd:49:23  */
  assign hbl_end = n321_o; // (signal)
  /* ./video.vhd:56:57  */
  assign n18_o = video_state_in[21:13];
  /* ./video.vhd:57:57  */
  assign n19_o = video_state_in[12:4];
  /* ./video.vhd:58:60  */
  assign n20_o = video_state_in[3];
  /* ./video.vhd:59:60  */
  assign n21_o = video_state_in[2];
  /* ./video.vhd:62:51  */
  assign n22_o = video_state_in[21:13];
  /* ./video.vhd:62:66  */
  assign n24_o = n22_o == 9'b111100110;
  /* ./video.vhd:63:51  */
  assign n25_o = video_state_in[21:13];
  /* ./video.vhd:63:66  */
  assign n27_o = n25_o == 9'b111100111;
  /* ./video.vhd:62:98  */
  assign n28_o = n24_o | n27_o;
  /* ./video.vhd:65:67  */
  assign n29_o = smode_M2 & smode_M1;
  /* ./video.vhd:66:74  */
  assign n30_o = video_state_in[12:4];
  /* ./video.vhd:66:88  */
  assign n32_o = n30_o == 9'b100000010;
  /* ./video.vhd:69:99  */
  assign n33_o = video_state_in[12:4];
  /* ./video.vhd:69:113  */
  assign n35_o = n33_o + 9'b000000001;
  /* ./video.vhd:66:57  */
  assign n37_o = n32_o ? 9'b111001010 : n35_o;
  /* ./video.vhd:71:70  */
  assign n38_o = smode_M2 & smode_M3;
  /* ./video.vhd:72:74  */
  assign n39_o = video_state_in[12:4];
  /* ./video.vhd:72:88  */
  assign n41_o = n39_o == 9'b100001010;
  /* ./video.vhd:75:99  */
  assign n42_o = video_state_in[12:4];
  /* ./video.vhd:75:113  */
  assign n44_o = n42_o + 9'b000000001;
  /* ./video.vhd:72:57  */
  assign n46_o = n41_o ? 9'b111100010 : n44_o;
  /* ./video.vhd:78:74  */
  assign n47_o = video_state_in[12:4];
  /* ./video.vhd:78:88  */
  assign n49_o = n47_o == 9'b011110010;
  /* ./video.vhd:81:99  */
  assign n50_o = video_state_in[12:4];
  /* ./video.vhd:81:113  */
  assign n52_o = n50_o + 9'b000000001;
  /* ./video.vhd:78:57  */
  assign n54_o = n49_o ? 9'b110111010 : n52_o;
  /* ./video.vhd:71:49  */
  assign n55_o = n38_o ? n46_o : n54_o;
  /* ./video.vhd:65:49  */
  assign n56_o = n29_o ? n37_o : n55_o;
  /* ./video.vhd:85:67  */
  assign n57_o = smode_M2 & smode_M1;
  /* ./video.vhd:86:74  */
  assign n58_o = video_state_in[12:4];
  /* ./video.vhd:86:88  */
  assign n60_o = n58_o == 9'b011101010;
  /* ./video.vhd:89:99  */
  assign n61_o = video_state_in[12:4];
  /* ./video.vhd:89:113  */
  assign n63_o = n61_o + 9'b000000001;
  /* ./video.vhd:86:57  */
  assign n65_o = n60_o ? 9'b111100101 : n63_o;
  /* ./video.vhd:91:70  */
  assign n66_o = smode_M2 & smode_M3;
  /* ./video.vhd:92:74  */
  assign n67_o = video_state_in[12:4];
  /* ./video.vhd:92:88  */
  assign n69_o = n67_o == 9'b100000101;
  /* ./video.vhd:95:99  */
  assign n70_o = video_state_in[12:4];
  /* ./video.vhd:95:113  */
  assign n72_o = n70_o + 9'b000000001;
  /* ./video.vhd:92:57  */
  assign n74_o = n69_o ? 9'b000000000 : n72_o;
  /* ./video.vhd:98:74  */
  assign n75_o = video_state_in[12:4];
  /* ./video.vhd:98:88  */
  assign n77_o = n75_o == 9'b011011010;
  /* ./video.vhd:101:99  */
  assign n78_o = video_state_in[12:4];
  /* ./video.vhd:101:113  */
  assign n80_o = n78_o + 9'b000000001;
  /* ./video.vhd:98:57  */
  assign n82_o = n77_o ? 9'b111010101 : n80_o;
  /* ./video.vhd:91:49  */
  assign n83_o = n66_o ? n74_o : n82_o;
  /* ./video.vhd:85:49  */
  assign n84_o = n57_o ? n65_o : n83_o;
  /* ./video.vhd:64:41  */
  assign n85_o = pal ? n56_o : n84_o;
  /* ./video.vhd:106:75  */
  assign n86_o = video_state_in[12:4];
  /* ./video.vhd:62:33  */
  assign n87_o = n28_o ? n85_o : n86_o;
  /* ./video.vhd:110:43  */
  assign n89_o = hcount == 9'b111100101;
  /* ./video.vhd:112:67  */
  assign n90_o = smode_M2 & smode_M1;
  /* ./video.vhd:114:67  */
  assign n92_o = vcount == 9'b100000010;
  /* ./video.vhd:117:92  */
  assign n94_o = vcount + 9'b000000001;
  /* ./video.vhd:114:57  */
  assign n96_o = n92_o ? 9'b111001010 : n94_o;
  /* ./video.vhd:120:70  */
  assign n97_o = smode_M2 & smode_M3;
  /* ./video.vhd:122:67  */
  assign n99_o = vcount == 9'b100001010;
  /* ./video.vhd:125:92  */
  assign n101_o = vcount + 9'b000000001;
  /* ./video.vhd:122:57  */
  assign n103_o = n99_o ? 9'b111100010 : n101_o;
  /* ./video.vhd:130:67  */
  assign n105_o = vcount == 9'b011110010;
  /* ./video.vhd:133:92  */
  assign n107_o = vcount + 9'b000000001;
  /* ./video.vhd:130:57  */
  assign n109_o = n105_o ? 9'b110111010 : n107_o;
  /* ./video.vhd:120:49  */
  assign n110_o = n97_o ? n103_o : n109_o;
  /* ./video.vhd:112:49  */
  assign n111_o = n90_o ? n96_o : n110_o;
  /* ./video.vhd:138:67  */
  assign n112_o = smode_M2 & smode_M1;
  /* ./video.vhd:140:67  */
  assign n114_o = vcount == 9'b011101010;
  /* ./video.vhd:143:92  */
  assign n116_o = vcount + 9'b000000001;
  /* ./video.vhd:140:57  */
  assign n118_o = n114_o ? 9'b111100101 : n116_o;
  /* ./video.vhd:146:70  */
  assign n119_o = smode_M2 & smode_M3;
  /* ./video.vhd:148:67  */
  assign n121_o = vcount == 9'b100000101;
  /* ./video.vhd:151:92  */
  assign n123_o = vcount + 9'b000000001;
  /* ./video.vhd:148:57  */
  assign n125_o = n121_o ? 9'b000000000 : n123_o;
  /* ./video.vhd:156:67  */
  assign n127_o = vcount == 9'b011011010;
  /* ./video.vhd:159:92  */
  assign n129_o = vcount + 9'b000000001;
  /* ./video.vhd:156:57  */
  assign n131_o = n127_o ? 9'b111010101 : n129_o;
  /* ./video.vhd:146:49  */
  assign n132_o = n119_o ? n125_o : n131_o;
  /* ./video.vhd:138:49  */
  assign n133_o = n112_o ? n118_o : n132_o;
  /* ./video.vhd:111:41  */
  assign n134_o = pal ? n111_o : n133_o;
  /* ./video.vhd:108:25  */
  assign n135_o = n250_o ? n134_o : vcounter_cpu_reg;
  /* ./video.vhd:165:42  */
  assign n137_o = hcount == 9'b111100111;
  /* ./video.vhd:166:58  */
  assign n139_o = vcount + 9'b000000001;
  /* ./video.vhd:169:65  */
  assign n140_o = smode_M2 & smode_M1;
  /* ./video.vhd:170:67  */
  assign n142_o = vcount == 9'b100000010;
  /* ./video.vhd:172:70  */
  assign n144_o = vcount == 9'b111001101;
  /* ./video.vhd:174:70  */
  assign n146_o = vcount == 9'b111010000;
  /* ./video.vhd:174:57  */
  assign n148_o = n146_o ? 1'b0 : vsync_reg;
  /* ./video.vhd:172:57  */
  assign n150_o = n144_o ? 1'b1 : n148_o;
  /* ./video.vhd:170:57  */
  assign n152_o = n142_o ? 9'b111001010 : n139_o;
  /* ./video.vhd:170:57  */
  assign n153_o = n142_o ? vsync_reg : n150_o;
  /* ./video.vhd:177:68  */
  assign n154_o = smode_M2 & smode_M3;
  /* ./video.vhd:178:67  */
  assign n156_o = vcount == 9'b100001010;
  /* ./video.vhd:180:70  */
  assign n158_o = vcount == 9'b111100010;
  /* ./video.vhd:182:70  */
  assign n160_o = vcount == 9'b111100101;
  /* ./video.vhd:182:57  */
  assign n162_o = n160_o ? 1'b0 : vsync_reg;
  /* ./video.vhd:180:57  */
  assign n164_o = n158_o ? 1'b1 : n162_o;
  /* ./video.vhd:178:57  */
  assign n166_o = n156_o ? 9'b111100010 : n139_o;
  /* ./video.vhd:178:57  */
  assign n167_o = n156_o ? vsync_reg : n164_o;
  /* ./video.vhd:187:67  */
  assign n169_o = vcount == 9'b011110010;
  /* ./video.vhd:189:70  */
  assign n171_o = vcount == 9'b110111010;
  /* ./video.vhd:191:70  */
  assign n173_o = vcount == 9'b110111101;
  /* ./video.vhd:191:57  */
  assign n175_o = n173_o ? 1'b0 : vsync_reg;
  /* ./video.vhd:189:57  */
  assign n177_o = n171_o ? 1'b1 : n175_o;
  /* ./video.vhd:187:57  */
  assign n179_o = n169_o ? 9'b110111010 : n139_o;
  /* ./video.vhd:187:57  */
  assign n180_o = n169_o ? vsync_reg : n177_o;
  /* ./video.vhd:177:49  */
  assign n181_o = n154_o ? n166_o : n179_o;
  /* ./video.vhd:177:49  */
  assign n182_o = n154_o ? n167_o : n180_o;
  /* ./video.vhd:169:49  */
  assign n183_o = n140_o ? n152_o : n181_o;
  /* ./video.vhd:169:49  */
  assign n184_o = n140_o ? n153_o : n182_o;
  /* ./video.vhd:197:65  */
  assign n185_o = smode_M2 & smode_M1;
  /* ./video.vhd:198:67  */
  assign n187_o = vcount == 9'b011101010;
  /* ./video.vhd:200:70  */
  assign n189_o = vcount == 9'b111100111;
  /* ./video.vhd:202:70  */
  assign n191_o = vcount == 9'b111101010;
  /* ./video.vhd:202:57  */
  assign n193_o = n191_o ? 1'b0 : vsync_reg;
  /* ./video.vhd:200:57  */
  assign n195_o = n189_o ? 1'b1 : n193_o;
  /* ./video.vhd:198:57  */
  assign n197_o = n187_o ? 9'b111100101 : n139_o;
  /* ./video.vhd:198:57  */
  assign n198_o = n187_o ? vsync_reg : n195_o;
  /* ./video.vhd:206:60  */
  assign n199_o = smode_M2 & smode_M3;
  /* ./video.vhd:207:67  */
  assign n201_o = vcount == 9'b100000101;
  /* ./video.vhd:209:70  */
  assign n203_o = vcount == 9'b100000001;
  /* ./video.vhd:211:70  */
  assign n205_o = vcount == 9'b100000100;
  /* ./video.vhd:211:57  */
  assign n207_o = n205_o ? 1'b0 : vsync_reg;
  /* ./video.vhd:209:57  */
  assign n209_o = n203_o ? 1'b1 : n207_o;
  /* ./video.vhd:207:57  */
  assign n211_o = n201_o ? 9'b000000000 : n139_o;
  /* ./video.vhd:207:57  */
  assign n212_o = n201_o ? vsync_reg : n209_o;
  /* ./video.vhd:216:67  */
  assign n214_o = vcount == 9'b011011010;
  /* ./video.vhd:218:70  */
  assign n216_o = vcount == 9'b111010111;
  /* ./video.vhd:220:70  */
  assign n218_o = vcount == 9'b111011010;
  /* ./video.vhd:220:57  */
  assign n220_o = n218_o ? 1'b0 : vsync_reg;
  /* ./video.vhd:218:57  */
  assign n222_o = n216_o ? 1'b1 : n220_o;
  /* ./video.vhd:216:57  */
  assign n224_o = n214_o ? 9'b111010101 : n139_o;
  /* ./video.vhd:216:57  */
  assign n225_o = n214_o ? vsync_reg : n222_o;
  /* ./video.vhd:206:41  */
  assign n226_o = n199_o ? n211_o : n224_o;
  /* ./video.vhd:206:41  */
  assign n227_o = n199_o ? n212_o : n225_o;
  /* ./video.vhd:197:49  */
  assign n228_o = n185_o ? n197_o : n226_o;
  /* ./video.vhd:197:49  */
  assign n229_o = n185_o ? n198_o : n227_o;
  /* ./video.vhd:167:41  */
  assign n230_o = pal ? n183_o : n228_o;
  /* ./video.vhd:167:41  */
  assign n231_o = pal ? n184_o : n229_o;
  /* ./video.vhd:108:25  */
  assign n232_o = n249_o ? n230_o : vcount;
  /* ./video.vhd:108:25  */
  assign n233_o = n252_o ? n231_o : vsync_reg;
  /* ./video.vhd:227:50  */
  assign n235_o = hcount + 9'b000000001;
  /* ./video.vhd:229:43  */
  assign n237_o = hcount == 9'b100100111;
  /* ./video.vhd:229:33  */
  assign n239_o = n237_o ? 9'b111010010 : n235_o;
  /* ./video.vhd:232:43  */
  assign n241_o = hcount == 9'b100011000;
  /* ./video.vhd:234:46  */
  assign n243_o = hcount == 9'b111011010;
  /* ./video.vhd:234:33  */
  assign n245_o = n243_o ? 1'b0 : hsync_reg;
  /* ./video.vhd:232:33  */
  assign n247_o = n241_o ? 1'b1 : n245_o;
  /* ./video.vhd:108:25  */
  assign n248_o = ce_pix ? n239_o : hcount;
  /* ./video.vhd:108:25  */
  assign n249_o = n137_o & ce_pix;
  /* ./video.vhd:108:25  */
  assign n250_o = n89_o & ce_pix;
  /* ./video.vhd:108:25  */
  assign n251_o = ce_pix ? n247_o : hsync_reg;
  /* ./video.vhd:108:25  */
  assign n252_o = n137_o & ce_pix;
  /* ./video.vhd:55:25  */
  assign n253_o = video_state_set ? n18_o : n248_o;
  /* ./video.vhd:55:25  */
  assign n254_o = video_state_set ? n19_o : n232_o;
  /* ./video.vhd:55:25  */
  assign n255_o = video_state_set ? n87_o : n135_o;
  /* ./video.vhd:55:25  */
  assign n256_o = video_state_set ? n20_o : n251_o;
  /* ./video.vhd:55:25  */
  assign n257_o = video_state_set ? n21_o : n233_o;
  /* ./video.vhd:243:41  */
  assign n264_o = vcounter_cpu_reg[7:0];
  /* ./video.vhd:249:35  */
  assign n265_o = {hcount, vcount};
  /* ./video.vhd:249:44  */
  assign n266_o = {n265_o, hsync_reg};
  /* ./video.vhd:249:56  */
  assign n267_o = {n266_o, vsync_reg};
  /* ./video.vhd:249:68  */
  assign n268_o = {n267_o, hblank_reg};
  /* ./video.vhd:249:81  */
  assign n269_o = {n268_o, vblank_reg};
  /* ./video.vhd:251:84  */
  assign n271_o = smode_M2 & smode_M1;
  /* ./video.vhd:251:101  */
  assign n272_o = ggres & n271_o;
  /* ./video.vhd:251:65  */
  assign n273_o = n272_o ? 9'b010111000 : n276_o;
  /* ./video.vhd:252:80  */
  assign n275_o = smode_M2 & smode_M1;
  /* ./video.vhd:252:25  */
  assign n276_o = n275_o ? 9'b011100000 : n279_o;
  /* ./video.vhd:253:80  */
  assign n278_o = smode_M2 & smode_M3;
  /* ./video.vhd:253:25  */
  assign n279_o = n278_o ? 9'b011110000 : n283_o;
  /* ./video.vhd:254:85  */
  assign n281_o = ~pal;
  /* ./video.vhd:254:77  */
  assign n282_o = n281_o & border;
  /* ./video.vhd:254:25  */
  assign n283_o = n282_o ? 9'b011011000 : n285_o;
  /* ./video.vhd:255:25  */
  assign n285_o = border ? 9'b011110000 : n288_o;
  /* ./video.vhd:256:70  */
  assign n287_o = ~ggres;
  /* ./video.vhd:256:25  */
  assign n288_o = n287_o ? 9'b011000000 : 9'b010101000;
  /* ./video.vhd:259:68  */
  assign n291_o = ggres & smode_M1;
  /* ./video.vhd:259:49  */
  assign n292_o = n291_o ? 9'b000101000 : n301_o;
  /* ./video.vhd:260:80  */
  assign n294_o = smode_M2 & smode_M1;
  /* ./video.vhd:260:119  */
  assign n295_o = smode_M2 & smode_M3;
  /* ./video.vhd:260:100  */
  assign n296_o = n294_o | n295_o;
  /* ./video.vhd:260:150  */
  assign n297_o = ~border;
  /* ./video.vhd:260:166  */
  assign n298_o = ~ggres;
  /* ./video.vhd:260:156  */
  assign n299_o = n298_o & n297_o;
  /* ./video.vhd:260:139  */
  assign n300_o = n296_o | n299_o;
  /* ./video.vhd:260:25  */
  assign n301_o = n300_o ? 9'b000000000 : n305_o;
  /* ./video.vhd:261:85  */
  assign n303_o = ~pal;
  /* ./video.vhd:261:77  */
  assign n304_o = n303_o & border;
  /* ./video.vhd:261:25  */
  assign n305_o = n304_o ? 9'b111101000 : n307_o;
  /* ./video.vhd:262:25  */
  assign n307_o = border ? 9'b111001010 : 9'b000011000;
  /* ./video.vhd:265:77  */
  assign n310_o = ~ggres;
  /* ./video.vhd:265:67  */
  assign n311_o = n310_o & border;
  /* ./video.vhd:265:49  */
  assign n312_o = n311_o ? 9'b100001110 : n316_o;
  /* ./video.vhd:266:72  */
  assign n314_o = border ^ ggres;
  /* ./video.vhd:266:83  */
  assign n315_o = ~n314_o;
  /* ./video.vhd:266:25  */
  assign n316_o = n315_o ? 9'b100000000 : 9'b011010000;
  /* ./video.vhd:269:77  */
  assign n319_o = ~ggres;
  /* ./video.vhd:269:67  */
  assign n320_o = n319_o & border;
  /* ./video.vhd:269:49  */
  assign n321_o = n320_o ? 9'b111110100 : n327_o;
  /* ./video.vhd:270:72  */
  assign n323_o = border ^ ggres;
  /* ./video.vhd:270:83  */
  assign n324_o = ~n323_o;
  /* ./video.vhd:270:89  */
  assign n325_o = mask_column & n324_o;
  /* ./video.vhd:270:111  */
  assign n326_o = cut_mask & n325_o;
  /* ./video.vhd:270:25  */
  assign n327_o = n326_o ? 9'b000001000 : n331_o;
  /* ./video.vhd:271:72  */
  assign n329_o = border ^ ggres;
  /* ./video.vhd:271:83  */
  assign n330_o = ~n329_o;
  /* ./video.vhd:271:25  */
  assign n331_o = n330_o ? 9'b000000000 : 9'b000110000;
  /* ./video.vhd:278:61  */
  assign n336_o = video_state_in[1];
  /* ./video.vhd:279:61  */
  assign n337_o = video_state_in[0];
  /* ./video.vhd:281:43  */
  assign n338_o = hcount == hbl_end;
  /* ./video.vhd:283:46  */
  assign n339_o = hcount == hbl_st;
  /* ./video.vhd:283:33  */
  assign n341_o = n339_o ? 1'b1 : hblank_reg;
  /* ./video.vhd:281:33  */
  assign n343_o = n338_o ? 1'b0 : n341_o;
  /* ./video.vhd:287:43  */
  assign n344_o = vcount == vbl_end;
  /* ./video.vhd:289:46  */
  assign n345_o = vcount == vbl_st;
  /* ./video.vhd:289:33  */
  assign n347_o = n345_o ? 1'b1 : vblank_reg;
  /* ./video.vhd:287:33  */
  assign n349_o = n344_o ? 1'b0 : n347_o;
  /* ./video.vhd:280:25  */
  assign n350_o = ce_pix ? n343_o : hblank_reg;
  /* ./video.vhd:280:25  */
  assign n351_o = ce_pix ? n349_o : vblank_reg;
  /* ./video.vhd:277:25  */
  assign n352_o = video_state_set ? n336_o : n350_o;
  /* ./video.vhd:277:25  */
  assign n353_o = video_state_set ? n337_o : n351_o;
  /* ./video.vhd:54:17  */
  always @(posedge clk)
    n357_q <= n253_o;
  initial
    n357_q = 9'b000000000;
  /* ./video.vhd:54:17  */
  always @(posedge clk)
    n358_q <= n254_o;
  initial
    n358_q = 9'b000000000;
  /* ./video.vhd:54:17  */
  always @(posedge clk)
    n359_q <= n255_o;
  initial
    n359_q = 9'b000000000;
  /* ./video.vhd:54:17  */
  always @(posedge clk)
    n360_q <= n256_o;
  initial
    n360_q = 1'b0;
  /* ./video.vhd:54:17  */
  always @(posedge clk)
    n361_q <= n257_o;
  initial
    n361_q = 1'b0;
  /* ./video.vhd:276:17  */
  always @(posedge clk)
    n362_q <= n352_o;
  initial
    n362_q = 1'b0;
  /* ./video.vhd:276:17  */
  always @(posedge clk)
    n363_q <= n353_o;
  initial
    n363_q = 1'b0;
endmodule

