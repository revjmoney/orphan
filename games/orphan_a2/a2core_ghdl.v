module t65_alu
  (input  [1:0] mode,
   input  bcd_en,
   input  [4:0] op,
   input  [7:0] busa,
   input  [7:0] busb,
   input  [7:0] p_in,
   output [7:0] p_out,
   output [7:0] q);
  wire adc_z;
  wire adc_c;
  wire adc_v;
  wire adc_n;
  wire [7:0] adc_q;
  wire sbc_z;
  wire sbc_c;
  wire sbc_v;
  wire sbc_n;
  wire [7:0] sbc_q;
  wire [7:0] sbx_q;
  wire [3:0] n5037_o;
  wire n5038_o;
  wire [4:0] n5039_o;
  wire [6:0] n5040_o;
  wire [3:0] n5041_o;
  wire [4:0] n5043_o;
  wire [6:0] n5044_o;
  wire [6:0] n5045_o;
  wire [3:0] n5046_o;
  wire n5047_o;
  wire [4:0] n5048_o;
  wire [6:0] n5049_o;
  wire [3:0] n5050_o;
  wire [4:0] n5052_o;
  wire [6:0] n5053_o;
  wire [6:0] n5054_o;
  wire [3:0] n5055_o;
  wire n5057_o;
  wire [3:0] n5058_o;
  wire n5060_o;
  wire n5061_o;
  wire n5064_o;
  wire [4:0] n5065_o;
  wire n5067_o;
  wire n5068_o;
  wire n5069_o;
  wire n5070_o;
  wire [5:0] n5071_o;
  wire [5:0] n5073_o;
  wire [5:0] n5074_o;
  wire [5:0] n5075_o;
  wire n5076_o;
  wire [6:0] n5077_o;
  wire n5078_o;
  wire [6:0] n5079_o;
  wire n5080_o;
  wire n5081_o;
  wire [3:0] n5082_o;
  wire [4:0] n5083_o;
  wire [6:0] n5084_o;
  wire [3:0] n5085_o;
  wire [4:0] n5087_o;
  wire [6:0] n5088_o;
  wire [6:0] n5089_o;
  wire n5090_o;
  wire n5091_o;
  wire n5092_o;
  wire n5093_o;
  wire n5094_o;
  wire n5095_o;
  wire n5096_o;
  wire n5097_o;
  wire n5098_o;
  wire [4:0] n5099_o;
  wire n5101_o;
  wire n5102_o;
  wire n5103_o;
  wire n5104_o;
  wire [5:0] n5105_o;
  wire [5:0] n5107_o;
  wire [5:0] n5108_o;
  wire [5:0] n5109_o;
  wire n5110_o;
  wire [6:0] n5111_o;
  wire n5112_o;
  wire [6:0] n5113_o;
  wire n5114_o;
  wire n5115_o;
  wire [6:0] n5116_o;
  wire [3:0] n5117_o;
  wire [6:0] n5118_o;
  wire [3:0] n5119_o;
  wire [7:0] n5120_o;
  wire n5131_o;
  wire n5133_o;
  wire n5134_o;
  wire n5136_o;
  wire n5137_o;
  wire n5139_o;
  wire n5140_o;
  wire n5142_o;
  wire n5143_o;
  wire n5145_o;
  wire n5146_o;
  wire n5148_o;
  wire n5149_o;
  wire n5152_o;
  wire n5154_o;
  wire n5155_o;
  wire n5156_o;
  wire [3:0] n5157_o;
  wire [4:0] n5158_o;
  wire [6:0] n5159_o;
  wire [3:0] n5160_o;
  wire [4:0] n5162_o;
  wire [5:0] n5163_o;
  wire [6:0] n5164_o;
  wire [6:0] n5165_o;
  wire [3:0] n5166_o;
  wire [4:0] n5168_o;
  wire [5:0] n5169_o;
  wire [3:0] n5170_o;
  wire n5171_o;
  wire [4:0] n5172_o;
  wire [5:0] n5173_o;
  wire [5:0] n5174_o;
  wire [3:0] n5175_o;
  wire n5177_o;
  wire [3:0] n5178_o;
  wire n5180_o;
  wire n5181_o;
  wire n5184_o;
  wire n5185_o;
  wire n5186_o;
  wire n5187_o;
  wire n5188_o;
  wire n5189_o;
  wire n5190_o;
  wire n5191_o;
  wire n5192_o;
  wire n5193_o;
  wire n5194_o;
  wire [3:0] n5195_o;
  wire [3:0] n5196_o;
  wire [7:0] n5197_o;
  wire n5198_o;
  wire n5199_o;
  wire n5200_o;
  wire [4:0] n5201_o;
  wire [4:0] n5203_o;
  wire [4:0] n5204_o;
  wire [4:0] n5205_o;
  wire [3:0] n5206_o;
  wire [4:0] n5208_o;
  wire [5:0] n5209_o;
  wire [3:0] n5210_o;
  wire n5211_o;
  wire n5212_o;
  wire [6:0] n5213_o;
  wire n5214_o;
  wire [4:0] n5215_o;
  wire [5:0] n5216_o;
  wire [5:0] n5217_o;
  wire n5218_o;
  wire [4:0] n5219_o;
  wire [4:0] n5221_o;
  wire [4:0] n5222_o;
  wire [4:0] n5223_o;
  wire n5224_o;
  wire [4:0] n5225_o;
  wire [4:0] n5226_o;
  wire n5227_o;
  wire n5228_o;
  wire [5:0] n5229_o;
  wire [5:0] n5230_o;
  wire [3:0] n5231_o;
  wire [6:0] n5232_o;
  wire [3:0] n5233_o;
  wire [7:0] n5234_o;
  wire [7:0] n5241_o;
  wire n5243_o;
  wire [7:0] n5244_o;
  wire n5246_o;
  wire [7:0] n5247_o;
  wire n5249_o;
  wire n5251_o;
  wire n5253_o;
  wire n5255_o;
  wire n5257_o;
  wire [6:0] n5258_o;
  wire [7:0] n5260_o;
  wire n5261_o;
  wire n5263_o;
  wire [6:0] n5264_o;
  wire n5265_o;
  wire [7:0] n5266_o;
  wire n5267_o;
  wire n5269_o;
  wire [6:0] n5270_o;
  wire [7:0] n5272_o;
  wire n5273_o;
  wire n5275_o;
  wire n5276_o;
  wire [6:0] n5277_o;
  wire [7:0] n5278_o;
  wire n5279_o;
  wire n5281_o;
  wire n5282_o;
  wire [6:0] n5283_o;
  wire [6:0] n5284_o;
  wire [6:0] n5285_o;
  wire [7:0] n5286_o;
  wire n5287_o;
  wire n5288_o;
  wire n5289_o;
  wire n5290_o;
  wire n5291_o;
  wire [3:0] n5292_o;
  wire [3:0] n5293_o;
  wire [3:0] n5294_o;
  wire n5296_o;
  wire [3:0] n5297_o;
  wire [3:0] n5299_o;
  wire [3:0] n5300_o;
  wire [3:0] n5301_o;
  wire [3:0] n5302_o;
  wire [3:0] n5303_o;
  wire [3:0] n5304_o;
  wire n5306_o;
  wire [3:0] n5307_o;
  wire [3:0] n5309_o;
  wire n5312_o;
  wire [3:0] n5313_o;
  wire [3:0] n5314_o;
  wire n5315_o;
  wire n5316_o;
  wire [7:0] n5317_o;
  wire [7:0] n5318_o;
  wire n5320_o;
  wire n5321_o;
  wire n5323_o;
  wire [7:0] n5325_o;
  wire n5327_o;
  wire [7:0] n5329_o;
  wire n5331_o;
  wire [14:0] n5332_o;
  wire n5333_o;
  reg n5334_o;
  wire n5335_o;
  reg n5336_o;
  wire n5338_o;
  reg [7:0] n5340_o;
  reg [7:0] n5341_o;
  wire n5343_o;
  wire n5345_o;
  wire n5347_o;
  wire n5348_o;
  wire n5350_o;
  wire n5351_o;
  wire n5353_o;
  wire n5354_o;
  wire [7:0] n5355_o;
  wire n5357_o;
  wire n5360_o;
  wire n5362_o;
  wire n5363_o;
  wire n5364_o;
  wire n5366_o;
  wire n5369_o;
  wire n5371_o;
  wire n5372_o;
  wire n5374_o;
  wire n5377_o;
  wire [4:0] n5378_o;
  reg n5379_o;
  wire n5380_o;
  reg n5381_o;
  reg n5382_o;
  wire [3:0] n5383_o;
  wire n5385_o;
  wire [7:0] n5386_o;
  wire [7:0] n5388_o;
  assign p_out = n5388_o;
  assign q = n5386_o;
  /* ./T65_ALU.vhd:73:15  */
  assign adc_z = n5064_o; // (signal)
  /* ./T65_ALU.vhd:74:15  */
  assign adc_c = n5115_o; // (signal)
  /* ./T65_ALU.vhd:75:15  */
  assign adc_v = n5098_o; // (signal)
  /* ./T65_ALU.vhd:76:15  */
  assign adc_n = n5090_o; // (signal)
  /* ./T65_ALU.vhd:77:15  */
  assign adc_q = n5120_o; // (signal)
  /* ./T65_ALU.vhd:78:15  */
  assign sbc_z = n5184_o; // (signal)
  /* ./T65_ALU.vhd:79:15  */
  assign sbc_c = n5186_o; // (signal)
  /* ./T65_ALU.vhd:80:15  */
  assign sbc_v = n5193_o; // (signal)
  /* ./T65_ALU.vhd:81:15  */
  assign sbc_n = n5194_o; // (signal)
  /* ./T65_ALU.vhd:82:15  */
  assign sbc_q = n5234_o; // (signal)
  /* ./T65_ALU.vhd:83:15  */
  assign sbx_q = n5197_o; // (signal)
  /* ./T65_ALU.vhd:92:31  */
  assign n5037_o = busa[3:0];
  /* ./T65_ALU.vhd:92:50  */
  assign n5038_o = p_in[0];
  /* ./T65_ALU.vhd:92:44  */
  assign n5039_o = {n5037_o, n5038_o};
  /* ./T65_ALU.vhd:92:11  */
  assign n5040_o = {2'b0, n5039_o};  //  uext
  /* ./T65_ALU.vhd:92:86  */
  assign n5041_o = busb[3:0];
  /* ./T65_ALU.vhd:92:99  */
  assign n5043_o = {n5041_o, 1'b1};
  /* ./T65_ALU.vhd:92:66  */
  assign n5044_o = {2'b0, n5043_o};  //  uext
  /* ./T65_ALU.vhd:92:64  */
  assign n5045_o = n5040_o + n5044_o;
  /* ./T65_ALU.vhd:93:31  */
  assign n5046_o = busa[7:4];
  /* ./T65_ALU.vhd:93:48  */
  assign n5047_o = n5045_o[5];
  /* ./T65_ALU.vhd:93:44  */
  assign n5048_o = {n5046_o, n5047_o};
  /* ./T65_ALU.vhd:93:11  */
  assign n5049_o = {2'b0, n5048_o};  //  uext
  /* ./T65_ALU.vhd:93:79  */
  assign n5050_o = busb[7:4];
  /* ./T65_ALU.vhd:93:92  */
  assign n5052_o = {n5050_o, 1'b1};
  /* ./T65_ALU.vhd:93:59  */
  assign n5053_o = {2'b0, n5052_o};  //  uext
  /* ./T65_ALU.vhd:93:57  */
  assign n5054_o = n5049_o + n5053_o;
  /* ./T65_ALU.vhd:100:10  */
  assign n5055_o = n5045_o[4:1];
  /* ./T65_ALU.vhd:100:23  */
  assign n5057_o = n5055_o == 4'b0000;
  /* ./T65_ALU.vhd:100:33  */
  assign n5058_o = n5054_o[4:1];
  /* ./T65_ALU.vhd:100:46  */
  assign n5060_o = n5058_o == 4'b0000;
  /* ./T65_ALU.vhd:100:27  */
  assign n5061_o = n5060_o & n5057_o;
  /* ./T65_ALU.vhd:100:5  */
  assign n5064_o = n5061_o ? 1'b1 : 1'b0;
  /* ./T65_ALU.vhd:106:10  */
  assign n5065_o = n5045_o[5:1];
  /* ./T65_ALU.vhd:106:23  */
  assign n5067_o = $unsigned(n5065_o) > $unsigned(5'b01001);
  /* ./T65_ALU.vhd:106:35  */
  assign n5068_o = p_in[3];
  /* ./T65_ALU.vhd:106:27  */
  assign n5069_o = n5068_o & n5067_o;
  /* ./T65_ALU.vhd:106:50  */
  assign n5070_o = bcd_en & n5069_o;
  /* ./T65_ALU.vhd:107:27  */
  assign n5071_o = n5045_o[6:1];
  /* ./T65_ALU.vhd:107:40  */
  assign n5073_o = n5071_o + 6'b000110;
  assign n5074_o = n5045_o[6:1];
  /* ./T65_ALU.vhd:106:5  */
  assign n5075_o = n5070_o ? n5073_o : n5074_o;
  assign n5076_o = n5045_o[0];
  /* ./T65_MCode.vhd:451:15  */
  assign n5077_o = {n5075_o, n5076_o};
  /* ./T65_ALU.vhd:110:12  */
  assign n5078_o = n5077_o[6];
  assign n5079_o = {n5075_o, n5076_o};
  /* ./T65_ALU.vhd:110:21  */
  assign n5080_o = n5079_o[5];
  /* ./T65_ALU.vhd:110:16  */
  assign n5081_o = n5078_o | n5080_o;
  /* ./T65_ALU.vhd:111:31  */
  assign n5082_o = busa[7:4];
  /* ./T65_ALU.vhd:111:44  */
  assign n5083_o = {n5082_o, n5081_o};
  /* ./T65_ALU.vhd:111:11  */
  assign n5084_o = {2'b0, n5083_o};  //  uext
  /* ./T65_ALU.vhd:111:75  */
  assign n5085_o = busb[7:4];
  /* ./T65_ALU.vhd:111:88  */
  assign n5087_o = {n5085_o, 1'b1};
  /* ./T65_ALU.vhd:111:55  */
  assign n5088_o = {2'b0, n5087_o};  //  uext
  /* ./T65_ALU.vhd:111:53  */
  assign n5089_o = n5084_o + n5088_o;
  /* ./T65_ALU.vhd:113:16  */
  assign n5090_o = n5089_o[4];
  /* ./T65_ALU.vhd:114:17  */
  assign n5091_o = n5089_o[4];
  /* ./T65_ALU.vhd:114:29  */
  assign n5092_o = busa[7];
  /* ./T65_ALU.vhd:114:21  */
  assign n5093_o = n5091_o ^ n5092_o;
  /* ./T65_ALU.vhd:114:47  */
  assign n5094_o = busa[7];
  /* ./T65_ALU.vhd:114:59  */
  assign n5095_o = busb[7];
  /* ./T65_ALU.vhd:114:51  */
  assign n5096_o = n5094_o ^ n5095_o;
  /* ./T65_ALU.vhd:114:38  */
  assign n5097_o = ~n5096_o;
  /* ./T65_ALU.vhd:114:34  */
  assign n5098_o = n5093_o & n5097_o;
  /* ./T65_ALU.vhd:120:10  */
  assign n5099_o = n5089_o[5:1];
  /* ./T65_ALU.vhd:120:23  */
  assign n5101_o = $unsigned(n5099_o) > $unsigned(5'b01001);
  /* ./T65_ALU.vhd:120:35  */
  assign n5102_o = p_in[3];
  /* ./T65_ALU.vhd:120:27  */
  assign n5103_o = n5102_o & n5101_o;
  /* ./T65_ALU.vhd:120:50  */
  assign n5104_o = bcd_en & n5103_o;
  /* ./T65_ALU.vhd:121:27  */
  assign n5105_o = n5089_o[6:1];
  /* ./T65_ALU.vhd:121:40  */
  assign n5107_o = n5105_o + 6'b000110;
  assign n5108_o = n5089_o[6:1];
  /* ./T65_ALU.vhd:120:5  */
  assign n5109_o = n5104_o ? n5107_o : n5108_o;
  assign n5110_o = n5089_o[0];
  assign n5111_o = {n5109_o, n5110_o};
  /* ./T65_ALU.vhd:124:16  */
  assign n5112_o = n5111_o[6];
  assign n5113_o = {n5109_o, n5110_o};
  /* ./T65_ALU.vhd:124:25  */
  assign n5114_o = n5113_o[5];
  /* ./T65_ALU.vhd:124:20  */
  assign n5115_o = n5112_o | n5114_o;
  assign n5116_o = {n5109_o, n5110_o};
  /* ./T65_ALU.vhd:126:33  */
  assign n5117_o = n5116_o[4:1];
  assign n5118_o = {n5075_o, n5076_o};
  /* ./T65_ALU.vhd:126:50  */
  assign n5119_o = n5118_o[4:1];
  /* ./T65_ALU.vhd:126:46  */
  assign n5120_o = {n5117_o, n5119_o};
  /* ./T65_ALU.vhd:136:12  */
  assign n5131_o = op == 5'b00001;
  /* ./T65_ALU.vhd:137:12  */
  assign n5133_o = op == 5'b00011;
  /* ./T65_ALU.vhd:136:24  */
  assign n5134_o = n5131_o | n5133_o;
  /* ./T65_ALU.vhd:138:12  */
  assign n5136_o = op == 5'b00101;
  /* ./T65_ALU.vhd:137:24  */
  assign n5137_o = n5134_o | n5136_o;
  /* ./T65_ALU.vhd:139:12  */
  assign n5139_o = op == 5'b00111;
  /* ./T65_ALU.vhd:138:24  */
  assign n5140_o = n5137_o | n5139_o;
  /* ./T65_ALU.vhd:140:12  */
  assign n5142_o = op == 5'b01001;
  /* ./T65_ALU.vhd:139:24  */
  assign n5143_o = n5140_o | n5142_o;
  /* ./T65_ALU.vhd:141:12  */
  assign n5145_o = op == 5'b01011;
  /* ./T65_ALU.vhd:140:24  */
  assign n5146_o = n5143_o | n5145_o;
  /* ./T65_ALU.vhd:143:12  */
  assign n5148_o = op == 5'b01110;
  /* ./T65_ALU.vhd:141:24  */
  assign n5149_o = n5146_o | n5148_o;
  /* ./T65_ALU.vhd:136:5  */
  assign n5152_o = n5149_o ? 1'b1 : 1'b0;
  /* ./T65_ALU.vhd:148:14  */
  assign n5154_o = p_in[0];
  /* ./T65_ALU.vhd:148:26  */
  assign n5155_o = ~n5152_o;
  /* ./T65_ALU.vhd:148:23  */
  assign n5156_o = n5154_o | n5155_o;
  /* ./T65_ALU.vhd:149:31  */
  assign n5157_o = busa[3:0];
  /* ./T65_ALU.vhd:149:44  */
  assign n5158_o = {n5157_o, n5156_o};
  /* ./T65_ALU.vhd:149:11  */
  assign n5159_o = {2'b0, n5158_o};  //  uext
  /* ./T65_ALU.vhd:149:75  */
  assign n5160_o = busb[3:0];
  /* ./T65_ALU.vhd:149:88  */
  assign n5162_o = {n5160_o, 1'b1};
  /* ./T65_ALU.vhd:149:55  */
  assign n5163_o = {1'b0, n5162_o};  //  uext
  /* ./T65_ALU.vhd:149:53  */
  assign n5164_o = {1'b0, n5163_o};  //  uext
  /* ./T65_ALU.vhd:149:53  */
  assign n5165_o = n5159_o - n5164_o;
  /* ./T65_ALU.vhd:150:31  */
  assign n5166_o = busa[7:4];
  /* ./T65_ALU.vhd:150:44  */
  assign n5168_o = {n5166_o, 1'b0};
  /* ./T65_ALU.vhd:150:11  */
  assign n5169_o = {1'b0, n5168_o};  //  uext
  /* ./T65_ALU.vhd:150:77  */
  assign n5170_o = busb[7:4];
  /* ./T65_ALU.vhd:150:94  */
  assign n5171_o = n5165_o[5];
  /* ./T65_ALU.vhd:150:90  */
  assign n5172_o = {n5170_o, n5171_o};
  /* ./T65_ALU.vhd:150:57  */
  assign n5173_o = {1'b0, n5172_o};  //  uext
  /* ./T65_ALU.vhd:150:55  */
  assign n5174_o = n5169_o - n5173_o;
  /* ./T65_ALU.vhd:157:10  */
  assign n5175_o = n5165_o[4:1];
  /* ./T65_ALU.vhd:157:23  */
  assign n5177_o = n5175_o == 4'b0000;
  /* ./T65_ALU.vhd:157:33  */
  assign n5178_o = n5174_o[4:1];
  /* ./T65_ALU.vhd:157:46  */
  assign n5180_o = n5178_o == 4'b0000;
  /* ./T65_ALU.vhd:157:27  */
  assign n5181_o = n5180_o & n5177_o;
  /* ./T65_ALU.vhd:157:5  */
  assign n5184_o = n5181_o ? 1'b1 : 1'b0;
  /* ./T65_ALU.vhd:163:20  */
  assign n5185_o = n5174_o[5];
  /* ./T65_ALU.vhd:163:14  */
  assign n5186_o = ~n5185_o;
  /* ./T65_ALU.vhd:164:17  */
  assign n5187_o = n5174_o[4];
  /* ./T65_ALU.vhd:164:29  */
  assign n5188_o = busa[7];
  /* ./T65_ALU.vhd:164:21  */
  assign n5189_o = n5187_o ^ n5188_o;
  /* ./T65_ALU.vhd:164:43  */
  assign n5190_o = busa[7];
  /* ./T65_ALU.vhd:164:55  */
  assign n5191_o = busb[7];
  /* ./T65_ALU.vhd:164:47  */
  assign n5192_o = n5190_o ^ n5191_o;
  /* ./T65_ALU.vhd:164:34  */
  assign n5193_o = n5189_o & n5192_o;
  /* ./T65_ALU.vhd:165:16  */
  assign n5194_o = n5174_o[4];
  /* ./T65_ALU.vhd:167:33  */
  assign n5195_o = n5174_o[4:1];
  /* ./T65_ALU.vhd:167:50  */
  assign n5196_o = n5165_o[4:1];
  /* ./T65_ALU.vhd:167:46  */
  assign n5197_o = {n5195_o, n5196_o};
  /* ./T65_ALU.vhd:169:12  */
  assign n5198_o = p_in[3];
  /* ./T65_ALU.vhd:169:27  */
  assign n5199_o = bcd_en & n5198_o;
  /* ./T65_ALU.vhd:170:12  */
  assign n5200_o = n5165_o[5];
  /* ./T65_ALU.vhd:171:29  */
  assign n5201_o = n5165_o[5:1];
  /* ./T65_ALU.vhd:171:42  */
  assign n5203_o = n5201_o - 5'b00110;
  assign n5204_o = n5165_o[5:1];
  /* ./T65_ALU.vhd:170:7  */
  assign n5205_o = n5200_o ? n5203_o : n5204_o;
  /* ./T65_ALU.vhd:173:33  */
  assign n5206_o = busa[7:4];
  /* ./T65_ALU.vhd:173:46  */
  assign n5208_o = {n5206_o, 1'b0};
  /* ./T65_ALU.vhd:173:13  */
  assign n5209_o = {1'b0, n5208_o};  //  uext
  /* ./T65_ALU.vhd:173:79  */
  assign n5210_o = busb[7:4];
  assign n5211_o = n5165_o[0];
  assign n5212_o = n5165_o[6];
  assign n5213_o = {n5212_o, n5205_o, n5211_o};
  /* ./T65_ALU.vhd:173:96  */
  assign n5214_o = n5213_o[6];
  /* ./T65_ALU.vhd:173:92  */
  assign n5215_o = {n5210_o, n5214_o};
  /* ./T65_ALU.vhd:173:59  */
  assign n5216_o = {1'b0, n5215_o};  //  uext
  /* ./T65_ALU.vhd:173:57  */
  assign n5217_o = n5209_o - n5216_o;
  /* ./T65_ALU.vhd:174:12  */
  assign n5218_o = n5217_o[5];
  /* ./T65_ALU.vhd:175:29  */
  assign n5219_o = n5217_o[5:1];
  /* ./T65_ALU.vhd:175:42  */
  assign n5221_o = n5219_o - 5'b00110;
  assign n5222_o = n5217_o[5:1];
  /* ./T65_ALU.vhd:174:7  */
  assign n5223_o = n5218_o ? n5221_o : n5222_o;
  assign n5224_o = n5217_o[0];
  assign n5225_o = n5165_o[5:1];
  /* ./T65_ALU.vhd:169:5  */
  assign n5226_o = n5199_o ? n5205_o : n5225_o;
  assign n5227_o = n5165_o[6];
  assign n5228_o = n5165_o[0];
  assign n5229_o = {n5223_o, n5224_o};
  /* ./T65_ALU.vhd:169:5  */
  assign n5230_o = n5199_o ? n5229_o : n5174_o;
  /* ./T65_ALU.vhd:179:33  */
  assign n5231_o = n5230_o[4:1];
  assign n5232_o = {n5227_o, n5226_o, n5228_o};
  /* ./T65_ALU.vhd:179:50  */
  assign n5233_o = n5232_o[4:1];
  /* ./T65_ALU.vhd:179:46  */
  assign n5234_o = {n5231_o, n5233_o};
  /* ./T65_ALU.vhd:196:21  */
  assign n5241_o = busa | busb;
  /* ./T65_ALU.vhd:195:7  */
  assign n5243_o = op == 5'b00000;
  /* ./T65_ALU.vhd:198:21  */
  assign n5244_o = busa & busb;
  /* ./T65_ALU.vhd:197:7  */
  assign n5246_o = op == 5'b00001;
  /* ./T65_ALU.vhd:200:21  */
  assign n5247_o = busa ^ busb;
  /* ./T65_ALU.vhd:199:7  */
  assign n5249_o = op == 5'b00010;
  /* ./T65_ALU.vhd:201:7  */
  assign n5251_o = op == 5'b00011;
  /* ./T65_ALU.vhd:205:7  */
  assign n5253_o = op == 5'b00110;
  /* ./T65_ALU.vhd:207:7  */
  assign n5255_o = op == 5'b10001;
  /* ./T65_ALU.vhd:210:7  */
  assign n5257_o = op == 5'b00111;
  /* ./T65_ALU.vhd:215:20  */
  assign n5258_o = busa[6:0];
  /* ./T65_ALU.vhd:215:33  */
  assign n5260_o = {n5258_o, 1'b0};
  /* ./T65_ALU.vhd:216:30  */
  assign n5261_o = busa[7];
  /* ./T65_ALU.vhd:214:7  */
  assign n5263_o = op == 5'b01000;
  /* ./T65_ALU.vhd:218:20  */
  assign n5264_o = busa[6:0];
  /* ./T65_ALU.vhd:218:39  */
  assign n5265_o = p_in[0];
  /* ./T65_ALU.vhd:218:33  */
  assign n5266_o = {n5264_o, n5265_o};
  /* ./T65_ALU.vhd:219:30  */
  assign n5267_o = busa[7];
  /* ./T65_ALU.vhd:217:7  */
  assign n5269_o = op == 5'b01001;
  /* ./T65_ALU.vhd:221:26  */
  assign n5270_o = busa[7:1];
  /* ./T65_ALU.vhd:221:20  */
  assign n5272_o = {1'b0, n5270_o};
  /* ./T65_ALU.vhd:222:30  */
  assign n5273_o = busa[0];
  /* ./T65_ALU.vhd:220:7  */
  assign n5275_o = op == 5'b01010;
  /* ./T65_ALU.vhd:224:20  */
  assign n5276_o = p_in[0];
  /* ./T65_ALU.vhd:224:35  */
  assign n5277_o = busa[7:1];
  /* ./T65_ALU.vhd:224:29  */
  assign n5278_o = {n5276_o, n5277_o};
  /* ./T65_ALU.vhd:225:30  */
  assign n5279_o = busa[0];
  /* ./T65_ALU.vhd:223:7  */
  assign n5281_o = op == 5'b01011;
  /* ./T65_ALU.vhd:227:20  */
  assign n5282_o = p_in[0];
  /* ./T65_ALU.vhd:227:36  */
  assign n5283_o = busa[7:1];
  /* ./T65_ALU.vhd:227:57  */
  assign n5284_o = busb[7:1];
  /* ./T65_ALU.vhd:227:49  */
  assign n5285_o = n5283_o & n5284_o;
  /* ./T65_ALU.vhd:227:29  */
  assign n5286_o = {n5282_o, n5285_o};
  /* ./T65_ALU.vhd:228:29  */
  assign n5287_o = n5286_o[5];
  /* ./T65_ALU.vhd:228:40  */
  assign n5288_o = n5286_o[6];
  /* ./T65_ALU.vhd:228:33  */
  assign n5289_o = n5287_o ^ n5288_o;
  /* ./T65_ALU.vhd:230:16  */
  assign n5290_o = p_in[3];
  /* ./T65_ALU.vhd:230:29  */
  assign n5291_o = bcd_en & n5290_o;
  /* ./T65_ALU.vhd:231:19  */
  assign n5292_o = busa[3:0];
  /* ./T65_ALU.vhd:231:40  */
  assign n5293_o = busb[3:0];
  /* ./T65_ALU.vhd:231:32  */
  assign n5294_o = n5292_o & n5293_o;
  /* ./T65_ALU.vhd:231:54  */
  assign n5296_o = $unsigned(n5294_o) > $unsigned(4'b0100);
  /* ./T65_ALU.vhd:232:62  */
  assign n5297_o = n5286_o[3:0];
  /* ./T65_ALU.vhd:232:76  */
  assign n5299_o = n5297_o + 4'b0110;
  assign n5300_o = n5286_o[3:0];
  /* ./T65_ALU.vhd:231:11  */
  assign n5301_o = n5296_o ? n5299_o : n5300_o;
  /* ./T65_ALU.vhd:234:19  */
  assign n5302_o = busa[7:4];
  /* ./T65_ALU.vhd:234:40  */
  assign n5303_o = busb[7:4];
  /* ./T65_ALU.vhd:234:32  */
  assign n5304_o = n5302_o & n5303_o;
  /* ./T65_ALU.vhd:234:54  */
  assign n5306_o = $unsigned(n5304_o) > $unsigned(4'b0100);
  /* ./T65_ALU.vhd:235:62  */
  assign n5307_o = n5286_o[7:4];
  /* ./T65_ALU.vhd:235:76  */
  assign n5309_o = n5307_o + 4'b0110;
  /* ./T65_ALU.vhd:234:11  */
  assign n5312_o = n5306_o ? 1'b1 : 1'b0;
  assign n5313_o = n5286_o[7:4];
  /* ./T65_ALU.vhd:234:11  */
  assign n5314_o = n5306_o ? n5309_o : n5313_o;
  /* ./T65_ALU.vhd:241:31  */
  assign n5315_o = n5286_o[6];
  /* ./T65_ALU.vhd:230:9  */
  assign n5316_o = n5291_o ? n5312_o : n5315_o;
  assign n5317_o = {n5314_o, n5301_o};
  /* ./T65_ALU.vhd:230:9  */
  assign n5318_o = n5291_o ? n5317_o : n5286_o;
  /* ./T65_ALU.vhd:226:7  */
  assign n5320_o = op == 5'b01111;
  /* ./T65_ALU.vhd:244:30  */
  assign n5321_o = busb[6];
  /* ./T65_ALU.vhd:243:7  */
  assign n5323_o = op == 5'b01100;
  /* ./T65_ALU.vhd:246:48  */
  assign n5325_o = busa - 8'b00000001;
  /* ./T65_ALU.vhd:245:7  */
  assign n5327_o = op == 5'b01101;
  /* ./T65_ALU.vhd:248:48  */
  assign n5329_o = busa + 8'b00000001;
  /* ./T65_ALU.vhd:247:7  */
  assign n5331_o = op == 5'b01110;
  assign n5332_o = {n5331_o, n5327_o, n5323_o, n5320_o, n5281_o, n5275_o, n5269_o, n5263_o, n5257_o, n5255_o, n5253_o, n5251_o, n5249_o, n5246_o, n5243_o};
  assign n5333_o = p_in[0];
  /* ./T65_ALU.vhd:194:5  */
  always @*
    case (n5332_o)
      15'b100000000000000: n5334_o = n5333_o;
      15'b010000000000000: n5334_o = n5333_o;
      15'b001000000000000: n5334_o = n5333_o;
      15'b000100000000000: n5334_o = n5316_o;
      15'b000010000000000: n5334_o = n5279_o;
      15'b000001000000000: n5334_o = n5273_o;
      15'b000000100000000: n5334_o = n5267_o;
      15'b000000010000000: n5334_o = n5261_o;
      15'b000000001000000: n5334_o = sbc_c;
      15'b000000000100000: n5334_o = sbc_c;
      15'b000000000010000: n5334_o = sbc_c;
      15'b000000000001000: n5334_o = adc_c;
      15'b000000000000100: n5334_o = n5333_o;
      15'b000000000000010: n5334_o = n5333_o;
      15'b000000000000001: n5334_o = n5333_o;
      default: n5334_o = n5333_o;
    endcase
  assign n5335_o = p_in[6];
  /* ./T65_ALU.vhd:194:5  */
  always @*
    case (n5332_o)
      15'b100000000000000: n5336_o = n5335_o;
      15'b010000000000000: n5336_o = n5335_o;
      15'b001000000000000: n5336_o = n5321_o;
      15'b000100000000000: n5336_o = n5289_o;
      15'b000010000000000: n5336_o = n5335_o;
      15'b000001000000000: n5336_o = n5335_o;
      15'b000000100000000: n5336_o = n5335_o;
      15'b000000010000000: n5336_o = n5335_o;
      15'b000000001000000: n5336_o = sbc_v;
      15'b000000000100000: n5336_o = n5335_o;
      15'b000000000010000: n5336_o = n5335_o;
      15'b000000000001000: n5336_o = adc_v;
      15'b000000000000100: n5336_o = n5335_o;
      15'b000000000000010: n5336_o = n5335_o;
      15'b000000000000001: n5336_o = n5335_o;
      default: n5336_o = n5335_o;
    endcase
  assign n5338_o = p_in[7];
  /* ./T65_ALU.vhd:194:5  */
  always @*
    case (n5332_o)
      15'b100000000000000: n5340_o = n5329_o;
      15'b010000000000000: n5340_o = n5325_o;
      15'b001000000000000: n5340_o = busa;
      15'b000100000000000: n5340_o = n5286_o;
      15'b000010000000000: n5340_o = n5278_o;
      15'b000001000000000: n5340_o = n5272_o;
      15'b000000100000000: n5340_o = n5266_o;
      15'b000000010000000: n5340_o = n5260_o;
      15'b000000001000000: n5340_o = sbc_q;
      15'b000000000100000: n5340_o = sbx_q;
      15'b000000000010000: n5340_o = busa;
      15'b000000000001000: n5340_o = adc_q;
      15'b000000000000100: n5340_o = n5247_o;
      15'b000000000000010: n5340_o = n5244_o;
      15'b000000000000001: n5340_o = n5241_o;
      default: n5340_o = busa;
    endcase
  /* ./T65_ALU.vhd:194:5  */
  always @*
    case (n5332_o)
      15'b100000000000000: n5341_o = busa;
      15'b010000000000000: n5341_o = busa;
      15'b001000000000000: n5341_o = busa;
      15'b000100000000000: n5341_o = n5318_o;
      15'b000010000000000: n5341_o = busa;
      15'b000001000000000: n5341_o = busa;
      15'b000000100000000: n5341_o = busa;
      15'b000000010000000: n5341_o = busa;
      15'b000000001000000: n5341_o = busa;
      15'b000000000100000: n5341_o = busa;
      15'b000000000010000: n5341_o = busa;
      15'b000000000001000: n5341_o = busa;
      15'b000000000000100: n5341_o = busa;
      15'b000000000000010: n5341_o = busa;
      15'b000000000000001: n5341_o = busa;
      default: n5341_o = busa;
    endcase
  /* ./T65_ALU.vhd:255:7  */
  assign n5343_o = op == 5'b00011;
  /* ./T65_ALU.vhd:258:7  */
  assign n5345_o = op == 5'b00110;
  /* ./T65_ALU.vhd:258:22  */
  assign n5347_o = op == 5'b00111;
  /* ./T65_ALU.vhd:258:22  */
  assign n5348_o = n5345_o | n5347_o;
  /* ./T65_ALU.vhd:258:33  */
  assign n5350_o = op == 5'b10001;
  /* ./T65_ALU.vhd:258:33  */
  assign n5351_o = n5348_o | n5350_o;
  /* ./T65_ALU.vhd:261:7  */
  assign n5353_o = op == 5'b00100;
  /* ./T65_ALU.vhd:263:30  */
  assign n5354_o = busb[7];
  /* ./T65_ALU.vhd:264:18  */
  assign n5355_o = busa & busb;
  /* ./T65_ALU.vhd:264:28  */
  assign n5357_o = n5355_o == 8'b00000000;
  /* ./T65_ALU.vhd:264:9  */
  assign n5360_o = n5357_o ? 1'b1 : 1'b0;
  /* ./T65_ALU.vhd:262:7  */
  assign n5362_o = op == 5'b01100;
  /* ./T65_ALU.vhd:270:29  */
  assign n5363_o = n5340_o[7];
  /* ./T65_ALU.vhd:271:29  */
  assign n5364_o = n5340_o[7];
  /* ./T65_ALU.vhd:272:16  */
  assign n5366_o = n5340_o == 8'b00000000;
  /* ./T65_ALU.vhd:272:9  */
  assign n5369_o = n5366_o ? 1'b1 : 1'b0;
  /* ./T65_ALU.vhd:269:7  */
  assign n5371_o = op == 5'b10000;
  /* ./T65_ALU.vhd:278:29  */
  assign n5372_o = n5340_o[7];
  /* ./T65_ALU.vhd:279:16  */
  assign n5374_o = n5340_o == 8'b00000000;
  /* ./T65_ALU.vhd:279:9  */
  assign n5377_o = n5374_o ? 1'b1 : 1'b0;
  assign n5378_o = {n5371_o, n5362_o, n5353_o, n5351_o, n5343_o};
  /* ./T65_ALU.vhd:254:5  */
  always @*
    case (n5378_o)
      5'b10000: n5379_o = n5364_o;
      5'b01000: n5379_o = n5334_o;
      5'b00100: n5379_o = n5334_o;
      5'b00010: n5379_o = n5334_o;
      5'b00001: n5379_o = n5334_o;
      default: n5379_o = n5334_o;
    endcase
  assign n5380_o = p_in[1];
  /* ./T65_ALU.vhd:254:5  */
  always @*
    case (n5378_o)
      5'b10000: n5381_o = n5369_o;
      5'b01000: n5381_o = n5360_o;
      5'b00100: n5381_o = n5380_o;
      5'b00010: n5381_o = sbc_z;
      5'b00001: n5381_o = adc_z;
      default: n5381_o = n5377_o;
    endcase
  /* ./T65_ALU.vhd:254:5  */
  always @*
    case (n5378_o)
      5'b10000: n5382_o = n5363_o;
      5'b01000: n5382_o = n5354_o;
      5'b00100: n5382_o = n5338_o;
      5'b00010: n5382_o = sbc_n;
      5'b00001: n5382_o = adc_n;
      default: n5382_o = n5372_o;
    endcase
  assign n5383_o = p_in[5:2];
  /* ./T65_ALU.vhd:286:10  */
  assign n5385_o = op == 5'b01111;
  /* ./T65_ALU.vhd:286:5  */
  assign n5386_o = n5385_o ? n5341_o : n5340_o;
  assign n5388_o = {n5382_o, n5336_o, n5383_o, n5381_o, n5379_o};
endmodule

module t65_mcode
  (input  [1:0] mode,
   input  [7:0] ir,
   input  [2:0] mcycle,
   input  [7:0] p,
   input  rdy_mod,
   output [2:0] lcycle,
   output [4:0] alu_op,
   output [3:0] set_busa_to,
   output [1:0] set_addr_to,
   output [3:0] write_data,
   output [1:0] jump,
   output [1:0] baadd,
   output [1:0] baquirk,
   output breakatna,
   output adadd,
   output addy,
   output pcadd,
   output inc_s,
   output dec_s,
   output lda,
   output ldp,
   output ldx,
   output ldy,
   output lds,
   output lddi,
   output ldalu,
   output ldad,
   output ldbal,
   output ldbah,
   output savep,
   output write);
  wire branch;
  wire alumore;
  wire [2:0] n2839_o;
  wire n2840_o;
  wire n2841_o;
  wire n2843_o;
  wire n2844_o;
  wire n2846_o;
  wire n2847_o;
  wire n2848_o;
  wire n2850_o;
  wire n2851_o;
  wire n2853_o;
  wire n2854_o;
  wire n2855_o;
  wire n2857_o;
  wire n2858_o;
  wire n2860_o;
  wire n2861_o;
  wire n2862_o;
  wire n2864_o;
  wire n2865_o;
  wire [6:0] n2866_o;
  reg n2867_o;
  wire [2:0] n2870_o;
  wire [1:0] n2871_o;
  wire [2:0] n2872_o;
  wire n2874_o;
  wire n2875_o;
  wire [3:0] n2878_o;
  wire [3:0] n2880_o;
  wire n2882_o;
  wire [2:0] n2883_o;
  wire n2885_o;
  wire n2886_o;
  wire [3:0] n2889_o;
  wire [3:0] n2891_o;
  wire n2893_o;
  wire [2:0] n2894_o;
  wire n2896_o;
  wire [3:0] n2899_o;
  wire n2902_o;
  wire [2:0] n2903_o;
  wire n2905_o;
  wire [2:0] n2906_o;
  wire n2908_o;
  wire n2909_o;
  wire [2:0] n2910_o;
  wire n2912_o;
  wire n2913_o;
  wire n2914_o;
  wire [3:0] n2917_o;
  wire [3:0] n2919_o;
  wire n2921_o;
  wire [2:0] n2922_o;
  reg [3:0] n2926_o;
  reg [3:0] n2928_o;
  reg n2930_o;
  wire n2932_o;
  wire [1:0] n2933_o;
  wire n2934_o;
  wire n2936_o;
  wire n2937_o;
  wire n2939_o;
  wire n2940_o;
  wire n2943_o;
  wire n2945_o;
  wire n2947_o;
  wire n2949_o;
  wire [2:0] n2950_o;
  wire n2952_o;
  wire [3:0] n2955_o;
  wire n2958_o;
  wire [2:0] n2959_o;
  reg [3:0] n2961_o;
  reg n2966_o;
  reg n2970_o;
  reg n2972_o;
  reg n2974_o;
  wire n2976_o;
  wire [1:0] n2977_o;
  wire n2978_o;
  wire n2979_o;
  wire n2982_o;
  wire n2984_o;
  reg [3:0] n2987_o;
  reg n2989_o;
  wire n2991_o;
  wire [1:0] n2992_o;
  wire n2993_o;
  wire n2994_o;
  wire n2997_o;
  wire n2999_o;
  reg [3:0] n3002_o;
  reg n3004_o;
  wire n3006_o;
  wire [3:0] n3007_o;
  reg [3:0] n3009_o;
  reg [3:0] n3012_o;
  reg n3015_o;
  reg n3018_o;
  reg n3021_o;
  reg n3024_o;
  wire [1:0] n3026_o;
  wire n3028_o;
  wire n3029_o;
  wire n3030_o;
  wire n3032_o;
  wire n3033_o;
  wire n3034_o;
  wire n3035_o;
  wire n3036_o;
  wire n3038_o;
  wire [3:0] n3041_o;
  wire [3:0] n3042_o;
  wire [4:0] n3043_o;
  wire n3045_o;
  wire n3047_o;
  wire n3049_o;
  wire n3051_o;
  wire n3053_o;
  wire n3055_o;
  wire [5:0] n3056_o;
  reg [1:0] n3063_o;
  reg [3:0] n3067_o;
  reg [1:0] n3070_o;
  reg n3075_o;
  reg n3078_o;
  reg n3083_o;
  wire n3085_o;
  wire n3087_o;
  wire n3089_o;
  wire n3091_o;
  wire n3093_o;
  wire n3095_o;
  wire [4:0] n3096_o;
  reg [1:0] n3101_o;
  reg [3:0] n3104_o;
  reg [1:0] n3108_o;
  reg n3112_o;
  reg n3115_o;
  reg n3119_o;
  wire n3121_o;
  wire n3123_o;
  wire n3125_o;
  wire n3127_o;
  wire n3129_o;
  wire n3131_o;
  wire [4:0] n3132_o;
  reg [3:0] n3134_o;
  reg [1:0] n3140_o;
  reg [1:0] n3143_o;
  reg n3148_o;
  reg n3151_o;
  reg n3154_o;
  wire n3156_o;
  wire n3158_o;
  wire n3160_o;
  wire n3162_o;
  wire n3164_o;
  wire n3166_o;
  wire [4:0] n3167_o;
  reg [1:0] n3172_o;
  reg [1:0] n3176_o;
  reg n3180_o;
  reg n3183_o;
  wire n3185_o;
  wire n3187_o;
  wire n3188_o;
  wire n3189_o;
  wire [2:0] n3192_o;
  wire n3195_o;
  wire n3196_o;
  wire n3197_o;
  wire n3198_o;
  wire [3:0] n3199_o;
  wire n3201_o;
  wire n3203_o;
  wire n3205_o;
  wire [3:0] n3207_o;
  wire n3210_o;
  wire n3212_o;
  wire n3214_o;
  wire [3:0] n3216_o;
  wire n3219_o;
  wire n3221_o;
  wire [3:0] n3222_o;
  reg [3:0] n3225_o;
  reg n3227_o;
  wire [1:0] n3231_o;
  wire [3:0] n3232_o;
  wire n3234_o;
  wire n3236_o;
  wire n3238_o;
  wire [1:0] n3239_o;
  reg [1:0] n3241_o;
  reg [3:0] n3242_o;
  reg n3245_o;
  reg n3247_o;
  wire n3249_o;
  wire n3251_o;
  wire n3252_o;
  wire n3254_o;
  wire n3255_o;
  wire n3257_o;
  wire n3258_o;
  wire n3260_o;
  wire n3261_o;
  wire n3262_o;
  wire [2:0] n3265_o;
  wire [3:0] n3267_o;
  wire n3269_o;
  wire n3271_o;
  wire n3273_o;
  wire n3275_o;
  wire n3277_o;
  wire n3279_o;
  wire n3281_o;
  wire n3283_o;
  wire [3:0] n3284_o;
  reg n3286_o;
  reg n3289_o;
  reg n3290_o;
  reg n3291_o;
  wire n3293_o;
  wire n3294_o;
  wire n3295_o;
  wire n3296_o;
  wire n3299_o;
  wire n3301_o;
  wire n3303_o;
  wire n3304_o;
  wire n3305_o;
  wire n3306_o;
  wire [1:0] n3309_o;
  wire n3311_o;
  wire n3313_o;
  wire n3315_o;
  wire n3317_o;
  wire [3:0] n3318_o;
  reg [3:0] n3320_o;
  reg [1:0] n3323_o;
  reg n3326_o;
  reg n3328_o;
  reg n3330_o;
  wire n3332_o;
  wire n3334_o;
  wire n3335_o;
  wire n3337_o;
  wire n3338_o;
  wire n3340_o;
  wire n3341_o;
  wire n3343_o;
  wire n3345_o;
  wire [1:0] n3346_o;
  reg [1:0] n3349_o;
  wire n3351_o;
  wire n3353_o;
  wire n3354_o;
  wire n3356_o;
  wire n3357_o;
  wire n3359_o;
  wire n3361_o;
  wire [1:0] n3362_o;
  reg [3:0] n3364_o;
  wire n3366_o;
  wire n3368_o;
  wire n3370_o;
  wire [1:0] n3371_o;
  reg [3:0] n3373_o;
  wire n3375_o;
  wire n3377_o;
  wire n3379_o;
  wire n3381_o;
  wire n3383_o;
  wire [1:0] n3384_o;
  reg [3:0] n3386_o;
  wire n3388_o;
  wire n3390_o;
  wire n3391_o;
  wire n3398_o;
  wire n3400_o;
  wire n3401_o;
  wire n3403_o;
  wire n3404_o;
  wire n3406_o;
  wire n3407_o;
  wire n3414_o;
  wire n3416_o;
  wire n3417_o;
  wire n3419_o;
  wire n3421_o;
  wire [1:0] n3422_o;
  reg [3:0] n3424_o;
  wire n3426_o;
  wire n3428_o;
  wire n3429_o;
  wire n3431_o;
  wire n3433_o;
  wire n3435_o;
  wire [1:0] n3436_o;
  reg [3:0] n3438_o;
  wire n3440_o;
  wire n3442_o;
  wire n3444_o;
  wire [1:0] n3445_o;
  reg [1:0] n3448_o;
  wire n3450_o;
  wire [15:0] n3453_o;
  reg [2:0] n3459_o;
  reg [3:0] n3461_o;
  reg [1:0] n3463_o;
  reg [3:0] n3464_o;
  reg [1:0] n3466_o;
  reg n3468_o;
  reg n3470_o;
  reg n3473_o;
  reg n3475_o;
  reg n3478_o;
  reg n3480_o;
  reg n3482_o;
  reg n3484_o;
  reg n3486_o;
  reg n3488_o;
  wire n3490_o;
  wire n3492_o;
  wire n3493_o;
  wire n3495_o;
  wire n3496_o;
  wire n3498_o;
  wire n3499_o;
  wire n3501_o;
  wire n3502_o;
  wire [1:0] n3503_o;
  wire n3505_o;
  wire n3507_o;
  wire n3508_o;
  wire n3509_o;
  wire [2:0] n3512_o;
  wire [2:0] n3514_o;
  wire n3517_o;
  wire n3519_o;
  wire n3521_o;
  wire n3523_o;
  wire [2:0] n3524_o;
  wire n3526_o;
  wire n3529_o;
  wire n3531_o;
  wire n3533_o;
  wire n3534_o;
  wire n3535_o;
  wire [1:0] n3536_o;
  wire n3538_o;
  wire n3539_o;
  wire [1:0] n3542_o;
  wire n3545_o;
  wire n3548_o;
  wire n3550_o;
  wire n3552_o;
  wire n3554_o;
  wire [6:0] n3555_o;
  reg [3:0] n3557_o;
  reg [1:0] n3564_o;
  reg [1:0] n3567_o;
  reg [1:0] n3570_o;
  reg n3573_o;
  reg n3575_o;
  reg n3578_o;
  reg n3581_o;
  reg n3584_o;
  reg n3587_o;
  reg n3590_o;
  reg n3593_o;
  reg n3596_o;
  wire n3598_o;
  wire n3600_o;
  wire n3601_o;
  wire [2:0] n3602_o;
  wire n3604_o;
  wire n3606_o;
  wire n3608_o;
  reg [1:0] n3611_o;
  wire n3613_o;
  wire n3615_o;
  wire [2:0] n3616_o;
  wire n3618_o;
  wire n3620_o;
  wire n3621_o;
  wire n3623_o;
  wire n3624_o;
  wire n3626_o;
  wire n3627_o;
  wire n3629_o;
  wire n3631_o;
  wire n3633_o;
  wire [3:0] n3634_o;
  reg [3:0] n3639_o;
  reg n3644_o;
  reg n3646_o;
  wire n3648_o;
  reg [1:0] n3651_o;
  wire [3:0] n3652_o;
  wire [1:0] n3654_o;
  wire n3655_o;
  wire n3656_o;
  wire n3658_o;
  wire n3660_o;
  wire n3662_o;
  wire [3:0] n3663_o;
  wire n3665_o;
  wire [3:0] n3666_o;
  wire n3668_o;
  wire n3669_o;
  wire [3:0] n3670_o;
  wire n3672_o;
  wire n3673_o;
  wire [1:0] n3676_o;
  wire [1:0] n3678_o;
  wire n3680_o;
  wire n3682_o;
  wire [1:0] n3683_o;
  reg [1:0] n3685_o;
  reg n3686_o;
  wire n3688_o;
  wire n3690_o;
  wire n3691_o;
  wire [2:0] n3692_o;
  wire n3694_o;
  wire n3697_o;
  wire n3699_o;
  wire [2:0] n3700_o;
  wire n3702_o;
  wire n3705_o;
  wire n3707_o;
  wire n3709_o;
  wire [2:0] n3710_o;
  reg [1:0] n3713_o;
  reg [1:0] n3716_o;
  reg n3719_o;
  reg n3721_o;
  reg n3723_o;
  wire n3725_o;
  wire [1:0] n3726_o;
  wire n3728_o;
  wire n3729_o;
  wire n3730_o;
  wire n3732_o;
  wire n3733_o;
  wire n3734_o;
  wire n3735_o;
  wire n3736_o;
  wire n3738_o;
  wire n3739_o;
  wire n3740_o;
  wire n3742_o;
  wire n3744_o;
  wire n3746_o;
  wire n3749_o;
  wire n3751_o;
  wire n3753_o;
  wire n3755_o;
  wire n3756_o;
  wire n3757_o;
  wire [3:0] n3759_o;
  wire n3762_o;
  wire n3765_o;
  wire n3767_o;
  wire [3:0] n3768_o;
  reg [3:0] n3769_o;
  reg [1:0] n3774_o;
  reg [1:0] n3777_o;
  reg n3780_o;
  reg n3783_o;
  reg n3786_o;
  reg n3789_o;
  reg n3792_o;
  reg n3794_o;
  wire [1:0] n3795_o;
  wire n3797_o;
  wire n3799_o;
  wire n3801_o;
  wire [2:0] n3802_o;
  wire n3804_o;
  wire n3807_o;
  wire n3809_o;
  wire n3811_o;
  wire [2:0] n3812_o;
  reg [1:0] n3815_o;
  reg [1:0] n3818_o;
  reg n3821_o;
  reg n3823_o;
  wire [2:0] n3826_o;
  wire [3:0] n3827_o;
  wire [1:0] n3828_o;
  wire [1:0] n3829_o;
  wire n3830_o;
  wire n3832_o;
  wire n3834_o;
  wire n3835_o;
  wire n3837_o;
  wire n3838_o;
  wire n3840_o;
  wire n3842_o;
  wire n3844_o;
  wire n3845_o;
  wire n3847_o;
  wire n3848_o;
  wire [1:0] n3849_o;
  wire n3851_o;
  wire [4:0] n3852_o;
  wire n3854_o;
  wire n3855_o;
  wire n3856_o;
  wire n3857_o;
  wire n3859_o;
  wire n3861_o;
  wire [1:0] n3862_o;
  reg [1:0] n3866_o;
  reg n3869_o;
  wire n3871_o;
  wire n3873_o;
  wire [1:0] n3876_o;
  wire n3878_o;
  wire [1:0] n3881_o;
  wire n3883_o;
  wire n3885_o;
  wire [1:0] n3888_o;
  wire [1:0] n3891_o;
  wire [1:0] n3894_o;
  wire n3896_o;
  wire n3898_o;
  wire [3:0] n3899_o;
  reg [1:0] n3901_o;
  reg [1:0] n3905_o;
  reg [1:0] n3907_o;
  reg n3911_o;
  reg n3914_o;
  reg n3917_o;
  wire [2:0] n3920_o;
  wire [1:0] n3922_o;
  wire [1:0] n3923_o;
  wire [1:0] n3925_o;
  wire n3926_o;
  wire n3928_o;
  wire n3930_o;
  wire [2:0] n3931_o;
  wire n3933_o;
  wire n3936_o;
  wire n3938_o;
  wire n3940_o;
  wire [2:0] n3941_o;
  wire n3943_o;
  wire n3946_o;
  wire n3948_o;
  wire n3950_o;
  wire [3:0] n3951_o;
  reg [1:0] n3954_o;
  reg [1:0] n3958_o;
  reg n3961_o;
  reg n3964_o;
  reg n3966_o;
  reg n3968_o;
  wire [2:0] n3970_o;
  wire [1:0] n3971_o;
  wire [1:0] n3972_o;
  wire [1:0] n3974_o;
  wire n3976_o;
  wire n3977_o;
  wire n3978_o;
  wire n3980_o;
  wire n3982_o;
  wire n3984_o;
  wire [1:0] n3985_o;
  wire n3987_o;
  wire n3988_o;
  wire n3989_o;
  wire n3991_o;
  wire n3992_o;
  wire n3993_o;
  wire n3994_o;
  wire n3995_o;
  wire n3997_o;
  wire n3998_o;
  wire n3999_o;
  wire n4001_o;
  wire n4003_o;
  wire n4005_o;
  wire n4007_o;
  wire n4010_o;
  wire n4012_o;
  wire n4014_o;
  wire n4016_o;
  wire n4017_o;
  wire n4018_o;
  wire [3:0] n4020_o;
  wire n4023_o;
  wire n4025_o;
  wire [4:0] n4026_o;
  reg [3:0] n4027_o;
  reg [1:0] n4032_o;
  reg [1:0] n4036_o;
  reg n4039_o;
  reg n4042_o;
  reg n4045_o;
  reg n4048_o;
  reg n4051_o;
  reg n4054_o;
  reg n4056_o;
  wire [1:0] n4057_o;
  wire n4059_o;
  wire n4061_o;
  wire n4063_o;
  wire n4065_o;
  wire [2:0] n4066_o;
  wire n4068_o;
  wire n4071_o;
  wire n4073_o;
  wire n4075_o;
  wire [3:0] n4076_o;
  reg [1:0] n4079_o;
  reg [1:0] n4083_o;
  reg n4086_o;
  reg n4089_o;
  reg n4091_o;
  wire [2:0] n4094_o;
  wire [3:0] n4095_o;
  wire [1:0] n4096_o;
  wire [1:0] n4097_o;
  wire n4098_o;
  wire n4100_o;
  wire n4102_o;
  wire n4103_o;
  wire n4104_o;
  wire n4106_o;
  wire n4107_o;
  wire n4109_o;
  wire n4111_o;
  wire n4113_o;
  wire n4114_o;
  wire n4116_o;
  wire n4117_o;
  wire [2:0] n4120_o;
  wire n4122_o;
  wire n4124_o;
  wire n4126_o;
  wire [2:0] n4127_o;
  reg [1:0] n4131_o;
  reg n4134_o;
  reg n4137_o;
  wire n4139_o;
  wire [1:0] n4140_o;
  wire n4142_o;
  wire n4144_o;
  wire n4145_o;
  wire n4146_o;
  wire [2:0] n4149_o;
  wire [2:0] n4151_o;
  wire n4154_o;
  wire n4156_o;
  wire n4158_o;
  wire n4160_o;
  wire [2:0] n4161_o;
  wire n4163_o;
  wire [3:0] n4164_o;
  wire n4166_o;
  wire [1:0] n4169_o;
  wire n4170_o;
  wire n4171_o;
  wire n4173_o;
  wire n4174_o;
  wire n4177_o;
  wire [1:0] n4179_o;
  wire n4181_o;
  wire n4184_o;
  wire n4186_o;
  wire n4188_o;
  wire n4189_o;
  wire n4190_o;
  wire [1:0] n4191_o;
  wire n4193_o;
  wire n4194_o;
  wire [1:0] n4197_o;
  wire n4200_o;
  wire n4203_o;
  wire n4205_o;
  wire n4207_o;
  wire n4209_o;
  wire [6:0] n4210_o;
  reg [3:0] n4213_o;
  reg [1:0] n4220_o;
  reg [1:0] n4223_o;
  reg [1:0] n4228_o;
  reg [1:0] n4230_o;
  reg n4232_o;
  reg n4234_o;
  reg n4237_o;
  reg n4240_o;
  reg n4243_o;
  reg n4246_o;
  reg n4249_o;
  reg n4252_o;
  reg n4255_o;
  wire n4257_o;
  wire n4259_o;
  wire n4260_o;
  wire [1:0] n4261_o;
  wire n4263_o;
  wire n4264_o;
  wire n4265_o;
  wire n4267_o;
  wire n4268_o;
  wire n4269_o;
  wire n4270_o;
  wire n4271_o;
  wire n4273_o;
  wire n4274_o;
  wire n4275_o;
  wire n4277_o;
  wire n4279_o;
  wire n4281_o;
  wire n4283_o;
  wire n4286_o;
  wire n4288_o;
  wire n4290_o;
  wire n4291_o;
  wire n4292_o;
  wire n4295_o;
  wire n4297_o;
  wire n4299_o;
  wire n4300_o;
  wire n4301_o;
  wire [3:0] n4303_o;
  wire n4306_o;
  wire n4308_o;
  wire [4:0] n4309_o;
  reg [3:0] n4310_o;
  reg [1:0] n4316_o;
  reg [1:0] n4319_o;
  reg n4322_o;
  reg n4325_o;
  reg n4328_o;
  reg n4331_o;
  reg n4334_o;
  reg n4337_o;
  reg n4339_o;
  wire [1:0] n4340_o;
  wire n4342_o;
  wire n4343_o;
  wire n4344_o;
  wire n4346_o;
  wire n4348_o;
  wire n4350_o;
  wire [2:0] n4351_o;
  wire n4353_o;
  wire n4356_o;
  wire [2:0] n4357_o;
  wire n4359_o;
  wire n4362_o;
  wire n4364_o;
  wire n4366_o;
  wire [3:0] n4367_o;
  reg [1:0] n4371_o;
  reg [1:0] n4374_o;
  reg n4377_o;
  reg n4379_o;
  reg n4382_o;
  reg n4384_o;
  wire [2:0] n4387_o;
  wire [3:0] n4388_o;
  wire [1:0] n4389_o;
  wire [1:0] n4390_o;
  wire n4391_o;
  wire n4393_o;
  wire n4394_o;
  wire n4396_o;
  wire n4398_o;
  wire n4399_o;
  wire n4401_o;
  wire n4402_o;
  wire n4404_o;
  wire n4406_o;
  wire n4408_o;
  wire n4409_o;
  wire n4411_o;
  wire n4412_o;
  wire n4414_o;
  wire n4415_o;
  wire [1:0] n4416_o;
  wire n4418_o;
  wire n4420_o;
  wire n4421_o;
  wire n4422_o;
  wire [2:0] n4425_o;
  wire [2:0] n4427_o;
  wire n4430_o;
  wire n4432_o;
  wire n4434_o;
  wire [2:0] n4435_o;
  wire n4437_o;
  wire [3:0] n4438_o;
  wire n4440_o;
  wire [1:0] n4443_o;
  wire n4444_o;
  wire n4445_o;
  wire n4447_o;
  wire n4448_o;
  wire n4451_o;
  wire [1:0] n4453_o;
  wire n4455_o;
  wire n4458_o;
  wire n4460_o;
  wire n4462_o;
  wire n4463_o;
  wire n4464_o;
  wire [1:0] n4465_o;
  wire n4467_o;
  wire n4468_o;
  wire [1:0] n4471_o;
  wire n4474_o;
  wire n4477_o;
  wire n4479_o;
  wire n4481_o;
  wire n4483_o;
  wire [5:0] n4484_o;
  reg [3:0] n4487_o;
  reg [1:0] n4492_o;
  reg [1:0] n4496_o;
  reg [1:0] n4500_o;
  reg [1:0] n4502_o;
  reg n4504_o;
  reg n4506_o;
  reg n4509_o;
  reg n4512_o;
  reg n4515_o;
  reg n4518_o;
  reg n4521_o;
  reg n4524_o;
  wire n4526_o;
  wire n4528_o;
  wire n4529_o;
  wire [1:0] n4530_o;
  wire n4532_o;
  wire n4533_o;
  wire n4534_o;
  wire n4536_o;
  wire n4537_o;
  wire n4538_o;
  wire n4539_o;
  wire n4540_o;
  wire n4542_o;
  wire n4543_o;
  wire n4544_o;
  wire n4546_o;
  wire n4548_o;
  wire n4550_o;
  wire n4552_o;
  wire n4554_o;
  wire n4557_o;
  wire n4559_o;
  wire n4561_o;
  wire n4563_o;
  wire n4564_o;
  wire n4565_o;
  wire [3:0] n4567_o;
  wire n4570_o;
  wire n4572_o;
  wire [5:0] n4573_o;
  reg [3:0] n4575_o;
  reg [1:0] n4581_o;
  reg [1:0] n4585_o;
  reg [1:0] n4589_o;
  reg n4592_o;
  reg n4595_o;
  reg n4598_o;
  reg n4601_o;
  reg n4604_o;
  reg n4607_o;
  reg n4609_o;
  wire [1:0] n4610_o;
  wire n4612_o;
  wire n4614_o;
  wire n4615_o;
  wire n4616_o;
  wire n4617_o;
  wire [1:0] n4618_o;
  wire n4620_o;
  wire n4621_o;
  wire n4623_o;
  wire n4624_o;
  wire n4626_o;
  wire n4628_o;
  wire [1:0] n4629_o;
  wire n4631_o;
  wire [3:0] n4632_o;
  wire n4634_o;
  wire n4635_o;
  wire [3:0] n4638_o;
  wire n4640_o;
  wire [2:0] n4641_o;
  wire n4643_o;
  wire [1:0] n4644_o;
  wire n4646_o;
  wire n4648_o;
  wire n4649_o;
  wire n4651_o;
  wire [1:0] n4652_o;
  reg [1:0] n4656_o;
  wire [1:0] n4658_o;
  wire n4661_o;
  wire n4664_o;
  wire n4666_o;
  wire n4668_o;
  wire [4:0] n4669_o;
  reg [3:0] n4670_o;
  reg [1:0] n4674_o;
  reg [1:0] n4678_o;
  reg [1:0] n4682_o;
  reg [1:0] n4684_o;
  reg n4686_o;
  reg n4689_o;
  reg n4692_o;
  reg n4694_o;
  wire [2:0] n4697_o;
  wire [3:0] n4698_o;
  wire [1:0] n4699_o;
  wire [1:0] n4700_o;
  wire [1:0] n4701_o;
  wire [1:0] n4703_o;
  wire n4705_o;
  wire n4706_o;
  wire n4708_o;
  wire n4710_o;
  wire n4711_o;
  wire n4712_o;
  wire n4714_o;
  wire n4715_o;
  wire n4717_o;
  wire n4719_o;
  wire n4721_o;
  wire n4722_o;
  wire n4724_o;
  wire n4725_o;
  wire n4727_o;
  wire n4728_o;
  wire [13:0] n4729_o;
  reg [2:0] n4732_o;
  reg [3:0] n4734_o;
  reg [1:0] n4736_o;
  reg [3:0] n4738_o;
  reg [1:0] n4740_o;
  reg [1:0] n4743_o;
  reg [1:0] n4746_o;
  reg n4749_o;
  reg n4752_o;
  reg n4755_o;
  reg n4758_o;
  reg n4761_o;
  reg n4764_o;
  reg n4766_o;
  reg n4768_o;
  reg n4770_o;
  reg n4771_o;
  reg n4772_o;
  reg n4774_o;
  reg n4777_o;
  reg n4780_o;
  reg n4783_o;
  reg n4786_o;
  reg n4789_o;
  reg n4792_o;
  reg n4795_o;
  wire [1:0] n4800_o;
  wire [2:0] n4801_o;
  wire [2:0] n4802_o;
  wire n4804_o;
  wire n4806_o;
  wire n4807_o;
  wire n4809_o;
  wire n4811_o;
  wire [2:0] n4812_o;
  reg [4:0] n4817_o;
  wire n4819_o;
  wire n4821_o;
  wire n4822_o;
  wire n4824_o;
  wire n4825_o;
  wire [2:0] n4826_o;
  wire n4828_o;
  wire n4830_o;
  wire n4831_o;
  wire n4833_o;
  wire [1:0] n4834_o;
  reg [4:0] n4838_o;
  wire n4840_o;
  wire [2:0] n4841_o;
  wire n4843_o;
  reg [4:0] n4846_o;
  wire n4848_o;
  wire [2:0] n4849_o;
  wire n4851_o;
  reg [4:0] n4854_o;
  wire [2:0] n4855_o;
  reg [4:0] n4856_o;
  wire n4858_o;
  wire [2:0] n4859_o;
  wire [30:0] n4860_o;
  wire n4862_o;
  wire n4864_o;
  wire n4866_o;
  wire n4868_o;
  wire n4870_o;
  wire n4872_o;
  wire n4874_o;
  wire [6:0] n4875_o;
  reg [4:0] n4884_o;
  wire n4886_o;
  wire [2:0] n4887_o;
  wire [30:0] n4888_o;
  wire [2:0] n4889_o;
  wire n4891_o;
  wire n4893_o;
  wire n4894_o;
  wire [4:0] n4897_o;
  wire n4900_o;
  wire [2:0] n4901_o;
  wire n4903_o;
  wire n4905_o;
  wire n4906_o;
  wire [4:0] n4909_o;
  wire n4912_o;
  wire n4914_o;
  wire n4916_o;
  wire [2:0] n4917_o;
  wire n4919_o;
  wire [4:0] n4922_o;
  wire n4925_o;
  wire n4927_o;
  wire n4929_o;
  wire [6:0] n4930_o;
  reg [4:0] n4936_o;
  wire n4938_o;
  wire [2:0] n4939_o;
  wire [30:0] n4940_o;
  wire n4942_o;
  wire [4:0] n4945_o;
  wire n4947_o;
  wire n4949_o;
  wire n4951_o;
  wire n4953_o;
  wire n4955_o;
  wire n4956_o;
  wire n4958_o;
  wire [2:0] n4959_o;
  wire [30:0] n4960_o;
  wire n4962_o;
  wire n4964_o;
  wire n4966_o;
  wire n4968_o;
  wire n4970_o;
  wire n4972_o;
  wire n4974_o;
  wire [6:0] n4975_o;
  reg [4:0] n4984_o;
  wire [2:0] n4985_o;
  wire [30:0] n4986_o;
  wire n4988_o;
  wire n4990_o;
  wire n4992_o;
  wire n4994_o;
  wire n4996_o;
  wire n4998_o;
  wire [2:0] n4999_o;
  wire n5001_o;
  wire [4:0] n5004_o;
  wire n5007_o;
  wire [6:0] n5008_o;
  reg [4:0] n5016_o;
  wire [4:0] n5017_o;
  wire [4:0] n5019_o;
  wire [4:0] n5021_o;
  wire [4:0] n5023_o;
  wire [4:0] n5025_o;
  reg [4:0] n5026_o;
  wire [2:0] n5027_o;
  reg [4:0] n5028_o;
  assign lcycle = n4732_o;
  assign alu_op = n5028_o;
  assign set_busa_to = n4734_o;
  assign set_addr_to = n4736_o;
  assign write_data = n4738_o;
  assign jump = n4740_o;
  assign baadd = n4743_o;
  assign baquirk = n4746_o;
  assign breakatna = n4749_o;
  assign adadd = n4752_o;
  assign addy = n4755_o;
  assign pcadd = n4758_o;
  assign inc_s = n4761_o;
  assign dec_s = n4764_o;
  assign lda = n4766_o;
  assign ldp = n4768_o;
  assign ldx = n4770_o;
  assign ldy = n4771_o;
  assign lds = n4772_o;
  assign lddi = n4774_o;
  assign ldalu = n4777_o;
  assign ldad = n4780_o;
  assign ldbal = n4783_o;
  assign ldbah = n4786_o;
  assign savep = n4789_o;
  assign write = n4792_o;
  /* ./T65_MCode.vhd:96:10  */
  assign branch = n2867_o; // (signal)
  /* ./T65_MCode.vhd:97:10  */
  assign alumore = n4795_o; // (signal)
  /* ./T65_MCode.vhd:101:10  */
  assign n2839_o = ir[7:5];
  /* ./T65_MCode.vhd:102:20  */
  assign n2840_o = p[7];
  /* ./T65_MCode.vhd:102:15  */
  assign n2841_o = ~n2840_o;
  /* ./T65_MCode.vhd:102:29  */
  assign n2843_o = n2839_o == 3'b000;
  /* ./T65_MCode.vhd:103:20  */
  assign n2844_o = p[7];
  /* ./T65_MCode.vhd:103:29  */
  assign n2846_o = n2839_o == 3'b001;
  /* ./T65_MCode.vhd:104:20  */
  assign n2847_o = p[6];
  /* ./T65_MCode.vhd:104:15  */
  assign n2848_o = ~n2847_o;
  /* ./T65_MCode.vhd:104:29  */
  assign n2850_o = n2839_o == 3'b010;
  /* ./T65_MCode.vhd:105:20  */
  assign n2851_o = p[6];
  /* ./T65_MCode.vhd:105:29  */
  assign n2853_o = n2839_o == 3'b011;
  /* ./T65_MCode.vhd:106:20  */
  assign n2854_o = p[0];
  /* ./T65_MCode.vhd:106:15  */
  assign n2855_o = ~n2854_o;
  /* ./T65_MCode.vhd:106:29  */
  assign n2857_o = n2839_o == 3'b100;
  /* ./T65_MCode.vhd:107:20  */
  assign n2858_o = p[0];
  /* ./T65_MCode.vhd:107:29  */
  assign n2860_o = n2839_o == 3'b101;
  /* ./T65_MCode.vhd:108:20  */
  assign n2861_o = p[1];
  /* ./T65_MCode.vhd:108:15  */
  assign n2862_o = ~n2861_o;
  /* ./T65_MCode.vhd:108:29  */
  assign n2864_o = n2839_o == 3'b110;
  /* ./T65_MCode.vhd:109:20  */
  assign n2865_o = p[1];
  assign n2866_o = {n2864_o, n2860_o, n2857_o, n2853_o, n2850_o, n2846_o, n2843_o};
  /* ./T65_MCode.vhd:101:3  */
  always @*
    case (n2866_o)
      7'b1000000: n2867_o = n2862_o;
      7'b0100000: n2867_o = n2858_o;
      7'b0010000: n2867_o = n2855_o;
      7'b0001000: n2867_o = n2851_o;
      7'b0000100: n2867_o = n2848_o;
      7'b0000010: n2867_o = n2844_o;
      7'b0000001: n2867_o = n2841_o;
      default: n2867_o = n2865_o;
    endcase
  /* ./T65_MCode.vhd:140:12  */
  assign n2870_o = ir[7:5];
  /* ./T65_MCode.vhd:142:16  */
  assign n2871_o = ir[1:0];
  /* ./T65_MCode.vhd:145:18  */
  assign n2872_o = ir[4:2];
  /* ./T65_MCode.vhd:145:30  */
  assign n2874_o = n2872_o == 3'b111;
  /* ./T65_MCode.vhd:146:26  */
  assign n2875_o = ~rdy_mod;
  /* ./T65_MCode.vhd:146:15  */
  assign n2878_o = n2875_o ? 4'b1011 : 4'b0011;
  /* ./T65_MCode.vhd:145:13  */
  assign n2880_o = n2874_o ? n2878_o : 4'b0011;
  /* ./T65_MCode.vhd:143:11  */
  assign n2882_o = n2871_o == 2'b00;
  /* ./T65_MCode.vhd:156:18  */
  assign n2883_o = ir[4:2];
  /* ./T65_MCode.vhd:156:30  */
  assign n2885_o = n2883_o == 3'b111;
  /* ./T65_MCode.vhd:157:26  */
  assign n2886_o = ~rdy_mod;
  /* ./T65_MCode.vhd:157:15  */
  assign n2889_o = n2886_o ? 4'b1010 : 4'b0010;
  /* ./T65_MCode.vhd:156:13  */
  assign n2891_o = n2885_o ? n2889_o : 4'b0010;
  /* ./T65_MCode.vhd:154:11  */
  assign n2893_o = n2871_o == 2'b10;
  /* ./T65_MCode.vhd:166:18  */
  assign n2894_o = ir[4:2];
  /* ./T65_MCode.vhd:166:30  */
  assign n2896_o = n2894_o == 3'b110;
  /* ./T65_MCode.vhd:166:13  */
  assign n2899_o = n2896_o ? 4'b1001 : 4'b0001;
  /* ./T65_MCode.vhd:166:13  */
  assign n2902_o = n2896_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:172:18  */
  assign n2903_o = ir[4:2];
  /* ./T65_MCode.vhd:172:30  */
  assign n2905_o = n2903_o == 3'b111;
  /* ./T65_MCode.vhd:172:42  */
  assign n2906_o = ir[4:2];
  /* ./T65_MCode.vhd:172:54  */
  assign n2908_o = n2906_o == 3'b110;
  /* ./T65_MCode.vhd:172:37  */
  assign n2909_o = n2905_o | n2908_o;
  /* ./T65_MCode.vhd:172:66  */
  assign n2910_o = ir[4:2];
  /* ./T65_MCode.vhd:172:78  */
  assign n2912_o = n2910_o == 3'b100;
  /* ./T65_MCode.vhd:172:61  */
  assign n2913_o = n2909_o | n2912_o;
  /* ./T65_MCode.vhd:173:26  */
  assign n2914_o = ~rdy_mod;
  /* ./T65_MCode.vhd:173:15  */
  assign n2917_o = n2914_o ? 4'b1001 : 4'b1000;
  /* ./T65_MCode.vhd:172:13  */
  assign n2919_o = n2913_o ? n2917_o : 4'b1000;
  /* ./T65_MCode.vhd:165:11  */
  assign n2921_o = n2871_o == 2'b11;
  assign n2922_o = {n2921_o, n2893_o, n2882_o};
  /* ./T65_MCode.vhd:142:9  */
  always @*
    case (n2922_o)
      3'b100: n2926_o = n2899_o;
      3'b010: n2926_o = 4'b0010;
      3'b001: n2926_o = 4'b0011;
      default: n2926_o = 4'b0001;
    endcase
  /* ./T65_MCode.vhd:142:9  */
  always @*
    case (n2922_o)
      3'b100: n2928_o = n2919_o;
      3'b010: n2928_o = n2891_o;
      3'b001: n2928_o = n2880_o;
      default: n2928_o = 4'b0001;
    endcase
  /* ./T65_MCode.vhd:142:9  */
  always @*
    case (n2922_o)
      3'b100: n2930_o = n2902_o;
      3'b010: n2930_o = 1'b0;
      3'b001: n2930_o = 1'b0;
      default: n2930_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:141:7  */
  assign n2932_o = n2870_o == 3'b100;
  /* ./T65_MCode.vhd:186:16  */
  assign n2933_o = ir[1:0];
  /* ./T65_MCode.vhd:188:18  */
  assign n2934_o = ir[4];
  /* ./T65_MCode.vhd:188:22  */
  assign n2936_o = n2934_o != 1'b1;
  /* ./T65_MCode.vhd:188:34  */
  assign n2937_o = ir[2];
  /* ./T65_MCode.vhd:188:38  */
  assign n2939_o = n2937_o != 1'b0;
  /* ./T65_MCode.vhd:188:29  */
  assign n2940_o = n2936_o | n2939_o;
  /* ./T65_MCode.vhd:188:13  */
  assign n2943_o = n2940_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:187:11  */
  assign n2945_o = n2933_o == 2'b00;
  /* ./T65_MCode.vhd:191:11  */
  assign n2947_o = n2933_o == 2'b01;
  /* ./T65_MCode.vhd:193:11  */
  assign n2949_o = n2933_o == 2'b10;
  /* ./T65_MCode.vhd:198:18  */
  assign n2950_o = ir[4:2];
  /* ./T65_MCode.vhd:198:30  */
  assign n2952_o = n2950_o == 3'b110;
  /* ./T65_MCode.vhd:198:13  */
  assign n2955_o = n2952_o ? 4'b0100 : 4'b0000;
  /* ./T65_MCode.vhd:198:13  */
  assign n2958_o = n2952_o ? 1'b1 : 1'b0;
  assign n2959_o = {n2949_o, n2947_o, n2945_o};
  /* ./T65_MCode.vhd:186:9  */
  always @*
    case (n2959_o)
      3'b100: n2961_o = 4'b0000;
      3'b010: n2961_o = 4'b0000;
      3'b001: n2961_o = 4'b0000;
      default: n2961_o = n2955_o;
    endcase
  /* ./T65_MCode.vhd:186:9  */
  always @*
    case (n2959_o)
      3'b100: n2966_o = 1'b0;
      3'b010: n2966_o = 1'b1;
      3'b001: n2966_o = 1'b0;
      default: n2966_o = 1'b1;
    endcase
  /* ./T65_MCode.vhd:186:9  */
  always @*
    case (n2959_o)
      3'b100: n2970_o = 1'b1;
      3'b010: n2970_o = 1'b0;
      3'b001: n2970_o = 1'b0;
      default: n2970_o = 1'b1;
    endcase
  /* ./T65_MCode.vhd:186:9  */
  always @*
    case (n2959_o)
      3'b100: n2972_o = 1'b0;
      3'b010: n2972_o = 1'b0;
      3'b001: n2972_o = n2943_o;
      default: n2972_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:186:9  */
  always @*
    case (n2959_o)
      3'b100: n2974_o = 1'b0;
      3'b010: n2974_o = 1'b0;
      3'b001: n2974_o = 1'b0;
      default: n2974_o = n2958_o;
    endcase
  /* ./T65_MCode.vhd:184:7  */
  assign n2976_o = n2870_o == 3'b101;
  /* ./T65_MCode.vhd:204:16  */
  assign n2977_o = ir[1:0];
  /* ./T65_MCode.vhd:206:18  */
  assign n2978_o = ir[4];
  /* ./T65_MCode.vhd:206:22  */
  assign n2979_o = ~n2978_o;
  /* ./T65_MCode.vhd:206:13  */
  assign n2982_o = n2979_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:205:11  */
  assign n2984_o = n2977_o == 2'b00;
  /* ./T65_MCode.vhd:204:9  */
  always @*
    case (n2984_o)
      1'b1: n2987_o = 4'b0011;
      default: n2987_o = 4'b0001;
    endcase
  /* ./T65_MCode.vhd:204:9  */
  always @*
    case (n2984_o)
      1'b1: n2989_o = n2982_o;
      default: n2989_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:203:7  */
  assign n2991_o = n2870_o == 3'b110;
  /* ./T65_MCode.vhd:214:16  */
  assign n2992_o = ir[1:0];
  /* ./T65_MCode.vhd:216:16  */
  assign n2993_o = ir[4];
  /* ./T65_MCode.vhd:216:20  */
  assign n2994_o = ~n2993_o;
  /* ./T65_MCode.vhd:216:11  */
  assign n2997_o = n2994_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:215:9  */
  assign n2999_o = n2992_o == 2'b00;
  /* ./T65_MCode.vhd:214:9  */
  always @*
    case (n2999_o)
      1'b1: n3002_o = 4'b0010;
      default: n3002_o = 4'b0001;
    endcase
  /* ./T65_MCode.vhd:214:9  */
  always @*
    case (n2999_o)
      1'b1: n3004_o = n2997_o;
      default: n3004_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:213:7  */
  assign n3006_o = n2870_o == 3'b111;
  assign n3007_o = {n3006_o, n2991_o, n2976_o, n2932_o};
  /* ./T65_MCode.vhd:140:5  */
  always @*
    case (n3007_o)
      4'b1000: n3009_o = n3002_o;
      4'b0100: n3009_o = n2987_o;
      4'b0010: n3009_o = n2961_o;
      4'b0001: n3009_o = n2926_o;
      default: n3009_o = 4'b0001;
    endcase
  /* ./T65_MCode.vhd:140:5  */
  always @*
    case (n3007_o)
      4'b1000: n3012_o = 4'b0000;
      4'b0100: n3012_o = 4'b0000;
      4'b0010: n3012_o = 4'b0000;
      4'b0001: n3012_o = n2928_o;
      default: n3012_o = 4'b0000;
    endcase
  /* ./T65_MCode.vhd:140:5  */
  always @*
    case (n3007_o)
      4'b1000: n3015_o = 1'b0;
      4'b0100: n3015_o = 1'b0;
      4'b0010: n3015_o = n2966_o;
      4'b0001: n3015_o = 1'b0;
      default: n3015_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:140:5  */
  always @*
    case (n3007_o)
      4'b1000: n3018_o = n3004_o;
      4'b0100: n3018_o = 1'b0;
      4'b0010: n3018_o = n2970_o;
      4'b0001: n3018_o = 1'b0;
      default: n3018_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:140:5  */
  always @*
    case (n3007_o)
      4'b1000: n3021_o = 1'b0;
      4'b0100: n3021_o = n2989_o;
      4'b0010: n3021_o = n2972_o;
      4'b0001: n3021_o = 1'b0;
      default: n3021_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:140:5  */
  always @*
    case (n3007_o)
      4'b1000: n3024_o = 1'b0;
      4'b0100: n3024_o = 1'b0;
      4'b0010: n3024_o = n2974_o;
      4'b0001: n3024_o = n2930_o;
      default: n3024_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:226:10  */
  assign n3026_o = ir[7:6];
  /* ./T65_MCode.vhd:226:23  */
  assign n3028_o = n3026_o != 2'b10;
  /* ./T65_MCode.vhd:226:37  */
  assign n3029_o = ir[1];
  /* ./T65_MCode.vhd:226:31  */
  assign n3030_o = n3029_o & n3028_o;
  /* ./T65_MCode.vhd:226:56  */
  assign n3032_o = mode == 2'b00;
  /* ./T65_MCode.vhd:226:67  */
  assign n3033_o = ir[0];
  /* ./T65_MCode.vhd:226:70  */
  assign n3034_o = ~n3033_o;
  /* ./T65_MCode.vhd:226:62  */
  assign n3035_o = n3032_o | n3034_o;
  /* ./T65_MCode.vhd:226:47  */
  assign n3036_o = n3035_o & n3030_o;
  /* ./T65_MCode.vhd:227:12  */
  assign n3038_o = ir == 8'b11101011;
  /* ./T65_MCode.vhd:227:7  */
  assign n3041_o = n3038_o ? 4'b0001 : 4'b0000;
  /* ./T65_MCode.vhd:226:5  */
  assign n3042_o = n3036_o ? n3041_o : n3009_o;
  /* ./T65_MCode.vhd:234:12  */
  assign n3043_o = ir[4:0];
  /* ./T65_MCode.vhd:247:15  */
  assign n3045_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:251:15  */
  assign n3047_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:256:15  */
  assign n3049_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:261:15  */
  assign n3051_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:264:15  */
  assign n3053_o = mcycle == 3'b101;
  /* ./T65_MCode.vhd:267:15  */
  assign n3055_o = mcycle == 3'b110;
  assign n3056_o = {n3055_o, n3053_o, n3051_o, n3049_o, n3047_o, n3045_o};
  /* ./T65_MCode.vhd:246:13  */
  always @*
    case (n3056_o)
      6'b100000: n3063_o = 2'b00;
      6'b010000: n3063_o = 2'b11;
      6'b001000: n3063_o = 2'b11;
      6'b000100: n3063_o = 2'b01;
      6'b000010: n3063_o = 2'b01;
      6'b000001: n3063_o = 2'b01;
      default: n3063_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:246:13  */
  always @*
    case (n3056_o)
      6'b100000: n3067_o = n3012_o;
      6'b010000: n3067_o = n3012_o;
      6'b001000: n3067_o = n3012_o;
      6'b000100: n3067_o = 4'b0101;
      6'b000010: n3067_o = 4'b0110;
      6'b000001: n3067_o = 4'b0111;
      default: n3067_o = n3012_o;
    endcase
  /* ./T65_MCode.vhd:246:13  */
  always @*
    case (n3056_o)
      6'b100000: n3070_o = 2'b10;
      6'b010000: n3070_o = 2'b00;
      6'b001000: n3070_o = 2'b00;
      6'b000100: n3070_o = 2'b00;
      6'b000010: n3070_o = 2'b00;
      6'b000001: n3070_o = 2'b00;
      default: n3070_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:246:13  */
  always @*
    case (n3056_o)
      6'b100000: n3075_o = 1'b0;
      6'b010000: n3075_o = 1'b0;
      6'b001000: n3075_o = 1'b1;
      6'b000100: n3075_o = 1'b1;
      6'b000010: n3075_o = 1'b1;
      6'b000001: n3075_o = 1'b0;
      default: n3075_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:246:13  */
  always @*
    case (n3056_o)
      6'b100000: n3078_o = 1'b0;
      6'b010000: n3078_o = 1'b1;
      6'b001000: n3078_o = 1'b0;
      6'b000100: n3078_o = 1'b0;
      6'b000010: n3078_o = 1'b0;
      6'b000001: n3078_o = 1'b0;
      default: n3078_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:246:13  */
  always @*
    case (n3056_o)
      6'b100000: n3083_o = 1'b0;
      6'b010000: n3083_o = 1'b0;
      6'b001000: n3083_o = 1'b0;
      6'b000100: n3083_o = 1'b1;
      6'b000010: n3083_o = 1'b1;
      6'b000001: n3083_o = 1'b1;
      default: n3083_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:243:11  */
  assign n3085_o = ir == 8'b00000000;
  /* ./T65_MCode.vhd:274:15  */
  assign n3087_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:278:15  */
  assign n3089_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:282:15  */
  assign n3091_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:287:15  */
  assign n3093_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:289:15  */
  assign n3095_o = mcycle == 3'b101;
  assign n3096_o = {n3095_o, n3093_o, n3091_o, n3089_o, n3087_o};
  /* ./T65_MCode.vhd:273:13  */
  always @*
    case (n3096_o)
      5'b10000: n3101_o = 2'b00;
      5'b01000: n3101_o = 2'b00;
      5'b00100: n3101_o = 2'b01;
      5'b00010: n3101_o = 2'b01;
      5'b00001: n3101_o = 2'b01;
      default: n3101_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:273:13  */
  always @*
    case (n3096_o)
      5'b10000: n3104_o = n3012_o;
      5'b01000: n3104_o = n3012_o;
      5'b00100: n3104_o = 4'b0110;
      5'b00010: n3104_o = 4'b0111;
      5'b00001: n3104_o = n3012_o;
      default: n3104_o = n3012_o;
    endcase
  /* ./T65_MCode.vhd:273:13  */
  always @*
    case (n3096_o)
      5'b10000: n3108_o = 2'b10;
      5'b01000: n3108_o = 2'b00;
      5'b00100: n3108_o = 2'b00;
      5'b00010: n3108_o = 2'b00;
      5'b00001: n3108_o = 2'b01;
      default: n3108_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:273:13  */
  always @*
    case (n3096_o)
      5'b10000: n3112_o = 1'b0;
      5'b01000: n3112_o = 1'b1;
      5'b00100: n3112_o = 1'b1;
      5'b00010: n3112_o = 1'b0;
      5'b00001: n3112_o = 1'b0;
      default: n3112_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:273:13  */
  always @*
    case (n3096_o)
      5'b10000: n3115_o = 1'b0;
      5'b01000: n3115_o = 1'b0;
      5'b00100: n3115_o = 1'b0;
      5'b00010: n3115_o = 1'b0;
      5'b00001: n3115_o = 1'b1;
      default: n3115_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:273:13  */
  always @*
    case (n3096_o)
      5'b10000: n3119_o = 1'b0;
      5'b01000: n3119_o = 1'b0;
      5'b00100: n3119_o = 1'b1;
      5'b00010: n3119_o = 1'b1;
      5'b00001: n3119_o = 1'b0;
      default: n3119_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:271:11  */
  assign n3121_o = ir == 8'b00100000;
  /* ./T65_MCode.vhd:296:15  */
  assign n3123_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:298:15  */
  assign n3125_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:301:15  */
  assign n3127_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:305:15  */
  assign n3129_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:310:15  */
  assign n3131_o = mcycle == 3'b101;
  assign n3132_o = {n3131_o, n3129_o, n3127_o, n3125_o, n3123_o};
  /* ./T65_MCode.vhd:295:15  */
  always @*
    case (n3132_o)
      5'b10000: n3134_o = n3042_o;
      5'b01000: n3134_o = n3042_o;
      5'b00100: n3134_o = 4'b0000;
      5'b00010: n3134_o = n3042_o;
      5'b00001: n3134_o = n3042_o;
      default: n3134_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:295:15  */
  always @*
    case (n3132_o)
      5'b10000: n3140_o = 2'b00;
      5'b01000: n3140_o = 2'b01;
      5'b00100: n3140_o = 2'b01;
      5'b00010: n3140_o = 2'b01;
      5'b00001: n3140_o = 2'b01;
      default: n3140_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:295:15  */
  always @*
    case (n3132_o)
      5'b10000: n3143_o = 2'b10;
      5'b01000: n3143_o = 2'b00;
      5'b00100: n3143_o = 2'b00;
      5'b00010: n3143_o = 2'b00;
      5'b00001: n3143_o = 2'b00;
      default: n3143_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:295:15  */
  always @*
    case (n3132_o)
      5'b10000: n3148_o = 1'b0;
      5'b01000: n3148_o = 1'b1;
      5'b00100: n3148_o = 1'b1;
      5'b00010: n3148_o = 1'b1;
      5'b00001: n3148_o = 1'b0;
      default: n3148_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:295:15  */
  always @*
    case (n3132_o)
      5'b10000: n3151_o = 1'b0;
      5'b01000: n3151_o = 1'b1;
      5'b00100: n3151_o = 1'b0;
      5'b00010: n3151_o = 1'b0;
      5'b00001: n3151_o = 1'b0;
      default: n3151_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:295:15  */
  always @*
    case (n3132_o)
      5'b10000: n3154_o = 1'b0;
      5'b01000: n3154_o = 1'b1;
      5'b00100: n3154_o = 1'b0;
      5'b00010: n3154_o = 1'b0;
      5'b00001: n3154_o = 1'b0;
      default: n3154_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:293:13  */
  assign n3156_o = ir == 8'b01000000;
  /* ./T65_MCode.vhd:317:15  */
  assign n3158_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:319:15  */
  assign n3160_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:322:15  */
  assign n3162_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:326:15  */
  assign n3164_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:328:15  */
  assign n3166_o = mcycle == 3'b101;
  assign n3167_o = {n3166_o, n3164_o, n3162_o, n3160_o, n3158_o};
  /* ./T65_MCode.vhd:316:13  */
  always @*
    case (n3167_o)
      5'b10000: n3172_o = 2'b00;
      5'b01000: n3172_o = 2'b00;
      5'b00100: n3172_o = 2'b01;
      5'b00010: n3172_o = 2'b01;
      5'b00001: n3172_o = 2'b01;
      default: n3172_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:316:13  */
  always @*
    case (n3167_o)
      5'b10000: n3176_o = 2'b01;
      5'b01000: n3176_o = 2'b10;
      5'b00100: n3176_o = 2'b00;
      5'b00010: n3176_o = 2'b00;
      5'b00001: n3176_o = 2'b00;
      default: n3176_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:316:13  */
  always @*
    case (n3167_o)
      5'b10000: n3180_o = 1'b0;
      5'b01000: n3180_o = 1'b0;
      5'b00100: n3180_o = 1'b1;
      5'b00010: n3180_o = 1'b1;
      5'b00001: n3180_o = 1'b0;
      default: n3180_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:316:13  */
  always @*
    case (n3167_o)
      5'b10000: n3183_o = 1'b0;
      5'b01000: n3183_o = 1'b0;
      5'b00100: n3183_o = 1'b1;
      5'b00010: n3183_o = 1'b0;
      5'b00001: n3183_o = 1'b0;
      default: n3183_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:314:11  */
  assign n3185_o = ir == 8'b01100000;
  /* ./T65_MCode.vhd:334:23  */
  assign n3187_o = mode == 2'b00;
  /* ./T65_MCode.vhd:334:36  */
  assign n3188_o = ir[1];
  /* ./T65_MCode.vhd:334:30  */
  assign n3189_o = n3188_o & n3187_o;
  /* ./T65_MCode.vhd:334:15  */
  assign n3192_o = n3189_o ? 3'b001 : 3'b010;
  /* ./T65_MCode.vhd:339:24  */
  assign n3195_o = mode != 2'b00;
  /* ./T65_MCode.vhd:339:36  */
  assign n3196_o = ir[1];
  /* ./T65_MCode.vhd:339:39  */
  assign n3197_o = ~n3196_o;
  /* ./T65_MCode.vhd:339:31  */
  assign n3198_o = n3195_o | n3197_o;
  /* ./T65_MCode.vhd:341:26  */
  assign n3199_o = ir[7:4];
  /* ./T65_MCode.vhd:342:19  */
  assign n3201_o = n3199_o == 4'b0000;
  /* ./T65_MCode.vhd:344:19  */
  assign n3203_o = n3199_o == 4'b0100;
  /* ./T65_MCode.vhd:347:29  */
  assign n3205_o = mode != 2'b00;
  /* ./T65_MCode.vhd:347:21  */
  assign n3207_o = n3205_o ? 4'b0011 : n3012_o;
  /* ./T65_MCode.vhd:347:21  */
  assign n3210_o = n3205_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:346:19  */
  assign n3212_o = n3199_o == 4'b0101;
  /* ./T65_MCode.vhd:353:29  */
  assign n3214_o = mode != 2'b00;
  /* ./T65_MCode.vhd:353:21  */
  assign n3216_o = n3214_o ? 4'b0010 : n3012_o;
  /* ./T65_MCode.vhd:353:21  */
  assign n3219_o = n3214_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:352:19  */
  assign n3221_o = n3199_o == 4'b1101;
  assign n3222_o = {n3221_o, n3212_o, n3203_o, n3201_o};
  /* ./T65_MCode.vhd:341:19  */
  always @*
    case (n3222_o)
      4'b1000: n3225_o = n3216_o;
      4'b0100: n3225_o = n3207_o;
      4'b0010: n3225_o = 4'b0001;
      4'b0001: n3225_o = 4'b0101;
      default: n3225_o = n3012_o;
    endcase
  /* ./T65_MCode.vhd:341:19  */
  always @*
    case (n3222_o)
      4'b1000: n3227_o = n3219_o;
      4'b0100: n3227_o = n3210_o;
      4'b0010: n3227_o = 1'b1;
      4'b0001: n3227_o = 1'b1;
      default: n3227_o = 1'b1;
    endcase
  /* ./T65_MCode.vhd:339:17  */
  assign n3231_o = n3198_o ? 2'b01 : 2'b00;
  /* ./T65_MCode.vhd:339:17  */
  assign n3232_o = n3198_o ? n3225_o : n3012_o;
  /* ./T65_MCode.vhd:339:17  */
  assign n3234_o = n3198_o ? n3227_o : 1'b0;
  /* ./T65_MCode.vhd:338:15  */
  assign n3236_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:362:15  */
  assign n3238_o = mcycle == 3'b010;
  assign n3239_o = {n3238_o, n3236_o};
  /* ./T65_MCode.vhd:337:15  */
  always @*
    case (n3239_o)
      2'b10: n3241_o = 2'b00;
      2'b01: n3241_o = n3231_o;
      default: n3241_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:337:15  */
  always @*
    case (n3239_o)
      2'b10: n3242_o = n3012_o;
      2'b01: n3242_o = n3232_o;
      default: n3242_o = n3012_o;
    endcase
  /* ./T65_MCode.vhd:337:15  */
  always @*
    case (n3239_o)
      2'b10: n3245_o = 1'b1;
      2'b01: n3245_o = 1'b0;
      default: n3245_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:337:15  */
  always @*
    case (n3239_o)
      2'b10: n3247_o = 1'b0;
      2'b01: n3247_o = n3234_o;
      default: n3247_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:332:13  */
  assign n3249_o = ir == 8'b00001000;
  /* ./T65_MCode.vhd:332:24  */
  assign n3251_o = ir == 8'b01001000;
  /* ./T65_MCode.vhd:332:24  */
  assign n3252_o = n3249_o | n3251_o;
  /* ./T65_MCode.vhd:332:32  */
  assign n3254_o = ir == 8'b01011010;
  /* ./T65_MCode.vhd:332:32  */
  assign n3255_o = n3252_o | n3254_o;
  /* ./T65_MCode.vhd:332:40  */
  assign n3257_o = ir == 8'b11011010;
  /* ./T65_MCode.vhd:332:40  */
  assign n3258_o = n3255_o | n3257_o;
  /* ./T65_MCode.vhd:368:21  */
  assign n3260_o = mode == 2'b00;
  /* ./T65_MCode.vhd:368:34  */
  assign n3261_o = ir[1];
  /* ./T65_MCode.vhd:368:28  */
  assign n3262_o = n3261_o & n3260_o;
  /* ./T65_MCode.vhd:368:13  */
  assign n3265_o = n3262_o ? 3'b001 : 3'b011;
  /* ./T65_MCode.vhd:371:20  */
  assign n3267_o = ir[7:4];
  /* ./T65_MCode.vhd:372:15  */
  assign n3269_o = n3267_o == 4'b0010;
  /* ./T65_MCode.vhd:374:15  */
  assign n3271_o = n3267_o == 4'b0110;
  /* ./T65_MCode.vhd:377:25  */
  assign n3273_o = mode != 2'b00;
  /* ./T65_MCode.vhd:377:17  */
  assign n3275_o = n3273_o ? 1'b1 : n3021_o;
  /* ./T65_MCode.vhd:376:15  */
  assign n3277_o = n3267_o == 4'b0111;
  /* ./T65_MCode.vhd:381:25  */
  assign n3279_o = mode != 2'b00;
  /* ./T65_MCode.vhd:381:17  */
  assign n3281_o = n3279_o ? 1'b1 : n3018_o;
  /* ./T65_MCode.vhd:380:15  */
  assign n3283_o = n3267_o == 4'b1111;
  assign n3284_o = {n3283_o, n3277_o, n3271_o, n3269_o};
  /* ./T65_MCode.vhd:371:13  */
  always @*
    case (n3284_o)
      4'b1000: n3286_o = n3015_o;
      4'b0100: n3286_o = n3015_o;
      4'b0010: n3286_o = 1'b1;
      4'b0001: n3286_o = n3015_o;
      default: n3286_o = n3015_o;
    endcase
  /* ./T65_MCode.vhd:371:13  */
  always @*
    case (n3284_o)
      4'b1000: n3289_o = 1'b0;
      4'b0100: n3289_o = 1'b0;
      4'b0010: n3289_o = 1'b0;
      4'b0001: n3289_o = 1'b1;
      default: n3289_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:371:13  */
  always @*
    case (n3284_o)
      4'b1000: n3290_o = n3281_o;
      4'b0100: n3290_o = n3018_o;
      4'b0010: n3290_o = n3018_o;
      4'b0001: n3290_o = n3018_o;
      default: n3290_o = n3018_o;
    endcase
  /* ./T65_MCode.vhd:371:13  */
  always @*
    case (n3284_o)
      4'b1000: n3291_o = n3021_o;
      4'b0100: n3291_o = n3275_o;
      4'b0010: n3291_o = n3021_o;
      4'b0001: n3291_o = n3021_o;
      default: n3291_o = n3021_o;
    endcase
  /* ./T65_MCode.vhd:388:25  */
  assign n3293_o = mode != 2'b00;
  /* ./T65_MCode.vhd:388:38  */
  assign n3294_o = ir[1];
  /* ./T65_MCode.vhd:388:42  */
  assign n3295_o = ~n3294_o;
  /* ./T65_MCode.vhd:388:33  */
  assign n3296_o = n3293_o | n3295_o;
  /* ./T65_MCode.vhd:388:17  */
  assign n3299_o = n3296_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:387:15  */
  assign n3301_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:392:25  */
  assign n3303_o = mode != 2'b00;
  /* ./T65_MCode.vhd:392:38  */
  assign n3304_o = ir[1];
  /* ./T65_MCode.vhd:392:42  */
  assign n3305_o = ~n3304_o;
  /* ./T65_MCode.vhd:392:33  */
  assign n3306_o = n3303_o | n3305_o;
  /* ./T65_MCode.vhd:392:17  */
  assign n3309_o = n3306_o ? 2'b01 : 2'b00;
  /* ./T65_MCode.vhd:392:17  */
  assign n3311_o = n3306_o ? 1'b0 : n3289_o;
  /* ./T65_MCode.vhd:391:15  */
  assign n3313_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:396:15  */
  assign n3315_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:400:15  */
  assign n3317_o = mcycle == 3'b011;
  assign n3318_o = {n3317_o, n3315_o, n3313_o, n3301_o};
  /* ./T65_MCode.vhd:386:13  */
  always @*
    case (n3318_o)
      4'b1000: n3320_o = 4'b0000;
      4'b0100: n3320_o = n3042_o;
      4'b0010: n3320_o = n3042_o;
      4'b0001: n3320_o = n3042_o;
      default: n3320_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:386:13  */
  always @*
    case (n3318_o)
      4'b1000: n3323_o = 2'b00;
      4'b0100: n3323_o = 2'b01;
      4'b0010: n3323_o = n3309_o;
      4'b0001: n3323_o = 2'b00;
      default: n3323_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:386:13  */
  always @*
    case (n3318_o)
      4'b1000: n3326_o = 1'b0;
      4'b0100: n3326_o = 1'b1;
      4'b0010: n3326_o = 1'b0;
      4'b0001: n3326_o = 1'b0;
      default: n3326_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:386:13  */
  always @*
    case (n3318_o)
      4'b1000: n3328_o = n3289_o;
      4'b0100: n3328_o = 1'b0;
      4'b0010: n3328_o = n3311_o;
      4'b0001: n3328_o = n3289_o;
      default: n3328_o = n3289_o;
    endcase
  /* ./T65_MCode.vhd:386:13  */
  always @*
    case (n3318_o)
      4'b1000: n3330_o = 1'b0;
      4'b0100: n3330_o = 1'b0;
      4'b0010: n3330_o = 1'b0;
      4'b0001: n3330_o = n3299_o;
      default: n3330_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:366:11  */
  assign n3332_o = ir == 8'b00101000;
  /* ./T65_MCode.vhd:366:23  */
  assign n3334_o = ir == 8'b01101000;
  /* ./T65_MCode.vhd:366:23  */
  assign n3335_o = n3332_o | n3334_o;
  /* ./T65_MCode.vhd:366:31  */
  assign n3337_o = ir == 8'b01111010;
  /* ./T65_MCode.vhd:366:31  */
  assign n3338_o = n3335_o | n3337_o;
  /* ./T65_MCode.vhd:366:39  */
  assign n3340_o = ir == 8'b11111010;
  /* ./T65_MCode.vhd:366:39  */
  assign n3341_o = n3338_o | n3340_o;
  /* ./T65_MCode.vhd:407:15  */
  assign n3343_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:408:15  */
  assign n3345_o = mcycle == 3'b001;
  assign n3346_o = {n3345_o, n3343_o};
  /* ./T65_MCode.vhd:406:13  */
  always @*
    case (n3346_o)
      2'b10: n3349_o = 2'b01;
      2'b01: n3349_o = 2'b00;
      default: n3349_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:404:11  */
  assign n3351_o = ir == 8'b10100000;
  /* ./T65_MCode.vhd:404:22  */
  assign n3353_o = ir == 8'b11000000;
  /* ./T65_MCode.vhd:404:22  */
  assign n3354_o = n3351_o | n3353_o;
  /* ./T65_MCode.vhd:404:30  */
  assign n3356_o = ir == 8'b11100000;
  /* ./T65_MCode.vhd:404:30  */
  assign n3357_o = n3354_o | n3356_o;
  /* ./T65_MCode.vhd:415:15  */
  assign n3359_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:416:15  */
  assign n3361_o = mcycle == 3'b001;
  assign n3362_o = {n3361_o, n3359_o};
  /* ./T65_MCode.vhd:414:13  */
  always @*
    case (n3362_o)
      2'b10: n3364_o = 4'b0011;
      2'b01: n3364_o = n3042_o;
      default: n3364_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:412:11  */
  assign n3366_o = ir == 8'b10001000;
  /* ./T65_MCode.vhd:423:15  */
  assign n3368_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:424:15  */
  assign n3370_o = mcycle == 3'b001;
  assign n3371_o = {n3370_o, n3368_o};
  /* ./T65_MCode.vhd:422:13  */
  always @*
    case (n3371_o)
      2'b10: n3373_o = 4'b0010;
      2'b01: n3373_o = n3042_o;
      default: n3373_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:420:11  */
  assign n3375_o = ir == 8'b11001010;
  /* ./T65_MCode.vhd:429:21  */
  assign n3377_o = mode != 2'b00;
  /* ./T65_MCode.vhd:429:13  */
  assign n3379_o = n3377_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:435:15  */
  assign n3381_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:436:15  */
  assign n3383_o = mcycle == 3'b001;
  assign n3384_o = {n3383_o, n3381_o};
  /* ./T65_MCode.vhd:434:13  */
  always @*
    case (n3384_o)
      2'b10: n3386_o = 4'b0100;
      2'b01: n3386_o = n3042_o;
      default: n3386_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:428:11  */
  assign n3388_o = ir == 8'b00011010;
  /* ./T65_MCode.vhd:428:22  */
  assign n3390_o = ir == 8'b00111010;
  /* ./T65_MCode.vhd:428:22  */
  assign n3391_o = n3388_o | n3390_o;
  /* ./T65_MCode.vhd:440:11  */
  assign n3398_o = ir == 8'b00001010;
  /* ./T65_MCode.vhd:440:22  */
  assign n3400_o = ir == 8'b00101010;
  /* ./T65_MCode.vhd:440:22  */
  assign n3401_o = n3398_o | n3400_o;
  /* ./T65_MCode.vhd:440:30  */
  assign n3403_o = ir == 8'b01001010;
  /* ./T65_MCode.vhd:440:30  */
  assign n3404_o = n3401_o | n3403_o;
  /* ./T65_MCode.vhd:440:38  */
  assign n3406_o = ir == 8'b01101010;
  /* ./T65_MCode.vhd:440:38  */
  assign n3407_o = n3404_o | n3406_o;
  /* ./T65_MCode.vhd:448:11  */
  assign n3414_o = ir == 8'b10001010;
  /* ./T65_MCode.vhd:448:22  */
  assign n3416_o = ir == 8'b10011000;
  /* ./T65_MCode.vhd:448:22  */
  assign n3417_o = n3414_o | n3416_o;
  /* ./T65_MCode.vhd:457:15  */
  assign n3419_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:458:15  */
  assign n3421_o = mcycle == 3'b001;
  assign n3422_o = {n3421_o, n3419_o};
  /* ./T65_MCode.vhd:456:13  */
  always @*
    case (n3422_o)
      2'b10: n3424_o = 4'b0001;
      2'b01: n3424_o = n3042_o;
      default: n3424_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:455:11  */
  assign n3426_o = ir == 8'b10101010;
  /* ./T65_MCode.vhd:455:22  */
  assign n3428_o = ir == 8'b10101000;
  /* ./T65_MCode.vhd:455:22  */
  assign n3429_o = n3426_o | n3428_o;
  /* ./T65_MCode.vhd:462:11  */
  assign n3431_o = ir == 8'b10011010;
  /* ./T65_MCode.vhd:467:15  */
  assign n3433_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:468:15  */
  assign n3435_o = mcycle == 3'b001;
  assign n3436_o = {n3435_o, n3433_o};
  /* ./T65_MCode.vhd:466:13  */
  always @*
    case (n3436_o)
      2'b10: n3438_o = 4'b0100;
      2'b01: n3438_o = n3042_o;
      default: n3438_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:464:11  */
  assign n3440_o = ir == 8'b10111010;
  /* ./T65_MCode.vhd:474:15  */
  assign n3442_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:475:15  */
  assign n3444_o = mcycle == 3'b001;
  assign n3445_o = {n3444_o, n3442_o};
  /* ./T65_MCode.vhd:473:13  */
  always @*
    case (n3445_o)
      2'b10: n3448_o = 2'b01;
      2'b01: n3448_o = 2'b00;
      default: n3448_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:472:11  */
  assign n3450_o = ir == 8'b10000000;
  assign n3453_o = {n3450_o, n3440_o, n3431_o, n3429_o, n3417_o, n3407_o, n3391_o, n3375_o, n3366_o, n3357_o, n3341_o, n3258_o, n3185_o, n3156_o, n3121_o, n3085_o};
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3459_o = 3'b001;
      16'b0100000000000000: n3459_o = 3'b001;
      16'b0010000000000000: n3459_o = 3'b001;
      16'b0001000000000000: n3459_o = 3'b001;
      16'b0000100000000000: n3459_o = 3'b001;
      16'b0000010000000000: n3459_o = 3'b001;
      16'b0000001000000000: n3459_o = 3'b001;
      16'b0000000100000000: n3459_o = 3'b001;
      16'b0000000010000000: n3459_o = 3'b001;
      16'b0000000001000000: n3459_o = 3'b001;
      16'b0000000000100000: n3459_o = n3265_o;
      16'b0000000000010000: n3459_o = n3192_o;
      16'b0000000000001000: n3459_o = 3'b101;
      16'b0000000000000100: n3459_o = 3'b101;
      16'b0000000000000010: n3459_o = 3'b101;
      16'b0000000000000001: n3459_o = 3'b110;
      default: n3459_o = 3'b001;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3461_o = n3042_o;
      16'b0100000000000000: n3461_o = n3438_o;
      16'b0010000000000000: n3461_o = n3042_o;
      16'b0001000000000000: n3461_o = n3424_o;
      16'b0000100000000000: n3461_o = n3042_o;
      16'b0000010000000000: n3461_o = 4'b0001;
      16'b0000001000000000: n3461_o = n3386_o;
      16'b0000000100000000: n3461_o = n3373_o;
      16'b0000000010000000: n3461_o = n3364_o;
      16'b0000000001000000: n3461_o = n3042_o;
      16'b0000000000100000: n3461_o = n3320_o;
      16'b0000000000010000: n3461_o = n3042_o;
      16'b0000000000001000: n3461_o = n3042_o;
      16'b0000000000000100: n3461_o = n3134_o;
      16'b0000000000000010: n3461_o = n3042_o;
      16'b0000000000000001: n3461_o = n3042_o;
      default: n3461_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3463_o = 2'b00;
      16'b0100000000000000: n3463_o = 2'b00;
      16'b0010000000000000: n3463_o = 2'b00;
      16'b0001000000000000: n3463_o = 2'b00;
      16'b0000100000000000: n3463_o = 2'b00;
      16'b0000010000000000: n3463_o = 2'b00;
      16'b0000001000000000: n3463_o = 2'b00;
      16'b0000000100000000: n3463_o = 2'b00;
      16'b0000000010000000: n3463_o = 2'b00;
      16'b0000000001000000: n3463_o = 2'b00;
      16'b0000000000100000: n3463_o = n3323_o;
      16'b0000000000010000: n3463_o = n3241_o;
      16'b0000000000001000: n3463_o = n3172_o;
      16'b0000000000000100: n3463_o = n3140_o;
      16'b0000000000000010: n3463_o = n3101_o;
      16'b0000000000000001: n3463_o = n3063_o;
      default: n3463_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3464_o = n3012_o;
      16'b0100000000000000: n3464_o = n3012_o;
      16'b0010000000000000: n3464_o = n3012_o;
      16'b0001000000000000: n3464_o = n3012_o;
      16'b0000100000000000: n3464_o = n3012_o;
      16'b0000010000000000: n3464_o = n3012_o;
      16'b0000001000000000: n3464_o = n3012_o;
      16'b0000000100000000: n3464_o = n3012_o;
      16'b0000000010000000: n3464_o = n3012_o;
      16'b0000000001000000: n3464_o = n3012_o;
      16'b0000000000100000: n3464_o = n3012_o;
      16'b0000000000010000: n3464_o = n3242_o;
      16'b0000000000001000: n3464_o = n3012_o;
      16'b0000000000000100: n3464_o = n3012_o;
      16'b0000000000000010: n3464_o = n3104_o;
      16'b0000000000000001: n3464_o = n3067_o;
      default: n3464_o = n3012_o;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3466_o = n3448_o;
      16'b0100000000000000: n3466_o = 2'b00;
      16'b0010000000000000: n3466_o = 2'b00;
      16'b0001000000000000: n3466_o = 2'b00;
      16'b0000100000000000: n3466_o = 2'b00;
      16'b0000010000000000: n3466_o = 2'b00;
      16'b0000001000000000: n3466_o = 2'b00;
      16'b0000000100000000: n3466_o = 2'b00;
      16'b0000000010000000: n3466_o = 2'b00;
      16'b0000000001000000: n3466_o = n3349_o;
      16'b0000000000100000: n3466_o = 2'b00;
      16'b0000000000010000: n3466_o = 2'b00;
      16'b0000000000001000: n3466_o = n3176_o;
      16'b0000000000000100: n3466_o = n3143_o;
      16'b0000000000000010: n3466_o = n3108_o;
      16'b0000000000000001: n3466_o = n3070_o;
      default: n3466_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3468_o = 1'b0;
      16'b0100000000000000: n3468_o = 1'b0;
      16'b0010000000000000: n3468_o = 1'b0;
      16'b0001000000000000: n3468_o = 1'b0;
      16'b0000100000000000: n3468_o = 1'b0;
      16'b0000010000000000: n3468_o = 1'b0;
      16'b0000001000000000: n3468_o = 1'b0;
      16'b0000000100000000: n3468_o = 1'b0;
      16'b0000000010000000: n3468_o = 1'b0;
      16'b0000000001000000: n3468_o = 1'b0;
      16'b0000000000100000: n3468_o = n3326_o;
      16'b0000000000010000: n3468_o = 1'b0;
      16'b0000000000001000: n3468_o = n3180_o;
      16'b0000000000000100: n3468_o = n3148_o;
      16'b0000000000000010: n3468_o = 1'b0;
      16'b0000000000000001: n3468_o = 1'b0;
      default: n3468_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3470_o = 1'b0;
      16'b0100000000000000: n3470_o = 1'b0;
      16'b0010000000000000: n3470_o = 1'b0;
      16'b0001000000000000: n3470_o = 1'b0;
      16'b0000100000000000: n3470_o = 1'b0;
      16'b0000010000000000: n3470_o = 1'b0;
      16'b0000001000000000: n3470_o = 1'b0;
      16'b0000000100000000: n3470_o = 1'b0;
      16'b0000000010000000: n3470_o = 1'b0;
      16'b0000000001000000: n3470_o = 1'b0;
      16'b0000000000100000: n3470_o = 1'b0;
      16'b0000000000010000: n3470_o = n3245_o;
      16'b0000000000001000: n3470_o = 1'b0;
      16'b0000000000000100: n3470_o = 1'b0;
      16'b0000000000000010: n3470_o = n3112_o;
      16'b0000000000000001: n3470_o = n3075_o;
      default: n3470_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3473_o = n3015_o;
      16'b0100000000000000: n3473_o = n3015_o;
      16'b0010000000000000: n3473_o = n3015_o;
      16'b0001000000000000: n3473_o = n3015_o;
      16'b0000100000000000: n3473_o = 1'b1;
      16'b0000010000000000: n3473_o = 1'b1;
      16'b0000001000000000: n3473_o = n3379_o;
      16'b0000000100000000: n3473_o = n3015_o;
      16'b0000000010000000: n3473_o = n3015_o;
      16'b0000000001000000: n3473_o = n3015_o;
      16'b0000000000100000: n3473_o = n3286_o;
      16'b0000000000010000: n3473_o = n3015_o;
      16'b0000000000001000: n3473_o = n3015_o;
      16'b0000000000000100: n3473_o = n3015_o;
      16'b0000000000000010: n3473_o = n3015_o;
      16'b0000000000000001: n3473_o = n3015_o;
      default: n3473_o = n3015_o;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3475_o = 1'b0;
      16'b0100000000000000: n3475_o = 1'b0;
      16'b0010000000000000: n3475_o = 1'b0;
      16'b0001000000000000: n3475_o = 1'b0;
      16'b0000100000000000: n3475_o = 1'b0;
      16'b0000010000000000: n3475_o = 1'b0;
      16'b0000001000000000: n3475_o = 1'b0;
      16'b0000000100000000: n3475_o = 1'b0;
      16'b0000000010000000: n3475_o = 1'b0;
      16'b0000000001000000: n3475_o = 1'b0;
      16'b0000000000100000: n3475_o = n3328_o;
      16'b0000000000010000: n3475_o = 1'b0;
      16'b0000000000001000: n3475_o = 1'b0;
      16'b0000000000000100: n3475_o = n3151_o;
      16'b0000000000000010: n3475_o = 1'b0;
      16'b0000000000000001: n3475_o = 1'b0;
      default: n3475_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3478_o = n3018_o;
      16'b0100000000000000: n3478_o = 1'b1;
      16'b0010000000000000: n3478_o = n3018_o;
      16'b0001000000000000: n3478_o = n3018_o;
      16'b0000100000000000: n3478_o = n3018_o;
      16'b0000010000000000: n3478_o = n3018_o;
      16'b0000001000000000: n3478_o = n3018_o;
      16'b0000000100000000: n3478_o = 1'b1;
      16'b0000000010000000: n3478_o = n3018_o;
      16'b0000000001000000: n3478_o = n3018_o;
      16'b0000000000100000: n3478_o = n3290_o;
      16'b0000000000010000: n3478_o = n3018_o;
      16'b0000000000001000: n3478_o = n3018_o;
      16'b0000000000000100: n3478_o = n3018_o;
      16'b0000000000000010: n3478_o = n3018_o;
      16'b0000000000000001: n3478_o = n3018_o;
      default: n3478_o = n3018_o;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3480_o = n3021_o;
      16'b0100000000000000: n3480_o = n3021_o;
      16'b0010000000000000: n3480_o = n3021_o;
      16'b0001000000000000: n3480_o = n3021_o;
      16'b0000100000000000: n3480_o = n3021_o;
      16'b0000010000000000: n3480_o = n3021_o;
      16'b0000001000000000: n3480_o = n3021_o;
      16'b0000000100000000: n3480_o = n3021_o;
      16'b0000000010000000: n3480_o = 1'b1;
      16'b0000000001000000: n3480_o = n3021_o;
      16'b0000000000100000: n3480_o = n3291_o;
      16'b0000000000010000: n3480_o = n3021_o;
      16'b0000000000001000: n3480_o = n3021_o;
      16'b0000000000000100: n3480_o = n3021_o;
      16'b0000000000000010: n3480_o = n3021_o;
      16'b0000000000000001: n3480_o = n3021_o;
      default: n3480_o = n3021_o;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3482_o = n3024_o;
      16'b0100000000000000: n3482_o = n3024_o;
      16'b0010000000000000: n3482_o = 1'b1;
      16'b0001000000000000: n3482_o = n3024_o;
      16'b0000100000000000: n3482_o = n3024_o;
      16'b0000010000000000: n3482_o = n3024_o;
      16'b0000001000000000: n3482_o = n3024_o;
      16'b0000000100000000: n3482_o = n3024_o;
      16'b0000000010000000: n3482_o = n3024_o;
      16'b0000000001000000: n3482_o = n3024_o;
      16'b0000000000100000: n3482_o = n3024_o;
      16'b0000000000010000: n3482_o = n3024_o;
      16'b0000000000001000: n3482_o = n3024_o;
      16'b0000000000000100: n3482_o = n3024_o;
      16'b0000000000000010: n3482_o = n3024_o;
      16'b0000000000000001: n3482_o = n3024_o;
      default: n3482_o = n3024_o;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3484_o = 1'b0;
      16'b0100000000000000: n3484_o = 1'b0;
      16'b0010000000000000: n3484_o = 1'b0;
      16'b0001000000000000: n3484_o = 1'b0;
      16'b0000100000000000: n3484_o = 1'b0;
      16'b0000010000000000: n3484_o = 1'b0;
      16'b0000001000000000: n3484_o = 1'b0;
      16'b0000000100000000: n3484_o = 1'b0;
      16'b0000000010000000: n3484_o = 1'b0;
      16'b0000000001000000: n3484_o = 1'b0;
      16'b0000000000100000: n3484_o = 1'b0;
      16'b0000000000010000: n3484_o = 1'b0;
      16'b0000000000001000: n3484_o = n3183_o;
      16'b0000000000000100: n3484_o = n3154_o;
      16'b0000000000000010: n3484_o = n3115_o;
      16'b0000000000000001: n3484_o = n3078_o;
      default: n3484_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3486_o = 1'b0;
      16'b0100000000000000: n3486_o = 1'b0;
      16'b0010000000000000: n3486_o = 1'b0;
      16'b0001000000000000: n3486_o = 1'b0;
      16'b0000100000000000: n3486_o = 1'b0;
      16'b0000010000000000: n3486_o = 1'b0;
      16'b0000001000000000: n3486_o = 1'b0;
      16'b0000000100000000: n3486_o = 1'b0;
      16'b0000000010000000: n3486_o = 1'b0;
      16'b0000000001000000: n3486_o = 1'b0;
      16'b0000000000100000: n3486_o = n3330_o;
      16'b0000000000010000: n3486_o = 1'b0;
      16'b0000000000001000: n3486_o = 1'b0;
      16'b0000000000000100: n3486_o = 1'b0;
      16'b0000000000000010: n3486_o = 1'b0;
      16'b0000000000000001: n3486_o = 1'b0;
      default: n3486_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:242:9  */
  always @*
    case (n3453_o)
      16'b1000000000000000: n3488_o = 1'b0;
      16'b0100000000000000: n3488_o = 1'b0;
      16'b0010000000000000: n3488_o = 1'b0;
      16'b0001000000000000: n3488_o = 1'b0;
      16'b0000100000000000: n3488_o = 1'b0;
      16'b0000010000000000: n3488_o = 1'b0;
      16'b0000001000000000: n3488_o = 1'b0;
      16'b0000000100000000: n3488_o = 1'b0;
      16'b0000000010000000: n3488_o = 1'b0;
      16'b0000000001000000: n3488_o = 1'b0;
      16'b0000000000100000: n3488_o = 1'b0;
      16'b0000000000010000: n3488_o = n3247_o;
      16'b0000000000001000: n3488_o = 1'b0;
      16'b0000000000000100: n3488_o = 1'b0;
      16'b0000000000000010: n3488_o = n3119_o;
      16'b0000000000000001: n3488_o = n3083_o;
      default: n3488_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:240:7  */
  assign n3490_o = n3043_o == 5'b00000;
  /* ./T65_MCode.vhd:240:20  */
  assign n3492_o = n3043_o == 5'b01000;
  /* ./T65_MCode.vhd:240:20  */
  assign n3493_o = n3490_o | n3492_o;
  /* ./T65_MCode.vhd:240:30  */
  assign n3495_o = n3043_o == 5'b01010;
  /* ./T65_MCode.vhd:240:30  */
  assign n3496_o = n3493_o | n3495_o;
  /* ./T65_MCode.vhd:240:40  */
  assign n3498_o = n3043_o == 5'b11000;
  /* ./T65_MCode.vhd:240:40  */
  assign n3499_o = n3496_o | n3498_o;
  /* ./T65_MCode.vhd:240:50  */
  assign n3501_o = n3043_o == 5'b11010;
  /* ./T65_MCode.vhd:240:50  */
  assign n3502_o = n3499_o | n3501_o;
  /* ./T65_MCode.vhd:491:14  */
  assign n3503_o = ir[7:6];
  /* ./T65_MCode.vhd:491:27  */
  assign n3505_o = n3503_o != 2'b10;
  /* ./T65_MCode.vhd:493:18  */
  assign n3507_o = mode == 2'b00;
  /* ./T65_MCode.vhd:493:30  */
  assign n3508_o = ir[1];
  /* ./T65_MCode.vhd:493:24  */
  assign n3509_o = n3508_o & n3507_o;
  /* ./T65_MCode.vhd:493:11  */
  assign n3512_o = n3509_o ? 3'b111 : 3'b101;
  /* ./T65_MCode.vhd:491:9  */
  assign n3514_o = n3505_o ? n3512_o : 3'b101;
  /* ./T65_MCode.vhd:491:9  */
  assign n3517_o = n3505_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:498:11  */
  assign n3519_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:502:11  */
  assign n3521_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:505:11  */
  assign n3523_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:511:18  */
  assign n3524_o = ir[7:5];
  /* ./T65_MCode.vhd:511:31  */
  assign n3526_o = n3524_o == 3'b100;
  /* ./T65_MCode.vhd:511:13  */
  assign n3529_o = n3526_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:509:11  */
  assign n3531_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:516:20  */
  assign n3533_o = mode == 2'b00;
  /* ./T65_MCode.vhd:516:32  */
  assign n3534_o = ir[1];
  /* ./T65_MCode.vhd:516:26  */
  assign n3535_o = n3534_o & n3533_o;
  /* ./T65_MCode.vhd:516:46  */
  assign n3536_o = ir[7:6];
  /* ./T65_MCode.vhd:516:58  */
  assign n3538_o = n3536_o != 2'b10;
  /* ./T65_MCode.vhd:516:40  */
  assign n3539_o = n3538_o & n3535_o;
  /* ./T65_MCode.vhd:516:13  */
  assign n3542_o = n3539_o ? 2'b11 : 2'b00;
  /* ./T65_MCode.vhd:516:13  */
  assign n3545_o = n3539_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:516:13  */
  assign n3548_o = n3539_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:515:11  */
  assign n3550_o = mcycle == 3'b101;
  /* ./T65_MCode.vhd:521:11  */
  assign n3552_o = mcycle == 3'b110;
  /* ./T65_MCode.vhd:526:11  */
  assign n3554_o = mcycle == 3'b111;
  assign n3555_o = {n3554_o, n3552_o, n3550_o, n3531_o, n3523_o, n3521_o, n3519_o};
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3557_o = 4'b0001;
      7'b0100000: n3557_o = n3042_o;
      7'b0010000: n3557_o = n3042_o;
      7'b0001000: n3557_o = n3042_o;
      7'b0000100: n3557_o = n3042_o;
      7'b0000010: n3557_o = n3042_o;
      7'b0000001: n3557_o = n3042_o;
      default: n3557_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3564_o = 2'b00;
      7'b0100000: n3564_o = 2'b11;
      7'b0010000: n3564_o = n3542_o;
      7'b0001000: n3564_o = 2'b11;
      7'b0000100: n3564_o = 2'b10;
      7'b0000010: n3564_o = 2'b10;
      7'b0000001: n3564_o = 2'b10;
      default: n3564_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3567_o = 2'b00;
      7'b0100000: n3567_o = 2'b00;
      7'b0010000: n3567_o = 2'b00;
      7'b0001000: n3567_o = 2'b00;
      7'b0000100: n3567_o = 2'b00;
      7'b0000010: n3567_o = 2'b00;
      7'b0000001: n3567_o = 2'b01;
      default: n3567_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3570_o = 2'b00;
      7'b0100000: n3570_o = 2'b00;
      7'b0010000: n3570_o = 2'b00;
      7'b0001000: n3570_o = 2'b00;
      7'b0000100: n3570_o = 2'b01;
      7'b0000010: n3570_o = 2'b00;
      7'b0000001: n3570_o = 2'b00;
      default: n3570_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3573_o = 1'b0;
      7'b0100000: n3573_o = 1'b0;
      7'b0010000: n3573_o = 1'b0;
      7'b0001000: n3573_o = 1'b0;
      7'b0000100: n3573_o = 1'b0;
      7'b0000010: n3573_o = 1'b1;
      7'b0000001: n3573_o = 1'b0;
      default: n3573_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3575_o = 1'b0;
      7'b0100000: n3575_o = 1'b0;
      7'b0010000: n3575_o = n3545_o;
      7'b0001000: n3575_o = 1'b0;
      7'b0000100: n3575_o = 1'b0;
      7'b0000010: n3575_o = 1'b0;
      7'b0000001: n3575_o = 1'b0;
      default: n3575_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3578_o = 1'b0;
      7'b0100000: n3578_o = 1'b1;
      7'b0010000: n3578_o = 1'b0;
      7'b0001000: n3578_o = 1'b0;
      7'b0000100: n3578_o = 1'b0;
      7'b0000010: n3578_o = 1'b0;
      7'b0000001: n3578_o = 1'b0;
      default: n3578_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3581_o = 1'b0;
      7'b0100000: n3581_o = 1'b0;
      7'b0010000: n3581_o = 1'b0;
      7'b0001000: n3581_o = 1'b0;
      7'b0000100: n3581_o = 1'b0;
      7'b0000010: n3581_o = 1'b0;
      7'b0000001: n3581_o = 1'b1;
      default: n3581_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3584_o = 1'b0;
      7'b0100000: n3584_o = 1'b0;
      7'b0010000: n3584_o = 1'b0;
      7'b0001000: n3584_o = 1'b0;
      7'b0000100: n3584_o = 1'b1;
      7'b0000010: n3584_o = 1'b0;
      7'b0000001: n3584_o = 1'b0;
      default: n3584_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3587_o = 1'b0;
      7'b0100000: n3587_o = 1'b0;
      7'b0010000: n3587_o = 1'b0;
      7'b0001000: n3587_o = 1'b1;
      7'b0000100: n3587_o = 1'b0;
      7'b0000010: n3587_o = 1'b0;
      7'b0000001: n3587_o = 1'b0;
      default: n3587_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3590_o = 1'b0;
      7'b0100000: n3590_o = 1'b1;
      7'b0010000: n3590_o = 1'b0;
      7'b0001000: n3590_o = 1'b0;
      7'b0000100: n3590_o = 1'b0;
      7'b0000010: n3590_o = 1'b0;
      7'b0000001: n3590_o = 1'b0;
      default: n3590_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3593_o = 1'b0;
      7'b0100000: n3593_o = 1'b1;
      7'b0010000: n3593_o = n3548_o;
      7'b0001000: n3593_o = n3529_o;
      7'b0000100: n3593_o = 1'b0;
      7'b0000010: n3593_o = 1'b0;
      7'b0000001: n3593_o = 1'b0;
      default: n3593_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:497:9  */
  always @*
    case (n3555_o)
      7'b1000000: n3596_o = 1'b1;
      7'b0100000: n3596_o = 1'b0;
      7'b0010000: n3596_o = 1'b0;
      7'b0001000: n3596_o = 1'b0;
      7'b0000100: n3596_o = 1'b0;
      7'b0000010: n3596_o = 1'b0;
      7'b0000001: n3596_o = 1'b0;
      default: n3596_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:488:7  */
  assign n3598_o = n3043_o == 5'b00001;
  /* ./T65_MCode.vhd:488:20  */
  assign n3600_o = n3043_o == 5'b00011;
  /* ./T65_MCode.vhd:488:20  */
  assign n3601_o = n3598_o | n3600_o;
  /* ./T65_MCode.vhd:535:14  */
  assign n3602_o = ir[7:5];
  /* ./T65_MCode.vhd:535:26  */
  assign n3604_o = n3602_o != 3'b100;
  /* ./T65_MCode.vhd:535:9  */
  assign n3606_o = n3604_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:539:11  */
  assign n3608_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:538:9  */
  always @*
    case (n3608_o)
      1'b1: n3611_o = 2'b01;
      default: n3611_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:533:7  */
  assign n3613_o = n3043_o == 5'b01001;
  /* ./T65_MCode.vhd:546:16  */
  assign n3615_o = mode == 2'b00;
  /* ./T65_MCode.vhd:548:18  */
  assign n3616_o = ir[7:5];
  /* ./T65_MCode.vhd:549:13  */
  assign n3618_o = n3616_o == 3'b010;
  /* ./T65_MCode.vhd:549:23  */
  assign n3620_o = n3616_o == 3'b011;
  /* ./T65_MCode.vhd:549:23  */
  assign n3621_o = n3618_o | n3620_o;
  /* ./T65_MCode.vhd:549:29  */
  assign n3623_o = n3616_o == 3'b000;
  /* ./T65_MCode.vhd:549:29  */
  assign n3624_o = n3621_o | n3623_o;
  /* ./T65_MCode.vhd:549:35  */
  assign n3626_o = n3616_o == 3'b001;
  /* ./T65_MCode.vhd:549:35  */
  assign n3627_o = n3624_o | n3626_o;
  /* ./T65_MCode.vhd:552:13  */
  assign n3629_o = n3616_o == 3'b100;
  /* ./T65_MCode.vhd:555:13  */
  assign n3631_o = n3616_o == 3'b110;
  /* ./T65_MCode.vhd:558:13  */
  assign n3633_o = n3616_o == 3'b101;
  assign n3634_o = {n3633_o, n3631_o, n3629_o, n3627_o};
  /* ./T65_MCode.vhd:548:11  */
  always @*
    case (n3634_o)
      4'b1000: n3639_o = 4'b0111;
      4'b0100: n3639_o = 4'b1001;
      4'b0010: n3639_o = 4'b1000;
      4'b0001: n3639_o = 4'b0110;
      default: n3639_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:548:11  */
  always @*
    case (n3634_o)
      4'b1000: n3644_o = 1'b1;
      4'b0100: n3644_o = n3015_o;
      4'b0010: n3644_o = 1'b1;
      4'b0001: n3644_o = 1'b1;
      default: n3644_o = 1'b1;
    endcase
  /* ./T65_MCode.vhd:548:11  */
  always @*
    case (n3634_o)
      4'b1000: n3646_o = n3018_o;
      4'b0100: n3646_o = 1'b1;
      4'b0010: n3646_o = n3018_o;
      4'b0001: n3646_o = n3018_o;
      default: n3646_o = n3018_o;
    endcase
  /* ./T65_MCode.vhd:565:13  */
  assign n3648_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:564:11  */
  always @*
    case (n3648_o)
      1'b1: n3651_o = 2'b01;
      default: n3651_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:546:9  */
  assign n3652_o = n3615_o ? n3639_o : n3042_o;
  /* ./T65_MCode.vhd:546:9  */
  assign n3654_o = n3615_o ? n3651_o : 2'b00;
  /* ./T65_MCode.vhd:546:9  */
  assign n3655_o = n3615_o ? n3644_o : n3015_o;
  /* ./T65_MCode.vhd:546:9  */
  assign n3656_o = n3615_o ? n3646_o : n3018_o;
  /* ./T65_MCode.vhd:545:7  */
  assign n3658_o = n3043_o == 5'b01011;
  /* ./T65_MCode.vhd:576:11  */
  assign n3660_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:578:19  */
  assign n3662_o = ir == 8'b10100010;
  /* ./T65_MCode.vhd:582:21  */
  assign n3663_o = ir[7:4];
  /* ./T65_MCode.vhd:582:33  */
  assign n3665_o = n3663_o == 4'b1000;
  /* ./T65_MCode.vhd:582:46  */
  assign n3666_o = ir[7:4];
  /* ./T65_MCode.vhd:582:58  */
  assign n3668_o = n3666_o == 4'b1100;
  /* ./T65_MCode.vhd:582:41  */
  assign n3669_o = n3665_o | n3668_o;
  /* ./T65_MCode.vhd:582:71  */
  assign n3670_o = ir[7:4];
  /* ./T65_MCode.vhd:582:83  */
  assign n3672_o = n3670_o == 4'b1110;
  /* ./T65_MCode.vhd:582:66  */
  assign n3673_o = n3669_o | n3672_o;
  /* ./T65_MCode.vhd:582:13  */
  assign n3676_o = n3673_o ? 2'b01 : 2'b00;
  /* ./T65_MCode.vhd:578:13  */
  assign n3678_o = n3662_o ? 2'b01 : n3676_o;
  /* ./T65_MCode.vhd:578:13  */
  assign n3680_o = n3662_o ? 1'b1 : n3018_o;
  /* ./T65_MCode.vhd:577:11  */
  assign n3682_o = mcycle == 3'b001;
  assign n3683_o = {n3682_o, n3660_o};
  /* ./T65_MCode.vhd:575:9  */
  always @*
    case (n3683_o)
      2'b10: n3685_o = n3678_o;
      2'b01: n3685_o = 2'b00;
      default: n3685_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:575:9  */
  always @*
    case (n3683_o)
      2'b10: n3686_o = n3680_o;
      2'b01: n3686_o = n3018_o;
      default: n3686_o = n3018_o;
    endcase
  /* ./T65_MCode.vhd:573:7  */
  assign n3688_o = n3043_o == 5'b00010;
  /* ./T65_MCode.vhd:573:20  */
  assign n3690_o = n3043_o == 5'b10010;
  /* ./T65_MCode.vhd:573:20  */
  assign n3691_o = n3688_o | n3690_o;
  /* ./T65_MCode.vhd:597:18  */
  assign n3692_o = ir[7:5];
  /* ./T65_MCode.vhd:597:31  */
  assign n3694_o = n3692_o == 3'b001;
  /* ./T65_MCode.vhd:597:13  */
  assign n3697_o = n3694_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:596:11  */
  assign n3699_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:603:18  */
  assign n3700_o = ir[7:5];
  /* ./T65_MCode.vhd:603:31  */
  assign n3702_o = n3700_o == 3'b100;
  /* ./T65_MCode.vhd:603:13  */
  assign n3705_o = n3702_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:600:11  */
  assign n3707_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:607:11  */
  assign n3709_o = mcycle == 3'b010;
  assign n3710_o = {n3709_o, n3707_o, n3699_o};
  /* ./T65_MCode.vhd:595:9  */
  always @*
    case (n3710_o)
      3'b100: n3713_o = 2'b00;
      3'b010: n3713_o = 2'b10;
      3'b001: n3713_o = 2'b00;
      default: n3713_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:595:9  */
  always @*
    case (n3710_o)
      3'b100: n3716_o = 2'b00;
      3'b010: n3716_o = 2'b01;
      3'b001: n3716_o = 2'b00;
      default: n3716_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:595:9  */
  always @*
    case (n3710_o)
      3'b100: n3719_o = 1'b0;
      3'b010: n3719_o = 1'b1;
      3'b001: n3719_o = 1'b0;
      default: n3719_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:595:9  */
  always @*
    case (n3710_o)
      3'b100: n3721_o = 1'b0;
      3'b010: n3721_o = 1'b0;
      3'b001: n3721_o = n3697_o;
      default: n3721_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:595:9  */
  always @*
    case (n3710_o)
      3'b100: n3723_o = 1'b0;
      3'b010: n3723_o = n3705_o;
      3'b001: n3723_o = 1'b0;
      default: n3723_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:592:7  */
  assign n3725_o = n3043_o == 5'b00100;
  /* ./T65_MCode.vhd:616:14  */
  assign n3726_o = ir[7:6];
  /* ./T65_MCode.vhd:616:27  */
  assign n3728_o = n3726_o != 2'b10;
  /* ./T65_MCode.vhd:616:41  */
  assign n3729_o = ir[1];
  /* ./T65_MCode.vhd:616:35  */
  assign n3730_o = n3729_o & n3728_o;
  /* ./T65_MCode.vhd:616:60  */
  assign n3732_o = mode == 2'b00;
  /* ./T65_MCode.vhd:616:71  */
  assign n3733_o = ir[0];
  /* ./T65_MCode.vhd:616:74  */
  assign n3734_o = ~n3733_o;
  /* ./T65_MCode.vhd:616:66  */
  assign n3735_o = n3732_o | n3734_o;
  /* ./T65_MCode.vhd:616:51  */
  assign n3736_o = n3735_o & n3730_o;
  /* ./T65_MCode.vhd:619:18  */
  assign n3738_o = mode == 2'b00;
  /* ./T65_MCode.vhd:619:30  */
  assign n3739_o = ir[0];
  /* ./T65_MCode.vhd:619:24  */
  assign n3740_o = n3739_o & n3738_o;
  /* ./T65_MCode.vhd:619:11  */
  assign n3742_o = n3740_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:623:13  */
  assign n3744_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:629:22  */
  assign n3746_o = mode == 2'b00;
  /* ./T65_MCode.vhd:629:15  */
  assign n3749_o = n3746_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:627:13  */
  assign n3751_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:633:13  */
  assign n3753_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:639:22  */
  assign n3755_o = mode == 2'b00;
  /* ./T65_MCode.vhd:639:34  */
  assign n3756_o = ir[0];
  /* ./T65_MCode.vhd:639:28  */
  assign n3757_o = n3756_o & n3755_o;
  /* ./T65_MCode.vhd:639:15  */
  assign n3759_o = n3757_o ? 4'b0001 : n3042_o;
  /* ./T65_MCode.vhd:639:15  */
  assign n3762_o = n3757_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:639:15  */
  assign n3765_o = n3757_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:638:13  */
  assign n3767_o = mcycle == 3'b100;
  assign n3768_o = {n3767_o, n3753_o, n3751_o, n3744_o};
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3769_o = n3759_o;
      4'b0100: n3769_o = n3042_o;
      4'b0010: n3769_o = n3042_o;
      4'b0001: n3769_o = n3042_o;
      default: n3769_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3774_o = 2'b00;
      4'b0100: n3774_o = 2'b10;
      4'b0010: n3774_o = 2'b10;
      4'b0001: n3774_o = 2'b10;
      default: n3774_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3777_o = 2'b00;
      4'b0100: n3777_o = 2'b00;
      4'b0010: n3777_o = 2'b00;
      4'b0001: n3777_o = 2'b01;
      default: n3777_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3780_o = n3762_o;
      4'b0100: n3780_o = 1'b0;
      4'b0010: n3780_o = 1'b1;
      4'b0001: n3780_o = 1'b0;
      default: n3780_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3783_o = 1'b0;
      4'b0100: n3783_o = 1'b1;
      4'b0010: n3783_o = 1'b0;
      4'b0001: n3783_o = 1'b0;
      default: n3783_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3786_o = 1'b0;
      4'b0100: n3786_o = 1'b0;
      4'b0010: n3786_o = 1'b0;
      4'b0001: n3786_o = 1'b1;
      default: n3786_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3789_o = 1'b0;
      4'b0100: n3789_o = 1'b1;
      4'b0010: n3789_o = 1'b0;
      4'b0001: n3789_o = 1'b0;
      default: n3789_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3792_o = 1'b0;
      4'b0100: n3792_o = 1'b1;
      4'b0010: n3792_o = n3749_o;
      4'b0001: n3792_o = 1'b0;
      default: n3792_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:622:11  */
  always @*
    case (n3768_o)
      4'b1000: n3794_o = n3765_o;
      4'b0100: n3794_o = 1'b0;
      4'b0010: n3794_o = 1'b0;
      4'b0001: n3794_o = 1'b0;
      default: n3794_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:648:16  */
  assign n3795_o = ir[7:6];
  /* ./T65_MCode.vhd:648:29  */
  assign n3797_o = n3795_o != 2'b10;
  /* ./T65_MCode.vhd:648:11  */
  assign n3799_o = n3797_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:652:13  */
  assign n3801_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:656:20  */
  assign n3802_o = ir[7:5];
  /* ./T65_MCode.vhd:656:33  */
  assign n3804_o = n3802_o == 3'b100;
  /* ./T65_MCode.vhd:656:15  */
  assign n3807_o = n3804_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:653:13  */
  assign n3809_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:660:13  */
  assign n3811_o = mcycle == 3'b010;
  assign n3812_o = {n3811_o, n3809_o, n3801_o};
  /* ./T65_MCode.vhd:651:11  */
  always @*
    case (n3812_o)
      3'b100: n3815_o = 2'b00;
      3'b010: n3815_o = 2'b10;
      3'b001: n3815_o = 2'b00;
      default: n3815_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:651:11  */
  always @*
    case (n3812_o)
      3'b100: n3818_o = 2'b00;
      3'b010: n3818_o = 2'b01;
      3'b001: n3818_o = 2'b00;
      default: n3818_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:651:11  */
  always @*
    case (n3812_o)
      3'b100: n3821_o = 1'b0;
      3'b010: n3821_o = 1'b1;
      3'b001: n3821_o = 1'b0;
      default: n3821_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:651:11  */
  always @*
    case (n3812_o)
      3'b100: n3823_o = 1'b0;
      3'b010: n3823_o = n3807_o;
      3'b001: n3823_o = 1'b0;
      default: n3823_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:616:9  */
  assign n3826_o = n3736_o ? 3'b100 : 3'b010;
  /* ./T65_MCode.vhd:616:9  */
  assign n3827_o = n3736_o ? n3769_o : n3042_o;
  /* ./T65_MCode.vhd:616:9  */
  assign n3828_o = n3736_o ? n3774_o : n3815_o;
  /* ./T65_MCode.vhd:616:9  */
  assign n3829_o = n3736_o ? n3777_o : n3818_o;
  /* ./T65_MCode.vhd:616:9  */
  assign n3830_o = n3736_o ? n3742_o : n3799_o;
  /* ./T65_MCode.vhd:616:9  */
  assign n3832_o = n3736_o ? n3780_o : 1'b0;
  /* ./T65_MCode.vhd:616:9  */
  assign n3834_o = n3736_o ? n3783_o : 1'b0;
  /* ./T65_MCode.vhd:616:9  */
  assign n3835_o = n3736_o ? n3786_o : n3821_o;
  /* ./T65_MCode.vhd:616:9  */
  assign n3837_o = n3736_o ? n3789_o : 1'b0;
  /* ./T65_MCode.vhd:616:9  */
  assign n3838_o = n3736_o ? n3792_o : n3823_o;
  /* ./T65_MCode.vhd:616:9  */
  assign n3840_o = n3736_o ? n3794_o : 1'b0;
  /* ./T65_MCode.vhd:614:7  */
  assign n3842_o = n3043_o == 5'b00101;
  /* ./T65_MCode.vhd:614:20  */
  assign n3844_o = n3043_o == 5'b00110;
  /* ./T65_MCode.vhd:614:20  */
  assign n3845_o = n3842_o | n3844_o;
  /* ./T65_MCode.vhd:614:30  */
  assign n3847_o = n3043_o == 5'b00111;
  /* ./T65_MCode.vhd:614:30  */
  assign n3848_o = n3845_o | n3847_o;
  /* ./T65_MCode.vhd:668:14  */
  assign n3849_o = ir[7:6];
  /* ./T65_MCode.vhd:668:27  */
  assign n3851_o = n3849_o == 2'b01;
  /* ./T65_MCode.vhd:668:40  */
  assign n3852_o = ir[4:0];
  /* ./T65_MCode.vhd:668:53  */
  assign n3854_o = n3852_o == 5'b01100;
  /* ./T65_MCode.vhd:668:34  */
  assign n3855_o = n3854_o & n3851_o;
  /* ./T65_MCode.vhd:669:16  */
  assign n3856_o = ir[5];
  /* ./T65_MCode.vhd:669:20  */
  assign n3857_o = ~n3856_o;
  /* ./T65_MCode.vhd:672:15  */
  assign n3859_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:675:15  */
  assign n3861_o = mcycle == 3'b010;
  assign n3862_o = {n3861_o, n3859_o};
  /* ./T65_MCode.vhd:671:13  */
  always @*
    case (n3862_o)
      2'b10: n3866_o = 2'b10;
      2'b01: n3866_o = 2'b01;
      default: n3866_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:671:13  */
  always @*
    case (n3862_o)
      2'b10: n3869_o = 1'b0;
      2'b01: n3869_o = 1'b1;
      default: n3869_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:682:15  */
  assign n3871_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:688:25  */
  assign n3873_o = mode != 2'b00;
  /* ./T65_MCode.vhd:688:17  */
  assign n3876_o = n3873_o ? 2'b10 : 2'b00;
  /* ./T65_MCode.vhd:691:25  */
  assign n3878_o = mode == 2'b00;
  /* ./T65_MCode.vhd:691:17  */
  assign n3881_o = n3878_o ? 2'b11 : 2'b00;
  /* ./T65_MCode.vhd:686:15  */
  assign n3883_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:696:25  */
  assign n3885_o = mode == 2'b00;
  /* ./T65_MCode.vhd:696:17  */
  assign n3888_o = n3885_o ? 2'b11 : 2'b00;
  /* ./T65_MCode.vhd:696:17  */
  assign n3891_o = n3885_o ? 2'b00 : 2'b01;
  /* ./T65_MCode.vhd:696:17  */
  assign n3894_o = n3885_o ? 2'b01 : 2'b00;
  /* ./T65_MCode.vhd:694:15  */
  assign n3896_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:702:15  */
  assign n3898_o = mcycle == 3'b100;
  assign n3899_o = {n3898_o, n3896_o, n3883_o, n3871_o};
  /* ./T65_MCode.vhd:681:13  */
  always @*
    case (n3899_o)
      4'b1000: n3901_o = 2'b00;
      4'b0100: n3901_o = n3888_o;
      4'b0010: n3901_o = n3881_o;
      4'b0001: n3901_o = 2'b00;
      default: n3901_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:681:13  */
  always @*
    case (n3899_o)
      4'b1000: n3905_o = 2'b10;
      4'b0100: n3905_o = n3891_o;
      4'b0010: n3905_o = n3876_o;
      4'b0001: n3905_o = 2'b01;
      default: n3905_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:681:13  */
  always @*
    case (n3899_o)
      4'b1000: n3907_o = 2'b00;
      4'b0100: n3907_o = n3894_o;
      4'b0010: n3907_o = 2'b00;
      4'b0001: n3907_o = 2'b00;
      default: n3907_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:681:13  */
  always @*
    case (n3899_o)
      4'b1000: n3911_o = 1'b0;
      4'b0100: n3911_o = 1'b1;
      4'b0010: n3911_o = 1'b0;
      4'b0001: n3911_o = 1'b1;
      default: n3911_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:681:13  */
  always @*
    case (n3899_o)
      4'b1000: n3914_o = 1'b0;
      4'b0100: n3914_o = 1'b0;
      4'b0010: n3914_o = 1'b0;
      4'b0001: n3914_o = 1'b1;
      default: n3914_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:681:13  */
  always @*
    case (n3899_o)
      4'b1000: n3917_o = 1'b0;
      4'b0100: n3917_o = 1'b0;
      4'b0010: n3917_o = 1'b1;
      4'b0001: n3917_o = 1'b0;
      default: n3917_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:669:11  */
  assign n3920_o = n3857_o ? 3'b010 : 3'b100;
  /* ./T65_MCode.vhd:669:11  */
  assign n3922_o = n3857_o ? 2'b00 : n3901_o;
  /* ./T65_MCode.vhd:669:11  */
  assign n3923_o = n3857_o ? n3866_o : n3905_o;
  /* ./T65_MCode.vhd:669:11  */
  assign n3925_o = n3857_o ? 2'b00 : n3907_o;
  /* ./T65_MCode.vhd:669:11  */
  assign n3926_o = n3857_o ? n3869_o : n3911_o;
  /* ./T65_MCode.vhd:669:11  */
  assign n3928_o = n3857_o ? 1'b0 : n3914_o;
  /* ./T65_MCode.vhd:669:11  */
  assign n3930_o = n3857_o ? 1'b0 : n3917_o;
  /* ./T65_MCode.vhd:711:20  */
  assign n3931_o = ir[7:5];
  /* ./T65_MCode.vhd:711:33  */
  assign n3933_o = n3931_o == 3'b001;
  /* ./T65_MCode.vhd:711:15  */
  assign n3936_o = n3933_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:710:13  */
  assign n3938_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:714:13  */
  assign n3940_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:720:20  */
  assign n3941_o = ir[7:5];
  /* ./T65_MCode.vhd:720:33  */
  assign n3943_o = n3941_o == 3'b100;
  /* ./T65_MCode.vhd:720:15  */
  assign n3946_o = n3943_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:717:13  */
  assign n3948_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:724:13  */
  assign n3950_o = mcycle == 3'b011;
  assign n3951_o = {n3950_o, n3948_o, n3940_o, n3938_o};
  /* ./T65_MCode.vhd:709:11  */
  always @*
    case (n3951_o)
      4'b1000: n3954_o = 2'b00;
      4'b0100: n3954_o = 2'b11;
      4'b0010: n3954_o = 2'b00;
      4'b0001: n3954_o = 2'b00;
      default: n3954_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:709:11  */
  always @*
    case (n3951_o)
      4'b1000: n3958_o = 2'b00;
      4'b0100: n3958_o = 2'b01;
      4'b0010: n3958_o = 2'b01;
      4'b0001: n3958_o = 2'b00;
      default: n3958_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:709:11  */
  always @*
    case (n3951_o)
      4'b1000: n3961_o = 1'b0;
      4'b0100: n3961_o = 1'b0;
      4'b0010: n3961_o = 1'b1;
      4'b0001: n3961_o = 1'b0;
      default: n3961_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:709:11  */
  always @*
    case (n3951_o)
      4'b1000: n3964_o = 1'b0;
      4'b0100: n3964_o = 1'b1;
      4'b0010: n3964_o = 1'b0;
      4'b0001: n3964_o = 1'b0;
      default: n3964_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:709:11  */
  always @*
    case (n3951_o)
      4'b1000: n3966_o = 1'b0;
      4'b0100: n3966_o = 1'b0;
      4'b0010: n3966_o = 1'b0;
      4'b0001: n3966_o = n3936_o;
      default: n3966_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:709:11  */
  always @*
    case (n3951_o)
      4'b1000: n3968_o = 1'b0;
      4'b0100: n3968_o = n3946_o;
      4'b0010: n3968_o = 1'b0;
      4'b0001: n3968_o = 1'b0;
      default: n3968_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:668:9  */
  assign n3970_o = n3855_o ? n3920_o : 3'b011;
  /* ./T65_MCode.vhd:668:9  */
  assign n3971_o = n3855_o ? n3922_o : n3954_o;
  /* ./T65_MCode.vhd:668:9  */
  assign n3972_o = n3855_o ? n3923_o : n3958_o;
  /* ./T65_MCode.vhd:668:9  */
  assign n3974_o = n3855_o ? n3925_o : 2'b00;
  /* ./T65_MCode.vhd:668:9  */
  assign n3976_o = n3855_o ? n3926_o : 1'b0;
  /* ./T65_MCode.vhd:668:9  */
  assign n3977_o = n3855_o ? n3928_o : n3961_o;
  /* ./T65_MCode.vhd:668:9  */
  assign n3978_o = n3855_o ? n3930_o : n3964_o;
  /* ./T65_MCode.vhd:668:9  */
  assign n3980_o = n3855_o ? 1'b0 : n3966_o;
  /* ./T65_MCode.vhd:668:9  */
  assign n3982_o = n3855_o ? 1'b0 : n3968_o;
  /* ./T65_MCode.vhd:666:7  */
  assign n3984_o = n3043_o == 5'b01100;
  /* ./T65_MCode.vhd:734:14  */
  assign n3985_o = ir[7:6];
  /* ./T65_MCode.vhd:734:27  */
  assign n3987_o = n3985_o != 2'b10;
  /* ./T65_MCode.vhd:734:41  */
  assign n3988_o = ir[1];
  /* ./T65_MCode.vhd:734:35  */
  assign n3989_o = n3988_o & n3987_o;
  /* ./T65_MCode.vhd:734:60  */
  assign n3991_o = mode == 2'b00;
  /* ./T65_MCode.vhd:734:71  */
  assign n3992_o = ir[0];
  /* ./T65_MCode.vhd:734:74  */
  assign n3993_o = ~n3992_o;
  /* ./T65_MCode.vhd:734:66  */
  assign n3994_o = n3991_o | n3993_o;
  /* ./T65_MCode.vhd:734:51  */
  assign n3995_o = n3994_o & n3989_o;
  /* ./T65_MCode.vhd:737:18  */
  assign n3997_o = mode == 2'b00;
  /* ./T65_MCode.vhd:737:30  */
  assign n3998_o = ir[0];
  /* ./T65_MCode.vhd:737:24  */
  assign n3999_o = n3998_o & n3997_o;
  /* ./T65_MCode.vhd:737:11  */
  assign n4001_o = n3999_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:741:13  */
  assign n4003_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:744:13  */
  assign n4005_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:750:22  */
  assign n4007_o = mode == 2'b00;
  /* ./T65_MCode.vhd:750:15  */
  assign n4010_o = n4007_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:748:13  */
  assign n4012_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:754:13  */
  assign n4014_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:760:22  */
  assign n4016_o = mode == 2'b00;
  /* ./T65_MCode.vhd:760:34  */
  assign n4017_o = ir[0];
  /* ./T65_MCode.vhd:760:28  */
  assign n4018_o = n4017_o & n4016_o;
  /* ./T65_MCode.vhd:760:15  */
  assign n4020_o = n4018_o ? 4'b0001 : n3042_o;
  /* ./T65_MCode.vhd:760:15  */
  assign n4023_o = n4018_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:759:13  */
  assign n4025_o = mcycle == 3'b101;
  assign n4026_o = {n4025_o, n4014_o, n4012_o, n4005_o, n4003_o};
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4027_o = n4020_o;
      5'b01000: n4027_o = n3042_o;
      5'b00100: n4027_o = n3042_o;
      5'b00010: n4027_o = n3042_o;
      5'b00001: n4027_o = n3042_o;
      default: n4027_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4032_o = 2'b00;
      5'b01000: n4032_o = 2'b11;
      5'b00100: n4032_o = 2'b11;
      5'b00010: n4032_o = 2'b11;
      5'b00001: n4032_o = 2'b00;
      default: n4032_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4036_o = 2'b00;
      5'b01000: n4036_o = 2'b00;
      5'b00100: n4036_o = 2'b00;
      5'b00010: n4036_o = 2'b01;
      5'b00001: n4036_o = 2'b01;
      default: n4036_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4039_o = 1'b0;
      5'b01000: n4039_o = 1'b0;
      5'b00100: n4039_o = 1'b1;
      5'b00010: n4039_o = 1'b0;
      5'b00001: n4039_o = 1'b0;
      default: n4039_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4042_o = 1'b0;
      5'b01000: n4042_o = 1'b1;
      5'b00100: n4042_o = 1'b0;
      5'b00010: n4042_o = 1'b0;
      5'b00001: n4042_o = 1'b0;
      default: n4042_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4045_o = 1'b0;
      5'b01000: n4045_o = 1'b0;
      5'b00100: n4045_o = 1'b0;
      5'b00010: n4045_o = 1'b0;
      5'b00001: n4045_o = 1'b1;
      default: n4045_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4048_o = 1'b0;
      5'b01000: n4048_o = 1'b0;
      5'b00100: n4048_o = 1'b0;
      5'b00010: n4048_o = 1'b1;
      5'b00001: n4048_o = 1'b0;
      default: n4048_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4051_o = 1'b0;
      5'b01000: n4051_o = 1'b1;
      5'b00100: n4051_o = 1'b0;
      5'b00010: n4051_o = 1'b0;
      5'b00001: n4051_o = 1'b0;
      default: n4051_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4054_o = 1'b0;
      5'b01000: n4054_o = 1'b1;
      5'b00100: n4054_o = n4010_o;
      5'b00010: n4054_o = 1'b0;
      5'b00001: n4054_o = 1'b0;
      default: n4054_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:740:11  */
  always @*
    case (n4026_o)
      5'b10000: n4056_o = n4023_o;
      5'b01000: n4056_o = 1'b0;
      5'b00100: n4056_o = 1'b0;
      5'b00010: n4056_o = 1'b0;
      5'b00001: n4056_o = 1'b0;
      default: n4056_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:768:16  */
  assign n4057_o = ir[7:6];
  /* ./T65_MCode.vhd:768:29  */
  assign n4059_o = n4057_o != 2'b10;
  /* ./T65_MCode.vhd:768:11  */
  assign n4061_o = n4059_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:772:13  */
  assign n4063_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:773:13  */
  assign n4065_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:779:20  */
  assign n4066_o = ir[7:5];
  /* ./T65_MCode.vhd:779:33  */
  assign n4068_o = n4066_o == 3'b100;
  /* ./T65_MCode.vhd:779:15  */
  assign n4071_o = n4068_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:776:13  */
  assign n4073_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:783:13  */
  assign n4075_o = mcycle == 3'b011;
  assign n4076_o = {n4075_o, n4073_o, n4065_o, n4063_o};
  /* ./T65_MCode.vhd:771:11  */
  always @*
    case (n4076_o)
      4'b1000: n4079_o = 2'b00;
      4'b0100: n4079_o = 2'b11;
      4'b0010: n4079_o = 2'b00;
      4'b0001: n4079_o = 2'b00;
      default: n4079_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:771:11  */
  always @*
    case (n4076_o)
      4'b1000: n4083_o = 2'b00;
      4'b0100: n4083_o = 2'b01;
      4'b0010: n4083_o = 2'b01;
      4'b0001: n4083_o = 2'b00;
      default: n4083_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:771:11  */
  always @*
    case (n4076_o)
      4'b1000: n4086_o = 1'b0;
      4'b0100: n4086_o = 1'b0;
      4'b0010: n4086_o = 1'b1;
      4'b0001: n4086_o = 1'b0;
      default: n4086_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:771:11  */
  always @*
    case (n4076_o)
      4'b1000: n4089_o = 1'b0;
      4'b0100: n4089_o = 1'b1;
      4'b0010: n4089_o = 1'b0;
      4'b0001: n4089_o = 1'b0;
      default: n4089_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:771:11  */
  always @*
    case (n4076_o)
      4'b1000: n4091_o = 1'b0;
      4'b0100: n4091_o = n4071_o;
      4'b0010: n4091_o = 1'b0;
      4'b0001: n4091_o = 1'b0;
      default: n4091_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:734:9  */
  assign n4094_o = n3995_o ? 3'b101 : 3'b011;
  /* ./T65_MCode.vhd:734:9  */
  assign n4095_o = n3995_o ? n4027_o : n3042_o;
  /* ./T65_MCode.vhd:734:9  */
  assign n4096_o = n3995_o ? n4032_o : n4079_o;
  /* ./T65_MCode.vhd:734:9  */
  assign n4097_o = n3995_o ? n4036_o : n4083_o;
  /* ./T65_MCode.vhd:734:9  */
  assign n4098_o = n3995_o ? n4001_o : n4061_o;
  /* ./T65_MCode.vhd:734:9  */
  assign n4100_o = n3995_o ? n4039_o : 1'b0;
  /* ./T65_MCode.vhd:734:9  */
  assign n4102_o = n3995_o ? n4042_o : 1'b0;
  /* ./T65_MCode.vhd:734:9  */
  assign n4103_o = n3995_o ? n4045_o : n4086_o;
  /* ./T65_MCode.vhd:734:9  */
  assign n4104_o = n3995_o ? n4048_o : n4089_o;
  /* ./T65_MCode.vhd:734:9  */
  assign n4106_o = n3995_o ? n4051_o : 1'b0;
  /* ./T65_MCode.vhd:734:9  */
  assign n4107_o = n3995_o ? n4054_o : n4091_o;
  /* ./T65_MCode.vhd:734:9  */
  assign n4109_o = n3995_o ? n4056_o : 1'b0;
  /* ./T65_MCode.vhd:732:7  */
  assign n4111_o = n3043_o == 5'b01101;
  /* ./T65_MCode.vhd:732:20  */
  assign n4113_o = n3043_o == 5'b01110;
  /* ./T65_MCode.vhd:732:20  */
  assign n4114_o = n4111_o | n4113_o;
  /* ./T65_MCode.vhd:732:30  */
  assign n4116_o = n3043_o == 5'b01111;
  /* ./T65_MCode.vhd:732:30  */
  assign n4117_o = n4114_o | n4116_o;
  /* ./T65_MCode.vhd:795:9  */
  assign n4120_o = branch ? 3'b011 : 3'b001;
  /* ./T65_MCode.vhd:809:11  */
  assign n4122_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:820:11  */
  assign n4124_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:829:11  */
  assign n4126_o = mcycle == 3'b011;
  assign n4127_o = {n4126_o, n4124_o, n4122_o};
  /* ./T65_MCode.vhd:804:9  */
  always @*
    case (n4127_o)
      3'b100: n4131_o = 2'b00;
      3'b010: n4131_o = 2'b11;
      3'b001: n4131_o = 2'b01;
      default: n4131_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:804:9  */
  always @*
    case (n4127_o)
      3'b100: n4134_o = 1'b0;
      3'b010: n4134_o = 1'b1;
      3'b001: n4134_o = 1'b0;
      default: n4134_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:804:9  */
  always @*
    case (n4127_o)
      3'b100: n4137_o = 1'b0;
      3'b010: n4137_o = 1'b0;
      3'b001: n4137_o = 1'b1;
      default: n4137_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:789:7  */
  assign n4139_o = n3043_o == 5'b10000;
  /* ./T65_MCode.vhd:837:14  */
  assign n4140_o = ir[7:6];
  /* ./T65_MCode.vhd:837:27  */
  assign n4142_o = n4140_o != 2'b10;
  /* ./T65_MCode.vhd:839:18  */
  assign n4144_o = mode == 2'b00;
  /* ./T65_MCode.vhd:839:30  */
  assign n4145_o = ir[1];
  /* ./T65_MCode.vhd:839:24  */
  assign n4146_o = n4145_o & n4144_o;
  /* ./T65_MCode.vhd:839:11  */
  assign n4149_o = n4146_o ? 3'b111 : 3'b101;
  /* ./T65_MCode.vhd:837:9  */
  assign n4151_o = n4142_o ? n4149_o : 3'b101;
  /* ./T65_MCode.vhd:837:9  */
  assign n4154_o = n4142_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:844:11  */
  assign n4156_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:848:11  */
  assign n4158_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:852:11  */
  assign n4160_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:859:18  */
  assign n4161_o = ir[7:5];
  /* ./T65_MCode.vhd:859:31  */
  assign n4163_o = n4161_o == 3'b100;
  /* ./T65_MCode.vhd:861:20  */
  assign n4164_o = ir[3:0];
  /* ./T65_MCode.vhd:861:33  */
  assign n4166_o = n4164_o == 4'b0011;
  /* ./T65_MCode.vhd:861:15  */
  assign n4169_o = n4166_o ? 2'b10 : 2'b00;
  /* ./T65_MCode.vhd:864:21  */
  assign n4170_o = ir[1];
  /* ./T65_MCode.vhd:864:24  */
  assign n4171_o = ~n4170_o;
  /* ./T65_MCode.vhd:864:34  */
  assign n4173_o = ir == 8'b10110011;
  /* ./T65_MCode.vhd:864:29  */
  assign n4174_o = n4171_o | n4173_o;
  /* ./T65_MCode.vhd:864:13  */
  assign n4177_o = n4174_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:859:13  */
  assign n4179_o = n4163_o ? n4169_o : 2'b00;
  /* ./T65_MCode.vhd:859:13  */
  assign n4181_o = n4163_o ? 1'b0 : n4177_o;
  /* ./T65_MCode.vhd:859:13  */
  assign n4184_o = n4163_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:857:11  */
  assign n4186_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:869:20  */
  assign n4188_o = mode == 2'b00;
  /* ./T65_MCode.vhd:869:32  */
  assign n4189_o = ir[1];
  /* ./T65_MCode.vhd:869:26  */
  assign n4190_o = n4189_o & n4188_o;
  /* ./T65_MCode.vhd:869:46  */
  assign n4191_o = ir[7:6];
  /* ./T65_MCode.vhd:869:58  */
  assign n4193_o = n4191_o != 2'b10;
  /* ./T65_MCode.vhd:869:40  */
  assign n4194_o = n4193_o & n4190_o;
  /* ./T65_MCode.vhd:869:13  */
  assign n4197_o = n4194_o ? 2'b11 : 2'b00;
  /* ./T65_MCode.vhd:869:13  */
  assign n4200_o = n4194_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:869:13  */
  assign n4203_o = n4194_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:868:11  */
  assign n4205_o = mcycle == 3'b101;
  /* ./T65_MCode.vhd:874:11  */
  assign n4207_o = mcycle == 3'b110;
  /* ./T65_MCode.vhd:879:11  */
  assign n4209_o = mcycle == 3'b111;
  assign n4210_o = {n4209_o, n4207_o, n4205_o, n4186_o, n4160_o, n4158_o, n4156_o};
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4213_o = 4'b0001;
      7'b0100000: n4213_o = n3042_o;
      7'b0010000: n4213_o = n3042_o;
      7'b0001000: n4213_o = n3042_o;
      7'b0000100: n4213_o = 4'b0011;
      7'b0000010: n4213_o = n3042_o;
      7'b0000001: n4213_o = n3042_o;
      default: n4213_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4220_o = 2'b00;
      7'b0100000: n4220_o = 2'b11;
      7'b0010000: n4220_o = n4197_o;
      7'b0001000: n4220_o = 2'b11;
      7'b0000100: n4220_o = 2'b11;
      7'b0000010: n4220_o = 2'b10;
      7'b0000001: n4220_o = 2'b10;
      default: n4220_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4223_o = 2'b00;
      7'b0100000: n4223_o = 2'b00;
      7'b0010000: n4223_o = 2'b00;
      7'b0001000: n4223_o = 2'b00;
      7'b0000100: n4223_o = 2'b00;
      7'b0000010: n4223_o = 2'b00;
      7'b0000001: n4223_o = 2'b01;
      default: n4223_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4228_o = 2'b00;
      7'b0100000: n4228_o = 2'b00;
      7'b0010000: n4228_o = 2'b00;
      7'b0001000: n4228_o = 2'b11;
      7'b0000100: n4228_o = 2'b10;
      7'b0000010: n4228_o = 2'b01;
      7'b0000001: n4228_o = 2'b00;
      default: n4228_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4230_o = 2'b00;
      7'b0100000: n4230_o = 2'b00;
      7'b0010000: n4230_o = 2'b00;
      7'b0001000: n4230_o = n4179_o;
      7'b0000100: n4230_o = 2'b00;
      7'b0000010: n4230_o = 2'b00;
      7'b0000001: n4230_o = 2'b00;
      default: n4230_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4232_o = 1'b0;
      7'b0100000: n4232_o = 1'b0;
      7'b0010000: n4232_o = 1'b0;
      7'b0001000: n4232_o = n4181_o;
      7'b0000100: n4232_o = 1'b0;
      7'b0000010: n4232_o = 1'b0;
      7'b0000001: n4232_o = 1'b0;
      default: n4232_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4234_o = 1'b0;
      7'b0100000: n4234_o = 1'b0;
      7'b0010000: n4234_o = n4200_o;
      7'b0001000: n4234_o = 1'b0;
      7'b0000100: n4234_o = 1'b0;
      7'b0000010: n4234_o = 1'b0;
      7'b0000001: n4234_o = 1'b0;
      default: n4234_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4237_o = 1'b0;
      7'b0100000: n4237_o = 1'b1;
      7'b0010000: n4237_o = 1'b0;
      7'b0001000: n4237_o = 1'b0;
      7'b0000100: n4237_o = 1'b0;
      7'b0000010: n4237_o = 1'b0;
      7'b0000001: n4237_o = 1'b0;
      default: n4237_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4240_o = 1'b0;
      7'b0100000: n4240_o = 1'b0;
      7'b0010000: n4240_o = 1'b0;
      7'b0001000: n4240_o = 1'b0;
      7'b0000100: n4240_o = 1'b0;
      7'b0000010: n4240_o = 1'b0;
      7'b0000001: n4240_o = 1'b1;
      default: n4240_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4243_o = 1'b0;
      7'b0100000: n4243_o = 1'b0;
      7'b0010000: n4243_o = 1'b0;
      7'b0001000: n4243_o = 1'b0;
      7'b0000100: n4243_o = 1'b0;
      7'b0000010: n4243_o = 1'b1;
      7'b0000001: n4243_o = 1'b0;
      default: n4243_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4246_o = 1'b0;
      7'b0100000: n4246_o = 1'b0;
      7'b0010000: n4246_o = 1'b0;
      7'b0001000: n4246_o = 1'b0;
      7'b0000100: n4246_o = 1'b1;
      7'b0000010: n4246_o = 1'b0;
      7'b0000001: n4246_o = 1'b0;
      default: n4246_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4249_o = 1'b0;
      7'b0100000: n4249_o = 1'b1;
      7'b0010000: n4249_o = 1'b0;
      7'b0001000: n4249_o = 1'b0;
      7'b0000100: n4249_o = 1'b0;
      7'b0000010: n4249_o = 1'b0;
      7'b0000001: n4249_o = 1'b0;
      default: n4249_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4252_o = 1'b0;
      7'b0100000: n4252_o = 1'b1;
      7'b0010000: n4252_o = n4203_o;
      7'b0001000: n4252_o = n4184_o;
      7'b0000100: n4252_o = 1'b0;
      7'b0000010: n4252_o = 1'b0;
      7'b0000001: n4252_o = 1'b0;
      default: n4252_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:843:9  */
  always @*
    case (n4210_o)
      7'b1000000: n4255_o = 1'b1;
      7'b0100000: n4255_o = 1'b0;
      7'b0010000: n4255_o = 1'b0;
      7'b0001000: n4255_o = 1'b0;
      7'b0000100: n4255_o = 1'b0;
      7'b0000010: n4255_o = 1'b0;
      7'b0000001: n4255_o = 1'b0;
      default: n4255_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:835:7  */
  assign n4257_o = n3043_o == 5'b10001;
  /* ./T65_MCode.vhd:835:20  */
  assign n4259_o = n3043_o == 5'b10011;
  /* ./T65_MCode.vhd:835:20  */
  assign n4260_o = n4257_o | n4259_o;
  /* ./T65_MCode.vhd:891:14  */
  assign n4261_o = ir[7:6];
  /* ./T65_MCode.vhd:891:27  */
  assign n4263_o = n4261_o != 2'b10;
  /* ./T65_MCode.vhd:891:41  */
  assign n4264_o = ir[1];
  /* ./T65_MCode.vhd:891:35  */
  assign n4265_o = n4264_o & n4263_o;
  /* ./T65_MCode.vhd:891:60  */
  assign n4267_o = mode == 2'b00;
  /* ./T65_MCode.vhd:891:71  */
  assign n4268_o = ir[0];
  /* ./T65_MCode.vhd:891:74  */
  assign n4269_o = ~n4268_o;
  /* ./T65_MCode.vhd:891:66  */
  assign n4270_o = n4267_o | n4269_o;
  /* ./T65_MCode.vhd:891:51  */
  assign n4271_o = n4270_o & n4265_o;
  /* ./T65_MCode.vhd:893:18  */
  assign n4273_o = mode == 2'b00;
  /* ./T65_MCode.vhd:893:30  */
  assign n4274_o = ir[0];
  /* ./T65_MCode.vhd:893:24  */
  assign n4275_o = n4274_o & n4273_o;
  /* ./T65_MCode.vhd:893:11  */
  assign n4277_o = n4275_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:898:13  */
  assign n4279_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:902:13  */
  assign n4281_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:907:22  */
  assign n4283_o = mode == 2'b00;
  /* ./T65_MCode.vhd:907:15  */
  assign n4286_o = n4283_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:905:13  */
  assign n4288_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:916:22  */
  assign n4290_o = mode == 2'b00;
  /* ./T65_MCode.vhd:916:34  */
  assign n4291_o = ir[0];
  /* ./T65_MCode.vhd:916:28  */
  assign n4292_o = n4291_o & n4290_o;
  /* ./T65_MCode.vhd:916:15  */
  assign n4295_o = n4292_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:911:13  */
  assign n4297_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:920:22  */
  assign n4299_o = mode == 2'b00;
  /* ./T65_MCode.vhd:920:34  */
  assign n4300_o = ir[0];
  /* ./T65_MCode.vhd:920:28  */
  assign n4301_o = n4300_o & n4299_o;
  /* ./T65_MCode.vhd:920:15  */
  assign n4303_o = n4301_o ? 4'b0001 : n3042_o;
  /* ./T65_MCode.vhd:920:15  */
  assign n4306_o = n4301_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:919:13  */
  assign n4308_o = mcycle == 3'b101;
  assign n4309_o = {n4308_o, n4297_o, n4288_o, n4281_o, n4279_o};
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4310_o = n4303_o;
      5'b01000: n4310_o = n3042_o;
      5'b00100: n4310_o = n3042_o;
      5'b00010: n4310_o = n3042_o;
      5'b00001: n4310_o = n3042_o;
      default: n4310_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4316_o = 2'b00;
      5'b01000: n4316_o = 2'b10;
      5'b00100: n4316_o = 2'b10;
      5'b00010: n4316_o = 2'b10;
      5'b00001: n4316_o = 2'b10;
      default: n4316_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4319_o = 2'b00;
      5'b01000: n4319_o = 2'b00;
      5'b00100: n4319_o = 2'b00;
      5'b00010: n4319_o = 2'b00;
      5'b00001: n4319_o = 2'b01;
      default: n4319_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4322_o = 1'b0;
      5'b01000: n4322_o = 1'b0;
      5'b00100: n4322_o = 1'b0;
      5'b00010: n4322_o = 1'b1;
      5'b00001: n4322_o = 1'b0;
      default: n4322_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4325_o = 1'b0;
      5'b01000: n4325_o = n4295_o;
      5'b00100: n4325_o = 1'b1;
      5'b00010: n4325_o = 1'b0;
      5'b00001: n4325_o = 1'b0;
      default: n4325_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4328_o = 1'b0;
      5'b01000: n4328_o = 1'b1;
      5'b00100: n4328_o = 1'b0;
      5'b00010: n4328_o = 1'b0;
      5'b00001: n4328_o = 1'b0;
      default: n4328_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4331_o = 1'b0;
      5'b01000: n4331_o = 1'b0;
      5'b00100: n4331_o = 1'b0;
      5'b00010: n4331_o = 1'b0;
      5'b00001: n4331_o = 1'b1;
      default: n4331_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4334_o = 1'b0;
      5'b01000: n4334_o = 1'b1;
      5'b00100: n4334_o = 1'b0;
      5'b00010: n4334_o = 1'b0;
      5'b00001: n4334_o = 1'b0;
      default: n4334_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4337_o = 1'b0;
      5'b01000: n4337_o = 1'b1;
      5'b00100: n4337_o = n4286_o;
      5'b00010: n4337_o = 1'b0;
      5'b00001: n4337_o = 1'b0;
      default: n4337_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:897:11  */
  always @*
    case (n4309_o)
      5'b10000: n4339_o = n4306_o;
      5'b01000: n4339_o = 1'b0;
      5'b00100: n4339_o = 1'b0;
      5'b00010: n4339_o = 1'b0;
      5'b00001: n4339_o = 1'b0;
      default: n4339_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:928:16  */
  assign n4340_o = ir[7:6];
  /* ./T65_MCode.vhd:928:29  */
  assign n4342_o = n4340_o != 2'b10;
  /* ./T65_MCode.vhd:928:43  */
  assign n4343_o = ir[0];
  /* ./T65_MCode.vhd:928:37  */
  assign n4344_o = n4343_o & n4342_o;
  /* ./T65_MCode.vhd:928:11  */
  assign n4346_o = n4344_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:932:13  */
  assign n4348_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:933:13  */
  assign n4350_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:940:21  */
  assign n4351_o = ir[3:1];
  /* ./T65_MCode.vhd:940:34  */
  assign n4353_o = n4351_o == 3'b011;
  /* ./T65_MCode.vhd:940:15  */
  assign n4356_o = n4353_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:943:20  */
  assign n4357_o = ir[7:5];
  /* ./T65_MCode.vhd:943:33  */
  assign n4359_o = n4357_o == 3'b100;
  /* ./T65_MCode.vhd:943:15  */
  assign n4362_o = n4359_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:937:13  */
  assign n4364_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:947:13  */
  assign n4366_o = mcycle == 3'b011;
  assign n4367_o = {n4366_o, n4364_o, n4350_o, n4348_o};
  /* ./T65_MCode.vhd:931:11  */
  always @*
    case (n4367_o)
      4'b1000: n4371_o = 2'b00;
      4'b0100: n4371_o = 2'b10;
      4'b0010: n4371_o = 2'b10;
      4'b0001: n4371_o = 2'b00;
      default: n4371_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:931:11  */
  always @*
    case (n4367_o)
      4'b1000: n4374_o = 2'b00;
      4'b0100: n4374_o = 2'b00;
      4'b0010: n4374_o = 2'b01;
      4'b0001: n4374_o = 2'b00;
      default: n4374_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:931:11  */
  always @*
    case (n4367_o)
      4'b1000: n4377_o = 1'b0;
      4'b0100: n4377_o = 1'b1;
      4'b0010: n4377_o = 1'b0;
      4'b0001: n4377_o = 1'b0;
      default: n4377_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:931:11  */
  always @*
    case (n4367_o)
      4'b1000: n4379_o = 1'b0;
      4'b0100: n4379_o = n4356_o;
      4'b0010: n4379_o = 1'b0;
      4'b0001: n4379_o = 1'b0;
      default: n4379_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:931:11  */
  always @*
    case (n4367_o)
      4'b1000: n4382_o = 1'b0;
      4'b0100: n4382_o = 1'b0;
      4'b0010: n4382_o = 1'b1;
      4'b0001: n4382_o = 1'b0;
      default: n4382_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:931:11  */
  always @*
    case (n4367_o)
      4'b1000: n4384_o = 1'b0;
      4'b0100: n4384_o = n4362_o;
      4'b0010: n4384_o = 1'b0;
      4'b0001: n4384_o = 1'b0;
      default: n4384_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:891:9  */
  assign n4387_o = n4271_o ? 3'b101 : 3'b011;
  /* ./T65_MCode.vhd:891:9  */
  assign n4388_o = n4271_o ? n4310_o : n3042_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4389_o = n4271_o ? n4316_o : n4371_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4390_o = n4271_o ? n4319_o : n4374_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4391_o = n4271_o ? n4322_o : n4377_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4393_o = n4271_o ? 1'b0 : n4379_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4394_o = n4271_o ? n4277_o : n4346_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4396_o = n4271_o ? n4325_o : 1'b0;
  /* ./T65_MCode.vhd:891:9  */
  assign n4398_o = n4271_o ? n4328_o : 1'b0;
  /* ./T65_MCode.vhd:891:9  */
  assign n4399_o = n4271_o ? n4331_o : n4382_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4401_o = n4271_o ? n4334_o : 1'b0;
  /* ./T65_MCode.vhd:891:9  */
  assign n4402_o = n4271_o ? n4337_o : n4384_o;
  /* ./T65_MCode.vhd:891:9  */
  assign n4404_o = n4271_o ? n4339_o : 1'b0;
  /* ./T65_MCode.vhd:889:7  */
  assign n4406_o = n3043_o == 5'b10100;
  /* ./T65_MCode.vhd:889:20  */
  assign n4408_o = n3043_o == 5'b10101;
  /* ./T65_MCode.vhd:889:20  */
  assign n4409_o = n4406_o | n4408_o;
  /* ./T65_MCode.vhd:889:30  */
  assign n4411_o = n3043_o == 5'b10110;
  /* ./T65_MCode.vhd:889:30  */
  assign n4412_o = n4409_o | n4411_o;
  /* ./T65_MCode.vhd:889:40  */
  assign n4414_o = n3043_o == 5'b10111;
  /* ./T65_MCode.vhd:889:40  */
  assign n4415_o = n4412_o | n4414_o;
  /* ./T65_MCode.vhd:957:14  */
  assign n4416_o = ir[7:6];
  /* ./T65_MCode.vhd:957:27  */
  assign n4418_o = n4416_o != 2'b10;
  /* ./T65_MCode.vhd:959:18  */
  assign n4420_o = mode == 2'b00;
  /* ./T65_MCode.vhd:959:30  */
  assign n4421_o = ir[1];
  /* ./T65_MCode.vhd:959:24  */
  assign n4422_o = n4421_o & n4420_o;
  /* ./T65_MCode.vhd:959:11  */
  assign n4425_o = n4422_o ? 3'b110 : 3'b100;
  /* ./T65_MCode.vhd:957:9  */
  assign n4427_o = n4418_o ? n4425_o : 3'b100;
  /* ./T65_MCode.vhd:957:9  */
  assign n4430_o = n4418_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:964:11  */
  assign n4432_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:967:11  */
  assign n4434_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:975:18  */
  assign n4435_o = ir[7:5];
  /* ./T65_MCode.vhd:975:31  */
  assign n4437_o = n4435_o == 3'b100;
  /* ./T65_MCode.vhd:977:20  */
  assign n4438_o = ir[3:0];
  /* ./T65_MCode.vhd:977:33  */
  assign n4440_o = n4438_o == 4'b1011;
  /* ./T65_MCode.vhd:977:15  */
  assign n4443_o = n4440_o ? 2'b01 : 2'b00;
  /* ./T65_MCode.vhd:980:21  */
  assign n4444_o = ir[1];
  /* ./T65_MCode.vhd:980:24  */
  assign n4445_o = ~n4444_o;
  /* ./T65_MCode.vhd:980:34  */
  assign n4447_o = ir == 8'b10111011;
  /* ./T65_MCode.vhd:980:29  */
  assign n4448_o = n4445_o | n4447_o;
  /* ./T65_MCode.vhd:980:13  */
  assign n4451_o = n4448_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:975:13  */
  assign n4453_o = n4437_o ? n4443_o : 2'b00;
  /* ./T65_MCode.vhd:975:13  */
  assign n4455_o = n4437_o ? 1'b0 : n4451_o;
  /* ./T65_MCode.vhd:975:13  */
  assign n4458_o = n4437_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:973:11  */
  assign n4460_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:985:20  */
  assign n4462_o = mode == 2'b00;
  /* ./T65_MCode.vhd:985:32  */
  assign n4463_o = ir[1];
  /* ./T65_MCode.vhd:985:26  */
  assign n4464_o = n4463_o & n4462_o;
  /* ./T65_MCode.vhd:985:46  */
  assign n4465_o = ir[7:6];
  /* ./T65_MCode.vhd:985:58  */
  assign n4467_o = n4465_o != 2'b10;
  /* ./T65_MCode.vhd:985:40  */
  assign n4468_o = n4467_o & n4464_o;
  /* ./T65_MCode.vhd:985:13  */
  assign n4471_o = n4468_o ? 2'b11 : 2'b00;
  /* ./T65_MCode.vhd:985:13  */
  assign n4474_o = n4468_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:985:13  */
  assign n4477_o = n4468_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:984:11  */
  assign n4479_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:990:11  */
  assign n4481_o = mcycle == 3'b101;
  /* ./T65_MCode.vhd:995:11  */
  assign n4483_o = mcycle == 3'b110;
  assign n4484_o = {n4483_o, n4481_o, n4479_o, n4460_o, n4434_o, n4432_o};
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4487_o = 4'b0001;
      6'b010000: n4487_o = n3042_o;
      6'b001000: n4487_o = n3042_o;
      6'b000100: n4487_o = n3042_o;
      6'b000010: n4487_o = 4'b0011;
      6'b000001: n4487_o = n3042_o;
      default: n4487_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4492_o = 2'b00;
      6'b010000: n4492_o = 2'b11;
      6'b001000: n4492_o = n4471_o;
      6'b000100: n4492_o = 2'b11;
      6'b000010: n4492_o = 2'b11;
      6'b000001: n4492_o = 2'b00;
      default: n4492_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4496_o = 2'b00;
      6'b010000: n4496_o = 2'b00;
      6'b001000: n4496_o = 2'b00;
      6'b000100: n4496_o = 2'b00;
      6'b000010: n4496_o = 2'b01;
      6'b000001: n4496_o = 2'b01;
      default: n4496_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4500_o = 2'b00;
      6'b010000: n4500_o = 2'b00;
      6'b001000: n4500_o = 2'b00;
      6'b000100: n4500_o = 2'b11;
      6'b000010: n4500_o = 2'b10;
      6'b000001: n4500_o = 2'b00;
      default: n4500_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4502_o = 2'b00;
      6'b010000: n4502_o = 2'b00;
      6'b001000: n4502_o = 2'b00;
      6'b000100: n4502_o = n4453_o;
      6'b000010: n4502_o = 2'b00;
      6'b000001: n4502_o = 2'b00;
      default: n4502_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4504_o = 1'b0;
      6'b010000: n4504_o = 1'b0;
      6'b001000: n4504_o = 1'b0;
      6'b000100: n4504_o = n4455_o;
      6'b000010: n4504_o = 1'b0;
      6'b000001: n4504_o = 1'b0;
      default: n4504_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4506_o = 1'b0;
      6'b010000: n4506_o = 1'b0;
      6'b001000: n4506_o = n4474_o;
      6'b000100: n4506_o = 1'b0;
      6'b000010: n4506_o = 1'b0;
      6'b000001: n4506_o = 1'b0;
      default: n4506_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4509_o = 1'b0;
      6'b010000: n4509_o = 1'b1;
      6'b001000: n4509_o = 1'b0;
      6'b000100: n4509_o = 1'b0;
      6'b000010: n4509_o = 1'b0;
      6'b000001: n4509_o = 1'b0;
      default: n4509_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4512_o = 1'b0;
      6'b010000: n4512_o = 1'b0;
      6'b001000: n4512_o = 1'b0;
      6'b000100: n4512_o = 1'b0;
      6'b000010: n4512_o = 1'b0;
      6'b000001: n4512_o = 1'b1;
      default: n4512_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4515_o = 1'b0;
      6'b010000: n4515_o = 1'b0;
      6'b001000: n4515_o = 1'b0;
      6'b000100: n4515_o = 1'b0;
      6'b000010: n4515_o = 1'b1;
      6'b000001: n4515_o = 1'b0;
      default: n4515_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4518_o = 1'b0;
      6'b010000: n4518_o = 1'b1;
      6'b001000: n4518_o = 1'b0;
      6'b000100: n4518_o = 1'b0;
      6'b000010: n4518_o = 1'b0;
      6'b000001: n4518_o = 1'b0;
      default: n4518_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4521_o = 1'b0;
      6'b010000: n4521_o = 1'b1;
      6'b001000: n4521_o = n4477_o;
      6'b000100: n4521_o = n4458_o;
      6'b000010: n4521_o = 1'b0;
      6'b000001: n4521_o = 1'b0;
      default: n4521_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:963:9  */
  always @*
    case (n4484_o)
      6'b100000: n4524_o = 1'b1;
      6'b010000: n4524_o = 1'b0;
      6'b001000: n4524_o = 1'b0;
      6'b000100: n4524_o = 1'b0;
      6'b000010: n4524_o = 1'b0;
      6'b000001: n4524_o = 1'b0;
      default: n4524_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:954:7  */
  assign n4526_o = n3043_o == 5'b11001;
  /* ./T65_MCode.vhd:954:20  */
  assign n4528_o = n3043_o == 5'b11011;
  /* ./T65_MCode.vhd:954:20  */
  assign n4529_o = n4526_o | n4528_o;
  /* ./T65_MCode.vhd:1007:14  */
  assign n4530_o = ir[7:6];
  /* ./T65_MCode.vhd:1007:27  */
  assign n4532_o = n4530_o != 2'b10;
  /* ./T65_MCode.vhd:1007:41  */
  assign n4533_o = ir[1];
  /* ./T65_MCode.vhd:1007:35  */
  assign n4534_o = n4533_o & n4532_o;
  /* ./T65_MCode.vhd:1007:60  */
  assign n4536_o = mode == 2'b00;
  /* ./T65_MCode.vhd:1007:71  */
  assign n4537_o = ir[0];
  /* ./T65_MCode.vhd:1007:74  */
  assign n4538_o = ~n4537_o;
  /* ./T65_MCode.vhd:1007:66  */
  assign n4539_o = n4536_o | n4538_o;
  /* ./T65_MCode.vhd:1007:51  */
  assign n4540_o = n4539_o & n4534_o;
  /* ./T65_MCode.vhd:1010:18  */
  assign n4542_o = mode == 2'b00;
  /* ./T65_MCode.vhd:1010:30  */
  assign n4543_o = ir[0];
  /* ./T65_MCode.vhd:1010:24  */
  assign n4544_o = n4543_o & n4542_o;
  /* ./T65_MCode.vhd:1010:11  */
  assign n4546_o = n4544_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:1014:13  */
  assign n4548_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:1017:13  */
  assign n4550_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:1023:13  */
  assign n4552_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:1028:22  */
  assign n4554_o = mode == 2'b00;
  /* ./T65_MCode.vhd:1028:15  */
  assign n4557_o = n4554_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:1026:13  */
  assign n4559_o = mcycle == 3'b100;
  /* ./T65_MCode.vhd:1032:13  */
  assign n4561_o = mcycle == 3'b101;
  /* ./T65_MCode.vhd:1038:22  */
  assign n4563_o = mode == 2'b00;
  /* ./T65_MCode.vhd:1038:34  */
  assign n4564_o = ir[0];
  /* ./T65_MCode.vhd:1038:28  */
  assign n4565_o = n4564_o & n4563_o;
  /* ./T65_MCode.vhd:1038:15  */
  assign n4567_o = n4565_o ? 4'b0001 : n3042_o;
  /* ./T65_MCode.vhd:1038:15  */
  assign n4570_o = n4565_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:1037:13  */
  assign n4572_o = mcycle == 3'b110;
  assign n4573_o = {n4572_o, n4561_o, n4559_o, n4552_o, n4550_o, n4548_o};
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4575_o = n4567_o;
      6'b010000: n4575_o = n3042_o;
      6'b001000: n4575_o = n3042_o;
      6'b000100: n4575_o = n3042_o;
      6'b000010: n4575_o = 4'b0010;
      6'b000001: n4575_o = n3042_o;
      default: n4575_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4581_o = 2'b00;
      6'b010000: n4581_o = 2'b11;
      6'b001000: n4581_o = 2'b11;
      6'b000100: n4581_o = 2'b11;
      6'b000010: n4581_o = 2'b11;
      6'b000001: n4581_o = 2'b00;
      default: n4581_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4585_o = 2'b00;
      6'b010000: n4585_o = 2'b00;
      6'b001000: n4585_o = 2'b00;
      6'b000100: n4585_o = 2'b00;
      6'b000010: n4585_o = 2'b01;
      6'b000001: n4585_o = 2'b01;
      default: n4585_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4589_o = 2'b00;
      6'b010000: n4589_o = 2'b00;
      6'b001000: n4589_o = 2'b00;
      6'b000100: n4589_o = 2'b11;
      6'b000010: n4589_o = 2'b10;
      6'b000001: n4589_o = 2'b00;
      default: n4589_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4592_o = 1'b0;
      6'b010000: n4592_o = 1'b0;
      6'b001000: n4592_o = 1'b1;
      6'b000100: n4592_o = 1'b0;
      6'b000010: n4592_o = 1'b0;
      6'b000001: n4592_o = 1'b0;
      default: n4592_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4595_o = 1'b0;
      6'b010000: n4595_o = 1'b1;
      6'b001000: n4595_o = 1'b0;
      6'b000100: n4595_o = 1'b0;
      6'b000010: n4595_o = 1'b0;
      6'b000001: n4595_o = 1'b0;
      default: n4595_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4598_o = 1'b0;
      6'b010000: n4598_o = 1'b0;
      6'b001000: n4598_o = 1'b0;
      6'b000100: n4598_o = 1'b0;
      6'b000010: n4598_o = 1'b0;
      6'b000001: n4598_o = 1'b1;
      default: n4598_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4601_o = 1'b0;
      6'b010000: n4601_o = 1'b0;
      6'b001000: n4601_o = 1'b0;
      6'b000100: n4601_o = 1'b0;
      6'b000010: n4601_o = 1'b1;
      6'b000001: n4601_o = 1'b0;
      default: n4601_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4604_o = 1'b0;
      6'b010000: n4604_o = 1'b1;
      6'b001000: n4604_o = 1'b0;
      6'b000100: n4604_o = 1'b0;
      6'b000010: n4604_o = 1'b0;
      6'b000001: n4604_o = 1'b0;
      default: n4604_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4607_o = 1'b0;
      6'b010000: n4607_o = 1'b1;
      6'b001000: n4607_o = n4557_o;
      6'b000100: n4607_o = 1'b0;
      6'b000010: n4607_o = 1'b0;
      6'b000001: n4607_o = 1'b0;
      default: n4607_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1013:11  */
  always @*
    case (n4573_o)
      6'b100000: n4609_o = n4570_o;
      6'b010000: n4609_o = 1'b0;
      6'b001000: n4609_o = 1'b0;
      6'b000100: n4609_o = 1'b0;
      6'b000010: n4609_o = 1'b0;
      6'b000001: n4609_o = 1'b0;
      default: n4609_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1046:16  */
  assign n4610_o = ir[7:6];
  /* ./T65_MCode.vhd:1046:29  */
  assign n4612_o = n4610_o != 2'b10;
  /* ./T65_MCode.vhd:1047:20  */
  assign n4614_o = mode != 2'b00;
  /* ./T65_MCode.vhd:1047:32  */
  assign n4615_o = ir[4];
  /* ./T65_MCode.vhd:1047:35  */
  assign n4616_o = ~n4615_o;
  /* ./T65_MCode.vhd:1047:27  */
  assign n4617_o = n4614_o | n4616_o;
  /* ./T65_MCode.vhd:1047:45  */
  assign n4618_o = ir[1:0];
  /* ./T65_MCode.vhd:1047:57  */
  assign n4620_o = n4618_o != 2'b00;
  /* ./T65_MCode.vhd:1047:40  */
  assign n4621_o = n4617_o | n4620_o;
  /* ./T65_MCode.vhd:1046:11  */
  assign n4623_o = n4624_o ? 1'b1 : n3015_o;
  /* ./T65_MCode.vhd:1046:11  */
  assign n4624_o = n4621_o & n4612_o;
  /* ./T65_MCode.vhd:1052:13  */
  assign n4626_o = mcycle == 3'b000;
  /* ./T65_MCode.vhd:1053:13  */
  assign n4628_o = mcycle == 3'b001;
  /* ./T65_MCode.vhd:1059:20  */
  assign n4629_o = ir[7:6];
  /* ./T65_MCode.vhd:1059:32  */
  assign n4631_o = n4629_o == 2'b10;
  /* ./T65_MCode.vhd:1059:44  */
  assign n4632_o = ir[4:1];
  /* ./T65_MCode.vhd:1059:56  */
  assign n4634_o = n4632_o == 4'b1111;
  /* ./T65_MCode.vhd:1059:38  */
  assign n4635_o = n4634_o & n4631_o;
  /* ./T65_MCode.vhd:1059:15  */
  assign n4638_o = n4635_o ? 4'b0011 : 4'b0010;
  /* ./T65_MCode.vhd:1056:13  */
  assign n4640_o = mcycle == 3'b010;
  /* ./T65_MCode.vhd:1069:20  */
  assign n4641_o = ir[7:5];
  /* ./T65_MCode.vhd:1069:33  */
  assign n4643_o = n4641_o == 3'b100;
  /* ./T65_MCode.vhd:1071:24  */
  assign n4644_o = ir[1:0];
  /* ./T65_MCode.vhd:1072:17  */
  assign n4646_o = n4644_o == 2'b00;
  /* ./T65_MCode.vhd:1072:26  */
  assign n4648_o = n4644_o == 2'b10;
  /* ./T65_MCode.vhd:1072:26  */
  assign n4649_o = n4646_o | n4648_o;
  /* ./T65_MCode.vhd:1073:17  */
  assign n4651_o = n4644_o == 2'b11;
  assign n4652_o = {n4651_o, n4649_o};
  /* ./T65_MCode.vhd:1071:17  */
  always @*
    case (n4652_o)
      2'b10: n4656_o = 2'b10;
      2'b01: n4656_o = 2'b01;
      default: n4656_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1069:15  */
  assign n4658_o = n4643_o ? n4656_o : 2'b00;
  /* ./T65_MCode.vhd:1069:15  */
  assign n4661_o = n4643_o ? 1'b0 : 1'b1;
  /* ./T65_MCode.vhd:1069:15  */
  assign n4664_o = n4643_o ? 1'b1 : 1'b0;
  /* ./T65_MCode.vhd:1067:13  */
  assign n4666_o = mcycle == 3'b011;
  /* ./T65_MCode.vhd:1080:13  */
  assign n4668_o = mcycle == 3'b100;
  assign n4669_o = {n4668_o, n4666_o, n4640_o, n4628_o, n4626_o};
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4670_o = n3042_o;
      5'b01000: n4670_o = n3042_o;
      5'b00100: n4670_o = n4638_o;
      5'b00010: n4670_o = n3042_o;
      5'b00001: n4670_o = n3042_o;
      default: n4670_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4674_o = 2'b00;
      5'b01000: n4674_o = 2'b11;
      5'b00100: n4674_o = 2'b11;
      5'b00010: n4674_o = 2'b00;
      5'b00001: n4674_o = 2'b00;
      default: n4674_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4678_o = 2'b00;
      5'b01000: n4678_o = 2'b00;
      5'b00100: n4678_o = 2'b01;
      5'b00010: n4678_o = 2'b01;
      5'b00001: n4678_o = 2'b00;
      default: n4678_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4682_o = 2'b00;
      5'b01000: n4682_o = 2'b11;
      5'b00100: n4682_o = 2'b10;
      5'b00010: n4682_o = 2'b00;
      5'b00001: n4682_o = 2'b00;
      default: n4682_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4684_o = 2'b00;
      5'b01000: n4684_o = n4658_o;
      5'b00100: n4684_o = 2'b00;
      5'b00010: n4684_o = 2'b00;
      5'b00001: n4684_o = 2'b00;
      default: n4684_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4686_o = 1'b0;
      5'b01000: n4686_o = n4661_o;
      5'b00100: n4686_o = 1'b0;
      5'b00010: n4686_o = 1'b0;
      5'b00001: n4686_o = 1'b0;
      default: n4686_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4689_o = 1'b0;
      5'b01000: n4689_o = 1'b0;
      5'b00100: n4689_o = 1'b0;
      5'b00010: n4689_o = 1'b1;
      5'b00001: n4689_o = 1'b0;
      default: n4689_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4692_o = 1'b0;
      5'b01000: n4692_o = 1'b0;
      5'b00100: n4692_o = 1'b1;
      5'b00010: n4692_o = 1'b0;
      5'b00001: n4692_o = 1'b0;
      default: n4692_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1051:11  */
  always @*
    case (n4669_o)
      5'b10000: n4694_o = 1'b0;
      5'b01000: n4694_o = n4664_o;
      5'b00100: n4694_o = 1'b0;
      5'b00010: n4694_o = 1'b0;
      5'b00001: n4694_o = 1'b0;
      default: n4694_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1007:9  */
  assign n4697_o = n4540_o ? 3'b110 : 3'b100;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4698_o = n4540_o ? n4575_o : n4670_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4699_o = n4540_o ? n4581_o : n4674_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4700_o = n4540_o ? n4585_o : n4678_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4701_o = n4540_o ? n4589_o : n4682_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4703_o = n4540_o ? 2'b00 : n4684_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4705_o = n4540_o ? 1'b0 : n4686_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4706_o = n4540_o ? n4546_o : n4623_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4708_o = n4540_o ? n4592_o : 1'b0;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4710_o = n4540_o ? n4595_o : 1'b0;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4711_o = n4540_o ? n4598_o : n4689_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4712_o = n4540_o ? n4601_o : n4692_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4714_o = n4540_o ? n4604_o : 1'b0;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4715_o = n4540_o ? n4607_o : n4694_o;
  /* ./T65_MCode.vhd:1007:9  */
  assign n4717_o = n4540_o ? n4609_o : 1'b0;
  /* ./T65_MCode.vhd:1005:7  */
  assign n4719_o = n3043_o == 5'b11100;
  /* ./T65_MCode.vhd:1005:20  */
  assign n4721_o = n3043_o == 5'b11101;
  /* ./T65_MCode.vhd:1005:20  */
  assign n4722_o = n4719_o | n4721_o;
  /* ./T65_MCode.vhd:1005:30  */
  assign n4724_o = n3043_o == 5'b11110;
  /* ./T65_MCode.vhd:1005:30  */
  assign n4725_o = n4722_o | n4724_o;
  /* ./T65_MCode.vhd:1005:40  */
  assign n4727_o = n3043_o == 5'b11111;
  /* ./T65_MCode.vhd:1005:40  */
  assign n4728_o = n4725_o | n4727_o;
  assign n4729_o = {n4728_o, n4529_o, n4415_o, n4260_o, n4139_o, n4117_o, n3984_o, n3848_o, n3725_o, n3691_o, n3658_o, n3613_o, n3601_o, n3502_o};
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4732_o = n4697_o;
      14'b01000000000000: n4732_o = n4427_o;
      14'b00100000000000: n4732_o = n4387_o;
      14'b00010000000000: n4732_o = n4151_o;
      14'b00001000000000: n4732_o = n4120_o;
      14'b00000100000000: n4732_o = n4094_o;
      14'b00000010000000: n4732_o = n3970_o;
      14'b00000001000000: n4732_o = n3826_o;
      14'b00000000100000: n4732_o = 3'b010;
      14'b00000000010000: n4732_o = 3'b001;
      14'b00000000001000: n4732_o = 3'b001;
      14'b00000000000100: n4732_o = 3'b001;
      14'b00000000000010: n4732_o = n3514_o;
      14'b00000000000001: n4732_o = n3459_o;
      default: n4732_o = 3'b001;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4734_o = n4698_o;
      14'b01000000000000: n4734_o = n4487_o;
      14'b00100000000000: n4734_o = n4388_o;
      14'b00010000000000: n4734_o = n4213_o;
      14'b00001000000000: n4734_o = n3042_o;
      14'b00000100000000: n4734_o = n4095_o;
      14'b00000010000000: n4734_o = n3042_o;
      14'b00000001000000: n4734_o = n3827_o;
      14'b00000000100000: n4734_o = n3042_o;
      14'b00000000010000: n4734_o = n3042_o;
      14'b00000000001000: n4734_o = n3652_o;
      14'b00000000000100: n4734_o = n3042_o;
      14'b00000000000010: n4734_o = n3557_o;
      14'b00000000000001: n4734_o = n3461_o;
      default: n4734_o = n3042_o;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4736_o = n4699_o;
      14'b01000000000000: n4736_o = n4492_o;
      14'b00100000000000: n4736_o = n4389_o;
      14'b00010000000000: n4736_o = n4220_o;
      14'b00001000000000: n4736_o = 2'b00;
      14'b00000100000000: n4736_o = n4096_o;
      14'b00000010000000: n4736_o = n3971_o;
      14'b00000001000000: n4736_o = n3828_o;
      14'b00000000100000: n4736_o = n3713_o;
      14'b00000000010000: n4736_o = 2'b00;
      14'b00000000001000: n4736_o = 2'b00;
      14'b00000000000100: n4736_o = 2'b00;
      14'b00000000000010: n4736_o = n3564_o;
      14'b00000000000001: n4736_o = n3463_o;
      default: n4736_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4738_o = n3012_o;
      14'b01000000000000: n4738_o = n3012_o;
      14'b00100000000000: n4738_o = n3012_o;
      14'b00010000000000: n4738_o = n3012_o;
      14'b00001000000000: n4738_o = n3012_o;
      14'b00000100000000: n4738_o = n3012_o;
      14'b00000010000000: n4738_o = n3012_o;
      14'b00000001000000: n4738_o = n3012_o;
      14'b00000000100000: n4738_o = n3012_o;
      14'b00000000010000: n4738_o = n3012_o;
      14'b00000000001000: n4738_o = n3012_o;
      14'b00000000000100: n4738_o = n3012_o;
      14'b00000000000010: n4738_o = n3012_o;
      14'b00000000000001: n4738_o = n3464_o;
      default: n4738_o = n3012_o;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4740_o = n4700_o;
      14'b01000000000000: n4740_o = n4496_o;
      14'b00100000000000: n4740_o = n4390_o;
      14'b00010000000000: n4740_o = n4223_o;
      14'b00001000000000: n4740_o = n4131_o;
      14'b00000100000000: n4740_o = n4097_o;
      14'b00000010000000: n4740_o = n3972_o;
      14'b00000001000000: n4740_o = n3829_o;
      14'b00000000100000: n4740_o = n3716_o;
      14'b00000000010000: n4740_o = n3685_o;
      14'b00000000001000: n4740_o = n3654_o;
      14'b00000000000100: n4740_o = n3611_o;
      14'b00000000000010: n4740_o = n3567_o;
      14'b00000000000001: n4740_o = n3466_o;
      default: n4740_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4743_o = n4701_o;
      14'b01000000000000: n4743_o = n4500_o;
      14'b00100000000000: n4743_o = 2'b00;
      14'b00010000000000: n4743_o = n4228_o;
      14'b00001000000000: n4743_o = 2'b00;
      14'b00000100000000: n4743_o = 2'b00;
      14'b00000010000000: n4743_o = n3974_o;
      14'b00000001000000: n4743_o = 2'b00;
      14'b00000000100000: n4743_o = 2'b00;
      14'b00000000010000: n4743_o = 2'b00;
      14'b00000000001000: n4743_o = 2'b00;
      14'b00000000000100: n4743_o = 2'b00;
      14'b00000000000010: n4743_o = n3570_o;
      14'b00000000000001: n4743_o = 2'b00;
      default: n4743_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4746_o = n4703_o;
      14'b01000000000000: n4746_o = n4502_o;
      14'b00100000000000: n4746_o = 2'b00;
      14'b00010000000000: n4746_o = n4230_o;
      14'b00001000000000: n4746_o = 2'b00;
      14'b00000100000000: n4746_o = 2'b00;
      14'b00000010000000: n4746_o = 2'b00;
      14'b00000001000000: n4746_o = 2'b00;
      14'b00000000100000: n4746_o = 2'b00;
      14'b00000000010000: n4746_o = 2'b00;
      14'b00000000001000: n4746_o = 2'b00;
      14'b00000000000100: n4746_o = 2'b00;
      14'b00000000000010: n4746_o = 2'b00;
      14'b00000000000001: n4746_o = 2'b00;
      default: n4746_o = 2'b00;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4749_o = n4705_o;
      14'b01000000000000: n4749_o = n4504_o;
      14'b00100000000000: n4749_o = 1'b0;
      14'b00010000000000: n4749_o = n4232_o;
      14'b00001000000000: n4749_o = 1'b0;
      14'b00000100000000: n4749_o = 1'b0;
      14'b00000010000000: n4749_o = 1'b0;
      14'b00000001000000: n4749_o = 1'b0;
      14'b00000000100000: n4749_o = 1'b0;
      14'b00000000010000: n4749_o = 1'b0;
      14'b00000000001000: n4749_o = 1'b0;
      14'b00000000000100: n4749_o = 1'b0;
      14'b00000000000010: n4749_o = 1'b0;
      14'b00000000000001: n4749_o = 1'b0;
      default: n4749_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4752_o = 1'b0;
      14'b01000000000000: n4752_o = 1'b0;
      14'b00100000000000: n4752_o = n4391_o;
      14'b00010000000000: n4752_o = 1'b0;
      14'b00001000000000: n4752_o = 1'b0;
      14'b00000100000000: n4752_o = 1'b0;
      14'b00000010000000: n4752_o = 1'b0;
      14'b00000001000000: n4752_o = 1'b0;
      14'b00000000100000: n4752_o = 1'b0;
      14'b00000000010000: n4752_o = 1'b0;
      14'b00000000001000: n4752_o = 1'b0;
      14'b00000000000100: n4752_o = 1'b0;
      14'b00000000000010: n4752_o = n3573_o;
      14'b00000000000001: n4752_o = 1'b0;
      default: n4752_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4755_o = 1'b0;
      14'b01000000000000: n4755_o = 1'b0;
      14'b00100000000000: n4755_o = n4393_o;
      14'b00010000000000: n4755_o = 1'b0;
      14'b00001000000000: n4755_o = 1'b0;
      14'b00000100000000: n4755_o = 1'b0;
      14'b00000010000000: n4755_o = 1'b0;
      14'b00000001000000: n4755_o = 1'b0;
      14'b00000000100000: n4755_o = 1'b0;
      14'b00000000010000: n4755_o = 1'b0;
      14'b00000000001000: n4755_o = 1'b0;
      14'b00000000000100: n4755_o = 1'b0;
      14'b00000000000010: n4755_o = 1'b0;
      14'b00000000000001: n4755_o = 1'b0;
      default: n4755_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4758_o = 1'b0;
      14'b01000000000000: n4758_o = 1'b0;
      14'b00100000000000: n4758_o = 1'b0;
      14'b00010000000000: n4758_o = 1'b0;
      14'b00001000000000: n4758_o = n4134_o;
      14'b00000100000000: n4758_o = 1'b0;
      14'b00000010000000: n4758_o = 1'b0;
      14'b00000001000000: n4758_o = 1'b0;
      14'b00000000100000: n4758_o = 1'b0;
      14'b00000000010000: n4758_o = 1'b0;
      14'b00000000001000: n4758_o = 1'b0;
      14'b00000000000100: n4758_o = 1'b0;
      14'b00000000000010: n4758_o = 1'b0;
      14'b00000000000001: n4758_o = 1'b0;
      default: n4758_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4761_o = 1'b0;
      14'b01000000000000: n4761_o = 1'b0;
      14'b00100000000000: n4761_o = 1'b0;
      14'b00010000000000: n4761_o = 1'b0;
      14'b00001000000000: n4761_o = 1'b0;
      14'b00000100000000: n4761_o = 1'b0;
      14'b00000010000000: n4761_o = 1'b0;
      14'b00000001000000: n4761_o = 1'b0;
      14'b00000000100000: n4761_o = 1'b0;
      14'b00000000010000: n4761_o = 1'b0;
      14'b00000000001000: n4761_o = 1'b0;
      14'b00000000000100: n4761_o = 1'b0;
      14'b00000000000010: n4761_o = 1'b0;
      14'b00000000000001: n4761_o = n3468_o;
      default: n4761_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4764_o = 1'b0;
      14'b01000000000000: n4764_o = 1'b0;
      14'b00100000000000: n4764_o = 1'b0;
      14'b00010000000000: n4764_o = 1'b0;
      14'b00001000000000: n4764_o = 1'b0;
      14'b00000100000000: n4764_o = 1'b0;
      14'b00000010000000: n4764_o = 1'b0;
      14'b00000001000000: n4764_o = 1'b0;
      14'b00000000100000: n4764_o = 1'b0;
      14'b00000000010000: n4764_o = 1'b0;
      14'b00000000001000: n4764_o = 1'b0;
      14'b00000000000100: n4764_o = 1'b0;
      14'b00000000000010: n4764_o = 1'b0;
      14'b00000000000001: n4764_o = n3470_o;
      default: n4764_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4766_o = n4706_o;
      14'b01000000000000: n4766_o = n4430_o;
      14'b00100000000000: n4766_o = n4394_o;
      14'b00010000000000: n4766_o = n4154_o;
      14'b00001000000000: n4766_o = n3015_o;
      14'b00000100000000: n4766_o = n4098_o;
      14'b00000010000000: n4766_o = n3015_o;
      14'b00000001000000: n4766_o = n3830_o;
      14'b00000000100000: n4766_o = n3015_o;
      14'b00000000010000: n4766_o = n3015_o;
      14'b00000000001000: n4766_o = n3655_o;
      14'b00000000000100: n4766_o = n3606_o;
      14'b00000000000010: n4766_o = n3517_o;
      14'b00000000000001: n4766_o = n3473_o;
      default: n4766_o = n3015_o;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4768_o = 1'b0;
      14'b01000000000000: n4768_o = 1'b0;
      14'b00100000000000: n4768_o = 1'b0;
      14'b00010000000000: n4768_o = 1'b0;
      14'b00001000000000: n4768_o = 1'b0;
      14'b00000100000000: n4768_o = 1'b0;
      14'b00000010000000: n4768_o = 1'b0;
      14'b00000001000000: n4768_o = 1'b0;
      14'b00000000100000: n4768_o = 1'b0;
      14'b00000000010000: n4768_o = 1'b0;
      14'b00000000001000: n4768_o = 1'b0;
      14'b00000000000100: n4768_o = 1'b0;
      14'b00000000000010: n4768_o = 1'b0;
      14'b00000000000001: n4768_o = n3475_o;
      default: n4768_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4770_o = n3018_o;
      14'b01000000000000: n4770_o = n3018_o;
      14'b00100000000000: n4770_o = n3018_o;
      14'b00010000000000: n4770_o = n3018_o;
      14'b00001000000000: n4770_o = n3018_o;
      14'b00000100000000: n4770_o = n3018_o;
      14'b00000010000000: n4770_o = n3018_o;
      14'b00000001000000: n4770_o = n3018_o;
      14'b00000000100000: n4770_o = n3018_o;
      14'b00000000010000: n4770_o = n3686_o;
      14'b00000000001000: n4770_o = n3656_o;
      14'b00000000000100: n4770_o = n3018_o;
      14'b00000000000010: n4770_o = n3018_o;
      14'b00000000000001: n4770_o = n3478_o;
      default: n4770_o = n3018_o;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4771_o = n3021_o;
      14'b01000000000000: n4771_o = n3021_o;
      14'b00100000000000: n4771_o = n3021_o;
      14'b00010000000000: n4771_o = n3021_o;
      14'b00001000000000: n4771_o = n3021_o;
      14'b00000100000000: n4771_o = n3021_o;
      14'b00000010000000: n4771_o = n3021_o;
      14'b00000001000000: n4771_o = n3021_o;
      14'b00000000100000: n4771_o = n3021_o;
      14'b00000000010000: n4771_o = n3021_o;
      14'b00000000001000: n4771_o = n3021_o;
      14'b00000000000100: n4771_o = n3021_o;
      14'b00000000000010: n4771_o = n3021_o;
      14'b00000000000001: n4771_o = n3480_o;
      default: n4771_o = n3021_o;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4772_o = n3024_o;
      14'b01000000000000: n4772_o = n3024_o;
      14'b00100000000000: n4772_o = n3024_o;
      14'b00010000000000: n4772_o = n3024_o;
      14'b00001000000000: n4772_o = n3024_o;
      14'b00000100000000: n4772_o = n3024_o;
      14'b00000010000000: n4772_o = n3024_o;
      14'b00000001000000: n4772_o = n3024_o;
      14'b00000000100000: n4772_o = n3024_o;
      14'b00000000010000: n4772_o = n3024_o;
      14'b00000000001000: n4772_o = n3024_o;
      14'b00000000000100: n4772_o = n3024_o;
      14'b00000000000010: n4772_o = n3024_o;
      14'b00000000000001: n4772_o = n3482_o;
      default: n4772_o = n3024_o;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4774_o = n4708_o;
      14'b01000000000000: n4774_o = n4506_o;
      14'b00100000000000: n4774_o = n4396_o;
      14'b00010000000000: n4774_o = n4234_o;
      14'b00001000000000: n4774_o = n4137_o;
      14'b00000100000000: n4774_o = n4100_o;
      14'b00000010000000: n4774_o = n3976_o;
      14'b00000001000000: n4774_o = n3832_o;
      14'b00000000100000: n4774_o = 1'b0;
      14'b00000000010000: n4774_o = 1'b0;
      14'b00000000001000: n4774_o = 1'b0;
      14'b00000000000100: n4774_o = 1'b0;
      14'b00000000000010: n4774_o = n3575_o;
      14'b00000000000001: n4774_o = n3484_o;
      default: n4774_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4777_o = n4710_o;
      14'b01000000000000: n4777_o = n4509_o;
      14'b00100000000000: n4777_o = n4398_o;
      14'b00010000000000: n4777_o = n4237_o;
      14'b00001000000000: n4777_o = 1'b0;
      14'b00000100000000: n4777_o = n4102_o;
      14'b00000010000000: n4777_o = 1'b0;
      14'b00000001000000: n4777_o = n3834_o;
      14'b00000000100000: n4777_o = 1'b0;
      14'b00000000010000: n4777_o = 1'b0;
      14'b00000000001000: n4777_o = 1'b0;
      14'b00000000000100: n4777_o = 1'b0;
      14'b00000000000010: n4777_o = n3578_o;
      14'b00000000000001: n4777_o = 1'b0;
      default: n4777_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4780_o = 1'b0;
      14'b01000000000000: n4780_o = 1'b0;
      14'b00100000000000: n4780_o = n4399_o;
      14'b00010000000000: n4780_o = n4240_o;
      14'b00001000000000: n4780_o = 1'b0;
      14'b00000100000000: n4780_o = 1'b0;
      14'b00000010000000: n4780_o = 1'b0;
      14'b00000001000000: n4780_o = n3835_o;
      14'b00000000100000: n4780_o = n3719_o;
      14'b00000000010000: n4780_o = 1'b0;
      14'b00000000001000: n4780_o = 1'b0;
      14'b00000000000100: n4780_o = 1'b0;
      14'b00000000000010: n4780_o = n3581_o;
      14'b00000000000001: n4780_o = 1'b0;
      default: n4780_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4783_o = n4711_o;
      14'b01000000000000: n4783_o = n4512_o;
      14'b00100000000000: n4783_o = 1'b0;
      14'b00010000000000: n4783_o = n4243_o;
      14'b00001000000000: n4783_o = 1'b0;
      14'b00000100000000: n4783_o = n4103_o;
      14'b00000010000000: n4783_o = n3977_o;
      14'b00000001000000: n4783_o = 1'b0;
      14'b00000000100000: n4783_o = 1'b0;
      14'b00000000010000: n4783_o = 1'b0;
      14'b00000000001000: n4783_o = 1'b0;
      14'b00000000000100: n4783_o = 1'b0;
      14'b00000000000010: n4783_o = n3584_o;
      14'b00000000000001: n4783_o = 1'b0;
      default: n4783_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4786_o = n4712_o;
      14'b01000000000000: n4786_o = n4515_o;
      14'b00100000000000: n4786_o = 1'b0;
      14'b00010000000000: n4786_o = n4246_o;
      14'b00001000000000: n4786_o = 1'b0;
      14'b00000100000000: n4786_o = n4104_o;
      14'b00000010000000: n4786_o = n3978_o;
      14'b00000001000000: n4786_o = 1'b0;
      14'b00000000100000: n4786_o = 1'b0;
      14'b00000000010000: n4786_o = 1'b0;
      14'b00000000001000: n4786_o = 1'b0;
      14'b00000000000100: n4786_o = 1'b0;
      14'b00000000000010: n4786_o = n3587_o;
      14'b00000000000001: n4786_o = 1'b0;
      default: n4786_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4789_o = n4714_o;
      14'b01000000000000: n4789_o = n4518_o;
      14'b00100000000000: n4789_o = n4401_o;
      14'b00010000000000: n4789_o = n4249_o;
      14'b00001000000000: n4789_o = 1'b0;
      14'b00000100000000: n4789_o = n4106_o;
      14'b00000010000000: n4789_o = n3980_o;
      14'b00000001000000: n4789_o = n3837_o;
      14'b00000000100000: n4789_o = n3721_o;
      14'b00000000010000: n4789_o = 1'b0;
      14'b00000000001000: n4789_o = 1'b0;
      14'b00000000000100: n4789_o = 1'b0;
      14'b00000000000010: n4789_o = n3590_o;
      14'b00000000000001: n4789_o = n3486_o;
      default: n4789_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4792_o = n4715_o;
      14'b01000000000000: n4792_o = n4521_o;
      14'b00100000000000: n4792_o = n4402_o;
      14'b00010000000000: n4792_o = n4252_o;
      14'b00001000000000: n4792_o = 1'b0;
      14'b00000100000000: n4792_o = n4107_o;
      14'b00000010000000: n4792_o = n3982_o;
      14'b00000001000000: n4792_o = n3838_o;
      14'b00000000100000: n4792_o = n3723_o;
      14'b00000000010000: n4792_o = 1'b0;
      14'b00000000001000: n4792_o = 1'b0;
      14'b00000000000100: n4792_o = 1'b0;
      14'b00000000000010: n4792_o = n3593_o;
      14'b00000000000001: n4792_o = n3488_o;
      default: n4792_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:234:5  */
  always @*
    case (n4729_o)
      14'b10000000000000: n4795_o = n4717_o;
      14'b01000000000000: n4795_o = n4524_o;
      14'b00100000000000: n4795_o = n4404_o;
      14'b00010000000000: n4795_o = n4255_o;
      14'b00001000000000: n4795_o = 1'b0;
      14'b00000100000000: n4795_o = n4109_o;
      14'b00000010000000: n4795_o = 1'b0;
      14'b00000001000000: n4795_o = n3840_o;
      14'b00000000100000: n4795_o = 1'b0;
      14'b00000000010000: n4795_o = 1'b0;
      14'b00000000001000: n4795_o = 1'b0;
      14'b00000000000100: n4795_o = 1'b0;
      14'b00000000000010: n4795_o = n3596_o;
      14'b00000000000001: n4795_o = 1'b0;
      default: n4795_o = 1'b0;
    endcase
  /* ./T65_MCode.vhd:1092:12  */
  assign n4800_o = ir[1:0];
  /* ./T65_MCode.vhd:1094:16  */
  assign n4801_o = ir[4:2];
  /* ./T65_MCode.vhd:1099:18  */
  assign n4802_o = ir[7:5];
  /* ./T65_MCode.vhd:1100:13  */
  assign n4804_o = n4802_o == 3'b110;
  /* ./T65_MCode.vhd:1100:24  */
  assign n4806_o = n4802_o == 3'b111;
  /* ./T65_MCode.vhd:1100:24  */
  assign n4807_o = n4804_o | n4806_o;
  /* ./T65_MCode.vhd:1102:13  */
  assign n4809_o = n4802_o == 3'b101;
  /* ./T65_MCode.vhd:1104:13  */
  assign n4811_o = n4802_o == 3'b001;
  assign n4812_o = {n4811_o, n4809_o, n4807_o};
  /* ./T65_MCode.vhd:1099:11  */
  always @*
    case (n4812_o)
      3'b100: n4817_o = 5'b01100;
      3'b010: n4817_o = 5'b00101;
      3'b001: n4817_o = 5'b00110;
      default: n4817_o = 5'b00100;
    endcase
  /* ./T65_MCode.vhd:1098:9  */
  assign n4819_o = n4801_o == 3'b000;
  /* ./T65_MCode.vhd:1098:20  */
  assign n4821_o = n4801_o == 3'b001;
  /* ./T65_MCode.vhd:1098:20  */
  assign n4822_o = n4819_o | n4821_o;
  /* ./T65_MCode.vhd:1098:28  */
  assign n4824_o = n4801_o == 3'b011;
  /* ./T65_MCode.vhd:1098:28  */
  assign n4825_o = n4822_o | n4824_o;
  /* ./T65_MCode.vhd:1112:18  */
  assign n4826_o = ir[7:5];
  /* ./T65_MCode.vhd:1113:13  */
  assign n4828_o = n4826_o == 3'b111;
  /* ./T65_MCode.vhd:1113:24  */
  assign n4830_o = n4826_o == 3'b110;
  /* ./T65_MCode.vhd:1113:24  */
  assign n4831_o = n4828_o | n4830_o;
  /* ./T65_MCode.vhd:1115:13  */
  assign n4833_o = n4826_o == 3'b100;
  assign n4834_o = {n4833_o, n4831_o};
  /* ./T65_MCode.vhd:1112:11  */
  always @*
    case (n4834_o)
      2'b10: n4838_o = 5'b01101;
      2'b01: n4838_o = 5'b01110;
      default: n4838_o = 5'b00101;
    endcase
  /* ./T65_MCode.vhd:1111:9  */
  assign n4840_o = n4801_o == 3'b010;
  /* ./T65_MCode.vhd:1123:18  */
  assign n4841_o = ir[7:5];
  /* ./T65_MCode.vhd:1124:13  */
  assign n4843_o = n4841_o == 3'b100;
  /* ./T65_MCode.vhd:1123:11  */
  always @*
    case (n4843_o)
      1'b1: n4846_o = 5'b00101;
      default: n4846_o = 5'b00100;
    endcase
  /* ./T65_MCode.vhd:1122:9  */
  assign n4848_o = n4801_o == 3'b110;
  /* ./T65_MCode.vhd:1134:18  */
  assign n4849_o = ir[7:5];
  /* ./T65_MCode.vhd:1135:13  */
  assign n4851_o = n4849_o == 3'b101;
  /* ./T65_MCode.vhd:1134:11  */
  always @*
    case (n4851_o)
      1'b1: n4854_o = 5'b00101;
      default: n4854_o = 5'b00100;
    endcase
  assign n4855_o = {n4848_o, n4840_o, n4825_o};
  /* ./T65_MCode.vhd:1094:9  */
  always @*
    case (n4855_o)
      3'b100: n4856_o = n4846_o;
      3'b010: n4856_o = n4838_o;
      3'b001: n4856_o = n4817_o;
      default: n4856_o = n4854_o;
    endcase
  /* ./T65_MCode.vhd:1093:7  */
  assign n4858_o = n4800_o == 2'b00;
  /* ./T65_MCode.vhd:1143:36  */
  assign n4859_o = ir[7:5];
  /* ./T65_MCode.vhd:1143:14  */
  assign n4860_o = {28'b0, n4859_o};  //  uext
  /* ./T65_MCode.vhd:1144:11  */
  assign n4862_o = n4860_o == 31'b0000000000000000000000000000000;
  /* ./T65_MCode.vhd:1146:11  */
  assign n4864_o = n4860_o == 31'b0000000000000000000000000000001;
  /* ./T65_MCode.vhd:1148:11  */
  assign n4866_o = n4860_o == 31'b0000000000000000000000000000010;
  /* ./T65_MCode.vhd:1150:11  */
  assign n4868_o = n4860_o == 31'b0000000000000000000000000000011;
  /* ./T65_MCode.vhd:1152:11  */
  assign n4870_o = n4860_o == 31'b0000000000000000000000000000100;
  /* ./T65_MCode.vhd:1154:11  */
  assign n4872_o = n4860_o == 31'b0000000000000000000000000000101;
  /* ./T65_MCode.vhd:1156:11  */
  assign n4874_o = n4860_o == 31'b0000000000000000000000000000110;
  assign n4875_o = {n4874_o, n4872_o, n4870_o, n4868_o, n4866_o, n4864_o, n4862_o};
  /* ./T65_MCode.vhd:1143:9  */
  always @*
    case (n4875_o)
      7'b1000000: n4884_o = 5'b00110;
      7'b0100000: n4884_o = 5'b00101;
      7'b0010000: n4884_o = 5'b00100;
      7'b0001000: n4884_o = 5'b00011;
      7'b0000100: n4884_o = 5'b00010;
      7'b0000010: n4884_o = 5'b00001;
      7'b0000001: n4884_o = 5'b00000;
      default: n4884_o = 5'b00111;
    endcase
  /* ./T65_MCode.vhd:1142:7  */
  assign n4886_o = n4800_o == 2'b01;
  /* ./T65_MCode.vhd:1163:36  */
  assign n4887_o = ir[7:5];
  /* ./T65_MCode.vhd:1163:14  */
  assign n4888_o = {28'b0, n4887_o};  //  uext
  /* ./T65_MCode.vhd:1166:18  */
  assign n4889_o = ir[4:2];
  /* ./T65_MCode.vhd:1166:31  */
  assign n4891_o = n4889_o == 3'b110;
  /* ./T65_MCode.vhd:1166:47  */
  assign n4893_o = mode != 2'b00;
  /* ./T65_MCode.vhd:1166:39  */
  assign n4894_o = n4893_o & n4891_o;
  /* ./T65_MCode.vhd:1166:13  */
  assign n4897_o = n4894_o ? 5'b01110 : 5'b01000;
  /* ./T65_MCode.vhd:1164:11  */
  assign n4900_o = n4888_o == 31'b0000000000000000000000000000000;
  /* ./T65_MCode.vhd:1171:18  */
  assign n4901_o = ir[4:2];
  /* ./T65_MCode.vhd:1171:31  */
  assign n4903_o = n4901_o == 3'b110;
  /* ./T65_MCode.vhd:1171:47  */
  assign n4905_o = mode != 2'b00;
  /* ./T65_MCode.vhd:1171:39  */
  assign n4906_o = n4905_o & n4903_o;
  /* ./T65_MCode.vhd:1171:13  */
  assign n4909_o = n4906_o ? 5'b01101 : 5'b01001;
  /* ./T65_MCode.vhd:1169:11  */
  assign n4912_o = n4888_o == 31'b0000000000000000000000000000001;
  /* ./T65_MCode.vhd:1174:11  */
  assign n4914_o = n4888_o == 31'b0000000000000000000000000000010;
  /* ./T65_MCode.vhd:1176:11  */
  assign n4916_o = n4888_o == 31'b0000000000000000000000000000011;
  /* ./T65_MCode.vhd:1180:18  */
  assign n4917_o = ir[4:2];
  /* ./T65_MCode.vhd:1180:31  */
  assign n4919_o = n4917_o == 3'b010;
  /* ./T65_MCode.vhd:1180:13  */
  assign n4922_o = n4919_o ? 5'b00101 : 5'b00100;
  /* ./T65_MCode.vhd:1178:11  */
  assign n4925_o = n4888_o == 31'b0000000000000000000000000000100;
  /* ./T65_MCode.vhd:1185:11  */
  assign n4927_o = n4888_o == 31'b0000000000000000000000000000101;
  /* ./T65_MCode.vhd:1187:11  */
  assign n4929_o = n4888_o == 31'b0000000000000000000000000000110;
  assign n4930_o = {n4929_o, n4927_o, n4925_o, n4916_o, n4914_o, n4912_o, n4900_o};
  /* ./T65_MCode.vhd:1163:9  */
  always @*
    case (n4930_o)
      7'b1000000: n4936_o = 5'b01101;
      7'b0100000: n4936_o = 5'b00101;
      7'b0010000: n4936_o = n4922_o;
      7'b0001000: n4936_o = 5'b01011;
      7'b0000100: n4936_o = 5'b01010;
      7'b0000010: n4936_o = n4909_o;
      7'b0000001: n4936_o = n4897_o;
      default: n4936_o = 5'b01110;
    endcase
  /* ./T65_MCode.vhd:1162:7  */
  assign n4938_o = n4800_o == 2'b10;
  /* ./T65_MCode.vhd:1194:36  */
  assign n4939_o = ir[7:5];
  /* ./T65_MCode.vhd:1194:14  */
  assign n4940_o = {28'b0, n4939_o};  //  uext
  /* ./T65_MCode.vhd:1197:18  */
  assign n4942_o = ir == 8'b10111011;
  /* ./T65_MCode.vhd:1197:13  */
  assign n4945_o = n4942_o ? 5'b00001 : 5'b00101;
  /* ./T65_MCode.vhd:1196:11  */
  assign n4947_o = n4940_o == 31'b0000000000000000000000000000101;
  /* ./T65_MCode.vhd:1211:18  */
  assign n4949_o = ir == 8'b01101011;
  /* ./T65_MCode.vhd:1213:21  */
  assign n4951_o = ir == 8'b10001011;
  /* ./T65_MCode.vhd:1215:21  */
  assign n4953_o = ir == 8'b00001011;
  /* ./T65_MCode.vhd:1215:33  */
  assign n4955_o = ir == 8'b00101011;
  /* ./T65_MCode.vhd:1215:28  */
  assign n4956_o = n4953_o | n4955_o;
  /* ./T65_MCode.vhd:1217:21  */
  assign n4958_o = ir == 8'b11101011;
  /* ./T65_MCode.vhd:1220:42  */
  assign n4959_o = ir[7:5];
  /* ./T65_MCode.vhd:1220:20  */
  assign n4960_o = {28'b0, n4959_o};  //  uext
  /* ./T65_MCode.vhd:1221:17  */
  assign n4962_o = n4960_o == 31'b0000000000000000000000000000000;
  /* ./T65_MCode.vhd:1223:17  */
  assign n4964_o = n4960_o == 31'b0000000000000000000000000000001;
  /* ./T65_MCode.vhd:1225:17  */
  assign n4966_o = n4960_o == 31'b0000000000000000000000000000010;
  /* ./T65_MCode.vhd:1227:17  */
  assign n4968_o = n4960_o == 31'b0000000000000000000000000000011;
  /* ./T65_MCode.vhd:1229:17  */
  assign n4970_o = n4960_o == 31'b0000000000000000000000000000100;
  /* ./T65_MCode.vhd:1231:17  */
  assign n4972_o = n4960_o == 31'b0000000000000000000000000000101;
  /* ./T65_MCode.vhd:1233:17  */
  assign n4974_o = n4960_o == 31'b0000000000000000000000000000110;
  assign n4975_o = {n4974_o, n4972_o, n4970_o, n4968_o, n4966_o, n4964_o, n4962_o};
  /* ./T65_MCode.vhd:1220:15  */
  always @*
    case (n4975_o)
      7'b1000000: n4984_o = 5'b00110;
      7'b0100000: n4984_o = 5'b00101;
      7'b0010000: n4984_o = 5'b00100;
      7'b0001000: n4984_o = 5'b00011;
      7'b0000100: n4984_o = 5'b00010;
      7'b0000010: n4984_o = 5'b00001;
      7'b0000001: n4984_o = 5'b00000;
      default: n4984_o = 5'b00111;
    endcase
  /* ./T65_MCode.vhd:1239:42  */
  assign n4985_o = ir[7:5];
  /* ./T65_MCode.vhd:1239:20  */
  assign n4986_o = {28'b0, n4985_o};  //  uext
  /* ./T65_MCode.vhd:1240:17  */
  assign n4988_o = n4986_o == 31'b0000000000000000000000000000000;
  /* ./T65_MCode.vhd:1242:17  */
  assign n4990_o = n4986_o == 31'b0000000000000000000000000000001;
  /* ./T65_MCode.vhd:1244:17  */
  assign n4992_o = n4986_o == 31'b0000000000000000000000000000010;
  /* ./T65_MCode.vhd:1246:17  */
  assign n4994_o = n4986_o == 31'b0000000000000000000000000000011;
  /* ./T65_MCode.vhd:1248:17  */
  assign n4996_o = n4986_o == 31'b0000000000000000000000000000100;
  /* ./T65_MCode.vhd:1250:17  */
  assign n4998_o = n4986_o == 31'b0000000000000000000000000000101;
  /* ./T65_MCode.vhd:1254:24  */
  assign n4999_o = ir[4:2];
  /* ./T65_MCode.vhd:1254:36  */
  assign n5001_o = n4999_o == 3'b010;
  /* ./T65_MCode.vhd:1254:19  */
  assign n5004_o = n5001_o ? 5'b10001 : 5'b01101;
  /* ./T65_MCode.vhd:1252:17  */
  assign n5007_o = n4986_o == 31'b0000000000000000000000000000110;
  assign n5008_o = {n5007_o, n4998_o, n4996_o, n4994_o, n4992_o, n4990_o, n4988_o};
  /* ./T65_MCode.vhd:1239:15  */
  always @*
    case (n5008_o)
      7'b1000000: n5016_o = n5004_o;
      7'b0100000: n5016_o = 5'b00101;
      7'b0010000: n5016_o = 5'b01100;
      7'b0001000: n5016_o = 5'b01011;
      7'b0000100: n5016_o = 5'b01010;
      7'b0000010: n5016_o = 5'b01001;
      7'b0000001: n5016_o = 5'b01000;
      default: n5016_o = 5'b01110;
    endcase
  /* ./T65_MCode.vhd:1219:13  */
  assign n5017_o = alumore ? n4984_o : n5016_o;
  /* ./T65_MCode.vhd:1217:13  */
  assign n5019_o = n4958_o ? 5'b00111 : n5017_o;
  /* ./T65_MCode.vhd:1215:13  */
  assign n5021_o = n4956_o ? 5'b10000 : n5019_o;
  /* ./T65_MCode.vhd:1213:13  */
  assign n5023_o = n4951_o ? 5'b10010 : n5021_o;
  /* ./T65_MCode.vhd:1211:13  */
  assign n5025_o = n4949_o ? 5'b01111 : n5023_o;
  /* ./T65_MCode.vhd:1194:9  */
  always @*
    case (n4947_o)
      1'b1: n5026_o = n4945_o;
      default: n5026_o = n5025_o;
    endcase
  assign n5027_o = {n4938_o, n4886_o, n4858_o};
  /* ./T65_MCode.vhd:1092:5  */
  always @*
    case (n5027_o)
      3'b100: n5028_o = n4936_o;
      3'b010: n5028_o = n4884_o;
      3'b001: n5028_o = n4856_o;
      default: n5028_o = n5026_o;
    endcase
endmodule

module drive_ii
  (input  clk_14m,
   input  clk_2m,
   input  phase_zero,
   input  reset,
   input  disk_ready,
   input  [7:0] d_in,
   input  disk_active,
   input  [3:0] motor_phase,
   input  write_mode,
   input  read_disk,
   input  write_reg,
   input  [7:0] track_do,
   input  track_busy,
   output [7:0] d_out,
   output [5:0] track,
   output [12:0] track_addr,
   output [7:0] track_di,
   output track_we);
  wire clk_2m_d;
  wire [7:0] phase;
  wire [12:0] track_byte_addr;
  reg [7:0] data_reg;
  reg reset_data_reg;
  wire [30:0] n2577_o;
  wire [31:0] n2578_o;
  wire [1:0] n2579_o;
  wire [1:0] n2580_o;
  wire [1:0] n2581_o;
  wire [3:0] n2582_o;
  wire n2584_o;
  wire [2:0] n2585_o;
  wire n2586_o;
  wire [3:0] n2587_o;
  wire n2589_o;
  wire n2591_o;
  wire n2592_o;
  wire [2:0] n2593_o;
  wire [3:0] n2594_o;
  wire n2596_o;
  wire [3:0] n2597_o;
  reg [3:0] n2598_o;
  wire n2599_o;
  wire n2601_o;
  wire n2603_o;
  wire n2605_o;
  wire n2607_o;
  wire n2609_o;
  wire n2611_o;
  wire n2613_o;
  wire n2615_o;
  wire n2617_o;
  wire n2619_o;
  wire n2621_o;
  wire n2623_o;
  wire n2625_o;
  wire [12:0] n2626_o;
  reg [31:0] n2641_o;
  wire n2643_o;
  wire n2645_o;
  wire n2647_o;
  wire n2649_o;
  wire n2651_o;
  wire n2653_o;
  wire n2655_o;
  wire n2657_o;
  wire n2659_o;
  wire n2661_o;
  wire n2663_o;
  wire n2665_o;
  wire n2667_o;
  wire [12:0] n2668_o;
  reg [31:0] n2683_o;
  wire [31:0] n2684_o;
  wire [31:0] n2686_o;
  wire n2688_o;
  wire [31:0] n2689_o;
  wire n2691_o;
  wire [31:0] n2692_o;
  wire [31:0] n2694_o;
  wire [31:0] n2696_o;
  wire [30:0] n2697_o;
  wire [7:0] n2698_o;
  wire [5:0] n2725_o;
  reg [5:0] read_head_byte_delay;
  wire n2729_o;
  wire n2730_o;
  wire n2731_o;
  wire n2732_o;
  wire [5:0] n2734_o;
  wire n2735_o;
  wire [7:0] n2737_o;
  wire n2739_o;
  wire n2741_o;
  wire [15:0] n2742_o;
  wire n2744_o;
  wire [12:0] n2746_o;
  wire [12:0] n2748_o;
  wire [12:0] n2749_o;
  wire [7:0] n2750_o;
  wire n2751_o;
  wire n2753_o;
  wire [7:0] n2754_o;
  wire n2755_o;
  wire n2756_o;
  wire [15:0] n2757_o;
  wire n2759_o;
  wire [12:0] n2761_o;
  wire [12:0] n2763_o;
  wire n2765_o;
  wire [12:0] n2766_o;
  wire n2768_o;
  wire [12:0] n2769_o;
  wire [7:0] n2770_o;
  wire n2773_o;
  wire n2777_o;
  wire [5:0] n2795_o;
  reg [5:0] n2796_q;
  wire n2797_o;
  wire n2798_o;
  reg n2799_q;
  wire [7:0] n2800_o;
  reg [7:0] n2801_q;
  wire [12:0] n2802_o;
  reg [12:0] n2803_q;
  wire n2804_o;
  wire n2805_o;
  wire [7:0] n2806_o;
  reg [7:0] n2807_q;
  wire n2808_o;
  reg n2809_q;
  wire n2810_o;
  wire n2811_o;
  reg n2812_q;
  assign d_out = data_reg;
  assign track = n2725_o;
  assign track_addr = track_byte_addr;
  assign track_di = data_reg;
  assign track_we = n2812_q;
  /* ./drive_ii.vhd:40:10  */
  assign clk_2m_d = n2799_q; // (signal)
  /* ./drive_ii.vhd:45:10  */
  assign phase = n2801_q; // (signal)
  /* ./drive_ii.vhd:47:10  */
  assign track_byte_addr = n2803_q; // (signal)
  /* ./drive_ii.vhd:48:10  */
  always @*
    data_reg = n2807_q; // (isignal)
  initial
    data_reg = 8'b00000000;
  /* ./drive_ii.vhd:49:10  */
  always @*
    reset_data_reg = n2809_q; // (isignal)
  initial
    reset_data_reg = 1'b0;
  /* ./drive_ii.vhd:63:24  */
  assign n2577_o = {23'b0, phase};  //  uext
  /* ./drive_ii.vhd:63:11  */
  assign n2578_o = {1'b0, n2577_o};  //  uext
  /* ./drive_ii.vhd:65:21  */
  assign n2579_o = phase[2:1];
  /* ./drive_ii.vhd:67:37  */
  assign n2580_o = motor_phase[1:0];
  /* ./drive_ii.vhd:67:61  */
  assign n2581_o = motor_phase[3:2];
  /* ./drive_ii.vhd:67:50  */
  assign n2582_o = {n2580_o, n2581_o};
  /* ./drive_ii.vhd:66:13  */
  assign n2584_o = n2579_o == 2'b00;
  /* ./drive_ii.vhd:69:37  */
  assign n2585_o = motor_phase[2:0];
  /* ./drive_ii.vhd:69:61  */
  assign n2586_o = motor_phase[3];
  /* ./drive_ii.vhd:69:50  */
  assign n2587_o = {n2585_o, n2586_o};
  /* ./drive_ii.vhd:68:13  */
  assign n2589_o = n2579_o == 2'b01;
  /* ./drive_ii.vhd:70:13  */
  assign n2591_o = n2579_o == 2'b10;
  /* ./drive_ii.vhd:72:37  */
  assign n2592_o = motor_phase[0];
  /* ./drive_ii.vhd:72:52  */
  assign n2593_o = motor_phase[3:1];
  /* ./drive_ii.vhd:72:41  */
  assign n2594_o = {n2592_o, n2593_o};
  /* ./drive_ii.vhd:71:13  */
  assign n2596_o = n2579_o == 2'b11;
  /* ./T65.vhd:147:5  */
  assign n2597_o = {n2596_o, n2591_o, n2589_o, n2584_o};
  /* ./drive_ii.vhd:65:11  */
  always @*
    case (n2597_o)
      4'b1000: n2598_o = n2594_o;
      4'b0100: n2598_o = motor_phase;
      4'b0010: n2598_o = n2587_o;
      4'b0001: n2598_o = n2582_o;
      default: n2598_o = motor_phase;
    endcase
  /* ./drive_ii.vhd:76:19  */
  assign n2599_o = phase[0];
  /* ./drive_ii.vhd:78:15  */
  assign n2601_o = n2598_o == 4'b0000;
  /* ./drive_ii.vhd:79:15  */
  assign n2603_o = n2598_o == 4'b0001;
  /* ./drive_ii.vhd:80:15  */
  assign n2605_o = n2598_o == 4'b0010;
  /* ./drive_ii.vhd:81:15  */
  assign n2607_o = n2598_o == 4'b0011;
  /* ./drive_ii.vhd:82:15  */
  assign n2609_o = n2598_o == 4'b0100;
  /* ./drive_ii.vhd:83:15  */
  assign n2611_o = n2598_o == 4'b0101;
  /* ./drive_ii.vhd:84:15  */
  assign n2613_o = n2598_o == 4'b0110;
  /* ./drive_ii.vhd:85:15  */
  assign n2615_o = n2598_o == 4'b0111;
  /* ./drive_ii.vhd:86:15  */
  assign n2617_o = n2598_o == 4'b1000;
  /* ./drive_ii.vhd:87:15  */
  assign n2619_o = n2598_o == 4'b1001;
  /* ./drive_ii.vhd:88:15  */
  assign n2621_o = n2598_o == 4'b1010;
  /* ./drive_ii.vhd:89:15  */
  assign n2623_o = n2598_o == 4'b1011;
  /* ./drive_ii.vhd:90:15  */
  assign n2625_o = n2598_o == 4'b1111;
  assign n2626_o = {n2625_o, n2623_o, n2621_o, n2619_o, n2617_o, n2615_o, n2613_o, n2611_o, n2609_o, n2607_o, n2605_o, n2603_o, n2601_o};
  /* ./drive_ii.vhd:77:13  */
  always @*
    case (n2626_o)
      13'b1000000000000: n2641_o = 32'b00000000000000000000000000000000;
      13'b0100000000000: n2641_o = 32'b11111111111111111111111111111101;
      13'b0010000000000: n2641_o = 32'b00000000000000000000000000000001;
      13'b0001000000000: n2641_o = 32'b00000000000000000000000000000000;
      13'b0000100000000: n2641_o = 32'b00000000000000000000000000000011;
      13'b0000010000000: n2641_o = 32'b11111111111111111111111111111111;
      13'b0000001000000: n2641_o = 32'b00000000000000000000000000000000;
      13'b0000000100000: n2641_o = 32'b11111111111111111111111111111111;
      13'b0000000010000: n2641_o = 32'b00000000000000000000000000000001;
      13'b0000000001000: n2641_o = 32'b11111111111111111111111111111110;
      13'b0000000000100: n2641_o = 32'b11111111111111111111111111111111;
      13'b0000000000010: n2641_o = 32'b11111111111111111111111111111101;
      13'b0000000000001: n2641_o = 32'b00000000000000000000000000000000;
      default: n2641_o = 32'b00000000000000000000000000000000;
    endcase
  /* ./drive_ii.vhd:95:15  */
  assign n2643_o = n2598_o == 4'b0000;
  /* ./drive_ii.vhd:96:15  */
  assign n2645_o = n2598_o == 4'b0001;
  /* ./drive_ii.vhd:97:15  */
  assign n2647_o = n2598_o == 4'b0010;
  /* ./drive_ii.vhd:98:15  */
  assign n2649_o = n2598_o == 4'b0011;
  /* ./drive_ii.vhd:99:15  */
  assign n2651_o = n2598_o == 4'b0100;
  /* ./drive_ii.vhd:100:15  */
  assign n2653_o = n2598_o == 4'b0101;
  /* ./drive_ii.vhd:101:15  */
  assign n2655_o = n2598_o == 4'b0110;
  /* ./drive_ii.vhd:102:15  */
  assign n2657_o = n2598_o == 4'b0111;
  /* ./drive_ii.vhd:103:15  */
  assign n2659_o = n2598_o == 4'b1000;
  /* ./drive_ii.vhd:104:15  */
  assign n2661_o = n2598_o == 4'b1001;
  /* ./drive_ii.vhd:105:15  */
  assign n2663_o = n2598_o == 4'b1010;
  /* ./drive_ii.vhd:106:15  */
  assign n2665_o = n2598_o == 4'b1011;
  /* ./drive_ii.vhd:107:15  */
  assign n2667_o = n2598_o == 4'b1111;
  /* ./T65.vhd:462:11  */
  assign n2668_o = {n2667_o, n2665_o, n2663_o, n2661_o, n2659_o, n2657_o, n2655_o, n2653_o, n2651_o, n2649_o, n2647_o, n2645_o, n2643_o};
  /* ./drive_ii.vhd:94:13  */
  always @*
    case (n2668_o)
      13'b1000000000000: n2683_o = 32'b00000000000000000000000000000000;
      13'b0100000000000: n2683_o = 32'b11111111111111111111111111111110;
      13'b0010000000000: n2683_o = 32'b00000000000000000000000000000010;
      13'b0001000000000: n2683_o = 32'b00000000000000000000000000000001;
      13'b0000100000000: n2683_o = 32'b00000000000000000000000000000000;
      13'b0000010000000: n2683_o = 32'b00000000000000000000000000000000;
      13'b0000001000000: n2683_o = 32'b00000000000000000000000000000001;
      13'b0000000100000: n2683_o = 32'b00000000000000000000000000000000;
      13'b0000000010000: n2683_o = 32'b00000000000000000000000000000010;
      13'b0000000001000: n2683_o = 32'b11111111111111111111111111111111;
      13'b0000000000100: n2683_o = 32'b00000000000000000000000000000000;
      13'b0000000000010: n2683_o = 32'b11111111111111111111111111111110;
      13'b0000000000001: n2683_o = 32'b00000000000000000000000000000000;
      default: n2683_o = 32'b00000000000000000000000000000000;
    endcase
  /* ./drive_ii.vhd:76:11  */
  assign n2684_o = n2599_o ? n2641_o : n2683_o;
  /* ./drive_ii.vhd:112:24  */
  assign n2686_o = n2578_o + n2684_o;
  /* ./drive_ii.vhd:112:39  */
  assign n2688_o = $signed(n2686_o) <= $signed(32'b00000000000000000000000000000000);
  /* ./drive_ii.vhd:114:27  */
  assign n2689_o = n2578_o + n2684_o;
  /* ./drive_ii.vhd:114:42  */
  assign n2691_o = $signed(n2689_o) > $signed(32'b00000000000000000000000010001011);
  /* ./drive_ii.vhd:117:36  */
  assign n2692_o = n2578_o + n2684_o;
  /* ./drive_ii.vhd:114:11  */
  assign n2694_o = n2691_o ? 32'b00000000000000000000000010001011 : n2692_o;
  /* ./drive_ii.vhd:112:11  */
  assign n2696_o = n2688_o ? 32'b00000000000000000000000000000000 : n2694_o;
  /* ./drive_ii.vhd:119:32  */
  assign n2697_o = n2696_o[30:0];  // trunc
  /* ./drive_ii.vhd:119:20  */
  assign n2698_o = n2697_o[7:0];  // trunc
  /* ./drive_ii.vhd:124:17  */
  assign n2725_o = phase[7:2];
  /* ./drive_ii.vhd:128:12  */
  always @*
    read_head_byte_delay = n2796_q; // (isignal)
  initial
    read_head_byte_delay = 6'bX;
  /* ./drive_ii.vhd:138:36  */
  assign n2729_o = ~clk_2m_d;
  /* ./drive_ii.vhd:138:23  */
  assign n2730_o = n2729_o & clk_2m;
  /* ./drive_ii.vhd:138:42  */
  assign n2731_o = disk_ready & n2730_o;
  /* ./drive_ii.vhd:138:63  */
  assign n2732_o = disk_active & n2731_o;
  /* ./drive_ii.vhd:139:34  */
  assign n2734_o = read_head_byte_delay - 6'b000001;
  /* ./drive_ii.vhd:141:23  */
  assign n2735_o = ~write_mode;
  /* ./drive_ii.vhd:143:11  */
  assign n2737_o = reset_data_reg ? 8'b00000000 : data_reg;
  /* ./drive_ii.vhd:143:11  */
  assign n2739_o = reset_data_reg ? 1'b0 : reset_data_reg;
  /* ./drive_ii.vhd:148:25  */
  assign n2741_o = n2734_o == 6'b000000;
  /* ./drive_ii.vhd:150:32  */
  assign n2742_o = {3'b0, track_byte_addr};  //  uext
  /* ./drive_ii.vhd:150:32  */
  assign n2744_o = n2742_o == 16'b0001100111111111;
  /* ./drive_ii.vhd:153:50  */
  assign n2746_o = track_byte_addr + 13'b0000000000001;
  /* ./drive_ii.vhd:150:13  */
  assign n2748_o = n2744_o ? 13'b0000000000000 : n2746_o;
  /* ./drive_ii.vhd:148:11  */
  assign n2749_o = n2741_o ? n2748_o : track_byte_addr;
  /* ./drive_ii.vhd:148:11  */
  assign n2750_o = n2741_o ? track_do : n2737_o;
  /* ./drive_ii.vhd:156:30  */
  assign n2751_o = phase_zero & read_disk;
  /* ./drive_ii.vhd:156:11  */
  assign n2753_o = n2751_o ? 1'b1 : n2739_o;
  /* ./drive_ii.vhd:161:11  */
  assign n2754_o = write_reg ? d_in : data_reg;
  /* ./drive_ii.vhd:162:30  */
  assign n2755_o = phase_zero & read_disk;
  /* ./drive_ii.vhd:163:25  */
  assign n2756_o = ~track_busy;
  /* ./drive_ii.vhd:164:32  */
  assign n2757_o = {3'b0, track_byte_addr};  //  uext
  /* ./drive_ii.vhd:164:32  */
  assign n2759_o = n2757_o == 16'b0001100111111111;
  /* ./drive_ii.vhd:167:50  */
  assign n2761_o = track_byte_addr + 13'b0000000000001;
  /* ./drive_ii.vhd:164:13  */
  assign n2763_o = n2759_o ? 13'b0000000000000 : n2761_o;
  /* ./drive_ii.vhd:162:11  */
  assign n2765_o = n2755_o ? n2756_o : 1'b0;
  /* ./drive_ii.vhd:162:11  */
  assign n2766_o = n2755_o ? n2763_o : track_byte_addr;
  /* ./drive_ii.vhd:141:9  */
  assign n2768_o = n2735_o ? 1'b0 : n2765_o;
  /* ./drive_ii.vhd:141:9  */
  assign n2769_o = n2735_o ? n2749_o : n2766_o;
  /* ./drive_ii.vhd:141:9  */
  assign n2770_o = n2735_o ? n2750_o : n2754_o;
  /* ./drive_ii.vhd:138:7  */
  assign n2773_o = n2732_o ? n2768_o : 1'b0;
  /* ./drive_ii.vhd:138:7  */
  assign n2777_o = n2735_o & n2732_o;
  /* ./drive_ii.vhd:134:5  */
  assign n2795_o = n2732_o ? n2734_o : read_head_byte_delay;
  /* ./drive_ii.vhd:134:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n2796_q <= 6'b000000;
    else
      n2796_q <= n2795_o;
  /* ./drive_ii.vhd:127:3  */
  assign n2797_o = ~reset;
  /* ./drive_ii.vhd:134:5  */
  assign n2798_o = n2797_o ? clk_2m : clk_2m_d;
  /* ./drive_ii.vhd:134:5  */
  always @(posedge clk_14m)
    n2799_q <= n2798_o;
  /* ./drive_ii.vhd:60:7  */
  assign n2800_o = disk_active ? n2698_o : phase;
  /* ./drive_ii.vhd:60:7  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n2801_q <= 8'b01000110;
    else
      n2801_q <= n2800_o;
  /* ./drive_ii.vhd:134:5  */
  assign n2802_o = n2732_o ? n2769_o : track_byte_addr;
  /* ./drive_ii.vhd:134:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n2803_q <= 13'b0000000000000;
    else
      n2803_q <= n2802_o;
  /* ./drive_ii.vhd:127:3  */
  assign n2804_o = ~reset;
  /* ./drive_ii.vhd:127:3  */
  assign n2805_o = n2732_o & n2804_o;
  /* ./drive_ii.vhd:134:5  */
  assign n2806_o = n2805_o ? n2770_o : data_reg;
  /* ./drive_ii.vhd:134:5  */
  always @(posedge clk_14m)
    n2807_q <= n2806_o;
  initial
    n2807_q = 8'b00000000;
  /* ./drive_ii.vhd:134:5  */
  assign n2808_o = n2777_o ? n2753_o : reset_data_reg;
  /* ./drive_ii.vhd:134:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n2809_q <= 1'b0;
    else
      n2809_q <= n2808_o;
  /* ./drive_ii.vhd:127:3  */
  assign n2810_o = ~reset;
  /* ./drive_ii.vhd:134:5  */
  assign n2811_o = n2810_o ? n2773_o : n2812_q;
  /* ./drive_ii.vhd:134:5  */
  always @(posedge clk_14m)
    n2812_q <= n2811_o;
endmodule

module t65
  (input  [1:0] mode,
   input  bcd_en,
   input  res_n,
   input  enable,
   input  clk,
   input  rdy,
   input  abort_n,
   input  irq_n,
   input  nmi_n,
   input  so_n,
   input  [7:0] di,
   output r_w_n,
   output sync,
   output ef,
   output mf,
   output xf,
   output ml_n,
   output vp_n,
   output vda,
   output vpa,
   output [23:0] a,
   output [7:0] do,
   output [63:0] regs,
   output [7:0] debug_i,
   output [7:0] debug_a,
   output [7:0] debug_x,
   output [7:0] debug_y,
   output [7:0] debug_s,
   output [7:0] debug_p,
   output nmi_ack);
  wire [7:0] n1550_o;
  wire [7:0] n1551_o;
  wire [7:0] n1552_o;
  wire [7:0] n1553_o;
  wire [7:0] n1554_o;
  wire [7:0] n1555_o;
  wire [15:0] abc;
  wire [15:0] x;
  wire [15:0] y;
  reg [7:0] p;
  reg [7:0] ad;
  reg [7:0] dl;
  wire [7:0] pwithb;
  wire [7:0] bah;
  wire [8:0] bal;
  wire [7:0] pbr;
  wire [7:0] dbr;
  wire [15:0] pc;
  wire [15:0] s;
  wire ef_i;
  wire mf_i;
  wire xf_i;
  wire [7:0] ir;
  wire [2:0] mcycle;
  wire [7:0] do_r;
  wire [1:0] mode_r;
  wire bcd_en_r;
  wire [4:0] alu_op_r;
  wire [3:0] write_data_r;
  wire [1:0] set_addr_to_r;
  wire [8:0] pcadder;
  wire rstcycle;
  wire irqcycle;
  wire nmicycle;
  wire so_n_o;
  wire irq_n_o;
  wire nmi_n_o;
  wire nmiact;
  wire break;
  wire [7:0] busa;
  wire [7:0] busa_r;
  wire [7:0] busb;
  wire [7:0] busb_r;
  wire [7:0] alu_q;
  wire [7:0] p_out;
  wire [2:0] lcycle;
  wire [4:0] alu_op;
  wire [3:0] set_busa_to;
  wire [1:0] set_addr_to;
  wire [3:0] write_data;
  wire [1:0] jump;
  wire [1:0] baadd;
  wire [1:0] baquirk;
  wire breakatna;
  wire adadd;
  wire addy;
  wire pcadd;
  wire inc_s;
  wire dec_s;
  wire lda;
  wire ldp;
  wire ldx;
  wire ldy;
  wire lds;
  wire lddi;
  wire ldalu;
  wire ldad;
  wire ldbal;
  wire ldbah;
  wire savep;
  wire write;
  wire res_n_i;
  wire res_n_d;
  wire rdy_mod;
  wire really_rdy;
  wire wrn_i;
  wire nmi_entered;
  wire n1560_o;
  wire n1561_o;
  wire n1564_o;
  wire n1565_o;
  wire [1:0] n1568_o;
  wire n1570_o;
  wire [1:0] n1571_o;
  wire n1573_o;
  wire n1574_o;
  wire [1:0] n1575_o;
  wire n1577_o;
  wire n1578_o;
  wire n1579_o;
  wire n1583_o;
  wire n1585_o;
  wire n1586_o;
  wire n1587_o;
  wire n1588_o;
  wire n1592_o;
  wire n1593_o;
  wire n1596_o;
  wire n1597_o;
  wire n1598_o;
  wire [7:0] n1600_o;
  wire [7:0] n1601_o;
  wire [7:0] n1602_o;
  wire [7:0] n1603_o;
  wire [31:0] n1604_o;
  wire [39:0] n1605_o;
  wire [7:0] n1606_o;
  wire [47:0] n1607_o;
  wire [7:0] n1608_o;
  wire [55:0] n1609_o;
  wire [7:0] n1610_o;
  wire [63:0] n1611_o;
  wire [2:0] mcode_lcycle;
  wire [4:0] mcode_alu_op;
  wire [3:0] mcode_set_busa_to;
  wire [1:0] mcode_set_addr_to;
  wire [3:0] mcode_write_data;
  wire [1:0] mcode_jump;
  wire [1:0] mcode_baadd;
  wire [1:0] mcode_baquirk;
  wire mcode_breakatna;
  wire mcode_adadd;
  wire mcode_addy;
  wire mcode_pcadd;
  wire mcode_inc_s;
  wire mcode_dec_s;
  wire mcode_lda;
  wire mcode_ldp;
  wire mcode_ldx;
  wire mcode_ldy;
  wire mcode_lds;
  wire mcode_lddi;
  wire mcode_ldalu;
  wire mcode_ldad;
  wire mcode_ldbal;
  wire mcode_ldbah;
  wire mcode_savep;
  wire mcode_write;
  wire [7:0] alu_p_out;
  wire n1642_o;
  wire n1654_o;
  wire n1657_o;
  wire n1659_o;
  wire n1661_o;
  wire n1662_o;
  wire n1664_o;
  wire n1666_o;
  wire n1667_o;
  wire n1668_o;
  wire n1669_o;
  wire n1670_o;
  wire n1672_o;
  wire n1674_o;
  wire n1675_o;
  wire n1676_o;
  wire n1678_o;
  wire n1679_o;
  wire n1680_o;
  wire n1681_o;
  wire [15:0] n1683_o;
  wire n1685_o;
  wire [7:0] n1687_o;
  wire [7:0] n1688_o;
  wire [7:0] n1689_o;
  wire n1690_o;
  wire n1692_o;
  wire [1:0] n1697_o;
  wire [15:0] n1699_o;
  wire [7:0] n1700_o;
  wire [15:0] n1701_o;
  wire [15:0] n1702_o;
  wire n1703_o;
  wire n1705_o;
  wire n1706_o;
  wire n1707_o;
  wire [15:0] n1709_o;
  wire [15:0] n1710_o;
  wire n1712_o;
  wire n1714_o;
  wire n1715_o;
  wire n1716_o;
  wire n1717_o;
  wire n1718_o;
  wire n1719_o;
  wire [15:0] n1721_o;
  wire [15:0] n1724_o;
  wire n1726_o;
  wire [15:0] n1727_o;
  wire n1729_o;
  wire n1730_o;
  wire n1731_o;
  wire n1732_o;
  wire [7:0] n1733_o;
  wire [7:0] n1735_o;
  wire [7:0] n1736_o;
  wire [7:0] n1738_o;
  wire [7:0] n1739_o;
  wire [7:0] n1740_o;
  wire [7:0] n1741_o;
  wire [7:0] n1742_o;
  wire [7:0] n1743_o;
  wire [7:0] n1744_o;
  wire [7:0] n1745_o;
  wire [7:0] n1746_o;
  wire n1748_o;
  wire [2:0] n1749_o;
  wire [7:0] n1750_o;
  wire [7:0] n1751_o;
  wire [7:0] n1752_o;
  wire [7:0] n1753_o;
  wire [7:0] n1754_o;
  wire [7:0] n1755_o;
  wire [7:0] n1756_o;
  reg [7:0] n1757_o;
  wire [7:0] n1758_o;
  wire [7:0] n1759_o;
  wire [7:0] n1760_o;
  wire [7:0] n1761_o;
  wire [7:0] n1762_o;
  wire [7:0] n1763_o;
  wire [7:0] n1764_o;
  reg [7:0] n1765_o;
  wire [15:0] n1775_o;
  wire n1784_o;
  wire n1785_o;
  wire n1786_o;
  wire n1791_o;
  wire n1792_o;
  wire n1793_o;
  wire n1794_o;
  wire n1795_o;
  wire n1796_o;
  wire n1797_o;
  wire n1798_o;
  wire n1799_o;
  wire n1800_o;
  wire n1801_o;
  wire n1802_o;
  wire n1803_o;
  wire n1805_o;
  wire [7:0] n1851_o;
  wire [8:0] n1852_o;
  wire n1853_o;
  wire [8:0] n1854_o;
  wire [8:0] n1855_o;
  wire [8:0] n1856_o;
  wire [7:0] n1857_o;
  wire [8:0] n1859_o;
  wire n1863_o;
  wire n1866_o;
  wire n1873_o;
  wire n1874_o;
  wire n1877_o;
  wire n1879_o;
  wire n1881_o;
  wire n1882_o;
  wire [4:0] n1885_o;
  wire n1887_o;
  wire [2:0] n1888_o;
  wire n1891_o;
  wire n1894_o;
  wire n1897_o;
  wire n1900_o;
  wire n1903_o;
  wire n1906_o;
  wire n1909_o;
  wire [6:0] n1910_o;
  wire n1911_o;
  wire n1912_o;
  wire n1913_o;
  wire n1914_o;
  wire n1915_o;
  wire n1916_o;
  wire n1917_o;
  reg n1918_o;
  wire n1919_o;
  wire n1920_o;
  wire n1921_o;
  wire n1922_o;
  wire n1923_o;
  wire n1924_o;
  wire n1925_o;
  reg n1926_o;
  wire n1927_o;
  wire n1928_o;
  wire n1929_o;
  wire n1930_o;
  wire n1931_o;
  wire n1932_o;
  wire n1933_o;
  reg n1934_o;
  wire n1935_o;
  wire n1936_o;
  wire n1937_o;
  wire n1938_o;
  wire n1939_o;
  wire n1940_o;
  wire n1941_o;
  reg n1942_o;
  wire [1:0] n1943_o;
  wire n1944_o;
  wire n1945_o;
  wire n1946_o;
  wire n1947_o;
  wire n1948_o;
  wire n1949_o;
  wire n1950_o;
  wire n1951_o;
  wire n1960_o;
  wire n1961_o;
  wire n1962_o;
  wire n1963_o;
  wire n1964_o;
  wire n1965_o;
  wire n1966_o;
  wire n1967_o;
  wire n1982_o;
  wire n1983_o;
  wire n1984_o;
  wire n1985_o;
  wire n1986_o;
  wire n1987_o;
  wire n1988_o;
  wire n1989_o;
  wire n1990_o;
  wire n1991_o;
  wire n1992_o;
  wire n1993_o;
  wire n1994_o;
  wire n1995_o;
  wire n2012_o;
  wire n2014_o;
  wire n2015_o;
  wire n2016_o;
  wire n2017_o;
  wire n2019_o;
  wire n2020_o;
  wire n2021_o;
  wire n2022_o;
  wire n2023_o;
  wire n2024_o;
  wire n2025_o;
  wire n2026_o;
  wire n2027_o;
  wire n2028_o;
  wire n2029_o;
  wire n2030_o;
  wire n2031_o;
  wire n2032_o;
  wire n2033_o;
  wire n2034_o;
  wire n2035_o;
  wire n2036_o;
  wire n2037_o;
  wire [1:0] n2040_o;
  wire [1:0] n2041_o;
  wire [1:0] n2042_o;
  wire [7:0] n2044_o;
  wire n2046_o;
  wire n2048_o;
  wire n2050_o;
  wire [4:0] n2054_o;
  wire n2056_o;
  wire n2058_o;
  wire n2059_o;
  wire n2060_o;
  wire n2061_o;
  wire [4:0] n2063_o;
  wire n2065_o;
  wire n2067_o;
  wire n2068_o;
  wire n2071_o;
  wire n2073_o;
  wire n2075_o;
  wire n2076_o;
  wire n2077_o;
  wire n2078_o;
  wire n2080_o;
  wire n2081_o;
  wire n2083_o;
  wire n2084_o;
  wire n2085_o;
  wire n2086_o;
  wire n2087_o;
  wire n2088_o;
  wire n2089_o;
  wire [5:0] n2090_o;
  wire [5:0] n2091_o;
  wire [5:0] n2092_o;
  wire [7:0] n2099_o;
  wire n2123_o;
  wire n2126_o;
  wire n2128_o;
  wire n2129_o;
  wire [7:0] n2131_o;
  wire [7:0] n2134_o;
  wire [8:0] n2136_o;
  wire n2138_o;
  wire [7:0] n2139_o;
  wire [8:0] n2140_o;
  wire [8:0] n2141_o;
  wire [8:0] n2142_o;
  wire n2144_o;
  wire n2145_o;
  wire [7:0] n2147_o;
  wire n2149_o;
  wire [7:0] n2151_o;
  wire [7:0] n2152_o;
  wire n2154_o;
  wire n2156_o;
  wire [2:0] n2157_o;
  reg [7:0] n2158_o;
  wire [7:0] n2159_o;
  wire n2161_o;
  wire [2:0] n2162_o;
  reg [7:0] n2163_o;
  reg [7:0] n2164_o;
  reg [8:0] n2165_o;
  wire [7:0] n2166_o;
  wire [7:0] n2167_o;
  wire [7:0] n2168_o;
  wire [7:0] n2169_o;
  wire [7:0] n2170_o;
  wire [7:0] n2171_o;
  wire n2173_o;
  localparam [2:0] n2174_o = 3'b100;
  wire n2176_o;
  wire n2177_o;
  wire n2178_o;
  wire n2179_o;
  localparam [2:0] n2180_o = 3'b010;
  wire n2182_o;
  wire n2185_o;
  localparam [2:0] n2186_o = 3'b110;
  wire n2189_o;
  localparam [8:0] n2191_o = 9'b111111111;
  wire [5:0] n2192_o;
  wire n2194_o;
  wire n2196_o;
  wire n2198_o;
  wire n2199_o;
  wire n2200_o;
  wire n2201_o;
  wire n2202_o;
  wire n2203_o;
  wire [1:0] n2204_o;
  wire [1:0] n2205_o;
  wire [1:0] n2206_o;
  wire [1:0] n2207_o;
  wire [1:0] n2208_o;
  wire [7:0] n2210_o;
  wire [8:0] n2211_o;
  wire n2214_o;
  wire [7:0] n2216_o;
  wire [7:0] n2217_o;
  wire [7:0] n2218_o;
  wire [7:0] n2219_o;
  wire [7:0] n2220_o;
  wire [7:0] n2221_o;
  wire [7:0] n2222_o;
  wire n2223_o;
  wire n2224_o;
  wire n2225_o;
  wire [7:0] n2226_o;
  wire [8:0] n2230_o;
  wire n2234_o;
  wire n2236_o;
  wire n2237_o;
  wire n2238_o;
  wire n2239_o;
  wire n2240_o;
  wire n2241_o;
  wire n2242_o;
  wire n2243_o;
  wire n2268_o;
  wire n2269_o;
  wire n2270_o;
  wire n2271_o;
  wire n2272_o;
  wire n2273_o;
  wire n2274_o;
  wire n2276_o;
  wire [7:0] n2277_o;
  wire n2279_o;
  wire [7:0] n2280_o;
  wire n2282_o;
  wire [7:0] n2283_o;
  wire n2285_o;
  wire [7:0] n2286_o;
  wire n2288_o;
  wire n2290_o;
  wire [7:0] n2291_o;
  wire [7:0] n2292_o;
  wire n2294_o;
  wire [7:0] n2295_o;
  wire [7:0] n2297_o;
  wire [7:0] n2298_o;
  wire n2300_o;
  wire [7:0] n2301_o;
  wire [7:0] n2303_o;
  wire [7:0] n2304_o;
  wire [7:0] n2305_o;
  wire [7:0] n2306_o;
  wire n2308_o;
  wire [7:0] n2309_o;
  wire [7:0] n2310_o;
  wire [7:0] n2311_o;
  wire n2313_o;
  wire n2316_o;
  wire [10:0] n2317_o;
  reg [7:0] n2319_o;
  wire [7:0] n2320_o;
  wire [23:0] n2322_o;
  wire n2324_o;
  wire [15:0] n2326_o;
  wire [23:0] n2327_o;
  wire n2329_o;
  wire [15:0] n2331_o;
  wire [7:0] n2332_o;
  wire [23:0] n2333_o;
  wire n2335_o;
  wire [7:0] n2336_o;
  wire [15:0] n2337_o;
  wire [7:0] n2338_o;
  wire [23:0] n2339_o;
  wire n2341_o;
  wire [3:0] n2342_o;
  reg [23:0] n2344_o;
  wire [7:0] n2346_o;
  wire n2347_o;
  wire [7:0] n2348_o;
  wire n2350_o;
  wire [7:0] n2351_o;
  wire n2353_o;
  wire [7:0] n2354_o;
  wire n2356_o;
  wire [7:0] n2357_o;
  wire n2359_o;
  wire [7:0] n2360_o;
  wire n2362_o;
  wire n2364_o;
  wire [7:0] n2365_o;
  wire n2367_o;
  wire [7:0] n2368_o;
  wire n2370_o;
  wire [7:0] n2371_o;
  wire [7:0] n2372_o;
  wire [7:0] n2373_o;
  wire n2375_o;
  wire [7:0] n2376_o;
  wire [7:0] n2377_o;
  wire [7:0] n2378_o;
  wire [7:0] n2379_o;
  wire n2381_o;
  wire [7:0] n2382_o;
  wire [7:0] n2383_o;
  wire n2385_o;
  wire [7:0] n2386_o;
  wire [7:0] n2387_o;
  wire n2389_o;
  wire n2392_o;
  wire [12:0] n2393_o;
  reg [7:0] n2395_o;
  wire n2398_o;
  wire n2400_o;
  wire n2401_o;
  wire n2403_o;
  wire n2404_o;
  wire n2405_o;
  wire n2406_o;
  wire n2407_o;
  wire n2408_o;
  wire n2411_o;
  wire n2413_o;
  wire n2417_o;
  wire n2420_o;
  wire [2:0] n2422_o;
  wire [2:0] n2424_o;
  wire n2429_o;
  wire n2431_o;
  wire n2432_o;
  wire n2433_o;
  wire n2434_o;
  wire n2435_o;
  wire [4:0] n2436_o;
  wire n2438_o;
  wire n2440_o;
  wire n2441_o;
  wire n2442_o;
  wire n2443_o;
  wire n2445_o;
  wire n2447_o;
  wire n2448_o;
  wire n2449_o;
  wire n2450_o;
  wire n2451_o;
  wire n2469_o;
  wire n2470_o;
  wire [7:0] n2471_o;
  wire [7:0] n2472_o;
  reg [7:0] n2473_q;
  wire [15:0] n2475_o;
  wire n2476_o;
  wire n2477_o;
  wire [7:0] n2478_o;
  wire [7:0] n2479_o;
  reg [7:0] n2480_q;
  wire [15:0] n2482_o;
  wire n2483_o;
  wire n2484_o;
  wire [7:0] n2485_o;
  wire [7:0] n2486_o;
  reg [7:0] n2487_q;
  wire [15:0] n2489_o;
  reg [7:0] n2490_q;
  wire [7:0] n2491_o;
  reg [7:0] n2492_q;
  wire [7:0] n2493_o;
  reg [7:0] n2494_q;
  wire [7:0] n2495_o;
  reg [7:0] n2496_q;
  wire [8:0] n2497_o;
  reg [8:0] n2498_q;
  wire [7:0] n2499_o;
  reg [7:0] n2500_q;
  wire [7:0] n2501_o;
  reg [7:0] n2502_q;
  wire [15:0] n2503_o;
  reg [15:0] n2504_q;
  wire [15:0] n2505_o;
  reg [15:0] n2506_q;
  wire n2507_o;
  reg n2508_q;
  wire n2509_o;
  reg n2510_q;
  wire n2511_o;
  reg n2512_q;
  wire [7:0] n2513_o;
  reg [7:0] n2514_q;
  wire [2:0] n2515_o;
  reg [2:0] n2516_q;
  wire [1:0] n2517_o;
  reg [1:0] n2518_q;
  wire n2519_o;
  reg n2520_q;
  wire [4:0] n2521_o;
  reg [4:0] n2522_q;
  wire [3:0] n2523_o;
  reg [3:0] n2524_q;
  wire [1:0] n2525_o;
  reg [1:0] n2526_q;
  wire n2527_o;
  reg n2528_q;
  wire n2529_o;
  reg n2530_q;
  wire n2531_o;
  reg n2532_q;
  wire n2533_o;
  wire n2534_o;
  reg n2535_q;
  wire n2536_o;
  wire n2537_o;
  wire n2538_o;
  reg n2539_q;
  wire n2540_o;
  wire n2541_o;
  wire n2542_o;
  reg n2543_q;
  wire n2544_o;
  reg n2545_q;
  wire [7:0] n2546_o;
  reg [7:0] n2547_q;
  wire [7:0] n2548_o;
  reg [7:0] n2549_q;
  wire [7:0] n2550_o;
  reg [7:0] n2551_q;
  reg n2552_q;
  reg n2553_q;
  wire n2554_o;
  wire n2555_o;
  wire n2556_o;
  reg n2557_q;
  wire n2558_o;
  reg n2559_q;
  wire n2560_o;
  wire n2561_o;
  wire n2562_o;
  reg n2563_q;
  wire [47:0] n2564_o;
  assign r_w_n = wrn_i;
  assign sync = n1565_o;
  assign ef = ef_i;
  assign mf = mf_i;
  assign xf = xf_i;
  assign ml_n = n1579_o;
  assign vp_n = n1588_o;
  assign vda = n1593_o;
  assign vpa = n1598_o;
  assign a = n2344_o;
  assign do = do_r;
  assign regs = n1611_o;
  assign debug_i = n1550_o;
  assign debug_a = n1551_o;
  assign debug_x = n1552_o;
  assign debug_y = n1553_o;
  assign debug_s = n1554_o;
  assign debug_p = n1555_o;
  assign nmi_ack = nmiact;
  assign n1550_o = n2564_o[7:0];
  assign n1551_o = n2564_o[15:8];
  assign n1552_o = n2564_o[23:16];
  assign n1553_o = n2564_o[31:24];
  assign n1554_o = n2564_o[39:32];
  assign n1555_o = n2564_o[47:40];
  /* ./T65.vhd:169:10  */
  assign abc = n2475_o; // (signal)
  /* ./T65.vhd:169:15  */
  assign x = n2482_o; // (signal)
  /* ./T65.vhd:169:18  */
  assign y = n2489_o; // (signal)
  /* ./T65.vhd:170:10  */
  always @*
    p = n2490_q; // (isignal)
  initial
    p = 8'b00000000;
  /* ./T65.vhd:170:13  */
  always @*
    ad = n2492_q; // (isignal)
  initial
    ad = 8'b00000000;
  /* ./T65.vhd:170:17  */
  always @*
    dl = n2494_q; // (isignal)
  initial
    dl = 8'b00000000;
  /* ./T65.vhd:171:10  */
  assign pwithb = n2348_o; // (signal)
  /* ./T65.vhd:172:10  */
  assign bah = n2496_q; // (signal)
  /* ./T65.vhd:173:10  */
  assign bal = n2498_q; // (signal)
  /* ./T65.vhd:174:10  */
  assign pbr = n2500_q; // (signal)
  /* ./T65.vhd:175:10  */
  assign dbr = n2502_q; // (signal)
  /* ./T65.vhd:176:10  */
  assign pc = n2504_q; // (signal)
  /* ./T65.vhd:177:10  */
  assign s = n2506_q; // (signal)
  /* ./T65.vhd:178:10  */
  assign ef_i = n2508_q; // (signal)
  /* ./T65.vhd:179:10  */
  assign mf_i = n2510_q; // (signal)
  /* ./T65.vhd:180:10  */
  assign xf_i = n2512_q; // (signal)
  /* ./T65.vhd:182:10  */
  assign ir = n2514_q; // (signal)
  /* ./T65.vhd:183:10  */
  assign mcycle = n2516_q; // (signal)
  /* ./T65.vhd:185:10  */
  assign do_r = n2395_o; // (signal)
  /* ./T65.vhd:187:10  */
  assign mode_r = n2518_q; // (signal)
  /* ./T65.vhd:188:10  */
  assign bcd_en_r = n2520_q; // (signal)
  /* ./T65.vhd:189:10  */
  assign alu_op_r = n2522_q; // (signal)
  /* ./T65.vhd:190:10  */
  assign write_data_r = n2524_q; // (signal)
  /* ./T65.vhd:191:10  */
  assign set_addr_to_r = n2526_q; // (signal)
  /* ./T65.vhd:192:10  */
  assign pcadder = n1856_o; // (signal)
  /* ./T65.vhd:194:10  */
  assign rstcycle = n2528_q; // (signal)
  /* ./T65.vhd:195:10  */
  assign irqcycle = n2530_q; // (signal)
  /* ./T65.vhd:196:10  */
  assign nmicycle = n2532_q; // (signal)
  /* ./T65.vhd:198:10  */
  assign so_n_o = n2535_q; // (signal)
  /* ./T65.vhd:199:10  */
  assign irq_n_o = n2539_q; // (signal)
  /* ./T65.vhd:200:10  */
  assign nmi_n_o = n2543_q; // (signal)
  /* ./T65.vhd:201:10  */
  assign nmiact = n2545_q; // (signal)
  /* ./T65.vhd:203:10  */
  assign break = n2274_o; // (signal)
  /* ./T65.vhd:206:10  */
  assign busa = n2319_o; // (signal)
  /* ./T65.vhd:207:10  */
  assign busa_r = n2547_q; // (signal)
  /* ./T65.vhd:208:10  */
  assign busb = n2549_q; // (signal)
  /* ./T65.vhd:209:10  */
  assign busb_r = n2551_q; // (signal)
  /* ./T65.vhd:210:10  */
  /* ./T65.vhd:211:10  */
  assign p_out = alu_p_out; // (signal)
  /* ./T65.vhd:214:10  */
  assign lcycle = mcode_lcycle; // (signal)
  /* ./T65.vhd:215:10  */
  assign alu_op = mcode_alu_op; // (signal)
  /* ./T65.vhd:216:10  */
  assign set_busa_to = mcode_set_busa_to; // (signal)
  /* ./T65.vhd:217:10  */
  assign set_addr_to = mcode_set_addr_to; // (signal)
  /* ./T65.vhd:218:10  */
  assign write_data = mcode_write_data; // (signal)
  /* ./T65.vhd:219:10  */
  assign jump = mcode_jump; // (signal)
  /* ./T65.vhd:220:10  */
  assign baadd = mcode_baadd; // (signal)
  /* ./T65.vhd:221:10  */
  assign baquirk = mcode_baquirk; // (signal)
  /* ./T65.vhd:222:10  */
  assign breakatna = mcode_breakatna; // (signal)
  /* ./T65.vhd:223:10  */
  assign adadd = mcode_adadd; // (signal)
  /* ./T65.vhd:224:10  */
  assign addy = mcode_addy; // (signal)
  /* ./T65.vhd:225:10  */
  assign pcadd = mcode_pcadd; // (signal)
  /* ./T65.vhd:226:10  */
  assign inc_s = mcode_inc_s; // (signal)
  /* ./T65.vhd:227:10  */
  assign dec_s = mcode_dec_s; // (signal)
  /* ./T65.vhd:228:10  */
  assign lda = mcode_lda; // (signal)
  /* ./T65.vhd:229:10  */
  assign ldp = mcode_ldp; // (signal)
  /* ./T65.vhd:230:10  */
  assign ldx = mcode_ldx; // (signal)
  /* ./T65.vhd:231:10  */
  assign ldy = mcode_ldy; // (signal)
  /* ./T65.vhd:232:10  */
  assign lds = mcode_lds; // (signal)
  /* ./T65.vhd:233:10  */
  assign lddi = mcode_lddi; // (signal)
  /* ./T65.vhd:234:10  */
  assign ldalu = mcode_ldalu; // (signal)
  /* ./T65.vhd:235:10  */
  assign ldad = mcode_ldad; // (signal)
  /* ./T65.vhd:236:10  */
  assign ldbal = mcode_ldbal; // (signal)
  /* ./T65.vhd:237:10  */
  assign ldbah = mcode_ldbah; // (signal)
  /* ./T65.vhd:238:10  */
  assign savep = mcode_savep; // (signal)
  /* ./T65.vhd:239:10  */
  assign write = mcode_write; // (signal)
  /* ./T65.vhd:241:10  */
  assign res_n_i = n2552_q; // (signal)
  /* ./T65.vhd:242:10  */
  assign res_n_d = n2553_q; // (signal)
  /* ./T65.vhd:244:10  */
  assign rdy_mod = n2557_q; // (signal)
  /* ./T65.vhd:245:10  */
  assign really_rdy = n1561_o; // (signal)
  /* ./T65.vhd:246:10  */
  assign wrn_i = n2559_q; // (signal)
  /* ./T65.vhd:248:10  */
  assign nmi_entered = n2563_q; // (signal)
  /* ./T65.vhd:254:24  */
  assign n1560_o = ~wrn_i;
  /* ./T65.vhd:254:21  */
  assign n1561_o = rdy | n1560_o;
  /* ./T65.vhd:255:27  */
  assign n1564_o = mcycle == 3'b000;
  /* ./T65.vhd:255:15  */
  assign n1565_o = n1564_o ? 1'b1 : 1'b0;
  /* ./T65.vhd:260:22  */
  assign n1568_o = ir[7:6];
  /* ./T65.vhd:260:35  */
  assign n1570_o = n1568_o != 2'b10;
  /* ./T65.vhd:260:49  */
  assign n1571_o = ir[2:1];
  /* ./T65.vhd:260:62  */
  assign n1573_o = n1571_o == 2'b11;
  /* ./T65.vhd:260:43  */
  assign n1574_o = n1573_o & n1570_o;
  /* ./T65.vhd:260:79  */
  assign n1575_o = mcycle[2:1];
  /* ./T65.vhd:260:92  */
  assign n1577_o = n1575_o != 2'b00;
  /* ./T65.vhd:260:69  */
  assign n1578_o = n1577_o & n1574_o;
  /* ./T65.vhd:260:15  */
  assign n1579_o = n1578_o ? 1'b0 : 1'b1;
  /* ./T65.vhd:261:47  */
  assign n1583_o = mcycle == 3'b101;
  /* ./T65.vhd:261:65  */
  assign n1585_o = mcycle == 3'b110;
  /* ./T65.vhd:261:55  */
  assign n1586_o = n1583_o | n1585_o;
  /* ./T65.vhd:261:35  */
  assign n1587_o = n1586_o & irqcycle;
  /* ./T65.vhd:261:15  */
  assign n1588_o = n1587_o ? 1'b0 : 1'b1;
  /* ./T65.vhd:262:33  */
  assign n1592_o = set_addr_to_r != 2'b00;
  /* ./T65.vhd:262:14  */
  assign n1593_o = n1592_o ? 1'b1 : 1'b0;
  /* ./T65.vhd:263:23  */
  assign n1596_o = jump[1];
  /* ./T65.vhd:263:27  */
  assign n1597_o = ~n1596_o;
  /* ./T65.vhd:263:14  */
  assign n1598_o = n1597_o ? 1'b1 : 1'b0;
  /* ./T65.vhd:267:17  */
  assign n1600_o = abc[7:0];
  /* ./T65.vhd:268:15  */
  assign n1601_o = x[7:0];
  /* ./T65.vhd:269:15  */
  assign n1602_o = y[7:0];
  /* ./T65.vhd:270:32  */
  assign n1603_o = s[7:0];
  /* ./T65.vhd:273:32  */
  assign n1604_o = {pc, s};
  /* ./T65.vhd:273:53  */
  assign n1605_o = {n1604_o, p};
  /* ./T65.vhd:273:60  */
  assign n1606_o = y[7:0];
  /* ./T65.vhd:273:57  */
  assign n1607_o = {n1605_o, n1606_o};
  /* ./T65.vhd:273:76  */
  assign n1608_o = x[7:0];
  /* ./T65.vhd:273:73  */
  assign n1609_o = {n1607_o, n1608_o};
  /* ./T65.vhd:273:94  */
  assign n1610_o = abc[7:0];
  /* ./T65.vhd:273:89  */
  assign n1611_o = {n1609_o, n1610_o};
  /* ./T65.vhd:275:3  */
  t65_mcode mcode (
    .mode(mode_r),
    .ir(ir),
    .mcycle(mcycle),
    .p(p),
    .rdy_mod(rdy_mod),
    .lcycle(mcode_lcycle),
    .alu_op(mcode_alu_op),
    .set_busa_to(mcode_set_busa_to),
    .set_addr_to(mcode_set_addr_to),
    .write_data(mcode_write_data),
    .jump(mcode_jump),
    .baadd(mcode_baadd),
    .baquirk(mcode_baquirk),
    .breakatna(mcode_breakatna),
    .adadd(mcode_adadd),
    .addy(mcode_addy),
    .pcadd(mcode_pcadd),
    .inc_s(mcode_inc_s),
    .dec_s(mcode_dec_s),
    .lda(mcode_lda),
    .ldp(mcode_ldp),
    .ldx(mcode_ldx),
    .ldy(mcode_ldy),
    .lds(mcode_lds),
    .lddi(mcode_lddi),
    .ldalu(mcode_ldalu),
    .ldad(mcode_ldad),
    .ldbal(mcode_ldbal),
    .ldbah(mcode_ldbah),
    .savep(mcode_savep),
    .write(mcode_write));
  /* ./T65.vhd:312:3  */
  t65_alu alu (
    .mode(mode_r),
    .bcd_en(bcd_en_r),
    .op(alu_op_r),
    .busa(busa_r),
    .busb(busb),
    .p_in(p),
    .p_out(alu_p_out),
    .q(alu_q));
  /* ./T65.vhd:328:14  */
  assign n1642_o = ~res_n;
  /* ./T65.vhd:339:16  */
  assign n1654_o = ~res_n_i;
  /* ./T65.vhd:360:20  */
  assign n1657_o = mcycle == 3'b000;
  /* ./T65.vhd:362:24  */
  assign n1659_o = mcycle == 3'b011;
  /* ./T65.vhd:362:39  */
  assign n1661_o = ir != 8'b10010011;
  /* ./T65.vhd:362:32  */
  assign n1662_o = n1661_o & n1659_o;
  /* ./T65.vhd:362:60  */
  assign n1664_o = mcycle == 3'b100;
  /* ./T65.vhd:362:75  */
  assign n1666_o = ir == 8'b10010011;
  /* ./T65.vhd:362:68  */
  assign n1667_o = n1666_o & n1664_o;
  /* ./T65.vhd:362:49  */
  assign n1668_o = n1662_o | n1667_o;
  /* ./T65.vhd:362:93  */
  assign n1669_o = ~rdy;
  /* ./T65.vhd:362:85  */
  assign n1670_o = n1669_o & n1668_o;
  /* ./T65.vhd:362:9  */
  assign n1672_o = n1670_o ? 1'b1 : rdy_mod;
  /* ./T65.vhd:360:9  */
  assign n1674_o = n1657_o ? 1'b0 : n1672_o;
  /* ./T65.vhd:367:20  */
  assign n1675_o = ~write;
  /* ./T65.vhd:367:30  */
  assign n1676_o = n1675_o | rstcycle;
  /* ./T65.vhd:375:22  */
  assign n1678_o = mcycle == 3'b000;
  /* ./T65.vhd:379:25  */
  assign n1679_o = ~irqcycle;
  /* ./T65.vhd:379:44  */
  assign n1680_o = ~nmicycle;
  /* ./T65.vhd:379:31  */
  assign n1681_o = n1680_o & n1679_o;
  /* ./T65.vhd:380:24  */
  assign n1683_o = pc + 16'b0000000000000001;
  /* ./T65.vhd:383:31  */
  assign n1685_o = irqcycle | nmicycle;
  /* ./T65.vhd:383:13  */
  assign n1687_o = n1685_o ? 8'b00000000 : di;
  assign n1688_o = s[7:0];
  /* ./T65.vhd:375:11  */
  assign n1689_o = n1692_o ? alu_q : n1688_o;
  /* ./T65.vhd:375:11  */
  assign n1690_o = n1681_o & n1678_o;
  /* ./T65.vhd:375:11  */
  assign n1692_o = lds & n1678_o;
  /* ./T65.vhd:396:11  */
  assign n1697_o = break ? 2'b00 : set_addr_to;
  /* ./T65.vhd:403:20  */
  assign n1699_o = s + 16'b0000000000000001;
  assign n1700_o = s[15:8];
  assign n1701_o = {n1700_o, n1689_o};
  /* ./T65.vhd:402:11  */
  assign n1702_o = inc_s ? n1699_o : n1701_o;
  /* ./T65.vhd:405:40  */
  assign n1703_o = ~rstcycle;
  /* ./T65.vhd:405:54  */
  assign n1705_o = mode == 2'b00;
  /* ./T65.vhd:405:46  */
  assign n1706_o = n1703_o | n1705_o;
  /* ./T65.vhd:405:26  */
  assign n1707_o = n1706_o & dec_s;
  /* ./T65.vhd:406:20  */
  assign n1709_o = s - 16'b0000000000000001;
  /* ./T65.vhd:405:11  */
  assign n1710_o = n1707_o ? n1709_o : n1702_o;
  /* ./T65.vhd:409:17  */
  assign n1712_o = ir == 8'b00000000;
  /* ./T65.vhd:409:41  */
  assign n1714_o = mcycle == 3'b001;
  /* ./T65.vhd:409:30  */
  assign n1715_o = n1714_o & n1712_o;
  /* ./T65.vhd:409:62  */
  assign n1716_o = ~irqcycle;
  /* ./T65.vhd:409:49  */
  assign n1717_o = n1716_o & n1715_o;
  /* ./T65.vhd:409:81  */
  assign n1718_o = ~nmicycle;
  /* ./T65.vhd:409:68  */
  assign n1719_o = n1718_o & n1717_o;
  /* ./T65.vhd:410:22  */
  assign n1721_o = pc + 16'b0000000000000001;
  /* ./T65.vhd:417:24  */
  assign n1724_o = pc + 16'b0000000000000001;
  /* ./T65.vhd:416:13  */
  assign n1726_o = jump == 2'b01;
  /* ./T65.vhd:419:33  */
  assign n1727_o = {di, dl};
  /* ./T65.vhd:418:13  */
  assign n1729_o = jump == 2'b10;
  /* ./T65.vhd:421:25  */
  assign n1730_o = pcadder[8];
  /* ./T65.vhd:422:22  */
  assign n1731_o = dl[7];
  /* ./T65.vhd:422:26  */
  assign n1732_o = ~n1731_o;
  /* ./T65.vhd:423:40  */
  assign n1733_o = pc[15:8];
  /* ./T65.vhd:423:54  */
  assign n1735_o = n1733_o + 8'b00000001;
  /* ./T65.vhd:425:40  */
  assign n1736_o = pc[15:8];
  /* ./T65.vhd:425:54  */
  assign n1738_o = n1736_o - 8'b00000001;
  /* ./T65.vhd:422:17  */
  assign n1739_o = n1732_o ? n1735_o : n1738_o;
  assign n1740_o = n1721_o[15:8];
  assign n1741_o = n1683_o[15:8];
  assign n1742_o = pc[15:8];
  /* ./T65.vhd:375:11  */
  assign n1743_o = n1690_o ? n1741_o : n1742_o;
  /* ./T65.vhd:409:11  */
  assign n1744_o = n1719_o ? n1740_o : n1743_o;
  /* ./T65.vhd:421:15  */
  assign n1745_o = n1730_o ? n1739_o : n1744_o;
  /* ./T65.vhd:428:40  */
  assign n1746_o = pcadder[7:0];
  /* ./T65.vhd:420:13  */
  assign n1748_o = jump == 2'b11;
  assign n1749_o = {n1748_o, n1729_o, n1726_o};
  assign n1750_o = n1724_o[7:0];
  assign n1751_o = n1727_o[7:0];
  assign n1752_o = n1721_o[7:0];
  assign n1753_o = n1683_o[7:0];
  assign n1754_o = pc[7:0];
  /* ./T65.vhd:375:11  */
  assign n1755_o = n1690_o ? n1753_o : n1754_o;
  /* ./T65.vhd:409:11  */
  assign n1756_o = n1719_o ? n1752_o : n1755_o;
  /* ./T65.vhd:415:11  */
  always @*
    case (n1749_o)
      3'b100: n1757_o = n1746_o;
      3'b010: n1757_o = n1751_o;
      3'b001: n1757_o = n1750_o;
      default: n1757_o = n1756_o;
    endcase
  assign n1758_o = n1724_o[15:8];
  assign n1759_o = n1727_o[15:8];
  assign n1760_o = n1721_o[15:8];
  assign n1761_o = n1683_o[15:8];
  assign n1762_o = pc[15:8];
  /* ./T65.vhd:375:11  */
  assign n1763_o = n1690_o ? n1761_o : n1762_o;
  /* ./T65.vhd:409:11  */
  assign n1764_o = n1719_o ? n1760_o : n1763_o;
  /* ./T65.vhd:415:11  */
  always @*
    case (n1749_o)
      3'b100: n1765_o = n1745_o;
      3'b010: n1765_o = n1759_o;
      3'b001: n1765_o = n1758_o;
      default: n1765_o = n1764_o;
    endcase
  assign n1775_o = {n1765_o, n1757_o};
  /* ./T65.vhd:366:9  */
  assign n1784_o = n1678_o & really_rdy;
  /* ./T65.vhd:366:9  */
  assign n1785_o = n1678_o & really_rdy;
  /* ./T65.vhd:366:9  */
  assign n1786_o = n1678_o & really_rdy;
  /* ./T65.vhd:358:7  */
  assign n1791_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1792_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1793_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1794_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1795_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1796_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1797_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1798_o = n1784_o & enable;
  /* ./T65.vhd:358:7  */
  assign n1799_o = n1785_o & enable;
  /* ./T65.vhd:358:7  */
  assign n1800_o = n1786_o & enable;
  /* ./T65.vhd:358:7  */
  assign n1801_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1802_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1803_o = really_rdy & enable;
  /* ./T65.vhd:358:7  */
  assign n1805_o = really_rdy & enable;
  /* ./T65.vhd:436:23  */
  assign n1851_o = pc[7:0];
  /* ./T65.vhd:436:14  */
  assign n1852_o = {1'b0, n1851_o};  //  uext
  /* ./T65.vhd:436:59  */
  assign n1853_o = dl[7];
  /* ./T65.vhd:436:63  */
  assign n1854_o = {n1853_o, dl};
  /* ./T65.vhd:436:39  */
  assign n1855_o = n1852_o + n1854_o;
  /* ./T65.vhd:436:72  */
  assign n1856_o = pcadd ? n1855_o : n1859_o;
  /* ./T65.vhd:437:23  */
  assign n1857_o = pc[7:0];
  /* ./T65.vhd:437:19  */
  assign n1859_o = {1'b0, n1857_o};
  /* ./T65.vhd:442:16  */
  assign n1863_o = ~res_n_i;
  /* ./T65.vhd:448:21  */
  assign n1866_o = mcycle == 3'b000;
  /* ./T65.vhd:458:21  */
  assign n1873_o = lda | ldx;
  /* ./T65.vhd:458:28  */
  assign n1874_o = n1873_o | ldy;
  /* ./T65.vhd:448:11  */
  assign n1877_o = lda & n1866_o;
  /* ./T65.vhd:448:11  */
  assign n1879_o = ldx & n1866_o;
  /* ./T65.vhd:448:11  */
  assign n1881_o = ldy & n1866_o;
  /* ./T65.vhd:448:11  */
  assign n1882_o = n1874_o & n1866_o;
  /* ./T65.vhd:468:16  */
  assign n1885_o = ir[4:0];
  /* ./T65.vhd:468:29  */
  assign n1887_o = n1885_o == 5'b11000;
  /* ./T65.vhd:469:20  */
  assign n1888_o = ir[7:5];
  /* ./T65.vhd:470:13  */
  assign n1891_o = n1888_o == 3'b000;
  /* ./T65.vhd:472:13  */
  assign n1894_o = n1888_o == 3'b001;
  /* ./T65.vhd:474:13  */
  assign n1897_o = n1888_o == 3'b010;
  /* ./T65.vhd:476:13  */
  assign n1900_o = n1888_o == 3'b011;
  /* ./T65.vhd:478:13  */
  assign n1903_o = n1888_o == 3'b101;
  /* ./T65.vhd:480:13  */
  assign n1906_o = n1888_o == 3'b110;
  /* ./T65.vhd:482:13  */
  assign n1909_o = n1888_o == 3'b111;
  assign n1910_o = {n1909_o, n1906_o, n1903_o, n1900_o, n1897_o, n1894_o, n1891_o};
  assign n1911_o = alu_q[0];
  assign n1912_o = p_out[0];
  assign n1913_o = p_out[0];
  assign n1914_o = p[0];
  /* ./T65.vhd:448:11  */
  assign n1915_o = n1882_o ? n1913_o : n1914_o;
  /* ./T65.vhd:462:11  */
  assign n1916_o = savep ? n1912_o : n1915_o;
  /* ./T65.vhd:465:11  */
  assign n1917_o = ldp ? n1911_o : n1916_o;
  /* ./T65.vhd:469:13  */
  always @*
    case (n1910_o)
      7'b1000000: n1918_o = n1917_o;
      7'b0100000: n1918_o = n1917_o;
      7'b0010000: n1918_o = n1917_o;
      7'b0001000: n1918_o = n1917_o;
      7'b0000100: n1918_o = n1917_o;
      7'b0000010: n1918_o = 1'b1;
      7'b0000001: n1918_o = 1'b0;
      default: n1918_o = n1917_o;
    endcase
  assign n1919_o = alu_q[2];
  assign n1920_o = p_out[2];
  assign n1921_o = p_out[2];
  assign n1922_o = p[2];
  /* ./T65.vhd:448:11  */
  assign n1923_o = n1882_o ? n1921_o : n1922_o;
  /* ./T65.vhd:462:11  */
  assign n1924_o = savep ? n1920_o : n1923_o;
  /* ./T65.vhd:465:11  */
  assign n1925_o = ldp ? n1919_o : n1924_o;
  /* ./T65.vhd:469:13  */
  always @*
    case (n1910_o)
      7'b1000000: n1926_o = n1925_o;
      7'b0100000: n1926_o = n1925_o;
      7'b0010000: n1926_o = n1925_o;
      7'b0001000: n1926_o = 1'b1;
      7'b0000100: n1926_o = 1'b0;
      7'b0000010: n1926_o = n1925_o;
      7'b0000001: n1926_o = n1925_o;
      default: n1926_o = n1925_o;
    endcase
  assign n1927_o = alu_q[3];
  assign n1928_o = p_out[3];
  assign n1929_o = p_out[3];
  assign n1930_o = p[3];
  /* ./T65.vhd:448:11  */
  assign n1931_o = n1882_o ? n1929_o : n1930_o;
  /* ./T65.vhd:462:11  */
  assign n1932_o = savep ? n1928_o : n1931_o;
  /* ./T65.vhd:465:11  */
  assign n1933_o = ldp ? n1927_o : n1932_o;
  /* ./T65.vhd:469:13  */
  always @*
    case (n1910_o)
      7'b1000000: n1934_o = 1'b1;
      7'b0100000: n1934_o = 1'b0;
      7'b0010000: n1934_o = n1933_o;
      7'b0001000: n1934_o = n1933_o;
      7'b0000100: n1934_o = n1933_o;
      7'b0000010: n1934_o = n1933_o;
      7'b0000001: n1934_o = n1933_o;
      default: n1934_o = n1933_o;
    endcase
  assign n1935_o = alu_q[6];
  assign n1936_o = p_out[6];
  assign n1937_o = p_out[6];
  assign n1938_o = p[6];
  /* ./T65.vhd:448:11  */
  assign n1939_o = n1882_o ? n1937_o : n1938_o;
  /* ./T65.vhd:462:11  */
  assign n1940_o = savep ? n1936_o : n1939_o;
  /* ./T65.vhd:465:11  */
  assign n1941_o = ldp ? n1935_o : n1940_o;
  /* ./T65.vhd:469:13  */
  always @*
    case (n1910_o)
      7'b1000000: n1942_o = n1941_o;
      7'b0100000: n1942_o = n1941_o;
      7'b0010000: n1942_o = 1'b0;
      7'b0001000: n1942_o = n1941_o;
      7'b0000100: n1942_o = n1941_o;
      7'b0000010: n1942_o = n1941_o;
      7'b0000001: n1942_o = n1941_o;
      default: n1942_o = n1941_o;
    endcase
  assign n1943_o = {n1934_o, n1926_o};
  assign n1944_o = alu_q[0];
  assign n1945_o = p_out[0];
  assign n1946_o = p_out[0];
  assign n1947_o = p[0];
  /* ./T65.vhd:448:11  */
  assign n1948_o = n1882_o ? n1946_o : n1947_o;
  /* ./T65.vhd:462:11  */
  assign n1949_o = savep ? n1945_o : n1948_o;
  /* ./T65.vhd:465:11  */
  assign n1950_o = ldp ? n1944_o : n1949_o;
  /* ./T65.vhd:468:11  */
  assign n1951_o = n1887_o ? n1918_o : n1950_o;
  assign n1960_o = alu_q[6];
  assign n1961_o = p_out[6];
  assign n1962_o = p_out[6];
  assign n1963_o = p[6];
  /* ./T65.vhd:448:11  */
  assign n1964_o = n1882_o ? n1962_o : n1963_o;
  /* ./T65.vhd:462:11  */
  assign n1965_o = savep ? n1961_o : n1964_o;
  /* ./T65.vhd:465:11  */
  assign n1966_o = ldp ? n1960_o : n1965_o;
  /* ./T65.vhd:468:11  */
  assign n1967_o = n1887_o ? n1942_o : n1966_o;
  assign n1982_o = alu_q[1];
  assign n1983_o = p_out[1];
  assign n1984_o = p_out[1];
  assign n1985_o = p[1];
  /* ./T65.vhd:448:11  */
  assign n1986_o = n1882_o ? n1984_o : n1985_o;
  /* ./T65.vhd:462:11  */
  assign n1987_o = savep ? n1983_o : n1986_o;
  /* ./T65.vhd:465:11  */
  assign n1988_o = ldp ? n1982_o : n1987_o;
  assign n1989_o = alu_q[7];
  assign n1990_o = p_out[7];
  assign n1991_o = p_out[7];
  assign n1992_o = p[7];
  /* ./T65.vhd:448:11  */
  assign n1993_o = n1882_o ? n1991_o : n1992_o;
  /* ./T65.vhd:462:11  */
  assign n1994_o = savep ? n1990_o : n1993_o;
  /* ./T65.vhd:465:11  */
  assign n1995_o = ldp ? n1989_o : n1994_o;
  /* ./T65.vhd:488:17  */
  assign n2012_o = ir == 8'b00000000;
  /* ./T65.vhd:488:41  */
  assign n2014_o = mcycle == 3'b100;
  /* ./T65.vhd:488:30  */
  assign n2015_o = n2014_o & n2012_o;
  /* ./T65.vhd:488:62  */
  assign n2016_o = ~rstcycle;
  /* ./T65.vhd:488:49  */
  assign n2017_o = n2016_o & n2015_o;
  assign n2019_o = n1943_o[0];
  assign n2020_o = alu_q[2];
  assign n2021_o = p_out[2];
  assign n2022_o = p_out[2];
  assign n2023_o = p[2];
  /* ./T65.vhd:448:11  */
  assign n2024_o = n1882_o ? n2022_o : n2023_o;
  /* ./T65.vhd:462:11  */
  assign n2025_o = savep ? n2021_o : n2024_o;
  /* ./T65.vhd:465:11  */
  assign n2026_o = ldp ? n2020_o : n2025_o;
  /* ./T65.vhd:468:11  */
  assign n2027_o = n1887_o ? n2019_o : n2026_o;
  /* ./T65.vhd:488:11  */
  assign n2028_o = n2017_o ? 1'b1 : n2027_o;
  assign n2029_o = n1943_o[1];
  assign n2030_o = alu_q[3];
  assign n2031_o = p_out[3];
  assign n2032_o = p_out[3];
  assign n2033_o = p[3];
  /* ./T65.vhd:448:11  */
  assign n2034_o = n1882_o ? n2032_o : n2033_o;
  /* ./T65.vhd:462:11  */
  assign n2035_o = savep ? n2031_o : n2034_o;
  /* ./T65.vhd:465:11  */
  assign n2036_o = ldp ? n2030_o : n2035_o;
  /* ./T65.vhd:468:11  */
  assign n2037_o = n1887_o ? n2029_o : n2036_o;
  assign n2040_o = {1'b0, 1'b1};
  assign n2041_o = {n2037_o, n2028_o};
  /* ./T65.vhd:492:11  */
  assign n2042_o = rstcycle ? n2040_o : n2041_o;
  assign n2044_o = {n1995_o, n1967_o, 1'b1, 1'b1, n2042_o, n1988_o, n1951_o};
  /* ./T65.vhd:447:9  */
  assign n2046_o = n1877_o & really_rdy;
  /* ./T65.vhd:447:9  */
  assign n2048_o = n1879_o & really_rdy;
  /* ./T65.vhd:447:9  */
  assign n2050_o = n1881_o & really_rdy;
  /* ./T65.vhd:503:14  */
  assign n2054_o = ir[4:0];
  /* ./T65.vhd:503:26  */
  assign n2056_o = n2054_o != 5'b10000;
  /* ./T65.vhd:503:43  */
  assign n2058_o = jump != 2'b01;
  /* ./T65.vhd:503:36  */
  assign n2059_o = n2056_o | n2058_o;
  /* ./T65.vhd:503:64  */
  assign n2060_o = ~really_rdy;
  /* ./T65.vhd:503:50  */
  assign n2061_o = n2059_o | n2060_o;
  /* ./T65.vhd:507:14  */
  assign n2063_o = ir[4:0];
  /* ./T65.vhd:507:26  */
  assign n2065_o = n2063_o != 5'b10000;
  /* ./T65.vhd:507:43  */
  assign n2067_o = jump != 2'b01;
  /* ./T65.vhd:507:36  */
  assign n2068_o = n2065_o | n2067_o;
  /* ./T65.vhd:446:7  */
  assign n2071_o = n2046_o & enable;
  /* ./T65.vhd:446:7  */
  assign n2073_o = n2048_o & enable;
  /* ./T65.vhd:446:7  */
  assign n2075_o = n2050_o & enable;
  /* ./T65.vhd:446:7  */
  assign n2076_o = really_rdy & enable;
  /* ./T65.vhd:446:7  */
  assign n2077_o = n2061_o & enable;
  /* ./T65.vhd:446:7  */
  assign n2078_o = n2068_o & enable;
  /* ./T65.vhd:514:42  */
  assign n2080_o = ~so_n;
  /* ./T65.vhd:514:33  */
  assign n2081_o = n2080_o & so_n_o;
  assign n2083_o = n2044_o[6];
  assign n2084_o = p[6];
  /* ./T65.vhd:446:7  */
  assign n2085_o = n2076_o ? n2083_o : n2084_o;
  /* ./T65.vhd:514:17  */
  assign n2086_o = n2081_o ? 1'b1 : n2085_o;
  assign n2087_o = n2044_o[7];
  assign n2088_o = p[7];
  /* ./T65.vhd:446:7  */
  assign n2089_o = n2076_o ? n2087_o : n2088_o;
  assign n2090_o = n2044_o[5:0];
  assign n2091_o = p[5:0];
  /* ./T65.vhd:446:7  */
  assign n2092_o = n2076_o ? n2090_o : n2091_o;
  assign n2099_o = {n2089_o, n2086_o, n2092_o};
  /* ./T65.vhd:529:16  */
  assign n2123_o = ~res_n_i;
  /* ./T65.vhd:545:28  */
  assign n2126_o = set_addr_to_r == 2'b00;
  /* ./T65.vhd:545:63  */
  assign n2128_o = set_addr_to_r == 2'b10;
  /* ./T65.vhd:545:46  */
  assign n2129_o = n2126_o | n2128_o;
  /* ./T65.vhd:546:65  */
  assign n2131_o = di + 8'b00000001;
  /* ./T65.vhd:552:49  */
  assign n2134_o = ad + 8'b00000001;
  /* ./T65.vhd:553:51  */
  assign n2136_o = bal + 9'b000000001;
  /* ./T65.vhd:550:11  */
  assign n2138_o = baadd == 2'b01;
  /* ./T65.vhd:556:56  */
  assign n2139_o = bal[7:0];
  /* ./T65.vhd:556:37  */
  assign n2140_o = {1'b0, n2139_o};  //  uext
  /* ./T65.vhd:556:75  */
  assign n2141_o = {1'b0, busa};  //  uext
  /* ./T65.vhd:556:73  */
  assign n2142_o = n2140_o + n2141_o;
  /* ./T65.vhd:554:11  */
  assign n2144_o = baadd == 2'b10;
  /* ./T65.vhd:559:19  */
  assign n2145_o = bal[8];
  /* ./T65.vhd:562:66  */
  assign n2147_o = bah + 8'b00000001;
  /* ./T65.vhd:562:15  */
  assign n2149_o = baquirk == 2'b00;
  /* ./T65.vhd:563:66  */
  assign n2151_o = bah + 8'b00000001;
  /* ./T65.vhd:563:71  */
  assign n2152_o = n2151_o & do_r;
  /* ./T65.vhd:563:15  */
  assign n2154_o = baquirk == 2'b01;
  /* ./T65.vhd:564:15  */
  assign n2156_o = baquirk == 2'b10;
  assign n2157_o = {n2156_o, n2154_o, n2149_o};
  /* ./T65.vhd:561:15  */
  always @*
    case (n2157_o)
      3'b100: n2158_o = do_r;
      3'b010: n2158_o = n2152_o;
      3'b001: n2158_o = n2147_o;
      default: n2158_o = bah;
    endcase
  /* ./T65.vhd:559:13  */
  assign n2159_o = n2145_o ? n2158_o : bah;
  /* ./T65.vhd:557:11  */
  assign n2161_o = baadd == 2'b11;
  assign n2162_o = {n2161_o, n2144_o, n2138_o};
  /* ./T65.vhd:549:11  */
  always @*
    case (n2162_o)
      3'b100: n2163_o = ad;
      3'b010: n2163_o = ad;
      3'b001: n2163_o = n2134_o;
      default: n2163_o = ad;
    endcase
  /* ./T65.vhd:549:11  */
  always @*
    case (n2162_o)
      3'b100: n2164_o = n2159_o;
      3'b010: n2164_o = bah;
      3'b001: n2164_o = bah;
      default: n2164_o = bah;
    endcase
  /* ./T65.vhd:549:11  */
  always @*
    case (n2162_o)
      3'b100: n2165_o = bal;
      3'b010: n2165_o = n2142_o;
      3'b001: n2165_o = n2136_o;
      default: n2165_o = bal;
    endcase
  /* ./T65.vhd:574:63  */
  assign n2166_o = y[7:0];
  /* ./T65.vhd:574:51  */
  assign n2167_o = ad + n2166_o;
  /* ./T65.vhd:576:63  */
  assign n2168_o = x[7:0];
  /* ./T65.vhd:576:51  */
  assign n2169_o = ad + n2168_o;
  /* ./T65.vhd:573:13  */
  assign n2170_o = addy ? n2167_o : n2169_o;
  /* ./T65.vhd:572:11  */
  assign n2171_o = adadd ? n2170_o : n2163_o;
  /* ./T65.vhd:580:17  */
  assign n2173_o = ir == 8'b00000000;
  /* ./T65.vhd:585:61  */
  assign n2176_o = mcycle == 3'b100;
  /* ./T65.vhd:585:51  */
  assign n2177_o = n2176_o & nmiact;
  /* ./T65.vhd:585:34  */
  assign n2178_o = nmicycle | n2177_o;
  /* ./T65.vhd:585:69  */
  assign n2179_o = n2178_o | nmi_entered;
  /* ./T65.vhd:587:24  */
  assign n2182_o = mcycle == 3'b100;
  /* ./T65.vhd:587:15  */
  assign n2185_o = n2182_o ? 1'b1 : 1'b0;
  /* ./T65.vhd:585:13  */
  assign n2189_o = n2179_o ? n2185_o : 1'b0;
  assign n2192_o = n2191_o[8:3];
  /* ./T65.vhd:583:13  */
  assign n2194_o = rstcycle ? 1'b0 : n2189_o;
  /* ./T65.vhd:593:30  */
  assign n2196_o = set_addr_to_r == 2'b11;
  assign n2198_o = n2174_o[0];
  assign n2199_o = n2180_o[0];
  assign n2200_o = n2186_o[0];
  /* ./T65.vhd:585:13  */
  assign n2201_o = n2179_o ? n2199_o : n2200_o;
  /* ./T65.vhd:583:13  */
  assign n2202_o = rstcycle ? n2198_o : n2201_o;
  /* ./T65.vhd:593:13  */
  assign n2203_o = n2196_o ? 1'b1 : n2202_o;
  assign n2204_o = n2174_o[2:1];
  assign n2205_o = n2180_o[2:1];
  assign n2206_o = n2186_o[2:1];
  /* ./T65.vhd:585:13  */
  assign n2207_o = n2179_o ? n2205_o : n2206_o;
  /* ./T65.vhd:583:13  */
  assign n2208_o = rstcycle ? n2204_o : n2207_o;
  /* ./T65.vhd:580:11  */
  assign n2210_o = n2173_o ? 8'b11111111 : n2164_o;
  assign n2211_o = {n2192_o, n2208_o, n2203_o};
  /* ./T65.vhd:580:11  */
  assign n2214_o = n2173_o ? n2194_o : 1'b0;
  /* ./T65.vhd:598:11  */
  assign n2216_o = lddi ? di : dl;
  /* ./T65.vhd:601:11  */
  assign n2217_o = ldalu ? alu_q : n2216_o;
  /* ./T65.vhd:604:11  */
  assign n2218_o = ldad ? di : n2171_o;
  assign n2219_o = n2211_o[7:0];
  assign n2220_o = n2165_o[7:0];
  /* ./T65.vhd:580:11  */
  assign n2221_o = n2173_o ? n2219_o : n2220_o;
  /* ./T65.vhd:607:11  */
  assign n2222_o = ldbal ? di : n2221_o;
  assign n2223_o = n2211_o[8];
  assign n2224_o = n2165_o[8];
  /* ./T65.vhd:580:11  */
  assign n2225_o = n2173_o ? n2223_o : n2224_o;
  /* ./T65.vhd:610:11  */
  assign n2226_o = ldbah ? di : n2210_o;
  assign n2230_o = {n2225_o, n2222_o};
  /* ./T65.vhd:539:9  */
  assign n2234_o = n2129_o & really_rdy;
  /* ./T65.vhd:538:7  */
  assign n2236_o = really_rdy & enable;
  /* ./T65.vhd:538:7  */
  assign n2237_o = really_rdy & enable;
  /* ./T65.vhd:538:7  */
  assign n2238_o = really_rdy & enable;
  /* ./T65.vhd:538:7  */
  assign n2239_o = really_rdy & enable;
  /* ./T65.vhd:538:7  */
  assign n2240_o = really_rdy & enable;
  /* ./T65.vhd:538:7  */
  assign n2241_o = really_rdy & enable;
  /* ./T65.vhd:538:7  */
  assign n2242_o = n2234_o & enable;
  /* ./T65.vhd:538:7  */
  assign n2243_o = really_rdy & enable;
  /* ./T65.vhd:618:34  */
  assign n2268_o = bal[8];
  /* ./T65.vhd:618:27  */
  assign n2269_o = ~n2268_o;
  /* ./T65.vhd:618:23  */
  assign n2270_o = breakatna & n2269_o;
  /* ./T65.vhd:618:64  */
  assign n2271_o = pcadder[8];
  /* ./T65.vhd:618:53  */
  assign n2272_o = ~n2271_o;
  /* ./T65.vhd:618:49  */
  assign n2273_o = pcadd & n2272_o;
  /* ./T65.vhd:618:39  */
  assign n2274_o = n2270_o | n2273_o;
  /* ./T65.vhd:622:45  */
  assign n2276_o = set_busa_to == 4'b0000;
  /* ./T65.vhd:623:10  */
  assign n2277_o = abc[7:0];
  /* ./T65.vhd:623:45  */
  assign n2279_o = set_busa_to == 4'b0001;
  /* ./T65.vhd:624:8  */
  assign n2280_o = x[7:0];
  /* ./T65.vhd:624:45  */
  assign n2282_o = set_busa_to == 4'b0010;
  /* ./T65.vhd:625:8  */
  assign n2283_o = y[7:0];
  /* ./T65.vhd:625:45  */
  assign n2285_o = set_busa_to == 4'b0011;
  /* ./T65.vhd:626:25  */
  assign n2286_o = s[7:0];
  /* ./T65.vhd:626:45  */
  assign n2288_o = set_busa_to == 4'b0100;
  /* ./T65.vhd:627:45  */
  assign n2290_o = set_busa_to == 4'b0101;
  /* ./T65.vhd:628:10  */
  assign n2291_o = abc[7:0];
  /* ./T65.vhd:628:23  */
  assign n2292_o = n2291_o & di;
  /* ./T65.vhd:628:45  */
  assign n2294_o = set_busa_to == 4'b0110;
  /* ./T65.vhd:629:11  */
  assign n2295_o = abc[7:0];
  /* ./T65.vhd:629:24  */
  assign n2297_o = n2295_o | 8'b11101110;
  /* ./T65.vhd:629:34  */
  assign n2298_o = n2297_o & di;
  /* ./T65.vhd:629:45  */
  assign n2300_o = set_busa_to == 4'b0111;
  /* ./T65.vhd:630:11  */
  assign n2301_o = abc[7:0];
  /* ./T65.vhd:630:24  */
  assign n2303_o = n2301_o | 8'b11101110;
  /* ./T65.vhd:630:34  */
  assign n2304_o = n2303_o & di;
  /* ./T65.vhd:630:46  */
  assign n2305_o = x[7:0];
  /* ./T65.vhd:630:41  */
  assign n2306_o = n2304_o & n2305_o;
  /* ./T65.vhd:630:62  */
  assign n2308_o = set_busa_to == 4'b1000;
  /* ./T65.vhd:631:10  */
  assign n2309_o = abc[7:0];
  /* ./T65.vhd:631:28  */
  assign n2310_o = x[7:0];
  /* ./T65.vhd:631:23  */
  assign n2311_o = n2309_o & n2310_o;
  /* ./T65.vhd:631:45  */
  assign n2313_o = set_busa_to == 4'b1001;
  /* ./T65.vhd:632:45  */
  assign n2316_o = set_busa_to == 4'b1010;
  assign n2317_o = {n2316_o, n2313_o, n2308_o, n2300_o, n2294_o, n2290_o, n2288_o, n2285_o, n2282_o, n2279_o, n2276_o};
  /* ./T65.vhd:620:3  */
  always @*
    case (n2317_o)
      11'b10000000000: n2319_o = 8'bX;
      11'b01000000000: n2319_o = n2311_o;
      11'b00100000000: n2319_o = n2306_o;
      11'b00010000000: n2319_o = n2298_o;
      11'b00001000000: n2319_o = n2292_o;
      11'b00000100000: n2319_o = p;
      11'b00000010000: n2319_o = n2286_o;
      11'b00000001000: n2319_o = n2283_o;
      11'b00000000100: n2319_o = n2280_o;
      11'b00000000010: n2319_o = n2277_o;
      11'b00000000001: n2319_o = di;
      default: n2319_o = 8'bX;
    endcase
  /* ./T65.vhd:636:46  */
  assign n2320_o = s[7:0];
  /* ./T65.vhd:636:26  */
  assign n2322_o = {16'b0000000000000001, n2320_o};
  /* ./T65.vhd:636:87  */
  assign n2324_o = set_addr_to_r == 2'b01;
  /* ./T65.vhd:637:11  */
  assign n2326_o = {dbr, 8'b00000000};
  /* ./T65.vhd:637:24  */
  assign n2327_o = {n2326_o, ad};
  /* ./T65.vhd:637:87  */
  assign n2329_o = set_addr_to_r == 2'b10;
  /* ./T65.vhd:638:18  */
  assign n2331_o = {8'b00000000, bah};
  /* ./T65.vhd:638:29  */
  assign n2332_o = bal[7:0];
  /* ./T65.vhd:638:24  */
  assign n2333_o = {n2331_o, n2332_o};
  /* ./T65.vhd:638:87  */
  assign n2335_o = set_addr_to_r == 2'b11;
  /* ./T65.vhd:639:32  */
  assign n2336_o = pc[15:8];
  /* ./T65.vhd:639:11  */
  assign n2337_o = {pbr, n2336_o};
  /* ./T65.vhd:639:73  */
  assign n2338_o = pcadder[7:0];
  /* ./T65.vhd:639:47  */
  assign n2339_o = {n2337_o, n2338_o};
  /* ./T65.vhd:639:87  */
  assign n2341_o = set_addr_to_r == 2'b00;
  assign n2342_o = {n2341_o, n2335_o, n2329_o, n2324_o};
  /* ./T65.vhd:634:3  */
  always @*
    case (n2342_o)
      4'b1000: n2344_o = n2339_o;
      4'b0100: n2344_o = n2333_o;
      4'b0010: n2344_o = n2327_o;
      4'b0001: n2344_o = n2322_o;
      default: n2344_o = 24'bX;
    endcase
  /* ./T65.vhd:642:14  */
  assign n2346_o = p & 8'b11101111;
  /* ./T65.vhd:642:44  */
  assign n2347_o = irqcycle | nmicycle;
  /* ./T65.vhd:642:25  */
  assign n2348_o = n2347_o ? n2346_o : p;
  /* ./T65.vhd:648:43  */
  assign n2350_o = write_data_r == 4'b0000;
  /* ./T65.vhd:649:10  */
  assign n2351_o = abc[7:0];
  /* ./T65.vhd:649:43  */
  assign n2353_o = write_data_r == 4'b0001;
  /* ./T65.vhd:650:8  */
  assign n2354_o = x[7:0];
  /* ./T65.vhd:650:43  */
  assign n2356_o = write_data_r == 4'b0010;
  /* ./T65.vhd:651:8  */
  assign n2357_o = y[7:0];
  /* ./T65.vhd:651:43  */
  assign n2359_o = write_data_r == 4'b0011;
  /* ./T65.vhd:652:25  */
  assign n2360_o = s[7:0];
  /* ./T65.vhd:652:43  */
  assign n2362_o = write_data_r == 4'b0100;
  /* ./T65.vhd:653:43  */
  assign n2364_o = write_data_r == 4'b0101;
  /* ./T65.vhd:654:26  */
  assign n2365_o = pc[7:0];
  /* ./T65.vhd:654:43  */
  assign n2367_o = write_data_r == 4'b0110;
  /* ./T65.vhd:655:26  */
  assign n2368_o = pc[15:8];
  /* ./T65.vhd:655:43  */
  assign n2370_o = write_data_r == 4'b0111;
  /* ./T65.vhd:656:10  */
  assign n2371_o = abc[7:0];
  /* ./T65.vhd:656:28  */
  assign n2372_o = x[7:0];
  /* ./T65.vhd:656:23  */
  assign n2373_o = n2371_o & n2372_o;
  /* ./T65.vhd:656:43  */
  assign n2375_o = write_data_r == 4'b1000;
  /* ./T65.vhd:657:10  */
  assign n2376_o = abc[7:0];
  /* ./T65.vhd:657:28  */
  assign n2377_o = x[7:0];
  /* ./T65.vhd:657:23  */
  assign n2378_o = n2376_o & n2377_o;
  /* ./T65.vhd:657:41  */
  assign n2379_o = n2378_o & busb_r;
  /* ./T65.vhd:657:64  */
  assign n2381_o = write_data_r == 4'b1001;
  /* ./T65.vhd:658:8  */
  assign n2382_o = x[7:0];
  /* ./T65.vhd:658:21  */
  assign n2383_o = n2382_o & busb_r;
  /* ./T65.vhd:658:44  */
  assign n2385_o = write_data_r == 4'b1010;
  /* ./T65.vhd:659:8  */
  assign n2386_o = y[7:0];
  /* ./T65.vhd:659:21  */
  assign n2387_o = n2386_o & busb_r;
  /* ./T65.vhd:659:44  */
  assign n2389_o = write_data_r == 4'b1011;
  /* ./T65.vhd:660:43  */
  assign n2392_o = write_data_r == 4'b1100;
  assign n2393_o = {n2392_o, n2389_o, n2385_o, n2381_o, n2375_o, n2370_o, n2367_o, n2364_o, n2362_o, n2359_o, n2356_o, n2353_o, n2350_o};
  /* ./T65.vhd:646:3  */
  always @*
    case (n2393_o)
      13'b1000000000000: n2395_o = 8'bX;
      13'b0100000000000: n2395_o = n2387_o;
      13'b0010000000000: n2395_o = n2383_o;
      13'b0001000000000: n2395_o = n2379_o;
      13'b0000100000000: n2395_o = n2373_o;
      13'b0000010000000: n2395_o = n2368_o;
      13'b0000001000000: n2395_o = n2365_o;
      13'b0000000100000: n2395_o = pwithb;
      13'b0000000010000: n2395_o = n2360_o;
      13'b0000000001000: n2395_o = n2357_o;
      13'b0000000000100: n2395_o = n2354_o;
      13'b0000000000010: n2395_o = n2351_o;
      13'b0000000000001: n2395_o = dl;
      default: n2395_o = 8'bX;
    endcase
  /* ./T65.vhd:671:16  */
  assign n2398_o = ~res_n_i;
  /* ./T65.vhd:680:21  */
  assign n2400_o = mcycle == lcycle;
  /* ./T65.vhd:680:30  */
  assign n2401_o = n2400_o | break;
  /* ./T65.vhd:685:35  */
  assign n2403_o = ir != 8'b00000000;
  /* ./T65.vhd:685:29  */
  assign n2404_o = n2403_o & nmiact;
  /* ./T65.vhd:688:27  */
  assign n2405_o = ~irq_n_o;
  /* ./T65.vhd:688:38  */
  assign n2406_o = p[2];
  /* ./T65.vhd:688:47  */
  assign n2407_o = ~n2406_o;
  /* ./T65.vhd:688:33  */
  assign n2408_o = n2407_o & n2405_o;
  /* ./T65.vhd:688:13  */
  assign n2411_o = n2408_o ? 1'b1 : 1'b0;
  /* ./T65.vhd:685:13  */
  assign n2413_o = n2404_o ? 1'b0 : n2411_o;
  /* ./T65.vhd:685:13  */
  assign n2417_o = n2404_o ? 1'b1 : 1'b0;
  /* ./T65.vhd:679:9  */
  assign n2420_o = n2434_o ? 1'b0 : nmiact;
  /* ./T65.vhd:692:57  */
  assign n2422_o = mcycle + 3'b001;
  /* ./T65.vhd:680:11  */
  assign n2424_o = n2401_o ? 3'b000 : n2422_o;
  /* ./T65.vhd:680:11  */
  assign n2429_o = n2404_o & n2401_o;
  /* ./T65.vhd:679:9  */
  assign n2431_o = n2401_o & really_rdy;
  /* ./T65.vhd:679:9  */
  assign n2432_o = n2401_o & really_rdy;
  /* ./T65.vhd:679:9  */
  assign n2433_o = n2401_o & really_rdy;
  /* ./T65.vhd:679:9  */
  assign n2434_o = n2429_o & really_rdy;
  /* ./T65.vhd:696:37  */
  assign n2435_o = ~nmi_n;
  /* ./T65.vhd:696:50  */
  assign n2436_o = ir[4:0];
  /* ./T65.vhd:696:62  */
  assign n2438_o = n2436_o != 5'b10000;
  /* ./T65.vhd:696:79  */
  assign n2440_o = jump != 2'b01;
  /* ./T65.vhd:696:72  */
  assign n2441_o = n2438_o | n2440_o;
  /* ./T65.vhd:696:43  */
  assign n2442_o = n2441_o & n2435_o;
  /* ./T65.vhd:696:26  */
  assign n2443_o = n2442_o & nmi_n_o;
  /* ./T65.vhd:696:9  */
  assign n2445_o = n2443_o ? 1'b1 : n2420_o;
  /* ./T65.vhd:700:9  */
  assign n2447_o = nmi_entered ? 1'b0 : n2445_o;
  /* ./T65.vhd:678:7  */
  assign n2448_o = really_rdy & enable;
  /* ./T65.vhd:678:7  */
  assign n2449_o = n2431_o & enable;
  /* ./T65.vhd:678:7  */
  assign n2450_o = n2432_o & enable;
  /* ./T65.vhd:678:7  */
  assign n2451_o = n2433_o & enable;
  /* ./T65.vhd:439:3  */
  assign n2469_o = ~n1863_o;
  /* ./T65.vhd:439:3  */
  assign n2470_o = n2071_o & n2469_o;
  /* ./T65.vhd:444:5  */
  assign n2471_o = abc[7:0];
  /* ./T65.vhd:444:5  */
  assign n2472_o = n2470_o ? alu_q : n2471_o;
  /* ./T65.vhd:444:5  */
  always @(posedge clk)
    n2473_q <= n2472_o;
  assign n2475_o = {8'bZ, n2473_q};
  /* ./T65.vhd:439:3  */
  assign n2476_o = ~n1863_o;
  /* ./T65.vhd:439:3  */
  assign n2477_o = n2073_o & n2476_o;
  /* ./T65.vhd:444:5  */
  assign n2478_o = x[7:0];
  /* ./T65.vhd:444:5  */
  assign n2479_o = n2477_o ? alu_q : n2478_o;
  /* ./T65.vhd:444:5  */
  always @(posedge clk)
    n2480_q <= n2479_o;
  assign n2482_o = {8'bZ, n2480_q};
  /* ./T65.vhd:439:3  */
  assign n2483_o = ~n1863_o;
  /* ./T65.vhd:439:3  */
  assign n2484_o = n2075_o & n2483_o;
  /* ./T65.vhd:444:5  */
  assign n2485_o = y[7:0];
  /* ./T65.vhd:444:5  */
  assign n2486_o = n2484_o ? alu_q : n2485_o;
  /* ./T65.vhd:444:5  */
  always @(posedge clk)
    n2487_q <= n2486_o;
  assign n2489_o = {8'bZ, n2487_q};
  /* ./T65.vhd:444:5  */
  always @(posedge clk or posedge n1863_o)
    if (n1863_o)
      n2490_q <= 8'b00000000;
    else
      n2490_q <= n2099_o;
  /* ./T65.vhd:537:5  */
  assign n2491_o = n2236_o ? n2218_o : ad;
  /* ./T65.vhd:537:5  */
  always @(posedge clk or posedge n2123_o)
    if (n2123_o)
      n2492_q <= 8'b00000000;
    else
      n2492_q <= n2491_o;
  /* ./T65.vhd:537:5  */
  assign n2493_o = n2237_o ? n2217_o : dl;
  /* ./T65.vhd:537:5  */
  always @(posedge clk or posedge n2123_o)
    if (n2123_o)
      n2494_q <= 8'b00000000;
    else
      n2494_q <= n2493_o;
  /* ./T65.vhd:537:5  */
  assign n2495_o = n2238_o ? n2226_o : bah;
  /* ./T65.vhd:537:5  */
  always @(posedge clk or posedge n2123_o)
    if (n2123_o)
      n2496_q <= 8'b00000000;
    else
      n2496_q <= n2495_o;
  /* ./T65.vhd:537:5  */
  assign n2497_o = n2239_o ? n2230_o : bal;
  /* ./T65.vhd:537:5  */
  always @(posedge clk or posedge n2123_o)
    if (n2123_o)
      n2498_q <= 9'b000000000;
    else
      n2498_q <= n2497_o;
  /* ./T65.vhd:357:5  */
  assign n2499_o = n1791_o ? 8'b11111111 : pbr;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2500_q <= 8'b00000000;
    else
      n2500_q <= n2499_o;
  /* ./T65.vhd:357:5  */
  assign n2501_o = n1792_o ? 8'b11111111 : dbr;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2502_q <= 8'b00000000;
    else
      n2502_q <= n2501_o;
  /* ./T65.vhd:357:5  */
  assign n2503_o = n1793_o ? n1775_o : pc;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2504_q <= 16'b0000000000000000;
    else
      n2504_q <= n2503_o;
  /* ./T65.vhd:357:5  */
  assign n2505_o = n1794_o ? n1710_o : s;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2506_q <= 16'b0000000000000000;
    else
      n2506_q <= n2505_o;
  /* ./T65.vhd:357:5  */
  assign n2507_o = n1795_o ? 1'b0 : ef_i;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2508_q <= 1'b1;
    else
      n2508_q <= n2507_o;
  /* ./T65.vhd:357:5  */
  assign n2509_o = n1796_o ? 1'b0 : mf_i;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2510_q <= 1'b1;
    else
      n2510_q <= n2509_o;
  /* ./T65.vhd:357:5  */
  assign n2511_o = n1797_o ? 1'b0 : xf_i;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2512_q <= 1'b1;
    else
      n2512_q <= n2511_o;
  /* ./T65.vhd:357:5  */
  assign n2513_o = n1798_o ? n1687_o : ir;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2514_q <= 8'b00000000;
    else
      n2514_q <= n2513_o;
  /* ./T65.vhd:677:5  */
  assign n2515_o = n2448_o ? n2424_o : mcycle;
  /* ./T65.vhd:677:5  */
  always @(posedge clk or posedge n2398_o)
    if (n2398_o)
      n2516_q <= 3'b001;
    else
      n2516_q <= n2515_o;
  /* ./T65.vhd:357:5  */
  assign n2517_o = n1799_o ? mode : mode_r;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2518_q <= 2'b00;
    else
      n2518_q <= n2517_o;
  /* ./T65.vhd:357:5  */
  assign n2519_o = n1800_o ? bcd_en : bcd_en_r;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2520_q <= 1'b1;
    else
      n2520_q <= n2519_o;
  /* ./T65.vhd:357:5  */
  assign n2521_o = n1801_o ? alu_op : alu_op_r;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2522_q <= 5'b01100;
    else
      n2522_q <= n2521_o;
  /* ./T65.vhd:357:5  */
  assign n2523_o = n1802_o ? write_data : write_data_r;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2524_q <= 4'b0000;
    else
      n2524_q <= n2523_o;
  /* ./T65.vhd:357:5  */
  assign n2525_o = n1803_o ? n1697_o : set_addr_to_r;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2526_q <= 2'b00;
    else
      n2526_q <= n2525_o;
  /* ./T65.vhd:677:5  */
  assign n2527_o = n2449_o ? 1'b0 : rstcycle;
  /* ./T65.vhd:677:5  */
  always @(posedge clk or posedge n2398_o)
    if (n2398_o)
      n2528_q <= 1'b1;
    else
      n2528_q <= n2527_o;
  /* ./T65.vhd:677:5  */
  assign n2529_o = n2450_o ? n2413_o : irqcycle;
  /* ./T65.vhd:677:5  */
  always @(posedge clk or posedge n2398_o)
    if (n2398_o)
      n2530_q <= 1'b0;
    else
      n2530_q <= n2529_o;
  /* ./T65.vhd:677:5  */
  assign n2531_o = n2451_o ? n2417_o : nmicycle;
  /* ./T65.vhd:677:5  */
  always @(posedge clk or posedge n2398_o)
    if (n2398_o)
      n2532_q <= 1'b0;
    else
      n2532_q <= n2531_o;
  /* ./T65.vhd:439:3  */
  assign n2533_o = ~n1863_o;
  /* ./T65.vhd:444:5  */
  assign n2534_o = n2533_o ? so_n : so_n_o;
  /* ./T65.vhd:444:5  */
  always @(posedge clk)
    n2535_q <= n2534_o;
  /* ./T65.vhd:439:3  */
  assign n2536_o = ~n1863_o;
  /* ./T65.vhd:439:3  */
  assign n2537_o = n2077_o & n2536_o;
  /* ./T65.vhd:444:5  */
  assign n2538_o = n2537_o ? irq_n : irq_n_o;
  /* ./T65.vhd:444:5  */
  always @(posedge clk)
    n2539_q <= n2538_o;
  /* ./T65.vhd:439:3  */
  assign n2540_o = ~n1863_o;
  /* ./T65.vhd:439:3  */
  assign n2541_o = n2078_o & n2540_o;
  /* ./T65.vhd:444:5  */
  assign n2542_o = n2541_o ? nmi_n : nmi_n_o;
  /* ./T65.vhd:444:5  */
  always @(posedge clk)
    n2543_q <= n2542_o;
  /* ./T65.vhd:677:5  */
  assign n2544_o = enable ? n2447_o : nmiact;
  /* ./T65.vhd:677:5  */
  always @(posedge clk or posedge n2398_o)
    if (n2398_o)
      n2545_q <= 1'b0;
    else
      n2545_q <= n2544_o;
  /* ./T65.vhd:537:5  */
  assign n2546_o = n2240_o ? busa : busa_r;
  /* ./T65.vhd:537:5  */
  always @(posedge clk or posedge n2123_o)
    if (n2123_o)
      n2547_q <= 8'b00000000;
    else
      n2547_q <= n2546_o;
  /* ./T65.vhd:537:5  */
  assign n2548_o = n2241_o ? di : busb;
  /* ./T65.vhd:537:5  */
  always @(posedge clk or posedge n2123_o)
    if (n2123_o)
      n2549_q <= 8'b00000000;
    else
      n2549_q <= n2548_o;
  /* ./T65.vhd:537:5  */
  assign n2550_o = n2242_o ? n2131_o : busb_r;
  /* ./T65.vhd:537:5  */
  always @(posedge clk or posedge n2123_o)
    if (n2123_o)
      n2551_q <= 8'b00000000;
    else
      n2551_q <= n2550_o;
  /* ./T65.vhd:331:5  */
  always @(posedge clk or posedge n1642_o)
    if (n1642_o)
      n2552_q <= 1'b0;
    else
      n2552_q <= res_n_d;
  /* ./T65.vhd:331:5  */
  always @(posedge clk or posedge n1642_o)
    if (n1642_o)
      n2553_q <= 1'b0;
    else
      n2553_q <= 1'b1;
  /* ./T65.vhd:337:3  */
  assign n2554_o = ~n1654_o;
  /* ./T65.vhd:337:3  */
  assign n2555_o = enable & n2554_o;
  /* ./T65.vhd:357:5  */
  assign n2556_o = n2555_o ? n1674_o : rdy_mod;
  /* ./T65.vhd:357:5  */
  always @(posedge clk)
    n2557_q <= n2556_o;
  /* ./T65.vhd:357:5  */
  assign n2558_o = n1805_o ? n1676_o : wrn_i;
  /* ./T65.vhd:357:5  */
  always @(posedge clk or posedge n1654_o)
    if (n1654_o)
      n2559_q <= 1'b1;
    else
      n2559_q <= n2558_o;
  /* ./T65.vhd:527:3  */
  assign n2560_o = ~n2123_o;
  /* ./T65.vhd:527:3  */
  assign n2561_o = n2243_o & n2560_o;
  /* ./T65.vhd:537:5  */
  assign n2562_o = n2561_o ? n2214_o : nmi_entered;
  /* ./T65.vhd:537:5  */
  always @(posedge clk)
    n2563_q <= n2562_o;
  /* ./T65.vhd:529:5  */
  assign n2564_o = {p, n1603_o, n1602_o, n1601_o, n1600_o, ir};
endmodule

module video_generator
  (input  clk_14m,
   input  clk_7m,
   input  altchar,
   input  romswitch,
   input  gr2,
   input  sega,
   input  segb,
   input  segc,
   input  wndw_n,
   input  [7:0] dl,
   input  ldps_n,
   input  [7:0] vrom_d,
   input  flash_clk,
   output [12:0] vrom_a,
   output video);
  wire [11:0] video_rom_addr;
  wire [7:0] video_rom_out;
  wire [7:0] video_shiftreg;
  wire n1499_o;
  wire n1500_o;
  wire n1501_o;
  wire n1502_o;
  wire n1503_o;
  wire n1504_o;
  wire n1505_o;
  wire n1506_o;
  wire [1:0] n1507_o;
  wire n1508_o;
  wire n1509_o;
  wire n1510_o;
  wire n1511_o;
  wire n1512_o;
  wire [2:0] n1513_o;
  wire [5:0] n1514_o;
  wire [8:0] n1515_o;
  wire [9:0] n1516_o;
  wire [10:0] n1517_o;
  wire [11:0] n1518_o;
  wire [12:0] n1519_o;
  wire n1522_o;
  wire n1523_o;
  wire [7:0] n1525_o;
  wire n1526_o;
  wire [6:0] n1527_o;
  wire [7:0] n1528_o;
  wire [7:0] n1529_o;
  wire n1533_o;
  wire n1534_o;
  wire [7:0] n1535_o;
  reg [7:0] n1536_q;
  assign vrom_a = n1519_o;
  assign video = n1534_o;
  /* ./video_generator.vhd:49:10  */
  assign video_rom_addr = n1518_o; // (signal)
  /* ./video_generator.vhd:50:10  */
  assign video_rom_out = vrom_d; // (signal)
  /* ./video_generator.vhd:51:10  */
  assign video_shiftreg = n1536_q; // (signal)
  /* ./video_generator.vhd:65:24  */
  assign n1499_o = dl[7];
  /* ./video_generator.vhd:65:32  */
  assign n1500_o = ~gr2;
  /* ./video_generator.vhd:65:46  */
  assign n1501_o = dl[6];
  /* ./video_generator.vhd:65:40  */
  assign n1502_o = n1500_o & n1501_o;
  /* ./video_generator.vhd:65:50  */
  assign n1503_o = n1502_o & flash_clk;
  /* ./video_generator.vhd:65:68  */
  assign n1504_o = ~altchar;
  /* ./video_generator.vhd:65:64  */
  assign n1505_o = n1503_o & n1504_o;
  /* ./video_generator.vhd:65:28  */
  assign n1506_o = n1499_o | n1505_o;
  /* ./video_generator.vhd:64:25  */
  assign n1507_o = {gr2, n1506_o};
  /* ./video_generator.vhd:66:24  */
  assign n1508_o = dl[6];
  /* ./video_generator.vhd:66:41  */
  assign n1509_o = altchar | gr2;
  /* ./video_generator.vhd:66:53  */
  assign n1510_o = dl[7];
  /* ./video_generator.vhd:66:48  */
  assign n1511_o = n1509_o | n1510_o;
  /* ./video_generator.vhd:66:28  */
  assign n1512_o = n1508_o & n1511_o;
  /* ./video_generator.vhd:65:82  */
  assign n1513_o = {n1507_o, n1512_o};
  /* ./video_generator.vhd:67:23  */
  assign n1514_o = dl[5:0];
  /* ./video_generator.vhd:66:59  */
  assign n1515_o = {n1513_o, n1514_o};
  /* ./video_generator.vhd:67:36  */
  assign n1516_o = {n1515_o, segc};
  /* ./video_generator.vhd:67:43  */
  assign n1517_o = {n1516_o, segb};
  /* ./video_generator.vhd:67:50  */
  assign n1518_o = {n1517_o, sega};
  /* ./video_generator.vhd:72:23  */
  assign n1519_o = {romswitch, video_rom_addr};
  /* ./video_generator.vhd:78:17  */
  assign n1522_o = ~clk_7m;
  /* ./video_generator.vhd:79:19  */
  assign n1523_o = ~ldps_n;
  /* ./video_generator.vhd:80:11  */
  assign n1525_o = wndw_n ? 8'b11111111 : video_rom_out;
  /* ./video_generator.vhd:86:43  */
  assign n1526_o = video_shiftreg[0];
  /* ./video_generator.vhd:86:63  */
  assign n1527_o = video_shiftreg[7:1];
  /* ./video_generator.vhd:86:47  */
  assign n1528_o = {n1526_o, n1527_o};
  /* ./video_generator.vhd:79:9  */
  assign n1529_o = n1523_o ? n1525_o : n1528_o;
  /* ./video_generator.vhd:92:30  */
  assign n1533_o = video_shiftreg[0];
  /* ./video_generator.vhd:92:12  */
  assign n1534_o = ~n1533_o;
  /* ./video_generator.vhd:77:5  */
  assign n1535_o = n1522_o ? n1529_o : video_shiftreg;
  /* ./video_generator.vhd:77:5  */
  always @(posedge clk_14m)
    n1536_q <= n1535_o;
endmodule

module timing_generator
  (input  clk_14m,
   input  palmode,
   input  text_mode,
   input  page2,
   input  hires_mode,
   input  mixed_mode,
   input  col80,
   input  store80,
   input  dhires_mode,
   input  vid7,
   output vid7m,
   output q3,
   output ras_n,
   output cas_n,
   output ax,
   output phi0,
   output phi0_en_r,
   output phi0_en_f,
   output color_ref,
   output [15:0] video_address,
   output sega,
   output segb,
   output segc,
   output gr1,
   output gr2,
   output hblank,
   output vblank,
   output wndw_n,
   output ldps_n);
  reg [6:0] h;
  reg [8:0] v;
  wire [8:0] v_reset;
  reg clk_7m;
  wire ras_n_pre;
  wire ax_pre;
  wire cas_n_pre;
  wire q3_pre;
  wire phi0_pre;
  wire vid7m_pre;
  wire ldps_n_pre;
  wire rasrise1;
  wire h0;
  wire va;
  wire vb;
  wire vc;
  wire v2;
  wire v4;
  wire gr2_g;
  wire hires;
  wire hbl;
  wire vbl;
  wire n1183_o;
  wire n1184_o;
  wire n1185_o;
  wire n1186_o;
  wire n1187_o;
  wire n1189_o;
  wire n1192_o;
  wire n1193_o;
  wire n1197_o;
  wire n1198_o;
  wire n1199_o;
  wire n1200_o;
  wire n1201_o;
  wire n1202_o;
  wire n1203_o;
  wire n1204_o;
  wire n1205_o;
  wire n1206_o;
  wire n1207_o;
  wire n1208_o;
  wire n1209_o;
  wire n1210_o;
  wire n1211_o;
  wire n1212_o;
  wire n1213_o;
  wire n1214_o;
  wire n1215_o;
  wire n1216_o;
  wire n1217_o;
  wire n1218_o;
  wire n1219_o;
  wire n1220_o;
  wire n1221_o;
  wire n1222_o;
  wire n1223_o;
  wire n1224_o;
  wire n1225_o;
  wire n1226_o;
  wire n1227_o;
  wire n1228_o;
  wire n1229_o;
  wire n1230_o;
  wire n1231_o;
  wire n1232_o;
  wire n1233_o;
  wire n1234_o;
  wire n1235_o;
  wire n1236_o;
  wire n1237_o;
  wire n1238_o;
  wire n1239_o;
  wire n1240_o;
  wire n1241_o;
  wire n1242_o;
  wire n1243_o;
  wire n1244_o;
  wire n1245_o;
  wire n1246_o;
  wire n1247_o;
  wire n1248_o;
  wire n1249_o;
  wire n1250_o;
  wire n1251_o;
  wire n1252_o;
  wire n1253_o;
  wire n1254_o;
  wire n1255_o;
  wire n1256_o;
  wire n1257_o;
  wire n1258_o;
  wire n1259_o;
  wire n1260_o;
  wire n1261_o;
  wire n1262_o;
  wire n1263_o;
  wire n1264_o;
  wire n1265_o;
  wire n1266_o;
  wire n1267_o;
  wire n1268_o;
  wire n1269_o;
  wire n1270_o;
  wire n1271_o;
  wire n1272_o;
  wire n1273_o;
  wire n1274_o;
  wire n1275_o;
  wire n1276_o;
  wire n1277_o;
  wire n1278_o;
  wire n1279_o;
  wire n1280_o;
  wire n1281_o;
  wire n1282_o;
  wire n1283_o;
  wire n1284_o;
  wire n1285_o;
  wire n1286_o;
  wire n1287_o;
  wire n1288_o;
  wire n1289_o;
  wire n1290_o;
  wire n1291_o;
  wire n1292_o;
  wire n1293_o;
  wire n1294_o;
  wire n1295_o;
  wire n1296_o;
  wire n1297_o;
  wire n1298_o;
  wire n1299_o;
  wire n1300_o;
  wire n1301_o;
  wire n1302_o;
  wire n1303_o;
  wire n1304_o;
  wire n1305_o;
  wire n1306_o;
  wire n1307_o;
  wire n1308_o;
  wire n1309_o;
  wire n1310_o;
  wire n1311_o;
  wire n1312_o;
  wire n1313_o;
  wire n1314_o;
  wire n1315_o;
  wire n1316_o;
  wire n1317_o;
  wire n1318_o;
  wire n1319_o;
  wire n1320_o;
  wire n1321_o;
  wire n1322_o;
  wire n1323_o;
  wire n1324_o;
  wire n1325_o;
  wire n1326_o;
  wire n1327_o;
  wire n1328_o;
  wire n1329_o;
  wire n1330_o;
  wire n1331_o;
  wire n1332_o;
  wire n1333_o;
  wire n1334_o;
  wire n1335_o;
  wire n1336_o;
  wire n1337_o;
  wire n1338_o;
  wire n1352_o;
  wire n1353_o;
  wire n1354_o;
  wire n1355_o;
  wire n1356_o;
  wire n1368_o;
  wire n1372_o;
  wire n1373_o;
  wire n1374_o;
  wire n1375_o;
  wire n1384_o;
  wire [8:0] n1385_o;
  wire n1389_o;
  wire n1390_o;
  wire [6:0] n1392_o;
  wire n1394_o;
  wire [8:0] n1396_o;
  wire n1398_o;
  wire [8:0] n1399_o;
  wire [8:0] n1400_o;
  wire [6:0] n1402_o;
  wire [8:0] n1403_o;
  wire n1409_o;
  wire n1410_o;
  wire n1411_o;
  wire n1412_o;
  wire n1413_o;
  wire n1414_o;
  wire n1415_o;
  wire n1416_o;
  wire n1417_o;
  wire n1418_o;
  wire n1419_o;
  wire n1420_o;
  wire n1421_o;
  wire n1422_o;
  wire n1423_o;
  wire [2:0] n1424_o;
  wire n1425_o;
  wire n1426_o;
  wire n1427_o;
  wire [1:0] n1428_o;
  wire n1429_o;
  wire [2:0] n1430_o;
  wire n1431_o;
  wire [3:0] n1432_o;
  wire n1433_o;
  wire n1434_o;
  wire n1435_o;
  wire [1:0] n1436_o;
  wire n1437_o;
  wire [2:0] n1438_o;
  wire [3:0] n1440_o;
  wire [3:0] n1441_o;
  wire n1442_o;
  wire [3:0] n1444_o;
  wire [3:0] n1445_o;
  wire [2:0] n1446_o;
  wire [2:0] n1448_o;
  wire n1449_o;
  wire n1450_o;
  wire [3:0] n1451_o;
  wire n1452_o;
  wire n1453_o;
  wire n1454_o;
  wire [4:0] n1455_o;
  wire n1456_o;
  wire [4:0] n1457_o;
  wire n1458_o;
  wire n1459_o;
  wire n1460_o;
  wire n1461_o;
  wire n1462_o;
  wire [1:0] n1463_o;
  wire [2:0] n1464_o;
  wire [4:0] n1465_o;
  wire [6:0] n1467_o;
  reg [6:0] n1468_q;
  wire [8:0] n1469_o;
  reg [8:0] n1470_q;
  reg n1471_q;
  reg n1472_q;
  reg n1473_q;
  reg n1474_q;
  reg n1475_q;
  reg n1476_q;
  reg n1477_q;
  reg n1478_q;
  wire [15:0] n1479_o;
  wire n1480_o;
  reg n1481_q;
  wire n1482_o;
  reg n1483_q;
  wire n1484_o;
  reg n1485_q;
  wire n1486_o;
  reg n1487_q;
  wire n1488_o;
  reg n1489_q;
  wire n1490_o;
  reg n1491_q;
  wire n1492_o;
  reg n1493_q;
  wire n1494_o;
  reg n1495_q;
  reg n1496_q;
  assign vid7m = n1472_q;
  assign q3 = n1473_q;
  assign ras_n = n1474_q;
  assign cas_n = n1475_q;
  assign ax = n1476_q;
  assign phi0 = n1477_q;
  assign phi0_en_r = n1336_o;
  assign phi0_en_f = n1338_o;
  assign color_ref = n1478_q;
  assign video_address = n1479_o;
  assign sega = n1481_q;
  assign segb = n1483_q;
  assign segc = n1485_q;
  assign gr1 = n1487_q;
  assign gr2 = n1489_q;
  assign hblank = n1491_q;
  assign vblank = n1493_q;
  assign wndw_n = n1495_q;
  assign ldps_n = n1496_q;
  /* ./timing_generator.vhd:59:10  */
  always @*
    h = n1468_q; // (isignal)
  initial
    h = 7'b0000000;
  /* ./timing_generator.vhd:60:10  */
  always @*
    v = n1470_q; // (isignal)
  initial
    v = 9'b011111010;
  /* ./timing_generator.vhd:61:10  */
  assign v_reset = n1385_o; // (signal)
  /* ./timing_generator.vhd:64:10  */
  always @*
    clk_7m = n1471_q; // (isignal)
  initial
    clk_7m = 1'b0;
  /* ./timing_generator.vhd:65:10  */
  assign ras_n_pre = n1212_o; // (signal)
  /* ./timing_generator.vhd:65:21  */
  assign ax_pre = n1218_o; // (signal)
  /* ./timing_generator.vhd:65:29  */
  assign cas_n_pre = n1228_o; // (signal)
  /* ./timing_generator.vhd:65:40  */
  assign q3_pre = n1242_o; // (signal)
  /* ./timing_generator.vhd:65:48  */
  assign phi0_pre = n1253_o; // (signal)
  /* ./timing_generator.vhd:65:58  */
  assign vid7m_pre = n1284_o; // (signal)
  /* ./timing_generator.vhd:65:69  */
  assign ldps_n_pre = n1334_o; // (signal)
  /* ./timing_generator.vhd:66:10  */
  assign rasrise1 = n1187_o; // (signal)
  /* ./timing_generator.vhd:67:10  */
  assign h0 = n1409_o; // (signal)
  /* ./timing_generator.vhd:67:14  */
  assign va = n1410_o; // (signal)
  /* ./timing_generator.vhd:67:18  */
  assign vb = n1411_o; // (signal)
  /* ./timing_generator.vhd:158:17  */
  assign vc = n1412_o; // (signal)
  /* ./timing_generator.vhd:67:26  */
  assign v2 = n1413_o; // (signal)
  /* ./timing_generator.vhd:67:30  */
  assign v4 = n1414_o; // (signal)
  /* ./timing_generator.vhd:67:34  */
  assign gr2_g = n1189_o; // (signal)
  /* ./timing_generator.vhd:68:10  */
  assign hires = n1368_o; // (signal)
  /* ./timing_generator.vhd:69:10  */
  assign hbl = n1420_o; // (signal)
  /* ./timing_generator.vhd:69:15  */
  assign vbl = n1423_o; // (signal)
  /* ./timing_generator.vhd:72:47  */
  assign n1183_o = ~n1477_q;
  /* ./timing_generator.vhd:72:38  */
  assign n1184_o = n1183_o & n1474_q;
  /* ./timing_generator.vhd:72:60  */
  assign n1185_o = ~n1473_q;
  /* ./timing_generator.vhd:72:53  */
  assign n1186_o = n1185_o & n1184_o;
  /* ./timing_generator.vhd:72:21  */
  assign n1187_o = n1186_o ? 1'b1 : 1'b0;
  /* ./timing_generator.vhd:73:18  */
  assign n1189_o = n1489_q & dhires_mode;
  /* ./timing_generator.vhd:79:33  */
  assign n1192_o = clk_7m ^ n1478_q;
  /* ./timing_generator.vhd:80:23  */
  assign n1193_o = ~clk_7m;
  /* ./timing_generator.vhd:87:14  */
  assign n1197_o = ~n1474_q;
  /* ./timing_generator.vhd:87:28  */
  assign n1198_o = ~n1476_q;
  /* ./timing_generator.vhd:87:24  */
  assign n1199_o = n1197_o & n1198_o;
  /* ./timing_generator.vhd:87:10  */
  assign n1200_o = n1473_q | n1199_o;
  /* ./timing_generator.vhd:88:14  */
  assign n1201_o = ~n1474_q;
  /* ./timing_generator.vhd:88:24  */
  assign n1202_o = n1201_o & n1478_q;
  /* ./timing_generator.vhd:88:38  */
  assign n1203_o = n1202_o & h0;
  /* ./timing_generator.vhd:88:45  */
  assign n1204_o = n1203_o & n1477_q;
  /* ./timing_generator.vhd:88:10  */
  assign n1205_o = n1200_o | n1204_o;
  /* ./timing_generator.vhd:89:14  */
  assign n1206_o = ~n1474_q;
  /* ./timing_generator.vhd:89:28  */
  assign n1207_o = ~clk_7m;
  /* ./timing_generator.vhd:89:24  */
  assign n1208_o = n1206_o & n1207_o;
  /* ./timing_generator.vhd:89:39  */
  assign n1209_o = n1208_o & h0;
  /* ./timing_generator.vhd:89:46  */
  assign n1210_o = n1209_o & n1477_q;
  /* ./timing_generator.vhd:89:10  */
  assign n1211_o = n1205_o | n1210_o;
  /* ./timing_generator.vhd:85:18  */
  assign n1212_o = ~n1211_o;
  /* ./timing_generator.vhd:91:14  */
  assign n1213_o = ~n1474_q;
  /* ./timing_generator.vhd:91:24  */
  assign n1214_o = n1213_o & n1473_q;
  /* ./timing_generator.vhd:92:14  */
  assign n1215_o = ~n1476_q;
  /* ./timing_generator.vhd:92:21  */
  assign n1216_o = n1215_o & n1473_q;
  /* ./timing_generator.vhd:92:10  */
  assign n1217_o = n1214_o | n1216_o;
  /* ./timing_generator.vhd:90:15  */
  assign n1218_o = ~n1217_o;
  /* ./timing_generator.vhd:94:14  */
  assign n1219_o = ~n1476_q;
  /* ./timing_generator.vhd:95:14  */
  assign n1220_o = ~n1476_q;
  /* ./timing_generator.vhd:95:25  */
  assign n1221_o = ~n1477_q;
  /* ./timing_generator.vhd:95:21  */
  assign n1222_o = n1220_o & n1221_o;
  /* ./timing_generator.vhd:95:10  */
  assign n1223_o = n1219_o | n1222_o;
  /* ./timing_generator.vhd:96:14  */
  assign n1224_o = ~n1475_q;
  /* ./timing_generator.vhd:96:28  */
  assign n1225_o = ~n1474_q;
  /* ./timing_generator.vhd:96:24  */
  assign n1226_o = n1224_o & n1225_o;
  /* ./timing_generator.vhd:96:10  */
  assign n1227_o = n1223_o | n1226_o;
  /* ./timing_generator.vhd:93:18  */
  assign n1228_o = ~n1227_o;
  /* ./timing_generator.vhd:98:14  */
  assign n1229_o = ~n1476_q;
  /* ./timing_generator.vhd:98:25  */
  assign n1230_o = ~n1477_q;
  /* ./timing_generator.vhd:98:21  */
  assign n1231_o = n1229_o & n1230_o;
  /* ./timing_generator.vhd:98:38  */
  assign n1232_o = ~clk_7m;
  /* ./timing_generator.vhd:98:34  */
  assign n1233_o = n1231_o & n1232_o;
  /* ./timing_generator.vhd:99:14  */
  assign n1234_o = ~n1476_q;
  /* ./timing_generator.vhd:99:21  */
  assign n1235_o = n1234_o & n1477_q;
  /* ./timing_generator.vhd:99:30  */
  assign n1236_o = n1235_o & clk_7m;
  /* ./timing_generator.vhd:99:10  */
  assign n1237_o = n1233_o | n1236_o;
  /* ./timing_generator.vhd:100:14  */
  assign n1238_o = ~n1473_q;
  /* ./timing_generator.vhd:100:25  */
  assign n1239_o = ~n1474_q;
  /* ./timing_generator.vhd:100:21  */
  assign n1240_o = n1238_o & n1239_o;
  /* ./timing_generator.vhd:100:10  */
  assign n1241_o = n1237_o | n1240_o;
  /* ./timing_generator.vhd:97:15  */
  assign n1242_o = ~n1241_o;
  /* ./timing_generator.vhd:102:19  */
  assign n1243_o = n1477_q & n1474_q;
  /* ./timing_generator.vhd:102:33  */
  assign n1244_o = ~n1473_q;
  /* ./timing_generator.vhd:102:29  */
  assign n1245_o = n1243_o & n1244_o;
  /* ./timing_generator.vhd:103:14  */
  assign n1246_o = ~n1477_q;
  /* ./timing_generator.vhd:103:27  */
  assign n1247_o = ~n1474_q;
  /* ./timing_generator.vhd:103:23  */
  assign n1248_o = n1246_o & n1247_o;
  /* ./timing_generator.vhd:103:10  */
  assign n1249_o = n1245_o | n1248_o;
  /* ./timing_generator.vhd:104:14  */
  assign n1250_o = ~n1477_q;
  /* ./timing_generator.vhd:104:23  */
  assign n1251_o = n1250_o & n1473_q;
  /* ./timing_generator.vhd:104:10  */
  assign n1252_o = n1249_o | n1251_o;
  /* ./timing_generator.vhd:101:17  */
  assign n1253_o = ~n1252_o;
  /* ./timing_generator.vhd:106:20  */
  assign n1254_o = gr2_g & n1483_q;
  /* ./timing_generator.vhd:107:14  */
  assign n1255_o = ~gr2_g;
  /* ./timing_generator.vhd:107:24  */
  assign n1256_o = n1255_o & col80;
  /* ./timing_generator.vhd:107:10  */
  assign n1257_o = n1254_o | n1256_o;
  /* ./timing_generator.vhd:108:14  */
  assign n1258_o = ~gr2_g;
  /* ./timing_generator.vhd:108:24  */
  assign n1259_o = n1258_o & clk_7m;
  /* ./timing_generator.vhd:108:10  */
  assign n1260_o = n1257_o | n1259_o;
  /* ./timing_generator.vhd:109:14  */
  assign n1261_o = ~vid7;
  /* ./timing_generator.vhd:109:27  */
  assign n1262_o = ~n1477_q;
  /* ./timing_generator.vhd:109:23  */
  assign n1263_o = n1261_o & n1262_o;
  /* ./timing_generator.vhd:109:40  */
  assign n1264_o = ~n1473_q;
  /* ./timing_generator.vhd:109:36  */
  assign n1265_o = n1263_o & n1264_o;
  /* ./timing_generator.vhd:109:51  */
  assign n1266_o = ~n1476_q;
  /* ./timing_generator.vhd:109:47  */
  assign n1267_o = n1265_o & n1266_o;
  /* ./timing_generator.vhd:109:10  */
  assign n1268_o = n1260_o | n1267_o;
  /* ./timing_generator.vhd:110:14  */
  assign n1269_o = ~h0;
  /* ./timing_generator.vhd:110:21  */
  assign n1270_o = n1269_o & n1478_q;
  /* ./timing_generator.vhd:110:39  */
  assign n1271_o = ~n1477_q;
  /* ./timing_generator.vhd:110:35  */
  assign n1272_o = n1270_o & n1271_o;
  /* ./timing_generator.vhd:110:52  */
  assign n1273_o = ~n1473_q;
  /* ./timing_generator.vhd:110:48  */
  assign n1274_o = n1272_o & n1273_o;
  /* ./timing_generator.vhd:110:63  */
  assign n1275_o = ~n1476_q;
  /* ./timing_generator.vhd:110:59  */
  assign n1276_o = n1274_o & n1275_o;
  /* ./timing_generator.vhd:110:10  */
  assign n1277_o = n1268_o | n1276_o;
  /* ./timing_generator.vhd:111:20  */
  assign n1278_o = n1472_q & n1476_q;
  /* ./timing_generator.vhd:111:10  */
  assign n1279_o = n1277_o | n1278_o;
  /* ./timing_generator.vhd:112:20  */
  assign n1280_o = n1472_q & n1477_q;
  /* ./timing_generator.vhd:112:10  */
  assign n1281_o = n1279_o | n1280_o;
  /* ./timing_generator.vhd:113:20  */
  assign n1282_o = n1472_q & n1473_q;
  /* ./timing_generator.vhd:113:10  */
  assign n1283_o = n1281_o | n1282_o;
  /* ./timing_generator.vhd:105:18  */
  assign n1284_o = ~n1283_o;
  /* ./timing_generator.vhd:115:14  */
  assign n1285_o = ~n1473_q;
  /* ./timing_generator.vhd:115:25  */
  assign n1286_o = ~n1476_q;
  /* ./timing_generator.vhd:115:21  */
  assign n1287_o = n1285_o & n1286_o;
  /* ./timing_generator.vhd:115:32  */
  assign n1288_o = n1287_o & col80;
  /* ./timing_generator.vhd:115:46  */
  assign n1289_o = ~gr2_g;
  /* ./timing_generator.vhd:115:42  */
  assign n1290_o = n1288_o & n1289_o;
  /* ./timing_generator.vhd:116:14  */
  assign n1291_o = ~n1473_q;
  /* ./timing_generator.vhd:116:25  */
  assign n1292_o = ~n1476_q;
  /* ./timing_generator.vhd:116:21  */
  assign n1293_o = n1291_o & n1292_o;
  /* ./timing_generator.vhd:116:36  */
  assign n1294_o = ~n1477_q;
  /* ./timing_generator.vhd:116:32  */
  assign n1295_o = n1293_o & n1294_o;
  /* ./timing_generator.vhd:116:49  */
  assign n1296_o = ~gr2_g;
  /* ./timing_generator.vhd:116:45  */
  assign n1297_o = n1295_o & n1296_o;
  /* ./timing_generator.vhd:116:10  */
  assign n1298_o = n1290_o | n1297_o;
  /* ./timing_generator.vhd:117:14  */
  assign n1299_o = ~n1473_q;
  /* ./timing_generator.vhd:117:25  */
  assign n1300_o = ~n1476_q;
  /* ./timing_generator.vhd:117:21  */
  assign n1301_o = n1299_o & n1300_o;
  /* ./timing_generator.vhd:117:36  */
  assign n1302_o = ~n1477_q;
  /* ./timing_generator.vhd:117:32  */
  assign n1303_o = n1301_o & n1302_o;
  /* ./timing_generator.vhd:117:45  */
  assign n1304_o = n1303_o & n1483_q;
  /* ./timing_generator.vhd:117:10  */
  assign n1305_o = n1298_o | n1304_o;
  /* ./timing_generator.vhd:118:14  */
  assign n1306_o = ~n1473_q;
  /* ./timing_generator.vhd:118:25  */
  assign n1307_o = ~n1476_q;
  /* ./timing_generator.vhd:118:21  */
  assign n1308_o = n1306_o & n1307_o;
  /* ./timing_generator.vhd:118:36  */
  assign n1309_o = ~n1477_q;
  /* ./timing_generator.vhd:118:32  */
  assign n1310_o = n1308_o & n1309_o;
  /* ./timing_generator.vhd:118:49  */
  assign n1311_o = ~vid7;
  /* ./timing_generator.vhd:118:45  */
  assign n1312_o = n1310_o & n1311_o;
  /* ./timing_generator.vhd:118:10  */
  assign n1313_o = n1305_o | n1312_o;
  /* ./timing_generator.vhd:119:14  */
  assign n1314_o = ~n1473_q;
  /* ./timing_generator.vhd:119:25  */
  assign n1315_o = ~n1476_q;
  /* ./timing_generator.vhd:119:21  */
  assign n1316_o = n1314_o & n1315_o;
  /* ./timing_generator.vhd:119:36  */
  assign n1317_o = ~n1477_q;
  /* ./timing_generator.vhd:119:32  */
  assign n1318_o = n1316_o & n1317_o;
  /* ./timing_generator.vhd:119:45  */
  assign n1319_o = n1318_o & n1478_q;
  /* ./timing_generator.vhd:119:63  */
  assign n1320_o = ~h0;
  /* ./timing_generator.vhd:119:59  */
  assign n1321_o = n1319_o & n1320_o;
  /* ./timing_generator.vhd:119:10  */
  assign n1322_o = n1313_o | n1321_o;
  /* ./timing_generator.vhd:120:14  */
  assign n1323_o = ~n1473_q;
  /* ./timing_generator.vhd:120:21  */
  assign n1324_o = n1323_o & n1476_q;
  /* ./timing_generator.vhd:120:32  */
  assign n1325_o = ~n1474_q;
  /* ./timing_generator.vhd:120:28  */
  assign n1326_o = n1324_o & n1325_o;
  /* ./timing_generator.vhd:120:46  */
  assign n1327_o = ~n1477_q;
  /* ./timing_generator.vhd:120:42  */
  assign n1328_o = n1326_o & n1327_o;
  /* ./timing_generator.vhd:120:55  */
  assign n1329_o = n1328_o & vid7;
  /* ./timing_generator.vhd:120:68  */
  assign n1330_o = ~n1483_q;
  /* ./timing_generator.vhd:120:64  */
  assign n1331_o = n1329_o & n1330_o;
  /* ./timing_generator.vhd:120:77  */
  assign n1332_o = n1331_o & gr2_g;
  /* ./timing_generator.vhd:120:10  */
  assign n1333_o = n1322_o | n1332_o;
  /* ./timing_generator.vhd:114:19  */
  assign n1334_o = ~n1333_o;
  /* ./timing_generator.vhd:122:18  */
  assign n1335_o = ~n1477_q;
  /* ./timing_generator.vhd:122:27  */
  assign n1336_o = n1335_o & phi0_pre;
  /* ./timing_generator.vhd:123:27  */
  assign n1337_o = ~phi0_pre;
  /* ./timing_generator.vhd:123:23  */
  assign n1338_o = n1477_q & n1337_o;
  /* ./timing_generator.vhd:145:31  */
  assign n1352_o = hbl | vbl;
  /* ./timing_generator.vhd:147:46  */
  assign n1353_o = v2 & v4;
  /* ./timing_generator.vhd:147:53  */
  assign n1354_o = n1353_o & mixed_mode;
  /* ./timing_generator.vhd:147:39  */
  assign n1355_o = text_mode | n1354_o;
  /* ./timing_generator.vhd:147:24  */
  assign n1356_o = ~n1355_o;
  /* ./timing_generator.vhd:152:25  */
  assign n1368_o = hires_mode & n1489_q;
  /* ./timing_generator.vhd:158:24  */
  assign n1372_o = ~n1487_q;
  /* ./timing_generator.vhd:164:29  */
  assign n1373_o = ~hires_mode;
  /* ./timing_generator.vhd:158:17  */
  assign n1374_o = n1372_o ? va : h0;
  /* ./timing_generator.vhd:158:17  */
  assign n1375_o = n1372_o ? vb : n1373_o;
  /* ./timing_generator.vhd:172:41  */
  assign n1384_o = ~palmode;
  /* ./timing_generator.vhd:172:28  */
  assign n1385_o = n1384_o ? 9'b011111010 : 9'b011001000;
  /* ./timing_generator.vhd:178:21  */
  assign n1389_o = h[6];
  /* ./timing_generator.vhd:178:25  */
  assign n1390_o = ~n1389_o;
  /* ./timing_generator.vhd:181:28  */
  assign n1392_o = h + 7'b0000001;
  /* ./timing_generator.vhd:182:26  */
  assign n1394_o = h == 7'b1111111;
  /* ./timing_generator.vhd:183:32  */
  assign n1396_o = v + 9'b000000001;
  /* ./timing_generator.vhd:184:30  */
  assign n1398_o = v == 9'b111111111;
  /* ./timing_generator.vhd:184:25  */
  assign n1399_o = n1398_o ? v_reset : n1396_o;
  /* ./timing_generator.vhd:182:21  */
  assign n1400_o = n1394_o ? n1399_o : v;
  /* ./timing_generator.vhd:178:17  */
  assign n1402_o = n1390_o ? 7'b1000000 : n1392_o;
  /* ./timing_generator.vhd:178:17  */
  assign n1403_o = n1390_o ? v : n1400_o;
  /* ./timing_generator.vhd:191:12  */
  assign n1409_o = h[0];
  /* ./timing_generator.vhd:192:12  */
  assign n1410_o = v[0];
  /* ./timing_generator.vhd:193:12  */
  assign n1411_o = v[1];
  /* ./timing_generator.vhd:194:12  */
  assign n1412_o = v[2];
  /* ./timing_generator.vhd:195:12  */
  assign n1413_o = v[5];
  /* ./timing_generator.vhd:196:12  */
  assign n1414_o = v[7];
  /* ./timing_generator.vhd:198:18  */
  assign n1415_o = h[5];
  /* ./timing_generator.vhd:198:27  */
  assign n1416_o = h[3];
  /* ./timing_generator.vhd:198:36  */
  assign n1417_o = h[4];
  /* ./timing_generator.vhd:198:31  */
  assign n1418_o = n1416_o & n1417_o;
  /* ./timing_generator.vhd:198:22  */
  assign n1419_o = n1415_o | n1418_o;
  /* ./timing_generator.vhd:198:12  */
  assign n1420_o = ~n1419_o;
  /* ./timing_generator.vhd:199:13  */
  assign n1421_o = v[6];
  /* ./timing_generator.vhd:199:22  */
  assign n1422_o = v[7];
  /* ./timing_generator.vhd:199:17  */
  assign n1423_o = n1421_o & n1422_o;
  /* ./timing_generator.vhd:209:33  */
  assign n1424_o = h[2:0];
  /* ./timing_generator.vhd:210:38  */
  assign n1425_o = h[5];
  /* ./timing_generator.vhd:210:33  */
  assign n1426_o = ~n1425_o;
  /* ./timing_generator.vhd:210:49  */
  assign n1427_o = v[6];
  /* ./timing_generator.vhd:210:42  */
  assign n1428_o = {n1426_o, n1427_o};
  /* ./timing_generator.vhd:210:56  */
  assign n1429_o = h[4];
  /* ./timing_generator.vhd:210:53  */
  assign n1430_o = {n1428_o, n1429_o};
  /* ./timing_generator.vhd:210:63  */
  assign n1431_o = h[3];
  /* ./timing_generator.vhd:210:60  */
  assign n1432_o = {n1430_o, n1431_o};
  /* ./timing_generator.vhd:211:38  */
  assign n1433_o = v[7];
  /* ./timing_generator.vhd:211:49  */
  assign n1434_o = h[5];
  /* ./timing_generator.vhd:211:44  */
  assign n1435_o = ~n1434_o;
  /* ./timing_generator.vhd:211:42  */
  assign n1436_o = {n1433_o, n1435_o};
  /* ./timing_generator.vhd:211:56  */
  assign n1437_o = v[7];
  /* ./timing_generator.vhd:211:53  */
  assign n1438_o = {n1436_o, n1437_o};
  /* ./timing_generator.vhd:211:60  */
  assign n1440_o = {n1438_o, 1'b1};
  /* ./timing_generator.vhd:210:68  */
  assign n1441_o = n1432_o + n1440_o;
  /* ./timing_generator.vhd:212:63  */
  assign n1442_o = v[6];
  /* ./timing_generator.vhd:212:60  */
  assign n1444_o = {3'b000, n1442_o};
  /* ./timing_generator.vhd:211:68  */
  assign n1445_o = n1441_o + n1444_o;
  /* ./timing_generator.vhd:213:33  */
  assign n1446_o = v[5:3];
  /* ./timing_generator.vhd:215:11  */
  assign n1448_o = {2'b00, hbl};
  /* ./timing_generator.vhd:215:30  */
  assign n1449_o = ~store80;
  /* ./timing_generator.vhd:215:26  */
  assign n1450_o = page2 & n1449_o;
  /* ./timing_generator.vhd:215:17  */
  assign n1451_o = {n1448_o, n1450_o};
  /* ./timing_generator.vhd:215:60  */
  assign n1452_o = ~store80;
  /* ./timing_generator.vhd:215:56  */
  assign n1453_o = page2 & n1452_o;
  /* ./timing_generator.vhd:215:45  */
  assign n1454_o = ~n1453_o;
  /* ./timing_generator.vhd:215:43  */
  assign n1455_o = {n1451_o, n1454_o};
  /* ./timing_generator.vhd:215:85  */
  assign n1456_o = ~hires;
  /* ./timing_generator.vhd:215:74  */
  assign n1457_o = n1456_o ? n1455_o : n1465_o;
  /* ./timing_generator.vhd:216:30  */
  assign n1458_o = ~store80;
  /* ./timing_generator.vhd:216:26  */
  assign n1459_o = page2 & n1458_o;
  /* ./timing_generator.vhd:216:60  */
  assign n1460_o = ~store80;
  /* ./timing_generator.vhd:216:56  */
  assign n1461_o = page2 & n1460_o;
  /* ./timing_generator.vhd:216:45  */
  assign n1462_o = ~n1461_o;
  /* ./timing_generator.vhd:216:43  */
  assign n1463_o = {n1459_o, n1462_o};
  /* ./timing_generator.vhd:216:77  */
  assign n1464_o = v[2:0];
  /* ./timing_generator.vhd:216:73  */
  assign n1465_o = {n1463_o, n1464_o};
  /* ./timing_generator.vhd:176:9  */
  assign n1467_o = rasrise1 ? n1402_o : h;
  /* ./timing_generator.vhd:176:9  */
  always @(posedge clk_14m)
    n1468_q <= n1467_o;
  initial
    n1468_q = 7'b0000000;
  /* ./timing_generator.vhd:176:9  */
  assign n1469_o = rasrise1 ? n1403_o : v;
  /* ./timing_generator.vhd:176:9  */
  always @(posedge clk_14m)
    n1470_q <= n1469_o;
  initial
    n1470_q = 9'b011111010;
  /* ./timing_generator.vhd:78:9  */
  always @(posedge clk_14m)
    n1471_q <= n1193_o;
  initial
    n1471_q = 1'b0;
  /* ./timing_generator.vhd:127:9  */
  always @(posedge clk_14m)
    n1472_q <= vid7m_pre;
  initial
    n1472_q = 1'b0;
  /* ./timing_generator.vhd:127:9  */
  always @(posedge clk_14m)
    n1473_q <= q3_pre;
  initial
    n1473_q = 1'b0;
  /* ./timing_generator.vhd:127:9  */
  always @(posedge clk_14m)
    n1474_q <= ras_n_pre;
  initial
    n1474_q = 1'b0;
  /* ./timing_generator.vhd:127:9  */
  always @(posedge clk_14m)
    n1475_q <= cas_n_pre;
  initial
    n1475_q = 1'b0;
  /* ./timing_generator.vhd:127:9  */
  always @(posedge clk_14m)
    n1476_q <= ax_pre;
  initial
    n1476_q = 1'b0;
  /* ./timing_generator.vhd:127:9  */
  always @(posedge clk_14m)
    n1477_q <= phi0_pre;
  initial
    n1477_q = 1'b0;
  /* ./timing_generator.vhd:78:9  */
  always @(posedge clk_14m)
    n1478_q <= n1192_o;
  initial
    n1478_q = 1'b0;
  /* ./timing_generator.vhd:78:9  */
  assign n1479_o = {1'b0, n1457_o, n1446_o, n1445_o, n1424_o};
  /* ./timing_generator.vhd:156:9  */
  assign n1480_o = rasrise1 ? n1374_o : n1481_q;
  /* ./timing_generator.vhd:156:9  */
  always @(posedge clk_14m)
    n1481_q <= n1480_o;
  /* ./timing_generator.vhd:156:9  */
  assign n1482_o = rasrise1 ? n1375_o : n1483_q;
  /* ./timing_generator.vhd:156:9  */
  always @(posedge clk_14m)
    n1483_q <= n1482_o;
  /* ./timing_generator.vhd:156:9  */
  assign n1484_o = rasrise1 ? vc : n1485_q;
  /* ./timing_generator.vhd:156:9  */
  always @(posedge clk_14m)
    n1485_q <= n1484_o;
  /* ./timing_generator.vhd:141:9  */
  assign n1486_o = rasrise1 ? n1356_o : n1487_q;
  /* ./timing_generator.vhd:141:9  */
  always @(posedge clk_14m)
    n1487_q <= n1486_o;
  /* ./timing_generator.vhd:141:9  */
  assign n1488_o = rasrise1 ? n1487_q : n1489_q;
  /* ./timing_generator.vhd:141:9  */
  always @(posedge clk_14m)
    n1489_q <= n1488_o;
  /* ./timing_generator.vhd:141:9  */
  assign n1490_o = rasrise1 ? hbl : n1491_q;
  /* ./timing_generator.vhd:141:9  */
  always @(posedge clk_14m)
    n1491_q <= n1490_o;
  /* ./timing_generator.vhd:141:9  */
  assign n1492_o = rasrise1 ? vbl : n1493_q;
  /* ./timing_generator.vhd:141:9  */
  always @(posedge clk_14m)
    n1493_q <= n1492_o;
  /* ./timing_generator.vhd:141:9  */
  assign n1494_o = rasrise1 ? n1352_o : n1495_q;
  /* ./timing_generator.vhd:141:9  */
  always @(posedge clk_14m)
    n1495_q <= n1494_o;
  /* ./timing_generator.vhd:127:9  */
  always @(posedge clk_14m)
    n1496_q <= ldps_n_pre;
endmodule

module disk_ii
  (input  clk_14m,
   input  clk_2m,
   input  phase_zero,
   input  io_select,
   input  device_select,
   input  reset,
   input  [1:0] disk_ready,
   input  [15:0] a,
   input  [7:0] d_in,
   input  [7:0] drom_d,
   input  d1_wp,
   input  d2_wp,
   input  [7:0] track1_do,
   input  track1_busy,
   input  [7:0] track2_do,
   input  track2_busy,
   output [7:0] d_out,
   output d1_active,
   output d2_active,
   output [5:0] track1,
   output [12:0] track1_addr,
   output [7:0] track1_di,
   output track1_we,
   output [5:0] track2,
   output [12:0] track2_addr,
   output [7:0] track2_di,
   output track2_we);
  wire [3:0] motor_phase;
  wire drive_on;
  wire drive_real_on;
  wire drive2_select;
  wire q6;
  wire q7;
  wire [7:0] rom_dout;
  wire [7:0] d_out1;
  wire [7:0] d_out2;
  wire read_disk;
  wire write_reg;
  wire [7:0] data_reg;
  wire write_mode;
  wire [7:0] write_protect_bits;
  wire n995_o;
  wire n996_o;
  wire [1:0] n997_o;
  wire n1000_o;
  wire [1:0] n1002_o;
  wire n1003_o;
  wire n1005_o;
  wire n1006_o;
  wire n1008_o;
  wire n1009_o;
  wire n1011_o;
  wire n1012_o;
  wire n1014_o;
  wire [3:0] n1015_o;
  reg n1016_o;
  reg n1017_o;
  reg n1018_o;
  reg n1019_o;
  wire [3:0] n1020_o;
  wire n1021_o;
  wire n1022_o;
  wire n1023_o;
  wire n1024_o;
  wire n1025_o;
  wire n1026_o;
  wire n1027_o;
  wire n1028_o;
  wire n1029_o;
  wire [3:0] n1031_o;
  wire n1033_o;
  wire n1035_o;
  wire n1037_o;
  wire n1039_o;
  reg [23:0] drive_on_delay_spindown_delay;
  reg drive_on_delay_drive_on_old;
  wire n1051_o;
  wire [23:0] n1053_o;
  wire n1055_o;
  wire n1057_o;
  wire n1058_o;
  wire [23:0] n1059_o;
  wire [23:0] n1061_o;
  wire n1063_o;
  wire [23:0] n1065_o;
  reg [23:0] n1075_q;
  wire n1076_o;
  wire n1077_o;
  reg n1078_q;
  wire n1079_o;
  wire n1080_o;
  wire n1081_o;
  wire [3:0] n1083_o;
  wire n1085_o;
  wire n1086_o;
  wire n1087_o;
  wire [1:0] n1090_o;
  wire n1092_o;
  wire n1093_o;
  wire n1094_o;
  wire n1095_o;
  wire n1096_o;
  wire n1099_o;
  wire [7:0] n1100_o;
  wire n1102_o;
  wire n1103_o;
  wire [7:0] n1104_o;
  wire [7:0] n1106_o;
  wire n1107_o;
  wire [7:0] n1108_o;
  wire n1109_o;
  wire [7:0] n1110_o;
  wire [7:0] drive_1_d_out;
  wire [5:0] drive_1_track;
  wire [12:0] drive_1_track_addr;
  wire [7:0] drive_1_track_di;
  wire drive_1_track_we;
  wire n1111_o;
  wire [7:0] drive_2_d_out;
  wire [5:0] drive_2_track;
  wire [12:0] drive_2_track_addr;
  wire [7:0] drive_2_track_di;
  wire drive_2_track_we;
  wire n1117_o;
  reg [3:0] n1123_q;
  reg n1124_q;
  reg n1125_q;
  reg n1126_q;
  reg n1127_q;
  reg n1128_q;
  wire n1133_o;
  wire n1134_o;
  wire n1135_o;
  wire n1136_o;
  wire n1137_o;
  wire n1138_o;
  wire n1139_o;
  wire n1140_o;
  wire n1141_o;
  wire n1142_o;
  wire n1143_o;
  wire n1144_o;
  wire n1145_o;
  wire n1146_o;
  wire n1147_o;
  wire n1148_o;
  wire [3:0] n1149_o;
  assign d_out = n1106_o;
  assign d1_active = n1080_o;
  assign d2_active = n1081_o;
  assign track1 = drive_1_track;
  assign track1_addr = drive_1_track_addr;
  assign track1_di = drive_1_track_di;
  assign track1_we = drive_1_track_we;
  assign track2 = drive_2_track;
  assign track2_addr = drive_2_track_addr;
  assign track2_di = drive_2_track_di;
  assign track2_we = drive_2_track_we;
  /* ./disk_ii.vhd:106:10  */
  assign motor_phase = n1123_q; // (signal)
  /* ./disk_ii.vhd:107:10  */
  assign drive_on = n1124_q; // (signal)
  /* ./disk_ii.vhd:108:10  */
  assign drive_real_on = n1125_q; // (signal)
  /* ./disk_ii.vhd:109:10  */
  assign drive2_select = n1126_q; // (signal)
  /* ./disk_ii.vhd:110:10  */
  assign q6 = n1127_q; // (signal)
  /* ./disk_ii.vhd:110:14  */
  assign q7 = n1128_q; // (signal)
  /* ./disk_ii.vhd:113:10  */
  assign rom_dout = drom_d; // (signal)
  /* ./disk_ii.vhd:114:10  */
  assign d_out1 = drive_1_d_out; // (signal)
  /* ./disk_ii.vhd:115:10  */
  assign d_out2 = drive_2_d_out; // (signal)
  /* ./disk_ii.vhd:123:10  */
  assign read_disk = n1087_o; // (signal)
  /* ./disk_ii.vhd:124:10  */
  assign write_reg = n1096_o; // (signal)
  /* ./disk_ii.vhd:125:10  */
  assign data_reg = n1110_o; // (signal)
  /* ./disk_ii.vhd:127:10  */
  assign write_mode = q7; // (signal)
  /* ./disk_ii.vhd:129:10  */
  assign write_protect_bits = n1100_o; // (signal)
  /* ./disk_ii.vhd:144:15  */
  assign n995_o = a[3];
  /* ./disk_ii.vhd:144:19  */
  assign n996_o = ~n995_o;
  /* ./disk_ii.vhd:145:37  */
  assign n997_o = a[2:1];
  /* ./disk_ii.vhd:145:56  */
  assign n1000_o = a[0];
  /* ./disk_ii.vhd:147:19  */
  assign n1002_o = a[2:1];
  /* ./disk_ii.vhd:148:41  */
  assign n1003_o = a[0];
  /* ./disk_ii.vhd:148:15  */
  assign n1005_o = n1002_o == 2'b00;
  /* ./disk_ii.vhd:149:46  */
  assign n1006_o = a[0];
  /* ./disk_ii.vhd:149:15  */
  assign n1008_o = n1002_o == 2'b01;
  /* ./disk_ii.vhd:150:35  */
  assign n1009_o = a[0];
  /* ./disk_ii.vhd:150:15  */
  assign n1011_o = n1002_o == 2'b10;
  /* ./disk_ii.vhd:151:35  */
  assign n1012_o = a[0];
  /* ./disk_ii.vhd:151:15  */
  assign n1014_o = n1002_o == 2'b11;
  assign n1015_o = {n1014_o, n1011_o, n1008_o, n1005_o};
  /* ./disk_ii.vhd:147:13  */
  always @*
    case (n1015_o)
      4'b1000: n1016_o = drive_on;
      4'b0100: n1016_o = drive_on;
      4'b0010: n1016_o = drive_on;
      4'b0001: n1016_o = n1003_o;
      default: n1016_o = drive_on;
    endcase
  /* ./disk_ii.vhd:147:13  */
  always @*
    case (n1015_o)
      4'b1000: n1017_o = drive2_select;
      4'b0100: n1017_o = drive2_select;
      4'b0010: n1017_o = n1006_o;
      4'b0001: n1017_o = drive2_select;
      default: n1017_o = drive2_select;
    endcase
  /* ./disk_ii.vhd:147:13  */
  always @*
    case (n1015_o)
      4'b1000: n1018_o = q6;
      4'b0100: n1018_o = n1009_o;
      4'b0010: n1018_o = q6;
      4'b0001: n1018_o = q6;
      default: n1018_o = q6;
    endcase
  /* ./disk_ii.vhd:147:13  */
  always @*
    case (n1015_o)
      4'b1000: n1019_o = n1012_o;
      4'b0100: n1019_o = q7;
      4'b0010: n1019_o = q7;
      4'b0001: n1019_o = q7;
      default: n1019_o = q7;
    endcase
  /* ./disk_ii.vhd:143:9  */
  assign n1020_o = n1025_o ? n1149_o : motor_phase;
  /* ./disk_ii.vhd:144:11  */
  assign n1021_o = n996_o ? drive_on : n1016_o;
  /* ./disk_ii.vhd:144:11  */
  assign n1022_o = n996_o ? drive2_select : n1017_o;
  /* ./disk_ii.vhd:144:11  */
  assign n1023_o = n996_o ? q6 : n1018_o;
  /* ./disk_ii.vhd:144:11  */
  assign n1024_o = n996_o ? q7 : n1019_o;
  /* ./disk_ii.vhd:143:9  */
  assign n1025_o = n996_o & device_select;
  /* ./disk_ii.vhd:143:9  */
  assign n1026_o = device_select ? n1021_o : drive_on;
  /* ./disk_ii.vhd:143:9  */
  assign n1027_o = device_select ? n1022_o : drive2_select;
  /* ./disk_ii.vhd:143:9  */
  assign n1028_o = device_select ? n1023_o : q6;
  /* ./disk_ii.vhd:143:9  */
  assign n1029_o = device_select ? n1024_o : q7;
  /* ./disk_ii.vhd:136:7  */
  assign n1031_o = reset ? 4'b0000 : n1020_o;
  /* ./disk_ii.vhd:136:7  */
  assign n1033_o = reset ? 1'b0 : n1026_o;
  /* ./disk_ii.vhd:136:7  */
  assign n1035_o = reset ? 1'b0 : n1027_o;
  /* ./disk_ii.vhd:136:7  */
  assign n1037_o = reset ? 1'b0 : n1028_o;
  /* ./disk_ii.vhd:136:7  */
  assign n1039_o = reset ? 1'b0 : n1029_o;
  /* ./disk_ii.vhd:161:14  */
  always @*
    drive_on_delay_spindown_delay = n1075_q; // (isignal)
  initial
    drive_on_delay_spindown_delay = 24'bX;
  /* ./disk_ii.vhd:162:14  */
  always @*
    drive_on_delay_drive_on_old = n1078_q; // (isignal)
  initial
    drive_on_delay_drive_on_old = 1'bX;
  /* ./disk_ii.vhd:168:25  */
  assign n1051_o = drive_on_delay_spindown_delay != 24'b000000000000000000000000;
  /* ./disk_ii.vhd:169:42  */
  assign n1053_o = drive_on_delay_spindown_delay - 24'b000000000000000000000001;
  /* ./disk_ii.vhd:170:27  */
  assign n1055_o = n1053_o == 24'b000000000000000000000000;
  /* ./disk_ii.vhd:168:7  */
  assign n1057_o = n1058_o ? 1'b0 : drive_real_on;
  /* ./disk_ii.vhd:168:7  */
  assign n1058_o = n1055_o & n1051_o;
  /* ./disk_ii.vhd:168:7  */
  assign n1059_o = n1051_o ? n1053_o : drive_on_delay_spindown_delay;
  /* ./disk_ii.vhd:178:7  */
  assign n1061_o = drive_on_delay_drive_on_old ? 24'b110101011001111110000000 : n1059_o;
  /* ./disk_ii.vhd:175:7  */
  assign n1063_o = drive_on ? 1'b1 : n1057_o;
  /* ./disk_ii.vhd:175:7  */
  assign n1065_o = drive_on ? 24'b000000000000000000000000 : n1061_o;
  /* ./disk_ii.vhd:167:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n1075_q <= 24'b000000000000000000000000;
    else
      n1075_q <= n1065_o;
  /* ./disk_ii.vhd:160:3  */
  assign n1076_o = ~reset;
  /* ./disk_ii.vhd:167:5  */
  assign n1077_o = n1076_o ? drive_on : drive_on_delay_drive_on_old;
  /* ./disk_ii.vhd:167:5  */
  always @(posedge clk_14m)
    n1078_q <= n1077_o;
  /* ./disk_ii.vhd:187:34  */
  assign n1079_o = ~drive2_select;
  /* ./disk_ii.vhd:187:30  */
  assign n1080_o = drive_real_on & n1079_o;
  /* ./disk_ii.vhd:188:30  */
  assign n1081_o = drive_real_on & drive2_select;
  /* ./disk_ii.vhd:191:50  */
  assign n1083_o = a[3:0];
  /* ./disk_ii.vhd:191:63  */
  assign n1085_o = n1083_o == 4'b1100;
  /* ./disk_ii.vhd:191:45  */
  assign n1086_o = n1085_o & device_select;
  /* ./disk_ii.vhd:191:20  */
  assign n1087_o = n1086_o ? 1'b1 : 1'b0;
  /* ./disk_ii.vhd:193:50  */
  assign n1090_o = a[3:2];
  /* ./disk_ii.vhd:193:63  */
  assign n1092_o = n1090_o == 2'b11;
  /* ./disk_ii.vhd:193:45  */
  assign n1093_o = n1092_o & device_select;
  /* ./disk_ii.vhd:193:75  */
  assign n1094_o = a[0];
  /* ./disk_ii.vhd:193:70  */
  assign n1095_o = n1094_o & n1093_o;
  /* ./disk_ii.vhd:193:20  */
  assign n1096_o = n1095_o ? 1'b1 : 1'b0;
  /* ./disk_ii.vhd:196:56  */
  assign n1099_o = d2_wp & drive2_select;
  /* ./disk_ii.vhd:196:31  */
  assign n1100_o = n1099_o ? 8'b10000000 : n1104_o;
  /* ./disk_ii.vhd:196:102  */
  assign n1102_o = ~drive2_select;
  /* ./disk_ii.vhd:196:108  */
  assign n1103_o = d1_wp & n1102_o;
  /* ./disk_ii.vhd:196:72  */
  assign n1104_o = n1103_o ? 8'b10000000 : 8'b00000000;
  /* ./disk_ii.vhd:198:21  */
  assign n1106_o = io_select ? rom_dout : n1108_o;
  /* ./disk_ii.vhd:198:64  */
  assign n1107_o = ~q6;
  /* ./disk_ii.vhd:198:42  */
  assign n1108_o = n1107_o ? data_reg : write_protect_bits;
  /* ./disk_ii.vhd:199:41  */
  assign n1109_o = ~drive2_select;
  /* ./disk_ii.vhd:199:22  */
  assign n1110_o = n1109_o ? d_out1 : d_out2;
  /* ./disk_ii.vhd:201:3  */
  drive_ii drive_1 (
    .clk_14m(clk_14m),
    .clk_2m(clk_2m),
    .phase_zero(phase_zero),
    .reset(reset),
    .disk_ready(n1111_o),
    .d_in(d_in),
    .disk_active(n1080_o),
    .motor_phase(motor_phase),
    .write_mode(write_mode),
    .read_disk(read_disk),
    .write_reg(write_reg),
    .track_do(track1_do),
    .track_busy(track1_busy),
    .d_out(drive_1_d_out),
    .track(drive_1_track),
    .track_addr(drive_1_track_addr),
    .track_di(drive_1_track_di),
    .track_we(drive_1_track_we));
  /* ./disk_ii.vhd:207:33  */
  assign n1111_o = disk_ready[0];
  /* ./disk_ii.vhd:224:3  */
  drive_ii drive_2 (
    .clk_14m(clk_14m),
    .clk_2m(clk_2m),
    .phase_zero(phase_zero),
    .reset(reset),
    .disk_ready(n1117_o),
    .d_in(d_in),
    .disk_active(n1081_o),
    .motor_phase(motor_phase),
    .write_mode(write_mode),
    .read_disk(read_disk),
    .write_reg(write_reg),
    .track_do(track2_do),
    .track_busy(track2_busy),
    .d_out(drive_2_d_out),
    .track(drive_2_track),
    .track_addr(drive_2_track_addr),
    .track_di(drive_2_track_di),
    .track_we(drive_2_track_we));
  /* ./disk_ii.vhd:230:33  */
  assign n1117_o = disk_ready[1];
  /* ./disk_ii.vhd:135:5  */
  always @(posedge clk_14m)
    n1123_q <= n1031_o;
  /* ./disk_ii.vhd:135:5  */
  always @(posedge clk_14m)
    n1124_q <= n1033_o;
  /* ./disk_ii.vhd:167:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n1125_q <= 1'b0;
    else
      n1125_q <= n1063_o;
  /* ./disk_ii.vhd:135:5  */
  always @(posedge clk_14m)
    n1126_q <= n1035_o;
  /* ./disk_ii.vhd:135:5  */
  always @(posedge clk_14m)
    n1127_q <= n1037_o;
  /* ./disk_ii.vhd:135:5  */
  always @(posedge clk_14m)
    n1128_q <= n1039_o;
  /* ./disk_ii.vhd:145:13  */
  assign n1133_o = n997_o[1];
  /* ./disk_ii.vhd:145:13  */
  assign n1134_o = ~n1133_o;
  /* ./disk_ii.vhd:145:13  */
  assign n1135_o = n997_o[0];
  /* ./disk_ii.vhd:145:13  */
  assign n1136_o = ~n1135_o;
  /* ./disk_ii.vhd:145:13  */
  assign n1137_o = n1134_o & n1136_o;
  /* ./disk_ii.vhd:145:13  */
  assign n1138_o = n1134_o & n1135_o;
  /* ./disk_ii.vhd:145:13  */
  assign n1139_o = n1133_o & n1136_o;
  /* ./disk_ii.vhd:145:13  */
  assign n1140_o = n1133_o & n1135_o;
  /* ./disk_ii.vhd:216:23  */
  assign n1141_o = motor_phase[0];
  /* ./disk_ii.vhd:145:13  */
  assign n1142_o = n1137_o ? n1000_o : n1141_o;
  /* ./disk_ii.vhd:99:5  */
  assign n1143_o = motor_phase[1];
  /* ./disk_ii.vhd:145:13  */
  assign n1144_o = n1138_o ? n1000_o : n1143_o;
  /* ./disk_ii.vhd:96:5  */
  assign n1145_o = motor_phase[2];
  /* ./disk_ii.vhd:145:13  */
  assign n1146_o = n1139_o ? n1000_o : n1145_o;
  /* ./disk_ii.vhd:92:5  */
  assign n1147_o = motor_phase[3];
  /* ./disk_ii.vhd:145:13  */
  assign n1148_o = n1140_o ? n1000_o : n1147_o;
  /* ./disk_ii.vhd:89:5  */
  assign n1149_o = {n1148_o, n1146_o, n1144_o, n1142_o};
endmodule

module apple2
  (input  clk_14m,
   input  palmode,
   input  romswitch,
   input  cpu_wait,
   input  flash_clk,
   input  reset,
   input  cpu,
   input  [15:0] ram_do,
   input  [7:0] pd,
   input  irq_n,
   input  nmi_n,
   input  [7:0] k,
   input  akd,
   input  [7:0] gameport,
   input  [7:0] rom_d,
   input  [7:0] vrom_d,
   output clk_2m,
   output phase_zero,
   output phase_zero_r,
   output phase_zero_f,
   output [15:0] addr,
   output [17:0] ram_addr,
   output [7:0] d,
   output aux,
   output cpu_we,
   output ram_we,
   output video,
   output color_line,
   output text_mode,
   output hbl,
   output vbl,
   output read_key,
   output [3:0] an,
   output pdl_strobe,
   output stb,
   output [7:0] io_select,
   output [7:0] device_select,
   output io_strobe,
   output [13:0] rom_a,
   output [12:0] vrom_a,
   output speaker);
  wire clk_7m;
  wire q3;
  wire ras_n;
  wire cas_n;
  wire ax;
  wire cpu_en;
  wire phase_zero_d;
  wire [15:0] video_address;
  wire ldps_n;
  wire wndw_n;
  wire gr2;
  wire sega;
  wire segb;
  wire segc;
  reg [7:0] soft_switches;
  wire mixed_mode;
  wire page2;
  wire hires_mode;
  wire dhires_mode;
  wire ramrd;
  wire ramwrt;
  wire cxrom;
  wire store80;
  wire c3rom;
  wire c8rom;
  wire altzp;
  wire altchar;
  wire col80;
  wire sf_d;
  wire [7:0] d_in;
  wire [7:0] d_out;
  wire [15:0] a;
  wire [23:0] t65_a;
  wire [7:0] t65_di;
  wire [7:0] t65_do;
  wire t65_we_n;
  wire we;
  wire [7:0] rom_out;
  wire [13:0] rom_addr;
  reg ram_select;
  reg keyboard_select;
  wire tape_out;
  wire speaker_select;
  wire softswitch_select;
  wire rom_select;
  wire gameport_select;
  wire hram_control;
  wire c01x_select;
  reg speaker_sig;
  wire [7:0] cpu_dl;
  wire [7:0] video_dl;
  wire [15:0] video_dl_latch;
  wire dxxx;
  wire hram_read;
  wire hram_pre_wr;
  wire hram_wr_n;
  wire hram_bank1;
  wire [17:0] cpu_ram_addr;
  wire hram_read_en;
  wire hram_write_en;
  wire [7:0] ioselect;
  wire [7:0] devselect;
  wire [17:0] card_addr;
  wire card_ram_rd;
  wire card_ram_we;
  wire ram_card_read;
  wire ram_card_write;
  wire ram_card_sel;
  wire [17:0] n109_o;
  wire [17:0] n111_o;
  wire n112_o;
  wire n113_o;
  wire n114_o;
  wire n115_o;
  wire n116_o;
  wire n121_o;
  wire n122_o;
  wire n123_o;
  wire n126_o;
  wire n127_o;
  wire n128_o;
  wire n129_o;
  wire n130_o;
  wire n131_o;
  wire n132_o;
  wire [7:0] n133_o;
  wire [7:0] n134_o;
  wire [7:0] n135_o;
  wire [7:0] n136_o;
  wire n139_o;
  wire [7:0] n143_o;
  wire n144_o;
  wire [7:0] n145_o;
  wire [7:0] n146_o;
  wire [13:0] n147_o;
  wire [1:0] n149_o;
  wire n151_o;
  wire n153_o;
  wire n154_o;
  wire n156_o;
  wire n157_o;
  wire [1:0] n158_o;
  wire [3:0] n159_o;
  wire [3:0] n160_o;
  wire n162_o;
  wire n164_o;
  wire n166_o;
  wire n168_o;
  wire n170_o;
  wire n172_o;
  wire n174_o;
  wire n176_o;
  wire n178_o;
  wire [2:0] n179_o;
  localparam [7:0] n182_o = 8'b00000000;
  wire n186_o;
  wire n188_o;
  wire n189_o;
  wire n191_o;
  wire n192_o;
  wire n194_o;
  wire n195_o;
  wire n197_o;
  wire n198_o;
  wire n200_o;
  wire n201_o;
  wire n203_o;
  wire n204_o;
  wire [9:0] n205_o;
  reg n208_o;
  reg n211_o;
  reg n214_o;
  reg n217_o;
  reg n220_o;
  reg n223_o;
  reg n226_o;
  reg n229_o;
  reg n232_o;
  reg [7:0] n234_o;
  wire n236_o;
  wire [2:0] n237_o;
  localparam [7:0] n240_o = 8'b00000000;
  wire n245_o;
  wire [7:0] n247_o;
  wire n249_o;
  wire n251_o;
  wire n252_o;
  wire n254_o;
  wire n255_o;
  wire n257_o;
  wire n258_o;
  wire n260_o;
  wire n261_o;
  wire n263_o;
  wire n264_o;
  wire n265_o;
  wire n266_o;
  wire [2:0] n267_o;
  localparam [7:0] n270_o = 8'b00000000;
  wire n275_o;
  wire [7:0] n277_o;
  wire n279_o;
  wire n280_o;
  wire n283_o;
  wire n286_o;
  wire n288_o;
  wire n290_o;
  wire n291_o;
  wire n293_o;
  wire n294_o;
  wire n296_o;
  wire n297_o;
  wire n299_o;
  wire n300_o;
  wire n302_o;
  wire n303_o;
  wire n305_o;
  wire n306_o;
  wire n308_o;
  wire n309_o;
  wire [3:0] n310_o;
  reg n312_o;
  reg n314_o;
  reg n316_o;
  reg n318_o;
  reg n320_o;
  reg n322_o;
  reg n324_o;
  reg n326_o;
  reg n328_o;
  reg n330_o;
  reg n332_o;
  reg [7:0] n334_o;
  reg [7:0] n336_o;
  wire n338_o;
  wire n340_o;
  wire n342_o;
  wire n343_o;
  wire n345_o;
  wire n346_o;
  wire [1:0] n347_o;
  reg n349_o;
  reg n351_o;
  reg n353_o;
  reg n355_o;
  reg n357_o;
  reg n359_o;
  reg n361_o;
  reg n364_o;
  reg n366_o;
  reg n368_o;
  reg n370_o;
  reg [7:0] n372_o;
  reg [7:0] n374_o;
  wire n376_o;
  wire [1:0] n377_o;
  reg n379_o;
  reg n382_o;
  reg n385_o;
  reg n389_o;
  reg n392_o;
  reg n395_o;
  reg n398_o;
  reg n401_o;
  reg n404_o;
  reg n407_o;
  reg n410_o;
  reg n413_o;
  reg [7:0] n416_o;
  reg [7:0] n419_o;
  wire [6:0] n423_o;
  wire n425_o;
  wire [1:0] n426_o;
  wire n428_o;
  wire n429_o;
  wire [5:0] n430_o;
  wire n432_o;
  wire n433_o;
  wire n434_o;
  wire n435_o;
  wire n436_o;
  wire n437_o;
  wire n438_o;
  wire n439_o;
  wire n440_o;
  wire [2:0] n441_o;
  wire n443_o;
  wire n444_o;
  wire n445_o;
  wire n446_o;
  wire n447_o;
  wire n448_o;
  wire n449_o;
  wire n450_o;
  wire n451_o;
  wire n452_o;
  wire n453_o;
  wire n454_o;
  wire n455_o;
  wire n456_o;
  wire n457_o;
  wire n458_o;
  wire n459_o;
  wire n460_o;
  wire n461_o;
  wire n463_o;
  wire n468_o;
  wire n469_o;
  wire n475_o;
  wire [2:0] n476_o;
  wire n479_o;
  wire n484_o;
  wire n485_o;
  wire n486_o;
  wire n487_o;
  wire [3:0] n488_o;
  wire n489_o;
  wire n492_o;
  wire n493_o;
  wire n494_o;
  wire n495_o;
  wire n496_o;
  wire n497_o;
  wire n498_o;
  wire n499_o;
  wire n500_o;
  wire n501_o;
  wire n502_o;
  wire n504_o;
  wire n506_o;
  wire n507_o;
  wire n508_o;
  wire n509_o;
  wire n510_o;
  wire [3:0] n529_o;
  wire n531_o;
  wire n532_o;
  wire [17:0] n534_o;
  wire [2:0] n535_o;
  wire [4:0] n537_o;
  wire n538_o;
  wire n539_o;
  wire n540_o;
  wire n541_o;
  wire [5:0] n542_o;
  wire [11:0] n543_o;
  wire [17:0] n544_o;
  wire n545_o;
  wire n546_o;
  wire n547_o;
  wire n548_o;
  wire n549_o;
  wire n550_o;
  wire n551_o;
  wire n552_o;
  wire n553_o;
  wire n554_o;
  wire n555_o;
  wire n556_o;
  wire n557_o;
  wire n558_o;
  wire n559_o;
  wire n560_o;
  wire n561_o;
  wire [7:0] n564_o;
  wire n566_o;
  wire n567_o;
  wire n568_o;
  wire n570_o;
  wire n572_o;
  wire n574_o;
  wire n575_o;
  wire n576_o;
  wire [2:0] n577_o;
  wire n578_o;
  wire n580_o;
  wire n581_o;
  wire n583_o;
  wire n584_o;
  wire n586_o;
  wire n587_o;
  wire n589_o;
  wire n590_o;
  wire n592_o;
  wire n593_o;
  wire n595_o;
  wire n596_o;
  wire n598_o;
  wire n599_o;
  wire n601_o;
  wire [7:0] n602_o;
  reg n603_o;
  reg n604_o;
  reg n605_o;
  reg n606_o;
  reg n607_o;
  reg n608_o;
  reg n609_o;
  reg n610_o;
  wire n611_o;
  wire n612_o;
  wire [3:0] n613_o;
  wire n615_o;
  wire n616_o;
  wire n618_o;
  wire n620_o;
  wire n622_o;
  wire n624_o;
  wire n626_o;
  wire n628_o;
  wire n630_o;
  wire n632_o;
  wire n633_o;
  wire n635_o;
  wire n637_o;
  wire n639_o;
  wire n641_o;
  wire n643_o;
  wire n645_o;
  wire n647_o;
  wire [15:0] n648_o;
  reg n651_o;
  reg n652_o;
  wire n653_o;
  wire n656_o;
  wire n657_o;
  wire n658_o;
  wire n660_o;
  wire n670_o;
  wire n703_o;
  wire n704_o;
  wire [7:0] n705_o;
  wire [7:0] n706_o;
  wire [6:0] n707_o;
  wire [7:0] n708_o;
  wire [7:0] n709_o;
  wire [2:0] n710_o;
  wire [6:0] n714_o;
  wire [7:0] n715_o;
  wire [7:0] n716_o;
  wire [7:0] n717_o;
  wire [7:0] n718_o;
  wire n719_o;
  wire n720_o;
  wire n721_o;
  wire n722_o;
  wire n723_o;
  wire n725_o;
  wire n726_o;
  wire [7:0] n727_o;
  wire timing_vid7m;
  wire timing_q3;
  wire timing_ras_n;
  wire timing_cas_n;
  wire timing_ax;
  wire timing_phi0;
  wire timing_phi0_en_r;
  wire timing_phi0_en_f;
  wire timing_color_ref;
  wire [15:0] timing_video_address;
  wire timing_sega;
  wire timing_segb;
  wire timing_segc;
  wire timing_gr1;
  wire timing_gr2;
  wire timing_hblank;
  wire timing_vblank;
  wire timing_wndw_n;
  wire timing_ldps_n;
  wire n737_o;
  wire [12:0] video_display_vrom_a;
  wire video_display_video;
  wire n750_o;
  wire [15:0] n751_o;
  wire n752_o;
  wire [7:0] n753_o;
  wire n755_o;
  wire n756_o;
  wire n757_o;
  wire cpu6502_r_w_n;
  wire cpu6502_sync;
  wire cpu6502_ef;
  wire cpu6502_mf;
  wire cpu6502_xf;
  wire cpu6502_ml_n;
  wire cpu6502_vp_n;
  wire cpu6502_vda;
  wire cpu6502_vpa;
  wire [23:0] cpu6502_a;
  wire [7:0] cpu6502_do;
  wire [63:0] cpu6502_regs;
  wire [7:0] cpu6502_debug_i;
  wire [7:0] cpu6502_debug_a;
  wire [7:0] cpu6502_debug_x;
  wire [7:0] cpu6502_debug_y;
  wire [7:0] cpu6502_debug_s;
  wire [7:0] cpu6502_debug_p;
  wire cpu6502_nmi_ack;
  localparam [1:0] n763_o = 2'b01;
  localparam n764_o = 1'b1;
  wire n765_o;
  wire n766_o;
  wire n767_o;
  localparam n768_o = 1'b1;
  localparam n769_o = 1'b1;
  localparam n770_o = 1'b1;
  reg n775_q;
  reg [7:0] n777_q;
  wire n778_o;
  reg n779_q;
  wire n780_o;
  reg n781_q;
  wire n782_o;
  reg n783_q;
  wire n784_o;
  reg n785_q;
  wire n786_o;
  reg n787_q;
  reg n788_q;
  wire n789_o;
  reg n790_q;
  wire n791_o;
  reg n792_q;
  wire n793_o;
  reg n794_q;
  wire n795_o;
  wire n796_o;
  reg n797_q;
  wire n801_o;
  reg n802_q;
  wire [7:0] n803_o;
  reg [7:0] n804_q;
  wire [15:0] n805_o;
  reg [15:0] n806_q;
  wire n807_o;
  reg n808_q;
  wire n809_o;
  reg n810_q;
  wire n811_o;
  reg n812_q;
  wire n813_o;
  reg n814_q;
  wire n817_o;
  wire n818_o;
  reg n819_q;
  wire n820_o;
  wire n821_o;
  wire n822_o;
  wire n823_o;
  wire n824_o;
  wire n825_o;
  wire n826_o;
  wire n827_o;
  wire n828_o;
  wire n829_o;
  wire n830_o;
  wire n831_o;
  wire n832_o;
  wire n833_o;
  wire n834_o;
  wire n835_o;
  wire n836_o;
  wire n837_o;
  wire n838_o;
  wire n839_o;
  wire n840_o;
  wire n841_o;
  wire n842_o;
  wire n843_o;
  wire n844_o;
  wire n845_o;
  wire n846_o;
  wire n847_o;
  wire n848_o;
  wire n849_o;
  wire n850_o;
  wire n851_o;
  wire n852_o;
  wire n853_o;
  wire [7:0] n854_o;
  wire n855_o;
  wire n856_o;
  wire n857_o;
  wire n858_o;
  wire n859_o;
  wire n860_o;
  wire n861_o;
  wire n862_o;
  wire n863_o;
  wire n864_o;
  wire n865_o;
  wire n866_o;
  wire n867_o;
  wire n868_o;
  wire n869_o;
  wire n870_o;
  wire n871_o;
  wire n872_o;
  wire n873_o;
  wire n874_o;
  wire n875_o;
  wire n876_o;
  wire n877_o;
  wire n878_o;
  wire n879_o;
  wire n880_o;
  wire n881_o;
  wire n882_o;
  wire n883_o;
  wire n884_o;
  wire n885_o;
  wire n886_o;
  wire n887_o;
  wire n888_o;
  wire [7:0] n889_o;
  wire n890_o;
  wire n891_o;
  wire n892_o;
  wire n893_o;
  wire n894_o;
  wire n895_o;
  wire n896_o;
  wire n897_o;
  wire n898_o;
  wire n899_o;
  wire n900_o;
  wire n901_o;
  wire n902_o;
  wire n903_o;
  wire n904_o;
  wire n905_o;
  wire n906_o;
  wire n907_o;
  wire n908_o;
  wire n909_o;
  wire n910_o;
  wire n911_o;
  wire n912_o;
  wire n913_o;
  wire n914_o;
  wire n915_o;
  wire n916_o;
  wire n917_o;
  wire n918_o;
  wire n919_o;
  wire n920_o;
  wire n921_o;
  wire n922_o;
  wire n923_o;
  wire [7:0] n924_o;
  wire n925_o;
  wire n926_o;
  wire n927_o;
  wire n928_o;
  wire n929_o;
  wire n930_o;
  wire n931_o;
  wire n932_o;
  wire [1:0] n933_o;
  reg n934_o;
  wire [1:0] n935_o;
  reg n936_o;
  wire n937_o;
  wire n938_o;
  wire n939_o;
  wire n940_o;
  wire n941_o;
  wire n942_o;
  wire n943_o;
  wire n944_o;
  wire n945_o;
  wire n946_o;
  wire n947_o;
  wire n948_o;
  wire n949_o;
  wire n950_o;
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
  wire n969_o;
  wire n970_o;
  wire n971_o;
  wire n972_o;
  wire n973_o;
  wire n974_o;
  wire n975_o;
  wire n976_o;
  wire n977_o;
  wire n978_o;
  wire n979_o;
  wire n980_o;
  wire [7:0] n981_o;
  assign clk_2m = q3;
  assign phase_zero = timing_phi0;
  assign phase_zero_r = timing_phi0_en_r;
  assign phase_zero_f = timing_phi0_en_f;
  assign addr = a;
  assign ram_addr = n109_o;
  assign d = d_out;
  assign aux = n463_o;
  assign cpu_we = we;
  assign ram_we = n116_o;
  assign video = video_display_video;
  assign color_line = timing_gr1;
  assign text_mode = n484_o;
  assign hbl = timing_hblank;
  assign vbl = timing_vblank;
  assign read_key = n819_q;
  assign an = n488_o;
  assign pdl_strobe = n379_o;
  assign stb = n382_o;
  assign io_select = ioselect;
  assign device_select = devselect;
  assign io_strobe = n385_o;
  assign rom_a = rom_addr;
  assign vrom_a = video_display_vrom_a;
  assign speaker = speaker_sig;
  /* ./apple2.vhd:71:10  */
  assign clk_7m = timing_vid7m; // (signal)
  /* ./apple2.vhd:72:10  */
  assign q3 = timing_q3; // (signal)
  /* ./apple2.vhd:72:14  */
  assign ras_n = timing_ras_n; // (signal)
  /* ./apple2.vhd:72:21  */
  assign cas_n = timing_cas_n; // (signal)
  /* ./apple2.vhd:72:28  */
  assign ax = timing_ax; // (signal)
  /* ./apple2.vhd:74:10  */
  assign cpu_en = n757_o; // (signal)
  /* ./apple2.vhd:75:10  */
  assign phase_zero_d = n775_q; // (signal)
  /* ./apple2.vhd:78:10  */
  assign video_address = timing_video_address; // (signal)
  /* ./apple2.vhd:79:10  */
  assign ldps_n = timing_ldps_n; // (signal)
  /* ./apple2.vhd:80:10  */
  assign wndw_n = timing_wndw_n; // (signal)
  /* ./apple2.vhd:80:18  */
  assign gr2 = timing_gr2; // (signal)
  /* ./apple2.vhd:81:10  */
  assign sega = timing_sega; // (signal)
  /* ./apple2.vhd:81:16  */
  assign segb = timing_segb; // (signal)
  /* ./apple2.vhd:81:22  */
  assign segc = timing_segc; // (signal)
  /* ./apple2.vhd:84:10  */
  always @*
    soft_switches = n777_q; // (isignal)
  initial
    soft_switches = 8'b00000000;
  /* ./apple2.vhd:85:10  */
  assign mixed_mode = n485_o; // (signal)
  /* ./apple2.vhd:86:10  */
  assign page2 = n486_o; // (signal)
  /* ./apple2.vhd:87:10  */
  assign hires_mode = n487_o; // (signal)
  /* ./apple2.vhd:88:10  */
  assign dhires_mode = n489_o; // (signal)
  /* ./apple2.vhd:91:10  */
  assign ramrd = n779_q; // (signal)
  /* ./apple2.vhd:92:10  */
  assign ramwrt = n781_q; // (signal)
  /* ./apple2.vhd:93:10  */
  assign cxrom = n783_q; // (signal)
  /* ./apple2.vhd:94:10  */
  assign store80 = n785_q; // (signal)
  /* ./apple2.vhd:95:10  */
  assign c3rom = n787_q; // (signal)
  /* ./apple2.vhd:96:10  */
  assign c8rom = n788_q; // (signal)
  /* ./apple2.vhd:97:10  */
  assign altzp = n790_q; // (signal)
  /* ./apple2.vhd:98:10  */
  assign altchar = n792_q; // (signal)
  /* ./apple2.vhd:99:10  */
  assign col80 = n794_q; // (signal)
  /* ./apple2.vhd:100:10  */
  assign sf_d = n797_q; // (signal)
  /* ./apple2.vhd:103:10  */
  assign d_in = n705_o; // (signal)
  /* ./apple2.vhd:104:10  */
  assign d_out = t65_do; // (signal)
  /* ./apple2.vhd:105:10  */
  assign a = n751_o; // (signal)
  /* ./apple2.vhd:106:10  */
  assign t65_a = cpu6502_a; // (signal)
  /* ./apple2.vhd:107:10  */
  assign t65_di = n753_o; // (signal)
  /* ./apple2.vhd:108:10  */
  assign t65_do = cpu6502_do; // (signal)
  /* ./apple2.vhd:109:10  */
  assign t65_we_n = cpu6502_r_w_n; // (signal)
  /* ./apple2.vhd:113:10  */
  assign we = n750_o; // (signal)
  /* ./apple2.vhd:116:10  */
  assign rom_out = rom_d; // (signal)
  /* ./apple2.vhd:117:10  */
  assign rom_addr = n147_o; // (signal)
  /* ./apple2.vhd:120:10  */
  always @*
    ram_select = n389_o; // (isignal)
  initial
    ram_select = 1'b1;
  /* ./apple2.vhd:121:10  */
  always @*
    keyboard_select = n392_o; // (isignal)
  initial
    keyboard_select = 1'b0;
  /* ./apple2.vhd:122:10  */
  assign tape_out = n395_o; // (signal)
  /* ./apple2.vhd:123:10  */
  assign speaker_select = n398_o; // (signal)
  /* ./apple2.vhd:124:10  */
  assign softswitch_select = n401_o; // (signal)
  /* ./apple2.vhd:125:10  */
  assign rom_select = n404_o; // (signal)
  /* ./apple2.vhd:126:10  */
  assign gameport_select = n407_o; // (signal)
  /* ./apple2.vhd:128:10  */
  assign hram_control = n410_o; // (signal)
  /* ./apple2.vhd:129:10  */
  assign c01x_select = n413_o; // (signal)
  /* ./apple2.vhd:132:10  */
  always @*
    speaker_sig = n802_q; // (isignal)
  initial
    speaker_sig = 1'b0;
  /* ./apple2.vhd:134:10  */
  assign cpu_dl = n804_q; // (signal)
  /* ./apple2.vhd:134:18  */
  assign video_dl = n145_o; // (signal)
  /* ./apple2.vhd:135:10  */
  assign video_dl_latch = n806_q; // (signal)
  /* ./apple2.vhd:138:10  */
  assign dxxx = n532_o; // (signal)
  /* ./apple2.vhd:139:10  */
  assign hram_read = n808_q; // (signal)
  /* ./apple2.vhd:140:10  */
  assign hram_pre_wr = n810_q; // (signal)
  /* ./apple2.vhd:141:10  */
  assign hram_wr_n = n812_q; // (signal)
  /* ./apple2.vhd:142:10  */
  assign hram_bank1 = n814_q; // (signal)
  /* ./apple2.vhd:143:10  */
  assign cpu_ram_addr = n534_o; // (signal)
  /* ./apple2.vhd:145:10  */
  assign hram_read_en = n552_o; // (signal)
  /* ./apple2.vhd:146:10  */
  assign hram_write_en = n561_o; // (signal)
  /* ./apple2.vhd:148:10  */
  assign ioselect = n416_o; // (signal)
  /* ./apple2.vhd:149:10  */
  assign devselect = n419_o; // (signal)
  /* ./apple2.vhd:154:10  */
  assign card_addr = 18'b000000000000000000; // (signal)
  /* ./apple2.vhd:155:10  */
  assign card_ram_rd = 1'b0; // (signal)
  /* ./apple2.vhd:156:10  */
  assign card_ram_we = 1'b0; // (signal)
  /* ./apple2.vhd:157:10  */
  assign ram_card_read = n121_o; // (signal)
  /* ./apple2.vhd:158:10  */
  assign ram_card_write = n122_o; // (signal)
  /* ./apple2.vhd:159:10  */
  assign ram_card_sel = n123_o; // (signal)
  /* ./apple2.vhd:167:28  */
  assign n109_o = timing_phi0 ? cpu_ram_addr : n111_o;
  /* ./apple2.vhd:167:60  */
  assign n111_o = {2'b00, video_address};
  /* ./apple2.vhd:168:18  */
  assign n112_o = we & ram_select;
  /* ./apple2.vhd:168:60  */
  assign n113_o = hram_write_en | ram_card_write;
  /* ./apple2.vhd:168:41  */
  assign n114_o = we & n113_o;
  /* ./apple2.vhd:168:34  */
  assign n115_o = n112_o | n114_o;
  /* ./apple2.vhd:168:81  */
  assign n116_o = timing_phi0 ? n115_o : 1'b0;
  /* ./apple2.vhd:176:34  */
  assign n121_o = rom_select & card_ram_rd;
  /* ./apple2.vhd:177:34  */
  assign n122_o = rom_select & card_ram_we;
  /* ./apple2.vhd:178:44  */
  assign n123_o = we ? ram_card_write : ram_card_read;
  /* ./apple2.vhd:183:29  */
  assign n126_o = ~cas_n;
  /* ./apple2.vhd:183:19  */
  assign n127_o = n126_o & ax;
  /* ./apple2.vhd:183:35  */
  assign n128_o = ras_n & n127_o;
  /* ./apple2.vhd:183:58  */
  assign n129_o = ~q3;
  /* ./apple2.vhd:183:51  */
  assign n130_o = n129_o & n128_o;
  /* ./apple2.vhd:185:23  */
  assign n131_o = ~timing_phi0;
  /* ./apple2.vhd:187:19  */
  assign n132_o = ~n463_o;
  /* ./apple2.vhd:188:29  */
  assign n133_o = ram_do[7:0];
  /* ./apple2.vhd:190:29  */
  assign n134_o = ram_do[15:8];
  /* ./apple2.vhd:187:9  */
  assign n135_o = n132_o ? n133_o : n134_o;
  /* ./apple2.vhd:185:9  */
  assign n136_o = n131_o ? cpu_dl : n135_o;
  /* ./apple2.vhd:183:7  */
  assign n139_o = n131_o & n130_o;
  /* ./apple2.vhd:195:29  */
  assign n143_o = video_dl_latch[7:0];
  /* ./apple2.vhd:195:58  */
  assign n144_o = ~timing_phi0;
  /* ./apple2.vhd:195:42  */
  assign n145_o = n144_o ? n143_o : n146_o;
  /* ./apple2.vhd:195:83  */
  assign n146_o = video_dl_latch[15:8];
  /* ./apple2.vhd:205:16  */
  assign n147_o = a[13:0];
  /* ./apple2.vhd:223:11  */
  assign n149_o = a[15:14];
  /* ./apple2.vhd:224:7  */
  assign n151_o = n149_o == 2'b00;
  /* ./apple2.vhd:224:17  */
  assign n153_o = n149_o == 2'b01;
  /* ./apple2.vhd:224:17  */
  assign n154_o = n151_o | n153_o;
  /* ./apple2.vhd:224:24  */
  assign n156_o = n149_o == 2'b10;
  /* ./apple2.vhd:224:24  */
  assign n157_o = n154_o | n156_o;
  /* ./apple2.vhd:227:15  */
  assign n158_o = a[13:12];
  /* ./apple2.vhd:229:19  */
  assign n159_o = a[11:8];
  /* ./apple2.vhd:231:23  */
  assign n160_o = a[7:4];
  /* ./apple2.vhd:232:19  */
  assign n162_o = n160_o == 4'b0000;
  /* ./apple2.vhd:234:19  */
  assign n164_o = n160_o == 4'b0001;
  /* ./apple2.vhd:236:19  */
  assign n166_o = n160_o == 4'b0010;
  /* ./apple2.vhd:238:19  */
  assign n168_o = n160_o == 4'b0011;
  /* ./apple2.vhd:240:19  */
  assign n170_o = n160_o == 4'b0100;
  /* ./apple2.vhd:242:19  */
  assign n172_o = n160_o == 4'b0101;
  /* ./apple2.vhd:244:19  */
  assign n174_o = n160_o == 4'b0110;
  /* ./apple2.vhd:246:19  */
  assign n176_o = n160_o == 4'b0111;
  /* ./apple2.vhd:248:19  */
  assign n178_o = n160_o == 4'b1000;
  /* ./apple2.vhd:252:43  */
  assign n179_o = a[6:4];
  /* ./apple2.vhd:250:19  */
  assign n186_o = n160_o == 4'b1001;
  /* ./apple2.vhd:250:29  */
  assign n188_o = n160_o == 4'b1010;
  /* ./apple2.vhd:250:29  */
  assign n189_o = n186_o | n188_o;
  /* ./apple2.vhd:250:36  */
  assign n191_o = n160_o == 4'b1011;
  /* ./apple2.vhd:250:36  */
  assign n192_o = n189_o | n191_o;
  /* ./apple2.vhd:250:43  */
  assign n194_o = n160_o == 4'b1100;
  /* ./apple2.vhd:250:43  */
  assign n195_o = n192_o | n194_o;
  /* ./apple2.vhd:251:29  */
  assign n197_o = n160_o == 4'b1101;
  /* ./apple2.vhd:251:29  */
  assign n198_o = n195_o | n197_o;
  /* ./apple2.vhd:251:36  */
  assign n200_o = n160_o == 4'b1110;
  /* ./apple2.vhd:251:36  */
  assign n201_o = n198_o | n200_o;
  /* ./apple2.vhd:251:43  */
  assign n203_o = n160_o == 4'b1111;
  /* ./apple2.vhd:251:43  */
  assign n204_o = n201_o | n203_o;
  assign n205_o = {n204_o, n178_o, n176_o, n174_o, n172_o, n170_o, n168_o, n166_o, n164_o, n162_o};
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n208_o = 1'b0;
      10'b0100000000: n208_o = 1'b0;
      10'b0010000000: n208_o = 1'b1;
      10'b0001000000: n208_o = 1'b0;
      10'b0000100000: n208_o = 1'b0;
      10'b0000010000: n208_o = 1'b0;
      10'b0000001000: n208_o = 1'b0;
      10'b0000000100: n208_o = 1'b0;
      10'b0000000010: n208_o = 1'b0;
      10'b0000000001: n208_o = 1'b0;
      default: n208_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n211_o = 1'b0;
      10'b0100000000: n211_o = 1'b0;
      10'b0010000000: n211_o = 1'b0;
      10'b0001000000: n211_o = 1'b0;
      10'b0000100000: n211_o = 1'b0;
      10'b0000010000: n211_o = 1'b1;
      10'b0000001000: n211_o = 1'b0;
      10'b0000000100: n211_o = 1'b0;
      10'b0000000010: n211_o = 1'b0;
      10'b0000000001: n211_o = 1'b0;
      default: n211_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n214_o = 1'b0;
      10'b0100000000: n214_o = 1'b0;
      10'b0010000000: n214_o = 1'b0;
      10'b0001000000: n214_o = 1'b0;
      10'b0000100000: n214_o = 1'b0;
      10'b0000010000: n214_o = 1'b0;
      10'b0000001000: n214_o = 1'b0;
      10'b0000000100: n214_o = 1'b0;
      10'b0000000010: n214_o = 1'b0;
      10'b0000000001: n214_o = 1'b1;
      default: n214_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n217_o = 1'b0;
      10'b0100000000: n217_o = 1'b0;
      10'b0010000000: n217_o = 1'b0;
      10'b0001000000: n217_o = 1'b0;
      10'b0000100000: n217_o = 1'b0;
      10'b0000010000: n217_o = 1'b0;
      10'b0000001000: n217_o = 1'b0;
      10'b0000000100: n217_o = 1'b1;
      10'b0000000010: n217_o = 1'b0;
      10'b0000000001: n217_o = 1'b0;
      default: n217_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n220_o = 1'b0;
      10'b0100000000: n220_o = 1'b0;
      10'b0010000000: n220_o = 1'b0;
      10'b0001000000: n220_o = 1'b0;
      10'b0000100000: n220_o = 1'b0;
      10'b0000010000: n220_o = 1'b0;
      10'b0000001000: n220_o = 1'b1;
      10'b0000000100: n220_o = 1'b0;
      10'b0000000010: n220_o = 1'b0;
      10'b0000000001: n220_o = 1'b0;
      default: n220_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n223_o = 1'b0;
      10'b0100000000: n223_o = 1'b0;
      10'b0010000000: n223_o = 1'b0;
      10'b0001000000: n223_o = 1'b0;
      10'b0000100000: n223_o = 1'b1;
      10'b0000010000: n223_o = 1'b0;
      10'b0000001000: n223_o = 1'b0;
      10'b0000000100: n223_o = 1'b0;
      10'b0000000010: n223_o = 1'b0;
      10'b0000000001: n223_o = 1'b0;
      default: n223_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n226_o = 1'b0;
      10'b0100000000: n226_o = 1'b0;
      10'b0010000000: n226_o = 1'b0;
      10'b0001000000: n226_o = 1'b1;
      10'b0000100000: n226_o = 1'b0;
      10'b0000010000: n226_o = 1'b0;
      10'b0000001000: n226_o = 1'b0;
      10'b0000000100: n226_o = 1'b0;
      10'b0000000010: n226_o = 1'b0;
      10'b0000000001: n226_o = 1'b0;
      default: n226_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n229_o = 1'b0;
      10'b0100000000: n229_o = 1'b1;
      10'b0010000000: n229_o = 1'b0;
      10'b0001000000: n229_o = 1'b0;
      10'b0000100000: n229_o = 1'b0;
      10'b0000010000: n229_o = 1'b0;
      10'b0000001000: n229_o = 1'b0;
      10'b0000000100: n229_o = 1'b0;
      10'b0000000010: n229_o = 1'b0;
      10'b0000000001: n229_o = 1'b0;
      default: n229_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n232_o = 1'b0;
      10'b0100000000: n232_o = 1'b0;
      10'b0010000000: n232_o = 1'b0;
      10'b0001000000: n232_o = 1'b0;
      10'b0000100000: n232_o = 1'b0;
      10'b0000010000: n232_o = 1'b0;
      10'b0000001000: n232_o = 1'b0;
      10'b0000000100: n232_o = 1'b0;
      10'b0000000010: n232_o = 1'b1;
      10'b0000000001: n232_o = 1'b0;
      default: n232_o = 1'b0;
    endcase
  /* ./apple2.vhd:231:17  */
  always @*
    case (n205_o)
      10'b1000000000: n234_o = n854_o;
      10'b0100000000: n234_o = 8'b00000000;
      10'b0010000000: n234_o = 8'b00000000;
      10'b0001000000: n234_o = 8'b00000000;
      10'b0000100000: n234_o = 8'b00000000;
      10'b0000010000: n234_o = 8'b00000000;
      10'b0000001000: n234_o = 8'b00000000;
      10'b0000000100: n234_o = 8'b00000000;
      10'b0000000010: n234_o = 8'b00000000;
      10'b0000000001: n234_o = 8'b00000000;
      default: n234_o = 8'b00000000;
    endcase
  /* ./apple2.vhd:230:15  */
  assign n236_o = n159_o == 4'b0000;
  /* ./apple2.vhd:260:40  */
  assign n237_o = a[10:8];
  /* ./apple2.vhd:257:17  */
  assign n245_o = cxrom ? 1'b1 : 1'b0;
  /* ./apple2.vhd:257:17  */
  assign n247_o = cxrom ? 8'b00000000 : n889_o;
  /* ./apple2.vhd:255:15  */
  assign n249_o = n159_o == 4'b0001;
  /* ./apple2.vhd:255:25  */
  assign n251_o = n159_o == 4'b0010;
  /* ./apple2.vhd:255:25  */
  assign n252_o = n249_o | n251_o;
  /* ./apple2.vhd:255:32  */
  assign n254_o = n159_o == 4'b0100;
  /* ./apple2.vhd:255:32  */
  assign n255_o = n252_o | n254_o;
  /* ./apple2.vhd:256:25  */
  assign n257_o = n159_o == 4'b0101;
  /* ./apple2.vhd:256:25  */
  assign n258_o = n255_o | n257_o;
  /* ./apple2.vhd:256:32  */
  assign n260_o = n159_o == 4'b0110;
  /* ./apple2.vhd:256:32  */
  assign n261_o = n258_o | n260_o;
  /* ./apple2.vhd:256:39  */
  assign n263_o = n159_o == 4'b0111;
  /* ./apple2.vhd:256:39  */
  assign n264_o = n261_o | n263_o;
  /* ./apple2.vhd:263:41  */
  assign n265_o = ~c3rom;
  /* ./apple2.vhd:263:32  */
  assign n266_o = cxrom | n265_o;
  /* ./apple2.vhd:266:40  */
  assign n267_o = a[10:8];
  /* ./apple2.vhd:263:17  */
  assign n275_o = n266_o ? 1'b1 : 1'b0;
  /* ./apple2.vhd:263:17  */
  assign n277_o = n266_o ? 8'b00000000 : n924_o;
  /* ./apple2.vhd:262:15  */
  assign n279_o = n159_o == 4'b0011;
  /* ./apple2.vhd:270:32  */
  assign n280_o = cxrom | c8rom;
  /* ./apple2.vhd:270:17  */
  assign n283_o = n280_o ? 1'b0 : 1'b1;
  /* ./apple2.vhd:270:17  */
  assign n286_o = n280_o ? 1'b1 : 1'b0;
  /* ./apple2.vhd:268:15  */
  assign n288_o = n159_o == 4'b1000;
  /* ./apple2.vhd:268:25  */
  assign n290_o = n159_o == 4'b1001;
  /* ./apple2.vhd:268:25  */
  assign n291_o = n288_o | n290_o;
  /* ./apple2.vhd:268:32  */
  assign n293_o = n159_o == 4'b1010;
  /* ./apple2.vhd:268:32  */
  assign n294_o = n291_o | n293_o;
  /* ./apple2.vhd:268:39  */
  assign n296_o = n159_o == 4'b1011;
  /* ./apple2.vhd:268:39  */
  assign n297_o = n294_o | n296_o;
  /* ./apple2.vhd:269:25  */
  assign n299_o = n159_o == 4'b1100;
  /* ./apple2.vhd:269:25  */
  assign n300_o = n297_o | n299_o;
  /* ./apple2.vhd:269:32  */
  assign n302_o = n159_o == 4'b1101;
  /* ./apple2.vhd:269:32  */
  assign n303_o = n300_o | n302_o;
  /* ./apple2.vhd:269:39  */
  assign n305_o = n159_o == 4'b1110;
  /* ./apple2.vhd:269:39  */
  assign n306_o = n303_o | n305_o;
  /* ./apple2.vhd:269:46  */
  assign n308_o = n159_o == 4'b1111;
  /* ./apple2.vhd:269:46  */
  assign n309_o = n306_o | n308_o;
  assign n310_o = {n309_o, n279_o, n264_o, n236_o};
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n312_o = 1'b0;
      4'b0100: n312_o = 1'b0;
      4'b0010: n312_o = 1'b0;
      4'b0001: n312_o = n208_o;
      default: n312_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n314_o = 1'b0;
      4'b0100: n314_o = 1'b0;
      4'b0010: n314_o = 1'b0;
      4'b0001: n314_o = n211_o;
      default: n314_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n316_o = n283_o;
      4'b0100: n316_o = 1'b0;
      4'b0010: n316_o = 1'b0;
      4'b0001: n316_o = 1'b0;
      default: n316_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n318_o = 1'b0;
      4'b0100: n318_o = 1'b0;
      4'b0010: n318_o = 1'b0;
      4'b0001: n318_o = n214_o;
      default: n318_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n320_o = 1'b0;
      4'b0100: n320_o = 1'b0;
      4'b0010: n320_o = 1'b0;
      4'b0001: n320_o = n217_o;
      default: n320_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n322_o = 1'b0;
      4'b0100: n322_o = 1'b0;
      4'b0010: n322_o = 1'b0;
      4'b0001: n322_o = n220_o;
      default: n322_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n324_o = 1'b0;
      4'b0100: n324_o = 1'b0;
      4'b0010: n324_o = 1'b0;
      4'b0001: n324_o = n223_o;
      default: n324_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n326_o = n286_o;
      4'b0100: n326_o = n275_o;
      4'b0010: n326_o = n245_o;
      4'b0001: n326_o = 1'b0;
      default: n326_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n328_o = 1'b0;
      4'b0100: n328_o = 1'b0;
      4'b0010: n328_o = 1'b0;
      4'b0001: n328_o = n226_o;
      default: n328_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n330_o = 1'b0;
      4'b0100: n330_o = 1'b0;
      4'b0010: n330_o = 1'b0;
      4'b0001: n330_o = n229_o;
      default: n330_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n332_o = 1'b0;
      4'b0100: n332_o = 1'b0;
      4'b0010: n332_o = 1'b0;
      4'b0001: n332_o = n232_o;
      default: n332_o = 1'b0;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n334_o = 8'b00000000;
      4'b0100: n334_o = n277_o;
      4'b0010: n334_o = n247_o;
      4'b0001: n334_o = 8'b00000000;
      default: n334_o = 8'b00000000;
    endcase
  /* ./apple2.vhd:229:13  */
  always @*
    case (n310_o)
      4'b1000: n336_o = 8'b00000000;
      4'b0100: n336_o = 8'b00000000;
      4'b0010: n336_o = 8'b00000000;
      4'b0001: n336_o = n234_o;
      default: n336_o = 8'b00000000;
    endcase
  /* ./apple2.vhd:228:11  */
  assign n338_o = n158_o == 2'b00;
  /* ./apple2.vhd:277:11  */
  assign n340_o = n158_o == 2'b01;
  /* ./apple2.vhd:277:21  */
  assign n342_o = n158_o == 2'b10;
  /* ./apple2.vhd:277:21  */
  assign n343_o = n340_o | n342_o;
  /* ./apple2.vhd:277:28  */
  assign n345_o = n158_o == 2'b11;
  /* ./apple2.vhd:277:28  */
  assign n346_o = n343_o | n345_o;
  assign n347_o = {n346_o, n338_o};
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n349_o = 1'b0;
      2'b01: n349_o = n312_o;
      default: n349_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n351_o = 1'b0;
      2'b01: n351_o = n314_o;
      default: n351_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n353_o = 1'b0;
      2'b01: n353_o = n316_o;
      default: n353_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n355_o = 1'b0;
      2'b01: n355_o = n318_o;
      default: n355_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n357_o = 1'b0;
      2'b01: n357_o = n320_o;
      default: n357_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n359_o = 1'b0;
      2'b01: n359_o = n322_o;
      default: n359_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n361_o = 1'b0;
      2'b01: n361_o = n324_o;
      default: n361_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n364_o = 1'b1;
      2'b01: n364_o = n326_o;
      default: n364_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n366_o = 1'b0;
      2'b01: n366_o = n328_o;
      default: n366_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n368_o = 1'b0;
      2'b01: n368_o = n330_o;
      default: n368_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n370_o = 1'b0;
      2'b01: n370_o = n332_o;
      default: n370_o = 1'b0;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n372_o = 8'b00000000;
      2'b01: n372_o = n334_o;
      default: n372_o = 8'b00000000;
    endcase
  /* ./apple2.vhd:227:9  */
  always @*
    case (n347_o)
      2'b10: n374_o = 8'b00000000;
      2'b01: n374_o = n336_o;
      default: n374_o = 8'b00000000;
    endcase
  /* ./apple2.vhd:226:7  */
  assign n376_o = n149_o == 2'b11;
  assign n377_o = {n376_o, n157_o};
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n379_o = n349_o;
      2'b01: n379_o = 1'b0;
      default: n379_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n382_o = n351_o;
      2'b01: n382_o = 1'b0;
      default: n382_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n385_o = n353_o;
      2'b01: n385_o = 1'b0;
      default: n385_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n389_o = 1'b0;
      2'b01: n389_o = 1'b1;
      default: n389_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n392_o = n355_o;
      2'b01: n392_o = 1'b0;
      default: n392_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n395_o = n357_o;
      2'b01: n395_o = 1'b0;
      default: n395_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n398_o = n359_o;
      2'b01: n398_o = 1'b0;
      default: n398_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n401_o = n361_o;
      2'b01: n401_o = 1'b0;
      default: n401_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n404_o = n364_o;
      2'b01: n404_o = 1'b0;
      default: n404_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n407_o = n366_o;
      2'b01: n407_o = 1'b0;
      default: n407_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n410_o = n368_o;
      2'b01: n410_o = 1'b0;
      default: n410_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n413_o = n370_o;
      2'b01: n413_o = 1'b0;
      default: n413_o = 1'b0;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n416_o = n372_o;
      2'b01: n416_o = 8'b00000000;
      default: n416_o = 8'b00000000;
    endcase
  /* ./apple2.vhd:223:5  */
  always @*
    case (n377_o)
      2'b10: n419_o = n374_o;
      2'b01: n419_o = 8'b00000000;
      default: n419_o = 8'b00000000;
    endcase
  /* ./apple2.vhd:291:12  */
  assign n423_o = a[15:9];
  /* ./apple2.vhd:291:26  */
  assign n425_o = n423_o == 7'b0000000;
  /* ./apple2.vhd:291:42  */
  assign n426_o = a[15:14];
  /* ./apple2.vhd:291:57  */
  assign n428_o = n426_o == 2'b11;
  /* ./apple2.vhd:291:38  */
  assign n429_o = n425_o | n428_o;
  /* ./apple2.vhd:293:12  */
  assign n430_o = a[15:10];
  /* ./apple2.vhd:293:27  */
  assign n432_o = n430_o == 6'b000001;
  /* ./apple2.vhd:294:25  */
  assign n433_o = store80 & page2;
  /* ./apple2.vhd:294:40  */
  assign n434_o = ~store80;
  /* ./apple2.vhd:294:69  */
  assign n435_o = ~we;
  /* ./apple2.vhd:294:65  */
  assign n436_o = ramrd & n435_o;
  /* ./apple2.vhd:294:90  */
  assign n437_o = ramwrt & we;
  /* ./apple2.vhd:294:78  */
  assign n438_o = n436_o | n437_o;
  /* ./apple2.vhd:294:52  */
  assign n439_o = n434_o & n438_o;
  /* ./apple2.vhd:294:36  */
  assign n440_o = n433_o | n439_o;
  /* ./apple2.vhd:295:12  */
  assign n441_o = a[15:13];
  /* ./apple2.vhd:295:27  */
  assign n443_o = n441_o == 3'b001;
  /* ./apple2.vhd:296:25  */
  assign n444_o = store80 & page2;
  /* ./apple2.vhd:296:35  */
  assign n445_o = n444_o & hires_mode;
  /* ./apple2.vhd:296:56  */
  assign n446_o = ~store80;
  /* ./apple2.vhd:296:71  */
  assign n447_o = ~hires_mode;
  /* ./apple2.vhd:296:68  */
  assign n448_o = n446_o | n447_o;
  /* ./apple2.vhd:296:104  */
  assign n449_o = ~we;
  /* ./apple2.vhd:296:100  */
  assign n450_o = ramrd & n449_o;
  /* ./apple2.vhd:296:125  */
  assign n451_o = ramwrt & we;
  /* ./apple2.vhd:296:113  */
  assign n452_o = n450_o | n451_o;
  /* ./apple2.vhd:296:87  */
  assign n453_o = n448_o & n452_o;
  /* ./apple2.vhd:296:51  */
  assign n454_o = n445_o | n453_o;
  /* ./apple2.vhd:298:28  */
  assign n455_o = ~we;
  /* ./apple2.vhd:298:24  */
  assign n456_o = ramrd & n455_o;
  /* ./apple2.vhd:298:49  */
  assign n457_o = ramwrt & we;
  /* ./apple2.vhd:298:37  */
  assign n458_o = n456_o | n457_o;
  /* ./apple2.vhd:295:5  */
  assign n459_o = n443_o ? n454_o : n458_o;
  /* ./apple2.vhd:293:5  */
  assign n460_o = n432_o ? n440_o : n459_o;
  /* ./apple2.vhd:291:5  */
  assign n461_o = n429_o ? altzp : n460_o;
  /* ./apple2.vhd:289:10  */
  assign n463_o = ram_card_sel ? 1'b0 : n461_o;
  /* ./apple2.vhd:305:29  */
  assign n468_o = speaker_select & timing_phi0_en_r;
  /* ./apple2.vhd:306:24  */
  assign n469_o = ~speaker_sig;
  /* ./apple2.vhd:314:29  */
  assign n475_o = softswitch_select & timing_phi0_en_r;
  /* ./apple2.vhd:315:35  */
  assign n476_o = a[3:1];
  /* ./apple2.vhd:315:54  */
  assign n479_o = a[0];
  /* ./apple2.vhd:320:29  */
  assign n484_o = soft_switches[0];
  /* ./apple2.vhd:321:30  */
  assign n485_o = soft_switches[1];
  /* ./apple2.vhd:322:25  */
  assign n486_o = soft_switches[2];
  /* ./apple2.vhd:323:30  */
  assign n487_o = soft_switches[3];
  /* ./apple2.vhd:324:22  */
  assign n488_o = soft_switches[7:4];
  /* ./apple2.vhd:325:20  */
  assign n489_o = n488_o[3];
  /* ./apple2.vhd:335:29  */
  assign n492_o = hram_control & timing_phi0_en_r;
  /* ./apple2.vhd:336:24  */
  assign n493_o = a[3];
  /* ./apple2.vhd:337:25  */
  assign n494_o = a[0];
  /* ./apple2.vhd:337:33  */
  assign n495_o = ~we;
  /* ./apple2.vhd:337:29  */
  assign n496_o = n494_o & n495_o;
  /* ./apple2.vhd:338:29  */
  assign n497_o = ~we;
  /* ./apple2.vhd:338:25  */
  assign n498_o = hram_pre_wr & n497_o;
  /* ./apple2.vhd:338:41  */
  assign n499_o = a[0];
  /* ./apple2.vhd:338:36  */
  assign n500_o = n498_o & n499_o;
  /* ./apple2.vhd:340:16  */
  assign n501_o = a[0];
  /* ./apple2.vhd:340:20  */
  assign n502_o = ~n501_o;
  /* ./apple2.vhd:340:9  */
  assign n504_o = n502_o ? 1'b1 : hram_wr_n;
  /* ./apple2.vhd:338:9  */
  assign n506_o = n500_o ? 1'b0 : n504_o;
  /* ./apple2.vhd:343:28  */
  assign n507_o = a[0];
  /* ./apple2.vhd:343:37  */
  assign n508_o = a[1];
  /* ./apple2.vhd:343:32  */
  assign n509_o = n507_o ^ n508_o;
  /* ./apple2.vhd:343:22  */
  assign n510_o = ~n509_o;
  /* ./apple2.vhd:348:21  */
  assign n529_o = a[15:12];
  /* ./apple2.vhd:348:36  */
  assign n531_o = n529_o == 4'b1101;
  /* ./apple2.vhd:348:15  */
  assign n532_o = n531_o ? 1'b1 : 1'b0;
  /* ./apple2.vhd:349:29  */
  assign n534_o = ram_card_sel ? card_addr : n544_o;
  /* ./apple2.vhd:349:66  */
  assign n535_o = a[15:13];
  /* ./apple2.vhd:349:63  */
  assign n537_o = {2'b00, n535_o};
  /* ./apple2.vhd:349:85  */
  assign n538_o = a[12];
  /* ./apple2.vhd:349:110  */
  assign n539_o = hram_bank1 & dxxx;
  /* ./apple2.vhd:349:94  */
  assign n540_o = ~n539_o;
  /* ./apple2.vhd:349:90  */
  assign n541_o = n538_o & n540_o;
  /* ./apple2.vhd:349:81  */
  assign n542_o = {n537_o, n541_o};
  /* ./apple2.vhd:349:124  */
  assign n543_o = a[11:0];
  /* ./apple2.vhd:349:121  */
  assign n544_o = {n542_o, n543_o};
  /* ./apple2.vhd:350:34  */
  assign n545_o = a[15];
  /* ./apple2.vhd:350:29  */
  assign n546_o = hram_read & n545_o;
  /* ./apple2.vhd:350:44  */
  assign n547_o = a[14];
  /* ./apple2.vhd:350:39  */
  assign n548_o = n546_o & n547_o;
  /* ./apple2.vhd:350:55  */
  assign n549_o = a[13];
  /* ./apple2.vhd:350:64  */
  assign n550_o = a[12];
  /* ./apple2.vhd:350:60  */
  assign n551_o = n549_o | n550_o;
  /* ./apple2.vhd:350:49  */
  assign n552_o = n548_o & n551_o;
  /* ./apple2.vhd:351:20  */
  assign n553_o = ~hram_wr_n;
  /* ./apple2.vhd:351:39  */
  assign n554_o = a[15];
  /* ./apple2.vhd:351:34  */
  assign n555_o = n553_o & n554_o;
  /* ./apple2.vhd:351:49  */
  assign n556_o = a[14];
  /* ./apple2.vhd:351:44  */
  assign n557_o = n555_o & n556_o;
  /* ./apple2.vhd:351:60  */
  assign n558_o = a[13];
  /* ./apple2.vhd:351:69  */
  assign n559_o = a[12];
  /* ./apple2.vhd:351:65  */
  assign n560_o = n558_o | n559_o;
  /* ./apple2.vhd:351:54  */
  assign n561_o = n557_o & n560_o;
  /* ./apple2.vhd:367:11  */
  assign n564_o = a[15:8];
  /* ./apple2.vhd:367:25  */
  assign n566_o = n564_o == 8'b11000011;
  /* ./apple2.vhd:367:43  */
  assign n567_o = ~c3rom;
  /* ./apple2.vhd:367:33  */
  assign n568_o = n567_o & n566_o;
  /* ./apple2.vhd:369:15  */
  assign n570_o = a == 16'b1100111111111111;
  /* ./apple2.vhd:369:7  */
  assign n572_o = n570_o ? 1'b0 : c8rom;
  /* ./apple2.vhd:367:7  */
  assign n574_o = n568_o ? 1'b1 : n572_o;
  /* ./apple2.vhd:372:29  */
  assign n575_o = keyboard_select & timing_phi0_en_r;
  /* ./apple2.vhd:372:55  */
  assign n576_o = we & n575_o;
  /* ./apple2.vhd:373:15  */
  assign n577_o = a[3:1];
  /* ./apple2.vhd:374:35  */
  assign n578_o = a[0];
  /* ./apple2.vhd:374:9  */
  assign n580_o = n577_o == 3'b000;
  /* ./apple2.vhd:375:33  */
  assign n581_o = a[0];
  /* ./apple2.vhd:375:9  */
  assign n583_o = n577_o == 3'b001;
  /* ./apple2.vhd:376:34  */
  assign n584_o = a[0];
  /* ./apple2.vhd:376:9  */
  assign n586_o = n577_o == 3'b010;
  /* ./apple2.vhd:377:33  */
  assign n587_o = a[0];
  /* ./apple2.vhd:377:9  */
  assign n589_o = n577_o == 3'b011;
  /* ./apple2.vhd:378:33  */
  assign n590_o = a[0];
  /* ./apple2.vhd:378:9  */
  assign n592_o = n577_o == 3'b100;
  /* ./apple2.vhd:379:33  */
  assign n593_o = a[0];
  /* ./apple2.vhd:379:9  */
  assign n595_o = n577_o == 3'b101;
  /* ./apple2.vhd:380:33  */
  assign n596_o = a[0];
  /* ./apple2.vhd:380:9  */
  assign n598_o = n577_o == 3'b110;
  /* ./apple2.vhd:381:35  */
  assign n599_o = a[0];
  /* ./apple2.vhd:381:9  */
  assign n601_o = n577_o == 3'b111;
  assign n602_o = {n601_o, n598_o, n595_o, n592_o, n589_o, n586_o, n583_o, n580_o};
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n603_o = ramrd;
      8'b01000000: n603_o = ramrd;
      8'b00100000: n603_o = ramrd;
      8'b00010000: n603_o = ramrd;
      8'b00001000: n603_o = ramrd;
      8'b00000100: n603_o = ramrd;
      8'b00000010: n603_o = n581_o;
      8'b00000001: n603_o = ramrd;
      default: n603_o = ramrd;
    endcase
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n604_o = ramwrt;
      8'b01000000: n604_o = ramwrt;
      8'b00100000: n604_o = ramwrt;
      8'b00010000: n604_o = ramwrt;
      8'b00001000: n604_o = ramwrt;
      8'b00000100: n604_o = n584_o;
      8'b00000010: n604_o = ramwrt;
      8'b00000001: n604_o = ramwrt;
      default: n604_o = ramwrt;
    endcase
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n605_o = cxrom;
      8'b01000000: n605_o = cxrom;
      8'b00100000: n605_o = cxrom;
      8'b00010000: n605_o = cxrom;
      8'b00001000: n605_o = n587_o;
      8'b00000100: n605_o = cxrom;
      8'b00000010: n605_o = cxrom;
      8'b00000001: n605_o = cxrom;
      default: n605_o = cxrom;
    endcase
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n606_o = store80;
      8'b01000000: n606_o = store80;
      8'b00100000: n606_o = store80;
      8'b00010000: n606_o = store80;
      8'b00001000: n606_o = store80;
      8'b00000100: n606_o = store80;
      8'b00000010: n606_o = store80;
      8'b00000001: n606_o = n578_o;
      default: n606_o = store80;
    endcase
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n607_o = c3rom;
      8'b01000000: n607_o = c3rom;
      8'b00100000: n607_o = n593_o;
      8'b00010000: n607_o = c3rom;
      8'b00001000: n607_o = c3rom;
      8'b00000100: n607_o = c3rom;
      8'b00000010: n607_o = c3rom;
      8'b00000001: n607_o = c3rom;
      default: n607_o = c3rom;
    endcase
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n608_o = altzp;
      8'b01000000: n608_o = altzp;
      8'b00100000: n608_o = altzp;
      8'b00010000: n608_o = n590_o;
      8'b00001000: n608_o = altzp;
      8'b00000100: n608_o = altzp;
      8'b00000010: n608_o = altzp;
      8'b00000001: n608_o = altzp;
      default: n608_o = altzp;
    endcase
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n609_o = n599_o;
      8'b01000000: n609_o = altchar;
      8'b00100000: n609_o = altchar;
      8'b00010000: n609_o = altchar;
      8'b00001000: n609_o = altchar;
      8'b00000100: n609_o = altchar;
      8'b00000010: n609_o = altchar;
      8'b00000001: n609_o = altchar;
      default: n609_o = altchar;
    endcase
  /* ./apple2.vhd:373:9  */
  always @*
    case (n602_o)
      8'b10000000: n610_o = col80;
      8'b01000000: n610_o = n596_o;
      8'b00100000: n610_o = col80;
      8'b00010000: n610_o = col80;
      8'b00001000: n610_o = col80;
      8'b00000100: n610_o = col80;
      8'b00000010: n610_o = col80;
      8'b00000001: n610_o = col80;
      default: n610_o = col80;
    endcase
  /* ./apple2.vhd:384:38  */
  assign n611_o = ~we;
  /* ./apple2.vhd:384:31  */
  assign n612_o = n611_o & c01x_select;
  /* ./apple2.vhd:385:15  */
  assign n613_o = a[3:0];
  /* ./apple2.vhd:386:9  */
  assign n615_o = n613_o == 4'b0000;
  /* ./apple2.vhd:389:30  */
  assign n616_o = ~hram_bank1;
  /* ./apple2.vhd:389:9  */
  assign n618_o = n613_o == 4'b0001;
  /* ./apple2.vhd:390:9  */
  assign n620_o = n613_o == 4'b0010;
  /* ./apple2.vhd:391:9  */
  assign n622_o = n613_o == 4'b0011;
  /* ./apple2.vhd:392:9  */
  assign n624_o = n613_o == 4'b0100;
  /* ./apple2.vhd:393:9  */
  assign n626_o = n613_o == 4'b0101;
  /* ./apple2.vhd:394:9  */
  assign n628_o = n613_o == 4'b0110;
  /* ./apple2.vhd:395:9  */
  assign n630_o = n613_o == 4'b0111;
  /* ./apple2.vhd:396:9  */
  assign n632_o = n613_o == 4'b1000;
  /* ./apple2.vhd:397:30  */
  assign n633_o = ~timing_vblank;
  /* ./apple2.vhd:397:9  */
  assign n635_o = n613_o == 4'b1001;
  /* ./apple2.vhd:398:9  */
  assign n637_o = n613_o == 4'b1010;
  /* ./apple2.vhd:399:9  */
  assign n639_o = n613_o == 4'b1011;
  /* ./apple2.vhd:400:9  */
  assign n641_o = n613_o == 4'b1100;
  /* ./apple2.vhd:401:9  */
  assign n643_o = n613_o == 4'b1101;
  /* ./apple2.vhd:402:9  */
  assign n645_o = n613_o == 4'b1110;
  /* ./apple2.vhd:403:9  */
  assign n647_o = n613_o == 4'b1111;
  assign n648_o = {n647_o, n645_o, n643_o, n641_o, n639_o, n637_o, n635_o, n632_o, n630_o, n628_o, n626_o, n624_o, n622_o, n620_o, n618_o, n615_o};
  /* ./apple2.vhd:385:9  */
  always @*
    case (n648_o)
      16'b1000000000000000: n651_o = 1'b0;
      16'b0100000000000000: n651_o = 1'b0;
      16'b0010000000000000: n651_o = 1'b0;
      16'b0001000000000000: n651_o = 1'b0;
      16'b0000100000000000: n651_o = 1'b0;
      16'b0000010000000000: n651_o = 1'b0;
      16'b0000001000000000: n651_o = 1'b0;
      16'b0000000100000000: n651_o = 1'b0;
      16'b0000000010000000: n651_o = 1'b0;
      16'b0000000001000000: n651_o = 1'b0;
      16'b0000000000100000: n651_o = 1'b0;
      16'b0000000000010000: n651_o = 1'b0;
      16'b0000000000001000: n651_o = 1'b0;
      16'b0000000000000100: n651_o = 1'b0;
      16'b0000000000000010: n651_o = 1'b0;
      16'b0000000000000001: n651_o = 1'b1;
      default: n651_o = 1'b0;
    endcase
  /* ./apple2.vhd:385:9  */
  always @*
    case (n648_o)
      16'b1000000000000000: n652_o = col80;
      16'b0100000000000000: n652_o = altchar;
      16'b0010000000000000: n652_o = hires_mode;
      16'b0001000000000000: n652_o = page2;
      16'b0000100000000000: n652_o = mixed_mode;
      16'b0000010000000000: n652_o = n484_o;
      16'b0000001000000000: n652_o = n633_o;
      16'b0000000100000000: n652_o = store80;
      16'b0000000010000000: n652_o = c3rom;
      16'b0000000001000000: n652_o = altzp;
      16'b0000000000100000: n652_o = cxrom;
      16'b0000000000010000: n652_o = ramwrt;
      16'b0000000000001000: n652_o = ramrd;
      16'b0000000000000100: n652_o = hram_read;
      16'b0000000000000010: n652_o = n616_o;
      16'b0000000000000001: n652_o = akd;
      default: n652_o = sf_d;
    endcase
  /* ./apple2.vhd:406:31  */
  assign n653_o = we & c01x_select;
  /* ./apple2.vhd:406:7  */
  assign n656_o = n653_o ? 1'b1 : 1'b0;
  /* ./apple2.vhd:384:7  */
  assign n657_o = n612_o ? n651_o : n656_o;
  /* ./apple2.vhd:384:7  */
  assign n658_o = n612_o ? n652_o : sf_d;
  /* ./apple2.vhd:372:7  */
  assign n660_o = n576_o ? 1'b0 : n657_o;
  /* ./apple2.vhd:372:7  */
  assign n670_o = n576_o ? sf_d : n658_o;
  /* ./apple2.vhd:414:40  */
  assign n703_o = ram_select | hram_read_en;
  /* ./apple2.vhd:414:62  */
  assign n704_o = n703_o | ram_card_read;
  /* ./apple2.vhd:414:18  */
  assign n705_o = n704_o ? cpu_dl : n706_o;
  /* ./apple2.vhd:414:85  */
  assign n706_o = keyboard_select ? k : n709_o;
  /* ./apple2.vhd:416:19  */
  assign n707_o = k[6:0];
  /* ./apple2.vhd:416:16  */
  assign n708_o = {sf_d, n707_o};
  /* ./apple2.vhd:415:40  */
  assign n709_o = c01x_select ? n708_o : n716_o;
  /* ./apple2.vhd:417:32  */
  assign n710_o = a[2:0];
  /* ./apple2.vhd:417:63  */
  assign n714_o = video_dl_latch[6:0];
  /* ./apple2.vhd:417:47  */
  assign n715_o = {n938_o, n714_o};
  /* ./apple2.vhd:416:55  */
  assign n716_o = gameport_select ? n715_o : n717_o;
  /* ./apple2.vhd:418:41  */
  assign n717_o = rom_select ? rom_out : n727_o;
  /* ./apple2.vhd:420:25  */
  assign n718_o = video_dl_latch[7:0];
  /* ./apple2.vhd:420:58  */
  assign n719_o = tape_out | speaker_select;
  /* ./apple2.vhd:420:82  */
  assign n720_o = n719_o | n382_o;
  /* ./apple2.vhd:420:95  */
  assign n721_o = n720_o | softswitch_select;
  /* ./apple2.vhd:421:49  */
  assign n722_o = n721_o | n379_o;
  /* ./apple2.vhd:421:69  */
  assign n723_o = n722_o | hram_control;
  /* ./apple2.vhd:422:49  */
  assign n725_o = a == 16'b1100111111111111;
  /* ./apple2.vhd:422:44  */
  assign n726_o = n723_o | n725_o;
  /* ./apple2.vhd:419:41  */
  assign n727_o = n726_o ? n718_o : pd;
  /* ./apple2.vhd:425:3  */
  timing_generator timing (
    .clk_14m(clk_14m),
    .palmode(palmode),
    .text_mode(n484_o),
    .page2(page2),
    .hires_mode(hires_mode),
    .mixed_mode(mixed_mode),
    .col80(col80),
    .store80(store80),
    .dhires_mode(dhires_mode),
    .vid7(n737_o),
    .vid7m(timing_vid7m),
    .q3(timing_q3),
    .ras_n(timing_ras_n),
    .cas_n(timing_cas_n),
    .ax(timing_ax),
    .phi0(timing_phi0),
    .phi0_en_r(timing_phi0_en_r),
    .phi0_en_f(timing_phi0_en_f),
    .color_ref(),
    .video_address(timing_video_address),
    .sega(timing_sega),
    .segb(timing_segb),
    .segc(timing_segc),
    .gr1(timing_gr1),
    .gr2(timing_gr2),
    .hblank(timing_hblank),
    .vblank(timing_vblank),
    .wndw_n(timing_wndw_n),
    .ldps_n(timing_ldps_n));
  /* ./apple2.vhd:444:31  */
  assign n737_o = video_dl[7];
  /* ./apple2.vhd:457:3  */
  video_generator video_display (
    .clk_14m(clk_14m),
    .clk_7m(clk_7m),
    .altchar(altchar),
    .romswitch(romswitch),
    .gr2(gr2),
    .sega(sega),
    .segb(segb),
    .segc(segc),
    .wndw_n(wndw_n),
    .dl(video_dl),
    .ldps_n(ldps_n),
    .vrom_d(vrom_d),
    .flash_clk(flash_clk),
    .vrom_a(video_display_vrom_a),
    .video(video_display_video));
  /* ./apple2.vhd:476:9  */
  assign n750_o = ~t65_we_n;
  /* ./apple2.vhd:477:22  */
  assign n751_o = t65_a[15:0];
  /* ./apple2.vhd:479:51  */
  assign n752_o = ~t65_we_n;
  /* ./apple2.vhd:479:37  */
  assign n753_o = n752_o ? d_out : d_in;
  /* ./apple2.vhd:481:56  */
  assign n755_o = ~timing_phi0;
  /* ./apple2.vhd:481:41  */
  assign n756_o = n755_o & phase_zero_d;
  /* ./apple2.vhd:481:17  */
  assign n757_o = n756_o ? 1'b1 : 1'b0;
  /* ./apple2.vhd:492:3  */
  t65 cpu6502 (
    .mode(n763_o),
    .bcd_en(n764_o),
    .res_n(n765_o),
    .enable(n767_o),
    .clk(clk_14m),
    .rdy(n768_o),
    .abort_n(n769_o),
    .irq_n(irq_n),
    .nmi_n(nmi_n),
    .so_n(n770_o),
    .di(t65_di),
    .r_w_n(cpu6502_r_w_n),
    .sync(),
    .ef(),
    .mf(),
    .xf(),
    .ml_n(),
    .vp_n(),
    .vda(),
    .vpa(),
    .a(cpu6502_a),
    .do(cpu6502_do),
    .regs(),
    .debug_i(),
    .debug_a(),
    .debug_x(),
    .debug_y(),
    .debug_s(),
    .debug_p(),
    .nmi_ack());
  /* ./apple2.vhd:497:19  */
  assign n765_o = ~reset;
  /* ./apple2.vhd:496:31  */
  assign n766_o = ~cpu_wait;
  /* ./apple2.vhd:496:26  */
  assign n767_o = cpu_en & n766_o;
  /* ./apple2.vhd:484:5  */
  always @(posedge clk_14m)
    n775_q <= timing_phi0;
  /* ./apple2.vhd:313:5  */
  always @(posedge clk_14m)
    n777_q <= n981_o;
  initial
    n777_q = 8'b00000000;
  /* ./apple2.vhd:365:5  */
  assign n778_o = n576_o ? n603_o : ramrd;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n779_q <= 1'b0;
    else
      n779_q <= n778_o;
  /* ./apple2.vhd:365:5  */
  assign n780_o = n576_o ? n604_o : ramwrt;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n781_q <= 1'b0;
    else
      n781_q <= n780_o;
  /* ./apple2.vhd:365:5  */
  assign n782_o = n576_o ? n605_o : cxrom;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n783_q <= 1'b0;
    else
      n783_q <= n782_o;
  /* ./apple2.vhd:365:5  */
  assign n784_o = n576_o ? n606_o : store80;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n785_q <= 1'b0;
    else
      n785_q <= n784_o;
  /* ./apple2.vhd:365:5  */
  assign n786_o = n576_o ? n607_o : c3rom;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n787_q <= 1'b0;
    else
      n787_q <= n786_o;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n788_q <= 1'b0;
    else
      n788_q <= n574_o;
  /* ./apple2.vhd:365:5  */
  assign n789_o = n576_o ? n608_o : altzp;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n790_q <= 1'b0;
    else
      n790_q <= n789_o;
  /* ./apple2.vhd:365:5  */
  assign n791_o = n576_o ? n609_o : altchar;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n792_q <= 1'b0;
    else
      n792_q <= n791_o;
  /* ./apple2.vhd:365:5  */
  assign n793_o = n576_o ? n610_o : col80;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n794_q <= 1'b0;
    else
      n794_q <= n793_o;
  /* ./apple2.vhd:353:3  */
  assign n795_o = ~reset;
  /* ./apple2.vhd:365:5  */
  assign n796_o = n795_o ? n670_o : sf_d;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m)
    n797_q <= n796_o;
  /* ./apple2.vhd:304:5  */
  assign n801_o = n468_o ? n469_o : speaker_sig;
  /* ./apple2.vhd:304:5  */
  always @(posedge clk_14m)
    n802_q <= n801_o;
  initial
    n802_q = 1'b0;
  /* ./apple2.vhd:182:5  */
  assign n803_o = n130_o ? n136_o : cpu_dl;
  /* ./apple2.vhd:182:5  */
  always @(posedge clk_14m)
    n804_q <= n803_o;
  /* ./apple2.vhd:182:5  */
  assign n805_o = n139_o ? ram_do : video_dl_latch;
  /* ./apple2.vhd:182:5  */
  always @(posedge clk_14m)
    n806_q <= n805_o;
  /* ./apple2.vhd:334:5  */
  assign n807_o = n492_o ? n510_o : hram_read;
  /* ./apple2.vhd:334:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n808_q <= 1'b0;
    else
      n808_q <= n807_o;
  /* ./apple2.vhd:334:5  */
  assign n809_o = n492_o ? n496_o : hram_pre_wr;
  /* ./apple2.vhd:334:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n810_q <= 1'b0;
    else
      n810_q <= n809_o;
  /* ./apple2.vhd:334:5  */
  assign n811_o = n492_o ? n506_o : hram_wr_n;
  /* ./apple2.vhd:334:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n812_q <= 1'b0;
    else
      n812_q <= n811_o;
  /* ./apple2.vhd:334:5  */
  assign n813_o = n492_o ? n493_o : hram_bank1;
  /* ./apple2.vhd:334:5  */
  always @(posedge clk_14m or posedge reset)
    if (reset)
      n814_q <= 1'b0;
    else
      n814_q <= n813_o;
  /* ./apple2.vhd:353:3  */
  assign n817_o = ~reset;
  /* ./apple2.vhd:365:5  */
  assign n818_o = n817_o ? n660_o : n819_q;
  /* ./apple2.vhd:365:5  */
  always @(posedge clk_14m)
    n819_q <= n818_o;
  /* ./apple2.vhd:252:21  */
  assign n820_o = n179_o[2];
  /* ./apple2.vhd:252:21  */
  assign n821_o = ~n820_o;
  /* ./apple2.vhd:252:21  */
  assign n822_o = n179_o[1];
  /* ./apple2.vhd:252:21  */
  assign n823_o = ~n822_o;
  /* ./apple2.vhd:252:21  */
  assign n824_o = n821_o & n823_o;
  /* ./apple2.vhd:252:21  */
  assign n825_o = n821_o & n822_o;
  /* ./apple2.vhd:252:21  */
  assign n826_o = n820_o & n823_o;
  /* ./apple2.vhd:252:21  */
  assign n827_o = n820_o & n822_o;
  /* ./apple2.vhd:252:21  */
  assign n828_o = n179_o[0];
  /* ./apple2.vhd:252:21  */
  assign n829_o = ~n828_o;
  /* ./apple2.vhd:252:21  */
  assign n830_o = n824_o & n829_o;
  /* ./apple2.vhd:252:21  */
  assign n831_o = n824_o & n828_o;
  /* ./apple2.vhd:252:21  */
  assign n832_o = n825_o & n829_o;
  /* ./apple2.vhd:252:21  */
  assign n833_o = n825_o & n828_o;
  /* ./apple2.vhd:252:21  */
  assign n834_o = n826_o & n829_o;
  /* ./apple2.vhd:252:21  */
  assign n835_o = n826_o & n828_o;
  /* ./apple2.vhd:252:21  */
  assign n836_o = n827_o & n829_o;
  /* ./apple2.vhd:252:21  */
  assign n837_o = n827_o & n828_o;
  /* ./apple2.vhd:432:23  */
  assign n838_o = n182_o[0];
  /* ./apple2.vhd:252:21  */
  assign n839_o = n830_o ? 1'b1 : n838_o;
  /* ./apple2.vhd:430:23  */
  assign n840_o = n182_o[1];
  /* ./apple2.vhd:252:21  */
  assign n841_o = n831_o ? 1'b1 : n840_o;
  /* ./apple2.vhd:428:23  */
  assign n842_o = n182_o[2];
  /* ./apple2.vhd:252:21  */
  assign n843_o = n832_o ? 1'b1 : n842_o;
  /* ./apple2.vhd:59:5  */
  assign n844_o = n182_o[3];
  /* ./apple2.vhd:252:21  */
  assign n845_o = n833_o ? 1'b1 : n844_o;
  /* ./apple2.vhd:55:5  */
  assign n846_o = n182_o[4];
  /* ./apple2.vhd:252:21  */
  assign n847_o = n834_o ? 1'b1 : n846_o;
  /* ./apple2.vhd:53:5  */
  assign n848_o = n182_o[5];
  /* ./apple2.vhd:252:21  */
  assign n849_o = n835_o ? 1'b1 : n848_o;
  /* ./apple2.vhd:51:5  */
  assign n850_o = n182_o[6];
  /* ./apple2.vhd:252:21  */
  assign n851_o = n836_o ? 1'b1 : n850_o;
  /* ./apple2.vhd:44:5  */
  assign n852_o = n182_o[7];
  /* ./apple2.vhd:252:21  */
  assign n853_o = n837_o ? 1'b1 : n852_o;
  /* ./apple2.vhd:41:5  */
  assign n854_o = {n853_o, n851_o, n849_o, n847_o, n845_o, n843_o, n841_o, n839_o};
  /* ./apple2.vhd:260:19  */
  assign n855_o = n237_o[2];
  /* ./apple2.vhd:260:19  */
  assign n856_o = ~n855_o;
  /* ./apple2.vhd:260:19  */
  assign n857_o = n237_o[1];
  /* ./apple2.vhd:260:19  */
  assign n858_o = ~n857_o;
  /* ./apple2.vhd:260:19  */
  assign n859_o = n856_o & n858_o;
  /* ./apple2.vhd:260:19  */
  assign n860_o = n856_o & n857_o;
  /* ./apple2.vhd:260:19  */
  assign n861_o = n855_o & n858_o;
  /* ./apple2.vhd:260:19  */
  assign n862_o = n855_o & n857_o;
  /* ./apple2.vhd:260:19  */
  assign n863_o = n237_o[0];
  /* ./apple2.vhd:260:19  */
  assign n864_o = ~n863_o;
  /* ./apple2.vhd:260:19  */
  assign n865_o = n859_o & n864_o;
  /* ./apple2.vhd:260:19  */
  assign n866_o = n859_o & n863_o;
  /* ./apple2.vhd:260:19  */
  assign n867_o = n860_o & n864_o;
  /* ./apple2.vhd:260:19  */
  assign n868_o = n860_o & n863_o;
  /* ./apple2.vhd:260:19  */
  assign n869_o = n861_o & n864_o;
  /* ./apple2.vhd:260:19  */
  assign n870_o = n861_o & n863_o;
  /* ./apple2.vhd:260:19  */
  assign n871_o = n862_o & n864_o;
  /* ./apple2.vhd:260:19  */
  assign n872_o = n862_o & n863_o;
  assign n873_o = n240_o[0];
  /* ./apple2.vhd:260:19  */
  assign n874_o = n865_o ? 1'b1 : n873_o;
  assign n875_o = n240_o[1];
  /* ./apple2.vhd:260:19  */
  assign n876_o = n866_o ? 1'b1 : n875_o;
  /* ./apple2.vhd:482:3  */
  assign n877_o = n240_o[2];
  /* ./apple2.vhd:260:19  */
  assign n878_o = n867_o ? 1'b1 : n877_o;
  /* ./apple2.vhd:417:20  */
  assign n879_o = n240_o[3];
  /* ./apple2.vhd:260:19  */
  assign n880_o = n868_o ? 1'b1 : n879_o;
  /* ./apple2.vhd:365:5  */
  assign n881_o = n240_o[4];
  /* ./apple2.vhd:260:19  */
  assign n882_o = n869_o ? 1'b1 : n881_o;
  /* ./apple2.vhd:365:5  */
  assign n883_o = n240_o[5];
  /* ./apple2.vhd:260:19  */
  assign n884_o = n870_o ? 1'b1 : n883_o;
  /* ./apple2.vhd:365:5  */
  assign n885_o = n240_o[6];
  /* ./apple2.vhd:260:19  */
  assign n886_o = n871_o ? 1'b1 : n885_o;
  /* ./apple2.vhd:365:5  */
  assign n887_o = n240_o[7];
  /* ./apple2.vhd:260:19  */
  assign n888_o = n872_o ? 1'b1 : n887_o;
  assign n889_o = {n888_o, n886_o, n884_o, n882_o, n880_o, n878_o, n876_o, n874_o};
  /* ./apple2.vhd:266:19  */
  assign n890_o = n267_o[2];
  /* ./apple2.vhd:266:19  */
  assign n891_o = ~n890_o;
  /* ./apple2.vhd:266:19  */
  assign n892_o = n267_o[1];
  /* ./apple2.vhd:266:19  */
  assign n893_o = ~n892_o;
  /* ./apple2.vhd:266:19  */
  assign n894_o = n891_o & n893_o;
  /* ./apple2.vhd:266:19  */
  assign n895_o = n891_o & n892_o;
  /* ./apple2.vhd:266:19  */
  assign n896_o = n890_o & n893_o;
  /* ./apple2.vhd:266:19  */
  assign n897_o = n890_o & n892_o;
  /* ./apple2.vhd:266:19  */
  assign n898_o = n267_o[0];
  /* ./apple2.vhd:266:19  */
  assign n899_o = ~n898_o;
  /* ./apple2.vhd:266:19  */
  assign n900_o = n894_o & n899_o;
  /* ./apple2.vhd:266:19  */
  assign n901_o = n894_o & n898_o;
  /* ./apple2.vhd:266:19  */
  assign n902_o = n895_o & n899_o;
  /* ./apple2.vhd:266:19  */
  assign n903_o = n895_o & n898_o;
  /* ./apple2.vhd:266:19  */
  assign n904_o = n896_o & n899_o;
  /* ./apple2.vhd:266:19  */
  assign n905_o = n896_o & n898_o;
  /* ./apple2.vhd:266:19  */
  assign n906_o = n897_o & n899_o;
  /* ./apple2.vhd:266:19  */
  assign n907_o = n897_o & n898_o;
  /* ./apple2.vhd:286:3  */
  assign n908_o = n270_o[0];
  /* ./apple2.vhd:266:19  */
  assign n909_o = n900_o ? 1'b1 : n908_o;
  assign n910_o = n270_o[1];
  /* ./apple2.vhd:266:19  */
  assign n911_o = n901_o ? 1'b1 : n910_o;
  assign n912_o = n270_o[2];
  /* ./apple2.vhd:266:19  */
  assign n913_o = n902_o ? 1'b1 : n912_o;
  assign n914_o = n270_o[3];
  /* ./apple2.vhd:266:19  */
  assign n915_o = n903_o ? 1'b1 : n914_o;
  assign n916_o = n270_o[4];
  /* ./apple2.vhd:266:19  */
  assign n917_o = n904_o ? 1'b1 : n916_o;
  assign n918_o = n270_o[5];
  /* ./apple2.vhd:266:19  */
  assign n919_o = n905_o ? 1'b1 : n918_o;
  assign n920_o = n270_o[6];
  /* ./apple2.vhd:266:19  */
  assign n921_o = n906_o ? 1'b1 : n920_o;
  assign n922_o = n270_o[7];
  /* ./apple2.vhd:266:19  */
  assign n923_o = n907_o ? 1'b1 : n922_o;
  /* ./apple2.vhd:266:28  */
  assign n924_o = {n923_o, n921_o, n919_o, n917_o, n915_o, n913_o, n911_o, n909_o};
  /* ./apple2.vhd:266:28  */
  assign n925_o = gameport[0];
  /* ./apple2.vhd:266:19  */
  assign n926_o = gameport[1];
  /* ./apple2.vhd:260:28  */
  assign n927_o = gameport[2];
  /* ./apple2.vhd:252:31  */
  assign n928_o = gameport[3];
  /* ./apple2.vhd:207:3  */
  assign n929_o = gameport[4];
  assign n930_o = gameport[5];
  /* ./apple2.vhd:182:5  */
  assign n931_o = gameport[6];
  /* ./apple2.vhd:182:5  */
  assign n932_o = gameport[7];
  /* ./apple2.vhd:417:19  */
  assign n933_o = n710_o[1:0];
  /* ./apple2.vhd:417:19  */
  always @*
    case (n933_o)
      2'b00: n934_o = n925_o;
      2'b01: n934_o = n926_o;
      2'b10: n934_o = n927_o;
      2'b11: n934_o = n928_o;
    endcase
  /* ./apple2.vhd:417:19  */
  assign n935_o = n710_o[1:0];
  /* ./apple2.vhd:417:19  */
  always @*
    case (n935_o)
      2'b00: n936_o = n929_o;
      2'b01: n936_o = n930_o;
      2'b10: n936_o = n931_o;
      2'b11: n936_o = n932_o;
    endcase
  /* ./apple2.vhd:417:19  */
  assign n937_o = n710_o[2];
  /* ./apple2.vhd:417:19  */
  assign n938_o = n937_o ? n936_o : n934_o;
  /* ./apple2.vhd:315:9  */
  assign n939_o = n476_o[2];
  /* ./apple2.vhd:315:9  */
  assign n940_o = ~n939_o;
  /* ./apple2.vhd:315:9  */
  assign n941_o = n476_o[1];
  /* ./apple2.vhd:315:9  */
  assign n942_o = ~n941_o;
  /* ./apple2.vhd:315:9  */
  assign n943_o = n940_o & n942_o;
  /* ./apple2.vhd:315:9  */
  assign n944_o = n940_o & n941_o;
  /* ./apple2.vhd:315:9  */
  assign n945_o = n939_o & n942_o;
  /* ./apple2.vhd:315:9  */
  assign n946_o = n939_o & n941_o;
  /* ./apple2.vhd:315:9  */
  assign n947_o = n476_o[0];
  /* ./apple2.vhd:315:9  */
  assign n948_o = ~n947_o;
  /* ./apple2.vhd:315:9  */
  assign n949_o = n943_o & n948_o;
  /* ./apple2.vhd:315:9  */
  assign n950_o = n943_o & n947_o;
  /* ./apple2.vhd:315:9  */
  assign n951_o = n944_o & n948_o;
  /* ./apple2.vhd:315:9  */
  assign n952_o = n944_o & n947_o;
  /* ./apple2.vhd:315:9  */
  assign n953_o = n945_o & n948_o;
  /* ./apple2.vhd:315:9  */
  assign n954_o = n945_o & n947_o;
  /* ./apple2.vhd:315:9  */
  assign n955_o = n946_o & n948_o;
  /* ./apple2.vhd:315:9  */
  assign n956_o = n946_o & n947_o;
  assign n957_o = soft_switches[0];
  /* ./apple2.vhd:315:9  */
  assign n958_o = n949_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n959_o = n958_o ? n479_o : n957_o;
  assign n960_o = soft_switches[1];
  /* ./apple2.vhd:315:9  */
  assign n961_o = n950_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n962_o = n961_o ? n479_o : n960_o;
  assign n963_o = soft_switches[2];
  /* ./apple2.vhd:315:9  */
  assign n964_o = n951_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n965_o = n964_o ? n479_o : n963_o;
  assign n966_o = soft_switches[3];
  /* ./apple2.vhd:315:9  */
  assign n967_o = n952_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n968_o = n967_o ? n479_o : n966_o;
  assign n969_o = soft_switches[4];
  /* ./apple2.vhd:315:9  */
  assign n970_o = n953_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n971_o = n970_o ? n479_o : n969_o;
  assign n972_o = soft_switches[5];
  /* ./apple2.vhd:315:9  */
  assign n973_o = n954_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n974_o = n973_o ? n479_o : n972_o;
  assign n975_o = soft_switches[6];
  /* ./apple2.vhd:315:9  */
  assign n976_o = n955_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n977_o = n976_o ? n479_o : n975_o;
  assign n978_o = soft_switches[7];
  /* ./apple2.vhd:315:9  */
  assign n979_o = n956_o & n475_o;
  /* ./apple2.vhd:315:9  */
  assign n980_o = n979_o ? n479_o : n978_o;
  assign n981_o = {n980_o, n977_o, n974_o, n971_o, n968_o, n965_o, n962_o, n959_o};
endmodule

module a2core
  (input  CLK_14M,
   input  reset,
   input  [15:0] ram_do,
   input  [7:0] rom_d,
   input  [7:0] vrom_d,
   input  [7:0] drom_d,
   input  [7:0] K,
   input  AKD,
   input  [7:0] GAMEPORT,
   input  DISK_READY,
   input  D1_WP,
   input  [7:0] TRACK1_DO,
   output [17:0] ram_addr,
   output [7:0] ram_di,
   output ram_we,
   output ram_aux,
   output [13:0] rom_a,
   output [12:0] vrom_a,
   output [7:0] drom_a,
   output VIDEO,
   output COLOR_LINE,
   output TEXT_MODE,
   output HBL,
   output VBL,
   output READ_KEY,
   output PDL_STROBE,
   output CLK_2M,
   output speaker,
   output D1_ACTIVE,
   output [5:0] TRACK1,
   output [12:0] TRACK1_ADDR,
   output [7:0] TRACK1_DI,
   output TRACK1_WE);
  wire clk2m;
  wire phase_zero;
  wire d1a;
  reg [22:0] flash;
  wire [15:0] addr;
  wire [7:0] d;
  wire [7:0] disk_do;
  wire [7:0] io_select;
  wire [7:0] device_select;
  wire [1:0] dready;
  wire [22:0] n26_o;
  wire core_clk_2m;
  wire core_phase_zero;
  wire core_phase_zero_r;
  wire core_phase_zero_f;
  wire [15:0] core_addr;
  wire [17:0] core_ram_addr;
  wire [7:0] core_d;
  wire core_aux;
  wire core_cpu_we;
  wire core_ram_we;
  wire core_video;
  wire core_color_line;
  wire core_text_mode;
  wire core_hbl;
  wire core_vbl;
  wire core_read_key;
  wire [3:0] core_an;
  wire core_pdl_strobe;
  wire core_stb;
  wire [7:0] core_io_select;
  wire [7:0] core_device_select;
  wire core_io_strobe;
  wire [13:0] core_rom_a;
  wire [12:0] core_vrom_a;
  wire core_speaker;
  localparam n30_o = 1'b0;
  localparam n31_o = 1'b0;
  localparam n32_o = 1'b0;
  wire n36_o;
  localparam n37_o = 1'b1;
  localparam n43_o = 1'b1;
  localparam n44_o = 1'b1;
  wire [7:0] n59_o;
  wire [7:0] disk_d_out;
  wire disk_d1_active;
  wire disk_d2_active;
  wire [5:0] disk_track1;
  wire [12:0] disk_track1_addr;
  wire [7:0] disk_track1_di;
  wire disk_track1_we;
  wire [5:0] disk_track2;
  wire [12:0] disk_track2_addr;
  wire [7:0] disk_track2_di;
  wire disk_track2_we;
  wire n60_o;
  wire n61_o;
  localparam n65_o = 1'b1;
  localparam n70_o = 1'b0;
  localparam [7:0] n74_o = 8'b00000000;
  localparam n76_o = 1'b1;
  wire [1:0] n78_o;
  reg [22:0] n79_q;
  assign ram_addr = core_ram_addr;
  assign ram_di = d;
  assign ram_we = core_ram_we;
  assign ram_aux = core_aux;
  assign rom_a = core_rom_a;
  assign vrom_a = core_vrom_a;
  assign drom_a = n59_o;
  assign VIDEO = core_video;
  assign COLOR_LINE = core_color_line;
  assign TEXT_MODE = core_text_mode;
  assign HBL = core_hbl;
  assign VBL = core_vbl;
  assign READ_KEY = core_read_key;
  assign PDL_STROBE = core_pdl_strobe;
  assign CLK_2M = clk2m;
  assign speaker = core_speaker;
  assign D1_ACTIVE = d1a;
  assign TRACK1 = disk_track1;
  assign TRACK1_ADDR = disk_track1_addr;
  assign TRACK1_DI = disk_track1_di;
  assign TRACK1_WE = disk_track1_we;
  /* ./a2core.vhd:55:10  */
  assign clk2m = core_clk_2m; // (signal)
  /* ./a2core.vhd:55:17  */
  assign phase_zero = core_phase_zero; // (signal)
  /* ./a2core.vhd:55:49  */
  assign d1a = disk_d1_active; // (signal)
  /* ./a2core.vhd:56:10  */
  always @*
    flash = n79_q; // (isignal)
  initial
    flash = 23'b00000000000000000000000;
  /* ./a2core.vhd:57:10  */
  assign addr = core_addr; // (signal)
  /* ./a2core.vhd:58:10  */
  assign d = core_d; // (signal)
  /* ./a2core.vhd:58:13  */
  assign disk_do = disk_d_out; // (signal)
  /* ./a2core.vhd:59:10  */
  assign io_select = core_io_select; // (signal)
  /* ./a2core.vhd:59:21  */
  assign device_select = core_device_select; // (signal)
  /* ./a2core.vhd:65:10  */
  assign dready = n78_o; // (signal)
  /* ./a2core.vhd:68:49  */
  assign n26_o = flash + 23'b00000000000000000000001;
  /* ./a2core.vhd:71:3  */
  apple2 core (
    .clk_14m(CLK_14M),
    .palmode(n30_o),
    .romswitch(n31_o),
    .cpu_wait(n32_o),
    .flash_clk(n36_o),
    .reset(reset),
    .cpu(n37_o),
    .ram_do(ram_do),
    .pd(disk_do),
    .irq_n(n43_o),
    .nmi_n(n44_o),
    .k(K),
    .akd(AKD),
    .gameport(GAMEPORT),
    .rom_d(rom_d),
    .vrom_d(vrom_d),
    .clk_2m(core_clk_2m),
    .phase_zero(core_phase_zero),
    .phase_zero_r(),
    .phase_zero_f(),
    .addr(core_addr),
    .ram_addr(core_ram_addr),
    .d(core_d),
    .aux(core_aux),
    .cpu_we(),
    .ram_we(core_ram_we),
    .video(core_video),
    .color_line(core_color_line),
    .text_mode(core_text_mode),
    .hbl(core_hbl),
    .vbl(core_vbl),
    .read_key(core_read_key),
    .an(),
    .pdl_strobe(core_pdl_strobe),
    .stb(),
    .io_select(core_io_select),
    .device_select(core_device_select),
    .io_strobe(),
    .rom_a(core_rom_a),
    .vrom_a(core_vrom_a),
    .speaker(core_speaker));
  /* ./a2core.vhd:73:93  */
  assign n36_o = flash[22];
  /* ./a2core.vhd:83:17  */
  assign n59_o = addr[7:0];
  /* ./a2core.vhd:85:3  */
  disk_ii disk (
    .clk_14m(CLK_14M),
    .clk_2m(clk2m),
    .phase_zero(phase_zero),
    .io_select(n60_o),
    .device_select(n61_o),
    .reset(reset),
    .disk_ready(dready),
    .a(addr),
    .d_in(d),
    .drom_d(drom_d),
    .d1_wp(D1_WP),
    .d2_wp(n65_o),
    .track1_do(TRACK1_DO),
    .track1_busy(n70_o),
    .track2_do(n74_o),
    .track2_busy(n76_o),
    .d_out(disk_d_out),
    .d1_active(disk_d1_active),
    .d2_active(),
    .track1(disk_track1),
    .track1_addr(disk_track1_addr),
    .track1_di(disk_track1_di),
    .track1_we(disk_track1_we),
    .track2(),
    .track2_addr(),
    .track2_di(),
    .track2_we());
  /* ./a2core.vhd:86:90  */
  assign n60_o = io_select[6];
  /* ./a2core.vhd:87:35  */
  assign n61_o = device_select[6];
  /* ./a2core.vhd:94:17  */
  assign n78_o = {1'b0, DISK_READY};
  /* ./a2core.vhd:68:5  */
  always @(posedge CLK_14M)
    n79_q <= n26_o;
  initial
    n79_q = 23'b00000000000000000000000;
endmodule

