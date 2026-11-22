// [orphan] Orphan Games: the Sega Master System / Game Gear core for the S9 control board FPGA.
// This file is MACHINE-GENERATED Verilog: GHDL 4.1 synthesized it from the VHDL of the MiSTer SMS core
// (https://github.com/MiSTer-devel/SMS_MiSTer, GPL-2.0-or-later; patched copies in games/sms_vhdl,
// converter games/ghdl_convert.sh). Its licence follows the VHDL it was made from. See LICENSES.md here.
// GHDL escaped names (a backslash name such as u0 reg) were renamed for Yosys (*_esc). by JMSCNC, makers of RotatoCAM (the glue).
//
// The T80 Z80 CPU core notice (kept in synthesized form as its licence requires):
//
// Z80 compatible microprocessor core
//
// Version : 0247
// Copyright (c) 2001-2002 Daniel Wallner (jesus@opencores.org)
// All rights reserved
//
// Redistribution and use in source and synthezised forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// Redistributions in synthesized form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// Neither the name of the author nor the names of other contributors may
// be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

module t80_reg
  (input  clk,
   input  cen,
   input  weh,
   input  wel,
   input  [2:0] addra,
   input  [2:0] addrb,
   input  [2:0] addrc,
   input  [7:0] dih,
   input  [7:0] dil,
   input  dirset,
   input  [127:0] dir,
   output [7:0] doah,
   output [7:0] doal,
   output [7:0] dobh,
   output [7:0] dobl,
   output [7:0] doch,
   output [7:0] docl,
   output [127:0] dor);
  wire [63:0] regsh;
  wire [63:0] regsl;
  wire [7:0] n7719_o;
  wire [7:0] n7720_o;
  wire [7:0] n7721_o;
  wire [7:0] n7722_o;
  wire [7:0] n7723_o;
  wire [7:0] n7724_o;
  wire [7:0] n7725_o;
  wire [7:0] n7726_o;
  wire [7:0] n7727_o;
  wire [7:0] n7728_o;
  wire [7:0] n7729_o;
  wire [7:0] n7730_o;
  wire [7:0] n7731_o;
  wire [7:0] n7732_o;
  wire [7:0] n7733_o;
  wire [7:0] n7734_o;
  wire [2:0] n7737_o;
  wire [63:0] n7740_o;
  wire [2:0] n7743_o;
  wire [63:0] n7746_o;
  wire n7747_o;
  wire n7748_o;
  wire [63:0] n7749_o;
  wire [63:0] n7750_o;
  wire [63:0] n7751_o;
  wire [63:0] n7752_o;
  wire [2:0] n7758_o;
  wire [2:0] n7763_o;
  wire [2:0] n7768_o;
  wire [2:0] n7773_o;
  wire [2:0] n7778_o;
  wire [2:0] n7783_o;
  wire [7:0] n7786_o;
  wire [7:0] n7787_o;
  wire [15:0] n7788_o;
  wire [7:0] n7789_o;
  wire [23:0] n7790_o;
  wire [7:0] n7791_o;
  wire [31:0] n7792_o;
  wire [7:0] n7793_o;
  wire [39:0] n7794_o;
  wire [7:0] n7795_o;
  wire [47:0] n7796_o;
  wire [7:0] n7797_o;
  wire [55:0] n7798_o;
  wire [7:0] n7799_o;
  wire [63:0] n7800_o;
  wire [7:0] n7801_o;
  wire [71:0] n7802_o;
  wire [7:0] n7803_o;
  wire [79:0] n7804_o;
  wire [7:0] n7805_o;
  wire [87:0] n7806_o;
  wire [7:0] n7807_o;
  wire [95:0] n7808_o;
  wire [7:0] n7809_o;
  wire [103:0] n7810_o;
  wire [7:0] n7811_o;
  wire [111:0] n7812_o;
  wire [7:0] n7813_o;
  wire [119:0] n7814_o;
  wire [7:0] n7815_o;
  wire [127:0] n7816_o;
  reg [63:0] n7817_q;
  reg [63:0] n7818_q;
  wire n7819_o;
  wire n7820_o;
  wire n7821_o;
  wire n7822_o;
  wire n7823_o;
  wire n7824_o;
  wire n7825_o;
  wire n7826_o;
  wire n7827_o;
  wire n7828_o;
  wire n7829_o;
  wire n7830_o;
  wire n7831_o;
  wire n7832_o;
  wire n7833_o;
  wire n7834_o;
  wire n7835_o;
  wire n7836_o;
  wire [7:0] n7837_o;
  wire [7:0] n7838_o;
  wire [7:0] n7839_o;
  wire [7:0] n7840_o;
  wire [7:0] n7841_o;
  wire [7:0] n7842_o;
  wire [7:0] n7843_o;
  wire [7:0] n7844_o;
  wire [7:0] n7845_o;
  wire [7:0] n7846_o;
  wire [7:0] n7847_o;
  wire [7:0] n7848_o;
  wire [7:0] n7849_o;
  wire [7:0] n7850_o;
  wire [7:0] n7851_o;
  wire [7:0] n7852_o;
  wire [63:0] n7853_o;
  wire n7854_o;
  wire n7855_o;
  wire n7856_o;
  wire n7857_o;
  wire n7858_o;
  wire n7859_o;
  wire n7860_o;
  wire n7861_o;
  wire n7862_o;
  wire n7863_o;
  wire n7864_o;
  wire n7865_o;
  wire n7866_o;
  wire n7867_o;
  wire n7868_o;
  wire n7869_o;
  wire n7870_o;
  wire n7871_o;
  wire [7:0] n7872_o;
  wire [7:0] n7873_o;
  wire [7:0] n7874_o;
  wire [7:0] n7875_o;
  wire [7:0] n7876_o;
  wire [7:0] n7877_o;
  wire [7:0] n7878_o;
  wire [7:0] n7879_o;
  wire [7:0] n7880_o;
  wire [7:0] n7881_o;
  wire [7:0] n7882_o;
  wire [7:0] n7883_o;
  wire [7:0] n7884_o;
  wire [7:0] n7885_o;
  wire [7:0] n7886_o;
  wire [7:0] n7887_o;
  wire [63:0] n7888_o;
  wire [7:0] n7889_o;
  wire [7:0] n7890_o;
  wire [7:0] n7891_o;
  wire [7:0] n7892_o;
  wire [7:0] n7893_o;
  wire [7:0] n7894_o;
  wire [7:0] n7895_o;
  wire [7:0] n7896_o;
  wire [1:0] n7897_o;
  reg [7:0] n7898_o;
  wire [1:0] n7899_o;
  reg [7:0] n7900_o;
  wire n7901_o;
  wire [7:0] n7902_o;
  wire [7:0] n7903_o;
  wire [7:0] n7904_o;
  wire [7:0] n7905_o;
  wire [7:0] n7906_o;
  wire [7:0] n7907_o;
  wire [7:0] n7908_o;
  wire [7:0] n7909_o;
  wire [7:0] n7910_o;
  wire [1:0] n7911_o;
  reg [7:0] n7912_o;
  wire [1:0] n7913_o;
  reg [7:0] n7914_o;
  wire n7915_o;
  wire [7:0] n7916_o;
  wire [7:0] n7917_o;
  wire [7:0] n7918_o;
  wire [7:0] n7919_o;
  wire [7:0] n7920_o;
  wire [7:0] n7921_o;
  wire [7:0] n7922_o;
  wire [7:0] n7923_o;
  wire [7:0] n7924_o;
  wire [1:0] n7925_o;
  reg [7:0] n7926_o;
  wire [1:0] n7927_o;
  reg [7:0] n7928_o;
  wire n7929_o;
  wire [7:0] n7930_o;
  wire [7:0] n7931_o;
  wire [7:0] n7932_o;
  wire [7:0] n7933_o;
  wire [7:0] n7934_o;
  wire [7:0] n7935_o;
  wire [7:0] n7936_o;
  wire [7:0] n7937_o;
  wire [7:0] n7938_o;
  wire [1:0] n7939_o;
  reg [7:0] n7940_o;
  wire [1:0] n7941_o;
  reg [7:0] n7942_o;
  wire n7943_o;
  wire [7:0] n7944_o;
  wire [7:0] n7945_o;
  wire [7:0] n7946_o;
  wire [7:0] n7947_o;
  wire [7:0] n7948_o;
  wire [7:0] n7949_o;
  wire [7:0] n7950_o;
  wire [7:0] n7951_o;
  wire [7:0] n7952_o;
  wire [1:0] n7953_o;
  reg [7:0] n7954_o;
  wire [1:0] n7955_o;
  reg [7:0] n7956_o;
  wire n7957_o;
  wire [7:0] n7958_o;
  wire [7:0] n7959_o;
  wire [7:0] n7960_o;
  wire [7:0] n7961_o;
  wire [7:0] n7962_o;
  wire [7:0] n7963_o;
  wire [7:0] n7964_o;
  wire [7:0] n7965_o;
  wire [7:0] n7966_o;
  wire [1:0] n7967_o;
  reg [7:0] n7968_o;
  wire [1:0] n7969_o;
  reg [7:0] n7970_o;
  wire n7971_o;
  wire [7:0] n7972_o;
  assign doah = n7902_o;
  assign doal = n7916_o;
  assign dobh = n7930_o;
  assign dobl = n7944_o;
  assign doch = n7958_o;
  assign docl = n7972_o;
  assign dor = n7816_o;
  /* ./T80/T80_Reg.vhd:101:16  */
  assign regsh = n7817_q; // (signal)
  /* ./T80/T80_Reg.vhd:102:16  */
  assign regsl = n7818_q; // (signal)
  /* ./T80/T80_Reg.vhd:110:48  */
  assign n7719_o = dir[7:0];
  /* ./T80/T80_Reg.vhd:111:48  */
  assign n7720_o = dir[15:8];
  /* ./T80/T80_Reg.vhd:113:48  */
  assign n7721_o = dir[23:16];
  /* ./T80/T80_Reg.vhd:114:48  */
  assign n7722_o = dir[31:24];
  /* ./T80/T80_Reg.vhd:116:48  */
  assign n7723_o = dir[39:32];
  /* ./T80/T80_Reg.vhd:117:48  */
  assign n7724_o = dir[47:40];
  /* ./T80/T80_Reg.vhd:119:48  */
  assign n7725_o = dir[55:48];
  /* ./T80/T80_Reg.vhd:120:48  */
  assign n7726_o = dir[63:56];
  /* ./T80/T80_Reg.vhd:122:48  */
  assign n7727_o = dir[71:64];
  /* ./T80/T80_Reg.vhd:123:48  */
  assign n7728_o = dir[79:72];
  /* ./T80/T80_Reg.vhd:125:48  */
  assign n7729_o = dir[87:80];
  /* ./T80/T80_Reg.vhd:126:48  */
  assign n7730_o = dir[95:88];
  /* ./T80/T80_Reg.vhd:128:48  */
  assign n7731_o = dir[103:96];
  /* ./T80/T80_Reg.vhd:129:48  */
  assign n7732_o = dir[111:104];
  /* ./T80/T80_Reg.vhd:131:48  */
  assign n7733_o = dir[119:112];
  /* ./T80/T80_Reg.vhd:132:48  */
  assign n7734_o = dir[127:120];
  /* ./T80/T80_Reg.vhd:135:47  */
  assign n7737_o = 3'b111 - addra;
  /* ./T80/T80_Reg.vhd:133:25  */
  assign n7740_o = n7747_o ? n7853_o : regsh;
  /* ./T80/T80_Reg.vhd:138:47  */
  assign n7743_o = 3'b111 - addra;
  /* ./T80/T80_Reg.vhd:133:25  */
  assign n7746_o = n7748_o ? n7888_o : regsl;
  /* ./T80/T80_Reg.vhd:133:25  */
  assign n7747_o = weh & cen;
  /* ./T80/T80_Reg.vhd:133:25  */
  assign n7748_o = wel & cen;
  assign n7749_o = {n7720_o, n7722_o, n7724_o, n7726_o, n7728_o, n7730_o, n7732_o, n7734_o};
  /* ./T80/T80_Reg.vhd:109:25  */
  assign n7750_o = dirset ? n7749_o : n7740_o;
  /* ./T80/T80_ALU.vhd:112:26  */
  assign n7751_o = {n7719_o, n7721_o, n7723_o, n7725_o, n7727_o, n7729_o, n7731_o, n7733_o};
  /* ./T80/T80_Reg.vhd:109:25  */
  assign n7752_o = dirset ? n7751_o : n7746_o;
  /* ./T80/T80_Reg.vhd:144:23  */
  assign n7758_o = 3'b111 - addra;
  /* ./T80/T80_Reg.vhd:145:23  */
  assign n7763_o = 3'b111 - addra;
  /* ./T80/T80_Reg.vhd:146:23  */
  assign n7768_o = 3'b111 - addrb;
  /* ./T80/T80_Reg.vhd:147:23  */
  assign n7773_o = 3'b111 - addrb;
  /* ./T80/T80_Reg.vhd:148:23  */
  assign n7778_o = 3'b111 - addrc;
  /* ./T80/T80_Reg.vhd:149:23  */
  assign n7783_o = 3'b111 - addrc;
  /* ./T80/T80_Reg.vhd:150:22  */
  assign n7786_o = regsh[7:0];
  /* ./T80/T80_Reg.vhd:150:33  */
  assign n7787_o = regsl[7:0];
  /* ./T80/T80_Reg.vhd:150:26  */
  assign n7788_o = {n7786_o, n7787_o};
  /* ./T80/T80_Reg.vhd:150:44  */
  assign n7789_o = regsh[15:8];
  /* ./T80/T80_Reg.vhd:150:37  */
  assign n7790_o = {n7788_o, n7789_o};
  /* ./T80/T80_Reg.vhd:150:55  */
  assign n7791_o = regsl[15:8];
  /* ./T80/T80_Reg.vhd:150:48  */
  assign n7792_o = {n7790_o, n7791_o};
  /* ./T80/T80_Reg.vhd:150:66  */
  assign n7793_o = regsh[23:16];
  /* ./T80/T80_Reg.vhd:150:59  */
  assign n7794_o = {n7792_o, n7793_o};
  /* ./T80/T80_Reg.vhd:150:77  */
  assign n7795_o = regsl[23:16];
  /* ./T80/T80_Reg.vhd:150:70  */
  assign n7796_o = {n7794_o, n7795_o};
  /* ./T80/T80_Reg.vhd:150:88  */
  assign n7797_o = regsh[31:24];
  /* ./T80/T80_Reg.vhd:150:81  */
  assign n7798_o = {n7796_o, n7797_o};
  /* ./T80/T80_Reg.vhd:150:99  */
  assign n7799_o = regsl[31:24];
  /* ./T80/T80_Reg.vhd:150:92  */
  assign n7800_o = {n7798_o, n7799_o};
  /* ./T80/T80_Reg.vhd:150:110  */
  assign n7801_o = regsh[39:32];
  /* ./T80/T80_Reg.vhd:150:103  */
  assign n7802_o = {n7800_o, n7801_o};
  /* ./T80/T80_Reg.vhd:150:121  */
  assign n7803_o = regsl[39:32];
  /* ./T80/T80_Reg.vhd:150:114  */
  assign n7804_o = {n7802_o, n7803_o};
  /* ./T80/T80_Reg.vhd:150:132  */
  assign n7805_o = regsh[47:40];
  /* ./T80/T80_Reg.vhd:150:125  */
  assign n7806_o = {n7804_o, n7805_o};
  /* ./T80/T80_Reg.vhd:150:143  */
  assign n7807_o = regsl[47:40];
  /* ./T80/T80_Reg.vhd:150:136  */
  assign n7808_o = {n7806_o, n7807_o};
  /* ./T80/T80_Reg.vhd:150:154  */
  assign n7809_o = regsh[55:48];
  /* ./T80/T80_Reg.vhd:150:147  */
  assign n7810_o = {n7808_o, n7809_o};
  /* ./T80/T80_Reg.vhd:150:165  */
  assign n7811_o = regsl[55:48];
  /* ./T80/T80_Reg.vhd:150:158  */
  assign n7812_o = {n7810_o, n7811_o};
  /* ./T80/T80_Reg.vhd:150:176  */
  assign n7813_o = regsh[63:56];
  /* ./T80/T80_Reg.vhd:150:169  */
  assign n7814_o = {n7812_o, n7813_o};
  /* ./T80/T80_Reg.vhd:150:187  */
  assign n7815_o = regsl[63:56];
  /* ./T80/T80_Reg.vhd:150:180  */
  assign n7816_o = {n7814_o, n7815_o};
  /* ./T80/T80_Reg.vhd:108:17  */
  always @(posedge clk)
    n7817_q <= n7750_o;
  /* ./T80/T80_Reg.vhd:108:17  */
  always @(posedge clk)
    n7818_q <= n7752_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7819_o = n7737_o[2];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7820_o = ~n7819_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7821_o = n7737_o[1];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7822_o = ~n7821_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7823_o = n7820_o & n7822_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7824_o = n7820_o & n7821_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7825_o = n7819_o & n7822_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7826_o = n7819_o & n7821_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7827_o = n7737_o[0];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7828_o = ~n7827_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7829_o = n7823_o & n7828_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7830_o = n7823_o & n7827_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7831_o = n7824_o & n7828_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7832_o = n7824_o & n7827_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7833_o = n7825_o & n7828_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7834_o = n7825_o & n7827_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7835_o = n7826_o & n7828_o;
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7836_o = n7826_o & n7827_o;
  assign n7837_o = regsh[7:0];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7838_o = n7829_o ? dih : n7837_o;
  assign n7839_o = regsh[15:8];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7840_o = n7830_o ? dih : n7839_o;
  assign n7841_o = regsh[23:16];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7842_o = n7831_o ? dih : n7841_o;
  assign n7843_o = regsh[31:24];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7844_o = n7832_o ? dih : n7843_o;
  assign n7845_o = regsh[39:32];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7846_o = n7833_o ? dih : n7845_o;
  assign n7847_o = regsh[47:40];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7848_o = n7834_o ? dih : n7847_o;
  assign n7849_o = regsh[55:48];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7850_o = n7835_o ? dih : n7849_o;
  assign n7851_o = regsh[63:56];
  /* ./T80/T80_Reg.vhd:135:41  */
  assign n7852_o = n7836_o ? dih : n7851_o;
  assign n7853_o = {n7852_o, n7850_o, n7848_o, n7846_o, n7844_o, n7842_o, n7840_o, n7838_o};
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7854_o = n7743_o[2];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7855_o = ~n7854_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7856_o = n7743_o[1];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7857_o = ~n7856_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7858_o = n7855_o & n7857_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7859_o = n7855_o & n7856_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7860_o = n7854_o & n7857_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7861_o = n7854_o & n7856_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7862_o = n7743_o[0];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7863_o = ~n7862_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7864_o = n7858_o & n7863_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7865_o = n7858_o & n7862_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7866_o = n7859_o & n7863_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7867_o = n7859_o & n7862_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7868_o = n7860_o & n7863_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7869_o = n7860_o & n7862_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7870_o = n7861_o & n7863_o;
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7871_o = n7861_o & n7862_o;
  assign n7872_o = regsl[7:0];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7873_o = n7864_o ? dil : n7872_o;
  assign n7874_o = regsl[15:8];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7875_o = n7865_o ? dil : n7874_o;
  assign n7876_o = regsl[23:16];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7877_o = n7866_o ? dil : n7876_o;
  assign n7878_o = regsl[31:24];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7879_o = n7867_o ? dil : n7878_o;
  assign n7880_o = regsl[39:32];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7881_o = n7868_o ? dil : n7880_o;
  assign n7882_o = regsl[47:40];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7883_o = n7869_o ? dil : n7882_o;
  assign n7884_o = regsl[55:48];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7885_o = n7870_o ? dil : n7884_o;
  assign n7886_o = regsl[63:56];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7887_o = n7871_o ? dil : n7886_o;
  assign n7888_o = {n7887_o, n7885_o, n7883_o, n7881_o, n7879_o, n7877_o, n7875_o, n7873_o};
  /* ./T80/T80_Reg.vhd:138:47  */
  assign n7889_o = regsh[7:0];
  /* ./T80/T80_Reg.vhd:138:41  */
  assign n7890_o = regsh[15:8];
  assign n7891_o = regsh[23:16];
  assign n7892_o = regsh[31:24];
  assign n7893_o = regsh[39:32];
  assign n7894_o = regsh[47:40];
  assign n7895_o = regsh[55:48];
  assign n7896_o = regsh[63:56];
  /* ./T80/T80_Reg.vhd:144:22  */
  assign n7897_o = n7758_o[1:0];
  /* ./T80/T80_Reg.vhd:144:22  */
  always @*
    case (n7897_o)
      2'b00: n7898_o = n7889_o;
      2'b01: n7898_o = n7890_o;
      2'b10: n7898_o = n7891_o;
      2'b11: n7898_o = n7892_o;
    endcase
  /* ./T80/T80_Reg.vhd:144:22  */
  assign n7899_o = n7758_o[1:0];
  /* ./T80/T80_Reg.vhd:144:22  */
  always @*
    case (n7899_o)
      2'b00: n7900_o = n7893_o;
      2'b01: n7900_o = n7894_o;
      2'b10: n7900_o = n7895_o;
      2'b11: n7900_o = n7896_o;
    endcase
  /* ./T80/T80_Reg.vhd:144:22  */
  assign n7901_o = n7758_o[2];
  /* ./T80/T80_Reg.vhd:144:22  */
  assign n7902_o = n7901_o ? n7900_o : n7898_o;
  /* ./T80/T80_Reg.vhd:144:22  */
  assign n7903_o = regsl[7:0];
  /* ./T80/T80_Reg.vhd:144:23  */
  assign n7904_o = regsl[15:8];
  assign n7905_o = regsl[23:16];
  assign n7906_o = regsl[31:24];
  assign n7907_o = regsl[39:32];
  assign n7908_o = regsl[47:40];
  assign n7909_o = regsl[55:48];
  assign n7910_o = regsl[63:56];
  /* ./T80/T80_Reg.vhd:145:22  */
  assign n7911_o = n7763_o[1:0];
  /* ./T80/T80_Reg.vhd:145:22  */
  always @*
    case (n7911_o)
      2'b00: n7912_o = n7903_o;
      2'b01: n7912_o = n7904_o;
      2'b10: n7912_o = n7905_o;
      2'b11: n7912_o = n7906_o;
    endcase
  /* ./T80/T80_Reg.vhd:145:22  */
  assign n7913_o = n7763_o[1:0];
  /* ./T80/T80_Reg.vhd:145:22  */
  always @*
    case (n7913_o)
      2'b00: n7914_o = n7907_o;
      2'b01: n7914_o = n7908_o;
      2'b10: n7914_o = n7909_o;
      2'b11: n7914_o = n7910_o;
    endcase
  /* ./T80/T80_Reg.vhd:145:22  */
  assign n7915_o = n7763_o[2];
  /* ./T80/T80_Reg.vhd:145:22  */
  assign n7916_o = n7915_o ? n7914_o : n7912_o;
  /* ./T80/T80_Reg.vhd:145:22  */
  assign n7917_o = regsh[7:0];
  /* ./T80/T80_Reg.vhd:145:23  */
  assign n7918_o = regsh[15:8];
  assign n7919_o = regsh[23:16];
  assign n7920_o = regsh[31:24];
  assign n7921_o = regsh[39:32];
  assign n7922_o = regsh[47:40];
  assign n7923_o = regsh[55:48];
  assign n7924_o = regsh[63:56];
  /* ./T80/T80_Reg.vhd:146:22  */
  assign n7925_o = n7768_o[1:0];
  /* ./T80/T80_Reg.vhd:146:22  */
  always @*
    case (n7925_o)
      2'b00: n7926_o = n7917_o;
      2'b01: n7926_o = n7918_o;
      2'b10: n7926_o = n7919_o;
      2'b11: n7926_o = n7920_o;
    endcase
  /* ./T80/T80_Reg.vhd:146:22  */
  assign n7927_o = n7768_o[1:0];
  /* ./T80/T80_Reg.vhd:146:22  */
  always @*
    case (n7927_o)
      2'b00: n7928_o = n7921_o;
      2'b01: n7928_o = n7922_o;
      2'b10: n7928_o = n7923_o;
      2'b11: n7928_o = n7924_o;
    endcase
  /* ./T80/T80_Reg.vhd:146:22  */
  assign n7929_o = n7768_o[2];
  /* ./T80/T80_Reg.vhd:146:22  */
  assign n7930_o = n7929_o ? n7928_o : n7926_o;
  /* ./T80/T80_Reg.vhd:146:22  */
  assign n7931_o = regsl[7:0];
  /* ./T80/T80_Reg.vhd:146:23  */
  assign n7932_o = regsl[15:8];
  assign n7933_o = regsl[23:16];
  assign n7934_o = regsl[31:24];
  assign n7935_o = regsl[39:32];
  assign n7936_o = regsl[47:40];
  assign n7937_o = regsl[55:48];
  assign n7938_o = regsl[63:56];
  /* ./T80/T80_Reg.vhd:147:22  */
  assign n7939_o = n7773_o[1:0];
  /* ./T80/T80_Reg.vhd:147:22  */
  always @*
    case (n7939_o)
      2'b00: n7940_o = n7931_o;
      2'b01: n7940_o = n7932_o;
      2'b10: n7940_o = n7933_o;
      2'b11: n7940_o = n7934_o;
    endcase
  /* ./T80/T80_Reg.vhd:147:22  */
  assign n7941_o = n7773_o[1:0];
  /* ./T80/T80_Reg.vhd:147:22  */
  always @*
    case (n7941_o)
      2'b00: n7942_o = n7935_o;
      2'b01: n7942_o = n7936_o;
      2'b10: n7942_o = n7937_o;
      2'b11: n7942_o = n7938_o;
    endcase
  /* ./T80/T80_Reg.vhd:147:22  */
  assign n7943_o = n7773_o[2];
  /* ./T80/T80_Reg.vhd:147:22  */
  assign n7944_o = n7943_o ? n7942_o : n7940_o;
  /* ./T80/T80_Reg.vhd:147:22  */
  assign n7945_o = regsh[7:0];
  /* ./T80/T80_Reg.vhd:147:23  */
  assign n7946_o = regsh[15:8];
  assign n7947_o = regsh[23:16];
  assign n7948_o = regsh[31:24];
  assign n7949_o = regsh[39:32];
  assign n7950_o = regsh[47:40];
  assign n7951_o = regsh[55:48];
  assign n7952_o = regsh[63:56];
  /* ./T80/T80_Reg.vhd:148:22  */
  assign n7953_o = n7778_o[1:0];
  /* ./T80/T80_Reg.vhd:148:22  */
  always @*
    case (n7953_o)
      2'b00: n7954_o = n7945_o;
      2'b01: n7954_o = n7946_o;
      2'b10: n7954_o = n7947_o;
      2'b11: n7954_o = n7948_o;
    endcase
  /* ./T80/T80_Reg.vhd:148:22  */
  assign n7955_o = n7778_o[1:0];
  /* ./T80/T80_Reg.vhd:148:22  */
  always @*
    case (n7955_o)
      2'b00: n7956_o = n7949_o;
      2'b01: n7956_o = n7950_o;
      2'b10: n7956_o = n7951_o;
      2'b11: n7956_o = n7952_o;
    endcase
  /* ./T80/T80_Reg.vhd:148:22  */
  assign n7957_o = n7778_o[2];
  /* ./T80/T80_Reg.vhd:148:22  */
  assign n7958_o = n7957_o ? n7956_o : n7954_o;
  /* ./T80/T80_Reg.vhd:148:22  */
  assign n7959_o = regsl[7:0];
  /* ./T80/T80_Reg.vhd:148:23  */
  assign n7960_o = regsl[15:8];
  assign n7961_o = regsl[23:16];
  assign n7962_o = regsl[31:24];
  assign n7963_o = regsl[39:32];
  assign n7964_o = regsl[47:40];
  assign n7965_o = regsl[55:48];
  assign n7966_o = regsl[63:56];
  /* ./T80/T80_Reg.vhd:149:22  */
  assign n7967_o = n7783_o[1:0];
  /* ./T80/T80_Reg.vhd:149:22  */
  always @*
    case (n7967_o)
      2'b00: n7968_o = n7959_o;
      2'b01: n7968_o = n7960_o;
      2'b10: n7968_o = n7961_o;
      2'b11: n7968_o = n7962_o;
    endcase
  /* ./T80/T80_Reg.vhd:149:22  */
  assign n7969_o = n7783_o[1:0];
  /* ./T80/T80_Reg.vhd:149:22  */
  always @*
    case (n7969_o)
      2'b00: n7970_o = n7963_o;
      2'b01: n7970_o = n7964_o;
      2'b10: n7970_o = n7965_o;
      2'b11: n7970_o = n7966_o;
    endcase
  /* ./T80/T80_Reg.vhd:149:22  */
  assign n7971_o = n7783_o[2];
  /* ./T80/T80_Reg.vhd:149:22  */
  assign n7972_o = n7971_o ? n7970_o : n7968_o;
endmodule

module t80_alu_0_0_1_2_3_4_5_6_7
  (input  arith16,
   input  z16,
   input  [15:0] wz,
   input  [1:0] xy_state,
   input  [3:0] alu_op,
   input  [5:0] ir,
   input  [1:0] iset,
   input  [7:0] busa,
   input  [7:0] busb,
   input  [7:0] f_in,
   output [7:0] q,
   output [7:0] f_out);
  wire usecarry;
  wire carry7_v;
  wire overflow_v;
  wire halfcarry_v;
  wire carry_v;
  wire [7:0] q_v;
  wire [7:0] bitmask;
  wire [2:0] n7131_o;
  wire n7134_o;
  wire n7137_o;
  wire n7140_o;
  wire n7143_o;
  wire n7146_o;
  wire n7149_o;
  wire n7152_o;
  wire [6:0] n7154_o;
  reg [7:0] n7155_o;
  wire n7156_o;
  wire n7157_o;
  wire n7158_o;
  wire n7159_o;
  wire [3:0] n7161_o;
  wire [3:0] n7162_o;
  wire n7163_o;
  wire n7164_o;
  wire n7165_o;
  wire n7166_o;
  wire n7167_o;
  wire [3:0] n7172_o;
  wire [3:0] n7173_o;
  wire [4:0] n7176_o;
  wire [5:0] n7177_o;
  wire [4:0] n7179_o;
  wire [5:0] n7181_o;
  wire [5:0] n7182_o;
  wire n7184_o;
  wire [3:0] n7185_o;
  wire [2:0] n7187_o;
  wire [2:0] n7188_o;
  wire n7189_o;
  wire [2:0] n7194_o;
  wire [2:0] n7195_o;
  wire [3:0] n7198_o;
  wire [4:0] n7199_o;
  wire [3:0] n7201_o;
  wire [4:0] n7203_o;
  wire [4:0] n7204_o;
  wire n7206_o;
  wire [2:0] n7207_o;
  wire n7209_o;
  wire n7210_o;
  wire n7211_o;
  wire n7216_o;
  wire n7217_o;
  wire [1:0] n7220_o;
  wire [2:0] n7221_o;
  wire [1:0] n7223_o;
  wire [2:0] n7225_o;
  wire [2:0] n7226_o;
  wire n7228_o;
  wire n7229_o;
  wire n7232_o;
  wire [2:0] n7240_o;
  wire n7242_o;
  wire n7244_o;
  wire n7245_o;
  wire n7247_o;
  wire n7248_o;
  wire n7250_o;
  wire n7252_o;
  wire n7253_o;
  wire n7255_o;
  wire n7256_o;
  wire [7:0] n7257_o;
  wire n7260_o;
  wire [7:0] n7261_o;
  wire n7264_o;
  wire [7:0] n7265_o;
  wire [3:0] n7267_o;
  reg n7268_o;
  reg n7269_o;
  wire n7270_o;
  reg n7271_o;
  reg n7272_o;
  reg [7:0] n7273_o;
  wire [2:0] n7274_o;
  wire n7276_o;
  wire n7277_o;
  wire n7278_o;
  wire n7279_o;
  wire n7280_o;
  wire n7281_o;
  wire n7282_o;
  wire n7284_o;
  wire n7286_o;
  wire n7287_o;
  wire n7289_o;
  wire n7290_o;
  wire [2:0] n7291_o;
  wire n7293_o;
  wire n7295_o;
  wire n7296_o;
  wire n7298_o;
  wire n7299_o;
  wire n7301_o;
  wire n7302_o;
  wire n7304_o;
  wire n7305_o;
  wire n7306_o;
  wire n7307_o;
  wire n7308_o;
  wire n7309_o;
  wire n7310_o;
  wire n7311_o;
  wire n7312_o;
  wire n7313_o;
  wire n7314_o;
  wire n7315_o;
  wire n7316_o;
  wire n7317_o;
  wire n7318_o;
  wire n7319_o;
  wire n7320_o;
  wire n7321_o;
  reg n7322_o;
  wire n7323_o;
  wire n7324_o;
  wire n7325_o;
  wire [1:0] n7326_o;
  wire n7327_o;
  wire [1:0] n7328_o;
  wire [1:0] n7329_o;
  wire n7331_o;
  wire n7333_o;
  wire n7334_o;
  wire n7336_o;
  wire n7337_o;
  wire n7339_o;
  wire n7340_o;
  wire n7342_o;
  wire n7343_o;
  wire n7345_o;
  wire n7346_o;
  wire n7348_o;
  wire n7349_o;
  wire n7351_o;
  wire n7352_o;
  wire n7353_o;
  wire n7356_o;
  wire n7357_o;
  wire [8:0] n7358_o;
  wire [3:0] n7359_o;
  wire n7361_o;
  wire n7362_o;
  wire n7363_o;
  wire [8:0] n7364_o;
  wire [3:0] n7365_o;
  wire n7367_o;
  wire n7370_o;
  wire [8:0] n7371_o;
  wire [8:0] n7373_o;
  wire n7374_o;
  wire [8:0] n7375_o;
  wire [8:0] n7376_o;
  wire [4:0] n7377_o;
  wire n7379_o;
  wire n7380_o;
  wire n7381_o;
  wire [8:0] n7383_o;
  wire [8:0] n7384_o;
  wire [8:0] n7385_o;
  wire [3:0] n7386_o;
  wire n7388_o;
  wire n7389_o;
  wire n7390_o;
  wire [8:0] n7391_o;
  wire [3:0] n7392_o;
  wire n7394_o;
  wire n7396_o;
  wire [8:0] n7397_o;
  wire [7:0] n7398_o;
  wire [7:0] n7400_o;
  wire n7401_o;
  wire [7:0] n7402_o;
  wire n7404_o;
  wire n7405_o;
  wire n7406_o;
  wire [8:0] n7407_o;
  wire [8:0] n7409_o;
  wire [8:0] n7410_o;
  wire [8:0] n7411_o;
  wire n7412_o;
  wire [8:0] n7413_o;
  wire n7414_o;
  wire n7415_o;
  wire n7416_o;
  wire n7417_o;
  wire n7418_o;
  wire [7:0] n7419_o;
  wire [7:0] n7420_o;
  wire n7422_o;
  wire n7425_o;
  wire n7426_o;
  wire n7427_o;
  wire n7428_o;
  wire n7429_o;
  wire n7430_o;
  wire n7431_o;
  wire n7432_o;
  wire n7433_o;
  wire n7434_o;
  wire n7435_o;
  wire n7436_o;
  wire n7437_o;
  wire n7438_o;
  wire n7439_o;
  wire n7440_o;
  wire n7441_o;
  wire n7442_o;
  wire n7444_o;
  wire [3:0] n7445_o;
  wire n7446_o;
  wire [3:0] n7447_o;
  wire [3:0] n7448_o;
  wire [3:0] n7449_o;
  wire [7:0] n7452_o;
  wire n7453_o;
  wire [7:0] n7454_o;
  wire n7455_o;
  wire [7:0] n7456_o;
  wire n7458_o;
  wire n7461_o;
  wire [7:0] n7462_o;
  wire n7463_o;
  wire [7:0] n7464_o;
  wire n7465_o;
  wire [7:0] n7466_o;
  wire n7467_o;
  wire n7468_o;
  wire [7:0] n7469_o;
  wire n7470_o;
  wire n7471_o;
  wire [7:0] n7472_o;
  wire n7473_o;
  wire n7474_o;
  wire [7:0] n7475_o;
  wire n7476_o;
  wire n7477_o;
  wire [7:0] n7478_o;
  wire n7479_o;
  wire n7480_o;
  wire [7:0] n7481_o;
  wire n7482_o;
  wire n7483_o;
  wire [7:0] n7484_o;
  wire n7485_o;
  wire n7486_o;
  wire n7487_o;
  wire n7489_o;
  wire n7491_o;
  wire n7492_o;
  wire [7:0] n7493_o;
  wire n7494_o;
  wire n7496_o;
  wire n7501_o;
  wire n7502_o;
  wire [2:0] n7505_o;
  wire n7507_o;
  wire n7509_o;
  wire n7510_o;
  wire n7511_o;
  wire n7512_o;
  wire n7513_o;
  wire n7514_o;
  wire n7515_o;
  wire n7516_o;
  wire n7518_o;
  wire [7:0] n7519_o;
  wire n7521_o;
  wire [7:0] n7522_o;
  wire [7:0] n7523_o;
  wire n7525_o;
  wire [2:0] n7526_o;
  wire [6:0] n7527_o;
  wire n7528_o;
  wire n7529_o;
  wire n7531_o;
  wire [6:0] n7532_o;
  wire n7533_o;
  wire n7534_o;
  wire n7536_o;
  wire [6:0] n7537_o;
  wire n7538_o;
  wire n7539_o;
  wire n7541_o;
  wire [6:0] n7542_o;
  wire n7543_o;
  wire n7544_o;
  wire n7546_o;
  wire [6:0] n7547_o;
  wire n7549_o;
  wire n7551_o;
  wire [6:0] n7552_o;
  wire n7554_o;
  wire n7556_o;
  wire [6:0] n7557_o;
  wire n7558_o;
  wire n7559_o;
  wire n7561_o;
  wire [6:0] n7562_o;
  wire n7564_o;
  wire [6:0] n7565_o;
  reg n7566_o;
  wire n7567_o;
  wire n7568_o;
  wire n7569_o;
  wire n7570_o;
  reg n7571_o;
  wire [5:0] n7572_o;
  wire [5:0] n7573_o;
  wire [5:0] n7574_o;
  wire [5:0] n7575_o;
  wire [5:0] n7576_o;
  wire [5:0] n7577_o;
  wire [5:0] n7578_o;
  wire [5:0] n7579_o;
  reg [5:0] n7580_o;
  wire n7581_o;
  wire n7582_o;
  wire n7583_o;
  wire n7584_o;
  reg n7585_o;
  wire [7:0] n7588_o;
  wire n7589_o;
  wire [7:0] n7590_o;
  wire n7591_o;
  wire [7:0] n7592_o;
  wire n7593_o;
  wire [7:0] n7594_o;
  wire n7596_o;
  wire n7599_o;
  wire [7:0] n7600_o;
  wire n7601_o;
  wire [7:0] n7602_o;
  wire n7603_o;
  wire n7604_o;
  wire [7:0] n7605_o;
  wire n7606_o;
  wire n7607_o;
  wire [7:0] n7608_o;
  wire n7609_o;
  wire n7610_o;
  wire [7:0] n7611_o;
  wire n7612_o;
  wire n7613_o;
  wire [7:0] n7614_o;
  wire n7615_o;
  wire n7616_o;
  wire [7:0] n7617_o;
  wire n7618_o;
  wire n7619_o;
  wire [7:0] n7620_o;
  wire n7621_o;
  wire n7622_o;
  wire n7623_o;
  wire n7625_o;
  wire n7626_o;
  wire n7627_o;
  wire n7628_o;
  wire [1:0] n7629_o;
  wire n7630_o;
  wire [1:0] n7631_o;
  wire [1:0] n7632_o;
  wire n7634_o;
  wire [6:0] n7635_o;
  wire n7636_o;
  reg n7637_o;
  wire n7638_o;
  reg n7639_o;
  wire n7640_o;
  reg n7641_o;
  wire n7642_o;
  reg n7643_o;
  wire n7644_o;
  reg n7645_o;
  wire n7646_o;
  reg n7647_o;
  wire n7648_o;
  wire n7649_o;
  wire n7650_o;
  reg n7651_o;
  wire n7652_o;
  wire n7653_o;
  wire n7654_o;
  reg n7655_o;
  wire n7663_o;
  wire n7664_o;
  wire n7665_o;
  wire n7666_o;
  wire n7667_o;
  wire n7668_o;
  reg n7670_o;
  wire [2:0] n7671_o;
  wire [2:0] n7672_o;
  wire [2:0] n7673_o;
  wire [2:0] n7674_o;
  wire [2:0] n7675_o;
  wire [2:0] n7676_o;
  wire [2:0] n7677_o;
  reg [2:0] n7679_o;
  wire [2:0] n7680_o;
  wire [2:0] n7681_o;
  wire [2:0] n7682_o;
  wire [2:0] n7683_o;
  wire [2:0] n7684_o;
  wire [2:0] n7685_o;
  wire [2:0] n7686_o;
  reg [2:0] n7688_o;
  wire n7689_o;
  wire n7690_o;
  wire n7691_o;
  wire n7692_o;
  wire n7693_o;
  wire n7694_o;
  reg n7696_o;
  wire [7:0] n7704_o;
  wire [7:0] n7707_o;
  wire [7:0] n7708_o;
  assign q = n7704_o;
  assign f_out = n7708_o;
  /* ./T80/T80_ALU.vhd:126:16  */
  assign usecarry = n7159_o; // (signal)
  /* ./T80/T80_ALU.vhd:127:16  */
  assign carry7_v = n7206_o; // (signal)
  /* ./T80/T80_ALU.vhd:128:16  */
  assign overflow_v = n7232_o; // (signal)
  /* ./T80/T80_ALU.vhd:129:16  */
  assign halfcarry_v = n7184_o; // (signal)
  /* ./T80/T80_ALU.vhd:130:16  */
  assign carry_v = n7228_o; // (signal)
  /* ./T80/T80_ALU.vhd:131:16  */
  assign q_v = n7707_o; // (signal)
  /* ./T80/T80_ALU.vhd:133:16  */
  assign bitmask = n7155_o; // (signal)
  /* ./T80/T80_ALU.vhd:137:16  */
  assign n7131_o = ir[5:3];
  /* ./T80/T80_ALU.vhd:137:58  */
  assign n7134_o = n7131_o == 3'b000;
  /* ./T80/T80_ALU.vhd:138:94  */
  assign n7137_o = n7131_o == 3'b001;
  /* ./T80/T80_ALU.vhd:139:94  */
  assign n7140_o = n7131_o == 3'b010;
  /* ./T80/T80_ALU.vhd:140:94  */
  assign n7143_o = n7131_o == 3'b011;
  /* ./T80/T80_ALU.vhd:141:94  */
  assign n7146_o = n7131_o == 3'b100;
  /* ./T80/T80_ALU.vhd:142:94  */
  assign n7149_o = n7131_o == 3'b101;
  /* ./T80/T80_ALU.vhd:143:94  */
  assign n7152_o = n7131_o == 3'b110;
  /* ./T80/T80_MCode.vhd:113:7  */
  assign n7154_o = {n7152_o, n7149_o, n7146_o, n7143_o, n7140_o, n7137_o, n7134_o};
  /* ./T80/T80_ALU.vhd:137:9  */
  always @*
    case (n7154_o)
      7'b1000000: n7155_o = 8'b01000000;
      7'b0100000: n7155_o = 8'b00100000;
      7'b0010000: n7155_o = 8'b00010000;
      7'b0001000: n7155_o = 8'b00001000;
      7'b0000100: n7155_o = 8'b00000100;
      7'b0000010: n7155_o = 8'b00000010;
      7'b0000001: n7155_o = 8'b00000001;
      default: n7155_o = 8'b10000000;
    endcase
  /* ./T80/T80_ALU.vhd:146:31  */
  assign n7156_o = alu_op[2];
  /* ./T80/T80_ALU.vhd:146:21  */
  assign n7157_o = ~n7156_o;
  /* ./T80/T80_ALU.vhd:146:45  */
  assign n7158_o = alu_op[0];
  /* ./T80/T80_ALU.vhd:146:35  */
  assign n7159_o = n7157_o & n7158_o;
  /* ./T80/T80_ALU.vhd:147:20  */
  assign n7161_o = busa[3:0];
  /* ./T80/T80_ALU.vhd:147:38  */
  assign n7162_o = busb[3:0];
  /* ./T80/T80_ALU.vhd:147:58  */
  assign n7163_o = alu_op[1];
  /* ./T80/T80_ALU.vhd:147:69  */
  assign n7164_o = alu_op[1];
  /* ./T80/T80_ALU.vhd:147:95  */
  assign n7165_o = f_in[0];
  /* ./T80/T80_ALU.vhd:147:87  */
  assign n7166_o = usecarry & n7165_o;
  /* ./T80/T80_ALU.vhd:147:73  */
  assign n7167_o = n7164_o ^ n7166_o;
  /* ./T80/T80_ALU.vhd:115:32  */
  assign n7172_o = ~n7162_o;
  /* ./T80/T80_ALU.vhd:114:17  */
  assign n7173_o = n7163_o ? n7172_o : n7162_o;
  /* ./T80/T80_ALU.vhd:120:39  */
  assign n7176_o = {1'b0, n7161_o};
  /* ./T80/T80_ALU.vhd:120:43  */
  assign n7177_o = {n7176_o, n7167_o};
  /* ./T80/T80_ALU.vhd:120:70  */
  assign n7179_o = {1'b0, n7173_o};
  /* ./T80/T80_ALU.vhd:120:76  */
  assign n7181_o = {n7179_o, 1'b1};
  /* ./T80/T80_ALU.vhd:120:55  */
  assign n7182_o = n7177_o + n7181_o;
  /* ./T80/T80_ALU.vhd:121:31  */
  assign n7184_o = n7182_o[5];
  /* ./T80/T80_ALU.vhd:122:46  */
  assign n7185_o = n7182_o[4:1];
  /* ./T80/T80_ALU.vhd:148:20  */
  assign n7187_o = busa[6:4];
  /* ./T80/T80_ALU.vhd:148:38  */
  assign n7188_o = busb[6:4];
  /* ./T80/T80_ALU.vhd:148:58  */
  assign n7189_o = alu_op[1];
  /* ./T80/T80_ALU.vhd:115:32  */
  assign n7194_o = ~n7188_o;
  /* ./T80/T80_ALU.vhd:114:17  */
  assign n7195_o = n7189_o ? n7194_o : n7188_o;
  /* ./T80/T80_ALU.vhd:120:39  */
  assign n7198_o = {1'b0, n7187_o};
  /* ./T80/T80_ALU.vhd:120:43  */
  assign n7199_o = {n7198_o, halfcarry_v};
  /* ./T80/T80_ALU.vhd:120:70  */
  assign n7201_o = {1'b0, n7195_o};
  /* ./T80/T80_ALU.vhd:120:76  */
  assign n7203_o = {n7201_o, 1'b1};
  /* ./T80/T80_ALU.vhd:120:55  */
  assign n7204_o = n7199_o + n7203_o;
  /* ./T80/T80_ALU.vhd:121:31  */
  assign n7206_o = n7204_o[4];
  /* ./T80/T80_ALU.vhd:122:46  */
  assign n7207_o = n7204_o[3:1];
  /* ./T80/T80_ALU.vhd:149:20  */
  assign n7209_o = busa[7];
  /* ./T80/T80_ALU.vhd:149:38  */
  assign n7210_o = busb[7];
  /* ./T80/T80_ALU.vhd:149:58  */
  assign n7211_o = alu_op[1];
  /* ./T80/T80_ALU.vhd:115:32  */
  assign n7216_o = ~n7210_o;
  /* ./T80/T80_ALU.vhd:114:17  */
  assign n7217_o = n7211_o ? n7216_o : n7210_o;
  /* ./T80/T80_ALU.vhd:120:39  */
  assign n7220_o = {1'b0, n7209_o};
  /* ./T80/T80_ALU.vhd:120:43  */
  assign n7221_o = {n7220_o, carry7_v};
  /* ./T80/T80_ALU.vhd:120:70  */
  assign n7223_o = {1'b0, n7217_o};
  /* ./T80/T80_ALU.vhd:120:76  */
  assign n7225_o = {n7223_o, 1'b1};
  /* ./T80/T80_ALU.vhd:120:55  */
  assign n7226_o = n7221_o + n7225_o;
  /* ./T80/T80_ALU.vhd:121:31  */
  assign n7228_o = n7226_o[2];
  /* ./T80/T80_ALU.vhd:122:46  */
  assign n7229_o = n7226_o[1];
  /* ./T80/T80_ALU.vhd:157:47  */
  assign n7232_o = carry_v ^ carry7_v;
  /* ./T80/T80_ALU.vhd:172:36  */
  assign n7240_o = alu_op[2:0];
  /* ./T80/T80_ALU.vhd:173:25  */
  assign n7242_o = n7240_o == 3'b000;
  /* ./T80/T80_ALU.vhd:173:36  */
  assign n7244_o = n7240_o == 3'b001;
  /* ./T80/T80_ALU.vhd:173:36  */
  assign n7245_o = n7242_o | n7244_o;
  /* ./T80/T80_ALU.vhd:181:50  */
  assign n7247_o = ~carry_v;
  /* ./T80/T80_ALU.vhd:182:50  */
  assign n7248_o = ~halfcarry_v;
  /* ./T80/T80_ALU.vhd:178:25  */
  assign n7250_o = n7240_o == 3'b010;
  /* ./T80/T80_ALU.vhd:178:36  */
  assign n7252_o = n7240_o == 3'b011;
  /* ./T80/T80_ALU.vhd:178:36  */
  assign n7253_o = n7250_o | n7252_o;
  /* ./T80/T80_ALU.vhd:178:44  */
  assign n7255_o = n7240_o == 3'b111;
  /* ./T80/T80_ALU.vhd:178:44  */
  assign n7256_o = n7253_o | n7255_o;
  /* ./T80/T80_ALU.vhd:185:57  */
  assign n7257_o = busa & busb;
  /* ./T80/T80_ALU.vhd:184:25  */
  assign n7260_o = n7240_o == 3'b100;
  /* ./T80/T80_ALU.vhd:188:57  */
  assign n7261_o = busa ^ busb;
  /* ./T80/T80_ALU.vhd:187:25  */
  assign n7264_o = n7240_o == 3'b101;
  /* ./T80/T80_ALU.vhd:191:57  */
  assign n7265_o = busa | busb;
  assign n7267_o = {n7264_o, n7260_o, n7256_o, n7245_o};
  /* ./T80/T80_ALU.vhd:172:25  */
  always @*
    case (n7267_o)
      4'b1000: n7268_o = 1'b0;
      4'b0100: n7268_o = 1'b0;
      4'b0010: n7268_o = n7247_o;
      4'b0001: n7268_o = carry_v;
      default: n7268_o = 1'b0;
    endcase
  /* ./T80/T80_ALU.vhd:172:25  */
  always @*
    case (n7267_o)
      4'b1000: n7269_o = 1'b0;
      4'b0100: n7269_o = 1'b0;
      4'b0010: n7269_o = 1'b1;
      4'b0001: n7269_o = 1'b0;
      default: n7269_o = 1'b0;
    endcase
  assign n7270_o = f_in[2];
  /* ./T80/T80_ALU.vhd:172:25  */
  always @*
    case (n7267_o)
      4'b1000: n7271_o = n7270_o;
      4'b0100: n7271_o = n7270_o;
      4'b0010: n7271_o = overflow_v;
      4'b0001: n7271_o = overflow_v;
      default: n7271_o = n7270_o;
    endcase
  /* ./T80/T80_ALU.vhd:172:25  */
  always @*
    case (n7267_o)
      4'b1000: n7272_o = 1'b0;
      4'b0100: n7272_o = 1'b1;
      4'b0010: n7272_o = n7248_o;
      4'b0001: n7272_o = halfcarry_v;
      default: n7272_o = 1'b0;
    endcase
  /* ./T80/T80_ALU.vhd:172:25  */
  always @*
    case (n7267_o)
      4'b1000: n7273_o = n7261_o;
      4'b0100: n7273_o = n7257_o;
      4'b0010: n7273_o = q_v;
      4'b0001: n7273_o = q_v;
      default: n7273_o = n7265_o;
    endcase
  /* ./T80/T80_ALU.vhd:194:34  */
  assign n7274_o = alu_op[2:0];
  /* ./T80/T80_ALU.vhd:194:47  */
  assign n7276_o = n7274_o == 3'b111;
  /* ./T80/T80_ALU.vhd:195:54  */
  assign n7277_o = busb[3];
  /* ./T80/T80_ALU.vhd:196:54  */
  assign n7278_o = busb[5];
  /* ./T80/T80_ALU.vhd:198:53  */
  assign n7279_o = n7273_o[3];
  /* ./T80/T80_ALU.vhd:199:53  */
  assign n7280_o = n7273_o[5];
  /* ./T80/T80_ALU.vhd:194:25  */
  assign n7281_o = n7276_o ? n7277_o : n7279_o;
  /* ./T80/T80_ALU.vhd:194:25  */
  assign n7282_o = n7276_o ? n7278_o : n7280_o;
  /* ./T80/T80_ALU.vhd:201:44  */
  assign n7284_o = n7273_o == 8'b00000000;
  /* ./T80/T80_ALU.vhd:204:62  */
  assign n7286_o = f_in[6];
  /* ./T80/T80_ALU.vhd:203:33  */
  assign n7287_o = z16 ? n7286_o : 1'b1;
  /* ./T80/T80_ALU.vhd:201:25  */
  assign n7289_o = n7284_o ? n7287_o : 1'b0;
  /* ./T80/T80_ALU.vhd:209:45  */
  assign n7290_o = n7273_o[7];
  /* ./T80/T80_ALU.vhd:210:36  */
  assign n7291_o = alu_op[2:0];
  /* ./T80/T80_ALU.vhd:211:25  */
  assign n7293_o = n7291_o == 3'b000;
  /* ./T80/T80_ALU.vhd:211:36  */
  assign n7295_o = n7291_o == 3'b001;
  /* ./T80/T80_ALU.vhd:211:36  */
  assign n7296_o = n7293_o | n7295_o;
  /* ./T80/T80_ALU.vhd:211:44  */
  assign n7298_o = n7291_o == 3'b010;
  /* ./T80/T80_ALU.vhd:211:44  */
  assign n7299_o = n7296_o | n7298_o;
  /* ./T80/T80_ALU.vhd:211:52  */
  assign n7301_o = n7291_o == 3'b011;
  /* ./T80/T80_ALU.vhd:211:52  */
  assign n7302_o = n7299_o | n7301_o;
  /* ./T80/T80_ALU.vhd:211:60  */
  assign n7304_o = n7291_o == 3'b111;
  /* ./T80/T80_ALU.vhd:211:60  */
  assign n7305_o = n7302_o | n7304_o;
  /* ./T80/T80_ALU.vhd:213:58  */
  assign n7306_o = n7273_o[0];
  /* ./T80/T80_ALU.vhd:213:69  */
  assign n7307_o = n7273_o[1];
  /* ./T80/T80_ALU.vhd:213:62  */
  assign n7308_o = n7306_o ^ n7307_o;
  /* ./T80/T80_ALU.vhd:213:80  */
  assign n7309_o = n7273_o[2];
  /* ./T80/T80_ALU.vhd:213:73  */
  assign n7310_o = n7308_o ^ n7309_o;
  /* ./T80/T80_ALU.vhd:213:91  */
  assign n7311_o = n7273_o[3];
  /* ./T80/T80_ALU.vhd:213:84  */
  assign n7312_o = n7310_o ^ n7311_o;
  /* ./T80/T80_ALU.vhd:214:44  */
  assign n7313_o = n7273_o[4];
  /* ./T80/T80_ALU.vhd:213:95  */
  assign n7314_o = n7312_o ^ n7313_o;
  /* ./T80/T80_ALU.vhd:214:55  */
  assign n7315_o = n7273_o[5];
  /* ./T80/T80_ALU.vhd:214:48  */
  assign n7316_o = n7314_o ^ n7315_o;
  /* ./T80/T80_ALU.vhd:214:66  */
  assign n7317_o = n7273_o[6];
  /* ./T80/T80_ALU.vhd:214:59  */
  assign n7318_o = n7316_o ^ n7317_o;
  /* ./T80/T80_ALU.vhd:214:77  */
  assign n7319_o = n7273_o[7];
  /* ./T80/T80_ALU.vhd:214:70  */
  assign n7320_o = n7318_o ^ n7319_o;
  /* ./T80/T80_ALU.vhd:213:50  */
  assign n7321_o = ~n7320_o;
  /* ./T80/T80_ALU.vhd:210:25  */
  always @*
    case (n7305_o)
      1'b1: n7322_o = n7271_o;
      default: n7322_o = n7321_o;
    endcase
  /* ./T80/T80_ALU.vhd:217:54  */
  assign n7323_o = f_in[7];
  /* ./T80/T80_ALU.vhd:218:54  */
  assign n7324_o = f_in[6];
  /* ./T80/T80_ALU.vhd:219:54  */
  assign n7325_o = f_in[2];
  assign n7326_o = {n7323_o, n7324_o};
  /* ./T80/T80_ALU.vhd:216:25  */
  assign n7327_o = arith16 ? n7325_o : n7322_o;
  assign n7328_o = {n7290_o, n7289_o};
  /* ./T80/T80_ALU.vhd:216:25  */
  assign n7329_o = arith16 ? n7326_o : n7328_o;
  /* ./T80/T80_ALU.vhd:169:17  */
  assign n7331_o = alu_op == 4'b0000;
  /* ./T80/T80_ALU.vhd:169:29  */
  assign n7333_o = alu_op == 4'b0001;
  /* ./T80/T80_ALU.vhd:169:29  */
  assign n7334_o = n7331_o | n7333_o;
  /* ./T80/T80_ALU.vhd:169:38  */
  assign n7336_o = alu_op == 4'b0010;
  /* ./T80/T80_ALU.vhd:169:38  */
  assign n7337_o = n7334_o | n7336_o;
  /* ./T80/T80_ALU.vhd:169:48  */
  assign n7339_o = alu_op == 4'b0011;
  /* ./T80/T80_ALU.vhd:169:48  */
  assign n7340_o = n7337_o | n7339_o;
  /* ./T80/T80_ALU.vhd:169:57  */
  assign n7342_o = alu_op == 4'b0100;
  /* ./T80/T80_ALU.vhd:169:57  */
  assign n7343_o = n7340_o | n7342_o;
  /* ./T80/T80_ALU.vhd:169:66  */
  assign n7345_o = alu_op == 4'b0101;
  /* ./T80/T80_ALU.vhd:169:66  */
  assign n7346_o = n7343_o | n7345_o;
  /* ./T80/T80_ALU.vhd:169:75  */
  assign n7348_o = alu_op == 4'b0110;
  /* ./T80/T80_ALU.vhd:169:75  */
  assign n7349_o = n7346_o | n7348_o;
  /* ./T80/T80_ALU.vhd:169:84  */
  assign n7351_o = alu_op == 4'b0111;
  /* ./T80/T80_ALU.vhd:169:84  */
  assign n7352_o = n7349_o | n7351_o;
  /* ./T80/T80_ALU.vhd:223:46  */
  assign n7353_o = f_in[4];
  /* ./T80/T80_ALU.vhd:227:32  */
  assign n7356_o = f_in[1];
  /* ./T80/T80_ALU.vhd:227:41  */
  assign n7357_o = ~n7356_o;
  assign n7358_o = {1'b0, busa};
  /* ./T80/T80_ALU.vhd:230:41  */
  assign n7359_o = n7358_o[3:0];
  /* ./T80/T80_ALU.vhd:230:54  */
  assign n7361_o = $unsigned(n7359_o) > $unsigned(4'b1001);
  /* ./T80/T80_ALU.vhd:230:65  */
  assign n7362_o = f_in[4];
  /* ./T80/T80_ALU.vhd:230:58  */
  assign n7363_o = n7361_o | n7362_o;
  assign n7364_o = {1'b0, busa};
  /* ./T80/T80_ALU.vhd:231:50  */
  assign n7365_o = n7364_o[3:0];
  /* ./T80/T80_ALU.vhd:231:63  */
  assign n7367_o = $unsigned(n7365_o) > $unsigned(4'b1001);
  /* ./T80/T80_ALU.vhd:231:41  */
  assign n7370_o = n7367_o ? 1'b1 : 1'b0;
  assign n7371_o = {1'b0, busa};
  /* ./T80/T80_ALU.vhd:236:56  */
  assign n7373_o = n7371_o + 9'b000000110;
  /* ./T80/T80_ALU.vhd:230:33  */
  assign n7374_o = n7363_o ? n7370_o : n7353_o;
  assign n7375_o = {1'b0, busa};
  /* ./T80/T80_ALU.vhd:230:33  */
  assign n7376_o = n7363_o ? n7373_o : n7375_o;
  /* ./T80/T80_ALU.vhd:239:41  */
  assign n7377_o = n7376_o[8:4];
  /* ./T80/T80_ALU.vhd:239:54  */
  assign n7379_o = $unsigned(n7377_o) > $unsigned(5'b01001);
  /* ./T80/T80_ALU.vhd:239:65  */
  assign n7380_o = f_in[0];
  /* ./T80/T80_ALU.vhd:239:58  */
  assign n7381_o = n7379_o | n7380_o;
  /* ./T80/T80_ALU.vhd:240:56  */
  assign n7383_o = n7376_o + 9'b001100000;
  /* ./T80/T80_ALU.vhd:239:33  */
  assign n7384_o = n7381_o ? n7383_o : n7376_o;
  assign n7385_o = {1'b0, busa};
  /* ./T80/T80_ALU.vhd:244:41  */
  assign n7386_o = n7385_o[3:0];
  /* ./T80/T80_ALU.vhd:244:54  */
  assign n7388_o = $unsigned(n7386_o) > $unsigned(4'b1001);
  /* ./T80/T80_ALU.vhd:244:65  */
  assign n7389_o = f_in[4];
  /* ./T80/T80_ALU.vhd:244:58  */
  assign n7390_o = n7388_o | n7389_o;
  assign n7391_o = {1'b0, busa};
  /* ./T80/T80_ALU.vhd:245:49  */
  assign n7392_o = n7391_o[3:0];
  /* ./T80/T80_ALU.vhd:245:62  */
  assign n7394_o = $unsigned(n7392_o) > $unsigned(4'b0101);
  /* ./T80/T80_ALU.vhd:244:33  */
  assign n7396_o = n7401_o ? 1'b0 : n7353_o;
  assign n7397_o = {1'b0, busa};
  /* ./T80/T80_ALU.vhd:248:67  */
  assign n7398_o = n7397_o[7:0];
  /* ./T80/T80_ALU.vhd:248:80  */
  assign n7400_o = n7398_o - 8'b00000110;
  /* ./T80/T80_ALU.vhd:244:33  */
  assign n7401_o = n7394_o & n7390_o;
  /* ./T80/T80_ALU.vhd:244:33  */
  assign n7402_o = n7390_o ? n7400_o : busa;
  /* ./T80/T80_ALU.vhd:250:51  */
  assign n7404_o = $unsigned(busa) > $unsigned(8'b10011001);
  /* ./T80/T80_ALU.vhd:250:64  */
  assign n7405_o = f_in[0];
  /* ./T80/T80_ALU.vhd:250:57  */
  assign n7406_o = n7404_o | n7405_o;
  assign n7407_o = {1'b0, n7402_o};
  /* ./T80/T80_ALU.vhd:251:56  */
  assign n7409_o = n7407_o - 9'b101100000;
  assign n7410_o = {1'b0, n7402_o};
  /* ./T80/T80_ALU.vhd:250:33  */
  assign n7411_o = n7406_o ? n7409_o : n7410_o;
  /* ./T80/T80_ALU.vhd:227:25  */
  assign n7412_o = n7357_o ? n7374_o : n7396_o;
  /* ./T80/T80_ALU.vhd:227:25  */
  assign n7413_o = n7357_o ? n7384_o : n7411_o;
  /* ./T80/T80_ALU.vhd:254:47  */
  assign n7414_o = n7413_o[3];
  /* ./T80/T80_ALU.vhd:255:47  */
  assign n7415_o = n7413_o[5];
  /* ./T80/T80_ALU.vhd:256:46  */
  assign n7416_o = f_in[0];
  /* ./T80/T80_ALU.vhd:256:63  */
  assign n7417_o = n7413_o[8];
  /* ./T80/T80_ALU.vhd:256:55  */
  assign n7418_o = n7416_o | n7417_o;
  /* ./T80/T80_ALU.vhd:257:54  */
  assign n7419_o = n7413_o[7:0];
  /* ./T80/T80_ALU.vhd:258:33  */
  assign n7420_o = n7413_o[7:0];
  /* ./T80/T80_ALU.vhd:258:46  */
  assign n7422_o = n7420_o == 8'b00000000;
  /* ./T80/T80_ALU.vhd:258:25  */
  assign n7425_o = n7422_o ? 1'b1 : 1'b0;
  /* ./T80/T80_ALU.vhd:263:47  */
  assign n7426_o = n7413_o[7];
  /* ./T80/T80_ALU.vhd:264:52  */
  assign n7427_o = n7413_o[0];
  /* ./T80/T80_ALU.vhd:264:65  */
  assign n7428_o = n7413_o[1];
  /* ./T80/T80_ALU.vhd:264:56  */
  assign n7429_o = n7427_o ^ n7428_o;
  /* ./T80/T80_ALU.vhd:264:78  */
  assign n7430_o = n7413_o[2];
  /* ./T80/T80_ALU.vhd:264:69  */
  assign n7431_o = n7429_o ^ n7430_o;
  /* ./T80/T80_ALU.vhd:264:91  */
  assign n7432_o = n7413_o[3];
  /* ./T80/T80_ALU.vhd:264:82  */
  assign n7433_o = n7431_o ^ n7432_o;
  /* ./T80/T80_ALU.vhd:265:38  */
  assign n7434_o = n7413_o[4];
  /* ./T80/T80_ALU.vhd:264:95  */
  assign n7435_o = n7433_o ^ n7434_o;
  /* ./T80/T80_ALU.vhd:265:51  */
  assign n7436_o = n7413_o[5];
  /* ./T80/T80_ALU.vhd:265:42  */
  assign n7437_o = n7435_o ^ n7436_o;
  /* ./T80/T80_ALU.vhd:265:64  */
  assign n7438_o = n7413_o[6];
  /* ./T80/T80_ALU.vhd:265:55  */
  assign n7439_o = n7437_o ^ n7438_o;
  /* ./T80/T80_ALU.vhd:265:77  */
  assign n7440_o = n7413_o[7];
  /* ./T80/T80_ALU.vhd:265:68  */
  assign n7441_o = n7439_o ^ n7440_o;
  /* ./T80/T80_ALU.vhd:264:42  */
  assign n7442_o = ~n7441_o;
  /* ./T80/T80_ALU.vhd:221:17  */
  assign n7444_o = alu_op == 4'b1100;
  /* ./T80/T80_ALU.vhd:268:48  */
  assign n7445_o = busa[7:4];
  /* ./T80/T80_ALU.vhd:269:34  */
  assign n7446_o = alu_op[0];
  /* ./T80/T80_ALU.vhd:270:56  */
  assign n7447_o = busb[7:4];
  /* ./T80/T80_ALU.vhd:272:56  */
  assign n7448_o = busb[3:0];
  /* ./T80/T80_ALU.vhd:269:25  */
  assign n7449_o = n7446_o ? n7447_o : n7448_o;
  assign n7452_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:276:45  */
  assign n7453_o = n7452_o[3];
  assign n7454_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:277:45  */
  assign n7455_o = n7454_o[5];
  assign n7456_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:278:44  */
  assign n7458_o = n7456_o == 8'b00000000;
  /* ./T80/T80_ALU.vhd:278:25  */
  assign n7461_o = n7458_o ? 1'b1 : 1'b0;
  assign n7462_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:283:45  */
  assign n7463_o = n7462_o[7];
  assign n7464_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:284:50  */
  assign n7465_o = n7464_o[0];
  assign n7466_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:284:61  */
  assign n7467_o = n7466_o[1];
  /* ./T80/T80_ALU.vhd:284:54  */
  assign n7468_o = n7465_o ^ n7467_o;
  assign n7469_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:284:72  */
  assign n7470_o = n7469_o[2];
  /* ./T80/T80_ALU.vhd:284:65  */
  assign n7471_o = n7468_o ^ n7470_o;
  assign n7472_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:284:83  */
  assign n7473_o = n7472_o[3];
  /* ./T80/T80_ALU.vhd:284:76  */
  assign n7474_o = n7471_o ^ n7473_o;
  assign n7475_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:285:36  */
  assign n7476_o = n7475_o[4];
  /* ./T80/T80_ALU.vhd:284:87  */
  assign n7477_o = n7474_o ^ n7476_o;
  assign n7478_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:285:47  */
  assign n7479_o = n7478_o[5];
  /* ./T80/T80_ALU.vhd:285:40  */
  assign n7480_o = n7477_o ^ n7479_o;
  assign n7481_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:285:58  */
  assign n7482_o = n7481_o[6];
  /* ./T80/T80_ALU.vhd:285:51  */
  assign n7483_o = n7480_o ^ n7482_o;
  assign n7484_o = {n7445_o, n7449_o};
  /* ./T80/T80_ALU.vhd:285:69  */
  assign n7485_o = n7484_o[7];
  /* ./T80/T80_ALU.vhd:285:62  */
  assign n7486_o = n7483_o ^ n7485_o;
  /* ./T80/T80_ALU.vhd:284:42  */
  assign n7487_o = ~n7486_o;
  /* ./T80/T80_ALU.vhd:266:17  */
  assign n7489_o = alu_op == 4'b1101;
  /* ./T80/T80_ALU.vhd:266:29  */
  assign n7491_o = alu_op == 4'b1110;
  /* ./T80/T80_ALU.vhd:266:29  */
  assign n7492_o = n7489_o | n7491_o;
  /* ./T80/T80_ALU.vhd:288:49  */
  assign n7493_o = busb & bitmask;
  /* ./T80/T80_ALU.vhd:289:45  */
  assign n7494_o = n7493_o[7];
  /* ./T80/T80_ALU.vhd:290:44  */
  assign n7496_o = n7493_o == 8'b00000000;
  /* ./T80/T80_ALU.vhd:290:25  */
  assign n7501_o = n7496_o ? 1'b1 : 1'b0;
  /* ./T80/T80_ALU.vhd:290:25  */
  assign n7502_o = n7496_o ? 1'b1 : 1'b0;
  /* ./T80/T80_ALU.vhd:299:30  */
  assign n7505_o = ir[2:0];
  /* ./T80/T80_ALU.vhd:299:43  */
  assign n7507_o = n7505_o == 3'b110;
  /* ./T80/T80_ALU.vhd:299:63  */
  assign n7509_o = xy_state != 2'b00;
  /* ./T80/T80_ALU.vhd:299:51  */
  assign n7510_o = n7507_o | n7509_o;
  /* ./T80/T80_ALU.vhd:300:52  */
  assign n7511_o = wz[11];
  /* ./T80/T80_ALU.vhd:301:52  */
  assign n7512_o = wz[13];
  /* ./T80/T80_ALU.vhd:303:54  */
  assign n7513_o = busb[3];
  /* ./T80/T80_ALU.vhd:304:54  */
  assign n7514_o = busb[5];
  /* ./T80/T80_ALU.vhd:299:25  */
  assign n7515_o = n7510_o ? n7511_o : n7513_o;
  /* ./T80/T80_ALU.vhd:299:25  */
  assign n7516_o = n7510_o ? n7512_o : n7514_o;
  /* ./T80/T80_ALU.vhd:286:17  */
  assign n7518_o = alu_op == 4'b1001;
  /* ./T80/T80_ALU.vhd:308:49  */
  assign n7519_o = busb | bitmask;
  /* ./T80/T80_ALU.vhd:306:17  */
  assign n7521_o = alu_op == 4'b1010;
  /* ./T80/T80_ALU.vhd:311:53  */
  assign n7522_o = ~bitmask;
  /* ./T80/T80_ALU.vhd:311:49  */
  assign n7523_o = busb & n7522_o;
  /* ./T80/T80_ALU.vhd:309:17  */
  assign n7525_o = alu_op == 4'b1011;
  /* ./T80/T80_ALU.vhd:314:32  */
  assign n7526_o = ir[5:3];
  /* ./T80/T80_ALU.vhd:316:56  */
  assign n7527_o = busa[6:0];
  /* ./T80/T80_ALU.vhd:317:47  */
  assign n7528_o = busa[7];
  /* ./T80/T80_ALU.vhd:318:54  */
  assign n7529_o = busa[7];
  /* ./T80/T80_ALU.vhd:315:25  */
  assign n7531_o = n7526_o == 3'b000;
  /* ./T80/T80_ALU.vhd:320:56  */
  assign n7532_o = busa[6:0];
  /* ./T80/T80_ALU.vhd:321:47  */
  assign n7533_o = f_in[0];
  /* ./T80/T80_ALU.vhd:322:54  */
  assign n7534_o = busa[7];
  /* ./T80/T80_ALU.vhd:319:25  */
  assign n7536_o = n7526_o == 3'b010;
  /* ./T80/T80_ALU.vhd:324:56  */
  assign n7537_o = busa[7:1];
  /* ./T80/T80_ALU.vhd:325:47  */
  assign n7538_o = busa[0];
  /* ./T80/T80_ALU.vhd:326:54  */
  assign n7539_o = busa[0];
  /* ./T80/T80_ALU.vhd:323:25  */
  assign n7541_o = n7526_o == 3'b001;
  /* ./T80/T80_ALU.vhd:328:56  */
  assign n7542_o = busa[7:1];
  /* ./T80/T80_ALU.vhd:329:47  */
  assign n7543_o = f_in[0];
  /* ./T80/T80_ALU.vhd:330:54  */
  assign n7544_o = busa[0];
  /* ./T80/T80_ALU.vhd:327:25  */
  assign n7546_o = n7526_o == 3'b011;
  /* ./T80/T80_ALU.vhd:332:56  */
  assign n7547_o = busa[6:0];
  /* ./T80/T80_ALU.vhd:334:54  */
  assign n7549_o = busa[7];
  /* ./T80/T80_ALU.vhd:331:25  */
  assign n7551_o = n7526_o == 3'b100;
  /* ./T80/T80_ALU.vhd:341:64  */
  assign n7552_o = busa[6:0];
  /* ./T80/T80_ALU.vhd:343:62  */
  assign n7554_o = busa[7];
  /* ./T80/T80_ALU.vhd:335:25  */
  assign n7556_o = n7526_o == 3'b110;
  /* ./T80/T80_ALU.vhd:346:56  */
  assign n7557_o = busa[7:1];
  /* ./T80/T80_ALU.vhd:347:47  */
  assign n7558_o = busa[7];
  /* ./T80/T80_ALU.vhd:348:54  */
  assign n7559_o = busa[0];
  /* ./T80/T80_ALU.vhd:345:25  */
  assign n7561_o = n7526_o == 3'b101;
  /* ./T80/T80_ALU.vhd:350:56  */
  assign n7562_o = busa[7:1];
  /* ./T80/T80_ALU.vhd:352:54  */
  assign n7564_o = busa[0];
  assign n7565_o = {n7561_o, n7556_o, n7551_o, n7546_o, n7541_o, n7536_o, n7531_o};
  /* ./T80/T80_ALU.vhd:314:25  */
  always @*
    case (n7565_o)
      7'b1000000: n7566_o = n7559_o;
      7'b0100000: n7566_o = n7554_o;
      7'b0010000: n7566_o = n7549_o;
      7'b0001000: n7566_o = n7544_o;
      7'b0000100: n7566_o = n7539_o;
      7'b0000010: n7566_o = n7534_o;
      7'b0000001: n7566_o = n7529_o;
      default: n7566_o = n7564_o;
    endcase
  assign n7567_o = n7537_o[0];
  assign n7568_o = n7542_o[0];
  assign n7569_o = n7557_o[0];
  assign n7570_o = n7562_o[0];
  /* ./T80/T80_ALU.vhd:314:25  */
  always @*
    case (n7565_o)
      7'b1000000: n7571_o = n7569_o;
      7'b0100000: n7571_o = 1'b1;
      7'b0010000: n7571_o = 1'b0;
      7'b0001000: n7571_o = n7568_o;
      7'b0000100: n7571_o = n7567_o;
      7'b0000010: n7571_o = n7533_o;
      7'b0000001: n7571_o = n7528_o;
      default: n7571_o = n7570_o;
    endcase
  assign n7572_o = n7527_o[5:0];
  assign n7573_o = n7532_o[5:0];
  assign n7574_o = n7537_o[6:1];
  assign n7575_o = n7542_o[6:1];
  assign n7576_o = n7547_o[5:0];
  assign n7577_o = n7552_o[5:0];
  assign n7578_o = n7557_o[6:1];
  assign n7579_o = n7562_o[6:1];
  /* ./T80/T80_ALU.vhd:314:25  */
  always @*
    case (n7565_o)
      7'b1000000: n7580_o = n7578_o;
      7'b0100000: n7580_o = n7577_o;
      7'b0010000: n7580_o = n7576_o;
      7'b0001000: n7580_o = n7575_o;
      7'b0000100: n7580_o = n7574_o;
      7'b0000010: n7580_o = n7573_o;
      7'b0000001: n7580_o = n7572_o;
      default: n7580_o = n7579_o;
    endcase
  assign n7581_o = n7527_o[6];
  assign n7582_o = n7532_o[6];
  assign n7583_o = n7547_o[6];
  assign n7584_o = n7552_o[6];
  /* ./T80/T80_ALU.vhd:314:25  */
  always @*
    case (n7565_o)
      7'b1000000: n7585_o = n7558_o;
      7'b0100000: n7585_o = n7584_o;
      7'b0010000: n7585_o = n7583_o;
      7'b0001000: n7585_o = n7543_o;
      7'b0000100: n7585_o = n7538_o;
      7'b0000010: n7585_o = n7582_o;
      7'b0000001: n7585_o = n7581_o;
      default: n7585_o = 1'b0;
    endcase
  assign n7588_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:356:45  */
  assign n7589_o = n7588_o[3];
  assign n7590_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:357:45  */
  assign n7591_o = n7590_o[5];
  assign n7592_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:358:45  */
  assign n7593_o = n7592_o[7];
  assign n7594_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:359:44  */
  assign n7596_o = n7594_o == 8'b00000000;
  /* ./T80/T80_ALU.vhd:359:25  */
  assign n7599_o = n7596_o ? 1'b1 : 1'b0;
  assign n7600_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:364:50  */
  assign n7601_o = n7600_o[0];
  assign n7602_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:364:61  */
  assign n7603_o = n7602_o[1];
  /* ./T80/T80_ALU.vhd:364:54  */
  assign n7604_o = n7601_o ^ n7603_o;
  assign n7605_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:364:72  */
  assign n7606_o = n7605_o[2];
  /* ./T80/T80_ALU.vhd:364:65  */
  assign n7607_o = n7604_o ^ n7606_o;
  assign n7608_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:364:83  */
  assign n7609_o = n7608_o[3];
  /* ./T80/T80_ALU.vhd:364:76  */
  assign n7610_o = n7607_o ^ n7609_o;
  assign n7611_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:365:36  */
  assign n7612_o = n7611_o[4];
  /* ./T80/T80_ALU.vhd:364:87  */
  assign n7613_o = n7610_o ^ n7612_o;
  assign n7614_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:365:47  */
  assign n7615_o = n7614_o[5];
  /* ./T80/T80_ALU.vhd:365:40  */
  assign n7616_o = n7613_o ^ n7615_o;
  assign n7617_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:365:58  */
  assign n7618_o = n7617_o[6];
  /* ./T80/T80_ALU.vhd:365:51  */
  assign n7619_o = n7616_o ^ n7618_o;
  assign n7620_o = {n7585_o, n7580_o, n7571_o};
  /* ./T80/T80_ALU.vhd:365:69  */
  assign n7621_o = n7620_o[7];
  /* ./T80/T80_ALU.vhd:365:62  */
  assign n7622_o = n7619_o ^ n7621_o;
  /* ./T80/T80_ALU.vhd:364:42  */
  assign n7623_o = ~n7622_o;
  /* ./T80/T80_ALU.vhd:366:33  */
  assign n7625_o = iset == 2'b00;
  /* ./T80/T80_ALU.vhd:367:54  */
  assign n7626_o = f_in[2];
  /* ./T80/T80_ALU.vhd:368:54  */
  assign n7627_o = f_in[7];
  /* ./T80/T80_ALU.vhd:369:54  */
  assign n7628_o = f_in[6];
  assign n7629_o = {n7627_o, n7628_o};
  /* ./T80/T80_ALU.vhd:366:25  */
  assign n7630_o = n7625_o ? n7626_o : n7623_o;
  assign n7631_o = {n7593_o, n7599_o};
  /* ./T80/T80_ALU.vhd:366:25  */
  assign n7632_o = n7625_o ? n7629_o : n7631_o;
  /* ./T80/T80_ALU.vhd:312:17  */
  assign n7634_o = alu_op == 4'b1000;
  assign n7635_o = {n7634_o, n7525_o, n7521_o, n7518_o, n7492_o, n7444_o, n7352_o};
  assign n7636_o = f_in[0];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7637_o = n7566_o;
      7'b0100000: n7637_o = n7636_o;
      7'b0010000: n7637_o = n7636_o;
      7'b0001000: n7637_o = n7636_o;
      7'b0000100: n7637_o = n7636_o;
      7'b0000010: n7637_o = n7418_o;
      7'b0000001: n7637_o = n7268_o;
      default: n7637_o = n7636_o;
    endcase
  assign n7638_o = f_in[1];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7639_o = 1'b0;
      7'b0100000: n7639_o = n7638_o;
      7'b0010000: n7639_o = n7638_o;
      7'b0001000: n7639_o = 1'b0;
      7'b0000100: n7639_o = 1'b0;
      7'b0000010: n7639_o = n7638_o;
      7'b0000001: n7639_o = n7269_o;
      default: n7639_o = n7638_o;
    endcase
  assign n7640_o = f_in[2];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7641_o = n7630_o;
      7'b0100000: n7641_o = n7640_o;
      7'b0010000: n7641_o = n7640_o;
      7'b0001000: n7641_o = n7501_o;
      7'b0000100: n7641_o = n7487_o;
      7'b0000010: n7641_o = n7442_o;
      7'b0000001: n7641_o = n7327_o;
      default: n7641_o = n7640_o;
    endcase
  assign n7642_o = f_in[3];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7643_o = n7589_o;
      7'b0100000: n7643_o = n7642_o;
      7'b0010000: n7643_o = n7642_o;
      7'b0001000: n7643_o = n7515_o;
      7'b0000100: n7643_o = n7453_o;
      7'b0000010: n7643_o = n7414_o;
      7'b0000001: n7643_o = n7281_o;
      default: n7643_o = n7642_o;
    endcase
  assign n7644_o = f_in[4];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7645_o = 1'b0;
      7'b0100000: n7645_o = n7644_o;
      7'b0010000: n7645_o = n7644_o;
      7'b0001000: n7645_o = 1'b1;
      7'b0000100: n7645_o = 1'b0;
      7'b0000010: n7645_o = n7412_o;
      7'b0000001: n7645_o = n7272_o;
      default: n7645_o = n7644_o;
    endcase
  assign n7646_o = f_in[5];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7647_o = n7591_o;
      7'b0100000: n7647_o = n7646_o;
      7'b0010000: n7647_o = n7646_o;
      7'b0001000: n7647_o = n7516_o;
      7'b0000100: n7647_o = n7455_o;
      7'b0000010: n7647_o = n7415_o;
      7'b0000001: n7647_o = n7282_o;
      default: n7647_o = n7646_o;
    endcase
  assign n7648_o = n7329_o[0];
  assign n7649_o = n7632_o[0];
  assign n7650_o = f_in[6];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7651_o = n7649_o;
      7'b0100000: n7651_o = n7650_o;
      7'b0010000: n7651_o = n7650_o;
      7'b0001000: n7651_o = n7502_o;
      7'b0000100: n7651_o = n7461_o;
      7'b0000010: n7651_o = n7425_o;
      7'b0000001: n7651_o = n7648_o;
      default: n7651_o = n7650_o;
    endcase
  assign n7652_o = n7329_o[1];
  assign n7653_o = n7632_o[1];
  assign n7654_o = f_in[7];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7655_o = n7653_o;
      7'b0100000: n7655_o = n7654_o;
      7'b0010000: n7655_o = n7654_o;
      7'b0001000: n7655_o = n7494_o;
      7'b0000100: n7655_o = n7463_o;
      7'b0000010: n7655_o = n7426_o;
      7'b0000001: n7655_o = n7652_o;
      default: n7655_o = n7654_o;
    endcase
  assign n7663_o = n7273_o[0];
  assign n7664_o = n7419_o[0];
  assign n7665_o = n7449_o[0];
  assign n7666_o = n7493_o[0];
  assign n7667_o = n7519_o[0];
  assign n7668_o = n7523_o[0];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7670_o = n7571_o;
      7'b0100000: n7670_o = n7668_o;
      7'b0010000: n7670_o = n7667_o;
      7'b0001000: n7670_o = n7666_o;
      7'b0000100: n7670_o = n7665_o;
      7'b0000010: n7670_o = n7664_o;
      7'b0000001: n7670_o = n7663_o;
      default: n7670_o = 1'bX;
    endcase
  assign n7671_o = n7273_o[3:1];
  assign n7672_o = n7419_o[3:1];
  assign n7673_o = n7449_o[3:1];
  assign n7674_o = n7493_o[3:1];
  assign n7675_o = n7519_o[3:1];
  assign n7676_o = n7523_o[3:1];
  assign n7677_o = n7580_o[2:0];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7679_o = n7677_o;
      7'b0100000: n7679_o = n7676_o;
      7'b0010000: n7679_o = n7675_o;
      7'b0001000: n7679_o = n7674_o;
      7'b0000100: n7679_o = n7673_o;
      7'b0000010: n7679_o = n7672_o;
      7'b0000001: n7679_o = n7671_o;
      default: n7679_o = 3'bX;
    endcase
  assign n7680_o = n7273_o[6:4];
  assign n7681_o = n7419_o[6:4];
  assign n7682_o = n7445_o[2:0];
  assign n7683_o = n7493_o[6:4];
  assign n7684_o = n7519_o[6:4];
  assign n7685_o = n7523_o[6:4];
  assign n7686_o = n7580_o[5:3];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7688_o = n7686_o;
      7'b0100000: n7688_o = n7685_o;
      7'b0010000: n7688_o = n7684_o;
      7'b0001000: n7688_o = n7683_o;
      7'b0000100: n7688_o = n7682_o;
      7'b0000010: n7688_o = n7681_o;
      7'b0000001: n7688_o = n7680_o;
      default: n7688_o = 3'bX;
    endcase
  assign n7689_o = n7273_o[7];
  assign n7690_o = n7419_o[7];
  assign n7691_o = n7445_o[3];
  assign n7692_o = n7493_o[7];
  assign n7693_o = n7519_o[7];
  assign n7694_o = n7523_o[7];
  /* ./T80/T80_ALU.vhd:168:17  */
  always @*
    case (n7635_o)
      7'b1000000: n7696_o = n7585_o;
      7'b0100000: n7696_o = n7694_o;
      7'b0010000: n7696_o = n7693_o;
      7'b0001000: n7696_o = n7692_o;
      7'b0000100: n7696_o = n7691_o;
      7'b0000010: n7696_o = n7690_o;
      7'b0000001: n7696_o = n7689_o;
      default: n7696_o = 1'bX;
    endcase
  assign n7704_o = {n7696_o, n7688_o, n7679_o, n7670_o};
  assign n7707_o = {n7229_o, n7207_o, n7185_o};
  assign n7708_o = {n7655_o, n7651_o, n7647_o, n7645_o, n7643_o, n7641_o, n7639_o, n7637_o};
endmodule

module t80_mcode_0_0_1_2_3_4_5_6_7
  (input  [7:0] ir,
   input  [1:0] iset,
   input  [2:0] mcycle,
   input  [7:0] f,
   input  nmicycle,
   input  intcycle,
   input  [1:0] xy_state,
   output [2:0] mcycles,
   output [2:0] tstates,
   output [1:0] prefix,
   output inc_pc,
   output inc_wz,
   output [3:0] incdec_16,
   output read_to_reg,
   output read_to_acc,
   output [3:0] set_busa_to,
   output [3:0] set_busb_to,
   output [3:0] alu_op,
   output save_alu,
   output preservec,
   output arith16,
   output [2:0] set_addr_to,
   output iorq,
   output jump,
   output jumpe,
   output jumpxy,
   output call,
   output rstp,
   output ldz,
   output ldw,
   output ldsphl,
   output [2:0] special_ld,
   output exchangedh,
   output exchangerp,
   output exchangeaf,
   output exchangers,
   output i_djnz,
   output i_cpl,
   output i_ccf,
   output i_scf,
   output i_retn,
   output i_bt,
   output i_bc,
   output i_btr,
   output i_rld,
   output i_rrd,
   output i_inrc,
   output [1:0] setwz,
   output setdi,
   output setei,
   output [1:0] imode,
   output halt,
   output noread,
   output write,
   output xybit_undoc);
  wire [2:0] n2108_o;
  wire [2:0] n2109_o;
  wire [1:0] n2110_o;
  wire n2112_o;
  wire [2:0] n2115_o;
  wire [2:0] n2116_o;
  wire [3:0] n2118_o;
  wire n2120_o;
  wire n2122_o;
  wire n2123_o;
  wire n2125_o;
  wire n2126_o;
  wire n2128_o;
  wire n2129_o;
  wire n2131_o;
  wire n2132_o;
  wire n2134_o;
  wire n2135_o;
  wire n2137_o;
  wire n2138_o;
  wire n2140_o;
  wire n2141_o;
  wire n2143_o;
  wire n2144_o;
  wire n2146_o;
  wire n2147_o;
  wire n2149_o;
  wire n2150_o;
  wire n2152_o;
  wire n2153_o;
  wire n2155_o;
  wire n2156_o;
  wire n2158_o;
  wire n2159_o;
  wire n2161_o;
  wire n2162_o;
  wire n2164_o;
  wire n2165_o;
  wire n2167_o;
  wire n2168_o;
  wire n2170_o;
  wire n2171_o;
  wire n2173_o;
  wire n2174_o;
  wire n2176_o;
  wire n2177_o;
  wire n2179_o;
  wire n2180_o;
  wire n2182_o;
  wire n2183_o;
  wire n2185_o;
  wire n2186_o;
  wire n2188_o;
  wire n2189_o;
  wire n2191_o;
  wire n2192_o;
  wire n2194_o;
  wire n2195_o;
  wire n2197_o;
  wire n2198_o;
  wire n2200_o;
  wire n2201_o;
  wire n2203_o;
  wire n2204_o;
  wire n2206_o;
  wire n2207_o;
  wire n2209_o;
  wire n2210_o;
  wire n2212_o;
  wire n2213_o;
  wire n2215_o;
  wire n2216_o;
  wire n2218_o;
  wire n2219_o;
  wire n2221_o;
  wire n2222_o;
  wire n2224_o;
  wire n2225_o;
  wire n2227_o;
  wire n2228_o;
  wire n2230_o;
  wire n2231_o;
  wire n2233_o;
  wire n2234_o;
  wire n2236_o;
  wire n2237_o;
  wire n2239_o;
  wire n2240_o;
  wire n2242_o;
  wire n2243_o;
  wire n2245_o;
  wire n2246_o;
  wire n2248_o;
  wire n2249_o;
  wire n2251_o;
  wire n2252_o;
  wire n2254_o;
  wire n2255_o;
  wire n2257_o;
  wire n2258_o;
  wire n2260_o;
  wire n2261_o;
  wire n2263_o;
  wire n2264_o;
  wire [30:0] n2265_o;
  wire n2267_o;
  reg n2270_o;
  reg n2273_o;
  reg [2:0] n2275_o;
  wire n2277_o;
  wire n2279_o;
  wire n2280_o;
  wire n2282_o;
  wire n2283_o;
  wire n2285_o;
  wire n2286_o;
  wire n2288_o;
  wire n2289_o;
  wire n2291_o;
  wire n2292_o;
  wire n2294_o;
  wire n2295_o;
  wire [30:0] n2296_o;
  wire n2298_o;
  wire n2300_o;
  wire [1:0] n2301_o;
  reg n2304_o;
  reg [2:0] n2306_o;
  reg [2:0] n2309_o;
  wire n2311_o;
  wire n2313_o;
  wire n2314_o;
  wire n2316_o;
  wire n2317_o;
  wire n2319_o;
  wire n2320_o;
  wire n2322_o;
  wire n2323_o;
  wire n2325_o;
  wire n2326_o;
  wire n2328_o;
  wire n2329_o;
  wire [30:0] n2330_o;
  wire n2333_o;
  wire n2335_o;
  wire [1:0] n2336_o;
  reg [2:0] n2338_o;
  reg n2340_o;
  reg [2:0] n2343_o;
  reg n2346_o;
  wire n2348_o;
  wire n2350_o;
  wire n2351_o;
  wire n2353_o;
  wire n2354_o;
  wire n2356_o;
  wire n2357_o;
  wire n2359_o;
  wire n2360_o;
  wire n2362_o;
  wire n2363_o;
  wire n2365_o;
  wire n2366_o;
  wire [30:0] n2367_o;
  wire n2370_o;
  wire n2372_o;
  wire [1:0] n2373_o;
  reg n2376_o;
  reg [2:0] n2378_o;
  reg n2380_o;
  reg [2:0] n2383_o;
  reg n2386_o;
  wire n2388_o;
  wire [30:0] n2389_o;
  wire n2391_o;
  wire n2393_o;
  wire [1:0] n2394_o;
  reg n2397_o;
  reg [2:0] n2400_o;
  wire n2402_o;
  wire [30:0] n2403_o;
  wire n2405_o;
  wire n2407_o;
  wire [1:0] n2408_o;
  reg n2411_o;
  reg [2:0] n2414_o;
  wire n2416_o;
  wire [30:0] n2417_o;
  wire n2419_o;
  wire n2421_o;
  wire n2423_o;
  wire [2:0] n2424_o;
  reg n2428_o;
  reg n2431_o;
  reg [2:0] n2434_o;
  reg n2437_o;
  wire n2439_o;
  wire [30:0] n2440_o;
  wire n2442_o;
  wire n2444_o;
  wire [1:0] n2445_o;
  reg [3:0] n2448_o;
  reg [2:0] n2451_o;
  reg [1:0] n2454_o;
  reg n2457_o;
  wire n2459_o;
  wire [30:0] n2460_o;
  wire n2462_o;
  wire n2464_o;
  wire [1:0] n2465_o;
  reg [3:0] n2468_o;
  reg [2:0] n2471_o;
  reg [1:0] n2474_o;
  reg n2477_o;
  wire n2479_o;
  wire [30:0] n2480_o;
  wire n2482_o;
  wire n2484_o;
  wire n2486_o;
  wire [2:0] n2487_o;
  reg n2491_o;
  reg [3:0] n2494_o;
  reg [2:0] n2497_o;
  reg n2500_o;
  reg [1:0] n2503_o;
  reg n2506_o;
  wire n2508_o;
  wire [30:0] n2509_o;
  wire n2511_o;
  wire [2:0] n2513_o;
  wire [2:0] n2515_o;
  wire n2518_o;
  wire n2520_o;
  wire n2522_o;
  wire [2:0] n2524_o;
  wire [2:0] n2526_o;
  wire n2529_o;
  wire n2531_o;
  wire [1:0] n2532_o;
  reg n2536_o;
  reg n2540_o;
  reg [2:0] n2542_o;
  reg n2544_o;
  wire n2546_o;
  wire n2548_o;
  wire n2549_o;
  wire n2551_o;
  wire n2552_o;
  wire n2554_o;
  wire n2555_o;
  wire [30:0] n2556_o;
  wire n2558_o;
  wire n2560_o;
  wire n2563_o;
  wire n2566_o;
  wire [3:0] n2567_o;
  reg n2571_o;
  reg n2574_o;
  reg n2578_o;
  reg [2:0] n2580_o;
  reg [2:0] n2584_o;
  reg n2587_o;
  reg n2590_o;
  wire n2592_o;
  wire [30:0] n2593_o;
  wire n2595_o;
  wire n2597_o;
  wire n2599_o;
  wire n2601_o;
  wire [3:0] n2602_o;
  reg n2606_o;
  reg n2609_o;
  reg [3:0] n2613_o;
  reg [2:0] n2617_o;
  reg n2620_o;
  reg n2623_o;
  reg n2627_o;
  wire n2629_o;
  wire n2631_o;
  wire [30:0] n2632_o;
  wire n2634_o;
  wire [3:0] n2637_o;
  wire [3:0] n2639_o;
  wire n2641_o;
  wire n2643_o;
  wire [3:0] n2646_o;
  wire [3:0] n2648_o;
  wire n2650_o;
  wire n2652_o;
  wire [2:0] n2653_o;
  reg [2:0] n2655_o;
  reg [3:0] n2659_o;
  reg [3:0] n2661_o;
  reg [2:0] n2665_o;
  reg n2669_o;
  wire n2671_o;
  wire n2673_o;
  wire n2674_o;
  wire n2676_o;
  wire n2677_o;
  wire n2679_o;
  wire n2680_o;
  wire [30:0] n2681_o;
  wire n2683_o;
  wire n2685_o;
  wire [2:0] n2687_o;
  wire [2:0] n2689_o;
  wire n2692_o;
  wire n2694_o;
  wire n2696_o;
  wire [2:0] n2698_o;
  wire [2:0] n2700_o;
  wire n2703_o;
  wire n2705_o;
  wire [2:0] n2706_o;
  reg [3:0] n2710_o;
  reg n2714_o;
  reg [2:0] n2716_o;
  reg n2718_o;
  reg [2:0] n2722_o;
  wire n2724_o;
  wire n2726_o;
  wire n2727_o;
  wire n2729_o;
  wire n2730_o;
  wire n2732_o;
  wire n2733_o;
  wire n2735_o;
  wire n2737_o;
  wire n2739_o;
  wire [30:0] n2740_o;
  wire n2742_o;
  wire n2744_o;
  wire n2746_o;
  wire n2748_o;
  wire n2750_o;
  wire [4:0] n2751_o;
  reg [2:0] n2754_o;
  reg [3:0] n2758_o;
  reg n2762_o;
  reg [3:0] n2766_o;
  reg [3:0] n2770_o;
  reg [2:0] n2776_o;
  reg n2779_o;
  reg n2782_o;
  reg n2786_o;
  wire n2788_o;
  wire n2791_o;
  wire n2793_o;
  wire n2794_o;
  wire n2796_o;
  wire n2797_o;
  wire n2799_o;
  wire n2800_o;
  wire n2802_o;
  wire n2803_o;
  wire n2805_o;
  wire n2806_o;
  wire n2808_o;
  wire n2809_o;
  wire n2811_o;
  wire n2812_o;
  wire n2814_o;
  wire n2815_o;
  wire n2817_o;
  wire n2818_o;
  wire n2820_o;
  wire n2821_o;
  wire n2823_o;
  wire n2824_o;
  wire n2826_o;
  wire n2827_o;
  wire n2829_o;
  wire n2830_o;
  wire n2832_o;
  wire n2833_o;
  wire n2835_o;
  wire n2836_o;
  wire n2838_o;
  wire n2839_o;
  wire n2841_o;
  wire n2842_o;
  wire n2844_o;
  wire n2845_o;
  wire n2847_o;
  wire n2848_o;
  wire n2850_o;
  wire n2851_o;
  wire n2853_o;
  wire n2854_o;
  wire n2856_o;
  wire n2857_o;
  wire n2859_o;
  wire n2860_o;
  wire n2862_o;
  wire n2863_o;
  wire n2865_o;
  wire n2866_o;
  wire n2868_o;
  wire n2869_o;
  wire n2871_o;
  wire n2872_o;
  wire n2874_o;
  wire n2875_o;
  wire n2877_o;
  wire n2878_o;
  wire n2880_o;
  wire n2881_o;
  wire n2883_o;
  wire n2884_o;
  wire n2886_o;
  wire n2887_o;
  wire n2889_o;
  wire n2890_o;
  wire n2892_o;
  wire n2893_o;
  wire n2895_o;
  wire n2896_o;
  wire n2898_o;
  wire n2899_o;
  wire n2901_o;
  wire n2902_o;
  wire n2904_o;
  wire n2905_o;
  wire n2907_o;
  wire n2908_o;
  wire n2910_o;
  wire n2911_o;
  wire n2913_o;
  wire n2914_o;
  wire n2916_o;
  wire n2917_o;
  wire n2919_o;
  wire n2920_o;
  wire n2922_o;
  wire n2923_o;
  wire n2925_o;
  wire n2926_o;
  wire n2928_o;
  wire n2929_o;
  wire n2931_o;
  wire n2932_o;
  wire n2934_o;
  wire n2935_o;
  wire n2937_o;
  wire n2938_o;
  wire n2940_o;
  wire n2941_o;
  wire n2943_o;
  wire n2944_o;
  wire n2946_o;
  wire n2947_o;
  wire n2949_o;
  wire n2950_o;
  wire n2952_o;
  wire n2953_o;
  wire n2955_o;
  wire n2956_o;
  wire [30:0] n2957_o;
  wire n2959_o;
  wire n2962_o;
  wire [1:0] n2963_o;
  reg n2966_o;
  reg [2:0] n2968_o;
  reg [2:0] n2970_o;
  reg n2973_o;
  reg [2:0] n2976_o;
  wire n2978_o;
  wire n2980_o;
  wire n2981_o;
  wire n2983_o;
  wire n2984_o;
  wire n2986_o;
  wire n2987_o;
  wire n2989_o;
  wire n2990_o;
  wire n2992_o;
  wire n2993_o;
  wire n2995_o;
  wire n2996_o;
  wire n2998_o;
  wire n2999_o;
  wire n3001_o;
  wire n3005_o;
  wire n3008_o;
  wire [2:0] n3010_o;
  wire [2:0] n3012_o;
  wire n3015_o;
  wire n3017_o;
  wire n3019_o;
  wire n3020_o;
  wire n3022_o;
  wire n3023_o;
  wire n3025_o;
  wire n3026_o;
  wire n3028_o;
  wire n3029_o;
  wire n3031_o;
  wire n3032_o;
  wire n3034_o;
  wire n3035_o;
  wire n3037_o;
  wire n3038_o;
  wire n3040_o;
  wire n3042_o;
  wire n3043_o;
  wire n3045_o;
  wire n3046_o;
  wire n3048_o;
  wire n3049_o;
  wire n3051_o;
  wire n3052_o;
  wire n3054_o;
  wire n3055_o;
  wire n3057_o;
  wire n3058_o;
  wire [30:0] n3059_o;
  wire n3061_o;
  wire n3063_o;
  wire n3065_o;
  wire [2:0] n3066_o;
  reg [2:0] n3068_o;
  reg n3071_o;
  reg [2:0] n3073_o;
  reg [3:0] n3076_o;
  reg [3:0] n3078_o;
  reg n3081_o;
  reg n3084_o;
  reg [2:0] n3088_o;
  reg n3091_o;
  wire n3093_o;
  wire n3095_o;
  wire n3097_o;
  wire n3098_o;
  wire n3100_o;
  wire n3101_o;
  wire n3103_o;
  wire n3104_o;
  wire n3106_o;
  wire n3107_o;
  wire n3109_o;
  wire n3110_o;
  wire n3112_o;
  wire n3113_o;
  wire [30:0] n3114_o;
  wire n3116_o;
  wire n3118_o;
  wire n3120_o;
  wire [2:0] n3121_o;
  reg [2:0] n3123_o;
  reg n3126_o;
  reg [2:0] n3128_o;
  reg [3:0] n3131_o;
  reg [3:0] n3133_o;
  reg n3136_o;
  reg n3139_o;
  reg [2:0] n3143_o;
  reg n3146_o;
  wire n3148_o;
  wire n3151_o;
  wire n3153_o;
  wire n3155_o;
  wire n3157_o;
  wire [30:0] n3158_o;
  wire n3160_o;
  wire n3162_o;
  wire n3164_o;
  wire [2:0] n3165_o;
  reg [2:0] n3167_o;
  reg [3:0] n3171_o;
  reg [3:0] n3175_o;
  reg [2:0] n3179_o;
  reg n3183_o;
  wire [30:0] n3184_o;
  wire n3186_o;
  wire n3188_o;
  wire n3190_o;
  wire n3192_o;
  wire n3194_o;
  wire [4:0] n3195_o;
  reg [2:0] n3197_o;
  reg n3200_o;
  reg [3:0] n3204_o;
  reg [3:0] n3208_o;
  reg [2:0] n3212_o;
  reg n3215_o;
  reg n3219_o;
  reg n3223_o;
  wire [2:0] n3226_o;
  wire [2:0] n3227_o;
  wire n3229_o;
  wire [3:0] n3231_o;
  wire [3:0] n3233_o;
  wire [2:0] n3235_o;
  wire n3237_o;
  wire n3239_o;
  wire n3241_o;
  wire [2:0] n3243_o;
  wire [2:0] n3244_o;
  wire n3246_o;
  wire [3:0] n3247_o;
  wire [3:0] n3248_o;
  wire [2:0] n3249_o;
  wire n3251_o;
  wire n3253_o;
  wire n3254_o;
  wire n3256_o;
  wire n3258_o;
  wire n3260_o;
  wire n3262_o;
  wire [30:0] n3263_o;
  wire [1:0] n3265_o;
  wire [30:0] n3266_o;
  wire [1:0] n3267_o;
  wire n3270_o;
  wire n3272_o;
  wire n3273_o;
  wire n3275_o;
  wire n3276_o;
  reg n3278_o;
  reg [1:0] n3280_o;
  reg n3283_o;
  wire n3285_o;
  wire [1:0] n3287_o;
  wire [30:0] n3288_o;
  wire [1:0] n3289_o;
  wire n3291_o;
  wire n3293_o;
  wire n3294_o;
  wire n3296_o;
  wire n3297_o;
  reg n3300_o;
  reg [1:0] n3302_o;
  reg n3305_o;
  wire n3307_o;
  wire [1:0] n3308_o;
  reg [2:0] n3310_o;
  reg n3314_o;
  reg [2:0] n3316_o;
  reg n3318_o;
  reg [1:0] n3320_o;
  reg n3322_o;
  reg [3:0] n3325_o;
  reg n3329_o;
  reg n3333_o;
  reg [1:0] n3336_o;
  reg n3340_o;
  wire n3342_o;
  wire n3344_o;
  wire n3345_o;
  wire n3347_o;
  wire n3348_o;
  wire n3350_o;
  wire n3351_o;
  wire n3354_o;
  wire n3356_o;
  wire n3357_o;
  wire n3359_o;
  wire n3360_o;
  wire n3362_o;
  wire n3363_o;
  wire n3366_o;
  wire n3368_o;
  wire n3369_o;
  wire n3371_o;
  wire n3372_o;
  wire n3374_o;
  wire n3375_o;
  wire n3378_o;
  wire n3380_o;
  wire n3381_o;
  wire n3383_o;
  wire n3384_o;
  wire n3386_o;
  wire n3387_o;
  wire [30:0] n3388_o;
  wire n3390_o;
  wire n3392_o;
  wire [1:0] n3393_o;
  reg n3397_o;
  reg n3400_o;
  reg n3403_o;
  reg n3406_o;
  wire n3408_o;
  wire [30:0] n3410_o;
  wire n3412_o;
  wire [2:0] n3414_o;
  wire n3419_o;
  wire n3420_o;
  wire n3422_o;
  wire n3423_o;
  wire n3425_o;
  wire n3426_o;
  wire n3427_o;
  wire n3429_o;
  wire n3430_o;
  wire n3432_o;
  wire n3433_o;
  wire n3434_o;
  wire n3436_o;
  wire n3437_o;
  wire n3439_o;
  wire n3440_o;
  wire n3441_o;
  wire n3443_o;
  wire n3444_o;
  wire n3446_o;
  wire [7:0] n3447_o;
  reg n3449_o;
  wire n3452_o;
  wire n3454_o;
  wire [1:0] n3455_o;
  reg n3459_o;
  reg n3461_o;
  reg n3464_o;
  reg n3467_o;
  wire n3469_o;
  wire n3471_o;
  wire n3472_o;
  wire n3474_o;
  wire n3475_o;
  wire n3477_o;
  wire n3478_o;
  wire n3480_o;
  wire n3481_o;
  wire n3483_o;
  wire n3484_o;
  wire n3486_o;
  wire n3487_o;
  wire n3489_o;
  wire n3490_o;
  wire [30:0] n3491_o;
  wire n3493_o;
  wire n3495_o;
  wire [1:0] n3496_o;
  reg [2:0] n3498_o;
  reg n3501_o;
  reg n3504_o;
  reg n3507_o;
  wire n3509_o;
  wire [30:0] n3510_o;
  wire n3511_o;
  wire n3512_o;
  wire [2:0] n3515_o;
  wire n3517_o;
  wire n3519_o;
  wire [1:0] n3520_o;
  reg [2:0] n3522_o;
  reg [2:0] n3525_o;
  reg n3528_o;
  reg n3531_o;
  reg n3534_o;
  wire n3536_o;
  wire [30:0] n3537_o;
  wire n3538_o;
  wire [2:0] n3541_o;
  wire n3543_o;
  wire n3545_o;
  wire [1:0] n3546_o;
  reg [2:0] n3548_o;
  reg [2:0] n3551_o;
  reg n3554_o;
  reg n3557_o;
  reg n3560_o;
  wire n3562_o;
  wire [30:0] n3563_o;
  wire n3564_o;
  wire n3565_o;
  wire [2:0] n3568_o;
  wire n3570_o;
  wire n3572_o;
  wire [1:0] n3573_o;
  reg [2:0] n3575_o;
  reg [2:0] n3578_o;
  reg n3581_o;
  reg n3584_o;
  reg n3587_o;
  wire n3589_o;
  wire [30:0] n3590_o;
  wire n3591_o;
  wire [2:0] n3594_o;
  wire n3596_o;
  wire n3598_o;
  wire [1:0] n3599_o;
  reg [2:0] n3601_o;
  reg [2:0] n3604_o;
  reg n3607_o;
  reg n3610_o;
  reg n3613_o;
  wire n3615_o;
  wire n3617_o;
  wire [30:0] n3618_o;
  wire n3621_o;
  wire n3623_o;
  wire n3625_o;
  wire [2:0] n3626_o;
  reg [2:0] n3629_o;
  reg n3632_o;
  reg n3635_o;
  reg [2:0] n3637_o;
  reg [3:0] n3640_o;
  reg [3:0] n3642_o;
  reg n3645_o;
  reg n3648_o;
  reg n3652_o;
  reg n3655_o;
  wire n3657_o;
  wire [30:0] n3658_o;
  wire n3660_o;
  wire n3662_o;
  wire n3664_o;
  wire n3666_o;
  wire [3:0] n3667_o;
  reg [2:0] n3669_o;
  reg n3673_o;
  reg [3:0] n3677_o;
  reg [3:0] n3681_o;
  reg [2:0] n3685_o;
  reg n3688_o;
  reg n3691_o;
  reg n3694_o;
  reg n3698_o;
  wire n3700_o;
  wire [30:0] n3703_o;
  wire n3705_o;
  wire [2:0] n3707_o;
  wire n3712_o;
  wire n3713_o;
  wire n3715_o;
  wire n3716_o;
  wire n3718_o;
  wire n3719_o;
  wire n3720_o;
  wire n3722_o;
  wire n3723_o;
  wire n3725_o;
  wire n3726_o;
  wire n3727_o;
  wire n3729_o;
  wire n3730_o;
  wire n3732_o;
  wire n3733_o;
  wire n3734_o;
  wire n3736_o;
  wire n3737_o;
  wire n3739_o;
  wire [7:0] n3740_o;
  reg n3742_o;
  wire [2:0] n3745_o;
  wire [2:0] n3747_o;
  wire [3:0] n3750_o;
  wire [3:0] n3753_o;
  wire [2:0] n3756_o;
  wire n3758_o;
  wire n3760_o;
  wire n3762_o;
  wire [3:0] n3763_o;
  reg [2:0] n3765_o;
  reg [2:0] n3767_o;
  reg n3771_o;
  reg [3:0] n3774_o;
  reg [3:0] n3777_o;
  reg [2:0] n3780_o;
  reg n3783_o;
  reg n3786_o;
  reg n3789_o;
  reg n3793_o;
  wire n3795_o;
  wire n3797_o;
  wire n3798_o;
  wire n3800_o;
  wire n3801_o;
  wire n3803_o;
  wire n3804_o;
  wire n3806_o;
  wire n3807_o;
  wire n3809_o;
  wire n3810_o;
  wire n3812_o;
  wire n3813_o;
  wire n3815_o;
  wire n3816_o;
  wire [30:0] n3817_o;
  wire n3819_o;
  wire n3821_o;
  wire n3823_o;
  wire [2:0] n3824_o;
  reg [3:0] n3828_o;
  reg [2:0] n3832_o;
  reg n3835_o;
  reg n3838_o;
  wire n3840_o;
  wire [30:0] n3842_o;
  wire [2:0] n3844_o;
  wire n3849_o;
  wire n3850_o;
  wire n3852_o;
  wire n3853_o;
  wire n3855_o;
  wire n3856_o;
  wire n3857_o;
  wire n3859_o;
  wire n3860_o;
  wire n3862_o;
  wire n3863_o;
  wire n3864_o;
  wire n3866_o;
  wire n3867_o;
  wire n3869_o;
  wire n3870_o;
  wire n3871_o;
  wire n3873_o;
  wire n3874_o;
  wire n3876_o;
  wire [7:0] n3877_o;
  reg n3879_o;
  wire [2:0] n3882_o;
  wire [2:0] n3885_o;
  wire n3887_o;
  wire n3889_o;
  wire n3891_o;
  wire [2:0] n3892_o;
  reg [2:0] n3894_o;
  reg [2:0] n3897_o;
  reg [3:0] n3901_o;
  reg [2:0] n3904_o;
  reg n3907_o;
  reg n3910_o;
  wire n3912_o;
  wire n3914_o;
  wire n3915_o;
  wire n3917_o;
  wire n3918_o;
  wire n3920_o;
  wire n3921_o;
  wire n3923_o;
  wire n3924_o;
  wire n3926_o;
  wire n3927_o;
  wire n3929_o;
  wire n3930_o;
  wire n3932_o;
  wire n3933_o;
  wire [30:0] n3934_o;
  wire n3936_o;
  wire n3938_o;
  wire n3940_o;
  wire [2:0] n3941_o;
  reg [2:0] n3943_o;
  reg [3:0] n3947_o;
  reg [3:0] n3951_o;
  reg [2:0] n3955_o;
  reg n3958_o;
  reg n3962_o;
  wire n3964_o;
  wire n3966_o;
  wire n3967_o;
  wire n3969_o;
  wire n3970_o;
  wire n3972_o;
  wire n3973_o;
  wire n3975_o;
  wire n3976_o;
  wire n3978_o;
  wire n3979_o;
  wire n3981_o;
  wire n3982_o;
  wire n3984_o;
  wire n3985_o;
  wire [30:0] n3986_o;
  wire n3988_o;
  wire n3990_o;
  wire [1:0] n3991_o;
  reg n3994_o;
  reg n3997_o;
  reg [2:0] n4000_o;
  reg n4003_o;
  wire n4005_o;
  wire [30:0] n4006_o;
  wire n4008_o;
  wire n4010_o;
  wire [1:0] n4011_o;
  reg n4014_o;
  reg [3:0] n4017_o;
  reg [2:0] n4020_o;
  reg n4023_o;
  reg n4026_o;
  wire n4028_o;
  wire n4030_o;
  wire n4032_o;
  wire n4034_o;
  wire n4036_o;
  wire n4037_o;
  wire [58:0] n4038_o;
  reg [2:0] n4071_o;
  reg [2:0] n4076_o;
  reg [1:0] n4082_o;
  reg n4085_o;
  reg n4088_o;
  wire [1:0] n4089_o;
  wire [1:0] n4090_o;
  wire [1:0] n4091_o;
  wire [1:0] n4092_o;
  wire [1:0] n4093_o;
  wire [1:0] n4094_o;
  wire [1:0] n4095_o;
  wire [1:0] n4096_o;
  wire [1:0] n4097_o;
  reg [1:0] n4100_o;
  wire [1:0] n4101_o;
  wire [1:0] n4102_o;
  wire [1:0] n4103_o;
  wire [1:0] n4104_o;
  wire [1:0] n4105_o;
  wire [1:0] n4106_o;
  wire [1:0] n4107_o;
  wire [1:0] n4108_o;
  wire [1:0] n4109_o;
  reg [1:0] n4112_o;
  reg n4121_o;
  reg n4124_o;
  wire [2:0] n4125_o;
  reg [2:0] n4128_o;
  wire n4129_o;
  reg n4132_o;
  wire n4133_o;
  wire n4134_o;
  wire n4135_o;
  wire n4136_o;
  wire n4137_o;
  wire n4138_o;
  wire n4139_o;
  wire n4140_o;
  wire n4141_o;
  wire n4142_o;
  wire n4143_o;
  wire n4144_o;
  wire n4146_o;
  wire n4148_o;
  wire n4149_o;
  wire n4150_o;
  wire n4151_o;
  wire n4152_o;
  wire n4153_o;
  wire n4154_o;
  reg n4157_o;
  wire [1:0] n4158_o;
  wire [1:0] n4159_o;
  wire [1:0] n4160_o;
  wire [1:0] n4161_o;
  wire [1:0] n4162_o;
  wire [1:0] n4163_o;
  wire [1:0] n4164_o;
  wire [1:0] n4165_o;
  wire [1:0] n4166_o;
  wire [1:0] n4167_o;
  wire [1:0] n4168_o;
  wire [1:0] n4169_o;
  wire [1:0] n4171_o;
  wire [1:0] n4173_o;
  wire [1:0] n4174_o;
  wire [1:0] n4175_o;
  wire [1:0] n4176_o;
  wire [1:0] n4177_o;
  wire [1:0] n4178_o;
  wire [1:0] n4179_o;
  reg [1:0] n4182_o;
  wire n4183_o;
  wire n4184_o;
  wire n4185_o;
  wire n4186_o;
  wire n4187_o;
  wire n4188_o;
  wire n4190_o;
  wire n4192_o;
  wire n4193_o;
  wire n4194_o;
  wire n4195_o;
  wire n4196_o;
  wire n4197_o;
  wire n4198_o;
  reg n4201_o;
  reg [3:0] n4207_o;
  reg n4215_o;
  reg n4220_o;
  reg n4223_o;
  reg [2:0] n4226_o;
  reg n4229_o;
  reg n4232_o;
  reg n4235_o;
  reg n4239_o;
  reg n4242_o;
  reg n4245_o;
  reg n4248_o;
  reg n4251_o;
  reg n4255_o;
  reg n4259_o;
  reg n4263_o;
  reg n4267_o;
  reg n4271_o;
  reg n4274_o;
  reg n4278_o;
  reg n4282_o;
  reg n4286_o;
  reg [1:0] n4289_o;
  reg n4293_o;
  reg n4297_o;
  reg n4301_o;
  reg n4304_o;
  reg n4307_o;
  wire n4309_o;
  wire [2:0] n4310_o;
  wire [2:0] n4311_o;
  wire n4313_o;
  wire n4315_o;
  wire n4318_o;
  wire [3:0] n4320_o;
  wire n4323_o;
  wire [30:0] n4324_o;
  wire n4326_o;
  wire n4328_o;
  wire n4329_o;
  wire n4331_o;
  wire n4333_o;
  wire [2:0] n4334_o;
  reg [2:0] n4336_o;
  reg n4339_o;
  reg [3:0] n4341_o;
  reg n4344_o;
  reg [2:0] n4348_o;
  reg n4351_o;
  wire [2:0] n4354_o;
  wire [2:0] n4355_o;
  wire n4356_o;
  wire [3:0] n4357_o;
  wire n4358_o;
  wire [2:0] n4360_o;
  wire n4362_o;
  wire n4365_o;
  wire n4367_o;
  wire n4369_o;
  wire n4370_o;
  wire n4372_o;
  wire n4373_o;
  wire n4375_o;
  wire n4376_o;
  wire n4378_o;
  wire n4379_o;
  wire n4381_o;
  wire n4382_o;
  wire n4384_o;
  wire n4385_o;
  wire n4387_o;
  wire n4388_o;
  wire n4390_o;
  wire n4391_o;
  wire n4393_o;
  wire n4394_o;
  wire n4396_o;
  wire n4397_o;
  wire n4399_o;
  wire n4400_o;
  wire n4402_o;
  wire n4403_o;
  wire n4405_o;
  wire n4406_o;
  wire n4408_o;
  wire n4409_o;
  wire n4411_o;
  wire n4412_o;
  wire n4414_o;
  wire n4415_o;
  wire n4417_o;
  wire n4418_o;
  wire n4420_o;
  wire n4421_o;
  wire n4423_o;
  wire n4424_o;
  wire n4426_o;
  wire n4427_o;
  wire n4429_o;
  wire n4430_o;
  wire n4432_o;
  wire n4433_o;
  wire n4435_o;
  wire n4436_o;
  wire n4438_o;
  wire n4439_o;
  wire n4441_o;
  wire n4442_o;
  wire n4444_o;
  wire n4445_o;
  wire n4447_o;
  wire n4448_o;
  wire n4450_o;
  wire n4451_o;
  wire n4453_o;
  wire n4454_o;
  wire n4456_o;
  wire n4457_o;
  wire n4459_o;
  wire n4460_o;
  wire n4462_o;
  wire n4463_o;
  wire n4465_o;
  wire n4466_o;
  wire n4468_o;
  wire n4469_o;
  wire n4471_o;
  wire n4472_o;
  wire n4474_o;
  wire n4475_o;
  wire n4477_o;
  wire n4478_o;
  wire n4480_o;
  wire n4481_o;
  wire n4483_o;
  wire n4484_o;
  wire n4486_o;
  wire n4487_o;
  wire n4489_o;
  wire n4490_o;
  wire n4492_o;
  wire n4493_o;
  wire n4495_o;
  wire n4496_o;
  wire n4498_o;
  wire n4499_o;
  wire n4501_o;
  wire n4502_o;
  wire n4504_o;
  wire n4505_o;
  wire n4507_o;
  wire n4508_o;
  wire n4510_o;
  wire n4511_o;
  wire n4513_o;
  wire n4514_o;
  wire n4516_o;
  wire n4517_o;
  wire n4519_o;
  wire n4520_o;
  wire n4522_o;
  wire n4523_o;
  wire n4525_o;
  wire n4526_o;
  wire n4528_o;
  wire n4529_o;
  wire n4531_o;
  wire n4532_o;
  wire [30:0] n4533_o;
  wire n4535_o;
  wire n4537_o;
  wire n4538_o;
  wire n4540_o;
  wire n4542_o;
  wire [2:0] n4543_o;
  reg [2:0] n4545_o;
  reg n4548_o;
  reg [3:0] n4550_o;
  reg n4553_o;
  reg [2:0] n4557_o;
  reg n4560_o;
  wire n4562_o;
  wire n4564_o;
  wire n4565_o;
  wire n4567_o;
  wire n4568_o;
  wire n4570_o;
  wire n4571_o;
  wire n4573_o;
  wire n4574_o;
  wire n4576_o;
  wire n4577_o;
  wire n4579_o;
  wire n4580_o;
  wire n4582_o;
  wire n4583_o;
  wire n4585_o;
  wire n4587_o;
  wire [2:0] n4588_o;
  wire [2:0] n4589_o;
  wire [3:0] n4591_o;
  wire [30:0] n4592_o;
  wire n4594_o;
  wire n4596_o;
  wire n4597_o;
  wire n4599_o;
  wire [1:0] n4600_o;
  reg [2:0] n4602_o;
  reg [3:0] n4604_o;
  reg [2:0] n4607_o;
  wire [2:0] n4610_o;
  wire [2:0] n4611_o;
  wire n4612_o;
  wire [3:0] n4613_o;
  wire [2:0] n4615_o;
  wire n4618_o;
  wire n4620_o;
  wire n4622_o;
  wire n4623_o;
  wire n4625_o;
  wire n4626_o;
  wire n4628_o;
  wire n4629_o;
  wire n4631_o;
  wire n4632_o;
  wire n4634_o;
  wire n4635_o;
  wire n4637_o;
  wire n4638_o;
  wire n4640_o;
  wire n4641_o;
  wire n4643_o;
  wire n4644_o;
  wire n4646_o;
  wire n4647_o;
  wire n4649_o;
  wire n4650_o;
  wire n4652_o;
  wire n4653_o;
  wire n4655_o;
  wire n4656_o;
  wire n4658_o;
  wire n4659_o;
  wire n4661_o;
  wire n4662_o;
  wire n4664_o;
  wire n4665_o;
  wire n4667_o;
  wire n4668_o;
  wire n4670_o;
  wire n4671_o;
  wire n4673_o;
  wire n4674_o;
  wire n4676_o;
  wire n4677_o;
  wire n4679_o;
  wire n4680_o;
  wire n4682_o;
  wire n4683_o;
  wire n4685_o;
  wire n4686_o;
  wire n4688_o;
  wire n4689_o;
  wire n4691_o;
  wire n4692_o;
  wire n4694_o;
  wire n4695_o;
  wire n4697_o;
  wire n4698_o;
  wire n4700_o;
  wire n4701_o;
  wire n4703_o;
  wire n4704_o;
  wire n4706_o;
  wire n4707_o;
  wire n4709_o;
  wire n4710_o;
  wire n4712_o;
  wire n4713_o;
  wire n4715_o;
  wire n4716_o;
  wire n4718_o;
  wire n4719_o;
  wire n4721_o;
  wire n4722_o;
  wire n4724_o;
  wire n4725_o;
  wire n4727_o;
  wire n4728_o;
  wire n4730_o;
  wire n4731_o;
  wire n4733_o;
  wire n4734_o;
  wire n4736_o;
  wire n4737_o;
  wire n4739_o;
  wire n4740_o;
  wire n4742_o;
  wire n4743_o;
  wire n4745_o;
  wire n4746_o;
  wire n4748_o;
  wire n4749_o;
  wire n4751_o;
  wire n4752_o;
  wire n4754_o;
  wire n4755_o;
  wire n4757_o;
  wire n4758_o;
  wire n4760_o;
  wire n4761_o;
  wire n4763_o;
  wire n4764_o;
  wire n4766_o;
  wire n4767_o;
  wire n4769_o;
  wire n4770_o;
  wire n4772_o;
  wire n4773_o;
  wire n4775_o;
  wire n4776_o;
  wire n4778_o;
  wire n4779_o;
  wire n4781_o;
  wire n4782_o;
  wire n4784_o;
  wire n4785_o;
  wire [30:0] n4786_o;
  wire n4788_o;
  wire n4790_o;
  wire n4791_o;
  wire n4793_o;
  wire [1:0] n4794_o;
  reg [2:0] n4796_o;
  reg [3:0] n4798_o;
  reg [2:0] n4801_o;
  wire n4803_o;
  wire n4805_o;
  wire n4806_o;
  wire n4808_o;
  wire n4809_o;
  wire n4811_o;
  wire n4812_o;
  wire n4814_o;
  wire n4815_o;
  wire n4817_o;
  wire n4818_o;
  wire n4820_o;
  wire n4821_o;
  wire n4823_o;
  wire n4824_o;
  wire n4826_o;
  wire n4828_o;
  wire n4831_o;
  wire [3:0] n4833_o;
  wire n4836_o;
  wire [30:0] n4837_o;
  wire n4839_o;
  wire n4841_o;
  wire n4842_o;
  wire n4844_o;
  wire n4846_o;
  wire [2:0] n4847_o;
  reg [2:0] n4849_o;
  reg n4852_o;
  reg [3:0] n4854_o;
  reg n4857_o;
  reg [2:0] n4861_o;
  reg n4864_o;
  wire [2:0] n4867_o;
  wire [2:0] n4868_o;
  wire n4869_o;
  wire [3:0] n4870_o;
  wire n4871_o;
  wire [2:0] n4873_o;
  wire n4875_o;
  wire n4878_o;
  wire n4880_o;
  wire n4882_o;
  wire n4883_o;
  wire n4885_o;
  wire n4886_o;
  wire n4888_o;
  wire n4889_o;
  wire n4891_o;
  wire n4892_o;
  wire n4894_o;
  wire n4895_o;
  wire n4897_o;
  wire n4898_o;
  wire n4900_o;
  wire n4901_o;
  wire n4903_o;
  wire n4904_o;
  wire n4906_o;
  wire n4907_o;
  wire n4909_o;
  wire n4910_o;
  wire n4912_o;
  wire n4913_o;
  wire n4915_o;
  wire n4916_o;
  wire n4918_o;
  wire n4919_o;
  wire n4921_o;
  wire n4922_o;
  wire n4924_o;
  wire n4925_o;
  wire n4927_o;
  wire n4928_o;
  wire n4930_o;
  wire n4931_o;
  wire n4933_o;
  wire n4934_o;
  wire n4936_o;
  wire n4937_o;
  wire n4939_o;
  wire n4940_o;
  wire n4942_o;
  wire n4943_o;
  wire n4945_o;
  wire n4946_o;
  wire n4948_o;
  wire n4949_o;
  wire n4951_o;
  wire n4952_o;
  wire n4954_o;
  wire n4955_o;
  wire n4957_o;
  wire n4958_o;
  wire n4960_o;
  wire n4961_o;
  wire n4963_o;
  wire n4964_o;
  wire n4966_o;
  wire n4967_o;
  wire n4969_o;
  wire n4970_o;
  wire n4972_o;
  wire n4973_o;
  wire n4975_o;
  wire n4976_o;
  wire n4978_o;
  wire n4979_o;
  wire n4981_o;
  wire n4982_o;
  wire n4984_o;
  wire n4985_o;
  wire n4987_o;
  wire n4988_o;
  wire n4990_o;
  wire n4991_o;
  wire n4993_o;
  wire n4994_o;
  wire n4996_o;
  wire n4997_o;
  wire n4999_o;
  wire n5000_o;
  wire n5002_o;
  wire n5003_o;
  wire n5005_o;
  wire n5006_o;
  wire n5008_o;
  wire n5009_o;
  wire n5011_o;
  wire n5012_o;
  wire n5014_o;
  wire n5015_o;
  wire n5017_o;
  wire n5018_o;
  wire n5020_o;
  wire n5021_o;
  wire n5023_o;
  wire n5024_o;
  wire n5026_o;
  wire n5027_o;
  wire n5029_o;
  wire n5030_o;
  wire n5032_o;
  wire n5033_o;
  wire n5035_o;
  wire n5036_o;
  wire n5038_o;
  wire n5039_o;
  wire n5041_o;
  wire n5042_o;
  wire n5044_o;
  wire n5045_o;
  wire [30:0] n5046_o;
  wire n5048_o;
  wire n5050_o;
  wire n5051_o;
  wire n5053_o;
  wire n5055_o;
  wire [2:0] n5056_o;
  reg [2:0] n5058_o;
  reg n5061_o;
  reg [3:0] n5063_o;
  reg n5066_o;
  reg [2:0] n5070_o;
  reg n5073_o;
  wire n5075_o;
  wire n5077_o;
  wire n5078_o;
  wire n5080_o;
  wire n5081_o;
  wire n5083_o;
  wire n5084_o;
  wire n5086_o;
  wire n5087_o;
  wire n5089_o;
  wire n5090_o;
  wire n5092_o;
  wire n5093_o;
  wire n5095_o;
  wire n5096_o;
  wire n5098_o;
  wire n5100_o;
  wire n5103_o;
  wire [3:0] n5105_o;
  wire n5108_o;
  wire [30:0] n5109_o;
  wire n5111_o;
  wire n5113_o;
  wire n5114_o;
  wire n5116_o;
  wire n5118_o;
  wire [2:0] n5119_o;
  reg [2:0] n5121_o;
  reg n5124_o;
  reg [3:0] n5126_o;
  reg n5129_o;
  reg [2:0] n5133_o;
  reg n5136_o;
  wire [2:0] n5139_o;
  wire [2:0] n5140_o;
  wire n5141_o;
  wire [3:0] n5142_o;
  wire n5143_o;
  wire [2:0] n5145_o;
  wire n5147_o;
  wire n5150_o;
  wire n5152_o;
  wire n5154_o;
  wire n5155_o;
  wire n5157_o;
  wire n5158_o;
  wire n5160_o;
  wire n5161_o;
  wire n5163_o;
  wire n5164_o;
  wire n5166_o;
  wire n5167_o;
  wire n5169_o;
  wire n5170_o;
  wire n5172_o;
  wire n5173_o;
  wire n5175_o;
  wire n5176_o;
  wire n5178_o;
  wire n5179_o;
  wire n5181_o;
  wire n5182_o;
  wire n5184_o;
  wire n5185_o;
  wire n5187_o;
  wire n5188_o;
  wire n5190_o;
  wire n5191_o;
  wire n5193_o;
  wire n5194_o;
  wire n5196_o;
  wire n5197_o;
  wire n5199_o;
  wire n5200_o;
  wire n5202_o;
  wire n5203_o;
  wire n5205_o;
  wire n5206_o;
  wire n5208_o;
  wire n5209_o;
  wire n5211_o;
  wire n5212_o;
  wire n5214_o;
  wire n5215_o;
  wire n5217_o;
  wire n5218_o;
  wire n5220_o;
  wire n5221_o;
  wire n5223_o;
  wire n5224_o;
  wire n5226_o;
  wire n5227_o;
  wire n5229_o;
  wire n5230_o;
  wire n5232_o;
  wire n5233_o;
  wire n5235_o;
  wire n5236_o;
  wire n5238_o;
  wire n5239_o;
  wire n5241_o;
  wire n5242_o;
  wire n5244_o;
  wire n5245_o;
  wire n5247_o;
  wire n5248_o;
  wire n5250_o;
  wire n5251_o;
  wire n5253_o;
  wire n5254_o;
  wire n5256_o;
  wire n5257_o;
  wire n5259_o;
  wire n5260_o;
  wire n5262_o;
  wire n5263_o;
  wire n5265_o;
  wire n5266_o;
  wire n5268_o;
  wire n5269_o;
  wire n5271_o;
  wire n5272_o;
  wire n5274_o;
  wire n5275_o;
  wire n5277_o;
  wire n5278_o;
  wire n5280_o;
  wire n5281_o;
  wire n5283_o;
  wire n5284_o;
  wire n5286_o;
  wire n5287_o;
  wire n5289_o;
  wire n5290_o;
  wire n5292_o;
  wire n5293_o;
  wire n5295_o;
  wire n5296_o;
  wire n5298_o;
  wire n5299_o;
  wire n5301_o;
  wire n5302_o;
  wire n5304_o;
  wire n5305_o;
  wire n5307_o;
  wire n5308_o;
  wire n5310_o;
  wire n5311_o;
  wire n5313_o;
  wire n5314_o;
  wire n5316_o;
  wire n5317_o;
  wire [30:0] n5318_o;
  wire n5320_o;
  wire n5322_o;
  wire n5323_o;
  wire n5325_o;
  wire n5327_o;
  wire [2:0] n5328_o;
  reg [2:0] n5330_o;
  reg n5333_o;
  reg [3:0] n5335_o;
  reg n5338_o;
  reg [2:0] n5342_o;
  reg n5345_o;
  wire n5347_o;
  wire n5349_o;
  wire n5350_o;
  wire n5352_o;
  wire n5353_o;
  wire n5355_o;
  wire n5356_o;
  wire n5358_o;
  wire n5359_o;
  wire n5361_o;
  wire n5362_o;
  wire n5364_o;
  wire n5365_o;
  wire n5367_o;
  wire n5368_o;
  wire [7:0] n5369_o;
  reg [2:0] n5375_o;
  reg [2:0] n5377_o;
  reg n5380_o;
  reg [2:0] n5382_o;
  reg [3:0] n5384_o;
  reg n5387_o;
  reg [2:0] n5389_o;
  reg n5392_o;
  reg n5395_o;
  wire n5397_o;
  wire n5399_o;
  wire n5401_o;
  wire n5402_o;
  wire n5404_o;
  wire n5405_o;
  wire n5407_o;
  wire n5408_o;
  wire n5410_o;
  wire n5411_o;
  wire n5413_o;
  wire n5414_o;
  wire n5416_o;
  wire n5417_o;
  wire n5419_o;
  wire n5420_o;
  wire n5422_o;
  wire n5423_o;
  wire n5425_o;
  wire n5426_o;
  wire n5428_o;
  wire n5429_o;
  wire n5431_o;
  wire n5432_o;
  wire n5434_o;
  wire n5435_o;
  wire n5437_o;
  wire n5438_o;
  wire n5440_o;
  wire n5441_o;
  wire n5443_o;
  wire n5444_o;
  wire n5446_o;
  wire n5447_o;
  wire n5449_o;
  wire n5450_o;
  wire n5452_o;
  wire n5453_o;
  wire n5455_o;
  wire n5456_o;
  wire n5458_o;
  wire n5459_o;
  wire n5461_o;
  wire n5462_o;
  wire n5464_o;
  wire n5465_o;
  wire n5467_o;
  wire n5468_o;
  wire n5470_o;
  wire n5471_o;
  wire n5473_o;
  wire n5474_o;
  wire n5476_o;
  wire n5477_o;
  wire n5479_o;
  wire n5480_o;
  wire n5482_o;
  wire n5483_o;
  wire n5485_o;
  wire n5486_o;
  wire n5488_o;
  wire n5489_o;
  wire n5491_o;
  wire n5492_o;
  wire n5494_o;
  wire n5495_o;
  wire n5497_o;
  wire n5498_o;
  wire n5500_o;
  wire n5501_o;
  wire n5503_o;
  wire n5504_o;
  wire n5506_o;
  wire n5507_o;
  wire n5509_o;
  wire n5510_o;
  wire n5512_o;
  wire n5513_o;
  wire n5515_o;
  wire n5516_o;
  wire n5518_o;
  wire n5519_o;
  wire n5521_o;
  wire n5522_o;
  wire n5524_o;
  wire n5525_o;
  wire n5527_o;
  wire n5528_o;
  wire n5530_o;
  wire n5531_o;
  wire n5533_o;
  wire n5534_o;
  wire n5536_o;
  wire n5537_o;
  wire n5539_o;
  wire n5540_o;
  wire n5542_o;
  wire n5543_o;
  wire n5545_o;
  wire n5546_o;
  wire n5548_o;
  wire n5549_o;
  wire n5551_o;
  wire n5552_o;
  wire n5554_o;
  wire n5555_o;
  wire n5557_o;
  wire n5558_o;
  wire n5560_o;
  wire n5561_o;
  wire n5563_o;
  wire n5564_o;
  wire n5566_o;
  wire n5567_o;
  wire n5569_o;
  wire n5570_o;
  wire n5572_o;
  wire n5573_o;
  wire n5575_o;
  wire n5576_o;
  wire n5578_o;
  wire n5579_o;
  wire n5581_o;
  wire n5582_o;
  wire n5584_o;
  wire n5585_o;
  wire n5587_o;
  wire n5588_o;
  wire n5590_o;
  wire n5591_o;
  wire n5593_o;
  wire n5594_o;
  wire n5596_o;
  wire n5597_o;
  wire n5599_o;
  wire n5600_o;
  wire n5602_o;
  wire n5603_o;
  wire n5605_o;
  wire n5606_o;
  wire n5608_o;
  wire n5609_o;
  wire n5611_o;
  wire n5612_o;
  wire n5614_o;
  wire n5615_o;
  wire n5617_o;
  wire n5618_o;
  wire n5620_o;
  wire n5621_o;
  wire n5623_o;
  wire n5624_o;
  wire n5626_o;
  wire n5627_o;
  wire n5629_o;
  wire n5630_o;
  wire n5632_o;
  wire n5633_o;
  wire n5635_o;
  wire n5636_o;
  wire n5638_o;
  wire n5639_o;
  wire n5641_o;
  wire n5642_o;
  wire n5644_o;
  wire n5645_o;
  wire n5647_o;
  wire n5648_o;
  wire n5650_o;
  wire n5651_o;
  wire n5653_o;
  wire n5654_o;
  wire n5656_o;
  wire n5657_o;
  wire n5659_o;
  wire n5660_o;
  wire n5662_o;
  wire n5663_o;
  wire n5665_o;
  wire n5666_o;
  wire n5668_o;
  wire n5669_o;
  wire n5671_o;
  wire n5672_o;
  wire n5674_o;
  wire n5675_o;
  wire n5677_o;
  wire n5678_o;
  wire n5680_o;
  wire n5681_o;
  wire n5683_o;
  wire n5684_o;
  wire n5686_o;
  wire n5687_o;
  wire n5689_o;
  wire n5690_o;
  wire n5692_o;
  wire n5693_o;
  wire n5695_o;
  wire n5696_o;
  wire n5698_o;
  wire n5699_o;
  wire n5701_o;
  wire n5702_o;
  wire n5704_o;
  wire n5705_o;
  wire n5707_o;
  wire n5708_o;
  wire n5710_o;
  wire n5711_o;
  wire n5713_o;
  wire n5714_o;
  wire n5716_o;
  wire n5717_o;
  wire n5719_o;
  wire n5720_o;
  wire n5722_o;
  wire n5723_o;
  wire n5725_o;
  wire n5726_o;
  wire n5728_o;
  wire n5729_o;
  wire n5731_o;
  wire n5732_o;
  wire n5734_o;
  wire n5735_o;
  wire n5737_o;
  wire n5738_o;
  wire n5740_o;
  wire n5741_o;
  wire n5743_o;
  wire n5744_o;
  wire n5746_o;
  wire n5747_o;
  wire n5749_o;
  wire n5750_o;
  wire n5752_o;
  wire n5753_o;
  wire n5755_o;
  wire n5756_o;
  wire n5758_o;
  wire n5759_o;
  wire n5761_o;
  wire n5762_o;
  wire n5764_o;
  wire n5765_o;
  wire n5767_o;
  wire n5768_o;
  wire n5770_o;
  wire n5771_o;
  wire n5773_o;
  wire n5774_o;
  wire n5776_o;
  wire n5777_o;
  wire n5779_o;
  wire n5780_o;
  wire n5782_o;
  wire n5783_o;
  wire n5785_o;
  wire n5786_o;
  wire n5788_o;
  wire n5789_o;
  wire n5791_o;
  wire n5792_o;
  wire n5794_o;
  wire n5795_o;
  wire n5797_o;
  wire n5798_o;
  wire n5800_o;
  wire n5801_o;
  wire n5803_o;
  wire n5804_o;
  wire n5806_o;
  wire n5807_o;
  wire n5809_o;
  wire n5810_o;
  wire n5812_o;
  wire n5813_o;
  wire n5815_o;
  wire n5816_o;
  wire n5818_o;
  wire n5819_o;
  wire n5821_o;
  wire n5822_o;
  wire n5824_o;
  wire n5825_o;
  wire n5827_o;
  wire n5828_o;
  wire n5830_o;
  wire n5831_o;
  wire n5833_o;
  wire n5834_o;
  wire n5836_o;
  wire n5837_o;
  wire n5839_o;
  wire n5840_o;
  wire n5842_o;
  wire n5843_o;
  wire n5845_o;
  wire n5846_o;
  wire n5848_o;
  wire n5849_o;
  wire n5851_o;
  wire n5852_o;
  wire n5854_o;
  wire n5855_o;
  wire n5857_o;
  wire n5858_o;
  wire n5860_o;
  wire n5861_o;
  wire n5863_o;
  wire n5864_o;
  wire n5866_o;
  wire n5867_o;
  wire n5869_o;
  wire n5870_o;
  wire n5872_o;
  wire n5873_o;
  wire n5875_o;
  wire n5876_o;
  wire n5878_o;
  wire n5879_o;
  wire n5881_o;
  wire n5882_o;
  wire n5884_o;
  wire n5885_o;
  wire n5887_o;
  wire n5888_o;
  wire n5890_o;
  wire n5891_o;
  wire n5893_o;
  wire n5894_o;
  wire n5896_o;
  wire n5897_o;
  wire n5899_o;
  wire n5900_o;
  wire n5902_o;
  wire n5903_o;
  wire n5905_o;
  wire n5906_o;
  wire n5908_o;
  wire n5909_o;
  wire n5911_o;
  wire n5912_o;
  wire n5914_o;
  wire n5915_o;
  wire n5917_o;
  wire n5918_o;
  wire n5920_o;
  wire n5921_o;
  wire n5923_o;
  wire n5924_o;
  wire n5926_o;
  wire n5928_o;
  wire n5929_o;
  wire n5931_o;
  wire n5933_o;
  wire n5935_o;
  wire n5937_o;
  wire [30:0] n5938_o;
  wire n5940_o;
  wire n5942_o;
  wire [1:0] n5943_o;
  wire n5945_o;
  wire [1:0] n5946_o;
  wire [2:0] n5948_o;
  wire [2:0] n5950_o;
  wire n5953_o;
  wire n5955_o;
  wire [1:0] n5956_o;
  wire n5958_o;
  wire [1:0] n5959_o;
  wire [2:0] n5961_o;
  wire [2:0] n5963_o;
  wire n5966_o;
  wire n5968_o;
  wire [3:0] n5969_o;
  reg n5973_o;
  reg n5976_o;
  reg n5980_o;
  reg [2:0] n5982_o;
  reg n5984_o;
  reg [2:0] n5988_o;
  reg n5991_o;
  reg n5994_o;
  wire n5996_o;
  wire n5998_o;
  wire n5999_o;
  wire n6001_o;
  wire n6002_o;
  wire n6004_o;
  wire n6005_o;
  wire [30:0] n6006_o;
  wire n6008_o;
  wire [1:0] n6009_o;
  wire n6011_o;
  wire [1:0] n6012_o;
  wire [3:0] n6015_o;
  wire [3:0] n6017_o;
  wire n6019_o;
  wire [1:0] n6020_o;
  wire n6022_o;
  wire [1:0] n6023_o;
  wire [3:0] n6026_o;
  wire [3:0] n6028_o;
  wire n6030_o;
  wire n6032_o;
  wire [3:0] n6033_o;
  reg n6037_o;
  reg n6040_o;
  reg [3:0] n6042_o;
  reg [2:0] n6046_o;
  reg n6049_o;
  reg n6052_o;
  reg n6056_o;
  wire n6058_o;
  wire n6060_o;
  wire n6061_o;
  wire n6063_o;
  wire n6064_o;
  wire n6066_o;
  wire n6067_o;
  wire [30:0] n6068_o;
  wire n6070_o;
  wire n6072_o;
  wire n6073_o;
  wire [3:0] n6076_o;
  wire n6078_o;
  wire n6079_o;
  wire n6080_o;
  wire [3:0] n6083_o;
  wire n6085_o;
  wire n6087_o;
  wire [3:0] n6088_o;
  reg [2:0] n6091_o;
  reg [3:0] n6094_o;
  reg [2:0] n6096_o;
  reg [3:0] n6099_o;
  reg [3:0] n6101_o;
  reg [2:0] n6105_o;
  reg n6108_o;
  reg n6111_o;
  reg n6114_o;
  wire n6116_o;
  wire n6118_o;
  wire n6119_o;
  wire n6121_o;
  wire n6122_o;
  wire n6124_o;
  wire n6125_o;
  wire [30:0] n6126_o;
  wire n6128_o;
  wire n6130_o;
  wire n6131_o;
  wire [3:0] n6134_o;
  wire n6136_o;
  wire n6138_o;
  wire n6140_o;
  wire [3:0] n6141_o;
  reg [2:0] n6144_o;
  reg [3:0] n6147_o;
  reg [2:0] n6149_o;
  reg [3:0] n6152_o;
  reg [3:0] n6154_o;
  reg n6157_o;
  reg n6160_o;
  reg [2:0] n6163_o;
  reg n6166_o;
  reg n6170_o;
  wire n6172_o;
  wire n6174_o;
  wire n6175_o;
  wire n6177_o;
  wire n6178_o;
  wire n6180_o;
  wire n6181_o;
  wire n6183_o;
  wire n6185_o;
  wire n6186_o;
  wire n6188_o;
  wire n6189_o;
  wire n6191_o;
  wire n6192_o;
  wire n6194_o;
  wire n6195_o;
  wire n6197_o;
  wire n6198_o;
  wire n6200_o;
  wire n6201_o;
  wire n6203_o;
  wire n6204_o;
  wire n6206_o;
  wire n6208_o;
  wire n6209_o;
  wire n6211_o;
  wire n6212_o;
  wire n6214_o;
  wire n6215_o;
  wire n6217_o;
  wire n6219_o;
  wire n6220_o;
  wire n6222_o;
  wire n6224_o;
  wire n6225_o;
  wire [30:0] n6226_o;
  wire [1:0] n6228_o;
  wire [30:0] n6229_o;
  wire [1:0] n6230_o;
  wire n6233_o;
  wire n6235_o;
  wire n6236_o;
  wire n6238_o;
  wire n6239_o;
  reg n6241_o;
  reg [1:0] n6243_o;
  reg n6246_o;
  wire n6248_o;
  wire [1:0] n6250_o;
  wire [30:0] n6251_o;
  wire [1:0] n6252_o;
  wire n6255_o;
  wire n6257_o;
  wire n6258_o;
  wire n6260_o;
  wire n6261_o;
  reg n6263_o;
  reg [1:0] n6265_o;
  reg n6268_o;
  wire n6270_o;
  wire [1:0] n6271_o;
  reg [2:0] n6273_o;
  reg n6277_o;
  reg [2:0] n6279_o;
  reg n6281_o;
  reg [1:0] n6283_o;
  reg n6285_o;
  reg [3:0] n6288_o;
  reg n6292_o;
  reg [1:0] n6295_o;
  reg n6299_o;
  wire n6301_o;
  wire n6303_o;
  wire n6304_o;
  wire n6306_o;
  wire n6307_o;
  wire n6309_o;
  wire n6310_o;
  wire [30:0] n6311_o;
  wire [1:0] n6313_o;
  wire [30:0] n6314_o;
  wire [1:0] n6315_o;
  wire n6318_o;
  wire n6320_o;
  wire n6321_o;
  wire n6323_o;
  wire n6324_o;
  reg n6326_o;
  reg [1:0] n6328_o;
  reg n6331_o;
  wire n6333_o;
  wire [1:0] n6335_o;
  wire [30:0] n6336_o;
  wire [1:0] n6337_o;
  wire n6339_o;
  wire n6341_o;
  wire n6342_o;
  wire n6344_o;
  wire n6345_o;
  reg n6348_o;
  reg [1:0] n6350_o;
  reg n6353_o;
  wire n6355_o;
  wire [1:0] n6356_o;
  reg [2:0] n6358_o;
  reg n6362_o;
  reg [2:0] n6364_o;
  reg n6366_o;
  reg [1:0] n6368_o;
  reg n6370_o;
  reg [3:0] n6373_o;
  reg n6377_o;
  reg [1:0] n6380_o;
  reg n6384_o;
  wire n6386_o;
  wire n6388_o;
  wire n6389_o;
  wire n6391_o;
  wire n6392_o;
  wire n6394_o;
  wire n6395_o;
  wire [30:0] n6396_o;
  wire n6398_o;
  wire n6402_o;
  wire n6404_o;
  wire n6406_o;
  wire [3:0] n6407_o;
  reg [2:0] n6409_o;
  reg n6412_o;
  reg [2:0] n6414_o;
  reg [2:0] n6416_o;
  reg [3:0] n6418_o;
  reg n6421_o;
  reg [2:0] n6425_o;
  reg n6428_o;
  reg n6431_o;
  reg n6434_o;
  wire n6436_o;
  wire [30:0] n6437_o;
  wire n6439_o;
  wire n6443_o;
  wire n6445_o;
  wire n6447_o;
  wire [3:0] n6448_o;
  reg [2:0] n6450_o;
  reg n6453_o;
  reg [2:0] n6455_o;
  reg [2:0] n6457_o;
  reg [3:0] n6459_o;
  reg n6462_o;
  reg [2:0] n6466_o;
  reg n6469_o;
  reg n6472_o;
  reg n6475_o;
  wire n6477_o;
  wire [30:0] n6478_o;
  wire n6480_o;
  wire n6482_o;
  wire n6484_o;
  wire [2:0] n6485_o;
  reg [3:0] n6489_o;
  reg [2:0] n6493_o;
  reg n6496_o;
  reg n6499_o;
  reg n6502_o;
  reg n6505_o;
  wire n6507_o;
  wire n6509_o;
  wire n6510_o;
  wire n6512_o;
  wire n6513_o;
  wire n6515_o;
  wire n6516_o;
  wire n6518_o;
  wire n6519_o;
  wire n6521_o;
  wire n6522_o;
  wire n6524_o;
  wire n6525_o;
  wire n6527_o;
  wire n6528_o;
  wire [30:0] n6529_o;
  wire n6531_o;
  wire [2:0] n6532_o;
  wire n6534_o;
  wire [2:0] n6535_o;
  wire n6538_o;
  wire [2:0] n6540_o;
  wire n6542_o;
  wire [1:0] n6543_o;
  reg n6545_o;
  reg [2:0] n6547_o;
  reg [2:0] n6550_o;
  reg n6553_o;
  reg n6556_o;
  reg [1:0] n6559_o;
  wire n6561_o;
  wire n6563_o;
  wire n6564_o;
  wire n6566_o;
  wire n6567_o;
  wire n6569_o;
  wire n6570_o;
  wire n6572_o;
  wire n6573_o;
  wire n6575_o;
  wire n6576_o;
  wire n6578_o;
  wire n6579_o;
  wire n6581_o;
  wire n6582_o;
  wire [30:0] n6583_o;
  wire [2:0] n6584_o;
  wire [2:0] n6585_o;
  wire n6587_o;
  wire n6590_o;
  wire n6592_o;
  wire n6594_o;
  wire [1:0] n6595_o;
  reg [2:0] n6597_o;
  reg n6599_o;
  reg [2:0] n6602_o;
  reg n6605_o;
  reg [1:0] n6608_o;
  reg n6611_o;
  wire n6613_o;
  wire n6615_o;
  wire n6616_o;
  wire n6618_o;
  wire n6619_o;
  wire n6621_o;
  wire n6622_o;
  wire n6624_o;
  wire n6625_o;
  wire n6627_o;
  wire n6628_o;
  wire n6630_o;
  wire n6631_o;
  wire n6633_o;
  wire n6634_o;
  wire [30:0] n6635_o;
  wire n6636_o;
  wire n6638_o;
  wire n6640_o;
  wire n6641_o;
  wire n6642_o;
  wire [3:0] n6645_o;
  wire n6647_o;
  wire n6649_o;
  wire [3:0] n6650_o;
  reg [2:0] n6653_o;
  wire [2:0] n6654_o;
  reg [2:0] n6656_o;
  wire n6657_o;
  reg n6659_o;
  reg n6662_o;
  reg [3:0] n6665_o;
  reg [3:0] n6669_o;
  reg [3:0] n6671_o;
  reg n6674_o;
  reg [2:0] n6678_o;
  reg n6681_o;
  reg n6684_o;
  reg [1:0] n6687_o;
  reg n6690_o;
  reg n6693_o;
  wire n6695_o;
  wire n6697_o;
  wire n6698_o;
  wire n6700_o;
  wire n6701_o;
  wire n6703_o;
  wire n6704_o;
  wire [30:0] n6705_o;
  wire n6707_o;
  wire n6708_o;
  wire n6710_o;
  wire n6711_o;
  wire n6712_o;
  wire [3:0] n6715_o;
  wire n6717_o;
  wire n6719_o;
  wire [3:0] n6720_o;
  reg [2:0] n6723_o;
  wire [2:0] n6724_o;
  reg [2:0] n6726_o;
  wire n6727_o;
  reg n6729_o;
  reg n6732_o;
  reg [3:0] n6735_o;
  reg [3:0] n6739_o;
  reg [3:0] n6741_o;
  reg n6744_o;
  reg [2:0] n6748_o;
  reg n6751_o;
  reg n6754_o;
  reg [1:0] n6757_o;
  reg n6760_o;
  reg n6763_o;
  wire n6765_o;
  wire n6767_o;
  wire n6768_o;
  wire n6770_o;
  wire n6771_o;
  wire n6773_o;
  wire n6774_o;
  wire [22:0] n6775_o;
  reg [2:0] n6791_o;
  reg [2:0] n6797_o;
  reg n6800_o;
  reg n6803_o;
  wire [2:0] n6804_o;
  wire [2:0] n6805_o;
  wire [2:0] n6806_o;
  reg [2:0] n6809_o;
  wire n6810_o;
  wire n6811_o;
  wire n6812_o;
  reg n6815_o;
  reg n6818_o;
  reg n6822_o;
  wire [2:0] n6824_o;
  wire [2:0] n6825_o;
  reg [2:0] n6828_o;
  wire n6830_o;
  wire n6831_o;
  reg n6834_o;
  wire n6835_o;
  wire n6836_o;
  wire n6837_o;
  wire n6839_o;
  wire n6840_o;
  wire n6841_o;
  wire n6842_o;
  wire n6843_o;
  reg n6846_o;
  wire [1:0] n6847_o;
  wire [1:0] n6848_o;
  wire [1:0] n6849_o;
  wire [1:0] n6851_o;
  wire [1:0] n6852_o;
  wire [1:0] n6853_o;
  wire [1:0] n6854_o;
  wire [1:0] n6855_o;
  reg [1:0] n6858_o;
  wire n6859_o;
  wire n6860_o;
  wire n6861_o;
  wire n6863_o;
  wire n6864_o;
  reg n6867_o;
  reg [3:0] n6870_o;
  reg n6874_o;
  reg n6877_o;
  reg [2:0] n6880_o;
  reg n6883_o;
  reg n6886_o;
  reg n6889_o;
  reg n6892_o;
  reg [2:0] n6899_o;
  reg n6902_o;
  reg n6905_o;
  reg n6908_o;
  reg n6911_o;
  reg n6914_o;
  reg n6917_o;
  reg n6920_o;
  reg [1:0] n6923_o;
  reg [1:0] n6929_o;
  reg n6932_o;
  reg n6935_o;
  wire [1:0] n6936_o;
  reg [2:0] n6937_o;
  reg [2:0] n6939_o;
  reg [1:0] n6941_o;
  reg n6944_o;
  reg n6947_o;
  wire [1:0] n6949_o;
  reg [1:0] n6951_o;
  wire n6952_o;
  wire n6953_o;
  reg n6955_o;
  wire n6956_o;
  reg n6958_o;
  reg n6962_o;
  reg n6965_o;
  reg [2:0] n6967_o;
  reg n6969_o;
  wire n6972_o;
  reg n6973_o;
  wire [1:0] n6974_o;
  reg [1:0] n6975_o;
  reg n6977_o;
  reg [3:0] n6981_o;
  reg n6982_o;
  reg n6985_o;
  reg n6988_o;
  reg [2:0] n6990_o;
  reg n6993_o;
  reg n6996_o;
  reg n6999_o;
  reg n7002_o;
  reg n7005_o;
  reg n7008_o;
  reg n7011_o;
  reg n7014_o;
  reg n7017_o;
  reg [2:0] n7020_o;
  reg n7023_o;
  reg n7026_o;
  reg n7029_o;
  reg n7032_o;
  reg n7035_o;
  reg n7038_o;
  reg n7041_o;
  reg n7044_o;
  reg n7047_o;
  reg n7050_o;
  reg n7053_o;
  reg n7056_o;
  reg n7059_o;
  reg n7062_o;
  reg n7065_o;
  reg [1:0] n7068_o;
  reg n7071_o;
  reg n7074_o;
  reg [1:0] n7077_o;
  reg n7080_o;
  reg n7083_o;
  reg n7085_o;
  reg n7088_o;
  wire n7091_o;
  wire n7093_o;
  wire n7095_o;
  wire n7096_o;
  wire [2:0] n7098_o;
  wire n7100_o;
  wire n7101_o;
  wire n7103_o;
  wire n7105_o;
  wire [2:0] n7107_o;
  wire n7110_o;
  wire n7112_o;
  wire n7113_o;
  wire n7115_o;
  wire n7117_o;
  wire [2:0] n7119_o;
  wire n7120_o;
  wire [3:0] n7121_o;
  wire [3:0] n7122_o;
  wire [3:0] n7123_o;
  wire n7124_o;
  wire n7125_o;
  wire [3:0] n7127_o;
  wire [3:0] n7128_o;
  assign mcycles = n6937_o;
  assign tstates = n7119_o;
  assign prefix = n6941_o;
  assign inc_pc = n7115_o;
  assign inc_wz = n6947_o;
  assign incdec_16 = n7127_o;
  assign read_to_reg = n6962_o;
  assign read_to_acc = n6965_o;
  assign set_busa_to = n7128_o;
  assign set_busb_to = n7123_o;
  assign alu_op = n6981_o;
  assign save_alu = n6982_o;
  assign preservec = n6985_o;
  assign arith16 = n6988_o;
  assign set_addr_to = n7107_o;
  assign iorq = n6993_o;
  assign jump = n6996_o;
  assign jumpe = n6999_o;
  assign jumpxy = n7002_o;
  assign call = n7005_o;
  assign rstp = n7008_o;
  assign ldz = n7011_o;
  assign ldw = n7014_o;
  assign ldsphl = n7017_o;
  assign special_ld = n7020_o;
  assign exchangedh = n7023_o;
  assign exchangerp = n7026_o;
  assign exchangeaf = n7029_o;
  assign exchangers = n7032_o;
  assign i_djnz = n7035_o;
  assign i_cpl = n7038_o;
  assign i_ccf = n7041_o;
  assign i_scf = n7044_o;
  assign i_retn = n7047_o;
  assign i_bt = n7050_o;
  assign i_bc = n7053_o;
  assign i_btr = n7056_o;
  assign i_rld = n7059_o;
  assign i_rrd = n7062_o;
  assign i_inrc = n7065_o;
  assign setwz = n7068_o;
  assign setdi = n7071_o;
  assign setei = n7074_o;
  assign imode = n7077_o;
  assign halt = n7080_o;
  assign noread = n7125_o;
  assign write = n7085_o;
  assign xybit_undoc = n7088_o;
  /* ./T80/T80_MCode.vhd:198:26  */
  assign n2108_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:199:26  */
  assign n2109_o = ir[2:0];
  /* ./T80/T80_MCode.vhd:200:28  */
  assign n2110_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:204:27  */
  assign n2112_o = mcycle == 3'b001;
  /* ./T80/T80_MCode.vhd:204:17  */
  assign n2115_o = n2112_o ? 3'b100 : 3'b011;
  /* ./T80/T80_MCode.vhd:217:35  */
  assign n2116_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:217:31  */
  assign n2118_o = {1'b0, n2116_o};
  /* ./T80/T80_MCode.vhd:267:17  */
  assign n2120_o = ir == 8'b01000000;
  /* ./T80/T80_MCode.vhd:267:32  */
  assign n2122_o = ir == 8'b01000001;
  /* ./T80/T80_MCode.vhd:267:32  */
  assign n2123_o = n2120_o | n2122_o;
  /* ./T80/T80_MCode.vhd:267:43  */
  assign n2125_o = ir == 8'b01000010;
  /* ./T80/T80_MCode.vhd:267:43  */
  assign n2126_o = n2123_o | n2125_o;
  /* ./T80/T80_MCode.vhd:267:54  */
  assign n2128_o = ir == 8'b01000011;
  /* ./T80/T80_MCode.vhd:267:54  */
  assign n2129_o = n2126_o | n2128_o;
  /* ./T80/T80_MCode.vhd:267:65  */
  assign n2131_o = ir == 8'b01000100;
  /* ./T80/T80_MCode.vhd:267:65  */
  assign n2132_o = n2129_o | n2131_o;
  /* ./T80/T80_MCode.vhd:267:76  */
  assign n2134_o = ir == 8'b01000101;
  /* ./T80/T80_MCode.vhd:267:76  */
  assign n2135_o = n2132_o | n2134_o;
  /* ./T80/T80_MCode.vhd:267:87  */
  assign n2137_o = ir == 8'b01000111;
  /* ./T80/T80_MCode.vhd:267:87  */
  assign n2138_o = n2135_o | n2137_o;
  /* ./T80/T80_MCode.vhd:268:25  */
  assign n2140_o = ir == 8'b01001000;
  /* ./T80/T80_MCode.vhd:268:25  */
  assign n2141_o = n2138_o | n2140_o;
  /* ./T80/T80_MCode.vhd:268:36  */
  assign n2143_o = ir == 8'b01001001;
  /* ./T80/T80_MCode.vhd:268:36  */
  assign n2144_o = n2141_o | n2143_o;
  /* ./T80/T80_MCode.vhd:268:47  */
  assign n2146_o = ir == 8'b01001010;
  /* ./T80/T80_MCode.vhd:268:47  */
  assign n2147_o = n2144_o | n2146_o;
  /* ./T80/T80_MCode.vhd:268:58  */
  assign n2149_o = ir == 8'b01001011;
  /* ./T80/T80_MCode.vhd:268:58  */
  assign n2150_o = n2147_o | n2149_o;
  /* ./T80/T80_MCode.vhd:268:69  */
  assign n2152_o = ir == 8'b01001100;
  /* ./T80/T80_MCode.vhd:268:69  */
  assign n2153_o = n2150_o | n2152_o;
  /* ./T80/T80_MCode.vhd:268:80  */
  assign n2155_o = ir == 8'b01001101;
  /* ./T80/T80_MCode.vhd:268:80  */
  assign n2156_o = n2153_o | n2155_o;
  /* ./T80/T80_MCode.vhd:268:91  */
  assign n2158_o = ir == 8'b01001111;
  /* ./T80/T80_MCode.vhd:268:91  */
  assign n2159_o = n2156_o | n2158_o;
  /* ./T80/T80_MCode.vhd:269:25  */
  assign n2161_o = ir == 8'b01010000;
  /* ./T80/T80_MCode.vhd:269:25  */
  assign n2162_o = n2159_o | n2161_o;
  /* ./T80/T80_MCode.vhd:269:36  */
  assign n2164_o = ir == 8'b01010001;
  /* ./T80/T80_MCode.vhd:269:36  */
  assign n2165_o = n2162_o | n2164_o;
  /* ./T80/T80_MCode.vhd:269:47  */
  assign n2167_o = ir == 8'b01010010;
  /* ./T80/T80_MCode.vhd:269:47  */
  assign n2168_o = n2165_o | n2167_o;
  /* ./T80/T80_MCode.vhd:269:58  */
  assign n2170_o = ir == 8'b01010011;
  /* ./T80/T80_MCode.vhd:269:58  */
  assign n2171_o = n2168_o | n2170_o;
  /* ./T80/T80_MCode.vhd:269:69  */
  assign n2173_o = ir == 8'b01010100;
  /* ./T80/T80_MCode.vhd:269:69  */
  assign n2174_o = n2171_o | n2173_o;
  /* ./T80/T80_MCode.vhd:269:80  */
  assign n2176_o = ir == 8'b01010101;
  /* ./T80/T80_MCode.vhd:269:80  */
  assign n2177_o = n2174_o | n2176_o;
  /* ./T80/T80_MCode.vhd:269:91  */
  assign n2179_o = ir == 8'b01010111;
  /* ./T80/T80_MCode.vhd:269:91  */
  assign n2180_o = n2177_o | n2179_o;
  /* ./T80/T80_MCode.vhd:270:25  */
  assign n2182_o = ir == 8'b01011000;
  /* ./T80/T80_MCode.vhd:270:25  */
  assign n2183_o = n2180_o | n2182_o;
  /* ./T80/T80_MCode.vhd:270:36  */
  assign n2185_o = ir == 8'b01011001;
  /* ./T80/T80_MCode.vhd:270:36  */
  assign n2186_o = n2183_o | n2185_o;
  /* ./T80/T80_MCode.vhd:270:47  */
  assign n2188_o = ir == 8'b01011010;
  /* ./T80/T80_MCode.vhd:270:47  */
  assign n2189_o = n2186_o | n2188_o;
  /* ./T80/T80_MCode.vhd:270:58  */
  assign n2191_o = ir == 8'b01011011;
  /* ./T80/T80_MCode.vhd:270:58  */
  assign n2192_o = n2189_o | n2191_o;
  /* ./T80/T80_MCode.vhd:270:69  */
  assign n2194_o = ir == 8'b01011100;
  /* ./T80/T80_MCode.vhd:270:69  */
  assign n2195_o = n2192_o | n2194_o;
  /* ./T80/T80_MCode.vhd:270:80  */
  assign n2197_o = ir == 8'b01011101;
  /* ./T80/T80_MCode.vhd:270:80  */
  assign n2198_o = n2195_o | n2197_o;
  /* ./T80/T80_MCode.vhd:270:91  */
  assign n2200_o = ir == 8'b01011111;
  /* ./T80/T80_MCode.vhd:270:91  */
  assign n2201_o = n2198_o | n2200_o;
  /* ./T80/T80_MCode.vhd:271:25  */
  assign n2203_o = ir == 8'b01100000;
  /* ./T80/T80_MCode.vhd:271:25  */
  assign n2204_o = n2201_o | n2203_o;
  /* ./T80/T80_MCode.vhd:271:36  */
  assign n2206_o = ir == 8'b01100001;
  /* ./T80/T80_MCode.vhd:271:36  */
  assign n2207_o = n2204_o | n2206_o;
  /* ./T80/T80_MCode.vhd:271:47  */
  assign n2209_o = ir == 8'b01100010;
  /* ./T80/T80_MCode.vhd:271:47  */
  assign n2210_o = n2207_o | n2209_o;
  /* ./T80/T80_MCode.vhd:271:58  */
  assign n2212_o = ir == 8'b01100011;
  /* ./T80/T80_MCode.vhd:271:58  */
  assign n2213_o = n2210_o | n2212_o;
  /* ./T80/T80_MCode.vhd:271:69  */
  assign n2215_o = ir == 8'b01100100;
  /* ./T80/T80_MCode.vhd:271:69  */
  assign n2216_o = n2213_o | n2215_o;
  /* ./T80/T80_MCode.vhd:271:80  */
  assign n2218_o = ir == 8'b01100101;
  /* ./T80/T80_MCode.vhd:271:80  */
  assign n2219_o = n2216_o | n2218_o;
  /* ./T80/T80_MCode.vhd:271:91  */
  assign n2221_o = ir == 8'b01100111;
  /* ./T80/T80_MCode.vhd:271:91  */
  assign n2222_o = n2219_o | n2221_o;
  /* ./T80/T80_MCode.vhd:272:25  */
  assign n2224_o = ir == 8'b01101000;
  /* ./T80/T80_MCode.vhd:272:25  */
  assign n2225_o = n2222_o | n2224_o;
  /* ./T80/T80_MCode.vhd:272:36  */
  assign n2227_o = ir == 8'b01101001;
  /* ./T80/T80_MCode.vhd:272:36  */
  assign n2228_o = n2225_o | n2227_o;
  /* ./T80/T80_MCode.vhd:272:47  */
  assign n2230_o = ir == 8'b01101010;
  /* ./T80/T80_MCode.vhd:272:47  */
  assign n2231_o = n2228_o | n2230_o;
  /* ./T80/T80_MCode.vhd:272:58  */
  assign n2233_o = ir == 8'b01101011;
  /* ./T80/T80_MCode.vhd:272:58  */
  assign n2234_o = n2231_o | n2233_o;
  /* ./T80/T80_MCode.vhd:272:69  */
  assign n2236_o = ir == 8'b01101100;
  /* ./T80/T80_MCode.vhd:272:69  */
  assign n2237_o = n2234_o | n2236_o;
  /* ./T80/T80_MCode.vhd:272:80  */
  assign n2239_o = ir == 8'b01101101;
  /* ./T80/T80_MCode.vhd:272:80  */
  assign n2240_o = n2237_o | n2239_o;
  /* ./T80/T80_MCode.vhd:272:91  */
  assign n2242_o = ir == 8'b01101111;
  /* ./T80/T80_MCode.vhd:272:91  */
  assign n2243_o = n2240_o | n2242_o;
  /* ./T80/T80_MCode.vhd:273:25  */
  assign n2245_o = ir == 8'b01111000;
  /* ./T80/T80_MCode.vhd:273:25  */
  assign n2246_o = n2243_o | n2245_o;
  /* ./T80/T80_MCode.vhd:273:36  */
  assign n2248_o = ir == 8'b01111001;
  /* ./T80/T80_MCode.vhd:273:36  */
  assign n2249_o = n2246_o | n2248_o;
  /* ./T80/T80_MCode.vhd:273:47  */
  assign n2251_o = ir == 8'b01111010;
  /* ./T80/T80_MCode.vhd:273:47  */
  assign n2252_o = n2249_o | n2251_o;
  /* ./T80/T80_MCode.vhd:273:58  */
  assign n2254_o = ir == 8'b01111011;
  /* ./T80/T80_MCode.vhd:273:58  */
  assign n2255_o = n2252_o | n2254_o;
  /* ./T80/T80_MCode.vhd:273:69  */
  assign n2257_o = ir == 8'b01111100;
  /* ./T80/T80_MCode.vhd:273:69  */
  assign n2258_o = n2255_o | n2257_o;
  /* ./T80/T80_MCode.vhd:273:80  */
  assign n2260_o = ir == 8'b01111101;
  /* ./T80/T80_MCode.vhd:273:80  */
  assign n2261_o = n2258_o | n2260_o;
  /* ./T80/T80_MCode.vhd:273:91  */
  assign n2263_o = ir == 8'b01111111;
  /* ./T80/T80_MCode.vhd:273:91  */
  assign n2264_o = n2261_o | n2263_o;
  /* ./T80/T80_MCode.vhd:282:30  */
  assign n2265_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:283:25  */
  assign n2267_o = n2265_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:282:25  */
  always @*
    case (n2267_o)
      1'b1: n2270_o = 1'b1;
      default: n2270_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:282:25  */
  always @*
    case (n2267_o)
      1'b1: n2273_o = 1'b1;
      default: n2273_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:282:25  */
  always @*
    case (n2267_o)
      1'b1: n2275_o = n2108_o;
      default: n2275_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:279:17  */
  assign n2277_o = ir == 8'b00000110;
  /* ./T80/T80_MCode.vhd:279:32  */
  assign n2279_o = ir == 8'b00001110;
  /* ./T80/T80_MCode.vhd:279:32  */
  assign n2280_o = n2277_o | n2279_o;
  /* ./T80/T80_MCode.vhd:279:43  */
  assign n2282_o = ir == 8'b00010110;
  /* ./T80/T80_MCode.vhd:279:43  */
  assign n2283_o = n2280_o | n2282_o;
  /* ./T80/T80_MCode.vhd:279:54  */
  assign n2285_o = ir == 8'b00011110;
  /* ./T80/T80_MCode.vhd:279:54  */
  assign n2286_o = n2283_o | n2285_o;
  /* ./T80/T80_MCode.vhd:279:65  */
  assign n2288_o = ir == 8'b00100110;
  /* ./T80/T80_MCode.vhd:279:65  */
  assign n2289_o = n2286_o | n2288_o;
  /* ./T80/T80_MCode.vhd:279:76  */
  assign n2291_o = ir == 8'b00101110;
  /* ./T80/T80_MCode.vhd:279:76  */
  assign n2292_o = n2289_o | n2291_o;
  /* ./T80/T80_MCode.vhd:279:87  */
  assign n2294_o = ir == 8'b00111110;
  /* ./T80/T80_MCode.vhd:279:87  */
  assign n2295_o = n2292_o | n2294_o;
  /* ./T80/T80_MCode.vhd:292:30  */
  assign n2296_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:293:25  */
  assign n2298_o = n2296_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:295:25  */
  assign n2300_o = n2296_o == 31'b0000000000000000000000000000010;
  assign n2301_o = {n2300_o, n2298_o};
  /* ./T80/T80_MCode.vhd:292:25  */
  always @*
    case (n2301_o)
      2'b10: n2304_o = 1'b1;
      2'b01: n2304_o = 1'b0;
      default: n2304_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:292:25  */
  always @*
    case (n2301_o)
      2'b10: n2306_o = n2108_o;
      2'b01: n2306_o = 3'b000;
      default: n2306_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:292:25  */
  always @*
    case (n2301_o)
      2'b10: n2309_o = 3'b111;
      2'b01: n2309_o = 3'b010;
      default: n2309_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:289:17  */
  assign n2311_o = ir == 8'b01000110;
  /* ./T80/T80_MCode.vhd:289:32  */
  assign n2313_o = ir == 8'b01001110;
  /* ./T80/T80_MCode.vhd:289:32  */
  assign n2314_o = n2311_o | n2313_o;
  /* ./T80/T80_MCode.vhd:289:43  */
  assign n2316_o = ir == 8'b01010110;
  /* ./T80/T80_MCode.vhd:289:43  */
  assign n2317_o = n2314_o | n2316_o;
  /* ./T80/T80_MCode.vhd:289:54  */
  assign n2319_o = ir == 8'b01011110;
  /* ./T80/T80_MCode.vhd:289:54  */
  assign n2320_o = n2317_o | n2319_o;
  /* ./T80/T80_MCode.vhd:289:65  */
  assign n2322_o = ir == 8'b01100110;
  /* ./T80/T80_MCode.vhd:289:65  */
  assign n2323_o = n2320_o | n2322_o;
  /* ./T80/T80_MCode.vhd:289:76  */
  assign n2325_o = ir == 8'b01101110;
  /* ./T80/T80_MCode.vhd:289:76  */
  assign n2326_o = n2323_o | n2325_o;
  /* ./T80/T80_MCode.vhd:289:87  */
  assign n2328_o = ir == 8'b01111110;
  /* ./T80/T80_MCode.vhd:289:87  */
  assign n2329_o = n2326_o | n2328_o;
  /* ./T80/T80_MCode.vhd:303:30  */
  assign n2330_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:304:25  */
  assign n2333_o = n2330_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:308:25  */
  assign n2335_o = n2330_o == 31'b0000000000000000000000000000010;
  assign n2336_o = {n2335_o, n2333_o};
  /* ./T80/T80_MCode.vhd:303:25  */
  always @*
    case (n2336_o)
      2'b10: n2338_o = 3'b000;
      2'b01: n2338_o = n2109_o;
      default: n2338_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:303:25  */
  always @*
    case (n2336_o)
      2'b10: n2340_o = 1'b0;
      2'b01: n2340_o = 1'b0;
      default: n2340_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:303:25  */
  always @*
    case (n2336_o)
      2'b10: n2343_o = 3'b111;
      2'b01: n2343_o = 3'b010;
      default: n2343_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:303:25  */
  always @*
    case (n2336_o)
      2'b10: n2346_o = 1'b1;
      2'b01: n2346_o = 1'b0;
      default: n2346_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:300:17  */
  assign n2348_o = ir == 8'b01110000;
  /* ./T80/T80_MCode.vhd:300:32  */
  assign n2350_o = ir == 8'b01110001;
  /* ./T80/T80_MCode.vhd:300:32  */
  assign n2351_o = n2348_o | n2350_o;
  /* ./T80/T80_MCode.vhd:300:43  */
  assign n2353_o = ir == 8'b01110010;
  /* ./T80/T80_MCode.vhd:300:43  */
  assign n2354_o = n2351_o | n2353_o;
  /* ./T80/T80_MCode.vhd:300:54  */
  assign n2356_o = ir == 8'b01110011;
  /* ./T80/T80_MCode.vhd:300:54  */
  assign n2357_o = n2354_o | n2356_o;
  /* ./T80/T80_MCode.vhd:300:65  */
  assign n2359_o = ir == 8'b01110100;
  /* ./T80/T80_MCode.vhd:300:65  */
  assign n2360_o = n2357_o | n2359_o;
  /* ./T80/T80_MCode.vhd:300:76  */
  assign n2362_o = ir == 8'b01110101;
  /* ./T80/T80_MCode.vhd:300:76  */
  assign n2363_o = n2360_o | n2362_o;
  /* ./T80/T80_MCode.vhd:300:87  */
  assign n2365_o = ir == 8'b01110111;
  /* ./T80/T80_MCode.vhd:300:87  */
  assign n2366_o = n2363_o | n2365_o;
  /* ./T80/T80_MCode.vhd:315:30  */
  assign n2367_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:316:25  */
  assign n2370_o = n2367_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:321:25  */
  assign n2372_o = n2367_o == 31'b0000000000000000000000000000011;
  assign n2373_o = {n2372_o, n2370_o};
  /* ./T80/T80_MCode.vhd:315:25  */
  always @*
    case (n2373_o)
      2'b10: n2376_o = 1'b0;
      2'b01: n2376_o = 1'b1;
      default: n2376_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:315:25  */
  always @*
    case (n2373_o)
      2'b10: n2378_o = 3'b000;
      2'b01: n2378_o = n2109_o;
      default: n2378_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:315:25  */
  always @*
    case (n2373_o)
      2'b10: n2380_o = 1'b0;
      2'b01: n2380_o = 1'b0;
      default: n2380_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:315:25  */
  always @*
    case (n2373_o)
      2'b10: n2383_o = 3'b111;
      2'b01: n2383_o = 3'b010;
      default: n2383_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:315:25  */
  always @*
    case (n2373_o)
      2'b10: n2386_o = 1'b1;
      2'b01: n2386_o = 1'b0;
      default: n2386_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:312:17  */
  assign n2388_o = ir == 8'b00110110;
  /* ./T80/T80_MCode.vhd:328:30  */
  assign n2389_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:329:25  */
  assign n2391_o = n2389_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:331:25  */
  assign n2393_o = n2389_o == 31'b0000000000000000000000000000010;
  assign n2394_o = {n2393_o, n2391_o};
  /* ./T80/T80_MCode.vhd:328:25  */
  always @*
    case (n2394_o)
      2'b10: n2397_o = 1'b1;
      2'b01: n2397_o = 1'b0;
      default: n2397_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:328:25  */
  always @*
    case (n2394_o)
      2'b10: n2400_o = 3'b111;
      2'b01: n2400_o = 3'b000;
      default: n2400_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:325:17  */
  assign n2402_o = ir == 8'b00001010;
  /* ./T80/T80_MCode.vhd:338:30  */
  assign n2403_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:339:25  */
  assign n2405_o = n2403_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:341:25  */
  assign n2407_o = n2403_o == 31'b0000000000000000000000000000010;
  assign n2408_o = {n2407_o, n2405_o};
  /* ./T80/T80_MCode.vhd:338:25  */
  always @*
    case (n2408_o)
      2'b10: n2411_o = 1'b1;
      2'b01: n2411_o = 1'b0;
      default: n2411_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:338:25  */
  always @*
    case (n2408_o)
      2'b10: n2414_o = 3'b111;
      2'b01: n2414_o = 3'b001;
      default: n2414_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:335:17  */
  assign n2416_o = ir == 8'b00011010;
  /* ./T80/T80_MCode.vhd:360:38  */
  assign n2417_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:361:33  */
  assign n2419_o = n2417_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:364:33  */
  assign n2421_o = n2417_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:367:33  */
  assign n2423_o = n2417_o == 31'b0000000000000000000000000000100;
  assign n2424_o = {n2423_o, n2421_o, n2419_o};
  /* ./T80/T80_MCode.vhd:360:33  */
  always @*
    case (n2424_o)
      3'b100: n2428_o = 1'b0;
      3'b010: n2428_o = 1'b1;
      3'b001: n2428_o = 1'b1;
      default: n2428_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:360:33  */
  always @*
    case (n2424_o)
      3'b100: n2431_o = 1'b1;
      3'b010: n2431_o = 1'b0;
      3'b001: n2431_o = 1'b0;
      default: n2431_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:360:33  */
  always @*
    case (n2424_o)
      3'b100: n2434_o = 3'b111;
      3'b010: n2434_o = 3'b110;
      3'b001: n2434_o = 3'b111;
      default: n2434_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:360:33  */
  always @*
    case (n2424_o)
      3'b100: n2437_o = 1'b0;
      3'b010: n2437_o = 1'b0;
      3'b001: n2437_o = 1'b1;
      default: n2437_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:345:17  */
  assign n2439_o = ir == 8'b00111010;
  /* ./T80/T80_MCode.vhd:375:30  */
  assign n2440_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:376:25  */
  assign n2442_o = n2440_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:380:25  */
  assign n2444_o = n2440_o == 31'b0000000000000000000000000000010;
  assign n2445_o = {n2444_o, n2442_o};
  /* ./T80/T80_MCode.vhd:375:25  */
  always @*
    case (n2445_o)
      2'b10: n2448_o = 4'b0000;
      2'b01: n2448_o = 4'b0111;
      default: n2448_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:375:25  */
  always @*
    case (n2445_o)
      2'b10: n2451_o = 3'b111;
      2'b01: n2451_o = 3'b000;
      default: n2451_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:375:25  */
  always @*
    case (n2445_o)
      2'b10: n2454_o = 2'b00;
      2'b01: n2454_o = 2'b10;
      default: n2454_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:375:25  */
  always @*
    case (n2445_o)
      2'b10: n2457_o = 1'b1;
      2'b01: n2457_o = 1'b0;
      default: n2457_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:372:17  */
  assign n2459_o = ir == 8'b00000010;
  /* ./T80/T80_MCode.vhd:387:30  */
  assign n2460_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:388:25  */
  assign n2462_o = n2460_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:392:25  */
  assign n2464_o = n2460_o == 31'b0000000000000000000000000000010;
  assign n2465_o = {n2464_o, n2462_o};
  /* ./T80/T80_MCode.vhd:387:25  */
  always @*
    case (n2465_o)
      2'b10: n2468_o = 4'b0000;
      2'b01: n2468_o = 4'b0111;
      default: n2468_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:387:25  */
  always @*
    case (n2465_o)
      2'b10: n2471_o = 3'b111;
      2'b01: n2471_o = 3'b001;
      default: n2471_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:387:25  */
  always @*
    case (n2465_o)
      2'b10: n2474_o = 2'b00;
      2'b01: n2474_o = 2'b10;
      default: n2474_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:387:25  */
  always @*
    case (n2465_o)
      2'b10: n2477_o = 1'b1;
      2'b01: n2477_o = 1'b0;
      default: n2477_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:384:17  */
  assign n2479_o = ir == 8'b00010010;
  /* ./T80/T80_MCode.vhd:412:38  */
  assign n2480_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:413:33  */
  assign n2482_o = n2480_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:416:33  */
  assign n2484_o = n2480_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:421:33  */
  assign n2486_o = n2480_o == 31'b0000000000000000000000000000100;
  assign n2487_o = {n2486_o, n2484_o, n2482_o};
  /* ./T80/T80_MCode.vhd:412:33  */
  always @*
    case (n2487_o)
      3'b100: n2491_o = 1'b0;
      3'b010: n2491_o = 1'b1;
      3'b001: n2491_o = 1'b1;
      default: n2491_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:412:33  */
  always @*
    case (n2487_o)
      3'b100: n2494_o = 4'b0000;
      3'b010: n2494_o = 4'b0111;
      3'b001: n2494_o = 4'b0000;
      default: n2494_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:412:33  */
  always @*
    case (n2487_o)
      3'b100: n2497_o = 3'b111;
      3'b010: n2497_o = 3'b110;
      3'b001: n2497_o = 3'b111;
      default: n2497_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:412:33  */
  always @*
    case (n2487_o)
      3'b100: n2500_o = 1'b0;
      3'b010: n2500_o = 1'b0;
      3'b001: n2500_o = 1'b1;
      default: n2500_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:412:33  */
  always @*
    case (n2487_o)
      3'b100: n2503_o = 2'b00;
      3'b010: n2503_o = 2'b10;
      3'b001: n2503_o = 2'b00;
      default: n2503_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:412:33  */
  always @*
    case (n2487_o)
      3'b100: n2506_o = 1'b1;
      3'b010: n2506_o = 1'b0;
      3'b001: n2506_o = 1'b0;
      default: n2506_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:396:17  */
  assign n2508_o = ir == 8'b00110010;
  /* ./T80/T80_MCode.vhd:431:30  */
  assign n2509_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:435:42  */
  assign n2511_o = n2110_o == 2'b11;
  assign n2513_o = {n2110_o, 1'b1};
  /* ./T80/T80_MCode.vhd:435:33  */
  assign n2515_o = n2511_o ? 3'b000 : n2513_o;
  /* ./T80/T80_MCode.vhd:435:33  */
  assign n2518_o = n2511_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:432:25  */
  assign n2520_o = n2509_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:444:42  */
  assign n2522_o = n2110_o == 2'b11;
  assign n2524_o = {n2110_o, 1'b0};
  /* ./T80/T80_MCode.vhd:444:33  */
  assign n2526_o = n2522_o ? 3'b001 : n2524_o;
  /* ./T80/T80_MCode.vhd:444:33  */
  assign n2529_o = n2522_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:441:25  */
  assign n2531_o = n2509_o == 31'b0000000000000000000000000000011;
  assign n2532_o = {n2531_o, n2520_o};
  /* ./T80/T80_MCode.vhd:431:25  */
  always @*
    case (n2532_o)
      2'b10: n2536_o = 1'b1;
      2'b01: n2536_o = 1'b1;
      default: n2536_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:431:25  */
  always @*
    case (n2532_o)
      2'b10: n2540_o = 1'b1;
      2'b01: n2540_o = 1'b1;
      default: n2540_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:431:25  */
  always @*
    case (n2532_o)
      2'b10: n2542_o = n2526_o;
      2'b01: n2542_o = n2515_o;
      default: n2542_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:431:25  */
  always @*
    case (n2532_o)
      2'b10: n2544_o = n2529_o;
      2'b01: n2544_o = n2518_o;
      default: n2544_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:428:17  */
  assign n2546_o = ir == 8'b00000001;
  /* ./T80/T80_MCode.vhd:428:32  */
  assign n2548_o = ir == 8'b00010001;
  /* ./T80/T80_MCode.vhd:428:32  */
  assign n2549_o = n2546_o | n2548_o;
  /* ./T80/T80_MCode.vhd:428:43  */
  assign n2551_o = ir == 8'b00100001;
  /* ./T80/T80_MCode.vhd:428:43  */
  assign n2552_o = n2549_o | n2551_o;
  /* ./T80/T80_MCode.vhd:428:54  */
  assign n2554_o = ir == 8'b00110001;
  /* ./T80/T80_MCode.vhd:428:54  */
  assign n2555_o = n2552_o | n2554_o;
  /* ./T80/T80_MCode.vhd:467:38  */
  assign n2556_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:468:33  */
  assign n2558_o = n2556_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:471:33  */
  assign n2560_o = n2556_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:475:33  */
  assign n2563_o = n2556_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:480:33  */
  assign n2566_o = n2556_o == 31'b0000000000000000000000000000101;
  assign n2567_o = {n2566_o, n2563_o, n2560_o, n2558_o};
  /* ./T80/T80_MCode.vhd:467:33  */
  always @*
    case (n2567_o)
      4'b1000: n2571_o = 1'b0;
      4'b0100: n2571_o = 1'b0;
      4'b0010: n2571_o = 1'b1;
      4'b0001: n2571_o = 1'b1;
      default: n2571_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:467:33  */
  always @*
    case (n2567_o)
      4'b1000: n2574_o = 1'b0;
      4'b0100: n2574_o = 1'b1;
      4'b0010: n2574_o = 1'b0;
      4'b0001: n2574_o = 1'b0;
      default: n2574_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:467:33  */
  always @*
    case (n2567_o)
      4'b1000: n2578_o = 1'b1;
      4'b0100: n2578_o = 1'b1;
      4'b0010: n2578_o = 1'b0;
      4'b0001: n2578_o = 1'b0;
      default: n2578_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:467:33  */
  always @*
    case (n2567_o)
      4'b1000: n2580_o = 3'b100;
      4'b0100: n2580_o = 3'b101;
      4'b0010: n2580_o = 3'b000;
      4'b0001: n2580_o = 3'b000;
      default: n2580_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:467:33  */
  always @*
    case (n2567_o)
      4'b1000: n2584_o = 3'b111;
      4'b0100: n2584_o = 3'b110;
      4'b0010: n2584_o = 3'b110;
      4'b0001: n2584_o = 3'b111;
      default: n2584_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:467:33  */
  always @*
    case (n2567_o)
      4'b1000: n2587_o = 1'b0;
      4'b0100: n2587_o = 1'b0;
      4'b0010: n2587_o = 1'b0;
      4'b0001: n2587_o = 1'b1;
      default: n2587_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:467:33  */
  always @*
    case (n2567_o)
      4'b1000: n2590_o = 1'b0;
      4'b0100: n2590_o = 1'b0;
      4'b0010: n2590_o = 1'b1;
      4'b0001: n2590_o = 1'b0;
      default: n2590_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:452:17  */
  assign n2592_o = ir == 8'b00101010;
  /* ./T80/T80_MCode.vhd:502:38  */
  assign n2593_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:503:33  */
  assign n2595_o = n2593_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:506:33  */
  assign n2597_o = n2593_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:511:33  */
  assign n2599_o = n2593_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:516:33  */
  assign n2601_o = n2593_o == 31'b0000000000000000000000000000101;
  assign n2602_o = {n2601_o, n2599_o, n2597_o, n2595_o};
  /* ./T80/T80_MCode.vhd:502:33  */
  always @*
    case (n2602_o)
      4'b1000: n2606_o = 1'b0;
      4'b0100: n2606_o = 1'b0;
      4'b0010: n2606_o = 1'b1;
      4'b0001: n2606_o = 1'b1;
      default: n2606_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:502:33  */
  always @*
    case (n2602_o)
      4'b1000: n2609_o = 1'b0;
      4'b0100: n2609_o = 1'b1;
      4'b0010: n2609_o = 1'b0;
      4'b0001: n2609_o = 1'b0;
      default: n2609_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:502:33  */
  always @*
    case (n2602_o)
      4'b1000: n2613_o = 4'b0000;
      4'b0100: n2613_o = 4'b0100;
      4'b0010: n2613_o = 4'b0101;
      4'b0001: n2613_o = 4'b0000;
      default: n2613_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:502:33  */
  always @*
    case (n2602_o)
      4'b1000: n2617_o = 3'b111;
      4'b0100: n2617_o = 3'b110;
      4'b0010: n2617_o = 3'b110;
      4'b0001: n2617_o = 3'b111;
      default: n2617_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:502:33  */
  always @*
    case (n2602_o)
      4'b1000: n2620_o = 1'b0;
      4'b0100: n2620_o = 1'b0;
      4'b0010: n2620_o = 1'b0;
      4'b0001: n2620_o = 1'b1;
      default: n2620_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:502:33  */
  always @*
    case (n2602_o)
      4'b1000: n2623_o = 1'b0;
      4'b0100: n2623_o = 1'b0;
      4'b0010: n2623_o = 1'b1;
      4'b0001: n2623_o = 1'b0;
      default: n2623_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:502:33  */
  always @*
    case (n2602_o)
      4'b1000: n2627_o = 1'b1;
      4'b0100: n2627_o = 1'b1;
      4'b0010: n2627_o = 1'b0;
      4'b0001: n2627_o = 1'b0;
      default: n2627_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:486:17  */
  assign n2629_o = ir == 8'b00100010;
  /* ./T80/T80_MCode.vhd:521:17  */
  assign n2631_o = ir == 8'b11111001;
  /* ./T80/T80_MCode.vhd:528:30  */
  assign n2632_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:533:42  */
  assign n2634_o = n2110_o == 2'b11;
  assign n2637_o = {1'b0, n2110_o, 1'b0};
  /* ./T80/T80_MCode.vhd:533:33  */
  assign n2639_o = n2634_o ? 4'b0111 : n2637_o;
  /* ./T80/T80_MCode.vhd:529:25  */
  assign n2641_o = n2632_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:543:42  */
  assign n2643_o = n2110_o == 2'b11;
  assign n2646_o = {1'b0, n2110_o, 1'b1};
  /* ./T80/T80_MCode.vhd:543:33  */
  assign n2648_o = n2643_o ? 4'b1011 : n2646_o;
  /* ./T80/T80_MCode.vhd:540:25  */
  assign n2650_o = n2632_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:551:25  */
  assign n2652_o = n2632_o == 31'b0000000000000000000000000000011;
  assign n2653_o = {n2652_o, n2650_o, n2641_o};
  /* ./T80/T80_MCode.vhd:528:25  */
  always @*
    case (n2653_o)
      3'b100: n2655_o = n2115_o;
      3'b010: n2655_o = n2115_o;
      3'b001: n2655_o = 3'b101;
      default: n2655_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:528:25  */
  always @*
    case (n2653_o)
      3'b100: n2659_o = 4'b0000;
      3'b010: n2659_o = 4'b1111;
      3'b001: n2659_o = 4'b1111;
      default: n2659_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:528:25  */
  always @*
    case (n2653_o)
      3'b100: n2661_o = 4'b0000;
      3'b010: n2661_o = n2648_o;
      3'b001: n2661_o = n2639_o;
      default: n2661_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:528:25  */
  always @*
    case (n2653_o)
      3'b100: n2665_o = 3'b111;
      3'b010: n2665_o = 3'b101;
      3'b001: n2665_o = 3'b101;
      default: n2665_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:528:25  */
  always @*
    case (n2653_o)
      3'b100: n2669_o = 1'b1;
      3'b010: n2669_o = 1'b1;
      3'b001: n2669_o = 1'b0;
      default: n2669_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:525:17  */
  assign n2671_o = ir == 8'b11000101;
  /* ./T80/T80_MCode.vhd:525:32  */
  assign n2673_o = ir == 8'b11010101;
  /* ./T80/T80_MCode.vhd:525:32  */
  assign n2674_o = n2671_o | n2673_o;
  /* ./T80/T80_MCode.vhd:525:43  */
  assign n2676_o = ir == 8'b11100101;
  /* ./T80/T80_MCode.vhd:525:43  */
  assign n2677_o = n2674_o | n2676_o;
  /* ./T80/T80_MCode.vhd:525:54  */
  assign n2679_o = ir == 8'b11110101;
  /* ./T80/T80_MCode.vhd:525:54  */
  assign n2680_o = n2677_o | n2679_o;
  /* ./T80/T80_MCode.vhd:558:30  */
  assign n2681_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:559:25  */
  assign n2683_o = n2681_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:565:42  */
  assign n2685_o = n2110_o == 2'b11;
  assign n2687_o = {n2110_o, 1'b1};
  /* ./T80/T80_MCode.vhd:565:33  */
  assign n2689_o = n2685_o ? 3'b011 : n2687_o;
  /* ./T80/T80_MCode.vhd:565:33  */
  assign n2692_o = n2685_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:561:25  */
  assign n2694_o = n2681_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:574:42  */
  assign n2696_o = n2110_o == 2'b11;
  assign n2698_o = {n2110_o, 1'b0};
  /* ./T80/T80_MCode.vhd:574:33  */
  assign n2700_o = n2696_o ? 3'b111 : n2698_o;
  /* ./T80/T80_MCode.vhd:574:33  */
  assign n2703_o = n2696_o ? 1'b0 : 1'b0;
  /* ./T80/T80_MCode.vhd:571:25  */
  assign n2705_o = n2681_o == 31'b0000000000000000000000000000011;
  assign n2706_o = {n2705_o, n2694_o, n2683_o};
  /* ./T80/T80_MCode.vhd:558:25  */
  always @*
    case (n2706_o)
      3'b100: n2710_o = 4'b0111;
      3'b010: n2710_o = 4'b0111;
      3'b001: n2710_o = 4'b0000;
      default: n2710_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:558:25  */
  always @*
    case (n2706_o)
      3'b100: n2714_o = 1'b1;
      3'b010: n2714_o = 1'b1;
      3'b001: n2714_o = 1'b0;
      default: n2714_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:558:25  */
  always @*
    case (n2706_o)
      3'b100: n2716_o = n2700_o;
      3'b010: n2716_o = n2689_o;
      3'b001: n2716_o = 3'b000;
      default: n2716_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:558:25  */
  always @*
    case (n2706_o)
      3'b100: n2718_o = n2703_o;
      3'b010: n2718_o = n2692_o;
      3'b001: n2718_o = 1'b0;
      default: n2718_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:558:25  */
  always @*
    case (n2706_o)
      3'b100: n2722_o = 3'b111;
      3'b010: n2722_o = 3'b101;
      3'b001: n2722_o = 3'b101;
      default: n2722_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:555:17  */
  assign n2724_o = ir == 8'b11000001;
  /* ./T80/T80_MCode.vhd:555:32  */
  assign n2726_o = ir == 8'b11010001;
  /* ./T80/T80_MCode.vhd:555:32  */
  assign n2727_o = n2724_o | n2726_o;
  /* ./T80/T80_MCode.vhd:555:43  */
  assign n2729_o = ir == 8'b11100001;
  /* ./T80/T80_MCode.vhd:555:43  */
  assign n2730_o = n2727_o | n2729_o;
  /* ./T80/T80_MCode.vhd:555:54  */
  assign n2732_o = ir == 8'b11110001;
  /* ./T80/T80_MCode.vhd:555:54  */
  assign n2733_o = n2730_o | n2732_o;
  /* ./T80/T80_MCode.vhd:584:17  */
  assign n2735_o = ir == 8'b11101011;
  /* ./T80/T80_MCode.vhd:589:17  */
  assign n2737_o = ir == 8'b00001000;
  /* ./T80/T80_MCode.vhd:615:17  */
  assign n2739_o = ir == 8'b11011001;
  /* ./T80/T80_MCode.vhd:641:38  */
  assign n2740_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:642:33  */
  assign n2742_o = n2740_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:644:33  */
  assign n2744_o = n2740_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:650:33  */
  assign n2746_o = n2740_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:655:33  */
  assign n2748_o = n2740_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:661:33  */
  assign n2750_o = n2740_o == 31'b0000000000000000000000000000101;
  assign n2751_o = {n2750_o, n2748_o, n2746_o, n2744_o, n2742_o};
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2754_o = 3'b101;
      5'b01000: n2754_o = n2115_o;
      5'b00100: n2754_o = 3'b100;
      5'b00010: n2754_o = n2115_o;
      5'b00001: n2754_o = n2115_o;
      default: n2754_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2758_o = 4'b1111;
      5'b01000: n2758_o = 4'b0000;
      5'b00100: n2758_o = 4'b0111;
      5'b00010: n2758_o = 4'b0000;
      5'b00001: n2758_o = 4'b0000;
      default: n2758_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2762_o = 1'b0;
      5'b01000: n2762_o = 1'b1;
      5'b00100: n2762_o = 1'b0;
      5'b00010: n2762_o = 1'b1;
      5'b00001: n2762_o = 1'b0;
      default: n2762_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2766_o = 4'b0000;
      5'b01000: n2766_o = 4'b0100;
      5'b00100: n2766_o = 4'b0000;
      5'b00010: n2766_o = 4'b0101;
      5'b00001: n2766_o = 4'b0000;
      default: n2766_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2770_o = 4'b0000;
      5'b01000: n2770_o = 4'b0100;
      5'b00100: n2770_o = 4'b0000;
      5'b00010: n2770_o = 4'b0101;
      5'b00001: n2770_o = 4'b0000;
      default: n2770_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2776_o = 3'b111;
      5'b01000: n2776_o = 3'b101;
      5'b00100: n2776_o = 3'b101;
      5'b00010: n2776_o = 3'b101;
      5'b00001: n2776_o = 3'b101;
      default: n2776_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2779_o = 1'b0;
      5'b01000: n2779_o = 1'b0;
      5'b00100: n2779_o = 1'b0;
      5'b00010: n2779_o = 1'b1;
      5'b00001: n2779_o = 1'b0;
      default: n2779_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2782_o = 1'b0;
      5'b01000: n2782_o = 1'b1;
      5'b00100: n2782_o = 1'b0;
      5'b00010: n2782_o = 1'b0;
      5'b00001: n2782_o = 1'b0;
      default: n2782_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:641:33  */
  always @*
    case (n2751_o)
      5'b10000: n2786_o = 1'b1;
      5'b01000: n2786_o = 1'b0;
      5'b00100: n2786_o = 1'b1;
      5'b00010: n2786_o = 1'b0;
      5'b00001: n2786_o = 1'b0;
      default: n2786_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:637:17  */
  assign n2788_o = ir == 8'b11100011;
  /* ./T80/T80_MCode.vhd:670:17  */
  assign n2791_o = ir == 8'b10000000;
  /* ./T80/T80_MCode.vhd:670:32  */
  assign n2793_o = ir == 8'b10000001;
  /* ./T80/T80_MCode.vhd:670:32  */
  assign n2794_o = n2791_o | n2793_o;
  /* ./T80/T80_MCode.vhd:670:43  */
  assign n2796_o = ir == 8'b10000010;
  /* ./T80/T80_MCode.vhd:670:43  */
  assign n2797_o = n2794_o | n2796_o;
  /* ./T80/T80_MCode.vhd:670:54  */
  assign n2799_o = ir == 8'b10000011;
  /* ./T80/T80_MCode.vhd:670:54  */
  assign n2800_o = n2797_o | n2799_o;
  /* ./T80/T80_MCode.vhd:670:65  */
  assign n2802_o = ir == 8'b10000100;
  /* ./T80/T80_MCode.vhd:670:65  */
  assign n2803_o = n2800_o | n2802_o;
  /* ./T80/T80_MCode.vhd:670:76  */
  assign n2805_o = ir == 8'b10000101;
  /* ./T80/T80_MCode.vhd:670:76  */
  assign n2806_o = n2803_o | n2805_o;
  /* ./T80/T80_MCode.vhd:670:87  */
  assign n2808_o = ir == 8'b10000111;
  /* ./T80/T80_MCode.vhd:670:87  */
  assign n2809_o = n2806_o | n2808_o;
  /* ./T80/T80_MCode.vhd:671:25  */
  assign n2811_o = ir == 8'b10001000;
  /* ./T80/T80_MCode.vhd:671:25  */
  assign n2812_o = n2809_o | n2811_o;
  /* ./T80/T80_MCode.vhd:671:36  */
  assign n2814_o = ir == 8'b10001001;
  /* ./T80/T80_MCode.vhd:671:36  */
  assign n2815_o = n2812_o | n2814_o;
  /* ./T80/T80_MCode.vhd:671:47  */
  assign n2817_o = ir == 8'b10001010;
  /* ./T80/T80_MCode.vhd:671:47  */
  assign n2818_o = n2815_o | n2817_o;
  /* ./T80/T80_MCode.vhd:671:58  */
  assign n2820_o = ir == 8'b10001011;
  /* ./T80/T80_MCode.vhd:671:58  */
  assign n2821_o = n2818_o | n2820_o;
  /* ./T80/T80_MCode.vhd:671:69  */
  assign n2823_o = ir == 8'b10001100;
  /* ./T80/T80_MCode.vhd:671:69  */
  assign n2824_o = n2821_o | n2823_o;
  /* ./T80/T80_MCode.vhd:671:80  */
  assign n2826_o = ir == 8'b10001101;
  /* ./T80/T80_MCode.vhd:671:80  */
  assign n2827_o = n2824_o | n2826_o;
  /* ./T80/T80_MCode.vhd:671:91  */
  assign n2829_o = ir == 8'b10001111;
  /* ./T80/T80_MCode.vhd:671:91  */
  assign n2830_o = n2827_o | n2829_o;
  /* ./T80/T80_MCode.vhd:672:25  */
  assign n2832_o = ir == 8'b10010000;
  /* ./T80/T80_MCode.vhd:672:25  */
  assign n2833_o = n2830_o | n2832_o;
  /* ./T80/T80_MCode.vhd:672:36  */
  assign n2835_o = ir == 8'b10010001;
  /* ./T80/T80_MCode.vhd:672:36  */
  assign n2836_o = n2833_o | n2835_o;
  /* ./T80/T80_MCode.vhd:672:47  */
  assign n2838_o = ir == 8'b10010010;
  /* ./T80/T80_MCode.vhd:672:47  */
  assign n2839_o = n2836_o | n2838_o;
  /* ./T80/T80_MCode.vhd:672:58  */
  assign n2841_o = ir == 8'b10010011;
  /* ./T80/T80_MCode.vhd:672:58  */
  assign n2842_o = n2839_o | n2841_o;
  /* ./T80/T80_MCode.vhd:672:69  */
  assign n2844_o = ir == 8'b10010100;
  /* ./T80/T80_MCode.vhd:672:69  */
  assign n2845_o = n2842_o | n2844_o;
  /* ./T80/T80_MCode.vhd:672:80  */
  assign n2847_o = ir == 8'b10010101;
  /* ./T80/T80_MCode.vhd:672:80  */
  assign n2848_o = n2845_o | n2847_o;
  /* ./T80/T80_MCode.vhd:672:91  */
  assign n2850_o = ir == 8'b10010111;
  /* ./T80/T80_MCode.vhd:672:91  */
  assign n2851_o = n2848_o | n2850_o;
  /* ./T80/T80_MCode.vhd:673:25  */
  assign n2853_o = ir == 8'b10011000;
  /* ./T80/T80_MCode.vhd:673:25  */
  assign n2854_o = n2851_o | n2853_o;
  /* ./T80/T80_MCode.vhd:673:36  */
  assign n2856_o = ir == 8'b10011001;
  /* ./T80/T80_MCode.vhd:673:36  */
  assign n2857_o = n2854_o | n2856_o;
  /* ./T80/T80_MCode.vhd:673:47  */
  assign n2859_o = ir == 8'b10011010;
  /* ./T80/T80_MCode.vhd:673:47  */
  assign n2860_o = n2857_o | n2859_o;
  /* ./T80/T80_MCode.vhd:673:58  */
  assign n2862_o = ir == 8'b10011011;
  /* ./T80/T80_MCode.vhd:673:58  */
  assign n2863_o = n2860_o | n2862_o;
  /* ./T80/T80_MCode.vhd:673:69  */
  assign n2865_o = ir == 8'b10011100;
  /* ./T80/T80_MCode.vhd:673:69  */
  assign n2866_o = n2863_o | n2865_o;
  /* ./T80/T80_MCode.vhd:673:80  */
  assign n2868_o = ir == 8'b10011101;
  /* ./T80/T80_MCode.vhd:673:80  */
  assign n2869_o = n2866_o | n2868_o;
  /* ./T80/T80_MCode.vhd:673:91  */
  assign n2871_o = ir == 8'b10011111;
  /* ./T80/T80_MCode.vhd:673:91  */
  assign n2872_o = n2869_o | n2871_o;
  /* ./T80/T80_MCode.vhd:674:25  */
  assign n2874_o = ir == 8'b10100000;
  /* ./T80/T80_MCode.vhd:674:25  */
  assign n2875_o = n2872_o | n2874_o;
  /* ./T80/T80_MCode.vhd:674:36  */
  assign n2877_o = ir == 8'b10100001;
  /* ./T80/T80_MCode.vhd:674:36  */
  assign n2878_o = n2875_o | n2877_o;
  /* ./T80/T80_MCode.vhd:674:47  */
  assign n2880_o = ir == 8'b10100010;
  /* ./T80/T80_MCode.vhd:674:47  */
  assign n2881_o = n2878_o | n2880_o;
  /* ./T80/T80_MCode.vhd:674:58  */
  assign n2883_o = ir == 8'b10100011;
  /* ./T80/T80_MCode.vhd:674:58  */
  assign n2884_o = n2881_o | n2883_o;
  /* ./T80/T80_MCode.vhd:674:69  */
  assign n2886_o = ir == 8'b10100100;
  /* ./T80/T80_MCode.vhd:674:69  */
  assign n2887_o = n2884_o | n2886_o;
  /* ./T80/T80_MCode.vhd:674:80  */
  assign n2889_o = ir == 8'b10100101;
  /* ./T80/T80_MCode.vhd:674:80  */
  assign n2890_o = n2887_o | n2889_o;
  /* ./T80/T80_MCode.vhd:674:91  */
  assign n2892_o = ir == 8'b10100111;
  /* ./T80/T80_MCode.vhd:674:91  */
  assign n2893_o = n2890_o | n2892_o;
  /* ./T80/T80_MCode.vhd:675:25  */
  assign n2895_o = ir == 8'b10101000;
  /* ./T80/T80_MCode.vhd:675:25  */
  assign n2896_o = n2893_o | n2895_o;
  /* ./T80/T80_MCode.vhd:675:36  */
  assign n2898_o = ir == 8'b10101001;
  /* ./T80/T80_MCode.vhd:675:36  */
  assign n2899_o = n2896_o | n2898_o;
  /* ./T80/T80_MCode.vhd:675:47  */
  assign n2901_o = ir == 8'b10101010;
  /* ./T80/T80_MCode.vhd:675:47  */
  assign n2902_o = n2899_o | n2901_o;
  /* ./T80/T80_MCode.vhd:675:58  */
  assign n2904_o = ir == 8'b10101011;
  /* ./T80/T80_MCode.vhd:675:58  */
  assign n2905_o = n2902_o | n2904_o;
  /* ./T80/T80_MCode.vhd:675:69  */
  assign n2907_o = ir == 8'b10101100;
  /* ./T80/T80_MCode.vhd:675:69  */
  assign n2908_o = n2905_o | n2907_o;
  /* ./T80/T80_MCode.vhd:675:80  */
  assign n2910_o = ir == 8'b10101101;
  /* ./T80/T80_MCode.vhd:675:80  */
  assign n2911_o = n2908_o | n2910_o;
  /* ./T80/T80_MCode.vhd:675:91  */
  assign n2913_o = ir == 8'b10101111;
  /* ./T80/T80_MCode.vhd:675:91  */
  assign n2914_o = n2911_o | n2913_o;
  /* ./T80/T80_MCode.vhd:676:25  */
  assign n2916_o = ir == 8'b10110000;
  /* ./T80/T80_MCode.vhd:676:25  */
  assign n2917_o = n2914_o | n2916_o;
  /* ./T80/T80_MCode.vhd:676:36  */
  assign n2919_o = ir == 8'b10110001;
  /* ./T80/T80_MCode.vhd:676:36  */
  assign n2920_o = n2917_o | n2919_o;
  /* ./T80/T80_MCode.vhd:676:47  */
  assign n2922_o = ir == 8'b10110010;
  /* ./T80/T80_MCode.vhd:676:47  */
  assign n2923_o = n2920_o | n2922_o;
  /* ./T80/T80_MCode.vhd:676:58  */
  assign n2925_o = ir == 8'b10110011;
  /* ./T80/T80_MCode.vhd:676:58  */
  assign n2926_o = n2923_o | n2925_o;
  /* ./T80/T80_MCode.vhd:676:69  */
  assign n2928_o = ir == 8'b10110100;
  /* ./T80/T80_MCode.vhd:676:69  */
  assign n2929_o = n2926_o | n2928_o;
  /* ./T80/T80_MCode.vhd:676:80  */
  assign n2931_o = ir == 8'b10110101;
  /* ./T80/T80_MCode.vhd:676:80  */
  assign n2932_o = n2929_o | n2931_o;
  /* ./T80/T80_MCode.vhd:676:91  */
  assign n2934_o = ir == 8'b10110111;
  /* ./T80/T80_MCode.vhd:676:91  */
  assign n2935_o = n2932_o | n2934_o;
  /* ./T80/T80_MCode.vhd:677:25  */
  assign n2937_o = ir == 8'b10111000;
  /* ./T80/T80_MCode.vhd:677:25  */
  assign n2938_o = n2935_o | n2937_o;
  /* ./T80/T80_MCode.vhd:677:36  */
  assign n2940_o = ir == 8'b10111001;
  /* ./T80/T80_MCode.vhd:677:36  */
  assign n2941_o = n2938_o | n2940_o;
  /* ./T80/T80_MCode.vhd:677:47  */
  assign n2943_o = ir == 8'b10111010;
  /* ./T80/T80_MCode.vhd:677:47  */
  assign n2944_o = n2941_o | n2943_o;
  /* ./T80/T80_MCode.vhd:677:58  */
  assign n2946_o = ir == 8'b10111011;
  /* ./T80/T80_MCode.vhd:677:58  */
  assign n2947_o = n2944_o | n2946_o;
  /* ./T80/T80_MCode.vhd:677:69  */
  assign n2949_o = ir == 8'b10111100;
  /* ./T80/T80_MCode.vhd:677:69  */
  assign n2950_o = n2947_o | n2949_o;
  /* ./T80/T80_MCode.vhd:677:80  */
  assign n2952_o = ir == 8'b10111101;
  /* ./T80/T80_MCode.vhd:677:80  */
  assign n2953_o = n2950_o | n2952_o;
  /* ./T80/T80_MCode.vhd:677:91  */
  assign n2955_o = ir == 8'b10111111;
  /* ./T80/T80_MCode.vhd:677:91  */
  assign n2956_o = n2953_o | n2955_o;
  /* ./T80/T80_MCode.vhd:700:30  */
  assign n2957_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:701:25  */
  assign n2959_o = n2957_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:703:25  */
  assign n2962_o = n2957_o == 31'b0000000000000000000000000000010;
  assign n2963_o = {n2962_o, n2959_o};
  /* ./T80/T80_MCode.vhd:700:25  */
  always @*
    case (n2963_o)
      2'b10: n2966_o = 1'b1;
      2'b01: n2966_o = 1'b0;
      default: n2966_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:700:25  */
  always @*
    case (n2963_o)
      2'b10: n2968_o = 3'b111;
      2'b01: n2968_o = 3'b000;
      default: n2968_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:700:25  */
  always @*
    case (n2963_o)
      2'b10: n2970_o = n2109_o;
      2'b01: n2970_o = 3'b000;
      default: n2970_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:700:25  */
  always @*
    case (n2963_o)
      2'b10: n2973_o = 1'b1;
      2'b01: n2973_o = 1'b0;
      default: n2973_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:700:25  */
  always @*
    case (n2963_o)
      2'b10: n2976_o = 3'b111;
      2'b01: n2976_o = 3'b010;
      default: n2976_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:690:17  */
  assign n2978_o = ir == 8'b10000110;
  /* ./T80/T80_MCode.vhd:690:32  */
  assign n2980_o = ir == 8'b10001110;
  /* ./T80/T80_MCode.vhd:690:32  */
  assign n2981_o = n2978_o | n2980_o;
  /* ./T80/T80_MCode.vhd:690:43  */
  assign n2983_o = ir == 8'b10010110;
  /* ./T80/T80_MCode.vhd:690:43  */
  assign n2984_o = n2981_o | n2983_o;
  /* ./T80/T80_MCode.vhd:690:54  */
  assign n2986_o = ir == 8'b10011110;
  /* ./T80/T80_MCode.vhd:690:54  */
  assign n2987_o = n2984_o | n2986_o;
  /* ./T80/T80_MCode.vhd:690:65  */
  assign n2989_o = ir == 8'b10100110;
  /* ./T80/T80_MCode.vhd:690:65  */
  assign n2990_o = n2987_o | n2989_o;
  /* ./T80/T80_MCode.vhd:690:76  */
  assign n2992_o = ir == 8'b10101110;
  /* ./T80/T80_MCode.vhd:690:76  */
  assign n2993_o = n2990_o | n2992_o;
  /* ./T80/T80_MCode.vhd:690:87  */
  assign n2995_o = ir == 8'b10110110;
  /* ./T80/T80_MCode.vhd:690:87  */
  assign n2996_o = n2993_o | n2995_o;
  /* ./T80/T80_MCode.vhd:690:98  */
  assign n2998_o = ir == 8'b10111110;
  /* ./T80/T80_MCode.vhd:690:98  */
  assign n2999_o = n2996_o | n2998_o;
  /* ./T80/T80_MCode.vhd:720:35  */
  assign n3001_o = mcycle == 3'b010;
  /* ./T80/T80_MCode.vhd:720:25  */
  assign n3005_o = n3001_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:720:25  */
  assign n3008_o = n3001_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:720:25  */
  assign n3010_o = n3001_o ? 3'b111 : 3'b000;
  /* ./T80/T80_MCode.vhd:720:25  */
  assign n3012_o = n3001_o ? n2109_o : 3'b000;
  /* ./T80/T80_MCode.vhd:720:25  */
  assign n3015_o = n3001_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:710:17  */
  assign n3017_o = ir == 8'b11000110;
  /* ./T80/T80_MCode.vhd:710:32  */
  assign n3019_o = ir == 8'b11001110;
  /* ./T80/T80_MCode.vhd:710:32  */
  assign n3020_o = n3017_o | n3019_o;
  /* ./T80/T80_MCode.vhd:710:43  */
  assign n3022_o = ir == 8'b11010110;
  /* ./T80/T80_MCode.vhd:710:43  */
  assign n3023_o = n3020_o | n3022_o;
  /* ./T80/T80_MCode.vhd:710:54  */
  assign n3025_o = ir == 8'b11011110;
  /* ./T80/T80_MCode.vhd:710:54  */
  assign n3026_o = n3023_o | n3025_o;
  /* ./T80/T80_MCode.vhd:710:65  */
  assign n3028_o = ir == 8'b11100110;
  /* ./T80/T80_MCode.vhd:710:65  */
  assign n3029_o = n3026_o | n3028_o;
  /* ./T80/T80_MCode.vhd:710:76  */
  assign n3031_o = ir == 8'b11101110;
  /* ./T80/T80_MCode.vhd:710:76  */
  assign n3032_o = n3029_o | n3031_o;
  /* ./T80/T80_MCode.vhd:710:87  */
  assign n3034_o = ir == 8'b11110110;
  /* ./T80/T80_MCode.vhd:710:87  */
  assign n3035_o = n3032_o | n3034_o;
  /* ./T80/T80_MCode.vhd:710:98  */
  assign n3037_o = ir == 8'b11111110;
  /* ./T80/T80_MCode.vhd:710:98  */
  assign n3038_o = n3035_o | n3037_o;
  /* ./T80/T80_MCode.vhd:727:17  */
  assign n3040_o = ir == 8'b00000100;
  /* ./T80/T80_MCode.vhd:727:32  */
  assign n3042_o = ir == 8'b00001100;
  /* ./T80/T80_MCode.vhd:727:32  */
  assign n3043_o = n3040_o | n3042_o;
  /* ./T80/T80_MCode.vhd:727:43  */
  assign n3045_o = ir == 8'b00010100;
  /* ./T80/T80_MCode.vhd:727:43  */
  assign n3046_o = n3043_o | n3045_o;
  /* ./T80/T80_MCode.vhd:727:54  */
  assign n3048_o = ir == 8'b00011100;
  /* ./T80/T80_MCode.vhd:727:54  */
  assign n3049_o = n3046_o | n3048_o;
  /* ./T80/T80_MCode.vhd:727:65  */
  assign n3051_o = ir == 8'b00100100;
  /* ./T80/T80_MCode.vhd:727:65  */
  assign n3052_o = n3049_o | n3051_o;
  /* ./T80/T80_MCode.vhd:727:76  */
  assign n3054_o = ir == 8'b00101100;
  /* ./T80/T80_MCode.vhd:727:76  */
  assign n3055_o = n3052_o | n3054_o;
  /* ./T80/T80_MCode.vhd:727:87  */
  assign n3057_o = ir == 8'b00111100;
  /* ./T80/T80_MCode.vhd:727:87  */
  assign n3058_o = n3055_o | n3057_o;
  /* ./T80/T80_MCode.vhd:738:30  */
  assign n3059_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:739:25  */
  assign n3061_o = n3059_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:741:25  */
  assign n3063_o = n3059_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:750:25  */
  assign n3065_o = n3059_o == 31'b0000000000000000000000000000011;
  assign n3066_o = {n3065_o, n3063_o, n3061_o};
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3068_o = n2115_o;
      3'b010: n3068_o = 3'b100;
      3'b001: n3068_o = n2115_o;
      default: n3068_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3071_o = 1'b0;
      3'b010: n3071_o = 1'b1;
      3'b001: n3071_o = 1'b0;
      default: n3071_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3073_o = 3'b000;
      3'b010: n3073_o = n2108_o;
      3'b001: n3073_o = 3'b000;
      default: n3073_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3076_o = 4'b0000;
      3'b010: n3076_o = 4'b1010;
      3'b001: n3076_o = 4'b0000;
      default: n3076_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3078_o = n2118_o;
      3'b010: n3078_o = 4'b0000;
      3'b001: n3078_o = n2118_o;
      default: n3078_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3081_o = 1'b0;
      3'b010: n3081_o = 1'b1;
      3'b001: n3081_o = 1'b0;
      default: n3081_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3084_o = 1'b0;
      3'b010: n3084_o = 1'b1;
      3'b001: n3084_o = 1'b0;
      default: n3084_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3088_o = 3'b111;
      3'b010: n3088_o = 3'b010;
      3'b001: n3088_o = 3'b010;
      default: n3088_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:738:25  */
  always @*
    case (n3066_o)
      3'b100: n3091_o = 1'b1;
      3'b010: n3091_o = 1'b0;
      3'b001: n3091_o = 1'b0;
      default: n3091_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:735:17  */
  assign n3093_o = ir == 8'b00110100;
  /* ./T80/T80_MCode.vhd:754:17  */
  assign n3095_o = ir == 8'b00000101;
  /* ./T80/T80_MCode.vhd:754:32  */
  assign n3097_o = ir == 8'b00001101;
  /* ./T80/T80_MCode.vhd:754:32  */
  assign n3098_o = n3095_o | n3097_o;
  /* ./T80/T80_MCode.vhd:754:43  */
  assign n3100_o = ir == 8'b00010101;
  /* ./T80/T80_MCode.vhd:754:43  */
  assign n3101_o = n3098_o | n3100_o;
  /* ./T80/T80_MCode.vhd:754:54  */
  assign n3103_o = ir == 8'b00011101;
  /* ./T80/T80_MCode.vhd:754:54  */
  assign n3104_o = n3101_o | n3103_o;
  /* ./T80/T80_MCode.vhd:754:65  */
  assign n3106_o = ir == 8'b00100101;
  /* ./T80/T80_MCode.vhd:754:65  */
  assign n3107_o = n3104_o | n3106_o;
  /* ./T80/T80_MCode.vhd:754:76  */
  assign n3109_o = ir == 8'b00101101;
  /* ./T80/T80_MCode.vhd:754:76  */
  assign n3110_o = n3107_o | n3109_o;
  /* ./T80/T80_MCode.vhd:754:87  */
  assign n3112_o = ir == 8'b00111101;
  /* ./T80/T80_MCode.vhd:754:87  */
  assign n3113_o = n3110_o | n3112_o;
  /* ./T80/T80_MCode.vhd:765:30  */
  assign n3114_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:766:25  */
  assign n3116_o = n3114_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:768:25  */
  assign n3118_o = n3114_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:777:25  */
  assign n3120_o = n3114_o == 31'b0000000000000000000000000000011;
  assign n3121_o = {n3120_o, n3118_o, n3116_o};
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3123_o = n2115_o;
      3'b010: n3123_o = 3'b100;
      3'b001: n3123_o = n2115_o;
      default: n3123_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3126_o = 1'b0;
      3'b010: n3126_o = 1'b1;
      3'b001: n3126_o = 1'b0;
      default: n3126_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3128_o = 3'b000;
      3'b010: n3128_o = n2108_o;
      3'b001: n3128_o = 3'b000;
      default: n3128_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3131_o = 4'b0000;
      3'b010: n3131_o = 4'b1010;
      3'b001: n3131_o = 4'b0000;
      default: n3131_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3133_o = n2118_o;
      3'b010: n3133_o = 4'b0010;
      3'b001: n3133_o = n2118_o;
      default: n3133_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3136_o = 1'b0;
      3'b010: n3136_o = 1'b1;
      3'b001: n3136_o = 1'b0;
      default: n3136_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3139_o = 1'b0;
      3'b010: n3139_o = 1'b1;
      3'b001: n3139_o = 1'b0;
      default: n3139_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3143_o = 3'b111;
      3'b010: n3143_o = 3'b010;
      3'b001: n3143_o = 3'b010;
      default: n3143_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:765:25  */
  always @*
    case (n3121_o)
      3'b100: n3146_o = 1'b1;
      3'b010: n3146_o = 1'b0;
      3'b001: n3146_o = 1'b0;
      default: n3146_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:762:17  */
  assign n3148_o = ir == 8'b00110101;
  /* ./T80/T80_MCode.vhd:783:17  */
  assign n3151_o = ir == 8'b00100111;
  /* ./T80/T80_MCode.vhd:789:17  */
  assign n3153_o = ir == 8'b00101111;
  /* ./T80/T80_MCode.vhd:792:17  */
  assign n3155_o = ir == 8'b00111111;
  /* ./T80/T80_MCode.vhd:795:17  */
  assign n3157_o = ir == 8'b00110111;
  /* ./T80/T80_MCode.vhd:802:38  */
  assign n3158_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:803:33  */
  assign n3160_o = n3158_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:808:33  */
  assign n3162_o = n3158_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:813:33  */
  assign n3164_o = n3158_o == 31'b0000000000000000000000000000011;
  assign n3165_o = {n3164_o, n3162_o, n3160_o};
  /* ./T80/T80_MCode.vhd:802:33  */
  always @*
    case (n3165_o)
      3'b100: n3167_o = n2115_o;
      3'b010: n3167_o = n2115_o;
      3'b001: n3167_o = 3'b101;
      default: n3167_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:802:33  */
  always @*
    case (n3165_o)
      3'b100: n3171_o = 4'b0000;
      3'b010: n3171_o = 4'b1111;
      3'b001: n3171_o = 4'b1111;
      default: n3171_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:802:33  */
  always @*
    case (n3165_o)
      3'b100: n3175_o = 4'b0000;
      3'b010: n3175_o = 4'b1100;
      3'b001: n3175_o = 4'b1101;
      default: n3175_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:802:33  */
  always @*
    case (n3165_o)
      3'b100: n3179_o = 3'b111;
      3'b010: n3179_o = 3'b101;
      3'b001: n3179_o = 3'b101;
      default: n3179_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:802:33  */
  always @*
    case (n3165_o)
      3'b100: n3183_o = 1'b1;
      3'b010: n3183_o = 1'b1;
      3'b001: n3183_o = 1'b0;
      default: n3183_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:820:38  */
  assign n3184_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:821:33  */
  assign n3186_o = n3184_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:827:33  */
  assign n3188_o = n3184_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:833:33  */
  assign n3190_o = n3184_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:836:33  */
  assign n3192_o = n3184_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:839:33  */
  assign n3194_o = n3184_o == 31'b0000000000000000000000000000101;
  assign n3195_o = {n3194_o, n3192_o, n3190_o, n3188_o, n3186_o};
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3197_o = n2115_o;
      5'b01000: n3197_o = n2115_o;
      5'b00100: n3197_o = n2115_o;
      5'b00010: n3197_o = n2115_o;
      5'b00001: n3197_o = 3'b101;
      default: n3197_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3200_o = 1'b0;
      5'b01000: n3200_o = 1'b1;
      5'b00100: n3200_o = 1'b0;
      5'b00010: n3200_o = 1'b0;
      5'b00001: n3200_o = 1'b0;
      default: n3200_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3204_o = 4'b0000;
      5'b01000: n3204_o = 4'b0000;
      5'b00100: n3204_o = 4'b0000;
      5'b00010: n3204_o = 4'b1111;
      5'b00001: n3204_o = 4'b1111;
      default: n3204_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3208_o = 4'b0000;
      5'b01000: n3208_o = 4'b0000;
      5'b00100: n3208_o = 4'b0000;
      5'b00010: n3208_o = 4'b1100;
      5'b00001: n3208_o = 4'b1101;
      default: n3208_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3212_o = 3'b111;
      5'b01000: n3212_o = 3'b111;
      5'b00100: n3212_o = 3'b111;
      5'b00010: n3212_o = 3'b101;
      5'b00001: n3212_o = 3'b101;
      default: n3212_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3215_o = 1'b1;
      5'b01000: n3215_o = 1'b0;
      5'b00100: n3215_o = 1'b0;
      5'b00010: n3215_o = 1'b0;
      5'b00001: n3215_o = 1'b0;
      default: n3215_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3219_o = 1'b0;
      5'b01000: n3219_o = 1'b1;
      5'b00100: n3219_o = 1'b0;
      5'b00010: n3219_o = 1'b0;
      5'b00001: n3219_o = 1'b1;
      default: n3219_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:820:33  */
  always @*
    case (n3195_o)
      5'b10000: n3223_o = 1'b0;
      5'b01000: n3223_o = 1'b0;
      5'b00100: n3223_o = 1'b1;
      5'b00010: n3223_o = 1'b1;
      5'b00001: n3223_o = 1'b0;
      default: n3223_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3226_o = intcycle ? 3'b101 : 3'b001;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3227_o = intcycle ? n3197_o : n2115_o;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3229_o = intcycle ? n3200_o : 1'b0;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3231_o = intcycle ? n3204_o : 4'b0000;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3233_o = intcycle ? n3208_o : 4'b0000;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3235_o = intcycle ? n3212_o : 3'b111;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3237_o = intcycle ? n3215_o : 1'b0;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3239_o = intcycle ? n3219_o : 1'b0;
  /* ./T80/T80_MCode.vhd:817:25  */
  assign n3241_o = intcycle ? n3223_o : 1'b0;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3243_o = nmicycle ? 3'b011 : n3226_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3244_o = nmicycle ? n3167_o : n3227_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3246_o = nmicycle ? 1'b0 : n3229_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3247_o = nmicycle ? n3171_o : n3231_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3248_o = nmicycle ? n3175_o : n3233_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3249_o = nmicycle ? n3179_o : n3235_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3251_o = nmicycle ? 1'b0 : n3237_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3253_o = nmicycle ? 1'b0 : n3239_o;
  /* ./T80/T80_MCode.vhd:799:25  */
  assign n3254_o = nmicycle ? n3183_o : n3241_o;
  /* ./T80/T80_MCode.vhd:798:17  */
  assign n3256_o = ir == 8'b00000000;
  /* ./T80/T80_MCode.vhd:846:17  */
  assign n3258_o = ir == 8'b01110110;
  /* ./T80/T80_MCode.vhd:849:17  */
  assign n3260_o = ir == 8'b11110011;
  /* ./T80/T80_MCode.vhd:852:17  */
  assign n3262_o = ir == 8'b11111011;
  /* ./T80/T80_MCode.vhd:860:30  */
  assign n3263_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:867:60  */
  assign n3265_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:867:38  */
  assign n3266_o = {29'b0, n3265_o};  //  uext
  /* ./T80/T80_MCode.vhd:869:70  */
  assign n3267_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:868:33  */
  assign n3270_o = n3266_o == 31'b0000000000000000000000000000000;
  /* ./T80/T80_MCode.vhd:868:39  */
  assign n3272_o = n3266_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:868:39  */
  assign n3273_o = n3270_o | n3272_o;
  /* ./T80/T80_MCode.vhd:868:41  */
  assign n3275_o = n3266_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:868:41  */
  assign n3276_o = n3273_o | n3275_o;
  /* ./T80/T80_MCode.vhd:867:33  */
  always @*
    case (n3276_o)
      1'b1: n3278_o = 1'b1;
      default: n3278_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:867:33  */
  always @*
    case (n3276_o)
      1'b1: n3280_o = n3267_o;
      default: n3280_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:867:33  */
  always @*
    case (n3276_o)
      1'b1: n3283_o = 1'b0;
      default: n3283_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:861:25  */
  assign n3285_o = n3263_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:883:60  */
  assign n3287_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:883:38  */
  assign n3288_o = {29'b0, n3287_o};  //  uext
  /* ./T80/T80_MCode.vhd:885:70  */
  assign n3289_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:884:33  */
  assign n3291_o = n3288_o == 31'b0000000000000000000000000000000;
  /* ./T80/T80_MCode.vhd:884:39  */
  assign n3293_o = n3288_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:884:39  */
  assign n3294_o = n3291_o | n3293_o;
  /* ./T80/T80_MCode.vhd:884:41  */
  assign n3296_o = n3288_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:884:41  */
  assign n3297_o = n3294_o | n3296_o;
  /* ./T80/T80_MCode.vhd:883:33  */
  always @*
    case (n3297_o)
      1'b1: n3300_o = 1'b0;
      default: n3300_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:883:33  */
  always @*
    case (n3297_o)
      1'b1: n3302_o = n3289_o;
      default: n3302_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:883:33  */
  always @*
    case (n3297_o)
      1'b1: n3305_o = 1'b0;
      default: n3305_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:877:25  */
  assign n3307_o = n3263_o == 31'b0000000000000000000000000000011;
  assign n3308_o = {n3307_o, n3285_o};
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3310_o = n2115_o;
      2'b01: n3310_o = 3'b100;
      default: n3310_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3314_o = 1'b1;
      2'b01: n3314_o = 1'b1;
      default: n3314_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3316_o = 3'b100;
      2'b01: n3316_o = 3'b101;
      default: n3316_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3318_o = n3300_o;
      2'b01: n3318_o = n3278_o;
      default: n3318_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3320_o = n3302_o;
      2'b01: n3320_o = n3280_o;
      default: n3320_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3322_o = n3305_o;
      2'b01: n3322_o = n3283_o;
      default: n3322_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3325_o = 4'b0001;
      2'b01: n3325_o = 4'b0000;
      default: n3325_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3329_o = 1'b1;
      2'b01: n3329_o = 1'b1;
      default: n3329_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3333_o = 1'b1;
      2'b01: n3333_o = 1'b1;
      default: n3333_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3336_o = 2'b00;
      2'b01: n3336_o = 2'b11;
      default: n3336_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:860:25  */
  always @*
    case (n3308_o)
      2'b10: n3340_o = 1'b1;
      2'b01: n3340_o = 1'b1;
      default: n3340_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:857:17  */
  assign n3342_o = ir == 8'b00001001;
  /* ./T80/T80_MCode.vhd:857:32  */
  assign n3344_o = ir == 8'b00011001;
  /* ./T80/T80_MCode.vhd:857:32  */
  assign n3345_o = n3342_o | n3344_o;
  /* ./T80/T80_MCode.vhd:857:43  */
  assign n3347_o = ir == 8'b00101001;
  /* ./T80/T80_MCode.vhd:857:43  */
  assign n3348_o = n3345_o | n3347_o;
  /* ./T80/T80_MCode.vhd:857:54  */
  assign n3350_o = ir == 8'b00111001;
  /* ./T80/T80_MCode.vhd:857:54  */
  assign n3351_o = n3348_o | n3350_o;
  /* ./T80/T80_MCode.vhd:892:17  */
  assign n3354_o = ir == 8'b00000011;
  /* ./T80/T80_MCode.vhd:892:32  */
  assign n3356_o = ir == 8'b00010011;
  /* ./T80/T80_MCode.vhd:892:32  */
  assign n3357_o = n3354_o | n3356_o;
  /* ./T80/T80_MCode.vhd:892:43  */
  assign n3359_o = ir == 8'b00100011;
  /* ./T80/T80_MCode.vhd:892:43  */
  assign n3360_o = n3357_o | n3359_o;
  /* ./T80/T80_MCode.vhd:892:54  */
  assign n3362_o = ir == 8'b00110011;
  /* ./T80/T80_MCode.vhd:892:54  */
  assign n3363_o = n3360_o | n3362_o;
  /* ./T80/T80_MCode.vhd:897:17  */
  assign n3366_o = ir == 8'b00001011;
  /* ./T80/T80_MCode.vhd:897:32  */
  assign n3368_o = ir == 8'b00011011;
  /* ./T80/T80_MCode.vhd:897:32  */
  assign n3369_o = n3366_o | n3368_o;
  /* ./T80/T80_MCode.vhd:897:43  */
  assign n3371_o = ir == 8'b00101011;
  /* ./T80/T80_MCode.vhd:897:43  */
  assign n3372_o = n3369_o | n3371_o;
  /* ./T80/T80_MCode.vhd:897:54  */
  assign n3374_o = ir == 8'b00111011;
  /* ./T80/T80_MCode.vhd:897:54  */
  assign n3375_o = n3372_o | n3374_o;
  /* ./T80/T80_MCode.vhd:904:17  */
  assign n3378_o = ir == 8'b00000111;
  /* ./T80/T80_MCode.vhd:906:25  */
  assign n3380_o = ir == 8'b00010111;
  /* ./T80/T80_MCode.vhd:906:25  */
  assign n3381_o = n3378_o | n3380_o;
  /* ./T80/T80_MCode.vhd:908:25  */
  assign n3383_o = ir == 8'b00001111;
  /* ./T80/T80_MCode.vhd:908:25  */
  assign n3384_o = n3381_o | n3383_o;
  /* ./T80/T80_MCode.vhd:910:25  */
  assign n3386_o = ir == 8'b00011111;
  /* ./T80/T80_MCode.vhd:910:25  */
  assign n3387_o = n3384_o | n3386_o;
  /* ./T80/T80_MCode.vhd:921:30  */
  assign n3388_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:922:25  */
  assign n3390_o = n3388_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:925:25  */
  assign n3392_o = n3388_o == 31'b0000000000000000000000000000011;
  assign n3393_o = {n3392_o, n3390_o};
  /* ./T80/T80_MCode.vhd:921:25  */
  always @*
    case (n3393_o)
      2'b10: n3397_o = 1'b1;
      2'b01: n3397_o = 1'b1;
      default: n3397_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:921:25  */
  always @*
    case (n3393_o)
      2'b10: n3400_o = 1'b1;
      2'b01: n3400_o = 1'b0;
      default: n3400_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:921:25  */
  always @*
    case (n3393_o)
      2'b10: n3403_o = 1'b0;
      2'b01: n3403_o = 1'b1;
      default: n3403_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:921:25  */
  always @*
    case (n3393_o)
      2'b10: n3406_o = 1'b1;
      2'b01: n3406_o = 1'b0;
      default: n3406_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:918:17  */
  assign n3408_o = ir == 8'b11000011;
  /* ./T80/T80_MCode.vhd:990:38  */
  assign n3410_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:991:33  */
  assign n3412_o = n3410_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:997:73  */
  assign n3414_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:178:47  */
  assign n3419_o = f[6];
  /* ./T80/T80_MCode.vhd:178:56  */
  assign n3420_o = ~n3419_o;
  /* ./T80/T80_MCode.vhd:178:25  */
  assign n3422_o = n3414_o == 3'b000;
  /* ./T80/T80_MCode.vhd:179:47  */
  assign n3423_o = f[6];
  /* ./T80/T80_MCode.vhd:179:25  */
  assign n3425_o = n3414_o == 3'b001;
  /* ./T80/T80_MCode.vhd:180:47  */
  assign n3426_o = f[0];
  /* ./T80/T80_MCode.vhd:180:56  */
  assign n3427_o = ~n3426_o;
  /* ./T80/T80_MCode.vhd:180:25  */
  assign n3429_o = n3414_o == 3'b010;
  /* ./T80/T80_MCode.vhd:181:47  */
  assign n3430_o = f[0];
  /* ./T80/T80_MCode.vhd:181:25  */
  assign n3432_o = n3414_o == 3'b011;
  /* ./T80/T80_MCode.vhd:182:47  */
  assign n3433_o = f[2];
  /* ./T80/T80_MCode.vhd:182:56  */
  assign n3434_o = ~n3433_o;
  /* ./T80/T80_MCode.vhd:182:25  */
  assign n3436_o = n3414_o == 3'b100;
  /* ./T80/T80_MCode.vhd:183:47  */
  assign n3437_o = f[2];
  /* ./T80/T80_MCode.vhd:183:25  */
  assign n3439_o = n3414_o == 3'b101;
  /* ./T80/T80_MCode.vhd:184:47  */
  assign n3440_o = f[7];
  /* ./T80/T80_MCode.vhd:184:56  */
  assign n3441_o = ~n3440_o;
  /* ./T80/T80_MCode.vhd:184:25  */
  assign n3443_o = n3414_o == 3'b110;
  /* ./T80/T80_MCode.vhd:185:47  */
  assign n3444_o = f[7];
  /* ./T80/T80_MCode.vhd:185:25  */
  assign n3446_o = n3414_o == 3'b111;
  assign n3447_o = {n3446_o, n3443_o, n3439_o, n3436_o, n3432_o, n3429_o, n3425_o, n3422_o};
  /* ./T80/T80_MCode.vhd:177:25  */
  always @*
    case (n3447_o)
      8'b10000000: n3449_o = n3444_o;
      8'b01000000: n3449_o = n3441_o;
      8'b00100000: n3449_o = n3437_o;
      8'b00010000: n3449_o = n3434_o;
      8'b00001000: n3449_o = n3430_o;
      8'b00000100: n3449_o = n3427_o;
      8'b00000010: n3449_o = n3423_o;
      8'b00000001: n3449_o = n3420_o;
      default: n3449_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:997:41  */
  assign n3452_o = n3449_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:994:33  */
  assign n3454_o = n3410_o == 31'b0000000000000000000000000000011;
  assign n3455_o = {n3454_o, n3412_o};
  /* ./T80/T80_MCode.vhd:990:33  */
  always @*
    case (n3455_o)
      2'b10: n3459_o = 1'b1;
      2'b01: n3459_o = 1'b1;
      default: n3459_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:990:33  */
  always @*
    case (n3455_o)
      2'b10: n3461_o = n3452_o;
      2'b01: n3461_o = 1'b0;
      default: n3461_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:990:33  */
  always @*
    case (n3455_o)
      2'b10: n3464_o = 1'b0;
      2'b01: n3464_o = 1'b1;
      default: n3464_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:990:33  */
  always @*
    case (n3455_o)
      2'b10: n3467_o = 1'b1;
      2'b01: n3467_o = 1'b0;
      default: n3467_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:931:17  */
  assign n3469_o = ir == 8'b11000010;
  /* ./T80/T80_MCode.vhd:931:32  */
  assign n3471_o = ir == 8'b11001010;
  /* ./T80/T80_MCode.vhd:931:32  */
  assign n3472_o = n3469_o | n3471_o;
  /* ./T80/T80_MCode.vhd:931:43  */
  assign n3474_o = ir == 8'b11010010;
  /* ./T80/T80_MCode.vhd:931:43  */
  assign n3475_o = n3472_o | n3474_o;
  /* ./T80/T80_MCode.vhd:931:54  */
  assign n3477_o = ir == 8'b11011010;
  /* ./T80/T80_MCode.vhd:931:54  */
  assign n3478_o = n3475_o | n3477_o;
  /* ./T80/T80_MCode.vhd:931:65  */
  assign n3480_o = ir == 8'b11100010;
  /* ./T80/T80_MCode.vhd:931:65  */
  assign n3481_o = n3478_o | n3480_o;
  /* ./T80/T80_MCode.vhd:931:76  */
  assign n3483_o = ir == 8'b11101010;
  /* ./T80/T80_MCode.vhd:931:76  */
  assign n3484_o = n3481_o | n3483_o;
  /* ./T80/T80_MCode.vhd:931:87  */
  assign n3486_o = ir == 8'b11110010;
  /* ./T80/T80_MCode.vhd:931:87  */
  assign n3487_o = n3484_o | n3486_o;
  /* ./T80/T80_MCode.vhd:931:98  */
  assign n3489_o = ir == 8'b11111010;
  /* ./T80/T80_MCode.vhd:931:98  */
  assign n3490_o = n3487_o | n3489_o;
  /* ./T80/T80_MCode.vhd:1007:38  */
  assign n3491_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1008:33  */
  assign n3493_o = n3491_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1010:33  */
  assign n3495_o = n3491_o == 31'b0000000000000000000000000000011;
  assign n3496_o = {n3495_o, n3493_o};
  /* ./T80/T80_MCode.vhd:1007:33  */
  always @*
    case (n3496_o)
      2'b10: n3498_o = 3'b101;
      2'b01: n3498_o = n2115_o;
      default: n3498_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1007:33  */
  always @*
    case (n3496_o)
      2'b10: n3501_o = 1'b0;
      2'b01: n3501_o = 1'b1;
      default: n3501_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1007:33  */
  always @*
    case (n3496_o)
      2'b10: n3504_o = 1'b1;
      2'b01: n3504_o = 1'b0;
      default: n3504_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1007:33  */
  always @*
    case (n3496_o)
      2'b10: n3507_o = 1'b1;
      2'b01: n3507_o = 1'b0;
      default: n3507_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1003:17  */
  assign n3509_o = ir == 8'b00011000;
  /* ./T80/T80_MCode.vhd:1021:38  */
  assign n3510_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1024:45  */
  assign n3511_o = f[0];
  /* ./T80/T80_MCode.vhd:1024:54  */
  assign n3512_o = ~n3511_o;
  /* ./T80/T80_MCode.vhd:1024:41  */
  assign n3515_o = n3512_o ? 3'b010 : 3'b011;
  /* ./T80/T80_MCode.vhd:1022:33  */
  assign n3517_o = n3510_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1027:33  */
  assign n3519_o = n3510_o == 31'b0000000000000000000000000000011;
  assign n3520_o = {n3519_o, n3517_o};
  /* ./T80/T80_MCode.vhd:1021:33  */
  always @*
    case (n3520_o)
      2'b10: n3522_o = 3'b011;
      2'b01: n3522_o = n3515_o;
      default: n3522_o = 3'b011;
    endcase
  /* ./T80/T80_MCode.vhd:1021:33  */
  always @*
    case (n3520_o)
      2'b10: n3525_o = 3'b101;
      2'b01: n3525_o = n2115_o;
      default: n3525_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1021:33  */
  always @*
    case (n3520_o)
      2'b10: n3528_o = 1'b0;
      2'b01: n3528_o = 1'b1;
      default: n3528_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1021:33  */
  always @*
    case (n3520_o)
      2'b10: n3531_o = 1'b1;
      2'b01: n3531_o = 1'b0;
      default: n3531_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1021:33  */
  always @*
    case (n3520_o)
      2'b10: n3534_o = 1'b1;
      2'b01: n3534_o = 1'b0;
      default: n3534_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1017:17  */
  assign n3536_o = ir == 8'b00111000;
  /* ./T80/T80_MCode.vhd:1038:38  */
  assign n3537_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1041:45  */
  assign n3538_o = f[0];
  /* ./T80/T80_MCode.vhd:1041:41  */
  assign n3541_o = n3538_o ? 3'b010 : 3'b011;
  /* ./T80/T80_MCode.vhd:1039:33  */
  assign n3543_o = n3537_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1044:33  */
  assign n3545_o = n3537_o == 31'b0000000000000000000000000000011;
  assign n3546_o = {n3545_o, n3543_o};
  /* ./T80/T80_MCode.vhd:1038:33  */
  always @*
    case (n3546_o)
      2'b10: n3548_o = 3'b011;
      2'b01: n3548_o = n3541_o;
      default: n3548_o = 3'b011;
    endcase
  /* ./T80/T80_MCode.vhd:1038:33  */
  always @*
    case (n3546_o)
      2'b10: n3551_o = 3'b101;
      2'b01: n3551_o = n2115_o;
      default: n3551_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1038:33  */
  always @*
    case (n3546_o)
      2'b10: n3554_o = 1'b0;
      2'b01: n3554_o = 1'b1;
      default: n3554_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1038:33  */
  always @*
    case (n3546_o)
      2'b10: n3557_o = 1'b1;
      2'b01: n3557_o = 1'b0;
      default: n3557_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1038:33  */
  always @*
    case (n3546_o)
      2'b10: n3560_o = 1'b1;
      2'b01: n3560_o = 1'b0;
      default: n3560_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1034:17  */
  assign n3562_o = ir == 8'b00110000;
  /* ./T80/T80_MCode.vhd:1055:38  */
  assign n3563_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1058:45  */
  assign n3564_o = f[6];
  /* ./T80/T80_MCode.vhd:1058:54  */
  assign n3565_o = ~n3564_o;
  /* ./T80/T80_MCode.vhd:1058:41  */
  assign n3568_o = n3565_o ? 3'b010 : 3'b011;
  /* ./T80/T80_MCode.vhd:1056:33  */
  assign n3570_o = n3563_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1061:33  */
  assign n3572_o = n3563_o == 31'b0000000000000000000000000000011;
  assign n3573_o = {n3572_o, n3570_o};
  /* ./T80/T80_MCode.vhd:1055:33  */
  always @*
    case (n3573_o)
      2'b10: n3575_o = 3'b011;
      2'b01: n3575_o = n3568_o;
      default: n3575_o = 3'b011;
    endcase
  /* ./T80/T80_MCode.vhd:1055:33  */
  always @*
    case (n3573_o)
      2'b10: n3578_o = 3'b101;
      2'b01: n3578_o = n2115_o;
      default: n3578_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1055:33  */
  always @*
    case (n3573_o)
      2'b10: n3581_o = 1'b0;
      2'b01: n3581_o = 1'b1;
      default: n3581_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1055:33  */
  always @*
    case (n3573_o)
      2'b10: n3584_o = 1'b1;
      2'b01: n3584_o = 1'b0;
      default: n3584_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1055:33  */
  always @*
    case (n3573_o)
      2'b10: n3587_o = 1'b1;
      2'b01: n3587_o = 1'b0;
      default: n3587_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1051:17  */
  assign n3589_o = ir == 8'b00101000;
  /* ./T80/T80_MCode.vhd:1072:38  */
  assign n3590_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1075:45  */
  assign n3591_o = f[6];
  /* ./T80/T80_MCode.vhd:1075:41  */
  assign n3594_o = n3591_o ? 3'b010 : 3'b011;
  /* ./T80/T80_MCode.vhd:1073:33  */
  assign n3596_o = n3590_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1078:33  */
  assign n3598_o = n3590_o == 31'b0000000000000000000000000000011;
  assign n3599_o = {n3598_o, n3596_o};
  /* ./T80/T80_MCode.vhd:1072:33  */
  always @*
    case (n3599_o)
      2'b10: n3601_o = 3'b011;
      2'b01: n3601_o = n3594_o;
      default: n3601_o = 3'b011;
    endcase
  /* ./T80/T80_MCode.vhd:1072:33  */
  always @*
    case (n3599_o)
      2'b10: n3604_o = 3'b101;
      2'b01: n3604_o = n2115_o;
      default: n3604_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1072:33  */
  always @*
    case (n3599_o)
      2'b10: n3607_o = 1'b0;
      2'b01: n3607_o = 1'b1;
      default: n3607_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1072:33  */
  always @*
    case (n3599_o)
      2'b10: n3610_o = 1'b1;
      2'b01: n3610_o = 1'b0;
      default: n3610_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1072:33  */
  always @*
    case (n3599_o)
      2'b10: n3613_o = 1'b1;
      2'b01: n3613_o = 1'b0;
      default: n3613_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1068:17  */
  assign n3615_o = ir == 8'b00100000;
  /* ./T80/T80_MCode.vhd:1085:17  */
  assign n3617_o = ir == 8'b11101001;
  /* ./T80/T80_MCode.vhd:1094:38  */
  assign n3618_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1095:33  */
  assign n3621_o = n3618_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1103:33  */
  assign n3623_o = n3618_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1106:33  */
  assign n3625_o = n3618_o == 31'b0000000000000000000000000000011;
  assign n3626_o = {n3625_o, n3623_o, n3621_o};
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3629_o = 3'b101;
      3'b010: n3629_o = n2115_o;
      3'b001: n3629_o = 3'b101;
      default: n3629_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3632_o = 1'b0;
      3'b010: n3632_o = 1'b1;
      3'b001: n3632_o = 1'b0;
      default: n3632_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3635_o = 1'b0;
      3'b010: n3635_o = 1'b0;
      3'b001: n3635_o = 1'b1;
      default: n3635_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3637_o = 3'b000;
      3'b010: n3637_o = 3'b000;
      3'b001: n3637_o = 3'b000;
      default: n3637_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3640_o = 4'b0000;
      3'b010: n3640_o = 4'b0000;
      3'b001: n3640_o = 4'b1010;
      default: n3640_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3642_o = n2118_o;
      3'b010: n3642_o = n2118_o;
      3'b001: n3642_o = 4'b0010;
      default: n3642_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3645_o = 1'b0;
      3'b010: n3645_o = 1'b0;
      3'b001: n3645_o = 1'b1;
      default: n3645_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3648_o = 1'b1;
      3'b010: n3648_o = 1'b0;
      3'b001: n3648_o = 1'b0;
      default: n3648_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3652_o = 1'b0;
      3'b010: n3652_o = 1'b1;
      3'b001: n3652_o = 1'b1;
      default: n3652_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1094:33  */
  always @*
    case (n3626_o)
      3'b100: n3655_o = 1'b1;
      3'b010: n3655_o = 1'b0;
      3'b001: n3655_o = 1'b0;
      default: n3655_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1088:17  */
  assign n3657_o = ir == 8'b00010000;
  /* ./T80/T80_MCode.vhd:1118:30  */
  assign n3658_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1119:25  */
  assign n3660_o = n3658_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1122:25  */
  assign n3662_o = n3658_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1129:25  */
  assign n3664_o = n3658_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:1134:25  */
  assign n3666_o = n3658_o == 31'b0000000000000000000000000000101;
  assign n3667_o = {n3666_o, n3664_o, n3662_o, n3660_o};
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3669_o = n2115_o;
      4'b0100: n3669_o = n2115_o;
      4'b0010: n3669_o = 3'b100;
      4'b0001: n3669_o = n2115_o;
      default: n3669_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3673_o = 1'b0;
      4'b0100: n3673_o = 1'b0;
      4'b0010: n3673_o = 1'b1;
      4'b0001: n3673_o = 1'b1;
      default: n3673_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3677_o = 4'b0000;
      4'b0100: n3677_o = 4'b1111;
      4'b0010: n3677_o = 4'b1111;
      4'b0001: n3677_o = 4'b0000;
      default: n3677_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3681_o = 4'b0000;
      4'b0100: n3681_o = 4'b1100;
      4'b0010: n3681_o = 4'b1101;
      4'b0001: n3681_o = 4'b0000;
      default: n3681_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3685_o = 3'b111;
      4'b0100: n3685_o = 3'b101;
      4'b0010: n3685_o = 3'b101;
      4'b0001: n3685_o = 3'b111;
      default: n3685_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3688_o = 1'b1;
      4'b0100: n3688_o = 1'b0;
      4'b0010: n3688_o = 1'b0;
      4'b0001: n3688_o = 1'b0;
      default: n3688_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3691_o = 1'b0;
      4'b0100: n3691_o = 1'b0;
      4'b0010: n3691_o = 1'b0;
      4'b0001: n3691_o = 1'b1;
      default: n3691_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3694_o = 1'b0;
      4'b0100: n3694_o = 1'b0;
      4'b0010: n3694_o = 1'b1;
      4'b0001: n3694_o = 1'b0;
      default: n3694_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1118:25  */
  always @*
    case (n3667_o)
      4'b1000: n3698_o = 1'b1;
      4'b0100: n3698_o = 1'b1;
      4'b0010: n3698_o = 1'b0;
      4'b0001: n3698_o = 1'b0;
      default: n3698_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1115:17  */
  assign n3700_o = ir == 8'b11001101;
  /* ./T80/T80_MCode.vhd:1143:38  */
  assign n3703_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1144:33  */
  assign n3705_o = n3703_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1150:73  */
  assign n3707_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:178:47  */
  assign n3712_o = f[6];
  /* ./T80/T80_MCode.vhd:178:56  */
  assign n3713_o = ~n3712_o;
  /* ./T80/T80_MCode.vhd:178:25  */
  assign n3715_o = n3707_o == 3'b000;
  /* ./T80/T80_MCode.vhd:179:47  */
  assign n3716_o = f[6];
  /* ./T80/T80_MCode.vhd:179:25  */
  assign n3718_o = n3707_o == 3'b001;
  /* ./T80/T80_MCode.vhd:180:47  */
  assign n3719_o = f[0];
  /* ./T80/T80_MCode.vhd:180:56  */
  assign n3720_o = ~n3719_o;
  /* ./T80/T80_MCode.vhd:180:25  */
  assign n3722_o = n3707_o == 3'b010;
  /* ./T80/T80_MCode.vhd:181:47  */
  assign n3723_o = f[0];
  /* ./T80/T80_MCode.vhd:181:25  */
  assign n3725_o = n3707_o == 3'b011;
  /* ./T80/T80_MCode.vhd:182:47  */
  assign n3726_o = f[2];
  /* ./T80/T80_MCode.vhd:182:56  */
  assign n3727_o = ~n3726_o;
  /* ./T80/T80_MCode.vhd:182:25  */
  assign n3729_o = n3707_o == 3'b100;
  /* ./T80/T80_MCode.vhd:183:47  */
  assign n3730_o = f[2];
  /* ./T80/T80_MCode.vhd:183:25  */
  assign n3732_o = n3707_o == 3'b101;
  /* ./T80/T80_MCode.vhd:184:47  */
  assign n3733_o = f[7];
  /* ./T80/T80_MCode.vhd:184:56  */
  assign n3734_o = ~n3733_o;
  /* ./T80/T80_MCode.vhd:184:25  */
  assign n3736_o = n3707_o == 3'b110;
  /* ./T80/T80_MCode.vhd:185:47  */
  assign n3737_o = f[7];
  /* ./T80/T80_MCode.vhd:185:25  */
  assign n3739_o = n3707_o == 3'b111;
  assign n3740_o = {n3739_o, n3736_o, n3732_o, n3729_o, n3725_o, n3722_o, n3718_o, n3715_o};
  /* ./T80/T80_MCode.vhd:177:25  */
  always @*
    case (n3740_o)
      8'b10000000: n3742_o = n3737_o;
      8'b01000000: n3742_o = n3734_o;
      8'b00100000: n3742_o = n3730_o;
      8'b00010000: n3742_o = n3727_o;
      8'b00001000: n3742_o = n3723_o;
      8'b00000100: n3742_o = n3720_o;
      8'b00000010: n3742_o = n3716_o;
      8'b00000001: n3742_o = n3713_o;
      default: n3742_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1150:41  */
  assign n3745_o = n3742_o ? 3'b101 : 3'b011;
  /* ./T80/T80_MCode.vhd:1150:41  */
  assign n3747_o = n3742_o ? 3'b100 : n2115_o;
  /* ./T80/T80_MCode.vhd:1150:41  */
  assign n3750_o = n3742_o ? 4'b1111 : 4'b0000;
  /* ./T80/T80_MCode.vhd:1150:41  */
  assign n3753_o = n3742_o ? 4'b1101 : 4'b0000;
  /* ./T80/T80_MCode.vhd:1150:41  */
  assign n3756_o = n3742_o ? 3'b101 : 3'b111;
  /* ./T80/T80_MCode.vhd:1147:33  */
  assign n3758_o = n3703_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1158:33  */
  assign n3760_o = n3703_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:1163:33  */
  assign n3762_o = n3703_o == 31'b0000000000000000000000000000101;
  assign n3763_o = {n3762_o, n3760_o, n3758_o, n3705_o};
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3765_o = 3'b101;
      4'b0100: n3765_o = 3'b101;
      4'b0010: n3765_o = n3745_o;
      4'b0001: n3765_o = 3'b101;
      default: n3765_o = 3'b101;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3767_o = n2115_o;
      4'b0100: n3767_o = n2115_o;
      4'b0010: n3767_o = n3747_o;
      4'b0001: n3767_o = n2115_o;
      default: n3767_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3771_o = 1'b0;
      4'b0100: n3771_o = 1'b0;
      4'b0010: n3771_o = 1'b1;
      4'b0001: n3771_o = 1'b1;
      default: n3771_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3774_o = 4'b0000;
      4'b0100: n3774_o = 4'b1111;
      4'b0010: n3774_o = n3750_o;
      4'b0001: n3774_o = 4'b0000;
      default: n3774_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3777_o = 4'b0000;
      4'b0100: n3777_o = 4'b1100;
      4'b0010: n3777_o = n3753_o;
      4'b0001: n3777_o = 4'b0000;
      default: n3777_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3780_o = 3'b111;
      4'b0100: n3780_o = 3'b101;
      4'b0010: n3780_o = n3756_o;
      4'b0001: n3780_o = 3'b111;
      default: n3780_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3783_o = 1'b1;
      4'b0100: n3783_o = 1'b0;
      4'b0010: n3783_o = 1'b0;
      4'b0001: n3783_o = 1'b0;
      default: n3783_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3786_o = 1'b0;
      4'b0100: n3786_o = 1'b0;
      4'b0010: n3786_o = 1'b0;
      4'b0001: n3786_o = 1'b1;
      default: n3786_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3789_o = 1'b0;
      4'b0100: n3789_o = 1'b0;
      4'b0010: n3789_o = 1'b1;
      4'b0001: n3789_o = 1'b0;
      default: n3789_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1143:33  */
  always @*
    case (n3763_o)
      4'b1000: n3793_o = 1'b1;
      4'b0100: n3793_o = 1'b1;
      4'b0010: n3793_o = 1'b0;
      4'b0001: n3793_o = 1'b0;
      default: n3793_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1139:17  */
  assign n3795_o = ir == 8'b11000100;
  /* ./T80/T80_MCode.vhd:1139:32  */
  assign n3797_o = ir == 8'b11001100;
  /* ./T80/T80_MCode.vhd:1139:32  */
  assign n3798_o = n3795_o | n3797_o;
  /* ./T80/T80_MCode.vhd:1139:43  */
  assign n3800_o = ir == 8'b11010100;
  /* ./T80/T80_MCode.vhd:1139:43  */
  assign n3801_o = n3798_o | n3800_o;
  /* ./T80/T80_MCode.vhd:1139:54  */
  assign n3803_o = ir == 8'b11011100;
  /* ./T80/T80_MCode.vhd:1139:54  */
  assign n3804_o = n3801_o | n3803_o;
  /* ./T80/T80_MCode.vhd:1139:65  */
  assign n3806_o = ir == 8'b11100100;
  /* ./T80/T80_MCode.vhd:1139:65  */
  assign n3807_o = n3804_o | n3806_o;
  /* ./T80/T80_MCode.vhd:1139:76  */
  assign n3809_o = ir == 8'b11101100;
  /* ./T80/T80_MCode.vhd:1139:76  */
  assign n3810_o = n3807_o | n3809_o;
  /* ./T80/T80_MCode.vhd:1139:87  */
  assign n3812_o = ir == 8'b11110100;
  /* ./T80/T80_MCode.vhd:1139:87  */
  assign n3813_o = n3810_o | n3812_o;
  /* ./T80/T80_MCode.vhd:1139:98  */
  assign n3815_o = ir == 8'b11111100;
  /* ./T80/T80_MCode.vhd:1139:98  */
  assign n3816_o = n3813_o | n3815_o;
  /* ./T80/T80_MCode.vhd:1172:30  */
  assign n3817_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1173:25  */
  assign n3819_o = n3817_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1176:25  */
  assign n3821_o = n3817_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1180:25  */
  assign n3823_o = n3817_o == 31'b0000000000000000000000000000011;
  assign n3824_o = {n3823_o, n3821_o, n3819_o};
  /* ./T80/T80_MCode.vhd:1172:25  */
  always @*
    case (n3824_o)
      3'b100: n3828_o = 4'b0111;
      3'b010: n3828_o = 4'b0111;
      3'b001: n3828_o = 4'b0000;
      default: n3828_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1172:25  */
  always @*
    case (n3824_o)
      3'b100: n3832_o = 3'b111;
      3'b010: n3832_o = 3'b101;
      3'b001: n3832_o = 3'b101;
      default: n3832_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1172:25  */
  always @*
    case (n3824_o)
      3'b100: n3835_o = 1'b1;
      3'b010: n3835_o = 1'b0;
      3'b001: n3835_o = 1'b0;
      default: n3835_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1172:25  */
  always @*
    case (n3824_o)
      3'b100: n3838_o = 1'b0;
      3'b010: n3838_o = 1'b1;
      3'b001: n3838_o = 1'b0;
      default: n3838_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1169:17  */
  assign n3840_o = ir == 8'b11001001;
  /* ./T80/T80_MCode.vhd:1256:38  */
  assign n3842_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1258:73  */
  assign n3844_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:178:47  */
  assign n3849_o = f[6];
  /* ./T80/T80_MCode.vhd:178:56  */
  assign n3850_o = ~n3849_o;
  /* ./T80/T80_MCode.vhd:178:25  */
  assign n3852_o = n3844_o == 3'b000;
  /* ./T80/T80_MCode.vhd:179:47  */
  assign n3853_o = f[6];
  /* ./T80/T80_MCode.vhd:179:25  */
  assign n3855_o = n3844_o == 3'b001;
  /* ./T80/T80_MCode.vhd:180:47  */
  assign n3856_o = f[0];
  /* ./T80/T80_MCode.vhd:180:56  */
  assign n3857_o = ~n3856_o;
  /* ./T80/T80_MCode.vhd:180:25  */
  assign n3859_o = n3844_o == 3'b010;
  /* ./T80/T80_MCode.vhd:181:47  */
  assign n3860_o = f[0];
  /* ./T80/T80_MCode.vhd:181:25  */
  assign n3862_o = n3844_o == 3'b011;
  /* ./T80/T80_MCode.vhd:182:47  */
  assign n3863_o = f[2];
  /* ./T80/T80_MCode.vhd:182:56  */
  assign n3864_o = ~n3863_o;
  /* ./T80/T80_MCode.vhd:182:25  */
  assign n3866_o = n3844_o == 3'b100;
  /* ./T80/T80_MCode.vhd:183:47  */
  assign n3867_o = f[2];
  /* ./T80/T80_MCode.vhd:183:25  */
  assign n3869_o = n3844_o == 3'b101;
  /* ./T80/T80_MCode.vhd:184:47  */
  assign n3870_o = f[7];
  /* ./T80/T80_MCode.vhd:184:56  */
  assign n3871_o = ~n3870_o;
  /* ./T80/T80_MCode.vhd:184:25  */
  assign n3873_o = n3844_o == 3'b110;
  /* ./T80/T80_MCode.vhd:185:47  */
  assign n3874_o = f[7];
  /* ./T80/T80_MCode.vhd:185:25  */
  assign n3876_o = n3844_o == 3'b111;
  assign n3877_o = {n3876_o, n3873_o, n3869_o, n3866_o, n3862_o, n3859_o, n3855_o, n3852_o};
  /* ./T80/T80_MCode.vhd:177:25  */
  always @*
    case (n3877_o)
      8'b10000000: n3879_o = n3874_o;
      8'b01000000: n3879_o = n3871_o;
      8'b00100000: n3879_o = n3867_o;
      8'b00010000: n3879_o = n3864_o;
      8'b00001000: n3879_o = n3860_o;
      8'b00000100: n3879_o = n3857_o;
      8'b00000010: n3879_o = n3853_o;
      8'b00000001: n3879_o = n3850_o;
      default: n3879_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1258:41  */
  assign n3882_o = n3879_o ? 3'b011 : 3'b001;
  /* ./T80/T80_MCode.vhd:1258:41  */
  assign n3885_o = n3879_o ? 3'b101 : 3'b111;
  /* ./T80/T80_MCode.vhd:1257:33  */
  assign n3887_o = n3842_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1264:33  */
  assign n3889_o = n3842_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1268:33  */
  assign n3891_o = n3842_o == 31'b0000000000000000000000000000011;
  assign n3892_o = {n3891_o, n3889_o, n3887_o};
  /* ./T80/T80_MCode.vhd:1256:33  */
  always @*
    case (n3892_o)
      3'b100: n3894_o = 3'b011;
      3'b010: n3894_o = 3'b011;
      3'b001: n3894_o = n3882_o;
      default: n3894_o = 3'b011;
    endcase
  /* ./T80/T80_MCode.vhd:1256:33  */
  always @*
    case (n3892_o)
      3'b100: n3897_o = n2115_o;
      3'b010: n3897_o = n2115_o;
      3'b001: n3897_o = 3'b101;
      default: n3897_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1256:33  */
  always @*
    case (n3892_o)
      3'b100: n3901_o = 4'b0111;
      3'b010: n3901_o = 4'b0111;
      3'b001: n3901_o = 4'b0000;
      default: n3901_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1256:33  */
  always @*
    case (n3892_o)
      3'b100: n3904_o = 3'b111;
      3'b010: n3904_o = 3'b101;
      3'b001: n3904_o = n3885_o;
      default: n3904_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1256:33  */
  always @*
    case (n3892_o)
      3'b100: n3907_o = 1'b1;
      3'b010: n3907_o = 1'b0;
      3'b001: n3907_o = 1'b0;
      default: n3907_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1256:33  */
  always @*
    case (n3892_o)
      3'b100: n3910_o = 1'b0;
      3'b010: n3910_o = 1'b1;
      3'b001: n3910_o = 1'b0;
      default: n3910_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1185:17  */
  assign n3912_o = ir == 8'b11000000;
  /* ./T80/T80_MCode.vhd:1185:32  */
  assign n3914_o = ir == 8'b11001000;
  /* ./T80/T80_MCode.vhd:1185:32  */
  assign n3915_o = n3912_o | n3914_o;
  /* ./T80/T80_MCode.vhd:1185:43  */
  assign n3917_o = ir == 8'b11010000;
  /* ./T80/T80_MCode.vhd:1185:43  */
  assign n3918_o = n3915_o | n3917_o;
  /* ./T80/T80_MCode.vhd:1185:54  */
  assign n3920_o = ir == 8'b11011000;
  /* ./T80/T80_MCode.vhd:1185:54  */
  assign n3921_o = n3918_o | n3920_o;
  /* ./T80/T80_MCode.vhd:1185:65  */
  assign n3923_o = ir == 8'b11100000;
  /* ./T80/T80_MCode.vhd:1185:65  */
  assign n3924_o = n3921_o | n3923_o;
  /* ./T80/T80_MCode.vhd:1185:76  */
  assign n3926_o = ir == 8'b11101000;
  /* ./T80/T80_MCode.vhd:1185:76  */
  assign n3927_o = n3924_o | n3926_o;
  /* ./T80/T80_MCode.vhd:1185:87  */
  assign n3929_o = ir == 8'b11110000;
  /* ./T80/T80_MCode.vhd:1185:87  */
  assign n3930_o = n3927_o | n3929_o;
  /* ./T80/T80_MCode.vhd:1185:98  */
  assign n3932_o = ir == 8'b11111000;
  /* ./T80/T80_MCode.vhd:1185:98  */
  assign n3933_o = n3930_o | n3932_o;
  /* ./T80/T80_MCode.vhd:1277:30  */
  assign n3934_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1278:25  */
  assign n3936_o = n3934_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1283:25  */
  assign n3938_o = n3934_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1288:25  */
  assign n3940_o = n3934_o == 31'b0000000000000000000000000000011;
  assign n3941_o = {n3940_o, n3938_o, n3936_o};
  /* ./T80/T80_MCode.vhd:1277:25  */
  always @*
    case (n3941_o)
      3'b100: n3943_o = n2115_o;
      3'b010: n3943_o = n2115_o;
      3'b001: n3943_o = 3'b101;
      default: n3943_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1277:25  */
  always @*
    case (n3941_o)
      3'b100: n3947_o = 4'b0000;
      3'b010: n3947_o = 4'b1111;
      3'b001: n3947_o = 4'b1111;
      default: n3947_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1277:25  */
  always @*
    case (n3941_o)
      3'b100: n3951_o = 4'b0000;
      3'b010: n3951_o = 4'b1100;
      3'b001: n3951_o = 4'b1101;
      default: n3951_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1277:25  */
  always @*
    case (n3941_o)
      3'b100: n3955_o = 3'b111;
      3'b010: n3955_o = 3'b101;
      3'b001: n3955_o = 3'b101;
      default: n3955_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1277:25  */
  always @*
    case (n3941_o)
      3'b100: n3958_o = 1'b1;
      3'b010: n3958_o = 1'b0;
      3'b001: n3958_o = 1'b0;
      default: n3958_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1277:25  */
  always @*
    case (n3941_o)
      3'b100: n3962_o = 1'b1;
      3'b010: n3962_o = 1'b1;
      3'b001: n3962_o = 1'b0;
      default: n3962_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1274:17  */
  assign n3964_o = ir == 8'b11000111;
  /* ./T80/T80_MCode.vhd:1274:32  */
  assign n3966_o = ir == 8'b11001111;
  /* ./T80/T80_MCode.vhd:1274:32  */
  assign n3967_o = n3964_o | n3966_o;
  /* ./T80/T80_MCode.vhd:1274:43  */
  assign n3969_o = ir == 8'b11010111;
  /* ./T80/T80_MCode.vhd:1274:43  */
  assign n3970_o = n3967_o | n3969_o;
  /* ./T80/T80_MCode.vhd:1274:54  */
  assign n3972_o = ir == 8'b11011111;
  /* ./T80/T80_MCode.vhd:1274:54  */
  assign n3973_o = n3970_o | n3972_o;
  /* ./T80/T80_MCode.vhd:1274:65  */
  assign n3975_o = ir == 8'b11100111;
  /* ./T80/T80_MCode.vhd:1274:65  */
  assign n3976_o = n3973_o | n3975_o;
  /* ./T80/T80_MCode.vhd:1274:76  */
  assign n3978_o = ir == 8'b11101111;
  /* ./T80/T80_MCode.vhd:1274:76  */
  assign n3979_o = n3976_o | n3978_o;
  /* ./T80/T80_MCode.vhd:1274:87  */
  assign n3981_o = ir == 8'b11110111;
  /* ./T80/T80_MCode.vhd:1274:87  */
  assign n3982_o = n3979_o | n3981_o;
  /* ./T80/T80_MCode.vhd:1274:98  */
  assign n3984_o = ir == 8'b11111111;
  /* ./T80/T80_MCode.vhd:1274:98  */
  assign n3985_o = n3982_o | n3984_o;
  /* ./T80/T80_MCode.vhd:1299:38  */
  assign n3986_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1300:33  */
  assign n3988_o = n3986_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1303:33  */
  assign n3990_o = n3986_o == 31'b0000000000000000000000000000011;
  assign n3991_o = {n3990_o, n3988_o};
  /* ./T80/T80_MCode.vhd:1299:33  */
  always @*
    case (n3991_o)
      2'b10: n3994_o = 1'b0;
      2'b01: n3994_o = 1'b1;
      default: n3994_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1299:33  */
  always @*
    case (n3991_o)
      2'b10: n3997_o = 1'b1;
      2'b01: n3997_o = 1'b0;
      default: n3997_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1299:33  */
  always @*
    case (n3991_o)
      2'b10: n4000_o = 3'b111;
      2'b01: n4000_o = 3'b100;
      default: n4000_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1299:33  */
  always @*
    case (n3991_o)
      2'b10: n4003_o = 1'b1;
      2'b01: n4003_o = 1'b0;
      default: n4003_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1295:17  */
  assign n4005_o = ir == 8'b11011011;
  /* ./T80/T80_MCode.vhd:1313:38  */
  assign n4006_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1314:33  */
  assign n4008_o = n4006_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1318:33  */
  assign n4010_o = n4006_o == 31'b0000000000000000000000000000011;
  assign n4011_o = {n4010_o, n4008_o};
  /* ./T80/T80_MCode.vhd:1313:33  */
  always @*
    case (n4011_o)
      2'b10: n4014_o = 1'b0;
      2'b01: n4014_o = 1'b1;
      default: n4014_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1313:33  */
  always @*
    case (n4011_o)
      2'b10: n4017_o = 4'b0000;
      2'b01: n4017_o = 4'b0111;
      default: n4017_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1313:33  */
  always @*
    case (n4011_o)
      2'b10: n4020_o = 3'b111;
      2'b01: n4020_o = 3'b100;
      default: n4020_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1313:33  */
  always @*
    case (n4011_o)
      2'b10: n4023_o = 1'b1;
      2'b01: n4023_o = 1'b0;
      default: n4023_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1313:33  */
  always @*
    case (n4011_o)
      2'b10: n4026_o = 1'b1;
      2'b01: n4026_o = 1'b0;
      default: n4026_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1309:17  */
  assign n4028_o = ir == 8'b11010011;
  /* ./T80/T80_MCode.vhd:1331:17  */
  assign n4030_o = ir == 8'b11001011;
  /* ./T80/T80_MCode.vhd:1336:17  */
  assign n4032_o = ir == 8'b11101101;
  /* ./T80/T80_MCode.vhd:1341:17  */
  assign n4034_o = ir == 8'b11011101;
  /* ./T80/T80_MCode.vhd:1341:32  */
  assign n4036_o = ir == 8'b11111101;
  /* ./T80/T80_MCode.vhd:1341:32  */
  assign n4037_o = n4034_o | n4036_o;
  assign n4038_o = {n4037_o, n4032_o, n4030_o, n4028_o, n4005_o, n3985_o, n3933_o, n3840_o, n3816_o, n3700_o, n3657_o, n3617_o, n3615_o, n3589_o, n3562_o, n3536_o, n3509_o, n3490_o, n3408_o, n3387_o, n3375_o, n3363_o, n3351_o, n3262_o, n3260_o, n3258_o, n3256_o, n3157_o, n3155_o, n3153_o, n3151_o, n3148_o, n3113_o, n3093_o, n3058_o, n3038_o, n2999_o, n2956_o, n2788_o, n2739_o, n2737_o, n2735_o, n2733_o, n2680_o, n2631_o, n2629_o, n2592_o, n2555_o, n2508_o, n2479_o, n2459_o, n2439_o, n2416_o, n2402_o, n2388_o, n2366_o, n2329_o, n2295_o, n2264_o};
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4071_o = 3'b001;
      59'b01000000000000000000000000000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00100000000000000000000000000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00010000000000000000000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00001000000000000000000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000100000000000000000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000010000000000000000000000000000000000000000000000000000: n4071_o = n3894_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000000100000000000000000000000000000000000000000000000000: n4071_o = n3765_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4071_o = 3'b101;
      59'b00000000001000000000000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000000000100000000000000000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000010000000000000000000000000000000000000000000000: n4071_o = n3601_o;
      59'b00000000000001000000000000000000000000000000000000000000000: n4071_o = n3575_o;
      59'b00000000000000100000000000000000000000000000000000000000000: n4071_o = n3548_o;
      59'b00000000000000010000000000000000000000000000000000000000000: n4071_o = n3522_o;
      59'b00000000000000001000000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000000000000000100000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000000000000000010000000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000000000000000001000000000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000100000000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000010000000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000001000000000000000000000000000000000000: n4071_o = 3'b011;
      59'b00000000000000000000000100000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000010000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000001000000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000100000000000000000000000000000000: n4071_o = n3243_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000001000000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000100000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000010000000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000001000000000000000000000000000: n4071_o = 3'b011;
      59'b00000000000000000000000000000000100000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000000010000000000000000000000000: n4071_o = 3'b011;
      59'b00000000000000000000000000000000001000000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000000000100000000000000000000000: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000010000000000000000000000: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000001000000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000000000000100000000000000000000: n4071_o = 3'b101;
      59'b00000000000000000000000000000000000000010000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000000000000001000000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000000000000000100000000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000000000000000010000000000000000: n4071_o = 3'b011;
      59'b00000000000000000000000000000000000000000001000000000000000: n4071_o = 3'b011;
      59'b00000000000000000000000000000000000000000000100000000000000: n4071_o = 3'b001;
      59'b00000000000000000000000000000000000000000000010000000000000: n4071_o = 3'b101;
      59'b00000000000000000000000000000000000000000000001000000000000: n4071_o = 3'b101;
      59'b00000000000000000000000000000000000000000000000100000000000: n4071_o = 3'b011;
      59'b00000000000000000000000000000000000000000000000010000000000: n4071_o = 3'b100;
      59'b00000000000000000000000000000000000000000000000001000000000: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000000000000000000100000000: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000000000000000000010000000: n4071_o = 3'b100;
      59'b00000000000000000000000000000000000000000000000000001000000: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000000000000000000000100000: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000000000000000000000010000: n4071_o = 3'b011;
      59'b00000000000000000000000000000000000000000000000000000001000: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000000000000000000000000100: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000000000000000000000000010: n4071_o = 3'b010;
      59'b00000000000000000000000000000000000000000000000000000000001: n4071_o = 3'b001;
      default: n4071_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b01000000000000000000000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00100000000000000000000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00010000000000000000000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000100000000000000000000000000000000000000000000000000000: n4076_o = n3943_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4076_o = n3897_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000100000000000000000000000000000000000000000000000000: n4076_o = n3767_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4076_o = n3669_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4076_o = n3629_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000010000000000000000000000000000000000000000000000: n4076_o = n3604_o;
      59'b00000000000001000000000000000000000000000000000000000000000: n4076_o = n3578_o;
      59'b00000000000000100000000000000000000000000000000000000000000: n4076_o = n3551_o;
      59'b00000000000000010000000000000000000000000000000000000000000: n4076_o = n3525_o;
      59'b00000000000000001000000000000000000000000000000000000000000: n4076_o = n3498_o;
      59'b00000000000000000100000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000010000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000001000000000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000100000000000000000000000000000000000000: n4076_o = 3'b110;
      59'b00000000000000000000010000000000000000000000000000000000000: n4076_o = 3'b110;
      59'b00000000000000000000001000000000000000000000000000000000000: n4076_o = n3310_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000010000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000001000000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000100000000000000000000000000000000: n4076_o = n3244_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000001000000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000100000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000010000000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000001000000000000000000000000000: n4076_o = n3123_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000010000000000000000000000000: n4076_o = n3068_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000100000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000100000000000000000000: n4076_o = n2754_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000001000000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000100000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000010000000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4076_o = n2655_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4076_o = 3'b110;
      59'b00000000000000000000000000000000000000000000010000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000010000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000001000000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000000100000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000000010000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000000000100: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000000000010: n4076_o = n2115_o;
      59'b00000000000000000000000000000000000000000000000000000000001: n4076_o = n2115_o;
      default: n4076_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4082_o = 2'b11;
      59'b01000000000000000000000000000000000000000000000000000000000: n4082_o = 2'b10;
      59'b00100000000000000000000000000000000000000000000000000000000: n4082_o = 2'b01;
      59'b00010000000000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00001000000000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000100000000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000010000000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000001000000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000100000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000010000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000001000000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000100000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000010000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000001000000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000100000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000010000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000001000000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000100000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000010000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000001000000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000100000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000010000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000001000000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000100000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000010000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000001000000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000100000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000010000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000001000000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000100000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000010000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000001000000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000100000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000010000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000001000000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000100000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000010000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000001000000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000100000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000010000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000001000000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000100000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000010000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000001000000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000100000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000010000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000001000000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000100000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000010000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000001000000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000100000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000010000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000001000000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000100000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000010000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000001000: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000100: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000010: n4082_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000001: n4082_o = 2'b00;
      default: n4082_o = 2'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4085_o = n4014_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4085_o = n3994_o;
      59'b00000100000000000000000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4085_o = n3771_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4085_o = n3673_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4085_o = n3632_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4085_o = n3607_o;
      59'b00000000000001000000000000000000000000000000000000000000000: n4085_o = n3581_o;
      59'b00000000000000100000000000000000000000000000000000000000000: n4085_o = n3554_o;
      59'b00000000000000010000000000000000000000000000000000000000000: n4085_o = n3528_o;
      59'b00000000000000001000000000000000000000000000000000000000000: n4085_o = n3501_o;
      59'b00000000000000000100000000000000000000000000000000000000000: n4085_o = n3459_o;
      59'b00000000000000000010000000000000000000000000000000000000000: n4085_o = n3397_o;
      59'b00000000000000000001000000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4085_o = n3246_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4085_o = n3005_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4085_o = n2606_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4085_o = n2571_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4085_o = n2536_o;
      59'b00000000000000000000000000000000000000000000000010000000000: n4085_o = n2491_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4085_o = n2428_o;
      59'b00000000000000000000000000000000000000000000000000001000000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4085_o = n2376_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4085_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4085_o = n2270_o;
      59'b00000000000000000000000000000000000000000000000000000000001: n4085_o = 1'b0;
      default: n4085_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4088_o = n2609_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4088_o = n2574_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4088_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4088_o = 1'b0;
      default: n4088_o = 1'bX;
    endcase
  assign n4089_o = n2659_o[1:0];
  assign n4090_o = n2710_o[1:0];
  assign n4091_o = n2758_o[1:0];
  assign n4092_o = n3247_o[1:0];
  assign n4093_o = n3677_o[1:0];
  assign n4094_o = n3774_o[1:0];
  assign n4095_o = n3828_o[1:0];
  assign n4096_o = n3901_o[1:0];
  assign n4097_o = n3947_o[1:0];
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b01000000000000000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00100000000000000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00010000000000000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00001000000000000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000100000000000000000000000000000000000000000000000000000: n4100_o = n4097_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4100_o = n4096_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4100_o = n4095_o;
      59'b00000000100000000000000000000000000000000000000000000000000: n4100_o = n4094_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4100_o = n4093_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000100000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000010000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000001000000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000100000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000010000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000001000000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000100000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000010000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000001000000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000100000000000000000000000000000000000000: n4100_o = n2110_o;
      59'b00000000000000000000010000000000000000000000000000000000000: n4100_o = n2110_o;
      59'b00000000000000000000001000000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000100000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000010000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000001000000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000100000000000000000000000000000000: n4100_o = n4092_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000001000000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000100000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000010000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000001000000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000100000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000010000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000001000000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000100000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000010000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000001000000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000100000000000000000000: n4100_o = n4091_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000001000000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000100000000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000010000000000000000: n4100_o = n4090_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4100_o = n4089_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000010000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000001000000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000100000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000010000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000001000000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000100000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000010000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000001000000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000100000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000010000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000001000: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000100: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000010: n4100_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000001: n4100_o = 2'b00;
      default: n4100_o = 2'bX;
    endcase
  assign n4101_o = n2659_o[3:2];
  assign n4102_o = n2710_o[3:2];
  assign n4103_o = n2758_o[3:2];
  assign n4104_o = n3247_o[3:2];
  assign n4105_o = n3677_o[3:2];
  assign n4106_o = n3774_o[3:2];
  assign n4107_o = n3828_o[3:2];
  assign n4108_o = n3901_o[3:2];
  assign n4109_o = n3947_o[3:2];
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b01000000000000000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00100000000000000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00010000000000000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00001000000000000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000100000000000000000000000000000000000000000000000000000: n4112_o = n4109_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4112_o = n4108_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4112_o = n4107_o;
      59'b00000000100000000000000000000000000000000000000000000000000: n4112_o = n4106_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4112_o = n4105_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000100000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000010000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000001000000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000100000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000010000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000001000000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000100000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000010000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000001000000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000100000000000000000000000000000000000000: n4112_o = 2'b11;
      59'b00000000000000000000010000000000000000000000000000000000000: n4112_o = 2'b01;
      59'b00000000000000000000001000000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000100000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000010000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000001000000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000100000000000000000000000000000000: n4112_o = n4104_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000001000000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000100000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000010000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000001000000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000100000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000010000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000001000000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000100000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000010000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000001000000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000100000000000000000000: n4112_o = n4103_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000001000000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000100000000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000010000000000000000: n4112_o = n4102_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4112_o = n4101_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000010000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000001000000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000100000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000010000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000001000000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000100000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000010000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000001000000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000100000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000010000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000001000: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000100: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000010: n4112_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000001: n4112_o = 2'b00;
      default: n4112_o = 2'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4121_o = n3635_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4121_o = 1'b1;
      59'b00000000000000000000100000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4121_o = n3314_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4121_o = 1'b1;
      59'b00000000000000000000000000000001000000000000000000000000000: n4121_o = n3126_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4121_o = 1'b1;
      59'b00000000000000000000000000000000010000000000000000000000000: n4121_o = n3071_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4121_o = 1'b1;
      59'b00000000000000000000000000000000000100000000000000000000000: n4121_o = n3008_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4121_o = n2966_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4121_o = 1'b1;
      59'b00000000000000000000000000000000000000100000000000000000000: n4121_o = n2762_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4121_o = n2714_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4121_o = n2578_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4121_o = n2540_o;
      59'b00000000000000000000000000000000000000000000000010000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4121_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4121_o = n2304_o;
      59'b00000000000000000000000000000000000000000000000000000000010: n4121_o = n2273_o;
      59'b00000000000000000000000000000000000000000000000000000000001: n4121_o = 1'b1;
      default: n4121_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4124_o = n3997_o;
      59'b00000100000000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4124_o = n2431_o;
      59'b00000000000000000000000000000000000000000000000000001000000: n4124_o = n2411_o;
      59'b00000000000000000000000000000000000000000000000000000100000: n4124_o = n2397_o;
      59'b00000000000000000000000000000000000000000000000000000010000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4124_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4124_o = 1'b0;
      default: n4124_o = 1'bX;
    endcase
  assign n4125_o = n2766_o[2:0];
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b01000000000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00100000000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00010000000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00001000000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000100000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000010000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000001000000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000100000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000010000000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000001000000000000000000000000000000000000000000000000: n4128_o = n3637_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000010000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000001000000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000100000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000010000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000001000000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000100000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000010000000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000001000000000000000000000000000000000000000: n4128_o = 3'b111;
      59'b00000000000000000000100000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000010000000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000001000000000000000000000000000000000000: n4128_o = n3316_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000010000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000001000000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000100000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000010000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000001000000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000100000000000000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000010000000000000000000000000000: n4128_o = 3'b111;
      59'b00000000000000000000000000000001000000000000000000000000000: n4128_o = n3128_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4128_o = n2108_o;
      59'b00000000000000000000000000000000010000000000000000000000000: n4128_o = n3073_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4128_o = n2108_o;
      59'b00000000000000000000000000000000000100000000000000000000000: n4128_o = n3010_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4128_o = n2968_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4128_o = 3'b111;
      59'b00000000000000000000000000000000000000100000000000000000000: n4128_o = n4125_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000001000000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000100000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000010000000000000000: n4128_o = n2716_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000100000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000010000000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000001000000000000: n4128_o = n2580_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4128_o = n2542_o;
      59'b00000000000000000000000000000000000000000000000010000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000001000000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000000100000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000000010000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000000001000000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000000000100000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000000000010000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000000000001000: n4128_o = 3'b000;
      59'b00000000000000000000000000000000000000000000000000000000100: n4128_o = n2306_o;
      59'b00000000000000000000000000000000000000000000000000000000010: n4128_o = n2275_o;
      59'b00000000000000000000000000000000000000000000000000000000001: n4128_o = n2108_o;
      default: n4128_o = 3'bX;
    endcase
  assign n4129_o = n2766_o[3];
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4132_o = n4129_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4132_o = n2718_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4132_o = n2544_o;
      59'b00000000000000000000000000000000000000000000000010000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4132_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4132_o = 1'b0;
      default: n4132_o = 1'bX;
    endcase
  assign n4133_o = n2109_o[0];
  assign n4134_o = n2338_o[0];
  assign n4135_o = n2378_o[0];
  assign n4136_o = n2448_o[0];
  assign n4137_o = n2468_o[0];
  assign n4138_o = n2494_o[0];
  assign n4139_o = n2613_o[0];
  assign n4140_o = n2661_o[0];
  assign n4141_o = n2770_o[0];
  assign n4142_o = n2109_o[0];
  assign n4143_o = n2970_o[0];
  assign n4144_o = n3012_o[0];
  assign n4146_o = n3076_o[0];
  assign n4148_o = n3131_o[0];
  assign n4149_o = n3248_o[0];
  assign n4150_o = n3640_o[0];
  assign n4151_o = n3681_o[0];
  assign n4152_o = n3777_o[0];
  assign n4153_o = n3951_o[0];
  assign n4154_o = n4017_o[0];
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4157_o = n4154_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4157_o = n4153_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4157_o = n4152_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4157_o = n4151_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4157_o = n4150_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4157_o = n3318_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4157_o = n4149_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4157_o = n4148_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4157_o = n4146_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4157_o = n4144_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4157_o = n4143_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4157_o = n4142_o;
      59'b00000000000000000000000000000000000000100000000000000000000: n4157_o = n4141_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4157_o = n4140_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4157_o = n4139_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4157_o = n4138_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4157_o = n4137_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4157_o = n4136_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4157_o = n4135_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4157_o = n4134_o;
      59'b00000000000000000000000000000000000000000000000000000000100: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4157_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4157_o = n4133_o;
      default: n4157_o = 1'bX;
    endcase
  assign n4158_o = n2109_o[2:1];
  assign n4159_o = n2338_o[2:1];
  assign n4160_o = n2378_o[2:1];
  assign n4161_o = n2448_o[2:1];
  assign n4162_o = n2468_o[2:1];
  assign n4163_o = n2494_o[2:1];
  assign n4164_o = n2613_o[2:1];
  assign n4165_o = n2661_o[2:1];
  assign n4166_o = n2770_o[2:1];
  assign n4167_o = n2109_o[2:1];
  assign n4168_o = n2970_o[2:1];
  assign n4169_o = n3012_o[2:1];
  assign n4171_o = n3076_o[2:1];
  assign n4173_o = n3131_o[2:1];
  assign n4174_o = n3248_o[2:1];
  assign n4175_o = n3640_o[2:1];
  assign n4176_o = n3681_o[2:1];
  assign n4177_o = n3777_o[2:1];
  assign n4178_o = n3951_o[2:1];
  assign n4179_o = n4017_o[2:1];
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b01000000000000000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00100000000000000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00010000000000000000000000000000000000000000000000000000000: n4182_o = n4179_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000100000000000000000000000000000000000000000000000000000: n4182_o = n4178_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000001000000000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000100000000000000000000000000000000000000000000000000: n4182_o = n4177_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4182_o = n4176_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4182_o = n4175_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000010000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000001000000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000100000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000010000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000001000000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000100000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000010000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000001000000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000100000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000010000000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000001000000000000000000000000000000000000: n4182_o = n3320_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000010000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000001000000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000100000000000000000000000000000000: n4182_o = n4174_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000001000000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000100000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000010000000000000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000001000000000000000000000000000: n4182_o = n4173_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4182_o = 2'b01;
      59'b00000000000000000000000000000000010000000000000000000000000: n4182_o = n4171_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4182_o = 2'b01;
      59'b00000000000000000000000000000000000100000000000000000000000: n4182_o = n4169_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4182_o = n4168_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4182_o = n4167_o;
      59'b00000000000000000000000000000000000000100000000000000000000: n4182_o = n4166_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000001000000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000100000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000010000000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000001000000000000000: n4182_o = n4165_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000010000000000000: n4182_o = n4164_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000100000000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000010000000000: n4182_o = n4163_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4182_o = n4162_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4182_o = n4161_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000001000000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000100000: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000010000: n4182_o = n4160_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4182_o = n4159_o;
      59'b00000000000000000000000000000000000000000000000000000000100: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000010: n4182_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000001: n4182_o = n4158_o;
      default: n4182_o = 2'bX;
    endcase
  assign n4183_o = n2448_o[3];
  assign n4184_o = n2468_o[3];
  assign n4185_o = n2494_o[3];
  assign n4186_o = n2613_o[3];
  assign n4187_o = n2661_o[3];
  assign n4188_o = n2770_o[3];
  assign n4190_o = n3076_o[3];
  assign n4192_o = n3131_o[3];
  assign n4193_o = n3248_o[3];
  assign n4194_o = n3640_o[3];
  assign n4195_o = n3681_o[3];
  assign n4196_o = n3777_o[3];
  assign n4197_o = n3951_o[3];
  assign n4198_o = n4017_o[3];
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4201_o = n4198_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4201_o = n4197_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4201_o = n4196_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4201_o = n4195_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4201_o = n4194_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4201_o = n3322_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4201_o = n4193_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4201_o = n4192_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4201_o = 1'b1;
      59'b00000000000000000000000000000000010000000000000000000000000: n4201_o = n4190_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4201_o = 1'b1;
      59'b00000000000000000000000000000000000100000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4201_o = n4188_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4201_o = n4187_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4201_o = n4186_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4201_o = n4185_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4201_o = n4184_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4201_o = n4183_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4201_o = n2380_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4201_o = n2340_o;
      59'b00000000000000000000000000000000000000000000000000000000100: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4201_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4201_o = 1'b0;
      default: n4201_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b01000000000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00100000000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00010000000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000100000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000100000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4207_o = n3642_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000010000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000001000000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000100000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000010000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000001000000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000100000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000010000000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000001000000000000000000000000000000000000000: n4207_o = 4'b1000;
      59'b00000000000000000000100000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000010000000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000001000000000000000000000000000000000000: n4207_o = n3325_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000010000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000001000000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000100000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000001000000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000100000000000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000010000000000000000000000000000: n4207_o = 4'b1100;
      59'b00000000000000000000000000000001000000000000000000000000000: n4207_o = n3133_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4207_o = 4'b0010;
      59'b00000000000000000000000000000000010000000000000000000000000: n4207_o = n3078_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4207_o = 4'b0000;
      59'b00000000000000000000000000000000000100000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000100000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000001000000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000100000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000010000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000010000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000010000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000001000000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000000100000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000000010000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000000000100: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000000000010: n4207_o = n2118_o;
      59'b00000000000000000000000000000000000000000000000000000000001: n4207_o = n2118_o;
      default: n4207_o = 4'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4215_o = n3645_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4215_o = 1'b1;
      59'b00000000000000000000100000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4215_o = n3329_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4215_o = 1'b1;
      59'b00000000000000000000000000000001000000000000000000000000000: n4215_o = n3136_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4215_o = 1'b1;
      59'b00000000000000000000000000000000010000000000000000000000000: n4215_o = n3081_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4215_o = 1'b1;
      59'b00000000000000000000000000000000000100000000000000000000000: n4215_o = n3015_o;
      59'b00000000000000000000000000000000000010000000000000000000000: n4215_o = n2973_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4215_o = 1'b1;
      59'b00000000000000000000000000000000000000100000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4215_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4215_o = 1'b0;
      default: n4215_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4220_o = n3139_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4220_o = 1'b1;
      59'b00000000000000000000000000000000010000000000000000000000000: n4220_o = n3084_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4220_o = 1'b1;
      59'b00000000000000000000000000000000000100000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4220_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4220_o = 1'b0;
      default: n4220_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4223_o = n3333_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4223_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4223_o = 1'b0;
      default: n4223_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b01000000000000000000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00100000000000000000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00010000000000000000000000000000000000000000000000000000000: n4226_o = n4020_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4226_o = n4000_o;
      59'b00000100000000000000000000000000000000000000000000000000000: n4226_o = n3955_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4226_o = n3904_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4226_o = n3832_o;
      59'b00000000100000000000000000000000000000000000000000000000000: n4226_o = n3780_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4226_o = n3685_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000100000000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000010000000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000001000000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000100000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000010000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000001000000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000100000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000010000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000001000000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000100000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000010000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000001000000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000100000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000010000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000001000000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000100000000000000000000000000000000: n4226_o = n3249_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000001000000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000100000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000010000000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000001000000000000000000000000000: n4226_o = n3143_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000010000000000000000000000000: n4226_o = n3088_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000100000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000010000000000000000000000: n4226_o = n2976_o;
      59'b00000000000000000000000000000000000001000000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000000100000000000000000000: n4226_o = n2776_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000000001000000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000000000100000000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000000000010000000000000000: n4226_o = n2722_o;
      59'b00000000000000000000000000000000000000000001000000000000000: n4226_o = n2665_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000000000000010000000000000: n4226_o = n2617_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4226_o = n2584_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000000000000000010000000000: n4226_o = n2497_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4226_o = n2471_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4226_o = n2451_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4226_o = n2434_o;
      59'b00000000000000000000000000000000000000000000000000001000000: n4226_o = n2414_o;
      59'b00000000000000000000000000000000000000000000000000000100000: n4226_o = n2400_o;
      59'b00000000000000000000000000000000000000000000000000000010000: n4226_o = n2383_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4226_o = n2343_o;
      59'b00000000000000000000000000000000000000000000000000000000100: n4226_o = n2309_o;
      59'b00000000000000000000000000000000000000000000000000000000010: n4226_o = 3'b111;
      59'b00000000000000000000000000000000000000000000000000000000001: n4226_o = 3'b111;
      default: n4226_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4229_o = n4023_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4229_o = n4003_o;
      59'b00000100000000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4229_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4229_o = 1'b0;
      default: n4229_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4232_o = n3907_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4232_o = n3835_o;
      59'b00000000100000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4232_o = n3461_o;
      59'b00000000000000000010000000000000000000000000000000000000000: n4232_o = n3400_o;
      59'b00000000000000000001000000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4232_o = n3251_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4232_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4232_o = 1'b0;
      default: n4232_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4235_o = n3648_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4235_o = n3610_o;
      59'b00000000000001000000000000000000000000000000000000000000000: n4235_o = n3584_o;
      59'b00000000000000100000000000000000000000000000000000000000000: n4235_o = n3557_o;
      59'b00000000000000010000000000000000000000000000000000000000000: n4235_o = n3531_o;
      59'b00000000000000001000000000000000000000000000000000000000000: n4235_o = n3504_o;
      59'b00000000000000000100000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4235_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4235_o = 1'b0;
      default: n4235_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4239_o = 1'b1;
      59'b00000000000010000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4239_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4239_o = 1'b0;
      default: n4239_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4242_o = n3783_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4242_o = n3688_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4242_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4242_o = 1'b0;
      default: n4242_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4245_o = n3958_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4245_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4245_o = 1'b0;
      default: n4245_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4248_o = n3910_o;
      59'b00000001000000000000000000000000000000000000000000000000000: n4248_o = n3838_o;
      59'b00000000100000000000000000000000000000000000000000000000000: n4248_o = n3786_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4248_o = n3691_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4248_o = n3464_o;
      59'b00000000000000000010000000000000000000000000000000000000000: n4248_o = n3403_o;
      59'b00000000000000000001000000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4248_o = n3253_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4248_o = n2779_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4248_o = n2620_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4248_o = n2587_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4248_o = n2500_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4248_o = n2437_o;
      59'b00000000000000000000000000000000000000000000000000001000000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4248_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4248_o = 1'b0;
      default: n4248_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4251_o = n3789_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4251_o = n3694_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4251_o = n3467_o;
      59'b00000000000000000010000000000000000000000000000000000000000: n4251_o = n3406_o;
      59'b00000000000000000001000000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4251_o = n2782_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4251_o = n2623_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4251_o = n2590_o;
      59'b00000000000000000000000000000000000000000000000100000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4251_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4251_o = 1'b0;
      default: n4251_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4255_o = 1'b1;
      59'b00000000000000000000000000000000000000000000010000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4255_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4255_o = 1'b0;
      default: n4255_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4259_o = 1'b1;
      59'b00000000000000000000000000000000000000000010000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4259_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4259_o = 1'b0;
      default: n4259_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4263_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4263_o = 1'b1;
      default: n4263_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4267_o = 1'b1;
      59'b00000000000000000000000000000000000000000100000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4267_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4267_o = 1'b0;
      default: n4267_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4271_o = 1'b1;
      59'b00000000000000000000000000000000000000001000000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4271_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4271_o = 1'b0;
      default: n4271_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4274_o = n3652_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4274_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4274_o = 1'b0;
      default: n4274_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4278_o = 1'b1;
      59'b00000000000000000000000000000010000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4278_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4278_o = 1'b0;
      default: n4278_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4282_o = 1'b1;
      59'b00000000000000000000000000000100000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4282_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4282_o = 1'b0;
      default: n4282_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4286_o = 1'b1;
      59'b00000000000000000000000000001000000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4286_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4286_o = 1'b0;
      default: n4286_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b01000000000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00100000000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00010000000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00001000000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000100000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000010000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000001000000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000100000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000010000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000001000000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000100000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000010000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000001000000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000100000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000010000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000001000000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000100000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000010000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000001000000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000100000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000010000000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000001000000000000000000000000000000000000: n4289_o = n3336_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000010000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000001000000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000100000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000010000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000001000000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000100000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000010000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000001000000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000100000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000010000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000001000000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000100000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000010000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000001000000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000100000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000010000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000001000000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000100000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000010000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000001000000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000100000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000010000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000001000000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000100000000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000010000000000: n4289_o = n2503_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4289_o = n2474_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4289_o = n2454_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000001000000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000100000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000010000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000001000: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000100: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000010: n4289_o = 2'b00;
      59'b00000000000000000000000000000000000000000000000000000000001: n4289_o = 2'b00;
      default: n4289_o = 2'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4293_o = 1'b1;
      59'b00000000000000000000000001000000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4293_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4293_o = 1'b0;
      default: n4293_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4297_o = 1'b1;
      59'b00000000000000000000000010000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4297_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4297_o = 1'b0;
      default: n4297_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4301_o = 1'b1;
      59'b00000000000000000000000000100000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4301_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4301_o = 1'b0;
      default: n4301_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00001000000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000010000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000010000000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000001000000000000000000000000000000000000000000000000: n4304_o = n3655_o;
      59'b00000000000100000000000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4304_o = n3613_o;
      59'b00000000000001000000000000000000000000000000000000000000000: n4304_o = n3587_o;
      59'b00000000000000100000000000000000000000000000000000000000000: n4304_o = n3560_o;
      59'b00000000000000010000000000000000000000000000000000000000000: n4304_o = n3534_o;
      59'b00000000000000001000000000000000000000000000000000000000000: n4304_o = n3507_o;
      59'b00000000000000000100000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4304_o = n3340_o;
      59'b00000000000000000000000100000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000010000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000100000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000001000000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000010000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000100000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000001000000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000001000000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000100000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000010000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000001000: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000100: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4304_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4304_o = 1'b0;
      default: n4304_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:265:17  */
  always @*
    case (n4038_o)
      59'b10000000000000000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b01000000000000000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00100000000000000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00010000000000000000000000000000000000000000000000000000000: n4307_o = n4026_o;
      59'b00001000000000000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000100000000000000000000000000000000000000000000000000000: n4307_o = n3962_o;
      59'b00000010000000000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000001000000000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000100000000000000000000000000000000000000000000000000: n4307_o = n3793_o;
      59'b00000000010000000000000000000000000000000000000000000000000: n4307_o = n3698_o;
      59'b00000000001000000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000100000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000010000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000001000000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000100000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000010000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000001000000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000100000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000010000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000001000000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000100000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000010000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000001000000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000100000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000010000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000001000000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000100000000000000000000000000000000: n4307_o = n3254_o;
      59'b00000000000000000000000000010000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000001000000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000100000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000010000000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000001000000000000000000000000000: n4307_o = n3146_o;
      59'b00000000000000000000000000000000100000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000010000000000000000000000000: n4307_o = n3091_o;
      59'b00000000000000000000000000000000001000000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000100000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000010000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000001000000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000100000000000000000000: n4307_o = n2786_o;
      59'b00000000000000000000000000000000000000010000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000001000000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000100000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000010000000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000001000000000000000: n4307_o = n2669_o;
      59'b00000000000000000000000000000000000000000000100000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000010000000000000: n4307_o = n2627_o;
      59'b00000000000000000000000000000000000000000000001000000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000100000000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000010000000000: n4307_o = n2506_o;
      59'b00000000000000000000000000000000000000000000000001000000000: n4307_o = n2477_o;
      59'b00000000000000000000000000000000000000000000000000100000000: n4307_o = n2457_o;
      59'b00000000000000000000000000000000000000000000000000010000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000001000000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000100000: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000010000: n4307_o = n2386_o;
      59'b00000000000000000000000000000000000000000000000000000001000: n4307_o = n2346_o;
      59'b00000000000000000000000000000000000000000000000000000000100: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000010: n4307_o = 1'b0;
      59'b00000000000000000000000000000000000000000000000000000000001: n4307_o = 1'b0;
      default: n4307_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:257:17  */
  assign n4309_o = iset == 2'b00;
  /* ./T80/T80_MCode.vhd:1356:54  */
  assign n4310_o = ir[2:0];
  /* ./T80/T80_MCode.vhd:1357:54  */
  assign n4311_o = ir[2:0];
  /* ./T80/T80_MCode.vhd:1376:44  */
  assign n4313_o = xy_state == 2'b00;
  /* ./T80/T80_MCode.vhd:1377:51  */
  assign n4315_o = mcycle == 3'b001;
  /* ./T80/T80_MCode.vhd:1377:41  */
  assign n4318_o = n4315_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1377:41  */
  assign n4320_o = n4315_o ? 4'b1000 : n2118_o;
  /* ./T80/T80_MCode.vhd:1377:41  */
  assign n4323_o = n4315_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1386:46  */
  assign n4324_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1387:41  */
  assign n4326_o = n4324_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1387:48  */
  assign n4328_o = n4324_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1387:48  */
  assign n4329_o = n4326_o | n4328_o;
  /* ./T80/T80_MCode.vhd:1389:41  */
  assign n4331_o = n4324_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1395:41  */
  assign n4333_o = n4324_o == 31'b0000000000000000000000000000011;
  assign n4334_o = {n4333_o, n4331_o, n4329_o};
  /* ./T80/T80_MCode.vhd:1386:41  */
  always @*
    case (n4334_o)
      3'b100: n4336_o = n2115_o;
      3'b010: n4336_o = 3'b100;
      3'b001: n4336_o = n2115_o;
      default: n4336_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1386:41  */
  always @*
    case (n4334_o)
      3'b100: n4339_o = 1'b0;
      3'b010: n4339_o = 1'b1;
      3'b001: n4339_o = 1'b0;
      default: n4339_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1386:41  */
  always @*
    case (n4334_o)
      3'b100: n4341_o = n2118_o;
      3'b010: n4341_o = 4'b1000;
      3'b001: n4341_o = n2118_o;
      default: n4341_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1386:41  */
  always @*
    case (n4334_o)
      3'b100: n4344_o = 1'b0;
      3'b010: n4344_o = 1'b1;
      3'b001: n4344_o = 1'b0;
      default: n4344_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1386:41  */
  always @*
    case (n4334_o)
      3'b100: n4348_o = 3'b111;
      3'b010: n4348_o = 3'b010;
      3'b001: n4348_o = 3'b010;
      default: n4348_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1386:41  */
  always @*
    case (n4334_o)
      3'b100: n4351_o = 1'b1;
      3'b010: n4351_o = 1'b0;
      3'b001: n4351_o = 1'b0;
      default: n4351_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4354_o = n4313_o ? 3'b001 : 3'b011;
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4355_o = n4313_o ? n2115_o : n4336_o;
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4356_o = n4313_o ? n4318_o : n4339_o;
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4357_o = n4313_o ? n4320_o : n4341_o;
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4358_o = n4313_o ? n4323_o : n4344_o;
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4360_o = n4313_o ? 3'b111 : n4348_o;
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4362_o = n4313_o ? 1'b0 : n4351_o;
  /* ./T80/T80_MCode.vhd:1376:33  */
  assign n4365_o = n4313_o ? 1'b0 : 1'b1;
  /* ./T80/T80_MCode.vhd:1360:25  */
  assign n4367_o = ir == 8'b00000000;
  /* ./T80/T80_MCode.vhd:1360:40  */
  assign n4369_o = ir == 8'b00000001;
  /* ./T80/T80_MCode.vhd:1360:40  */
  assign n4370_o = n4367_o | n4369_o;
  /* ./T80/T80_MCode.vhd:1360:51  */
  assign n4372_o = ir == 8'b00000010;
  /* ./T80/T80_MCode.vhd:1360:51  */
  assign n4373_o = n4370_o | n4372_o;
  /* ./T80/T80_MCode.vhd:1360:62  */
  assign n4375_o = ir == 8'b00000011;
  /* ./T80/T80_MCode.vhd:1360:62  */
  assign n4376_o = n4373_o | n4375_o;
  /* ./T80/T80_MCode.vhd:1360:73  */
  assign n4378_o = ir == 8'b00000100;
  /* ./T80/T80_MCode.vhd:1360:73  */
  assign n4379_o = n4376_o | n4378_o;
  /* ./T80/T80_MCode.vhd:1360:84  */
  assign n4381_o = ir == 8'b00000101;
  /* ./T80/T80_MCode.vhd:1360:84  */
  assign n4382_o = n4379_o | n4381_o;
  /* ./T80/T80_MCode.vhd:1360:95  */
  assign n4384_o = ir == 8'b00000111;
  /* ./T80/T80_MCode.vhd:1360:95  */
  assign n4385_o = n4382_o | n4384_o;
  /* ./T80/T80_MCode.vhd:1361:33  */
  assign n4387_o = ir == 8'b00010000;
  /* ./T80/T80_MCode.vhd:1361:33  */
  assign n4388_o = n4385_o | n4387_o;
  /* ./T80/T80_MCode.vhd:1361:44  */
  assign n4390_o = ir == 8'b00010001;
  /* ./T80/T80_MCode.vhd:1361:44  */
  assign n4391_o = n4388_o | n4390_o;
  /* ./T80/T80_MCode.vhd:1361:55  */
  assign n4393_o = ir == 8'b00010010;
  /* ./T80/T80_MCode.vhd:1361:55  */
  assign n4394_o = n4391_o | n4393_o;
  /* ./T80/T80_MCode.vhd:1361:66  */
  assign n4396_o = ir == 8'b00010011;
  /* ./T80/T80_MCode.vhd:1361:66  */
  assign n4397_o = n4394_o | n4396_o;
  /* ./T80/T80_MCode.vhd:1361:77  */
  assign n4399_o = ir == 8'b00010100;
  /* ./T80/T80_MCode.vhd:1361:77  */
  assign n4400_o = n4397_o | n4399_o;
  /* ./T80/T80_MCode.vhd:1361:88  */
  assign n4402_o = ir == 8'b00010101;
  /* ./T80/T80_MCode.vhd:1361:88  */
  assign n4403_o = n4400_o | n4402_o;
  /* ./T80/T80_MCode.vhd:1361:99  */
  assign n4405_o = ir == 8'b00010111;
  /* ./T80/T80_MCode.vhd:1361:99  */
  assign n4406_o = n4403_o | n4405_o;
  /* ./T80/T80_MCode.vhd:1362:33  */
  assign n4408_o = ir == 8'b00001000;
  /* ./T80/T80_MCode.vhd:1362:33  */
  assign n4409_o = n4406_o | n4408_o;
  /* ./T80/T80_MCode.vhd:1362:44  */
  assign n4411_o = ir == 8'b00001001;
  /* ./T80/T80_MCode.vhd:1362:44  */
  assign n4412_o = n4409_o | n4411_o;
  /* ./T80/T80_MCode.vhd:1362:55  */
  assign n4414_o = ir == 8'b00001010;
  /* ./T80/T80_MCode.vhd:1362:55  */
  assign n4415_o = n4412_o | n4414_o;
  /* ./T80/T80_MCode.vhd:1362:66  */
  assign n4417_o = ir == 8'b00001011;
  /* ./T80/T80_MCode.vhd:1362:66  */
  assign n4418_o = n4415_o | n4417_o;
  /* ./T80/T80_MCode.vhd:1362:77  */
  assign n4420_o = ir == 8'b00001100;
  /* ./T80/T80_MCode.vhd:1362:77  */
  assign n4421_o = n4418_o | n4420_o;
  /* ./T80/T80_MCode.vhd:1362:88  */
  assign n4423_o = ir == 8'b00001101;
  /* ./T80/T80_MCode.vhd:1362:88  */
  assign n4424_o = n4421_o | n4423_o;
  /* ./T80/T80_MCode.vhd:1362:99  */
  assign n4426_o = ir == 8'b00001111;
  /* ./T80/T80_MCode.vhd:1362:99  */
  assign n4427_o = n4424_o | n4426_o;
  /* ./T80/T80_MCode.vhd:1363:33  */
  assign n4429_o = ir == 8'b00011000;
  /* ./T80/T80_MCode.vhd:1363:33  */
  assign n4430_o = n4427_o | n4429_o;
  /* ./T80/T80_MCode.vhd:1363:44  */
  assign n4432_o = ir == 8'b00011001;
  /* ./T80/T80_MCode.vhd:1363:44  */
  assign n4433_o = n4430_o | n4432_o;
  /* ./T80/T80_MCode.vhd:1363:55  */
  assign n4435_o = ir == 8'b00011010;
  /* ./T80/T80_MCode.vhd:1363:55  */
  assign n4436_o = n4433_o | n4435_o;
  /* ./T80/T80_MCode.vhd:1363:66  */
  assign n4438_o = ir == 8'b00011011;
  /* ./T80/T80_MCode.vhd:1363:66  */
  assign n4439_o = n4436_o | n4438_o;
  /* ./T80/T80_MCode.vhd:1363:77  */
  assign n4441_o = ir == 8'b00011100;
  /* ./T80/T80_MCode.vhd:1363:77  */
  assign n4442_o = n4439_o | n4441_o;
  /* ./T80/T80_MCode.vhd:1363:88  */
  assign n4444_o = ir == 8'b00011101;
  /* ./T80/T80_MCode.vhd:1363:88  */
  assign n4445_o = n4442_o | n4444_o;
  /* ./T80/T80_MCode.vhd:1363:99  */
  assign n4447_o = ir == 8'b00011111;
  /* ./T80/T80_MCode.vhd:1363:99  */
  assign n4448_o = n4445_o | n4447_o;
  /* ./T80/T80_MCode.vhd:1364:33  */
  assign n4450_o = ir == 8'b00100000;
  /* ./T80/T80_MCode.vhd:1364:33  */
  assign n4451_o = n4448_o | n4450_o;
  /* ./T80/T80_MCode.vhd:1364:44  */
  assign n4453_o = ir == 8'b00100001;
  /* ./T80/T80_MCode.vhd:1364:44  */
  assign n4454_o = n4451_o | n4453_o;
  /* ./T80/T80_MCode.vhd:1364:55  */
  assign n4456_o = ir == 8'b00100010;
  /* ./T80/T80_MCode.vhd:1364:55  */
  assign n4457_o = n4454_o | n4456_o;
  /* ./T80/T80_MCode.vhd:1364:66  */
  assign n4459_o = ir == 8'b00100011;
  /* ./T80/T80_MCode.vhd:1364:66  */
  assign n4460_o = n4457_o | n4459_o;
  /* ./T80/T80_MCode.vhd:1364:77  */
  assign n4462_o = ir == 8'b00100100;
  /* ./T80/T80_MCode.vhd:1364:77  */
  assign n4463_o = n4460_o | n4462_o;
  /* ./T80/T80_MCode.vhd:1364:88  */
  assign n4465_o = ir == 8'b00100101;
  /* ./T80/T80_MCode.vhd:1364:88  */
  assign n4466_o = n4463_o | n4465_o;
  /* ./T80/T80_MCode.vhd:1364:99  */
  assign n4468_o = ir == 8'b00100111;
  /* ./T80/T80_MCode.vhd:1364:99  */
  assign n4469_o = n4466_o | n4468_o;
  /* ./T80/T80_MCode.vhd:1365:33  */
  assign n4471_o = ir == 8'b00101000;
  /* ./T80/T80_MCode.vhd:1365:33  */
  assign n4472_o = n4469_o | n4471_o;
  /* ./T80/T80_MCode.vhd:1365:44  */
  assign n4474_o = ir == 8'b00101001;
  /* ./T80/T80_MCode.vhd:1365:44  */
  assign n4475_o = n4472_o | n4474_o;
  /* ./T80/T80_MCode.vhd:1365:55  */
  assign n4477_o = ir == 8'b00101010;
  /* ./T80/T80_MCode.vhd:1365:55  */
  assign n4478_o = n4475_o | n4477_o;
  /* ./T80/T80_MCode.vhd:1365:66  */
  assign n4480_o = ir == 8'b00101011;
  /* ./T80/T80_MCode.vhd:1365:66  */
  assign n4481_o = n4478_o | n4480_o;
  /* ./T80/T80_MCode.vhd:1365:77  */
  assign n4483_o = ir == 8'b00101100;
  /* ./T80/T80_MCode.vhd:1365:77  */
  assign n4484_o = n4481_o | n4483_o;
  /* ./T80/T80_MCode.vhd:1365:88  */
  assign n4486_o = ir == 8'b00101101;
  /* ./T80/T80_MCode.vhd:1365:88  */
  assign n4487_o = n4484_o | n4486_o;
  /* ./T80/T80_MCode.vhd:1365:99  */
  assign n4489_o = ir == 8'b00101111;
  /* ./T80/T80_MCode.vhd:1365:99  */
  assign n4490_o = n4487_o | n4489_o;
  /* ./T80/T80_MCode.vhd:1366:33  */
  assign n4492_o = ir == 8'b00110000;
  /* ./T80/T80_MCode.vhd:1366:33  */
  assign n4493_o = n4490_o | n4492_o;
  /* ./T80/T80_MCode.vhd:1366:44  */
  assign n4495_o = ir == 8'b00110001;
  /* ./T80/T80_MCode.vhd:1366:44  */
  assign n4496_o = n4493_o | n4495_o;
  /* ./T80/T80_MCode.vhd:1366:55  */
  assign n4498_o = ir == 8'b00110010;
  /* ./T80/T80_MCode.vhd:1366:55  */
  assign n4499_o = n4496_o | n4498_o;
  /* ./T80/T80_MCode.vhd:1366:66  */
  assign n4501_o = ir == 8'b00110011;
  /* ./T80/T80_MCode.vhd:1366:66  */
  assign n4502_o = n4499_o | n4501_o;
  /* ./T80/T80_MCode.vhd:1366:77  */
  assign n4504_o = ir == 8'b00110100;
  /* ./T80/T80_MCode.vhd:1366:77  */
  assign n4505_o = n4502_o | n4504_o;
  /* ./T80/T80_MCode.vhd:1366:88  */
  assign n4507_o = ir == 8'b00110101;
  /* ./T80/T80_MCode.vhd:1366:88  */
  assign n4508_o = n4505_o | n4507_o;
  /* ./T80/T80_MCode.vhd:1366:99  */
  assign n4510_o = ir == 8'b00110111;
  /* ./T80/T80_MCode.vhd:1366:99  */
  assign n4511_o = n4508_o | n4510_o;
  /* ./T80/T80_MCode.vhd:1367:33  */
  assign n4513_o = ir == 8'b00111000;
  /* ./T80/T80_MCode.vhd:1367:33  */
  assign n4514_o = n4511_o | n4513_o;
  /* ./T80/T80_MCode.vhd:1367:44  */
  assign n4516_o = ir == 8'b00111001;
  /* ./T80/T80_MCode.vhd:1367:44  */
  assign n4517_o = n4514_o | n4516_o;
  /* ./T80/T80_MCode.vhd:1367:55  */
  assign n4519_o = ir == 8'b00111010;
  /* ./T80/T80_MCode.vhd:1367:55  */
  assign n4520_o = n4517_o | n4519_o;
  /* ./T80/T80_MCode.vhd:1367:66  */
  assign n4522_o = ir == 8'b00111011;
  /* ./T80/T80_MCode.vhd:1367:66  */
  assign n4523_o = n4520_o | n4522_o;
  /* ./T80/T80_MCode.vhd:1367:77  */
  assign n4525_o = ir == 8'b00111100;
  /* ./T80/T80_MCode.vhd:1367:77  */
  assign n4526_o = n4523_o | n4525_o;
  /* ./T80/T80_MCode.vhd:1367:88  */
  assign n4528_o = ir == 8'b00111101;
  /* ./T80/T80_MCode.vhd:1367:88  */
  assign n4529_o = n4526_o | n4528_o;
  /* ./T80/T80_MCode.vhd:1367:99  */
  assign n4531_o = ir == 8'b00111111;
  /* ./T80/T80_MCode.vhd:1367:99  */
  assign n4532_o = n4529_o | n4531_o;
  /* ./T80/T80_MCode.vhd:1411:38  */
  assign n4533_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1412:33  */
  assign n4535_o = n4533_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1412:40  */
  assign n4537_o = n4533_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1412:40  */
  assign n4538_o = n4535_o | n4537_o;
  /* ./T80/T80_MCode.vhd:1414:33  */
  assign n4540_o = n4533_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1420:33  */
  assign n4542_o = n4533_o == 31'b0000000000000000000000000000011;
  assign n4543_o = {n4542_o, n4540_o, n4538_o};
  /* ./T80/T80_MCode.vhd:1411:33  */
  always @*
    case (n4543_o)
      3'b100: n4545_o = n2115_o;
      3'b010: n4545_o = 3'b100;
      3'b001: n4545_o = n2115_o;
      default: n4545_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1411:33  */
  always @*
    case (n4543_o)
      3'b100: n4548_o = 1'b0;
      3'b010: n4548_o = 1'b1;
      3'b001: n4548_o = 1'b0;
      default: n4548_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1411:33  */
  always @*
    case (n4543_o)
      3'b100: n4550_o = n2118_o;
      3'b010: n4550_o = 4'b1000;
      3'b001: n4550_o = n2118_o;
      default: n4550_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1411:33  */
  always @*
    case (n4543_o)
      3'b100: n4553_o = 1'b0;
      3'b010: n4553_o = 1'b1;
      3'b001: n4553_o = 1'b0;
      default: n4553_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1411:33  */
  always @*
    case (n4543_o)
      3'b100: n4557_o = 3'b111;
      3'b010: n4557_o = 3'b010;
      3'b001: n4557_o = 3'b010;
      default: n4557_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1411:33  */
  always @*
    case (n4543_o)
      3'b100: n4560_o = 1'b1;
      3'b010: n4560_o = 1'b0;
      3'b001: n4560_o = 1'b0;
      default: n4560_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1401:25  */
  assign n4562_o = ir == 8'b00000110;
  /* ./T80/T80_MCode.vhd:1401:40  */
  assign n4564_o = ir == 8'b00010110;
  /* ./T80/T80_MCode.vhd:1401:40  */
  assign n4565_o = n4562_o | n4564_o;
  /* ./T80/T80_MCode.vhd:1401:51  */
  assign n4567_o = ir == 8'b00001110;
  /* ./T80/T80_MCode.vhd:1401:51  */
  assign n4568_o = n4565_o | n4567_o;
  /* ./T80/T80_MCode.vhd:1401:62  */
  assign n4570_o = ir == 8'b00011110;
  /* ./T80/T80_MCode.vhd:1401:62  */
  assign n4571_o = n4568_o | n4570_o;
  /* ./T80/T80_MCode.vhd:1401:73  */
  assign n4573_o = ir == 8'b00101110;
  /* ./T80/T80_MCode.vhd:1401:73  */
  assign n4574_o = n4571_o | n4573_o;
  /* ./T80/T80_MCode.vhd:1401:84  */
  assign n4576_o = ir == 8'b00111110;
  /* ./T80/T80_MCode.vhd:1401:84  */
  assign n4577_o = n4574_o | n4576_o;
  /* ./T80/T80_MCode.vhd:1401:95  */
  assign n4579_o = ir == 8'b00100110;
  /* ./T80/T80_MCode.vhd:1401:95  */
  assign n4580_o = n4577_o | n4579_o;
  /* ./T80/T80_MCode.vhd:1401:106  */
  assign n4582_o = ir == 8'b00110110;
  /* ./T80/T80_MCode.vhd:1401:106  */
  assign n4583_o = n4580_o | n4582_o;
  /* ./T80/T80_MCode.vhd:1433:44  */
  assign n4585_o = xy_state == 2'b00;
  /* ./T80/T80_MCode.vhd:1434:51  */
  assign n4587_o = mcycle == 3'b001;
  /* ./T80/T80_MCode.vhd:1435:72  */
  assign n4588_o = ir[2:0];
  /* ./T80/T80_MCode.vhd:1433:33  */
  assign n4589_o = n4612_o ? n4588_o : n4311_o;
  /* ./T80/T80_MCode.vhd:1434:41  */
  assign n4591_o = n4587_o ? 4'b1001 : n2118_o;
  /* ./T80/T80_MCode.vhd:1442:46  */
  assign n4592_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1443:41  */
  assign n4594_o = n4592_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1443:48  */
  assign n4596_o = n4592_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1443:48  */
  assign n4597_o = n4594_o | n4596_o;
  /* ./T80/T80_MCode.vhd:1445:41  */
  assign n4599_o = n4592_o == 31'b0000000000000000000000000000010;
  assign n4600_o = {n4599_o, n4597_o};
  /* ./T80/T80_MCode.vhd:1442:41  */
  always @*
    case (n4600_o)
      2'b10: n4602_o = 3'b100;
      2'b01: n4602_o = n2115_o;
      default: n4602_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1442:41  */
  always @*
    case (n4600_o)
      2'b10: n4604_o = 4'b1001;
      2'b01: n4604_o = n2118_o;
      default: n4604_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1442:41  */
  always @*
    case (n4600_o)
      2'b10: n4607_o = 3'b111;
      2'b01: n4607_o = 3'b010;
      default: n4607_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1433:33  */
  assign n4610_o = n4585_o ? 3'b001 : 3'b010;
  /* ./T80/T80_MCode.vhd:1433:33  */
  assign n4611_o = n4585_o ? n2115_o : n4602_o;
  /* ./T80/T80_MCode.vhd:1433:33  */
  assign n4612_o = n4587_o & n4585_o;
  /* ./T80/T80_MCode.vhd:1433:33  */
  assign n4613_o = n4585_o ? n4591_o : n4604_o;
  /* ./T80/T80_MCode.vhd:1433:33  */
  assign n4615_o = n4585_o ? 3'b111 : n4607_o;
  /* ./T80/T80_MCode.vhd:1433:33  */
  assign n4618_o = n4585_o ? 1'b0 : 1'b1;
  /* ./T80/T80_MCode.vhd:1424:25  */
  assign n4620_o = ir == 8'b01000000;
  /* ./T80/T80_MCode.vhd:1424:40  */
  assign n4622_o = ir == 8'b01000001;
  /* ./T80/T80_MCode.vhd:1424:40  */
  assign n4623_o = n4620_o | n4622_o;
  /* ./T80/T80_MCode.vhd:1424:51  */
  assign n4625_o = ir == 8'b01000010;
  /* ./T80/T80_MCode.vhd:1424:51  */
  assign n4626_o = n4623_o | n4625_o;
  /* ./T80/T80_MCode.vhd:1424:62  */
  assign n4628_o = ir == 8'b01000011;
  /* ./T80/T80_MCode.vhd:1424:62  */
  assign n4629_o = n4626_o | n4628_o;
  /* ./T80/T80_MCode.vhd:1424:73  */
  assign n4631_o = ir == 8'b01000100;
  /* ./T80/T80_MCode.vhd:1424:73  */
  assign n4632_o = n4629_o | n4631_o;
  /* ./T80/T80_MCode.vhd:1424:84  */
  assign n4634_o = ir == 8'b01000101;
  /* ./T80/T80_MCode.vhd:1424:84  */
  assign n4635_o = n4632_o | n4634_o;
  /* ./T80/T80_MCode.vhd:1424:95  */
  assign n4637_o = ir == 8'b01000111;
  /* ./T80/T80_MCode.vhd:1424:95  */
  assign n4638_o = n4635_o | n4637_o;
  /* ./T80/T80_MCode.vhd:1425:33  */
  assign n4640_o = ir == 8'b01001000;
  /* ./T80/T80_MCode.vhd:1425:33  */
  assign n4641_o = n4638_o | n4640_o;
  /* ./T80/T80_MCode.vhd:1425:44  */
  assign n4643_o = ir == 8'b01001001;
  /* ./T80/T80_MCode.vhd:1425:44  */
  assign n4644_o = n4641_o | n4643_o;
  /* ./T80/T80_MCode.vhd:1425:55  */
  assign n4646_o = ir == 8'b01001010;
  /* ./T80/T80_MCode.vhd:1425:55  */
  assign n4647_o = n4644_o | n4646_o;
  /* ./T80/T80_MCode.vhd:1425:66  */
  assign n4649_o = ir == 8'b01001011;
  /* ./T80/T80_MCode.vhd:1425:66  */
  assign n4650_o = n4647_o | n4649_o;
  /* ./T80/T80_MCode.vhd:1425:77  */
  assign n4652_o = ir == 8'b01001100;
  /* ./T80/T80_MCode.vhd:1425:77  */
  assign n4653_o = n4650_o | n4652_o;
  /* ./T80/T80_MCode.vhd:1425:88  */
  assign n4655_o = ir == 8'b01001101;
  /* ./T80/T80_MCode.vhd:1425:88  */
  assign n4656_o = n4653_o | n4655_o;
  /* ./T80/T80_MCode.vhd:1425:99  */
  assign n4658_o = ir == 8'b01001111;
  /* ./T80/T80_MCode.vhd:1425:99  */
  assign n4659_o = n4656_o | n4658_o;
  /* ./T80/T80_MCode.vhd:1426:33  */
  assign n4661_o = ir == 8'b01010000;
  /* ./T80/T80_MCode.vhd:1426:33  */
  assign n4662_o = n4659_o | n4661_o;
  /* ./T80/T80_MCode.vhd:1426:44  */
  assign n4664_o = ir == 8'b01010001;
  /* ./T80/T80_MCode.vhd:1426:44  */
  assign n4665_o = n4662_o | n4664_o;
  /* ./T80/T80_MCode.vhd:1426:55  */
  assign n4667_o = ir == 8'b01010010;
  /* ./T80/T80_MCode.vhd:1426:55  */
  assign n4668_o = n4665_o | n4667_o;
  /* ./T80/T80_MCode.vhd:1426:66  */
  assign n4670_o = ir == 8'b01010011;
  /* ./T80/T80_MCode.vhd:1426:66  */
  assign n4671_o = n4668_o | n4670_o;
  /* ./T80/T80_MCode.vhd:1426:77  */
  assign n4673_o = ir == 8'b01010100;
  /* ./T80/T80_MCode.vhd:1426:77  */
  assign n4674_o = n4671_o | n4673_o;
  /* ./T80/T80_MCode.vhd:1426:88  */
  assign n4676_o = ir == 8'b01010101;
  /* ./T80/T80_MCode.vhd:1426:88  */
  assign n4677_o = n4674_o | n4676_o;
  /* ./T80/T80_MCode.vhd:1426:99  */
  assign n4679_o = ir == 8'b01010111;
  /* ./T80/T80_MCode.vhd:1426:99  */
  assign n4680_o = n4677_o | n4679_o;
  /* ./T80/T80_MCode.vhd:1427:33  */
  assign n4682_o = ir == 8'b01011000;
  /* ./T80/T80_MCode.vhd:1427:33  */
  assign n4683_o = n4680_o | n4682_o;
  /* ./T80/T80_MCode.vhd:1427:44  */
  assign n4685_o = ir == 8'b01011001;
  /* ./T80/T80_MCode.vhd:1427:44  */
  assign n4686_o = n4683_o | n4685_o;
  /* ./T80/T80_MCode.vhd:1427:55  */
  assign n4688_o = ir == 8'b01011010;
  /* ./T80/T80_MCode.vhd:1427:55  */
  assign n4689_o = n4686_o | n4688_o;
  /* ./T80/T80_MCode.vhd:1427:66  */
  assign n4691_o = ir == 8'b01011011;
  /* ./T80/T80_MCode.vhd:1427:66  */
  assign n4692_o = n4689_o | n4691_o;
  /* ./T80/T80_MCode.vhd:1427:77  */
  assign n4694_o = ir == 8'b01011100;
  /* ./T80/T80_MCode.vhd:1427:77  */
  assign n4695_o = n4692_o | n4694_o;
  /* ./T80/T80_MCode.vhd:1427:88  */
  assign n4697_o = ir == 8'b01011101;
  /* ./T80/T80_MCode.vhd:1427:88  */
  assign n4698_o = n4695_o | n4697_o;
  /* ./T80/T80_MCode.vhd:1427:99  */
  assign n4700_o = ir == 8'b01011111;
  /* ./T80/T80_MCode.vhd:1427:99  */
  assign n4701_o = n4698_o | n4700_o;
  /* ./T80/T80_MCode.vhd:1428:33  */
  assign n4703_o = ir == 8'b01100000;
  /* ./T80/T80_MCode.vhd:1428:33  */
  assign n4704_o = n4701_o | n4703_o;
  /* ./T80/T80_MCode.vhd:1428:44  */
  assign n4706_o = ir == 8'b01100001;
  /* ./T80/T80_MCode.vhd:1428:44  */
  assign n4707_o = n4704_o | n4706_o;
  /* ./T80/T80_MCode.vhd:1428:55  */
  assign n4709_o = ir == 8'b01100010;
  /* ./T80/T80_MCode.vhd:1428:55  */
  assign n4710_o = n4707_o | n4709_o;
  /* ./T80/T80_MCode.vhd:1428:66  */
  assign n4712_o = ir == 8'b01100011;
  /* ./T80/T80_MCode.vhd:1428:66  */
  assign n4713_o = n4710_o | n4712_o;
  /* ./T80/T80_MCode.vhd:1428:77  */
  assign n4715_o = ir == 8'b01100100;
  /* ./T80/T80_MCode.vhd:1428:77  */
  assign n4716_o = n4713_o | n4715_o;
  /* ./T80/T80_MCode.vhd:1428:88  */
  assign n4718_o = ir == 8'b01100101;
  /* ./T80/T80_MCode.vhd:1428:88  */
  assign n4719_o = n4716_o | n4718_o;
  /* ./T80/T80_MCode.vhd:1428:99  */
  assign n4721_o = ir == 8'b01100111;
  /* ./T80/T80_MCode.vhd:1428:99  */
  assign n4722_o = n4719_o | n4721_o;
  /* ./T80/T80_MCode.vhd:1429:33  */
  assign n4724_o = ir == 8'b01101000;
  /* ./T80/T80_MCode.vhd:1429:33  */
  assign n4725_o = n4722_o | n4724_o;
  /* ./T80/T80_MCode.vhd:1429:44  */
  assign n4727_o = ir == 8'b01101001;
  /* ./T80/T80_MCode.vhd:1429:44  */
  assign n4728_o = n4725_o | n4727_o;
  /* ./T80/T80_MCode.vhd:1429:55  */
  assign n4730_o = ir == 8'b01101010;
  /* ./T80/T80_MCode.vhd:1429:55  */
  assign n4731_o = n4728_o | n4730_o;
  /* ./T80/T80_MCode.vhd:1429:66  */
  assign n4733_o = ir == 8'b01101011;
  /* ./T80/T80_MCode.vhd:1429:66  */
  assign n4734_o = n4731_o | n4733_o;
  /* ./T80/T80_MCode.vhd:1429:77  */
  assign n4736_o = ir == 8'b01101100;
  /* ./T80/T80_MCode.vhd:1429:77  */
  assign n4737_o = n4734_o | n4736_o;
  /* ./T80/T80_MCode.vhd:1429:88  */
  assign n4739_o = ir == 8'b01101101;
  /* ./T80/T80_MCode.vhd:1429:88  */
  assign n4740_o = n4737_o | n4739_o;
  /* ./T80/T80_MCode.vhd:1429:99  */
  assign n4742_o = ir == 8'b01101111;
  /* ./T80/T80_MCode.vhd:1429:99  */
  assign n4743_o = n4740_o | n4742_o;
  /* ./T80/T80_MCode.vhd:1430:33  */
  assign n4745_o = ir == 8'b01110000;
  /* ./T80/T80_MCode.vhd:1430:33  */
  assign n4746_o = n4743_o | n4745_o;
  /* ./T80/T80_MCode.vhd:1430:44  */
  assign n4748_o = ir == 8'b01110001;
  /* ./T80/T80_MCode.vhd:1430:44  */
  assign n4749_o = n4746_o | n4748_o;
  /* ./T80/T80_MCode.vhd:1430:55  */
  assign n4751_o = ir == 8'b01110010;
  /* ./T80/T80_MCode.vhd:1430:55  */
  assign n4752_o = n4749_o | n4751_o;
  /* ./T80/T80_MCode.vhd:1430:66  */
  assign n4754_o = ir == 8'b01110011;
  /* ./T80/T80_MCode.vhd:1430:66  */
  assign n4755_o = n4752_o | n4754_o;
  /* ./T80/T80_MCode.vhd:1430:77  */
  assign n4757_o = ir == 8'b01110100;
  /* ./T80/T80_MCode.vhd:1430:77  */
  assign n4758_o = n4755_o | n4757_o;
  /* ./T80/T80_MCode.vhd:1430:88  */
  assign n4760_o = ir == 8'b01110101;
  /* ./T80/T80_MCode.vhd:1430:88  */
  assign n4761_o = n4758_o | n4760_o;
  /* ./T80/T80_MCode.vhd:1430:99  */
  assign n4763_o = ir == 8'b01110111;
  /* ./T80/T80_MCode.vhd:1430:99  */
  assign n4764_o = n4761_o | n4763_o;
  /* ./T80/T80_MCode.vhd:1431:33  */
  assign n4766_o = ir == 8'b01111000;
  /* ./T80/T80_MCode.vhd:1431:33  */
  assign n4767_o = n4764_o | n4766_o;
  /* ./T80/T80_MCode.vhd:1431:44  */
  assign n4769_o = ir == 8'b01111001;
  /* ./T80/T80_MCode.vhd:1431:44  */
  assign n4770_o = n4767_o | n4769_o;
  /* ./T80/T80_MCode.vhd:1431:55  */
  assign n4772_o = ir == 8'b01111010;
  /* ./T80/T80_MCode.vhd:1431:55  */
  assign n4773_o = n4770_o | n4772_o;
  /* ./T80/T80_MCode.vhd:1431:66  */
  assign n4775_o = ir == 8'b01111011;
  /* ./T80/T80_MCode.vhd:1431:66  */
  assign n4776_o = n4773_o | n4775_o;
  /* ./T80/T80_MCode.vhd:1431:77  */
  assign n4778_o = ir == 8'b01111100;
  /* ./T80/T80_MCode.vhd:1431:77  */
  assign n4779_o = n4776_o | n4778_o;
  /* ./T80/T80_MCode.vhd:1431:88  */
  assign n4781_o = ir == 8'b01111101;
  /* ./T80/T80_MCode.vhd:1431:88  */
  assign n4782_o = n4779_o | n4781_o;
  /* ./T80/T80_MCode.vhd:1431:99  */
  assign n4784_o = ir == 8'b01111111;
  /* ./T80/T80_MCode.vhd:1431:99  */
  assign n4785_o = n4782_o | n4784_o;
  /* ./T80/T80_MCode.vhd:1455:38  */
  assign n4786_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1456:33  */
  assign n4788_o = n4786_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1456:40  */
  assign n4790_o = n4786_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1456:40  */
  assign n4791_o = n4788_o | n4790_o;
  /* ./T80/T80_MCode.vhd:1458:33  */
  assign n4793_o = n4786_o == 31'b0000000000000000000000000000010;
  assign n4794_o = {n4793_o, n4791_o};
  /* ./T80/T80_MCode.vhd:1455:33  */
  always @*
    case (n4794_o)
      2'b10: n4796_o = 3'b100;
      2'b01: n4796_o = n2115_o;
      default: n4796_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1455:33  */
  always @*
    case (n4794_o)
      2'b10: n4798_o = 4'b1001;
      2'b01: n4798_o = n2118_o;
      default: n4798_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1455:33  */
  always @*
    case (n4794_o)
      2'b10: n4801_o = 3'b111;
      2'b01: n4801_o = 3'b010;
      default: n4801_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1452:25  */
  assign n4803_o = ir == 8'b01000110;
  /* ./T80/T80_MCode.vhd:1452:40  */
  assign n4805_o = ir == 8'b01001110;
  /* ./T80/T80_MCode.vhd:1452:40  */
  assign n4806_o = n4803_o | n4805_o;
  /* ./T80/T80_MCode.vhd:1452:51  */
  assign n4808_o = ir == 8'b01010110;
  /* ./T80/T80_MCode.vhd:1452:51  */
  assign n4809_o = n4806_o | n4808_o;
  /* ./T80/T80_MCode.vhd:1452:62  */
  assign n4811_o = ir == 8'b01011110;
  /* ./T80/T80_MCode.vhd:1452:62  */
  assign n4812_o = n4809_o | n4811_o;
  /* ./T80/T80_MCode.vhd:1452:73  */
  assign n4814_o = ir == 8'b01100110;
  /* ./T80/T80_MCode.vhd:1452:73  */
  assign n4815_o = n4812_o | n4814_o;
  /* ./T80/T80_MCode.vhd:1452:84  */
  assign n4817_o = ir == 8'b01101110;
  /* ./T80/T80_MCode.vhd:1452:84  */
  assign n4818_o = n4815_o | n4817_o;
  /* ./T80/T80_MCode.vhd:1452:95  */
  assign n4820_o = ir == 8'b01110110;
  /* ./T80/T80_MCode.vhd:1452:95  */
  assign n4821_o = n4818_o | n4820_o;
  /* ./T80/T80_MCode.vhd:1452:106  */
  assign n4823_o = ir == 8'b01111110;
  /* ./T80/T80_MCode.vhd:1452:106  */
  assign n4824_o = n4821_o | n4823_o;
  /* ./T80/T80_MCode.vhd:1472:44  */
  assign n4826_o = xy_state == 2'b00;
  /* ./T80/T80_MCode.vhd:1473:51  */
  assign n4828_o = mcycle == 3'b001;
  /* ./T80/T80_MCode.vhd:1473:41  */
  assign n4831_o = n4828_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1473:41  */
  assign n4833_o = n4828_o ? 4'b1010 : n2118_o;
  /* ./T80/T80_MCode.vhd:1473:41  */
  assign n4836_o = n4828_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1482:46  */
  assign n4837_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1483:41  */
  assign n4839_o = n4837_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1483:48  */
  assign n4841_o = n4837_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1483:48  */
  assign n4842_o = n4839_o | n4841_o;
  /* ./T80/T80_MCode.vhd:1485:41  */
  assign n4844_o = n4837_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1491:41  */
  assign n4846_o = n4837_o == 31'b0000000000000000000000000000011;
  assign n4847_o = {n4846_o, n4844_o, n4842_o};
  /* ./T80/T80_MCode.vhd:1482:41  */
  always @*
    case (n4847_o)
      3'b100: n4849_o = n2115_o;
      3'b010: n4849_o = 3'b100;
      3'b001: n4849_o = n2115_o;
      default: n4849_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1482:41  */
  always @*
    case (n4847_o)
      3'b100: n4852_o = 1'b0;
      3'b010: n4852_o = 1'b1;
      3'b001: n4852_o = 1'b0;
      default: n4852_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1482:41  */
  always @*
    case (n4847_o)
      3'b100: n4854_o = n2118_o;
      3'b010: n4854_o = 4'b1010;
      3'b001: n4854_o = n2118_o;
      default: n4854_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1482:41  */
  always @*
    case (n4847_o)
      3'b100: n4857_o = 1'b0;
      3'b010: n4857_o = 1'b1;
      3'b001: n4857_o = 1'b0;
      default: n4857_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1482:41  */
  always @*
    case (n4847_o)
      3'b100: n4861_o = 3'b111;
      3'b010: n4861_o = 3'b010;
      3'b001: n4861_o = 3'b010;
      default: n4861_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1482:41  */
  always @*
    case (n4847_o)
      3'b100: n4864_o = 1'b1;
      3'b010: n4864_o = 1'b0;
      3'b001: n4864_o = 1'b0;
      default: n4864_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4867_o = n4826_o ? 3'b001 : 3'b011;
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4868_o = n4826_o ? n2115_o : n4849_o;
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4869_o = n4826_o ? n4831_o : n4852_o;
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4870_o = n4826_o ? n4833_o : n4854_o;
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4871_o = n4826_o ? n4836_o : n4857_o;
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4873_o = n4826_o ? 3'b111 : n4861_o;
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4875_o = n4826_o ? 1'b0 : n4864_o;
  /* ./T80/T80_MCode.vhd:1472:33  */
  assign n4878_o = n4826_o ? 1'b0 : 1'b1;
  /* ./T80/T80_MCode.vhd:1463:25  */
  assign n4880_o = ir == 8'b11000000;
  /* ./T80/T80_MCode.vhd:1463:40  */
  assign n4882_o = ir == 8'b11000001;
  /* ./T80/T80_MCode.vhd:1463:40  */
  assign n4883_o = n4880_o | n4882_o;
  /* ./T80/T80_MCode.vhd:1463:51  */
  assign n4885_o = ir == 8'b11000010;
  /* ./T80/T80_MCode.vhd:1463:51  */
  assign n4886_o = n4883_o | n4885_o;
  /* ./T80/T80_MCode.vhd:1463:62  */
  assign n4888_o = ir == 8'b11000011;
  /* ./T80/T80_MCode.vhd:1463:62  */
  assign n4889_o = n4886_o | n4888_o;
  /* ./T80/T80_MCode.vhd:1463:73  */
  assign n4891_o = ir == 8'b11000100;
  /* ./T80/T80_MCode.vhd:1463:73  */
  assign n4892_o = n4889_o | n4891_o;
  /* ./T80/T80_MCode.vhd:1463:84  */
  assign n4894_o = ir == 8'b11000101;
  /* ./T80/T80_MCode.vhd:1463:84  */
  assign n4895_o = n4892_o | n4894_o;
  /* ./T80/T80_MCode.vhd:1463:95  */
  assign n4897_o = ir == 8'b11000111;
  /* ./T80/T80_MCode.vhd:1463:95  */
  assign n4898_o = n4895_o | n4897_o;
  /* ./T80/T80_MCode.vhd:1464:33  */
  assign n4900_o = ir == 8'b11001000;
  /* ./T80/T80_MCode.vhd:1464:33  */
  assign n4901_o = n4898_o | n4900_o;
  /* ./T80/T80_MCode.vhd:1464:44  */
  assign n4903_o = ir == 8'b11001001;
  /* ./T80/T80_MCode.vhd:1464:44  */
  assign n4904_o = n4901_o | n4903_o;
  /* ./T80/T80_MCode.vhd:1464:55  */
  assign n4906_o = ir == 8'b11001010;
  /* ./T80/T80_MCode.vhd:1464:55  */
  assign n4907_o = n4904_o | n4906_o;
  /* ./T80/T80_MCode.vhd:1464:66  */
  assign n4909_o = ir == 8'b11001011;
  /* ./T80/T80_MCode.vhd:1464:66  */
  assign n4910_o = n4907_o | n4909_o;
  /* ./T80/T80_MCode.vhd:1464:77  */
  assign n4912_o = ir == 8'b11001100;
  /* ./T80/T80_MCode.vhd:1464:77  */
  assign n4913_o = n4910_o | n4912_o;
  /* ./T80/T80_MCode.vhd:1464:88  */
  assign n4915_o = ir == 8'b11001101;
  /* ./T80/T80_MCode.vhd:1464:88  */
  assign n4916_o = n4913_o | n4915_o;
  /* ./T80/T80_MCode.vhd:1464:99  */
  assign n4918_o = ir == 8'b11001111;
  /* ./T80/T80_MCode.vhd:1464:99  */
  assign n4919_o = n4916_o | n4918_o;
  /* ./T80/T80_MCode.vhd:1465:33  */
  assign n4921_o = ir == 8'b11010000;
  /* ./T80/T80_MCode.vhd:1465:33  */
  assign n4922_o = n4919_o | n4921_o;
  /* ./T80/T80_MCode.vhd:1465:44  */
  assign n4924_o = ir == 8'b11010001;
  /* ./T80/T80_MCode.vhd:1465:44  */
  assign n4925_o = n4922_o | n4924_o;
  /* ./T80/T80_MCode.vhd:1465:55  */
  assign n4927_o = ir == 8'b11010010;
  /* ./T80/T80_MCode.vhd:1465:55  */
  assign n4928_o = n4925_o | n4927_o;
  /* ./T80/T80_MCode.vhd:1465:66  */
  assign n4930_o = ir == 8'b11010011;
  /* ./T80/T80_MCode.vhd:1465:66  */
  assign n4931_o = n4928_o | n4930_o;
  /* ./T80/T80_MCode.vhd:1465:77  */
  assign n4933_o = ir == 8'b11010100;
  /* ./T80/T80_MCode.vhd:1465:77  */
  assign n4934_o = n4931_o | n4933_o;
  /* ./T80/T80_MCode.vhd:1465:88  */
  assign n4936_o = ir == 8'b11010101;
  /* ./T80/T80_MCode.vhd:1465:88  */
  assign n4937_o = n4934_o | n4936_o;
  /* ./T80/T80_MCode.vhd:1465:99  */
  assign n4939_o = ir == 8'b11010111;
  /* ./T80/T80_MCode.vhd:1465:99  */
  assign n4940_o = n4937_o | n4939_o;
  /* ./T80/T80_MCode.vhd:1466:33  */
  assign n4942_o = ir == 8'b11011000;
  /* ./T80/T80_MCode.vhd:1466:33  */
  assign n4943_o = n4940_o | n4942_o;
  /* ./T80/T80_MCode.vhd:1466:44  */
  assign n4945_o = ir == 8'b11011001;
  /* ./T80/T80_MCode.vhd:1466:44  */
  assign n4946_o = n4943_o | n4945_o;
  /* ./T80/T80_MCode.vhd:1466:55  */
  assign n4948_o = ir == 8'b11011010;
  /* ./T80/T80_MCode.vhd:1466:55  */
  assign n4949_o = n4946_o | n4948_o;
  /* ./T80/T80_MCode.vhd:1466:66  */
  assign n4951_o = ir == 8'b11011011;
  /* ./T80/T80_MCode.vhd:1466:66  */
  assign n4952_o = n4949_o | n4951_o;
  /* ./T80/T80_MCode.vhd:1466:77  */
  assign n4954_o = ir == 8'b11011100;
  /* ./T80/T80_MCode.vhd:1466:77  */
  assign n4955_o = n4952_o | n4954_o;
  /* ./T80/T80_MCode.vhd:1466:88  */
  assign n4957_o = ir == 8'b11011101;
  /* ./T80/T80_MCode.vhd:1466:88  */
  assign n4958_o = n4955_o | n4957_o;
  /* ./T80/T80_MCode.vhd:1466:99  */
  assign n4960_o = ir == 8'b11011111;
  /* ./T80/T80_MCode.vhd:1466:99  */
  assign n4961_o = n4958_o | n4960_o;
  /* ./T80/T80_MCode.vhd:1467:33  */
  assign n4963_o = ir == 8'b11100000;
  /* ./T80/T80_MCode.vhd:1467:33  */
  assign n4964_o = n4961_o | n4963_o;
  /* ./T80/T80_MCode.vhd:1467:44  */
  assign n4966_o = ir == 8'b11100001;
  /* ./T80/T80_MCode.vhd:1467:44  */
  assign n4967_o = n4964_o | n4966_o;
  /* ./T80/T80_MCode.vhd:1467:55  */
  assign n4969_o = ir == 8'b11100010;
  /* ./T80/T80_MCode.vhd:1467:55  */
  assign n4970_o = n4967_o | n4969_o;
  /* ./T80/T80_MCode.vhd:1467:66  */
  assign n4972_o = ir == 8'b11100011;
  /* ./T80/T80_MCode.vhd:1467:66  */
  assign n4973_o = n4970_o | n4972_o;
  /* ./T80/T80_MCode.vhd:1467:77  */
  assign n4975_o = ir == 8'b11100100;
  /* ./T80/T80_MCode.vhd:1467:77  */
  assign n4976_o = n4973_o | n4975_o;
  /* ./T80/T80_MCode.vhd:1467:88  */
  assign n4978_o = ir == 8'b11100101;
  /* ./T80/T80_MCode.vhd:1467:88  */
  assign n4979_o = n4976_o | n4978_o;
  /* ./T80/T80_MCode.vhd:1467:99  */
  assign n4981_o = ir == 8'b11100111;
  /* ./T80/T80_MCode.vhd:1467:99  */
  assign n4982_o = n4979_o | n4981_o;
  /* ./T80/T80_MCode.vhd:1468:33  */
  assign n4984_o = ir == 8'b11101000;
  /* ./T80/T80_MCode.vhd:1468:33  */
  assign n4985_o = n4982_o | n4984_o;
  /* ./T80/T80_MCode.vhd:1468:44  */
  assign n4987_o = ir == 8'b11101001;
  /* ./T80/T80_MCode.vhd:1468:44  */
  assign n4988_o = n4985_o | n4987_o;
  /* ./T80/T80_MCode.vhd:1468:55  */
  assign n4990_o = ir == 8'b11101010;
  /* ./T80/T80_MCode.vhd:1468:55  */
  assign n4991_o = n4988_o | n4990_o;
  /* ./T80/T80_MCode.vhd:1468:66  */
  assign n4993_o = ir == 8'b11101011;
  /* ./T80/T80_MCode.vhd:1468:66  */
  assign n4994_o = n4991_o | n4993_o;
  /* ./T80/T80_MCode.vhd:1468:77  */
  assign n4996_o = ir == 8'b11101100;
  /* ./T80/T80_MCode.vhd:1468:77  */
  assign n4997_o = n4994_o | n4996_o;
  /* ./T80/T80_MCode.vhd:1468:88  */
  assign n4999_o = ir == 8'b11101101;
  /* ./T80/T80_MCode.vhd:1468:88  */
  assign n5000_o = n4997_o | n4999_o;
  /* ./T80/T80_MCode.vhd:1468:99  */
  assign n5002_o = ir == 8'b11101111;
  /* ./T80/T80_MCode.vhd:1468:99  */
  assign n5003_o = n5000_o | n5002_o;
  /* ./T80/T80_MCode.vhd:1469:33  */
  assign n5005_o = ir == 8'b11110000;
  /* ./T80/T80_MCode.vhd:1469:33  */
  assign n5006_o = n5003_o | n5005_o;
  /* ./T80/T80_MCode.vhd:1469:44  */
  assign n5008_o = ir == 8'b11110001;
  /* ./T80/T80_MCode.vhd:1469:44  */
  assign n5009_o = n5006_o | n5008_o;
  /* ./T80/T80_MCode.vhd:1469:55  */
  assign n5011_o = ir == 8'b11110010;
  /* ./T80/T80_MCode.vhd:1469:55  */
  assign n5012_o = n5009_o | n5011_o;
  /* ./T80/T80_MCode.vhd:1469:66  */
  assign n5014_o = ir == 8'b11110011;
  /* ./T80/T80_MCode.vhd:1469:66  */
  assign n5015_o = n5012_o | n5014_o;
  /* ./T80/T80_MCode.vhd:1469:77  */
  assign n5017_o = ir == 8'b11110100;
  /* ./T80/T80_MCode.vhd:1469:77  */
  assign n5018_o = n5015_o | n5017_o;
  /* ./T80/T80_MCode.vhd:1469:88  */
  assign n5020_o = ir == 8'b11110101;
  /* ./T80/T80_MCode.vhd:1469:88  */
  assign n5021_o = n5018_o | n5020_o;
  /* ./T80/T80_MCode.vhd:1469:99  */
  assign n5023_o = ir == 8'b11110111;
  /* ./T80/T80_MCode.vhd:1469:99  */
  assign n5024_o = n5021_o | n5023_o;
  /* ./T80/T80_MCode.vhd:1470:33  */
  assign n5026_o = ir == 8'b11111000;
  /* ./T80/T80_MCode.vhd:1470:33  */
  assign n5027_o = n5024_o | n5026_o;
  /* ./T80/T80_MCode.vhd:1470:44  */
  assign n5029_o = ir == 8'b11111001;
  /* ./T80/T80_MCode.vhd:1470:44  */
  assign n5030_o = n5027_o | n5029_o;
  /* ./T80/T80_MCode.vhd:1470:55  */
  assign n5032_o = ir == 8'b11111010;
  /* ./T80/T80_MCode.vhd:1470:55  */
  assign n5033_o = n5030_o | n5032_o;
  /* ./T80/T80_MCode.vhd:1470:66  */
  assign n5035_o = ir == 8'b11111011;
  /* ./T80/T80_MCode.vhd:1470:66  */
  assign n5036_o = n5033_o | n5035_o;
  /* ./T80/T80_MCode.vhd:1470:77  */
  assign n5038_o = ir == 8'b11111100;
  /* ./T80/T80_MCode.vhd:1470:77  */
  assign n5039_o = n5036_o | n5038_o;
  /* ./T80/T80_MCode.vhd:1470:88  */
  assign n5041_o = ir == 8'b11111101;
  /* ./T80/T80_MCode.vhd:1470:88  */
  assign n5042_o = n5039_o | n5041_o;
  /* ./T80/T80_MCode.vhd:1470:99  */
  assign n5044_o = ir == 8'b11111111;
  /* ./T80/T80_MCode.vhd:1470:99  */
  assign n5045_o = n5042_o | n5044_o;
  /* ./T80/T80_MCode.vhd:1500:38  */
  assign n5046_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1501:33  */
  assign n5048_o = n5046_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1501:40  */
  assign n5050_o = n5046_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1501:40  */
  assign n5051_o = n5048_o | n5050_o;
  /* ./T80/T80_MCode.vhd:1503:33  */
  assign n5053_o = n5046_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1509:33  */
  assign n5055_o = n5046_o == 31'b0000000000000000000000000000011;
  assign n5056_o = {n5055_o, n5053_o, n5051_o};
  /* ./T80/T80_MCode.vhd:1500:33  */
  always @*
    case (n5056_o)
      3'b100: n5058_o = n2115_o;
      3'b010: n5058_o = 3'b100;
      3'b001: n5058_o = n2115_o;
      default: n5058_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1500:33  */
  always @*
    case (n5056_o)
      3'b100: n5061_o = 1'b0;
      3'b010: n5061_o = 1'b1;
      3'b001: n5061_o = 1'b0;
      default: n5061_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1500:33  */
  always @*
    case (n5056_o)
      3'b100: n5063_o = n2118_o;
      3'b010: n5063_o = 4'b1010;
      3'b001: n5063_o = n2118_o;
      default: n5063_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1500:33  */
  always @*
    case (n5056_o)
      3'b100: n5066_o = 1'b0;
      3'b010: n5066_o = 1'b1;
      3'b001: n5066_o = 1'b0;
      default: n5066_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1500:33  */
  always @*
    case (n5056_o)
      3'b100: n5070_o = 3'b111;
      3'b010: n5070_o = 3'b010;
      3'b001: n5070_o = 3'b010;
      default: n5070_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1500:33  */
  always @*
    case (n5056_o)
      3'b100: n5073_o = 1'b1;
      3'b010: n5073_o = 1'b0;
      3'b001: n5073_o = 1'b0;
      default: n5073_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1497:25  */
  assign n5075_o = ir == 8'b11000110;
  /* ./T80/T80_MCode.vhd:1497:40  */
  assign n5077_o = ir == 8'b11001110;
  /* ./T80/T80_MCode.vhd:1497:40  */
  assign n5078_o = n5075_o | n5077_o;
  /* ./T80/T80_MCode.vhd:1497:51  */
  assign n5080_o = ir == 8'b11010110;
  /* ./T80/T80_MCode.vhd:1497:51  */
  assign n5081_o = n5078_o | n5080_o;
  /* ./T80/T80_MCode.vhd:1497:62  */
  assign n5083_o = ir == 8'b11011110;
  /* ./T80/T80_MCode.vhd:1497:62  */
  assign n5084_o = n5081_o | n5083_o;
  /* ./T80/T80_MCode.vhd:1497:73  */
  assign n5086_o = ir == 8'b11100110;
  /* ./T80/T80_MCode.vhd:1497:73  */
  assign n5087_o = n5084_o | n5086_o;
  /* ./T80/T80_MCode.vhd:1497:84  */
  assign n5089_o = ir == 8'b11101110;
  /* ./T80/T80_MCode.vhd:1497:84  */
  assign n5090_o = n5087_o | n5089_o;
  /* ./T80/T80_MCode.vhd:1497:95  */
  assign n5092_o = ir == 8'b11110110;
  /* ./T80/T80_MCode.vhd:1497:95  */
  assign n5093_o = n5090_o | n5092_o;
  /* ./T80/T80_MCode.vhd:1497:106  */
  assign n5095_o = ir == 8'b11111110;
  /* ./T80/T80_MCode.vhd:1497:106  */
  assign n5096_o = n5093_o | n5095_o;
  /* ./T80/T80_MCode.vhd:1522:44  */
  assign n5098_o = xy_state == 2'b00;
  /* ./T80/T80_MCode.vhd:1523:51  */
  assign n5100_o = mcycle == 3'b001;
  /* ./T80/T80_MCode.vhd:1523:41  */
  assign n5103_o = n5100_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1523:41  */
  assign n5105_o = n5100_o ? 4'b1011 : n2118_o;
  /* ./T80/T80_MCode.vhd:1523:41  */
  assign n5108_o = n5100_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1532:46  */
  assign n5109_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1533:41  */
  assign n5111_o = n5109_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1533:48  */
  assign n5113_o = n5109_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1533:48  */
  assign n5114_o = n5111_o | n5113_o;
  /* ./T80/T80_MCode.vhd:1535:41  */
  assign n5116_o = n5109_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1541:41  */
  assign n5118_o = n5109_o == 31'b0000000000000000000000000000011;
  assign n5119_o = {n5118_o, n5116_o, n5114_o};
  /* ./T80/T80_MCode.vhd:1532:41  */
  always @*
    case (n5119_o)
      3'b100: n5121_o = n2115_o;
      3'b010: n5121_o = 3'b100;
      3'b001: n5121_o = n2115_o;
      default: n5121_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1532:41  */
  always @*
    case (n5119_o)
      3'b100: n5124_o = 1'b0;
      3'b010: n5124_o = 1'b1;
      3'b001: n5124_o = 1'b0;
      default: n5124_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1532:41  */
  always @*
    case (n5119_o)
      3'b100: n5126_o = n2118_o;
      3'b010: n5126_o = 4'b1011;
      3'b001: n5126_o = n2118_o;
      default: n5126_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1532:41  */
  always @*
    case (n5119_o)
      3'b100: n5129_o = 1'b0;
      3'b010: n5129_o = 1'b1;
      3'b001: n5129_o = 1'b0;
      default: n5129_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1532:41  */
  always @*
    case (n5119_o)
      3'b100: n5133_o = 3'b111;
      3'b010: n5133_o = 3'b010;
      3'b001: n5133_o = 3'b010;
      default: n5133_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1532:41  */
  always @*
    case (n5119_o)
      3'b100: n5136_o = 1'b1;
      3'b010: n5136_o = 1'b0;
      3'b001: n5136_o = 1'b0;
      default: n5136_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5139_o = n5098_o ? 3'b001 : 3'b011;
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5140_o = n5098_o ? n2115_o : n5121_o;
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5141_o = n5098_o ? n5103_o : n5124_o;
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5142_o = n5098_o ? n5105_o : n5126_o;
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5143_o = n5098_o ? n5108_o : n5129_o;
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5145_o = n5098_o ? 3'b111 : n5133_o;
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5147_o = n5098_o ? 1'b0 : n5136_o;
  /* ./T80/T80_MCode.vhd:1522:33  */
  assign n5150_o = n5098_o ? 1'b0 : 1'b1;
  /* ./T80/T80_MCode.vhd:1513:25  */
  assign n5152_o = ir == 8'b10000000;
  /* ./T80/T80_MCode.vhd:1513:40  */
  assign n5154_o = ir == 8'b10000001;
  /* ./T80/T80_MCode.vhd:1513:40  */
  assign n5155_o = n5152_o | n5154_o;
  /* ./T80/T80_MCode.vhd:1513:51  */
  assign n5157_o = ir == 8'b10000010;
  /* ./T80/T80_MCode.vhd:1513:51  */
  assign n5158_o = n5155_o | n5157_o;
  /* ./T80/T80_MCode.vhd:1513:62  */
  assign n5160_o = ir == 8'b10000011;
  /* ./T80/T80_MCode.vhd:1513:62  */
  assign n5161_o = n5158_o | n5160_o;
  /* ./T80/T80_MCode.vhd:1513:73  */
  assign n5163_o = ir == 8'b10000100;
  /* ./T80/T80_MCode.vhd:1513:73  */
  assign n5164_o = n5161_o | n5163_o;
  /* ./T80/T80_MCode.vhd:1513:84  */
  assign n5166_o = ir == 8'b10000101;
  /* ./T80/T80_MCode.vhd:1513:84  */
  assign n5167_o = n5164_o | n5166_o;
  /* ./T80/T80_MCode.vhd:1513:95  */
  assign n5169_o = ir == 8'b10000111;
  /* ./T80/T80_MCode.vhd:1513:95  */
  assign n5170_o = n5167_o | n5169_o;
  /* ./T80/T80_MCode.vhd:1514:33  */
  assign n5172_o = ir == 8'b10001000;
  /* ./T80/T80_MCode.vhd:1514:33  */
  assign n5173_o = n5170_o | n5172_o;
  /* ./T80/T80_MCode.vhd:1514:44  */
  assign n5175_o = ir == 8'b10001001;
  /* ./T80/T80_MCode.vhd:1514:44  */
  assign n5176_o = n5173_o | n5175_o;
  /* ./T80/T80_MCode.vhd:1514:55  */
  assign n5178_o = ir == 8'b10001010;
  /* ./T80/T80_MCode.vhd:1514:55  */
  assign n5179_o = n5176_o | n5178_o;
  /* ./T80/T80_MCode.vhd:1514:66  */
  assign n5181_o = ir == 8'b10001011;
  /* ./T80/T80_MCode.vhd:1514:66  */
  assign n5182_o = n5179_o | n5181_o;
  /* ./T80/T80_MCode.vhd:1514:77  */
  assign n5184_o = ir == 8'b10001100;
  /* ./T80/T80_MCode.vhd:1514:77  */
  assign n5185_o = n5182_o | n5184_o;
  /* ./T80/T80_MCode.vhd:1514:88  */
  assign n5187_o = ir == 8'b10001101;
  /* ./T80/T80_MCode.vhd:1514:88  */
  assign n5188_o = n5185_o | n5187_o;
  /* ./T80/T80_MCode.vhd:1514:99  */
  assign n5190_o = ir == 8'b10001111;
  /* ./T80/T80_MCode.vhd:1514:99  */
  assign n5191_o = n5188_o | n5190_o;
  /* ./T80/T80_MCode.vhd:1515:33  */
  assign n5193_o = ir == 8'b10010000;
  /* ./T80/T80_MCode.vhd:1515:33  */
  assign n5194_o = n5191_o | n5193_o;
  /* ./T80/T80_MCode.vhd:1515:44  */
  assign n5196_o = ir == 8'b10010001;
  /* ./T80/T80_MCode.vhd:1515:44  */
  assign n5197_o = n5194_o | n5196_o;
  /* ./T80/T80_MCode.vhd:1515:55  */
  assign n5199_o = ir == 8'b10010010;
  /* ./T80/T80_MCode.vhd:1515:55  */
  assign n5200_o = n5197_o | n5199_o;
  /* ./T80/T80_MCode.vhd:1515:66  */
  assign n5202_o = ir == 8'b10010011;
  /* ./T80/T80_MCode.vhd:1515:66  */
  assign n5203_o = n5200_o | n5202_o;
  /* ./T80/T80_MCode.vhd:1515:77  */
  assign n5205_o = ir == 8'b10010100;
  /* ./T80/T80_MCode.vhd:1515:77  */
  assign n5206_o = n5203_o | n5205_o;
  /* ./T80/T80_MCode.vhd:1515:88  */
  assign n5208_o = ir == 8'b10010101;
  /* ./T80/T80_MCode.vhd:1515:88  */
  assign n5209_o = n5206_o | n5208_o;
  /* ./T80/T80_MCode.vhd:1515:99  */
  assign n5211_o = ir == 8'b10010111;
  /* ./T80/T80_MCode.vhd:1515:99  */
  assign n5212_o = n5209_o | n5211_o;
  /* ./T80/T80_MCode.vhd:1516:33  */
  assign n5214_o = ir == 8'b10011000;
  /* ./T80/T80_MCode.vhd:1516:33  */
  assign n5215_o = n5212_o | n5214_o;
  /* ./T80/T80_MCode.vhd:1516:44  */
  assign n5217_o = ir == 8'b10011001;
  /* ./T80/T80_MCode.vhd:1516:44  */
  assign n5218_o = n5215_o | n5217_o;
  /* ./T80/T80_MCode.vhd:1516:55  */
  assign n5220_o = ir == 8'b10011010;
  /* ./T80/T80_MCode.vhd:1516:55  */
  assign n5221_o = n5218_o | n5220_o;
  /* ./T80/T80_MCode.vhd:1516:66  */
  assign n5223_o = ir == 8'b10011011;
  /* ./T80/T80_MCode.vhd:1516:66  */
  assign n5224_o = n5221_o | n5223_o;
  /* ./T80/T80_MCode.vhd:1516:77  */
  assign n5226_o = ir == 8'b10011100;
  /* ./T80/T80_MCode.vhd:1516:77  */
  assign n5227_o = n5224_o | n5226_o;
  /* ./T80/T80_MCode.vhd:1516:88  */
  assign n5229_o = ir == 8'b10011101;
  /* ./T80/T80_MCode.vhd:1516:88  */
  assign n5230_o = n5227_o | n5229_o;
  /* ./T80/T80_MCode.vhd:1516:99  */
  assign n5232_o = ir == 8'b10011111;
  /* ./T80/T80_MCode.vhd:1516:99  */
  assign n5233_o = n5230_o | n5232_o;
  /* ./T80/T80_MCode.vhd:1517:33  */
  assign n5235_o = ir == 8'b10100000;
  /* ./T80/T80_MCode.vhd:1517:33  */
  assign n5236_o = n5233_o | n5235_o;
  /* ./T80/T80_MCode.vhd:1517:44  */
  assign n5238_o = ir == 8'b10100001;
  /* ./T80/T80_MCode.vhd:1517:44  */
  assign n5239_o = n5236_o | n5238_o;
  /* ./T80/T80_MCode.vhd:1517:55  */
  assign n5241_o = ir == 8'b10100010;
  /* ./T80/T80_MCode.vhd:1517:55  */
  assign n5242_o = n5239_o | n5241_o;
  /* ./T80/T80_MCode.vhd:1517:66  */
  assign n5244_o = ir == 8'b10100011;
  /* ./T80/T80_MCode.vhd:1517:66  */
  assign n5245_o = n5242_o | n5244_o;
  /* ./T80/T80_MCode.vhd:1517:77  */
  assign n5247_o = ir == 8'b10100100;
  /* ./T80/T80_MCode.vhd:1517:77  */
  assign n5248_o = n5245_o | n5247_o;
  /* ./T80/T80_MCode.vhd:1517:88  */
  assign n5250_o = ir == 8'b10100101;
  /* ./T80/T80_MCode.vhd:1517:88  */
  assign n5251_o = n5248_o | n5250_o;
  /* ./T80/T80_MCode.vhd:1517:99  */
  assign n5253_o = ir == 8'b10100111;
  /* ./T80/T80_MCode.vhd:1517:99  */
  assign n5254_o = n5251_o | n5253_o;
  /* ./T80/T80_MCode.vhd:1518:33  */
  assign n5256_o = ir == 8'b10101000;
  /* ./T80/T80_MCode.vhd:1518:33  */
  assign n5257_o = n5254_o | n5256_o;
  /* ./T80/T80_MCode.vhd:1518:44  */
  assign n5259_o = ir == 8'b10101001;
  /* ./T80/T80_MCode.vhd:1518:44  */
  assign n5260_o = n5257_o | n5259_o;
  /* ./T80/T80_MCode.vhd:1518:55  */
  assign n5262_o = ir == 8'b10101010;
  /* ./T80/T80_MCode.vhd:1518:55  */
  assign n5263_o = n5260_o | n5262_o;
  /* ./T80/T80_MCode.vhd:1518:66  */
  assign n5265_o = ir == 8'b10101011;
  /* ./T80/T80_MCode.vhd:1518:66  */
  assign n5266_o = n5263_o | n5265_o;
  /* ./T80/T80_MCode.vhd:1518:77  */
  assign n5268_o = ir == 8'b10101100;
  /* ./T80/T80_MCode.vhd:1518:77  */
  assign n5269_o = n5266_o | n5268_o;
  /* ./T80/T80_MCode.vhd:1518:88  */
  assign n5271_o = ir == 8'b10101101;
  /* ./T80/T80_MCode.vhd:1518:88  */
  assign n5272_o = n5269_o | n5271_o;
  /* ./T80/T80_MCode.vhd:1518:99  */
  assign n5274_o = ir == 8'b10101111;
  /* ./T80/T80_MCode.vhd:1518:99  */
  assign n5275_o = n5272_o | n5274_o;
  /* ./T80/T80_MCode.vhd:1519:33  */
  assign n5277_o = ir == 8'b10110000;
  /* ./T80/T80_MCode.vhd:1519:33  */
  assign n5278_o = n5275_o | n5277_o;
  /* ./T80/T80_MCode.vhd:1519:44  */
  assign n5280_o = ir == 8'b10110001;
  /* ./T80/T80_MCode.vhd:1519:44  */
  assign n5281_o = n5278_o | n5280_o;
  /* ./T80/T80_MCode.vhd:1519:55  */
  assign n5283_o = ir == 8'b10110010;
  /* ./T80/T80_MCode.vhd:1519:55  */
  assign n5284_o = n5281_o | n5283_o;
  /* ./T80/T80_MCode.vhd:1519:66  */
  assign n5286_o = ir == 8'b10110011;
  /* ./T80/T80_MCode.vhd:1519:66  */
  assign n5287_o = n5284_o | n5286_o;
  /* ./T80/T80_MCode.vhd:1519:77  */
  assign n5289_o = ir == 8'b10110100;
  /* ./T80/T80_MCode.vhd:1519:77  */
  assign n5290_o = n5287_o | n5289_o;
  /* ./T80/T80_MCode.vhd:1519:88  */
  assign n5292_o = ir == 8'b10110101;
  /* ./T80/T80_MCode.vhd:1519:88  */
  assign n5293_o = n5290_o | n5292_o;
  /* ./T80/T80_MCode.vhd:1519:99  */
  assign n5295_o = ir == 8'b10110111;
  /* ./T80/T80_MCode.vhd:1519:99  */
  assign n5296_o = n5293_o | n5295_o;
  /* ./T80/T80_MCode.vhd:1520:33  */
  assign n5298_o = ir == 8'b10111000;
  /* ./T80/T80_MCode.vhd:1520:33  */
  assign n5299_o = n5296_o | n5298_o;
  /* ./T80/T80_MCode.vhd:1520:44  */
  assign n5301_o = ir == 8'b10111001;
  /* ./T80/T80_MCode.vhd:1520:44  */
  assign n5302_o = n5299_o | n5301_o;
  /* ./T80/T80_MCode.vhd:1520:55  */
  assign n5304_o = ir == 8'b10111010;
  /* ./T80/T80_MCode.vhd:1520:55  */
  assign n5305_o = n5302_o | n5304_o;
  /* ./T80/T80_MCode.vhd:1520:66  */
  assign n5307_o = ir == 8'b10111011;
  /* ./T80/T80_MCode.vhd:1520:66  */
  assign n5308_o = n5305_o | n5307_o;
  /* ./T80/T80_MCode.vhd:1520:77  */
  assign n5310_o = ir == 8'b10111100;
  /* ./T80/T80_MCode.vhd:1520:77  */
  assign n5311_o = n5308_o | n5310_o;
  /* ./T80/T80_MCode.vhd:1520:88  */
  assign n5313_o = ir == 8'b10111101;
  /* ./T80/T80_MCode.vhd:1520:88  */
  assign n5314_o = n5311_o | n5313_o;
  /* ./T80/T80_MCode.vhd:1520:99  */
  assign n5316_o = ir == 8'b10111111;
  /* ./T80/T80_MCode.vhd:1520:99  */
  assign n5317_o = n5314_o | n5316_o;
  /* ./T80/T80_MCode.vhd:1550:38  */
  assign n5318_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1551:33  */
  assign n5320_o = n5318_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1551:40  */
  assign n5322_o = n5318_o == 31'b0000000000000000000000000000111;
  /* ./T80/T80_MCode.vhd:1551:40  */
  assign n5323_o = n5320_o | n5322_o;
  /* ./T80/T80_MCode.vhd:1553:33  */
  assign n5325_o = n5318_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1559:33  */
  assign n5327_o = n5318_o == 31'b0000000000000000000000000000011;
  assign n5328_o = {n5327_o, n5325_o, n5323_o};
  /* ./T80/T80_MCode.vhd:1550:33  */
  always @*
    case (n5328_o)
      3'b100: n5330_o = n2115_o;
      3'b010: n5330_o = 3'b100;
      3'b001: n5330_o = n2115_o;
      default: n5330_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1550:33  */
  always @*
    case (n5328_o)
      3'b100: n5333_o = 1'b0;
      3'b010: n5333_o = 1'b1;
      3'b001: n5333_o = 1'b0;
      default: n5333_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1550:33  */
  always @*
    case (n5328_o)
      3'b100: n5335_o = n2118_o;
      3'b010: n5335_o = 4'b1011;
      3'b001: n5335_o = n2118_o;
      default: n5335_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1550:33  */
  always @*
    case (n5328_o)
      3'b100: n5338_o = 1'b0;
      3'b010: n5338_o = 1'b1;
      3'b001: n5338_o = 1'b0;
      default: n5338_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1550:33  */
  always @*
    case (n5328_o)
      3'b100: n5342_o = 3'b111;
      3'b010: n5342_o = 3'b010;
      3'b001: n5342_o = 3'b010;
      default: n5342_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1550:33  */
  always @*
    case (n5328_o)
      3'b100: n5345_o = 1'b1;
      3'b010: n5345_o = 1'b0;
      3'b001: n5345_o = 1'b0;
      default: n5345_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1547:25  */
  assign n5347_o = ir == 8'b10000110;
  /* ./T80/T80_MCode.vhd:1547:40  */
  assign n5349_o = ir == 8'b10001110;
  /* ./T80/T80_MCode.vhd:1547:40  */
  assign n5350_o = n5347_o | n5349_o;
  /* ./T80/T80_MCode.vhd:1547:51  */
  assign n5352_o = ir == 8'b10010110;
  /* ./T80/T80_MCode.vhd:1547:51  */
  assign n5353_o = n5350_o | n5352_o;
  /* ./T80/T80_MCode.vhd:1547:62  */
  assign n5355_o = ir == 8'b10011110;
  /* ./T80/T80_MCode.vhd:1547:62  */
  assign n5356_o = n5353_o | n5355_o;
  /* ./T80/T80_MCode.vhd:1547:73  */
  assign n5358_o = ir == 8'b10100110;
  /* ./T80/T80_MCode.vhd:1547:73  */
  assign n5359_o = n5356_o | n5358_o;
  /* ./T80/T80_MCode.vhd:1547:84  */
  assign n5361_o = ir == 8'b10101110;
  /* ./T80/T80_MCode.vhd:1547:84  */
  assign n5362_o = n5359_o | n5361_o;
  /* ./T80/T80_MCode.vhd:1547:95  */
  assign n5364_o = ir == 8'b10110110;
  /* ./T80/T80_MCode.vhd:1547:95  */
  assign n5365_o = n5362_o | n5364_o;
  /* ./T80/T80_MCode.vhd:1547:106  */
  assign n5367_o = ir == 8'b10111110;
  /* ./T80/T80_MCode.vhd:1547:106  */
  assign n5368_o = n5365_o | n5367_o;
  assign n5369_o = {n5368_o, n5317_o, n5096_o, n5045_o, n4824_o, n4785_o, n4583_o, n4532_o};
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5375_o = 3'b011;
      8'b01000000: n5375_o = n5139_o;
      8'b00100000: n5375_o = 3'b011;
      8'b00010000: n5375_o = n4867_o;
      8'b00001000: n5375_o = 3'b010;
      8'b00000100: n5375_o = n4610_o;
      8'b00000010: n5375_o = 3'b011;
      8'b00000001: n5375_o = n4354_o;
      default: n5375_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5377_o = n5330_o;
      8'b01000000: n5377_o = n5140_o;
      8'b00100000: n5377_o = n5058_o;
      8'b00010000: n5377_o = n4868_o;
      8'b00001000: n5377_o = n4796_o;
      8'b00000100: n5377_o = n4611_o;
      8'b00000010: n5377_o = n4545_o;
      8'b00000001: n5377_o = n4355_o;
      default: n5377_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5380_o = n5333_o;
      8'b01000000: n5380_o = n5141_o;
      8'b00100000: n5380_o = n5061_o;
      8'b00010000: n5380_o = n4869_o;
      8'b00001000: n5380_o = 1'b0;
      8'b00000100: n5380_o = 1'b0;
      8'b00000010: n5380_o = n4548_o;
      8'b00000001: n5380_o = n4356_o;
      default: n5380_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5382_o = n4311_o;
      8'b01000000: n5382_o = n4311_o;
      8'b00100000: n5382_o = n4311_o;
      8'b00010000: n5382_o = n4311_o;
      8'b00001000: n5382_o = n4311_o;
      8'b00000100: n5382_o = n4589_o;
      8'b00000010: n5382_o = n4311_o;
      8'b00000001: n5382_o = n4311_o;
      default: n5382_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5384_o = n5335_o;
      8'b01000000: n5384_o = n5142_o;
      8'b00100000: n5384_o = n5063_o;
      8'b00010000: n5384_o = n4870_o;
      8'b00001000: n5384_o = n4798_o;
      8'b00000100: n5384_o = n4613_o;
      8'b00000010: n5384_o = n4550_o;
      8'b00000001: n5384_o = n4357_o;
      default: n5384_o = 4'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5387_o = n5338_o;
      8'b01000000: n5387_o = n5143_o;
      8'b00100000: n5387_o = n5066_o;
      8'b00010000: n5387_o = n4871_o;
      8'b00001000: n5387_o = 1'b0;
      8'b00000100: n5387_o = 1'b0;
      8'b00000010: n5387_o = n4553_o;
      8'b00000001: n5387_o = n4358_o;
      default: n5387_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5389_o = n5342_o;
      8'b01000000: n5389_o = n5145_o;
      8'b00100000: n5389_o = n5070_o;
      8'b00010000: n5389_o = n4873_o;
      8'b00001000: n5389_o = n4801_o;
      8'b00000100: n5389_o = n4615_o;
      8'b00000010: n5389_o = n4557_o;
      8'b00000001: n5389_o = n4360_o;
      default: n5389_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5392_o = n5345_o;
      8'b01000000: n5392_o = n5147_o;
      8'b00100000: n5392_o = n5073_o;
      8'b00010000: n5392_o = n4875_o;
      8'b00001000: n5392_o = 1'b0;
      8'b00000100: n5392_o = 1'b0;
      8'b00000010: n5392_o = n4560_o;
      8'b00000001: n5392_o = n4362_o;
      default: n5392_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1359:25  */
  always @*
    case (n5369_o)
      8'b10000000: n5395_o = 1'b0;
      8'b01000000: n5395_o = n5150_o;
      8'b00100000: n5395_o = 1'b0;
      8'b00010000: n5395_o = n4878_o;
      8'b00001000: n5395_o = 1'b0;
      8'b00000100: n5395_o = n4618_o;
      8'b00000010: n5395_o = 1'b0;
      8'b00000001: n5395_o = n4365_o;
      default: n5395_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1348:17  */
  assign n5397_o = iset == 2'b01;
  /* ./T80/T80_MCode.vhd:1574:25  */
  assign n5399_o = ir == 8'b00000000;
  /* ./T80/T80_MCode.vhd:1574:40  */
  assign n5401_o = ir == 8'b00000001;
  /* ./T80/T80_MCode.vhd:1574:40  */
  assign n5402_o = n5399_o | n5401_o;
  /* ./T80/T80_MCode.vhd:1574:51  */
  assign n5404_o = ir == 8'b00000010;
  /* ./T80/T80_MCode.vhd:1574:51  */
  assign n5405_o = n5402_o | n5404_o;
  /* ./T80/T80_MCode.vhd:1574:62  */
  assign n5407_o = ir == 8'b00000011;
  /* ./T80/T80_MCode.vhd:1574:62  */
  assign n5408_o = n5405_o | n5407_o;
  /* ./T80/T80_MCode.vhd:1574:73  */
  assign n5410_o = ir == 8'b00000100;
  /* ./T80/T80_MCode.vhd:1574:73  */
  assign n5411_o = n5408_o | n5410_o;
  /* ./T80/T80_MCode.vhd:1574:84  */
  assign n5413_o = ir == 8'b00000101;
  /* ./T80/T80_MCode.vhd:1574:84  */
  assign n5414_o = n5411_o | n5413_o;
  /* ./T80/T80_MCode.vhd:1574:95  */
  assign n5416_o = ir == 8'b00000110;
  /* ./T80/T80_MCode.vhd:1574:95  */
  assign n5417_o = n5414_o | n5416_o;
  /* ./T80/T80_MCode.vhd:1574:106  */
  assign n5419_o = ir == 8'b00000111;
  /* ./T80/T80_MCode.vhd:1574:106  */
  assign n5420_o = n5417_o | n5419_o;
  /* ./T80/T80_MCode.vhd:1575:33  */
  assign n5422_o = ir == 8'b00001000;
  /* ./T80/T80_MCode.vhd:1575:33  */
  assign n5423_o = n5420_o | n5422_o;
  /* ./T80/T80_MCode.vhd:1575:44  */
  assign n5425_o = ir == 8'b00001001;
  /* ./T80/T80_MCode.vhd:1575:44  */
  assign n5426_o = n5423_o | n5425_o;
  /* ./T80/T80_MCode.vhd:1575:55  */
  assign n5428_o = ir == 8'b00001010;
  /* ./T80/T80_MCode.vhd:1575:55  */
  assign n5429_o = n5426_o | n5428_o;
  /* ./T80/T80_MCode.vhd:1575:66  */
  assign n5431_o = ir == 8'b00001011;
  /* ./T80/T80_MCode.vhd:1575:66  */
  assign n5432_o = n5429_o | n5431_o;
  /* ./T80/T80_MCode.vhd:1575:77  */
  assign n5434_o = ir == 8'b00001100;
  /* ./T80/T80_MCode.vhd:1575:77  */
  assign n5435_o = n5432_o | n5434_o;
  /* ./T80/T80_MCode.vhd:1575:88  */
  assign n5437_o = ir == 8'b00001101;
  /* ./T80/T80_MCode.vhd:1575:88  */
  assign n5438_o = n5435_o | n5437_o;
  /* ./T80/T80_MCode.vhd:1575:99  */
  assign n5440_o = ir == 8'b00001110;
  /* ./T80/T80_MCode.vhd:1575:99  */
  assign n5441_o = n5438_o | n5440_o;
  /* ./T80/T80_MCode.vhd:1575:110  */
  assign n5443_o = ir == 8'b00001111;
  /* ./T80/T80_MCode.vhd:1575:110  */
  assign n5444_o = n5441_o | n5443_o;
  /* ./T80/T80_MCode.vhd:1576:33  */
  assign n5446_o = ir == 8'b00010000;
  /* ./T80/T80_MCode.vhd:1576:33  */
  assign n5447_o = n5444_o | n5446_o;
  /* ./T80/T80_MCode.vhd:1576:44  */
  assign n5449_o = ir == 8'b00010001;
  /* ./T80/T80_MCode.vhd:1576:44  */
  assign n5450_o = n5447_o | n5449_o;
  /* ./T80/T80_MCode.vhd:1576:55  */
  assign n5452_o = ir == 8'b00010010;
  /* ./T80/T80_MCode.vhd:1576:55  */
  assign n5453_o = n5450_o | n5452_o;
  /* ./T80/T80_MCode.vhd:1576:66  */
  assign n5455_o = ir == 8'b00010011;
  /* ./T80/T80_MCode.vhd:1576:66  */
  assign n5456_o = n5453_o | n5455_o;
  /* ./T80/T80_MCode.vhd:1576:77  */
  assign n5458_o = ir == 8'b00010100;
  /* ./T80/T80_MCode.vhd:1576:77  */
  assign n5459_o = n5456_o | n5458_o;
  /* ./T80/T80_MCode.vhd:1576:88  */
  assign n5461_o = ir == 8'b00010101;
  /* ./T80/T80_MCode.vhd:1576:88  */
  assign n5462_o = n5459_o | n5461_o;
  /* ./T80/T80_MCode.vhd:1576:99  */
  assign n5464_o = ir == 8'b00010110;
  /* ./T80/T80_MCode.vhd:1576:99  */
  assign n5465_o = n5462_o | n5464_o;
  /* ./T80/T80_MCode.vhd:1576:110  */
  assign n5467_o = ir == 8'b00010111;
  /* ./T80/T80_MCode.vhd:1576:110  */
  assign n5468_o = n5465_o | n5467_o;
  /* ./T80/T80_MCode.vhd:1577:33  */
  assign n5470_o = ir == 8'b00011000;
  /* ./T80/T80_MCode.vhd:1577:33  */
  assign n5471_o = n5468_o | n5470_o;
  /* ./T80/T80_MCode.vhd:1577:44  */
  assign n5473_o = ir == 8'b00011001;
  /* ./T80/T80_MCode.vhd:1577:44  */
  assign n5474_o = n5471_o | n5473_o;
  /* ./T80/T80_MCode.vhd:1577:55  */
  assign n5476_o = ir == 8'b00011010;
  /* ./T80/T80_MCode.vhd:1577:55  */
  assign n5477_o = n5474_o | n5476_o;
  /* ./T80/T80_MCode.vhd:1577:66  */
  assign n5479_o = ir == 8'b00011011;
  /* ./T80/T80_MCode.vhd:1577:66  */
  assign n5480_o = n5477_o | n5479_o;
  /* ./T80/T80_MCode.vhd:1577:77  */
  assign n5482_o = ir == 8'b00011100;
  /* ./T80/T80_MCode.vhd:1577:77  */
  assign n5483_o = n5480_o | n5482_o;
  /* ./T80/T80_MCode.vhd:1577:88  */
  assign n5485_o = ir == 8'b00011101;
  /* ./T80/T80_MCode.vhd:1577:88  */
  assign n5486_o = n5483_o | n5485_o;
  /* ./T80/T80_MCode.vhd:1577:99  */
  assign n5488_o = ir == 8'b00011110;
  /* ./T80/T80_MCode.vhd:1577:99  */
  assign n5489_o = n5486_o | n5488_o;
  /* ./T80/T80_MCode.vhd:1577:110  */
  assign n5491_o = ir == 8'b00011111;
  /* ./T80/T80_MCode.vhd:1577:110  */
  assign n5492_o = n5489_o | n5491_o;
  /* ./T80/T80_MCode.vhd:1578:33  */
  assign n5494_o = ir == 8'b00100000;
  /* ./T80/T80_MCode.vhd:1578:33  */
  assign n5495_o = n5492_o | n5494_o;
  /* ./T80/T80_MCode.vhd:1578:44  */
  assign n5497_o = ir == 8'b00100001;
  /* ./T80/T80_MCode.vhd:1578:44  */
  assign n5498_o = n5495_o | n5497_o;
  /* ./T80/T80_MCode.vhd:1578:55  */
  assign n5500_o = ir == 8'b00100010;
  /* ./T80/T80_MCode.vhd:1578:55  */
  assign n5501_o = n5498_o | n5500_o;
  /* ./T80/T80_MCode.vhd:1578:66  */
  assign n5503_o = ir == 8'b00100011;
  /* ./T80/T80_MCode.vhd:1578:66  */
  assign n5504_o = n5501_o | n5503_o;
  /* ./T80/T80_MCode.vhd:1578:77  */
  assign n5506_o = ir == 8'b00100100;
  /* ./T80/T80_MCode.vhd:1578:77  */
  assign n5507_o = n5504_o | n5506_o;
  /* ./T80/T80_MCode.vhd:1578:88  */
  assign n5509_o = ir == 8'b00100101;
  /* ./T80/T80_MCode.vhd:1578:88  */
  assign n5510_o = n5507_o | n5509_o;
  /* ./T80/T80_MCode.vhd:1578:99  */
  assign n5512_o = ir == 8'b00100110;
  /* ./T80/T80_MCode.vhd:1578:99  */
  assign n5513_o = n5510_o | n5512_o;
  /* ./T80/T80_MCode.vhd:1578:110  */
  assign n5515_o = ir == 8'b00100111;
  /* ./T80/T80_MCode.vhd:1578:110  */
  assign n5516_o = n5513_o | n5515_o;
  /* ./T80/T80_MCode.vhd:1579:33  */
  assign n5518_o = ir == 8'b00101000;
  /* ./T80/T80_MCode.vhd:1579:33  */
  assign n5519_o = n5516_o | n5518_o;
  /* ./T80/T80_MCode.vhd:1579:44  */
  assign n5521_o = ir == 8'b00101001;
  /* ./T80/T80_MCode.vhd:1579:44  */
  assign n5522_o = n5519_o | n5521_o;
  /* ./T80/T80_MCode.vhd:1579:55  */
  assign n5524_o = ir == 8'b00101010;
  /* ./T80/T80_MCode.vhd:1579:55  */
  assign n5525_o = n5522_o | n5524_o;
  /* ./T80/T80_MCode.vhd:1579:66  */
  assign n5527_o = ir == 8'b00101011;
  /* ./T80/T80_MCode.vhd:1579:66  */
  assign n5528_o = n5525_o | n5527_o;
  /* ./T80/T80_MCode.vhd:1579:77  */
  assign n5530_o = ir == 8'b00101100;
  /* ./T80/T80_MCode.vhd:1579:77  */
  assign n5531_o = n5528_o | n5530_o;
  /* ./T80/T80_MCode.vhd:1579:88  */
  assign n5533_o = ir == 8'b00101101;
  /* ./T80/T80_MCode.vhd:1579:88  */
  assign n5534_o = n5531_o | n5533_o;
  /* ./T80/T80_MCode.vhd:1579:99  */
  assign n5536_o = ir == 8'b00101110;
  /* ./T80/T80_MCode.vhd:1579:99  */
  assign n5537_o = n5534_o | n5536_o;
  /* ./T80/T80_MCode.vhd:1579:110  */
  assign n5539_o = ir == 8'b00101111;
  /* ./T80/T80_MCode.vhd:1579:110  */
  assign n5540_o = n5537_o | n5539_o;
  /* ./T80/T80_MCode.vhd:1580:33  */
  assign n5542_o = ir == 8'b00110000;
  /* ./T80/T80_MCode.vhd:1580:33  */
  assign n5543_o = n5540_o | n5542_o;
  /* ./T80/T80_MCode.vhd:1580:44  */
  assign n5545_o = ir == 8'b00110001;
  /* ./T80/T80_MCode.vhd:1580:44  */
  assign n5546_o = n5543_o | n5545_o;
  /* ./T80/T80_MCode.vhd:1580:55  */
  assign n5548_o = ir == 8'b00110010;
  /* ./T80/T80_MCode.vhd:1580:55  */
  assign n5549_o = n5546_o | n5548_o;
  /* ./T80/T80_MCode.vhd:1580:66  */
  assign n5551_o = ir == 8'b00110011;
  /* ./T80/T80_MCode.vhd:1580:66  */
  assign n5552_o = n5549_o | n5551_o;
  /* ./T80/T80_MCode.vhd:1580:77  */
  assign n5554_o = ir == 8'b00110100;
  /* ./T80/T80_MCode.vhd:1580:77  */
  assign n5555_o = n5552_o | n5554_o;
  /* ./T80/T80_MCode.vhd:1580:88  */
  assign n5557_o = ir == 8'b00110101;
  /* ./T80/T80_MCode.vhd:1580:88  */
  assign n5558_o = n5555_o | n5557_o;
  /* ./T80/T80_MCode.vhd:1580:99  */
  assign n5560_o = ir == 8'b00110110;
  /* ./T80/T80_MCode.vhd:1580:99  */
  assign n5561_o = n5558_o | n5560_o;
  /* ./T80/T80_MCode.vhd:1580:110  */
  assign n5563_o = ir == 8'b00110111;
  /* ./T80/T80_MCode.vhd:1580:110  */
  assign n5564_o = n5561_o | n5563_o;
  /* ./T80/T80_MCode.vhd:1581:33  */
  assign n5566_o = ir == 8'b00111000;
  /* ./T80/T80_MCode.vhd:1581:33  */
  assign n5567_o = n5564_o | n5566_o;
  /* ./T80/T80_MCode.vhd:1581:44  */
  assign n5569_o = ir == 8'b00111001;
  /* ./T80/T80_MCode.vhd:1581:44  */
  assign n5570_o = n5567_o | n5569_o;
  /* ./T80/T80_MCode.vhd:1581:55  */
  assign n5572_o = ir == 8'b00111010;
  /* ./T80/T80_MCode.vhd:1581:55  */
  assign n5573_o = n5570_o | n5572_o;
  /* ./T80/T80_MCode.vhd:1581:66  */
  assign n5575_o = ir == 8'b00111011;
  /* ./T80/T80_MCode.vhd:1581:66  */
  assign n5576_o = n5573_o | n5575_o;
  /* ./T80/T80_MCode.vhd:1581:77  */
  assign n5578_o = ir == 8'b00111100;
  /* ./T80/T80_MCode.vhd:1581:77  */
  assign n5579_o = n5576_o | n5578_o;
  /* ./T80/T80_MCode.vhd:1581:88  */
  assign n5581_o = ir == 8'b00111101;
  /* ./T80/T80_MCode.vhd:1581:88  */
  assign n5582_o = n5579_o | n5581_o;
  /* ./T80/T80_MCode.vhd:1581:99  */
  assign n5584_o = ir == 8'b00111110;
  /* ./T80/T80_MCode.vhd:1581:99  */
  assign n5585_o = n5582_o | n5584_o;
  /* ./T80/T80_MCode.vhd:1581:110  */
  assign n5587_o = ir == 8'b00111111;
  /* ./T80/T80_MCode.vhd:1581:110  */
  assign n5588_o = n5585_o | n5587_o;
  /* ./T80/T80_MCode.vhd:1584:33  */
  assign n5590_o = ir == 8'b10000000;
  /* ./T80/T80_MCode.vhd:1584:33  */
  assign n5591_o = n5588_o | n5590_o;
  /* ./T80/T80_MCode.vhd:1584:44  */
  assign n5593_o = ir == 8'b10000001;
  /* ./T80/T80_MCode.vhd:1584:44  */
  assign n5594_o = n5591_o | n5593_o;
  /* ./T80/T80_MCode.vhd:1584:55  */
  assign n5596_o = ir == 8'b10000010;
  /* ./T80/T80_MCode.vhd:1584:55  */
  assign n5597_o = n5594_o | n5596_o;
  /* ./T80/T80_MCode.vhd:1584:66  */
  assign n5599_o = ir == 8'b10000011;
  /* ./T80/T80_MCode.vhd:1584:66  */
  assign n5600_o = n5597_o | n5599_o;
  /* ./T80/T80_MCode.vhd:1584:77  */
  assign n5602_o = ir == 8'b10000100;
  /* ./T80/T80_MCode.vhd:1584:77  */
  assign n5603_o = n5600_o | n5602_o;
  /* ./T80/T80_MCode.vhd:1584:88  */
  assign n5605_o = ir == 8'b10000101;
  /* ./T80/T80_MCode.vhd:1584:88  */
  assign n5606_o = n5603_o | n5605_o;
  /* ./T80/T80_MCode.vhd:1584:99  */
  assign n5608_o = ir == 8'b10000110;
  /* ./T80/T80_MCode.vhd:1584:99  */
  assign n5609_o = n5606_o | n5608_o;
  /* ./T80/T80_MCode.vhd:1584:110  */
  assign n5611_o = ir == 8'b10000111;
  /* ./T80/T80_MCode.vhd:1584:110  */
  assign n5612_o = n5609_o | n5611_o;
  /* ./T80/T80_MCode.vhd:1585:33  */
  assign n5614_o = ir == 8'b10001000;
  /* ./T80/T80_MCode.vhd:1585:33  */
  assign n5615_o = n5612_o | n5614_o;
  /* ./T80/T80_MCode.vhd:1585:44  */
  assign n5617_o = ir == 8'b10001001;
  /* ./T80/T80_MCode.vhd:1585:44  */
  assign n5618_o = n5615_o | n5617_o;
  /* ./T80/T80_MCode.vhd:1585:55  */
  assign n5620_o = ir == 8'b10001010;
  /* ./T80/T80_MCode.vhd:1585:55  */
  assign n5621_o = n5618_o | n5620_o;
  /* ./T80/T80_MCode.vhd:1585:66  */
  assign n5623_o = ir == 8'b10001011;
  /* ./T80/T80_MCode.vhd:1585:66  */
  assign n5624_o = n5621_o | n5623_o;
  /* ./T80/T80_MCode.vhd:1585:77  */
  assign n5626_o = ir == 8'b10001100;
  /* ./T80/T80_MCode.vhd:1585:77  */
  assign n5627_o = n5624_o | n5626_o;
  /* ./T80/T80_MCode.vhd:1585:88  */
  assign n5629_o = ir == 8'b10001101;
  /* ./T80/T80_MCode.vhd:1585:88  */
  assign n5630_o = n5627_o | n5629_o;
  /* ./T80/T80_MCode.vhd:1585:99  */
  assign n5632_o = ir == 8'b10001110;
  /* ./T80/T80_MCode.vhd:1585:99  */
  assign n5633_o = n5630_o | n5632_o;
  /* ./T80/T80_MCode.vhd:1585:110  */
  assign n5635_o = ir == 8'b10001111;
  /* ./T80/T80_MCode.vhd:1585:110  */
  assign n5636_o = n5633_o | n5635_o;
  /* ./T80/T80_MCode.vhd:1586:33  */
  assign n5638_o = ir == 8'b10010000;
  /* ./T80/T80_MCode.vhd:1586:33  */
  assign n5639_o = n5636_o | n5638_o;
  /* ./T80/T80_MCode.vhd:1586:44  */
  assign n5641_o = ir == 8'b10010001;
  /* ./T80/T80_MCode.vhd:1586:44  */
  assign n5642_o = n5639_o | n5641_o;
  /* ./T80/T80_MCode.vhd:1586:55  */
  assign n5644_o = ir == 8'b10010010;
  /* ./T80/T80_MCode.vhd:1586:55  */
  assign n5645_o = n5642_o | n5644_o;
  /* ./T80/T80_MCode.vhd:1586:66  */
  assign n5647_o = ir == 8'b10010011;
  /* ./T80/T80_MCode.vhd:1586:66  */
  assign n5648_o = n5645_o | n5647_o;
  /* ./T80/T80_MCode.vhd:1586:77  */
  assign n5650_o = ir == 8'b10010100;
  /* ./T80/T80_MCode.vhd:1586:77  */
  assign n5651_o = n5648_o | n5650_o;
  /* ./T80/T80_MCode.vhd:1586:88  */
  assign n5653_o = ir == 8'b10010101;
  /* ./T80/T80_MCode.vhd:1586:88  */
  assign n5654_o = n5651_o | n5653_o;
  /* ./T80/T80_MCode.vhd:1586:99  */
  assign n5656_o = ir == 8'b10010110;
  /* ./T80/T80_MCode.vhd:1586:99  */
  assign n5657_o = n5654_o | n5656_o;
  /* ./T80/T80_MCode.vhd:1586:110  */
  assign n5659_o = ir == 8'b10010111;
  /* ./T80/T80_MCode.vhd:1586:110  */
  assign n5660_o = n5657_o | n5659_o;
  /* ./T80/T80_MCode.vhd:1587:33  */
  assign n5662_o = ir == 8'b10011000;
  /* ./T80/T80_MCode.vhd:1587:33  */
  assign n5663_o = n5660_o | n5662_o;
  /* ./T80/T80_MCode.vhd:1587:44  */
  assign n5665_o = ir == 8'b10011001;
  /* ./T80/T80_MCode.vhd:1587:44  */
  assign n5666_o = n5663_o | n5665_o;
  /* ./T80/T80_MCode.vhd:1587:55  */
  assign n5668_o = ir == 8'b10011010;
  /* ./T80/T80_MCode.vhd:1587:55  */
  assign n5669_o = n5666_o | n5668_o;
  /* ./T80/T80_MCode.vhd:1587:66  */
  assign n5671_o = ir == 8'b10011011;
  /* ./T80/T80_MCode.vhd:1587:66  */
  assign n5672_o = n5669_o | n5671_o;
  /* ./T80/T80_MCode.vhd:1587:77  */
  assign n5674_o = ir == 8'b10011100;
  /* ./T80/T80_MCode.vhd:1587:77  */
  assign n5675_o = n5672_o | n5674_o;
  /* ./T80/T80_MCode.vhd:1587:88  */
  assign n5677_o = ir == 8'b10011101;
  /* ./T80/T80_MCode.vhd:1587:88  */
  assign n5678_o = n5675_o | n5677_o;
  /* ./T80/T80_MCode.vhd:1587:99  */
  assign n5680_o = ir == 8'b10011110;
  /* ./T80/T80_MCode.vhd:1587:99  */
  assign n5681_o = n5678_o | n5680_o;
  /* ./T80/T80_MCode.vhd:1587:110  */
  assign n5683_o = ir == 8'b10011111;
  /* ./T80/T80_MCode.vhd:1587:110  */
  assign n5684_o = n5681_o | n5683_o;
  /* ./T80/T80_MCode.vhd:1588:33  */
  assign n5686_o = ir == 8'b10100100;
  /* ./T80/T80_MCode.vhd:1588:33  */
  assign n5687_o = n5684_o | n5686_o;
  /* ./T80/T80_MCode.vhd:1588:88  */
  assign n5689_o = ir == 8'b10100101;
  /* ./T80/T80_MCode.vhd:1588:88  */
  assign n5690_o = n5687_o | n5689_o;
  /* ./T80/T80_MCode.vhd:1588:99  */
  assign n5692_o = ir == 8'b10100110;
  /* ./T80/T80_MCode.vhd:1588:99  */
  assign n5693_o = n5690_o | n5692_o;
  /* ./T80/T80_MCode.vhd:1588:110  */
  assign n5695_o = ir == 8'b10100111;
  /* ./T80/T80_MCode.vhd:1588:110  */
  assign n5696_o = n5693_o | n5695_o;
  /* ./T80/T80_MCode.vhd:1589:33  */
  assign n5698_o = ir == 8'b10101100;
  /* ./T80/T80_MCode.vhd:1589:33  */
  assign n5699_o = n5696_o | n5698_o;
  /* ./T80/T80_MCode.vhd:1589:88  */
  assign n5701_o = ir == 8'b10101101;
  /* ./T80/T80_MCode.vhd:1589:88  */
  assign n5702_o = n5699_o | n5701_o;
  /* ./T80/T80_MCode.vhd:1589:99  */
  assign n5704_o = ir == 8'b10101110;
  /* ./T80/T80_MCode.vhd:1589:99  */
  assign n5705_o = n5702_o | n5704_o;
  /* ./T80/T80_MCode.vhd:1589:110  */
  assign n5707_o = ir == 8'b10101111;
  /* ./T80/T80_MCode.vhd:1589:110  */
  assign n5708_o = n5705_o | n5707_o;
  /* ./T80/T80_MCode.vhd:1590:33  */
  assign n5710_o = ir == 8'b10110100;
  /* ./T80/T80_MCode.vhd:1590:33  */
  assign n5711_o = n5708_o | n5710_o;
  /* ./T80/T80_MCode.vhd:1590:88  */
  assign n5713_o = ir == 8'b10110101;
  /* ./T80/T80_MCode.vhd:1590:88  */
  assign n5714_o = n5711_o | n5713_o;
  /* ./T80/T80_MCode.vhd:1590:99  */
  assign n5716_o = ir == 8'b10110110;
  /* ./T80/T80_MCode.vhd:1590:99  */
  assign n5717_o = n5714_o | n5716_o;
  /* ./T80/T80_MCode.vhd:1590:110  */
  assign n5719_o = ir == 8'b10110111;
  /* ./T80/T80_MCode.vhd:1590:110  */
  assign n5720_o = n5717_o | n5719_o;
  /* ./T80/T80_MCode.vhd:1591:33  */
  assign n5722_o = ir == 8'b10111100;
  /* ./T80/T80_MCode.vhd:1591:33  */
  assign n5723_o = n5720_o | n5722_o;
  /* ./T80/T80_MCode.vhd:1591:88  */
  assign n5725_o = ir == 8'b10111101;
  /* ./T80/T80_MCode.vhd:1591:88  */
  assign n5726_o = n5723_o | n5725_o;
  /* ./T80/T80_MCode.vhd:1591:99  */
  assign n5728_o = ir == 8'b10111110;
  /* ./T80/T80_MCode.vhd:1591:99  */
  assign n5729_o = n5726_o | n5728_o;
  /* ./T80/T80_MCode.vhd:1591:110  */
  assign n5731_o = ir == 8'b10111111;
  /* ./T80/T80_MCode.vhd:1591:110  */
  assign n5732_o = n5729_o | n5731_o;
  /* ./T80/T80_MCode.vhd:1592:33  */
  assign n5734_o = ir == 8'b11000000;
  /* ./T80/T80_MCode.vhd:1592:33  */
  assign n5735_o = n5732_o | n5734_o;
  /* ./T80/T80_MCode.vhd:1592:44  */
  assign n5737_o = ir == 8'b11000001;
  /* ./T80/T80_MCode.vhd:1592:44  */
  assign n5738_o = n5735_o | n5737_o;
  /* ./T80/T80_MCode.vhd:1592:55  */
  assign n5740_o = ir == 8'b11000010;
  /* ./T80/T80_MCode.vhd:1592:55  */
  assign n5741_o = n5738_o | n5740_o;
  /* ./T80/T80_MCode.vhd:1592:66  */
  assign n5743_o = ir == 8'b11000011;
  /* ./T80/T80_MCode.vhd:1592:66  */
  assign n5744_o = n5741_o | n5743_o;
  /* ./T80/T80_MCode.vhd:1592:77  */
  assign n5746_o = ir == 8'b11000100;
  /* ./T80/T80_MCode.vhd:1592:77  */
  assign n5747_o = n5744_o | n5746_o;
  /* ./T80/T80_MCode.vhd:1592:88  */
  assign n5749_o = ir == 8'b11000101;
  /* ./T80/T80_MCode.vhd:1592:88  */
  assign n5750_o = n5747_o | n5749_o;
  /* ./T80/T80_MCode.vhd:1592:99  */
  assign n5752_o = ir == 8'b11000110;
  /* ./T80/T80_MCode.vhd:1592:99  */
  assign n5753_o = n5750_o | n5752_o;
  /* ./T80/T80_MCode.vhd:1592:110  */
  assign n5755_o = ir == 8'b11000111;
  /* ./T80/T80_MCode.vhd:1592:110  */
  assign n5756_o = n5753_o | n5755_o;
  /* ./T80/T80_MCode.vhd:1593:33  */
  assign n5758_o = ir == 8'b11001000;
  /* ./T80/T80_MCode.vhd:1593:33  */
  assign n5759_o = n5756_o | n5758_o;
  /* ./T80/T80_MCode.vhd:1593:44  */
  assign n5761_o = ir == 8'b11001001;
  /* ./T80/T80_MCode.vhd:1593:44  */
  assign n5762_o = n5759_o | n5761_o;
  /* ./T80/T80_MCode.vhd:1593:55  */
  assign n5764_o = ir == 8'b11001010;
  /* ./T80/T80_MCode.vhd:1593:55  */
  assign n5765_o = n5762_o | n5764_o;
  /* ./T80/T80_MCode.vhd:1593:66  */
  assign n5767_o = ir == 8'b11001011;
  /* ./T80/T80_MCode.vhd:1593:66  */
  assign n5768_o = n5765_o | n5767_o;
  /* ./T80/T80_MCode.vhd:1593:77  */
  assign n5770_o = ir == 8'b11001100;
  /* ./T80/T80_MCode.vhd:1593:77  */
  assign n5771_o = n5768_o | n5770_o;
  /* ./T80/T80_MCode.vhd:1593:88  */
  assign n5773_o = ir == 8'b11001101;
  /* ./T80/T80_MCode.vhd:1593:88  */
  assign n5774_o = n5771_o | n5773_o;
  /* ./T80/T80_MCode.vhd:1593:99  */
  assign n5776_o = ir == 8'b11001110;
  /* ./T80/T80_MCode.vhd:1593:99  */
  assign n5777_o = n5774_o | n5776_o;
  /* ./T80/T80_MCode.vhd:1593:110  */
  assign n5779_o = ir == 8'b11001111;
  /* ./T80/T80_MCode.vhd:1593:110  */
  assign n5780_o = n5777_o | n5779_o;
  /* ./T80/T80_MCode.vhd:1594:33  */
  assign n5782_o = ir == 8'b11010000;
  /* ./T80/T80_MCode.vhd:1594:33  */
  assign n5783_o = n5780_o | n5782_o;
  /* ./T80/T80_MCode.vhd:1594:44  */
  assign n5785_o = ir == 8'b11010001;
  /* ./T80/T80_MCode.vhd:1594:44  */
  assign n5786_o = n5783_o | n5785_o;
  /* ./T80/T80_MCode.vhd:1594:55  */
  assign n5788_o = ir == 8'b11010010;
  /* ./T80/T80_MCode.vhd:1594:55  */
  assign n5789_o = n5786_o | n5788_o;
  /* ./T80/T80_MCode.vhd:1594:66  */
  assign n5791_o = ir == 8'b11010011;
  /* ./T80/T80_MCode.vhd:1594:66  */
  assign n5792_o = n5789_o | n5791_o;
  /* ./T80/T80_MCode.vhd:1594:77  */
  assign n5794_o = ir == 8'b11010100;
  /* ./T80/T80_MCode.vhd:1594:77  */
  assign n5795_o = n5792_o | n5794_o;
  /* ./T80/T80_MCode.vhd:1594:88  */
  assign n5797_o = ir == 8'b11010101;
  /* ./T80/T80_MCode.vhd:1594:88  */
  assign n5798_o = n5795_o | n5797_o;
  /* ./T80/T80_MCode.vhd:1594:99  */
  assign n5800_o = ir == 8'b11010110;
  /* ./T80/T80_MCode.vhd:1594:99  */
  assign n5801_o = n5798_o | n5800_o;
  /* ./T80/T80_MCode.vhd:1594:110  */
  assign n5803_o = ir == 8'b11010111;
  /* ./T80/T80_MCode.vhd:1594:110  */
  assign n5804_o = n5801_o | n5803_o;
  /* ./T80/T80_MCode.vhd:1595:33  */
  assign n5806_o = ir == 8'b11011000;
  /* ./T80/T80_MCode.vhd:1595:33  */
  assign n5807_o = n5804_o | n5806_o;
  /* ./T80/T80_MCode.vhd:1595:44  */
  assign n5809_o = ir == 8'b11011001;
  /* ./T80/T80_MCode.vhd:1595:44  */
  assign n5810_o = n5807_o | n5809_o;
  /* ./T80/T80_MCode.vhd:1595:55  */
  assign n5812_o = ir == 8'b11011010;
  /* ./T80/T80_MCode.vhd:1595:55  */
  assign n5813_o = n5810_o | n5812_o;
  /* ./T80/T80_MCode.vhd:1595:66  */
  assign n5815_o = ir == 8'b11011011;
  /* ./T80/T80_MCode.vhd:1595:66  */
  assign n5816_o = n5813_o | n5815_o;
  /* ./T80/T80_MCode.vhd:1595:77  */
  assign n5818_o = ir == 8'b11011100;
  /* ./T80/T80_MCode.vhd:1595:77  */
  assign n5819_o = n5816_o | n5818_o;
  /* ./T80/T80_MCode.vhd:1595:88  */
  assign n5821_o = ir == 8'b11011101;
  /* ./T80/T80_MCode.vhd:1595:88  */
  assign n5822_o = n5819_o | n5821_o;
  /* ./T80/T80_MCode.vhd:1595:99  */
  assign n5824_o = ir == 8'b11011110;
  /* ./T80/T80_MCode.vhd:1595:99  */
  assign n5825_o = n5822_o | n5824_o;
  /* ./T80/T80_MCode.vhd:1595:110  */
  assign n5827_o = ir == 8'b11011111;
  /* ./T80/T80_MCode.vhd:1595:110  */
  assign n5828_o = n5825_o | n5827_o;
  /* ./T80/T80_MCode.vhd:1596:33  */
  assign n5830_o = ir == 8'b11100000;
  /* ./T80/T80_MCode.vhd:1596:33  */
  assign n5831_o = n5828_o | n5830_o;
  /* ./T80/T80_MCode.vhd:1596:44  */
  assign n5833_o = ir == 8'b11100001;
  /* ./T80/T80_MCode.vhd:1596:44  */
  assign n5834_o = n5831_o | n5833_o;
  /* ./T80/T80_MCode.vhd:1596:55  */
  assign n5836_o = ir == 8'b11100010;
  /* ./T80/T80_MCode.vhd:1596:55  */
  assign n5837_o = n5834_o | n5836_o;
  /* ./T80/T80_MCode.vhd:1596:66  */
  assign n5839_o = ir == 8'b11100011;
  /* ./T80/T80_MCode.vhd:1596:66  */
  assign n5840_o = n5837_o | n5839_o;
  /* ./T80/T80_MCode.vhd:1596:77  */
  assign n5842_o = ir == 8'b11100100;
  /* ./T80/T80_MCode.vhd:1596:77  */
  assign n5843_o = n5840_o | n5842_o;
  /* ./T80/T80_MCode.vhd:1596:88  */
  assign n5845_o = ir == 8'b11100101;
  /* ./T80/T80_MCode.vhd:1596:88  */
  assign n5846_o = n5843_o | n5845_o;
  /* ./T80/T80_MCode.vhd:1596:99  */
  assign n5848_o = ir == 8'b11100110;
  /* ./T80/T80_MCode.vhd:1596:99  */
  assign n5849_o = n5846_o | n5848_o;
  /* ./T80/T80_MCode.vhd:1596:110  */
  assign n5851_o = ir == 8'b11100111;
  /* ./T80/T80_MCode.vhd:1596:110  */
  assign n5852_o = n5849_o | n5851_o;
  /* ./T80/T80_MCode.vhd:1597:33  */
  assign n5854_o = ir == 8'b11101000;
  /* ./T80/T80_MCode.vhd:1597:33  */
  assign n5855_o = n5852_o | n5854_o;
  /* ./T80/T80_MCode.vhd:1597:44  */
  assign n5857_o = ir == 8'b11101001;
  /* ./T80/T80_MCode.vhd:1597:44  */
  assign n5858_o = n5855_o | n5857_o;
  /* ./T80/T80_MCode.vhd:1597:55  */
  assign n5860_o = ir == 8'b11101010;
  /* ./T80/T80_MCode.vhd:1597:55  */
  assign n5861_o = n5858_o | n5860_o;
  /* ./T80/T80_MCode.vhd:1597:66  */
  assign n5863_o = ir == 8'b11101011;
  /* ./T80/T80_MCode.vhd:1597:66  */
  assign n5864_o = n5861_o | n5863_o;
  /* ./T80/T80_MCode.vhd:1597:77  */
  assign n5866_o = ir == 8'b11101100;
  /* ./T80/T80_MCode.vhd:1597:77  */
  assign n5867_o = n5864_o | n5866_o;
  /* ./T80/T80_MCode.vhd:1597:88  */
  assign n5869_o = ir == 8'b11101101;
  /* ./T80/T80_MCode.vhd:1597:88  */
  assign n5870_o = n5867_o | n5869_o;
  /* ./T80/T80_MCode.vhd:1597:99  */
  assign n5872_o = ir == 8'b11101110;
  /* ./T80/T80_MCode.vhd:1597:99  */
  assign n5873_o = n5870_o | n5872_o;
  /* ./T80/T80_MCode.vhd:1597:110  */
  assign n5875_o = ir == 8'b11101111;
  /* ./T80/T80_MCode.vhd:1597:110  */
  assign n5876_o = n5873_o | n5875_o;
  /* ./T80/T80_MCode.vhd:1598:33  */
  assign n5878_o = ir == 8'b11110000;
  /* ./T80/T80_MCode.vhd:1598:33  */
  assign n5879_o = n5876_o | n5878_o;
  /* ./T80/T80_MCode.vhd:1598:44  */
  assign n5881_o = ir == 8'b11110001;
  /* ./T80/T80_MCode.vhd:1598:44  */
  assign n5882_o = n5879_o | n5881_o;
  /* ./T80/T80_MCode.vhd:1598:55  */
  assign n5884_o = ir == 8'b11110010;
  /* ./T80/T80_MCode.vhd:1598:55  */
  assign n5885_o = n5882_o | n5884_o;
  /* ./T80/T80_MCode.vhd:1598:66  */
  assign n5887_o = ir == 8'b11110011;
  /* ./T80/T80_MCode.vhd:1598:66  */
  assign n5888_o = n5885_o | n5887_o;
  /* ./T80/T80_MCode.vhd:1598:77  */
  assign n5890_o = ir == 8'b11110100;
  /* ./T80/T80_MCode.vhd:1598:77  */
  assign n5891_o = n5888_o | n5890_o;
  /* ./T80/T80_MCode.vhd:1598:88  */
  assign n5893_o = ir == 8'b11110101;
  /* ./T80/T80_MCode.vhd:1598:88  */
  assign n5894_o = n5891_o | n5893_o;
  /* ./T80/T80_MCode.vhd:1598:99  */
  assign n5896_o = ir == 8'b11110110;
  /* ./T80/T80_MCode.vhd:1598:99  */
  assign n5897_o = n5894_o | n5896_o;
  /* ./T80/T80_MCode.vhd:1598:110  */
  assign n5899_o = ir == 8'b11110111;
  /* ./T80/T80_MCode.vhd:1598:110  */
  assign n5900_o = n5897_o | n5899_o;
  /* ./T80/T80_MCode.vhd:1599:33  */
  assign n5902_o = ir == 8'b11111000;
  /* ./T80/T80_MCode.vhd:1599:33  */
  assign n5903_o = n5900_o | n5902_o;
  /* ./T80/T80_MCode.vhd:1599:44  */
  assign n5905_o = ir == 8'b11111001;
  /* ./T80/T80_MCode.vhd:1599:44  */
  assign n5906_o = n5903_o | n5905_o;
  /* ./T80/T80_MCode.vhd:1599:55  */
  assign n5908_o = ir == 8'b11111010;
  /* ./T80/T80_MCode.vhd:1599:55  */
  assign n5909_o = n5906_o | n5908_o;
  /* ./T80/T80_MCode.vhd:1599:66  */
  assign n5911_o = ir == 8'b11111011;
  /* ./T80/T80_MCode.vhd:1599:66  */
  assign n5912_o = n5909_o | n5911_o;
  /* ./T80/T80_MCode.vhd:1599:77  */
  assign n5914_o = ir == 8'b11111100;
  /* ./T80/T80_MCode.vhd:1599:77  */
  assign n5915_o = n5912_o | n5914_o;
  /* ./T80/T80_MCode.vhd:1599:88  */
  assign n5917_o = ir == 8'b11111101;
  /* ./T80/T80_MCode.vhd:1599:88  */
  assign n5918_o = n5915_o | n5917_o;
  /* ./T80/T80_MCode.vhd:1599:99  */
  assign n5920_o = ir == 8'b11111110;
  /* ./T80/T80_MCode.vhd:1599:99  */
  assign n5921_o = n5918_o | n5920_o;
  /* ./T80/T80_MCode.vhd:1599:110  */
  assign n5923_o = ir == 8'b11111111;
  /* ./T80/T80_MCode.vhd:1599:110  */
  assign n5924_o = n5921_o | n5923_o;
  /* ./T80/T80_MCode.vhd:1601:25  */
  assign n5926_o = ir == 8'b01111110;
  /* ./T80/T80_MCode.vhd:1601:40  */
  assign n5928_o = ir == 8'b01111111;
  /* ./T80/T80_MCode.vhd:1601:40  */
  assign n5929_o = n5926_o | n5928_o;
  /* ./T80/T80_MCode.vhd:1605:25  */
  assign n5931_o = ir == 8'b01010111;
  /* ./T80/T80_MCode.vhd:1609:25  */
  assign n5933_o = ir == 8'b01011111;
  /* ./T80/T80_MCode.vhd:1613:25  */
  assign n5935_o = ir == 8'b01000111;
  /* ./T80/T80_MCode.vhd:1617:25  */
  assign n5937_o = ir == 8'b01001111;
  /* ./T80/T80_MCode.vhd:1625:38  */
  assign n5938_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1626:33  */
  assign n5940_o = n5938_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1629:33  */
  assign n5942_o = n5938_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1635:46  */
  assign n5943_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1635:59  */
  assign n5945_o = n5943_o == 2'b11;
  /* ./T80/T80_MCode.vhd:1638:78  */
  assign n5946_o = ir[5:4];
  assign n5948_o = {n5946_o, 1'b1};
  /* ./T80/T80_MCode.vhd:1635:41  */
  assign n5950_o = n5945_o ? 3'b000 : n5948_o;
  /* ./T80/T80_MCode.vhd:1635:41  */
  assign n5953_o = n5945_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1633:33  */
  assign n5955_o = n5938_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:1645:46  */
  assign n5956_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1645:59  */
  assign n5958_o = n5956_o == 2'b11;
  /* ./T80/T80_MCode.vhd:1648:78  */
  assign n5959_o = ir[5:4];
  assign n5961_o = {n5959_o, 1'b0};
  /* ./T80/T80_MCode.vhd:1645:41  */
  assign n5963_o = n5958_o ? 3'b001 : n5961_o;
  /* ./T80/T80_MCode.vhd:1645:41  */
  assign n5966_o = n5958_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1643:33  */
  assign n5968_o = n5938_o == 31'b0000000000000000000000000000101;
  assign n5969_o = {n5968_o, n5955_o, n5942_o, n5940_o};
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5973_o = 1'b0;
      4'b0100: n5973_o = 1'b0;
      4'b0010: n5973_o = 1'b1;
      4'b0001: n5973_o = 1'b1;
      default: n5973_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5976_o = 1'b0;
      4'b0100: n5976_o = 1'b1;
      4'b0010: n5976_o = 1'b0;
      4'b0001: n5976_o = 1'b0;
      default: n5976_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5980_o = 1'b1;
      4'b0100: n5980_o = 1'b1;
      4'b0010: n5980_o = 1'b0;
      4'b0001: n5980_o = 1'b0;
      default: n5980_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5982_o = n5963_o;
      4'b0100: n5982_o = n5950_o;
      4'b0010: n5982_o = 3'b000;
      4'b0001: n5982_o = 3'b000;
      default: n5982_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5984_o = n5966_o;
      4'b0100: n5984_o = n5953_o;
      4'b0010: n5984_o = 1'b0;
      4'b0001: n5984_o = 1'b0;
      default: n5984_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5988_o = 3'b111;
      4'b0100: n5988_o = 3'b110;
      4'b0010: n5988_o = 3'b110;
      4'b0001: n5988_o = 3'b111;
      default: n5988_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5991_o = 1'b0;
      4'b0100: n5991_o = 1'b0;
      4'b0010: n5991_o = 1'b0;
      4'b0001: n5991_o = 1'b1;
      default: n5991_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1625:33  */
  always @*
    case (n5969_o)
      4'b1000: n5994_o = 1'b0;
      4'b0100: n5994_o = 1'b0;
      4'b0010: n5994_o = 1'b1;
      4'b0001: n5994_o = 1'b0;
      default: n5994_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1622:25  */
  assign n5996_o = ir == 8'b01001011;
  /* ./T80/T80_MCode.vhd:1622:40  */
  assign n5998_o = ir == 8'b01011011;
  /* ./T80/T80_MCode.vhd:1622:40  */
  assign n5999_o = n5996_o | n5998_o;
  /* ./T80/T80_MCode.vhd:1622:51  */
  assign n6001_o = ir == 8'b01101011;
  /* ./T80/T80_MCode.vhd:1622:51  */
  assign n6002_o = n5999_o | n6001_o;
  /* ./T80/T80_MCode.vhd:1622:62  */
  assign n6004_o = ir == 8'b01111011;
  /* ./T80/T80_MCode.vhd:1622:62  */
  assign n6005_o = n6002_o | n6004_o;
  /* ./T80/T80_MCode.vhd:1656:38  */
  assign n6006_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1657:33  */
  assign n6008_o = n6006_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1664:46  */
  assign n6009_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1664:59  */
  assign n6011_o = n6009_o == 2'b11;
  /* ./T80/T80_MCode.vhd:1667:78  */
  assign n6012_o = ir[5:4];
  assign n6015_o = {1'b0, n6012_o, 1'b1};
  /* ./T80/T80_MCode.vhd:1664:41  */
  assign n6017_o = n6011_o ? 4'b1000 : n6015_o;
  /* ./T80/T80_MCode.vhd:1660:33  */
  assign n6019_o = n6006_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1675:46  */
  assign n6020_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1675:59  */
  assign n6022_o = n6020_o == 2'b11;
  /* ./T80/T80_MCode.vhd:1678:78  */
  assign n6023_o = ir[5:4];
  assign n6026_o = {1'b0, n6023_o, 1'b0};
  /* ./T80/T80_MCode.vhd:1675:41  */
  assign n6028_o = n6022_o ? 4'b1001 : n6026_o;
  /* ./T80/T80_MCode.vhd:1671:33  */
  assign n6030_o = n6006_o == 31'b0000000000000000000000000000100;
  /* ./T80/T80_MCode.vhd:1682:33  */
  assign n6032_o = n6006_o == 31'b0000000000000000000000000000101;
  assign n6033_o = {n6032_o, n6030_o, n6019_o, n6008_o};
  /* ./T80/T80_MCode.vhd:1656:33  */
  always @*
    case (n6033_o)
      4'b1000: n6037_o = 1'b0;
      4'b0100: n6037_o = 1'b0;
      4'b0010: n6037_o = 1'b1;
      4'b0001: n6037_o = 1'b1;
      default: n6037_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1656:33  */
  always @*
    case (n6033_o)
      4'b1000: n6040_o = 1'b0;
      4'b0100: n6040_o = 1'b1;
      4'b0010: n6040_o = 1'b0;
      4'b0001: n6040_o = 1'b0;
      default: n6040_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1656:33  */
  always @*
    case (n6033_o)
      4'b1000: n6042_o = 4'b0000;
      4'b0100: n6042_o = n6028_o;
      4'b0010: n6042_o = n6017_o;
      4'b0001: n6042_o = 4'b0000;
      default: n6042_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1656:33  */
  always @*
    case (n6033_o)
      4'b1000: n6046_o = 3'b111;
      4'b0100: n6046_o = 3'b110;
      4'b0010: n6046_o = 3'b110;
      4'b0001: n6046_o = 3'b111;
      default: n6046_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1656:33  */
  always @*
    case (n6033_o)
      4'b1000: n6049_o = 1'b0;
      4'b0100: n6049_o = 1'b0;
      4'b0010: n6049_o = 1'b0;
      4'b0001: n6049_o = 1'b1;
      default: n6049_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1656:33  */
  always @*
    case (n6033_o)
      4'b1000: n6052_o = 1'b0;
      4'b0100: n6052_o = 1'b0;
      4'b0010: n6052_o = 1'b1;
      4'b0001: n6052_o = 1'b0;
      default: n6052_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1656:33  */
  always @*
    case (n6033_o)
      4'b1000: n6056_o = 1'b1;
      4'b0100: n6056_o = 1'b1;
      4'b0010: n6056_o = 1'b0;
      4'b0001: n6056_o = 1'b0;
      default: n6056_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1653:25  */
  assign n6058_o = ir == 8'b01000011;
  /* ./T80/T80_MCode.vhd:1653:40  */
  assign n6060_o = ir == 8'b01010011;
  /* ./T80/T80_MCode.vhd:1653:40  */
  assign n6061_o = n6058_o | n6060_o;
  /* ./T80/T80_MCode.vhd:1653:51  */
  assign n6063_o = ir == 8'b01100011;
  /* ./T80/T80_MCode.vhd:1653:51  */
  assign n6064_o = n6061_o | n6063_o;
  /* ./T80/T80_MCode.vhd:1653:62  */
  assign n6066_o = ir == 8'b01110011;
  /* ./T80/T80_MCode.vhd:1653:62  */
  assign n6067_o = n6064_o | n6066_o;
  /* ./T80/T80_MCode.vhd:1689:38  */
  assign n6068_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1690:33  */
  assign n6070_o = n6068_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1698:46  */
  assign n6072_o = ir[3];
  /* ./T80/T80_MCode.vhd:1698:50  */
  assign n6073_o = ~n6072_o;
  /* ./T80/T80_MCode.vhd:1698:41  */
  assign n6076_o = n6073_o ? 4'b0110 : 4'b1110;
  /* ./T80/T80_MCode.vhd:1693:33  */
  assign n6078_o = n6068_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1707:46  */
  assign n6079_o = ir[3];
  /* ./T80/T80_MCode.vhd:1707:50  */
  assign n6080_o = ~n6079_o;
  /* ./T80/T80_MCode.vhd:1707:41  */
  assign n6083_o = n6080_o ? 4'b0101 : 4'b1101;
  /* ./T80/T80_MCode.vhd:1703:33  */
  assign n6085_o = n6068_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1712:33  */
  assign n6087_o = n6068_o == 31'b0000000000000000000000000000100;
  assign n6088_o = {n6087_o, n6085_o, n6078_o, n6070_o};
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6091_o = 3'b101;
      4'b0100: n6091_o = 3'b101;
      4'b0010: n6091_o = n2115_o;
      4'b0001: n6091_o = n2115_o;
      default: n6091_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6094_o = 4'b0000;
      4'b0100: n6094_o = n6083_o;
      4'b0010: n6094_o = n6076_o;
      4'b0001: n6094_o = 4'b1100;
      default: n6094_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6096_o = 3'b000;
      4'b0100: n6096_o = 3'b000;
      4'b0010: n6096_o = 3'b111;
      4'b0001: n6096_o = 3'b000;
      default: n6096_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6099_o = 4'b0000;
      4'b0100: n6099_o = 4'b0000;
      4'b0010: n6099_o = 4'b0110;
      4'b0001: n6099_o = 4'b0000;
      default: n6099_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6101_o = n2118_o;
      4'b0100: n6101_o = n2118_o;
      4'b0010: n6101_o = 4'b0000;
      4'b0001: n6101_o = n2118_o;
      default: n6101_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6105_o = 3'b111;
      4'b0100: n6105_o = 3'b111;
      4'b0010: n6105_o = 3'b001;
      4'b0001: n6105_o = 3'b010;
      default: n6105_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6108_o = 1'b0;
      4'b0100: n6108_o = 1'b1;
      4'b0010: n6108_o = 1'b0;
      4'b0001: n6108_o = 1'b0;
      default: n6108_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6111_o = 1'b1;
      4'b0100: n6111_o = 1'b0;
      4'b0010: n6111_o = 1'b0;
      4'b0001: n6111_o = 1'b0;
      default: n6111_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1689:33  */
  always @*
    case (n6088_o)
      4'b1000: n6114_o = 1'b0;
      4'b0100: n6114_o = 1'b1;
      4'b0010: n6114_o = 1'b0;
      4'b0001: n6114_o = 1'b0;
      default: n6114_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1686:25  */
  assign n6116_o = ir == 8'b10100000;
  /* ./T80/T80_MCode.vhd:1686:41  */
  assign n6118_o = ir == 8'b10101000;
  /* ./T80/T80_MCode.vhd:1686:41  */
  assign n6119_o = n6116_o | n6118_o;
  /* ./T80/T80_MCode.vhd:1686:54  */
  assign n6121_o = ir == 8'b10110000;
  /* ./T80/T80_MCode.vhd:1686:54  */
  assign n6122_o = n6119_o | n6121_o;
  /* ./T80/T80_MCode.vhd:1686:67  */
  assign n6124_o = ir == 8'b10111000;
  /* ./T80/T80_MCode.vhd:1686:67  */
  assign n6125_o = n6122_o | n6124_o;
  /* ./T80/T80_MCode.vhd:1720:38  */
  assign n6126_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1721:33  */
  assign n6128_o = n6126_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1730:46  */
  assign n6130_o = ir[3];
  /* ./T80/T80_MCode.vhd:1730:50  */
  assign n6131_o = ~n6130_o;
  /* ./T80/T80_MCode.vhd:1730:41  */
  assign n6134_o = n6131_o ? 4'b0110 : 4'b1110;
  /* ./T80/T80_MCode.vhd:1724:33  */
  assign n6136_o = n6126_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1735:33  */
  assign n6138_o = n6126_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1739:33  */
  assign n6140_o = n6126_o == 31'b0000000000000000000000000000100;
  assign n6141_o = {n6140_o, n6138_o, n6136_o, n6128_o};
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6144_o = 3'b101;
      4'b0100: n6144_o = 3'b101;
      4'b0010: n6144_o = n2115_o;
      4'b0001: n6144_o = n2115_o;
      default: n6144_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6147_o = 4'b0000;
      4'b0100: n6147_o = 4'b0000;
      4'b0010: n6147_o = n6134_o;
      4'b0001: n6147_o = 4'b1100;
      default: n6147_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6149_o = 3'b000;
      4'b0100: n6149_o = 3'b000;
      4'b0010: n6149_o = 3'b111;
      4'b0001: n6149_o = 3'b000;
      default: n6149_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6152_o = 4'b0000;
      4'b0100: n6152_o = 4'b0000;
      4'b0010: n6152_o = 4'b0110;
      4'b0001: n6152_o = 4'b0000;
      default: n6152_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6154_o = n2118_o;
      4'b0100: n6154_o = n2118_o;
      4'b0010: n6154_o = 4'b0111;
      4'b0001: n6154_o = n2118_o;
      default: n6154_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6157_o = 1'b0;
      4'b0100: n6157_o = 1'b0;
      4'b0010: n6157_o = 1'b1;
      4'b0001: n6157_o = 1'b0;
      default: n6157_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6160_o = 1'b0;
      4'b0100: n6160_o = 1'b0;
      4'b0010: n6160_o = 1'b1;
      4'b0001: n6160_o = 1'b0;
      default: n6160_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6163_o = 3'b111;
      4'b0100: n6163_o = 3'b111;
      4'b0010: n6163_o = 3'b111;
      4'b0001: n6163_o = 3'b010;
      default: n6163_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6166_o = 1'b0;
      4'b0100: n6166_o = 1'b1;
      4'b0010: n6166_o = 1'b0;
      4'b0001: n6166_o = 1'b0;
      default: n6166_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1720:33  */
  always @*
    case (n6141_o)
      4'b1000: n6170_o = 1'b1;
      4'b0100: n6170_o = 1'b1;
      4'b0010: n6170_o = 1'b0;
      4'b0001: n6170_o = 1'b0;
      default: n6170_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1717:25  */
  assign n6172_o = ir == 8'b10100001;
  /* ./T80/T80_MCode.vhd:1717:41  */
  assign n6174_o = ir == 8'b10101001;
  /* ./T80/T80_MCode.vhd:1717:41  */
  assign n6175_o = n6172_o | n6174_o;
  /* ./T80/T80_MCode.vhd:1717:54  */
  assign n6177_o = ir == 8'b10110001;
  /* ./T80/T80_MCode.vhd:1717:54  */
  assign n6178_o = n6175_o | n6177_o;
  /* ./T80/T80_MCode.vhd:1717:67  */
  assign n6180_o = ir == 8'b10111001;
  /* ./T80/T80_MCode.vhd:1717:67  */
  assign n6181_o = n6178_o | n6180_o;
  /* ./T80/T80_MCode.vhd:1744:25  */
  assign n6183_o = ir == 8'b01000100;
  /* ./T80/T80_MCode.vhd:1744:40  */
  assign n6185_o = ir == 8'b01001100;
  /* ./T80/T80_MCode.vhd:1744:40  */
  assign n6186_o = n6183_o | n6185_o;
  /* ./T80/T80_MCode.vhd:1744:51  */
  assign n6188_o = ir == 8'b01010100;
  /* ./T80/T80_MCode.vhd:1744:51  */
  assign n6189_o = n6186_o | n6188_o;
  /* ./T80/T80_MCode.vhd:1744:62  */
  assign n6191_o = ir == 8'b01011100;
  /* ./T80/T80_MCode.vhd:1744:62  */
  assign n6192_o = n6189_o | n6191_o;
  /* ./T80/T80_MCode.vhd:1744:73  */
  assign n6194_o = ir == 8'b01100100;
  /* ./T80/T80_MCode.vhd:1744:73  */
  assign n6195_o = n6192_o | n6194_o;
  /* ./T80/T80_MCode.vhd:1744:84  */
  assign n6197_o = ir == 8'b01101100;
  /* ./T80/T80_MCode.vhd:1744:84  */
  assign n6198_o = n6195_o | n6197_o;
  /* ./T80/T80_MCode.vhd:1744:95  */
  assign n6200_o = ir == 8'b01110100;
  /* ./T80/T80_MCode.vhd:1744:95  */
  assign n6201_o = n6198_o | n6200_o;
  /* ./T80/T80_MCode.vhd:1744:106  */
  assign n6203_o = ir == 8'b01111100;
  /* ./T80/T80_MCode.vhd:1744:106  */
  assign n6204_o = n6201_o | n6203_o;
  /* ./T80/T80_MCode.vhd:1751:25  */
  assign n6206_o = ir == 8'b01000110;
  /* ./T80/T80_MCode.vhd:1751:40  */
  assign n6208_o = ir == 8'b01001110;
  /* ./T80/T80_MCode.vhd:1751:40  */
  assign n6209_o = n6206_o | n6208_o;
  /* ./T80/T80_MCode.vhd:1751:51  */
  assign n6211_o = ir == 8'b01100110;
  /* ./T80/T80_MCode.vhd:1751:51  */
  assign n6212_o = n6209_o | n6211_o;
  /* ./T80/T80_MCode.vhd:1751:62  */
  assign n6214_o = ir == 8'b01101110;
  /* ./T80/T80_MCode.vhd:1751:62  */
  assign n6215_o = n6212_o | n6214_o;
  /* ./T80/T80_MCode.vhd:1754:25  */
  assign n6217_o = ir == 8'b01010110;
  /* ./T80/T80_MCode.vhd:1754:40  */
  assign n6219_o = ir == 8'b01110110;
  /* ./T80/T80_MCode.vhd:1754:40  */
  assign n6220_o = n6217_o | n6219_o;
  /* ./T80/T80_MCode.vhd:1757:25  */
  assign n6222_o = ir == 8'b01011110;
  /* ./T80/T80_MCode.vhd:1757:40  */
  assign n6224_o = ir == 8'b01110111;
  /* ./T80/T80_MCode.vhd:1757:40  */
  assign n6225_o = n6222_o | n6224_o;
  /* ./T80/T80_MCode.vhd:1764:38  */
  assign n6226_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1771:68  */
  assign n6228_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1771:46  */
  assign n6229_o = {29'b0, n6228_o};  //  uext
  /* ./T80/T80_MCode.vhd:1773:78  */
  assign n6230_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1772:41  */
  assign n6233_o = n6229_o == 31'b0000000000000000000000000000000;
  /* ./T80/T80_MCode.vhd:1772:47  */
  assign n6235_o = n6229_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1772:47  */
  assign n6236_o = n6233_o | n6235_o;
  /* ./T80/T80_MCode.vhd:1772:49  */
  assign n6238_o = n6229_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1772:49  */
  assign n6239_o = n6236_o | n6238_o;
  /* ./T80/T80_MCode.vhd:1771:41  */
  always @*
    case (n6239_o)
      1'b1: n6241_o = 1'b1;
      default: n6241_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1771:41  */
  always @*
    case (n6239_o)
      1'b1: n6243_o = n6230_o;
      default: n6243_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1771:41  */
  always @*
    case (n6239_o)
      1'b1: n6246_o = 1'b0;
      default: n6246_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:1765:33  */
  assign n6248_o = n6226_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1786:68  */
  assign n6250_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1786:46  */
  assign n6251_o = {29'b0, n6250_o};  //  uext
  /* ./T80/T80_MCode.vhd:1788:78  */
  assign n6252_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1787:41  */
  assign n6255_o = n6251_o == 31'b0000000000000000000000000000000;
  /* ./T80/T80_MCode.vhd:1787:47  */
  assign n6257_o = n6251_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1787:47  */
  assign n6258_o = n6255_o | n6257_o;
  /* ./T80/T80_MCode.vhd:1787:49  */
  assign n6260_o = n6251_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1787:49  */
  assign n6261_o = n6258_o | n6260_o;
  /* ./T80/T80_MCode.vhd:1786:41  */
  always @*
    case (n6261_o)
      1'b1: n6263_o = 1'b0;
      default: n6263_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:1786:41  */
  always @*
    case (n6261_o)
      1'b1: n6265_o = n6252_o;
      default: n6265_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1786:41  */
  always @*
    case (n6261_o)
      1'b1: n6268_o = 1'b0;
      default: n6268_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:1780:33  */
  assign n6270_o = n6226_o == 31'b0000000000000000000000000000011;
  assign n6271_o = {n6270_o, n6248_o};
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6273_o = n2115_o;
      2'b01: n6273_o = 3'b100;
      default: n6273_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6277_o = 1'b1;
      2'b01: n6277_o = 1'b1;
      default: n6277_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6279_o = 3'b100;
      2'b01: n6279_o = 3'b101;
      default: n6279_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6281_o = n6263_o;
      2'b01: n6281_o = n6241_o;
      default: n6281_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6283_o = n6265_o;
      2'b01: n6283_o = n6243_o;
      default: n6283_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6285_o = n6268_o;
      2'b01: n6285_o = n6246_o;
      default: n6285_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6288_o = 4'b0001;
      2'b01: n6288_o = 4'b0001;
      default: n6288_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6292_o = 1'b1;
      2'b01: n6292_o = 1'b1;
      default: n6292_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6295_o = 2'b00;
      2'b01: n6295_o = 2'b11;
      default: n6295_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1764:33  */
  always @*
    case (n6271_o)
      2'b10: n6299_o = 1'b1;
      2'b01: n6299_o = 1'b1;
      default: n6299_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1761:25  */
  assign n6301_o = ir == 8'b01001010;
  /* ./T80/T80_MCode.vhd:1761:40  */
  assign n6303_o = ir == 8'b01011010;
  /* ./T80/T80_MCode.vhd:1761:40  */
  assign n6304_o = n6301_o | n6303_o;
  /* ./T80/T80_MCode.vhd:1761:51  */
  assign n6306_o = ir == 8'b01101010;
  /* ./T80/T80_MCode.vhd:1761:51  */
  assign n6307_o = n6304_o | n6306_o;
  /* ./T80/T80_MCode.vhd:1761:62  */
  assign n6309_o = ir == 8'b01111010;
  /* ./T80/T80_MCode.vhd:1761:62  */
  assign n6310_o = n6307_o | n6309_o;
  /* ./T80/T80_MCode.vhd:1798:38  */
  assign n6311_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1805:68  */
  assign n6313_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1805:46  */
  assign n6314_o = {29'b0, n6313_o};  //  uext
  /* ./T80/T80_MCode.vhd:1807:78  */
  assign n6315_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1806:41  */
  assign n6318_o = n6314_o == 31'b0000000000000000000000000000000;
  /* ./T80/T80_MCode.vhd:1806:47  */
  assign n6320_o = n6314_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1806:47  */
  assign n6321_o = n6318_o | n6320_o;
  /* ./T80/T80_MCode.vhd:1806:49  */
  assign n6323_o = n6314_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1806:49  */
  assign n6324_o = n6321_o | n6323_o;
  /* ./T80/T80_MCode.vhd:1805:41  */
  always @*
    case (n6324_o)
      1'b1: n6326_o = 1'b1;
      default: n6326_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1805:41  */
  always @*
    case (n6324_o)
      1'b1: n6328_o = n6315_o;
      default: n6328_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1805:41  */
  always @*
    case (n6324_o)
      1'b1: n6331_o = 1'b0;
      default: n6331_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:1799:33  */
  assign n6333_o = n6311_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1820:68  */
  assign n6335_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1820:46  */
  assign n6336_o = {29'b0, n6335_o};  //  uext
  /* ./T80/T80_MCode.vhd:1822:78  */
  assign n6337_o = ir[5:4];
  /* ./T80/T80_MCode.vhd:1821:41  */
  assign n6339_o = n6336_o == 31'b0000000000000000000000000000000;
  /* ./T80/T80_MCode.vhd:1821:47  */
  assign n6341_o = n6336_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1821:47  */
  assign n6342_o = n6339_o | n6341_o;
  /* ./T80/T80_MCode.vhd:1821:49  */
  assign n6344_o = n6336_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1821:49  */
  assign n6345_o = n6342_o | n6344_o;
  /* ./T80/T80_MCode.vhd:1820:41  */
  always @*
    case (n6345_o)
      1'b1: n6348_o = 1'b0;
      default: n6348_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:1820:41  */
  always @*
    case (n6345_o)
      1'b1: n6350_o = n6337_o;
      default: n6350_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1820:41  */
  always @*
    case (n6345_o)
      1'b1: n6353_o = 1'b0;
      default: n6353_o = 1'b1;
    endcase
  /* ./T80/T80_MCode.vhd:1814:33  */
  assign n6355_o = n6311_o == 31'b0000000000000000000000000000011;
  assign n6356_o = {n6355_o, n6333_o};
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6358_o = n2115_o;
      2'b01: n6358_o = 3'b100;
      default: n6358_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6362_o = 1'b1;
      2'b01: n6362_o = 1'b1;
      default: n6362_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6364_o = 3'b100;
      2'b01: n6364_o = 3'b101;
      default: n6364_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6366_o = n6348_o;
      2'b01: n6366_o = n6326_o;
      default: n6366_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6368_o = n6350_o;
      2'b01: n6368_o = n6328_o;
      default: n6368_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6370_o = n6353_o;
      2'b01: n6370_o = n6331_o;
      default: n6370_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6373_o = 4'b0011;
      2'b01: n6373_o = 4'b0011;
      default: n6373_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6377_o = 1'b1;
      2'b01: n6377_o = 1'b1;
      default: n6377_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6380_o = 2'b00;
      2'b01: n6380_o = 2'b11;
      default: n6380_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1798:33  */
  always @*
    case (n6356_o)
      2'b10: n6384_o = 1'b1;
      2'b01: n6384_o = 1'b1;
      default: n6384_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1795:25  */
  assign n6386_o = ir == 8'b01000010;
  /* ./T80/T80_MCode.vhd:1795:40  */
  assign n6388_o = ir == 8'b01010010;
  /* ./T80/T80_MCode.vhd:1795:40  */
  assign n6389_o = n6386_o | n6388_o;
  /* ./T80/T80_MCode.vhd:1795:51  */
  assign n6391_o = ir == 8'b01100010;
  /* ./T80/T80_MCode.vhd:1795:51  */
  assign n6392_o = n6389_o | n6391_o;
  /* ./T80/T80_MCode.vhd:1795:62  */
  assign n6394_o = ir == 8'b01110010;
  /* ./T80/T80_MCode.vhd:1795:62  */
  assign n6395_o = n6392_o | n6394_o;
  /* ./T80/T80_MCode.vhd:1831:38  */
  assign n6396_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1832:33  */
  assign n6398_o = n6396_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1834:33  */
  assign n6402_o = n6396_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1840:33  */
  assign n6404_o = n6396_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1845:33  */
  assign n6406_o = n6396_o == 31'b0000000000000000000000000000100;
  assign n6407_o = {n6406_o, n6404_o, n6402_o, n6398_o};
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6409_o = n2115_o;
      4'b0100: n6409_o = 3'b100;
      4'b0010: n6409_o = n2115_o;
      4'b0001: n6409_o = n2115_o;
      default: n6409_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6412_o = 1'b0;
      4'b0100: n6412_o = 1'b0;
      4'b0010: n6412_o = 1'b1;
      4'b0001: n6412_o = 1'b0;
      default: n6412_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6414_o = 3'b000;
      4'b0100: n6414_o = 3'b000;
      4'b0010: n6414_o = 3'b111;
      4'b0001: n6414_o = 3'b000;
      default: n6414_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6416_o = 3'b000;
      4'b0100: n6416_o = 3'b000;
      4'b0010: n6416_o = 3'b110;
      4'b0001: n6416_o = 3'b000;
      default: n6416_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6418_o = n2118_o;
      4'b0100: n6418_o = n2118_o;
      4'b0010: n6418_o = 4'b1101;
      4'b0001: n6418_o = n2118_o;
      default: n6418_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6421_o = 1'b0;
      4'b0100: n6421_o = 1'b0;
      4'b0010: n6421_o = 1'b1;
      4'b0001: n6421_o = 1'b0;
      default: n6421_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6425_o = 3'b111;
      4'b0100: n6425_o = 3'b010;
      4'b0010: n6425_o = 3'b111;
      4'b0001: n6425_o = 3'b010;
      default: n6425_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6428_o = 1'b0;
      4'b0100: n6428_o = 1'b1;
      4'b0010: n6428_o = 1'b0;
      4'b0001: n6428_o = 1'b0;
      default: n6428_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6431_o = 1'b0;
      4'b0100: n6431_o = 1'b1;
      4'b0010: n6431_o = 1'b0;
      4'b0001: n6431_o = 1'b0;
      default: n6431_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1831:33  */
  always @*
    case (n6407_o)
      4'b1000: n6434_o = 1'b1;
      4'b0100: n6434_o = 1'b0;
      4'b0010: n6434_o = 1'b0;
      4'b0001: n6434_o = 1'b0;
      default: n6434_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1828:25  */
  assign n6436_o = ir == 8'b01101111;
  /* ./T80/T80_MCode.vhd:1852:38  */
  assign n6437_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1853:33  */
  assign n6439_o = n6437_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1855:33  */
  assign n6443_o = n6437_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1861:33  */
  assign n6445_o = n6437_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1866:33  */
  assign n6447_o = n6437_o == 31'b0000000000000000000000000000100;
  assign n6448_o = {n6447_o, n6445_o, n6443_o, n6439_o};
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6450_o = n2115_o;
      4'b0100: n6450_o = 3'b100;
      4'b0010: n6450_o = n2115_o;
      4'b0001: n6450_o = n2115_o;
      default: n6450_o = n2115_o;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6453_o = 1'b0;
      4'b0100: n6453_o = 1'b0;
      4'b0010: n6453_o = 1'b1;
      4'b0001: n6453_o = 1'b0;
      default: n6453_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6455_o = 3'b000;
      4'b0100: n6455_o = 3'b000;
      4'b0010: n6455_o = 3'b111;
      4'b0001: n6455_o = 3'b000;
      default: n6455_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6457_o = 3'b000;
      4'b0100: n6457_o = 3'b000;
      4'b0010: n6457_o = 3'b110;
      4'b0001: n6457_o = 3'b000;
      default: n6457_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6459_o = n2118_o;
      4'b0100: n6459_o = n2118_o;
      4'b0010: n6459_o = 4'b1110;
      4'b0001: n6459_o = n2118_o;
      default: n6459_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6462_o = 1'b0;
      4'b0100: n6462_o = 1'b0;
      4'b0010: n6462_o = 1'b1;
      4'b0001: n6462_o = 1'b0;
      default: n6462_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6466_o = 3'b111;
      4'b0100: n6466_o = 3'b010;
      4'b0010: n6466_o = 3'b111;
      4'b0001: n6466_o = 3'b010;
      default: n6466_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6469_o = 1'b0;
      4'b0100: n6469_o = 1'b1;
      4'b0010: n6469_o = 1'b0;
      4'b0001: n6469_o = 1'b0;
      default: n6469_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6472_o = 1'b0;
      4'b0100: n6472_o = 1'b1;
      4'b0010: n6472_o = 1'b0;
      4'b0001: n6472_o = 1'b0;
      default: n6472_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1852:33  */
  always @*
    case (n6448_o)
      4'b1000: n6475_o = 1'b1;
      4'b0100: n6475_o = 1'b0;
      4'b0010: n6475_o = 1'b0;
      4'b0001: n6475_o = 1'b0;
      default: n6475_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1849:25  */
  assign n6477_o = ir == 8'b01100111;
  /* ./T80/T80_MCode.vhd:1873:38  */
  assign n6478_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1874:33  */
  assign n6480_o = n6478_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1876:33  */
  assign n6482_o = n6478_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1880:33  */
  assign n6484_o = n6478_o == 31'b0000000000000000000000000000011;
  assign n6485_o = {n6484_o, n6482_o, n6480_o};
  /* ./T80/T80_MCode.vhd:1873:33  */
  always @*
    case (n6485_o)
      3'b100: n6489_o = 4'b0111;
      3'b010: n6489_o = 4'b0111;
      3'b001: n6489_o = 4'b0000;
      default: n6489_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1873:33  */
  always @*
    case (n6485_o)
      3'b100: n6493_o = 3'b111;
      3'b010: n6493_o = 3'b101;
      3'b001: n6493_o = 3'b101;
      default: n6493_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1873:33  */
  always @*
    case (n6485_o)
      3'b100: n6496_o = 1'b1;
      3'b010: n6496_o = 1'b0;
      3'b001: n6496_o = 1'b0;
      default: n6496_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1873:33  */
  always @*
    case (n6485_o)
      3'b100: n6499_o = 1'b0;
      3'b010: n6499_o = 1'b1;
      3'b001: n6499_o = 1'b0;
      default: n6499_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1873:33  */
  always @*
    case (n6485_o)
      3'b100: n6502_o = 1'b1;
      3'b010: n6502_o = 1'b0;
      3'b001: n6502_o = 1'b0;
      default: n6502_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1873:33  */
  always @*
    case (n6485_o)
      3'b100: n6505_o = 1'b1;
      3'b010: n6505_o = 1'b0;
      3'b001: n6505_o = 1'b0;
      default: n6505_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1870:25  */
  assign n6507_o = ir == 8'b01000101;
  /* ./T80/T80_MCode.vhd:1870:40  */
  assign n6509_o = ir == 8'b01001101;
  /* ./T80/T80_MCode.vhd:1870:40  */
  assign n6510_o = n6507_o | n6509_o;
  /* ./T80/T80_MCode.vhd:1870:51  */
  assign n6512_o = ir == 8'b01010101;
  /* ./T80/T80_MCode.vhd:1870:51  */
  assign n6513_o = n6510_o | n6512_o;
  /* ./T80/T80_MCode.vhd:1870:62  */
  assign n6515_o = ir == 8'b01011101;
  /* ./T80/T80_MCode.vhd:1870:62  */
  assign n6516_o = n6513_o | n6515_o;
  /* ./T80/T80_MCode.vhd:1870:73  */
  assign n6518_o = ir == 8'b01100101;
  /* ./T80/T80_MCode.vhd:1870:73  */
  assign n6519_o = n6516_o | n6518_o;
  /* ./T80/T80_MCode.vhd:1870:84  */
  assign n6521_o = ir == 8'b01101101;
  /* ./T80/T80_MCode.vhd:1870:84  */
  assign n6522_o = n6519_o | n6521_o;
  /* ./T80/T80_MCode.vhd:1870:95  */
  assign n6524_o = ir == 8'b01110101;
  /* ./T80/T80_MCode.vhd:1870:95  */
  assign n6525_o = n6522_o | n6524_o;
  /* ./T80/T80_MCode.vhd:1870:106  */
  assign n6527_o = ir == 8'b01111101;
  /* ./T80/T80_MCode.vhd:1870:106  */
  assign n6528_o = n6525_o | n6527_o;
  /* ./T80/T80_MCode.vhd:1890:38  */
  assign n6529_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1891:33  */
  assign n6531_o = n6529_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1896:46  */
  assign n6532_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:1896:59  */
  assign n6534_o = n6532_o != 3'b110;
  /* ./T80/T80_MCode.vhd:1898:78  */
  assign n6535_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:1896:41  */
  assign n6538_o = n6534_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1896:41  */
  assign n6540_o = n6534_o ? n6535_o : 3'b000;
  /* ./T80/T80_MCode.vhd:1894:33  */
  assign n6542_o = n6529_o == 31'b0000000000000000000000000000010;
  assign n6543_o = {n6542_o, n6531_o};
  /* ./T80/T80_MCode.vhd:1890:33  */
  always @*
    case (n6543_o)
      2'b10: n6545_o = n6538_o;
      2'b01: n6545_o = 1'b0;
      default: n6545_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1890:33  */
  always @*
    case (n6543_o)
      2'b10: n6547_o = n6540_o;
      2'b01: n6547_o = 3'b000;
      default: n6547_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1890:33  */
  always @*
    case (n6543_o)
      2'b10: n6550_o = 3'b111;
      2'b01: n6550_o = 3'b000;
      default: n6550_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1890:33  */
  always @*
    case (n6543_o)
      2'b10: n6553_o = 1'b1;
      2'b01: n6553_o = 1'b0;
      default: n6553_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1890:33  */
  always @*
    case (n6543_o)
      2'b10: n6556_o = 1'b1;
      2'b01: n6556_o = 1'b0;
      default: n6556_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1890:33  */
  always @*
    case (n6543_o)
      2'b10: n6559_o = 2'b00;
      2'b01: n6559_o = 2'b01;
      default: n6559_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1887:25  */
  assign n6561_o = ir == 8'b01000000;
  /* ./T80/T80_MCode.vhd:1887:40  */
  assign n6563_o = ir == 8'b01001000;
  /* ./T80/T80_MCode.vhd:1887:40  */
  assign n6564_o = n6561_o | n6563_o;
  /* ./T80/T80_MCode.vhd:1887:51  */
  assign n6566_o = ir == 8'b01010000;
  /* ./T80/T80_MCode.vhd:1887:51  */
  assign n6567_o = n6564_o | n6566_o;
  /* ./T80/T80_MCode.vhd:1887:62  */
  assign n6569_o = ir == 8'b01011000;
  /* ./T80/T80_MCode.vhd:1887:62  */
  assign n6570_o = n6567_o | n6569_o;
  /* ./T80/T80_MCode.vhd:1887:73  */
  assign n6572_o = ir == 8'b01100000;
  /* ./T80/T80_MCode.vhd:1887:73  */
  assign n6573_o = n6570_o | n6572_o;
  /* ./T80/T80_MCode.vhd:1887:84  */
  assign n6575_o = ir == 8'b01101000;
  /* ./T80/T80_MCode.vhd:1887:84  */
  assign n6576_o = n6573_o | n6575_o;
  /* ./T80/T80_MCode.vhd:1887:95  */
  assign n6578_o = ir == 8'b01110000;
  /* ./T80/T80_MCode.vhd:1887:95  */
  assign n6579_o = n6576_o | n6578_o;
  /* ./T80/T80_MCode.vhd:1887:106  */
  assign n6581_o = ir == 8'b01111000;
  /* ./T80/T80_MCode.vhd:1887:106  */
  assign n6582_o = n6579_o | n6581_o;
  /* ./T80/T80_MCode.vhd:1907:38  */
  assign n6583_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1911:78  */
  assign n6584_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:1912:46  */
  assign n6585_o = ir[5:3];
  /* ./T80/T80_MCode.vhd:1912:59  */
  assign n6587_o = n6585_o == 3'b110;
  /* ./T80/T80_MCode.vhd:1912:41  */
  assign n6590_o = n6587_o ? 1'b1 : 1'b0;
  /* ./T80/T80_MCode.vhd:1908:33  */
  assign n6592_o = n6583_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1915:33  */
  assign n6594_o = n6583_o == 31'b0000000000000000000000000000010;
  assign n6595_o = {n6594_o, n6592_o};
  /* ./T80/T80_MCode.vhd:1907:33  */
  always @*
    case (n6595_o)
      2'b10: n6597_o = 3'b000;
      2'b01: n6597_o = n6584_o;
      default: n6597_o = 3'b000;
    endcase
  /* ./T80/T80_MCode.vhd:1907:33  */
  always @*
    case (n6595_o)
      2'b10: n6599_o = 1'b0;
      2'b01: n6599_o = n6590_o;
      default: n6599_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1907:33  */
  always @*
    case (n6595_o)
      2'b10: n6602_o = 3'b111;
      2'b01: n6602_o = 3'b000;
      default: n6602_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1907:33  */
  always @*
    case (n6595_o)
      2'b10: n6605_o = 1'b1;
      2'b01: n6605_o = 1'b0;
      default: n6605_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1907:33  */
  always @*
    case (n6595_o)
      2'b10: n6608_o = 2'b00;
      2'b01: n6608_o = 2'b01;
      default: n6608_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1907:33  */
  always @*
    case (n6595_o)
      2'b10: n6611_o = 1'b1;
      2'b01: n6611_o = 1'b0;
      default: n6611_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1903:25  */
  assign n6613_o = ir == 8'b01000001;
  /* ./T80/T80_MCode.vhd:1903:40  */
  assign n6615_o = ir == 8'b01001001;
  /* ./T80/T80_MCode.vhd:1903:40  */
  assign n6616_o = n6613_o | n6615_o;
  /* ./T80/T80_MCode.vhd:1903:51  */
  assign n6618_o = ir == 8'b01010001;
  /* ./T80/T80_MCode.vhd:1903:51  */
  assign n6619_o = n6616_o | n6618_o;
  /* ./T80/T80_MCode.vhd:1903:62  */
  assign n6621_o = ir == 8'b01011001;
  /* ./T80/T80_MCode.vhd:1903:62  */
  assign n6622_o = n6619_o | n6621_o;
  /* ./T80/T80_MCode.vhd:1903:73  */
  assign n6624_o = ir == 8'b01100001;
  /* ./T80/T80_MCode.vhd:1903:73  */
  assign n6625_o = n6622_o | n6624_o;
  /* ./T80/T80_MCode.vhd:1903:84  */
  assign n6627_o = ir == 8'b01101001;
  /* ./T80/T80_MCode.vhd:1903:84  */
  assign n6628_o = n6625_o | n6627_o;
  /* ./T80/T80_MCode.vhd:1903:95  */
  assign n6630_o = ir == 8'b01110001;
  /* ./T80/T80_MCode.vhd:1903:95  */
  assign n6631_o = n6628_o | n6630_o;
  /* ./T80/T80_MCode.vhd:1903:106  */
  assign n6633_o = ir == 8'b01111001;
  /* ./T80/T80_MCode.vhd:1903:106  */
  assign n6634_o = n6631_o | n6633_o;
  /* ./T80/T80_MCode.vhd:1923:38  */
  assign n6635_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1933:59  */
  assign n6636_o = ir[3];
  /* ./T80/T80_MCode.vhd:1924:33  */
  assign n6638_o = n6635_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1934:33  */
  assign n6640_o = n6635_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1939:46  */
  assign n6641_o = ir[3];
  /* ./T80/T80_MCode.vhd:1939:50  */
  assign n6642_o = ~n6641_o;
  /* ./T80/T80_MCode.vhd:1939:41  */
  assign n6645_o = n6642_o ? 4'b0110 : 4'b1110;
  /* ./T80/T80_MCode.vhd:1938:33  */
  assign n6647_o = n6635_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1946:33  */
  assign n6649_o = n6635_o == 31'b0000000000000000000000000000100;
  assign n6650_o = {n6649_o, n6647_o, n6640_o, n6638_o};
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6653_o = 3'b101;
      4'b0100: n6653_o = n2115_o;
      4'b0010: n6653_o = n2115_o;
      4'b0001: n6653_o = 3'b101;
      default: n6653_o = n2115_o;
    endcase
  assign n6654_o = n6645_o[2:0];
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6656_o = 3'b000;
      4'b0100: n6656_o = n6654_o;
      4'b0010: n6656_o = 3'b000;
      4'b0001: n6656_o = 3'b000;
      default: n6656_o = 3'b000;
    endcase
  assign n6657_o = n6645_o[3];
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6659_o = 1'b0;
      4'b0100: n6659_o = n6657_o;
      4'b0010: n6659_o = 1'b0;
      4'b0001: n6659_o = n6636_o;
      default: n6659_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6662_o = 1'b0;
      4'b0100: n6662_o = 1'b0;
      4'b0010: n6662_o = 1'b0;
      4'b0001: n6662_o = 1'b1;
      default: n6662_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6665_o = 4'b0000;
      4'b0100: n6665_o = 4'b0000;
      4'b0010: n6665_o = 4'b0000;
      4'b0001: n6665_o = 4'b0000;
      default: n6665_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6669_o = 4'b0000;
      4'b0100: n6669_o = 4'b0000;
      4'b0010: n6669_o = 4'b0110;
      4'b0001: n6669_o = 4'b1010;
      default: n6669_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6671_o = n2118_o;
      4'b0100: n6671_o = n2118_o;
      4'b0010: n6671_o = n2118_o;
      4'b0001: n6671_o = 4'b0010;
      default: n6671_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6674_o = 1'b0;
      4'b0100: n6674_o = 1'b0;
      4'b0010: n6674_o = 1'b0;
      4'b0001: n6674_o = 1'b1;
      default: n6674_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6678_o = 3'b111;
      4'b0100: n6678_o = 3'b111;
      4'b0010: n6678_o = 3'b010;
      4'b0001: n6678_o = 3'b000;
      default: n6678_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6681_o = 1'b0;
      4'b0100: n6681_o = 1'b0;
      4'b0010: n6681_o = 1'b1;
      4'b0001: n6681_o = 1'b0;
      default: n6681_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6684_o = 1'b0;
      4'b0100: n6684_o = 1'b1;
      4'b0010: n6684_o = 1'b0;
      4'b0001: n6684_o = 1'b0;
      default: n6684_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6687_o = 2'b00;
      4'b0100: n6687_o = 2'b00;
      4'b0010: n6687_o = 2'b00;
      4'b0001: n6687_o = 2'b11;
      default: n6687_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6690_o = 1'b1;
      4'b0100: n6690_o = 1'b0;
      4'b0010: n6690_o = 1'b0;
      4'b0001: n6690_o = 1'b0;
      default: n6690_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1923:33  */
  always @*
    case (n6650_o)
      4'b1000: n6693_o = 1'b0;
      4'b0100: n6693_o = 1'b1;
      4'b0010: n6693_o = 1'b0;
      4'b0001: n6693_o = 1'b0;
      default: n6693_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1920:25  */
  assign n6695_o = ir == 8'b10100010;
  /* ./T80/T80_MCode.vhd:1920:41  */
  assign n6697_o = ir == 8'b10101010;
  /* ./T80/T80_MCode.vhd:1920:41  */
  assign n6698_o = n6695_o | n6697_o;
  /* ./T80/T80_MCode.vhd:1920:54  */
  assign n6700_o = ir == 8'b10110010;
  /* ./T80/T80_MCode.vhd:1920:54  */
  assign n6701_o = n6698_o | n6700_o;
  /* ./T80/T80_MCode.vhd:1920:67  */
  assign n6703_o = ir == 8'b10111010;
  /* ./T80/T80_MCode.vhd:1920:67  */
  assign n6704_o = n6701_o | n6703_o;
  /* ./T80/T80_MCode.vhd:1954:38  */
  assign n6705_o = {28'b0, mcycle};  //  uext
  /* ./T80/T80_MCode.vhd:1955:33  */
  assign n6707_o = n6705_o == 31'b0000000000000000000000000000001;
  /* ./T80/T80_MCode.vhd:1967:59  */
  assign n6708_o = ir[3];
  /* ./T80/T80_MCode.vhd:1963:33  */
  assign n6710_o = n6705_o == 31'b0000000000000000000000000000010;
  /* ./T80/T80_MCode.vhd:1969:46  */
  assign n6711_o = ir[3];
  /* ./T80/T80_MCode.vhd:1969:50  */
  assign n6712_o = ~n6711_o;
  /* ./T80/T80_MCode.vhd:1969:41  */
  assign n6715_o = n6712_o ? 4'b0110 : 4'b1110;
  /* ./T80/T80_MCode.vhd:1968:33  */
  assign n6717_o = n6705_o == 31'b0000000000000000000000000000011;
  /* ./T80/T80_MCode.vhd:1977:33  */
  assign n6719_o = n6705_o == 31'b0000000000000000000000000000100;
  assign n6720_o = {n6719_o, n6717_o, n6710_o, n6707_o};
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6723_o = 3'b101;
      4'b0100: n6723_o = n2115_o;
      4'b0010: n6723_o = n2115_o;
      4'b0001: n6723_o = 3'b101;
      default: n6723_o = n2115_o;
    endcase
  assign n6724_o = n6715_o[2:0];
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6726_o = 3'b000;
      4'b0100: n6726_o = n6724_o;
      4'b0010: n6726_o = 3'b000;
      4'b0001: n6726_o = 3'b000;
      default: n6726_o = 3'b000;
    endcase
  assign n6727_o = n6715_o[3];
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6729_o = 1'b0;
      4'b0100: n6729_o = n6727_o;
      4'b0010: n6729_o = n6708_o;
      4'b0001: n6729_o = 1'b0;
      default: n6729_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6732_o = 1'b0;
      4'b0100: n6732_o = 1'b0;
      4'b0010: n6732_o = 1'b0;
      4'b0001: n6732_o = 1'b1;
      default: n6732_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6735_o = 4'b0000;
      4'b0100: n6735_o = 4'b0000;
      4'b0010: n6735_o = 4'b0000;
      4'b0001: n6735_o = 4'b0000;
      default: n6735_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6739_o = 4'b0000;
      4'b0100: n6739_o = 4'b0000;
      4'b0010: n6739_o = 4'b0110;
      4'b0001: n6739_o = 4'b1010;
      default: n6739_o = 4'b0000;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6741_o = n2118_o;
      4'b0100: n6741_o = n2118_o;
      4'b0010: n6741_o = n2118_o;
      4'b0001: n6741_o = 4'b0010;
      default: n6741_o = n2118_o;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6744_o = 1'b0;
      4'b0100: n6744_o = 1'b0;
      4'b0010: n6744_o = 1'b0;
      4'b0001: n6744_o = 1'b1;
      default: n6744_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6748_o = 3'b111;
      4'b0100: n6748_o = 3'b111;
      4'b0010: n6748_o = 3'b000;
      4'b0001: n6748_o = 3'b010;
      default: n6748_o = 3'b111;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6751_o = 1'b0;
      4'b0100: n6751_o = 1'b1;
      4'b0010: n6751_o = 1'b0;
      4'b0001: n6751_o = 1'b0;
      default: n6751_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6754_o = 1'b0;
      4'b0100: n6754_o = 1'b1;
      4'b0010: n6754_o = 1'b0;
      4'b0001: n6754_o = 1'b0;
      default: n6754_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6757_o = 2'b00;
      4'b0100: n6757_o = 2'b00;
      4'b0010: n6757_o = 2'b11;
      4'b0001: n6757_o = 2'b00;
      default: n6757_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6760_o = 1'b1;
      4'b0100: n6760_o = 1'b0;
      4'b0010: n6760_o = 1'b0;
      4'b0001: n6760_o = 1'b0;
      default: n6760_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1954:33  */
  always @*
    case (n6720_o)
      4'b1000: n6763_o = 1'b0;
      4'b0100: n6763_o = 1'b1;
      4'b0010: n6763_o = 1'b0;
      4'b0001: n6763_o = 1'b0;
      default: n6763_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:1951:25  */
  assign n6765_o = ir == 8'b10100011;
  /* ./T80/T80_MCode.vhd:1951:41  */
  assign n6767_o = ir == 8'b10101011;
  /* ./T80/T80_MCode.vhd:1951:41  */
  assign n6768_o = n6765_o | n6767_o;
  /* ./T80/T80_MCode.vhd:1951:54  */
  assign n6770_o = ir == 8'b10110011;
  /* ./T80/T80_MCode.vhd:1951:54  */
  assign n6771_o = n6768_o | n6770_o;
  /* ./T80/T80_MCode.vhd:1951:67  */
  assign n6773_o = ir == 8'b10111011;
  /* ./T80/T80_MCode.vhd:1951:67  */
  assign n6774_o = n6771_o | n6773_o;
  assign n6775_o = {n6774_o, n6704_o, n6634_o, n6582_o, n6528_o, n6477_o, n6436_o, n6395_o, n6310_o, n6225_o, n6220_o, n6215_o, n6204_o, n6181_o, n6125_o, n6067_o, n6005_o, n5937_o, n5935_o, n5933_o, n5931_o, n5929_o, n5924_o};
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6791_o = 3'b100;
      23'b01000000000000000000000: n6791_o = 3'b100;
      23'b00100000000000000000000: n6791_o = 3'b010;
      23'b00010000000000000000000: n6791_o = 3'b010;
      23'b00001000000000000000000: n6791_o = 3'b011;
      23'b00000100000000000000000: n6791_o = 3'b100;
      23'b00000010000000000000000: n6791_o = 3'b100;
      23'b00000001000000000000000: n6791_o = 3'b011;
      23'b00000000100000000000000: n6791_o = 3'b011;
      23'b00000000010000000000000: n6791_o = 3'b001;
      23'b00000000001000000000000: n6791_o = 3'b001;
      23'b00000000000100000000000: n6791_o = 3'b001;
      23'b00000000000010000000000: n6791_o = 3'b001;
      23'b00000000000001000000000: n6791_o = 3'b100;
      23'b00000000000000100000000: n6791_o = 3'b100;
      23'b00000000000000010000000: n6791_o = 3'b101;
      23'b00000000000000001000000: n6791_o = 3'b101;
      23'b00000000000000000100000: n6791_o = 3'b001;
      23'b00000000000000000010000: n6791_o = 3'b001;
      23'b00000000000000000001000: n6791_o = 3'b001;
      23'b00000000000000000000100: n6791_o = 3'b001;
      23'b00000000000000000000010: n6791_o = 3'b001;
      23'b00000000000000000000001: n6791_o = 3'b001;
      default: n6791_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6797_o = n6723_o;
      23'b01000000000000000000000: n6797_o = n6653_o;
      23'b00100000000000000000000: n6797_o = n2115_o;
      23'b00010000000000000000000: n6797_o = n2115_o;
      23'b00001000000000000000000: n6797_o = n2115_o;
      23'b00000100000000000000000: n6797_o = n6450_o;
      23'b00000010000000000000000: n6797_o = n6409_o;
      23'b00000001000000000000000: n6797_o = n6358_o;
      23'b00000000100000000000000: n6797_o = n6273_o;
      23'b00000000010000000000000: n6797_o = n2115_o;
      23'b00000000001000000000000: n6797_o = n2115_o;
      23'b00000000000100000000000: n6797_o = n2115_o;
      23'b00000000000010000000000: n6797_o = n2115_o;
      23'b00000000000001000000000: n6797_o = n6144_o;
      23'b00000000000000100000000: n6797_o = n6091_o;
      23'b00000000000000010000000: n6797_o = n2115_o;
      23'b00000000000000001000000: n6797_o = n2115_o;
      23'b00000000000000000100000: n6797_o = 3'b101;
      23'b00000000000000000010000: n6797_o = 3'b101;
      23'b00000000000000000001000: n6797_o = 3'b101;
      23'b00000000000000000000100: n6797_o = 3'b101;
      23'b00000000000000000000010: n6797_o = n2115_o;
      23'b00000000000000000000001: n6797_o = n2115_o;
      default: n6797_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6800_o = 1'b0;
      23'b01000000000000000000000: n6800_o = 1'b0;
      23'b00100000000000000000000: n6800_o = 1'b0;
      23'b00010000000000000000000: n6800_o = 1'b0;
      23'b00001000000000000000000: n6800_o = 1'b0;
      23'b00000100000000000000000: n6800_o = 1'b0;
      23'b00000010000000000000000: n6800_o = 1'b0;
      23'b00000001000000000000000: n6800_o = 1'b0;
      23'b00000000100000000000000: n6800_o = 1'b0;
      23'b00000000010000000000000: n6800_o = 1'b0;
      23'b00000000001000000000000: n6800_o = 1'b0;
      23'b00000000000100000000000: n6800_o = 1'b0;
      23'b00000000000010000000000: n6800_o = 1'b0;
      23'b00000000000001000000000: n6800_o = 1'b0;
      23'b00000000000000100000000: n6800_o = 1'b0;
      23'b00000000000000010000000: n6800_o = n6037_o;
      23'b00000000000000001000000: n6800_o = n5973_o;
      23'b00000000000000000100000: n6800_o = 1'b0;
      23'b00000000000000000010000: n6800_o = 1'b0;
      23'b00000000000000000001000: n6800_o = 1'b0;
      23'b00000000000000000000100: n6800_o = 1'b0;
      23'b00000000000000000000010: n6800_o = 1'b0;
      23'b00000000000000000000001: n6800_o = 1'b0;
      default: n6800_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6803_o = 1'b0;
      23'b01000000000000000000000: n6803_o = 1'b0;
      23'b00100000000000000000000: n6803_o = 1'b0;
      23'b00010000000000000000000: n6803_o = 1'b0;
      23'b00001000000000000000000: n6803_o = 1'b0;
      23'b00000100000000000000000: n6803_o = 1'b0;
      23'b00000010000000000000000: n6803_o = 1'b0;
      23'b00000001000000000000000: n6803_o = 1'b0;
      23'b00000000100000000000000: n6803_o = 1'b0;
      23'b00000000010000000000000: n6803_o = 1'b0;
      23'b00000000001000000000000: n6803_o = 1'b0;
      23'b00000000000100000000000: n6803_o = 1'b0;
      23'b00000000000010000000000: n6803_o = 1'b0;
      23'b00000000000001000000000: n6803_o = 1'b0;
      23'b00000000000000100000000: n6803_o = 1'b0;
      23'b00000000000000010000000: n6803_o = n6040_o;
      23'b00000000000000001000000: n6803_o = n5976_o;
      23'b00000000000000000100000: n6803_o = 1'b0;
      23'b00000000000000000010000: n6803_o = 1'b0;
      23'b00000000000000000001000: n6803_o = 1'b0;
      23'b00000000000000000000100: n6803_o = 1'b0;
      23'b00000000000000000000010: n6803_o = 1'b0;
      23'b00000000000000000000001: n6803_o = 1'b0;
      default: n6803_o = 1'bX;
    endcase
  assign n6804_o = n6094_o[2:0];
  assign n6805_o = n6147_o[2:0];
  assign n6806_o = n6489_o[2:0];
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6809_o = n6726_o;
      23'b01000000000000000000000: n6809_o = n6656_o;
      23'b00100000000000000000000: n6809_o = 3'b000;
      23'b00010000000000000000000: n6809_o = 3'b000;
      23'b00001000000000000000000: n6809_o = n6806_o;
      23'b00000100000000000000000: n6809_o = 3'b000;
      23'b00000010000000000000000: n6809_o = 3'b000;
      23'b00000001000000000000000: n6809_o = 3'b000;
      23'b00000000100000000000000: n6809_o = 3'b000;
      23'b00000000010000000000000: n6809_o = 3'b000;
      23'b00000000001000000000000: n6809_o = 3'b000;
      23'b00000000000100000000000: n6809_o = 3'b000;
      23'b00000000000010000000000: n6809_o = 3'b000;
      23'b00000000000001000000000: n6809_o = n6805_o;
      23'b00000000000000100000000: n6809_o = n6804_o;
      23'b00000000000000010000000: n6809_o = 3'b000;
      23'b00000000000000001000000: n6809_o = 3'b000;
      23'b00000000000000000100000: n6809_o = 3'b000;
      23'b00000000000000000010000: n6809_o = 3'b000;
      23'b00000000000000000001000: n6809_o = 3'b000;
      23'b00000000000000000000100: n6809_o = 3'b000;
      23'b00000000000000000000010: n6809_o = 3'b000;
      23'b00000000000000000000001: n6809_o = 3'b000;
      default: n6809_o = 3'bX;
    endcase
  assign n6810_o = n6094_o[3];
  assign n6811_o = n6147_o[3];
  assign n6812_o = n6489_o[3];
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6815_o = n6729_o;
      23'b01000000000000000000000: n6815_o = n6659_o;
      23'b00100000000000000000000: n6815_o = 1'b0;
      23'b00010000000000000000000: n6815_o = 1'b0;
      23'b00001000000000000000000: n6815_o = n6812_o;
      23'b00000100000000000000000: n6815_o = 1'b0;
      23'b00000010000000000000000: n6815_o = 1'b0;
      23'b00000001000000000000000: n6815_o = 1'b0;
      23'b00000000100000000000000: n6815_o = 1'b0;
      23'b00000000010000000000000: n6815_o = 1'b0;
      23'b00000000001000000000000: n6815_o = 1'b0;
      23'b00000000000100000000000: n6815_o = 1'b0;
      23'b00000000000010000000000: n6815_o = 1'b0;
      23'b00000000000001000000000: n6815_o = n6811_o;
      23'b00000000000000100000000: n6815_o = n6810_o;
      23'b00000000000000010000000: n6815_o = 1'b0;
      23'b00000000000000001000000: n6815_o = 1'b0;
      23'b00000000000000000100000: n6815_o = 1'b0;
      23'b00000000000000000010000: n6815_o = 1'b0;
      23'b00000000000000000001000: n6815_o = 1'b0;
      23'b00000000000000000000100: n6815_o = 1'b0;
      23'b00000000000000000000010: n6815_o = 1'b0;
      23'b00000000000000000000001: n6815_o = 1'b0;
      default: n6815_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6818_o = n6732_o;
      23'b01000000000000000000000: n6818_o = n6662_o;
      23'b00100000000000000000000: n6818_o = 1'b0;
      23'b00010000000000000000000: n6818_o = n6545_o;
      23'b00001000000000000000000: n6818_o = 1'b0;
      23'b00000100000000000000000: n6818_o = n6453_o;
      23'b00000010000000000000000: n6818_o = n6412_o;
      23'b00000001000000000000000: n6818_o = n6362_o;
      23'b00000000100000000000000: n6818_o = n6277_o;
      23'b00000000010000000000000: n6818_o = 1'b0;
      23'b00000000001000000000000: n6818_o = 1'b0;
      23'b00000000000100000000000: n6818_o = 1'b0;
      23'b00000000000010000000000: n6818_o = 1'b0;
      23'b00000000000001000000000: n6818_o = 1'b0;
      23'b00000000000000100000000: n6818_o = 1'b0;
      23'b00000000000000010000000: n6818_o = 1'b0;
      23'b00000000000000001000000: n6818_o = n5980_o;
      23'b00000000000000000100000: n6818_o = 1'b0;
      23'b00000000000000000010000: n6818_o = 1'b0;
      23'b00000000000000000001000: n6818_o = 1'b0;
      23'b00000000000000000000100: n6818_o = 1'b0;
      23'b00000000000000000000010: n6818_o = 1'b0;
      23'b00000000000000000000001: n6818_o = 1'b0;
      default: n6818_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6822_o = 1'b0;
      23'b01000000000000000000000: n6822_o = 1'b0;
      23'b00100000000000000000000: n6822_o = 1'b0;
      23'b00010000000000000000000: n6822_o = 1'b0;
      23'b00001000000000000000000: n6822_o = 1'b0;
      23'b00000100000000000000000: n6822_o = 1'b0;
      23'b00000010000000000000000: n6822_o = 1'b0;
      23'b00000001000000000000000: n6822_o = 1'b0;
      23'b00000000100000000000000: n6822_o = 1'b0;
      23'b00000000010000000000000: n6822_o = 1'b0;
      23'b00000000001000000000000: n6822_o = 1'b0;
      23'b00000000000100000000000: n6822_o = 1'b0;
      23'b00000000000010000000000: n6822_o = 1'b1;
      23'b00000000000001000000000: n6822_o = 1'b0;
      23'b00000000000000100000000: n6822_o = 1'b0;
      23'b00000000000000010000000: n6822_o = 1'b0;
      23'b00000000000000001000000: n6822_o = 1'b0;
      23'b00000000000000000100000: n6822_o = 1'b0;
      23'b00000000000000000010000: n6822_o = 1'b0;
      23'b00000000000000000001000: n6822_o = 1'b0;
      23'b00000000000000000000100: n6822_o = 1'b0;
      23'b00000000000000000000010: n6822_o = 1'b0;
      23'b00000000000000000000001: n6822_o = 1'b0;
      default: n6822_o = 1'bX;
    endcase
  assign n6824_o = n6665_o[2:0];
  assign n6825_o = n6735_o[2:0];
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6828_o = n6825_o;
      23'b01000000000000000000000: n6828_o = n6824_o;
      23'b00100000000000000000000: n6828_o = 3'b000;
      23'b00010000000000000000000: n6828_o = n6547_o;
      23'b00001000000000000000000: n6828_o = 3'b000;
      23'b00000100000000000000000: n6828_o = n6455_o;
      23'b00000010000000000000000: n6828_o = n6414_o;
      23'b00000001000000000000000: n6828_o = n6364_o;
      23'b00000000100000000000000: n6828_o = n6279_o;
      23'b00000000010000000000000: n6828_o = 3'b000;
      23'b00000000001000000000000: n6828_o = 3'b000;
      23'b00000000000100000000000: n6828_o = 3'b000;
      23'b00000000000010000000000: n6828_o = 3'b010;
      23'b00000000000001000000000: n6828_o = n6149_o;
      23'b00000000000000100000000: n6828_o = n6096_o;
      23'b00000000000000010000000: n6828_o = 3'b000;
      23'b00000000000000001000000: n6828_o = n5982_o;
      23'b00000000000000000100000: n6828_o = 3'b000;
      23'b00000000000000000010000: n6828_o = 3'b000;
      23'b00000000000000000001000: n6828_o = 3'b000;
      23'b00000000000000000000100: n6828_o = 3'b000;
      23'b00000000000000000000010: n6828_o = 3'b000;
      23'b00000000000000000000001: n6828_o = 3'b000;
      default: n6828_o = 3'bX;
    endcase
  assign n6830_o = n6665_o[3];
  assign n6831_o = n6735_o[3];
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6834_o = n6831_o;
      23'b01000000000000000000000: n6834_o = n6830_o;
      23'b00100000000000000000000: n6834_o = 1'b0;
      23'b00010000000000000000000: n6834_o = 1'b0;
      23'b00001000000000000000000: n6834_o = 1'b0;
      23'b00000100000000000000000: n6834_o = 1'b0;
      23'b00000010000000000000000: n6834_o = 1'b0;
      23'b00000001000000000000000: n6834_o = 1'b0;
      23'b00000000100000000000000: n6834_o = 1'b0;
      23'b00000000010000000000000: n6834_o = 1'b0;
      23'b00000000001000000000000: n6834_o = 1'b0;
      23'b00000000000100000000000: n6834_o = 1'b0;
      23'b00000000000010000000000: n6834_o = 1'b1;
      23'b00000000000001000000000: n6834_o = 1'b0;
      23'b00000000000000100000000: n6834_o = 1'b0;
      23'b00000000000000010000000: n6834_o = 1'b0;
      23'b00000000000000001000000: n6834_o = n5984_o;
      23'b00000000000000000100000: n6834_o = 1'b0;
      23'b00000000000000000010000: n6834_o = 1'b0;
      23'b00000000000000000001000: n6834_o = 1'b0;
      23'b00000000000000000000100: n6834_o = 1'b0;
      23'b00000000000000000000010: n6834_o = 1'b0;
      23'b00000000000000000000001: n6834_o = 1'b0;
      default: n6834_o = 1'bX;
    endcase
  assign n6835_o = n6042_o[0];
  assign n6836_o = n6099_o[0];
  assign n6837_o = n6152_o[0];
  assign n6839_o = n6416_o[0];
  assign n6840_o = n6457_o[0];
  assign n6841_o = n6597_o[0];
  assign n6842_o = n6669_o[0];
  assign n6843_o = n6739_o[0];
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6846_o = n6843_o;
      23'b01000000000000000000000: n6846_o = n6842_o;
      23'b00100000000000000000000: n6846_o = n6841_o;
      23'b00010000000000000000000: n6846_o = 1'b0;
      23'b00001000000000000000000: n6846_o = 1'b0;
      23'b00000100000000000000000: n6846_o = n6840_o;
      23'b00000010000000000000000: n6846_o = n6839_o;
      23'b00000001000000000000000: n6846_o = n6366_o;
      23'b00000000100000000000000: n6846_o = n6281_o;
      23'b00000000010000000000000: n6846_o = 1'b0;
      23'b00000000001000000000000: n6846_o = 1'b0;
      23'b00000000000100000000000: n6846_o = 1'b0;
      23'b00000000000010000000000: n6846_o = 1'b1;
      23'b00000000000001000000000: n6846_o = n6837_o;
      23'b00000000000000100000000: n6846_o = n6836_o;
      23'b00000000000000010000000: n6846_o = n6835_o;
      23'b00000000000000001000000: n6846_o = 1'b0;
      23'b00000000000000000100000: n6846_o = 1'b0;
      23'b00000000000000000010000: n6846_o = 1'b0;
      23'b00000000000000000001000: n6846_o = 1'b0;
      23'b00000000000000000000100: n6846_o = 1'b0;
      23'b00000000000000000000010: n6846_o = 1'b0;
      23'b00000000000000000000001: n6846_o = 1'b0;
      default: n6846_o = 1'bX;
    endcase
  assign n6847_o = n6042_o[2:1];
  assign n6848_o = n6099_o[2:1];
  assign n6849_o = n6152_o[2:1];
  assign n6851_o = n6416_o[2:1];
  assign n6852_o = n6457_o[2:1];
  assign n6853_o = n6597_o[2:1];
  assign n6854_o = n6669_o[2:1];
  assign n6855_o = n6739_o[2:1];
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6858_o = n6855_o;
      23'b01000000000000000000000: n6858_o = n6854_o;
      23'b00100000000000000000000: n6858_o = n6853_o;
      23'b00010000000000000000000: n6858_o = 2'b00;
      23'b00001000000000000000000: n6858_o = 2'b00;
      23'b00000100000000000000000: n6858_o = n6852_o;
      23'b00000010000000000000000: n6858_o = n6851_o;
      23'b00000001000000000000000: n6858_o = n6368_o;
      23'b00000000100000000000000: n6858_o = n6283_o;
      23'b00000000010000000000000: n6858_o = 2'b00;
      23'b00000000001000000000000: n6858_o = 2'b00;
      23'b00000000000100000000000: n6858_o = 2'b00;
      23'b00000000000010000000000: n6858_o = 2'b11;
      23'b00000000000001000000000: n6858_o = n6849_o;
      23'b00000000000000100000000: n6858_o = n6848_o;
      23'b00000000000000010000000: n6858_o = n6847_o;
      23'b00000000000000001000000: n6858_o = 2'b00;
      23'b00000000000000000100000: n6858_o = 2'b00;
      23'b00000000000000000010000: n6858_o = 2'b00;
      23'b00000000000000000001000: n6858_o = 2'b00;
      23'b00000000000000000000100: n6858_o = 2'b00;
      23'b00000000000000000000010: n6858_o = 2'b00;
      23'b00000000000000000000001: n6858_o = 2'b00;
      default: n6858_o = 2'bX;
    endcase
  assign n6859_o = n6042_o[3];
  assign n6860_o = n6099_o[3];
  assign n6861_o = n6152_o[3];
  assign n6863_o = n6669_o[3];
  assign n6864_o = n6739_o[3];
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6867_o = n6864_o;
      23'b01000000000000000000000: n6867_o = n6863_o;
      23'b00100000000000000000000: n6867_o = n6599_o;
      23'b00010000000000000000000: n6867_o = 1'b0;
      23'b00001000000000000000000: n6867_o = 1'b0;
      23'b00000100000000000000000: n6867_o = 1'b0;
      23'b00000010000000000000000: n6867_o = 1'b0;
      23'b00000001000000000000000: n6867_o = n6370_o;
      23'b00000000100000000000000: n6867_o = n6285_o;
      23'b00000000010000000000000: n6867_o = 1'b0;
      23'b00000000001000000000000: n6867_o = 1'b0;
      23'b00000000000100000000000: n6867_o = 1'b0;
      23'b00000000000010000000000: n6867_o = 1'b0;
      23'b00000000000001000000000: n6867_o = n6861_o;
      23'b00000000000000100000000: n6867_o = n6860_o;
      23'b00000000000000010000000: n6867_o = n6859_o;
      23'b00000000000000001000000: n6867_o = 1'b0;
      23'b00000000000000000100000: n6867_o = 1'b0;
      23'b00000000000000000010000: n6867_o = 1'b0;
      23'b00000000000000000001000: n6867_o = 1'b0;
      23'b00000000000000000000100: n6867_o = 1'b0;
      23'b00000000000000000000010: n6867_o = 1'b0;
      23'b00000000000000000000001: n6867_o = 1'b0;
      default: n6867_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6870_o = n6741_o;
      23'b01000000000000000000000: n6870_o = n6671_o;
      23'b00100000000000000000000: n6870_o = n2118_o;
      23'b00010000000000000000000: n6870_o = n2118_o;
      23'b00001000000000000000000: n6870_o = n2118_o;
      23'b00000100000000000000000: n6870_o = n6459_o;
      23'b00000010000000000000000: n6870_o = n6418_o;
      23'b00000001000000000000000: n6870_o = n6373_o;
      23'b00000000100000000000000: n6870_o = n6288_o;
      23'b00000000010000000000000: n6870_o = n2118_o;
      23'b00000000001000000000000: n6870_o = n2118_o;
      23'b00000000000100000000000: n6870_o = n2118_o;
      23'b00000000000010000000000: n6870_o = 4'b0010;
      23'b00000000000001000000000: n6870_o = n6154_o;
      23'b00000000000000100000000: n6870_o = n6101_o;
      23'b00000000000000010000000: n6870_o = n2118_o;
      23'b00000000000000001000000: n6870_o = n2118_o;
      23'b00000000000000000100000: n6870_o = n2118_o;
      23'b00000000000000000010000: n6870_o = n2118_o;
      23'b00000000000000000001000: n6870_o = n2118_o;
      23'b00000000000000000000100: n6870_o = n2118_o;
      23'b00000000000000000000010: n6870_o = n2118_o;
      23'b00000000000000000000001: n6870_o = n2118_o;
      default: n6870_o = 4'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6874_o = n6744_o;
      23'b01000000000000000000000: n6874_o = n6674_o;
      23'b00100000000000000000000: n6874_o = 1'b0;
      23'b00010000000000000000000: n6874_o = 1'b0;
      23'b00001000000000000000000: n6874_o = 1'b0;
      23'b00000100000000000000000: n6874_o = n6462_o;
      23'b00000010000000000000000: n6874_o = n6421_o;
      23'b00000001000000000000000: n6874_o = n6377_o;
      23'b00000000100000000000000: n6874_o = n6292_o;
      23'b00000000010000000000000: n6874_o = 1'b0;
      23'b00000000001000000000000: n6874_o = 1'b0;
      23'b00000000000100000000000: n6874_o = 1'b0;
      23'b00000000000010000000000: n6874_o = 1'b1;
      23'b00000000000001000000000: n6874_o = n6157_o;
      23'b00000000000000100000000: n6874_o = 1'b0;
      23'b00000000000000010000000: n6874_o = 1'b0;
      23'b00000000000000001000000: n6874_o = 1'b0;
      23'b00000000000000000100000: n6874_o = 1'b0;
      23'b00000000000000000010000: n6874_o = 1'b0;
      23'b00000000000000000001000: n6874_o = 1'b0;
      23'b00000000000000000000100: n6874_o = 1'b0;
      23'b00000000000000000000010: n6874_o = 1'b0;
      23'b00000000000000000000001: n6874_o = 1'b0;
      default: n6874_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6877_o = 1'b0;
      23'b01000000000000000000000: n6877_o = 1'b0;
      23'b00100000000000000000000: n6877_o = 1'b0;
      23'b00010000000000000000000: n6877_o = 1'b0;
      23'b00001000000000000000000: n6877_o = 1'b0;
      23'b00000100000000000000000: n6877_o = 1'b0;
      23'b00000010000000000000000: n6877_o = 1'b0;
      23'b00000001000000000000000: n6877_o = 1'b0;
      23'b00000000100000000000000: n6877_o = 1'b0;
      23'b00000000010000000000000: n6877_o = 1'b0;
      23'b00000000001000000000000: n6877_o = 1'b0;
      23'b00000000000100000000000: n6877_o = 1'b0;
      23'b00000000000010000000000: n6877_o = 1'b0;
      23'b00000000000001000000000: n6877_o = n6160_o;
      23'b00000000000000100000000: n6877_o = 1'b0;
      23'b00000000000000010000000: n6877_o = 1'b0;
      23'b00000000000000001000000: n6877_o = 1'b0;
      23'b00000000000000000100000: n6877_o = 1'b0;
      23'b00000000000000000010000: n6877_o = 1'b0;
      23'b00000000000000000001000: n6877_o = 1'b0;
      23'b00000000000000000000100: n6877_o = 1'b0;
      23'b00000000000000000000010: n6877_o = 1'b0;
      23'b00000000000000000000001: n6877_o = 1'b0;
      default: n6877_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6880_o = n6748_o;
      23'b01000000000000000000000: n6880_o = n6678_o;
      23'b00100000000000000000000: n6880_o = n6602_o;
      23'b00010000000000000000000: n6880_o = n6550_o;
      23'b00001000000000000000000: n6880_o = n6493_o;
      23'b00000100000000000000000: n6880_o = n6466_o;
      23'b00000010000000000000000: n6880_o = n6425_o;
      23'b00000001000000000000000: n6880_o = 3'b111;
      23'b00000000100000000000000: n6880_o = 3'b111;
      23'b00000000010000000000000: n6880_o = 3'b111;
      23'b00000000001000000000000: n6880_o = 3'b111;
      23'b00000000000100000000000: n6880_o = 3'b111;
      23'b00000000000010000000000: n6880_o = 3'b111;
      23'b00000000000001000000000: n6880_o = n6163_o;
      23'b00000000000000100000000: n6880_o = n6105_o;
      23'b00000000000000010000000: n6880_o = n6046_o;
      23'b00000000000000001000000: n6880_o = n5988_o;
      23'b00000000000000000100000: n6880_o = 3'b111;
      23'b00000000000000000010000: n6880_o = 3'b111;
      23'b00000000000000000001000: n6880_o = 3'b111;
      23'b00000000000000000000100: n6880_o = 3'b111;
      23'b00000000000000000000010: n6880_o = 3'b111;
      23'b00000000000000000000001: n6880_o = 3'b111;
      default: n6880_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6883_o = n6751_o;
      23'b01000000000000000000000: n6883_o = n6681_o;
      23'b00100000000000000000000: n6883_o = n6605_o;
      23'b00010000000000000000000: n6883_o = n6553_o;
      23'b00001000000000000000000: n6883_o = 1'b0;
      23'b00000100000000000000000: n6883_o = 1'b0;
      23'b00000010000000000000000: n6883_o = 1'b0;
      23'b00000001000000000000000: n6883_o = 1'b0;
      23'b00000000100000000000000: n6883_o = 1'b0;
      23'b00000000010000000000000: n6883_o = 1'b0;
      23'b00000000001000000000000: n6883_o = 1'b0;
      23'b00000000000100000000000: n6883_o = 1'b0;
      23'b00000000000010000000000: n6883_o = 1'b0;
      23'b00000000000001000000000: n6883_o = 1'b0;
      23'b00000000000000100000000: n6883_o = 1'b0;
      23'b00000000000000010000000: n6883_o = 1'b0;
      23'b00000000000000001000000: n6883_o = 1'b0;
      23'b00000000000000000100000: n6883_o = 1'b0;
      23'b00000000000000000010000: n6883_o = 1'b0;
      23'b00000000000000000001000: n6883_o = 1'b0;
      23'b00000000000000000000100: n6883_o = 1'b0;
      23'b00000000000000000000010: n6883_o = 1'b0;
      23'b00000000000000000000001: n6883_o = 1'b0;
      default: n6883_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6886_o = 1'b0;
      23'b01000000000000000000000: n6886_o = 1'b0;
      23'b00100000000000000000000: n6886_o = 1'b0;
      23'b00010000000000000000000: n6886_o = 1'b0;
      23'b00001000000000000000000: n6886_o = n6496_o;
      23'b00000100000000000000000: n6886_o = 1'b0;
      23'b00000010000000000000000: n6886_o = 1'b0;
      23'b00000001000000000000000: n6886_o = 1'b0;
      23'b00000000100000000000000: n6886_o = 1'b0;
      23'b00000000010000000000000: n6886_o = 1'b0;
      23'b00000000001000000000000: n6886_o = 1'b0;
      23'b00000000000100000000000: n6886_o = 1'b0;
      23'b00000000000010000000000: n6886_o = 1'b0;
      23'b00000000000001000000000: n6886_o = 1'b0;
      23'b00000000000000100000000: n6886_o = 1'b0;
      23'b00000000000000010000000: n6886_o = 1'b0;
      23'b00000000000000001000000: n6886_o = 1'b0;
      23'b00000000000000000100000: n6886_o = 1'b0;
      23'b00000000000000000010000: n6886_o = 1'b0;
      23'b00000000000000000001000: n6886_o = 1'b0;
      23'b00000000000000000000100: n6886_o = 1'b0;
      23'b00000000000000000000010: n6886_o = 1'b0;
      23'b00000000000000000000001: n6886_o = 1'b0;
      default: n6886_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6889_o = 1'b0;
      23'b01000000000000000000000: n6889_o = 1'b0;
      23'b00100000000000000000000: n6889_o = 1'b0;
      23'b00010000000000000000000: n6889_o = 1'b0;
      23'b00001000000000000000000: n6889_o = n6499_o;
      23'b00000100000000000000000: n6889_o = 1'b0;
      23'b00000010000000000000000: n6889_o = 1'b0;
      23'b00000001000000000000000: n6889_o = 1'b0;
      23'b00000000100000000000000: n6889_o = 1'b0;
      23'b00000000010000000000000: n6889_o = 1'b0;
      23'b00000000001000000000000: n6889_o = 1'b0;
      23'b00000000000100000000000: n6889_o = 1'b0;
      23'b00000000000010000000000: n6889_o = 1'b0;
      23'b00000000000001000000000: n6889_o = 1'b0;
      23'b00000000000000100000000: n6889_o = 1'b0;
      23'b00000000000000010000000: n6889_o = n6049_o;
      23'b00000000000000001000000: n6889_o = n5991_o;
      23'b00000000000000000100000: n6889_o = 1'b0;
      23'b00000000000000000010000: n6889_o = 1'b0;
      23'b00000000000000000001000: n6889_o = 1'b0;
      23'b00000000000000000000100: n6889_o = 1'b0;
      23'b00000000000000000000010: n6889_o = 1'b0;
      23'b00000000000000000000001: n6889_o = 1'b0;
      default: n6889_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6892_o = 1'b0;
      23'b01000000000000000000000: n6892_o = 1'b0;
      23'b00100000000000000000000: n6892_o = 1'b0;
      23'b00010000000000000000000: n6892_o = 1'b0;
      23'b00001000000000000000000: n6892_o = n6502_o;
      23'b00000100000000000000000: n6892_o = 1'b0;
      23'b00000010000000000000000: n6892_o = 1'b0;
      23'b00000001000000000000000: n6892_o = 1'b0;
      23'b00000000100000000000000: n6892_o = 1'b0;
      23'b00000000010000000000000: n6892_o = 1'b0;
      23'b00000000001000000000000: n6892_o = 1'b0;
      23'b00000000000100000000000: n6892_o = 1'b0;
      23'b00000000000010000000000: n6892_o = 1'b0;
      23'b00000000000001000000000: n6892_o = 1'b0;
      23'b00000000000000100000000: n6892_o = 1'b0;
      23'b00000000000000010000000: n6892_o = n6052_o;
      23'b00000000000000001000000: n6892_o = n5994_o;
      23'b00000000000000000100000: n6892_o = 1'b0;
      23'b00000000000000000010000: n6892_o = 1'b0;
      23'b00000000000000000001000: n6892_o = 1'b0;
      23'b00000000000000000000100: n6892_o = 1'b0;
      23'b00000000000000000000010: n6892_o = 1'b0;
      23'b00000000000000000000001: n6892_o = 1'b0;
      default: n6892_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6899_o = 3'b000;
      23'b01000000000000000000000: n6899_o = 3'b000;
      23'b00100000000000000000000: n6899_o = 3'b000;
      23'b00010000000000000000000: n6899_o = 3'b000;
      23'b00001000000000000000000: n6899_o = 3'b000;
      23'b00000100000000000000000: n6899_o = 3'b000;
      23'b00000010000000000000000: n6899_o = 3'b000;
      23'b00000001000000000000000: n6899_o = 3'b000;
      23'b00000000100000000000000: n6899_o = 3'b000;
      23'b00000000010000000000000: n6899_o = 3'b000;
      23'b00000000001000000000000: n6899_o = 3'b000;
      23'b00000000000100000000000: n6899_o = 3'b000;
      23'b00000000000010000000000: n6899_o = 3'b000;
      23'b00000000000001000000000: n6899_o = 3'b000;
      23'b00000000000000100000000: n6899_o = 3'b000;
      23'b00000000000000010000000: n6899_o = 3'b000;
      23'b00000000000000001000000: n6899_o = 3'b000;
      23'b00000000000000000100000: n6899_o = 3'b111;
      23'b00000000000000000010000: n6899_o = 3'b110;
      23'b00000000000000000001000: n6899_o = 3'b101;
      23'b00000000000000000000100: n6899_o = 3'b100;
      23'b00000000000000000000010: n6899_o = 3'b000;
      23'b00000000000000000000001: n6899_o = 3'b000;
      default: n6899_o = 3'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6902_o = 1'b0;
      23'b01000000000000000000000: n6902_o = 1'b0;
      23'b00100000000000000000000: n6902_o = 1'b0;
      23'b00010000000000000000000: n6902_o = 1'b0;
      23'b00001000000000000000000: n6902_o = n6505_o;
      23'b00000100000000000000000: n6902_o = 1'b0;
      23'b00000010000000000000000: n6902_o = 1'b0;
      23'b00000001000000000000000: n6902_o = 1'b0;
      23'b00000000100000000000000: n6902_o = 1'b0;
      23'b00000000010000000000000: n6902_o = 1'b0;
      23'b00000000001000000000000: n6902_o = 1'b0;
      23'b00000000000100000000000: n6902_o = 1'b0;
      23'b00000000000010000000000: n6902_o = 1'b0;
      23'b00000000000001000000000: n6902_o = 1'b0;
      23'b00000000000000100000000: n6902_o = 1'b0;
      23'b00000000000000010000000: n6902_o = 1'b0;
      23'b00000000000000001000000: n6902_o = 1'b0;
      23'b00000000000000000100000: n6902_o = 1'b0;
      23'b00000000000000000010000: n6902_o = 1'b0;
      23'b00000000000000000001000: n6902_o = 1'b0;
      23'b00000000000000000000100: n6902_o = 1'b0;
      23'b00000000000000000000010: n6902_o = 1'b0;
      23'b00000000000000000000001: n6902_o = 1'b0;
      default: n6902_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6905_o = 1'b0;
      23'b01000000000000000000000: n6905_o = 1'b0;
      23'b00100000000000000000000: n6905_o = 1'b0;
      23'b00010000000000000000000: n6905_o = 1'b0;
      23'b00001000000000000000000: n6905_o = 1'b0;
      23'b00000100000000000000000: n6905_o = 1'b0;
      23'b00000010000000000000000: n6905_o = 1'b0;
      23'b00000001000000000000000: n6905_o = 1'b0;
      23'b00000000100000000000000: n6905_o = 1'b0;
      23'b00000000010000000000000: n6905_o = 1'b0;
      23'b00000000001000000000000: n6905_o = 1'b0;
      23'b00000000000100000000000: n6905_o = 1'b0;
      23'b00000000000010000000000: n6905_o = 1'b0;
      23'b00000000000001000000000: n6905_o = 1'b0;
      23'b00000000000000100000000: n6905_o = n6108_o;
      23'b00000000000000010000000: n6905_o = 1'b0;
      23'b00000000000000001000000: n6905_o = 1'b0;
      23'b00000000000000000100000: n6905_o = 1'b0;
      23'b00000000000000000010000: n6905_o = 1'b0;
      23'b00000000000000000001000: n6905_o = 1'b0;
      23'b00000000000000000000100: n6905_o = 1'b0;
      23'b00000000000000000000010: n6905_o = 1'b0;
      23'b00000000000000000000001: n6905_o = 1'b0;
      default: n6905_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6908_o = 1'b0;
      23'b01000000000000000000000: n6908_o = 1'b0;
      23'b00100000000000000000000: n6908_o = 1'b0;
      23'b00010000000000000000000: n6908_o = 1'b0;
      23'b00001000000000000000000: n6908_o = 1'b0;
      23'b00000100000000000000000: n6908_o = 1'b0;
      23'b00000010000000000000000: n6908_o = 1'b0;
      23'b00000001000000000000000: n6908_o = 1'b0;
      23'b00000000100000000000000: n6908_o = 1'b0;
      23'b00000000010000000000000: n6908_o = 1'b0;
      23'b00000000001000000000000: n6908_o = 1'b0;
      23'b00000000000100000000000: n6908_o = 1'b0;
      23'b00000000000010000000000: n6908_o = 1'b0;
      23'b00000000000001000000000: n6908_o = n6166_o;
      23'b00000000000000100000000: n6908_o = 1'b0;
      23'b00000000000000010000000: n6908_o = 1'b0;
      23'b00000000000000001000000: n6908_o = 1'b0;
      23'b00000000000000000100000: n6908_o = 1'b0;
      23'b00000000000000000010000: n6908_o = 1'b0;
      23'b00000000000000000001000: n6908_o = 1'b0;
      23'b00000000000000000000100: n6908_o = 1'b0;
      23'b00000000000000000000010: n6908_o = 1'b0;
      23'b00000000000000000000001: n6908_o = 1'b0;
      default: n6908_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6911_o = n6754_o;
      23'b01000000000000000000000: n6911_o = n6684_o;
      23'b00100000000000000000000: n6911_o = 1'b0;
      23'b00010000000000000000000: n6911_o = 1'b0;
      23'b00001000000000000000000: n6911_o = 1'b0;
      23'b00000100000000000000000: n6911_o = 1'b0;
      23'b00000010000000000000000: n6911_o = 1'b0;
      23'b00000001000000000000000: n6911_o = 1'b0;
      23'b00000000100000000000000: n6911_o = 1'b0;
      23'b00000000010000000000000: n6911_o = 1'b0;
      23'b00000000001000000000000: n6911_o = 1'b0;
      23'b00000000000100000000000: n6911_o = 1'b0;
      23'b00000000000010000000000: n6911_o = 1'b0;
      23'b00000000000001000000000: n6911_o = 1'b0;
      23'b00000000000000100000000: n6911_o = 1'b0;
      23'b00000000000000010000000: n6911_o = 1'b0;
      23'b00000000000000001000000: n6911_o = 1'b0;
      23'b00000000000000000100000: n6911_o = 1'b0;
      23'b00000000000000000010000: n6911_o = 1'b0;
      23'b00000000000000000001000: n6911_o = 1'b0;
      23'b00000000000000000000100: n6911_o = 1'b0;
      23'b00000000000000000000010: n6911_o = 1'b0;
      23'b00000000000000000000001: n6911_o = 1'b0;
      default: n6911_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6914_o = 1'b0;
      23'b01000000000000000000000: n6914_o = 1'b0;
      23'b00100000000000000000000: n6914_o = 1'b0;
      23'b00010000000000000000000: n6914_o = 1'b0;
      23'b00001000000000000000000: n6914_o = 1'b0;
      23'b00000100000000000000000: n6914_o = 1'b0;
      23'b00000010000000000000000: n6914_o = n6428_o;
      23'b00000001000000000000000: n6914_o = 1'b0;
      23'b00000000100000000000000: n6914_o = 1'b0;
      23'b00000000010000000000000: n6914_o = 1'b0;
      23'b00000000001000000000000: n6914_o = 1'b0;
      23'b00000000000100000000000: n6914_o = 1'b0;
      23'b00000000000010000000000: n6914_o = 1'b0;
      23'b00000000000001000000000: n6914_o = 1'b0;
      23'b00000000000000100000000: n6914_o = 1'b0;
      23'b00000000000000010000000: n6914_o = 1'b0;
      23'b00000000000000001000000: n6914_o = 1'b0;
      23'b00000000000000000100000: n6914_o = 1'b0;
      23'b00000000000000000010000: n6914_o = 1'b0;
      23'b00000000000000000001000: n6914_o = 1'b0;
      23'b00000000000000000000100: n6914_o = 1'b0;
      23'b00000000000000000000010: n6914_o = 1'b0;
      23'b00000000000000000000001: n6914_o = 1'b0;
      default: n6914_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6917_o = 1'b0;
      23'b01000000000000000000000: n6917_o = 1'b0;
      23'b00100000000000000000000: n6917_o = 1'b0;
      23'b00010000000000000000000: n6917_o = 1'b0;
      23'b00001000000000000000000: n6917_o = 1'b0;
      23'b00000100000000000000000: n6917_o = n6469_o;
      23'b00000010000000000000000: n6917_o = 1'b0;
      23'b00000001000000000000000: n6917_o = 1'b0;
      23'b00000000100000000000000: n6917_o = 1'b0;
      23'b00000000010000000000000: n6917_o = 1'b0;
      23'b00000000001000000000000: n6917_o = 1'b0;
      23'b00000000000100000000000: n6917_o = 1'b0;
      23'b00000000000010000000000: n6917_o = 1'b0;
      23'b00000000000001000000000: n6917_o = 1'b0;
      23'b00000000000000100000000: n6917_o = 1'b0;
      23'b00000000000000010000000: n6917_o = 1'b0;
      23'b00000000000000001000000: n6917_o = 1'b0;
      23'b00000000000000000100000: n6917_o = 1'b0;
      23'b00000000000000000010000: n6917_o = 1'b0;
      23'b00000000000000000001000: n6917_o = 1'b0;
      23'b00000000000000000000100: n6917_o = 1'b0;
      23'b00000000000000000000010: n6917_o = 1'b0;
      23'b00000000000000000000001: n6917_o = 1'b0;
      default: n6917_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6920_o = 1'b0;
      23'b01000000000000000000000: n6920_o = 1'b0;
      23'b00100000000000000000000: n6920_o = 1'b0;
      23'b00010000000000000000000: n6920_o = n6556_o;
      23'b00001000000000000000000: n6920_o = 1'b0;
      23'b00000100000000000000000: n6920_o = 1'b0;
      23'b00000010000000000000000: n6920_o = 1'b0;
      23'b00000001000000000000000: n6920_o = 1'b0;
      23'b00000000100000000000000: n6920_o = 1'b0;
      23'b00000000010000000000000: n6920_o = 1'b0;
      23'b00000000001000000000000: n6920_o = 1'b0;
      23'b00000000000100000000000: n6920_o = 1'b0;
      23'b00000000000010000000000: n6920_o = 1'b0;
      23'b00000000000001000000000: n6920_o = 1'b0;
      23'b00000000000000100000000: n6920_o = 1'b0;
      23'b00000000000000010000000: n6920_o = 1'b0;
      23'b00000000000000001000000: n6920_o = 1'b0;
      23'b00000000000000000100000: n6920_o = 1'b0;
      23'b00000000000000000010000: n6920_o = 1'b0;
      23'b00000000000000000001000: n6920_o = 1'b0;
      23'b00000000000000000000100: n6920_o = 1'b0;
      23'b00000000000000000000010: n6920_o = 1'b0;
      23'b00000000000000000000001: n6920_o = 1'b0;
      default: n6920_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6923_o = n6757_o;
      23'b01000000000000000000000: n6923_o = n6687_o;
      23'b00100000000000000000000: n6923_o = n6608_o;
      23'b00010000000000000000000: n6923_o = n6559_o;
      23'b00001000000000000000000: n6923_o = 2'b00;
      23'b00000100000000000000000: n6923_o = 2'b00;
      23'b00000010000000000000000: n6923_o = 2'b00;
      23'b00000001000000000000000: n6923_o = n6380_o;
      23'b00000000100000000000000: n6923_o = n6295_o;
      23'b00000000010000000000000: n6923_o = 2'b00;
      23'b00000000001000000000000: n6923_o = 2'b00;
      23'b00000000000100000000000: n6923_o = 2'b00;
      23'b00000000000010000000000: n6923_o = 2'b00;
      23'b00000000000001000000000: n6923_o = 2'b00;
      23'b00000000000000100000000: n6923_o = 2'b00;
      23'b00000000000000010000000: n6923_o = 2'b00;
      23'b00000000000000001000000: n6923_o = 2'b00;
      23'b00000000000000000100000: n6923_o = 2'b00;
      23'b00000000000000000010000: n6923_o = 2'b00;
      23'b00000000000000000001000: n6923_o = 2'b00;
      23'b00000000000000000000100: n6923_o = 2'b00;
      23'b00000000000000000000010: n6923_o = 2'b00;
      23'b00000000000000000000001: n6923_o = 2'b00;
      default: n6923_o = 2'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6929_o = 2'b11;
      23'b01000000000000000000000: n6929_o = 2'b11;
      23'b00100000000000000000000: n6929_o = 2'b11;
      23'b00010000000000000000000: n6929_o = 2'b11;
      23'b00001000000000000000000: n6929_o = 2'b11;
      23'b00000100000000000000000: n6929_o = 2'b11;
      23'b00000010000000000000000: n6929_o = 2'b11;
      23'b00000001000000000000000: n6929_o = 2'b11;
      23'b00000000100000000000000: n6929_o = 2'b11;
      23'b00000000010000000000000: n6929_o = 2'b10;
      23'b00000000001000000000000: n6929_o = 2'b01;
      23'b00000000000100000000000: n6929_o = 2'b00;
      23'b00000000000010000000000: n6929_o = 2'b11;
      23'b00000000000001000000000: n6929_o = 2'b11;
      23'b00000000000000100000000: n6929_o = 2'b11;
      23'b00000000000000010000000: n6929_o = 2'b11;
      23'b00000000000000001000000: n6929_o = 2'b11;
      23'b00000000000000000100000: n6929_o = 2'b11;
      23'b00000000000000000010000: n6929_o = 2'b11;
      23'b00000000000000000001000: n6929_o = 2'b11;
      23'b00000000000000000000100: n6929_o = 2'b11;
      23'b00000000000000000000010: n6929_o = 2'b11;
      23'b00000000000000000000001: n6929_o = 2'b11;
      default: n6929_o = 2'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6932_o = n6760_o;
      23'b01000000000000000000000: n6932_o = n6690_o;
      23'b00100000000000000000000: n6932_o = 1'b0;
      23'b00010000000000000000000: n6932_o = 1'b0;
      23'b00001000000000000000000: n6932_o = 1'b0;
      23'b00000100000000000000000: n6932_o = n6472_o;
      23'b00000010000000000000000: n6932_o = n6431_o;
      23'b00000001000000000000000: n6932_o = n6384_o;
      23'b00000000100000000000000: n6932_o = n6299_o;
      23'b00000000010000000000000: n6932_o = 1'b0;
      23'b00000000001000000000000: n6932_o = 1'b0;
      23'b00000000000100000000000: n6932_o = 1'b0;
      23'b00000000000010000000000: n6932_o = 1'b0;
      23'b00000000000001000000000: n6932_o = n6170_o;
      23'b00000000000000100000000: n6932_o = n6111_o;
      23'b00000000000000010000000: n6932_o = 1'b0;
      23'b00000000000000001000000: n6932_o = 1'b0;
      23'b00000000000000000100000: n6932_o = 1'b0;
      23'b00000000000000000010000: n6932_o = 1'b0;
      23'b00000000000000000001000: n6932_o = 1'b0;
      23'b00000000000000000000100: n6932_o = 1'b0;
      23'b00000000000000000000010: n6932_o = 1'b0;
      23'b00000000000000000000001: n6932_o = 1'b0;
      default: n6932_o = 1'bX;
    endcase
  /* ./T80/T80_MCode.vhd:1573:25  */
  always @*
    case (n6775_o)
      23'b10000000000000000000000: n6935_o = n6763_o;
      23'b01000000000000000000000: n6935_o = n6693_o;
      23'b00100000000000000000000: n6935_o = n6611_o;
      23'b00010000000000000000000: n6935_o = 1'b0;
      23'b00001000000000000000000: n6935_o = 1'b0;
      23'b00000100000000000000000: n6935_o = n6475_o;
      23'b00000010000000000000000: n6935_o = n6434_o;
      23'b00000001000000000000000: n6935_o = 1'b0;
      23'b00000000100000000000000: n6935_o = 1'b0;
      23'b00000000010000000000000: n6935_o = 1'b0;
      23'b00000000001000000000000: n6935_o = 1'b0;
      23'b00000000000100000000000: n6935_o = 1'b0;
      23'b00000000000010000000000: n6935_o = 1'b0;
      23'b00000000000001000000000: n6935_o = 1'b0;
      23'b00000000000000100000000: n6935_o = n6114_o;
      23'b00000000000000010000000: n6935_o = n6056_o;
      23'b00000000000000001000000: n6935_o = 1'b0;
      23'b00000000000000000100000: n6935_o = 1'b0;
      23'b00000000000000000010000: n6935_o = 1'b0;
      23'b00000000000000000001000: n6935_o = 1'b0;
      23'b00000000000000000000100: n6935_o = 1'b0;
      23'b00000000000000000000010: n6935_o = 1'b0;
      23'b00000000000000000000001: n6935_o = 1'b0;
      default: n6935_o = 1'bX;
    endcase
  assign n6936_o = {n5397_o, n4309_o};
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6937_o = n5375_o;
      2'b01: n6937_o = n4071_o;
      default: n6937_o = n6791_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6939_o = n5377_o;
      2'b01: n6939_o = n4076_o;
      default: n6939_o = n6797_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6941_o = 2'b00;
      2'b01: n6941_o = n4082_o;
      default: n6941_o = 2'b00;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6944_o = 1'b0;
      2'b01: n6944_o = n4085_o;
      default: n6944_o = n6800_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6947_o = 1'b0;
      2'b01: n6947_o = n4088_o;
      default: n6947_o = n6803_o;
    endcase
  assign n6949_o = n6809_o[1:0];
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6951_o = 2'b00;
      2'b01: n6951_o = n4100_o;
      default: n6951_o = n6949_o;
    endcase
  assign n6952_o = n4112_o[0];
  assign n6953_o = n6809_o[2];
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6955_o = 1'b0;
      2'b01: n6955_o = n6952_o;
      default: n6955_o = n6953_o;
    endcase
  assign n6956_o = n4112_o[1];
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6958_o = 1'b0;
      2'b01: n6958_o = n6956_o;
      default: n6958_o = n6815_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6962_o = n5380_o;
      2'b01: n6962_o = n4121_o;
      default: n6962_o = n6818_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6965_o = 1'b0;
      2'b01: n6965_o = n4124_o;
      default: n6965_o = n6822_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6967_o = n4310_o;
      2'b01: n6967_o = n4128_o;
      default: n6967_o = n6828_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6969_o = 1'b0;
      2'b01: n6969_o = n4132_o;
      default: n6969_o = n6834_o;
    endcase
  assign n6972_o = n5382_o[0];
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6973_o = n6972_o;
      2'b01: n6973_o = n4157_o;
      default: n6973_o = n6846_o;
    endcase
  assign n6974_o = n5382_o[2:1];
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6975_o = n6974_o;
      2'b01: n6975_o = n4182_o;
      default: n6975_o = n6858_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6977_o = 1'b0;
      2'b01: n6977_o = n4201_o;
      default: n6977_o = n6867_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6981_o = n5384_o;
      2'b01: n6981_o = n4207_o;
      default: n6981_o = n6870_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6982_o = n5387_o;
      2'b01: n6982_o = n4215_o;
      default: n6982_o = n6874_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6985_o = 1'b0;
      2'b01: n6985_o = n4220_o;
      default: n6985_o = n6877_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6988_o = 1'b0;
      2'b01: n6988_o = n4223_o;
      default: n6988_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6990_o = n5389_o;
      2'b01: n6990_o = n4226_o;
      default: n6990_o = n6880_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6993_o = 1'b0;
      2'b01: n6993_o = n4229_o;
      default: n6993_o = n6883_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6996_o = 1'b0;
      2'b01: n6996_o = n4232_o;
      default: n6996_o = n6886_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n6999_o = 1'b0;
      2'b01: n6999_o = n4235_o;
      default: n6999_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7002_o = 1'b0;
      2'b01: n7002_o = n4239_o;
      default: n7002_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7005_o = 1'b0;
      2'b01: n7005_o = n4242_o;
      default: n7005_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7008_o = 1'b0;
      2'b01: n7008_o = n4245_o;
      default: n7008_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7011_o = 1'b0;
      2'b01: n7011_o = n4248_o;
      default: n7011_o = n6889_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7014_o = 1'b0;
      2'b01: n7014_o = n4251_o;
      default: n7014_o = n6892_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7017_o = 1'b0;
      2'b01: n7017_o = n4255_o;
      default: n7017_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7020_o = 3'b000;
      2'b01: n7020_o = 3'b000;
      default: n7020_o = n6899_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7023_o = 1'b0;
      2'b01: n7023_o = n4259_o;
      default: n7023_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7026_o = 1'b0;
      2'b01: n7026_o = n4263_o;
      default: n7026_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7029_o = 1'b0;
      2'b01: n7029_o = n4267_o;
      default: n7029_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7032_o = 1'b0;
      2'b01: n7032_o = n4271_o;
      default: n7032_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7035_o = 1'b0;
      2'b01: n7035_o = n4274_o;
      default: n7035_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7038_o = 1'b0;
      2'b01: n7038_o = n4278_o;
      default: n7038_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7041_o = 1'b0;
      2'b01: n7041_o = n4282_o;
      default: n7041_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7044_o = 1'b0;
      2'b01: n7044_o = n4286_o;
      default: n7044_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7047_o = 1'b0;
      2'b01: n7047_o = 1'b0;
      default: n7047_o = n6902_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7050_o = 1'b0;
      2'b01: n7050_o = 1'b0;
      default: n7050_o = n6905_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7053_o = 1'b0;
      2'b01: n7053_o = 1'b0;
      default: n7053_o = n6908_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7056_o = 1'b0;
      2'b01: n7056_o = 1'b0;
      default: n7056_o = n6911_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7059_o = 1'b0;
      2'b01: n7059_o = 1'b0;
      default: n7059_o = n6914_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7062_o = 1'b0;
      2'b01: n7062_o = 1'b0;
      default: n7062_o = n6917_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7065_o = 1'b0;
      2'b01: n7065_o = 1'b0;
      default: n7065_o = n6920_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7068_o = 2'b00;
      2'b01: n7068_o = n4289_o;
      default: n7068_o = n6923_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7071_o = 1'b0;
      2'b01: n7071_o = n4293_o;
      default: n7071_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7074_o = 1'b0;
      2'b01: n7074_o = n4297_o;
      default: n7074_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7077_o = 2'b11;
      2'b01: n7077_o = 2'b11;
      default: n7077_o = n6929_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7080_o = 1'b0;
      2'b01: n7080_o = n4301_o;
      default: n7080_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7083_o = 1'b0;
      2'b01: n7083_o = n4304_o;
      default: n7083_o = n6932_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7085_o = n5392_o;
      2'b01: n7085_o = n4307_o;
      default: n7085_o = n6935_o;
    endcase
  /* ./T80/T80_MCode.vhd:256:17  */
  always @*
    case (n6936_o)
      2'b10: n7088_o = n5395_o;
      2'b01: n7088_o = 1'b0;
      default: n7088_o = 1'b0;
    endcase
  /* ./T80/T80_MCode.vhd:2003:35  */
  assign n7091_o = mcycle == 3'b110;
  /* ./T80/T80_MCode.vhd:2011:40  */
  assign n7093_o = ir == 8'b00110110;
  /* ./T80/T80_MCode.vhd:2011:60  */
  assign n7095_o = ir == 8'b11001011;
  /* ./T80/T80_MCode.vhd:2011:53  */
  assign n7096_o = n7093_o | n7095_o;
  /* ./T80/T80_MCode.vhd:2003:25  */
  assign n7098_o = n7101_o ? 3'b111 : n6990_o;
  /* ./T80/T80_MCode.vhd:2003:25  */
  assign n7100_o = n7091_o ? 1'b1 : n6944_o;
  /* ./T80/T80_MCode.vhd:2003:25  */
  assign n7101_o = n7096_o & n7091_o;
  /* ./T80/T80_MCode.vhd:2015:35  */
  assign n7103_o = mcycle == 3'b111;
  /* ./T80/T80_MCode.vhd:2019:41  */
  assign n7105_o = iset != 2'b01;
  /* ./T80/T80_MCode.vhd:2015:25  */
  assign n7107_o = n7124_o ? 3'b010 : n7098_o;
  /* ./T80/T80_MCode.vhd:2024:40  */
  assign n7110_o = ir == 8'b00110110;
  /* ./T80/T80_MCode.vhd:2024:61  */
  assign n7112_o = iset == 2'b01;
  /* ./T80/T80_MCode.vhd:2024:53  */
  assign n7113_o = n7110_o | n7112_o;
  /* ./T80/T80_MCode.vhd:2015:25  */
  assign n7115_o = n7120_o ? 1'b1 : n7100_o;
  /* ./T80/T80_MCode.vhd:2024:33  */
  assign n7117_o = n7113_o ? n7083_o : 1'b1;
  /* ./T80/T80_MCode.vhd:2015:25  */
  assign n7119_o = n7103_o ? 3'b101 : n6939_o;
  /* ./T80/T80_MCode.vhd:2015:25  */
  assign n7120_o = n7113_o & n7103_o;
  assign n7121_o = {1'b0, n2109_o};
  assign n7122_o = {n6977_o, n6975_o, n6973_o};
  /* ./T80/T80_MCode.vhd:2015:25  */
  assign n7123_o = n7103_o ? n7121_o : n7122_o;
  /* ./T80/T80_MCode.vhd:2015:25  */
  assign n7124_o = n7105_o & n7103_o;
  /* ./T80/T80_MCode.vhd:2015:25  */
  assign n7125_o = n7103_o ? n7117_o : n7083_o;
  assign n7127_o = {n6958_o, n6955_o, n6951_o};
  assign n7128_o = {n6969_o, n6967_o};
endmodule

module t80_0_1_0_1_2_3_4_5_6_7
  (input  reset_n,
   input  clk_n,
   input  cen,
   input  wait_n,
   input  int_n,
   input  nmi_n,
   input  busrq_n,
   input  [7:0] dinst,
   input  [7:0] di,
   input  out0,
   input  dirset,
   input  [229:0] dir,
   output m1_n,
   output iorq,
   output noread,
   output write,
   output rfsh_n,
   output halt_n,
   output busak_n,
   output [15:0] a,
   output [7:0] do,
   output [2:0] mc,
   output [2:0] ts,
   output intcycle_n,
   output inte,
   output stop,
   output [229:0] \reg ,
   output [1:0] iset_out);
  wire [7:0] acc;
  wire [7:0] f;
  wire [7:0] ap;
  wire [7:0] fp;
  wire [7:0] i;
  wire [7:0] r;
  wire [15:0] sp;
  wire [15:0] pc;
  wire [7:0] regdih;
  wire [7:0] regdil;
  wire [15:0] regbusa;
  wire [15:0] regbusb;
  wire [15:0] regbusc;
  wire [2:0] regaddra_r;
  wire [2:0] regaddra;
  wire [2:0] regaddrb_r;
  wire [2:0] regaddrb;
  wire [2:0] regaddrc;
  wire regweh;
  wire regwel;
  wire alternate;
  wire [15:0] wz;
  wire [7:0] ir;
  wire [1:0] iset;
  wire [15:0] regbusa_r;
  wire [15:0] id16;
  wire [7:0] save_mux;
  wire [2:0] tstate;
  wire [2:0] mcycle;
  wire inte_ff1;
  wire inte_ff2;
  wire halt_ff;
  wire busreq_s;
  wire busack;
  wire clken;
  wire nmi_s;
  wire [1:0] istatus;
  wire [7:0] di_reg;
  wire t_res;
  wire [1:0] xy_state;
  wire [2:0] pre_xy_f_m;
  wire nextis_xy_fetch;
  wire xy_ind;
  wire no_btr;
  wire btr_r;
  wire auto_wait;
  wire auto_wait_t1;
  wire auto_wait_t2;
  wire incdecz;
  wire [7:0] busb;
  wire [7:0] busa;
  wire [7:0] alu_q;
  wire [7:0] f_out;
  wire [4:0] read_to_reg_r;
  wire arith16_r;
  wire z16_r;
  wire [3:0] alu_op_r;
  wire save_alu_r;
  wire preservec_r;
  wire [2:0] mcycles;
  wire [2:0] mcycles_d;
  wire [2:0] tstates;
  wire intcycle;
  wire nmicycle;
  wire inc_pc;
  wire inc_wz;
  wire [3:0] incdec_16;
  wire [1:0] prefix;
  wire read_to_acc;
  wire read_to_reg;
  wire [3:0] set_busb_to;
  wire [3:0] set_busa_to;
  wire [3:0] alu_op;
  wire save_alu;
  wire preservec;
  wire arith16;
  wire [2:0] set_addr_to;
  wire jump;
  wire jumpe;
  wire jumpxy;
  wire call;
  wire rstp;
  wire ldz;
  wire ldw;
  wire ldsphl;
  wire iorq_i;
  wire [2:0] special_ld;
  wire exchangedh;
  wire exchangerp;
  wire exchangeaf;
  wire exchangers;
  wire i_djnz;
  wire i_cpl;
  wire i_ccf;
  wire i_scf;
  wire i_retn;
  wire i_bt;
  wire i_bc;
  wire i_btr;
  wire i_rld;
  wire i_rrd;
  wire i_rxdd;
  wire i_inrc;
  wire [1:0] setwz;
  wire setdi;
  wire setei;
  wire [1:0] imode;
  wire halt;
  wire xybit_undoc;
  wire [127:0] dor;
  wire [127:0] regdir;
  wire [1:0] n148_o;
  wire [17:0] n149_o;
  wire [18:0] n150_o;
  wire [19:0] n151_o;
  wire [21:0] n152_o;
  wire [149:0] n153_o;
  wire [165:0] n154_o;
  wire [181:0] n155_o;
  wire [189:0] n156_o;
  wire [197:0] n157_o;
  wire [205:0] n158_o;
  wire [213:0] n159_o;
  wire [221:0] n160_o;
  wire [229:0] n161_o;
  wire n162_o;
  wire [229:0] n163_o;
  wire [1:0] n164_o;
  wire [17:0] n165_o;
  wire [18:0] n166_o;
  wire [19:0] n167_o;
  wire [21:0] n168_o;
  wire [15:0] n169_o;
  wire [37:0] n170_o;
  wire [47:0] n171_o;
  wire [85:0] n172_o;
  wire [15:0] n173_o;
  wire [101:0] n174_o;
  wire [47:0] n175_o;
  wire [149:0] n176_o;
  wire [165:0] n177_o;
  wire [181:0] n178_o;
  wire [189:0] n179_o;
  wire [197:0] n180_o;
  wire [205:0] n181_o;
  wire [213:0] n182_o;
  wire [221:0] n183_o;
  wire [229:0] n184_o;
  wire [127:0] n185_o;
  wire n186_o;
  wire n187_o;
  wire [127:0] n188_o;
  wire [15:0] n189_o;
  wire [15:0] n190_o;
  wire [31:0] n191_o;
  wire [15:0] n192_o;
  wire [47:0] n193_o;
  wire [15:0] n194_o;
  wire [63:0] n195_o;
  wire [15:0] n196_o;
  wire [79:0] n197_o;
  wire [15:0] n198_o;
  wire [95:0] n199_o;
  wire [15:0] n200_o;
  wire [111:0] n201_o;
  wire [15:0] n202_o;
  wire [127:0] n203_o;
  wire [2:0] mcode_mcycles;
  wire [2:0] mcode_tstates;
  wire [1:0] mcode_prefix;
  wire mcode_inc_pc;
  wire mcode_inc_wz;
  wire [3:0] mcode_incdec_16;
  wire mcode_read_to_reg;
  wire mcode_read_to_acc;
  wire [3:0] mcode_set_busa_to;
  wire [3:0] mcode_set_busb_to;
  wire [3:0] mcode_alu_op;
  wire mcode_save_alu;
  wire mcode_preservec;
  wire mcode_arith16;
  wire [2:0] mcode_set_addr_to;
  wire mcode_iorq;
  wire mcode_jump;
  wire mcode_jumpe;
  wire mcode_jumpxy;
  wire mcode_call;
  wire mcode_rstp;
  wire mcode_ldz;
  wire mcode_ldw;
  wire mcode_ldsphl;
  wire [2:0] mcode_special_ld;
  wire mcode_exchangedh;
  wire mcode_exchangerp;
  wire mcode_exchangeaf;
  wire mcode_exchangers;
  wire mcode_i_djnz;
  wire mcode_i_cpl;
  wire mcode_i_ccf;
  wire mcode_i_scf;
  wire mcode_i_retn;
  wire mcode_i_bt;
  wire mcode_i_bc;
  wire mcode_i_btr;
  wire mcode_i_rld;
  wire mcode_i_rrd;
  wire mcode_i_inrc;
  wire [1:0] mcode_setwz;
  wire mcode_setdi;
  wire mcode_setei;
  wire [1:0] mcode_imode;
  wire mcode_halt;
  wire mcode_noread;
  wire mcode_write;
  wire mcode_xybit_undoc;
  wire [7:0] alu_q;
  wire [7:0] alu_f_out;
  wire [5:0] n252_o;
  wire n255_o;
  wire n256_o;
  wire n258_o;
  wire n259_o;
  wire n263_o;
  wire n264_o;
  wire n265_o;
  wire n267_o;
  wire n269_o;
  wire n271_o;
  wire n272_o;
  wire n273_o;
  wire n275_o;
  wire n277_o;
  wire n278_o;
  wire n279_o;
  wire n280_o;
  wire n281_o;
  wire [7:0] n283_o;
  wire n284_o;
  wire [7:0] n285_o;
  wire n290_o;
  wire [7:0] n292_o;
  wire [7:0] n293_o;
  wire [7:0] n294_o;
  wire [7:0] n295_o;
  wire [7:0] n296_o;
  wire [7:0] n297_o;
  wire [15:0] n298_o;
  wire [15:0] n299_o;
  wire [15:0] n300_o;
  wire [15:0] n301_o;
  wire [1:0] n302_o;
  wire n303_o;
  wire n305_o;
  wire [1:0] n306_o;
  wire n308_o;
  wire n309_o;
  wire n310_o;
  wire n311_o;
  wire n312_o;
  wire n313_o;
  wire n315_o;
  wire n316_o;
  wire n319_o;
  wire n321_o;
  wire n322_o;
  wire n323_o;
  wire n324_o;
  wire n326_o;
  wire n327_o;
  wire [6:0] n328_o;
  wire [6:0] n330_o;
  wire n331_o;
  wire n332_o;
  wire n333_o;
  wire n334_o;
  wire n335_o;
  wire n336_o;
  wire n337_o;
  wire n338_o;
  wire n339_o;
  wire n340_o;
  wire [15:0] n342_o;
  wire [15:0] n343_o;
  wire n345_o;
  wire n346_o;
  wire n348_o;
  wire n349_o;
  wire n350_o;
  wire n351_o;
  wire [7:0] n353_o;
  wire [7:0] n355_o;
  wire n357_o;
  wire n359_o;
  wire n360_o;
  wire [1:0] n363_o;
  wire n365_o;
  wire [1:0] n367_o;
  wire n369_o;
  wire [1:0] n371_o;
  wire [1:0] n372_o;
  wire n373_o;
  wire [1:0] n375_o;
  wire [1:0] n378_o;
  wire n380_o;
  wire [15:0] n381_o;
  wire [15:0] n382_o;
  wire [6:0] n383_o;
  wire [6:0] n384_o;
  wire n385_o;
  wire [7:0] n386_o;
  wire [1:0] n387_o;
  wire [1:0] n388_o;
  wire n389_o;
  wire n391_o;
  wire n393_o;
  wire [1:0] n395_o;
  wire n396_o;
  wire n398_o;
  wire n399_o;
  wire n400_o;
  wire n401_o;
  wire n402_o;
  wire [7:0] n403_o;
  wire [7:0] n404_o;
  wire n405_o;
  wire n406_o;
  wire n407_o;
  wire n409_o;
  wire n410_o;
  wire n412_o;
  wire n413_o;
  wire [7:0] n414_o;
  wire [7:0] n415_o;
  wire n417_o;
  wire [15:0] n418_o;
  wire [15:0] n419_o;
  wire n421_o;
  wire [15:0] n422_o;
  wire [15:0] n425_o;
  wire n427_o;
  wire n429_o;
  wire n431_o;
  wire [15:0] n434_o;
  wire [15:0] n435_o;
  wire n437_o;
  wire [7:0] n438_o;
  wire [7:0] n441_o;
  wire [15:0] n442_o;
  wire [15:0] n443_o;
  wire n445_o;
  wire n447_o;
  wire [7:0] n448_o;
  wire [7:0] n451_o;
  wire [15:0] n452_o;
  wire [15:0] n453_o;
  wire n455_o;
  wire [15:0] n457_o;
  wire [7:0] n458_o;
  wire n460_o;
  wire [7:0] n461_o;
  wire [7:0] n464_o;
  wire [15:0] n465_o;
  wire [15:0] n466_o;
  wire [15:0] n467_o;
  wire [15:0] n468_o;
  wire [15:0] n469_o;
  wire n471_o;
  wire [5:0] n472_o;
  wire [7:0] n473_o;
  wire [7:0] n474_o;
  wire [7:0] n475_o;
  wire [7:0] n476_o;
  wire [7:0] n477_o;
  wire [7:0] n478_o;
  reg [7:0] n479_o;
  wire [7:0] n480_o;
  wire [7:0] n481_o;
  wire [7:0] n482_o;
  wire [7:0] n483_o;
  wire [7:0] n484_o;
  wire [7:0] n485_o;
  reg [7:0] n486_o;
  reg [15:0] n487_o;
  wire [15:0] n488_o;
  wire [15:0] n489_o;
  wire [15:0] n490_o;
  wire [15:0] n491_o;
  wire [15:0] n492_o;
  wire [15:0] n493_o;
  wire [15:0] n495_o;
  wire [15:0] n497_o;
  wire [15:0] n498_o;
  wire [15:0] n499_o;
  wire [15:0] n500_o;
  wire [15:0] n501_o;
  wire [15:0] n502_o;
  wire [15:0] n503_o;
  wire [15:0] n504_o;
  wire [15:0] n505_o;
  wire [15:0] n506_o;
  wire [15:0] n507_o;
  wire [15:0] n508_o;
  wire [15:0] n509_o;
  wire n511_o;
  wire [15:0] n512_o;
  wire [7:0] n513_o;
  wire n514_o;
  wire n515_o;
  wire n517_o;
  wire n518_o;
  wire [7:0] n520_o;
  wire [2:0] n521_o;
  wire n522_o;
  wire n523_o;
  wire n526_o;
  wire n527_o;
  wire n528_o;
  wire n529_o;
  wire n530_o;
  wire [1:0] n532_o;
  wire [2:0] n533_o;
  wire n534_o;
  wire [1:0] n535_o;
  wire [1:0] n536_o;
  wire n539_o;
  wire n541_o;
  wire [1:0] n543_o;
  wire [2:0] n544_o;
  wire [1:0] n545_o;
  wire [15:0] n547_o;
  wire n548_o;
  wire [1:0] n549_o;
  wire [1:0] n550_o;
  wire [15:0] n553_o;
  wire [15:0] n554_o;
  wire n555_o;
  wire [3:0] n557_o;
  wire n559_o;
  wire n561_o;
  wire n562_o;
  wire n563_o;
  wire n564_o;
  wire n566_o;
  wire n567_o;
  wire n568_o;
  wire n569_o;
  wire n570_o;
  wire n571_o;
  wire [8:0] n573_o;
  wire [7:0] n574_o;
  wire [8:0] n576_o;
  wire [8:0] n577_o;
  wire n578_o;
  wire n579_o;
  wire n580_o;
  wire [8:0] n582_o;
  wire [8:0] n584_o;
  wire [8:0] n585_o;
  wire n586_o;
  wire n587_o;
  wire n588_o;
  wire n589_o;
  wire n590_o;
  wire n591_o;
  wire n592_o;
  wire n593_o;
  wire n594_o;
  wire n595_o;
  wire n596_o;
  wire n597_o;
  wire n598_o;
  wire n599_o;
  wire n600_o;
  wire n601_o;
  wire [2:0] n602_o;
  wire n603_o;
  wire [2:0] n604_o;
  wire [2:0] n605_o;
  wire n606_o;
  wire n607_o;
  wire n608_o;
  wire n609_o;
  wire n610_o;
  wire n611_o;
  wire n612_o;
  wire n613_o;
  wire n614_o;
  wire n615_o;
  wire n616_o;
  wire n617_o;
  wire n618_o;
  wire n619_o;
  wire n620_o;
  wire n621_o;
  wire n622_o;
  wire n623_o;
  wire n624_o;
  wire n625_o;
  wire n626_o;
  wire n627_o;
  wire n628_o;
  wire n629_o;
  wire n630_o;
  wire n631_o;
  wire n632_o;
  wire n633_o;
  wire n636_o;
  wire n637_o;
  wire n639_o;
  wire n641_o;
  wire n642_o;
  wire [7:0] n643_o;
  wire [15:0] n644_o;
  wire [15:0] n645_o;
  wire [15:0] n646_o;
  wire [15:0] n647_o;
  wire [15:0] n649_o;
  wire [15:0] n650_o;
  wire [15:0] n651_o;
  wire [15:0] n652_o;
  wire [15:0] n654_o;
  wire [15:0] n655_o;
  wire [2:0] n656_o;
  localparam [15:0] n657_o = 16'b0000000000000000;
  wire [9:0] n658_o;
  wire [2:0] n659_o;
  wire [15:0] n660_o;
  wire [15:0] n661_o;
  wire [15:0] n662_o;
  wire [15:0] n663_o;
  wire n664_o;
  wire n666_o;
  wire n668_o;
  wire n669_o;
  wire [15:0] n670_o;
  wire [15:0] n671_o;
  wire [15:0] n672_o;
  wire n674_o;
  wire n676_o;
  wire n677_o;
  wire n678_o;
  wire n679_o;
  wire n680_o;
  wire [15:0] n683_o;
  wire [15:0] n684_o;
  wire n685_o;
  wire n687_o;
  wire n688_o;
  wire n690_o;
  wire n692_o;
  wire n693_o;
  wire n694_o;
  wire [2:0] n695_o;
  wire n697_o;
  wire n698_o;
  wire [15:0] n700_o;
  wire [15:0] n702_o;
  wire [15:0] n703_o;
  wire [15:0] n704_o;
  wire n705_o;
  wire [15:0] n706_o;
  wire [7:0] n707_o;
  wire [1:0] n708_o;
  wire [7:0] n709_o;
  wire [7:0] n711_o;
  wire [7:0] n712_o;
  wire n713_o;
  wire n714_o;
  wire [15:0] n715_o;
  wire [7:0] n716_o;
  wire [7:0] n718_o;
  wire [7:0] n719_o;
  wire n721_o;
  wire [15:0] n722_o;
  wire [15:0] n723_o;
  wire n724_o;
  wire [15:0] n725_o;
  wire [7:0] n726_o;
  wire [1:0] n727_o;
  wire n728_o;
  wire n729_o;
  wire n730_o;
  wire [3:0] n732_o;
  wire n735_o;
  wire n739_o;
  wire [7:0] n740_o;
  wire [7:0] n741_o;
  wire [7:0] n742_o;
  wire [7:0] n743_o;
  wire [7:0] n744_o;
  wire [7:0] n745_o;
  wire [7:0] n746_o;
  wire [7:0] n747_o;
  wire [7:0] n748_o;
  wire [7:0] n749_o;
  wire [7:0] n750_o;
  wire [7:0] n751_o;
  wire [7:0] n752_o;
  wire [7:0] n753_o;
  wire [7:0] n754_o;
  wire [7:0] n755_o;
  wire [7:0] n756_o;
  wire [7:0] n757_o;
  wire [7:0] n758_o;
  wire [7:0] n759_o;
  wire [7:0] n760_o;
  wire [7:0] n761_o;
  wire [7:0] n762_o;
  wire [7:0] n763_o;
  wire [7:0] n764_o;
  wire [7:0] n765_o;
  wire [7:0] n766_o;
  wire [7:0] n767_o;
  wire [7:0] n768_o;
  wire [7:0] n769_o;
  wire [7:0] n770_o;
  wire [7:0] n771_o;
  wire [7:0] n772_o;
  wire [7:0] n773_o;
  wire [7:0] n774_o;
  wire [7:0] n775_o;
  wire [7:0] n776_o;
  wire [7:0] n777_o;
  wire [7:0] n778_o;
  wire [7:0] n779_o;
  wire [7:0] n780_o;
  wire [7:0] n781_o;
  wire [7:0] n782_o;
  wire [7:0] n783_o;
  wire [7:0] n784_o;
  wire [7:0] n785_o;
  wire [7:0] n786_o;
  wire [7:0] n787_o;
  wire [7:0] n788_o;
  wire [7:0] n789_o;
  wire [7:0] n790_o;
  wire [7:0] n791_o;
  wire [7:0] n792_o;
  wire [7:0] n793_o;
  wire [7:0] n794_o;
  wire [7:0] n795_o;
  wire [7:0] n796_o;
  wire [7:0] n797_o;
  wire [7:0] n798_o;
  wire [7:0] n799_o;
  wire [7:0] n800_o;
  wire [7:0] n801_o;
  wire [7:0] n802_o;
  wire [7:0] n803_o;
  wire [7:0] n804_o;
  wire [7:0] n805_o;
  wire [7:0] n806_o;
  wire [7:0] n807_o;
  wire [7:0] n808_o;
  wire [7:0] n809_o;
  wire [7:0] n810_o;
  wire [7:0] n811_o;
  wire [7:0] n812_o;
  wire [7:0] n813_o;
  wire [7:0] n814_o;
  wire [7:0] n815_o;
  wire [7:0] n816_o;
  wire [7:0] n817_o;
  wire [7:0] n818_o;
  wire [7:0] n819_o;
  wire [7:0] n820_o;
  wire [7:0] n821_o;
  wire [7:0] n822_o;
  wire [7:0] n823_o;
  wire n824_o;
  wire [1:0] n825_o;
  wire n826_o;
  wire n828_o;
  wire n831_o;
  wire n832_o;
  wire n834_o;
  wire n837_o;
  wire n838_o;
  wire n840_o;
  wire n843_o;
  wire n844_o;
  wire n846_o;
  wire n849_o;
  wire n851_o;
  wire [2:0] n852_o;
  reg [7:0] n853_o;
  wire n854_o;
  wire n855_o;
  wire n856_o;
  wire n857_o;
  wire n858_o;
  reg n859_o;
  wire n860_o;
  wire n861_o;
  wire n862_o;
  wire n863_o;
  wire n864_o;
  reg n865_o;
  wire n866_o;
  wire n867_o;
  wire n868_o;
  wire n869_o;
  wire n870_o;
  reg n871_o;
  wire n872_o;
  wire n873_o;
  wire n874_o;
  wire n875_o;
  wire n876_o;
  reg n877_o;
  wire n878_o;
  wire n879_o;
  wire n880_o;
  wire n881_o;
  wire n882_o;
  reg n883_o;
  wire n884_o;
  wire n885_o;
  wire n886_o;
  wire n887_o;
  wire n888_o;
  reg n889_o;
  wire n890_o;
  wire n891_o;
  wire n892_o;
  wire n893_o;
  wire n894_o;
  reg n895_o;
  reg [7:0] n896_o;
  wire n897_o;
  wire [7:0] n898_o;
  reg [7:0] n899_o;
  wire [7:0] n900_o;
  wire [6:0] n901_o;
  wire [6:0] n902_o;
  wire [6:0] n903_o;
  wire [6:0] n904_o;
  wire [6:0] n905_o;
  wire [6:0] n906_o;
  wire [6:0] n907_o;
  wire [7:0] n908_o;
  wire n909_o;
  wire [7:0] n910_o;
  wire [7:0] n911_o;
  wire n912_o;
  wire [6:0] n913_o;
  wire [6:0] n914_o;
  wire [6:0] n915_o;
  wire [6:0] n916_o;
  wire [6:0] n917_o;
  wire [6:0] n918_o;
  wire n919_o;
  wire n920_o;
  wire n921_o;
  wire n922_o;
  wire n923_o;
  wire n924_o;
  wire n925_o;
  wire [7:0] n926_o;
  wire [7:0] n927_o;
  wire [15:0] n928_o;
  wire [15:0] n929_o;
  wire n930_o;
  wire n931_o;
  wire n933_o;
  wire n934_o;
  wire [6:0] n935_o;
  wire n936_o;
  wire n937_o;
  wire n938_o;
  wire [7:0] n939_o;
  wire [7:0] n940_o;
  wire n942_o;
  wire n945_o;
  wire n946_o;
  wire n948_o;
  wire n951_o;
  wire n952_o;
  wire n953_o;
  wire n954_o;
  wire n955_o;
  wire n956_o;
  wire n957_o;
  wire n958_o;
  wire n959_o;
  wire n960_o;
  wire n961_o;
  wire n962_o;
  wire n963_o;
  wire n964_o;
  wire n965_o;
  wire n966_o;
  wire n967_o;
  wire n968_o;
  wire [6:0] n969_o;
  wire n974_o;
  wire n975_o;
  wire n976_o;
  wire n978_o;
  wire n979_o;
  wire n980_o;
  wire n981_o;
  wire n982_o;
  wire [7:0] n983_o;
  wire [3:0] n984_o;
  wire [3:0] n985_o;
  wire [7:0] n986_o;
  wire [7:0] n987_o;
  wire [3:0] n988_o;
  wire [3:0] n989_o;
  wire [7:0] n990_o;
  wire [7:0] n991_o;
  wire [7:0] n992_o;
  wire n993_o;
  wire [4:0] n996_o;
  wire [4:0] n997_o;
  wire [4:0] n998_o;
  wire [4:0] n1000_o;
  wire n1003_o;
  wire n1004_o;
  wire n1005_o;
  wire n1006_o;
  wire [2:0] n1009_o;
  wire n1010_o;
  wire n1011_o;
  wire n1012_o;
  wire n1013_o;
  wire n1014_o;
  wire n1015_o;
  wire [1:0] n1027_o;
  wire [1:0] n1028_o;
  wire [1:0] n1029_o;
  wire [1:0] n1030_o;
  wire [1:0] n1031_o;
  wire n1032_o;
  wire n1033_o;
  wire n1034_o;
  wire n1035_o;
  wire n1036_o;
  wire n1038_o;
  wire n1039_o;
  wire n1040_o;
  wire [7:0] n1042_o;
  wire [7:0] n1043_o;
  wire n1044_o;
  wire n1045_o;
  wire n1046_o;
  wire n1047_o;
  wire n1048_o;
  wire n1049_o;
  wire n1050_o;
  wire n1051_o;
  wire n1052_o;
  wire n1053_o;
  wire n1054_o;
  wire n1055_o;
  wire n1056_o;
  wire n1057_o;
  wire n1058_o;
  wire n1059_o;
  wire n1060_o;
  wire n1061_o;
  wire n1069_o;
  wire n1070_o;
  wire n1071_o;
  wire n1072_o;
  wire n1073_o;
  wire n1074_o;
  wire n1075_o;
  wire n1077_o;
  wire n1078_o;
  wire n1080_o;
  wire n1081_o;
  wire n1082_o;
  wire n1083_o;
  wire n1084_o;
  wire n1086_o;
  wire n1087_o;
  wire n1088_o;
  wire n1090_o;
  wire n1092_o;
  wire n1094_o;
  wire n1096_o;
  wire n1098_o;
  wire [4:0] n1099_o;
  reg [7:0] n1100_o;
  reg [7:0] n1101_o;
  wire [7:0] n1102_o;
  reg [7:0] n1103_o;
  wire [7:0] n1104_o;
  wire [7:0] n1105_o;
  wire [7:0] n1106_o;
  wire [7:0] n1107_o;
  wire [7:0] n1108_o;
  wire [7:0] n1109_o;
  wire [7:0] n1110_o;
  wire [7:0] n1111_o;
  wire [7:0] n1112_o;
  reg [7:0] n1113_o;
  wire [7:0] n1114_o;
  wire [7:0] n1115_o;
  wire [7:0] n1116_o;
  wire [7:0] n1117_o;
  wire [7:0] n1118_o;
  wire [7:0] n1119_o;
  wire [7:0] n1120_o;
  wire [7:0] n1121_o;
  wire [7:0] n1122_o;
  reg [7:0] n1123_o;
  wire [7:0] n1124_o;
  wire [7:0] n1125_o;
  wire [7:0] n1126_o;
  wire [7:0] n1127_o;
  wire [7:0] n1128_o;
  wire [15:0] n1129_o;
  wire [15:0] n1130_o;
  wire [15:0] n1131_o;
  wire [7:0] n1132_o;
  wire [7:0] n1133_o;
  wire [7:0] n1134_o;
  wire [7:0] n1135_o;
  wire [7:0] n1136_o;
  wire n1137_o;
  wire [7:0] n1138_o;
  wire [15:0] n1139_o;
  wire [15:0] n1140_o;
  wire n1141_o;
  wire [15:0] n1142_o;
  wire [7:0] n1143_o;
  wire [1:0] n1144_o;
  wire n1145_o;
  wire n1146_o;
  wire n1147_o;
  wire n1148_o;
  wire [4:0] n1149_o;
  wire n1150_o;
  wire n1151_o;
  wire [3:0] n1152_o;
  wire n1153_o;
  wire n1154_o;
  wire [2:0] n1155_o;
  wire n1156_o;
  wire [15:0] n1159_o;
  wire [7:0] n1161_o;
  wire [7:0] n1162_o;
  wire [7:0] n1163_o;
  wire [7:0] n1164_o;
  wire [7:0] n1165_o;
  wire [7:0] n1166_o;
  wire [7:0] n1167_o;
  wire [15:0] n1168_o;
  wire [15:0] n1169_o;
  wire n1170_o;
  wire [15:0] n1171_o;
  wire [7:0] n1173_o;
  wire [1:0] n1175_o;
  wire [1:0] n1176_o;
  wire [1:0] n1178_o;
  wire n1180_o;
  wire n1182_o;
  wire [4:0] n1184_o;
  wire n1186_o;
  wire n1188_o;
  wire [3:0] n1190_o;
  wire n1192_o;
  wire n1194_o;
  wire [2:0] n1196_o;
  wire n1198_o;
  wire [1:0] n1293_o;
  wire [2:0] n1294_o;
  wire n1295_o;
  wire n1297_o;
  wire n1298_o;
  wire [1:0] n1299_o;
  wire n1301_o;
  wire n1302_o;
  wire n1303_o;
  wire [2:0] n1305_o;
  wire [2:0] n1306_o;
  wire [1:0] n1307_o;
  wire [2:0] n1308_o;
  wire n1309_o;
  wire n1311_o;
  wire n1312_o;
  wire [1:0] n1313_o;
  wire n1315_o;
  wire n1316_o;
  wire n1317_o;
  wire [2:0] n1319_o;
  wire [2:0] n1320_o;
  wire [1:0] n1321_o;
  wire [2:0] n1322_o;
  wire n1323_o;
  wire [2:0] n1325_o;
  wire [2:0] n1326_o;
  wire n1327_o;
  wire n1329_o;
  wire n1330_o;
  wire n1332_o;
  wire n1333_o;
  wire n1334_o;
  wire [2:0] n1336_o;
  wire [2:0] n1337_o;
  wire n1338_o;
  wire n1340_o;
  wire n1341_o;
  wire n1342_o;
  wire n1344_o;
  wire n1346_o;
  wire n1348_o;
  wire n1349_o;
  wire n1350_o;
  wire [2:0] n1351_o;
  wire n1353_o;
  wire n1354_o;
  wire n1356_o;
  wire n1359_o;
  wire n1360_o;
  wire [1:0] n1372_o;
  wire [2:0] n1373_o;
  wire n1375_o;
  wire n1377_o;
  wire n1379_o;
  wire n1380_o;
  wire n1381_o;
  wire n1382_o;
  wire n1383_o;
  wire n1385_o;
  wire n1386_o;
  wire [2:0] n1387_o;
  wire n1388_o;
  wire [2:0] n1390_o;
  wire n1392_o;
  wire n1394_o;
  wire n1396_o;
  wire n1397_o;
  wire n1398_o;
  wire n1399_o;
  wire n1400_o;
  wire [1:0] n1401_o;
  wire n1403_o;
  wire n1404_o;
  wire [2:0] n1405_o;
  wire [2:0] n1407_o;
  wire n1409_o;
  wire n1410_o;
  wire [2:0] n1411_o;
  wire [2:0] n1413_o;
  wire n1415_o;
  wire n1416_o;
  wire [2:0] n1417_o;
  wire [2:0] n1419_o;
  wire n1421_o;
  wire n1422_o;
  wire [2:0] n1423_o;
  wire [15:0] n1425_o;
  wire n1426_o;
  wire [15:0] n1427_o;
  wire [15:0] n1429_o;
  wire n1433_o;
  wire n1434_o;
  wire n1435_o;
  wire n1436_o;
  wire n1437_o;
  wire n1439_o;
  wire n1440_o;
  wire n1441_o;
  wire n1442_o;
  wire n1443_o;
  wire n1444_o;
  wire n1446_o;
  wire n1448_o;
  wire n1449_o;
  wire n1451_o;
  wire n1452_o;
  wire n1454_o;
  wire n1455_o;
  wire n1457_o;
  wire n1458_o;
  wire n1460_o;
  wire n1461_o;
  reg n1463_o;
  reg n1465_o;
  wire n1467_o;
  wire n1470_o;
  wire n1473_o;
  wire n1475_o;
  wire n1476_o;
  wire n1477_o;
  wire n1479_o;
  wire n1481_o;
  wire n1482_o;
  wire n1484_o;
  wire n1485_o;
  wire n1487_o;
  wire n1488_o;
  wire n1490_o;
  wire n1492_o;
  wire n1493_o;
  wire n1494_o;
  wire n1495_o;
  wire [1:0] n1496_o;
  wire n1498_o;
  wire n1500_o;
  wire n1501_o;
  wire n1503_o;
  wire n1504_o;
  reg n1506_o;
  reg n1508_o;
  wire n1509_o;
  wire n1510_o;
  wire n1515_o;
  wire n1516_o;
  wire [7:0] n1517_o;
  wire [7:0] n1518_o;
  wire [7:0] n1519_o;
  wire [7:0] n1520_o;
  wire n1522_o;
  wire n1523_o;
  wire [7:0] n1524_o;
  wire [7:0] n1525_o;
  wire [7:0] n1526_o;
  wire [7:0] n1527_o;
  wire n1528_o;
  wire n1530_o;
  wire n1532_o;
  wire n1533_o;
  wire n1535_o;
  wire n1537_o;
  wire n1538_o;
  wire n1539_o;
  wire n1540_o;
  wire [7:0] n1541_o;
  wire [7:0] n1542_o;
  wire [7:0] n1543_o;
  wire [7:0] n1544_o;
  wire [7:0] regs_doah;
  wire [7:0] regs_doal;
  wire [7:0] regs_dobh;
  wire [7:0] regs_dobl;
  wire [7:0] regs_doch;
  wire [7:0] regs_docl;
  wire [127:0] regs_dor;
  wire n1557_o;
  wire n1558_o;
  wire [7:0] n1559_o;
  wire [7:0] n1560_o;
  wire [7:0] n1561_o;
  wire n1563_o;
  wire n1565_o;
  wire n1566_o;
  wire n1568_o;
  wire n1569_o;
  wire n1571_o;
  wire n1572_o;
  wire n1574_o;
  wire n1575_o;
  wire n1577_o;
  wire n1578_o;
  wire n1580_o;
  wire [7:0] n1581_o;
  wire n1583_o;
  wire [7:0] n1584_o;
  wire n1586_o;
  wire n1588_o;
  wire n1590_o;
  wire [7:0] n1591_o;
  wire n1593_o;
  wire [7:0] n1594_o;
  wire n1596_o;
  wire n1598_o;
  wire n1599_o;
  wire [7:0] n1602_o;
  wire n1604_o;
  wire [9:0] n1605_o;
  reg [7:0] n1608_o;
  wire n1610_o;
  wire n1611_o;
  wire [7:0] n1612_o;
  wire [7:0] n1613_o;
  wire [7:0] n1614_o;
  wire n1616_o;
  wire n1618_o;
  wire n1619_o;
  wire n1621_o;
  wire n1622_o;
  wire n1624_o;
  wire n1625_o;
  wire n1627_o;
  wire n1628_o;
  wire n1630_o;
  wire n1631_o;
  wire n1633_o;
  wire [7:0] n1634_o;
  wire n1636_o;
  wire [7:0] n1637_o;
  wire n1639_o;
  wire n1641_o;
  wire [5:0] n1642_o;
  reg [7:0] n1645_o;
  wire [7:0] n1646_o;
  wire [7:0] n1647_o;
  wire n1655_o;
  wire n1657_o;
  wire n1658_o;
  wire n1660_o;
  wire n1662_o;
  wire n1663_o;
  wire n1665_o;
  wire n1666_o;
  wire n1667_o;
  wire n1670_o;
  wire n1676_o;
  wire n1677_o;
  wire n1678_o;
  reg n1679_oldnmi_n;
  wire n1682_o;
  wire n1684_o;
  wire n1685_o;
  wire n1686_o;
  wire n1687_o;
  wire n1688_o;
  wire n1690_o;
  wire n1691_o;
  wire n1692_o;
  wire n1694_o;
  wire n1696_o;
  wire n1697_o;
  wire n1698_o;
  wire n1699_o;
  wire n1700_o;
  wire n1701_o;
  wire n1702_o;
  wire n1703_o;
  wire n1704_o;
  wire n1705_o;
  wire n1706_o;
  wire n1707_o;
  wire n1708_o;
  wire n1709_o;
  wire n1710_o;
  wire n1711_o;
  wire n1712_o;
  wire n1713_o;
  wire n1714_o;
  wire n1715_o;
  wire n1716_o;
  wire n1717_o;
  wire n1719_o;
  wire n1721_o;
  wire n1723_o;
  wire n1724_o;
  wire n1725_o;
  wire n1726_o;
  wire n1728_o;
  wire n1730_o;
  wire n1732_o;
  wire n1733_o;
  wire n1734_o;
  wire n1735_o;
  wire n1737_o;
  wire n1739_o;
  wire n1741_o;
  wire n1742_o;
  wire n1743_o;
  wire n1745_o;
  wire n1746_o;
  wire n1748_o;
  wire n1749_o;
  wire n1750_o;
  wire n1752_o;
  wire n1754_o;
  wire n1756_o;
  wire [2:0] n1758_o;
  wire n1760_o;
  wire n1764_o;
  wire [2:0] n1766_o;
  wire n1767_o;
  wire n1768_o;
  wire n1770_o;
  wire n1771_o;
  wire n1772_o;
  wire n1773_o;
  wire n1775_o;
  wire n1776_o;
  wire n1777_o;
  wire n1778_o;
  wire n1780_o;
  wire n1781_o;
  wire n1782_o;
  wire n1783_o;
  wire n1785_o;
  wire n1787_o;
  wire n1790_o;
  wire n1792_o;
  wire n1793_o;
  wire n1795_o;
  wire n1797_o;
  wire n1801_o;
  wire [2:0] n1804_o;
  wire n1806_o;
  wire [2:0] n1808_o;
  wire n1809_o;
  wire n1810_o;
  wire n1811_o;
  wire n1812_o;
  wire n1813_o;
  wire n1814_o;
  wire [2:0] n1815_o;
  wire n1816_o;
  wire n1817_o;
  wire n1818_o;
  wire n1819_o;
  wire n1820_o;
  wire n1821_o;
  wire [2:0] n1823_o;
  wire n1824_o;
  wire n1825_o;
  wire n1826_o;
  wire [2:0] n1827_o;
  wire n1828_o;
  wire n1829_o;
  wire n1830_o;
  wire [2:0] n1832_o;
  wire [2:0] n1833_o;
  wire n1834_o;
  wire n1835_o;
  wire n1838_o;
  wire n1839_o;
  wire [2:0] n1840_o;
  wire n1841_o;
  wire n1842_o;
  wire n1843_o;
  wire n1844_o;
  wire n1846_o;
  wire n1847_o;
  wire n1848_o;
  wire n1849_o;
  wire n1850_o;
  wire [2:0] n1852_o;
  wire [2:0] n1853_o;
  wire n1854_o;
  wire [2:0] n1855_o;
  wire [2:0] n1856_o;
  wire n1857_o;
  wire n1858_o;
  wire n1859_o;
  wire n1861_o;
  wire n1862_o;
  wire [2:0] n1863_o;
  wire n1864_o;
  wire n1865_o;
  wire n1866_o;
  wire [2:0] n1867_o;
  wire [2:0] n1868_o;
  wire n1869_o;
  wire n1870_o;
  wire n1871_o;
  wire n1873_o;
  wire n1875_o;
  wire [2:0] n1876_o;
  wire n1877_o;
  wire n1878_o;
  wire n1879_o;
  wire [2:0] n1880_o;
  wire [2:0] n1881_o;
  wire n1882_o;
  wire n1883_o;
  wire n1884_o;
  wire n1885_o;
  wire n1886_o;
  wire [2:0] n1887_o;
  wire n1888_o;
  wire n1889_o;
  wire n1891_o;
  wire n1893_o;
  wire n1894_o;
  wire [2:0] n1895_o;
  wire [2:0] n1896_o;
  wire n1897_o;
  wire n1898_o;
  wire n1899_o;
  wire n1900_o;
  wire n1901_o;
  wire n1902_o;
  wire [2:0] n1903_o;
  wire n1904_o;
  wire n1905_o;
  wire n1906_o;
  wire n1907_o;
  wire n1908_o;
  wire n1910_o;
  wire [2:0] n1912_o;
  wire [2:0] n1914_o;
  wire n1915_o;
  wire n1916_o;
  wire n1917_o;
  wire n1919_o;
  wire n1921_o;
  wire n1923_o;
  wire [2:0] n1925_o;
  wire n1927_o;
  wire n1929_o;
  wire n1931_o;
  wire n1933_o;
  wire n1935_o;
  wire n1936_o;
  wire n1985_o;
  wire n1986_o;
  reg n1987_q;
  wire n1990_o;
  wire n1991_o;
  wire n1992_o;
  reg [7:0] n1994_q;
  reg [7:0] n1995_q;
  reg [7:0] n1996_q;
  reg [7:0] n1997_q;
  reg [7:0] n1998_q;
  reg [7:0] n1999_q;
  reg [15:0] n2000_q;
  reg [15:0] n2001_q;
  wire [15:0] n2002_o;
  wire [15:0] n2003_o;
  wire [15:0] n2004_o;
  wire [2:0] n2005_o;
  reg [2:0] n2006_q;
  wire [2:0] n2007_o;
  reg [2:0] n2008_q;
  wire [2:0] n2009_o;
  reg [2:0] n2010_q;
  reg n2011_q;
  reg [15:0] n2012_q;
  reg [7:0] n2013_q;
  reg [1:0] n2014_q;
  wire [15:0] n2015_o;
  reg [15:0] n2016_q;
  reg [2:0] n2017_q;
  reg [2:0] n2018_q;
  reg n2019_q;
  reg n2020_q;
  reg n2021_q;
  reg n2022_q;
  reg n2023_q;
  reg n2024_q;
  reg [1:0] n2025_q;
  reg [1:0] n2026_q;
  reg [2:0] n2027_q;
  reg n2028_q;
  reg n2029_q;
  reg n2030_q;
  reg n2031_q;
  reg n2032_q;
  wire n2033_o;
  reg n2034_q;
  wire [7:0] n2035_o;
  reg [7:0] n2036_q;
  wire [7:0] n2037_o;
  reg [7:0] n2038_q;
  reg [4:0] n2039_q;
  reg n2040_q;
  reg n2041_q;
  reg [3:0] n2042_q;
  reg n2043_q;
  reg n2044_q;
  reg [2:0] n2045_q;
  reg n2046_q;
  reg n2047_q;
  reg n2048_q;
  reg n2049_q;
  wire n2050_o;
  reg n2051_q;
  reg [15:0] n2052_q;
  reg [7:0] n2053_q;
  assign m1_n = n2049_q;
  assign iorq = iorq_i;
  assign noread = mcode_noread;
  assign write = mcode_write;
  assign rfsh_n = n2051_q;
  assign halt_n = n1676_o;
  assign busak_n = n1677_o;
  assign a = n2052_q;
  assign do = n2053_q;
  assign mc = mcycle;
  assign ts = tstate;
  assign intcycle_n = n1678_o;
  assign inte = inte_ff1;
  assign stop = i_djnz;
  assign \reg  = n163_o;
  assign iset_out = iset;
  /* ./T80/T80.vhd:141:16  */
  assign acc = n1994_q; // (signal)
  /* ./T80/T80.vhd:141:21  */
  assign f = n1995_q; // (signal)
  /* ./T80/T80.vhd:142:16  */
  assign ap = n1996_q; // (signal)
  /* ./T80/T80.vhd:142:20  */
  assign fp = n1997_q; // (signal)
  /* ./T80/T80.vhd:143:16  */
  assign i = n1998_q; // (signal)
  /* ./T80/T80.vhd:144:16  */
  assign r = n1999_q; // (signal)
  /* ./T80/T80.vhd:145:16  */
  assign sp = n2000_q; // (signal)
  /* ./T80/T80.vhd:145:20  */
  assign pc = n2001_q; // (signal)
  /* ./T80/T80.vhd:147:16  */
  assign regdih = n1543_o; // (signal)
  /* ./T80/T80.vhd:148:16  */
  assign regdil = n1544_o; // (signal)
  /* ./T80/T80.vhd:149:16  */
  assign regbusa = n2002_o; // (signal)
  /* ./T80/T80.vhd:150:16  */
  assign regbusb = n2003_o; // (signal)
  /* ./T80/T80.vhd:151:16  */
  assign regbusc = n2004_o; // (signal)
  /* ./T80/T80.vhd:152:16  */
  assign regaddra_r = n2006_q; // (signal)
  /* ./T80/T80.vhd:153:16  */
  assign regaddra = n1387_o; // (signal)
  /* ./T80/T80.vhd:154:16  */
  assign regaddrb_r = n2008_q; // (signal)
  /* ./T80/T80.vhd:155:16  */
  assign regaddrb = n1423_o; // (signal)
  /* ./T80/T80.vhd:156:16  */
  assign regaddrc = n2010_q; // (signal)
  /* ./T80/T80.vhd:157:16  */
  assign regweh = n1509_o; // (signal)
  /* ./T80/T80.vhd:158:16  */
  assign regwel = n1510_o; // (signal)
  /* ./T80/T80.vhd:159:16  */
  assign alternate = n2011_q; // (signal)
  /* ./T80/T80.vhd:162:16  */
  assign wz = n2012_q; // (signal)
  /* ./T80/T80.vhd:163:16  */
  assign ir = n2013_q; // (signal)
  /* ./T80/T80.vhd:164:16  */
  assign iset = n2014_q; // (signal)
  /* ./T80/T80.vhd:165:16  */
  assign regbusa_r = n2016_q; // (signal)
  /* ./T80/T80.vhd:167:16  */
  assign id16 = n1427_o; // (signal)
  /* ./T80/T80.vhd:168:16  */
  assign save_mux = n283_o; // (signal)
  /* ./T80/T80.vhd:170:16  */
  assign tstate = n2017_q; // (signal)
  /* ./T80/T80.vhd:171:16  */
  assign mcycle = n2018_q; // (signal)
  /* ./T80/T80.vhd:172:16  */
  assign inte_ff1 = n2019_q; // (signal)
  /* ./T80/T80.vhd:173:16  */
  assign inte_ff2 = n2020_q; // (signal)
  /* ./T80/T80.vhd:174:16  */
  assign halt_ff = n2021_q; // (signal)
  /* ./T80/T80.vhd:175:16  */
  assign busreq_s = n2022_q; // (signal)
  /* ./T80/T80.vhd:176:16  */
  assign busack = n2023_q; // (signal)
  /* ./T80/T80.vhd:177:16  */
  assign clken = n256_o; // (signal)
  /* ./T80/T80.vhd:178:16  */
  assign nmi_s = n2024_q; // (signal)
  /* ./T80/T80.vhd:179:16  */
  assign istatus = n2025_q; // (signal)
  /* ./T80/T80.vhd:181:16  */
  assign di_reg = di; // (signal)
  /* ./T80/T80.vhd:182:16  */
  assign t_res = n259_o; // (signal)
  /* ./T80/T80.vhd:183:16  */
  assign xy_state = n2026_q; // (signal)
  /* ./T80/T80.vhd:184:16  */
  assign pre_xy_f_m = n2027_q; // (signal)
  /* ./T80/T80.vhd:185:16  */
  assign nextis_xy_fetch = n281_o; // (signal)
  /* ./T80/T80.vhd:186:16  */
  assign xy_ind = n2028_q; // (signal)
  /* ./T80/T80.vhd:187:16  */
  assign no_btr = n2029_q; // (signal)
  /* ./T80/T80.vhd:188:16  */
  assign btr_r = n2030_q; // (signal)
  /* ./T80/T80.vhd:189:16  */
  assign auto_wait = n1992_o; // (signal)
  /* ./T80/T80.vhd:190:16  */
  assign auto_wait_t1 = n2031_q; // (signal)
  /* ./T80/T80.vhd:191:16  */
  assign auto_wait_t2 = n2032_q; // (signal)
  /* ./T80/T80.vhd:192:16  */
  assign incdecz = n2034_q; // (signal)
  /* ./T80/T80.vhd:195:16  */
  assign busb = n2036_q; // (signal)
  /* ./T80/T80.vhd:196:16  */
  assign busa = n2038_q; // (signal)
  /* ./T80/T80.vhd:197:16  */
  assign alu_q = alu_q; // (signal)
  /* ./T80/T80.vhd:198:16  */
  assign f_out = alu_f_out; // (signal)
  /* ./T80/T80.vhd:201:16  */
  assign read_to_reg_r = n2039_q; // (signal)
  /* ./T80/T80.vhd:202:16  */
  assign arith16_r = n2040_q; // (signal)
  /* ./T80/T80.vhd:203:16  */
  assign z16_r = n2041_q; // (signal)
  /* ./T80/T80.vhd:204:16  */
  assign alu_op_r = n2042_q; // (signal)
  /* ./T80/T80.vhd:205:16  */
  assign save_alu_r = n2043_q; // (signal)
  /* ./T80/T80.vhd:206:16  */
  assign preservec_r = n2044_q; // (signal)
  /* ./T80/T80.vhd:207:16  */
  assign mcycles = n2045_q; // (signal)
  /* ./T80/T80.vhd:210:16  */
  assign mcycles_d = mcode_mcycles; // (signal)
  /* ./T80/T80.vhd:211:16  */
  assign tstates = mcode_tstates; // (signal)
  /* ./T80/T80.vhd:212:16  */
  assign intcycle = n2046_q; // (signal)
  /* ./T80/T80.vhd:213:16  */
  assign nmicycle = n2047_q; // (signal)
  /* ./T80/T80.vhd:214:16  */
  assign inc_pc = mcode_inc_pc; // (signal)
  /* ./T80/T80.vhd:215:16  */
  assign inc_wz = mcode_inc_wz; // (signal)
  /* ./T80/T80.vhd:216:16  */
  assign incdec_16 = mcode_incdec_16; // (signal)
  /* ./T80/T80.vhd:217:16  */
  assign prefix = mcode_prefix; // (signal)
  /* ./T80/T80.vhd:218:16  */
  assign read_to_acc = mcode_read_to_acc; // (signal)
  /* ./T80/T80.vhd:219:16  */
  assign read_to_reg = mcode_read_to_reg; // (signal)
  /* ./T80/T80.vhd:220:16  */
  assign set_busb_to = mcode_set_busb_to; // (signal)
  /* ./T80/T80.vhd:221:16  */
  assign set_busa_to = mcode_set_busa_to; // (signal)
  /* ./T80/T80.vhd:222:16  */
  assign alu_op = mcode_alu_op; // (signal)
  /* ./T80/T80.vhd:223:16  */
  assign save_alu = mcode_save_alu; // (signal)
  /* ./T80/T80.vhd:224:16  */
  assign preservec = mcode_preservec; // (signal)
  /* ./T80/T80.vhd:225:16  */
  assign arith16 = mcode_arith16; // (signal)
  /* ./T80/T80.vhd:226:16  */
  assign set_addr_to = mcode_set_addr_to; // (signal)
  /* ./T80/T80.vhd:227:16  */
  assign jump = mcode_jump; // (signal)
  /* ./T80/T80.vhd:228:16  */
  assign jumpe = mcode_jumpe; // (signal)
  /* ./T80/T80.vhd:229:16  */
  assign jumpxy = mcode_jumpxy; // (signal)
  /* ./T80/T80.vhd:230:16  */
  assign call = mcode_call; // (signal)
  /* ./T80/T80.vhd:231:16  */
  assign rstp = mcode_rstp; // (signal)
  /* ./T80/T80.vhd:232:16  */
  assign ldz = mcode_ldz; // (signal)
  /* ./T80/T80.vhd:233:16  */
  assign ldw = mcode_ldw; // (signal)
  /* ./T80/T80.vhd:234:16  */
  assign ldsphl = mcode_ldsphl; // (signal)
  /* ./T80/T80.vhd:235:16  */
  assign iorq_i = mcode_iorq; // (signal)
  /* ./T80/T80.vhd:236:16  */
  assign special_ld = mcode_special_ld; // (signal)
  /* ./T80/T80.vhd:237:16  */
  assign exchangedh = mcode_exchangedh; // (signal)
  /* ./T80/T80.vhd:238:16  */
  assign exchangerp = mcode_exchangerp; // (signal)
  /* ./T80/T80.vhd:239:16  */
  assign exchangeaf = mcode_exchangeaf; // (signal)
  /* ./T80/T80.vhd:240:16  */
  assign exchangers = mcode_exchangers; // (signal)
  /* ./T80/T80.vhd:241:16  */
  assign i_djnz = mcode_i_djnz; // (signal)
  /* ./T80/T80.vhd:242:16  */
  assign i_cpl = mcode_i_cpl; // (signal)
  /* ./T80/T80.vhd:243:16  */
  assign i_ccf = mcode_i_ccf; // (signal)
  /* ./T80/T80.vhd:244:16  */
  assign i_scf = mcode_i_scf; // (signal)
  /* ./T80/T80.vhd:245:16  */
  assign i_retn = mcode_i_retn; // (signal)
  /* ./T80/T80.vhd:246:16  */
  assign i_bt = mcode_i_bt; // (signal)
  /* ./T80/T80.vhd:247:16  */
  assign i_bc = mcode_i_bc; // (signal)
  /* ./T80/T80.vhd:248:16  */
  assign i_btr = mcode_i_btr; // (signal)
  /* ./T80/T80.vhd:249:16  */
  assign i_rld = mcode_i_rld; // (signal)
  /* ./T80/T80.vhd:250:16  */
  assign i_rrd = mcode_i_rrd; // (signal)
  /* ./T80/T80.vhd:251:16  */
  assign i_rxdd = n2048_q; // (signal)
  /* ./T80/T80.vhd:252:16  */
  assign i_inrc = mcode_i_inrc; // (signal)
  /* ./T80/T80.vhd:253:16  */
  assign setwz = mcode_setwz; // (signal)
  /* ./T80/T80.vhd:254:16  */
  assign setdi = mcode_setdi; // (signal)
  /* ./T80/T80.vhd:255:16  */
  assign setei = mcode_setei; // (signal)
  /* ./T80/T80.vhd:256:16  */
  assign imode = mcode_imode; // (signal)
  /* ./T80/T80.vhd:257:16  */
  assign halt = mcode_halt; // (signal)
  /* ./T80/T80.vhd:258:16  */
  assign xybit_undoc = mcode_xybit_undoc; // (signal)
  /* ./T80/T80.vhd:259:16  */
  assign dor = regs_dor; // (signal)
  /* ./T80/T80.vhd:260:16  */
  assign regdir = n188_o; // (signal)
  /* ./T80/T80.vhd:266:24  */
  assign n148_o = {halt_ff, alternate};
  /* ./T80/T80.vhd:266:36  */
  assign n149_o = {n148_o, wz};
  /* ./T80/T80.vhd:266:41  */
  assign n150_o = {n149_o, inte_ff2};
  /* ./T80/T80.vhd:266:52  */
  assign n151_o = {n150_o, inte_ff1};
  /* ./T80/T80.vhd:266:63  */
  assign n152_o = {n151_o, istatus};
  /* ./T80/T80.vhd:266:73  */
  assign n153_o = {n152_o, dor};
  /* ./T80/T80.vhd:266:79  */
  assign n154_o = {n153_o, pc};
  /* ./T80/T80.vhd:266:102  */
  assign n155_o = {n154_o, sp};
  /* ./T80/T80.vhd:266:125  */
  assign n156_o = {n155_o, r};
  /* ./T80/T80.vhd:266:147  */
  assign n157_o = {n156_o, i};
  /* ./T80/T80.vhd:266:151  */
  assign n158_o = {n157_o, fp};
  /* ./T80/T80.vhd:266:156  */
  assign n159_o = {n158_o, ap};
  /* ./T80/T80.vhd:266:161  */
  assign n160_o = {n159_o, f};
  /* ./T80/T80.vhd:266:165  */
  assign n161_o = {n160_o, acc};
  /* ./T80/T80.vhd:266:186  */
  assign n162_o = ~alternate;
  /* ./T80/T80.vhd:266:171  */
  assign n163_o = n162_o ? n161_o : n184_o;
  /* ./T80/T80.vhd:267:39  */
  assign n164_o = {halt_ff, alternate};
  /* ./T80/T80.vhd:267:51  */
  assign n165_o = {n164_o, wz};
  /* ./T80/T80.vhd:267:56  */
  assign n166_o = {n165_o, inte_ff2};
  /* ./T80/T80.vhd:267:67  */
  assign n167_o = {n166_o, inte_ff1};
  /* ./T80/T80.vhd:267:78  */
  assign n168_o = {n167_o, istatus};
  /* ./T80/T80.vhd:267:93  */
  assign n169_o = dor[127:112];
  /* ./T80/T80.vhd:267:88  */
  assign n170_o = {n168_o, n169_o};
  /* ./T80/T80.vhd:267:115  */
  assign n171_o = dor[47:0];
  /* ./T80/T80.vhd:267:110  */
  assign n172_o = {n170_o, n171_o};
  /* ./T80/T80.vhd:267:134  */
  assign n173_o = dor[63:48];
  /* ./T80/T80.vhd:267:129  */
  assign n174_o = {n172_o, n173_o};
  /* ./T80/T80.vhd:267:154  */
  assign n175_o = dor[111:64];
  /* ./T80/T80.vhd:267:149  */
  assign n176_o = {n174_o, n175_o};
  /* ./T80/T80.vhd:267:170  */
  assign n177_o = {n176_o, pc};
  /* ./T80/T80.vhd:268:70  */
  assign n178_o = {n177_o, sp};
  /* ./T80/T80.vhd:268:93  */
  assign n179_o = {n178_o, r};
  /* ./T80/T80.vhd:268:115  */
  assign n180_o = {n179_o, i};
  /* ./T80/T80.vhd:268:119  */
  assign n181_o = {n180_o, fp};
  /* ./T80/T80.vhd:268:124  */
  assign n182_o = {n181_o, ap};
  /* ./T80/T80.vhd:268:129  */
  assign n183_o = {n182_o, f};
  /* ./T80/T80.vhd:268:133  */
  assign n184_o = {n183_o, acc};
  /* ./T80/T80.vhd:270:22  */
  assign n185_o = dir[207:80];
  /* ./T80/T80.vhd:270:46  */
  assign n186_o = dir[228];
  /* ./T80/T80.vhd:270:52  */
  assign n187_o = ~n186_o;
  /* ./T80/T80.vhd:270:38  */
  assign n188_o = n187_o ? n185_o : n203_o;
  /* ./T80/T80.vhd:271:22  */
  assign n189_o = dir[207:192];
  /* ./T80/T80.vhd:272:22  */
  assign n190_o = dir[127:112];
  /* ./T80/T80.vhd:271:39  */
  assign n191_o = {n189_o, n190_o};
  /* ./T80/T80.vhd:273:22  */
  assign n192_o = dir[111:96];
  /* ./T80/T80.vhd:272:39  */
  assign n193_o = {n191_o, n192_o};
  /* ./T80/T80.vhd:274:22  */
  assign n194_o = dir[95:80];
  /* ./T80/T80.vhd:273:39  */
  assign n195_o = {n193_o, n194_o};
  /* ./T80/T80.vhd:275:22  */
  assign n196_o = dir[143:128];
  /* ./T80/T80.vhd:274:39  */
  assign n197_o = {n195_o, n196_o};
  /* ./T80/T80.vhd:276:22  */
  assign n198_o = dir[191:176];
  /* ./T80/T80.vhd:275:39  */
  assign n199_o = {n197_o, n198_o};
  /* ./T80/T80.vhd:277:22  */
  assign n200_o = dir[175:160];
  /* ./T80/T80.vhd:276:39  */
  assign n201_o = {n199_o, n200_o};
  /* ./T80/T80.vhd:278:22  */
  assign n202_o = dir[159:144];
  /* ./T80/T80.vhd:277:39  */
  assign n203_o = {n201_o, n202_o};
  /* ./T80/T80.vhd:280:9  */
  t80_mcode_0_0_1_2_3_4_5_6_7 mcode (
    .ir(ir),
    .iset(iset),
    .mcycle(mcycle),
    .f(f),
    .nmicycle(nmicycle),
    .intcycle(intcycle),
    .xy_state(xy_state),
    .mcycles(mcode_mcycles),
    .tstates(mcode_tstates),
    .prefix(mcode_prefix),
    .inc_pc(mcode_inc_pc),
    .inc_wz(mcode_inc_wz),
    .incdec_16(mcode_incdec_16),
    .read_to_reg(mcode_read_to_reg),
    .read_to_acc(mcode_read_to_acc),
    .set_busa_to(mcode_set_busa_to),
    .set_busb_to(mcode_set_busb_to),
    .alu_op(mcode_alu_op),
    .save_alu(mcode_save_alu),
    .preservec(mcode_preservec),
    .arith16(mcode_arith16),
    .set_addr_to(mcode_set_addr_to),
    .iorq(mcode_iorq),
    .jump(mcode_jump),
    .jumpe(mcode_jumpe),
    .jumpxy(mcode_jumpxy),
    .call(mcode_call),
    .rstp(mcode_rstp),
    .ldz(mcode_ldz),
    .ldw(mcode_ldw),
    .ldsphl(mcode_ldsphl),
    .special_ld(mcode_special_ld),
    .exchangedh(mcode_exchangedh),
    .exchangerp(mcode_exchangerp),
    .exchangeaf(mcode_exchangeaf),
    .exchangers(mcode_exchangers),
    .i_djnz(mcode_i_djnz),
    .i_cpl(mcode_i_cpl),
    .i_ccf(mcode_i_ccf),
    .i_scf(mcode_i_scf),
    .i_retn(mcode_i_retn),
    .i_bt(mcode_i_bt),
    .i_bc(mcode_i_bc),
    .i_btr(mcode_i_btr),
    .i_rld(mcode_i_rld),
    .i_rrd(mcode_i_rrd),
    .i_inrc(mcode_i_inrc),
    .setwz(mcode_setwz),
    .setdi(mcode_setdi),
    .setei(mcode_setei),
    .imode(mcode_imode),
    .halt(mcode_halt),
    .noread(mcode_noread),
    .write(mcode_write),
    .xybit_undoc(mcode_xybit_undoc));
  /* ./T80/T80.vhd:348:9  */
  t80_alu_0_0_1_2_3_4_5_6_7 alu (
    .arith16(arith16_r),
    .z16(z16_r),
    .wz(wz),
    .xy_state(xy_state),
    .alu_op(alu_op_r),
    .ir(n252_o),
    .iset(iset),
    .busa(busa),
    .busb(busb),
    .f_in(f),
    .q(alu_q),
    .f_out(alu_f_out));
  /* ./T80/T80.vhd:365:38  */
  assign n252_o = ir[5:0];
  /* ./T80/T80.vhd:373:26  */
  assign n255_o = ~busack;
  /* ./T80/T80.vhd:373:22  */
  assign n256_o = cen & n255_o;
  /* ./T80/T80.vhd:375:34  */
  assign n258_o = tstate == tstates;
  /* ./T80/T80.vhd:375:22  */
  assign n259_o = n258_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:377:46  */
  assign n263_o = xy_state != 2'b00;
  /* ./T80/T80.vhd:377:65  */
  assign n264_o = ~xy_ind;
  /* ./T80/T80.vhd:377:54  */
  assign n265_o = n264_o & n263_o;
  /* ./T80/T80.vhd:378:71  */
  assign n267_o = set_addr_to == 3'b010;
  /* ./T80/T80.vhd:379:65  */
  assign n269_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:379:80  */
  assign n271_o = ir == 8'b11001011;
  /* ./T80/T80.vhd:379:73  */
  assign n272_o = n271_o & n269_o;
  /* ./T80/T80.vhd:378:78  */
  assign n273_o = n267_o | n272_o;
  /* ./T80/T80.vhd:380:65  */
  assign n275_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:380:80  */
  assign n277_o = ir == 8'b00110110;
  /* ./T80/T80.vhd:380:73  */
  assign n278_o = n277_o & n275_o;
  /* ./T80/T80.vhd:379:94  */
  assign n279_o = n273_o | n278_o;
  /* ./T80/T80.vhd:377:71  */
  assign n280_o = n279_o & n265_o;
  /* ./T80/T80.vhd:377:32  */
  assign n281_o = n280_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:382:26  */
  assign n283_o = exchangerp ? busb : n285_o;
  /* ./T80/T80.vhd:383:40  */
  assign n284_o = ~save_alu_r;
  /* ./T80/T80.vhd:382:48  */
  assign n285_o = n284_o ? di_reg : alu_q;
  /* ./T80/T80.vhd:390:28  */
  assign n290_o = ~reset_n;
  /* ./T80/T80.vhd:423:43  */
  assign n292_o = dir[7:0];
  /* ./T80/T80.vhd:424:43  */
  assign n293_o = dir[15:8];
  /* ./T80/T80.vhd:425:43  */
  assign n294_o = dir[23:16];
  /* ./T80/T80.vhd:426:43  */
  assign n295_o = dir[31:24];
  /* ./T80/T80.vhd:427:43  */
  assign n296_o = dir[39:32];
  /* ./T80/T80.vhd:428:52  */
  assign n297_o = dir[47:40];
  /* ./T80/T80.vhd:429:52  */
  assign n298_o = dir[63:48];
  /* ./T80/T80.vhd:430:52  */
  assign n299_o = dir[79:64];
  /* ./T80/T80.vhd:431:43  */
  assign n300_o = dir[79:64];
  /* ./T80/T80.vhd:432:43  */
  assign n301_o = dir[227:212];
  /* ./T80/T80.vhd:433:47  */
  assign n302_o = dir[209:208];
  /* ./T80/T80.vhd:437:49  */
  assign n303_o = dir[228];
  /* ./T80/T80.vhd:457:42  */
  assign n305_o = imode != 2'b11;
  /* ./T80/T80.vhd:450:25  */
  assign n306_o = n1145_o ? imode : istatus;
  /* ./T80/T80.vhd:463:41  */
  assign n308_o = iset == 2'b10;
  /* ./T80/T80.vhd:463:58  */
  assign n309_o = alu_op[2];
  /* ./T80/T80.vhd:463:62  */
  assign n310_o = ~n309_o;
  /* ./T80/T80.vhd:463:48  */
  assign n311_o = n310_o & n308_o;
  /* ./T80/T80.vhd:463:78  */
  assign n312_o = alu_op[0];
  /* ./T80/T80.vhd:463:68  */
  assign n313_o = n312_o & n311_o;
  /* ./T80/T80.vhd:463:99  */
  assign n315_o = mcycle == 3'b011;
  /* ./T80/T80.vhd:463:88  */
  assign n316_o = n315_o & n313_o;
  /* ./T80/T80.vhd:463:33  */
  assign n319_o = n316_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:469:44  */
  assign n321_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:469:62  */
  assign n322_o = tstate[2];
  /* ./T80/T80.vhd:469:66  */
  assign n323_o = ~n322_o;
  /* ./T80/T80.vhd:469:52  */
  assign n324_o = n323_o & n321_o;
  /* ./T80/T80.vhd:472:51  */
  assign n326_o = tstate == 3'b010;
  /* ./T80/T80.vhd:472:55  */
  assign n327_o = wait_n & n326_o;
  /* ./T80/T80.vhd:476:75  */
  assign n328_o = r[6:0];
  /* ./T80/T80.vhd:476:88  */
  assign n330_o = n328_o + 7'b0000001;
  /* ./T80/T80.vhd:479:57  */
  assign n331_o = ~jump;
  /* ./T80/T80.vhd:479:72  */
  assign n332_o = ~call;
  /* ./T80/T80.vhd:479:63  */
  assign n333_o = n332_o & n331_o;
  /* ./T80/T80.vhd:479:91  */
  assign n334_o = ~nmicycle;
  /* ./T80/T80.vhd:479:78  */
  assign n335_o = n334_o & n333_o;
  /* ./T80/T80.vhd:479:110  */
  assign n336_o = ~intcycle;
  /* ./T80/T80.vhd:479:97  */
  assign n337_o = n336_o & n335_o;
  /* ./T80/T80.vhd:479:139  */
  assign n338_o = halt_ff | halt;
  /* ./T80/T80.vhd:479:120  */
  assign n339_o = ~n338_o;
  /* ./T80/T80.vhd:479:116  */
  assign n340_o = n339_o & n337_o;
  /* ./T80/T80.vhd:480:66  */
  assign n342_o = pc + 16'b0000000000000001;
  /* ./T80/T80.vhd:472:41  */
  assign n343_o = n385_o ? n342_o : pc;
  /* ./T80/T80.vhd:483:79  */
  assign n345_o = istatus == 2'b01;
  /* ./T80/T80.vhd:483:67  */
  assign n346_o = n345_o & intcycle;
  /* ./T80/T80.vhd:485:100  */
  assign n348_o = istatus == 2'b10;
  /* ./T80/T80.vhd:485:88  */
  assign n349_o = n348_o & intcycle;
  /* ./T80/T80.vhd:485:69  */
  assign n350_o = halt_ff | n349_o;
  /* ./T80/T80.vhd:485:108  */
  assign n351_o = n350_o | nmicycle;
  /* ./T80/T80.vhd:485:49  */
  assign n353_o = n351_o ? 8'b00000000 : dinst;
  /* ./T80/T80.vhd:483:49  */
  assign n355_o = n346_o ? 8'b11111111 : n353_o;
  /* ./T80/T80.vhd:492:59  */
  assign n357_o = prefix != 2'b00;
  /* ./T80/T80.vhd:493:67  */
  assign n359_o = prefix == 2'b11;
  /* ./T80/T80.vhd:494:70  */
  assign n360_o = ir[5];
  /* ./T80/T80.vhd:494:65  */
  assign n363_o = n360_o ? 2'b10 : 2'b01;
  /* ./T80/T80.vhd:500:75  */
  assign n365_o = prefix == 2'b10;
  /* ./T80/T80.vhd:500:65  */
  assign n367_o = n365_o ? 2'b00 : xy_state;
  /* ./T80/T80.vhd:500:65  */
  assign n369_o = n365_o ? 1'b0 : xy_ind;
  /* ./T80/T80.vhd:493:57  */
  assign n371_o = n359_o ? 2'b00 : prefix;
  /* ./T80/T80.vhd:493:57  */
  assign n372_o = n359_o ? n363_o : n367_o;
  /* ./T80/T80.vhd:493:57  */
  assign n373_o = n359_o ? xy_ind : n369_o;
  /* ./T80/T80.vhd:492:49  */
  assign n375_o = n357_o ? n371_o : 2'b00;
  /* ./T80/T80.vhd:492:49  */
  assign n378_o = n357_o ? n372_o : 2'b00;
  /* ./T80/T80.vhd:492:49  */
  assign n380_o = n357_o ? n373_o : 1'b0;
  assign n381_o = {i, r};
  /* ./T80/T80.vhd:472:41  */
  assign n382_o = n327_o ? n381_o : n2052_q;
  assign n383_o = r[6:0];
  /* ./T80/T80.vhd:469:33  */
  assign n384_o = n721_o ? n330_o : n383_o;
  /* ./T80/T80.vhd:472:41  */
  assign n385_o = n340_o & n327_o;
  /* ./T80/T80.vhd:472:41  */
  assign n386_o = n327_o ? n355_o : ir;
  /* ./T80/T80.vhd:472:41  */
  assign n387_o = n327_o ? n375_o : iset;
  /* ./T80/T80.vhd:450:25  */
  assign n388_o = n1146_o ? n378_o : xy_state;
  /* ./T80/T80.vhd:472:41  */
  assign n389_o = n327_o ? n380_o : xy_ind;
  /* ./T80/T80.vhd:515:51  */
  assign n391_o = mcycle == 3'b110;
  /* ./T80/T80.vhd:517:59  */
  assign n393_o = prefix == 2'b01;
  /* ./T80/T80.vhd:515:41  */
  assign n395_o = n396_o ? 2'b01 : iset;
  /* ./T80/T80.vhd:515:41  */
  assign n396_o = n393_o & n391_o;
  /* ./T80/T80.vhd:515:41  */
  assign n398_o = n391_o ? 1'b1 : xy_ind;
  /* ./T80/T80.vhd:523:64  */
  assign n399_o = i_bt | i_bc;
  /* ./T80/T80.vhd:523:72  */
  assign n400_o = n399_o | i_btr;
  /* ./T80/T80.vhd:523:86  */
  assign n401_o = ~no_btr;
  /* ./T80/T80.vhd:523:82  */
  assign n402_o = n400_o & n401_o;
  /* ./T80/T80.vhd:526:76  */
  assign n403_o = wz[7:0];
  /* ./T80/T80.vhd:528:86  */
  assign n404_o = wz[7:0];
  /* ./T80/T80.vhd:532:66  */
  assign n405_o = call | rstp;
  /* ./T80/T80.vhd:535:62  */
  assign n406_o = mcycle == mcycles;
  /* ./T80/T80.vhd:535:72  */
  assign n407_o = nmicycle & n406_o;
  /* ./T80/T80.vhd:538:62  */
  assign n409_o = mcycle == 3'b011;
  /* ./T80/T80.vhd:538:70  */
  assign n410_o = intcycle & n409_o;
  /* ./T80/T80.vhd:538:101  */
  assign n412_o = istatus == 2'b10;
  /* ./T80/T80.vhd:538:89  */
  assign n413_o = n412_o & n410_o;
  /* ./T80/T80.vhd:540:76  */
  assign n414_o = wz[7:0];
  /* ./T80/T80.vhd:542:86  */
  assign n415_o = wz[7:0];
  /* ./T80/T80.vhd:546:77  */
  assign n417_o = xy_state == 2'b00;
  /* ./T80/T80.vhd:549:73  */
  assign n418_o = nextis_xy_fetch ? pc : wz;
  /* ./T80/T80.vhd:546:65  */
  assign n419_o = n417_o ? regbusc : n418_o;
  /* ./T80/T80.vhd:545:57  */
  assign n421_o = set_addr_to == 3'b010;
  /* ./T80/T80.vhd:566:76  */
  assign n422_o = {acc, di_reg};
  /* ./T80/T80.vhd:566:86  */
  assign n425_o = n422_o + 16'b0000000000000001;
  /* ./T80/T80.vhd:555:57  */
  assign n427_o = set_addr_to == 3'b100;
  /* ./T80/T80.vhd:567:57  */
  assign n429_o = set_addr_to == 3'b101;
  /* ./T80/T80.vhd:576:82  */
  assign n431_o = setwz == 2'b01;
  /* ./T80/T80.vhd:577:95  */
  assign n434_o = regbusc + 16'b0000000000000001;
  /* ./T80/T80.vhd:576:73  */
  assign n435_o = n431_o ? n434_o : wz;
  /* ./T80/T80.vhd:579:82  */
  assign n437_o = setwz == 2'b10;
  /* ./T80/T80.vhd:580:106  */
  assign n438_o = regbusc[7:0];
  /* ./T80/T80.vhd:580:119  */
  assign n441_o = n438_o + 8'b00000001;
  assign n442_o = {acc, n441_o};
  /* ./T80/T80.vhd:579:73  */
  assign n443_o = n437_o ? n442_o : n435_o;
  /* ./T80/T80.vhd:569:57  */
  assign n445_o = set_addr_to == 3'b000;
  /* ./T80/T80.vhd:586:74  */
  assign n447_o = setwz == 2'b10;
  /* ./T80/T80.vhd:587:98  */
  assign n448_o = regbusc[7:0];
  /* ./T80/T80.vhd:587:111  */
  assign n451_o = n448_o + 8'b00000001;
  assign n452_o = {acc, n451_o};
  /* ./T80/T80.vhd:586:65  */
  assign n453_o = n447_o ? n452_o : wz;
  /* ./T80/T80.vhd:584:57  */
  assign n455_o = set_addr_to == 3'b001;
  /* ./T80/T80.vhd:592:108  */
  assign n457_o = wz + 16'b0000000000000001;
  /* ./T80/T80.vhd:595:92  */
  assign n458_o = wz[7:0];
  /* ./T80/T80.vhd:596:82  */
  assign n460_o = setwz == 2'b10;
  /* ./T80/T80.vhd:597:101  */
  assign n461_o = wz[7:0];
  /* ./T80/T80.vhd:597:114  */
  assign n464_o = n461_o + 8'b00000001;
  assign n465_o = {acc, n464_o};
  /* ./T80/T80.vhd:596:73  */
  assign n466_o = n460_o ? n465_o : wz;
  assign n467_o = {di_reg, n458_o};
  /* ./T80/T80.vhd:591:65  */
  assign n468_o = inc_wz ? n457_o : n467_o;
  /* ./T80/T80.vhd:591:65  */
  assign n469_o = inc_wz ? wz : n466_o;
  /* ./T80/T80.vhd:590:57  */
  assign n471_o = set_addr_to == 3'b110;
  assign n472_o = {n471_o, n455_o, n445_o, n429_o, n427_o, n421_o};
  assign n473_o = n419_o[7:0];
  assign n474_o = sp[7:0];
  assign n475_o = regbusc[7:0];
  assign n476_o = regbusc[7:0];
  assign n477_o = n468_o[7:0];
  assign n478_o = pc[7:0];
  /* ./T80/T80.vhd:544:57  */
  always @*
    case (n472_o)
      6'b100000: n479_o = n477_o;
      6'b010000: n479_o = n476_o;
      6'b001000: n479_o = n475_o;
      6'b000100: n479_o = n474_o;
      6'b000010: n479_o = di_reg;
      6'b000001: n479_o = n473_o;
      default: n479_o = n478_o;
    endcase
  assign n480_o = n419_o[15:8];
  assign n481_o = sp[15:8];
  assign n482_o = regbusc[15:8];
  assign n483_o = regbusc[15:8];
  assign n484_o = n468_o[15:8];
  assign n485_o = pc[15:8];
  /* ./T80/T80.vhd:544:57  */
  always @*
    case (n472_o)
      6'b100000: n486_o = n484_o;
      6'b010000: n486_o = n483_o;
      6'b001000: n486_o = n482_o;
      6'b000100: n486_o = n481_o;
      6'b000010: n486_o = acc;
      6'b000001: n486_o = n480_o;
      default: n486_o = n485_o;
    endcase
  /* ./T80/T80.vhd:544:57  */
  always @*
    case (n472_o)
      6'b100000: n487_o = n469_o;
      6'b010000: n487_o = n453_o;
      6'b001000: n487_o = n443_o;
      6'b000100: n487_o = wz;
      6'b000010: n487_o = n425_o;
      6'b000001: n487_o = wz;
      default: n487_o = wz;
    endcase
  assign n488_o = {n486_o, n479_o};
  assign n489_o = {i, n414_o};
  /* ./T80/T80.vhd:538:49  */
  assign n490_o = n413_o ? n489_o : n488_o;
  assign n491_o = {i, n415_o};
  /* ./T80/T80.vhd:538:49  */
  assign n492_o = n413_o ? n491_o : pc;
  /* ./T80/T80.vhd:538:49  */
  assign n493_o = n413_o ? wz : n487_o;
  /* ./T80/T80.vhd:535:49  */
  assign n495_o = n407_o ? 16'b0000000001100110 : n490_o;
  /* ./T80/T80.vhd:535:49  */
  assign n497_o = n407_o ? 16'b0000000001100110 : n492_o;
  /* ./T80/T80.vhd:535:49  */
  assign n498_o = n407_o ? wz : n493_o;
  /* ./T80/T80.vhd:532:49  */
  assign n499_o = n405_o ? wz : n495_o;
  /* ./T80/T80.vhd:532:49  */
  assign n500_o = n405_o ? wz : n497_o;
  /* ./T80/T80.vhd:532:49  */
  assign n501_o = n405_o ? wz : n498_o;
  /* ./T80/T80.vhd:529:49  */
  assign n502_o = jumpxy ? regbusc : n499_o;
  /* ./T80/T80.vhd:529:49  */
  assign n503_o = jumpxy ? regbusc : n500_o;
  /* ./T80/T80.vhd:529:49  */
  assign n504_o = jumpxy ? wz : n501_o;
  assign n505_o = {di_reg, n403_o};
  /* ./T80/T80.vhd:524:49  */
  assign n506_o = jump ? n505_o : n502_o;
  assign n507_o = {di_reg, n404_o};
  /* ./T80/T80.vhd:524:49  */
  assign n508_o = jump ? n507_o : n503_o;
  /* ./T80/T80.vhd:524:49  */
  assign n509_o = jump ? wz : n504_o;
  /* ./T80/T80.vhd:606:58  */
  assign n511_o = setwz == 2'b11;
  /* ./T80/T80.vhd:606:49  */
  assign n512_o = n511_o ? id16 : n509_o;
  /* ./T80/T80.vhd:615:64  */
  assign n513_o = ~acc;
  /* ./T80/T80.vhd:616:77  */
  assign n514_o = acc[5];
  /* ./T80/T80.vhd:616:70  */
  assign n515_o = ~n514_o;
  /* ./T80/T80.vhd:618:77  */
  assign n517_o = acc[3];
  /* ./T80/T80.vhd:618:70  */
  assign n518_o = ~n517_o;
  /* ./T80/T80.vhd:522:41  */
  assign n520_o = n548_o ? n513_o : acc;
  assign n521_o = {n515_o, 1'b1, n518_o};
  assign n522_o = f[1];
  /* ./T80/T80.vhd:613:49  */
  assign n523_o = i_cpl ? 1'b1 : n522_o;
  /* ./T80/T80.vhd:623:75  */
  assign n526_o = f[0];
  /* ./T80/T80.vhd:623:70  */
  assign n527_o = ~n526_o;
  /* ./T80/T80.vhd:624:73  */
  assign n528_o = acc[5];
  /* ./T80/T80.vhd:625:71  */
  assign n529_o = f[0];
  /* ./T80/T80.vhd:626:73  */
  assign n530_o = acc[3];
  assign n532_o = {1'b0, n527_o};
  assign n533_o = {n528_o, n529_o, n530_o};
  assign n534_o = f[0];
  assign n535_o = {n523_o, n534_o};
  /* ./T80/T80.vhd:621:49  */
  assign n536_o = i_ccf ? n532_o : n535_o;
  /* ./T80/T80.vhd:632:73  */
  assign n539_o = acc[5];
  /* ./T80/T80.vhd:634:73  */
  assign n541_o = acc[3];
  assign n543_o = {1'b0, 1'b1};
  assign n544_o = {n539_o, 1'b0, n541_o};
  /* ./T80/T80.vhd:629:49  */
  assign n545_o = i_scf ? n543_o : n536_o;
  /* ./T80/T80.vhd:522:41  */
  assign n547_o = t_res ? n506_o : n2052_q;
  /* ./T80/T80.vhd:522:41  */
  assign n548_o = i_cpl & t_res;
  assign n549_o = f[1:0];
  /* ./T80/T80.vhd:522:41  */
  assign n550_o = t_res ? n545_o : n549_o;
  /* ./T80/T80.vhd:522:41  */
  assign n553_o = t_res ? n508_o : pc;
  /* ./T80/T80.vhd:522:41  */
  assign n554_o = t_res ? n512_o : wz;
  /* ./T80/T80.vhd:522:41  */
  assign n555_o = t_res ? n402_o : btr_r;
  /* ./T80/T80.vhd:522:41  */
  assign n557_o = t_res ? alu_op : 4'b0000;
  /* ./T80/T80.vhd:522:41  */
  assign n559_o = t_res ? save_alu : 1'b0;
  /* ./T80/T80.vhd:639:52  */
  assign n561_o = tstate == 3'b010;
  /* ./T80/T80.vhd:639:56  */
  assign n562_o = i_btr & n561_o;
  /* ./T80/T80.vhd:639:78  */
  assign n563_o = ir[0];
  /* ./T80/T80.vhd:639:72  */
  assign n564_o = n563_o & n562_o;
  /* ./T80/T80.vhd:639:100  */
  assign n566_o = tstate == 3'b001;
  /* ./T80/T80.vhd:639:104  */
  assign n567_o = i_btr & n566_o;
  /* ./T80/T80.vhd:639:126  */
  assign n568_o = ir[0];
  /* ./T80/T80.vhd:639:130  */
  assign n569_o = ~n568_o;
  /* ./T80/T80.vhd:639:120  */
  assign n570_o = n569_o & n567_o;
  /* ./T80/T80.vhd:639:89  */
  assign n571_o = n564_o | n570_o;
  /* ./T80/T80.vhd:640:61  */
  assign n573_o = {1'b0, di_reg};
  /* ./T80/T80.vhd:640:101  */
  assign n574_o = id16[7:0];
  /* ./T80/T80.vhd:640:78  */
  assign n576_o = {1'b0, n574_o};
  /* ./T80/T80.vhd:640:71  */
  assign n577_o = n573_o + n576_o;
  /* ./T80/T80.vhd:641:68  */
  assign n578_o = di_reg[7];
  /* ./T80/T80.vhd:642:65  */
  assign n579_o = n577_o[8];
  /* ./T80/T80.vhd:643:65  */
  assign n580_o = n577_o[8];
  /* ./T80/T80.vhd:644:61  */
  assign n582_o = n577_o & 9'b000000111;
  /* ./T80/T80.vhd:644:86  */
  assign n584_o = {1'b0, busa};
  /* ./T80/T80.vhd:644:78  */
  assign n585_o = n582_o ^ n584_o;
  /* ./T80/T80.vhd:645:70  */
  assign n586_o = n585_o[0];
  /* ./T80/T80.vhd:645:81  */
  assign n587_o = n585_o[1];
  /* ./T80/T80.vhd:645:74  */
  assign n588_o = n586_o ^ n587_o;
  /* ./T80/T80.vhd:645:92  */
  assign n589_o = n585_o[2];
  /* ./T80/T80.vhd:645:85  */
  assign n590_o = n588_o ^ n589_o;
  /* ./T80/T80.vhd:645:103  */
  assign n591_o = n585_o[3];
  /* ./T80/T80.vhd:645:96  */
  assign n592_o = n590_o ^ n591_o;
  /* ./T80/T80.vhd:645:114  */
  assign n593_o = n585_o[4];
  /* ./T80/T80.vhd:645:107  */
  assign n594_o = n592_o ^ n593_o;
  /* ./T80/T80.vhd:645:125  */
  assign n595_o = n585_o[5];
  /* ./T80/T80.vhd:645:118  */
  assign n596_o = n594_o ^ n595_o;
  /* ./T80/T80.vhd:645:136  */
  assign n597_o = n585_o[6];
  /* ./T80/T80.vhd:645:129  */
  assign n598_o = n596_o ^ n597_o;
  /* ./T80/T80.vhd:645:147  */
  assign n599_o = n585_o[7];
  /* ./T80/T80.vhd:645:140  */
  assign n600_o = n598_o ^ n599_o;
  /* ./T80/T80.vhd:645:62  */
  assign n601_o = ~n600_o;
  assign n602_o = {n601_o, n578_o, n579_o};
  assign n603_o = f[2];
  assign n604_o = {n603_o, n550_o};
  /* ./T80/T80.vhd:639:41  */
  assign n605_o = n571_o ? n602_o : n604_o;
  assign n606_o = n544_o[1];
  assign n607_o = n533_o[1];
  assign n608_o = n521_o[1];
  assign n609_o = f[4];
  /* ./T80/T80.vhd:613:49  */
  assign n610_o = i_cpl ? n608_o : n609_o;
  /* ./T80/T80.vhd:621:49  */
  assign n611_o = i_ccf ? n607_o : n610_o;
  /* ./T80/T80.vhd:629:49  */
  assign n612_o = i_scf ? n606_o : n611_o;
  assign n613_o = f[4];
  /* ./T80/T80.vhd:522:41  */
  assign n614_o = t_res ? n612_o : n613_o;
  /* ./T80/T80.vhd:639:41  */
  assign n615_o = n571_o ? n580_o : n614_o;
  assign n616_o = n544_o[2];
  assign n617_o = n533_o[2];
  assign n618_o = n521_o[2];
  assign n619_o = f[5];
  /* ./T80/T80.vhd:613:49  */
  assign n620_o = i_cpl ? n618_o : n619_o;
  /* ./T80/T80.vhd:621:49  */
  assign n621_o = i_ccf ? n617_o : n620_o;
  /* ./T80/T80.vhd:629:49  */
  assign n622_o = i_scf ? n616_o : n621_o;
  assign n623_o = f[5];
  /* ./T80/T80.vhd:522:41  */
  assign n624_o = t_res ? n622_o : n623_o;
  assign n625_o = n544_o[0];
  assign n626_o = n533_o[0];
  assign n627_o = n521_o[0];
  assign n628_o = f[3];
  /* ./T80/T80.vhd:613:49  */
  assign n629_o = i_cpl ? n627_o : n628_o;
  /* ./T80/T80.vhd:621:49  */
  assign n630_o = i_ccf ? n626_o : n629_o;
  /* ./T80/T80.vhd:629:49  */
  assign n631_o = i_scf ? n625_o : n630_o;
  assign n632_o = f[3];
  /* ./T80/T80.vhd:522:41  */
  assign n633_o = t_res ? n631_o : n632_o;
  /* ./T80/T80.vhd:648:51  */
  assign n636_o = tstate == 3'b010;
  /* ./T80/T80.vhd:648:55  */
  assign n637_o = wait_n & n636_o;
  /* ./T80/T80.vhd:649:57  */
  assign n639_o = iset == 2'b01;
  /* ./T80/T80.vhd:649:75  */
  assign n641_o = mcycle == 3'b111;
  /* ./T80/T80.vhd:649:64  */
  assign n642_o = n641_o & n639_o;
  /* ./T80/T80.vhd:648:41  */
  assign n643_o = n664_o ? dinst : ir;
  /* ./T80/T80.vhd:653:83  */
  assign n644_o = {{8{di_reg[7]}}, di_reg}; // sext
  /* ./T80/T80.vhd:653:83  */
  assign n645_o = pc + n644_o;
  /* ./T80/T80.vhd:654:91  */
  assign n646_o = {{8{di_reg[7]}}, di_reg}; // sext
  /* ./T80/T80.vhd:654:91  */
  assign n647_o = pc + n646_o;
  /* ./T80/T80.vhd:656:66  */
  assign n649_o = pc + 16'b0000000000000001;
  /* ./T80/T80.vhd:655:49  */
  assign n650_o = inc_pc ? n649_o : n553_o;
  /* ./T80/T80.vhd:652:49  */
  assign n651_o = jumpe ? n645_o : n650_o;
  /* ./T80/T80.vhd:652:49  */
  assign n652_o = jumpe ? n647_o : n554_o;
  /* ./T80/T80.vhd:659:66  */
  assign n654_o = pc - 16'b0000000000000010;
  /* ./T80/T80.vhd:658:49  */
  assign n655_o = btr_r ? n654_o : n651_o;
  /* ./T80/T80.vhd:663:77  */
  assign n656_o = ir[5:3];
  assign n658_o = n657_o[15:6];
  assign n659_o = n657_o[2:0];
  assign n660_o = {n658_o, n656_o, n659_o};
  /* ./T80/T80.vhd:661:49  */
  assign n661_o = rstp ? n660_o : n652_o;
  /* ./T80/T80.vhd:648:41  */
  assign n662_o = n637_o ? n655_o : n553_o;
  /* ./T80/T80.vhd:648:41  */
  assign n663_o = n637_o ? n661_o : n554_o;
  /* ./T80/T80.vhd:648:41  */
  assign n664_o = n642_o & n637_o;
  /* ./T80/T80.vhd:666:51  */
  assign n666_o = tstate == 3'b011;
  /* ./T80/T80.vhd:666:66  */
  assign n668_o = mcycle == 3'b110;
  /* ./T80/T80.vhd:666:55  */
  assign n669_o = n668_o & n666_o;
  /* ./T80/T80.vhd:667:88  */
  assign n670_o = {{8{di_reg[7]}}, di_reg}; // sext
  /* ./T80/T80.vhd:667:88  */
  assign n671_o = regbusc + n670_o;
  /* ./T80/T80.vhd:666:41  */
  assign n672_o = n669_o ? n671_o : n663_o;
  /* ./T80/T80.vhd:670:51  */
  assign n674_o = mcycle == 3'b011;
  /* ./T80/T80.vhd:670:70  */
  assign n676_o = tstate == 3'b100;
  /* ./T80/T80.vhd:670:59  */
  assign n677_o = n676_o & n674_o;
  /* ./T80/T80.vhd:670:85  */
  assign n678_o = ~no_btr;
  /* ./T80/T80.vhd:670:74  */
  assign n679_o = n678_o & n677_o;
  /* ./T80/T80.vhd:671:63  */
  assign n680_o = i_bt | i_bc;
  /* ./T80/T80.vhd:672:83  */
  assign n683_o = pc - 16'b0000000000000001;
  /* ./T80/T80.vhd:670:41  */
  assign n684_o = n685_o ? n683_o : n672_o;
  /* ./T80/T80.vhd:670:41  */
  assign n685_o = n680_o & n679_o;
  /* ./T80/T80.vhd:676:52  */
  assign n687_o = tstate == 3'b010;
  /* ./T80/T80.vhd:676:56  */
  assign n688_o = wait_n & n687_o;
  /* ./T80/T80.vhd:676:85  */
  assign n690_o = tstate == 3'b100;
  /* ./T80/T80.vhd:676:100  */
  assign n692_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:676:89  */
  assign n693_o = n692_o & n690_o;
  /* ./T80/T80.vhd:676:74  */
  assign n694_o = n688_o | n693_o;
  /* ./T80/T80.vhd:677:61  */
  assign n695_o = incdec_16[2:0];
  /* ./T80/T80.vhd:677:74  */
  assign n697_o = n695_o == 3'b111;
  /* ./T80/T80.vhd:678:69  */
  assign n698_o = incdec_16[3];
  /* ./T80/T80.vhd:679:74  */
  assign n700_o = sp - 16'b0000000000000001;
  /* ./T80/T80.vhd:681:74  */
  assign n702_o = sp + 16'b0000000000000001;
  /* ./T80/T80.vhd:678:57  */
  assign n703_o = n698_o ? n700_o : n702_o;
  /* ./T80/T80.vhd:676:41  */
  assign n704_o = n705_o ? n703_o : sp;
  /* ./T80/T80.vhd:676:41  */
  assign n705_o = n697_o & n694_o;
  /* ./T80/T80.vhd:686:41  */
  assign n706_o = ldsphl ? regbusc : n704_o;
  /* ./T80/T80.vhd:689:41  */
  assign n707_o = exchangeaf ? ap : n520_o;
  assign n708_o = f[7:6];
  assign n709_o = {n708_o, n624_o, n615_o, n633_o, n605_o};
  /* ./T80/T80.vhd:689:41  */
  assign n711_o = exchangeaf ? acc : ap;
  /* ./T80/T80.vhd:689:41  */
  assign n712_o = exchangeaf ? f : fp;
  /* ./T80/T80.vhd:696:62  */
  assign n713_o = ~alternate;
  /* ./T80/T80.vhd:695:41  */
  assign n714_o = exchangers ? n713_o : alternate;
  /* ./T80/T80.vhd:469:33  */
  assign n715_o = n324_o ? n382_o : n547_o;
  /* ./T80/T80.vhd:469:33  */
  assign n716_o = n324_o ? acc : n707_o;
  /* ./T80/T80.vhd:469:33  */
  assign n718_o = n324_o ? ap : n711_o;
  /* ./T80/T80.vhd:469:33  */
  assign n719_o = n324_o ? fp : n712_o;
  /* ./T80/T80.vhd:469:33  */
  assign n721_o = n327_o & n324_o;
  /* ./T80/T80.vhd:469:33  */
  assign n722_o = n324_o ? sp : n706_o;
  /* ./T80/T80.vhd:469:33  */
  assign n723_o = n324_o ? n343_o : n662_o;
  /* ./T80/T80.vhd:469:33  */
  assign n724_o = n324_o ? alternate : n714_o;
  /* ./T80/T80.vhd:469:33  */
  assign n725_o = n324_o ? wz : n684_o;
  /* ./T80/T80.vhd:469:33  */
  assign n726_o = n324_o ? n386_o : n643_o;
  /* ./T80/T80.vhd:469:33  */
  assign n727_o = n324_o ? n387_o : n395_o;
  /* ./T80/T80.vhd:469:33  */
  assign n728_o = n327_o & n324_o;
  /* ./T80/T80.vhd:469:33  */
  assign n729_o = n324_o ? n389_o : n398_o;
  /* ./T80/T80.vhd:469:33  */
  assign n730_o = n324_o ? btr_r : n555_o;
  /* ./T80/T80.vhd:469:33  */
  assign n732_o = n324_o ? 4'b0000 : n557_o;
  /* ./T80/T80.vhd:469:33  */
  assign n735_o = n324_o ? 1'b0 : n559_o;
  /* ./T80/T80.vhd:700:43  */
  assign n739_o = tstate == 3'b011;
  assign n740_o = wz[7:0];
  assign n741_o = n683_o[7:0];
  assign n742_o = n671_o[7:0];
  assign n743_o = n660_o[7:0];
  assign n744_o = n647_o[7:0];
  assign n745_o = id16[7:0];
  assign n746_o = wz[7:0];
  assign n747_o = wz[7:0];
  assign n748_o = wz[7:0];
  assign n749_o = wz[7:0];
  assign n750_o = wz[7:0];
  assign n751_o = n487_o[7:0];
  /* ./T80/T80.vhd:538:49  */
  assign n752_o = n413_o ? n750_o : n751_o;
  /* ./T80/T80.vhd:535:49  */
  assign n753_o = n407_o ? n749_o : n752_o;
  /* ./T80/T80.vhd:532:49  */
  assign n754_o = n405_o ? n748_o : n753_o;
  /* ./T80/T80.vhd:529:49  */
  assign n755_o = jumpxy ? n747_o : n754_o;
  /* ./T80/T80.vhd:524:49  */
  assign n756_o = jump ? n746_o : n755_o;
  /* ./T80/T80.vhd:606:49  */
  assign n757_o = n511_o ? n745_o : n756_o;
  assign n758_o = wz[7:0];
  /* ./T80/T80.vhd:522:41  */
  assign n759_o = t_res ? n757_o : n758_o;
  /* ./T80/T80.vhd:652:49  */
  assign n760_o = jumpe ? n744_o : n759_o;
  /* ./T80/T80.vhd:661:49  */
  assign n761_o = rstp ? n743_o : n760_o;
  assign n762_o = id16[7:0];
  assign n763_o = wz[7:0];
  assign n764_o = wz[7:0];
  assign n765_o = wz[7:0];
  assign n766_o = wz[7:0];
  assign n767_o = wz[7:0];
  assign n768_o = n487_o[7:0];
  /* ./T80/T80.vhd:538:49  */
  assign n769_o = n413_o ? n767_o : n768_o;
  /* ./T80/T80.vhd:535:49  */
  assign n770_o = n407_o ? n766_o : n769_o;
  /* ./T80/T80.vhd:532:49  */
  assign n771_o = n405_o ? n765_o : n770_o;
  /* ./T80/T80.vhd:529:49  */
  assign n772_o = jumpxy ? n764_o : n771_o;
  /* ./T80/T80.vhd:524:49  */
  assign n773_o = jump ? n763_o : n772_o;
  /* ./T80/T80.vhd:606:49  */
  assign n774_o = n511_o ? n762_o : n773_o;
  assign n775_o = wz[7:0];
  /* ./T80/T80.vhd:522:41  */
  assign n776_o = t_res ? n774_o : n775_o;
  /* ./T80/T80.vhd:648:41  */
  assign n777_o = n637_o ? n761_o : n776_o;
  /* ./T80/T80.vhd:666:41  */
  assign n778_o = n669_o ? n742_o : n777_o;
  /* ./T80/T80.vhd:670:41  */
  assign n779_o = n685_o ? n741_o : n778_o;
  /* ./T80/T80.vhd:469:33  */
  assign n780_o = n324_o ? n740_o : n779_o;
  /* ./T80/T80.vhd:701:41  */
  assign n781_o = ldz ? di_reg : n780_o;
  assign n782_o = wz[15:8];
  assign n783_o = n683_o[15:8];
  assign n784_o = n671_o[15:8];
  assign n785_o = n660_o[15:8];
  assign n786_o = n647_o[15:8];
  assign n787_o = id16[15:8];
  assign n788_o = wz[15:8];
  assign n789_o = wz[15:8];
  assign n790_o = wz[15:8];
  assign n791_o = wz[15:8];
  assign n792_o = wz[15:8];
  assign n793_o = n487_o[15:8];
  /* ./T80/T80.vhd:538:49  */
  assign n794_o = n413_o ? n792_o : n793_o;
  /* ./T80/T80.vhd:535:49  */
  assign n795_o = n407_o ? n791_o : n794_o;
  /* ./T80/T80.vhd:532:49  */
  assign n796_o = n405_o ? n790_o : n795_o;
  /* ./T80/T80.vhd:529:49  */
  assign n797_o = jumpxy ? n789_o : n796_o;
  /* ./T80/T80.vhd:524:49  */
  assign n798_o = jump ? n788_o : n797_o;
  /* ./T80/T80.vhd:606:49  */
  assign n799_o = n511_o ? n787_o : n798_o;
  assign n800_o = wz[15:8];
  /* ./T80/T80.vhd:522:41  */
  assign n801_o = t_res ? n799_o : n800_o;
  /* ./T80/T80.vhd:652:49  */
  assign n802_o = jumpe ? n786_o : n801_o;
  /* ./T80/T80.vhd:661:49  */
  assign n803_o = rstp ? n785_o : n802_o;
  assign n804_o = id16[15:8];
  assign n805_o = wz[15:8];
  assign n806_o = wz[15:8];
  assign n807_o = wz[15:8];
  assign n808_o = wz[15:8];
  assign n809_o = wz[15:8];
  assign n810_o = n487_o[15:8];
  /* ./T80/T80.vhd:538:49  */
  assign n811_o = n413_o ? n809_o : n810_o;
  /* ./T80/T80.vhd:535:49  */
  assign n812_o = n407_o ? n808_o : n811_o;
  /* ./T80/T80.vhd:532:49  */
  assign n813_o = n405_o ? n807_o : n812_o;
  /* ./T80/T80.vhd:529:49  */
  assign n814_o = jumpxy ? n806_o : n813_o;
  /* ./T80/T80.vhd:524:49  */
  assign n815_o = jump ? n805_o : n814_o;
  /* ./T80/T80.vhd:606:49  */
  assign n816_o = n511_o ? n804_o : n815_o;
  assign n817_o = wz[15:8];
  /* ./T80/T80.vhd:522:41  */
  assign n818_o = t_res ? n816_o : n817_o;
  /* ./T80/T80.vhd:648:41  */
  assign n819_o = n637_o ? n803_o : n818_o;
  /* ./T80/T80.vhd:666:41  */
  assign n820_o = n669_o ? n784_o : n819_o;
  /* ./T80/T80.vhd:670:41  */
  assign n821_o = n685_o ? n783_o : n820_o;
  /* ./T80/T80.vhd:469:33  */
  assign n822_o = n324_o ? n782_o : n821_o;
  /* ./T80/T80.vhd:704:41  */
  assign n823_o = ldw ? di_reg : n822_o;
  /* ./T80/T80.vhd:708:54  */
  assign n824_o = special_ld[2];
  /* ./T80/T80.vhd:709:64  */
  assign n825_o = special_ld[1:0];
  /* ./T80/T80.vhd:713:71  */
  assign n826_o = i[7];
  /* ./T80/T80.vhd:715:62  */
  assign n828_o = i == 8'b00000000;
  /* ./T80/T80.vhd:715:57  */
  assign n831_o = n828_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:721:71  */
  assign n832_o = i[5];
  /* ./T80/T80.vhd:723:71  */
  assign n834_o = i[3];
  /* ./T80/T80.vhd:710:49  */
  assign n837_o = n825_o == 2'b00;
  /* ./T80/T80.vhd:730:71  */
  assign n838_o = r[7];
  /* ./T80/T80.vhd:732:62  */
  assign n840_o = r == 8'b00000000;
  /* ./T80/T80.vhd:732:57  */
  assign n843_o = n840_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:738:71  */
  assign n844_o = r[5];
  /* ./T80/T80.vhd:740:71  */
  assign n846_o = r[3];
  /* ./T80/T80.vhd:727:49  */
  assign n849_o = n825_o == 2'b01;
  /* ./T80/T80.vhd:743:49  */
  assign n851_o = n825_o == 2'b10;
  assign n852_o = {n851_o, n849_o, n837_o};
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n853_o = n716_o;
      3'b010: n853_o = r;
      3'b001: n853_o = i;
      default: n853_o = n716_o;
    endcase
  assign n854_o = f[1];
  assign n855_o = fp[1];
  assign n856_o = n709_o[1];
  /* ./T80/T80.vhd:689:41  */
  assign n857_o = exchangeaf ? n855_o : n856_o;
  /* ./T80/T80.vhd:469:33  */
  assign n858_o = n324_o ? n854_o : n857_o;
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n859_o = n858_o;
      3'b010: n859_o = 1'b0;
      3'b001: n859_o = 1'b0;
      default: n859_o = n858_o;
    endcase
  assign n860_o = f[2];
  assign n861_o = fp[2];
  assign n862_o = n709_o[2];
  /* ./T80/T80.vhd:689:41  */
  assign n863_o = exchangeaf ? n861_o : n862_o;
  /* ./T80/T80.vhd:469:33  */
  assign n864_o = n324_o ? n860_o : n863_o;
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n865_o = n864_o;
      3'b010: n865_o = inte_ff2;
      3'b001: n865_o = inte_ff2;
      default: n865_o = n864_o;
    endcase
  assign n866_o = f[3];
  assign n867_o = fp[3];
  assign n868_o = n709_o[3];
  /* ./T80/T80.vhd:689:41  */
  assign n869_o = exchangeaf ? n867_o : n868_o;
  /* ./T80/T80.vhd:469:33  */
  assign n870_o = n324_o ? n866_o : n869_o;
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n871_o = n870_o;
      3'b010: n871_o = n846_o;
      3'b001: n871_o = n834_o;
      default: n871_o = n870_o;
    endcase
  assign n872_o = f[4];
  assign n873_o = fp[4];
  assign n874_o = n709_o[4];
  /* ./T80/T80.vhd:689:41  */
  assign n875_o = exchangeaf ? n873_o : n874_o;
  /* ./T80/T80.vhd:469:33  */
  assign n876_o = n324_o ? n872_o : n875_o;
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n877_o = n876_o;
      3'b010: n877_o = 1'b0;
      3'b001: n877_o = 1'b0;
      default: n877_o = n876_o;
    endcase
  assign n878_o = f[5];
  assign n879_o = fp[5];
  assign n880_o = n709_o[5];
  /* ./T80/T80.vhd:689:41  */
  assign n881_o = exchangeaf ? n879_o : n880_o;
  /* ./T80/T80.vhd:469:33  */
  assign n882_o = n324_o ? n878_o : n881_o;
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n883_o = n882_o;
      3'b010: n883_o = n844_o;
      3'b001: n883_o = n832_o;
      default: n883_o = n882_o;
    endcase
  assign n884_o = f[6];
  assign n885_o = fp[6];
  assign n886_o = n709_o[6];
  /* ./T80/T80.vhd:689:41  */
  assign n887_o = exchangeaf ? n885_o : n886_o;
  /* ./T80/T80.vhd:469:33  */
  assign n888_o = n324_o ? n884_o : n887_o;
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n889_o = n888_o;
      3'b010: n889_o = n843_o;
      3'b001: n889_o = n831_o;
      default: n889_o = n888_o;
    endcase
  assign n890_o = f[7];
  assign n891_o = fp[7];
  assign n892_o = n709_o[7];
  /* ./T80/T80.vhd:689:41  */
  assign n893_o = exchangeaf ? n891_o : n892_o;
  /* ./T80/T80.vhd:469:33  */
  assign n894_o = n324_o ? n890_o : n893_o;
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n895_o = n894_o;
      3'b010: n895_o = n838_o;
      3'b001: n895_o = n826_o;
      default: n895_o = n894_o;
    endcase
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n896_o = acc;
      3'b010: n896_o = i;
      3'b001: n896_o = i;
      default: n896_o = i;
    endcase
  assign n897_o = r[7];
  assign n898_o = {n897_o, n384_o};
  /* ./T80/T80.vhd:709:49  */
  always @*
    case (n852_o)
      3'b100: n899_o = n898_o;
      3'b010: n899_o = n898_o;
      3'b001: n899_o = n898_o;
      default: n899_o = acc;
    endcase
  /* ./T80/T80.vhd:700:33  */
  assign n900_o = n912_o ? n853_o : n716_o;
  assign n901_o = {n895_o, n889_o, n883_o, n877_o, n871_o, n865_o, n859_o};
  assign n902_o = f[7:1];
  assign n903_o = fp[7:1];
  assign n904_o = n709_o[7:1];
  /* ./T80/T80.vhd:689:41  */
  assign n905_o = exchangeaf ? n903_o : n904_o;
  /* ./T80/T80.vhd:469:33  */
  assign n906_o = n324_o ? n902_o : n905_o;
  /* ./T80/T80.vhd:708:41  */
  assign n907_o = n824_o ? n901_o : n906_o;
  /* ./T80/T80.vhd:450:25  */
  assign n908_o = n1137_o ? n896_o : i;
  assign n909_o = r[7];
  assign n910_o = {n909_o, n384_o};
  /* ./T80/T80.vhd:708:41  */
  assign n911_o = n824_o ? n899_o : n910_o;
  /* ./T80/T80.vhd:700:33  */
  assign n912_o = n824_o & n739_o;
  assign n913_o = f[7:1];
  assign n914_o = fp[7:1];
  assign n915_o = n709_o[7:1];
  /* ./T80/T80.vhd:689:41  */
  assign n916_o = exchangeaf ? n914_o : n915_o;
  /* ./T80/T80.vhd:469:33  */
  assign n917_o = n324_o ? n913_o : n916_o;
  /* ./T80/T80.vhd:700:33  */
  assign n918_o = n739_o ? n907_o : n917_o;
  assign n919_o = f[0];
  assign n920_o = fp[0];
  assign n921_o = n709_o[0];
  /* ./T80/T80.vhd:689:41  */
  assign n922_o = exchangeaf ? n920_o : n921_o;
  /* ./T80/T80.vhd:469:33  */
  assign n923_o = n324_o ? n919_o : n922_o;
  /* ./T80/T80.vhd:700:33  */
  assign n924_o = n824_o & n739_o;
  assign n925_o = r[7];
  assign n926_o = {n925_o, n384_o};
  /* ./T80/T80.vhd:700:33  */
  assign n927_o = n739_o ? n911_o : n926_o;
  assign n928_o = {n823_o, n781_o};
  /* ./T80/T80.vhd:700:33  */
  assign n929_o = n739_o ? n928_o : n725_o;
  /* ./T80/T80.vhd:751:44  */
  assign n930_o = ~i_djnz;
  /* ./T80/T80.vhd:751:50  */
  assign n931_o = save_alu_r & n930_o;
  /* ./T80/T80.vhd:751:84  */
  assign n933_o = alu_op_r == 4'b1001;
  /* ./T80/T80.vhd:751:72  */
  assign n934_o = n931_o | n933_o;
  /* ./T80/T80.vhd:760:71  */
  assign n935_o = f_out[7:1];
  /* ./T80/T80.vhd:761:64  */
  assign n936_o = ~preservec_r;
  /* ./T80/T80.vhd:762:75  */
  assign n937_o = f_out[0];
  /* ./T80/T80.vhd:761:49  */
  assign n938_o = n936_o ? n937_o : n923_o;
  assign n939_o = {n935_o, n938_o};
  assign n940_o = {n918_o, n923_o};
  /* ./T80/T80.vhd:766:48  */
  assign n942_o = i_inrc & t_res;
  /* ./T80/T80.vhd:769:60  */
  assign n945_o = di_reg[3];
  /* ./T80/T80.vhd:770:60  */
  assign n946_o = di_reg[5];
  /* ./T80/T80.vhd:771:63  */
  assign n948_o = di_reg == 8'b00000000;
  /* ./T80/T80.vhd:771:41  */
  assign n951_o = n948_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:776:60  */
  assign n952_o = di_reg[7];
  /* ./T80/T80.vhd:777:65  */
  assign n953_o = di_reg[0];
  /* ./T80/T80.vhd:777:79  */
  assign n954_o = di_reg[1];
  /* ./T80/T80.vhd:777:69  */
  assign n955_o = n953_o ^ n954_o;
  /* ./T80/T80.vhd:777:93  */
  assign n956_o = di_reg[2];
  /* ./T80/T80.vhd:777:83  */
  assign n957_o = n955_o ^ n956_o;
  /* ./T80/T80.vhd:777:107  */
  assign n958_o = di_reg[3];
  /* ./T80/T80.vhd:777:97  */
  assign n959_o = n957_o ^ n958_o;
  /* ./T80/T80.vhd:778:55  */
  assign n960_o = di_reg[4];
  /* ./T80/T80.vhd:777:111  */
  assign n961_o = n959_o ^ n960_o;
  /* ./T80/T80.vhd:778:69  */
  assign n962_o = di_reg[5];
  /* ./T80/T80.vhd:778:59  */
  assign n963_o = n961_o ^ n962_o;
  /* ./T80/T80.vhd:778:83  */
  assign n964_o = di_reg[6];
  /* ./T80/T80.vhd:778:73  */
  assign n965_o = n963_o ^ n964_o;
  /* ./T80/T80.vhd:778:97  */
  assign n966_o = di_reg[7];
  /* ./T80/T80.vhd:778:87  */
  assign n967_o = n965_o ^ n966_o;
  /* ./T80/T80.vhd:777:54  */
  assign n968_o = ~n967_o;
  assign n969_o = {n952_o, n951_o, n946_o, 1'b0, n945_o, n968_o, 1'b0};
  assign n974_o = n939_o[0];
  assign n975_o = n940_o[0];
  /* ./T80/T80.vhd:751:33  */
  assign n976_o = n934_o ? n974_o : n975_o;
  /* ./T80/T80.vhd:781:43  */
  assign n978_o = tstate == 3'b001;
  /* ./T80/T80.vhd:781:64  */
  assign n979_o = ~auto_wait_t1;
  /* ./T80/T80.vhd:781:47  */
  assign n980_o = n979_o & n978_o;
  /* ./T80/T80.vhd:783:57  */
  assign n981_o = i_rld | i_rrd;
  /* ./T80/T80.vhd:784:50  */
  assign n982_o = ~i_rxdd;
  /* ./T80/T80.vhd:784:41  */
  assign n983_o = n982_o ? busb : n2053_q;
  /* ./T80/T80.vhd:788:71  */
  assign n984_o = busa[3:0];
  /* ./T80/T80.vhd:789:71  */
  assign n985_o = busb[3:0];
  assign n986_o = {n985_o, n984_o};
  /* ./T80/T80.vhd:787:41  */
  assign n987_o = i_rld ? n986_o : n983_o;
  /* ./T80/T80.vhd:792:71  */
  assign n988_o = busb[7:4];
  /* ./T80/T80.vhd:793:71  */
  assign n989_o = busa[3:0];
  assign n990_o = {n989_o, n988_o};
  /* ./T80/T80.vhd:791:41  */
  assign n991_o = i_rrd ? n990_o : n987_o;
  /* ./T80/T80.vhd:781:33  */
  assign n992_o = n980_o ? n991_o : n2053_q;
  /* ./T80/T80.vhd:450:25  */
  assign n993_o = n1156_o ? n981_o : i_rxdd;
  assign n996_o = {1'b1, 4'b0111};
  assign n997_o = {read_to_reg, set_busa_to};
  /* ./T80/T80.vhd:800:41  */
  assign n998_o = read_to_acc ? n996_o : n997_o;
  /* ./T80/T80.vhd:797:33  */
  assign n1000_o = t_res ? n998_o : 5'b00000;
  /* ./T80/T80.vhd:806:43  */
  assign n1003_o = tstate == 3'b001;
  /* ./T80/T80.vhd:806:47  */
  assign n1004_o = i_bt & n1003_o;
  /* ./T80/T80.vhd:807:59  */
  assign n1005_o = alu_q[3];
  /* ./T80/T80.vhd:808:59  */
  assign n1006_o = alu_q[1];
  assign n1009_o = {n1006_o, 1'b0, n1005_o};
  assign n1010_o = n969_o[0];
  assign n1011_o = n939_o[1];
  assign n1012_o = n940_o[1];
  /* ./T80/T80.vhd:751:33  */
  assign n1013_o = n934_o ? n1011_o : n1012_o;
  /* ./T80/T80.vhd:766:33  */
  assign n1014_o = n942_o ? n1010_o : n1013_o;
  /* ./T80/T80.vhd:806:33  */
  assign n1015_o = n1004_o ? 1'b0 : n1014_o;
  assign n1027_o = n969_o[6:5];
  assign n1028_o = n939_o[7:6];
  assign n1029_o = n940_o[7:6];
  /* ./T80/T80.vhd:751:33  */
  assign n1030_o = n934_o ? n1028_o : n1029_o;
  /* ./T80/T80.vhd:766:33  */
  assign n1031_o = n942_o ? n1027_o : n1030_o;
  assign n1032_o = n969_o[1];
  assign n1033_o = n939_o[2];
  assign n1034_o = n940_o[2];
  /* ./T80/T80.vhd:751:33  */
  assign n1035_o = n934_o ? n1033_o : n1034_o;
  /* ./T80/T80.vhd:766:33  */
  assign n1036_o = n942_o ? n1032_o : n1035_o;
  /* ./T80/T80.vhd:812:43  */
  assign n1038_o = tstate == 3'b001;
  /* ./T80/T80.vhd:812:47  */
  assign n1039_o = i_bc & n1038_o;
  /* ./T80/T80.vhd:813:72  */
  assign n1040_o = f_out[4];
  /* ./T80/T80.vhd:813:65  */
  assign n1042_o = {7'b0000000, n1040_o};
  /* ./T80/T80.vhd:813:52  */
  assign n1043_o = alu_q - n1042_o;
  /* ./T80/T80.vhd:814:55  */
  assign n1044_o = n1043_o[3];
  /* ./T80/T80.vhd:815:55  */
  assign n1045_o = n1043_o[1];
  assign n1046_o = n1009_o[0];
  assign n1047_o = n969_o[2];
  assign n1048_o = n939_o[3];
  assign n1049_o = n940_o[3];
  /* ./T80/T80.vhd:751:33  */
  assign n1050_o = n934_o ? n1048_o : n1049_o;
  /* ./T80/T80.vhd:766:33  */
  assign n1051_o = n942_o ? n1047_o : n1050_o;
  /* ./T80/T80.vhd:806:33  */
  assign n1052_o = n1004_o ? n1046_o : n1051_o;
  /* ./T80/T80.vhd:812:33  */
  assign n1053_o = n1039_o ? n1044_o : n1052_o;
  assign n1054_o = n1009_o[2];
  assign n1055_o = n969_o[4];
  assign n1056_o = n939_o[5];
  assign n1057_o = n940_o[5];
  /* ./T80/T80.vhd:751:33  */
  assign n1058_o = n934_o ? n1056_o : n1057_o;
  /* ./T80/T80.vhd:766:33  */
  assign n1059_o = n942_o ? n1055_o : n1058_o;
  /* ./T80/T80.vhd:806:33  */
  assign n1060_o = n1004_o ? n1054_o : n1059_o;
  /* ./T80/T80.vhd:812:33  */
  assign n1061_o = n1039_o ? n1045_o : n1060_o;
  assign n1069_o = n1009_o[1];
  assign n1070_o = n969_o[3];
  assign n1071_o = n939_o[4];
  assign n1072_o = n940_o[4];
  /* ./T80/T80.vhd:751:33  */
  assign n1073_o = n934_o ? n1071_o : n1072_o;
  /* ./T80/T80.vhd:766:33  */
  assign n1074_o = n942_o ? n1070_o : n1073_o;
  /* ./T80/T80.vhd:806:33  */
  assign n1075_o = n1004_o ? n1069_o : n1074_o;
  /* ./T80/T80.vhd:817:47  */
  assign n1077_o = i_bc | i_bt;
  /* ./T80/T80.vhd:817:33  */
  assign n1078_o = n1077_o ? incdecz : n1036_o;
  /* ./T80/T80.vhd:821:44  */
  assign n1080_o = tstate == 3'b001;
  /* ./T80/T80.vhd:821:63  */
  assign n1081_o = ~save_alu_r;
  /* ./T80/T80.vhd:821:48  */
  assign n1082_o = n1081_o & n1080_o;
  /* ./T80/T80.vhd:821:86  */
  assign n1083_o = ~auto_wait_t1;
  /* ./T80/T80.vhd:821:69  */
  assign n1084_o = n1083_o & n1082_o;
  /* ./T80/T80.vhd:822:72  */
  assign n1086_o = alu_op_r != 4'b0111;
  /* ./T80/T80.vhd:822:59  */
  assign n1087_o = n1086_o & save_alu_r;
  /* ./T80/T80.vhd:821:93  */
  assign n1088_o = n1084_o | n1087_o;
  /* ./T80/T80.vhd:824:41  */
  assign n1090_o = read_to_reg_r == 5'b10111;
  /* ./T80/T80.vhd:826:41  */
  assign n1092_o = read_to_reg_r == 5'b10110;
  /* ./T80/T80.vhd:828:41  */
  assign n1094_o = read_to_reg_r == 5'b11000;
  /* ./T80/T80.vhd:830:41  */
  assign n1096_o = read_to_reg_r == 5'b11001;
  /* ./T80/T80.vhd:832:41  */
  assign n1098_o = read_to_reg_r == 5'b11011;
  assign n1099_o = {n1098_o, n1096_o, n1094_o, n1092_o, n1090_o};
  /* ./T80/T80.vhd:823:41  */
  always @*
    case (n1099_o)
      5'b10000: n1100_o = n992_o;
      5'b01000: n1100_o = n992_o;
      5'b00100: n1100_o = n992_o;
      5'b00010: n1100_o = save_mux;
      5'b00001: n1100_o = n992_o;
      default: n1100_o = n992_o;
    endcase
  /* ./T80/T80.vhd:823:41  */
  always @*
    case (n1099_o)
      5'b10000: n1101_o = n900_o;
      5'b01000: n1101_o = n900_o;
      5'b00100: n1101_o = n900_o;
      5'b00010: n1101_o = n900_o;
      5'b00001: n1101_o = save_mux;
      default: n1101_o = n900_o;
    endcase
  assign n1102_o = {n1031_o, n1061_o, n1075_o, n1053_o, n1078_o, n1015_o, n976_o};
  /* ./T80/T80.vhd:823:41  */
  always @*
    case (n1099_o)
      5'b10000: n1103_o = save_mux;
      5'b01000: n1103_o = n1102_o;
      5'b00100: n1103_o = n1102_o;
      5'b00010: n1103_o = n1102_o;
      5'b00001: n1103_o = n1102_o;
      default: n1103_o = n1102_o;
    endcase
  assign n1104_o = sp[7:0];
  assign n1105_o = regbusc[7:0];
  assign n1106_o = n700_o[7:0];
  assign n1107_o = n702_o[7:0];
  /* ./T80/T80.vhd:678:57  */
  assign n1108_o = n698_o ? n1106_o : n1107_o;
  assign n1109_o = sp[7:0];
  /* ./T80/T80.vhd:676:41  */
  assign n1110_o = n705_o ? n1108_o : n1109_o;
  /* ./T80/T80.vhd:686:41  */
  assign n1111_o = ldsphl ? n1105_o : n1110_o;
  /* ./T80/T80.vhd:469:33  */
  assign n1112_o = n324_o ? n1104_o : n1111_o;
  /* ./T80/T80.vhd:823:41  */
  always @*
    case (n1099_o)
      5'b10000: n1113_o = n1112_o;
      5'b01000: n1113_o = n1112_o;
      5'b00100: n1113_o = save_mux;
      5'b00010: n1113_o = n1112_o;
      5'b00001: n1113_o = n1112_o;
      default: n1113_o = n1112_o;
    endcase
  assign n1114_o = sp[15:8];
  assign n1115_o = regbusc[15:8];
  assign n1116_o = n700_o[15:8];
  assign n1117_o = n702_o[15:8];
  /* ./T80/T80.vhd:678:57  */
  assign n1118_o = n698_o ? n1116_o : n1117_o;
  assign n1119_o = sp[15:8];
  /* ./T80/T80.vhd:676:41  */
  assign n1120_o = n705_o ? n1118_o : n1119_o;
  /* ./T80/T80.vhd:686:41  */
  assign n1121_o = ldsphl ? n1115_o : n1120_o;
  /* ./T80/T80.vhd:469:33  */
  assign n1122_o = n324_o ? n1114_o : n1121_o;
  /* ./T80/T80.vhd:823:41  */
  always @*
    case (n1099_o)
      5'b10000: n1123_o = n1122_o;
      5'b01000: n1123_o = save_mux;
      5'b00100: n1123_o = n1122_o;
      5'b00010: n1123_o = n1122_o;
      5'b00001: n1123_o = n1122_o;
      default: n1123_o = n1122_o;
    endcase
  /* ./T80/T80.vhd:836:41  */
  assign n1124_o = xybit_undoc ? alu_q : n1100_o;
  /* ./T80/T80.vhd:821:33  */
  assign n1125_o = n1088_o ? n1124_o : n992_o;
  /* ./T80/T80.vhd:821:33  */
  assign n1126_o = n1088_o ? n1101_o : n900_o;
  assign n1127_o = {n1031_o, n1061_o, n1075_o, n1053_o, n1078_o, n1015_o, n976_o};
  /* ./T80/T80.vhd:821:33  */
  assign n1128_o = n1088_o ? n1103_o : n1127_o;
  assign n1129_o = {n1123_o, n1113_o};
  /* ./T80/T80.vhd:821:33  */
  assign n1130_o = n1088_o ? n1129_o : n722_o;
  /* ./T80/T80.vhd:450:25  */
  assign n1131_o = clken ? n715_o : n2052_q;
  /* ./T80/T80.vhd:450:25  */
  assign n1132_o = clken ? n1125_o : n2053_q;
  /* ./T80/T80.vhd:450:25  */
  assign n1133_o = clken ? n1126_o : acc;
  /* ./T80/T80.vhd:450:25  */
  assign n1134_o = clken ? n1128_o : f;
  /* ./T80/T80.vhd:450:25  */
  assign n1135_o = clken ? n718_o : ap;
  /* ./T80/T80.vhd:450:25  */
  assign n1136_o = clken ? n719_o : fp;
  /* ./T80/T80.vhd:450:25  */
  assign n1137_o = n924_o & clken;
  /* ./T80/T80.vhd:450:25  */
  assign n1138_o = clken ? n927_o : r;
  /* ./T80/T80.vhd:450:25  */
  assign n1139_o = clken ? n1130_o : sp;
  /* ./T80/T80.vhd:450:25  */
  assign n1140_o = clken ? n723_o : pc;
  /* ./T80/T80.vhd:450:25  */
  assign n1141_o = clken ? n724_o : alternate;
  /* ./T80/T80.vhd:450:25  */
  assign n1142_o = clken ? n929_o : wz;
  /* ./T80/T80.vhd:450:25  */
  assign n1143_o = clken ? n726_o : ir;
  /* ./T80/T80.vhd:450:25  */
  assign n1144_o = clken ? n727_o : iset;
  /* ./T80/T80.vhd:450:25  */
  assign n1145_o = n305_o & clken;
  /* ./T80/T80.vhd:450:25  */
  assign n1146_o = n728_o & clken;
  /* ./T80/T80.vhd:450:25  */
  assign n1147_o = clken ? n729_o : xy_ind;
  /* ./T80/T80.vhd:450:25  */
  assign n1148_o = clken ? n730_o : btr_r;
  /* ./T80/T80.vhd:450:25  */
  assign n1149_o = clken ? n1000_o : read_to_reg_r;
  /* ./T80/T80.vhd:450:25  */
  assign n1150_o = clken ? arith16 : arith16_r;
  /* ./T80/T80.vhd:450:25  */
  assign n1151_o = clken ? n319_o : z16_r;
  /* ./T80/T80.vhd:450:25  */
  assign n1152_o = clken ? n732_o : alu_op_r;
  /* ./T80/T80.vhd:450:25  */
  assign n1153_o = clken ? n735_o : save_alu_r;
  /* ./T80/T80.vhd:450:25  */
  assign n1154_o = clken ? preservec : preservec_r;
  /* ./T80/T80.vhd:450:25  */
  assign n1155_o = clken ? mcycles_d : mcycles;
  /* ./T80/T80.vhd:450:25  */
  assign n1156_o = n980_o & clken;
  /* ./T80/T80.vhd:422:25  */
  assign n1159_o = dirset ? n300_o : n1131_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1161_o = dirset ? 8'b00000000 : n1132_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1162_o = dirset ? n292_o : n1133_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1163_o = dirset ? n293_o : n1134_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1164_o = dirset ? n294_o : n1135_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1165_o = dirset ? n295_o : n1136_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1166_o = dirset ? n296_o : n908_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1167_o = dirset ? n297_o : n1138_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1168_o = dirset ? n298_o : n1139_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1169_o = dirset ? n299_o : n1140_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1170_o = dirset ? n303_o : n1141_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1171_o = dirset ? n301_o : n1142_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1173_o = dirset ? 8'b00000000 : n1143_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1175_o = dirset ? 2'b00 : n1144_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1176_o = dirset ? n302_o : n306_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1178_o = dirset ? 2'b00 : n388_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1180_o = dirset ? 1'b0 : n1147_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1182_o = dirset ? 1'b0 : n1148_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1184_o = dirset ? 5'b00000 : n1149_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1186_o = dirset ? 1'b0 : n1150_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1188_o = dirset ? 1'b0 : n1151_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1190_o = dirset ? 4'b0000 : n1152_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1192_o = dirset ? 1'b0 : n1153_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1194_o = dirset ? 1'b0 : n1154_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1196_o = dirset ? 3'b001 : n1155_o;
  /* ./T80/T80.vhd:422:25  */
  assign n1198_o = dirset ? 1'b0 : n993_o;
  /* ./T80/T80.vhd:854:70  */
  assign n1293_o = set_busa_to[2:1];
  /* ./T80/T80.vhd:854:57  */
  assign n1294_o = {alternate, n1293_o};
  /* ./T80/T80.vhd:855:43  */
  assign n1295_o = ~xy_ind;
  /* ./T80/T80.vhd:855:62  */
  assign n1297_o = xy_state != 2'b00;
  /* ./T80/T80.vhd:855:49  */
  assign n1298_o = n1297_o & n1295_o;
  /* ./T80/T80.vhd:855:85  */
  assign n1299_o = set_busa_to[2:1];
  /* ./T80/T80.vhd:855:98  */
  assign n1301_o = n1299_o == 2'b10;
  /* ./T80/T80.vhd:855:70  */
  assign n1302_o = n1301_o & n1298_o;
  /* ./T80/T80.vhd:856:63  */
  assign n1303_o = xy_state[1];
  /* ./T80/T80.vhd:856:67  */
  assign n1305_o = {n1303_o, 2'b11};
  /* ./T80/T80.vhd:855:33  */
  assign n1306_o = n1302_o ? n1305_o : n1294_o;
  /* ./T80/T80.vhd:860:70  */
  assign n1307_o = set_busb_to[2:1];
  /* ./T80/T80.vhd:860:57  */
  assign n1308_o = {alternate, n1307_o};
  /* ./T80/T80.vhd:861:43  */
  assign n1309_o = ~xy_ind;
  /* ./T80/T80.vhd:861:62  */
  assign n1311_o = xy_state != 2'b00;
  /* ./T80/T80.vhd:861:49  */
  assign n1312_o = n1311_o & n1309_o;
  /* ./T80/T80.vhd:861:85  */
  assign n1313_o = set_busb_to[2:1];
  /* ./T80/T80.vhd:861:98  */
  assign n1315_o = n1313_o == 2'b10;
  /* ./T80/T80.vhd:861:70  */
  assign n1316_o = n1315_o & n1312_o;
  /* ./T80/T80.vhd:862:63  */
  assign n1317_o = xy_state[1];
  /* ./T80/T80.vhd:862:67  */
  assign n1319_o = {n1317_o, 2'b11};
  /* ./T80/T80.vhd:861:33  */
  assign n1320_o = n1316_o ? n1319_o : n1308_o;
  /* ./T80/T80.vhd:866:68  */
  assign n1321_o = set_addr_to[1:0];
  /* ./T80/T80.vhd:866:55  */
  assign n1322_o = {alternate, n1321_o};
  /* ./T80/T80.vhd:868:50  */
  assign n1323_o = jumpxy | ldsphl;
  /* ./T80/T80.vhd:869:63  */
  assign n1325_o = {alternate, 2'b10};
  /* ./T80/T80.vhd:868:33  */
  assign n1326_o = n1323_o ? n1325_o : n1322_o;
  /* ./T80/T80.vhd:871:51  */
  assign n1327_o = jumpxy | ldsphl;
  /* ./T80/T80.vhd:871:81  */
  assign n1329_o = xy_state != 2'b00;
  /* ./T80/T80.vhd:871:68  */
  assign n1330_o = n1329_o & n1327_o;
  /* ./T80/T80.vhd:871:101  */
  assign n1332_o = mcycle == 3'b110;
  /* ./T80/T80.vhd:871:90  */
  assign n1333_o = n1330_o | n1332_o;
  /* ./T80/T80.vhd:872:61  */
  assign n1334_o = xy_state[1];
  /* ./T80/T80.vhd:872:65  */
  assign n1336_o = {n1334_o, 2'b11};
  /* ./T80/T80.vhd:871:33  */
  assign n1337_o = n1333_o ? n1336_o : n1326_o;
  /* ./T80/T80.vhd:875:49  */
  assign n1338_o = save_alu_r & i_djnz;
  /* ./T80/T80.vhd:875:70  */
  assign n1340_o = 1'b1 & n1338_o;
  /* ./T80/T80.vhd:876:57  */
  assign n1341_o = f_out[6];
  /* ./T80/T80.vhd:875:33  */
  assign n1342_o = n1340_o ? n1341_o : incdecz;
  /* ./T80/T80.vhd:878:44  */
  assign n1344_o = tstate == 3'b010;
  /* ./T80/T80.vhd:878:59  */
  assign n1346_o = tstate == 3'b011;
  /* ./T80/T80.vhd:878:74  */
  assign n1348_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:878:63  */
  assign n1349_o = n1348_o & n1346_o;
  /* ./T80/T80.vhd:878:48  */
  assign n1350_o = n1344_o | n1349_o;
  /* ./T80/T80.vhd:878:97  */
  assign n1351_o = incdec_16[2:0];
  /* ./T80/T80.vhd:878:110  */
  assign n1353_o = n1351_o == 3'b100;
  /* ./T80/T80.vhd:878:84  */
  assign n1354_o = n1353_o & n1350_o;
  /* ./T80/T80.vhd:879:49  */
  assign n1356_o = id16 == 16'b0000000000000000;
  /* ./T80/T80.vhd:879:41  */
  assign n1359_o = n1356_o ? 1'b0 : 1'b1;
  /* ./T80/T80.vhd:878:33  */
  assign n1360_o = n1354_o ? n1359_o : n1342_o;
  /* ./T80/T80.vhd:893:46  */
  assign n1372_o = incdec_16[1:0];
  /* ./T80/T80.vhd:893:35  */
  assign n1373_o = {alternate, n1372_o};
  /* ./T80/T80.vhd:893:72  */
  assign n1375_o = tstate == 3'b010;
  /* ./T80/T80.vhd:894:41  */
  assign n1377_o = tstate == 3'b011;
  /* ./T80/T80.vhd:894:56  */
  assign n1379_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:894:45  */
  assign n1380_o = n1379_o & n1377_o;
  /* ./T80/T80.vhd:894:77  */
  assign n1381_o = incdec_16[2];
  /* ./T80/T80.vhd:894:64  */
  assign n1382_o = n1381_o & n1380_o;
  /* ./T80/T80.vhd:893:76  */
  assign n1383_o = n1375_o | n1382_o;
  /* ./T80/T80.vhd:894:102  */
  assign n1385_o = xy_state == 2'b00;
  /* ./T80/T80.vhd:894:89  */
  assign n1386_o = n1385_o & n1383_o;
  /* ./T80/T80.vhd:893:59  */
  assign n1387_o = n1386_o ? n1373_o : n1405_o;
  /* ./T80/T80.vhd:895:33  */
  assign n1388_o = xy_state[1];
  /* ./T80/T80.vhd:895:37  */
  assign n1390_o = {n1388_o, 2'b11};
  /* ./T80/T80.vhd:895:57  */
  assign n1392_o = tstate == 3'b010;
  /* ./T80/T80.vhd:896:41  */
  assign n1394_o = tstate == 3'b011;
  /* ./T80/T80.vhd:896:56  */
  assign n1396_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:896:45  */
  assign n1397_o = n1396_o & n1394_o;
  /* ./T80/T80.vhd:896:77  */
  assign n1398_o = incdec_16[2];
  /* ./T80/T80.vhd:896:64  */
  assign n1399_o = n1398_o & n1397_o;
  /* ./T80/T80.vhd:895:61  */
  assign n1400_o = n1392_o | n1399_o;
  /* ./T80/T80.vhd:896:102  */
  assign n1401_o = incdec_16[1:0];
  /* ./T80/T80.vhd:896:115  */
  assign n1403_o = n1401_o == 2'b10;
  /* ./T80/T80.vhd:896:89  */
  assign n1404_o = n1403_o & n1400_o;
  /* ./T80/T80.vhd:894:109  */
  assign n1405_o = n1404_o ? n1390_o : n1411_o;
  /* ./T80/T80.vhd:898:35  */
  assign n1407_o = {alternate, 2'b10};
  /* ./T80/T80.vhd:898:75  */
  assign n1409_o = tstate == 3'b011;
  /* ./T80/T80.vhd:898:64  */
  assign n1410_o = n1409_o & exchangedh;
  /* ./T80/T80.vhd:896:122  */
  assign n1411_o = n1410_o ? n1407_o : n1417_o;
  /* ./T80/T80.vhd:899:35  */
  assign n1413_o = {alternate, 2'b01};
  /* ./T80/T80.vhd:899:75  */
  assign n1415_o = tstate == 3'b100;
  /* ./T80/T80.vhd:899:64  */
  assign n1416_o = n1415_o & exchangedh;
  /* ./T80/T80.vhd:898:79  */
  assign n1417_o = n1416_o ? n1413_o : regaddra_r;
  /* ./T80/T80.vhd:905:35  */
  assign n1419_o = {alternate, 2'b01};
  /* ./T80/T80.vhd:905:75  */
  assign n1421_o = tstate == 3'b011;
  /* ./T80/T80.vhd:905:64  */
  assign n1422_o = n1421_o & exchangedh;
  /* ./T80/T80.vhd:905:42  */
  assign n1423_o = n1422_o ? n1419_o : regaddrb_r;
  /* ./T80/T80.vhd:909:33  */
  assign n1425_o = regbusa - 16'b0000000000000001;
  /* ./T80/T80.vhd:909:51  */
  assign n1426_o = incdec_16[3];
  /* ./T80/T80.vhd:909:37  */
  assign n1427_o = n1426_o ? n1425_o : n1429_o;
  /* ./T80/T80.vhd:910:41  */
  assign n1429_o = regbusa + 16'b0000000000000001;
  /* ./T80/T80.vhd:917:28  */
  assign n1433_o = tstate == 3'b001;
  /* ./T80/T80.vhd:917:47  */
  assign n1434_o = ~save_alu_r;
  /* ./T80/T80.vhd:917:32  */
  assign n1435_o = n1434_o & n1433_o;
  /* ./T80/T80.vhd:917:70  */
  assign n1436_o = ~auto_wait_t1;
  /* ./T80/T80.vhd:917:53  */
  assign n1437_o = n1436_o & n1435_o;
  /* ./T80/T80.vhd:918:56  */
  assign n1439_o = alu_op_r != 4'b0111;
  /* ./T80/T80.vhd:918:43  */
  assign n1440_o = n1439_o & save_alu_r;
  /* ./T80/T80.vhd:917:77  */
  assign n1441_o = n1437_o | n1440_o;
  /* ./T80/T80.vhd:921:60  */
  assign n1442_o = read_to_reg_r[0];
  /* ./T80/T80.vhd:921:43  */
  assign n1443_o = ~n1442_o;
  /* ./T80/T80.vhd:922:56  */
  assign n1444_o = read_to_reg_r[0];
  /* ./T80/T80.vhd:920:25  */
  assign n1446_o = read_to_reg_r == 5'b10000;
  /* ./T80/T80.vhd:920:38  */
  assign n1448_o = read_to_reg_r == 5'b10001;
  /* ./T80/T80.vhd:920:38  */
  assign n1449_o = n1446_o | n1448_o;
  /* ./T80/T80.vhd:920:48  */
  assign n1451_o = read_to_reg_r == 5'b10010;
  /* ./T80/T80.vhd:920:48  */
  assign n1452_o = n1449_o | n1451_o;
  /* ./T80/T80.vhd:920:58  */
  assign n1454_o = read_to_reg_r == 5'b10011;
  /* ./T80/T80.vhd:920:58  */
  assign n1455_o = n1452_o | n1454_o;
  /* ./T80/T80.vhd:920:68  */
  assign n1457_o = read_to_reg_r == 5'b10100;
  /* ./T80/T80.vhd:920:68  */
  assign n1458_o = n1455_o | n1457_o;
  /* ./T80/T80.vhd:920:78  */
  assign n1460_o = read_to_reg_r == 5'b10101;
  /* ./T80/T80.vhd:920:78  */
  assign n1461_o = n1458_o | n1460_o;
  /* ./T80/T80.vhd:919:25  */
  always @*
    case (n1461_o)
      1'b1: n1463_o = n1443_o;
      default: n1463_o = 1'b0;
    endcase
  /* ./T80/T80.vhd:919:25  */
  always @*
    case (n1461_o)
      1'b1: n1465_o = n1444_o;
      default: n1465_o = 1'b0;
    endcase
  /* ./T80/T80.vhd:917:17  */
  assign n1467_o = n1441_o ? n1463_o : 1'b0;
  /* ./T80/T80.vhd:917:17  */
  assign n1470_o = n1441_o ? n1465_o : 1'b0;
  /* ./T80/T80.vhd:927:49  */
  assign n1473_o = tstate == 3'b011;
  /* ./T80/T80.vhd:927:63  */
  assign n1475_o = tstate == 3'b100;
  /* ./T80/T80.vhd:927:53  */
  assign n1476_o = n1473_o | n1475_o;
  /* ./T80/T80.vhd:927:37  */
  assign n1477_o = n1476_o & exchangedh;
  /* ./T80/T80.vhd:927:17  */
  assign n1479_o = n1477_o ? 1'b1 : n1467_o;
  /* ./T80/T80.vhd:927:17  */
  assign n1481_o = n1477_o ? 1'b1 : n1470_o;
  /* ./T80/T80.vhd:932:29  */
  assign n1482_o = incdec_16[2];
  /* ./T80/T80.vhd:932:52  */
  assign n1484_o = tstate == 3'b010;
  /* ./T80/T80.vhd:932:56  */
  assign n1485_o = wait_n & n1484_o;
  /* ./T80/T80.vhd:932:84  */
  assign n1487_o = mcycle != 3'b001;
  /* ./T80/T80.vhd:932:73  */
  assign n1488_o = n1487_o & n1485_o;
  /* ./T80/T80.vhd:932:105  */
  assign n1490_o = tstate == 3'b011;
  /* ./T80/T80.vhd:932:120  */
  assign n1492_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:932:109  */
  assign n1493_o = n1492_o & n1490_o;
  /* ./T80/T80.vhd:932:94  */
  assign n1494_o = n1488_o | n1493_o;
  /* ./T80/T80.vhd:932:39  */
  assign n1495_o = n1494_o & n1482_o;
  /* ./T80/T80.vhd:933:39  */
  assign n1496_o = incdec_16[1:0];
  /* ./T80/T80.vhd:934:25  */
  assign n1498_o = n1496_o == 2'b00;
  /* ./T80/T80.vhd:934:35  */
  assign n1500_o = n1496_o == 2'b01;
  /* ./T80/T80.vhd:934:35  */
  assign n1501_o = n1498_o | n1500_o;
  /* ./T80/T80.vhd:934:42  */
  assign n1503_o = n1496_o == 2'b10;
  /* ./T80/T80.vhd:934:42  */
  assign n1504_o = n1501_o | n1503_o;
  /* ./T80/T80.vhd:933:25  */
  always @*
    case (n1504_o)
      1'b1: n1506_o = 1'b1;
      default: n1506_o = n1479_o;
    endcase
  /* ./T80/T80.vhd:933:25  */
  always @*
    case (n1504_o)
      1'b1: n1508_o = 1'b1;
      default: n1508_o = n1481_o;
    endcase
  /* ./T80/T80.vhd:932:17  */
  assign n1509_o = n1495_o ? n1506_o : n1479_o;
  /* ./T80/T80.vhd:932:17  */
  assign n1510_o = n1495_o ? n1508_o : n1481_o;
  /* ./T80/T80.vhd:948:48  */
  assign n1515_o = tstate == 3'b011;
  /* ./T80/T80.vhd:948:37  */
  assign n1516_o = n1515_o & exchangedh;
  /* ./T80/T80.vhd:949:42  */
  assign n1517_o = regbusb[15:8];
  /* ./T80/T80.vhd:950:42  */
  assign n1518_o = regbusb[7:0];
  /* ./T80/T80.vhd:948:17  */
  assign n1519_o = n1516_o ? n1517_o : save_mux;
  /* ./T80/T80.vhd:948:17  */
  assign n1520_o = n1516_o ? n1518_o : save_mux;
  /* ./T80/T80.vhd:952:48  */
  assign n1522_o = tstate == 3'b100;
  /* ./T80/T80.vhd:952:37  */
  assign n1523_o = n1522_o & exchangedh;
  /* ./T80/T80.vhd:953:44  */
  assign n1524_o = regbusa_r[15:8];
  /* ./T80/T80.vhd:954:44  */
  assign n1525_o = regbusa_r[7:0];
  /* ./T80/T80.vhd:952:17  */
  assign n1526_o = n1523_o ? n1524_o : n1519_o;
  /* ./T80/T80.vhd:952:17  */
  assign n1527_o = n1523_o ? n1525_o : n1520_o;
  /* ./T80/T80.vhd:957:29  */
  assign n1528_o = incdec_16[2];
  /* ./T80/T80.vhd:957:52  */
  assign n1530_o = tstate == 3'b010;
  /* ./T80/T80.vhd:957:67  */
  assign n1532_o = mcycle != 3'b001;
  /* ./T80/T80.vhd:957:56  */
  assign n1533_o = n1532_o & n1530_o;
  /* ./T80/T80.vhd:957:88  */
  assign n1535_o = tstate == 3'b011;
  /* ./T80/T80.vhd:957:103  */
  assign n1537_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:957:92  */
  assign n1538_o = n1537_o & n1535_o;
  /* ./T80/T80.vhd:957:77  */
  assign n1539_o = n1533_o | n1538_o;
  /* ./T80/T80.vhd:957:39  */
  assign n1540_o = n1539_o & n1528_o;
  /* ./T80/T80.vhd:958:56  */
  assign n1541_o = id16[15:8];
  /* ./T80/T80.vhd:959:56  */
  assign n1542_o = id16[7:0];
  /* ./T80/T80.vhd:957:17  */
  assign n1543_o = n1540_o ? n1541_o : n1526_o;
  /* ./T80/T80.vhd:957:17  */
  assign n1544_o = n1540_o ? n1542_o : n1527_o;
  /* ./T80/T80.vhd:963:9  */
  t80_reg regs (
    .clk(clk_n),
    .cen(clken),
    .weh(regweh),
    .wel(regwel),
    .addra(regaddra),
    .addrb(regaddrb),
    .addrc(regaddrc),
    .dih(regdih),
    .dil(regdil),
    .dirset(dirset),
    .dir(regdir),
    .doah(regs_doah),
    .doal(regs_doal),
    .dobh(regs_dobh),
    .dobl(regs_dobl),
    .doch(regs_doch),
    .docl(regs_docl),
    .dor(regs_dor));
  /* ./T80/T80.vhd:994:33  */
  assign n1557_o = set_busb_to == 4'b0111;
  /* ./T80/T80.vhd:997:55  */
  assign n1558_o = set_busb_to[0];
  /* ./T80/T80.vhd:998:64  */
  assign n1559_o = regbusb[7:0];
  /* ./T80/T80.vhd:1000:64  */
  assign n1560_o = regbusb[15:8];
  /* ./T80/T80.vhd:997:41  */
  assign n1561_o = n1558_o ? n1559_o : n1560_o;
  /* ./T80/T80.vhd:996:33  */
  assign n1563_o = set_busb_to == 4'b0000;
  /* ./T80/T80.vhd:996:45  */
  assign n1565_o = set_busb_to == 4'b0001;
  /* ./T80/T80.vhd:996:45  */
  assign n1566_o = n1563_o | n1565_o;
  /* ./T80/T80.vhd:996:54  */
  assign n1568_o = set_busb_to == 4'b0010;
  /* ./T80/T80.vhd:996:54  */
  assign n1569_o = n1566_o | n1568_o;
  /* ./T80/T80.vhd:996:63  */
  assign n1571_o = set_busb_to == 4'b0011;
  /* ./T80/T80.vhd:996:63  */
  assign n1572_o = n1569_o | n1571_o;
  /* ./T80/T80.vhd:996:72  */
  assign n1574_o = set_busb_to == 4'b0100;
  /* ./T80/T80.vhd:996:72  */
  assign n1575_o = n1572_o | n1574_o;
  /* ./T80/T80.vhd:996:81  */
  assign n1577_o = set_busb_to == 4'b0101;
  /* ./T80/T80.vhd:996:81  */
  assign n1578_o = n1575_o | n1577_o;
  /* ./T80/T80.vhd:1002:33  */
  assign n1580_o = set_busb_to == 4'b0110;
  /* ./T80/T80.vhd:1005:68  */
  assign n1581_o = sp[7:0];
  /* ./T80/T80.vhd:1004:33  */
  assign n1583_o = set_busb_to == 4'b1000;
  /* ./T80/T80.vhd:1007:68  */
  assign n1584_o = sp[15:8];
  /* ./T80/T80.vhd:1006:33  */
  assign n1586_o = set_busb_to == 4'b1001;
  /* ./T80/T80.vhd:1008:33  */
  assign n1588_o = set_busb_to == 4'b1010;
  /* ./T80/T80.vhd:1010:33  */
  assign n1590_o = set_busb_to == 4'b1011;
  /* ./T80/T80.vhd:1013:68  */
  assign n1591_o = pc[7:0];
  /* ./T80/T80.vhd:1012:33  */
  assign n1593_o = set_busb_to == 4'b1100;
  /* ./T80/T80.vhd:1015:68  */
  assign n1594_o = pc[15:8];
  /* ./T80/T80.vhd:1014:33  */
  assign n1596_o = set_busb_to == 4'b1101;
  /* ./T80/T80.vhd:1017:47  */
  assign n1598_o = ir == 8'b01110001;
  /* ./T80/T80.vhd:1017:55  */
  assign n1599_o = out0 & n1598_o;
  /* ./T80/T80.vhd:1017:41  */
  assign n1602_o = n1599_o ? 8'b11111111 : 8'b00000000;
  /* ./T80/T80.vhd:1016:33  */
  assign n1604_o = set_busb_to == 4'b1110;
  assign n1605_o = {n1604_o, n1596_o, n1593_o, n1590_o, n1588_o, n1586_o, n1583_o, n1580_o, n1578_o, n1557_o};
  /* ./T80/T80.vhd:993:33  */
  always @*
    case (n1605_o)
      10'b1000000000: n1608_o = n1602_o;
      10'b0100000000: n1608_o = n1594_o;
      10'b0010000000: n1608_o = n1591_o;
      10'b0001000000: n1608_o = f;
      10'b0000100000: n1608_o = 8'b00000001;
      10'b0000010000: n1608_o = n1584_o;
      10'b0000001000: n1608_o = n1581_o;
      10'b0000000100: n1608_o = di_reg;
      10'b0000000010: n1608_o = n1561_o;
      10'b0000000001: n1608_o = acc;
      default: n1608_o = 8'bX;
    endcase
  /* ./T80/T80.vhd:1027:33  */
  assign n1610_o = set_busa_to == 4'b0111;
  /* ./T80/T80.vhd:1030:55  */
  assign n1611_o = set_busa_to[0];
  /* ./T80/T80.vhd:1031:64  */
  assign n1612_o = regbusa[7:0];
  /* ./T80/T80.vhd:1033:64  */
  assign n1613_o = regbusa[15:8];
  /* ./T80/T80.vhd:1030:41  */
  assign n1614_o = n1611_o ? n1612_o : n1613_o;
  /* ./T80/T80.vhd:1029:33  */
  assign n1616_o = set_busa_to == 4'b0000;
  /* ./T80/T80.vhd:1029:45  */
  assign n1618_o = set_busa_to == 4'b0001;
  /* ./T80/T80.vhd:1029:45  */
  assign n1619_o = n1616_o | n1618_o;
  /* ./T80/T80.vhd:1029:54  */
  assign n1621_o = set_busa_to == 4'b0010;
  /* ./T80/T80.vhd:1029:54  */
  assign n1622_o = n1619_o | n1621_o;
  /* ./T80/T80.vhd:1029:63  */
  assign n1624_o = set_busa_to == 4'b0011;
  /* ./T80/T80.vhd:1029:63  */
  assign n1625_o = n1622_o | n1624_o;
  /* ./T80/T80.vhd:1029:72  */
  assign n1627_o = set_busa_to == 4'b0100;
  /* ./T80/T80.vhd:1029:72  */
  assign n1628_o = n1625_o | n1627_o;
  /* ./T80/T80.vhd:1029:81  */
  assign n1630_o = set_busa_to == 4'b0101;
  /* ./T80/T80.vhd:1029:81  */
  assign n1631_o = n1628_o | n1630_o;
  /* ./T80/T80.vhd:1035:33  */
  assign n1633_o = set_busa_to == 4'b0110;
  /* ./T80/T80.vhd:1038:68  */
  assign n1634_o = sp[7:0];
  /* ./T80/T80.vhd:1037:33  */
  assign n1636_o = set_busa_to == 4'b1000;
  /* ./T80/T80.vhd:1040:68  */
  assign n1637_o = sp[15:8];
  /* ./T80/T80.vhd:1039:33  */
  assign n1639_o = set_busa_to == 4'b1001;
  /* ./T80/T80.vhd:1041:33  */
  assign n1641_o = set_busa_to == 4'b1010;
  assign n1642_o = {n1641_o, n1639_o, n1636_o, n1633_o, n1631_o, n1610_o};
  /* ./T80/T80.vhd:1026:33  */
  always @*
    case (n1642_o)
      6'b100000: n1645_o = 8'b00000000;
      6'b010000: n1645_o = n1637_o;
      6'b001000: n1645_o = n1634_o;
      6'b000100: n1645_o = di_reg;
      6'b000010: n1645_o = n1614_o;
      6'b000001: n1645_o = acc;
      default: n1645_o = 8'bX;
    endcase
  /* ./T80/T80.vhd:1046:33  */
  assign n1646_o = xybit_undoc ? di_reg : n1608_o;
  /* ./T80/T80.vhd:1046:33  */
  assign n1647_o = xybit_undoc ? di_reg : n1645_o;
  /* ./T80/T80.vhd:1061:28  */
  assign n1655_o = ~reset_n;
  /* ./T80/T80.vhd:1064:35  */
  assign n1657_o = ~dirset;
  /* ./T80/T80.vhd:1064:41  */
  assign n1658_o = cen & n1657_o;
  /* ./T80/T80.vhd:1065:43  */
  assign n1660_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:1065:64  */
  assign n1662_o = tstate == 3'b010;
  /* ./T80/T80.vhd:1065:69  */
  assign n1663_o = wait_n & n1662_o;
  /* ./T80/T80.vhd:1065:97  */
  assign n1665_o = tstate == 3'b011;
  /* ./T80/T80.vhd:1065:87  */
  assign n1666_o = n1663_o | n1665_o;
  /* ./T80/T80.vhd:1065:51  */
  assign n1667_o = n1666_o & n1660_o;
  /* ./T80/T80.vhd:1065:33  */
  assign n1670_o = n1667_o ? 1'b0 : 1'b1;
  /* ./T80/T80.vhd:1077:19  */
  assign n1676_o = ~halt_ff;
  /* ./T80/T80.vhd:1078:20  */
  assign n1677_o = ~busack;
  /* ./T80/T80.vhd:1079:23  */
  assign n1678_o = ~intcycle;
  /* ./T80/T80.vhd:1090:26  */
  always @*
    n1679_oldnmi_n = n1987_q; // (isignal)
  initial
    n1679_oldnmi_n = 1'bX;
  /* ./T80/T80.vhd:1092:28  */
  assign n1682_o = ~reset_n;
  /* ./T80/T80.vhd:1111:48  */
  assign n1684_o = dir[211];
  /* ./T80/T80.vhd:1112:48  */
  assign n1685_o = dir[210];
  /* ./T80/T80.vhd:1113:47  */
  assign n1686_o = dir[229];
  /* ./T80/T80.vhd:1130:42  */
  assign n1687_o = ~nmi_n;
  /* ./T80/T80.vhd:1130:48  */
  assign n1688_o = n1679_oldnmi_n & n1687_o;
  /* ./T80/T80.vhd:1130:33  */
  assign n1690_o = n1688_o ? 1'b1 : nmi_s;
  /* ./T80/T80.vhd:1136:53  */
  assign n1691_o = ~busrq_n;
  /* ./T80/T80.vhd:1142:75  */
  assign n1692_o = auto_wait | iorq_i;
  /* ./T80/T80.vhd:1138:41  */
  assign n1694_o = t_res ? 1'b0 : n1692_o;
  /* ./T80/T80.vhd:1138:41  */
  assign n1696_o = t_res ? 1'b0 : auto_wait_t1;
  /* ./T80/T80.vhd:1144:68  */
  assign n1697_o = ir[4];
  /* ./T80/T80.vhd:1144:62  */
  assign n1698_o = ~n1697_o;
  /* ./T80/T80.vhd:1144:80  */
  assign n1699_o = f[2];
  /* ./T80/T80.vhd:1144:75  */
  assign n1700_o = ~n1699_o;
  /* ./T80/T80.vhd:1144:72  */
  assign n1701_o = n1698_o | n1700_o;
  /* ./T80/T80.vhd:1144:57  */
  assign n1702_o = i_bt & n1701_o;
  /* ./T80/T80.vhd:1145:74  */
  assign n1703_o = ir[4];
  /* ./T80/T80.vhd:1145:68  */
  assign n1704_o = ~n1703_o;
  /* ./T80/T80.vhd:1145:82  */
  assign n1705_o = f[6];
  /* ./T80/T80.vhd:1145:78  */
  assign n1706_o = n1704_o | n1705_o;
  /* ./T80/T80.vhd:1145:99  */
  assign n1707_o = f[2];
  /* ./T80/T80.vhd:1145:94  */
  assign n1708_o = ~n1707_o;
  /* ./T80/T80.vhd:1145:91  */
  assign n1709_o = n1706_o | n1708_o;
  /* ./T80/T80.vhd:1145:63  */
  assign n1710_o = i_bc & n1709_o;
  /* ./T80/T80.vhd:1144:91  */
  assign n1711_o = n1702_o | n1710_o;
  /* ./T80/T80.vhd:1146:75  */
  assign n1712_o = ir[4];
  /* ./T80/T80.vhd:1146:69  */
  assign n1713_o = ~n1712_o;
  /* ./T80/T80.vhd:1146:83  */
  assign n1714_o = f[6];
  /* ./T80/T80.vhd:1146:79  */
  assign n1715_o = n1713_o | n1714_o;
  /* ./T80/T80.vhd:1146:64  */
  assign n1716_o = i_btr & n1715_o;
  /* ./T80/T80.vhd:1145:110  */
  assign n1717_o = n1711_o | n1716_o;
  /* ./T80/T80.vhd:1147:51  */
  assign n1719_o = tstate == 3'b010;
  /* ./T80/T80.vhd:1148:49  */
  assign n1721_o = setei ? 1'b1 : inte_ff1;
  /* ./T80/T80.vhd:1147:41  */
  assign n1723_o = n1726_o ? 1'b1 : inte_ff2;
  /* ./T80/T80.vhd:1152:49  */
  assign n1724_o = i_retn ? inte_ff2 : n1721_o;
  /* ./T80/T80.vhd:1147:41  */
  assign n1725_o = n1719_o ? n1724_o : inte_ff1;
  /* ./T80/T80.vhd:1147:41  */
  assign n1726_o = setei & n1719_o;
  /* ./T80/T80.vhd:1156:51  */
  assign n1728_o = tstate == 3'b011;
  /* ./T80/T80.vhd:1156:41  */
  assign n1730_o = n1733_o ? 1'b0 : n1725_o;
  /* ./T80/T80.vhd:1156:41  */
  assign n1732_o = n1734_o ? 1'b0 : n1723_o;
  /* ./T80/T80.vhd:1156:41  */
  assign n1733_o = setdi & n1728_o;
  /* ./T80/T80.vhd:1156:41  */
  assign n1734_o = setdi & n1728_o;
  /* ./T80/T80.vhd:1162:59  */
  assign n1735_o = intcycle | nmicycle;
  /* ./T80/T80.vhd:1162:41  */
  assign n1737_o = n1735_o ? 1'b0 : halt_ff;
  /* ./T80/T80.vhd:1165:51  */
  assign n1739_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:1165:70  */
  assign n1741_o = tstate == 3'b010;
  /* ./T80/T80.vhd:1165:59  */
  assign n1742_o = n1741_o & n1739_o;
  /* ./T80/T80.vhd:1165:74  */
  assign n1743_o = wait_n & n1742_o;
  /* ./T80/T80.vhd:1165:41  */
  assign n1745_o = n1743_o ? 1'b1 : n2049_q;
  /* ./T80/T80.vhd:1168:59  */
  assign n1746_o = busack & busreq_s;
  /* ./T80/T80.vhd:1171:59  */
  assign n1748_o = tstate == 3'b010;
  /* ./T80/T80.vhd:1171:74  */
  assign n1749_o = ~wait_n;
  /* ./T80/T80.vhd:1171:63  */
  assign n1750_o = n1749_o & n1748_o;
  /* ./T80/T80.vhd:1172:49  */
  assign n1752_o = n1859_o ? 1'b1 : n1737_o;
  /* ./T80/T80.vhd:1183:79  */
  assign n1754_o = ir == 8'b00110110;
  /* ./T80/T80.vhd:1183:92  */
  assign n1756_o = 1'b1 & n1754_o;
  /* ./T80/T80.vhd:1183:73  */
  assign n1758_o = n1756_o ? 3'b010 : mcycle;
  /* ./T80/T80.vhd:1186:79  */
  assign n1760_o = mcycle == 3'b111;
  /* ./T80/T80.vhd:1186:88  */
  assign n1764_o = n1760_o | 1'b0;
  /* ./T80/T80.vhd:1187:121  */
  assign n1766_o = pre_xy_f_m + 3'b001;
  /* ./T80/T80.vhd:1188:79  */
  assign n1767_o = mcycle == mcycles;
  /* ./T80/T80.vhd:1188:90  */
  assign n1768_o = n1767_o | no_btr;
  /* ./T80/T80.vhd:1188:117  */
  assign n1770_o = mcycle == 3'b010;
  /* ./T80/T80.vhd:1188:125  */
  assign n1771_o = i_djnz & n1770_o;
  /* ./T80/T80.vhd:1188:142  */
  assign n1772_o = incdecz & n1771_o;
  /* ./T80/T80.vhd:1188:106  */
  assign n1773_o = n1768_o | n1772_o;
  /* ./T80/T80.vhd:1193:99  */
  assign n1775_o = prefix == 2'b00;
  /* ./T80/T80.vhd:1193:88  */
  assign n1776_o = n1775_o & nmi_s;
  /* ./T80/T80.vhd:1197:103  */
  assign n1777_o = ~int_n;
  /* ./T80/T80.vhd:1197:94  */
  assign n1778_o = n1777_o & inte_ff1;
  /* ./T80/T80.vhd:1197:119  */
  assign n1780_o = prefix == 2'b00;
  /* ./T80/T80.vhd:1197:108  */
  assign n1781_o = n1780_o & n1778_o;
  /* ./T80/T80.vhd:1197:136  */
  assign n1782_o = ~setei;
  /* ./T80/T80.vhd:1197:126  */
  assign n1783_o = n1782_o & n1781_o;
  /* ./T80/T80.vhd:1197:73  */
  assign n1785_o = n1783_o ? 1'b0 : n1730_o;
  /* ./T80/T80.vhd:1197:73  */
  assign n1787_o = n1783_o ? 1'b0 : n1732_o;
  /* ./T80/T80.vhd:1197:73  */
  assign n1790_o = n1783_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:1193:73  */
  assign n1792_o = n1776_o ? 1'b0 : n1785_o;
  /* ./T80/T80.vhd:1193:73  */
  assign n1793_o = n1776_o ? n1732_o : n1787_o;
  /* ./T80/T80.vhd:1188:65  */
  assign n1795_o = n1811_o ? 1'b0 : n1690_o;
  /* ./T80/T80.vhd:1193:73  */
  assign n1797_o = n1776_o ? 1'b0 : n1790_o;
  /* ./T80/T80.vhd:1193:73  */
  assign n1801_o = n1776_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:1203:117  */
  assign n1804_o = mcycle + 3'b001;
  /* ./T80/T80.vhd:1188:65  */
  assign n1806_o = n1773_o ? 1'b0 : n1745_o;
  /* ./T80/T80.vhd:1188:65  */
  assign n1808_o = n1773_o ? 3'b001 : n1804_o;
  /* ./T80/T80.vhd:1188:65  */
  assign n1809_o = n1773_o ? n1792_o : n1730_o;
  /* ./T80/T80.vhd:1188:65  */
  assign n1810_o = n1773_o ? n1793_o : n1732_o;
  /* ./T80/T80.vhd:1188:65  */
  assign n1811_o = n1776_o & n1773_o;
  /* ./T80/T80.vhd:1188:65  */
  assign n1812_o = n1773_o ? n1797_o : intcycle;
  /* ./T80/T80.vhd:1188:65  */
  assign n1813_o = n1773_o ? n1801_o : nmicycle;
  /* ./T80/T80.vhd:1186:65  */
  assign n1814_o = n1764_o ? n1745_o : n1806_o;
  /* ./T80/T80.vhd:1186:65  */
  assign n1815_o = n1764_o ? n1766_o : n1808_o;
  /* ./T80/T80.vhd:1186:65  */
  assign n1816_o = n1764_o ? n1730_o : n1809_o;
  /* ./T80/T80.vhd:1186:65  */
  assign n1817_o = n1764_o ? n1732_o : n1810_o;
  /* ./T80/T80.vhd:1186:65  */
  assign n1818_o = n1764_o ? n1690_o : n1795_o;
  /* ./T80/T80.vhd:1186:65  */
  assign n1819_o = n1764_o ? intcycle : n1812_o;
  /* ./T80/T80.vhd:1186:65  */
  assign n1820_o = n1764_o ? nmicycle : n1813_o;
  /* ./T80/T80.vhd:1180:65  */
  assign n1821_o = nextis_xy_fetch ? n1745_o : n1814_o;
  /* ./T80/T80.vhd:1180:65  */
  assign n1823_o = nextis_xy_fetch ? 3'b110 : n1815_o;
  /* ./T80/T80.vhd:1180:65  */
  assign n1824_o = nextis_xy_fetch ? n1730_o : n1816_o;
  /* ./T80/T80.vhd:1180:65  */
  assign n1825_o = nextis_xy_fetch ? n1732_o : n1817_o;
  /* ./T80/T80.vhd:1180:65  */
  assign n1826_o = nextis_xy_fetch ? n1690_o : n1818_o;
  /* ./T80/T80.vhd:1180:65  */
  assign n1827_o = nextis_xy_fetch ? n1758_o : pre_xy_f_m;
  /* ./T80/T80.vhd:1180:65  */
  assign n1828_o = nextis_xy_fetch ? intcycle : n1819_o;
  /* ./T80/T80.vhd:1180:65  */
  assign n1829_o = nextis_xy_fetch ? nmicycle : n1820_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1830_o = busreq_s ? n1745_o : n1821_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1832_o = busreq_s ? tstate : 3'b001;
  /* ./T80/T80.vhd:1176:57  */
  assign n1833_o = busreq_s ? mcycle : n1823_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1834_o = busreq_s ? n1730_o : n1824_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1835_o = busreq_s ? n1732_o : n1825_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1838_o = busreq_s ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:1176:57  */
  assign n1839_o = busreq_s ? n1690_o : n1826_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1840_o = busreq_s ? pre_xy_f_m : n1827_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1841_o = busreq_s ? intcycle : n1828_o;
  /* ./T80/T80.vhd:1176:57  */
  assign n1842_o = busreq_s ? nmicycle : n1829_o;
  /* ./T80/T80.vhd:1207:94  */
  assign n1843_o = ~auto_wait_t2;
  /* ./T80/T80.vhd:1207:77  */
  assign n1844_o = n1843_o & auto_wait;
  /* ./T80/T80.vhd:1208:77  */
  assign n1846_o = iorq_i & 1'b1;
  /* ./T80/T80.vhd:1208:111  */
  assign n1847_o = ~auto_wait_t1;
  /* ./T80/T80.vhd:1208:94  */
  assign n1848_o = n1847_o & n1846_o;
  /* ./T80/T80.vhd:1207:101  */
  assign n1849_o = n1844_o | n1848_o;
  /* ./T80/T80.vhd:1207:101  */
  assign n1850_o = ~n1849_o;
  /* ./T80/T80.vhd:1209:82  */
  assign n1852_o = tstate + 3'b001;
  /* ./T80/T80.vhd:1207:57  */
  assign n1853_o = n1850_o ? n1852_o : tstate;
  /* ./T80/T80.vhd:1172:49  */
  assign n1854_o = t_res ? n1830_o : n1745_o;
  /* ./T80/T80.vhd:1172:49  */
  assign n1855_o = t_res ? n1832_o : n1853_o;
  /* ./T80/T80.vhd:1172:49  */
  assign n1856_o = t_res ? n1833_o : mcycle;
  /* ./T80/T80.vhd:1172:49  */
  assign n1857_o = t_res ? n1834_o : n1730_o;
  /* ./T80/T80.vhd:1172:49  */
  assign n1858_o = t_res ? n1835_o : n1732_o;
  /* ./T80/T80.vhd:1172:49  */
  assign n1859_o = halt & t_res;
  /* ./T80/T80.vhd:1172:49  */
  assign n1861_o = t_res ? n1838_o : 1'b0;
  /* ./T80/T80.vhd:1172:49  */
  assign n1862_o = t_res ? n1839_o : n1690_o;
  /* ./T80/T80.vhd:1172:49  */
  assign n1863_o = t_res ? n1840_o : pre_xy_f_m;
  /* ./T80/T80.vhd:1172:49  */
  assign n1864_o = t_res ? n1841_o : intcycle;
  /* ./T80/T80.vhd:1172:49  */
  assign n1865_o = t_res ? n1842_o : nmicycle;
  /* ./T80/T80.vhd:1171:49  */
  assign n1866_o = n1750_o ? n1745_o : n1854_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1867_o = n1750_o ? tstate : n1855_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1868_o = n1750_o ? mcycle : n1856_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1869_o = n1750_o ? n1730_o : n1857_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1870_o = n1750_o ? n1732_o : n1858_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1871_o = n1750_o ? n1737_o : n1752_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1873_o = n1750_o ? 1'b0 : n1861_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1875_o = n1750_o ? n1690_o : n1862_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1876_o = n1750_o ? pre_xy_f_m : n1863_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1877_o = n1750_o ? intcycle : n1864_o;
  /* ./T80/T80.vhd:1171:49  */
  assign n1878_o = n1750_o ? nmicycle : n1865_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1879_o = n1746_o ? n1745_o : n1866_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1880_o = n1746_o ? tstate : n1867_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1881_o = n1746_o ? mcycle : n1868_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1882_o = n1746_o ? n1730_o : n1869_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1883_o = n1746_o ? n1732_o : n1870_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1884_o = n1746_o ? n1737_o : n1871_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1885_o = n1746_o ? busack : n1873_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1886_o = n1746_o ? n1690_o : n1875_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1887_o = n1746_o ? pre_xy_f_m : n1876_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1888_o = n1746_o ? intcycle : n1877_o;
  /* ./T80/T80.vhd:1168:41  */
  assign n1889_o = n1746_o ? nmicycle : n1878_o;
  /* ./T80/T80.vhd:1213:51  */
  assign n1891_o = tstate == 3'b000;
  /* ./T80/T80.vhd:1213:41  */
  assign n1893_o = n1891_o ? 1'b0 : n1879_o;
  /* ./T80/T80.vhd:1135:33  */
  assign n1894_o = cen ? n1893_o : n2049_q;
  /* ./T80/T80.vhd:1135:33  */
  assign n1895_o = cen ? n1880_o : tstate;
  /* ./T80/T80.vhd:1135:33  */
  assign n1896_o = cen ? n1881_o : mcycle;
  /* ./T80/T80.vhd:1135:33  */
  assign n1897_o = cen ? n1882_o : inte_ff1;
  /* ./T80/T80.vhd:1135:33  */
  assign n1898_o = cen ? n1883_o : inte_ff2;
  /* ./T80/T80.vhd:1135:33  */
  assign n1899_o = cen ? n1884_o : halt_ff;
  /* ./T80/T80.vhd:1135:33  */
  assign n1900_o = cen ? n1691_o : busreq_s;
  /* ./T80/T80.vhd:1135:33  */
  assign n1901_o = cen ? n1885_o : busack;
  /* ./T80/T80.vhd:1135:33  */
  assign n1902_o = cen ? n1886_o : n1690_o;
  /* ./T80/T80.vhd:1135:33  */
  assign n1903_o = cen ? n1887_o : pre_xy_f_m;
  /* ./T80/T80.vhd:1135:33  */
  assign n1904_o = cen ? n1717_o : no_btr;
  /* ./T80/T80.vhd:1135:33  */
  assign n1905_o = cen ? n1694_o : auto_wait_t1;
  /* ./T80/T80.vhd:1135:33  */
  assign n1906_o = cen ? n1696_o : auto_wait_t2;
  /* ./T80/T80.vhd:1135:33  */
  assign n1907_o = cen ? n1888_o : intcycle;
  /* ./T80/T80.vhd:1135:33  */
  assign n1908_o = cen ? n1889_o : nmicycle;
  /* ./T80/T80.vhd:1110:25  */
  assign n1910_o = dirset ? 1'b0 : n1894_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1912_o = dirset ? 3'b001 : n1895_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1914_o = dirset ? 3'b001 : n1896_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1915_o = dirset ? n1685_o : n1897_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1916_o = dirset ? n1684_o : n1898_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1917_o = dirset ? n1686_o : n1899_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1919_o = dirset ? 1'b0 : n1900_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1921_o = dirset ? 1'b0 : n1901_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1923_o = dirset ? 1'b0 : n1902_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1925_o = dirset ? 3'b000 : n1903_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1927_o = dirset ? 1'b0 : n1904_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1929_o = dirset ? 1'b0 : n1905_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1931_o = dirset ? 1'b0 : n1906_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1933_o = dirset ? 1'b0 : n1907_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1935_o = dirset ? 1'b0 : n1908_o;
  /* ./T80/T80.vhd:1110:25  */
  assign n1936_o = dirset ? n1679_oldnmi_n : nmi_n;
  /* ./T80/T80.vhd:1089:9  */
  assign n1985_o = ~n1682_o;
  /* ./T80/T80.vhd:1108:17  */
  assign n1986_o = n1985_o ? n1936_o : n1679_oldnmi_n;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n)
    n1987_q <= n1986_o;
  /* ./T80/T80.vhd:1221:57  */
  assign n1990_o = mcycle == 3'b001;
  /* ./T80/T80.vhd:1221:46  */
  assign n1991_o = n1990_o & intcycle;
  /* ./T80/T80.vhd:1221:26  */
  assign n1992_o = n1991_o ? 1'b1 : 1'b0;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n1994_q <= 8'b11111111;
    else
      n1994_q <= n1162_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n1995_q <= 8'b11111111;
    else
      n1995_q <= n1163_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n1996_q <= 8'b11111111;
    else
      n1996_q <= n1164_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n1997_q <= 8'b11111111;
    else
      n1997_q <= n1165_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n1998_q <= 8'b00000000;
    else
      n1998_q <= n1166_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n1999_q <= 8'b00000000;
    else
      n1999_q <= n1167_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2000_q <= 16'b1111111111111111;
    else
      n2000_q <= n1168_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2001_q <= 16'b0000000000000000;
    else
      n2001_q <= n1169_o;
  /* ./T80/T80.vhd:390:17  */
  assign n2002_o = {regs_doah, regs_doal};
  /* ./T80/T80.vhd:390:17  */
  assign n2003_o = {regs_dobh, regs_dobl};
  /* ./T80/T80.vhd:390:17  */
  assign n2004_o = {regs_doch, regs_docl};
  /* ./T80/T80.vhd:851:17  */
  assign n2005_o = clken ? n1306_o : regaddra_r;
  /* ./T80/T80.vhd:851:17  */
  always @(posedge clk_n)
    n2006_q <= n2005_o;
  /* ./T80/T80.vhd:851:17  */
  assign n2007_o = clken ? n1320_o : regaddrb_r;
  /* ./T80/T80.vhd:851:17  */
  always @(posedge clk_n)
    n2008_q <= n2007_o;
  /* ./T80/T80.vhd:851:17  */
  assign n2009_o = clken ? n1337_o : regaddrc;
  /* ./T80/T80.vhd:851:17  */
  always @(posedge clk_n)
    n2010_q <= n2009_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2011_q <= 1'b0;
    else
      n2011_q <= n1170_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2012_q <= 16'b0000000000000000;
    else
      n2012_q <= n1171_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2013_q <= 8'b00000000;
    else
      n2013_q <= n1173_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2014_q <= 2'b00;
    else
      n2014_q <= n1175_o;
  /* ./T80/T80.vhd:851:17  */
  assign n2015_o = clken ? regbusa : regbusa_r;
  /* ./T80/T80.vhd:851:17  */
  always @(posedge clk_n)
    n2016_q <= n2015_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2017_q <= 3'b000;
    else
      n2017_q <= n1912_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2018_q <= 3'b001;
    else
      n2018_q <= n1914_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2019_q <= 1'b0;
    else
      n2019_q <= n1915_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2020_q <= 1'b0;
    else
      n2020_q <= n1916_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2021_q <= 1'b0;
    else
      n2021_q <= n1917_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2022_q <= 1'b0;
    else
      n2022_q <= n1919_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2023_q <= 1'b0;
    else
      n2023_q <= n1921_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2024_q <= 1'b0;
    else
      n2024_q <= n1923_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2025_q <= 2'b00;
    else
      n2025_q <= n1176_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2026_q <= 2'b00;
    else
      n2026_q <= n1178_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2027_q <= 3'b000;
    else
      n2027_q <= n1925_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2028_q <= 1'b0;
    else
      n2028_q <= n1180_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2029_q <= 1'b0;
    else
      n2029_q <= n1927_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2030_q <= 1'b0;
    else
      n2030_q <= n1182_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2031_q <= 1'b0;
    else
      n2031_q <= n1929_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2032_q <= 1'b0;
    else
      n2032_q <= n1931_o;
  /* ./T80/T80.vhd:851:17  */
  assign n2033_o = clken ? n1360_o : incdecz;
  /* ./T80/T80.vhd:851:17  */
  always @(posedge clk_n)
    n2034_q <= n2033_o;
  /* ./T80/T80.vhd:991:17  */
  assign n2035_o = clken ? n1646_o : busb;
  /* ./T80/T80.vhd:991:17  */
  always @(posedge clk_n)
    n2036_q <= n2035_o;
  /* ./T80/T80.vhd:991:17  */
  assign n2037_o = clken ? n1647_o : busa;
  /* ./T80/T80.vhd:991:17  */
  always @(posedge clk_n)
    n2038_q <= n2037_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2039_q <= 5'b00000;
    else
      n2039_q <= n1184_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2040_q <= 1'b0;
    else
      n2040_q <= n1186_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2041_q <= 1'b0;
    else
      n2041_q <= n1188_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2042_q <= 4'b0000;
    else
      n2042_q <= n1190_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2043_q <= 1'b0;
    else
      n2043_q <= n1192_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2044_q <= 1'b0;
    else
      n2044_q <= n1194_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2045_q <= 3'b000;
    else
      n2045_q <= n1196_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2046_q <= 1'b0;
    else
      n2046_q <= n1933_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2047_q <= 1'b0;
    else
      n2047_q <= n1935_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2048_q <= 1'b0;
    else
      n2048_q <= n1198_o;
  /* ./T80/T80.vhd:1108:17  */
  always @(posedge clk_n or posedge n1682_o)
    if (n1682_o)
      n2049_q <= 1'b1;
    else
      n2049_q <= n1910_o;
  /* ./T80/T80.vhd:1063:17  */
  assign n2050_o = n1658_o ? n1670_o : n2051_q;
  /* ./T80/T80.vhd:1063:17  */
  always @(posedge clk_n or posedge n1655_o)
    if (n1655_o)
      n2051_q <= 1'b1;
    else
      n2051_q <= n2050_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2052_q <= 16'b0000000000000000;
    else
      n2052_q <= n1159_o;
  /* ./T80/T80.vhd:420:17  */
  always @(posedge clk_n or posedge n290_o)
    if (n290_o)
      n2053_q <= 8'b00000000;
    else
      n2053_q <= n1161_o;
endmodule

module T80s
  (input  RESET_n,
   input  CLK,
   input  CEN,
   input  WAIT_n,
   input  INT_n,
   input  NMI_n,
   input  BUSRQ_n,
   input  OUT0,
   input  [7:0] DI,
   input  DIRSet,
   input  [229:0] DIR,
   output M1_n,
   output MREQ_n,
   output IORQ_n,
   output RD_n,
   output WR_n,
   output RFSH_n,
   output HALT_n,
   output BUSAK_n,
   output [15:0] A,
   output [7:0] DO,
   output [229:0] REG,
   output [1:0] ISet_out);
  wire intcycle_n;
  wire noread;
  wire write;
  wire iorq;
  wire [7:0] di_reg;
  wire [2:0] mcycle;
  wire [2:0] tstate;
  wire u0_m1_n;
  wire u0_iorq;
  wire u0_noread;
  wire u0_write;
  wire u0_rfsh_n;
  wire u0_halt_n;
  wire u0_busak_n;
  wire [15:0] u0_a;
  wire [7:0] u0_do;
  wire [2:0] u0_mc;
  wire [2:0] u0_ts;
  wire u0_intcycle_n;
  wire u0_inte;
  wire u0_stop;
  wire [229:0] u0_reg_esc ;
  wire [1:0] u0_iset_out;
  wire n28_o;
  wire n31_o;
  wire n33_o;
  wire n35_o;
  wire n36_o;
  wire n37_o;
  wire n38_o;
  wire n39_o;
  wire n40_o;
  wire n42_o;
  wire n44_o;
  wire n46_o;
  wire n48_o;
  wire n50_o;
  wire n52_o;
  wire n54_o;
  wire n55_o;
  wire n56_o;
  wire n57_o;
  wire n58_o;
  wire n59_o;
  wire n60_o;
  wire n61_o;
  wire n62_o;
  wire n64_o;
  wire n66_o;
  wire n69_o;
  wire n71_o;
  wire n73_o;
  wire n74_o;
  wire n75_o;
  wire n76_o;
  wire n77_o;
  wire n78_o;
  wire n79_o;
  wire n80_o;
  wire n83_o;
  wire n84_o;
  wire n86_o;
  wire n88_o;
  wire n91_o;
  wire n94_o;
  wire n95_o;
  wire [7:0] n96_o;
  wire n97_o;
  wire n98_o;
  wire n99_o;
  wire n100_o;
  wire n101_o;
  wire n103_o;
  wire n105_o;
  wire n107_o;
  wire n109_o;
  wire [7:0] n110_o;
  reg [7:0] n127_q;
  reg n128_q;
  reg n129_q;
  reg n130_q;
  reg n131_q;
  assign M1_n = u0_m1_n;
  assign MREQ_n = n128_q;
  assign IORQ_n = n129_q;
  assign RD_n = n130_q;
  assign WR_n = n131_q;
  assign RFSH_n = u0_rfsh_n;
  assign HALT_n = u0_halt_n;
  assign BUSAK_n = u0_busak_n;
  assign A = u0_a;
  assign DO = u0_do;
  assign REG = u0_reg_esc ;
  assign ISet_out = u0_iset_out;
  /* ./T80/T80s.vhd:110:16  */
  assign intcycle_n = u0_intcycle_n; // (signal)
  /* ./T80/T80s.vhd:111:16  */
  assign noread = u0_noread; // (signal)
  /* ./T80/T80s.vhd:112:16  */
  assign write = u0_write; // (signal)
  /* ./T80/T80s.vhd:113:16  */
  assign iorq = u0_iorq; // (signal)
  /* ./T80/T80s.vhd:114:16  */
  assign di_reg = n127_q; // (signal)
  /* ./T80/T80s.vhd:115:16  */
  assign mcycle = u0_mc; // (signal)
  /* ./T80/T80s.vhd:116:16  */
  assign tstate = u0_ts; // (signal)
  /* ./T80/T80s.vhd:120:9  */
  t80_0_1_0_1_2_3_4_5_6_7 u0 (
    .reset_n(RESET_n),
    .clk_n(CLK),
    .cen(CEN),
    .wait_n(WAIT_n),
    .int_n(INT_n),
    .nmi_n(NMI_n),
    .busrq_n(BUSRQ_n),
    .dinst(DI),
    .di(di_reg),
    .out0(OUT0),
    .dirset(DIRSet),
    .dir(DIR),
    .m1_n(u0_m1_n),
    .iorq(u0_iorq),
    .noread(u0_noread),
    .write(u0_write),
    .rfsh_n(u0_rfsh_n),
    .halt_n(u0_halt_n),
    .busak_n(u0_busak_n),
    .a(u0_a),
    .do(u0_do),
    .mc(u0_mc),
    .ts(u0_ts),
    .intcycle_n(u0_intcycle_n),
    .inte(),
    .stop(),
    .\reg (u0_reg_esc ),
    .iset_out(u0_iset_out));
  /* ./T80/T80s.vhd:155:28  */
  assign n28_o = ~RESET_n;
  /* ./T80/T80s.vhd:172:43  */
  assign n31_o = mcycle == 3'b001;
  /* ./T80/T80s.vhd:173:51  */
  assign n33_o = tstate == 3'b001;
  /* ./T80/T80s.vhd:173:70  */
  assign n35_o = tstate == 3'b010;
  /* ./T80/T80s.vhd:173:89  */
  assign n36_o = ~WAIT_n;
  /* ./T80/T80s.vhd:173:78  */
  assign n37_o = n36_o & n35_o;
  /* ./T80/T80s.vhd:173:59  */
  assign n38_o = n33_o | n37_o;
  /* ./T80/T80s.vhd:174:57  */
  assign n39_o = ~intcycle_n;
  /* ./T80/T80s.vhd:175:59  */
  assign n40_o = ~intcycle_n;
  /* ./T80/T80s.vhd:173:41  */
  assign n42_o = n38_o ? n40_o : 1'b1;
  /* ./T80/T80s.vhd:173:41  */
  assign n44_o = n38_o ? intcycle_n : 1'b1;
  /* ./T80/T80s.vhd:173:41  */
  assign n46_o = n38_o ? n39_o : 1'b1;
  /* ./T80/T80s.vhd:178:51  */
  assign n48_o = tstate == 3'b011;
  /* ./T80/T80s.vhd:178:41  */
  assign n50_o = n48_o ? 1'b0 : n42_o;
  /* ./T80/T80s.vhd:182:52  */
  assign n52_o = tstate == 3'b001;
  /* ./T80/T80s.vhd:182:71  */
  assign n54_o = tstate == 3'b010;
  /* ./T80/T80s.vhd:182:90  */
  assign n55_o = ~WAIT_n;
  /* ./T80/T80s.vhd:182:79  */
  assign n56_o = n55_o & n54_o;
  /* ./T80/T80s.vhd:182:60  */
  assign n57_o = n52_o | n56_o;
  /* ./T80/T80s.vhd:182:109  */
  assign n58_o = ~noread;
  /* ./T80/T80s.vhd:182:98  */
  assign n59_o = n58_o & n57_o;
  /* ./T80/T80s.vhd:182:125  */
  assign n60_o = ~write;
  /* ./T80/T80s.vhd:182:115  */
  assign n61_o = n60_o & n59_o;
  /* ./T80/T80s.vhd:184:59  */
  assign n62_o = ~iorq;
  /* ./T80/T80s.vhd:182:41  */
  assign n64_o = n61_o ? iorq : 1'b1;
  /* ./T80/T80s.vhd:182:41  */
  assign n66_o = n61_o ? n62_o : 1'b1;
  /* ./T80/T80s.vhd:182:41  */
  assign n69_o = n61_o ? 1'b0 : 1'b1;
  /* ./T80/T80s.vhd:194:60  */
  assign n71_o = tstate == 3'b001;
  /* ./T80/T80s.vhd:194:79  */
  assign n73_o = tstate == 3'b010;
  /* ./T80/T80s.vhd:194:98  */
  assign n74_o = ~WAIT_n;
  /* ./T80/T80s.vhd:194:87  */
  assign n75_o = n74_o & n73_o;
  /* ./T80/T80s.vhd:194:68  */
  assign n76_o = n71_o | n75_o;
  /* ./T80/T80s.vhd:194:106  */
  assign n77_o = write & n76_o;
  /* ./T80/T80s.vhd:196:67  */
  assign n78_o = ~iorq;
  /* ./T80/T80s.vhd:194:49  */
  assign n79_o = n77_o ? iorq : n64_o;
  /* ./T80/T80s.vhd:194:49  */
  assign n80_o = n77_o ? n78_o : n66_o;
  /* ./T80/T80s.vhd:194:49  */
  assign n83_o = n77_o ? 1'b0 : 1'b1;
  /* ./T80/T80s.vhd:172:33  */
  assign n84_o = n31_o ? n50_o : n79_o;
  /* ./T80/T80s.vhd:172:33  */
  assign n86_o = n31_o ? n44_o : n80_o;
  /* ./T80/T80s.vhd:172:33  */
  assign n88_o = n31_o ? n46_o : n69_o;
  /* ./T80/T80s.vhd:172:33  */
  assign n91_o = n31_o ? 1'b1 : n83_o;
  /* ./T80/T80s.vhd:201:43  */
  assign n94_o = tstate == 3'b010;
  /* ./T80/T80s.vhd:201:51  */
  assign n95_o = WAIT_n & n94_o;
  /* ./T80/T80s.vhd:167:25  */
  assign n96_o = n101_o ? DI : di_reg;
  /* ./T80/T80s.vhd:167:25  */
  assign n97_o = CEN ? n84_o : n128_q;
  /* ./T80/T80s.vhd:167:25  */
  assign n98_o = CEN ? n86_o : n129_q;
  /* ./T80/T80s.vhd:167:25  */
  assign n99_o = CEN ? n88_o : n130_q;
  /* ./T80/T80s.vhd:167:25  */
  assign n100_o = CEN ? n91_o : n131_q;
  /* ./T80/T80s.vhd:167:25  */
  assign n101_o = n95_o & CEN;
  /* ./T80/T80s.vhd:162:25  */
  assign n103_o = DIRSet ? 1'b1 : n97_o;
  /* ./T80/T80s.vhd:162:25  */
  assign n105_o = DIRSet ? 1'b1 : n98_o;
  /* ./T80/T80s.vhd:162:25  */
  assign n107_o = DIRSet ? 1'b1 : n99_o;
  /* ./T80/T80s.vhd:162:25  */
  assign n109_o = DIRSet ? 1'b1 : n100_o;
  /* ./T80/T80s.vhd:162:25  */
  assign n110_o = DIRSet ? di_reg : n96_o;
  /* ./T80/T80s.vhd:161:17  */
  always @(posedge CLK or posedge n28_o)
    if (n28_o)
      n127_q <= 8'b00000000;
    else
      n127_q <= n110_o;
  /* ./T80/T80s.vhd:161:17  */
  always @(posedge CLK or posedge n28_o)
    if (n28_o)
      n128_q <= 1'b1;
    else
      n128_q <= n103_o;
  /* ./T80/T80s.vhd:161:17  */
  always @(posedge CLK or posedge n28_o)
    if (n28_o)
      n129_q <= 1'b1;
    else
      n129_q <= n105_o;
  /* ./T80/T80s.vhd:161:17  */
  always @(posedge CLK or posedge n28_o)
    if (n28_o)
      n130_q <= 1'b1;
    else
      n130_q <= n107_o;
  /* ./T80/T80s.vhd:161:17  */
  always @(posedge CLK or posedge n28_o)
    if (n28_o)
      n131_q <= 1'b1;
    else
      n131_q <= n109_o;
endmodule

