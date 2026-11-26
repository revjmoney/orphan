module cntr3
  (input  clk,
   input  rst,
   input  en,
   output [2:0] o);
  reg [2:0] d;
  wire [2:0] n8589_o;
  wire [2:0] n8590_o;
  wire [2:0] n8592_o;
  reg [2:0] n8595_q;
  assign o = d;
  /* ./TIA/TIA.vhd:119:12  */
  always @*
    d = n8595_q; // (isignal)
  initial
    d = 3'b000;
  /* ./TIA/TIA.vhd:131:24  */
  assign n8589_o = d + 3'b001;
  /* ./TIA/TIA.vhd:130:13  */
  assign n8590_o = en ? n8589_o : d;
  /* ./TIA/TIA.vhd:128:13  */
  assign n8592_o = rst ? 3'b000 : n8590_o;
  /* ./TIA/TIA.vhd:127:9  */
  always @(posedge clk)
    n8595_q <= n8592_o;
  initial
    n8595_q = 3'b000;
endmodule

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
  wire [3:0] n8231_o;
  wire n8232_o;
  wire [4:0] n8233_o;
  wire [6:0] n8234_o;
  wire [3:0] n8235_o;
  wire [4:0] n8237_o;
  wire [6:0] n8238_o;
  wire [6:0] n8239_o;
  wire [3:0] n8240_o;
  wire n8241_o;
  wire [4:0] n8242_o;
  wire [6:0] n8243_o;
  wire [3:0] n8244_o;
  wire [4:0] n8246_o;
  wire [6:0] n8247_o;
  wire [6:0] n8248_o;
  wire [3:0] n8249_o;
  wire n8251_o;
  wire [3:0] n8252_o;
  wire n8254_o;
  wire n8255_o;
  wire n8258_o;
  wire [4:0] n8259_o;
  wire n8261_o;
  wire n8262_o;
  wire n8263_o;
  wire n8264_o;
  wire [5:0] n8265_o;
  wire [5:0] n8267_o;
  wire [5:0] n8268_o;
  wire [5:0] n8269_o;
  wire n8270_o;
  wire [6:0] n8271_o;
  wire n8272_o;
  wire [6:0] n8273_o;
  wire n8274_o;
  wire n8275_o;
  wire [3:0] n8276_o;
  wire [4:0] n8277_o;
  wire [6:0] n8278_o;
  wire [3:0] n8279_o;
  wire [4:0] n8281_o;
  wire [6:0] n8282_o;
  wire [6:0] n8283_o;
  wire n8284_o;
  wire n8285_o;
  wire n8286_o;
  wire n8287_o;
  wire n8288_o;
  wire n8289_o;
  wire n8290_o;
  wire n8291_o;
  wire n8292_o;
  wire [4:0] n8293_o;
  wire n8295_o;
  wire n8296_o;
  wire n8297_o;
  wire n8298_o;
  wire [5:0] n8299_o;
  wire [5:0] n8301_o;
  wire [5:0] n8302_o;
  wire [5:0] n8303_o;
  wire n8304_o;
  wire [6:0] n8305_o;
  wire n8306_o;
  wire [6:0] n8307_o;
  wire n8308_o;
  wire n8309_o;
  wire [6:0] n8310_o;
  wire [3:0] n8311_o;
  wire [6:0] n8312_o;
  wire [3:0] n8313_o;
  wire [7:0] n8314_o;
  wire n8325_o;
  wire n8327_o;
  wire n8328_o;
  wire n8330_o;
  wire n8331_o;
  wire n8333_o;
  wire n8334_o;
  wire n8336_o;
  wire n8337_o;
  wire n8339_o;
  wire n8340_o;
  wire n8342_o;
  wire n8343_o;
  wire n8346_o;
  wire n8348_o;
  wire n8349_o;
  wire n8350_o;
  wire [3:0] n8351_o;
  wire [4:0] n8352_o;
  wire [6:0] n8353_o;
  wire [3:0] n8354_o;
  wire [4:0] n8356_o;
  wire [5:0] n8357_o;
  wire [6:0] n8358_o;
  wire [6:0] n8359_o;
  wire [3:0] n8360_o;
  wire [4:0] n8362_o;
  wire [5:0] n8363_o;
  wire [3:0] n8364_o;
  wire n8365_o;
  wire [4:0] n8366_o;
  wire [5:0] n8367_o;
  wire [5:0] n8368_o;
  wire [3:0] n8369_o;
  wire n8371_o;
  wire [3:0] n8372_o;
  wire n8374_o;
  wire n8375_o;
  wire n8378_o;
  wire n8379_o;
  wire n8380_o;
  wire n8381_o;
  wire n8382_o;
  wire n8383_o;
  wire n8384_o;
  wire n8385_o;
  wire n8386_o;
  wire n8387_o;
  wire n8388_o;
  wire [3:0] n8389_o;
  wire [3:0] n8390_o;
  wire [7:0] n8391_o;
  wire n8392_o;
  wire n8393_o;
  wire n8394_o;
  wire [4:0] n8395_o;
  wire [4:0] n8397_o;
  wire [4:0] n8398_o;
  wire [4:0] n8399_o;
  wire [3:0] n8400_o;
  wire [4:0] n8402_o;
  wire [5:0] n8403_o;
  wire [3:0] n8404_o;
  wire n8405_o;
  wire n8406_o;
  wire [6:0] n8407_o;
  wire n8408_o;
  wire [4:0] n8409_o;
  wire [5:0] n8410_o;
  wire [5:0] n8411_o;
  wire n8412_o;
  wire [4:0] n8413_o;
  wire [4:0] n8415_o;
  wire [4:0] n8416_o;
  wire [4:0] n8417_o;
  wire n8418_o;
  wire [4:0] n8419_o;
  wire [4:0] n8420_o;
  wire n8421_o;
  wire n8422_o;
  wire [5:0] n8423_o;
  wire [5:0] n8424_o;
  wire [3:0] n8425_o;
  wire [6:0] n8426_o;
  wire [3:0] n8427_o;
  wire [7:0] n8428_o;
  wire [7:0] n8435_o;
  wire n8437_o;
  wire [7:0] n8438_o;
  wire n8440_o;
  wire [7:0] n8441_o;
  wire n8443_o;
  wire n8445_o;
  wire n8447_o;
  wire n8449_o;
  wire n8451_o;
  wire [6:0] n8452_o;
  wire [7:0] n8454_o;
  wire n8455_o;
  wire n8457_o;
  wire [6:0] n8458_o;
  wire n8459_o;
  wire [7:0] n8460_o;
  wire n8461_o;
  wire n8463_o;
  wire [6:0] n8464_o;
  wire [7:0] n8466_o;
  wire n8467_o;
  wire n8469_o;
  wire n8470_o;
  wire [6:0] n8471_o;
  wire [7:0] n8472_o;
  wire n8473_o;
  wire n8475_o;
  wire n8476_o;
  wire [6:0] n8477_o;
  wire [6:0] n8478_o;
  wire [6:0] n8479_o;
  wire [7:0] n8480_o;
  wire n8481_o;
  wire n8482_o;
  wire n8483_o;
  wire n8484_o;
  wire n8485_o;
  wire [3:0] n8486_o;
  wire [3:0] n8487_o;
  wire [3:0] n8488_o;
  wire n8490_o;
  wire [3:0] n8491_o;
  wire [3:0] n8493_o;
  wire [3:0] n8494_o;
  wire [3:0] n8495_o;
  wire [3:0] n8496_o;
  wire [3:0] n8497_o;
  wire [3:0] n8498_o;
  wire n8500_o;
  wire [3:0] n8501_o;
  wire [3:0] n8503_o;
  wire n8506_o;
  wire [3:0] n8507_o;
  wire [3:0] n8508_o;
  wire n8509_o;
  wire n8510_o;
  wire [7:0] n8511_o;
  wire [7:0] n8512_o;
  wire n8514_o;
  wire n8515_o;
  wire n8517_o;
  wire [7:0] n8519_o;
  wire n8521_o;
  wire [7:0] n8523_o;
  wire n8525_o;
  wire [14:0] n8526_o;
  wire n8527_o;
  reg n8528_o;
  wire n8529_o;
  reg n8530_o;
  wire n8532_o;
  reg [7:0] n8534_o;
  reg [7:0] n8535_o;
  wire n8537_o;
  wire n8539_o;
  wire n8541_o;
  wire n8542_o;
  wire n8544_o;
  wire n8545_o;
  wire n8547_o;
  wire n8548_o;
  wire [7:0] n8549_o;
  wire n8551_o;
  wire n8554_o;
  wire n8556_o;
  wire n8557_o;
  wire n8558_o;
  wire n8560_o;
  wire n8563_o;
  wire n8565_o;
  wire n8566_o;
  wire n8568_o;
  wire n8571_o;
  wire [4:0] n8572_o;
  reg n8573_o;
  wire n8574_o;
  reg n8575_o;
  reg n8576_o;
  wire [3:0] n8577_o;
  wire n8579_o;
  wire [7:0] n8580_o;
  wire [7:0] n8582_o;
  assign p_out = n8582_o;
  assign q = n8580_o;
  /* ./T65/T65_ALU.vhd:73:15  */
  assign adc_z = n8258_o; // (signal)
  /* ./T65/T65_ALU.vhd:74:15  */
  assign adc_c = n8309_o; // (signal)
  /* ./T65/T65_ALU.vhd:75:15  */
  assign adc_v = n8292_o; // (signal)
  /* ./T65/T65_ALU.vhd:76:15  */
  assign adc_n = n8284_o; // (signal)
  /* ./T65/T65_ALU.vhd:77:15  */
  assign adc_q = n8314_o; // (signal)
  /* ./T65/T65_ALU.vhd:78:15  */
  assign sbc_z = n8378_o; // (signal)
  /* ./T65/T65_ALU.vhd:79:15  */
  assign sbc_c = n8380_o; // (signal)
  /* ./T65/T65_ALU.vhd:80:15  */
  assign sbc_v = n8387_o; // (signal)
  /* ./T65/T65_ALU.vhd:81:15  */
  assign sbc_n = n8388_o; // (signal)
  /* ./T65/T65_ALU.vhd:82:15  */
  assign sbc_q = n8428_o; // (signal)
  /* ./T65/T65_ALU.vhd:83:15  */
  assign sbx_q = n8391_o; // (signal)
  /* ./T65/T65_ALU.vhd:92:31  */
  assign n8231_o = busa[3:0];
  /* ./T65/T65_ALU.vhd:92:50  */
  assign n8232_o = p_in[0];
  /* ./T65/T65_ALU.vhd:92:44  */
  assign n8233_o = {n8231_o, n8232_o};
  /* ./T65/T65_ALU.vhd:92:11  */
  assign n8234_o = {2'b0, n8233_o};  //  uext
  /* ./T65/T65_ALU.vhd:92:86  */
  assign n8235_o = busb[3:0];
  /* ./T65/T65_ALU.vhd:92:99  */
  assign n8237_o = {n8235_o, 1'b1};
  /* ./T65/T65_ALU.vhd:92:66  */
  assign n8238_o = {2'b0, n8237_o};  //  uext
  /* ./T65/T65_ALU.vhd:92:64  */
  assign n8239_o = n8234_o + n8238_o;
  /* ./T65/T65_ALU.vhd:93:31  */
  assign n8240_o = busa[7:4];
  /* ./T65/T65_ALU.vhd:93:48  */
  assign n8241_o = n8239_o[5];
  /* ./T65/T65_ALU.vhd:93:44  */
  assign n8242_o = {n8240_o, n8241_o};
  /* ./T65/T65_ALU.vhd:93:11  */
  assign n8243_o = {2'b0, n8242_o};  //  uext
  /* ./T65/T65_ALU.vhd:93:79  */
  assign n8244_o = busb[7:4];
  /* ./T65/T65_ALU.vhd:93:92  */
  assign n8246_o = {n8244_o, 1'b1};
  /* ./T65/T65_ALU.vhd:93:59  */
  assign n8247_o = {2'b0, n8246_o};  //  uext
  /* ./T65/T65_ALU.vhd:93:57  */
  assign n8248_o = n8243_o + n8247_o;
  /* ./T65/T65_ALU.vhd:100:10  */
  assign n8249_o = n8239_o[4:1];
  /* ./T65/T65_ALU.vhd:100:23  */
  assign n8251_o = n8249_o == 4'b0000;
  /* ./T65/T65_ALU.vhd:100:33  */
  assign n8252_o = n8248_o[4:1];
  /* ./T65/T65_ALU.vhd:100:46  */
  assign n8254_o = n8252_o == 4'b0000;
  /* ./T65/T65_ALU.vhd:100:27  */
  assign n8255_o = n8254_o & n8251_o;
  /* ./T65/T65_ALU.vhd:100:5  */
  assign n8258_o = n8255_o ? 1'b1 : 1'b0;
  /* ./T65/T65_ALU.vhd:106:10  */
  assign n8259_o = n8239_o[5:1];
  /* ./T65/T65_ALU.vhd:106:23  */
  assign n8261_o = $unsigned(n8259_o) > $unsigned(5'b01001);
  /* ./T65/T65_ALU.vhd:106:35  */
  assign n8262_o = p_in[3];
  /* ./T65/T65_ALU.vhd:106:27  */
  assign n8263_o = n8262_o & n8261_o;
  /* ./T65/T65_ALU.vhd:106:50  */
  assign n8264_o = bcd_en & n8263_o;
  /* ./T65/T65_ALU.vhd:107:27  */
  assign n8265_o = n8239_o[6:1];
  /* ./T65/T65_ALU.vhd:107:40  */
  assign n8267_o = n8265_o + 6'b000110;
  assign n8268_o = n8239_o[6:1];
  /* ./T65/T65_ALU.vhd:106:5  */
  assign n8269_o = n8264_o ? n8267_o : n8268_o;
  assign n8270_o = n8239_o[0];
  /* ./T65/T65_MCode.vhd:451:15  */
  assign n8271_o = {n8269_o, n8270_o};
  /* ./T65/T65_ALU.vhd:110:12  */
  assign n8272_o = n8271_o[6];
  assign n8273_o = {n8269_o, n8270_o};
  /* ./T65/T65_ALU.vhd:110:21  */
  assign n8274_o = n8273_o[5];
  /* ./T65/T65_ALU.vhd:110:16  */
  assign n8275_o = n8272_o | n8274_o;
  /* ./T65/T65_ALU.vhd:111:31  */
  assign n8276_o = busa[7:4];
  /* ./T65/T65_ALU.vhd:111:44  */
  assign n8277_o = {n8276_o, n8275_o};
  /* ./T65/T65_ALU.vhd:111:11  */
  assign n8278_o = {2'b0, n8277_o};  //  uext
  /* ./T65/T65_ALU.vhd:111:75  */
  assign n8279_o = busb[7:4];
  /* ./T65/T65_ALU.vhd:111:88  */
  assign n8281_o = {n8279_o, 1'b1};
  /* ./T65/T65_ALU.vhd:111:55  */
  assign n8282_o = {2'b0, n8281_o};  //  uext
  /* ./T65/T65_ALU.vhd:111:53  */
  assign n8283_o = n8278_o + n8282_o;
  /* ./T65/T65_ALU.vhd:113:16  */
  assign n8284_o = n8283_o[4];
  /* ./T65/T65_ALU.vhd:114:17  */
  assign n8285_o = n8283_o[4];
  /* ./T65/T65_ALU.vhd:114:29  */
  assign n8286_o = busa[7];
  /* ./T65/T65_ALU.vhd:114:21  */
  assign n8287_o = n8285_o ^ n8286_o;
  /* ./T65/T65_ALU.vhd:114:47  */
  assign n8288_o = busa[7];
  /* ./T65/T65_ALU.vhd:114:59  */
  assign n8289_o = busb[7];
  /* ./T65/T65_ALU.vhd:114:51  */
  assign n8290_o = n8288_o ^ n8289_o;
  /* ./T65/T65_ALU.vhd:114:38  */
  assign n8291_o = ~n8290_o;
  /* ./T65/T65_ALU.vhd:114:34  */
  assign n8292_o = n8287_o & n8291_o;
  /* ./T65/T65_ALU.vhd:120:10  */
  assign n8293_o = n8283_o[5:1];
  /* ./T65/T65_ALU.vhd:120:23  */
  assign n8295_o = $unsigned(n8293_o) > $unsigned(5'b01001);
  /* ./T65/T65_ALU.vhd:120:35  */
  assign n8296_o = p_in[3];
  /* ./T65/T65_ALU.vhd:120:27  */
  assign n8297_o = n8296_o & n8295_o;
  /* ./T65/T65_ALU.vhd:120:50  */
  assign n8298_o = bcd_en & n8297_o;
  /* ./T65/T65_ALU.vhd:121:27  */
  assign n8299_o = n8283_o[6:1];
  /* ./T65/T65_ALU.vhd:121:40  */
  assign n8301_o = n8299_o + 6'b000110;
  assign n8302_o = n8283_o[6:1];
  /* ./T65/T65_ALU.vhd:120:5  */
  assign n8303_o = n8298_o ? n8301_o : n8302_o;
  assign n8304_o = n8283_o[0];
  assign n8305_o = {n8303_o, n8304_o};
  /* ./T65/T65_ALU.vhd:124:16  */
  assign n8306_o = n8305_o[6];
  assign n8307_o = {n8303_o, n8304_o};
  /* ./T65/T65_ALU.vhd:124:25  */
  assign n8308_o = n8307_o[5];
  /* ./T65/T65_ALU.vhd:124:20  */
  assign n8309_o = n8306_o | n8308_o;
  assign n8310_o = {n8303_o, n8304_o};
  /* ./T65/T65_ALU.vhd:126:33  */
  assign n8311_o = n8310_o[4:1];
  assign n8312_o = {n8269_o, n8270_o};
  /* ./T65/T65_ALU.vhd:126:50  */
  assign n8313_o = n8312_o[4:1];
  /* ./T65/T65_ALU.vhd:126:46  */
  assign n8314_o = {n8311_o, n8313_o};
  /* ./T65/T65_ALU.vhd:136:12  */
  assign n8325_o = op == 5'b00001;
  /* ./T65/T65_ALU.vhd:137:12  */
  assign n8327_o = op == 5'b00011;
  /* ./T65/T65_ALU.vhd:136:24  */
  assign n8328_o = n8325_o | n8327_o;
  /* ./T65/T65_ALU.vhd:138:12  */
  assign n8330_o = op == 5'b00101;
  /* ./T65/T65_ALU.vhd:137:24  */
  assign n8331_o = n8328_o | n8330_o;
  /* ./T65/T65_ALU.vhd:139:12  */
  assign n8333_o = op == 5'b00111;
  /* ./T65/T65_ALU.vhd:138:24  */
  assign n8334_o = n8331_o | n8333_o;
  /* ./T65/T65_ALU.vhd:140:12  */
  assign n8336_o = op == 5'b01001;
  /* ./T65/T65_ALU.vhd:139:24  */
  assign n8337_o = n8334_o | n8336_o;
  /* ./T65/T65_ALU.vhd:141:12  */
  assign n8339_o = op == 5'b01011;
  /* ./T65/T65_ALU.vhd:140:24  */
  assign n8340_o = n8337_o | n8339_o;
  /* ./T65/T65_ALU.vhd:143:12  */
  assign n8342_o = op == 5'b01110;
  /* ./T65/T65_ALU.vhd:141:24  */
  assign n8343_o = n8340_o | n8342_o;
  /* ./T65/T65_ALU.vhd:136:5  */
  assign n8346_o = n8343_o ? 1'b1 : 1'b0;
  /* ./T65/T65_ALU.vhd:148:14  */
  assign n8348_o = p_in[0];
  /* ./T65/T65_ALU.vhd:148:26  */
  assign n8349_o = ~n8346_o;
  /* ./T65/T65_ALU.vhd:148:23  */
  assign n8350_o = n8348_o | n8349_o;
  /* ./T65/T65_ALU.vhd:149:31  */
  assign n8351_o = busa[3:0];
  /* ./T65/T65_ALU.vhd:149:44  */
  assign n8352_o = {n8351_o, n8350_o};
  /* ./T65/T65_ALU.vhd:149:11  */
  assign n8353_o = {2'b0, n8352_o};  //  uext
  /* ./T65/T65_ALU.vhd:149:75  */
  assign n8354_o = busb[3:0];
  /* ./T65/T65_ALU.vhd:149:88  */
  assign n8356_o = {n8354_o, 1'b1};
  /* ./T65/T65_ALU.vhd:149:55  */
  assign n8357_o = {1'b0, n8356_o};  //  uext
  /* ./T65/T65_ALU.vhd:149:53  */
  assign n8358_o = {1'b0, n8357_o};  //  uext
  /* ./T65/T65_ALU.vhd:149:53  */
  assign n8359_o = n8353_o - n8358_o;
  /* ./T65/T65_ALU.vhd:150:31  */
  assign n8360_o = busa[7:4];
  /* ./T65/T65_ALU.vhd:150:44  */
  assign n8362_o = {n8360_o, 1'b0};
  /* ./T65/T65_ALU.vhd:150:11  */
  assign n8363_o = {1'b0, n8362_o};  //  uext
  /* ./T65/T65_ALU.vhd:150:77  */
  assign n8364_o = busb[7:4];
  /* ./T65/T65_ALU.vhd:150:94  */
  assign n8365_o = n8359_o[5];
  /* ./T65/T65_ALU.vhd:150:90  */
  assign n8366_o = {n8364_o, n8365_o};
  /* ./T65/T65_ALU.vhd:150:57  */
  assign n8367_o = {1'b0, n8366_o};  //  uext
  /* ./T65/T65_ALU.vhd:150:55  */
  assign n8368_o = n8363_o - n8367_o;
  /* ./T65/T65_ALU.vhd:157:10  */
  assign n8369_o = n8359_o[4:1];
  /* ./T65/T65_ALU.vhd:157:23  */
  assign n8371_o = n8369_o == 4'b0000;
  /* ./T65/T65_ALU.vhd:157:33  */
  assign n8372_o = n8368_o[4:1];
  /* ./T65/T65_ALU.vhd:157:46  */
  assign n8374_o = n8372_o == 4'b0000;
  /* ./T65/T65_ALU.vhd:157:27  */
  assign n8375_o = n8374_o & n8371_o;
  /* ./T65/T65_ALU.vhd:157:5  */
  assign n8378_o = n8375_o ? 1'b1 : 1'b0;
  /* ./T65/T65_ALU.vhd:163:20  */
  assign n8379_o = n8368_o[5];
  /* ./T65/T65_ALU.vhd:163:14  */
  assign n8380_o = ~n8379_o;
  /* ./T65/T65_ALU.vhd:164:17  */
  assign n8381_o = n8368_o[4];
  /* ./T65/T65_ALU.vhd:164:29  */
  assign n8382_o = busa[7];
  /* ./T65/T65_ALU.vhd:164:21  */
  assign n8383_o = n8381_o ^ n8382_o;
  /* ./T65/T65_ALU.vhd:164:43  */
  assign n8384_o = busa[7];
  /* ./T65/T65_ALU.vhd:164:55  */
  assign n8385_o = busb[7];
  /* ./T65/T65_ALU.vhd:164:47  */
  assign n8386_o = n8384_o ^ n8385_o;
  /* ./T65/T65_ALU.vhd:164:34  */
  assign n8387_o = n8383_o & n8386_o;
  /* ./T65/T65_ALU.vhd:165:16  */
  assign n8388_o = n8368_o[4];
  /* ./T65/T65_ALU.vhd:167:33  */
  assign n8389_o = n8368_o[4:1];
  /* ./T65/T65_ALU.vhd:167:50  */
  assign n8390_o = n8359_o[4:1];
  /* ./T65/T65_ALU.vhd:167:46  */
  assign n8391_o = {n8389_o, n8390_o};
  /* ./T65/T65_ALU.vhd:169:12  */
  assign n8392_o = p_in[3];
  /* ./T65/T65_ALU.vhd:169:27  */
  assign n8393_o = bcd_en & n8392_o;
  /* ./T65/T65_ALU.vhd:170:12  */
  assign n8394_o = n8359_o[5];
  /* ./T65/T65_ALU.vhd:171:29  */
  assign n8395_o = n8359_o[5:1];
  /* ./T65/T65_ALU.vhd:171:42  */
  assign n8397_o = n8395_o - 5'b00110;
  assign n8398_o = n8359_o[5:1];
  /* ./T65/T65_ALU.vhd:170:7  */
  assign n8399_o = n8394_o ? n8397_o : n8398_o;
  /* ./T65/T65_ALU.vhd:173:33  */
  assign n8400_o = busa[7:4];
  /* ./T65/T65_ALU.vhd:173:46  */
  assign n8402_o = {n8400_o, 1'b0};
  /* ./T65/T65_ALU.vhd:173:13  */
  assign n8403_o = {1'b0, n8402_o};  //  uext
  /* ./T65/T65_ALU.vhd:173:79  */
  assign n8404_o = busb[7:4];
  assign n8405_o = n8359_o[0];
  assign n8406_o = n8359_o[6];
  assign n8407_o = {n8406_o, n8399_o, n8405_o};
  /* ./T65/T65_ALU.vhd:173:96  */
  assign n8408_o = n8407_o[6];
  /* ./T65/T65_ALU.vhd:173:92  */
  assign n8409_o = {n8404_o, n8408_o};
  /* ./T65/T65_ALU.vhd:173:59  */
  assign n8410_o = {1'b0, n8409_o};  //  uext
  /* ./T65/T65_ALU.vhd:173:57  */
  assign n8411_o = n8403_o - n8410_o;
  /* ./T65/T65_ALU.vhd:174:12  */
  assign n8412_o = n8411_o[5];
  /* ./T65/T65_ALU.vhd:175:29  */
  assign n8413_o = n8411_o[5:1];
  /* ./T65/T65_ALU.vhd:175:42  */
  assign n8415_o = n8413_o - 5'b00110;
  assign n8416_o = n8411_o[5:1];
  /* ./T65/T65_ALU.vhd:174:7  */
  assign n8417_o = n8412_o ? n8415_o : n8416_o;
  assign n8418_o = n8411_o[0];
  assign n8419_o = n8359_o[5:1];
  /* ./T65/T65_ALU.vhd:169:5  */
  assign n8420_o = n8393_o ? n8399_o : n8419_o;
  assign n8421_o = n8359_o[6];
  assign n8422_o = n8359_o[0];
  assign n8423_o = {n8417_o, n8418_o};
  /* ./T65/T65_ALU.vhd:169:5  */
  assign n8424_o = n8393_o ? n8423_o : n8368_o;
  /* ./T65/T65_ALU.vhd:179:33  */
  assign n8425_o = n8424_o[4:1];
  assign n8426_o = {n8421_o, n8420_o, n8422_o};
  /* ./T65/T65_ALU.vhd:179:50  */
  assign n8427_o = n8426_o[4:1];
  /* ./T65/T65_ALU.vhd:179:46  */
  assign n8428_o = {n8425_o, n8427_o};
  /* ./T65/T65_ALU.vhd:196:21  */
  assign n8435_o = busa | busb;
  /* ./T65/T65_ALU.vhd:195:7  */
  assign n8437_o = op == 5'b00000;
  /* ./T65/T65_ALU.vhd:198:21  */
  assign n8438_o = busa & busb;
  /* ./T65/T65_ALU.vhd:197:7  */
  assign n8440_o = op == 5'b00001;
  /* ./T65/T65_ALU.vhd:200:21  */
  assign n8441_o = busa ^ busb;
  /* ./T65/T65_ALU.vhd:199:7  */
  assign n8443_o = op == 5'b00010;
  /* ./T65/T65_ALU.vhd:201:7  */
  assign n8445_o = op == 5'b00011;
  /* ./T65/T65_ALU.vhd:205:7  */
  assign n8447_o = op == 5'b00110;
  /* ./T65/T65_ALU.vhd:207:7  */
  assign n8449_o = op == 5'b10001;
  /* ./T65/T65_ALU.vhd:210:7  */
  assign n8451_o = op == 5'b00111;
  /* ./T65/T65_ALU.vhd:215:20  */
  assign n8452_o = busa[6:0];
  /* ./T65/T65_ALU.vhd:215:33  */
  assign n8454_o = {n8452_o, 1'b0};
  /* ./T65/T65_ALU.vhd:216:30  */
  assign n8455_o = busa[7];
  /* ./T65/T65_ALU.vhd:214:7  */
  assign n8457_o = op == 5'b01000;
  /* ./T65/T65_ALU.vhd:218:20  */
  assign n8458_o = busa[6:0];
  /* ./T65/T65_ALU.vhd:218:39  */
  assign n8459_o = p_in[0];
  /* ./T65/T65_ALU.vhd:218:33  */
  assign n8460_o = {n8458_o, n8459_o};
  /* ./T65/T65_ALU.vhd:219:30  */
  assign n8461_o = busa[7];
  /* ./T65/T65_ALU.vhd:217:7  */
  assign n8463_o = op == 5'b01001;
  /* ./T65/T65_ALU.vhd:221:26  */
  assign n8464_o = busa[7:1];
  /* ./T65/T65_ALU.vhd:221:20  */
  assign n8466_o = {1'b0, n8464_o};
  /* ./T65/T65_ALU.vhd:222:30  */
  assign n8467_o = busa[0];
  /* ./T65/T65_ALU.vhd:220:7  */
  assign n8469_o = op == 5'b01010;
  /* ./T65/T65_ALU.vhd:224:20  */
  assign n8470_o = p_in[0];
  /* ./T65/T65_ALU.vhd:224:35  */
  assign n8471_o = busa[7:1];
  /* ./T65/T65_ALU.vhd:224:29  */
  assign n8472_o = {n8470_o, n8471_o};
  /* ./T65/T65_ALU.vhd:225:30  */
  assign n8473_o = busa[0];
  /* ./T65/T65_ALU.vhd:223:7  */
  assign n8475_o = op == 5'b01011;
  /* ./T65/T65_ALU.vhd:227:20  */
  assign n8476_o = p_in[0];
  /* ./T65/T65_ALU.vhd:227:36  */
  assign n8477_o = busa[7:1];
  /* ./T65/T65_ALU.vhd:227:57  */
  assign n8478_o = busb[7:1];
  /* ./T65/T65_ALU.vhd:227:49  */
  assign n8479_o = n8477_o & n8478_o;
  /* ./T65/T65_ALU.vhd:227:29  */
  assign n8480_o = {n8476_o, n8479_o};
  /* ./T65/T65_ALU.vhd:228:29  */
  assign n8481_o = n8480_o[5];
  /* ./T65/T65_ALU.vhd:228:40  */
  assign n8482_o = n8480_o[6];
  /* ./T65/T65_ALU.vhd:228:33  */
  assign n8483_o = n8481_o ^ n8482_o;
  /* ./T65/T65_ALU.vhd:230:16  */
  assign n8484_o = p_in[3];
  /* ./T65/T65_ALU.vhd:230:29  */
  assign n8485_o = bcd_en & n8484_o;
  /* ./T65/T65_ALU.vhd:231:19  */
  assign n8486_o = busa[3:0];
  /* ./T65/T65_ALU.vhd:231:40  */
  assign n8487_o = busb[3:0];
  /* ./T65/T65_ALU.vhd:231:32  */
  assign n8488_o = n8486_o & n8487_o;
  /* ./T65/T65_ALU.vhd:231:54  */
  assign n8490_o = $unsigned(n8488_o) > $unsigned(4'b0100);
  /* ./T65/T65_ALU.vhd:232:62  */
  assign n8491_o = n8480_o[3:0];
  /* ./T65/T65_ALU.vhd:232:76  */
  assign n8493_o = n8491_o + 4'b0110;
  assign n8494_o = n8480_o[3:0];
  /* ./T65/T65_ALU.vhd:231:11  */
  assign n8495_o = n8490_o ? n8493_o : n8494_o;
  /* ./T65/T65_ALU.vhd:234:19  */
  assign n8496_o = busa[7:4];
  /* ./T65/T65_ALU.vhd:234:40  */
  assign n8497_o = busb[7:4];
  /* ./T65/T65_ALU.vhd:234:32  */
  assign n8498_o = n8496_o & n8497_o;
  /* ./T65/T65_ALU.vhd:234:54  */
  assign n8500_o = $unsigned(n8498_o) > $unsigned(4'b0100);
  /* ./T65/T65_ALU.vhd:235:62  */
  assign n8501_o = n8480_o[7:4];
  /* ./T65/T65_ALU.vhd:235:76  */
  assign n8503_o = n8501_o + 4'b0110;
  /* ./T65/T65_ALU.vhd:234:11  */
  assign n8506_o = n8500_o ? 1'b1 : 1'b0;
  assign n8507_o = n8480_o[7:4];
  /* ./T65/T65_ALU.vhd:234:11  */
  assign n8508_o = n8500_o ? n8503_o : n8507_o;
  /* ./T65/T65_ALU.vhd:241:31  */
  assign n8509_o = n8480_o[6];
  /* ./T65/T65_ALU.vhd:230:9  */
  assign n8510_o = n8485_o ? n8506_o : n8509_o;
  assign n8511_o = {n8508_o, n8495_o};
  /* ./T65/T65_ALU.vhd:230:9  */
  assign n8512_o = n8485_o ? n8511_o : n8480_o;
  /* ./T65/T65_ALU.vhd:226:7  */
  assign n8514_o = op == 5'b01111;
  /* ./T65/T65_ALU.vhd:244:30  */
  assign n8515_o = busb[6];
  /* ./T65/T65_ALU.vhd:243:7  */
  assign n8517_o = op == 5'b01100;
  /* ./T65/T65_ALU.vhd:246:48  */
  assign n8519_o = busa - 8'b00000001;
  /* ./T65/T65_ALU.vhd:245:7  */
  assign n8521_o = op == 5'b01101;
  /* ./T65/T65_ALU.vhd:248:48  */
  assign n8523_o = busa + 8'b00000001;
  /* ./T65/T65_ALU.vhd:247:7  */
  assign n8525_o = op == 5'b01110;
  assign n8526_o = {n8525_o, n8521_o, n8517_o, n8514_o, n8475_o, n8469_o, n8463_o, n8457_o, n8451_o, n8449_o, n8447_o, n8445_o, n8443_o, n8440_o, n8437_o};
  assign n8527_o = p_in[0];
  /* ./T65/T65_ALU.vhd:194:5  */
  always @*
    case (n8526_o)
      15'b100000000000000: n8528_o = n8527_o;
      15'b010000000000000: n8528_o = n8527_o;
      15'b001000000000000: n8528_o = n8527_o;
      15'b000100000000000: n8528_o = n8510_o;
      15'b000010000000000: n8528_o = n8473_o;
      15'b000001000000000: n8528_o = n8467_o;
      15'b000000100000000: n8528_o = n8461_o;
      15'b000000010000000: n8528_o = n8455_o;
      15'b000000001000000: n8528_o = sbc_c;
      15'b000000000100000: n8528_o = sbc_c;
      15'b000000000010000: n8528_o = sbc_c;
      15'b000000000001000: n8528_o = adc_c;
      15'b000000000000100: n8528_o = n8527_o;
      15'b000000000000010: n8528_o = n8527_o;
      15'b000000000000001: n8528_o = n8527_o;
      default: n8528_o = n8527_o;
    endcase
  assign n8529_o = p_in[6];
  /* ./T65/T65_ALU.vhd:194:5  */
  always @*
    case (n8526_o)
      15'b100000000000000: n8530_o = n8529_o;
      15'b010000000000000: n8530_o = n8529_o;
      15'b001000000000000: n8530_o = n8515_o;
      15'b000100000000000: n8530_o = n8483_o;
      15'b000010000000000: n8530_o = n8529_o;
      15'b000001000000000: n8530_o = n8529_o;
      15'b000000100000000: n8530_o = n8529_o;
      15'b000000010000000: n8530_o = n8529_o;
      15'b000000001000000: n8530_o = sbc_v;
      15'b000000000100000: n8530_o = n8529_o;
      15'b000000000010000: n8530_o = n8529_o;
      15'b000000000001000: n8530_o = adc_v;
      15'b000000000000100: n8530_o = n8529_o;
      15'b000000000000010: n8530_o = n8529_o;
      15'b000000000000001: n8530_o = n8529_o;
      default: n8530_o = n8529_o;
    endcase
  assign n8532_o = p_in[7];
  /* ./T65/T65_ALU.vhd:194:5  */
  always @*
    case (n8526_o)
      15'b100000000000000: n8534_o = n8523_o;
      15'b010000000000000: n8534_o = n8519_o;
      15'b001000000000000: n8534_o = busa;
      15'b000100000000000: n8534_o = n8480_o;
      15'b000010000000000: n8534_o = n8472_o;
      15'b000001000000000: n8534_o = n8466_o;
      15'b000000100000000: n8534_o = n8460_o;
      15'b000000010000000: n8534_o = n8454_o;
      15'b000000001000000: n8534_o = sbc_q;
      15'b000000000100000: n8534_o = sbx_q;
      15'b000000000010000: n8534_o = busa;
      15'b000000000001000: n8534_o = adc_q;
      15'b000000000000100: n8534_o = n8441_o;
      15'b000000000000010: n8534_o = n8438_o;
      15'b000000000000001: n8534_o = n8435_o;
      default: n8534_o = busa;
    endcase
  /* ./T65/T65_ALU.vhd:194:5  */
  always @*
    case (n8526_o)
      15'b100000000000000: n8535_o = busa;
      15'b010000000000000: n8535_o = busa;
      15'b001000000000000: n8535_o = busa;
      15'b000100000000000: n8535_o = n8512_o;
      15'b000010000000000: n8535_o = busa;
      15'b000001000000000: n8535_o = busa;
      15'b000000100000000: n8535_o = busa;
      15'b000000010000000: n8535_o = busa;
      15'b000000001000000: n8535_o = busa;
      15'b000000000100000: n8535_o = busa;
      15'b000000000010000: n8535_o = busa;
      15'b000000000001000: n8535_o = busa;
      15'b000000000000100: n8535_o = busa;
      15'b000000000000010: n8535_o = busa;
      15'b000000000000001: n8535_o = busa;
      default: n8535_o = busa;
    endcase
  /* ./T65/T65_ALU.vhd:255:7  */
  assign n8537_o = op == 5'b00011;
  /* ./T65/T65_ALU.vhd:258:7  */
  assign n8539_o = op == 5'b00110;
  /* ./T65/T65_ALU.vhd:258:22  */
  assign n8541_o = op == 5'b00111;
  /* ./T65/T65_ALU.vhd:258:22  */
  assign n8542_o = n8539_o | n8541_o;
  /* ./T65/T65_ALU.vhd:258:33  */
  assign n8544_o = op == 5'b10001;
  /* ./T65/T65_ALU.vhd:258:33  */
  assign n8545_o = n8542_o | n8544_o;
  /* ./T65/T65_ALU.vhd:261:7  */
  assign n8547_o = op == 5'b00100;
  /* ./T65/T65_ALU.vhd:263:30  */
  assign n8548_o = busb[7];
  /* ./T65/T65_ALU.vhd:264:18  */
  assign n8549_o = busa & busb;
  /* ./T65/T65_ALU.vhd:264:28  */
  assign n8551_o = n8549_o == 8'b00000000;
  /* ./T65/T65_ALU.vhd:264:9  */
  assign n8554_o = n8551_o ? 1'b1 : 1'b0;
  /* ./T65/T65_ALU.vhd:262:7  */
  assign n8556_o = op == 5'b01100;
  /* ./T65/T65_ALU.vhd:270:29  */
  assign n8557_o = n8534_o[7];
  /* ./T65/T65_ALU.vhd:271:29  */
  assign n8558_o = n8534_o[7];
  /* ./T65/T65_ALU.vhd:272:16  */
  assign n8560_o = n8534_o == 8'b00000000;
  /* ./T65/T65_ALU.vhd:272:9  */
  assign n8563_o = n8560_o ? 1'b1 : 1'b0;
  /* ./T65/T65_ALU.vhd:269:7  */
  assign n8565_o = op == 5'b10000;
  /* ./T65/T65_ALU.vhd:278:29  */
  assign n8566_o = n8534_o[7];
  /* ./T65/T65_ALU.vhd:279:16  */
  assign n8568_o = n8534_o == 8'b00000000;
  /* ./T65/T65_ALU.vhd:279:9  */
  assign n8571_o = n8568_o ? 1'b1 : 1'b0;
  assign n8572_o = {n8565_o, n8556_o, n8547_o, n8545_o, n8537_o};
  /* ./T65/T65_ALU.vhd:254:5  */
  always @*
    case (n8572_o)
      5'b10000: n8573_o = n8558_o;
      5'b01000: n8573_o = n8528_o;
      5'b00100: n8573_o = n8528_o;
      5'b00010: n8573_o = n8528_o;
      5'b00001: n8573_o = n8528_o;
      default: n8573_o = n8528_o;
    endcase
  assign n8574_o = p_in[1];
  /* ./T65/T65_ALU.vhd:254:5  */
  always @*
    case (n8572_o)
      5'b10000: n8575_o = n8563_o;
      5'b01000: n8575_o = n8554_o;
      5'b00100: n8575_o = n8574_o;
      5'b00010: n8575_o = sbc_z;
      5'b00001: n8575_o = adc_z;
      default: n8575_o = n8571_o;
    endcase
  /* ./T65/T65_ALU.vhd:254:5  */
  always @*
    case (n8572_o)
      5'b10000: n8576_o = n8557_o;
      5'b01000: n8576_o = n8548_o;
      5'b00100: n8576_o = n8532_o;
      5'b00010: n8576_o = sbc_n;
      5'b00001: n8576_o = adc_n;
      default: n8576_o = n8566_o;
    endcase
  assign n8577_o = p_in[5:2];
  /* ./T65/T65_ALU.vhd:286:10  */
  assign n8579_o = op == 5'b01111;
  /* ./T65/T65_ALU.vhd:286:5  */
  assign n8580_o = n8579_o ? n8535_o : n8534_o;
  assign n8582_o = {n8576_o, n8530_o, n8577_o, n8575_o, n8573_o};
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
  wire [2:0] n6033_o;
  wire n6034_o;
  wire n6035_o;
  wire n6037_o;
  wire n6038_o;
  wire n6040_o;
  wire n6041_o;
  wire n6042_o;
  wire n6044_o;
  wire n6045_o;
  wire n6047_o;
  wire n6048_o;
  wire n6049_o;
  wire n6051_o;
  wire n6052_o;
  wire n6054_o;
  wire n6055_o;
  wire n6056_o;
  wire n6058_o;
  wire n6059_o;
  wire [6:0] n6060_o;
  reg n6061_o;
  wire [2:0] n6064_o;
  wire [1:0] n6065_o;
  wire [2:0] n6066_o;
  wire n6068_o;
  wire n6069_o;
  wire [3:0] n6072_o;
  wire [3:0] n6074_o;
  wire n6076_o;
  wire [2:0] n6077_o;
  wire n6079_o;
  wire n6080_o;
  wire [3:0] n6083_o;
  wire [3:0] n6085_o;
  wire n6087_o;
  wire [2:0] n6088_o;
  wire n6090_o;
  wire [3:0] n6093_o;
  wire n6096_o;
  wire [2:0] n6097_o;
  wire n6099_o;
  wire [2:0] n6100_o;
  wire n6102_o;
  wire n6103_o;
  wire [2:0] n6104_o;
  wire n6106_o;
  wire n6107_o;
  wire n6108_o;
  wire [3:0] n6111_o;
  wire [3:0] n6113_o;
  wire n6115_o;
  wire [2:0] n6116_o;
  reg [3:0] n6120_o;
  reg [3:0] n6122_o;
  reg n6124_o;
  wire n6126_o;
  wire [1:0] n6127_o;
  wire n6128_o;
  wire n6130_o;
  wire n6131_o;
  wire n6133_o;
  wire n6134_o;
  wire n6137_o;
  wire n6139_o;
  wire n6141_o;
  wire n6143_o;
  wire [2:0] n6144_o;
  wire n6146_o;
  wire [3:0] n6149_o;
  wire n6152_o;
  wire [2:0] n6153_o;
  reg [3:0] n6155_o;
  reg n6160_o;
  reg n6164_o;
  reg n6166_o;
  reg n6168_o;
  wire n6170_o;
  wire [1:0] n6171_o;
  wire n6172_o;
  wire n6173_o;
  wire n6176_o;
  wire n6178_o;
  reg [3:0] n6181_o;
  reg n6183_o;
  wire n6185_o;
  wire [1:0] n6186_o;
  wire n6187_o;
  wire n6188_o;
  wire n6191_o;
  wire n6193_o;
  reg [3:0] n6196_o;
  reg n6198_o;
  wire n6200_o;
  wire [3:0] n6201_o;
  reg [3:0] n6203_o;
  reg [3:0] n6206_o;
  reg n6209_o;
  reg n6212_o;
  reg n6215_o;
  reg n6218_o;
  wire [1:0] n6220_o;
  wire n6222_o;
  wire n6223_o;
  wire n6224_o;
  wire n6226_o;
  wire n6227_o;
  wire n6228_o;
  wire n6229_o;
  wire n6230_o;
  wire n6232_o;
  wire [3:0] n6235_o;
  wire [3:0] n6236_o;
  wire [4:0] n6237_o;
  wire n6239_o;
  wire n6241_o;
  wire n6243_o;
  wire n6245_o;
  wire n6247_o;
  wire n6249_o;
  wire [5:0] n6250_o;
  reg [1:0] n6257_o;
  reg [3:0] n6261_o;
  reg [1:0] n6264_o;
  reg n6269_o;
  reg n6272_o;
  reg n6277_o;
  wire n6279_o;
  wire n6281_o;
  wire n6283_o;
  wire n6285_o;
  wire n6287_o;
  wire n6289_o;
  wire [4:0] n6290_o;
  reg [1:0] n6295_o;
  reg [3:0] n6298_o;
  reg [1:0] n6302_o;
  reg n6306_o;
  reg n6309_o;
  reg n6313_o;
  wire n6315_o;
  wire n6317_o;
  wire n6319_o;
  wire n6321_o;
  wire n6323_o;
  wire n6325_o;
  wire [4:0] n6326_o;
  reg [3:0] n6328_o;
  reg [1:0] n6334_o;
  reg [1:0] n6337_o;
  reg n6342_o;
  reg n6345_o;
  reg n6348_o;
  wire n6350_o;
  wire n6352_o;
  wire n6354_o;
  wire n6356_o;
  wire n6358_o;
  wire n6360_o;
  wire [4:0] n6361_o;
  reg [1:0] n6366_o;
  reg [1:0] n6370_o;
  reg n6374_o;
  reg n6377_o;
  wire n6379_o;
  wire n6381_o;
  wire n6382_o;
  wire n6383_o;
  wire [2:0] n6386_o;
  wire n6389_o;
  wire n6390_o;
  wire n6391_o;
  wire n6392_o;
  wire [3:0] n6393_o;
  wire n6395_o;
  wire n6397_o;
  wire n6399_o;
  wire [3:0] n6401_o;
  wire n6404_o;
  wire n6406_o;
  wire n6408_o;
  wire [3:0] n6410_o;
  wire n6413_o;
  wire n6415_o;
  wire [3:0] n6416_o;
  reg [3:0] n6419_o;
  reg n6421_o;
  wire [1:0] n6425_o;
  wire [3:0] n6426_o;
  wire n6428_o;
  wire n6430_o;
  wire n6432_o;
  wire [1:0] n6433_o;
  reg [1:0] n6435_o;
  reg [3:0] n6436_o;
  reg n6439_o;
  reg n6441_o;
  wire n6443_o;
  wire n6445_o;
  wire n6446_o;
  wire n6448_o;
  wire n6449_o;
  wire n6451_o;
  wire n6452_o;
  wire n6454_o;
  wire n6455_o;
  wire n6456_o;
  wire [2:0] n6459_o;
  wire [3:0] n6461_o;
  wire n6463_o;
  wire n6465_o;
  wire n6467_o;
  wire n6469_o;
  wire n6471_o;
  wire n6473_o;
  wire n6475_o;
  wire n6477_o;
  wire [3:0] n6478_o;
  reg n6480_o;
  reg n6483_o;
  reg n6484_o;
  reg n6485_o;
  wire n6487_o;
  wire n6488_o;
  wire n6489_o;
  wire n6490_o;
  wire n6493_o;
  wire n6495_o;
  wire n6497_o;
  wire n6498_o;
  wire n6499_o;
  wire n6500_o;
  wire [1:0] n6503_o;
  wire n6505_o;
  wire n6507_o;
  wire n6509_o;
  wire n6511_o;
  wire [3:0] n6512_o;
  reg [3:0] n6514_o;
  reg [1:0] n6517_o;
  reg n6520_o;
  reg n6522_o;
  reg n6524_o;
  wire n6526_o;
  wire n6528_o;
  wire n6529_o;
  wire n6531_o;
  wire n6532_o;
  wire n6534_o;
  wire n6535_o;
  wire n6537_o;
  wire n6539_o;
  wire [1:0] n6540_o;
  reg [1:0] n6543_o;
  wire n6545_o;
  wire n6547_o;
  wire n6548_o;
  wire n6550_o;
  wire n6551_o;
  wire n6553_o;
  wire n6555_o;
  wire [1:0] n6556_o;
  reg [3:0] n6558_o;
  wire n6560_o;
  wire n6562_o;
  wire n6564_o;
  wire [1:0] n6565_o;
  reg [3:0] n6567_o;
  wire n6569_o;
  wire n6571_o;
  wire n6573_o;
  wire n6575_o;
  wire n6577_o;
  wire [1:0] n6578_o;
  reg [3:0] n6580_o;
  wire n6582_o;
  wire n6584_o;
  wire n6585_o;
  wire n6592_o;
  wire n6594_o;
  wire n6595_o;
  wire n6597_o;
  wire n6598_o;
  wire n6600_o;
  wire n6601_o;
  wire n6608_o;
  wire n6610_o;
  wire n6611_o;
  wire n6613_o;
  wire n6615_o;
  wire [1:0] n6616_o;
  reg [3:0] n6618_o;
  wire n6620_o;
  wire n6622_o;
  wire n6623_o;
  wire n6625_o;
  wire n6627_o;
  wire n6629_o;
  wire [1:0] n6630_o;
  reg [3:0] n6632_o;
  wire n6634_o;
  wire n6636_o;
  wire n6638_o;
  wire [1:0] n6639_o;
  reg [1:0] n6642_o;
  wire n6644_o;
  wire [15:0] n6647_o;
  reg [2:0] n6653_o;
  reg [3:0] n6655_o;
  reg [1:0] n6657_o;
  reg [3:0] n6658_o;
  reg [1:0] n6660_o;
  reg n6662_o;
  reg n6664_o;
  reg n6667_o;
  reg n6669_o;
  reg n6672_o;
  reg n6674_o;
  reg n6676_o;
  reg n6678_o;
  reg n6680_o;
  reg n6682_o;
  wire n6684_o;
  wire n6686_o;
  wire n6687_o;
  wire n6689_o;
  wire n6690_o;
  wire n6692_o;
  wire n6693_o;
  wire n6695_o;
  wire n6696_o;
  wire [1:0] n6697_o;
  wire n6699_o;
  wire n6701_o;
  wire n6702_o;
  wire n6703_o;
  wire [2:0] n6706_o;
  wire [2:0] n6708_o;
  wire n6711_o;
  wire n6713_o;
  wire n6715_o;
  wire n6717_o;
  wire [2:0] n6718_o;
  wire n6720_o;
  wire n6723_o;
  wire n6725_o;
  wire n6727_o;
  wire n6728_o;
  wire n6729_o;
  wire [1:0] n6730_o;
  wire n6732_o;
  wire n6733_o;
  wire [1:0] n6736_o;
  wire n6739_o;
  wire n6742_o;
  wire n6744_o;
  wire n6746_o;
  wire n6748_o;
  wire [6:0] n6749_o;
  reg [3:0] n6751_o;
  reg [1:0] n6758_o;
  reg [1:0] n6761_o;
  reg [1:0] n6764_o;
  reg n6767_o;
  reg n6769_o;
  reg n6772_o;
  reg n6775_o;
  reg n6778_o;
  reg n6781_o;
  reg n6784_o;
  reg n6787_o;
  reg n6790_o;
  wire n6792_o;
  wire n6794_o;
  wire n6795_o;
  wire [2:0] n6796_o;
  wire n6798_o;
  wire n6800_o;
  wire n6802_o;
  reg [1:0] n6805_o;
  wire n6807_o;
  wire n6809_o;
  wire [2:0] n6810_o;
  wire n6812_o;
  wire n6814_o;
  wire n6815_o;
  wire n6817_o;
  wire n6818_o;
  wire n6820_o;
  wire n6821_o;
  wire n6823_o;
  wire n6825_o;
  wire n6827_o;
  wire [3:0] n6828_o;
  reg [3:0] n6833_o;
  reg n6838_o;
  reg n6840_o;
  wire n6842_o;
  reg [1:0] n6845_o;
  wire [3:0] n6846_o;
  wire [1:0] n6848_o;
  wire n6849_o;
  wire n6850_o;
  wire n6852_o;
  wire n6854_o;
  wire n6856_o;
  wire [3:0] n6857_o;
  wire n6859_o;
  wire [3:0] n6860_o;
  wire n6862_o;
  wire n6863_o;
  wire [3:0] n6864_o;
  wire n6866_o;
  wire n6867_o;
  wire [1:0] n6870_o;
  wire [1:0] n6872_o;
  wire n6874_o;
  wire n6876_o;
  wire [1:0] n6877_o;
  reg [1:0] n6879_o;
  reg n6880_o;
  wire n6882_o;
  wire n6884_o;
  wire n6885_o;
  wire [2:0] n6886_o;
  wire n6888_o;
  wire n6891_o;
  wire n6893_o;
  wire [2:0] n6894_o;
  wire n6896_o;
  wire n6899_o;
  wire n6901_o;
  wire n6903_o;
  wire [2:0] n6904_o;
  reg [1:0] n6907_o;
  reg [1:0] n6910_o;
  reg n6913_o;
  reg n6915_o;
  reg n6917_o;
  wire n6919_o;
  wire [1:0] n6920_o;
  wire n6922_o;
  wire n6923_o;
  wire n6924_o;
  wire n6926_o;
  wire n6927_o;
  wire n6928_o;
  wire n6929_o;
  wire n6930_o;
  wire n6932_o;
  wire n6933_o;
  wire n6934_o;
  wire n6936_o;
  wire n6938_o;
  wire n6940_o;
  wire n6943_o;
  wire n6945_o;
  wire n6947_o;
  wire n6949_o;
  wire n6950_o;
  wire n6951_o;
  wire [3:0] n6953_o;
  wire n6956_o;
  wire n6959_o;
  wire n6961_o;
  wire [3:0] n6962_o;
  reg [3:0] n6963_o;
  reg [1:0] n6968_o;
  reg [1:0] n6971_o;
  reg n6974_o;
  reg n6977_o;
  reg n6980_o;
  reg n6983_o;
  reg n6986_o;
  reg n6988_o;
  wire [1:0] n6989_o;
  wire n6991_o;
  wire n6993_o;
  wire n6995_o;
  wire [2:0] n6996_o;
  wire n6998_o;
  wire n7001_o;
  wire n7003_o;
  wire n7005_o;
  wire [2:0] n7006_o;
  reg [1:0] n7009_o;
  reg [1:0] n7012_o;
  reg n7015_o;
  reg n7017_o;
  wire [2:0] n7020_o;
  wire [3:0] n7021_o;
  wire [1:0] n7022_o;
  wire [1:0] n7023_o;
  wire n7024_o;
  wire n7026_o;
  wire n7028_o;
  wire n7029_o;
  wire n7031_o;
  wire n7032_o;
  wire n7034_o;
  wire n7036_o;
  wire n7038_o;
  wire n7039_o;
  wire n7041_o;
  wire n7042_o;
  wire [1:0] n7043_o;
  wire n7045_o;
  wire [4:0] n7046_o;
  wire n7048_o;
  wire n7049_o;
  wire n7050_o;
  wire n7051_o;
  wire n7053_o;
  wire n7055_o;
  wire [1:0] n7056_o;
  reg [1:0] n7060_o;
  reg n7063_o;
  wire n7065_o;
  wire n7067_o;
  wire [1:0] n7070_o;
  wire n7072_o;
  wire [1:0] n7075_o;
  wire n7077_o;
  wire n7079_o;
  wire [1:0] n7082_o;
  wire [1:0] n7085_o;
  wire [1:0] n7088_o;
  wire n7090_o;
  wire n7092_o;
  wire [3:0] n7093_o;
  reg [1:0] n7095_o;
  reg [1:0] n7099_o;
  reg [1:0] n7101_o;
  reg n7105_o;
  reg n7108_o;
  reg n7111_o;
  wire [2:0] n7114_o;
  wire [1:0] n7116_o;
  wire [1:0] n7117_o;
  wire [1:0] n7119_o;
  wire n7120_o;
  wire n7122_o;
  wire n7124_o;
  wire [2:0] n7125_o;
  wire n7127_o;
  wire n7130_o;
  wire n7132_o;
  wire n7134_o;
  wire [2:0] n7135_o;
  wire n7137_o;
  wire n7140_o;
  wire n7142_o;
  wire n7144_o;
  wire [3:0] n7145_o;
  reg [1:0] n7148_o;
  reg [1:0] n7152_o;
  reg n7155_o;
  reg n7158_o;
  reg n7160_o;
  reg n7162_o;
  wire [2:0] n7164_o;
  wire [1:0] n7165_o;
  wire [1:0] n7166_o;
  wire [1:0] n7168_o;
  wire n7170_o;
  wire n7171_o;
  wire n7172_o;
  wire n7174_o;
  wire n7176_o;
  wire n7178_o;
  wire [1:0] n7179_o;
  wire n7181_o;
  wire n7182_o;
  wire n7183_o;
  wire n7185_o;
  wire n7186_o;
  wire n7187_o;
  wire n7188_o;
  wire n7189_o;
  wire n7191_o;
  wire n7192_o;
  wire n7193_o;
  wire n7195_o;
  wire n7197_o;
  wire n7199_o;
  wire n7201_o;
  wire n7204_o;
  wire n7206_o;
  wire n7208_o;
  wire n7210_o;
  wire n7211_o;
  wire n7212_o;
  wire [3:0] n7214_o;
  wire n7217_o;
  wire n7219_o;
  wire [4:0] n7220_o;
  reg [3:0] n7221_o;
  reg [1:0] n7226_o;
  reg [1:0] n7230_o;
  reg n7233_o;
  reg n7236_o;
  reg n7239_o;
  reg n7242_o;
  reg n7245_o;
  reg n7248_o;
  reg n7250_o;
  wire [1:0] n7251_o;
  wire n7253_o;
  wire n7255_o;
  wire n7257_o;
  wire n7259_o;
  wire [2:0] n7260_o;
  wire n7262_o;
  wire n7265_o;
  wire n7267_o;
  wire n7269_o;
  wire [3:0] n7270_o;
  reg [1:0] n7273_o;
  reg [1:0] n7277_o;
  reg n7280_o;
  reg n7283_o;
  reg n7285_o;
  wire [2:0] n7288_o;
  wire [3:0] n7289_o;
  wire [1:0] n7290_o;
  wire [1:0] n7291_o;
  wire n7292_o;
  wire n7294_o;
  wire n7296_o;
  wire n7297_o;
  wire n7298_o;
  wire n7300_o;
  wire n7301_o;
  wire n7303_o;
  wire n7305_o;
  wire n7307_o;
  wire n7308_o;
  wire n7310_o;
  wire n7311_o;
  wire [2:0] n7314_o;
  wire n7316_o;
  wire n7318_o;
  wire n7320_o;
  wire [2:0] n7321_o;
  reg [1:0] n7325_o;
  reg n7328_o;
  reg n7331_o;
  wire n7333_o;
  wire [1:0] n7334_o;
  wire n7336_o;
  wire n7338_o;
  wire n7339_o;
  wire n7340_o;
  wire [2:0] n7343_o;
  wire [2:0] n7345_o;
  wire n7348_o;
  wire n7350_o;
  wire n7352_o;
  wire n7354_o;
  wire [2:0] n7355_o;
  wire n7357_o;
  wire [3:0] n7358_o;
  wire n7360_o;
  wire [1:0] n7363_o;
  wire n7364_o;
  wire n7365_o;
  wire n7367_o;
  wire n7368_o;
  wire n7371_o;
  wire [1:0] n7373_o;
  wire n7375_o;
  wire n7378_o;
  wire n7380_o;
  wire n7382_o;
  wire n7383_o;
  wire n7384_o;
  wire [1:0] n7385_o;
  wire n7387_o;
  wire n7388_o;
  wire [1:0] n7391_o;
  wire n7394_o;
  wire n7397_o;
  wire n7399_o;
  wire n7401_o;
  wire n7403_o;
  wire [6:0] n7404_o;
  reg [3:0] n7407_o;
  reg [1:0] n7414_o;
  reg [1:0] n7417_o;
  reg [1:0] n7422_o;
  reg [1:0] n7424_o;
  reg n7426_o;
  reg n7428_o;
  reg n7431_o;
  reg n7434_o;
  reg n7437_o;
  reg n7440_o;
  reg n7443_o;
  reg n7446_o;
  reg n7449_o;
  wire n7451_o;
  wire n7453_o;
  wire n7454_o;
  wire [1:0] n7455_o;
  wire n7457_o;
  wire n7458_o;
  wire n7459_o;
  wire n7461_o;
  wire n7462_o;
  wire n7463_o;
  wire n7464_o;
  wire n7465_o;
  wire n7467_o;
  wire n7468_o;
  wire n7469_o;
  wire n7471_o;
  wire n7473_o;
  wire n7475_o;
  wire n7477_o;
  wire n7480_o;
  wire n7482_o;
  wire n7484_o;
  wire n7485_o;
  wire n7486_o;
  wire n7489_o;
  wire n7491_o;
  wire n7493_o;
  wire n7494_o;
  wire n7495_o;
  wire [3:0] n7497_o;
  wire n7500_o;
  wire n7502_o;
  wire [4:0] n7503_o;
  reg [3:0] n7504_o;
  reg [1:0] n7510_o;
  reg [1:0] n7513_o;
  reg n7516_o;
  reg n7519_o;
  reg n7522_o;
  reg n7525_o;
  reg n7528_o;
  reg n7531_o;
  reg n7533_o;
  wire [1:0] n7534_o;
  wire n7536_o;
  wire n7537_o;
  wire n7538_o;
  wire n7540_o;
  wire n7542_o;
  wire n7544_o;
  wire [2:0] n7545_o;
  wire n7547_o;
  wire n7550_o;
  wire [2:0] n7551_o;
  wire n7553_o;
  wire n7556_o;
  wire n7558_o;
  wire n7560_o;
  wire [3:0] n7561_o;
  reg [1:0] n7565_o;
  reg [1:0] n7568_o;
  reg n7571_o;
  reg n7573_o;
  reg n7576_o;
  reg n7578_o;
  wire [2:0] n7581_o;
  wire [3:0] n7582_o;
  wire [1:0] n7583_o;
  wire [1:0] n7584_o;
  wire n7585_o;
  wire n7587_o;
  wire n7588_o;
  wire n7590_o;
  wire n7592_o;
  wire n7593_o;
  wire n7595_o;
  wire n7596_o;
  wire n7598_o;
  wire n7600_o;
  wire n7602_o;
  wire n7603_o;
  wire n7605_o;
  wire n7606_o;
  wire n7608_o;
  wire n7609_o;
  wire [1:0] n7610_o;
  wire n7612_o;
  wire n7614_o;
  wire n7615_o;
  wire n7616_o;
  wire [2:0] n7619_o;
  wire [2:0] n7621_o;
  wire n7624_o;
  wire n7626_o;
  wire n7628_o;
  wire [2:0] n7629_o;
  wire n7631_o;
  wire [3:0] n7632_o;
  wire n7634_o;
  wire [1:0] n7637_o;
  wire n7638_o;
  wire n7639_o;
  wire n7641_o;
  wire n7642_o;
  wire n7645_o;
  wire [1:0] n7647_o;
  wire n7649_o;
  wire n7652_o;
  wire n7654_o;
  wire n7656_o;
  wire n7657_o;
  wire n7658_o;
  wire [1:0] n7659_o;
  wire n7661_o;
  wire n7662_o;
  wire [1:0] n7665_o;
  wire n7668_o;
  wire n7671_o;
  wire n7673_o;
  wire n7675_o;
  wire n7677_o;
  wire [5:0] n7678_o;
  reg [3:0] n7681_o;
  reg [1:0] n7686_o;
  reg [1:0] n7690_o;
  reg [1:0] n7694_o;
  reg [1:0] n7696_o;
  reg n7698_o;
  reg n7700_o;
  reg n7703_o;
  reg n7706_o;
  reg n7709_o;
  reg n7712_o;
  reg n7715_o;
  reg n7718_o;
  wire n7720_o;
  wire n7722_o;
  wire n7723_o;
  wire [1:0] n7724_o;
  wire n7726_o;
  wire n7727_o;
  wire n7728_o;
  wire n7730_o;
  wire n7731_o;
  wire n7732_o;
  wire n7733_o;
  wire n7734_o;
  wire n7736_o;
  wire n7737_o;
  wire n7738_o;
  wire n7740_o;
  wire n7742_o;
  wire n7744_o;
  wire n7746_o;
  wire n7748_o;
  wire n7751_o;
  wire n7753_o;
  wire n7755_o;
  wire n7757_o;
  wire n7758_o;
  wire n7759_o;
  wire [3:0] n7761_o;
  wire n7764_o;
  wire n7766_o;
  wire [5:0] n7767_o;
  reg [3:0] n7769_o;
  reg [1:0] n7775_o;
  reg [1:0] n7779_o;
  reg [1:0] n7783_o;
  reg n7786_o;
  reg n7789_o;
  reg n7792_o;
  reg n7795_o;
  reg n7798_o;
  reg n7801_o;
  reg n7803_o;
  wire [1:0] n7804_o;
  wire n7806_o;
  wire n7808_o;
  wire n7809_o;
  wire n7810_o;
  wire n7811_o;
  wire [1:0] n7812_o;
  wire n7814_o;
  wire n7815_o;
  wire n7817_o;
  wire n7818_o;
  wire n7820_o;
  wire n7822_o;
  wire [1:0] n7823_o;
  wire n7825_o;
  wire [3:0] n7826_o;
  wire n7828_o;
  wire n7829_o;
  wire [3:0] n7832_o;
  wire n7834_o;
  wire [2:0] n7835_o;
  wire n7837_o;
  wire [1:0] n7838_o;
  wire n7840_o;
  wire n7842_o;
  wire n7843_o;
  wire n7845_o;
  wire [1:0] n7846_o;
  reg [1:0] n7850_o;
  wire [1:0] n7852_o;
  wire n7855_o;
  wire n7858_o;
  wire n7860_o;
  wire n7862_o;
  wire [4:0] n7863_o;
  reg [3:0] n7864_o;
  reg [1:0] n7868_o;
  reg [1:0] n7872_o;
  reg [1:0] n7876_o;
  reg [1:0] n7878_o;
  reg n7880_o;
  reg n7883_o;
  reg n7886_o;
  reg n7888_o;
  wire [2:0] n7891_o;
  wire [3:0] n7892_o;
  wire [1:0] n7893_o;
  wire [1:0] n7894_o;
  wire [1:0] n7895_o;
  wire [1:0] n7897_o;
  wire n7899_o;
  wire n7900_o;
  wire n7902_o;
  wire n7904_o;
  wire n7905_o;
  wire n7906_o;
  wire n7908_o;
  wire n7909_o;
  wire n7911_o;
  wire n7913_o;
  wire n7915_o;
  wire n7916_o;
  wire n7918_o;
  wire n7919_o;
  wire n7921_o;
  wire n7922_o;
  wire [13:0] n7923_o;
  reg [2:0] n7926_o;
  reg [3:0] n7928_o;
  reg [1:0] n7930_o;
  reg [3:0] n7932_o;
  reg [1:0] n7934_o;
  reg [1:0] n7937_o;
  reg [1:0] n7940_o;
  reg n7943_o;
  reg n7946_o;
  reg n7949_o;
  reg n7952_o;
  reg n7955_o;
  reg n7958_o;
  reg n7960_o;
  reg n7962_o;
  reg n7964_o;
  reg n7965_o;
  reg n7966_o;
  reg n7968_o;
  reg n7971_o;
  reg n7974_o;
  reg n7977_o;
  reg n7980_o;
  reg n7983_o;
  reg n7986_o;
  reg n7989_o;
  wire [1:0] n7994_o;
  wire [2:0] n7995_o;
  wire [2:0] n7996_o;
  wire n7998_o;
  wire n8000_o;
  wire n8001_o;
  wire n8003_o;
  wire n8005_o;
  wire [2:0] n8006_o;
  reg [4:0] n8011_o;
  wire n8013_o;
  wire n8015_o;
  wire n8016_o;
  wire n8018_o;
  wire n8019_o;
  wire [2:0] n8020_o;
  wire n8022_o;
  wire n8024_o;
  wire n8025_o;
  wire n8027_o;
  wire [1:0] n8028_o;
  reg [4:0] n8032_o;
  wire n8034_o;
  wire [2:0] n8035_o;
  wire n8037_o;
  reg [4:0] n8040_o;
  wire n8042_o;
  wire [2:0] n8043_o;
  wire n8045_o;
  reg [4:0] n8048_o;
  wire [2:0] n8049_o;
  reg [4:0] n8050_o;
  wire n8052_o;
  wire [2:0] n8053_o;
  wire [30:0] n8054_o;
  wire n8056_o;
  wire n8058_o;
  wire n8060_o;
  wire n8062_o;
  wire n8064_o;
  wire n8066_o;
  wire n8068_o;
  wire [6:0] n8069_o;
  reg [4:0] n8078_o;
  wire n8080_o;
  wire [2:0] n8081_o;
  wire [30:0] n8082_o;
  wire [2:0] n8083_o;
  wire n8085_o;
  wire n8087_o;
  wire n8088_o;
  wire [4:0] n8091_o;
  wire n8094_o;
  wire [2:0] n8095_o;
  wire n8097_o;
  wire n8099_o;
  wire n8100_o;
  wire [4:0] n8103_o;
  wire n8106_o;
  wire n8108_o;
  wire n8110_o;
  wire [2:0] n8111_o;
  wire n8113_o;
  wire [4:0] n8116_o;
  wire n8119_o;
  wire n8121_o;
  wire n8123_o;
  wire [6:0] n8124_o;
  reg [4:0] n8130_o;
  wire n8132_o;
  wire [2:0] n8133_o;
  wire [30:0] n8134_o;
  wire n8136_o;
  wire [4:0] n8139_o;
  wire n8141_o;
  wire n8143_o;
  wire n8145_o;
  wire n8147_o;
  wire n8149_o;
  wire n8150_o;
  wire n8152_o;
  wire [2:0] n8153_o;
  wire [30:0] n8154_o;
  wire n8156_o;
  wire n8158_o;
  wire n8160_o;
  wire n8162_o;
  wire n8164_o;
  wire n8166_o;
  wire n8168_o;
  wire [6:0] n8169_o;
  reg [4:0] n8178_o;
  wire [2:0] n8179_o;
  wire [30:0] n8180_o;
  wire n8182_o;
  wire n8184_o;
  wire n8186_o;
  wire n8188_o;
  wire n8190_o;
  wire n8192_o;
  wire [2:0] n8193_o;
  wire n8195_o;
  wire [4:0] n8198_o;
  wire n8201_o;
  wire [6:0] n8202_o;
  reg [4:0] n8210_o;
  wire [4:0] n8211_o;
  wire [4:0] n8213_o;
  wire [4:0] n8215_o;
  wire [4:0] n8217_o;
  wire [4:0] n8219_o;
  reg [4:0] n8220_o;
  wire [2:0] n8221_o;
  reg [4:0] n8222_o;
  assign lcycle = n7926_o;
  assign alu_op = n8222_o;
  assign set_busa_to = n7928_o;
  assign set_addr_to = n7930_o;
  assign write_data = n7932_o;
  assign jump = n7934_o;
  assign baadd = n7937_o;
  assign baquirk = n7940_o;
  assign breakatna = n7943_o;
  assign adadd = n7946_o;
  assign addy = n7949_o;
  assign pcadd = n7952_o;
  assign inc_s = n7955_o;
  assign dec_s = n7958_o;
  assign lda = n7960_o;
  assign ldp = n7962_o;
  assign ldx = n7964_o;
  assign ldy = n7965_o;
  assign lds = n7966_o;
  assign lddi = n7968_o;
  assign ldalu = n7971_o;
  assign ldad = n7974_o;
  assign ldbal = n7977_o;
  assign ldbah = n7980_o;
  assign savep = n7983_o;
  assign write = n7986_o;
  /* ./T65/T65_MCode.vhd:96:10  */
  assign branch = n6061_o; // (signal)
  /* ./T65/T65_MCode.vhd:97:10  */
  assign alumore = n7989_o; // (signal)
  /* ./T65/T65_MCode.vhd:101:10  */
  assign n6033_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:102:20  */
  assign n6034_o = p[7];
  /* ./T65/T65_MCode.vhd:102:15  */
  assign n6035_o = ~n6034_o;
  /* ./T65/T65_MCode.vhd:102:29  */
  assign n6037_o = n6033_o == 3'b000;
  /* ./T65/T65_MCode.vhd:103:20  */
  assign n6038_o = p[7];
  /* ./T65/T65_MCode.vhd:103:29  */
  assign n6040_o = n6033_o == 3'b001;
  /* ./T65/T65_MCode.vhd:104:20  */
  assign n6041_o = p[6];
  /* ./T65/T65_MCode.vhd:104:15  */
  assign n6042_o = ~n6041_o;
  /* ./T65/T65_MCode.vhd:104:29  */
  assign n6044_o = n6033_o == 3'b010;
  /* ./T65/T65_MCode.vhd:105:20  */
  assign n6045_o = p[6];
  /* ./T65/T65_MCode.vhd:105:29  */
  assign n6047_o = n6033_o == 3'b011;
  /* ./T65/T65_MCode.vhd:106:20  */
  assign n6048_o = p[0];
  /* ./T65/T65_MCode.vhd:106:15  */
  assign n6049_o = ~n6048_o;
  /* ./T65/T65_MCode.vhd:106:29  */
  assign n6051_o = n6033_o == 3'b100;
  /* ./T65/T65_MCode.vhd:107:20  */
  assign n6052_o = p[0];
  /* ./T65/T65_MCode.vhd:107:29  */
  assign n6054_o = n6033_o == 3'b101;
  /* ./T65/T65_MCode.vhd:108:20  */
  assign n6055_o = p[1];
  /* ./T65/T65_MCode.vhd:108:15  */
  assign n6056_o = ~n6055_o;
  /* ./T65/T65_MCode.vhd:108:29  */
  assign n6058_o = n6033_o == 3'b110;
  /* ./T65/T65_MCode.vhd:109:20  */
  assign n6059_o = p[1];
  assign n6060_o = {n6058_o, n6054_o, n6051_o, n6047_o, n6044_o, n6040_o, n6037_o};
  /* ./T65/T65_MCode.vhd:101:3  */
  always @*
    case (n6060_o)
      7'b1000000: n6061_o = n6056_o;
      7'b0100000: n6061_o = n6052_o;
      7'b0010000: n6061_o = n6049_o;
      7'b0001000: n6061_o = n6045_o;
      7'b0000100: n6061_o = n6042_o;
      7'b0000010: n6061_o = n6038_o;
      7'b0000001: n6061_o = n6035_o;
      default: n6061_o = n6059_o;
    endcase
  /* ./T65/T65_MCode.vhd:140:12  */
  assign n6064_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:142:16  */
  assign n6065_o = ir[1:0];
  /* ./T65/T65_MCode.vhd:145:18  */
  assign n6066_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:145:30  */
  assign n6068_o = n6066_o == 3'b111;
  /* ./T65/T65_MCode.vhd:146:26  */
  assign n6069_o = ~rdy_mod;
  /* ./T65/T65_MCode.vhd:146:15  */
  assign n6072_o = n6069_o ? 4'b1011 : 4'b0011;
  /* ./T65/T65_MCode.vhd:145:13  */
  assign n6074_o = n6068_o ? n6072_o : 4'b0011;
  /* ./T65/T65_MCode.vhd:143:11  */
  assign n6076_o = n6065_o == 2'b00;
  /* ./T65/T65_MCode.vhd:156:18  */
  assign n6077_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:156:30  */
  assign n6079_o = n6077_o == 3'b111;
  /* ./T65/T65_MCode.vhd:157:26  */
  assign n6080_o = ~rdy_mod;
  /* ./T65/T65_MCode.vhd:157:15  */
  assign n6083_o = n6080_o ? 4'b1010 : 4'b0010;
  /* ./T65/T65_MCode.vhd:156:13  */
  assign n6085_o = n6079_o ? n6083_o : 4'b0010;
  /* ./T65/T65_MCode.vhd:154:11  */
  assign n6087_o = n6065_o == 2'b10;
  /* ./T65/T65_MCode.vhd:166:18  */
  assign n6088_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:166:30  */
  assign n6090_o = n6088_o == 3'b110;
  /* ./T65/T65_MCode.vhd:166:13  */
  assign n6093_o = n6090_o ? 4'b1001 : 4'b0001;
  /* ./T65/T65_MCode.vhd:166:13  */
  assign n6096_o = n6090_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:172:18  */
  assign n6097_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:172:30  */
  assign n6099_o = n6097_o == 3'b111;
  /* ./T65/T65_MCode.vhd:172:42  */
  assign n6100_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:172:54  */
  assign n6102_o = n6100_o == 3'b110;
  /* ./T65/T65_MCode.vhd:172:37  */
  assign n6103_o = n6099_o | n6102_o;
  /* ./T65/T65_MCode.vhd:172:66  */
  assign n6104_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:172:78  */
  assign n6106_o = n6104_o == 3'b100;
  /* ./T65/T65_MCode.vhd:172:61  */
  assign n6107_o = n6103_o | n6106_o;
  /* ./T65/T65_MCode.vhd:173:26  */
  assign n6108_o = ~rdy_mod;
  /* ./T65/T65_MCode.vhd:173:15  */
  assign n6111_o = n6108_o ? 4'b1001 : 4'b1000;
  /* ./T65/T65_MCode.vhd:172:13  */
  assign n6113_o = n6107_o ? n6111_o : 4'b1000;
  /* ./T65/T65_MCode.vhd:165:11  */
  assign n6115_o = n6065_o == 2'b11;
  assign n6116_o = {n6115_o, n6087_o, n6076_o};
  /* ./T65/T65_MCode.vhd:142:9  */
  always @*
    case (n6116_o)
      3'b100: n6120_o = n6093_o;
      3'b010: n6120_o = 4'b0010;
      3'b001: n6120_o = 4'b0011;
      default: n6120_o = 4'b0001;
    endcase
  /* ./T65/T65_MCode.vhd:142:9  */
  always @*
    case (n6116_o)
      3'b100: n6122_o = n6113_o;
      3'b010: n6122_o = n6085_o;
      3'b001: n6122_o = n6074_o;
      default: n6122_o = 4'b0001;
    endcase
  /* ./T65/T65_MCode.vhd:142:9  */
  always @*
    case (n6116_o)
      3'b100: n6124_o = n6096_o;
      3'b010: n6124_o = 1'b0;
      3'b001: n6124_o = 1'b0;
      default: n6124_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:141:7  */
  assign n6126_o = n6064_o == 3'b100;
  /* ./T65/T65_MCode.vhd:186:16  */
  assign n6127_o = ir[1:0];
  /* ./T65/T65_MCode.vhd:188:18  */
  assign n6128_o = ir[4];
  /* ./T65/T65_MCode.vhd:188:22  */
  assign n6130_o = n6128_o != 1'b1;
  /* ./T65/T65_MCode.vhd:188:34  */
  assign n6131_o = ir[2];
  /* ./T65/T65_MCode.vhd:188:38  */
  assign n6133_o = n6131_o != 1'b0;
  /* ./T65/T65_MCode.vhd:188:29  */
  assign n6134_o = n6130_o | n6133_o;
  /* ./T65/T65_MCode.vhd:188:13  */
  assign n6137_o = n6134_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:187:11  */
  assign n6139_o = n6127_o == 2'b00;
  /* ./T65/T65_MCode.vhd:191:11  */
  assign n6141_o = n6127_o == 2'b01;
  /* ./T65/T65_MCode.vhd:193:11  */
  assign n6143_o = n6127_o == 2'b10;
  /* ./T65/T65_MCode.vhd:198:18  */
  assign n6144_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:198:30  */
  assign n6146_o = n6144_o == 3'b110;
  /* ./T65/T65_MCode.vhd:198:13  */
  assign n6149_o = n6146_o ? 4'b0100 : 4'b0000;
  /* ./T65/T65_MCode.vhd:198:13  */
  assign n6152_o = n6146_o ? 1'b1 : 1'b0;
  assign n6153_o = {n6143_o, n6141_o, n6139_o};
  /* ./T65/T65_MCode.vhd:186:9  */
  always @*
    case (n6153_o)
      3'b100: n6155_o = 4'b0000;
      3'b010: n6155_o = 4'b0000;
      3'b001: n6155_o = 4'b0000;
      default: n6155_o = n6149_o;
    endcase
  /* ./T65/T65_MCode.vhd:186:9  */
  always @*
    case (n6153_o)
      3'b100: n6160_o = 1'b0;
      3'b010: n6160_o = 1'b1;
      3'b001: n6160_o = 1'b0;
      default: n6160_o = 1'b1;
    endcase
  /* ./T65/T65_MCode.vhd:186:9  */
  always @*
    case (n6153_o)
      3'b100: n6164_o = 1'b1;
      3'b010: n6164_o = 1'b0;
      3'b001: n6164_o = 1'b0;
      default: n6164_o = 1'b1;
    endcase
  /* ./T65/T65_MCode.vhd:186:9  */
  always @*
    case (n6153_o)
      3'b100: n6166_o = 1'b0;
      3'b010: n6166_o = 1'b0;
      3'b001: n6166_o = n6137_o;
      default: n6166_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:186:9  */
  always @*
    case (n6153_o)
      3'b100: n6168_o = 1'b0;
      3'b010: n6168_o = 1'b0;
      3'b001: n6168_o = 1'b0;
      default: n6168_o = n6152_o;
    endcase
  /* ./T65/T65_MCode.vhd:184:7  */
  assign n6170_o = n6064_o == 3'b101;
  /* ./T65/T65_MCode.vhd:204:16  */
  assign n6171_o = ir[1:0];
  /* ./T65/T65_MCode.vhd:206:18  */
  assign n6172_o = ir[4];
  /* ./T65/T65_MCode.vhd:206:22  */
  assign n6173_o = ~n6172_o;
  /* ./T65/T65_MCode.vhd:206:13  */
  assign n6176_o = n6173_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:205:11  */
  assign n6178_o = n6171_o == 2'b00;
  /* ./T65/T65_MCode.vhd:204:9  */
  always @*
    case (n6178_o)
      1'b1: n6181_o = 4'b0011;
      default: n6181_o = 4'b0001;
    endcase
  /* ./T65/T65_MCode.vhd:204:9  */
  always @*
    case (n6178_o)
      1'b1: n6183_o = n6176_o;
      default: n6183_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:203:7  */
  assign n6185_o = n6064_o == 3'b110;
  /* ./T65/T65_MCode.vhd:214:16  */
  assign n6186_o = ir[1:0];
  /* ./T65/T65_MCode.vhd:216:16  */
  assign n6187_o = ir[4];
  /* ./T65/T65_MCode.vhd:216:20  */
  assign n6188_o = ~n6187_o;
  /* ./T65/T65_MCode.vhd:216:11  */
  assign n6191_o = n6188_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:215:9  */
  assign n6193_o = n6186_o == 2'b00;
  /* ./T65/T65_MCode.vhd:214:9  */
  always @*
    case (n6193_o)
      1'b1: n6196_o = 4'b0010;
      default: n6196_o = 4'b0001;
    endcase
  /* ./T65/T65_MCode.vhd:214:9  */
  always @*
    case (n6193_o)
      1'b1: n6198_o = n6191_o;
      default: n6198_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:213:7  */
  assign n6200_o = n6064_o == 3'b111;
  assign n6201_o = {n6200_o, n6185_o, n6170_o, n6126_o};
  /* ./T65/T65_MCode.vhd:140:5  */
  always @*
    case (n6201_o)
      4'b1000: n6203_o = n6196_o;
      4'b0100: n6203_o = n6181_o;
      4'b0010: n6203_o = n6155_o;
      4'b0001: n6203_o = n6120_o;
      default: n6203_o = 4'b0001;
    endcase
  /* ./T65/T65_MCode.vhd:140:5  */
  always @*
    case (n6201_o)
      4'b1000: n6206_o = 4'b0000;
      4'b0100: n6206_o = 4'b0000;
      4'b0010: n6206_o = 4'b0000;
      4'b0001: n6206_o = n6122_o;
      default: n6206_o = 4'b0000;
    endcase
  /* ./T65/T65_MCode.vhd:140:5  */
  always @*
    case (n6201_o)
      4'b1000: n6209_o = 1'b0;
      4'b0100: n6209_o = 1'b0;
      4'b0010: n6209_o = n6160_o;
      4'b0001: n6209_o = 1'b0;
      default: n6209_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:140:5  */
  always @*
    case (n6201_o)
      4'b1000: n6212_o = n6198_o;
      4'b0100: n6212_o = 1'b0;
      4'b0010: n6212_o = n6164_o;
      4'b0001: n6212_o = 1'b0;
      default: n6212_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:140:5  */
  always @*
    case (n6201_o)
      4'b1000: n6215_o = 1'b0;
      4'b0100: n6215_o = n6183_o;
      4'b0010: n6215_o = n6166_o;
      4'b0001: n6215_o = 1'b0;
      default: n6215_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:140:5  */
  always @*
    case (n6201_o)
      4'b1000: n6218_o = 1'b0;
      4'b0100: n6218_o = 1'b0;
      4'b0010: n6218_o = n6168_o;
      4'b0001: n6218_o = n6124_o;
      default: n6218_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:226:10  */
  assign n6220_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:226:23  */
  assign n6222_o = n6220_o != 2'b10;
  /* ./T65/T65_MCode.vhd:226:37  */
  assign n6223_o = ir[1];
  /* ./T65/T65_MCode.vhd:226:31  */
  assign n6224_o = n6223_o & n6222_o;
  /* ./T65/T65_MCode.vhd:226:56  */
  assign n6226_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:226:67  */
  assign n6227_o = ir[0];
  /* ./T65/T65_MCode.vhd:226:70  */
  assign n6228_o = ~n6227_o;
  /* ./T65/T65_MCode.vhd:226:62  */
  assign n6229_o = n6226_o | n6228_o;
  /* ./T65/T65_MCode.vhd:226:47  */
  assign n6230_o = n6229_o & n6224_o;
  /* ./T65/T65_MCode.vhd:227:12  */
  assign n6232_o = ir == 8'b11101011;
  /* ./T65/T65_MCode.vhd:227:7  */
  assign n6235_o = n6232_o ? 4'b0001 : 4'b0000;
  /* ./T65/T65_MCode.vhd:226:5  */
  assign n6236_o = n6230_o ? n6235_o : n6203_o;
  /* ./T65/T65_MCode.vhd:234:12  */
  assign n6237_o = ir[4:0];
  /* ./T65/T65_MCode.vhd:247:15  */
  assign n6239_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:251:15  */
  assign n6241_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:256:15  */
  assign n6243_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:261:15  */
  assign n6245_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:264:15  */
  assign n6247_o = mcycle == 3'b101;
  /* ./T65/T65_MCode.vhd:267:15  */
  assign n6249_o = mcycle == 3'b110;
  assign n6250_o = {n6249_o, n6247_o, n6245_o, n6243_o, n6241_o, n6239_o};
  /* ./T65/T65_MCode.vhd:246:13  */
  always @*
    case (n6250_o)
      6'b100000: n6257_o = 2'b00;
      6'b010000: n6257_o = 2'b11;
      6'b001000: n6257_o = 2'b11;
      6'b000100: n6257_o = 2'b01;
      6'b000010: n6257_o = 2'b01;
      6'b000001: n6257_o = 2'b01;
      default: n6257_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:246:13  */
  always @*
    case (n6250_o)
      6'b100000: n6261_o = n6206_o;
      6'b010000: n6261_o = n6206_o;
      6'b001000: n6261_o = n6206_o;
      6'b000100: n6261_o = 4'b0101;
      6'b000010: n6261_o = 4'b0110;
      6'b000001: n6261_o = 4'b0111;
      default: n6261_o = n6206_o;
    endcase
  /* ./T65/T65_MCode.vhd:246:13  */
  always @*
    case (n6250_o)
      6'b100000: n6264_o = 2'b10;
      6'b010000: n6264_o = 2'b00;
      6'b001000: n6264_o = 2'b00;
      6'b000100: n6264_o = 2'b00;
      6'b000010: n6264_o = 2'b00;
      6'b000001: n6264_o = 2'b00;
      default: n6264_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:246:13  */
  always @*
    case (n6250_o)
      6'b100000: n6269_o = 1'b0;
      6'b010000: n6269_o = 1'b0;
      6'b001000: n6269_o = 1'b1;
      6'b000100: n6269_o = 1'b1;
      6'b000010: n6269_o = 1'b1;
      6'b000001: n6269_o = 1'b0;
      default: n6269_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:246:13  */
  always @*
    case (n6250_o)
      6'b100000: n6272_o = 1'b0;
      6'b010000: n6272_o = 1'b1;
      6'b001000: n6272_o = 1'b0;
      6'b000100: n6272_o = 1'b0;
      6'b000010: n6272_o = 1'b0;
      6'b000001: n6272_o = 1'b0;
      default: n6272_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:246:13  */
  always @*
    case (n6250_o)
      6'b100000: n6277_o = 1'b0;
      6'b010000: n6277_o = 1'b0;
      6'b001000: n6277_o = 1'b0;
      6'b000100: n6277_o = 1'b1;
      6'b000010: n6277_o = 1'b1;
      6'b000001: n6277_o = 1'b1;
      default: n6277_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:243:11  */
  assign n6279_o = ir == 8'b00000000;
  /* ./T65/T65_MCode.vhd:274:15  */
  assign n6281_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:278:15  */
  assign n6283_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:282:15  */
  assign n6285_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:287:15  */
  assign n6287_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:289:15  */
  assign n6289_o = mcycle == 3'b101;
  assign n6290_o = {n6289_o, n6287_o, n6285_o, n6283_o, n6281_o};
  /* ./T65/T65_MCode.vhd:273:13  */
  always @*
    case (n6290_o)
      5'b10000: n6295_o = 2'b00;
      5'b01000: n6295_o = 2'b00;
      5'b00100: n6295_o = 2'b01;
      5'b00010: n6295_o = 2'b01;
      5'b00001: n6295_o = 2'b01;
      default: n6295_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:273:13  */
  always @*
    case (n6290_o)
      5'b10000: n6298_o = n6206_o;
      5'b01000: n6298_o = n6206_o;
      5'b00100: n6298_o = 4'b0110;
      5'b00010: n6298_o = 4'b0111;
      5'b00001: n6298_o = n6206_o;
      default: n6298_o = n6206_o;
    endcase
  /* ./T65/T65_MCode.vhd:273:13  */
  always @*
    case (n6290_o)
      5'b10000: n6302_o = 2'b10;
      5'b01000: n6302_o = 2'b00;
      5'b00100: n6302_o = 2'b00;
      5'b00010: n6302_o = 2'b00;
      5'b00001: n6302_o = 2'b01;
      default: n6302_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:273:13  */
  always @*
    case (n6290_o)
      5'b10000: n6306_o = 1'b0;
      5'b01000: n6306_o = 1'b1;
      5'b00100: n6306_o = 1'b1;
      5'b00010: n6306_o = 1'b0;
      5'b00001: n6306_o = 1'b0;
      default: n6306_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:273:13  */
  always @*
    case (n6290_o)
      5'b10000: n6309_o = 1'b0;
      5'b01000: n6309_o = 1'b0;
      5'b00100: n6309_o = 1'b0;
      5'b00010: n6309_o = 1'b0;
      5'b00001: n6309_o = 1'b1;
      default: n6309_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:273:13  */
  always @*
    case (n6290_o)
      5'b10000: n6313_o = 1'b0;
      5'b01000: n6313_o = 1'b0;
      5'b00100: n6313_o = 1'b1;
      5'b00010: n6313_o = 1'b1;
      5'b00001: n6313_o = 1'b0;
      default: n6313_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:271:11  */
  assign n6315_o = ir == 8'b00100000;
  /* ./T65/T65_MCode.vhd:296:15  */
  assign n6317_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:298:15  */
  assign n6319_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:301:15  */
  assign n6321_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:305:15  */
  assign n6323_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:310:15  */
  assign n6325_o = mcycle == 3'b101;
  assign n6326_o = {n6325_o, n6323_o, n6321_o, n6319_o, n6317_o};
  /* ./T65/T65_MCode.vhd:295:15  */
  always @*
    case (n6326_o)
      5'b10000: n6328_o = n6236_o;
      5'b01000: n6328_o = n6236_o;
      5'b00100: n6328_o = 4'b0000;
      5'b00010: n6328_o = n6236_o;
      5'b00001: n6328_o = n6236_o;
      default: n6328_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:295:15  */
  always @*
    case (n6326_o)
      5'b10000: n6334_o = 2'b00;
      5'b01000: n6334_o = 2'b01;
      5'b00100: n6334_o = 2'b01;
      5'b00010: n6334_o = 2'b01;
      5'b00001: n6334_o = 2'b01;
      default: n6334_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:295:15  */
  always @*
    case (n6326_o)
      5'b10000: n6337_o = 2'b10;
      5'b01000: n6337_o = 2'b00;
      5'b00100: n6337_o = 2'b00;
      5'b00010: n6337_o = 2'b00;
      5'b00001: n6337_o = 2'b00;
      default: n6337_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:295:15  */
  always @*
    case (n6326_o)
      5'b10000: n6342_o = 1'b0;
      5'b01000: n6342_o = 1'b1;
      5'b00100: n6342_o = 1'b1;
      5'b00010: n6342_o = 1'b1;
      5'b00001: n6342_o = 1'b0;
      default: n6342_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:295:15  */
  always @*
    case (n6326_o)
      5'b10000: n6345_o = 1'b0;
      5'b01000: n6345_o = 1'b1;
      5'b00100: n6345_o = 1'b0;
      5'b00010: n6345_o = 1'b0;
      5'b00001: n6345_o = 1'b0;
      default: n6345_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:295:15  */
  always @*
    case (n6326_o)
      5'b10000: n6348_o = 1'b0;
      5'b01000: n6348_o = 1'b1;
      5'b00100: n6348_o = 1'b0;
      5'b00010: n6348_o = 1'b0;
      5'b00001: n6348_o = 1'b0;
      default: n6348_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:293:13  */
  assign n6350_o = ir == 8'b01000000;
  /* ./T65/T65_MCode.vhd:317:15  */
  assign n6352_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:319:15  */
  assign n6354_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:322:15  */
  assign n6356_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:326:15  */
  assign n6358_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:328:15  */
  assign n6360_o = mcycle == 3'b101;
  assign n6361_o = {n6360_o, n6358_o, n6356_o, n6354_o, n6352_o};
  /* ./T65/T65_MCode.vhd:316:13  */
  always @*
    case (n6361_o)
      5'b10000: n6366_o = 2'b00;
      5'b01000: n6366_o = 2'b00;
      5'b00100: n6366_o = 2'b01;
      5'b00010: n6366_o = 2'b01;
      5'b00001: n6366_o = 2'b01;
      default: n6366_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:316:13  */
  always @*
    case (n6361_o)
      5'b10000: n6370_o = 2'b01;
      5'b01000: n6370_o = 2'b10;
      5'b00100: n6370_o = 2'b00;
      5'b00010: n6370_o = 2'b00;
      5'b00001: n6370_o = 2'b00;
      default: n6370_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:316:13  */
  always @*
    case (n6361_o)
      5'b10000: n6374_o = 1'b0;
      5'b01000: n6374_o = 1'b0;
      5'b00100: n6374_o = 1'b1;
      5'b00010: n6374_o = 1'b1;
      5'b00001: n6374_o = 1'b0;
      default: n6374_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:316:13  */
  always @*
    case (n6361_o)
      5'b10000: n6377_o = 1'b0;
      5'b01000: n6377_o = 1'b0;
      5'b00100: n6377_o = 1'b1;
      5'b00010: n6377_o = 1'b0;
      5'b00001: n6377_o = 1'b0;
      default: n6377_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:314:11  */
  assign n6379_o = ir == 8'b01100000;
  /* ./T65/T65_MCode.vhd:334:23  */
  assign n6381_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:334:36  */
  assign n6382_o = ir[1];
  /* ./T65/T65_MCode.vhd:334:30  */
  assign n6383_o = n6382_o & n6381_o;
  /* ./T65/T65_MCode.vhd:334:15  */
  assign n6386_o = n6383_o ? 3'b001 : 3'b010;
  /* ./T65/T65_MCode.vhd:339:24  */
  assign n6389_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:339:36  */
  assign n6390_o = ir[1];
  /* ./T65/T65_MCode.vhd:339:39  */
  assign n6391_o = ~n6390_o;
  /* ./T65/T65_MCode.vhd:339:31  */
  assign n6392_o = n6389_o | n6391_o;
  /* ./T65/T65_MCode.vhd:341:26  */
  assign n6393_o = ir[7:4];
  /* ./T65/T65_MCode.vhd:342:19  */
  assign n6395_o = n6393_o == 4'b0000;
  /* ./T65/T65_MCode.vhd:344:19  */
  assign n6397_o = n6393_o == 4'b0100;
  /* ./T65/T65_MCode.vhd:347:29  */
  assign n6399_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:347:21  */
  assign n6401_o = n6399_o ? 4'b0011 : n6206_o;
  /* ./T65/T65_MCode.vhd:347:21  */
  assign n6404_o = n6399_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:346:19  */
  assign n6406_o = n6393_o == 4'b0101;
  /* ./T65/T65_MCode.vhd:353:29  */
  assign n6408_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:353:21  */
  assign n6410_o = n6408_o ? 4'b0010 : n6206_o;
  /* ./T65/T65_MCode.vhd:353:21  */
  assign n6413_o = n6408_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:352:19  */
  assign n6415_o = n6393_o == 4'b1101;
  assign n6416_o = {n6415_o, n6406_o, n6397_o, n6395_o};
  /* ./T65/T65_MCode.vhd:341:19  */
  always @*
    case (n6416_o)
      4'b1000: n6419_o = n6410_o;
      4'b0100: n6419_o = n6401_o;
      4'b0010: n6419_o = 4'b0001;
      4'b0001: n6419_o = 4'b0101;
      default: n6419_o = n6206_o;
    endcase
  /* ./T65/T65_MCode.vhd:341:19  */
  always @*
    case (n6416_o)
      4'b1000: n6421_o = n6413_o;
      4'b0100: n6421_o = n6404_o;
      4'b0010: n6421_o = 1'b1;
      4'b0001: n6421_o = 1'b1;
      default: n6421_o = 1'b1;
    endcase
  /* ./T65/T65_MCode.vhd:339:17  */
  assign n6425_o = n6392_o ? 2'b01 : 2'b00;
  /* ./T65/T65_MCode.vhd:339:17  */
  assign n6426_o = n6392_o ? n6419_o : n6206_o;
  /* ./T65/T65_MCode.vhd:339:17  */
  assign n6428_o = n6392_o ? n6421_o : 1'b0;
  /* ./T65/T65_MCode.vhd:338:15  */
  assign n6430_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:362:15  */
  assign n6432_o = mcycle == 3'b010;
  assign n6433_o = {n6432_o, n6430_o};
  /* ./T65/T65_MCode.vhd:337:15  */
  always @*
    case (n6433_o)
      2'b10: n6435_o = 2'b00;
      2'b01: n6435_o = n6425_o;
      default: n6435_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:337:15  */
  always @*
    case (n6433_o)
      2'b10: n6436_o = n6206_o;
      2'b01: n6436_o = n6426_o;
      default: n6436_o = n6206_o;
    endcase
  /* ./T65/T65_MCode.vhd:337:15  */
  always @*
    case (n6433_o)
      2'b10: n6439_o = 1'b1;
      2'b01: n6439_o = 1'b0;
      default: n6439_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:337:15  */
  always @*
    case (n6433_o)
      2'b10: n6441_o = 1'b0;
      2'b01: n6441_o = n6428_o;
      default: n6441_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:332:13  */
  assign n6443_o = ir == 8'b00001000;
  /* ./T65/T65_MCode.vhd:332:24  */
  assign n6445_o = ir == 8'b01001000;
  /* ./T65/T65_MCode.vhd:332:24  */
  assign n6446_o = n6443_o | n6445_o;
  /* ./T65/T65_MCode.vhd:332:32  */
  assign n6448_o = ir == 8'b01011010;
  /* ./T65/T65_MCode.vhd:332:32  */
  assign n6449_o = n6446_o | n6448_o;
  /* ./T65/T65_MCode.vhd:332:40  */
  assign n6451_o = ir == 8'b11011010;
  /* ./T65/T65_MCode.vhd:332:40  */
  assign n6452_o = n6449_o | n6451_o;
  /* ./T65/T65_MCode.vhd:368:21  */
  assign n6454_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:368:34  */
  assign n6455_o = ir[1];
  /* ./T65/T65_MCode.vhd:368:28  */
  assign n6456_o = n6455_o & n6454_o;
  /* ./T65/T65_MCode.vhd:368:13  */
  assign n6459_o = n6456_o ? 3'b001 : 3'b011;
  /* ./T65/T65_MCode.vhd:371:20  */
  assign n6461_o = ir[7:4];
  /* ./T65/T65_MCode.vhd:372:15  */
  assign n6463_o = n6461_o == 4'b0010;
  /* ./T65/T65_MCode.vhd:374:15  */
  assign n6465_o = n6461_o == 4'b0110;
  /* ./T65/T65_MCode.vhd:377:25  */
  assign n6467_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:377:17  */
  assign n6469_o = n6467_o ? 1'b1 : n6215_o;
  /* ./T65/T65_MCode.vhd:376:15  */
  assign n6471_o = n6461_o == 4'b0111;
  /* ./T65/T65_MCode.vhd:381:25  */
  assign n6473_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:381:17  */
  assign n6475_o = n6473_o ? 1'b1 : n6212_o;
  /* ./T65/T65_MCode.vhd:380:15  */
  assign n6477_o = n6461_o == 4'b1111;
  assign n6478_o = {n6477_o, n6471_o, n6465_o, n6463_o};
  /* ./T65/T65_MCode.vhd:371:13  */
  always @*
    case (n6478_o)
      4'b1000: n6480_o = n6209_o;
      4'b0100: n6480_o = n6209_o;
      4'b0010: n6480_o = 1'b1;
      4'b0001: n6480_o = n6209_o;
      default: n6480_o = n6209_o;
    endcase
  /* ./T65/T65_MCode.vhd:371:13  */
  always @*
    case (n6478_o)
      4'b1000: n6483_o = 1'b0;
      4'b0100: n6483_o = 1'b0;
      4'b0010: n6483_o = 1'b0;
      4'b0001: n6483_o = 1'b1;
      default: n6483_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:371:13  */
  always @*
    case (n6478_o)
      4'b1000: n6484_o = n6475_o;
      4'b0100: n6484_o = n6212_o;
      4'b0010: n6484_o = n6212_o;
      4'b0001: n6484_o = n6212_o;
      default: n6484_o = n6212_o;
    endcase
  /* ./T65/T65_MCode.vhd:371:13  */
  always @*
    case (n6478_o)
      4'b1000: n6485_o = n6215_o;
      4'b0100: n6485_o = n6469_o;
      4'b0010: n6485_o = n6215_o;
      4'b0001: n6485_o = n6215_o;
      default: n6485_o = n6215_o;
    endcase
  /* ./T65/T65_MCode.vhd:388:25  */
  assign n6487_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:388:38  */
  assign n6488_o = ir[1];
  /* ./T65/T65_MCode.vhd:388:42  */
  assign n6489_o = ~n6488_o;
  /* ./T65/T65_MCode.vhd:388:33  */
  assign n6490_o = n6487_o | n6489_o;
  /* ./T65/T65_MCode.vhd:388:17  */
  assign n6493_o = n6490_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:387:15  */
  assign n6495_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:392:25  */
  assign n6497_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:392:38  */
  assign n6498_o = ir[1];
  /* ./T65/T65_MCode.vhd:392:42  */
  assign n6499_o = ~n6498_o;
  /* ./T65/T65_MCode.vhd:392:33  */
  assign n6500_o = n6497_o | n6499_o;
  /* ./T65/T65_MCode.vhd:392:17  */
  assign n6503_o = n6500_o ? 2'b01 : 2'b00;
  /* ./T65/T65_MCode.vhd:392:17  */
  assign n6505_o = n6500_o ? 1'b0 : n6483_o;
  /* ./T65/T65_MCode.vhd:391:15  */
  assign n6507_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:396:15  */
  assign n6509_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:400:15  */
  assign n6511_o = mcycle == 3'b011;
  assign n6512_o = {n6511_o, n6509_o, n6507_o, n6495_o};
  /* ./T65/T65_MCode.vhd:386:13  */
  always @*
    case (n6512_o)
      4'b1000: n6514_o = 4'b0000;
      4'b0100: n6514_o = n6236_o;
      4'b0010: n6514_o = n6236_o;
      4'b0001: n6514_o = n6236_o;
      default: n6514_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:386:13  */
  always @*
    case (n6512_o)
      4'b1000: n6517_o = 2'b00;
      4'b0100: n6517_o = 2'b01;
      4'b0010: n6517_o = n6503_o;
      4'b0001: n6517_o = 2'b00;
      default: n6517_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:386:13  */
  always @*
    case (n6512_o)
      4'b1000: n6520_o = 1'b0;
      4'b0100: n6520_o = 1'b1;
      4'b0010: n6520_o = 1'b0;
      4'b0001: n6520_o = 1'b0;
      default: n6520_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:386:13  */
  always @*
    case (n6512_o)
      4'b1000: n6522_o = n6483_o;
      4'b0100: n6522_o = 1'b0;
      4'b0010: n6522_o = n6505_o;
      4'b0001: n6522_o = n6483_o;
      default: n6522_o = n6483_o;
    endcase
  /* ./T65/T65_MCode.vhd:386:13  */
  always @*
    case (n6512_o)
      4'b1000: n6524_o = 1'b0;
      4'b0100: n6524_o = 1'b0;
      4'b0010: n6524_o = 1'b0;
      4'b0001: n6524_o = n6493_o;
      default: n6524_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:366:11  */
  assign n6526_o = ir == 8'b00101000;
  /* ./T65/T65_MCode.vhd:366:23  */
  assign n6528_o = ir == 8'b01101000;
  /* ./T65/T65_MCode.vhd:366:23  */
  assign n6529_o = n6526_o | n6528_o;
  /* ./T65/T65_MCode.vhd:366:31  */
  assign n6531_o = ir == 8'b01111010;
  /* ./T65/T65_MCode.vhd:366:31  */
  assign n6532_o = n6529_o | n6531_o;
  /* ./T65/T65_MCode.vhd:366:39  */
  assign n6534_o = ir == 8'b11111010;
  /* ./T65/T65_MCode.vhd:366:39  */
  assign n6535_o = n6532_o | n6534_o;
  /* ./T65/T65_MCode.vhd:407:15  */
  assign n6537_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:408:15  */
  assign n6539_o = mcycle == 3'b001;
  assign n6540_o = {n6539_o, n6537_o};
  /* ./T65/T65_MCode.vhd:406:13  */
  always @*
    case (n6540_o)
      2'b10: n6543_o = 2'b01;
      2'b01: n6543_o = 2'b00;
      default: n6543_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:404:11  */
  assign n6545_o = ir == 8'b10100000;
  /* ./T65/T65_MCode.vhd:404:22  */
  assign n6547_o = ir == 8'b11000000;
  /* ./T65/T65_MCode.vhd:404:22  */
  assign n6548_o = n6545_o | n6547_o;
  /* ./T65/T65_MCode.vhd:404:30  */
  assign n6550_o = ir == 8'b11100000;
  /* ./T65/T65_MCode.vhd:404:30  */
  assign n6551_o = n6548_o | n6550_o;
  /* ./T65/T65_MCode.vhd:415:15  */
  assign n6553_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:416:15  */
  assign n6555_o = mcycle == 3'b001;
  assign n6556_o = {n6555_o, n6553_o};
  /* ./T65/T65_MCode.vhd:414:13  */
  always @*
    case (n6556_o)
      2'b10: n6558_o = 4'b0011;
      2'b01: n6558_o = n6236_o;
      default: n6558_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:412:11  */
  assign n6560_o = ir == 8'b10001000;
  /* ./T65/T65_MCode.vhd:423:15  */
  assign n6562_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:424:15  */
  assign n6564_o = mcycle == 3'b001;
  assign n6565_o = {n6564_o, n6562_o};
  /* ./T65/T65_MCode.vhd:422:13  */
  always @*
    case (n6565_o)
      2'b10: n6567_o = 4'b0010;
      2'b01: n6567_o = n6236_o;
      default: n6567_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:420:11  */
  assign n6569_o = ir == 8'b11001010;
  /* ./T65/T65_MCode.vhd:429:21  */
  assign n6571_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:429:13  */
  assign n6573_o = n6571_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:435:15  */
  assign n6575_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:436:15  */
  assign n6577_o = mcycle == 3'b001;
  assign n6578_o = {n6577_o, n6575_o};
  /* ./T65/T65_MCode.vhd:434:13  */
  always @*
    case (n6578_o)
      2'b10: n6580_o = 4'b0100;
      2'b01: n6580_o = n6236_o;
      default: n6580_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:428:11  */
  assign n6582_o = ir == 8'b00011010;
  /* ./T65/T65_MCode.vhd:428:22  */
  assign n6584_o = ir == 8'b00111010;
  /* ./T65/T65_MCode.vhd:428:22  */
  assign n6585_o = n6582_o | n6584_o;
  /* ./T65/T65_MCode.vhd:440:11  */
  assign n6592_o = ir == 8'b00001010;
  /* ./T65/T65_MCode.vhd:440:22  */
  assign n6594_o = ir == 8'b00101010;
  /* ./T65/T65_MCode.vhd:440:22  */
  assign n6595_o = n6592_o | n6594_o;
  /* ./T65/T65_MCode.vhd:440:30  */
  assign n6597_o = ir == 8'b01001010;
  /* ./T65/T65_MCode.vhd:440:30  */
  assign n6598_o = n6595_o | n6597_o;
  /* ./T65/T65_MCode.vhd:440:38  */
  assign n6600_o = ir == 8'b01101010;
  /* ./T65/T65_MCode.vhd:440:38  */
  assign n6601_o = n6598_o | n6600_o;
  /* ./T65/T65_MCode.vhd:448:11  */
  assign n6608_o = ir == 8'b10001010;
  /* ./T65/T65_MCode.vhd:448:22  */
  assign n6610_o = ir == 8'b10011000;
  /* ./T65/T65_MCode.vhd:448:22  */
  assign n6611_o = n6608_o | n6610_o;
  /* ./T65/T65_MCode.vhd:457:15  */
  assign n6613_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:458:15  */
  assign n6615_o = mcycle == 3'b001;
  assign n6616_o = {n6615_o, n6613_o};
  /* ./T65/T65_MCode.vhd:456:13  */
  always @*
    case (n6616_o)
      2'b10: n6618_o = 4'b0001;
      2'b01: n6618_o = n6236_o;
      default: n6618_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:455:11  */
  assign n6620_o = ir == 8'b10101010;
  /* ./T65/T65_MCode.vhd:455:22  */
  assign n6622_o = ir == 8'b10101000;
  /* ./T65/T65_MCode.vhd:455:22  */
  assign n6623_o = n6620_o | n6622_o;
  /* ./T65/T65_MCode.vhd:462:11  */
  assign n6625_o = ir == 8'b10011010;
  /* ./T65/T65_MCode.vhd:467:15  */
  assign n6627_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:468:15  */
  assign n6629_o = mcycle == 3'b001;
  assign n6630_o = {n6629_o, n6627_o};
  /* ./T65/T65_MCode.vhd:466:13  */
  always @*
    case (n6630_o)
      2'b10: n6632_o = 4'b0100;
      2'b01: n6632_o = n6236_o;
      default: n6632_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:464:11  */
  assign n6634_o = ir == 8'b10111010;
  /* ./T65/T65_MCode.vhd:474:15  */
  assign n6636_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:475:15  */
  assign n6638_o = mcycle == 3'b001;
  assign n6639_o = {n6638_o, n6636_o};
  /* ./T65/T65_MCode.vhd:473:13  */
  always @*
    case (n6639_o)
      2'b10: n6642_o = 2'b01;
      2'b01: n6642_o = 2'b00;
      default: n6642_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:472:11  */
  assign n6644_o = ir == 8'b10000000;
  assign n6647_o = {n6644_o, n6634_o, n6625_o, n6623_o, n6611_o, n6601_o, n6585_o, n6569_o, n6560_o, n6551_o, n6535_o, n6452_o, n6379_o, n6350_o, n6315_o, n6279_o};
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6653_o = 3'b001;
      16'b0100000000000000: n6653_o = 3'b001;
      16'b0010000000000000: n6653_o = 3'b001;
      16'b0001000000000000: n6653_o = 3'b001;
      16'b0000100000000000: n6653_o = 3'b001;
      16'b0000010000000000: n6653_o = 3'b001;
      16'b0000001000000000: n6653_o = 3'b001;
      16'b0000000100000000: n6653_o = 3'b001;
      16'b0000000010000000: n6653_o = 3'b001;
      16'b0000000001000000: n6653_o = 3'b001;
      16'b0000000000100000: n6653_o = n6459_o;
      16'b0000000000010000: n6653_o = n6386_o;
      16'b0000000000001000: n6653_o = 3'b101;
      16'b0000000000000100: n6653_o = 3'b101;
      16'b0000000000000010: n6653_o = 3'b101;
      16'b0000000000000001: n6653_o = 3'b110;
      default: n6653_o = 3'b001;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6655_o = n6236_o;
      16'b0100000000000000: n6655_o = n6632_o;
      16'b0010000000000000: n6655_o = n6236_o;
      16'b0001000000000000: n6655_o = n6618_o;
      16'b0000100000000000: n6655_o = n6236_o;
      16'b0000010000000000: n6655_o = 4'b0001;
      16'b0000001000000000: n6655_o = n6580_o;
      16'b0000000100000000: n6655_o = n6567_o;
      16'b0000000010000000: n6655_o = n6558_o;
      16'b0000000001000000: n6655_o = n6236_o;
      16'b0000000000100000: n6655_o = n6514_o;
      16'b0000000000010000: n6655_o = n6236_o;
      16'b0000000000001000: n6655_o = n6236_o;
      16'b0000000000000100: n6655_o = n6328_o;
      16'b0000000000000010: n6655_o = n6236_o;
      16'b0000000000000001: n6655_o = n6236_o;
      default: n6655_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6657_o = 2'b00;
      16'b0100000000000000: n6657_o = 2'b00;
      16'b0010000000000000: n6657_o = 2'b00;
      16'b0001000000000000: n6657_o = 2'b00;
      16'b0000100000000000: n6657_o = 2'b00;
      16'b0000010000000000: n6657_o = 2'b00;
      16'b0000001000000000: n6657_o = 2'b00;
      16'b0000000100000000: n6657_o = 2'b00;
      16'b0000000010000000: n6657_o = 2'b00;
      16'b0000000001000000: n6657_o = 2'b00;
      16'b0000000000100000: n6657_o = n6517_o;
      16'b0000000000010000: n6657_o = n6435_o;
      16'b0000000000001000: n6657_o = n6366_o;
      16'b0000000000000100: n6657_o = n6334_o;
      16'b0000000000000010: n6657_o = n6295_o;
      16'b0000000000000001: n6657_o = n6257_o;
      default: n6657_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6658_o = n6206_o;
      16'b0100000000000000: n6658_o = n6206_o;
      16'b0010000000000000: n6658_o = n6206_o;
      16'b0001000000000000: n6658_o = n6206_o;
      16'b0000100000000000: n6658_o = n6206_o;
      16'b0000010000000000: n6658_o = n6206_o;
      16'b0000001000000000: n6658_o = n6206_o;
      16'b0000000100000000: n6658_o = n6206_o;
      16'b0000000010000000: n6658_o = n6206_o;
      16'b0000000001000000: n6658_o = n6206_o;
      16'b0000000000100000: n6658_o = n6206_o;
      16'b0000000000010000: n6658_o = n6436_o;
      16'b0000000000001000: n6658_o = n6206_o;
      16'b0000000000000100: n6658_o = n6206_o;
      16'b0000000000000010: n6658_o = n6298_o;
      16'b0000000000000001: n6658_o = n6261_o;
      default: n6658_o = n6206_o;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6660_o = n6642_o;
      16'b0100000000000000: n6660_o = 2'b00;
      16'b0010000000000000: n6660_o = 2'b00;
      16'b0001000000000000: n6660_o = 2'b00;
      16'b0000100000000000: n6660_o = 2'b00;
      16'b0000010000000000: n6660_o = 2'b00;
      16'b0000001000000000: n6660_o = 2'b00;
      16'b0000000100000000: n6660_o = 2'b00;
      16'b0000000010000000: n6660_o = 2'b00;
      16'b0000000001000000: n6660_o = n6543_o;
      16'b0000000000100000: n6660_o = 2'b00;
      16'b0000000000010000: n6660_o = 2'b00;
      16'b0000000000001000: n6660_o = n6370_o;
      16'b0000000000000100: n6660_o = n6337_o;
      16'b0000000000000010: n6660_o = n6302_o;
      16'b0000000000000001: n6660_o = n6264_o;
      default: n6660_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6662_o = 1'b0;
      16'b0100000000000000: n6662_o = 1'b0;
      16'b0010000000000000: n6662_o = 1'b0;
      16'b0001000000000000: n6662_o = 1'b0;
      16'b0000100000000000: n6662_o = 1'b0;
      16'b0000010000000000: n6662_o = 1'b0;
      16'b0000001000000000: n6662_o = 1'b0;
      16'b0000000100000000: n6662_o = 1'b0;
      16'b0000000010000000: n6662_o = 1'b0;
      16'b0000000001000000: n6662_o = 1'b0;
      16'b0000000000100000: n6662_o = n6520_o;
      16'b0000000000010000: n6662_o = 1'b0;
      16'b0000000000001000: n6662_o = n6374_o;
      16'b0000000000000100: n6662_o = n6342_o;
      16'b0000000000000010: n6662_o = 1'b0;
      16'b0000000000000001: n6662_o = 1'b0;
      default: n6662_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6664_o = 1'b0;
      16'b0100000000000000: n6664_o = 1'b0;
      16'b0010000000000000: n6664_o = 1'b0;
      16'b0001000000000000: n6664_o = 1'b0;
      16'b0000100000000000: n6664_o = 1'b0;
      16'b0000010000000000: n6664_o = 1'b0;
      16'b0000001000000000: n6664_o = 1'b0;
      16'b0000000100000000: n6664_o = 1'b0;
      16'b0000000010000000: n6664_o = 1'b0;
      16'b0000000001000000: n6664_o = 1'b0;
      16'b0000000000100000: n6664_o = 1'b0;
      16'b0000000000010000: n6664_o = n6439_o;
      16'b0000000000001000: n6664_o = 1'b0;
      16'b0000000000000100: n6664_o = 1'b0;
      16'b0000000000000010: n6664_o = n6306_o;
      16'b0000000000000001: n6664_o = n6269_o;
      default: n6664_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6667_o = n6209_o;
      16'b0100000000000000: n6667_o = n6209_o;
      16'b0010000000000000: n6667_o = n6209_o;
      16'b0001000000000000: n6667_o = n6209_o;
      16'b0000100000000000: n6667_o = 1'b1;
      16'b0000010000000000: n6667_o = 1'b1;
      16'b0000001000000000: n6667_o = n6573_o;
      16'b0000000100000000: n6667_o = n6209_o;
      16'b0000000010000000: n6667_o = n6209_o;
      16'b0000000001000000: n6667_o = n6209_o;
      16'b0000000000100000: n6667_o = n6480_o;
      16'b0000000000010000: n6667_o = n6209_o;
      16'b0000000000001000: n6667_o = n6209_o;
      16'b0000000000000100: n6667_o = n6209_o;
      16'b0000000000000010: n6667_o = n6209_o;
      16'b0000000000000001: n6667_o = n6209_o;
      default: n6667_o = n6209_o;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6669_o = 1'b0;
      16'b0100000000000000: n6669_o = 1'b0;
      16'b0010000000000000: n6669_o = 1'b0;
      16'b0001000000000000: n6669_o = 1'b0;
      16'b0000100000000000: n6669_o = 1'b0;
      16'b0000010000000000: n6669_o = 1'b0;
      16'b0000001000000000: n6669_o = 1'b0;
      16'b0000000100000000: n6669_o = 1'b0;
      16'b0000000010000000: n6669_o = 1'b0;
      16'b0000000001000000: n6669_o = 1'b0;
      16'b0000000000100000: n6669_o = n6522_o;
      16'b0000000000010000: n6669_o = 1'b0;
      16'b0000000000001000: n6669_o = 1'b0;
      16'b0000000000000100: n6669_o = n6345_o;
      16'b0000000000000010: n6669_o = 1'b0;
      16'b0000000000000001: n6669_o = 1'b0;
      default: n6669_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6672_o = n6212_o;
      16'b0100000000000000: n6672_o = 1'b1;
      16'b0010000000000000: n6672_o = n6212_o;
      16'b0001000000000000: n6672_o = n6212_o;
      16'b0000100000000000: n6672_o = n6212_o;
      16'b0000010000000000: n6672_o = n6212_o;
      16'b0000001000000000: n6672_o = n6212_o;
      16'b0000000100000000: n6672_o = 1'b1;
      16'b0000000010000000: n6672_o = n6212_o;
      16'b0000000001000000: n6672_o = n6212_o;
      16'b0000000000100000: n6672_o = n6484_o;
      16'b0000000000010000: n6672_o = n6212_o;
      16'b0000000000001000: n6672_o = n6212_o;
      16'b0000000000000100: n6672_o = n6212_o;
      16'b0000000000000010: n6672_o = n6212_o;
      16'b0000000000000001: n6672_o = n6212_o;
      default: n6672_o = n6212_o;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6674_o = n6215_o;
      16'b0100000000000000: n6674_o = n6215_o;
      16'b0010000000000000: n6674_o = n6215_o;
      16'b0001000000000000: n6674_o = n6215_o;
      16'b0000100000000000: n6674_o = n6215_o;
      16'b0000010000000000: n6674_o = n6215_o;
      16'b0000001000000000: n6674_o = n6215_o;
      16'b0000000100000000: n6674_o = n6215_o;
      16'b0000000010000000: n6674_o = 1'b1;
      16'b0000000001000000: n6674_o = n6215_o;
      16'b0000000000100000: n6674_o = n6485_o;
      16'b0000000000010000: n6674_o = n6215_o;
      16'b0000000000001000: n6674_o = n6215_o;
      16'b0000000000000100: n6674_o = n6215_o;
      16'b0000000000000010: n6674_o = n6215_o;
      16'b0000000000000001: n6674_o = n6215_o;
      default: n6674_o = n6215_o;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6676_o = n6218_o;
      16'b0100000000000000: n6676_o = n6218_o;
      16'b0010000000000000: n6676_o = 1'b1;
      16'b0001000000000000: n6676_o = n6218_o;
      16'b0000100000000000: n6676_o = n6218_o;
      16'b0000010000000000: n6676_o = n6218_o;
      16'b0000001000000000: n6676_o = n6218_o;
      16'b0000000100000000: n6676_o = n6218_o;
      16'b0000000010000000: n6676_o = n6218_o;
      16'b0000000001000000: n6676_o = n6218_o;
      16'b0000000000100000: n6676_o = n6218_o;
      16'b0000000000010000: n6676_o = n6218_o;
      16'b0000000000001000: n6676_o = n6218_o;
      16'b0000000000000100: n6676_o = n6218_o;
      16'b0000000000000010: n6676_o = n6218_o;
      16'b0000000000000001: n6676_o = n6218_o;
      default: n6676_o = n6218_o;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6678_o = 1'b0;
      16'b0100000000000000: n6678_o = 1'b0;
      16'b0010000000000000: n6678_o = 1'b0;
      16'b0001000000000000: n6678_o = 1'b0;
      16'b0000100000000000: n6678_o = 1'b0;
      16'b0000010000000000: n6678_o = 1'b0;
      16'b0000001000000000: n6678_o = 1'b0;
      16'b0000000100000000: n6678_o = 1'b0;
      16'b0000000010000000: n6678_o = 1'b0;
      16'b0000000001000000: n6678_o = 1'b0;
      16'b0000000000100000: n6678_o = 1'b0;
      16'b0000000000010000: n6678_o = 1'b0;
      16'b0000000000001000: n6678_o = n6377_o;
      16'b0000000000000100: n6678_o = n6348_o;
      16'b0000000000000010: n6678_o = n6309_o;
      16'b0000000000000001: n6678_o = n6272_o;
      default: n6678_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6680_o = 1'b0;
      16'b0100000000000000: n6680_o = 1'b0;
      16'b0010000000000000: n6680_o = 1'b0;
      16'b0001000000000000: n6680_o = 1'b0;
      16'b0000100000000000: n6680_o = 1'b0;
      16'b0000010000000000: n6680_o = 1'b0;
      16'b0000001000000000: n6680_o = 1'b0;
      16'b0000000100000000: n6680_o = 1'b0;
      16'b0000000010000000: n6680_o = 1'b0;
      16'b0000000001000000: n6680_o = 1'b0;
      16'b0000000000100000: n6680_o = n6524_o;
      16'b0000000000010000: n6680_o = 1'b0;
      16'b0000000000001000: n6680_o = 1'b0;
      16'b0000000000000100: n6680_o = 1'b0;
      16'b0000000000000010: n6680_o = 1'b0;
      16'b0000000000000001: n6680_o = 1'b0;
      default: n6680_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:242:9  */
  always @*
    case (n6647_o)
      16'b1000000000000000: n6682_o = 1'b0;
      16'b0100000000000000: n6682_o = 1'b0;
      16'b0010000000000000: n6682_o = 1'b0;
      16'b0001000000000000: n6682_o = 1'b0;
      16'b0000100000000000: n6682_o = 1'b0;
      16'b0000010000000000: n6682_o = 1'b0;
      16'b0000001000000000: n6682_o = 1'b0;
      16'b0000000100000000: n6682_o = 1'b0;
      16'b0000000010000000: n6682_o = 1'b0;
      16'b0000000001000000: n6682_o = 1'b0;
      16'b0000000000100000: n6682_o = 1'b0;
      16'b0000000000010000: n6682_o = n6441_o;
      16'b0000000000001000: n6682_o = 1'b0;
      16'b0000000000000100: n6682_o = 1'b0;
      16'b0000000000000010: n6682_o = n6313_o;
      16'b0000000000000001: n6682_o = n6277_o;
      default: n6682_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:240:7  */
  assign n6684_o = n6237_o == 5'b00000;
  /* ./T65/T65_MCode.vhd:240:20  */
  assign n6686_o = n6237_o == 5'b01000;
  /* ./T65/T65_MCode.vhd:240:20  */
  assign n6687_o = n6684_o | n6686_o;
  /* ./T65/T65_MCode.vhd:240:30  */
  assign n6689_o = n6237_o == 5'b01010;
  /* ./T65/T65_MCode.vhd:240:30  */
  assign n6690_o = n6687_o | n6689_o;
  /* ./T65/T65_MCode.vhd:240:40  */
  assign n6692_o = n6237_o == 5'b11000;
  /* ./T65/T65_MCode.vhd:240:40  */
  assign n6693_o = n6690_o | n6692_o;
  /* ./T65/T65_MCode.vhd:240:50  */
  assign n6695_o = n6237_o == 5'b11010;
  /* ./T65/T65_MCode.vhd:240:50  */
  assign n6696_o = n6693_o | n6695_o;
  /* ./T65/T65_MCode.vhd:491:14  */
  assign n6697_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:491:27  */
  assign n6699_o = n6697_o != 2'b10;
  /* ./T65/T65_MCode.vhd:493:18  */
  assign n6701_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:493:30  */
  assign n6702_o = ir[1];
  /* ./T65/T65_MCode.vhd:493:24  */
  assign n6703_o = n6702_o & n6701_o;
  /* ./T65/T65_MCode.vhd:493:11  */
  assign n6706_o = n6703_o ? 3'b111 : 3'b101;
  /* ./T65/T65_MCode.vhd:491:9  */
  assign n6708_o = n6699_o ? n6706_o : 3'b101;
  /* ./T65/T65_MCode.vhd:491:9  */
  assign n6711_o = n6699_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:498:11  */
  assign n6713_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:502:11  */
  assign n6715_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:505:11  */
  assign n6717_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:511:18  */
  assign n6718_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:511:31  */
  assign n6720_o = n6718_o == 3'b100;
  /* ./T65/T65_MCode.vhd:511:13  */
  assign n6723_o = n6720_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:509:11  */
  assign n6725_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:516:20  */
  assign n6727_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:516:32  */
  assign n6728_o = ir[1];
  /* ./T65/T65_MCode.vhd:516:26  */
  assign n6729_o = n6728_o & n6727_o;
  /* ./T65/T65_MCode.vhd:516:46  */
  assign n6730_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:516:58  */
  assign n6732_o = n6730_o != 2'b10;
  /* ./T65/T65_MCode.vhd:516:40  */
  assign n6733_o = n6732_o & n6729_o;
  /* ./T65/T65_MCode.vhd:516:13  */
  assign n6736_o = n6733_o ? 2'b11 : 2'b00;
  /* ./T65/T65_MCode.vhd:516:13  */
  assign n6739_o = n6733_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:516:13  */
  assign n6742_o = n6733_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:515:11  */
  assign n6744_o = mcycle == 3'b101;
  /* ./T65/T65_MCode.vhd:521:11  */
  assign n6746_o = mcycle == 3'b110;
  /* ./T65/T65_MCode.vhd:526:11  */
  assign n6748_o = mcycle == 3'b111;
  assign n6749_o = {n6748_o, n6746_o, n6744_o, n6725_o, n6717_o, n6715_o, n6713_o};
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6751_o = 4'b0001;
      7'b0100000: n6751_o = n6236_o;
      7'b0010000: n6751_o = n6236_o;
      7'b0001000: n6751_o = n6236_o;
      7'b0000100: n6751_o = n6236_o;
      7'b0000010: n6751_o = n6236_o;
      7'b0000001: n6751_o = n6236_o;
      default: n6751_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6758_o = 2'b00;
      7'b0100000: n6758_o = 2'b11;
      7'b0010000: n6758_o = n6736_o;
      7'b0001000: n6758_o = 2'b11;
      7'b0000100: n6758_o = 2'b10;
      7'b0000010: n6758_o = 2'b10;
      7'b0000001: n6758_o = 2'b10;
      default: n6758_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6761_o = 2'b00;
      7'b0100000: n6761_o = 2'b00;
      7'b0010000: n6761_o = 2'b00;
      7'b0001000: n6761_o = 2'b00;
      7'b0000100: n6761_o = 2'b00;
      7'b0000010: n6761_o = 2'b00;
      7'b0000001: n6761_o = 2'b01;
      default: n6761_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6764_o = 2'b00;
      7'b0100000: n6764_o = 2'b00;
      7'b0010000: n6764_o = 2'b00;
      7'b0001000: n6764_o = 2'b00;
      7'b0000100: n6764_o = 2'b01;
      7'b0000010: n6764_o = 2'b00;
      7'b0000001: n6764_o = 2'b00;
      default: n6764_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6767_o = 1'b0;
      7'b0100000: n6767_o = 1'b0;
      7'b0010000: n6767_o = 1'b0;
      7'b0001000: n6767_o = 1'b0;
      7'b0000100: n6767_o = 1'b0;
      7'b0000010: n6767_o = 1'b1;
      7'b0000001: n6767_o = 1'b0;
      default: n6767_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6769_o = 1'b0;
      7'b0100000: n6769_o = 1'b0;
      7'b0010000: n6769_o = n6739_o;
      7'b0001000: n6769_o = 1'b0;
      7'b0000100: n6769_o = 1'b0;
      7'b0000010: n6769_o = 1'b0;
      7'b0000001: n6769_o = 1'b0;
      default: n6769_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6772_o = 1'b0;
      7'b0100000: n6772_o = 1'b1;
      7'b0010000: n6772_o = 1'b0;
      7'b0001000: n6772_o = 1'b0;
      7'b0000100: n6772_o = 1'b0;
      7'b0000010: n6772_o = 1'b0;
      7'b0000001: n6772_o = 1'b0;
      default: n6772_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6775_o = 1'b0;
      7'b0100000: n6775_o = 1'b0;
      7'b0010000: n6775_o = 1'b0;
      7'b0001000: n6775_o = 1'b0;
      7'b0000100: n6775_o = 1'b0;
      7'b0000010: n6775_o = 1'b0;
      7'b0000001: n6775_o = 1'b1;
      default: n6775_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6778_o = 1'b0;
      7'b0100000: n6778_o = 1'b0;
      7'b0010000: n6778_o = 1'b0;
      7'b0001000: n6778_o = 1'b0;
      7'b0000100: n6778_o = 1'b1;
      7'b0000010: n6778_o = 1'b0;
      7'b0000001: n6778_o = 1'b0;
      default: n6778_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6781_o = 1'b0;
      7'b0100000: n6781_o = 1'b0;
      7'b0010000: n6781_o = 1'b0;
      7'b0001000: n6781_o = 1'b1;
      7'b0000100: n6781_o = 1'b0;
      7'b0000010: n6781_o = 1'b0;
      7'b0000001: n6781_o = 1'b0;
      default: n6781_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6784_o = 1'b0;
      7'b0100000: n6784_o = 1'b1;
      7'b0010000: n6784_o = 1'b0;
      7'b0001000: n6784_o = 1'b0;
      7'b0000100: n6784_o = 1'b0;
      7'b0000010: n6784_o = 1'b0;
      7'b0000001: n6784_o = 1'b0;
      default: n6784_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6787_o = 1'b0;
      7'b0100000: n6787_o = 1'b1;
      7'b0010000: n6787_o = n6742_o;
      7'b0001000: n6787_o = n6723_o;
      7'b0000100: n6787_o = 1'b0;
      7'b0000010: n6787_o = 1'b0;
      7'b0000001: n6787_o = 1'b0;
      default: n6787_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:497:9  */
  always @*
    case (n6749_o)
      7'b1000000: n6790_o = 1'b1;
      7'b0100000: n6790_o = 1'b0;
      7'b0010000: n6790_o = 1'b0;
      7'b0001000: n6790_o = 1'b0;
      7'b0000100: n6790_o = 1'b0;
      7'b0000010: n6790_o = 1'b0;
      7'b0000001: n6790_o = 1'b0;
      default: n6790_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:488:7  */
  assign n6792_o = n6237_o == 5'b00001;
  /* ./T65/T65_MCode.vhd:488:20  */
  assign n6794_o = n6237_o == 5'b00011;
  /* ./T65/T65_MCode.vhd:488:20  */
  assign n6795_o = n6792_o | n6794_o;
  /* ./T65/T65_MCode.vhd:535:14  */
  assign n6796_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:535:26  */
  assign n6798_o = n6796_o != 3'b100;
  /* ./T65/T65_MCode.vhd:535:9  */
  assign n6800_o = n6798_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:539:11  */
  assign n6802_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:538:9  */
  always @*
    case (n6802_o)
      1'b1: n6805_o = 2'b01;
      default: n6805_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:533:7  */
  assign n6807_o = n6237_o == 5'b01001;
  /* ./T65/T65_MCode.vhd:546:16  */
  assign n6809_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:548:18  */
  assign n6810_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:549:13  */
  assign n6812_o = n6810_o == 3'b010;
  /* ./T65/T65_MCode.vhd:549:23  */
  assign n6814_o = n6810_o == 3'b011;
  /* ./T65/T65_MCode.vhd:549:23  */
  assign n6815_o = n6812_o | n6814_o;
  /* ./T65/T65_MCode.vhd:549:29  */
  assign n6817_o = n6810_o == 3'b000;
  /* ./T65/T65_MCode.vhd:549:29  */
  assign n6818_o = n6815_o | n6817_o;
  /* ./T65/T65_MCode.vhd:549:35  */
  assign n6820_o = n6810_o == 3'b001;
  /* ./T65/T65_MCode.vhd:549:35  */
  assign n6821_o = n6818_o | n6820_o;
  /* ./T65/T65_MCode.vhd:552:13  */
  assign n6823_o = n6810_o == 3'b100;
  /* ./T65/T65_MCode.vhd:555:13  */
  assign n6825_o = n6810_o == 3'b110;
  /* ./T65/T65_MCode.vhd:558:13  */
  assign n6827_o = n6810_o == 3'b101;
  assign n6828_o = {n6827_o, n6825_o, n6823_o, n6821_o};
  /* ./T65/T65_MCode.vhd:548:11  */
  always @*
    case (n6828_o)
      4'b1000: n6833_o = 4'b0111;
      4'b0100: n6833_o = 4'b1001;
      4'b0010: n6833_o = 4'b1000;
      4'b0001: n6833_o = 4'b0110;
      default: n6833_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:548:11  */
  always @*
    case (n6828_o)
      4'b1000: n6838_o = 1'b1;
      4'b0100: n6838_o = n6209_o;
      4'b0010: n6838_o = 1'b1;
      4'b0001: n6838_o = 1'b1;
      default: n6838_o = 1'b1;
    endcase
  /* ./T65/T65_MCode.vhd:548:11  */
  always @*
    case (n6828_o)
      4'b1000: n6840_o = n6212_o;
      4'b0100: n6840_o = 1'b1;
      4'b0010: n6840_o = n6212_o;
      4'b0001: n6840_o = n6212_o;
      default: n6840_o = n6212_o;
    endcase
  /* ./T65/T65_MCode.vhd:565:13  */
  assign n6842_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:564:11  */
  always @*
    case (n6842_o)
      1'b1: n6845_o = 2'b01;
      default: n6845_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:546:9  */
  assign n6846_o = n6809_o ? n6833_o : n6236_o;
  /* ./T65/T65_MCode.vhd:546:9  */
  assign n6848_o = n6809_o ? n6845_o : 2'b00;
  /* ./T65/T65_MCode.vhd:546:9  */
  assign n6849_o = n6809_o ? n6838_o : n6209_o;
  /* ./T65/T65_MCode.vhd:546:9  */
  assign n6850_o = n6809_o ? n6840_o : n6212_o;
  /* ./T65/T65_MCode.vhd:545:7  */
  assign n6852_o = n6237_o == 5'b01011;
  /* ./T65/T65_MCode.vhd:576:11  */
  assign n6854_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:578:19  */
  assign n6856_o = ir == 8'b10100010;
  /* ./T65/T65_MCode.vhd:582:21  */
  assign n6857_o = ir[7:4];
  /* ./T65/T65_MCode.vhd:582:33  */
  assign n6859_o = n6857_o == 4'b1000;
  /* ./T65/T65_MCode.vhd:582:46  */
  assign n6860_o = ir[7:4];
  /* ./T65/T65_MCode.vhd:582:58  */
  assign n6862_o = n6860_o == 4'b1100;
  /* ./T65/T65_MCode.vhd:582:41  */
  assign n6863_o = n6859_o | n6862_o;
  /* ./T65/T65_MCode.vhd:582:71  */
  assign n6864_o = ir[7:4];
  /* ./T65/T65_MCode.vhd:582:83  */
  assign n6866_o = n6864_o == 4'b1110;
  /* ./T65/T65_MCode.vhd:582:66  */
  assign n6867_o = n6863_o | n6866_o;
  /* ./T65/T65_MCode.vhd:582:13  */
  assign n6870_o = n6867_o ? 2'b01 : 2'b00;
  /* ./T65/T65_MCode.vhd:578:13  */
  assign n6872_o = n6856_o ? 2'b01 : n6870_o;
  /* ./T65/T65_MCode.vhd:578:13  */
  assign n6874_o = n6856_o ? 1'b1 : n6212_o;
  /* ./T65/T65_MCode.vhd:577:11  */
  assign n6876_o = mcycle == 3'b001;
  assign n6877_o = {n6876_o, n6854_o};
  /* ./T65/T65_MCode.vhd:575:9  */
  always @*
    case (n6877_o)
      2'b10: n6879_o = n6872_o;
      2'b01: n6879_o = 2'b00;
      default: n6879_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:575:9  */
  always @*
    case (n6877_o)
      2'b10: n6880_o = n6874_o;
      2'b01: n6880_o = n6212_o;
      default: n6880_o = n6212_o;
    endcase
  /* ./T65/T65_MCode.vhd:573:7  */
  assign n6882_o = n6237_o == 5'b00010;
  /* ./T65/T65_MCode.vhd:573:20  */
  assign n6884_o = n6237_o == 5'b10010;
  /* ./T65/T65_MCode.vhd:573:20  */
  assign n6885_o = n6882_o | n6884_o;
  /* ./T65/T65_MCode.vhd:597:18  */
  assign n6886_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:597:31  */
  assign n6888_o = n6886_o == 3'b001;
  /* ./T65/T65_MCode.vhd:597:13  */
  assign n6891_o = n6888_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:596:11  */
  assign n6893_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:603:18  */
  assign n6894_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:603:31  */
  assign n6896_o = n6894_o == 3'b100;
  /* ./T65/T65_MCode.vhd:603:13  */
  assign n6899_o = n6896_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:600:11  */
  assign n6901_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:607:11  */
  assign n6903_o = mcycle == 3'b010;
  assign n6904_o = {n6903_o, n6901_o, n6893_o};
  /* ./T65/T65_MCode.vhd:595:9  */
  always @*
    case (n6904_o)
      3'b100: n6907_o = 2'b00;
      3'b010: n6907_o = 2'b10;
      3'b001: n6907_o = 2'b00;
      default: n6907_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:595:9  */
  always @*
    case (n6904_o)
      3'b100: n6910_o = 2'b00;
      3'b010: n6910_o = 2'b01;
      3'b001: n6910_o = 2'b00;
      default: n6910_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:595:9  */
  always @*
    case (n6904_o)
      3'b100: n6913_o = 1'b0;
      3'b010: n6913_o = 1'b1;
      3'b001: n6913_o = 1'b0;
      default: n6913_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:595:9  */
  always @*
    case (n6904_o)
      3'b100: n6915_o = 1'b0;
      3'b010: n6915_o = 1'b0;
      3'b001: n6915_o = n6891_o;
      default: n6915_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:595:9  */
  always @*
    case (n6904_o)
      3'b100: n6917_o = 1'b0;
      3'b010: n6917_o = n6899_o;
      3'b001: n6917_o = 1'b0;
      default: n6917_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:592:7  */
  assign n6919_o = n6237_o == 5'b00100;
  /* ./T65/T65_MCode.vhd:616:14  */
  assign n6920_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:616:27  */
  assign n6922_o = n6920_o != 2'b10;
  /* ./T65/T65_MCode.vhd:616:41  */
  assign n6923_o = ir[1];
  /* ./T65/T65_MCode.vhd:616:35  */
  assign n6924_o = n6923_o & n6922_o;
  /* ./T65/T65_MCode.vhd:616:60  */
  assign n6926_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:616:71  */
  assign n6927_o = ir[0];
  /* ./T65/T65_MCode.vhd:616:74  */
  assign n6928_o = ~n6927_o;
  /* ./T65/T65_MCode.vhd:616:66  */
  assign n6929_o = n6926_o | n6928_o;
  /* ./T65/T65_MCode.vhd:616:51  */
  assign n6930_o = n6929_o & n6924_o;
  /* ./T65/T65_MCode.vhd:619:18  */
  assign n6932_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:619:30  */
  assign n6933_o = ir[0];
  /* ./T65/T65_MCode.vhd:619:24  */
  assign n6934_o = n6933_o & n6932_o;
  /* ./T65/T65_MCode.vhd:619:11  */
  assign n6936_o = n6934_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:623:13  */
  assign n6938_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:629:22  */
  assign n6940_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:629:15  */
  assign n6943_o = n6940_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:627:13  */
  assign n6945_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:633:13  */
  assign n6947_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:639:22  */
  assign n6949_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:639:34  */
  assign n6950_o = ir[0];
  /* ./T65/T65_MCode.vhd:639:28  */
  assign n6951_o = n6950_o & n6949_o;
  /* ./T65/T65_MCode.vhd:639:15  */
  assign n6953_o = n6951_o ? 4'b0001 : n6236_o;
  /* ./T65/T65_MCode.vhd:639:15  */
  assign n6956_o = n6951_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:639:15  */
  assign n6959_o = n6951_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:638:13  */
  assign n6961_o = mcycle == 3'b100;
  assign n6962_o = {n6961_o, n6947_o, n6945_o, n6938_o};
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6963_o = n6953_o;
      4'b0100: n6963_o = n6236_o;
      4'b0010: n6963_o = n6236_o;
      4'b0001: n6963_o = n6236_o;
      default: n6963_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6968_o = 2'b00;
      4'b0100: n6968_o = 2'b10;
      4'b0010: n6968_o = 2'b10;
      4'b0001: n6968_o = 2'b10;
      default: n6968_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6971_o = 2'b00;
      4'b0100: n6971_o = 2'b00;
      4'b0010: n6971_o = 2'b00;
      4'b0001: n6971_o = 2'b01;
      default: n6971_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6974_o = n6956_o;
      4'b0100: n6974_o = 1'b0;
      4'b0010: n6974_o = 1'b1;
      4'b0001: n6974_o = 1'b0;
      default: n6974_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6977_o = 1'b0;
      4'b0100: n6977_o = 1'b1;
      4'b0010: n6977_o = 1'b0;
      4'b0001: n6977_o = 1'b0;
      default: n6977_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6980_o = 1'b0;
      4'b0100: n6980_o = 1'b0;
      4'b0010: n6980_o = 1'b0;
      4'b0001: n6980_o = 1'b1;
      default: n6980_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6983_o = 1'b0;
      4'b0100: n6983_o = 1'b1;
      4'b0010: n6983_o = 1'b0;
      4'b0001: n6983_o = 1'b0;
      default: n6983_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6986_o = 1'b0;
      4'b0100: n6986_o = 1'b1;
      4'b0010: n6986_o = n6943_o;
      4'b0001: n6986_o = 1'b0;
      default: n6986_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:622:11  */
  always @*
    case (n6962_o)
      4'b1000: n6988_o = n6959_o;
      4'b0100: n6988_o = 1'b0;
      4'b0010: n6988_o = 1'b0;
      4'b0001: n6988_o = 1'b0;
      default: n6988_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:648:16  */
  assign n6989_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:648:29  */
  assign n6991_o = n6989_o != 2'b10;
  /* ./T65/T65_MCode.vhd:648:11  */
  assign n6993_o = n6991_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:652:13  */
  assign n6995_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:656:20  */
  assign n6996_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:656:33  */
  assign n6998_o = n6996_o == 3'b100;
  /* ./T65/T65_MCode.vhd:656:15  */
  assign n7001_o = n6998_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:653:13  */
  assign n7003_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:660:13  */
  assign n7005_o = mcycle == 3'b010;
  assign n7006_o = {n7005_o, n7003_o, n6995_o};
  /* ./T65/T65_MCode.vhd:651:11  */
  always @*
    case (n7006_o)
      3'b100: n7009_o = 2'b00;
      3'b010: n7009_o = 2'b10;
      3'b001: n7009_o = 2'b00;
      default: n7009_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:651:11  */
  always @*
    case (n7006_o)
      3'b100: n7012_o = 2'b00;
      3'b010: n7012_o = 2'b01;
      3'b001: n7012_o = 2'b00;
      default: n7012_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:651:11  */
  always @*
    case (n7006_o)
      3'b100: n7015_o = 1'b0;
      3'b010: n7015_o = 1'b1;
      3'b001: n7015_o = 1'b0;
      default: n7015_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:651:11  */
  always @*
    case (n7006_o)
      3'b100: n7017_o = 1'b0;
      3'b010: n7017_o = n7001_o;
      3'b001: n7017_o = 1'b0;
      default: n7017_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7020_o = n6930_o ? 3'b100 : 3'b010;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7021_o = n6930_o ? n6963_o : n6236_o;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7022_o = n6930_o ? n6968_o : n7009_o;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7023_o = n6930_o ? n6971_o : n7012_o;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7024_o = n6930_o ? n6936_o : n6993_o;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7026_o = n6930_o ? n6974_o : 1'b0;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7028_o = n6930_o ? n6977_o : 1'b0;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7029_o = n6930_o ? n6980_o : n7015_o;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7031_o = n6930_o ? n6983_o : 1'b0;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7032_o = n6930_o ? n6986_o : n7017_o;
  /* ./T65/T65_MCode.vhd:616:9  */
  assign n7034_o = n6930_o ? n6988_o : 1'b0;
  /* ./T65/T65_MCode.vhd:614:7  */
  assign n7036_o = n6237_o == 5'b00101;
  /* ./T65/T65_MCode.vhd:614:20  */
  assign n7038_o = n6237_o == 5'b00110;
  /* ./T65/T65_MCode.vhd:614:20  */
  assign n7039_o = n7036_o | n7038_o;
  /* ./T65/T65_MCode.vhd:614:30  */
  assign n7041_o = n6237_o == 5'b00111;
  /* ./T65/T65_MCode.vhd:614:30  */
  assign n7042_o = n7039_o | n7041_o;
  /* ./T65/T65_MCode.vhd:668:14  */
  assign n7043_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:668:27  */
  assign n7045_o = n7043_o == 2'b01;
  /* ./T65/T65_MCode.vhd:668:40  */
  assign n7046_o = ir[4:0];
  /* ./T65/T65_MCode.vhd:668:53  */
  assign n7048_o = n7046_o == 5'b01100;
  /* ./T65/T65_MCode.vhd:668:34  */
  assign n7049_o = n7048_o & n7045_o;
  /* ./T65/T65_MCode.vhd:669:16  */
  assign n7050_o = ir[5];
  /* ./T65/T65_MCode.vhd:669:20  */
  assign n7051_o = ~n7050_o;
  /* ./T65/T65_MCode.vhd:672:15  */
  assign n7053_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:675:15  */
  assign n7055_o = mcycle == 3'b010;
  assign n7056_o = {n7055_o, n7053_o};
  /* ./T65/T65_MCode.vhd:671:13  */
  always @*
    case (n7056_o)
      2'b10: n7060_o = 2'b10;
      2'b01: n7060_o = 2'b01;
      default: n7060_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:671:13  */
  always @*
    case (n7056_o)
      2'b10: n7063_o = 1'b0;
      2'b01: n7063_o = 1'b1;
      default: n7063_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:682:15  */
  assign n7065_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:688:25  */
  assign n7067_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:688:17  */
  assign n7070_o = n7067_o ? 2'b10 : 2'b00;
  /* ./T65/T65_MCode.vhd:691:25  */
  assign n7072_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:691:17  */
  assign n7075_o = n7072_o ? 2'b11 : 2'b00;
  /* ./T65/T65_MCode.vhd:686:15  */
  assign n7077_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:696:25  */
  assign n7079_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:696:17  */
  assign n7082_o = n7079_o ? 2'b11 : 2'b00;
  /* ./T65/T65_MCode.vhd:696:17  */
  assign n7085_o = n7079_o ? 2'b00 : 2'b01;
  /* ./T65/T65_MCode.vhd:696:17  */
  assign n7088_o = n7079_o ? 2'b01 : 2'b00;
  /* ./T65/T65_MCode.vhd:694:15  */
  assign n7090_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:702:15  */
  assign n7092_o = mcycle == 3'b100;
  assign n7093_o = {n7092_o, n7090_o, n7077_o, n7065_o};
  /* ./T65/T65_MCode.vhd:681:13  */
  always @*
    case (n7093_o)
      4'b1000: n7095_o = 2'b00;
      4'b0100: n7095_o = n7082_o;
      4'b0010: n7095_o = n7075_o;
      4'b0001: n7095_o = 2'b00;
      default: n7095_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:681:13  */
  always @*
    case (n7093_o)
      4'b1000: n7099_o = 2'b10;
      4'b0100: n7099_o = n7085_o;
      4'b0010: n7099_o = n7070_o;
      4'b0001: n7099_o = 2'b01;
      default: n7099_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:681:13  */
  always @*
    case (n7093_o)
      4'b1000: n7101_o = 2'b00;
      4'b0100: n7101_o = n7088_o;
      4'b0010: n7101_o = 2'b00;
      4'b0001: n7101_o = 2'b00;
      default: n7101_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:681:13  */
  always @*
    case (n7093_o)
      4'b1000: n7105_o = 1'b0;
      4'b0100: n7105_o = 1'b1;
      4'b0010: n7105_o = 1'b0;
      4'b0001: n7105_o = 1'b1;
      default: n7105_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:681:13  */
  always @*
    case (n7093_o)
      4'b1000: n7108_o = 1'b0;
      4'b0100: n7108_o = 1'b0;
      4'b0010: n7108_o = 1'b0;
      4'b0001: n7108_o = 1'b1;
      default: n7108_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:681:13  */
  always @*
    case (n7093_o)
      4'b1000: n7111_o = 1'b0;
      4'b0100: n7111_o = 1'b0;
      4'b0010: n7111_o = 1'b1;
      4'b0001: n7111_o = 1'b0;
      default: n7111_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:669:11  */
  assign n7114_o = n7051_o ? 3'b010 : 3'b100;
  /* ./T65/T65_MCode.vhd:669:11  */
  assign n7116_o = n7051_o ? 2'b00 : n7095_o;
  /* ./T65/T65_MCode.vhd:669:11  */
  assign n7117_o = n7051_o ? n7060_o : n7099_o;
  /* ./T65/T65_MCode.vhd:669:11  */
  assign n7119_o = n7051_o ? 2'b00 : n7101_o;
  /* ./T65/T65_MCode.vhd:669:11  */
  assign n7120_o = n7051_o ? n7063_o : n7105_o;
  /* ./T65/T65_MCode.vhd:669:11  */
  assign n7122_o = n7051_o ? 1'b0 : n7108_o;
  /* ./T65/T65_MCode.vhd:669:11  */
  assign n7124_o = n7051_o ? 1'b0 : n7111_o;
  /* ./T65/T65_MCode.vhd:711:20  */
  assign n7125_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:711:33  */
  assign n7127_o = n7125_o == 3'b001;
  /* ./T65/T65_MCode.vhd:711:15  */
  assign n7130_o = n7127_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:710:13  */
  assign n7132_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:714:13  */
  assign n7134_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:720:20  */
  assign n7135_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:720:33  */
  assign n7137_o = n7135_o == 3'b100;
  /* ./T65/T65_MCode.vhd:720:15  */
  assign n7140_o = n7137_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:717:13  */
  assign n7142_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:724:13  */
  assign n7144_o = mcycle == 3'b011;
  assign n7145_o = {n7144_o, n7142_o, n7134_o, n7132_o};
  /* ./T65/T65_MCode.vhd:709:11  */
  always @*
    case (n7145_o)
      4'b1000: n7148_o = 2'b00;
      4'b0100: n7148_o = 2'b11;
      4'b0010: n7148_o = 2'b00;
      4'b0001: n7148_o = 2'b00;
      default: n7148_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:709:11  */
  always @*
    case (n7145_o)
      4'b1000: n7152_o = 2'b00;
      4'b0100: n7152_o = 2'b01;
      4'b0010: n7152_o = 2'b01;
      4'b0001: n7152_o = 2'b00;
      default: n7152_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:709:11  */
  always @*
    case (n7145_o)
      4'b1000: n7155_o = 1'b0;
      4'b0100: n7155_o = 1'b0;
      4'b0010: n7155_o = 1'b1;
      4'b0001: n7155_o = 1'b0;
      default: n7155_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:709:11  */
  always @*
    case (n7145_o)
      4'b1000: n7158_o = 1'b0;
      4'b0100: n7158_o = 1'b1;
      4'b0010: n7158_o = 1'b0;
      4'b0001: n7158_o = 1'b0;
      default: n7158_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:709:11  */
  always @*
    case (n7145_o)
      4'b1000: n7160_o = 1'b0;
      4'b0100: n7160_o = 1'b0;
      4'b0010: n7160_o = 1'b0;
      4'b0001: n7160_o = n7130_o;
      default: n7160_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:709:11  */
  always @*
    case (n7145_o)
      4'b1000: n7162_o = 1'b0;
      4'b0100: n7162_o = n7140_o;
      4'b0010: n7162_o = 1'b0;
      4'b0001: n7162_o = 1'b0;
      default: n7162_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7164_o = n7049_o ? n7114_o : 3'b011;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7165_o = n7049_o ? n7116_o : n7148_o;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7166_o = n7049_o ? n7117_o : n7152_o;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7168_o = n7049_o ? n7119_o : 2'b00;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7170_o = n7049_o ? n7120_o : 1'b0;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7171_o = n7049_o ? n7122_o : n7155_o;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7172_o = n7049_o ? n7124_o : n7158_o;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7174_o = n7049_o ? 1'b0 : n7160_o;
  /* ./T65/T65_MCode.vhd:668:9  */
  assign n7176_o = n7049_o ? 1'b0 : n7162_o;
  /* ./T65/T65_MCode.vhd:666:7  */
  assign n7178_o = n6237_o == 5'b01100;
  /* ./T65/T65_MCode.vhd:734:14  */
  assign n7179_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:734:27  */
  assign n7181_o = n7179_o != 2'b10;
  /* ./T65/T65_MCode.vhd:734:41  */
  assign n7182_o = ir[1];
  /* ./T65/T65_MCode.vhd:734:35  */
  assign n7183_o = n7182_o & n7181_o;
  /* ./T65/T65_MCode.vhd:734:60  */
  assign n7185_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:734:71  */
  assign n7186_o = ir[0];
  /* ./T65/T65_MCode.vhd:734:74  */
  assign n7187_o = ~n7186_o;
  /* ./T65/T65_MCode.vhd:734:66  */
  assign n7188_o = n7185_o | n7187_o;
  /* ./T65/T65_MCode.vhd:734:51  */
  assign n7189_o = n7188_o & n7183_o;
  /* ./T65/T65_MCode.vhd:737:18  */
  assign n7191_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:737:30  */
  assign n7192_o = ir[0];
  /* ./T65/T65_MCode.vhd:737:24  */
  assign n7193_o = n7192_o & n7191_o;
  /* ./T65/T65_MCode.vhd:737:11  */
  assign n7195_o = n7193_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:741:13  */
  assign n7197_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:744:13  */
  assign n7199_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:750:22  */
  assign n7201_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:750:15  */
  assign n7204_o = n7201_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:748:13  */
  assign n7206_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:754:13  */
  assign n7208_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:760:22  */
  assign n7210_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:760:34  */
  assign n7211_o = ir[0];
  /* ./T65/T65_MCode.vhd:760:28  */
  assign n7212_o = n7211_o & n7210_o;
  /* ./T65/T65_MCode.vhd:760:15  */
  assign n7214_o = n7212_o ? 4'b0001 : n6236_o;
  /* ./T65/T65_MCode.vhd:760:15  */
  assign n7217_o = n7212_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:759:13  */
  assign n7219_o = mcycle == 3'b101;
  assign n7220_o = {n7219_o, n7208_o, n7206_o, n7199_o, n7197_o};
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7221_o = n7214_o;
      5'b01000: n7221_o = n6236_o;
      5'b00100: n7221_o = n6236_o;
      5'b00010: n7221_o = n6236_o;
      5'b00001: n7221_o = n6236_o;
      default: n7221_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7226_o = 2'b00;
      5'b01000: n7226_o = 2'b11;
      5'b00100: n7226_o = 2'b11;
      5'b00010: n7226_o = 2'b11;
      5'b00001: n7226_o = 2'b00;
      default: n7226_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7230_o = 2'b00;
      5'b01000: n7230_o = 2'b00;
      5'b00100: n7230_o = 2'b00;
      5'b00010: n7230_o = 2'b01;
      5'b00001: n7230_o = 2'b01;
      default: n7230_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7233_o = 1'b0;
      5'b01000: n7233_o = 1'b0;
      5'b00100: n7233_o = 1'b1;
      5'b00010: n7233_o = 1'b0;
      5'b00001: n7233_o = 1'b0;
      default: n7233_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7236_o = 1'b0;
      5'b01000: n7236_o = 1'b1;
      5'b00100: n7236_o = 1'b0;
      5'b00010: n7236_o = 1'b0;
      5'b00001: n7236_o = 1'b0;
      default: n7236_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7239_o = 1'b0;
      5'b01000: n7239_o = 1'b0;
      5'b00100: n7239_o = 1'b0;
      5'b00010: n7239_o = 1'b0;
      5'b00001: n7239_o = 1'b1;
      default: n7239_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7242_o = 1'b0;
      5'b01000: n7242_o = 1'b0;
      5'b00100: n7242_o = 1'b0;
      5'b00010: n7242_o = 1'b1;
      5'b00001: n7242_o = 1'b0;
      default: n7242_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7245_o = 1'b0;
      5'b01000: n7245_o = 1'b1;
      5'b00100: n7245_o = 1'b0;
      5'b00010: n7245_o = 1'b0;
      5'b00001: n7245_o = 1'b0;
      default: n7245_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7248_o = 1'b0;
      5'b01000: n7248_o = 1'b1;
      5'b00100: n7248_o = n7204_o;
      5'b00010: n7248_o = 1'b0;
      5'b00001: n7248_o = 1'b0;
      default: n7248_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:740:11  */
  always @*
    case (n7220_o)
      5'b10000: n7250_o = n7217_o;
      5'b01000: n7250_o = 1'b0;
      5'b00100: n7250_o = 1'b0;
      5'b00010: n7250_o = 1'b0;
      5'b00001: n7250_o = 1'b0;
      default: n7250_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:768:16  */
  assign n7251_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:768:29  */
  assign n7253_o = n7251_o != 2'b10;
  /* ./T65/T65_MCode.vhd:768:11  */
  assign n7255_o = n7253_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:772:13  */
  assign n7257_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:773:13  */
  assign n7259_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:779:20  */
  assign n7260_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:779:33  */
  assign n7262_o = n7260_o == 3'b100;
  /* ./T65/T65_MCode.vhd:779:15  */
  assign n7265_o = n7262_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:776:13  */
  assign n7267_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:783:13  */
  assign n7269_o = mcycle == 3'b011;
  assign n7270_o = {n7269_o, n7267_o, n7259_o, n7257_o};
  /* ./T65/T65_MCode.vhd:771:11  */
  always @*
    case (n7270_o)
      4'b1000: n7273_o = 2'b00;
      4'b0100: n7273_o = 2'b11;
      4'b0010: n7273_o = 2'b00;
      4'b0001: n7273_o = 2'b00;
      default: n7273_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:771:11  */
  always @*
    case (n7270_o)
      4'b1000: n7277_o = 2'b00;
      4'b0100: n7277_o = 2'b01;
      4'b0010: n7277_o = 2'b01;
      4'b0001: n7277_o = 2'b00;
      default: n7277_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:771:11  */
  always @*
    case (n7270_o)
      4'b1000: n7280_o = 1'b0;
      4'b0100: n7280_o = 1'b0;
      4'b0010: n7280_o = 1'b1;
      4'b0001: n7280_o = 1'b0;
      default: n7280_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:771:11  */
  always @*
    case (n7270_o)
      4'b1000: n7283_o = 1'b0;
      4'b0100: n7283_o = 1'b1;
      4'b0010: n7283_o = 1'b0;
      4'b0001: n7283_o = 1'b0;
      default: n7283_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:771:11  */
  always @*
    case (n7270_o)
      4'b1000: n7285_o = 1'b0;
      4'b0100: n7285_o = n7265_o;
      4'b0010: n7285_o = 1'b0;
      4'b0001: n7285_o = 1'b0;
      default: n7285_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7288_o = n7189_o ? 3'b101 : 3'b011;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7289_o = n7189_o ? n7221_o : n6236_o;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7290_o = n7189_o ? n7226_o : n7273_o;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7291_o = n7189_o ? n7230_o : n7277_o;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7292_o = n7189_o ? n7195_o : n7255_o;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7294_o = n7189_o ? n7233_o : 1'b0;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7296_o = n7189_o ? n7236_o : 1'b0;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7297_o = n7189_o ? n7239_o : n7280_o;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7298_o = n7189_o ? n7242_o : n7283_o;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7300_o = n7189_o ? n7245_o : 1'b0;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7301_o = n7189_o ? n7248_o : n7285_o;
  /* ./T65/T65_MCode.vhd:734:9  */
  assign n7303_o = n7189_o ? n7250_o : 1'b0;
  /* ./T65/T65_MCode.vhd:732:7  */
  assign n7305_o = n6237_o == 5'b01101;
  /* ./T65/T65_MCode.vhd:732:20  */
  assign n7307_o = n6237_o == 5'b01110;
  /* ./T65/T65_MCode.vhd:732:20  */
  assign n7308_o = n7305_o | n7307_o;
  /* ./T65/T65_MCode.vhd:732:30  */
  assign n7310_o = n6237_o == 5'b01111;
  /* ./T65/T65_MCode.vhd:732:30  */
  assign n7311_o = n7308_o | n7310_o;
  /* ./T65/T65_MCode.vhd:795:9  */
  assign n7314_o = branch ? 3'b011 : 3'b001;
  /* ./T65/T65_MCode.vhd:809:11  */
  assign n7316_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:820:11  */
  assign n7318_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:829:11  */
  assign n7320_o = mcycle == 3'b011;
  assign n7321_o = {n7320_o, n7318_o, n7316_o};
  /* ./T65/T65_MCode.vhd:804:9  */
  always @*
    case (n7321_o)
      3'b100: n7325_o = 2'b00;
      3'b010: n7325_o = 2'b11;
      3'b001: n7325_o = 2'b01;
      default: n7325_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:804:9  */
  always @*
    case (n7321_o)
      3'b100: n7328_o = 1'b0;
      3'b010: n7328_o = 1'b1;
      3'b001: n7328_o = 1'b0;
      default: n7328_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:804:9  */
  always @*
    case (n7321_o)
      3'b100: n7331_o = 1'b0;
      3'b010: n7331_o = 1'b0;
      3'b001: n7331_o = 1'b1;
      default: n7331_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:789:7  */
  assign n7333_o = n6237_o == 5'b10000;
  /* ./T65/T65_MCode.vhd:837:14  */
  assign n7334_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:837:27  */
  assign n7336_o = n7334_o != 2'b10;
  /* ./T65/T65_MCode.vhd:839:18  */
  assign n7338_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:839:30  */
  assign n7339_o = ir[1];
  /* ./T65/T65_MCode.vhd:839:24  */
  assign n7340_o = n7339_o & n7338_o;
  /* ./T65/T65_MCode.vhd:839:11  */
  assign n7343_o = n7340_o ? 3'b111 : 3'b101;
  /* ./T65/T65_MCode.vhd:837:9  */
  assign n7345_o = n7336_o ? n7343_o : 3'b101;
  /* ./T65/T65_MCode.vhd:837:9  */
  assign n7348_o = n7336_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:844:11  */
  assign n7350_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:848:11  */
  assign n7352_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:852:11  */
  assign n7354_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:859:18  */
  assign n7355_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:859:31  */
  assign n7357_o = n7355_o == 3'b100;
  /* ./T65/T65_MCode.vhd:861:20  */
  assign n7358_o = ir[3:0];
  /* ./T65/T65_MCode.vhd:861:33  */
  assign n7360_o = n7358_o == 4'b0011;
  /* ./T65/T65_MCode.vhd:861:15  */
  assign n7363_o = n7360_o ? 2'b10 : 2'b00;
  /* ./T65/T65_MCode.vhd:864:21  */
  assign n7364_o = ir[1];
  /* ./T65/T65_MCode.vhd:864:24  */
  assign n7365_o = ~n7364_o;
  /* ./T65/T65_MCode.vhd:864:34  */
  assign n7367_o = ir == 8'b10110011;
  /* ./T65/T65_MCode.vhd:864:29  */
  assign n7368_o = n7365_o | n7367_o;
  /* ./T65/T65_MCode.vhd:864:13  */
  assign n7371_o = n7368_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:859:13  */
  assign n7373_o = n7357_o ? n7363_o : 2'b00;
  /* ./T65/T65_MCode.vhd:859:13  */
  assign n7375_o = n7357_o ? 1'b0 : n7371_o;
  /* ./T65/T65_MCode.vhd:859:13  */
  assign n7378_o = n7357_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:857:11  */
  assign n7380_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:869:20  */
  assign n7382_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:869:32  */
  assign n7383_o = ir[1];
  /* ./T65/T65_MCode.vhd:869:26  */
  assign n7384_o = n7383_o & n7382_o;
  /* ./T65/T65_MCode.vhd:869:46  */
  assign n7385_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:869:58  */
  assign n7387_o = n7385_o != 2'b10;
  /* ./T65/T65_MCode.vhd:869:40  */
  assign n7388_o = n7387_o & n7384_o;
  /* ./T65/T65_MCode.vhd:869:13  */
  assign n7391_o = n7388_o ? 2'b11 : 2'b00;
  /* ./T65/T65_MCode.vhd:869:13  */
  assign n7394_o = n7388_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:869:13  */
  assign n7397_o = n7388_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:868:11  */
  assign n7399_o = mcycle == 3'b101;
  /* ./T65/T65_MCode.vhd:874:11  */
  assign n7401_o = mcycle == 3'b110;
  /* ./T65/T65_MCode.vhd:879:11  */
  assign n7403_o = mcycle == 3'b111;
  assign n7404_o = {n7403_o, n7401_o, n7399_o, n7380_o, n7354_o, n7352_o, n7350_o};
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7407_o = 4'b0001;
      7'b0100000: n7407_o = n6236_o;
      7'b0010000: n7407_o = n6236_o;
      7'b0001000: n7407_o = n6236_o;
      7'b0000100: n7407_o = 4'b0011;
      7'b0000010: n7407_o = n6236_o;
      7'b0000001: n7407_o = n6236_o;
      default: n7407_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7414_o = 2'b00;
      7'b0100000: n7414_o = 2'b11;
      7'b0010000: n7414_o = n7391_o;
      7'b0001000: n7414_o = 2'b11;
      7'b0000100: n7414_o = 2'b11;
      7'b0000010: n7414_o = 2'b10;
      7'b0000001: n7414_o = 2'b10;
      default: n7414_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7417_o = 2'b00;
      7'b0100000: n7417_o = 2'b00;
      7'b0010000: n7417_o = 2'b00;
      7'b0001000: n7417_o = 2'b00;
      7'b0000100: n7417_o = 2'b00;
      7'b0000010: n7417_o = 2'b00;
      7'b0000001: n7417_o = 2'b01;
      default: n7417_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7422_o = 2'b00;
      7'b0100000: n7422_o = 2'b00;
      7'b0010000: n7422_o = 2'b00;
      7'b0001000: n7422_o = 2'b11;
      7'b0000100: n7422_o = 2'b10;
      7'b0000010: n7422_o = 2'b01;
      7'b0000001: n7422_o = 2'b00;
      default: n7422_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7424_o = 2'b00;
      7'b0100000: n7424_o = 2'b00;
      7'b0010000: n7424_o = 2'b00;
      7'b0001000: n7424_o = n7373_o;
      7'b0000100: n7424_o = 2'b00;
      7'b0000010: n7424_o = 2'b00;
      7'b0000001: n7424_o = 2'b00;
      default: n7424_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7426_o = 1'b0;
      7'b0100000: n7426_o = 1'b0;
      7'b0010000: n7426_o = 1'b0;
      7'b0001000: n7426_o = n7375_o;
      7'b0000100: n7426_o = 1'b0;
      7'b0000010: n7426_o = 1'b0;
      7'b0000001: n7426_o = 1'b0;
      default: n7426_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7428_o = 1'b0;
      7'b0100000: n7428_o = 1'b0;
      7'b0010000: n7428_o = n7394_o;
      7'b0001000: n7428_o = 1'b0;
      7'b0000100: n7428_o = 1'b0;
      7'b0000010: n7428_o = 1'b0;
      7'b0000001: n7428_o = 1'b0;
      default: n7428_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7431_o = 1'b0;
      7'b0100000: n7431_o = 1'b1;
      7'b0010000: n7431_o = 1'b0;
      7'b0001000: n7431_o = 1'b0;
      7'b0000100: n7431_o = 1'b0;
      7'b0000010: n7431_o = 1'b0;
      7'b0000001: n7431_o = 1'b0;
      default: n7431_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7434_o = 1'b0;
      7'b0100000: n7434_o = 1'b0;
      7'b0010000: n7434_o = 1'b0;
      7'b0001000: n7434_o = 1'b0;
      7'b0000100: n7434_o = 1'b0;
      7'b0000010: n7434_o = 1'b0;
      7'b0000001: n7434_o = 1'b1;
      default: n7434_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7437_o = 1'b0;
      7'b0100000: n7437_o = 1'b0;
      7'b0010000: n7437_o = 1'b0;
      7'b0001000: n7437_o = 1'b0;
      7'b0000100: n7437_o = 1'b0;
      7'b0000010: n7437_o = 1'b1;
      7'b0000001: n7437_o = 1'b0;
      default: n7437_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7440_o = 1'b0;
      7'b0100000: n7440_o = 1'b0;
      7'b0010000: n7440_o = 1'b0;
      7'b0001000: n7440_o = 1'b0;
      7'b0000100: n7440_o = 1'b1;
      7'b0000010: n7440_o = 1'b0;
      7'b0000001: n7440_o = 1'b0;
      default: n7440_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7443_o = 1'b0;
      7'b0100000: n7443_o = 1'b1;
      7'b0010000: n7443_o = 1'b0;
      7'b0001000: n7443_o = 1'b0;
      7'b0000100: n7443_o = 1'b0;
      7'b0000010: n7443_o = 1'b0;
      7'b0000001: n7443_o = 1'b0;
      default: n7443_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7446_o = 1'b0;
      7'b0100000: n7446_o = 1'b1;
      7'b0010000: n7446_o = n7397_o;
      7'b0001000: n7446_o = n7378_o;
      7'b0000100: n7446_o = 1'b0;
      7'b0000010: n7446_o = 1'b0;
      7'b0000001: n7446_o = 1'b0;
      default: n7446_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:843:9  */
  always @*
    case (n7404_o)
      7'b1000000: n7449_o = 1'b1;
      7'b0100000: n7449_o = 1'b0;
      7'b0010000: n7449_o = 1'b0;
      7'b0001000: n7449_o = 1'b0;
      7'b0000100: n7449_o = 1'b0;
      7'b0000010: n7449_o = 1'b0;
      7'b0000001: n7449_o = 1'b0;
      default: n7449_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:835:7  */
  assign n7451_o = n6237_o == 5'b10001;
  /* ./T65/T65_MCode.vhd:835:20  */
  assign n7453_o = n6237_o == 5'b10011;
  /* ./T65/T65_MCode.vhd:835:20  */
  assign n7454_o = n7451_o | n7453_o;
  /* ./T65/T65_MCode.vhd:891:14  */
  assign n7455_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:891:27  */
  assign n7457_o = n7455_o != 2'b10;
  /* ./T65/T65_MCode.vhd:891:41  */
  assign n7458_o = ir[1];
  /* ./T65/T65_MCode.vhd:891:35  */
  assign n7459_o = n7458_o & n7457_o;
  /* ./T65/T65_MCode.vhd:891:60  */
  assign n7461_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:891:71  */
  assign n7462_o = ir[0];
  /* ./T65/T65_MCode.vhd:891:74  */
  assign n7463_o = ~n7462_o;
  /* ./T65/T65_MCode.vhd:891:66  */
  assign n7464_o = n7461_o | n7463_o;
  /* ./T65/T65_MCode.vhd:891:51  */
  assign n7465_o = n7464_o & n7459_o;
  /* ./T65/T65_MCode.vhd:893:18  */
  assign n7467_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:893:30  */
  assign n7468_o = ir[0];
  /* ./T65/T65_MCode.vhd:893:24  */
  assign n7469_o = n7468_o & n7467_o;
  /* ./T65/T65_MCode.vhd:893:11  */
  assign n7471_o = n7469_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:898:13  */
  assign n7473_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:902:13  */
  assign n7475_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:907:22  */
  assign n7477_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:907:15  */
  assign n7480_o = n7477_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:905:13  */
  assign n7482_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:916:22  */
  assign n7484_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:916:34  */
  assign n7485_o = ir[0];
  /* ./T65/T65_MCode.vhd:916:28  */
  assign n7486_o = n7485_o & n7484_o;
  /* ./T65/T65_MCode.vhd:916:15  */
  assign n7489_o = n7486_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:911:13  */
  assign n7491_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:920:22  */
  assign n7493_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:920:34  */
  assign n7494_o = ir[0];
  /* ./T65/T65_MCode.vhd:920:28  */
  assign n7495_o = n7494_o & n7493_o;
  /* ./T65/T65_MCode.vhd:920:15  */
  assign n7497_o = n7495_o ? 4'b0001 : n6236_o;
  /* ./T65/T65_MCode.vhd:920:15  */
  assign n7500_o = n7495_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:919:13  */
  assign n7502_o = mcycle == 3'b101;
  assign n7503_o = {n7502_o, n7491_o, n7482_o, n7475_o, n7473_o};
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7504_o = n7497_o;
      5'b01000: n7504_o = n6236_o;
      5'b00100: n7504_o = n6236_o;
      5'b00010: n7504_o = n6236_o;
      5'b00001: n7504_o = n6236_o;
      default: n7504_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7510_o = 2'b00;
      5'b01000: n7510_o = 2'b10;
      5'b00100: n7510_o = 2'b10;
      5'b00010: n7510_o = 2'b10;
      5'b00001: n7510_o = 2'b10;
      default: n7510_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7513_o = 2'b00;
      5'b01000: n7513_o = 2'b00;
      5'b00100: n7513_o = 2'b00;
      5'b00010: n7513_o = 2'b00;
      5'b00001: n7513_o = 2'b01;
      default: n7513_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7516_o = 1'b0;
      5'b01000: n7516_o = 1'b0;
      5'b00100: n7516_o = 1'b0;
      5'b00010: n7516_o = 1'b1;
      5'b00001: n7516_o = 1'b0;
      default: n7516_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7519_o = 1'b0;
      5'b01000: n7519_o = n7489_o;
      5'b00100: n7519_o = 1'b1;
      5'b00010: n7519_o = 1'b0;
      5'b00001: n7519_o = 1'b0;
      default: n7519_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7522_o = 1'b0;
      5'b01000: n7522_o = 1'b1;
      5'b00100: n7522_o = 1'b0;
      5'b00010: n7522_o = 1'b0;
      5'b00001: n7522_o = 1'b0;
      default: n7522_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7525_o = 1'b0;
      5'b01000: n7525_o = 1'b0;
      5'b00100: n7525_o = 1'b0;
      5'b00010: n7525_o = 1'b0;
      5'b00001: n7525_o = 1'b1;
      default: n7525_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7528_o = 1'b0;
      5'b01000: n7528_o = 1'b1;
      5'b00100: n7528_o = 1'b0;
      5'b00010: n7528_o = 1'b0;
      5'b00001: n7528_o = 1'b0;
      default: n7528_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7531_o = 1'b0;
      5'b01000: n7531_o = 1'b1;
      5'b00100: n7531_o = n7480_o;
      5'b00010: n7531_o = 1'b0;
      5'b00001: n7531_o = 1'b0;
      default: n7531_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:897:11  */
  always @*
    case (n7503_o)
      5'b10000: n7533_o = n7500_o;
      5'b01000: n7533_o = 1'b0;
      5'b00100: n7533_o = 1'b0;
      5'b00010: n7533_o = 1'b0;
      5'b00001: n7533_o = 1'b0;
      default: n7533_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:928:16  */
  assign n7534_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:928:29  */
  assign n7536_o = n7534_o != 2'b10;
  /* ./T65/T65_MCode.vhd:928:43  */
  assign n7537_o = ir[0];
  /* ./T65/T65_MCode.vhd:928:37  */
  assign n7538_o = n7537_o & n7536_o;
  /* ./T65/T65_MCode.vhd:928:11  */
  assign n7540_o = n7538_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:932:13  */
  assign n7542_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:933:13  */
  assign n7544_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:940:21  */
  assign n7545_o = ir[3:1];
  /* ./T65/T65_MCode.vhd:940:34  */
  assign n7547_o = n7545_o == 3'b011;
  /* ./T65/T65_MCode.vhd:940:15  */
  assign n7550_o = n7547_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:943:20  */
  assign n7551_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:943:33  */
  assign n7553_o = n7551_o == 3'b100;
  /* ./T65/T65_MCode.vhd:943:15  */
  assign n7556_o = n7553_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:937:13  */
  assign n7558_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:947:13  */
  assign n7560_o = mcycle == 3'b011;
  assign n7561_o = {n7560_o, n7558_o, n7544_o, n7542_o};
  /* ./T65/T65_MCode.vhd:931:11  */
  always @*
    case (n7561_o)
      4'b1000: n7565_o = 2'b00;
      4'b0100: n7565_o = 2'b10;
      4'b0010: n7565_o = 2'b10;
      4'b0001: n7565_o = 2'b00;
      default: n7565_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:931:11  */
  always @*
    case (n7561_o)
      4'b1000: n7568_o = 2'b00;
      4'b0100: n7568_o = 2'b00;
      4'b0010: n7568_o = 2'b01;
      4'b0001: n7568_o = 2'b00;
      default: n7568_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:931:11  */
  always @*
    case (n7561_o)
      4'b1000: n7571_o = 1'b0;
      4'b0100: n7571_o = 1'b1;
      4'b0010: n7571_o = 1'b0;
      4'b0001: n7571_o = 1'b0;
      default: n7571_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:931:11  */
  always @*
    case (n7561_o)
      4'b1000: n7573_o = 1'b0;
      4'b0100: n7573_o = n7550_o;
      4'b0010: n7573_o = 1'b0;
      4'b0001: n7573_o = 1'b0;
      default: n7573_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:931:11  */
  always @*
    case (n7561_o)
      4'b1000: n7576_o = 1'b0;
      4'b0100: n7576_o = 1'b0;
      4'b0010: n7576_o = 1'b1;
      4'b0001: n7576_o = 1'b0;
      default: n7576_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:931:11  */
  always @*
    case (n7561_o)
      4'b1000: n7578_o = 1'b0;
      4'b0100: n7578_o = n7556_o;
      4'b0010: n7578_o = 1'b0;
      4'b0001: n7578_o = 1'b0;
      default: n7578_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7581_o = n7465_o ? 3'b101 : 3'b011;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7582_o = n7465_o ? n7504_o : n6236_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7583_o = n7465_o ? n7510_o : n7565_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7584_o = n7465_o ? n7513_o : n7568_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7585_o = n7465_o ? n7516_o : n7571_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7587_o = n7465_o ? 1'b0 : n7573_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7588_o = n7465_o ? n7471_o : n7540_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7590_o = n7465_o ? n7519_o : 1'b0;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7592_o = n7465_o ? n7522_o : 1'b0;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7593_o = n7465_o ? n7525_o : n7576_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7595_o = n7465_o ? n7528_o : 1'b0;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7596_o = n7465_o ? n7531_o : n7578_o;
  /* ./T65/T65_MCode.vhd:891:9  */
  assign n7598_o = n7465_o ? n7533_o : 1'b0;
  /* ./T65/T65_MCode.vhd:889:7  */
  assign n7600_o = n6237_o == 5'b10100;
  /* ./T65/T65_MCode.vhd:889:20  */
  assign n7602_o = n6237_o == 5'b10101;
  /* ./T65/T65_MCode.vhd:889:20  */
  assign n7603_o = n7600_o | n7602_o;
  /* ./T65/T65_MCode.vhd:889:30  */
  assign n7605_o = n6237_o == 5'b10110;
  /* ./T65/T65_MCode.vhd:889:30  */
  assign n7606_o = n7603_o | n7605_o;
  /* ./T65/T65_MCode.vhd:889:40  */
  assign n7608_o = n6237_o == 5'b10111;
  /* ./T65/T65_MCode.vhd:889:40  */
  assign n7609_o = n7606_o | n7608_o;
  /* ./T65/T65_MCode.vhd:957:14  */
  assign n7610_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:957:27  */
  assign n7612_o = n7610_o != 2'b10;
  /* ./T65/T65_MCode.vhd:959:18  */
  assign n7614_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:959:30  */
  assign n7615_o = ir[1];
  /* ./T65/T65_MCode.vhd:959:24  */
  assign n7616_o = n7615_o & n7614_o;
  /* ./T65/T65_MCode.vhd:959:11  */
  assign n7619_o = n7616_o ? 3'b110 : 3'b100;
  /* ./T65/T65_MCode.vhd:957:9  */
  assign n7621_o = n7612_o ? n7619_o : 3'b100;
  /* ./T65/T65_MCode.vhd:957:9  */
  assign n7624_o = n7612_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:964:11  */
  assign n7626_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:967:11  */
  assign n7628_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:975:18  */
  assign n7629_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:975:31  */
  assign n7631_o = n7629_o == 3'b100;
  /* ./T65/T65_MCode.vhd:977:20  */
  assign n7632_o = ir[3:0];
  /* ./T65/T65_MCode.vhd:977:33  */
  assign n7634_o = n7632_o == 4'b1011;
  /* ./T65/T65_MCode.vhd:977:15  */
  assign n7637_o = n7634_o ? 2'b01 : 2'b00;
  /* ./T65/T65_MCode.vhd:980:21  */
  assign n7638_o = ir[1];
  /* ./T65/T65_MCode.vhd:980:24  */
  assign n7639_o = ~n7638_o;
  /* ./T65/T65_MCode.vhd:980:34  */
  assign n7641_o = ir == 8'b10111011;
  /* ./T65/T65_MCode.vhd:980:29  */
  assign n7642_o = n7639_o | n7641_o;
  /* ./T65/T65_MCode.vhd:980:13  */
  assign n7645_o = n7642_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:975:13  */
  assign n7647_o = n7631_o ? n7637_o : 2'b00;
  /* ./T65/T65_MCode.vhd:975:13  */
  assign n7649_o = n7631_o ? 1'b0 : n7645_o;
  /* ./T65/T65_MCode.vhd:975:13  */
  assign n7652_o = n7631_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:973:11  */
  assign n7654_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:985:20  */
  assign n7656_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:985:32  */
  assign n7657_o = ir[1];
  /* ./T65/T65_MCode.vhd:985:26  */
  assign n7658_o = n7657_o & n7656_o;
  /* ./T65/T65_MCode.vhd:985:46  */
  assign n7659_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:985:58  */
  assign n7661_o = n7659_o != 2'b10;
  /* ./T65/T65_MCode.vhd:985:40  */
  assign n7662_o = n7661_o & n7658_o;
  /* ./T65/T65_MCode.vhd:985:13  */
  assign n7665_o = n7662_o ? 2'b11 : 2'b00;
  /* ./T65/T65_MCode.vhd:985:13  */
  assign n7668_o = n7662_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:985:13  */
  assign n7671_o = n7662_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:984:11  */
  assign n7673_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:990:11  */
  assign n7675_o = mcycle == 3'b101;
  /* ./T65/T65_MCode.vhd:995:11  */
  assign n7677_o = mcycle == 3'b110;
  assign n7678_o = {n7677_o, n7675_o, n7673_o, n7654_o, n7628_o, n7626_o};
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7681_o = 4'b0001;
      6'b010000: n7681_o = n6236_o;
      6'b001000: n7681_o = n6236_o;
      6'b000100: n7681_o = n6236_o;
      6'b000010: n7681_o = 4'b0011;
      6'b000001: n7681_o = n6236_o;
      default: n7681_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7686_o = 2'b00;
      6'b010000: n7686_o = 2'b11;
      6'b001000: n7686_o = n7665_o;
      6'b000100: n7686_o = 2'b11;
      6'b000010: n7686_o = 2'b11;
      6'b000001: n7686_o = 2'b00;
      default: n7686_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7690_o = 2'b00;
      6'b010000: n7690_o = 2'b00;
      6'b001000: n7690_o = 2'b00;
      6'b000100: n7690_o = 2'b00;
      6'b000010: n7690_o = 2'b01;
      6'b000001: n7690_o = 2'b01;
      default: n7690_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7694_o = 2'b00;
      6'b010000: n7694_o = 2'b00;
      6'b001000: n7694_o = 2'b00;
      6'b000100: n7694_o = 2'b11;
      6'b000010: n7694_o = 2'b10;
      6'b000001: n7694_o = 2'b00;
      default: n7694_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7696_o = 2'b00;
      6'b010000: n7696_o = 2'b00;
      6'b001000: n7696_o = 2'b00;
      6'b000100: n7696_o = n7647_o;
      6'b000010: n7696_o = 2'b00;
      6'b000001: n7696_o = 2'b00;
      default: n7696_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7698_o = 1'b0;
      6'b010000: n7698_o = 1'b0;
      6'b001000: n7698_o = 1'b0;
      6'b000100: n7698_o = n7649_o;
      6'b000010: n7698_o = 1'b0;
      6'b000001: n7698_o = 1'b0;
      default: n7698_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7700_o = 1'b0;
      6'b010000: n7700_o = 1'b0;
      6'b001000: n7700_o = n7668_o;
      6'b000100: n7700_o = 1'b0;
      6'b000010: n7700_o = 1'b0;
      6'b000001: n7700_o = 1'b0;
      default: n7700_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7703_o = 1'b0;
      6'b010000: n7703_o = 1'b1;
      6'b001000: n7703_o = 1'b0;
      6'b000100: n7703_o = 1'b0;
      6'b000010: n7703_o = 1'b0;
      6'b000001: n7703_o = 1'b0;
      default: n7703_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7706_o = 1'b0;
      6'b010000: n7706_o = 1'b0;
      6'b001000: n7706_o = 1'b0;
      6'b000100: n7706_o = 1'b0;
      6'b000010: n7706_o = 1'b0;
      6'b000001: n7706_o = 1'b1;
      default: n7706_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7709_o = 1'b0;
      6'b010000: n7709_o = 1'b0;
      6'b001000: n7709_o = 1'b0;
      6'b000100: n7709_o = 1'b0;
      6'b000010: n7709_o = 1'b1;
      6'b000001: n7709_o = 1'b0;
      default: n7709_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7712_o = 1'b0;
      6'b010000: n7712_o = 1'b1;
      6'b001000: n7712_o = 1'b0;
      6'b000100: n7712_o = 1'b0;
      6'b000010: n7712_o = 1'b0;
      6'b000001: n7712_o = 1'b0;
      default: n7712_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7715_o = 1'b0;
      6'b010000: n7715_o = 1'b1;
      6'b001000: n7715_o = n7671_o;
      6'b000100: n7715_o = n7652_o;
      6'b000010: n7715_o = 1'b0;
      6'b000001: n7715_o = 1'b0;
      default: n7715_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:963:9  */
  always @*
    case (n7678_o)
      6'b100000: n7718_o = 1'b1;
      6'b010000: n7718_o = 1'b0;
      6'b001000: n7718_o = 1'b0;
      6'b000100: n7718_o = 1'b0;
      6'b000010: n7718_o = 1'b0;
      6'b000001: n7718_o = 1'b0;
      default: n7718_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:954:7  */
  assign n7720_o = n6237_o == 5'b11001;
  /* ./T65/T65_MCode.vhd:954:20  */
  assign n7722_o = n6237_o == 5'b11011;
  /* ./T65/T65_MCode.vhd:954:20  */
  assign n7723_o = n7720_o | n7722_o;
  /* ./T65/T65_MCode.vhd:1007:14  */
  assign n7724_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:1007:27  */
  assign n7726_o = n7724_o != 2'b10;
  /* ./T65/T65_MCode.vhd:1007:41  */
  assign n7727_o = ir[1];
  /* ./T65/T65_MCode.vhd:1007:35  */
  assign n7728_o = n7727_o & n7726_o;
  /* ./T65/T65_MCode.vhd:1007:60  */
  assign n7730_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:1007:71  */
  assign n7731_o = ir[0];
  /* ./T65/T65_MCode.vhd:1007:74  */
  assign n7732_o = ~n7731_o;
  /* ./T65/T65_MCode.vhd:1007:66  */
  assign n7733_o = n7730_o | n7732_o;
  /* ./T65/T65_MCode.vhd:1007:51  */
  assign n7734_o = n7733_o & n7728_o;
  /* ./T65/T65_MCode.vhd:1010:18  */
  assign n7736_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:1010:30  */
  assign n7737_o = ir[0];
  /* ./T65/T65_MCode.vhd:1010:24  */
  assign n7738_o = n7737_o & n7736_o;
  /* ./T65/T65_MCode.vhd:1010:11  */
  assign n7740_o = n7738_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:1014:13  */
  assign n7742_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:1017:13  */
  assign n7744_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:1023:13  */
  assign n7746_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:1028:22  */
  assign n7748_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:1028:15  */
  assign n7751_o = n7748_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:1026:13  */
  assign n7753_o = mcycle == 3'b100;
  /* ./T65/T65_MCode.vhd:1032:13  */
  assign n7755_o = mcycle == 3'b101;
  /* ./T65/T65_MCode.vhd:1038:22  */
  assign n7757_o = mode == 2'b00;
  /* ./T65/T65_MCode.vhd:1038:34  */
  assign n7758_o = ir[0];
  /* ./T65/T65_MCode.vhd:1038:28  */
  assign n7759_o = n7758_o & n7757_o;
  /* ./T65/T65_MCode.vhd:1038:15  */
  assign n7761_o = n7759_o ? 4'b0001 : n6236_o;
  /* ./T65/T65_MCode.vhd:1038:15  */
  assign n7764_o = n7759_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:1037:13  */
  assign n7766_o = mcycle == 3'b110;
  assign n7767_o = {n7766_o, n7755_o, n7753_o, n7746_o, n7744_o, n7742_o};
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7769_o = n7761_o;
      6'b010000: n7769_o = n6236_o;
      6'b001000: n7769_o = n6236_o;
      6'b000100: n7769_o = n6236_o;
      6'b000010: n7769_o = 4'b0010;
      6'b000001: n7769_o = n6236_o;
      default: n7769_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7775_o = 2'b00;
      6'b010000: n7775_o = 2'b11;
      6'b001000: n7775_o = 2'b11;
      6'b000100: n7775_o = 2'b11;
      6'b000010: n7775_o = 2'b11;
      6'b000001: n7775_o = 2'b00;
      default: n7775_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7779_o = 2'b00;
      6'b010000: n7779_o = 2'b00;
      6'b001000: n7779_o = 2'b00;
      6'b000100: n7779_o = 2'b00;
      6'b000010: n7779_o = 2'b01;
      6'b000001: n7779_o = 2'b01;
      default: n7779_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7783_o = 2'b00;
      6'b010000: n7783_o = 2'b00;
      6'b001000: n7783_o = 2'b00;
      6'b000100: n7783_o = 2'b11;
      6'b000010: n7783_o = 2'b10;
      6'b000001: n7783_o = 2'b00;
      default: n7783_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7786_o = 1'b0;
      6'b010000: n7786_o = 1'b0;
      6'b001000: n7786_o = 1'b1;
      6'b000100: n7786_o = 1'b0;
      6'b000010: n7786_o = 1'b0;
      6'b000001: n7786_o = 1'b0;
      default: n7786_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7789_o = 1'b0;
      6'b010000: n7789_o = 1'b1;
      6'b001000: n7789_o = 1'b0;
      6'b000100: n7789_o = 1'b0;
      6'b000010: n7789_o = 1'b0;
      6'b000001: n7789_o = 1'b0;
      default: n7789_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7792_o = 1'b0;
      6'b010000: n7792_o = 1'b0;
      6'b001000: n7792_o = 1'b0;
      6'b000100: n7792_o = 1'b0;
      6'b000010: n7792_o = 1'b0;
      6'b000001: n7792_o = 1'b1;
      default: n7792_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7795_o = 1'b0;
      6'b010000: n7795_o = 1'b0;
      6'b001000: n7795_o = 1'b0;
      6'b000100: n7795_o = 1'b0;
      6'b000010: n7795_o = 1'b1;
      6'b000001: n7795_o = 1'b0;
      default: n7795_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7798_o = 1'b0;
      6'b010000: n7798_o = 1'b1;
      6'b001000: n7798_o = 1'b0;
      6'b000100: n7798_o = 1'b0;
      6'b000010: n7798_o = 1'b0;
      6'b000001: n7798_o = 1'b0;
      default: n7798_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7801_o = 1'b0;
      6'b010000: n7801_o = 1'b1;
      6'b001000: n7801_o = n7751_o;
      6'b000100: n7801_o = 1'b0;
      6'b000010: n7801_o = 1'b0;
      6'b000001: n7801_o = 1'b0;
      default: n7801_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1013:11  */
  always @*
    case (n7767_o)
      6'b100000: n7803_o = n7764_o;
      6'b010000: n7803_o = 1'b0;
      6'b001000: n7803_o = 1'b0;
      6'b000100: n7803_o = 1'b0;
      6'b000010: n7803_o = 1'b0;
      6'b000001: n7803_o = 1'b0;
      default: n7803_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1046:16  */
  assign n7804_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:1046:29  */
  assign n7806_o = n7804_o != 2'b10;
  /* ./T65/T65_MCode.vhd:1047:20  */
  assign n7808_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:1047:32  */
  assign n7809_o = ir[4];
  /* ./T65/T65_MCode.vhd:1047:35  */
  assign n7810_o = ~n7809_o;
  /* ./T65/T65_MCode.vhd:1047:27  */
  assign n7811_o = n7808_o | n7810_o;
  /* ./T65/T65_MCode.vhd:1047:45  */
  assign n7812_o = ir[1:0];
  /* ./T65/T65_MCode.vhd:1047:57  */
  assign n7814_o = n7812_o != 2'b00;
  /* ./T65/T65_MCode.vhd:1047:40  */
  assign n7815_o = n7811_o | n7814_o;
  /* ./T65/T65_MCode.vhd:1046:11  */
  assign n7817_o = n7818_o ? 1'b1 : n6209_o;
  /* ./T65/T65_MCode.vhd:1046:11  */
  assign n7818_o = n7815_o & n7806_o;
  /* ./T65/T65_MCode.vhd:1052:13  */
  assign n7820_o = mcycle == 3'b000;
  /* ./T65/T65_MCode.vhd:1053:13  */
  assign n7822_o = mcycle == 3'b001;
  /* ./T65/T65_MCode.vhd:1059:20  */
  assign n7823_o = ir[7:6];
  /* ./T65/T65_MCode.vhd:1059:32  */
  assign n7825_o = n7823_o == 2'b10;
  /* ./T65/T65_MCode.vhd:1059:44  */
  assign n7826_o = ir[4:1];
  /* ./T65/T65_MCode.vhd:1059:56  */
  assign n7828_o = n7826_o == 4'b1111;
  /* ./T65/T65_MCode.vhd:1059:38  */
  assign n7829_o = n7828_o & n7825_o;
  /* ./T65/T65_MCode.vhd:1059:15  */
  assign n7832_o = n7829_o ? 4'b0011 : 4'b0010;
  /* ./T65/T65_MCode.vhd:1056:13  */
  assign n7834_o = mcycle == 3'b010;
  /* ./T65/T65_MCode.vhd:1069:20  */
  assign n7835_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1069:33  */
  assign n7837_o = n7835_o == 3'b100;
  /* ./T65/T65_MCode.vhd:1071:24  */
  assign n7838_o = ir[1:0];
  /* ./T65/T65_MCode.vhd:1072:17  */
  assign n7840_o = n7838_o == 2'b00;
  /* ./T65/T65_MCode.vhd:1072:26  */
  assign n7842_o = n7838_o == 2'b10;
  /* ./T65/T65_MCode.vhd:1072:26  */
  assign n7843_o = n7840_o | n7842_o;
  /* ./T65/T65_MCode.vhd:1073:17  */
  assign n7845_o = n7838_o == 2'b11;
  assign n7846_o = {n7845_o, n7843_o};
  /* ./T65/T65_MCode.vhd:1071:17  */
  always @*
    case (n7846_o)
      2'b10: n7850_o = 2'b10;
      2'b01: n7850_o = 2'b01;
      default: n7850_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1069:15  */
  assign n7852_o = n7837_o ? n7850_o : 2'b00;
  /* ./T65/T65_MCode.vhd:1069:15  */
  assign n7855_o = n7837_o ? 1'b0 : 1'b1;
  /* ./T65/T65_MCode.vhd:1069:15  */
  assign n7858_o = n7837_o ? 1'b1 : 1'b0;
  /* ./T65/T65_MCode.vhd:1067:13  */
  assign n7860_o = mcycle == 3'b011;
  /* ./T65/T65_MCode.vhd:1080:13  */
  assign n7862_o = mcycle == 3'b100;
  assign n7863_o = {n7862_o, n7860_o, n7834_o, n7822_o, n7820_o};
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7864_o = n6236_o;
      5'b01000: n7864_o = n6236_o;
      5'b00100: n7864_o = n7832_o;
      5'b00010: n7864_o = n6236_o;
      5'b00001: n7864_o = n6236_o;
      default: n7864_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7868_o = 2'b00;
      5'b01000: n7868_o = 2'b11;
      5'b00100: n7868_o = 2'b11;
      5'b00010: n7868_o = 2'b00;
      5'b00001: n7868_o = 2'b00;
      default: n7868_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7872_o = 2'b00;
      5'b01000: n7872_o = 2'b00;
      5'b00100: n7872_o = 2'b01;
      5'b00010: n7872_o = 2'b01;
      5'b00001: n7872_o = 2'b00;
      default: n7872_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7876_o = 2'b00;
      5'b01000: n7876_o = 2'b11;
      5'b00100: n7876_o = 2'b10;
      5'b00010: n7876_o = 2'b00;
      5'b00001: n7876_o = 2'b00;
      default: n7876_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7878_o = 2'b00;
      5'b01000: n7878_o = n7852_o;
      5'b00100: n7878_o = 2'b00;
      5'b00010: n7878_o = 2'b00;
      5'b00001: n7878_o = 2'b00;
      default: n7878_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7880_o = 1'b0;
      5'b01000: n7880_o = n7855_o;
      5'b00100: n7880_o = 1'b0;
      5'b00010: n7880_o = 1'b0;
      5'b00001: n7880_o = 1'b0;
      default: n7880_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7883_o = 1'b0;
      5'b01000: n7883_o = 1'b0;
      5'b00100: n7883_o = 1'b0;
      5'b00010: n7883_o = 1'b1;
      5'b00001: n7883_o = 1'b0;
      default: n7883_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7886_o = 1'b0;
      5'b01000: n7886_o = 1'b0;
      5'b00100: n7886_o = 1'b1;
      5'b00010: n7886_o = 1'b0;
      5'b00001: n7886_o = 1'b0;
      default: n7886_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1051:11  */
  always @*
    case (n7863_o)
      5'b10000: n7888_o = 1'b0;
      5'b01000: n7888_o = n7858_o;
      5'b00100: n7888_o = 1'b0;
      5'b00010: n7888_o = 1'b0;
      5'b00001: n7888_o = 1'b0;
      default: n7888_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7891_o = n7734_o ? 3'b110 : 3'b100;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7892_o = n7734_o ? n7769_o : n7864_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7893_o = n7734_o ? n7775_o : n7868_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7894_o = n7734_o ? n7779_o : n7872_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7895_o = n7734_o ? n7783_o : n7876_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7897_o = n7734_o ? 2'b00 : n7878_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7899_o = n7734_o ? 1'b0 : n7880_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7900_o = n7734_o ? n7740_o : n7817_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7902_o = n7734_o ? n7786_o : 1'b0;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7904_o = n7734_o ? n7789_o : 1'b0;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7905_o = n7734_o ? n7792_o : n7883_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7906_o = n7734_o ? n7795_o : n7886_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7908_o = n7734_o ? n7798_o : 1'b0;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7909_o = n7734_o ? n7801_o : n7888_o;
  /* ./T65/T65_MCode.vhd:1007:9  */
  assign n7911_o = n7734_o ? n7803_o : 1'b0;
  /* ./T65/T65_MCode.vhd:1005:7  */
  assign n7913_o = n6237_o == 5'b11100;
  /* ./T65/T65_MCode.vhd:1005:20  */
  assign n7915_o = n6237_o == 5'b11101;
  /* ./T65/T65_MCode.vhd:1005:20  */
  assign n7916_o = n7913_o | n7915_o;
  /* ./T65/T65_MCode.vhd:1005:30  */
  assign n7918_o = n6237_o == 5'b11110;
  /* ./T65/T65_MCode.vhd:1005:30  */
  assign n7919_o = n7916_o | n7918_o;
  /* ./T65/T65_MCode.vhd:1005:40  */
  assign n7921_o = n6237_o == 5'b11111;
  /* ./T65/T65_MCode.vhd:1005:40  */
  assign n7922_o = n7919_o | n7921_o;
  assign n7923_o = {n7922_o, n7723_o, n7609_o, n7454_o, n7333_o, n7311_o, n7178_o, n7042_o, n6919_o, n6885_o, n6852_o, n6807_o, n6795_o, n6696_o};
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7926_o = n7891_o;
      14'b01000000000000: n7926_o = n7621_o;
      14'b00100000000000: n7926_o = n7581_o;
      14'b00010000000000: n7926_o = n7345_o;
      14'b00001000000000: n7926_o = n7314_o;
      14'b00000100000000: n7926_o = n7288_o;
      14'b00000010000000: n7926_o = n7164_o;
      14'b00000001000000: n7926_o = n7020_o;
      14'b00000000100000: n7926_o = 3'b010;
      14'b00000000010000: n7926_o = 3'b001;
      14'b00000000001000: n7926_o = 3'b001;
      14'b00000000000100: n7926_o = 3'b001;
      14'b00000000000010: n7926_o = n6708_o;
      14'b00000000000001: n7926_o = n6653_o;
      default: n7926_o = 3'b001;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7928_o = n7892_o;
      14'b01000000000000: n7928_o = n7681_o;
      14'b00100000000000: n7928_o = n7582_o;
      14'b00010000000000: n7928_o = n7407_o;
      14'b00001000000000: n7928_o = n6236_o;
      14'b00000100000000: n7928_o = n7289_o;
      14'b00000010000000: n7928_o = n6236_o;
      14'b00000001000000: n7928_o = n7021_o;
      14'b00000000100000: n7928_o = n6236_o;
      14'b00000000010000: n7928_o = n6236_o;
      14'b00000000001000: n7928_o = n6846_o;
      14'b00000000000100: n7928_o = n6236_o;
      14'b00000000000010: n7928_o = n6751_o;
      14'b00000000000001: n7928_o = n6655_o;
      default: n7928_o = n6236_o;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7930_o = n7893_o;
      14'b01000000000000: n7930_o = n7686_o;
      14'b00100000000000: n7930_o = n7583_o;
      14'b00010000000000: n7930_o = n7414_o;
      14'b00001000000000: n7930_o = 2'b00;
      14'b00000100000000: n7930_o = n7290_o;
      14'b00000010000000: n7930_o = n7165_o;
      14'b00000001000000: n7930_o = n7022_o;
      14'b00000000100000: n7930_o = n6907_o;
      14'b00000000010000: n7930_o = 2'b00;
      14'b00000000001000: n7930_o = 2'b00;
      14'b00000000000100: n7930_o = 2'b00;
      14'b00000000000010: n7930_o = n6758_o;
      14'b00000000000001: n7930_o = n6657_o;
      default: n7930_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7932_o = n6206_o;
      14'b01000000000000: n7932_o = n6206_o;
      14'b00100000000000: n7932_o = n6206_o;
      14'b00010000000000: n7932_o = n6206_o;
      14'b00001000000000: n7932_o = n6206_o;
      14'b00000100000000: n7932_o = n6206_o;
      14'b00000010000000: n7932_o = n6206_o;
      14'b00000001000000: n7932_o = n6206_o;
      14'b00000000100000: n7932_o = n6206_o;
      14'b00000000010000: n7932_o = n6206_o;
      14'b00000000001000: n7932_o = n6206_o;
      14'b00000000000100: n7932_o = n6206_o;
      14'b00000000000010: n7932_o = n6206_o;
      14'b00000000000001: n7932_o = n6658_o;
      default: n7932_o = n6206_o;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7934_o = n7894_o;
      14'b01000000000000: n7934_o = n7690_o;
      14'b00100000000000: n7934_o = n7584_o;
      14'b00010000000000: n7934_o = n7417_o;
      14'b00001000000000: n7934_o = n7325_o;
      14'b00000100000000: n7934_o = n7291_o;
      14'b00000010000000: n7934_o = n7166_o;
      14'b00000001000000: n7934_o = n7023_o;
      14'b00000000100000: n7934_o = n6910_o;
      14'b00000000010000: n7934_o = n6879_o;
      14'b00000000001000: n7934_o = n6848_o;
      14'b00000000000100: n7934_o = n6805_o;
      14'b00000000000010: n7934_o = n6761_o;
      14'b00000000000001: n7934_o = n6660_o;
      default: n7934_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7937_o = n7895_o;
      14'b01000000000000: n7937_o = n7694_o;
      14'b00100000000000: n7937_o = 2'b00;
      14'b00010000000000: n7937_o = n7422_o;
      14'b00001000000000: n7937_o = 2'b00;
      14'b00000100000000: n7937_o = 2'b00;
      14'b00000010000000: n7937_o = n7168_o;
      14'b00000001000000: n7937_o = 2'b00;
      14'b00000000100000: n7937_o = 2'b00;
      14'b00000000010000: n7937_o = 2'b00;
      14'b00000000001000: n7937_o = 2'b00;
      14'b00000000000100: n7937_o = 2'b00;
      14'b00000000000010: n7937_o = n6764_o;
      14'b00000000000001: n7937_o = 2'b00;
      default: n7937_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7940_o = n7897_o;
      14'b01000000000000: n7940_o = n7696_o;
      14'b00100000000000: n7940_o = 2'b00;
      14'b00010000000000: n7940_o = n7424_o;
      14'b00001000000000: n7940_o = 2'b00;
      14'b00000100000000: n7940_o = 2'b00;
      14'b00000010000000: n7940_o = 2'b00;
      14'b00000001000000: n7940_o = 2'b00;
      14'b00000000100000: n7940_o = 2'b00;
      14'b00000000010000: n7940_o = 2'b00;
      14'b00000000001000: n7940_o = 2'b00;
      14'b00000000000100: n7940_o = 2'b00;
      14'b00000000000010: n7940_o = 2'b00;
      14'b00000000000001: n7940_o = 2'b00;
      default: n7940_o = 2'b00;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7943_o = n7899_o;
      14'b01000000000000: n7943_o = n7698_o;
      14'b00100000000000: n7943_o = 1'b0;
      14'b00010000000000: n7943_o = n7426_o;
      14'b00001000000000: n7943_o = 1'b0;
      14'b00000100000000: n7943_o = 1'b0;
      14'b00000010000000: n7943_o = 1'b0;
      14'b00000001000000: n7943_o = 1'b0;
      14'b00000000100000: n7943_o = 1'b0;
      14'b00000000010000: n7943_o = 1'b0;
      14'b00000000001000: n7943_o = 1'b0;
      14'b00000000000100: n7943_o = 1'b0;
      14'b00000000000010: n7943_o = 1'b0;
      14'b00000000000001: n7943_o = 1'b0;
      default: n7943_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7946_o = 1'b0;
      14'b01000000000000: n7946_o = 1'b0;
      14'b00100000000000: n7946_o = n7585_o;
      14'b00010000000000: n7946_o = 1'b0;
      14'b00001000000000: n7946_o = 1'b0;
      14'b00000100000000: n7946_o = 1'b0;
      14'b00000010000000: n7946_o = 1'b0;
      14'b00000001000000: n7946_o = 1'b0;
      14'b00000000100000: n7946_o = 1'b0;
      14'b00000000010000: n7946_o = 1'b0;
      14'b00000000001000: n7946_o = 1'b0;
      14'b00000000000100: n7946_o = 1'b0;
      14'b00000000000010: n7946_o = n6767_o;
      14'b00000000000001: n7946_o = 1'b0;
      default: n7946_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7949_o = 1'b0;
      14'b01000000000000: n7949_o = 1'b0;
      14'b00100000000000: n7949_o = n7587_o;
      14'b00010000000000: n7949_o = 1'b0;
      14'b00001000000000: n7949_o = 1'b0;
      14'b00000100000000: n7949_o = 1'b0;
      14'b00000010000000: n7949_o = 1'b0;
      14'b00000001000000: n7949_o = 1'b0;
      14'b00000000100000: n7949_o = 1'b0;
      14'b00000000010000: n7949_o = 1'b0;
      14'b00000000001000: n7949_o = 1'b0;
      14'b00000000000100: n7949_o = 1'b0;
      14'b00000000000010: n7949_o = 1'b0;
      14'b00000000000001: n7949_o = 1'b0;
      default: n7949_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7952_o = 1'b0;
      14'b01000000000000: n7952_o = 1'b0;
      14'b00100000000000: n7952_o = 1'b0;
      14'b00010000000000: n7952_o = 1'b0;
      14'b00001000000000: n7952_o = n7328_o;
      14'b00000100000000: n7952_o = 1'b0;
      14'b00000010000000: n7952_o = 1'b0;
      14'b00000001000000: n7952_o = 1'b0;
      14'b00000000100000: n7952_o = 1'b0;
      14'b00000000010000: n7952_o = 1'b0;
      14'b00000000001000: n7952_o = 1'b0;
      14'b00000000000100: n7952_o = 1'b0;
      14'b00000000000010: n7952_o = 1'b0;
      14'b00000000000001: n7952_o = 1'b0;
      default: n7952_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7955_o = 1'b0;
      14'b01000000000000: n7955_o = 1'b0;
      14'b00100000000000: n7955_o = 1'b0;
      14'b00010000000000: n7955_o = 1'b0;
      14'b00001000000000: n7955_o = 1'b0;
      14'b00000100000000: n7955_o = 1'b0;
      14'b00000010000000: n7955_o = 1'b0;
      14'b00000001000000: n7955_o = 1'b0;
      14'b00000000100000: n7955_o = 1'b0;
      14'b00000000010000: n7955_o = 1'b0;
      14'b00000000001000: n7955_o = 1'b0;
      14'b00000000000100: n7955_o = 1'b0;
      14'b00000000000010: n7955_o = 1'b0;
      14'b00000000000001: n7955_o = n6662_o;
      default: n7955_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7958_o = 1'b0;
      14'b01000000000000: n7958_o = 1'b0;
      14'b00100000000000: n7958_o = 1'b0;
      14'b00010000000000: n7958_o = 1'b0;
      14'b00001000000000: n7958_o = 1'b0;
      14'b00000100000000: n7958_o = 1'b0;
      14'b00000010000000: n7958_o = 1'b0;
      14'b00000001000000: n7958_o = 1'b0;
      14'b00000000100000: n7958_o = 1'b0;
      14'b00000000010000: n7958_o = 1'b0;
      14'b00000000001000: n7958_o = 1'b0;
      14'b00000000000100: n7958_o = 1'b0;
      14'b00000000000010: n7958_o = 1'b0;
      14'b00000000000001: n7958_o = n6664_o;
      default: n7958_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7960_o = n7900_o;
      14'b01000000000000: n7960_o = n7624_o;
      14'b00100000000000: n7960_o = n7588_o;
      14'b00010000000000: n7960_o = n7348_o;
      14'b00001000000000: n7960_o = n6209_o;
      14'b00000100000000: n7960_o = n7292_o;
      14'b00000010000000: n7960_o = n6209_o;
      14'b00000001000000: n7960_o = n7024_o;
      14'b00000000100000: n7960_o = n6209_o;
      14'b00000000010000: n7960_o = n6209_o;
      14'b00000000001000: n7960_o = n6849_o;
      14'b00000000000100: n7960_o = n6800_o;
      14'b00000000000010: n7960_o = n6711_o;
      14'b00000000000001: n7960_o = n6667_o;
      default: n7960_o = n6209_o;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7962_o = 1'b0;
      14'b01000000000000: n7962_o = 1'b0;
      14'b00100000000000: n7962_o = 1'b0;
      14'b00010000000000: n7962_o = 1'b0;
      14'b00001000000000: n7962_o = 1'b0;
      14'b00000100000000: n7962_o = 1'b0;
      14'b00000010000000: n7962_o = 1'b0;
      14'b00000001000000: n7962_o = 1'b0;
      14'b00000000100000: n7962_o = 1'b0;
      14'b00000000010000: n7962_o = 1'b0;
      14'b00000000001000: n7962_o = 1'b0;
      14'b00000000000100: n7962_o = 1'b0;
      14'b00000000000010: n7962_o = 1'b0;
      14'b00000000000001: n7962_o = n6669_o;
      default: n7962_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7964_o = n6212_o;
      14'b01000000000000: n7964_o = n6212_o;
      14'b00100000000000: n7964_o = n6212_o;
      14'b00010000000000: n7964_o = n6212_o;
      14'b00001000000000: n7964_o = n6212_o;
      14'b00000100000000: n7964_o = n6212_o;
      14'b00000010000000: n7964_o = n6212_o;
      14'b00000001000000: n7964_o = n6212_o;
      14'b00000000100000: n7964_o = n6212_o;
      14'b00000000010000: n7964_o = n6880_o;
      14'b00000000001000: n7964_o = n6850_o;
      14'b00000000000100: n7964_o = n6212_o;
      14'b00000000000010: n7964_o = n6212_o;
      14'b00000000000001: n7964_o = n6672_o;
      default: n7964_o = n6212_o;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7965_o = n6215_o;
      14'b01000000000000: n7965_o = n6215_o;
      14'b00100000000000: n7965_o = n6215_o;
      14'b00010000000000: n7965_o = n6215_o;
      14'b00001000000000: n7965_o = n6215_o;
      14'b00000100000000: n7965_o = n6215_o;
      14'b00000010000000: n7965_o = n6215_o;
      14'b00000001000000: n7965_o = n6215_o;
      14'b00000000100000: n7965_o = n6215_o;
      14'b00000000010000: n7965_o = n6215_o;
      14'b00000000001000: n7965_o = n6215_o;
      14'b00000000000100: n7965_o = n6215_o;
      14'b00000000000010: n7965_o = n6215_o;
      14'b00000000000001: n7965_o = n6674_o;
      default: n7965_o = n6215_o;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7966_o = n6218_o;
      14'b01000000000000: n7966_o = n6218_o;
      14'b00100000000000: n7966_o = n6218_o;
      14'b00010000000000: n7966_o = n6218_o;
      14'b00001000000000: n7966_o = n6218_o;
      14'b00000100000000: n7966_o = n6218_o;
      14'b00000010000000: n7966_o = n6218_o;
      14'b00000001000000: n7966_o = n6218_o;
      14'b00000000100000: n7966_o = n6218_o;
      14'b00000000010000: n7966_o = n6218_o;
      14'b00000000001000: n7966_o = n6218_o;
      14'b00000000000100: n7966_o = n6218_o;
      14'b00000000000010: n7966_o = n6218_o;
      14'b00000000000001: n7966_o = n6676_o;
      default: n7966_o = n6218_o;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7968_o = n7902_o;
      14'b01000000000000: n7968_o = n7700_o;
      14'b00100000000000: n7968_o = n7590_o;
      14'b00010000000000: n7968_o = n7428_o;
      14'b00001000000000: n7968_o = n7331_o;
      14'b00000100000000: n7968_o = n7294_o;
      14'b00000010000000: n7968_o = n7170_o;
      14'b00000001000000: n7968_o = n7026_o;
      14'b00000000100000: n7968_o = 1'b0;
      14'b00000000010000: n7968_o = 1'b0;
      14'b00000000001000: n7968_o = 1'b0;
      14'b00000000000100: n7968_o = 1'b0;
      14'b00000000000010: n7968_o = n6769_o;
      14'b00000000000001: n7968_o = n6678_o;
      default: n7968_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7971_o = n7904_o;
      14'b01000000000000: n7971_o = n7703_o;
      14'b00100000000000: n7971_o = n7592_o;
      14'b00010000000000: n7971_o = n7431_o;
      14'b00001000000000: n7971_o = 1'b0;
      14'b00000100000000: n7971_o = n7296_o;
      14'b00000010000000: n7971_o = 1'b0;
      14'b00000001000000: n7971_o = n7028_o;
      14'b00000000100000: n7971_o = 1'b0;
      14'b00000000010000: n7971_o = 1'b0;
      14'b00000000001000: n7971_o = 1'b0;
      14'b00000000000100: n7971_o = 1'b0;
      14'b00000000000010: n7971_o = n6772_o;
      14'b00000000000001: n7971_o = 1'b0;
      default: n7971_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7974_o = 1'b0;
      14'b01000000000000: n7974_o = 1'b0;
      14'b00100000000000: n7974_o = n7593_o;
      14'b00010000000000: n7974_o = n7434_o;
      14'b00001000000000: n7974_o = 1'b0;
      14'b00000100000000: n7974_o = 1'b0;
      14'b00000010000000: n7974_o = 1'b0;
      14'b00000001000000: n7974_o = n7029_o;
      14'b00000000100000: n7974_o = n6913_o;
      14'b00000000010000: n7974_o = 1'b0;
      14'b00000000001000: n7974_o = 1'b0;
      14'b00000000000100: n7974_o = 1'b0;
      14'b00000000000010: n7974_o = n6775_o;
      14'b00000000000001: n7974_o = 1'b0;
      default: n7974_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7977_o = n7905_o;
      14'b01000000000000: n7977_o = n7706_o;
      14'b00100000000000: n7977_o = 1'b0;
      14'b00010000000000: n7977_o = n7437_o;
      14'b00001000000000: n7977_o = 1'b0;
      14'b00000100000000: n7977_o = n7297_o;
      14'b00000010000000: n7977_o = n7171_o;
      14'b00000001000000: n7977_o = 1'b0;
      14'b00000000100000: n7977_o = 1'b0;
      14'b00000000010000: n7977_o = 1'b0;
      14'b00000000001000: n7977_o = 1'b0;
      14'b00000000000100: n7977_o = 1'b0;
      14'b00000000000010: n7977_o = n6778_o;
      14'b00000000000001: n7977_o = 1'b0;
      default: n7977_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7980_o = n7906_o;
      14'b01000000000000: n7980_o = n7709_o;
      14'b00100000000000: n7980_o = 1'b0;
      14'b00010000000000: n7980_o = n7440_o;
      14'b00001000000000: n7980_o = 1'b0;
      14'b00000100000000: n7980_o = n7298_o;
      14'b00000010000000: n7980_o = n7172_o;
      14'b00000001000000: n7980_o = 1'b0;
      14'b00000000100000: n7980_o = 1'b0;
      14'b00000000010000: n7980_o = 1'b0;
      14'b00000000001000: n7980_o = 1'b0;
      14'b00000000000100: n7980_o = 1'b0;
      14'b00000000000010: n7980_o = n6781_o;
      14'b00000000000001: n7980_o = 1'b0;
      default: n7980_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7983_o = n7908_o;
      14'b01000000000000: n7983_o = n7712_o;
      14'b00100000000000: n7983_o = n7595_o;
      14'b00010000000000: n7983_o = n7443_o;
      14'b00001000000000: n7983_o = 1'b0;
      14'b00000100000000: n7983_o = n7300_o;
      14'b00000010000000: n7983_o = n7174_o;
      14'b00000001000000: n7983_o = n7031_o;
      14'b00000000100000: n7983_o = n6915_o;
      14'b00000000010000: n7983_o = 1'b0;
      14'b00000000001000: n7983_o = 1'b0;
      14'b00000000000100: n7983_o = 1'b0;
      14'b00000000000010: n7983_o = n6784_o;
      14'b00000000000001: n7983_o = n6680_o;
      default: n7983_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7986_o = n7909_o;
      14'b01000000000000: n7986_o = n7715_o;
      14'b00100000000000: n7986_o = n7596_o;
      14'b00010000000000: n7986_o = n7446_o;
      14'b00001000000000: n7986_o = 1'b0;
      14'b00000100000000: n7986_o = n7301_o;
      14'b00000010000000: n7986_o = n7176_o;
      14'b00000001000000: n7986_o = n7032_o;
      14'b00000000100000: n7986_o = n6917_o;
      14'b00000000010000: n7986_o = 1'b0;
      14'b00000000001000: n7986_o = 1'b0;
      14'b00000000000100: n7986_o = 1'b0;
      14'b00000000000010: n7986_o = n6787_o;
      14'b00000000000001: n7986_o = n6682_o;
      default: n7986_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:234:5  */
  always @*
    case (n7923_o)
      14'b10000000000000: n7989_o = n7911_o;
      14'b01000000000000: n7989_o = n7718_o;
      14'b00100000000000: n7989_o = n7598_o;
      14'b00010000000000: n7989_o = n7449_o;
      14'b00001000000000: n7989_o = 1'b0;
      14'b00000100000000: n7989_o = n7303_o;
      14'b00000010000000: n7989_o = 1'b0;
      14'b00000001000000: n7989_o = n7034_o;
      14'b00000000100000: n7989_o = 1'b0;
      14'b00000000010000: n7989_o = 1'b0;
      14'b00000000001000: n7989_o = 1'b0;
      14'b00000000000100: n7989_o = 1'b0;
      14'b00000000000010: n7989_o = n6790_o;
      14'b00000000000001: n7989_o = 1'b0;
      default: n7989_o = 1'b0;
    endcase
  /* ./T65/T65_MCode.vhd:1092:12  */
  assign n7994_o = ir[1:0];
  /* ./T65/T65_MCode.vhd:1094:16  */
  assign n7995_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:1099:18  */
  assign n7996_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1100:13  */
  assign n7998_o = n7996_o == 3'b110;
  /* ./T65/T65_MCode.vhd:1100:24  */
  assign n8000_o = n7996_o == 3'b111;
  /* ./T65/T65_MCode.vhd:1100:24  */
  assign n8001_o = n7998_o | n8000_o;
  /* ./T65/T65_MCode.vhd:1102:13  */
  assign n8003_o = n7996_o == 3'b101;
  /* ./T65/T65_MCode.vhd:1104:13  */
  assign n8005_o = n7996_o == 3'b001;
  assign n8006_o = {n8005_o, n8003_o, n8001_o};
  /* ./T65/T65_MCode.vhd:1099:11  */
  always @*
    case (n8006_o)
      3'b100: n8011_o = 5'b01100;
      3'b010: n8011_o = 5'b00101;
      3'b001: n8011_o = 5'b00110;
      default: n8011_o = 5'b00100;
    endcase
  /* ./T65/T65_MCode.vhd:1098:9  */
  assign n8013_o = n7995_o == 3'b000;
  /* ./T65/T65_MCode.vhd:1098:20  */
  assign n8015_o = n7995_o == 3'b001;
  /* ./T65/T65_MCode.vhd:1098:20  */
  assign n8016_o = n8013_o | n8015_o;
  /* ./T65/T65_MCode.vhd:1098:28  */
  assign n8018_o = n7995_o == 3'b011;
  /* ./T65/T65_MCode.vhd:1098:28  */
  assign n8019_o = n8016_o | n8018_o;
  /* ./T65/T65_MCode.vhd:1112:18  */
  assign n8020_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1113:13  */
  assign n8022_o = n8020_o == 3'b111;
  /* ./T65/T65_MCode.vhd:1113:24  */
  assign n8024_o = n8020_o == 3'b110;
  /* ./T65/T65_MCode.vhd:1113:24  */
  assign n8025_o = n8022_o | n8024_o;
  /* ./T65/T65_MCode.vhd:1115:13  */
  assign n8027_o = n8020_o == 3'b100;
  assign n8028_o = {n8027_o, n8025_o};
  /* ./T65/T65_MCode.vhd:1112:11  */
  always @*
    case (n8028_o)
      2'b10: n8032_o = 5'b01101;
      2'b01: n8032_o = 5'b01110;
      default: n8032_o = 5'b00101;
    endcase
  /* ./T65/T65_MCode.vhd:1111:9  */
  assign n8034_o = n7995_o == 3'b010;
  /* ./T65/T65_MCode.vhd:1123:18  */
  assign n8035_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1124:13  */
  assign n8037_o = n8035_o == 3'b100;
  /* ./T65/T65_MCode.vhd:1123:11  */
  always @*
    case (n8037_o)
      1'b1: n8040_o = 5'b00101;
      default: n8040_o = 5'b00100;
    endcase
  /* ./T65/T65_MCode.vhd:1122:9  */
  assign n8042_o = n7995_o == 3'b110;
  /* ./T65/T65_MCode.vhd:1134:18  */
  assign n8043_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1135:13  */
  assign n8045_o = n8043_o == 3'b101;
  /* ./T65/T65_MCode.vhd:1134:11  */
  always @*
    case (n8045_o)
      1'b1: n8048_o = 5'b00101;
      default: n8048_o = 5'b00100;
    endcase
  assign n8049_o = {n8042_o, n8034_o, n8019_o};
  /* ./T65/T65_MCode.vhd:1094:9  */
  always @*
    case (n8049_o)
      3'b100: n8050_o = n8040_o;
      3'b010: n8050_o = n8032_o;
      3'b001: n8050_o = n8011_o;
      default: n8050_o = n8048_o;
    endcase
  /* ./T65/T65_MCode.vhd:1093:7  */
  assign n8052_o = n7994_o == 2'b00;
  /* ./T65/T65_MCode.vhd:1143:36  */
  assign n8053_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1143:14  */
  assign n8054_o = {28'b0, n8053_o};  //  uext
  /* ./T65/T65_MCode.vhd:1144:11  */
  assign n8056_o = n8054_o == 31'b0000000000000000000000000000000;
  /* ./T65/T65_MCode.vhd:1146:11  */
  assign n8058_o = n8054_o == 31'b0000000000000000000000000000001;
  /* ./T65/T65_MCode.vhd:1148:11  */
  assign n8060_o = n8054_o == 31'b0000000000000000000000000000010;
  /* ./T65/T65_MCode.vhd:1150:11  */
  assign n8062_o = n8054_o == 31'b0000000000000000000000000000011;
  /* ./T65/T65_MCode.vhd:1152:11  */
  assign n8064_o = n8054_o == 31'b0000000000000000000000000000100;
  /* ./T65/T65_MCode.vhd:1154:11  */
  assign n8066_o = n8054_o == 31'b0000000000000000000000000000101;
  /* ./T65/T65_MCode.vhd:1156:11  */
  assign n8068_o = n8054_o == 31'b0000000000000000000000000000110;
  assign n8069_o = {n8068_o, n8066_o, n8064_o, n8062_o, n8060_o, n8058_o, n8056_o};
  /* ./T65/T65_MCode.vhd:1143:9  */
  always @*
    case (n8069_o)
      7'b1000000: n8078_o = 5'b00110;
      7'b0100000: n8078_o = 5'b00101;
      7'b0010000: n8078_o = 5'b00100;
      7'b0001000: n8078_o = 5'b00011;
      7'b0000100: n8078_o = 5'b00010;
      7'b0000010: n8078_o = 5'b00001;
      7'b0000001: n8078_o = 5'b00000;
      default: n8078_o = 5'b00111;
    endcase
  /* ./T65/T65_MCode.vhd:1142:7  */
  assign n8080_o = n7994_o == 2'b01;
  /* ./T65/T65_MCode.vhd:1163:36  */
  assign n8081_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1163:14  */
  assign n8082_o = {28'b0, n8081_o};  //  uext
  /* ./T65/T65_MCode.vhd:1166:18  */
  assign n8083_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:1166:31  */
  assign n8085_o = n8083_o == 3'b110;
  /* ./T65/T65_MCode.vhd:1166:47  */
  assign n8087_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:1166:39  */
  assign n8088_o = n8087_o & n8085_o;
  /* ./T65/T65_MCode.vhd:1166:13  */
  assign n8091_o = n8088_o ? 5'b01110 : 5'b01000;
  /* ./T65/T65_MCode.vhd:1164:11  */
  assign n8094_o = n8082_o == 31'b0000000000000000000000000000000;
  /* ./T65/T65_MCode.vhd:1171:18  */
  assign n8095_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:1171:31  */
  assign n8097_o = n8095_o == 3'b110;
  /* ./T65/T65_MCode.vhd:1171:47  */
  assign n8099_o = mode != 2'b00;
  /* ./T65/T65_MCode.vhd:1171:39  */
  assign n8100_o = n8099_o & n8097_o;
  /* ./T65/T65_MCode.vhd:1171:13  */
  assign n8103_o = n8100_o ? 5'b01101 : 5'b01001;
  /* ./T65/T65_MCode.vhd:1169:11  */
  assign n8106_o = n8082_o == 31'b0000000000000000000000000000001;
  /* ./T65/T65_MCode.vhd:1174:11  */
  assign n8108_o = n8082_o == 31'b0000000000000000000000000000010;
  /* ./T65/T65_MCode.vhd:1176:11  */
  assign n8110_o = n8082_o == 31'b0000000000000000000000000000011;
  /* ./T65/T65_MCode.vhd:1180:18  */
  assign n8111_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:1180:31  */
  assign n8113_o = n8111_o == 3'b010;
  /* ./T65/T65_MCode.vhd:1180:13  */
  assign n8116_o = n8113_o ? 5'b00101 : 5'b00100;
  /* ./T65/T65_MCode.vhd:1178:11  */
  assign n8119_o = n8082_o == 31'b0000000000000000000000000000100;
  /* ./T65/T65_MCode.vhd:1185:11  */
  assign n8121_o = n8082_o == 31'b0000000000000000000000000000101;
  /* ./T65/T65_MCode.vhd:1187:11  */
  assign n8123_o = n8082_o == 31'b0000000000000000000000000000110;
  assign n8124_o = {n8123_o, n8121_o, n8119_o, n8110_o, n8108_o, n8106_o, n8094_o};
  /* ./T65/T65_MCode.vhd:1163:9  */
  always @*
    case (n8124_o)
      7'b1000000: n8130_o = 5'b01101;
      7'b0100000: n8130_o = 5'b00101;
      7'b0010000: n8130_o = n8116_o;
      7'b0001000: n8130_o = 5'b01011;
      7'b0000100: n8130_o = 5'b01010;
      7'b0000010: n8130_o = n8103_o;
      7'b0000001: n8130_o = n8091_o;
      default: n8130_o = 5'b01110;
    endcase
  /* ./T65/T65_MCode.vhd:1162:7  */
  assign n8132_o = n7994_o == 2'b10;
  /* ./T65/T65_MCode.vhd:1194:36  */
  assign n8133_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1194:14  */
  assign n8134_o = {28'b0, n8133_o};  //  uext
  /* ./T65/T65_MCode.vhd:1197:18  */
  assign n8136_o = ir == 8'b10111011;
  /* ./T65/T65_MCode.vhd:1197:13  */
  assign n8139_o = n8136_o ? 5'b00001 : 5'b00101;
  /* ./T65/T65_MCode.vhd:1196:11  */
  assign n8141_o = n8134_o == 31'b0000000000000000000000000000101;
  /* ./T65/T65_MCode.vhd:1211:18  */
  assign n8143_o = ir == 8'b01101011;
  /* ./T65/T65_MCode.vhd:1213:21  */
  assign n8145_o = ir == 8'b10001011;
  /* ./T65/T65_MCode.vhd:1215:21  */
  assign n8147_o = ir == 8'b00001011;
  /* ./T65/T65_MCode.vhd:1215:33  */
  assign n8149_o = ir == 8'b00101011;
  /* ./T65/T65_MCode.vhd:1215:28  */
  assign n8150_o = n8147_o | n8149_o;
  /* ./T65/T65_MCode.vhd:1217:21  */
  assign n8152_o = ir == 8'b11101011;
  /* ./T65/T65_MCode.vhd:1220:42  */
  assign n8153_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1220:20  */
  assign n8154_o = {28'b0, n8153_o};  //  uext
  /* ./T65/T65_MCode.vhd:1221:17  */
  assign n8156_o = n8154_o == 31'b0000000000000000000000000000000;
  /* ./T65/T65_MCode.vhd:1223:17  */
  assign n8158_o = n8154_o == 31'b0000000000000000000000000000001;
  /* ./T65/T65_MCode.vhd:1225:17  */
  assign n8160_o = n8154_o == 31'b0000000000000000000000000000010;
  /* ./T65/T65_MCode.vhd:1227:17  */
  assign n8162_o = n8154_o == 31'b0000000000000000000000000000011;
  /* ./T65/T65_MCode.vhd:1229:17  */
  assign n8164_o = n8154_o == 31'b0000000000000000000000000000100;
  /* ./T65/T65_MCode.vhd:1231:17  */
  assign n8166_o = n8154_o == 31'b0000000000000000000000000000101;
  /* ./T65/T65_MCode.vhd:1233:17  */
  assign n8168_o = n8154_o == 31'b0000000000000000000000000000110;
  assign n8169_o = {n8168_o, n8166_o, n8164_o, n8162_o, n8160_o, n8158_o, n8156_o};
  /* ./T65/T65_MCode.vhd:1220:15  */
  always @*
    case (n8169_o)
      7'b1000000: n8178_o = 5'b00110;
      7'b0100000: n8178_o = 5'b00101;
      7'b0010000: n8178_o = 5'b00100;
      7'b0001000: n8178_o = 5'b00011;
      7'b0000100: n8178_o = 5'b00010;
      7'b0000010: n8178_o = 5'b00001;
      7'b0000001: n8178_o = 5'b00000;
      default: n8178_o = 5'b00111;
    endcase
  /* ./T65/T65_MCode.vhd:1239:42  */
  assign n8179_o = ir[7:5];
  /* ./T65/T65_MCode.vhd:1239:20  */
  assign n8180_o = {28'b0, n8179_o};  //  uext
  /* ./T65/T65_MCode.vhd:1240:17  */
  assign n8182_o = n8180_o == 31'b0000000000000000000000000000000;
  /* ./T65/T65_MCode.vhd:1242:17  */
  assign n8184_o = n8180_o == 31'b0000000000000000000000000000001;
  /* ./T65/T65_MCode.vhd:1244:17  */
  assign n8186_o = n8180_o == 31'b0000000000000000000000000000010;
  /* ./T65/T65_MCode.vhd:1246:17  */
  assign n8188_o = n8180_o == 31'b0000000000000000000000000000011;
  /* ./T65/T65_MCode.vhd:1248:17  */
  assign n8190_o = n8180_o == 31'b0000000000000000000000000000100;
  /* ./T65/T65_MCode.vhd:1250:17  */
  assign n8192_o = n8180_o == 31'b0000000000000000000000000000101;
  /* ./T65/T65_MCode.vhd:1254:24  */
  assign n8193_o = ir[4:2];
  /* ./T65/T65_MCode.vhd:1254:36  */
  assign n8195_o = n8193_o == 3'b010;
  /* ./T65/T65_MCode.vhd:1254:19  */
  assign n8198_o = n8195_o ? 5'b10001 : 5'b01101;
  /* ./T65/T65_MCode.vhd:1252:17  */
  assign n8201_o = n8180_o == 31'b0000000000000000000000000000110;
  assign n8202_o = {n8201_o, n8192_o, n8190_o, n8188_o, n8186_o, n8184_o, n8182_o};
  /* ./T65/T65_MCode.vhd:1239:15  */
  always @*
    case (n8202_o)
      7'b1000000: n8210_o = n8198_o;
      7'b0100000: n8210_o = 5'b00101;
      7'b0010000: n8210_o = 5'b01100;
      7'b0001000: n8210_o = 5'b01011;
      7'b0000100: n8210_o = 5'b01010;
      7'b0000010: n8210_o = 5'b01001;
      7'b0000001: n8210_o = 5'b01000;
      default: n8210_o = 5'b01110;
    endcase
  /* ./T65/T65_MCode.vhd:1219:13  */
  assign n8211_o = alumore ? n8178_o : n8210_o;
  /* ./T65/T65_MCode.vhd:1217:13  */
  assign n8213_o = n8152_o ? 5'b00111 : n8211_o;
  /* ./T65/T65_MCode.vhd:1215:13  */
  assign n8215_o = n8150_o ? 5'b10000 : n8213_o;
  /* ./T65/T65_MCode.vhd:1213:13  */
  assign n8217_o = n8145_o ? 5'b10010 : n8215_o;
  /* ./T65/T65_MCode.vhd:1211:13  */
  assign n8219_o = n8143_o ? 5'b01111 : n8217_o;
  /* ./T65/T65_MCode.vhd:1194:9  */
  always @*
    case (n8141_o)
      1'b1: n8220_o = n8139_o;
      default: n8220_o = n8219_o;
    endcase
  assign n8221_o = {n8132_o, n8080_o, n8052_o};
  /* ./T65/T65_MCode.vhd:1092:5  */
  always @*
    case (n8221_o)
      3'b100: n8222_o = n8130_o;
      3'b010: n8222_o = n8078_o;
      3'b001: n8222_o = n8050_o;
      default: n8222_o = n8220_o;
    endcase
endmodule

module vgacolortable
  (input  clk,
   input  [3:0] lum,
   input  [3:0] hue,
   input  [1:0] mode,
   output [23:0] outcolor);
  wire [8:0] n4845_o;
  wire [12:0] n4846_o;
  wire [2:0] n4847_o;
  wire [15:0] n4848_o;
  wire n4850_o;
  wire n4852_o;
  wire n4854_o;
  wire n4856_o;
  wire n4858_o;
  wire n4860_o;
  wire n4862_o;
  wire n4864_o;
  wire n4866_o;
  wire n4868_o;
  wire n4870_o;
  wire n4872_o;
  wire n4874_o;
  wire n4876_o;
  wire n4878_o;
  wire n4880_o;
  wire n4882_o;
  wire n4884_o;
  wire n4886_o;
  wire n4888_o;
  wire n4890_o;
  wire n4892_o;
  wire n4894_o;
  wire n4896_o;
  wire n4898_o;
  wire n4900_o;
  wire n4902_o;
  wire n4904_o;
  wire n4906_o;
  wire n4908_o;
  wire n4910_o;
  wire n4912_o;
  wire n4914_o;
  wire n4916_o;
  wire n4918_o;
  wire n4920_o;
  wire n4922_o;
  wire n4924_o;
  wire n4926_o;
  wire n4928_o;
  wire n4930_o;
  wire n4932_o;
  wire n4934_o;
  wire n4936_o;
  wire n4938_o;
  wire n4940_o;
  wire n4942_o;
  wire n4944_o;
  wire n4946_o;
  wire n4948_o;
  wire n4950_o;
  wire n4952_o;
  wire n4954_o;
  wire n4956_o;
  wire n4958_o;
  wire n4960_o;
  wire n4962_o;
  wire n4964_o;
  wire n4966_o;
  wire n4968_o;
  wire n4970_o;
  wire n4972_o;
  wire n4974_o;
  wire n4976_o;
  wire n4978_o;
  wire n4980_o;
  wire n4982_o;
  wire n4984_o;
  wire n4986_o;
  wire n4988_o;
  wire n4990_o;
  wire n4992_o;
  wire n4994_o;
  wire n4996_o;
  wire n4998_o;
  wire n5000_o;
  wire n5002_o;
  wire n5004_o;
  wire n5006_o;
  wire n5008_o;
  wire n5010_o;
  wire n5012_o;
  wire n5014_o;
  wire n5016_o;
  wire n5018_o;
  wire n5020_o;
  wire n5022_o;
  wire n5024_o;
  wire n5026_o;
  wire n5028_o;
  wire n5030_o;
  wire n5032_o;
  wire n5034_o;
  wire n5036_o;
  wire n5038_o;
  wire n5040_o;
  wire n5042_o;
  wire n5044_o;
  wire n5046_o;
  wire n5048_o;
  wire n5050_o;
  wire n5052_o;
  wire n5054_o;
  wire n5056_o;
  wire n5058_o;
  wire n5060_o;
  wire n5062_o;
  wire n5064_o;
  wire n5066_o;
  wire n5068_o;
  wire n5070_o;
  wire n5072_o;
  wire n5074_o;
  wire n5076_o;
  wire n5078_o;
  wire n5080_o;
  wire n5082_o;
  wire n5084_o;
  wire n5086_o;
  wire n5088_o;
  wire n5090_o;
  wire n5092_o;
  wire n5094_o;
  wire n5096_o;
  wire n5098_o;
  wire n5100_o;
  wire n5102_o;
  wire n5104_o;
  wire n5106_o;
  wire n5108_o;
  wire n5110_o;
  wire n5112_o;
  wire n5114_o;
  wire n5116_o;
  wire n5118_o;
  wire n5120_o;
  wire n5122_o;
  wire n5124_o;
  wire n5126_o;
  wire n5128_o;
  wire n5130_o;
  wire n5132_o;
  wire n5134_o;
  wire n5136_o;
  wire n5138_o;
  wire n5140_o;
  wire n5142_o;
  wire n5144_o;
  wire n5146_o;
  wire n5148_o;
  wire n5150_o;
  wire n5152_o;
  wire n5154_o;
  wire n5156_o;
  wire n5158_o;
  wire n5160_o;
  wire n5162_o;
  wire n5164_o;
  wire n5166_o;
  wire n5168_o;
  wire n5170_o;
  wire n5172_o;
  wire n5174_o;
  wire n5176_o;
  wire n5178_o;
  wire n5180_o;
  wire n5182_o;
  wire n5184_o;
  wire n5186_o;
  wire n5188_o;
  wire n5190_o;
  wire n5192_o;
  wire n5194_o;
  wire n5196_o;
  wire n5198_o;
  wire n5200_o;
  wire n5202_o;
  wire n5204_o;
  wire n5206_o;
  wire n5208_o;
  wire n5210_o;
  wire n5212_o;
  wire n5214_o;
  wire n5216_o;
  wire n5218_o;
  wire n5220_o;
  wire n5222_o;
  wire n5224_o;
  wire n5226_o;
  wire n5228_o;
  wire n5230_o;
  wire n5232_o;
  wire n5234_o;
  wire n5236_o;
  wire n5238_o;
  wire n5240_o;
  wire n5242_o;
  wire n5244_o;
  wire n5246_o;
  wire n5248_o;
  wire n5250_o;
  wire n5252_o;
  wire n5254_o;
  wire n5256_o;
  wire n5258_o;
  wire n5260_o;
  wire n5262_o;
  wire n5264_o;
  wire n5266_o;
  wire n5268_o;
  wire n5270_o;
  wire n5272_o;
  wire n5274_o;
  wire n5276_o;
  wire n5278_o;
  wire n5280_o;
  wire n5282_o;
  wire n5284_o;
  wire n5286_o;
  wire n5288_o;
  wire n5290_o;
  wire n5292_o;
  wire n5294_o;
  wire n5296_o;
  wire n5298_o;
  wire n5300_o;
  wire n5302_o;
  wire n5304_o;
  wire n5306_o;
  wire n5308_o;
  wire n5310_o;
  wire n5312_o;
  wire n5314_o;
  wire n5316_o;
  wire n5318_o;
  wire n5320_o;
  wire n5322_o;
  wire n5324_o;
  wire n5326_o;
  wire n5328_o;
  wire n5330_o;
  wire n5332_o;
  wire n5334_o;
  wire n5336_o;
  wire n5338_o;
  wire n5340_o;
  wire n5342_o;
  wire n5344_o;
  wire n5346_o;
  wire n5348_o;
  wire n5350_o;
  wire n5352_o;
  wire n5354_o;
  wire n5356_o;
  wire n5358_o;
  wire n5360_o;
  wire n5362_o;
  wire n5364_o;
  wire n5366_o;
  wire n5368_o;
  wire n5370_o;
  wire n5372_o;
  wire n5374_o;
  wire n5376_o;
  wire n5378_o;
  wire n5380_o;
  wire n5382_o;
  wire n5384_o;
  wire n5386_o;
  wire n5388_o;
  wire n5390_o;
  wire n5392_o;
  wire n5394_o;
  wire n5396_o;
  wire n5398_o;
  wire n5400_o;
  wire n5402_o;
  wire n5404_o;
  wire n5406_o;
  wire n5408_o;
  wire n5410_o;
  wire n5412_o;
  wire n5414_o;
  wire n5416_o;
  wire n5418_o;
  wire n5420_o;
  wire n5422_o;
  wire n5424_o;
  wire n5426_o;
  wire n5428_o;
  wire n5430_o;
  wire n5432_o;
  wire n5434_o;
  wire n5436_o;
  wire n5438_o;
  wire n5440_o;
  wire n5442_o;
  wire n5444_o;
  wire n5446_o;
  wire n5448_o;
  wire n5450_o;
  wire n5452_o;
  wire n5454_o;
  wire n5456_o;
  wire n5458_o;
  wire n5460_o;
  wire n5462_o;
  wire n5464_o;
  wire n5466_o;
  wire n5468_o;
  wire n5470_o;
  wire n5472_o;
  wire n5474_o;
  wire n5476_o;
  wire n5478_o;
  wire n5480_o;
  wire n5482_o;
  wire n5484_o;
  wire n5486_o;
  wire n5488_o;
  wire n5490_o;
  wire n5492_o;
  wire n5494_o;
  wire n5496_o;
  wire n5498_o;
  wire n5500_o;
  wire n5502_o;
  wire n5504_o;
  wire n5506_o;
  wire n5508_o;
  wire n5510_o;
  wire n5512_o;
  wire n5514_o;
  wire n5516_o;
  wire n5518_o;
  wire n5520_o;
  wire n5522_o;
  wire n5524_o;
  wire n5526_o;
  wire n5528_o;
  wire n5530_o;
  wire n5532_o;
  wire n5534_o;
  wire n5536_o;
  wire n5538_o;
  wire n5540_o;
  wire n5542_o;
  wire n5544_o;
  wire n5546_o;
  wire n5548_o;
  wire n5550_o;
  wire n5552_o;
  wire n5554_o;
  wire n5556_o;
  wire n5558_o;
  wire n5560_o;
  wire n5562_o;
  wire n5564_o;
  wire n5566_o;
  wire n5568_o;
  wire n5570_o;
  wire n5572_o;
  wire n5574_o;
  wire n5576_o;
  wire n5578_o;
  wire n5580_o;
  wire n5582_o;
  wire n5584_o;
  wire n5586_o;
  wire n5588_o;
  wire n5590_o;
  wire n5592_o;
  wire n5594_o;
  wire n5596_o;
  wire n5598_o;
  wire n5600_o;
  wire n5602_o;
  wire n5604_o;
  wire n5606_o;
  wire n5608_o;
  wire n5610_o;
  wire n5612_o;
  wire n5614_o;
  wire n5616_o;
  wire [383:0] n5617_o;
  reg [23:0] n6003_o;
  reg [23:0] n6006_q;
  assign outcolor = n6006_q;
  /* ./TIA/VGAColorTable.vhd:40:40  */
  assign n4845_o = {7'b0000000, mode};
  /* ./TIA/VGAColorTable.vhd:40:47  */
  assign n4846_o = {n4845_o, hue};
  /* ./TIA/VGAColorTable.vhd:40:58  */
  assign n4847_o = lum[2:0];
  /* ./TIA/VGAColorTable.vhd:40:53  */
  assign n4848_o = {n4846_o, n4847_o};
  /* ./TIA/VGAColorTable.vhd:42:33  */
  assign n4850_o = n4848_o == 16'b0000000000000000;
  /* ./TIA/VGAColorTable.vhd:43:33  */
  assign n4852_o = n4848_o == 16'b0000000000000001;
  /* ./TIA/VGAColorTable.vhd:44:33  */
  assign n4854_o = n4848_o == 16'b0000000000000010;
  /* ./TIA/VGAColorTable.vhd:45:33  */
  assign n4856_o = n4848_o == 16'b0000000000000011;
  /* ./TIA/VGAColorTable.vhd:46:33  */
  assign n4858_o = n4848_o == 16'b0000000000000100;
  /* ./TIA/VGAColorTable.vhd:47:33  */
  assign n4860_o = n4848_o == 16'b0000000000000101;
  /* ./TIA/VGAColorTable.vhd:48:33  */
  assign n4862_o = n4848_o == 16'b0000000000000110;
  /* ./TIA/VGAColorTable.vhd:49:33  */
  assign n4864_o = n4848_o == 16'b0000000000000111;
  /* ./TIA/VGAColorTable.vhd:50:33  */
  assign n4866_o = n4848_o == 16'b0000000000001000;
  /* ./TIA/VGAColorTable.vhd:51:33  */
  assign n4868_o = n4848_o == 16'b0000000000001001;
  /* ./TIA/VGAColorTable.vhd:52:33  */
  assign n4870_o = n4848_o == 16'b0000000000001010;
  /* ./TIA/VGAColorTable.vhd:53:33  */
  assign n4872_o = n4848_o == 16'b0000000000001011;
  /* ./TIA/VGAColorTable.vhd:54:33  */
  assign n4874_o = n4848_o == 16'b0000000000001100;
  /* ./TIA/VGAColorTable.vhd:55:33  */
  assign n4876_o = n4848_o == 16'b0000000000001101;
  /* ./TIA/VGAColorTable.vhd:56:33  */
  assign n4878_o = n4848_o == 16'b0000000000001110;
  /* ./TIA/VGAColorTable.vhd:57:33  */
  assign n4880_o = n4848_o == 16'b0000000000001111;
  /* ./TIA/VGAColorTable.vhd:58:33  */
  assign n4882_o = n4848_o == 16'b0000000000010000;
  /* ./TIA/VGAColorTable.vhd:59:33  */
  assign n4884_o = n4848_o == 16'b0000000000010001;
  /* ./TIA/VGAColorTable.vhd:60:33  */
  assign n4886_o = n4848_o == 16'b0000000000010010;
  /* ./TIA/VGAColorTable.vhd:61:33  */
  assign n4888_o = n4848_o == 16'b0000000000010011;
  /* ./TIA/VGAColorTable.vhd:62:33  */
  assign n4890_o = n4848_o == 16'b0000000000010100;
  /* ./TIA/VGAColorTable.vhd:63:33  */
  assign n4892_o = n4848_o == 16'b0000000000010101;
  /* ./TIA/VGAColorTable.vhd:64:33  */
  assign n4894_o = n4848_o == 16'b0000000000010110;
  /* ./TIA/VGAColorTable.vhd:65:33  */
  assign n4896_o = n4848_o == 16'b0000000000010111;
  /* ./TIA/VGAColorTable.vhd:66:33  */
  assign n4898_o = n4848_o == 16'b0000000000011000;
  /* ./TIA/VGAColorTable.vhd:67:33  */
  assign n4900_o = n4848_o == 16'b0000000000011001;
  /* ./TIA/VGAColorTable.vhd:68:33  */
  assign n4902_o = n4848_o == 16'b0000000000011010;
  /* ./TIA/VGAColorTable.vhd:69:33  */
  assign n4904_o = n4848_o == 16'b0000000000011011;
  /* ./TIA/VGAColorTable.vhd:70:33  */
  assign n4906_o = n4848_o == 16'b0000000000011100;
  /* ./TIA/VGAColorTable.vhd:71:33  */
  assign n4908_o = n4848_o == 16'b0000000000011101;
  /* ./TIA/VGAColorTable.vhd:72:33  */
  assign n4910_o = n4848_o == 16'b0000000000011110;
  /* ./TIA/VGAColorTable.vhd:73:33  */
  assign n4912_o = n4848_o == 16'b0000000000011111;
  /* ./TIA/VGAColorTable.vhd:74:33  */
  assign n4914_o = n4848_o == 16'b0000000000100000;
  /* ./TIA/VGAColorTable.vhd:75:33  */
  assign n4916_o = n4848_o == 16'b0000000000100001;
  /* ./TIA/VGAColorTable.vhd:76:33  */
  assign n4918_o = n4848_o == 16'b0000000000100010;
  /* ./TIA/VGAColorTable.vhd:77:33  */
  assign n4920_o = n4848_o == 16'b0000000000100011;
  /* ./TIA/VGAColorTable.vhd:78:33  */
  assign n4922_o = n4848_o == 16'b0000000000100100;
  /* ./TIA/VGAColorTable.vhd:79:33  */
  assign n4924_o = n4848_o == 16'b0000000000100101;
  /* ./TIA/VGAColorTable.vhd:80:33  */
  assign n4926_o = n4848_o == 16'b0000000000100110;
  /* ./TIA/VGAColorTable.vhd:81:33  */
  assign n4928_o = n4848_o == 16'b0000000000100111;
  /* ./TIA/VGAColorTable.vhd:82:33  */
  assign n4930_o = n4848_o == 16'b0000000000101000;
  /* ./TIA/VGAColorTable.vhd:83:33  */
  assign n4932_o = n4848_o == 16'b0000000000101001;
  /* ./TIA/VGAColorTable.vhd:84:33  */
  assign n4934_o = n4848_o == 16'b0000000000101010;
  /* ./TIA/VGAColorTable.vhd:85:33  */
  assign n4936_o = n4848_o == 16'b0000000000101011;
  /* ./TIA/VGAColorTable.vhd:86:33  */
  assign n4938_o = n4848_o == 16'b0000000000101100;
  /* ./TIA/VGAColorTable.vhd:87:33  */
  assign n4940_o = n4848_o == 16'b0000000000101101;
  /* ./TIA/VGAColorTable.vhd:88:33  */
  assign n4942_o = n4848_o == 16'b0000000000101110;
  /* ./TIA/VGAColorTable.vhd:89:33  */
  assign n4944_o = n4848_o == 16'b0000000000101111;
  /* ./TIA/VGAColorTable.vhd:90:33  */
  assign n4946_o = n4848_o == 16'b0000000000110000;
  /* ./TIA/VGAColorTable.vhd:91:33  */
  assign n4948_o = n4848_o == 16'b0000000000110001;
  /* ./TIA/VGAColorTable.vhd:92:33  */
  assign n4950_o = n4848_o == 16'b0000000000110010;
  /* ./TIA/VGAColorTable.vhd:93:33  */
  assign n4952_o = n4848_o == 16'b0000000000110011;
  /* ./TIA/VGAColorTable.vhd:94:33  */
  assign n4954_o = n4848_o == 16'b0000000000110100;
  /* ./TIA/VGAColorTable.vhd:95:33  */
  assign n4956_o = n4848_o == 16'b0000000000110101;
  /* ./TIA/VGAColorTable.vhd:96:33  */
  assign n4958_o = n4848_o == 16'b0000000000110110;
  /* ./TIA/VGAColorTable.vhd:97:33  */
  assign n4960_o = n4848_o == 16'b0000000000110111;
  /* ./TIA/VGAColorTable.vhd:98:33  */
  assign n4962_o = n4848_o == 16'b0000000000111000;
  /* ./TIA/VGAColorTable.vhd:99:33  */
  assign n4964_o = n4848_o == 16'b0000000000111001;
  /* ./TIA/VGAColorTable.vhd:100:33  */
  assign n4966_o = n4848_o == 16'b0000000000111010;
  /* ./TIA/VGAColorTable.vhd:101:33  */
  assign n4968_o = n4848_o == 16'b0000000000111011;
  /* ./TIA/VGAColorTable.vhd:102:33  */
  assign n4970_o = n4848_o == 16'b0000000000111100;
  /* ./TIA/VGAColorTable.vhd:103:33  */
  assign n4972_o = n4848_o == 16'b0000000000111101;
  /* ./TIA/VGAColorTable.vhd:104:33  */
  assign n4974_o = n4848_o == 16'b0000000000111110;
  /* ./TIA/VGAColorTable.vhd:105:33  */
  assign n4976_o = n4848_o == 16'b0000000000111111;
  /* ./TIA/VGAColorTable.vhd:106:33  */
  assign n4978_o = n4848_o == 16'b0000000001000000;
  /* ./TIA/VGAColorTable.vhd:107:33  */
  assign n4980_o = n4848_o == 16'b0000000001000001;
  /* ./TIA/VGAColorTable.vhd:108:33  */
  assign n4982_o = n4848_o == 16'b0000000001000010;
  /* ./TIA/VGAColorTable.vhd:109:33  */
  assign n4984_o = n4848_o == 16'b0000000001000011;
  /* ./TIA/VGAColorTable.vhd:110:33  */
  assign n4986_o = n4848_o == 16'b0000000001000100;
  /* ./TIA/VGAColorTable.vhd:111:33  */
  assign n4988_o = n4848_o == 16'b0000000001000101;
  /* ./TIA/VGAColorTable.vhd:112:33  */
  assign n4990_o = n4848_o == 16'b0000000001000110;
  /* ./TIA/VGAColorTable.vhd:113:33  */
  assign n4992_o = n4848_o == 16'b0000000001000111;
  /* ./TIA/VGAColorTable.vhd:114:33  */
  assign n4994_o = n4848_o == 16'b0000000001001000;
  /* ./TIA/VGAColorTable.vhd:115:33  */
  assign n4996_o = n4848_o == 16'b0000000001001001;
  /* ./TIA/VGAColorTable.vhd:116:33  */
  assign n4998_o = n4848_o == 16'b0000000001001010;
  /* ./TIA/VGAColorTable.vhd:117:33  */
  assign n5000_o = n4848_o == 16'b0000000001001011;
  /* ./TIA/VGAColorTable.vhd:118:33  */
  assign n5002_o = n4848_o == 16'b0000000001001100;
  /* ./TIA/VGAColorTable.vhd:119:33  */
  assign n5004_o = n4848_o == 16'b0000000001001101;
  /* ./TIA/VGAColorTable.vhd:120:33  */
  assign n5006_o = n4848_o == 16'b0000000001001110;
  /* ./TIA/VGAColorTable.vhd:121:33  */
  assign n5008_o = n4848_o == 16'b0000000001001111;
  /* ./TIA/VGAColorTable.vhd:122:33  */
  assign n5010_o = n4848_o == 16'b0000000001010000;
  /* ./TIA/VGAColorTable.vhd:123:33  */
  assign n5012_o = n4848_o == 16'b0000000001010001;
  /* ./TIA/VGAColorTable.vhd:124:33  */
  assign n5014_o = n4848_o == 16'b0000000001010010;
  /* ./TIA/VGAColorTable.vhd:125:33  */
  assign n5016_o = n4848_o == 16'b0000000001010011;
  /* ./TIA/VGAColorTable.vhd:126:33  */
  assign n5018_o = n4848_o == 16'b0000000001010100;
  /* ./TIA/VGAColorTable.vhd:127:33  */
  assign n5020_o = n4848_o == 16'b0000000001010101;
  /* ./TIA/VGAColorTable.vhd:128:33  */
  assign n5022_o = n4848_o == 16'b0000000001010110;
  /* ./TIA/VGAColorTable.vhd:129:33  */
  assign n5024_o = n4848_o == 16'b0000000001010111;
  /* ./TIA/VGAColorTable.vhd:130:33  */
  assign n5026_o = n4848_o == 16'b0000000001011000;
  /* ./TIA/VGAColorTable.vhd:131:33  */
  assign n5028_o = n4848_o == 16'b0000000001011001;
  /* ./TIA/VGAColorTable.vhd:132:33  */
  assign n5030_o = n4848_o == 16'b0000000001011010;
  /* ./TIA/VGAColorTable.vhd:133:33  */
  assign n5032_o = n4848_o == 16'b0000000001011011;
  /* ./TIA/VGAColorTable.vhd:134:33  */
  assign n5034_o = n4848_o == 16'b0000000001011100;
  /* ./TIA/VGAColorTable.vhd:135:33  */
  assign n5036_o = n4848_o == 16'b0000000001011101;
  /* ./TIA/VGAColorTable.vhd:136:33  */
  assign n5038_o = n4848_o == 16'b0000000001011110;
  /* ./TIA/VGAColorTable.vhd:137:33  */
  assign n5040_o = n4848_o == 16'b0000000001011111;
  /* ./TIA/VGAColorTable.vhd:138:33  */
  assign n5042_o = n4848_o == 16'b0000000001100000;
  /* ./TIA/VGAColorTable.vhd:139:33  */
  assign n5044_o = n4848_o == 16'b0000000001100001;
  /* ./TIA/VGAColorTable.vhd:140:33  */
  assign n5046_o = n4848_o == 16'b0000000001100010;
  /* ./TIA/VGAColorTable.vhd:141:33  */
  assign n5048_o = n4848_o == 16'b0000000001100011;
  /* ./TIA/VGAColorTable.vhd:142:33  */
  assign n5050_o = n4848_o == 16'b0000000001100100;
  /* ./TIA/VGAColorTable.vhd:143:33  */
  assign n5052_o = n4848_o == 16'b0000000001100101;
  /* ./TIA/VGAColorTable.vhd:144:33  */
  assign n5054_o = n4848_o == 16'b0000000001100110;
  /* ./TIA/VGAColorTable.vhd:145:33  */
  assign n5056_o = n4848_o == 16'b0000000001100111;
  /* ./TIA/VGAColorTable.vhd:146:33  */
  assign n5058_o = n4848_o == 16'b0000000001101000;
  /* ./TIA/VGAColorTable.vhd:147:33  */
  assign n5060_o = n4848_o == 16'b0000000001101001;
  /* ./TIA/VGAColorTable.vhd:148:33  */
  assign n5062_o = n4848_o == 16'b0000000001101010;
  /* ./TIA/VGAColorTable.vhd:149:33  */
  assign n5064_o = n4848_o == 16'b0000000001101011;
  /* ./TIA/VGAColorTable.vhd:150:33  */
  assign n5066_o = n4848_o == 16'b0000000001101100;
  /* ./TIA/VGAColorTable.vhd:151:33  */
  assign n5068_o = n4848_o == 16'b0000000001101101;
  /* ./TIA/VGAColorTable.vhd:152:33  */
  assign n5070_o = n4848_o == 16'b0000000001101110;
  /* ./TIA/VGAColorTable.vhd:153:33  */
  assign n5072_o = n4848_o == 16'b0000000001101111;
  /* ./TIA/VGAColorTable.vhd:154:33  */
  assign n5074_o = n4848_o == 16'b0000000001110000;
  /* ./TIA/VGAColorTable.vhd:155:33  */
  assign n5076_o = n4848_o == 16'b0000000001110001;
  /* ./TIA/VGAColorTable.vhd:156:33  */
  assign n5078_o = n4848_o == 16'b0000000001110010;
  /* ./TIA/VGAColorTable.vhd:157:33  */
  assign n5080_o = n4848_o == 16'b0000000001110011;
  /* ./TIA/VGAColorTable.vhd:158:33  */
  assign n5082_o = n4848_o == 16'b0000000001110100;
  /* ./TIA/VGAColorTable.vhd:159:33  */
  assign n5084_o = n4848_o == 16'b0000000001110101;
  /* ./TIA/VGAColorTable.vhd:160:33  */
  assign n5086_o = n4848_o == 16'b0000000001110110;
  /* ./TIA/VGAColorTable.vhd:161:33  */
  assign n5088_o = n4848_o == 16'b0000000001110111;
  /* ./TIA/VGAColorTable.vhd:162:33  */
  assign n5090_o = n4848_o == 16'b0000000001111000;
  /* ./TIA/VGAColorTable.vhd:163:33  */
  assign n5092_o = n4848_o == 16'b0000000001111001;
  /* ./TIA/VGAColorTable.vhd:164:33  */
  assign n5094_o = n4848_o == 16'b0000000001111010;
  /* ./TIA/VGAColorTable.vhd:165:33  */
  assign n5096_o = n4848_o == 16'b0000000001111011;
  /* ./TIA/VGAColorTable.vhd:166:33  */
  assign n5098_o = n4848_o == 16'b0000000001111100;
  /* ./TIA/VGAColorTable.vhd:167:33  */
  assign n5100_o = n4848_o == 16'b0000000001111101;
  /* ./TIA/VGAColorTable.vhd:168:33  */
  assign n5102_o = n4848_o == 16'b0000000001111110;
  /* ./TIA/VGAColorTable.vhd:169:33  */
  assign n5104_o = n4848_o == 16'b0000000001111111;
  /* ./TIA/VGAColorTable.vhd:171:33  */
  assign n5106_o = n4848_o == 16'b0000000010000000;
  /* ./TIA/VGAColorTable.vhd:172:33  */
  assign n5108_o = n4848_o == 16'b0000000010000001;
  /* ./TIA/VGAColorTable.vhd:173:33  */
  assign n5110_o = n4848_o == 16'b0000000010000010;
  /* ./TIA/VGAColorTable.vhd:174:33  */
  assign n5112_o = n4848_o == 16'b0000000010000011;
  /* ./TIA/VGAColorTable.vhd:175:33  */
  assign n5114_o = n4848_o == 16'b0000000010000100;
  /* ./TIA/VGAColorTable.vhd:176:33  */
  assign n5116_o = n4848_o == 16'b0000000010000101;
  /* ./TIA/VGAColorTable.vhd:177:33  */
  assign n5118_o = n4848_o == 16'b0000000010000110;
  /* ./TIA/VGAColorTable.vhd:178:33  */
  assign n5120_o = n4848_o == 16'b0000000010000111;
  /* ./TIA/VGAColorTable.vhd:179:33  */
  assign n5122_o = n4848_o == 16'b0000000010001000;
  /* ./TIA/VGAColorTable.vhd:180:33  */
  assign n5124_o = n4848_o == 16'b0000000010001001;
  /* ./TIA/VGAColorTable.vhd:181:33  */
  assign n5126_o = n4848_o == 16'b0000000010001010;
  /* ./TIA/VGAColorTable.vhd:182:33  */
  assign n5128_o = n4848_o == 16'b0000000010001011;
  /* ./TIA/VGAColorTable.vhd:183:33  */
  assign n5130_o = n4848_o == 16'b0000000010001100;
  /* ./TIA/VGAColorTable.vhd:184:33  */
  assign n5132_o = n4848_o == 16'b0000000010001101;
  /* ./TIA/VGAColorTable.vhd:185:33  */
  assign n5134_o = n4848_o == 16'b0000000010001110;
  /* ./TIA/VGAColorTable.vhd:186:33  */
  assign n5136_o = n4848_o == 16'b0000000010001111;
  /* ./TIA/VGAColorTable.vhd:187:33  */
  assign n5138_o = n4848_o == 16'b0000000010010000;
  /* ./TIA/VGAColorTable.vhd:188:33  */
  assign n5140_o = n4848_o == 16'b0000000010010001;
  /* ./TIA/VGAColorTable.vhd:189:33  */
  assign n5142_o = n4848_o == 16'b0000000010010010;
  /* ./TIA/VGAColorTable.vhd:190:33  */
  assign n5144_o = n4848_o == 16'b0000000010010011;
  /* ./TIA/VGAColorTable.vhd:191:33  */
  assign n5146_o = n4848_o == 16'b0000000010010100;
  /* ./TIA/VGAColorTable.vhd:192:33  */
  assign n5148_o = n4848_o == 16'b0000000010010101;
  /* ./TIA/VGAColorTable.vhd:193:33  */
  assign n5150_o = n4848_o == 16'b0000000010010110;
  /* ./TIA/VGAColorTable.vhd:194:33  */
  assign n5152_o = n4848_o == 16'b0000000010010111;
  /* ./TIA/VGAColorTable.vhd:195:33  */
  assign n5154_o = n4848_o == 16'b0000000010011000;
  /* ./TIA/VGAColorTable.vhd:196:33  */
  assign n5156_o = n4848_o == 16'b0000000010011001;
  /* ./TIA/VGAColorTable.vhd:197:33  */
  assign n5158_o = n4848_o == 16'b0000000010011010;
  /* ./TIA/VGAColorTable.vhd:198:33  */
  assign n5160_o = n4848_o == 16'b0000000010011011;
  /* ./TIA/VGAColorTable.vhd:199:33  */
  assign n5162_o = n4848_o == 16'b0000000010011100;
  /* ./TIA/VGAColorTable.vhd:200:33  */
  assign n5164_o = n4848_o == 16'b0000000010011101;
  /* ./TIA/VGAColorTable.vhd:201:33  */
  assign n5166_o = n4848_o == 16'b0000000010011110;
  /* ./TIA/VGAColorTable.vhd:202:33  */
  assign n5168_o = n4848_o == 16'b0000000010011111;
  /* ./TIA/VGAColorTable.vhd:203:33  */
  assign n5170_o = n4848_o == 16'b0000000010100000;
  /* ./TIA/VGAColorTable.vhd:204:33  */
  assign n5172_o = n4848_o == 16'b0000000010100001;
  /* ./TIA/VGAColorTable.vhd:205:33  */
  assign n5174_o = n4848_o == 16'b0000000010100010;
  /* ./TIA/VGAColorTable.vhd:206:33  */
  assign n5176_o = n4848_o == 16'b0000000010100011;
  /* ./TIA/VGAColorTable.vhd:207:33  */
  assign n5178_o = n4848_o == 16'b0000000010100100;
  /* ./TIA/VGAColorTable.vhd:208:33  */
  assign n5180_o = n4848_o == 16'b0000000010100101;
  /* ./TIA/VGAColorTable.vhd:209:33  */
  assign n5182_o = n4848_o == 16'b0000000010100110;
  /* ./TIA/VGAColorTable.vhd:210:33  */
  assign n5184_o = n4848_o == 16'b0000000010100111;
  /* ./TIA/VGAColorTable.vhd:211:33  */
  assign n5186_o = n4848_o == 16'b0000000010101000;
  /* ./TIA/VGAColorTable.vhd:212:33  */
  assign n5188_o = n4848_o == 16'b0000000010101001;
  /* ./TIA/VGAColorTable.vhd:213:33  */
  assign n5190_o = n4848_o == 16'b0000000010101010;
  /* ./TIA/VGAColorTable.vhd:214:33  */
  assign n5192_o = n4848_o == 16'b0000000010101011;
  /* ./TIA/VGAColorTable.vhd:215:33  */
  assign n5194_o = n4848_o == 16'b0000000010101100;
  /* ./TIA/VGAColorTable.vhd:216:33  */
  assign n5196_o = n4848_o == 16'b0000000010101101;
  /* ./TIA/VGAColorTable.vhd:217:33  */
  assign n5198_o = n4848_o == 16'b0000000010101110;
  /* ./TIA/VGAColorTable.vhd:218:33  */
  assign n5200_o = n4848_o == 16'b0000000010101111;
  /* ./TIA/VGAColorTable.vhd:219:33  */
  assign n5202_o = n4848_o == 16'b0000000010110000;
  /* ./TIA/VGAColorTable.vhd:220:33  */
  assign n5204_o = n4848_o == 16'b0000000010110001;
  /* ./TIA/VGAColorTable.vhd:221:33  */
  assign n5206_o = n4848_o == 16'b0000000010110010;
  /* ./TIA/VGAColorTable.vhd:222:33  */
  assign n5208_o = n4848_o == 16'b0000000010110011;
  /* ./TIA/VGAColorTable.vhd:223:33  */
  assign n5210_o = n4848_o == 16'b0000000010110100;
  /* ./TIA/VGAColorTable.vhd:224:33  */
  assign n5212_o = n4848_o == 16'b0000000010110101;
  /* ./TIA/VGAColorTable.vhd:225:33  */
  assign n5214_o = n4848_o == 16'b0000000010110110;
  /* ./TIA/VGAColorTable.vhd:226:33  */
  assign n5216_o = n4848_o == 16'b0000000010110111;
  /* ./TIA/VGAColorTable.vhd:227:33  */
  assign n5218_o = n4848_o == 16'b0000000010111000;
  /* ./TIA/VGAColorTable.vhd:228:33  */
  assign n5220_o = n4848_o == 16'b0000000010111001;
  /* ./TIA/VGAColorTable.vhd:229:33  */
  assign n5222_o = n4848_o == 16'b0000000010111010;
  /* ./TIA/VGAColorTable.vhd:230:33  */
  assign n5224_o = n4848_o == 16'b0000000010111011;
  /* ./TIA/VGAColorTable.vhd:231:33  */
  assign n5226_o = n4848_o == 16'b0000000010111100;
  /* ./TIA/VGAColorTable.vhd:232:33  */
  assign n5228_o = n4848_o == 16'b0000000010111101;
  /* ./TIA/VGAColorTable.vhd:233:33  */
  assign n5230_o = n4848_o == 16'b0000000010111110;
  /* ./TIA/VGAColorTable.vhd:234:33  */
  assign n5232_o = n4848_o == 16'b0000000010111111;
  /* ./TIA/VGAColorTable.vhd:235:33  */
  assign n5234_o = n4848_o == 16'b0000000011000000;
  /* ./TIA/VGAColorTable.vhd:236:33  */
  assign n5236_o = n4848_o == 16'b0000000011000001;
  /* ./TIA/VGAColorTable.vhd:237:33  */
  assign n5238_o = n4848_o == 16'b0000000011000010;
  /* ./TIA/VGAColorTable.vhd:238:33  */
  assign n5240_o = n4848_o == 16'b0000000011000011;
  /* ./TIA/VGAColorTable.vhd:239:33  */
  assign n5242_o = n4848_o == 16'b0000000011000100;
  /* ./TIA/VGAColorTable.vhd:240:33  */
  assign n5244_o = n4848_o == 16'b0000000011000101;
  /* ./TIA/VGAColorTable.vhd:241:33  */
  assign n5246_o = n4848_o == 16'b0000000011000110;
  /* ./TIA/VGAColorTable.vhd:242:33  */
  assign n5248_o = n4848_o == 16'b0000000011000111;
  /* ./TIA/VGAColorTable.vhd:243:33  */
  assign n5250_o = n4848_o == 16'b0000000011001000;
  /* ./TIA/VGAColorTable.vhd:244:33  */
  assign n5252_o = n4848_o == 16'b0000000011001001;
  /* ./TIA/VGAColorTable.vhd:245:33  */
  assign n5254_o = n4848_o == 16'b0000000011001010;
  /* ./TIA/VGAColorTable.vhd:246:33  */
  assign n5256_o = n4848_o == 16'b0000000011001011;
  /* ./TIA/VGAColorTable.vhd:247:33  */
  assign n5258_o = n4848_o == 16'b0000000011001100;
  /* ./TIA/VGAColorTable.vhd:248:33  */
  assign n5260_o = n4848_o == 16'b0000000011001101;
  /* ./TIA/VGAColorTable.vhd:249:33  */
  assign n5262_o = n4848_o == 16'b0000000011001110;
  /* ./TIA/VGAColorTable.vhd:250:33  */
  assign n5264_o = n4848_o == 16'b0000000011001111;
  /* ./TIA/VGAColorTable.vhd:251:33  */
  assign n5266_o = n4848_o == 16'b0000000011010000;
  /* ./TIA/VGAColorTable.vhd:252:33  */
  assign n5268_o = n4848_o == 16'b0000000011010001;
  /* ./TIA/VGAColorTable.vhd:253:33  */
  assign n5270_o = n4848_o == 16'b0000000011010010;
  /* ./TIA/VGAColorTable.vhd:254:33  */
  assign n5272_o = n4848_o == 16'b0000000011010011;
  /* ./TIA/VGAColorTable.vhd:255:33  */
  assign n5274_o = n4848_o == 16'b0000000011010100;
  /* ./TIA/VGAColorTable.vhd:256:33  */
  assign n5276_o = n4848_o == 16'b0000000011010101;
  /* ./TIA/VGAColorTable.vhd:257:33  */
  assign n5278_o = n4848_o == 16'b0000000011010110;
  /* ./TIA/VGAColorTable.vhd:258:33  */
  assign n5280_o = n4848_o == 16'b0000000011010111;
  /* ./TIA/VGAColorTable.vhd:259:33  */
  assign n5282_o = n4848_o == 16'b0000000011011000;
  /* ./TIA/VGAColorTable.vhd:260:33  */
  assign n5284_o = n4848_o == 16'b0000000011011001;
  /* ./TIA/VGAColorTable.vhd:261:33  */
  assign n5286_o = n4848_o == 16'b0000000011011010;
  /* ./TIA/VGAColorTable.vhd:262:33  */
  assign n5288_o = n4848_o == 16'b0000000011011011;
  /* ./TIA/VGAColorTable.vhd:263:33  */
  assign n5290_o = n4848_o == 16'b0000000011011100;
  /* ./TIA/VGAColorTable.vhd:264:33  */
  assign n5292_o = n4848_o == 16'b0000000011011101;
  /* ./TIA/VGAColorTable.vhd:265:33  */
  assign n5294_o = n4848_o == 16'b0000000011011110;
  /* ./TIA/VGAColorTable.vhd:266:33  */
  assign n5296_o = n4848_o == 16'b0000000011011111;
  /* ./TIA/VGAColorTable.vhd:267:33  */
  assign n5298_o = n4848_o == 16'b0000000011100000;
  /* ./TIA/VGAColorTable.vhd:268:33  */
  assign n5300_o = n4848_o == 16'b0000000011100001;
  /* ./TIA/VGAColorTable.vhd:269:33  */
  assign n5302_o = n4848_o == 16'b0000000011100010;
  /* ./TIA/VGAColorTable.vhd:270:33  */
  assign n5304_o = n4848_o == 16'b0000000011100011;
  /* ./TIA/VGAColorTable.vhd:271:33  */
  assign n5306_o = n4848_o == 16'b0000000011100100;
  /* ./TIA/VGAColorTable.vhd:272:33  */
  assign n5308_o = n4848_o == 16'b0000000011100101;
  /* ./TIA/VGAColorTable.vhd:273:33  */
  assign n5310_o = n4848_o == 16'b0000000011100110;
  /* ./TIA/VGAColorTable.vhd:274:33  */
  assign n5312_o = n4848_o == 16'b0000000011100111;
  /* ./TIA/VGAColorTable.vhd:275:33  */
  assign n5314_o = n4848_o == 16'b0000000011101000;
  /* ./TIA/VGAColorTable.vhd:276:33  */
  assign n5316_o = n4848_o == 16'b0000000011101001;
  /* ./TIA/VGAColorTable.vhd:277:33  */
  assign n5318_o = n4848_o == 16'b0000000011101010;
  /* ./TIA/VGAColorTable.vhd:278:33  */
  assign n5320_o = n4848_o == 16'b0000000011101011;
  /* ./TIA/VGAColorTable.vhd:279:33  */
  assign n5322_o = n4848_o == 16'b0000000011101100;
  /* ./TIA/VGAColorTable.vhd:280:33  */
  assign n5324_o = n4848_o == 16'b0000000011101101;
  /* ./TIA/VGAColorTable.vhd:281:33  */
  assign n5326_o = n4848_o == 16'b0000000011101110;
  /* ./TIA/VGAColorTable.vhd:282:33  */
  assign n5328_o = n4848_o == 16'b0000000011101111;
  /* ./TIA/VGAColorTable.vhd:283:33  */
  assign n5330_o = n4848_o == 16'b0000000011110000;
  /* ./TIA/VGAColorTable.vhd:284:33  */
  assign n5332_o = n4848_o == 16'b0000000011110001;
  /* ./TIA/VGAColorTable.vhd:285:33  */
  assign n5334_o = n4848_o == 16'b0000000011110010;
  /* ./TIA/VGAColorTable.vhd:286:33  */
  assign n5336_o = n4848_o == 16'b0000000011110011;
  /* ./TIA/VGAColorTable.vhd:287:33  */
  assign n5338_o = n4848_o == 16'b0000000011110100;
  /* ./TIA/VGAColorTable.vhd:288:33  */
  assign n5340_o = n4848_o == 16'b0000000011110101;
  /* ./TIA/VGAColorTable.vhd:289:33  */
  assign n5342_o = n4848_o == 16'b0000000011110110;
  /* ./TIA/VGAColorTable.vhd:290:33  */
  assign n5344_o = n4848_o == 16'b0000000011110111;
  /* ./TIA/VGAColorTable.vhd:291:33  */
  assign n5346_o = n4848_o == 16'b0000000011111000;
  /* ./TIA/VGAColorTable.vhd:292:33  */
  assign n5348_o = n4848_o == 16'b0000000011111001;
  /* ./TIA/VGAColorTable.vhd:293:33  */
  assign n5350_o = n4848_o == 16'b0000000011111010;
  /* ./TIA/VGAColorTable.vhd:294:33  */
  assign n5352_o = n4848_o == 16'b0000000011111011;
  /* ./TIA/VGAColorTable.vhd:295:33  */
  assign n5354_o = n4848_o == 16'b0000000011111100;
  /* ./TIA/VGAColorTable.vhd:296:33  */
  assign n5356_o = n4848_o == 16'b0000000011111101;
  /* ./TIA/VGAColorTable.vhd:297:33  */
  assign n5358_o = n4848_o == 16'b0000000011111110;
  /* ./TIA/VGAColorTable.vhd:298:33  */
  assign n5360_o = n4848_o == 16'b0000000011111111;
  /* ./TIA/VGAColorTable.vhd:300:33  */
  assign n5362_o = n4848_o == 16'b0000000100000000;
  /* ./TIA/VGAColorTable.vhd:301:33  */
  assign n5364_o = n4848_o == 16'b0000000100000001;
  /* ./TIA/VGAColorTable.vhd:302:33  */
  assign n5366_o = n4848_o == 16'b0000000100000010;
  /* ./TIA/VGAColorTable.vhd:303:33  */
  assign n5368_o = n4848_o == 16'b0000000100000011;
  /* ./TIA/VGAColorTable.vhd:304:33  */
  assign n5370_o = n4848_o == 16'b0000000100000100;
  /* ./TIA/VGAColorTable.vhd:305:33  */
  assign n5372_o = n4848_o == 16'b0000000100000101;
  /* ./TIA/VGAColorTable.vhd:306:33  */
  assign n5374_o = n4848_o == 16'b0000000100000110;
  /* ./TIA/VGAColorTable.vhd:307:33  */
  assign n5376_o = n4848_o == 16'b0000000100000111;
  /* ./TIA/VGAColorTable.vhd:308:33  */
  assign n5378_o = n4848_o == 16'b0000000100001000;
  /* ./TIA/VGAColorTable.vhd:309:33  */
  assign n5380_o = n4848_o == 16'b0000000100001001;
  /* ./TIA/VGAColorTable.vhd:310:33  */
  assign n5382_o = n4848_o == 16'b0000000100001010;
  /* ./TIA/VGAColorTable.vhd:311:33  */
  assign n5384_o = n4848_o == 16'b0000000100001011;
  /* ./TIA/VGAColorTable.vhd:312:33  */
  assign n5386_o = n4848_o == 16'b0000000100001100;
  /* ./TIA/VGAColorTable.vhd:313:33  */
  assign n5388_o = n4848_o == 16'b0000000100001101;
  /* ./TIA/VGAColorTable.vhd:314:33  */
  assign n5390_o = n4848_o == 16'b0000000100001110;
  /* ./TIA/VGAColorTable.vhd:315:33  */
  assign n5392_o = n4848_o == 16'b0000000100001111;
  /* ./TIA/VGAColorTable.vhd:316:33  */
  assign n5394_o = n4848_o == 16'b0000000100010000;
  /* ./TIA/VGAColorTable.vhd:317:33  */
  assign n5396_o = n4848_o == 16'b0000000100010001;
  /* ./TIA/VGAColorTable.vhd:318:33  */
  assign n5398_o = n4848_o == 16'b0000000100010010;
  /* ./TIA/VGAColorTable.vhd:319:33  */
  assign n5400_o = n4848_o == 16'b0000000100010011;
  /* ./TIA/VGAColorTable.vhd:320:33  */
  assign n5402_o = n4848_o == 16'b0000000100010100;
  /* ./TIA/VGAColorTable.vhd:321:33  */
  assign n5404_o = n4848_o == 16'b0000000100010101;
  /* ./TIA/VGAColorTable.vhd:322:33  */
  assign n5406_o = n4848_o == 16'b0000000100010110;
  /* ./TIA/VGAColorTable.vhd:323:33  */
  assign n5408_o = n4848_o == 16'b0000000100010111;
  /* ./TIA/VGAColorTable.vhd:324:33  */
  assign n5410_o = n4848_o == 16'b0000000100011000;
  /* ./TIA/VGAColorTable.vhd:325:33  */
  assign n5412_o = n4848_o == 16'b0000000100011001;
  /* ./TIA/VGAColorTable.vhd:326:33  */
  assign n5414_o = n4848_o == 16'b0000000100011010;
  /* ./TIA/VGAColorTable.vhd:327:33  */
  assign n5416_o = n4848_o == 16'b0000000100011011;
  /* ./TIA/VGAColorTable.vhd:328:33  */
  assign n5418_o = n4848_o == 16'b0000000100011100;
  /* ./TIA/VGAColorTable.vhd:329:33  */
  assign n5420_o = n4848_o == 16'b0000000100011101;
  /* ./TIA/VGAColorTable.vhd:330:33  */
  assign n5422_o = n4848_o == 16'b0000000100011110;
  /* ./TIA/VGAColorTable.vhd:331:33  */
  assign n5424_o = n4848_o == 16'b0000000100011111;
  /* ./TIA/VGAColorTable.vhd:332:33  */
  assign n5426_o = n4848_o == 16'b0000000100100000;
  /* ./TIA/VGAColorTable.vhd:333:33  */
  assign n5428_o = n4848_o == 16'b0000000100100001;
  /* ./TIA/VGAColorTable.vhd:334:33  */
  assign n5430_o = n4848_o == 16'b0000000100100010;
  /* ./TIA/VGAColorTable.vhd:335:33  */
  assign n5432_o = n4848_o == 16'b0000000100100011;
  /* ./TIA/VGAColorTable.vhd:336:33  */
  assign n5434_o = n4848_o == 16'b0000000100100100;
  /* ./TIA/VGAColorTable.vhd:337:33  */
  assign n5436_o = n4848_o == 16'b0000000100100101;
  /* ./TIA/VGAColorTable.vhd:338:33  */
  assign n5438_o = n4848_o == 16'b0000000100100110;
  /* ./TIA/VGAColorTable.vhd:339:33  */
  assign n5440_o = n4848_o == 16'b0000000100100111;
  /* ./TIA/VGAColorTable.vhd:340:33  */
  assign n5442_o = n4848_o == 16'b0000000100101000;
  /* ./TIA/VGAColorTable.vhd:341:33  */
  assign n5444_o = n4848_o == 16'b0000000100101001;
  /* ./TIA/VGAColorTable.vhd:342:33  */
  assign n5446_o = n4848_o == 16'b0000000100101010;
  /* ./TIA/VGAColorTable.vhd:343:33  */
  assign n5448_o = n4848_o == 16'b0000000100101011;
  /* ./TIA/VGAColorTable.vhd:344:33  */
  assign n5450_o = n4848_o == 16'b0000000100101100;
  /* ./TIA/VGAColorTable.vhd:345:33  */
  assign n5452_o = n4848_o == 16'b0000000100101101;
  /* ./TIA/VGAColorTable.vhd:346:33  */
  assign n5454_o = n4848_o == 16'b0000000100101110;
  /* ./TIA/VGAColorTable.vhd:347:33  */
  assign n5456_o = n4848_o == 16'b0000000100101111;
  /* ./TIA/VGAColorTable.vhd:348:33  */
  assign n5458_o = n4848_o == 16'b0000000100110000;
  /* ./TIA/VGAColorTable.vhd:349:33  */
  assign n5460_o = n4848_o == 16'b0000000100110001;
  /* ./TIA/VGAColorTable.vhd:350:33  */
  assign n5462_o = n4848_o == 16'b0000000100110010;
  /* ./TIA/VGAColorTable.vhd:351:33  */
  assign n5464_o = n4848_o == 16'b0000000100110011;
  /* ./TIA/VGAColorTable.vhd:352:33  */
  assign n5466_o = n4848_o == 16'b0000000100110100;
  /* ./TIA/VGAColorTable.vhd:353:33  */
  assign n5468_o = n4848_o == 16'b0000000100110101;
  /* ./TIA/VGAColorTable.vhd:354:33  */
  assign n5470_o = n4848_o == 16'b0000000100110110;
  /* ./TIA/VGAColorTable.vhd:355:33  */
  assign n5472_o = n4848_o == 16'b0000000100110111;
  /* ./TIA/VGAColorTable.vhd:356:33  */
  assign n5474_o = n4848_o == 16'b0000000100111000;
  /* ./TIA/VGAColorTable.vhd:357:33  */
  assign n5476_o = n4848_o == 16'b0000000100111001;
  /* ./TIA/VGAColorTable.vhd:358:33  */
  assign n5478_o = n4848_o == 16'b0000000100111010;
  /* ./TIA/VGAColorTable.vhd:359:33  */
  assign n5480_o = n4848_o == 16'b0000000100111011;
  /* ./TIA/VGAColorTable.vhd:360:33  */
  assign n5482_o = n4848_o == 16'b0000000100111100;
  /* ./TIA/VGAColorTable.vhd:361:33  */
  assign n5484_o = n4848_o == 16'b0000000100111101;
  /* ./TIA/VGAColorTable.vhd:362:33  */
  assign n5486_o = n4848_o == 16'b0000000100111110;
  /* ./TIA/VGAColorTable.vhd:363:33  */
  assign n5488_o = n4848_o == 16'b0000000100111111;
  /* ./TIA/VGAColorTable.vhd:364:33  */
  assign n5490_o = n4848_o == 16'b0000000101000000;
  /* ./TIA/VGAColorTable.vhd:365:33  */
  assign n5492_o = n4848_o == 16'b0000000101000001;
  /* ./TIA/VGAColorTable.vhd:366:33  */
  assign n5494_o = n4848_o == 16'b0000000101000010;
  /* ./TIA/VGAColorTable.vhd:367:33  */
  assign n5496_o = n4848_o == 16'b0000000101000011;
  /* ./TIA/VGAColorTable.vhd:368:33  */
  assign n5498_o = n4848_o == 16'b0000000101000100;
  /* ./TIA/VGAColorTable.vhd:369:33  */
  assign n5500_o = n4848_o == 16'b0000000101000101;
  /* ./TIA/VGAColorTable.vhd:370:33  */
  assign n5502_o = n4848_o == 16'b0000000101000110;
  /* ./TIA/VGAColorTable.vhd:371:33  */
  assign n5504_o = n4848_o == 16'b0000000101000111;
  /* ./TIA/VGAColorTable.vhd:372:33  */
  assign n5506_o = n4848_o == 16'b0000000101001000;
  /* ./TIA/VGAColorTable.vhd:373:33  */
  assign n5508_o = n4848_o == 16'b0000000101001001;
  /* ./TIA/VGAColorTable.vhd:374:33  */
  assign n5510_o = n4848_o == 16'b0000000101001010;
  /* ./TIA/VGAColorTable.vhd:375:33  */
  assign n5512_o = n4848_o == 16'b0000000101001011;
  /* ./TIA/VGAColorTable.vhd:376:33  */
  assign n5514_o = n4848_o == 16'b0000000101001100;
  /* ./TIA/VGAColorTable.vhd:377:33  */
  assign n5516_o = n4848_o == 16'b0000000101001101;
  /* ./TIA/VGAColorTable.vhd:378:33  */
  assign n5518_o = n4848_o == 16'b0000000101001110;
  /* ./TIA/VGAColorTable.vhd:379:33  */
  assign n5520_o = n4848_o == 16'b0000000101001111;
  /* ./TIA/VGAColorTable.vhd:380:33  */
  assign n5522_o = n4848_o == 16'b0000000101010000;
  /* ./TIA/VGAColorTable.vhd:381:33  */
  assign n5524_o = n4848_o == 16'b0000000101010001;
  /* ./TIA/VGAColorTable.vhd:382:33  */
  assign n5526_o = n4848_o == 16'b0000000101010010;
  /* ./TIA/VGAColorTable.vhd:383:33  */
  assign n5528_o = n4848_o == 16'b0000000101010011;
  /* ./TIA/VGAColorTable.vhd:384:33  */
  assign n5530_o = n4848_o == 16'b0000000101010100;
  /* ./TIA/VGAColorTable.vhd:385:33  */
  assign n5532_o = n4848_o == 16'b0000000101010101;
  /* ./TIA/VGAColorTable.vhd:386:33  */
  assign n5534_o = n4848_o == 16'b0000000101010110;
  /* ./TIA/VGAColorTable.vhd:387:33  */
  assign n5536_o = n4848_o == 16'b0000000101010111;
  /* ./TIA/VGAColorTable.vhd:388:33  */
  assign n5538_o = n4848_o == 16'b0000000101011000;
  /* ./TIA/VGAColorTable.vhd:389:33  */
  assign n5540_o = n4848_o == 16'b0000000101011001;
  /* ./TIA/VGAColorTable.vhd:390:33  */
  assign n5542_o = n4848_o == 16'b0000000101011010;
  /* ./TIA/VGAColorTable.vhd:391:33  */
  assign n5544_o = n4848_o == 16'b0000000101011011;
  /* ./TIA/VGAColorTable.vhd:392:33  */
  assign n5546_o = n4848_o == 16'b0000000101011100;
  /* ./TIA/VGAColorTable.vhd:393:33  */
  assign n5548_o = n4848_o == 16'b0000000101011101;
  /* ./TIA/VGAColorTable.vhd:394:33  */
  assign n5550_o = n4848_o == 16'b0000000101011110;
  /* ./TIA/VGAColorTable.vhd:395:33  */
  assign n5552_o = n4848_o == 16'b0000000101011111;
  /* ./TIA/VGAColorTable.vhd:396:33  */
  assign n5554_o = n4848_o == 16'b0000000101100000;
  /* ./TIA/VGAColorTable.vhd:397:33  */
  assign n5556_o = n4848_o == 16'b0000000101100001;
  /* ./TIA/VGAColorTable.vhd:398:33  */
  assign n5558_o = n4848_o == 16'b0000000101100010;
  /* ./TIA/VGAColorTable.vhd:399:33  */
  assign n5560_o = n4848_o == 16'b0000000101100011;
  /* ./TIA/VGAColorTable.vhd:400:33  */
  assign n5562_o = n4848_o == 16'b0000000101100100;
  /* ./TIA/VGAColorTable.vhd:401:33  */
  assign n5564_o = n4848_o == 16'b0000000101100101;
  /* ./TIA/VGAColorTable.vhd:402:33  */
  assign n5566_o = n4848_o == 16'b0000000101100110;
  /* ./TIA/VGAColorTable.vhd:403:33  */
  assign n5568_o = n4848_o == 16'b0000000101100111;
  /* ./TIA/VGAColorTable.vhd:404:33  */
  assign n5570_o = n4848_o == 16'b0000000101101000;
  /* ./TIA/VGAColorTable.vhd:405:33  */
  assign n5572_o = n4848_o == 16'b0000000101101001;
  /* ./TIA/VGAColorTable.vhd:406:33  */
  assign n5574_o = n4848_o == 16'b0000000101101010;
  /* ./TIA/VGAColorTable.vhd:407:33  */
  assign n5576_o = n4848_o == 16'b0000000101101011;
  /* ./TIA/VGAColorTable.vhd:408:33  */
  assign n5578_o = n4848_o == 16'b0000000101101100;
  /* ./TIA/VGAColorTable.vhd:409:33  */
  assign n5580_o = n4848_o == 16'b0000000101101101;
  /* ./TIA/VGAColorTable.vhd:410:33  */
  assign n5582_o = n4848_o == 16'b0000000101101110;
  /* ./TIA/VGAColorTable.vhd:411:33  */
  assign n5584_o = n4848_o == 16'b0000000101101111;
  /* ./TIA/VGAColorTable.vhd:412:33  */
  assign n5586_o = n4848_o == 16'b0000000101110000;
  /* ./TIA/VGAColorTable.vhd:413:33  */
  assign n5588_o = n4848_o == 16'b0000000101110001;
  /* ./TIA/VGAColorTable.vhd:414:33  */
  assign n5590_o = n4848_o == 16'b0000000101110010;
  /* ./TIA/VGAColorTable.vhd:415:33  */
  assign n5592_o = n4848_o == 16'b0000000101110011;
  /* ./TIA/VGAColorTable.vhd:416:33  */
  assign n5594_o = n4848_o == 16'b0000000101110100;
  /* ./TIA/VGAColorTable.vhd:417:33  */
  assign n5596_o = n4848_o == 16'b0000000101110101;
  /* ./TIA/VGAColorTable.vhd:418:33  */
  assign n5598_o = n4848_o == 16'b0000000101110110;
  /* ./TIA/VGAColorTable.vhd:419:33  */
  assign n5600_o = n4848_o == 16'b0000000101110111;
  /* ./TIA/VGAColorTable.vhd:420:33  */
  assign n5602_o = n4848_o == 16'b0000000101111000;
  /* ./TIA/VGAColorTable.vhd:421:33  */
  assign n5604_o = n4848_o == 16'b0000000101111001;
  /* ./TIA/VGAColorTable.vhd:422:33  */
  assign n5606_o = n4848_o == 16'b0000000101111010;
  /* ./TIA/VGAColorTable.vhd:423:33  */
  assign n5608_o = n4848_o == 16'b0000000101111011;
  /* ./TIA/VGAColorTable.vhd:424:33  */
  assign n5610_o = n4848_o == 16'b0000000101111100;
  /* ./TIA/VGAColorTable.vhd:425:33  */
  assign n5612_o = n4848_o == 16'b0000000101111101;
  /* ./TIA/VGAColorTable.vhd:426:33  */
  assign n5614_o = n4848_o == 16'b0000000101111110;
  /* ./TIA/VGAColorTable.vhd:427:33  */
  assign n5616_o = n4848_o == 16'b0000000101111111;
  assign n5617_o = {n5616_o, n5614_o, n5612_o, n5610_o, n5608_o, n5606_o, n5604_o, n5602_o, n5600_o, n5598_o, n5596_o, n5594_o, n5592_o, n5590_o, n5588_o, n5586_o, n5584_o, n5582_o, n5580_o, n5578_o, n5576_o, n5574_o, n5572_o, n5570_o, n5568_o, n5566_o, n5564_o, n5562_o, n5560_o, n5558_o, n5556_o, n5554_o, n5552_o, n5550_o, n5548_o, n5546_o, n5544_o, n5542_o, n5540_o, n5538_o, n5536_o, n5534_o, n5532_o, n5530_o, n5528_o, n5526_o, n5524_o, n5522_o, n5520_o, n5518_o, n5516_o, n5514_o, n5512_o, n5510_o, n5508_o, n5506_o, n5504_o, n5502_o, n5500_o, n5498_o, n5496_o, n5494_o, n5492_o, n5490_o, n5488_o, n5486_o, n5484_o, n5482_o, n5480_o, n5478_o, n5476_o, n5474_o, n5472_o, n5470_o, n5468_o, n5466_o, n5464_o, n5462_o, n5460_o, n5458_o, n5456_o, n5454_o, n5452_o, n5450_o, n5448_o, n5446_o, n5444_o, n5442_o, n5440_o, n5438_o, n5436_o, n5434_o, n5432_o, n5430_o, n5428_o, n5426_o, n5424_o, n5422_o, n5420_o, n5418_o, n5416_o, n5414_o, n5412_o, n5410_o, n5408_o, n5406_o, n5404_o, n5402_o, n5400_o, n5398_o, n5396_o, n5394_o, n5392_o, n5390_o, n5388_o, n5386_o, n5384_o, n5382_o, n5380_o, n5378_o, n5376_o, n5374_o, n5372_o, n5370_o, n5368_o, n5366_o, n5364_o, n5362_o, n5360_o, n5358_o, n5356_o, n5354_o, n5352_o, n5350_o, n5348_o, n5346_o, n5344_o, n5342_o, n5340_o, n5338_o, n5336_o, n5334_o, n5332_o, n5330_o, n5328_o, n5326_o, n5324_o, n5322_o, n5320_o, n5318_o, n5316_o, n5314_o, n5312_o, n5310_o, n5308_o, n5306_o, n5304_o, n5302_o, n5300_o, n5298_o, n5296_o, n5294_o, n5292_o, n5290_o, n5288_o, n5286_o, n5284_o, n5282_o, n5280_o, n5278_o, n5276_o, n5274_o, n5272_o, n5270_o, n5268_o, n5266_o, n5264_o, n5262_o, n5260_o, n5258_o, n5256_o, n5254_o, n5252_o, n5250_o, n5248_o, n5246_o, n5244_o, n5242_o, n5240_o, n5238_o, n5236_o, n5234_o, n5232_o, n5230_o, n5228_o, n5226_o, n5224_o, n5222_o, n5220_o, n5218_o, n5216_o, n5214_o, n5212_o, n5210_o, n5208_o, n5206_o, n5204_o, n5202_o, n5200_o, n5198_o, n5196_o, n5194_o, n5192_o, n5190_o, n5188_o, n5186_o, n5184_o, n5182_o, n5180_o, n5178_o, n5176_o, n5174_o, n5172_o, n5170_o, n5168_o, n5166_o, n5164_o, n5162_o, n5160_o, n5158_o, n5156_o, n5154_o, n5152_o, n5150_o, n5148_o, n5146_o, n5144_o, n5142_o, n5140_o, n5138_o, n5136_o, n5134_o, n5132_o, n5130_o, n5128_o, n5126_o, n5124_o, n5122_o, n5120_o, n5118_o, n5116_o, n5114_o, n5112_o, n5110_o, n5108_o, n5106_o, n5104_o, n5102_o, n5100_o, n5098_o, n5096_o, n5094_o, n5092_o, n5090_o, n5088_o, n5086_o, n5084_o, n5082_o, n5080_o, n5078_o, n5076_o, n5074_o, n5072_o, n5070_o, n5068_o, n5066_o, n5064_o, n5062_o, n5060_o, n5058_o, n5056_o, n5054_o, n5052_o, n5050_o, n5048_o, n5046_o, n5044_o, n5042_o, n5040_o, n5038_o, n5036_o, n5034_o, n5032_o, n5030_o, n5028_o, n5026_o, n5024_o, n5022_o, n5020_o, n5018_o, n5016_o, n5014_o, n5012_o, n5010_o, n5008_o, n5006_o, n5004_o, n5002_o, n5000_o, n4998_o, n4996_o, n4994_o, n4992_o, n4990_o, n4988_o, n4986_o, n4984_o, n4982_o, n4980_o, n4978_o, n4976_o, n4974_o, n4972_o, n4970_o, n4968_o, n4966_o, n4964_o, n4962_o, n4960_o, n4958_o, n4956_o, n4954_o, n4952_o, n4950_o, n4948_o, n4946_o, n4944_o, n4942_o, n4940_o, n4938_o, n4936_o, n4934_o, n4932_o, n4930_o, n4928_o, n4926_o, n4924_o, n4922_o, n4920_o, n4918_o, n4916_o, n4914_o, n4912_o, n4910_o, n4908_o, n4906_o, n4904_o, n4902_o, n4900_o, n4898_o, n4896_o, n4894_o, n4892_o, n4890_o, n4888_o, n4886_o, n4884_o, n4882_o, n4880_o, n4878_o, n4876_o, n4874_o, n4872_o, n4870_o, n4868_o, n4866_o, n4864_o, n4862_o, n4860_o, n4858_o, n4856_o, n4854_o, n4852_o, n4850_o};
  /* ./TIA/VGAColorTable.vhd:40:25  */
  always @*
    case (n5617_o)
      384'b100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111111111111100111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111111111111100000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111110101000011111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111100000011110001111001;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000010010000111111111;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111011001110110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110100001101000011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001011010010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101001001010010010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011101000111010001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000101000001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001010000010100000101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111011001110110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110100001101000011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001011010010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101001001010010010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011101000111010001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000101000001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001010000010100000101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101100001011000011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100111001001110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100001001000010011100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011100000111000011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010110000101100011000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001111000011110010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000000010000010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110010001011000011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101110001001110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101010001000010011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101000111000011001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100000000101100010111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011011000011110010101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010101000010000010010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001111000000000010000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001001100100011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100100001011010011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111001010000011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010001000100011001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000111010010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001110000101100010100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000111000011110010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000010000001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110101001011000011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110001001001110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001000010011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001000111000011001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101000101100010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100000000011110010100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011011000010000010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010110000000000001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001001110000011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100100001100110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111001011100011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010001010010011001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100001000110010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001110000111010010100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000111000101100010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000011110001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111000001011000011100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110100001001110011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110001001000010011000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101000111000010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101010000101100010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101000011110010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100001000010000001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011100000000000001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101100001110110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100111001101110011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100001001100100011001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011100001011100010111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010110001010010010100100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001111001000110010001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000000111010001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000101110001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111001011000011001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111011001001110010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110111001000010010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110010000111000010000100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101000101100001101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101000000011110001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100010000010000000110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011100000000000000010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101100001111110011001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100111001110100010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100001001101100010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011100001100010010000100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010110001011000001101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001111001001100001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000001000000000110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000110010000010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111001101010010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111011001100000010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110111001010110010000100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110010001001100001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001000010001011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101000000110100000111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100010000101000000100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011100000011010000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110101001111110010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110001001110100010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101100001101010010000100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101000001100000001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100011001010110001011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011101001001000000111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010111000111100000100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010001000101110000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111001110000010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111011001101000010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110111001100000010000100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110011001010110001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101111001001110001011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101010001000010000111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101000111000000100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100000000101100000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111011001110110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110100001101000011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001011010010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101001001010010010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011101000111010001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000101000001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001010000010100000101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111011001110110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110100001101000011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001011010010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101001001010010010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011101000111010001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000101000001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001010000010100000101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111111001110000010001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111010001100110001111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110100001011010001101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101110001001110001011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101000001000010001000100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100001000110100000110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011001000100100000011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010001000010100000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b111000001110110010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110011001101010010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001100000001111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100111001010100001100100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100001001000110001001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010000111000000110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010011000101000000011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001011000011000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110010001111110010100100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001110010010010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100111001100110001111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100001001011010001101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011011001001100001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000111110000111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001101000101110000011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000101000011100000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101110001111110010111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001001110010010100100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100011001101000010001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011101001011010001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010111001001110001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010000000111110001000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001000000101110000100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000011110000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001001111110011010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100100001110010011000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111001101000010101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010001011010010010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100001001110010000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001110000111110001100100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000111000101110001001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000011110000101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001001110000011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100100001100110011101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111001011010011010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010001001110011000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100001000010010101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001110000110100010010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000111000100110001111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000010110001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001001100100011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100100001011010011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111001001110011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010001000100011001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000111000010111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001110000101010010101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000111000011100010010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000001100001111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101001001011100011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100100001010010011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111001000110011100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010000111010011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010100000101110011000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001110000100000010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000111000010000010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000000000000000010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101111001011010011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b101010001010000011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b100101001000100011100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011111000111000011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b011010000101100011000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b010011000011110010101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000: n6003_o = 24'b001100000010000010011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000: n6003_o = 24'b000101000000000010000100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110101001011000011111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000: n6003_o = 24'b110001001001110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000: n6003_o = 24'b101101001000010011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000: n6003_o = 24'b101000000111000011001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000: n6003_o = 24'b100011000101100010111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000: n6003_o = 24'b011110000011110010100100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000: n6003_o = 24'b011000000010000010010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000: n6003_o = 24'b010010000000000001111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000: n6003_o = 24'b111011001011000011100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000: n6003_o = 24'b110111001001110011010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000: n6003_o = 24'b110100001000010011000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000: n6003_o = 24'b110000000111000010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000: n6003_o = 24'b101100000101100010011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000: n6003_o = 24'b101000000011110010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000: n6003_o = 24'b100011000010000001110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000: n6003_o = 24'b011110000000000001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000: n6003_o = 24'b111111001011010010110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000: n6003_o = 24'b111011001010000010100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000: n6003_o = 24'b111000001000100010001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000: n6003_o = 24'b110100000111000001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000: n6003_o = 24'b110000000101100001011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000: n6003_o = 24'b101100000011110000111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000: n6003_o = 24'b100111000010000000100000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000: n6003_o = 24'b100010000000000000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000: n6003_o = 24'b111111001011110010010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000: n6003_o = 24'b111011001010100010000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000: n6003_o = 24'b111000001001010001110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000: n6003_o = 24'b110100001000000001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000: n6003_o = 24'b110000000110100001001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000: n6003_o = 24'b101011000101000000110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000: n6003_o = 24'b100110000011010000011000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000: n6003_o = 24'b100001000001100000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000: n6003_o = 24'b111011001100100001111000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000: n6003_o = 24'b110111001011010001101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000: n6003_o = 24'b110011001010000001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000: n6003_o = 24'b101111001000110001001100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000: n6003_o = 24'b101011000111100000111100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000: n6003_o = 24'b100110000101110000101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000: n6003_o = 24'b100001000100010000010100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000: n6003_o = 24'b011100000010100000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000: n6003_o = 24'b111111001111110001101000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000: n6003_o = 24'b111010001110100001011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000: n6003_o = 24'b110100001101000001010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000: n6003_o = 24'b101110001011100001000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000: n6003_o = 24'b101000001010000000110100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000: n6003_o = 24'b100001001000010000100100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000: n6003_o = 24'b011001000110010000010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000: n6003_o = 24'b010001000100010000000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000: n6003_o = 24'b111011001110110011101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000: n6003_o = 24'b110111001101110011011100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000: n6003_o = 24'b110010001100100011001000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000: n6003_o = 24'b101100001011000010110000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000: n6003_o = 24'b100100001001000010010000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100: n6003_o = 24'b011011000110110001101100;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010: n6003_o = 24'b010000000100000001000000;
      384'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001: n6003_o = 24'b000000000000000000000000;
      default: n6003_o = 24'b000000000000000000000000;
    endcase
  /* ./TIA/VGAColorTable.vhd:39:17  */
  always @(posedge clk)
    n6006_q <= n6003_o;
endmodule

module ball
  (input  clk,
   input  prst,
   input  count,
   input  ennew,
   input  enold,
   input  vdel,
   input  [1:0] size,
   output pix);
  wire [5:0] lfsr_out;
  wire lfsr_rst;
  wire lfsr_cnt;
  wire [1:0] cntr_out;
  wire cntr_rst;
  wire cntr_en;
  reg start1;
  reg start2;
  wire ph1;
  wire ph1_edge;
  wire [5:0] lfsr_o;
  wire [1:0] cntr_o;
  wire n4782_o;
  wire n4783_o;
  wire n4787_o;
  wire n4788_o;
  wire n4792_o;
  wire n4794_o;
  wire n4795_o;
  wire n4796_o;
  wire n4797_o;
  wire n4800_o;
  wire n4801_o;
  wire n4807_o;
  wire n4808_o;
  wire n4811_o;
  wire n4818_o;
  wire n4819_o;
  wire n4820_o;
  wire n4821_o;
  wire n4822_o;
  wire n4823_o;
  wire n4824_o;
  wire n4825_o;
  wire n4826_o;
  wire n4827_o;
  wire n4828_o;
  wire n4830_o;
  wire n4831_o;
  wire n4832_o;
  wire n4833_o;
  wire n4834_o;
  wire n4836_o;
  reg n4837_q;
  wire n4838_o;
  reg n4839_q;
  assign pix = n4834_o;
  /* ./TIA/TIA.vhd:467:12  */
  assign lfsr_out = lfsr_o; // (signal)
  /* ./TIA/TIA.vhd:468:12  */
  assign lfsr_rst = n4797_o; // (signal)
  /* ./TIA/TIA.vhd:469:12  */
  assign lfsr_cnt = n4801_o; // (signal)
  /* ./TIA/TIA.vhd:471:12  */
  assign cntr_out = cntr_o; // (signal)
  /* ./TIA/TIA.vhd:472:12  */
  assign cntr_rst = prst; // (signal)
  /* ./TIA/TIA.vhd:473:12  */
  assign cntr_en = count; // (signal)
  /* ./TIA/TIA.vhd:475:12  */
  always @*
    start1 = n4837_q; // (isignal)
  initial
    start1 = 1'b0;
  /* ./TIA/TIA.vhd:476:12  */
  always @*
    start2 = n4839_q; // (isignal)
  initial
    start2 = 1'b0;
  /* ./TIA/TIA.vhd:478:12  */
  assign ph1 = n4788_o; // (signal)
  /* ./TIA/TIA.vhd:479:12  */
  assign ph1_edge = n4783_o; // (signal)
  /* ./TIA/TIA.vhd:483:5  */
  lfsr6 lfsr (
    .clk(clk),
    .prst(lfsr_rst),
    .cnt(lfsr_cnt),
    .o(lfsr_o));
  /* ./TIA/TIA.vhd:484:5  */
  cntr2 cntr (
    .clk(clk),
    .rst(cntr_rst),
    .en(cntr_en),
    .o(cntr_o));
  /* ./TIA/TIA.vhd:486:36  */
  assign n4782_o = cntr_out == 2'b10;
  /* ./TIA/TIA.vhd:486:21  */
  assign n4783_o = n4782_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:487:31  */
  assign n4787_o = cntr_out == 2'b11;
  /* ./TIA/TIA.vhd:487:16  */
  assign n4788_o = n4787_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:492:36  */
  assign n4792_o = lfsr_out == 6'b101101;
  /* ./TIA/TIA.vhd:492:61  */
  assign n4794_o = lfsr_out == 6'b111111;
  /* ./TIA/TIA.vhd:492:48  */
  assign n4795_o = n4792_o | n4794_o;
  /* ./TIA/TIA.vhd:492:73  */
  assign n4796_o = n4795_o | prst;
  /* ./TIA/TIA.vhd:492:21  */
  assign n4797_o = n4796_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:493:43  */
  assign n4800_o = count & ph1_edge;
  /* ./TIA/TIA.vhd:493:21  */
  assign n4801_o = n4800_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:499:30  */
  assign n4807_o = lfsr_out == 6'b101101;
  /* ./TIA/TIA.vhd:499:42  */
  assign n4808_o = n4807_o | prst;
  /* ./TIA/TIA.vhd:499:17  */
  assign n4811_o = n4808_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:511:32  */
  assign n4818_o = ~vdel;
  /* ./TIA/TIA.vhd:511:23  */
  assign n4819_o = n4818_o & ennew;
  /* ./TIA/TIA.vhd:511:55  */
  assign n4820_o = vdel & enold;
  /* ./TIA/TIA.vhd:511:39  */
  assign n4821_o = n4819_o | n4820_o;
  /* ./TIA/TIA.vhd:513:22  */
  assign n4822_o = size[1];
  /* ./TIA/TIA.vhd:513:33  */
  assign n4823_o = n4822_o | ph1;
  /* ./TIA/TIA.vhd:515:26  */
  assign n4824_o = cntr_out[0];
  /* ./TIA/TIA.vhd:515:44  */
  assign n4825_o = size[0];
  /* ./TIA/TIA.vhd:515:36  */
  assign n4826_o = n4825_o & n4824_o;
  /* ./TIA/TIA.vhd:514:29  */
  assign n4827_o = n4823_o | n4826_o;
  /* ./TIA/TIA.vhd:512:27  */
  assign n4828_o = n4827_o & start1;
  /* ./TIA/TIA.vhd:516:36  */
  assign n4830_o = size == 2'b11;
  /* ./TIA/TIA.vhd:516:27  */
  assign n4831_o = n4830_o & start2;
  /* ./TIA/TIA.vhd:515:57  */
  assign n4832_o = n4828_o | n4831_o;
  /* ./TIA/TIA.vhd:511:72  */
  assign n4833_o = n4832_o & n4821_o;
  /* ./TIA/TIA.vhd:510:16  */
  assign n4834_o = n4833_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:497:9  */
  assign n4836_o = ph1_edge ? n4811_o : start1;
  /* ./TIA/TIA.vhd:497:9  */
  always @(posedge clk)
    n4837_q <= n4836_o;
  initial
    n4837_q = 1'b0;
  /* ./TIA/TIA.vhd:497:9  */
  assign n4838_o = ph1_edge ? start1 : start2;
  /* ./TIA/TIA.vhd:497:9  */
  always @(posedge clk)
    n4839_q <= n4838_o;
  initial
    n4839_q = 1'b0;
endmodule

module missile
  (input  clk,
   input  prst,
   input  count,
   input  enable,
   input  [2:0] nusiz,
   input  [1:0] size,
   output pix);
  wire [5:0] lfsr_out;
  wire lfsr_rst;
  wire lfsr_cnt;
  wire [1:0] cntr_out;
  wire cntr_rst;
  wire cntr_en;
  reg start1;
  reg start2;
  wire ph1;
  wire ph1_edge;
  wire [5:0] lfsr_o;
  wire [1:0] cntr_o;
  wire n4692_o;
  wire n4693_o;
  wire n4697_o;
  wire n4698_o;
  wire n4702_o;
  wire n4704_o;
  wire n4705_o;
  wire n4706_o;
  wire n4707_o;
  wire n4710_o;
  wire n4711_o;
  wire n4717_o;
  wire n4719_o;
  wire n4721_o;
  wire n4723_o;
  wire n4724_o;
  wire n4725_o;
  wire n4726_o;
  wire n4728_o;
  wire n4730_o;
  wire n4732_o;
  wire n4733_o;
  wire n4735_o;
  wire n4736_o;
  wire n4737_o;
  wire n4738_o;
  wire n4740_o;
  wire n4742_o;
  wire n4744_o;
  wire n4745_o;
  wire n4746_o;
  wire n4747_o;
  wire n4750_o;
  wire n4757_o;
  wire n4758_o;
  wire n4759_o;
  wire n4760_o;
  wire n4761_o;
  wire n4762_o;
  wire n4763_o;
  wire n4765_o;
  wire n4766_o;
  wire n4767_o;
  wire n4768_o;
  wire n4769_o;
  wire n4771_o;
  reg n4772_q;
  wire n4773_o;
  reg n4774_q;
  assign pix = n4769_o;
  /* ./TIA/TIA.vhd:351:12  */
  assign lfsr_out = lfsr_o; // (signal)
  /* ./TIA/TIA.vhd:352:12  */
  assign lfsr_rst = n4707_o; // (signal)
  /* ./TIA/TIA.vhd:353:12  */
  assign lfsr_cnt = n4711_o; // (signal)
  /* ./TIA/TIA.vhd:355:12  */
  assign cntr_out = cntr_o; // (signal)
  /* ./TIA/TIA.vhd:356:12  */
  assign cntr_rst = prst; // (signal)
  /* ./TIA/TIA.vhd:357:12  */
  assign cntr_en = count; // (signal)
  /* ./TIA/TIA.vhd:359:12  */
  always @*
    start1 = n4772_q; // (isignal)
  initial
    start1 = 1'b0;
  /* ./TIA/TIA.vhd:360:12  */
  always @*
    start2 = n4774_q; // (isignal)
  initial
    start2 = 1'b0;
  /* ./TIA/TIA.vhd:362:12  */
  assign ph1 = n4698_o; // (signal)
  /* ./TIA/TIA.vhd:363:12  */
  assign ph1_edge = n4693_o; // (signal)
  /* ./TIA/TIA.vhd:367:5  */
  lfsr6 lfsr (
    .clk(clk),
    .prst(lfsr_rst),
    .cnt(lfsr_cnt),
    .o(lfsr_o));
  /* ./TIA/TIA.vhd:368:5  */
  cntr2 cntr (
    .clk(clk),
    .rst(cntr_rst),
    .en(cntr_en),
    .o(cntr_o));
  /* ./TIA/TIA.vhd:370:36  */
  assign n4692_o = cntr_out == 2'b10;
  /* ./TIA/TIA.vhd:370:21  */
  assign n4693_o = n4692_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:371:31  */
  assign n4697_o = cntr_out == 2'b11;
  /* ./TIA/TIA.vhd:371:16  */
  assign n4698_o = n4697_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:376:36  */
  assign n4702_o = lfsr_out == 6'b101101;
  /* ./TIA/TIA.vhd:376:61  */
  assign n4704_o = lfsr_out == 6'b111111;
  /* ./TIA/TIA.vhd:376:48  */
  assign n4705_o = n4702_o | n4704_o;
  /* ./TIA/TIA.vhd:376:73  */
  assign n4706_o = n4705_o | prst;
  /* ./TIA/TIA.vhd:376:21  */
  assign n4707_o = n4706_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:377:43  */
  assign n4710_o = count & ph1_edge;
  /* ./TIA/TIA.vhd:377:21  */
  assign n4711_o = n4710_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:383:30  */
  assign n4717_o = lfsr_out == 6'b101101;
  /* ./TIA/TIA.vhd:384:32  */
  assign n4719_o = lfsr_out == 6'b111000;
  /* ./TIA/TIA.vhd:384:56  */
  assign n4721_o = nusiz == 3'b001;
  /* ./TIA/TIA.vhd:384:75  */
  assign n4723_o = nusiz == 3'b011;
  /* ./TIA/TIA.vhd:384:65  */
  assign n4724_o = n4721_o | n4723_o;
  /* ./TIA/TIA.vhd:384:44  */
  assign n4725_o = n4724_o & n4719_o;
  /* ./TIA/TIA.vhd:383:42  */
  assign n4726_o = n4717_o | n4725_o;
  /* ./TIA/TIA.vhd:385:32  */
  assign n4728_o = lfsr_out == 6'b101111;
  /* ./TIA/TIA.vhd:385:56  */
  assign n4730_o = nusiz == 3'b011;
  /* ./TIA/TIA.vhd:385:75  */
  assign n4732_o = nusiz == 3'b010;
  /* ./TIA/TIA.vhd:385:65  */
  assign n4733_o = n4730_o | n4732_o;
  /* ./TIA/TIA.vhd:385:94  */
  assign n4735_o = nusiz == 3'b110;
  /* ./TIA/TIA.vhd:385:84  */
  assign n4736_o = n4733_o | n4735_o;
  /* ./TIA/TIA.vhd:385:44  */
  assign n4737_o = n4736_o & n4728_o;
  /* ./TIA/TIA.vhd:384:86  */
  assign n4738_o = n4726_o | n4737_o;
  /* ./TIA/TIA.vhd:386:32  */
  assign n4740_o = lfsr_out == 6'b111001;
  /* ./TIA/TIA.vhd:386:56  */
  assign n4742_o = nusiz == 3'b100;
  /* ./TIA/TIA.vhd:386:75  */
  assign n4744_o = nusiz == 3'b110;
  /* ./TIA/TIA.vhd:386:65  */
  assign n4745_o = n4742_o | n4744_o;
  /* ./TIA/TIA.vhd:386:44  */
  assign n4746_o = n4745_o & n4740_o;
  /* ./TIA/TIA.vhd:385:105  */
  assign n4747_o = n4738_o | n4746_o;
  /* ./TIA/TIA.vhd:383:17  */
  assign n4750_o = n4747_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:400:22  */
  assign n4757_o = size[1];
  /* ./TIA/TIA.vhd:400:33  */
  assign n4758_o = n4757_o | ph1;
  /* ./TIA/TIA.vhd:402:26  */
  assign n4759_o = cntr_out[0];
  /* ./TIA/TIA.vhd:402:44  */
  assign n4760_o = size[0];
  /* ./TIA/TIA.vhd:402:36  */
  assign n4761_o = n4760_o & n4759_o;
  /* ./TIA/TIA.vhd:401:29  */
  assign n4762_o = n4758_o | n4761_o;
  /* ./TIA/TIA.vhd:399:27  */
  assign n4763_o = n4762_o & start1;
  /* ./TIA/TIA.vhd:403:40  */
  assign n4765_o = size == 2'b11;
  /* ./TIA/TIA.vhd:403:31  */
  assign n4766_o = n4765_o & start2;
  /* ./TIA/TIA.vhd:402:57  */
  assign n4767_o = n4763_o | n4766_o;
  /* ./TIA/TIA.vhd:398:23  */
  assign n4768_o = n4767_o & enable;
  /* ./TIA/TIA.vhd:397:16  */
  assign n4769_o = n4768_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:381:9  */
  assign n4771_o = ph1_edge ? n4750_o : start1;
  /* ./TIA/TIA.vhd:381:9  */
  always @(posedge clk)
    n4772_q <= n4771_o;
  initial
    n4772_q = 1'b0;
  /* ./TIA/TIA.vhd:381:9  */
  assign n4773_o = ph1_edge ? start1 : start2;
  /* ./TIA/TIA.vhd:381:9  */
  always @(posedge clk)
    n4774_q <= n4773_o;
  initial
    n4774_q = 1'b0;
endmodule

module player
  (input  clk,
   input  prst,
   input  count,
   input  [2:0] nusiz,
   input  reflect,
   input  [7:0] grpnew,
   input  [7:0] grpold,
   input  vdel,
   output mrst,
   output pix);
  wire [5:0] lfsr_out;
  wire lfsr_rst;
  wire lfsr_cnt;
  wire [1:0] cntr_out;
  wire cntr_rst;
  wire cntr_en;
  wire [2:0] scan_out;
  reg scan_clk;
  reg scan_en;
  wire scan_cnt;
  reg start;
  wire [2:0] scan_adr;
  wire [1:0] pix_sel;
  wire ph0;
  wire ph1;
  wire ph1_edge;
  wire fstob;
  wire [5:0] lfsr_o;
  wire [1:0] cntr_o;
  wire [2:0] scan_o;
  localparam n4515_o = 1'b0;
  wire n4519_o;
  wire n4520_o;
  wire n4524_o;
  wire n4525_o;
  wire n4529_o;
  wire n4530_o;
  wire n4534_o;
  wire n4536_o;
  wire n4537_o;
  wire n4538_o;
  wire n4539_o;
  wire n4542_o;
  wire n4543_o;
  wire n4547_o;
  wire n4548_o;
  wire n4549_o;
  wire n4556_o;
  wire n4558_o;
  wire n4560_o;
  wire n4562_o;
  wire n4563_o;
  wire n4564_o;
  wire n4565_o;
  wire n4567_o;
  wire n4569_o;
  wire n4571_o;
  wire n4572_o;
  wire n4574_o;
  wire n4575_o;
  wire n4576_o;
  wire n4577_o;
  wire n4579_o;
  wire n4581_o;
  wire n4583_o;
  wire n4584_o;
  wire n4585_o;
  wire n4586_o;
  wire n4588_o;
  wire n4591_o;
  wire n4594_o;
  wire n4597_o;
  wire n4598_o;
  wire n4600_o;
  wire n4608_o;
  wire n4610_o;
  wire n4612_o;
  wire n4614_o;
  wire n4622_o;
  wire n4624_o;
  wire n4625_o;
  wire n4627_o;
  wire n4628_o;
  wire [2:0] n4631_o;
  wire [2:0] n4632_o;
  wire n4633_o;
  wire n4634_o;
  wire [1:0] n4635_o;
  wire n4640_o;
  wire n4645_o;
  wire [1:0] n4647_o;
  reg n4648_o;
  wire n4649_o;
  reg n4650_q;
  wire n4651_o;
  reg n4652_q;
  wire n4653_o;
  reg n4654_q;
  wire n4655_o;
  reg n4656_q;
  wire n4657_o;
  wire n4658_o;
  wire n4659_o;
  wire n4660_o;
  wire n4661_o;
  wire n4662_o;
  wire n4663_o;
  wire n4664_o;
  wire [1:0] n4665_o;
  reg n4666_o;
  wire [1:0] n4667_o;
  reg n4668_o;
  wire n4669_o;
  wire n4670_o;
  wire n4671_o;
  wire n4672_o;
  wire n4673_o;
  wire n4674_o;
  wire n4675_o;
  wire n4676_o;
  wire n4677_o;
  wire n4678_o;
  wire [1:0] n4679_o;
  reg n4680_o;
  wire [1:0] n4681_o;
  reg n4682_o;
  wire n4683_o;
  wire n4684_o;
  assign mrst = n4549_o;
  assign pix = n4648_o;
  /* ./TIA/TIA.vhd:234:12  */
  assign lfsr_out = lfsr_o; // (signal)
  /* ./TIA/TIA.vhd:235:12  */
  assign lfsr_rst = n4539_o; // (signal)
  /* ./TIA/TIA.vhd:236:12  */
  assign lfsr_cnt = n4543_o; // (signal)
  /* ./TIA/TIA.vhd:238:12  */
  assign cntr_out = cntr_o; // (signal)
  /* ./TIA/TIA.vhd:239:12  */
  assign cntr_rst = prst; // (signal)
  /* ./TIA/TIA.vhd:240:12  */
  assign cntr_en = count; // (signal)
  /* ./TIA/TIA.vhd:242:12  */
  assign scan_out = scan_o; // (signal)
  /* ./TIA/TIA.vhd:243:12  */
  always @*
    scan_clk = n4650_q; // (isignal)
  initial
    scan_clk = 1'b0;
  /* ./TIA/TIA.vhd:244:12  */
  always @*
    scan_en = n4652_q; // (isignal)
  initial
    scan_en = 1'b0;
  /* ./TIA/TIA.vhd:245:12  */
  assign scan_cnt = n4634_o; // (signal)
  /* ./TIA/TIA.vhd:247:12  */
  always @*
    start = n4654_q; // (isignal)
  initial
    start = 1'b0;
  /* ./TIA/TIA.vhd:249:12  */
  assign scan_adr = n4631_o; // (signal)
  /* ./TIA/TIA.vhd:251:12  */
  assign pix_sel = n4635_o; // (signal)
  /* ./TIA/TIA.vhd:253:12  */
  assign ph0 = n4520_o; // (signal)
  /* ./TIA/TIA.vhd:254:12  */
  assign ph1 = n4530_o; // (signal)
  /* ./TIA/TIA.vhd:255:12  */
  assign ph1_edge = n4525_o; // (signal)
  /* ./TIA/TIA.vhd:256:12  */
  assign fstob = n4656_q; // (signal)
  /* ./TIA/TIA.vhd:260:5  */
  lfsr6 lfsr (
    .clk(clk),
    .prst(lfsr_rst),
    .cnt(lfsr_cnt),
    .o(lfsr_o));
  /* ./TIA/TIA.vhd:261:5  */
  cntr2 cntr (
    .clk(clk),
    .rst(cntr_rst),
    .en(cntr_en),
    .o(cntr_o));
  /* ./TIA/TIA.vhd:262:5  */
  cntr3 scan (
    .clk(clk),
    .rst(n4515_o),
    .en(scan_cnt),
    .o(scan_o));
  /* ./TIA/TIA.vhd:264:31  */
  assign n4519_o = cntr_out == 2'b00;
  /* ./TIA/TIA.vhd:264:16  */
  assign n4520_o = n4519_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:265:36  */
  assign n4524_o = cntr_out == 2'b10;
  /* ./TIA/TIA.vhd:265:21  */
  assign n4525_o = n4524_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:266:31  */
  assign n4529_o = cntr_out == 2'b11;
  /* ./TIA/TIA.vhd:266:16  */
  assign n4530_o = n4529_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:271:36  */
  assign n4534_o = lfsr_out == 6'b101101;
  /* ./TIA/TIA.vhd:271:61  */
  assign n4536_o = lfsr_out == 6'b111111;
  /* ./TIA/TIA.vhd:271:48  */
  assign n4537_o = n4534_o | n4536_o;
  /* ./TIA/TIA.vhd:271:73  */
  assign n4538_o = n4537_o | prst;
  /* ./TIA/TIA.vhd:271:21  */
  assign n4539_o = n4538_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:272:43  */
  assign n4542_o = count & ph1_edge;
  /* ./TIA/TIA.vhd:272:21  */
  assign n4543_o = n4542_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:274:47  */
  assign n4547_o = scan_out == 3'b001;
  /* ./TIA/TIA.vhd:274:34  */
  assign n4548_o = n4547_o & fstob;
  /* ./TIA/TIA.vhd:274:17  */
  assign n4549_o = n4548_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:280:30  */
  assign n4556_o = lfsr_out == 6'b101101;
  /* ./TIA/TIA.vhd:281:32  */
  assign n4558_o = lfsr_out == 6'b111000;
  /* ./TIA/TIA.vhd:281:56  */
  assign n4560_o = nusiz == 3'b001;
  /* ./TIA/TIA.vhd:281:75  */
  assign n4562_o = nusiz == 3'b011;
  /* ./TIA/TIA.vhd:281:65  */
  assign n4563_o = n4560_o | n4562_o;
  /* ./TIA/TIA.vhd:281:44  */
  assign n4564_o = n4563_o & n4558_o;
  /* ./TIA/TIA.vhd:280:42  */
  assign n4565_o = n4556_o | n4564_o;
  /* ./TIA/TIA.vhd:282:32  */
  assign n4567_o = lfsr_out == 6'b101111;
  /* ./TIA/TIA.vhd:282:56  */
  assign n4569_o = nusiz == 3'b011;
  /* ./TIA/TIA.vhd:282:75  */
  assign n4571_o = nusiz == 3'b010;
  /* ./TIA/TIA.vhd:282:65  */
  assign n4572_o = n4569_o | n4571_o;
  /* ./TIA/TIA.vhd:282:94  */
  assign n4574_o = nusiz == 3'b110;
  /* ./TIA/TIA.vhd:282:84  */
  assign n4575_o = n4572_o | n4574_o;
  /* ./TIA/TIA.vhd:282:44  */
  assign n4576_o = n4575_o & n4567_o;
  /* ./TIA/TIA.vhd:281:86  */
  assign n4577_o = n4565_o | n4576_o;
  /* ./TIA/TIA.vhd:283:32  */
  assign n4579_o = lfsr_out == 6'b111001;
  /* ./TIA/TIA.vhd:283:56  */
  assign n4581_o = nusiz == 3'b100;
  /* ./TIA/TIA.vhd:283:75  */
  assign n4583_o = nusiz == 3'b110;
  /* ./TIA/TIA.vhd:283:65  */
  assign n4584_o = n4581_o | n4583_o;
  /* ./TIA/TIA.vhd:283:44  */
  assign n4585_o = n4584_o & n4579_o;
  /* ./TIA/TIA.vhd:282:105  */
  assign n4586_o = n4577_o | n4585_o;
  /* ./TIA/TIA.vhd:285:34  */
  assign n4588_o = lfsr_out == 6'b101101;
  /* ./TIA/TIA.vhd:285:21  */
  assign n4591_o = n4588_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:280:17  */
  assign n4594_o = n4586_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:279:13  */
  assign n4597_o = n4586_o & ph1_edge;
  /* ./TIA/TIA.vhd:278:37  */
  assign n4598_o = ph1_edge & count;
  /* ./TIA/TIA.vhd:278:37  */
  assign n4600_o = n4597_o & count;
  /* ./TIA/TIA.vhd:303:33  */
  assign n4608_o = scan_out == 3'b111;
  /* ./TIA/TIA.vhd:303:17  */
  assign n4610_o = n4608_o ? 1'b0 : scan_en;
  /* ./TIA/TIA.vhd:301:17  */
  assign n4612_o = start ? 1'b1 : n4610_o;
  /* ./TIA/TIA.vhd:299:37  */
  assign n4614_o = scan_clk & count;
  /* ./TIA/TIA.vhd:313:23  */
  assign n4622_o = nusiz == 3'b111;
  /* ./TIA/TIA.vhd:315:26  */
  assign n4624_o = nusiz == 3'b101;
  /* ./TIA/TIA.vhd:316:33  */
  assign n4625_o = ph0 | ph1;
  /* ./TIA/TIA.vhd:315:13  */
  assign n4627_o = n4624_o ? n4625_o : 1'b1;
  /* ./TIA/TIA.vhd:313:13  */
  assign n4628_o = n4622_o ? ph1 : n4627_o;
  /* ./TIA/TIA.vhd:323:26  */
  assign n4631_o = reflect ? scan_out : n4632_o;
  /* ./TIA/TIA.vhd:323:50  */
  assign n4632_o = ~scan_out;
  /* ./TIA/TIA.vhd:325:25  */
  assign n4633_o = scan_en & scan_clk;
  /* ./TIA/TIA.vhd:325:38  */
  assign n4634_o = n4633_o & count;
  /* ./TIA/TIA.vhd:327:24  */
  assign n4635_o = {scan_en, vdel};
  /* ./TIA/TIA.vhd:329:48  */
  assign n4640_o = pix_sel == 2'b10;
  /* ./TIA/TIA.vhd:330:48  */
  assign n4645_o = pix_sel == 2'b11;
  assign n4647_o = {n4645_o, n4640_o};
  /* ./TIA/TIA.vhd:328:5  */
  always @*
    case (n4647_o)
      2'b10: n4648_o = n4684_o;
      2'b01: n4648_o = n4670_o;
      default: n4648_o = 1'b0;
    endcase
  /* ./TIA/TIA.vhd:312:9  */
  assign n4649_o = count ? n4628_o : scan_clk;
  /* ./TIA/TIA.vhd:312:9  */
  always @(posedge clk)
    n4650_q <= n4649_o;
  initial
    n4650_q = 1'b0;
  /* ./TIA/TIA.vhd:299:9  */
  assign n4651_o = n4614_o ? n4612_o : scan_en;
  /* ./TIA/TIA.vhd:299:9  */
  always @(posedge clk)
    n4652_q <= n4651_o;
  initial
    n4652_q = 1'b0;
  /* ./TIA/TIA.vhd:278:9  */
  assign n4653_o = n4598_o ? n4594_o : start;
  /* ./TIA/TIA.vhd:278:9  */
  always @(posedge clk)
    n4654_q <= n4653_o;
  initial
    n4654_q = 1'b0;
  /* ./TIA/TIA.vhd:278:9  */
  assign n4655_o = n4600_o ? n4591_o : fstob;
  /* ./TIA/TIA.vhd:278:9  */
  always @(posedge clk)
    n4656_q <= n4655_o;
  /* ./TIA/TIA.vhd:262:58  */
  assign n4657_o = grpnew[0];
  /* ./TIA/TIA.vhd:261:62  */
  assign n4658_o = grpnew[1];
  /* ./TIA/TIA.vhd:260:63  */
  assign n4659_o = grpnew[2];
  /* ./TIA/TIA.vhd:228:11  */
  assign n4660_o = grpnew[3];
  /* ./TIA/TIA.vhd:227:11  */
  assign n4661_o = grpnew[4];
  /* ./TIA/TIA.vhd:330:16  */
  assign n4662_o = grpnew[5];
  /* ./TIA/TIA.vhd:329:16  */
  assign n4663_o = grpnew[6];
  assign n4664_o = grpnew[7];
  /* ./TIA/TIA.vhd:329:15  */
  assign n4665_o = scan_adr[1:0];
  /* ./TIA/TIA.vhd:329:15  */
  always @*
    case (n4665_o)
      2'b00: n4666_o = n4657_o;
      2'b01: n4666_o = n4658_o;
      2'b10: n4666_o = n4659_o;
      2'b11: n4666_o = n4660_o;
    endcase
  /* ./TIA/TIA.vhd:329:15  */
  assign n4667_o = scan_adr[1:0];
  /* ./TIA/TIA.vhd:329:15  */
  always @*
    case (n4667_o)
      2'b00: n4668_o = n4661_o;
      2'b01: n4668_o = n4662_o;
      2'b10: n4668_o = n4663_o;
      2'b11: n4668_o = n4664_o;
    endcase
  /* ./TIA/TIA.vhd:329:15  */
  assign n4669_o = scan_adr[2];
  /* ./TIA/TIA.vhd:329:15  */
  assign n4670_o = n4669_o ? n4668_o : n4666_o;
  /* ./TIA/TIA.vhd:329:15  */
  assign n4671_o = grpold[0];
  /* ./TIA/TIA.vhd:329:16  */
  assign n4672_o = grpold[1];
  assign n4673_o = grpold[2];
  /* ./TIA/TIA.vhd:278:9  */
  assign n4674_o = grpold[3];
  /* ./TIA/TIA.vhd:278:9  */
  assign n4675_o = grpold[4];
  /* ./TIA/TIA.vhd:278:37  */
  assign n4676_o = grpold[5];
  /* ./TIA/TIA.vhd:276:5  */
  assign n4677_o = grpold[6];
  /* ./TIA/TIA.vhd:278:9  */
  assign n4678_o = grpold[7];
  /* ./TIA/TIA.vhd:330:15  */
  assign n4679_o = scan_adr[1:0];
  /* ./TIA/TIA.vhd:330:15  */
  always @*
    case (n4679_o)
      2'b00: n4680_o = n4671_o;
      2'b01: n4680_o = n4672_o;
      2'b10: n4680_o = n4673_o;
      2'b11: n4680_o = n4674_o;
    endcase
  /* ./TIA/TIA.vhd:330:15  */
  assign n4681_o = scan_adr[1:0];
  /* ./TIA/TIA.vhd:330:15  */
  always @*
    case (n4681_o)
      2'b00: n4682_o = n4675_o;
      2'b01: n4682_o = n4676_o;
      2'b10: n4682_o = n4677_o;
      2'b11: n4682_o = n4678_o;
    endcase
  /* ./TIA/TIA.vhd:330:15  */
  assign n4683_o = scan_adr[2];
  /* ./TIA/TIA.vhd:330:15  */
  assign n4684_o = n4683_o ? n4682_o : n4680_o;
endmodule

module audio_argh2600
  (input  clk,
   input  clk_audio,
   input  [4:0] freq,
   input  [3:0] ctrl,
   output aout );
  wire w;
  reg [4:0] f_counter;
  reg toggled;
  wire toggled_next;
  reg [1:0] cnt3;
  wire [1:0] cnt3_next;
  wire cnt3_ena;
  reg [3:0] lfsr4;
  wire [3:0] lfsr4_next;
  reg [4:0] lfsr5;
  wire [4:0] lfsr5_next;
  reg [8:0] lfsr9;
  wire [8:0] lfsr9_next;
  wire lfsr4_clk_audio;
  wire lfsr4_out;
  wire lfsr5_out;
  wire lfsr9_out;
  wire lfsr5_edge;
  wire div31_edge;
  wire div6_edge;
  wire n4355_o;
  wire [4:0] n4359_o;
  wire [4:0] n4361_o;
  wire n4363_o;
  wire n4364_o;
  wire n4368_o;
  wire n4370_o;
  wire n4372_o;
  wire n4374_o;
  wire n4376_o;
  wire [3:0] n4380_o;
  wire n4382_o;
  wire n4383_o;
  wire n4387_o;
  wire n4389_o;
  wire n4390_o;
  wire n4391_o;
  wire n4395_o;
  wire n4396_o;
  wire n4397_o;
  wire n4402_o;
  wire n4404_o;
  wire n4406_o;
  wire n4408_o;
  wire n4409_o;
  wire n4411_o;
  wire n4412_o;
  wire n4414_o;
  wire n4415_o;
  wire n4416_o;
  wire n4418_o;
  wire n4420_o;
  wire n4422_o;
  wire n4424_o;
  wire n4425_o;
  wire n4426_o;
  wire n4428_o;
  wire n4430_o;
  wire n4431_o;
  wire n4432_o;
  wire n4434_o;
  wire n4435_o;
  wire n4436_o;
  wire n4438_o;
  wire n4439_o;
  wire n4440_o;
  wire n4442_o;
  wire n4443_o;
  wire n4444_o;
  wire n4446_o;
  wire [15:0] n4447_o;
  reg n4451_o;
  reg n4452_o;
  reg n4454_o;
  reg n4457_o;
  wire n4462_o;
  wire [1:0] n4463_o;
  wire [1:0] n4465_o;
  wire n4468_o;
  wire [3:0] n4469_o;
  wire n4470_o;
  wire n4471_o;
  wire n4472_o;
  wire [2:0] n4473_o;
  wire [3:0] n4474_o;
  wire n4477_o;
  wire [4:0] n4478_o;
  wire n4479_o;
  wire n4480_o;
  wire n4481_o;
  wire [3:0] n4482_o;
  wire [4:0] n4483_o;
  wire n4486_o;
  wire [8:0] n4487_o;
  wire n4488_o;
  wire n4489_o;
  wire n4490_o;
  wire [7:0] n4491_o;
  wire [8:0] n4492_o;
  wire n4493_o;
  wire n4494_o;
  wire n4495_o;
  wire [4:0] n4496_o;
  reg [4:0] n4497_q;
  wire n4498_o;
  reg n4499_q;
  wire [1:0] n4500_o;
  reg [1:0] n4501_q;
  wire [3:0] n4502_o;
  reg [3:0] n4503_q;
  wire [4:0] n4504_o;
  reg [4:0] n4505_q;
  wire [8:0] n4506_o;
  reg [8:0] n4507_q;
  assign aout  = w;
  /* ./TIA/audio_argh2600.vhd:43:8  */
  assign w = n4451_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:44:8  */
  always @*
    f_counter = n4497_q; // (isignal)
  initial
    f_counter = 5'b00000;
  /* ./TIA/audio_argh2600.vhd:45:8  */
  always @*
    toggled = n4499_q; // (isignal)
  initial
    toggled = 1'b0;
  /* ./TIA/audio_argh2600.vhd:46:8  */
  assign toggled_next = n4452_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:48:8  */
  always @*
    cnt3 = n4501_q; // (isignal)
  initial
    cnt3 = 2'b00;
  /* ./TIA/audio_argh2600.vhd:49:8  */
  assign cnt3_next = n4463_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:50:8  */
  assign cnt3_ena = n4454_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:52:8  */
  always @*
    lfsr4 = n4503_q; // (isignal)
  initial
    lfsr4 = 4'b0000;
  /* ./TIA/audio_argh2600.vhd:53:8  */
  assign lfsr4_next = n4469_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:54:8  */
  always @*
    lfsr5 = n4505_q; // (isignal)
  initial
    lfsr5 = 5'b00000;
  /* ./TIA/audio_argh2600.vhd:55:8  */
  assign lfsr5_next = n4478_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:56:8  */
  always @*
    lfsr9 = n4507_q; // (isignal)
  initial
    lfsr9 = 9'b000000000;
  /* ./TIA/audio_argh2600.vhd:57:8  */
  assign lfsr9_next = n4487_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:58:8  */
  assign lfsr4_clk_audio = n4457_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:59:8  */
  assign lfsr4_out = n4493_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:59:19  */
  assign lfsr5_out = n4494_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:59:30  */
  assign lfsr9_out = n4495_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:60:8  */
  assign lfsr5_edge = n4383_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:62:8  */
  assign div31_edge = n4391_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:62:20  */
  assign div6_edge = n4397_o; // (signal)
  /* ./TIA/audio_argh2600.vhd:71:47  */
  assign n4355_o = f_counter == freq;
  /* ./TIA/audio_argh2600.vhd:89:72  */
  assign n4359_o = f_counter + 5'b00001;
  /* ./TIA/audio_argh2600.vhd:71:33  */
  assign n4361_o = n4355_o ? 5'b00000 : n4359_o;
  /* ./TIA/audio_argh2600.vhd:71:33  */
  assign n4363_o = cnt3_ena & n4355_o;
  /* ./TIA/audio_argh2600.vhd:71:33  */
  assign n4364_o = lfsr4_clk_audio & n4355_o;
  /* ./TIA/audio_argh2600.vhd:69:45  */
  assign n4368_o = n4355_o & clk_audio;
  /* ./TIA/audio_argh2600.vhd:69:45  */
  assign n4370_o = n4363_o & clk_audio;
  /* ./TIA/audio_argh2600.vhd:69:45  */
  assign n4372_o = n4364_o & clk_audio;
  /* ./TIA/audio_argh2600.vhd:69:45  */
  assign n4374_o = n4355_o & clk_audio;
  /* ./TIA/audio_argh2600.vhd:69:45  */
  assign n4376_o = n4355_o & clk_audio;
  /* ./TIA/audio_argh2600.vhd:99:62  */
  assign n4380_o = lfsr5[4:1];
  /* ./TIA/audio_argh2600.vhd:99:75  */
  assign n4382_o = n4380_o == 4'b0110;
  /* ./TIA/audio_argh2600.vhd:96:27  */
  assign n4383_o = n4382_o ? 1'b1 : 1'b0;
  /* ./TIA/audio_argh2600.vhd:102:38  */
  assign n4387_o = lfsr5 == 5'b11111;
  /* ./TIA/audio_argh2600.vhd:102:57  */
  assign n4389_o = lfsr5 == 5'b10000;
  /* ./TIA/audio_argh2600.vhd:102:48  */
  assign n4390_o = n4387_o | n4389_o;
  /* ./TIA/audio_argh2600.vhd:102:27  */
  assign n4391_o = n4390_o ? 1'b1 : 1'b0;
  /* ./TIA/audio_argh2600.vhd:103:61  */
  assign n4395_o = cnt3_next == 2'b10;
  /* ./TIA/audio_argh2600.vhd:103:47  */
  assign n4396_o = n4395_o & cnt3_ena;
  /* ./TIA/audio_argh2600.vhd:103:27  */
  assign n4397_o = n4396_o ? 1'b1 : 1'b0;
  /* ./TIA/audio_argh2600.vhd:136:25  */
  assign n4402_o = ctrl == 4'b0000;
  /* ./TIA/audio_argh2600.vhd:139:25  */
  assign n4404_o = ctrl == 4'b0001;
  /* ./TIA/audio_argh2600.vhd:142:25  */
  assign n4406_o = ctrl == 4'b0010;
  /* ./TIA/audio_argh2600.vhd:146:25  */
  assign n4408_o = ctrl == 4'b0011;
  /* ./TIA/audio_argh2600.vhd:152:49  */
  assign n4409_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:150:25  */
  assign n4411_o = ctrl == 4'b0100;
  /* ./TIA/audio_argh2600.vhd:156:49  */
  assign n4412_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:154:25  */
  assign n4414_o = ctrl == 4'b0101;
  /* ./TIA/audio_argh2600.vhd:161:57  */
  assign n4415_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:160:33  */
  assign n4416_o = div31_edge ? n4415_o : toggled;
  /* ./TIA/audio_argh2600.vhd:158:25  */
  assign n4418_o = ctrl == 4'b0110;
  /* ./TIA/audio_argh2600.vhd:164:25  */
  assign n4420_o = ctrl == 4'b0111;
  /* ./TIA/audio_argh2600.vhd:167:25  */
  assign n4422_o = ctrl == 4'b1000;
  /* ./TIA/audio_argh2600.vhd:170:25  */
  assign n4424_o = ctrl == 4'b1001;
  /* ./TIA/audio_argh2600.vhd:176:57  */
  assign n4425_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:175:33  */
  assign n4426_o = div31_edge ? n4425_o : toggled;
  /* ./TIA/audio_argh2600.vhd:173:25  */
  assign n4428_o = ctrl == 4'b1010;
  /* ./TIA/audio_argh2600.vhd:179:25  */
  assign n4430_o = ctrl == 4'b1011;
  /* ./TIA/audio_argh2600.vhd:185:57  */
  assign n4431_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:184:33  */
  assign n4432_o = div6_edge ? n4431_o : toggled;
  /* ./TIA/audio_argh2600.vhd:182:25  */
  assign n4434_o = ctrl == 4'b1100;
  /* ./TIA/audio_argh2600.vhd:191:57  */
  assign n4435_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:190:33  */
  assign n4436_o = div6_edge ? n4435_o : toggled;
  /* ./TIA/audio_argh2600.vhd:188:25  */
  assign n4438_o = ctrl == 4'b1101;
  /* ./TIA/audio_argh2600.vhd:198:57  */
  assign n4439_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:197:33  */
  assign n4440_o = div6_edge ? n4439_o : toggled;
  /* ./TIA/audio_argh2600.vhd:194:25  */
  assign n4442_o = ctrl == 4'b1110;
  /* ./TIA/audio_argh2600.vhd:204:57  */
  assign n4443_o = ~toggled;
  /* ./TIA/audio_argh2600.vhd:203:33  */
  assign n4444_o = lfsr5_edge ? n4443_o : toggled;
  /* ./TIA/audio_argh2600.vhd:201:25  */
  assign n4446_o = ctrl == 4'b1111;
  assign n4447_o = {n4446_o, n4442_o, n4438_o, n4434_o, n4430_o, n4428_o, n4424_o, n4422_o, n4420_o, n4418_o, n4414_o, n4411_o, n4408_o, n4406_o, n4404_o, n4402_o};
  /* ./TIA/audio_argh2600.vhd:134:17  */
  always @*
    case (n4447_o)
      16'b1000000000000000: n4451_o = toggled;
      16'b0100000000000000: n4451_o = toggled;
      16'b0010000000000000: n4451_o = toggled;
      16'b0001000000000000: n4451_o = toggled;
      16'b0000100000000000: n4451_o = 1'b1;
      16'b0000010000000000: n4451_o = toggled;
      16'b0000001000000000: n4451_o = lfsr5_out;
      16'b0000000100000000: n4451_o = lfsr9_out;
      16'b0000000010000000: n4451_o = lfsr5_out;
      16'b0000000001000000: n4451_o = toggled;
      16'b0000000000100000: n4451_o = toggled;
      16'b0000000000010000: n4451_o = toggled;
      16'b0000000000001000: n4451_o = lfsr4_out;
      16'b0000000000000100: n4451_o = lfsr4_out;
      16'b0000000000000010: n4451_o = lfsr4_out;
      16'b0000000000000001: n4451_o = 1'b1;
      default: n4451_o = 1'b1;
    endcase
  /* ./TIA/audio_argh2600.vhd:134:17  */
  always @*
    case (n4447_o)
      16'b1000000000000000: n4452_o = n4444_o;
      16'b0100000000000000: n4452_o = n4440_o;
      16'b0010000000000000: n4452_o = n4436_o;
      16'b0001000000000000: n4452_o = n4432_o;
      16'b0000100000000000: n4452_o = toggled;
      16'b0000010000000000: n4452_o = n4426_o;
      16'b0000001000000000: n4452_o = toggled;
      16'b0000000100000000: n4452_o = toggled;
      16'b0000000010000000: n4452_o = toggled;
      16'b0000000001000000: n4452_o = n4416_o;
      16'b0000000000100000: n4452_o = n4412_o;
      16'b0000000000010000: n4452_o = n4409_o;
      16'b0000000000001000: n4452_o = toggled;
      16'b0000000000000100: n4452_o = toggled;
      16'b0000000000000010: n4452_o = toggled;
      16'b0000000000000001: n4452_o = toggled;
      default: n4452_o = toggled;
    endcase
  /* ./TIA/audio_argh2600.vhd:134:17  */
  always @*
    case (n4447_o)
      16'b1000000000000000: n4454_o = 1'b1;
      16'b0100000000000000: n4454_o = div31_edge;
      16'b0010000000000000: n4454_o = 1'b1;
      16'b0001000000000000: n4454_o = 1'b1;
      16'b0000100000000000: n4454_o = 1'b1;
      16'b0000010000000000: n4454_o = 1'b1;
      16'b0000001000000000: n4454_o = 1'b1;
      16'b0000000100000000: n4454_o = 1'b1;
      16'b0000000010000000: n4454_o = 1'b1;
      16'b0000000001000000: n4454_o = 1'b1;
      16'b0000000000100000: n4454_o = 1'b1;
      16'b0000000000010000: n4454_o = 1'b1;
      16'b0000000000001000: n4454_o = 1'b1;
      16'b0000000000000100: n4454_o = 1'b1;
      16'b0000000000000010: n4454_o = 1'b1;
      16'b0000000000000001: n4454_o = 1'b1;
      default: n4454_o = 1'b1;
    endcase
  /* ./TIA/audio_argh2600.vhd:134:17  */
  always @*
    case (n4447_o)
      16'b1000000000000000: n4457_o = 1'b1;
      16'b0100000000000000: n4457_o = 1'b1;
      16'b0010000000000000: n4457_o = 1'b1;
      16'b0001000000000000: n4457_o = 1'b1;
      16'b0000100000000000: n4457_o = 1'b1;
      16'b0000010000000000: n4457_o = 1'b1;
      16'b0000001000000000: n4457_o = 1'b1;
      16'b0000000100000000: n4457_o = 1'b1;
      16'b0000000010000000: n4457_o = 1'b1;
      16'b0000000001000000: n4457_o = 1'b1;
      16'b0000000000100000: n4457_o = 1'b1;
      16'b0000000000010000: n4457_o = 1'b1;
      16'b0000000000001000: n4457_o = lfsr5_out;
      16'b0000000000000100: n4457_o = div31_edge;
      16'b0000000000000010: n4457_o = 1'b1;
      16'b0000000000000001: n4457_o = 1'b1;
      default: n4457_o = 1'b1;
    endcase
  /* ./TIA/audio_argh2600.vhd:213:37  */
  assign n4462_o = cnt3 == 2'b10;
  /* ./TIA/audio_argh2600.vhd:213:27  */
  assign n4463_o = n4462_o ? 2'b00 : n4465_o;
  /* ./TIA/audio_argh2600.vhd:213:53  */
  assign n4465_o = cnt3 + 2'b01;
  /* ./TIA/audio_argh2600.vhd:215:41  */
  assign n4468_o = lfsr4 == 4'b0000;
  /* ./TIA/audio_argh2600.vhd:215:30  */
  assign n4469_o = n4468_o ? 4'b1111 : n4474_o;
  /* ./TIA/audio_argh2600.vhd:216:49  */
  assign n4470_o = lfsr4[0];
  /* ./TIA/audio_argh2600.vhd:216:62  */
  assign n4471_o = lfsr4[1];
  /* ./TIA/audio_argh2600.vhd:216:53  */
  assign n4472_o = n4470_o ^ n4471_o;
  /* ./TIA/audio_argh2600.vhd:216:74  */
  assign n4473_o = lfsr4[3:1];
  /* ./TIA/audio_argh2600.vhd:216:67  */
  assign n4474_o = {n4472_o, n4473_o};
  /* ./TIA/audio_argh2600.vhd:218:42  */
  assign n4477_o = lfsr5 == 5'b00000;
  /* ./TIA/audio_argh2600.vhd:218:31  */
  assign n4478_o = n4477_o ? 5'b11111 : n4483_o;
  /* ./TIA/audio_argh2600.vhd:219:49  */
  assign n4479_o = lfsr5[0];
  /* ./TIA/audio_argh2600.vhd:219:62  */
  assign n4480_o = lfsr5[2];
  /* ./TIA/audio_argh2600.vhd:219:53  */
  assign n4481_o = n4479_o ^ n4480_o;
  /* ./TIA/audio_argh2600.vhd:219:74  */
  assign n4482_o = lfsr5[4:1];
  /* ./TIA/audio_argh2600.vhd:219:67  */
  assign n4483_o = {n4481_o, n4482_o};
  /* ./TIA/audio_argh2600.vhd:221:46  */
  assign n4486_o = lfsr9 == 9'b000000000;
  /* ./TIA/audio_argh2600.vhd:221:35  */
  assign n4487_o = n4486_o ? 9'b111111111 : n4492_o;
  /* ./TIA/audio_argh2600.vhd:222:49  */
  assign n4488_o = lfsr9[0];
  /* ./TIA/audio_argh2600.vhd:222:62  */
  assign n4489_o = lfsr9[4];
  /* ./TIA/audio_argh2600.vhd:222:53  */
  assign n4490_o = n4488_o ^ n4489_o;
  /* ./TIA/audio_argh2600.vhd:222:74  */
  assign n4491_o = lfsr9[8:1];
  /* ./TIA/audio_argh2600.vhd:222:67  */
  assign n4492_o = {n4490_o, n4491_o};
  /* ./TIA/audio_argh2600.vhd:224:27  */
  assign n4493_o = lfsr4[0];
  /* ./TIA/audio_argh2600.vhd:225:27  */
  assign n4494_o = lfsr5[0];
  /* ./TIA/audio_argh2600.vhd:226:27  */
  assign n4495_o = lfsr9[0];
  /* ./TIA/audio_argh2600.vhd:69:17  */
  assign n4496_o = clk_audio ? n4361_o : f_counter;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  always @(posedge clk)
    n4497_q <= n4496_o;
  initial
    n4497_q = 5'b00000;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  assign n4498_o = n4368_o ? toggled_next : toggled;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  always @(posedge clk)
    n4499_q <= n4498_o;
  initial
    n4499_q = 1'b0;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  assign n4500_o = n4370_o ? cnt3_next : cnt3;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  always @(posedge clk)
    n4501_q <= n4500_o;
  initial
    n4501_q = 2'b00;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  assign n4502_o = n4372_o ? lfsr4_next : lfsr4;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  always @(posedge clk)
    n4503_q <= n4502_o;
  initial
    n4503_q = 4'b0000;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  assign n4504_o = n4374_o ? lfsr5_next : lfsr5;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  always @(posedge clk)
    n4505_q <= n4504_o;
  initial
    n4505_q = 5'b00000;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  assign n4506_o = n4376_o ? lfsr9_next : lfsr9;
  /* ./TIA/audio_argh2600.vhd:69:17  */
  always @(posedge clk)
    n4507_q <= n4506_o;
  initial
    n4507_q = 9'b000000000;
endmodule

module mux20
  (input  [19:0] i,
   input  [4:0] a,
   input  rev,
   output o);
  wire out_fwd;
  wire out_rev;
  wire n4216_o;
  wire n4217_o;
  wire n4218_o;
  wire n4220_o;
  wire n4221_o;
  wire n4223_o;
  wire n4224_o;
  wire n4226_o;
  wire n4227_o;
  wire n4229_o;
  wire n4230_o;
  wire n4232_o;
  wire n4233_o;
  wire n4235_o;
  wire n4236_o;
  wire n4238_o;
  wire n4239_o;
  wire n4241_o;
  wire n4242_o;
  wire n4244_o;
  wire n4245_o;
  wire n4247_o;
  wire n4248_o;
  wire n4250_o;
  wire n4251_o;
  wire n4253_o;
  wire n4254_o;
  wire n4256_o;
  wire n4257_o;
  wire n4259_o;
  wire n4260_o;
  wire n4262_o;
  wire n4263_o;
  wire n4265_o;
  wire n4266_o;
  wire n4268_o;
  wire n4269_o;
  wire n4271_o;
  wire n4272_o;
  wire n4274_o;
  wire n4275_o;
  wire n4277_o;
  wire [19:0] n4279_o;
  reg n4280_o;
  wire n4281_o;
  wire n4283_o;
  wire n4284_o;
  wire n4286_o;
  wire n4287_o;
  wire n4289_o;
  wire n4290_o;
  wire n4292_o;
  wire n4293_o;
  wire n4295_o;
  wire n4296_o;
  wire n4298_o;
  wire n4299_o;
  wire n4301_o;
  wire n4302_o;
  wire n4304_o;
  wire n4305_o;
  wire n4307_o;
  wire n4308_o;
  wire n4310_o;
  wire n4311_o;
  wire n4313_o;
  wire n4314_o;
  wire n4316_o;
  wire n4317_o;
  wire n4319_o;
  wire n4320_o;
  wire n4322_o;
  wire n4323_o;
  wire n4325_o;
  wire n4326_o;
  wire n4328_o;
  wire n4329_o;
  wire n4331_o;
  wire n4332_o;
  wire n4334_o;
  wire n4335_o;
  wire n4337_o;
  wire n4338_o;
  wire n4340_o;
  wire [19:0] n4342_o;
  reg n4343_o;
  assign o = n4217_o;
  /* ./TIA/TIA.vhd:533:10  */
  assign out_fwd = n4343_o; // (signal)
  /* ./TIA/TIA.vhd:534:10  */
  assign out_rev = n4280_o; // (signal)
  /* ./TIA/TIA.vhd:536:27  */
  assign n4216_o = ~rev;
  /* ./TIA/TIA.vhd:536:18  */
  assign n4217_o = n4216_o ? out_fwd : out_rev;
  /* ./TIA/TIA.vhd:539:10  */
  assign n4218_o = i[19];
  /* ./TIA/TIA.vhd:539:15  */
  assign n4220_o = a == 5'b00000;
  /* ./TIA/TIA.vhd:540:10  */
  assign n4221_o = i[18];
  /* ./TIA/TIA.vhd:540:15  */
  assign n4223_o = a == 5'b00001;
  /* ./TIA/TIA.vhd:541:10  */
  assign n4224_o = i[17];
  /* ./TIA/TIA.vhd:541:15  */
  assign n4226_o = a == 5'b00010;
  /* ./TIA/TIA.vhd:542:10  */
  assign n4227_o = i[16];
  /* ./TIA/TIA.vhd:542:15  */
  assign n4229_o = a == 5'b00011;
  /* ./TIA/TIA.vhd:543:10  */
  assign n4230_o = i[15];
  /* ./TIA/TIA.vhd:543:15  */
  assign n4232_o = a == 5'b00100;
  /* ./TIA/TIA.vhd:544:10  */
  assign n4233_o = i[14];
  /* ./TIA/TIA.vhd:544:15  */
  assign n4235_o = a == 5'b00101;
  /* ./TIA/TIA.vhd:545:10  */
  assign n4236_o = i[13];
  /* ./TIA/TIA.vhd:545:15  */
  assign n4238_o = a == 5'b00110;
  /* ./TIA/TIA.vhd:546:10  */
  assign n4239_o = i[12];
  /* ./TIA/TIA.vhd:546:15  */
  assign n4241_o = a == 5'b00111;
  /* ./TIA/TIA.vhd:547:10  */
  assign n4242_o = i[4];
  /* ./TIA/TIA.vhd:547:14  */
  assign n4244_o = a == 5'b01000;
  /* ./TIA/TIA.vhd:548:10  */
  assign n4245_o = i[5];
  /* ./TIA/TIA.vhd:548:14  */
  assign n4247_o = a == 5'b01001;
  /* ./TIA/TIA.vhd:549:10  */
  assign n4248_o = i[6];
  /* ./TIA/TIA.vhd:549:14  */
  assign n4250_o = a == 5'b01010;
  /* ./TIA/TIA.vhd:550:10  */
  assign n4251_o = i[7];
  /* ./TIA/TIA.vhd:550:14  */
  assign n4253_o = a == 5'b01011;
  /* ./TIA/TIA.vhd:551:10  */
  assign n4254_o = i[8];
  /* ./TIA/TIA.vhd:551:14  */
  assign n4256_o = a == 5'b01100;
  /* ./TIA/TIA.vhd:552:10  */
  assign n4257_o = i[9];
  /* ./TIA/TIA.vhd:552:14  */
  assign n4259_o = a == 5'b01101;
  /* ./TIA/TIA.vhd:553:10  */
  assign n4260_o = i[10];
  /* ./TIA/TIA.vhd:553:15  */
  assign n4262_o = a == 5'b01110;
  /* ./TIA/TIA.vhd:554:10  */
  assign n4263_o = i[11];
  /* ./TIA/TIA.vhd:554:15  */
  assign n4265_o = a == 5'b01111;
  /* ./TIA/TIA.vhd:555:10  */
  assign n4266_o = i[3];
  /* ./TIA/TIA.vhd:555:14  */
  assign n4268_o = a == 5'b10000;
  /* ./TIA/TIA.vhd:556:10  */
  assign n4269_o = i[2];
  /* ./TIA/TIA.vhd:556:14  */
  assign n4271_o = a == 5'b10001;
  /* ./TIA/TIA.vhd:557:10  */
  assign n4272_o = i[1];
  /* ./TIA/TIA.vhd:557:14  */
  assign n4274_o = a == 5'b10010;
  /* ./TIA/TIA.vhd:558:10  */
  assign n4275_o = i[0];
  /* ./TIA/TIA.vhd:558:14  */
  assign n4277_o = a == 5'b10011;
  assign n4279_o = {n4277_o, n4274_o, n4271_o, n4268_o, n4265_o, n4262_o, n4259_o, n4256_o, n4253_o, n4250_o, n4247_o, n4244_o, n4241_o, n4238_o, n4235_o, n4232_o, n4229_o, n4226_o, n4223_o, n4220_o};
  /* ./TIA/TIA.vhd:538:5  */
  always @*
    case (n4279_o)
      20'b10000000000000000000: n4280_o = n4275_o;
      20'b01000000000000000000: n4280_o = n4272_o;
      20'b00100000000000000000: n4280_o = n4269_o;
      20'b00010000000000000000: n4280_o = n4266_o;
      20'b00001000000000000000: n4280_o = n4263_o;
      20'b00000100000000000000: n4280_o = n4260_o;
      20'b00000010000000000000: n4280_o = n4257_o;
      20'b00000001000000000000: n4280_o = n4254_o;
      20'b00000000100000000000: n4280_o = n4251_o;
      20'b00000000010000000000: n4280_o = n4248_o;
      20'b00000000001000000000: n4280_o = n4245_o;
      20'b00000000000100000000: n4280_o = n4242_o;
      20'b00000000000010000000: n4280_o = n4239_o;
      20'b00000000000001000000: n4280_o = n4236_o;
      20'b00000000000000100000: n4280_o = n4233_o;
      20'b00000000000000010000: n4280_o = n4230_o;
      20'b00000000000000001000: n4280_o = n4227_o;
      20'b00000000000000000100: n4280_o = n4224_o;
      20'b00000000000000000010: n4280_o = n4221_o;
      20'b00000000000000000001: n4280_o = n4218_o;
      default: n4280_o = 1'bX;
    endcase
  /* ./TIA/TIA.vhd:562:10  */
  assign n4281_o = i[0];
  /* ./TIA/TIA.vhd:562:14  */
  assign n4283_o = a == 5'b00000;
  /* ./TIA/TIA.vhd:563:10  */
  assign n4284_o = i[1];
  /* ./TIA/TIA.vhd:563:14  */
  assign n4286_o = a == 5'b00001;
  /* ./TIA/TIA.vhd:564:10  */
  assign n4287_o = i[2];
  /* ./TIA/TIA.vhd:564:14  */
  assign n4289_o = a == 5'b00010;
  /* ./TIA/TIA.vhd:565:10  */
  assign n4290_o = i[3];
  /* ./TIA/TIA.vhd:565:14  */
  assign n4292_o = a == 5'b00011;
  /* ./TIA/TIA.vhd:566:10  */
  assign n4293_o = i[11];
  /* ./TIA/TIA.vhd:566:15  */
  assign n4295_o = a == 5'b00100;
  /* ./TIA/TIA.vhd:567:10  */
  assign n4296_o = i[10];
  /* ./TIA/TIA.vhd:567:15  */
  assign n4298_o = a == 5'b00101;
  /* ./TIA/TIA.vhd:568:10  */
  assign n4299_o = i[9];
  /* ./TIA/TIA.vhd:568:14  */
  assign n4301_o = a == 5'b00110;
  /* ./TIA/TIA.vhd:569:10  */
  assign n4302_o = i[8];
  /* ./TIA/TIA.vhd:569:14  */
  assign n4304_o = a == 5'b00111;
  /* ./TIA/TIA.vhd:570:10  */
  assign n4305_o = i[7];
  /* ./TIA/TIA.vhd:570:14  */
  assign n4307_o = a == 5'b01000;
  /* ./TIA/TIA.vhd:571:10  */
  assign n4308_o = i[6];
  /* ./TIA/TIA.vhd:571:14  */
  assign n4310_o = a == 5'b01001;
  /* ./TIA/TIA.vhd:572:10  */
  assign n4311_o = i[5];
  /* ./TIA/TIA.vhd:572:14  */
  assign n4313_o = a == 5'b01010;
  /* ./TIA/TIA.vhd:573:10  */
  assign n4314_o = i[4];
  /* ./TIA/TIA.vhd:573:14  */
  assign n4316_o = a == 5'b01011;
  /* ./TIA/TIA.vhd:574:10  */
  assign n4317_o = i[12];
  /* ./TIA/TIA.vhd:574:15  */
  assign n4319_o = a == 5'b01100;
  /* ./TIA/TIA.vhd:575:10  */
  assign n4320_o = i[13];
  /* ./TIA/TIA.vhd:575:15  */
  assign n4322_o = a == 5'b01101;
  /* ./TIA/TIA.vhd:576:10  */
  assign n4323_o = i[14];
  /* ./TIA/TIA.vhd:576:15  */
  assign n4325_o = a == 5'b01110;
  /* ./TIA/TIA.vhd:577:10  */
  assign n4326_o = i[15];
  /* ./TIA/TIA.vhd:577:15  */
  assign n4328_o = a == 5'b01111;
  /* ./TIA/TIA.vhd:578:10  */
  assign n4329_o = i[16];
  /* ./TIA/TIA.vhd:578:15  */
  assign n4331_o = a == 5'b10000;
  /* ./TIA/TIA.vhd:579:10  */
  assign n4332_o = i[17];
  /* ./TIA/TIA.vhd:579:15  */
  assign n4334_o = a == 5'b10001;
  /* ./TIA/TIA.vhd:580:10  */
  assign n4335_o = i[18];
  /* ./TIA/TIA.vhd:580:15  */
  assign n4337_o = a == 5'b10010;
  /* ./TIA/TIA.vhd:581:10  */
  assign n4338_o = i[19];
  /* ./TIA/TIA.vhd:581:15  */
  assign n4340_o = a == 5'b10011;
  assign n4342_o = {n4340_o, n4337_o, n4334_o, n4331_o, n4328_o, n4325_o, n4322_o, n4319_o, n4316_o, n4313_o, n4310_o, n4307_o, n4304_o, n4301_o, n4298_o, n4295_o, n4292_o, n4289_o, n4286_o, n4283_o};
  /* ./TIA/TIA.vhd:561:5  */
  always @*
    case (n4342_o)
      20'b10000000000000000000: n4343_o = n4338_o;
      20'b01000000000000000000: n4343_o = n4335_o;
      20'b00100000000000000000: n4343_o = n4332_o;
      20'b00010000000000000000: n4343_o = n4329_o;
      20'b00001000000000000000: n4343_o = n4326_o;
      20'b00000100000000000000: n4343_o = n4323_o;
      20'b00000010000000000000: n4343_o = n4320_o;
      20'b00000001000000000000: n4343_o = n4317_o;
      20'b00000000100000000000: n4343_o = n4314_o;
      20'b00000000010000000000: n4343_o = n4311_o;
      20'b00000000001000000000: n4343_o = n4308_o;
      20'b00000000000100000000: n4343_o = n4305_o;
      20'b00000000000010000000: n4343_o = n4302_o;
      20'b00000000000001000000: n4343_o = n4299_o;
      20'b00000000000000100000: n4343_o = n4296_o;
      20'b00000000000000010000: n4343_o = n4293_o;
      20'b00000000000000001000: n4343_o = n4290_o;
      20'b00000000000000000100: n4343_o = n4287_o;
      20'b00000000000000000010: n4343_o = n4284_o;
      20'b00000000000000000001: n4343_o = n4281_o;
      default: n4343_o = 1'bX;
    endcase
endmodule

module lfsr6
  (input  clk,
   input  prst,
   input  cnt,
   output [5:0] o);
  wire [5:0] d;
  reg prst_l;
  wire n4194_o;
  wire n4195_o;
  wire n4197_o;
  wire n4199_o;
  wire n4202_o;
  wire n4203_o;
  wire n4204_o;
  wire [4:0] n4205_o;
  wire [5:0] n4206_o;
  wire [5:0] n4208_o;
  wire [5:0] n4212_o;
  reg [5:0] n4213_q;
  reg n4214_q;
  assign o = d;
  /* ./TIA/TIA.vhd:33:12  */
  assign d = n4213_q; // (signal)
  /* ./TIA/TIA.vhd:34:12  */
  always @*
    prst_l = n4214_q; // (isignal)
  initial
    prst_l = 1'b1;
  /* ./TIA/TIA.vhd:44:39  */
  assign n4194_o = ~prst_l;
  /* ./TIA/TIA.vhd:44:28  */
  assign n4195_o = n4194_o & prst;
  /* ./TIA/TIA.vhd:46:13  */
  assign n4197_o = cnt ? 1'b0 : prst_l;
  /* ./TIA/TIA.vhd:44:13  */
  assign n4199_o = n4195_o ? 1'b1 : n4197_o;
  /* ./TIA/TIA.vhd:56:28  */
  assign n4202_o = d[0];
  /* ./TIA/TIA.vhd:56:38  */
  assign n4203_o = d[1];
  /* ./TIA/TIA.vhd:56:32  */
  assign n4204_o = ~(n4202_o ^ n4203_o);
  /* ./TIA/TIA.vhd:56:46  */
  assign n4205_o = d[5:1];
  /* ./TIA/TIA.vhd:56:43  */
  assign n4206_o = {n4204_o, n4205_o};
  /* ./TIA/TIA.vhd:53:17  */
  assign n4208_o = prst_l ? 6'b000000 : n4206_o;
  /* ./TIA/TIA.vhd:51:9  */
  assign n4212_o = cnt ? n4208_o : d;
  /* ./TIA/TIA.vhd:51:9  */
  always @(posedge clk)
    n4213_q <= n4212_o;
  /* ./TIA/TIA.vhd:43:9  */
  always @(posedge clk)
    n4214_q <= n4199_o;
  initial
    n4214_q = 1'b1;
endmodule

module cntr2
  (input  clk,
   input  rst,
   input  en,
   output [1:0] o);
  reg [1:0] d;
  wire n4170_o;
  wire n4172_o;
  wire n4174_o;
  wire n4176_o;
  wire [3:0] n4177_o;
  reg [1:0] n4182_o;
  wire [1:0] n4183_o;
  wire [1:0] n4185_o;
  reg [1:0] n4188_q;
  assign o = d;
  /* ./TIA/TIA.vhd:78:12  */
  always @*
    d = n4188_q; // (isignal)
  initial
    d = 2'b00;
  /* ./TIA/TIA.vhd:93:21  */
  assign n4170_o = d == 2'b00;
  /* ./TIA/TIA.vhd:94:21  */
  assign n4172_o = d == 2'b10;
  /* ./TIA/TIA.vhd:95:21  */
  assign n4174_o = d == 2'b11;
  /* ./TIA/TIA.vhd:96:21  */
  assign n4176_o = d == 2'b01;
  /* ./A6532.vhd:38:5  */
  assign n4177_o = {n4176_o, n4174_o, n4172_o, n4170_o};
  /* ./TIA/TIA.vhd:92:17  */
  always @*
    case (n4177_o)
      4'b1000: n4182_o = 2'b00;
      4'b0100: n4182_o = 2'b01;
      4'b0010: n4182_o = 2'b11;
      4'b0001: n4182_o = 2'b10;
      default: n4182_o = d;
    endcase
  /* ./TIA/TIA.vhd:91:13  */
  assign n4183_o = en ? n4182_o : d;
  /* ./TIA/TIA.vhd:89:13  */
  assign n4185_o = rst ? 2'b00 : n4183_o;
  /* ./TIA/TIA.vhd:88:9  */
  always @(posedge clk)
    n4188_q <= n4185_o;
  initial
    n4188_q = 2'b00;
endmodule

module ramx8_7
  (input  clk,
   input  r,
   input  [7:0] d_in,
   input  [6:0] a,
   output [7:0] d_out);
  wire n4157_o;
  reg [7:0] n4162_data; // mem_rd
  assign d_out = n4162_data;
  /* ./A6532.vhd:41:13  */
  assign n4157_o = ~r;
  /* ./A6532.vhd:42:30  */
  reg [7:0] ram[127:0] ; // memory
  always @(posedge clk)
    if (r)
      n4162_data <= ram[a];
  always @(posedge clk)
    if (n4157_o)
      ram[a] <= d_in;
  /* ./A6532.vhd:40:9  */
  /* ./A6532.vhd:44:21  */
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
  wire [7:0] n3123_o;
  wire [7:0] n3124_o;
  wire [7:0] n3125_o;
  wire [7:0] n3126_o;
  wire [7:0] n3127_o;
  wire [7:0] n3128_o;
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
  wire n3133_o;
  wire n3134_o;
  wire n3137_o;
  wire n3138_o;
  wire [1:0] n3141_o;
  wire n3143_o;
  wire [1:0] n3144_o;
  wire n3146_o;
  wire n3147_o;
  wire [1:0] n3148_o;
  wire n3150_o;
  wire n3151_o;
  wire n3152_o;
  wire n3156_o;
  wire n3158_o;
  wire n3159_o;
  wire n3160_o;
  wire n3161_o;
  wire n3165_o;
  wire n3166_o;
  wire n3169_o;
  wire n3170_o;
  wire n3171_o;
  wire [7:0] n3173_o;
  wire [7:0] n3174_o;
  wire [7:0] n3175_o;
  wire [7:0] n3176_o;
  wire [31:0] n3177_o;
  wire [39:0] n3178_o;
  wire [7:0] n3179_o;
  wire [47:0] n3180_o;
  wire [7:0] n3181_o;
  wire [55:0] n3182_o;
  wire [7:0] n3183_o;
  wire [63:0] n3184_o;
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
  wire n3215_o;
  wire n3227_o;
  wire n3230_o;
  wire n3232_o;
  wire n3234_o;
  wire n3235_o;
  wire n3237_o;
  wire n3239_o;
  wire n3240_o;
  wire n3241_o;
  wire n3242_o;
  wire n3243_o;
  wire n3245_o;
  wire n3247_o;
  wire n3248_o;
  wire n3249_o;
  wire n3251_o;
  wire n3252_o;
  wire n3253_o;
  wire n3254_o;
  wire [15:0] n3256_o;
  wire n3258_o;
  wire [7:0] n3260_o;
  wire [7:0] n3261_o;
  wire [7:0] n3262_o;
  wire n3263_o;
  wire n3265_o;
  wire [1:0] n3270_o;
  wire [15:0] n3272_o;
  wire [7:0] n3273_o;
  wire [15:0] n3274_o;
  wire [15:0] n3275_o;
  wire n3276_o;
  wire n3278_o;
  wire n3279_o;
  wire n3280_o;
  wire [15:0] n3282_o;
  wire [15:0] n3283_o;
  wire n3285_o;
  wire n3287_o;
  wire n3288_o;
  wire n3289_o;
  wire n3290_o;
  wire n3291_o;
  wire n3292_o;
  wire [15:0] n3294_o;
  wire [15:0] n3297_o;
  wire n3299_o;
  wire [15:0] n3300_o;
  wire n3302_o;
  wire n3303_o;
  wire n3304_o;
  wire n3305_o;
  wire [7:0] n3306_o;
  wire [7:0] n3308_o;
  wire [7:0] n3309_o;
  wire [7:0] n3311_o;
  wire [7:0] n3312_o;
  wire [7:0] n3313_o;
  wire [7:0] n3314_o;
  wire [7:0] n3315_o;
  wire [7:0] n3316_o;
  wire [7:0] n3317_o;
  wire [7:0] n3318_o;
  wire [7:0] n3319_o;
  wire n3321_o;
  wire [2:0] n3322_o;
  wire [7:0] n3323_o;
  wire [7:0] n3324_o;
  wire [7:0] n3325_o;
  wire [7:0] n3326_o;
  wire [7:0] n3327_o;
  wire [7:0] n3328_o;
  wire [7:0] n3329_o;
  reg [7:0] n3330_o;
  wire [7:0] n3331_o;
  wire [7:0] n3332_o;
  wire [7:0] n3333_o;
  wire [7:0] n3334_o;
  wire [7:0] n3335_o;
  wire [7:0] n3336_o;
  wire [7:0] n3337_o;
  reg [7:0] n3338_o;
  wire [15:0] n3348_o;
  wire n3357_o;
  wire n3358_o;
  wire n3359_o;
  wire n3364_o;
  wire n3365_o;
  wire n3366_o;
  wire n3367_o;
  wire n3368_o;
  wire n3369_o;
  wire n3370_o;
  wire n3371_o;
  wire n3372_o;
  wire n3373_o;
  wire n3374_o;
  wire n3375_o;
  wire n3376_o;
  wire n3378_o;
  wire [7:0] n3424_o;
  wire [8:0] n3425_o;
  wire n3426_o;
  wire [8:0] n3427_o;
  wire [8:0] n3428_o;
  wire [8:0] n3429_o;
  wire [7:0] n3430_o;
  wire [8:0] n3432_o;
  wire n3436_o;
  wire n3439_o;
  wire n3446_o;
  wire n3447_o;
  wire n3450_o;
  wire n3452_o;
  wire n3454_o;
  wire n3455_o;
  wire [4:0] n3458_o;
  wire n3460_o;
  wire [2:0] n3461_o;
  wire n3464_o;
  wire n3467_o;
  wire n3470_o;
  wire n3473_o;
  wire n3476_o;
  wire n3479_o;
  wire n3482_o;
  wire [6:0] n3483_o;
  wire n3484_o;
  wire n3485_o;
  wire n3486_o;
  wire n3487_o;
  wire n3488_o;
  wire n3489_o;
  wire n3490_o;
  reg n3491_o;
  wire n3492_o;
  wire n3493_o;
  wire n3494_o;
  wire n3495_o;
  wire n3496_o;
  wire n3497_o;
  wire n3498_o;
  reg n3499_o;
  wire n3500_o;
  wire n3501_o;
  wire n3502_o;
  wire n3503_o;
  wire n3504_o;
  wire n3505_o;
  wire n3506_o;
  reg n3507_o;
  wire n3508_o;
  wire n3509_o;
  wire n3510_o;
  wire n3511_o;
  wire n3512_o;
  wire n3513_o;
  wire n3514_o;
  reg n3515_o;
  wire [1:0] n3516_o;
  wire n3517_o;
  wire n3518_o;
  wire n3519_o;
  wire n3520_o;
  wire n3521_o;
  wire n3522_o;
  wire n3523_o;
  wire n3524_o;
  wire n3533_o;
  wire n3534_o;
  wire n3535_o;
  wire n3536_o;
  wire n3537_o;
  wire n3538_o;
  wire n3539_o;
  wire n3540_o;
  wire n3555_o;
  wire n3556_o;
  wire n3557_o;
  wire n3558_o;
  wire n3559_o;
  wire n3560_o;
  wire n3561_o;
  wire n3562_o;
  wire n3563_o;
  wire n3564_o;
  wire n3565_o;
  wire n3566_o;
  wire n3567_o;
  wire n3568_o;
  wire n3585_o;
  wire n3587_o;
  wire n3588_o;
  wire n3589_o;
  wire n3590_o;
  wire n3592_o;
  wire n3593_o;
  wire n3594_o;
  wire n3595_o;
  wire n3596_o;
  wire n3597_o;
  wire n3598_o;
  wire n3599_o;
  wire n3600_o;
  wire n3601_o;
  wire n3602_o;
  wire n3603_o;
  wire n3604_o;
  wire n3605_o;
  wire n3606_o;
  wire n3607_o;
  wire n3608_o;
  wire n3609_o;
  wire n3610_o;
  wire [1:0] n3613_o;
  wire [1:0] n3614_o;
  wire [1:0] n3615_o;
  wire [7:0] n3617_o;
  wire n3619_o;
  wire n3621_o;
  wire n3623_o;
  wire [4:0] n3627_o;
  wire n3629_o;
  wire n3631_o;
  wire n3632_o;
  wire n3633_o;
  wire n3634_o;
  wire [4:0] n3636_o;
  wire n3638_o;
  wire n3640_o;
  wire n3641_o;
  wire n3644_o;
  wire n3646_o;
  wire n3648_o;
  wire n3649_o;
  wire n3650_o;
  wire n3651_o;
  wire n3653_o;
  wire n3654_o;
  wire n3656_o;
  wire n3657_o;
  wire n3658_o;
  wire n3659_o;
  wire n3660_o;
  wire n3661_o;
  wire n3662_o;
  wire [5:0] n3663_o;
  wire [5:0] n3664_o;
  wire [5:0] n3665_o;
  wire [7:0] n3672_o;
  wire n3696_o;
  wire n3699_o;
  wire n3701_o;
  wire n3702_o;
  wire [7:0] n3704_o;
  wire [7:0] n3707_o;
  wire [8:0] n3709_o;
  wire n3711_o;
  wire [7:0] n3712_o;
  wire [8:0] n3713_o;
  wire [8:0] n3714_o;
  wire [8:0] n3715_o;
  wire n3717_o;
  wire n3718_o;
  wire [7:0] n3720_o;
  wire n3722_o;
  wire [7:0] n3724_o;
  wire [7:0] n3725_o;
  wire n3727_o;
  wire n3729_o;
  wire [2:0] n3730_o;
  reg [7:0] n3731_o;
  wire [7:0] n3732_o;
  wire n3734_o;
  wire [2:0] n3735_o;
  reg [7:0] n3736_o;
  reg [7:0] n3737_o;
  reg [8:0] n3738_o;
  wire [7:0] n3739_o;
  wire [7:0] n3740_o;
  wire [7:0] n3741_o;
  wire [7:0] n3742_o;
  wire [7:0] n3743_o;
  wire [7:0] n3744_o;
  wire n3746_o;
  localparam [2:0] n3747_o = 3'b100;
  wire n3749_o;
  wire n3750_o;
  wire n3751_o;
  wire n3752_o;
  localparam [2:0] n3753_o = 3'b010;
  wire n3755_o;
  wire n3758_o;
  localparam [2:0] n3759_o = 3'b110;
  wire n3762_o;
  localparam [8:0] n3764_o = 9'b111111111;
  wire [5:0] n3765_o;
  wire n3767_o;
  wire n3769_o;
  wire n3771_o;
  wire n3772_o;
  wire n3773_o;
  wire n3774_o;
  wire n3775_o;
  wire n3776_o;
  wire [1:0] n3777_o;
  wire [1:0] n3778_o;
  wire [1:0] n3779_o;
  wire [1:0] n3780_o;
  wire [1:0] n3781_o;
  wire [7:0] n3783_o;
  wire [8:0] n3784_o;
  wire n3787_o;
  wire [7:0] n3789_o;
  wire [7:0] n3790_o;
  wire [7:0] n3791_o;
  wire [7:0] n3792_o;
  wire [7:0] n3793_o;
  wire [7:0] n3794_o;
  wire [7:0] n3795_o;
  wire n3796_o;
  wire n3797_o;
  wire n3798_o;
  wire [7:0] n3799_o;
  wire [8:0] n3803_o;
  wire n3807_o;
  wire n3809_o;
  wire n3810_o;
  wire n3811_o;
  wire n3812_o;
  wire n3813_o;
  wire n3814_o;
  wire n3815_o;
  wire n3816_o;
  wire n3841_o;
  wire n3842_o;
  wire n3843_o;
  wire n3844_o;
  wire n3845_o;
  wire n3846_o;
  wire n3847_o;
  wire n3849_o;
  wire [7:0] n3850_o;
  wire n3852_o;
  wire [7:0] n3853_o;
  wire n3855_o;
  wire [7:0] n3856_o;
  wire n3858_o;
  wire [7:0] n3859_o;
  wire n3861_o;
  wire n3863_o;
  wire [7:0] n3864_o;
  wire [7:0] n3865_o;
  wire n3867_o;
  wire [7:0] n3868_o;
  wire [7:0] n3870_o;
  wire [7:0] n3871_o;
  wire n3873_o;
  wire [7:0] n3874_o;
  wire [7:0] n3876_o;
  wire [7:0] n3877_o;
  wire [7:0] n3878_o;
  wire [7:0] n3879_o;
  wire n3881_o;
  wire [7:0] n3882_o;
  wire [7:0] n3883_o;
  wire [7:0] n3884_o;
  wire n3886_o;
  wire n3889_o;
  wire [10:0] n3890_o;
  reg [7:0] n3892_o;
  wire [7:0] n3893_o;
  wire [23:0] n3895_o;
  wire n3897_o;
  wire [15:0] n3899_o;
  wire [23:0] n3900_o;
  wire n3902_o;
  wire [15:0] n3904_o;
  wire [7:0] n3905_o;
  wire [23:0] n3906_o;
  wire n3908_o;
  wire [7:0] n3909_o;
  wire [15:0] n3910_o;
  wire [7:0] n3911_o;
  wire [23:0] n3912_o;
  wire n3914_o;
  wire [3:0] n3915_o;
  reg [23:0] n3917_o;
  wire [7:0] n3919_o;
  wire n3920_o;
  wire [7:0] n3921_o;
  wire n3923_o;
  wire [7:0] n3924_o;
  wire n3926_o;
  wire [7:0] n3927_o;
  wire n3929_o;
  wire [7:0] n3930_o;
  wire n3932_o;
  wire [7:0] n3933_o;
  wire n3935_o;
  wire n3937_o;
  wire [7:0] n3938_o;
  wire n3940_o;
  wire [7:0] n3941_o;
  wire n3943_o;
  wire [7:0] n3944_o;
  wire [7:0] n3945_o;
  wire [7:0] n3946_o;
  wire n3948_o;
  wire [7:0] n3949_o;
  wire [7:0] n3950_o;
  wire [7:0] n3951_o;
  wire [7:0] n3952_o;
  wire n3954_o;
  wire [7:0] n3955_o;
  wire [7:0] n3956_o;
  wire n3958_o;
  wire [7:0] n3959_o;
  wire [7:0] n3960_o;
  wire n3962_o;
  wire n3965_o;
  wire [12:0] n3966_o;
  reg [7:0] n3968_o;
  wire n3971_o;
  wire n3973_o;
  wire n3974_o;
  wire n3976_o;
  wire n3977_o;
  wire n3978_o;
  wire n3979_o;
  wire n3980_o;
  wire n3981_o;
  wire n3984_o;
  wire n3986_o;
  wire n3990_o;
  wire n3993_o;
  wire [2:0] n3995_o;
  wire [2:0] n3997_o;
  wire n4002_o;
  wire n4004_o;
  wire n4005_o;
  wire n4006_o;
  wire n4007_o;
  wire n4008_o;
  wire [4:0] n4009_o;
  wire n4011_o;
  wire n4013_o;
  wire n4014_o;
  wire n4015_o;
  wire n4016_o;
  wire n4018_o;
  wire n4020_o;
  wire n4021_o;
  wire n4022_o;
  wire n4023_o;
  wire n4024_o;
  wire n4042_o;
  wire n4043_o;
  wire [7:0] n4044_o;
  wire [7:0] n4045_o;
  reg [7:0] n4046_q;
  wire [15:0] n4048_o;
  wire n4049_o;
  wire n4050_o;
  wire [7:0] n4051_o;
  wire [7:0] n4052_o;
  reg [7:0] n4053_q;
  wire [15:0] n4055_o;
  wire n4056_o;
  wire n4057_o;
  wire [7:0] n4058_o;
  wire [7:0] n4059_o;
  reg [7:0] n4060_q;
  wire [15:0] n4062_o;
  reg [7:0] n4063_q;
  wire [7:0] n4064_o;
  reg [7:0] n4065_q;
  wire [7:0] n4066_o;
  reg [7:0] n4067_q;
  wire [7:0] n4068_o;
  reg [7:0] n4069_q;
  wire [8:0] n4070_o;
  reg [8:0] n4071_q;
  wire [7:0] n4072_o;
  reg [7:0] n4073_q;
  wire [7:0] n4074_o;
  reg [7:0] n4075_q;
  wire [15:0] n4076_o;
  reg [15:0] n4077_q;
  wire [15:0] n4078_o;
  reg [15:0] n4079_q;
  wire n4080_o;
  reg n4081_q;
  wire n4082_o;
  reg n4083_q;
  wire n4084_o;
  reg n4085_q;
  wire [7:0] n4086_o;
  reg [7:0] n4087_q;
  wire [2:0] n4088_o;
  reg [2:0] n4089_q;
  wire [1:0] n4090_o;
  reg [1:0] n4091_q;
  wire n4092_o;
  reg n4093_q;
  wire [4:0] n4094_o;
  reg [4:0] n4095_q;
  wire [3:0] n4096_o;
  reg [3:0] n4097_q;
  wire [1:0] n4098_o;
  reg [1:0] n4099_q;
  wire n4100_o;
  reg n4101_q;
  wire n4102_o;
  reg n4103_q;
  wire n4104_o;
  reg n4105_q;
  wire n4106_o;
  wire n4107_o;
  reg n4108_q;
  wire n4109_o;
  wire n4110_o;
  wire n4111_o;
  reg n4112_q;
  wire n4113_o;
  wire n4114_o;
  wire n4115_o;
  reg n4116_q;
  wire n4117_o;
  reg n4118_q;
  wire [7:0] n4119_o;
  reg [7:0] n4120_q;
  wire [7:0] n4121_o;
  reg [7:0] n4122_q;
  wire [7:0] n4123_o;
  reg [7:0] n4124_q;
  reg n4125_q;
  reg n4126_q;
  wire n4127_o;
  wire n4128_o;
  wire n4129_o;
  reg n4130_q;
  wire n4131_o;
  reg n4132_q;
  wire n4133_o;
  wire n4134_o;
  wire n4135_o;
  reg n4136_q;
  wire [47:0] n4137_o;
  assign r_w_n = wrn_i;
  assign sync = n3138_o;
  assign ef = ef_i;
  assign mf = mf_i;
  assign xf = xf_i;
  assign ml_n = n3152_o;
  assign vp_n = n3161_o;
  assign vda = n3166_o;
  assign vpa = n3171_o;
  assign a = n3917_o;
  assign do = do_r;
  assign regs = n3184_o;
  assign debug_i = n3123_o;
  assign debug_a = n3124_o;
  assign debug_x = n3125_o;
  assign debug_y = n3126_o;
  assign debug_s = n3127_o;
  assign debug_p = n3128_o;
  assign nmi_ack = nmiact;
  /* ./TIA/TIA.vhd:616:10  */
  assign n3123_o = n4137_o[7:0];
  /* ./TIA/TIA.vhd:615:10  */
  assign n3124_o = n4137_o[15:8];
  /* ./TIA/TIA.vhd:614:10  */
  assign n3125_o = n4137_o[23:16];
  /* ./TIA/TIA.vhd:613:10  */
  assign n3126_o = n4137_o[31:24];
  /* ./TIA/TIA.vhd:612:10  */
  assign n3127_o = n4137_o[39:32];
  /* ./TIA/TIA.vhd:611:10  */
  assign n3128_o = n4137_o[47:40];
  /* ./T65/T65.vhd:169:10  */
  assign abc = n4048_o; // (signal)
  /* ./T65/T65.vhd:169:15  */
  assign x = n4055_o; // (signal)
  /* ./T65/T65.vhd:169:18  */
  assign y = n4062_o; // (signal)
  /* ./T65/T65.vhd:170:10  */
  always @*
    p = n4063_q; // (isignal)
  initial
    p = 8'b00000000;
  /* ./T65/T65.vhd:170:13  */
  always @*
    ad = n4065_q; // (isignal)
  initial
    ad = 8'b00000000;
  /* ./T65/T65.vhd:170:17  */
  always @*
    dl = n4067_q; // (isignal)
  initial
    dl = 8'b00000000;
  /* ./T65/T65.vhd:171:10  */
  assign pwithb = n3921_o; // (signal)
  /* ./T65/T65.vhd:172:10  */
  assign bah = n4069_q; // (signal)
  /* ./T65/T65.vhd:173:10  */
  assign bal = n4071_q; // (signal)
  /* ./T65/T65.vhd:174:10  */
  assign pbr = n4073_q; // (signal)
  /* ./T65/T65.vhd:175:10  */
  assign dbr = n4075_q; // (signal)
  /* ./T65/T65.vhd:176:10  */
  assign pc = n4077_q; // (signal)
  /* ./T65/T65.vhd:177:10  */
  assign s = n4079_q; // (signal)
  /* ./T65/T65.vhd:178:10  */
  assign ef_i = n4081_q; // (signal)
  /* ./T65/T65.vhd:179:10  */
  assign mf_i = n4083_q; // (signal)
  /* ./T65/T65.vhd:180:10  */
  assign xf_i = n4085_q; // (signal)
  /* ./T65/T65.vhd:182:10  */
  assign ir = n4087_q; // (signal)
  /* ./T65/T65.vhd:183:10  */
  assign mcycle = n4089_q; // (signal)
  /* ./T65/T65.vhd:185:10  */
  assign do_r = n3968_o; // (signal)
  /* ./T65/T65.vhd:187:10  */
  assign mode_r = n4091_q; // (signal)
  /* ./T65/T65.vhd:188:10  */
  assign bcd_en_r = n4093_q; // (signal)
  /* ./T65/T65.vhd:189:10  */
  assign alu_op_r = n4095_q; // (signal)
  /* ./T65/T65.vhd:190:10  */
  assign write_data_r = n4097_q; // (signal)
  /* ./T65/T65.vhd:191:10  */
  assign set_addr_to_r = n4099_q; // (signal)
  /* ./T65/T65.vhd:192:10  */
  assign pcadder = n3429_o; // (signal)
  /* ./T65/T65.vhd:194:10  */
  assign rstcycle = n4101_q; // (signal)
  /* ./T65/T65.vhd:195:10  */
  assign irqcycle = n4103_q; // (signal)
  /* ./T65/T65.vhd:196:10  */
  assign nmicycle = n4105_q; // (signal)
  /* ./T65/T65.vhd:198:10  */
  assign so_n_o = n4108_q; // (signal)
  /* ./T65/T65.vhd:199:10  */
  assign irq_n_o = n4112_q; // (signal)
  /* ./T65/T65.vhd:200:10  */
  assign nmi_n_o = n4116_q; // (signal)
  /* ./T65/T65.vhd:201:10  */
  assign nmiact = n4118_q; // (signal)
  /* ./T65/T65.vhd:203:10  */
  assign break = n3847_o; // (signal)
  /* ./T65/T65.vhd:206:10  */
  assign busa = n3892_o; // (signal)
  /* ./T65/T65.vhd:207:10  */
  assign busa_r = n4120_q; // (signal)
  /* ./T65/T65.vhd:208:10  */
  assign busb = n4122_q; // (signal)
  /* ./T65/T65.vhd:209:10  */
  assign busb_r = n4124_q; // (signal)
  /* ./T65/T65.vhd:210:10  */
  /* ./T65/T65.vhd:211:10  */
  assign p_out = alu_p_out; // (signal)
  /* ./T65/T65.vhd:214:10  */
  assign lcycle = mcode_lcycle; // (signal)
  /* ./T65/T65.vhd:215:10  */
  assign alu_op = mcode_alu_op; // (signal)
  /* ./T65/T65.vhd:216:10  */
  assign set_busa_to = mcode_set_busa_to; // (signal)
  /* ./T65/T65.vhd:217:10  */
  assign set_addr_to = mcode_set_addr_to; // (signal)
  /* ./T65/T65.vhd:218:10  */
  assign write_data = mcode_write_data; // (signal)
  /* ./T65/T65.vhd:219:10  */
  assign jump = mcode_jump; // (signal)
  /* ./T65/T65.vhd:220:10  */
  assign baadd = mcode_baadd; // (signal)
  /* ./T65/T65.vhd:221:10  */
  assign baquirk = mcode_baquirk; // (signal)
  /* ./T65/T65.vhd:222:10  */
  assign breakatna = mcode_breakatna; // (signal)
  /* ./T65/T65.vhd:223:10  */
  assign adadd = mcode_adadd; // (signal)
  /* ./T65/T65.vhd:224:10  */
  assign addy = mcode_addy; // (signal)
  /* ./T65/T65.vhd:225:10  */
  assign pcadd = mcode_pcadd; // (signal)
  /* ./T65/T65.vhd:226:10  */
  assign inc_s = mcode_inc_s; // (signal)
  /* ./T65/T65.vhd:227:10  */
  assign dec_s = mcode_dec_s; // (signal)
  /* ./T65/T65.vhd:228:10  */
  assign lda = mcode_lda; // (signal)
  /* ./T65/T65.vhd:229:10  */
  assign ldp = mcode_ldp; // (signal)
  /* ./T65/T65.vhd:230:10  */
  assign ldx = mcode_ldx; // (signal)
  /* ./T65/T65.vhd:231:10  */
  assign ldy = mcode_ldy; // (signal)
  /* ./T65/T65.vhd:232:10  */
  assign lds = mcode_lds; // (signal)
  /* ./T65/T65.vhd:233:10  */
  assign lddi = mcode_lddi; // (signal)
  /* ./T65/T65.vhd:234:10  */
  assign ldalu = mcode_ldalu; // (signal)
  /* ./T65/T65.vhd:235:10  */
  assign ldad = mcode_ldad; // (signal)
  /* ./T65/T65.vhd:236:10  */
  assign ldbal = mcode_ldbal; // (signal)
  /* ./T65/T65.vhd:237:10  */
  assign ldbah = mcode_ldbah; // (signal)
  /* ./T65/T65.vhd:238:10  */
  assign savep = mcode_savep; // (signal)
  /* ./T65/T65.vhd:239:10  */
  assign write = mcode_write; // (signal)
  /* ./T65/T65.vhd:241:10  */
  assign res_n_i = n4125_q; // (signal)
  /* ./T65/T65.vhd:242:10  */
  assign res_n_d = n4126_q; // (signal)
  /* ./T65/T65.vhd:244:10  */
  assign rdy_mod = n4130_q; // (signal)
  /* ./T65/T65.vhd:245:10  */
  assign really_rdy = n3134_o; // (signal)
  /* ./T65/T65.vhd:246:10  */
  assign wrn_i = n4132_q; // (signal)
  /* ./T65/T65.vhd:248:10  */
  assign nmi_entered = n4136_q; // (signal)
  /* ./T65/T65.vhd:254:24  */
  assign n3133_o = ~wrn_i;
  /* ./T65/T65.vhd:254:21  */
  assign n3134_o = rdy | n3133_o;
  /* ./T65/T65.vhd:255:27  */
  assign n3137_o = mcycle == 3'b000;
  /* ./T65/T65.vhd:255:15  */
  assign n3138_o = n3137_o ? 1'b1 : 1'b0;
  /* ./T65/T65.vhd:260:22  */
  assign n3141_o = ir[7:6];
  /* ./T65/T65.vhd:260:35  */
  assign n3143_o = n3141_o != 2'b10;
  /* ./T65/T65.vhd:260:49  */
  assign n3144_o = ir[2:1];
  /* ./T65/T65.vhd:260:62  */
  assign n3146_o = n3144_o == 2'b11;
  /* ./T65/T65.vhd:260:43  */
  assign n3147_o = n3146_o & n3143_o;
  /* ./T65/T65.vhd:260:79  */
  assign n3148_o = mcycle[2:1];
  /* ./T65/T65.vhd:260:92  */
  assign n3150_o = n3148_o != 2'b00;
  /* ./T65/T65.vhd:260:69  */
  assign n3151_o = n3150_o & n3147_o;
  /* ./T65/T65.vhd:260:15  */
  assign n3152_o = n3151_o ? 1'b0 : 1'b1;
  /* ./T65/T65.vhd:261:47  */
  assign n3156_o = mcycle == 3'b101;
  /* ./T65/T65.vhd:261:65  */
  assign n3158_o = mcycle == 3'b110;
  /* ./T65/T65.vhd:261:55  */
  assign n3159_o = n3156_o | n3158_o;
  /* ./T65/T65.vhd:261:35  */
  assign n3160_o = n3159_o & irqcycle;
  /* ./T65/T65.vhd:261:15  */
  assign n3161_o = n3160_o ? 1'b0 : 1'b1;
  /* ./T65/T65.vhd:262:33  */
  assign n3165_o = set_addr_to_r != 2'b00;
  /* ./T65/T65.vhd:262:14  */
  assign n3166_o = n3165_o ? 1'b1 : 1'b0;
  /* ./T65/T65.vhd:263:23  */
  assign n3169_o = jump[1];
  /* ./T65/T65.vhd:263:27  */
  assign n3170_o = ~n3169_o;
  /* ./T65/T65.vhd:263:14  */
  assign n3171_o = n3170_o ? 1'b1 : 1'b0;
  /* ./T65/T65.vhd:267:17  */
  assign n3173_o = abc[7:0];
  /* ./T65/T65.vhd:268:15  */
  assign n3174_o = x[7:0];
  /* ./T65/T65.vhd:269:15  */
  assign n3175_o = y[7:0];
  /* ./T65/T65.vhd:270:32  */
  assign n3176_o = s[7:0];
  /* ./T65/T65.vhd:273:32  */
  assign n3177_o = {pc, s};
  /* ./T65/T65.vhd:273:53  */
  assign n3178_o = {n3177_o, p};
  /* ./T65/T65.vhd:273:60  */
  assign n3179_o = y[7:0];
  /* ./T65/T65.vhd:273:57  */
  assign n3180_o = {n3178_o, n3179_o};
  /* ./T65/T65.vhd:273:76  */
  assign n3181_o = x[7:0];
  /* ./T65/T65.vhd:273:73  */
  assign n3182_o = {n3180_o, n3181_o};
  /* ./T65/T65.vhd:273:94  */
  assign n3183_o = abc[7:0];
  /* ./T65/T65.vhd:273:89  */
  assign n3184_o = {n3182_o, n3183_o};
  /* ./T65/T65.vhd:275:3  */
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
  /* ./T65/T65.vhd:312:3  */
  t65_alu alu (
    .mode(mode_r),
    .bcd_en(bcd_en_r),
    .op(alu_op_r),
    .busa(busa_r),
    .busb(busb),
    .p_in(p),
    .p_out(alu_p_out),
    .q(alu_q));
  /* ./T65/T65.vhd:328:14  */
  assign n3215_o = ~res_n;
  /* ./T65/T65.vhd:339:16  */
  assign n3227_o = ~res_n_i;
  /* ./T65/T65.vhd:360:20  */
  assign n3230_o = mcycle == 3'b000;
  /* ./T65/T65.vhd:362:24  */
  assign n3232_o = mcycle == 3'b011;
  /* ./T65/T65.vhd:362:39  */
  assign n3234_o = ir != 8'b10010011;
  /* ./T65/T65.vhd:362:32  */
  assign n3235_o = n3234_o & n3232_o;
  /* ./T65/T65.vhd:362:60  */
  assign n3237_o = mcycle == 3'b100;
  /* ./T65/T65.vhd:362:75  */
  assign n3239_o = ir == 8'b10010011;
  /* ./T65/T65.vhd:362:68  */
  assign n3240_o = n3239_o & n3237_o;
  /* ./T65/T65.vhd:362:49  */
  assign n3241_o = n3235_o | n3240_o;
  /* ./T65/T65.vhd:362:93  */
  assign n3242_o = ~rdy;
  /* ./T65/T65.vhd:362:85  */
  assign n3243_o = n3242_o & n3241_o;
  /* ./T65/T65.vhd:362:9  */
  assign n3245_o = n3243_o ? 1'b1 : rdy_mod;
  /* ./T65/T65.vhd:360:9  */
  assign n3247_o = n3230_o ? 1'b0 : n3245_o;
  /* ./T65/T65.vhd:367:20  */
  assign n3248_o = ~write;
  /* ./T65/T65.vhd:367:30  */
  assign n3249_o = n3248_o | rstcycle;
  /* ./T65/T65.vhd:375:22  */
  assign n3251_o = mcycle == 3'b000;
  /* ./T65/T65.vhd:379:25  */
  assign n3252_o = ~irqcycle;
  /* ./T65/T65.vhd:379:44  */
  assign n3253_o = ~nmicycle;
  /* ./T65/T65.vhd:379:31  */
  assign n3254_o = n3253_o & n3252_o;
  /* ./T65/T65.vhd:380:24  */
  assign n3256_o = pc + 16'b0000000000000001;
  /* ./T65/T65.vhd:383:31  */
  assign n3258_o = irqcycle | nmicycle;
  /* ./T65/T65.vhd:383:13  */
  assign n3260_o = n3258_o ? 8'b00000000 : di;
  assign n3261_o = s[7:0];
  /* ./T65/T65.vhd:375:11  */
  assign n3262_o = n3265_o ? alu_q : n3261_o;
  /* ./T65/T65.vhd:375:11  */
  assign n3263_o = n3254_o & n3251_o;
  /* ./T65/T65.vhd:375:11  */
  assign n3265_o = lds & n3251_o;
  /* ./T65/T65.vhd:396:11  */
  assign n3270_o = break ? 2'b00 : set_addr_to;
  /* ./T65/T65.vhd:403:20  */
  assign n3272_o = s + 16'b0000000000000001;
  assign n3273_o = s[15:8];
  assign n3274_o = {n3273_o, n3262_o};
  /* ./T65/T65.vhd:402:11  */
  assign n3275_o = inc_s ? n3272_o : n3274_o;
  /* ./T65/T65.vhd:405:40  */
  assign n3276_o = ~rstcycle;
  /* ./T65/T65.vhd:405:54  */
  assign n3278_o = mode == 2'b00;
  /* ./T65/T65.vhd:405:46  */
  assign n3279_o = n3276_o | n3278_o;
  /* ./T65/T65.vhd:405:26  */
  assign n3280_o = n3279_o & dec_s;
  /* ./T65/T65.vhd:406:20  */
  assign n3282_o = s - 16'b0000000000000001;
  /* ./T65/T65.vhd:405:11  */
  assign n3283_o = n3280_o ? n3282_o : n3275_o;
  /* ./T65/T65.vhd:409:17  */
  assign n3285_o = ir == 8'b00000000;
  /* ./T65/T65.vhd:409:41  */
  assign n3287_o = mcycle == 3'b001;
  /* ./T65/T65.vhd:409:30  */
  assign n3288_o = n3287_o & n3285_o;
  /* ./T65/T65.vhd:409:62  */
  assign n3289_o = ~irqcycle;
  /* ./T65/T65.vhd:409:49  */
  assign n3290_o = n3289_o & n3288_o;
  /* ./T65/T65.vhd:409:81  */
  assign n3291_o = ~nmicycle;
  /* ./T65/T65.vhd:409:68  */
  assign n3292_o = n3291_o & n3290_o;
  /* ./T65/T65.vhd:410:22  */
  assign n3294_o = pc + 16'b0000000000000001;
  /* ./T65/T65.vhd:417:24  */
  assign n3297_o = pc + 16'b0000000000000001;
  /* ./T65/T65.vhd:416:13  */
  assign n3299_o = jump == 2'b01;
  /* ./T65/T65.vhd:419:33  */
  assign n3300_o = {di, dl};
  /* ./T65/T65.vhd:418:13  */
  assign n3302_o = jump == 2'b10;
  /* ./T65/T65.vhd:421:25  */
  assign n3303_o = pcadder[8];
  /* ./T65/T65.vhd:422:22  */
  assign n3304_o = dl[7];
  /* ./T65/T65.vhd:422:26  */
  assign n3305_o = ~n3304_o;
  /* ./T65/T65.vhd:423:40  */
  assign n3306_o = pc[15:8];
  /* ./T65/T65.vhd:423:54  */
  assign n3308_o = n3306_o + 8'b00000001;
  /* ./T65/T65.vhd:425:40  */
  assign n3309_o = pc[15:8];
  /* ./T65/T65.vhd:425:54  */
  assign n3311_o = n3309_o - 8'b00000001;
  /* ./T65/T65.vhd:422:17  */
  assign n3312_o = n3305_o ? n3308_o : n3311_o;
  assign n3313_o = n3294_o[15:8];
  assign n3314_o = n3256_o[15:8];
  assign n3315_o = pc[15:8];
  /* ./T65/T65.vhd:375:11  */
  assign n3316_o = n3263_o ? n3314_o : n3315_o;
  /* ./T65/T65.vhd:409:11  */
  assign n3317_o = n3292_o ? n3313_o : n3316_o;
  /* ./T65/T65.vhd:421:15  */
  assign n3318_o = n3303_o ? n3312_o : n3317_o;
  /* ./T65/T65.vhd:428:40  */
  assign n3319_o = pcadder[7:0];
  /* ./T65/T65.vhd:420:13  */
  assign n3321_o = jump == 2'b11;
  assign n3322_o = {n3321_o, n3302_o, n3299_o};
  assign n3323_o = n3297_o[7:0];
  assign n3324_o = n3300_o[7:0];
  assign n3325_o = n3294_o[7:0];
  assign n3326_o = n3256_o[7:0];
  assign n3327_o = pc[7:0];
  /* ./T65/T65.vhd:375:11  */
  assign n3328_o = n3263_o ? n3326_o : n3327_o;
  /* ./T65/T65.vhd:409:11  */
  assign n3329_o = n3292_o ? n3325_o : n3328_o;
  /* ./T65/T65.vhd:415:11  */
  always @*
    case (n3322_o)
      3'b100: n3330_o = n3319_o;
      3'b010: n3330_o = n3324_o;
      3'b001: n3330_o = n3323_o;
      default: n3330_o = n3329_o;
    endcase
  assign n3331_o = n3297_o[15:8];
  assign n3332_o = n3300_o[15:8];
  assign n3333_o = n3294_o[15:8];
  assign n3334_o = n3256_o[15:8];
  assign n3335_o = pc[15:8];
  /* ./T65/T65.vhd:375:11  */
  assign n3336_o = n3263_o ? n3334_o : n3335_o;
  /* ./T65/T65.vhd:409:11  */
  assign n3337_o = n3292_o ? n3333_o : n3336_o;
  /* ./T65/T65.vhd:415:11  */
  always @*
    case (n3322_o)
      3'b100: n3338_o = n3318_o;
      3'b010: n3338_o = n3332_o;
      3'b001: n3338_o = n3331_o;
      default: n3338_o = n3337_o;
    endcase
  assign n3348_o = {n3338_o, n3330_o};
  /* ./T65/T65.vhd:366:9  */
  assign n3357_o = n3251_o & really_rdy;
  /* ./T65/T65.vhd:366:9  */
  assign n3358_o = n3251_o & really_rdy;
  /* ./T65/T65.vhd:366:9  */
  assign n3359_o = n3251_o & really_rdy;
  /* ./T65/T65.vhd:358:7  */
  assign n3364_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3365_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3366_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3367_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3368_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3369_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3370_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3371_o = n3357_o & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3372_o = n3358_o & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3373_o = n3359_o & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3374_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3375_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3376_o = really_rdy & enable;
  /* ./T65/T65.vhd:358:7  */
  assign n3378_o = really_rdy & enable;
  /* ./T65/T65.vhd:436:23  */
  assign n3424_o = pc[7:0];
  /* ./T65/T65.vhd:436:14  */
  assign n3425_o = {1'b0, n3424_o};  //  uext
  /* ./T65/T65.vhd:436:59  */
  assign n3426_o = dl[7];
  /* ./T65/T65.vhd:436:63  */
  assign n3427_o = {n3426_o, dl};
  /* ./T65/T65.vhd:436:39  */
  assign n3428_o = n3425_o + n3427_o;
  /* ./T65/T65.vhd:436:72  */
  assign n3429_o = pcadd ? n3428_o : n3432_o;
  /* ./T65/T65.vhd:437:23  */
  assign n3430_o = pc[7:0];
  /* ./T65/T65.vhd:437:19  */
  assign n3432_o = {1'b0, n3430_o};
  /* ./T65/T65.vhd:442:16  */
  assign n3436_o = ~res_n_i;
  /* ./T65/T65.vhd:448:21  */
  assign n3439_o = mcycle == 3'b000;
  /* ./T65/T65.vhd:458:21  */
  assign n3446_o = lda | ldx;
  /* ./T65/T65.vhd:458:28  */
  assign n3447_o = n3446_o | ldy;
  /* ./T65/T65.vhd:448:11  */
  assign n3450_o = lda & n3439_o;
  /* ./T65/T65.vhd:448:11  */
  assign n3452_o = ldx & n3439_o;
  /* ./T65/T65.vhd:448:11  */
  assign n3454_o = ldy & n3439_o;
  /* ./T65/T65.vhd:448:11  */
  assign n3455_o = n3447_o & n3439_o;
  /* ./T65/T65.vhd:468:16  */
  assign n3458_o = ir[4:0];
  /* ./T65/T65.vhd:468:29  */
  assign n3460_o = n3458_o == 5'b11000;
  /* ./T65/T65.vhd:469:20  */
  assign n3461_o = ir[7:5];
  /* ./T65/T65.vhd:470:13  */
  assign n3464_o = n3461_o == 3'b000;
  /* ./T65/T65.vhd:472:13  */
  assign n3467_o = n3461_o == 3'b001;
  /* ./T65/T65.vhd:474:13  */
  assign n3470_o = n3461_o == 3'b010;
  /* ./T65/T65.vhd:476:13  */
  assign n3473_o = n3461_o == 3'b011;
  /* ./T65/T65.vhd:478:13  */
  assign n3476_o = n3461_o == 3'b101;
  /* ./T65/T65.vhd:480:13  */
  assign n3479_o = n3461_o == 3'b110;
  /* ./T65/T65.vhd:482:13  */
  assign n3482_o = n3461_o == 3'b111;
  assign n3483_o = {n3482_o, n3479_o, n3476_o, n3473_o, n3470_o, n3467_o, n3464_o};
  assign n3484_o = alu_q[0];
  assign n3485_o = p_out[0];
  assign n3486_o = p_out[0];
  assign n3487_o = p[0];
  /* ./T65/T65.vhd:448:11  */
  assign n3488_o = n3455_o ? n3486_o : n3487_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3489_o = savep ? n3485_o : n3488_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3490_o = ldp ? n3484_o : n3489_o;
  /* ./T65/T65.vhd:469:13  */
  always @*
    case (n3483_o)
      7'b1000000: n3491_o = n3490_o;
      7'b0100000: n3491_o = n3490_o;
      7'b0010000: n3491_o = n3490_o;
      7'b0001000: n3491_o = n3490_o;
      7'b0000100: n3491_o = n3490_o;
      7'b0000010: n3491_o = 1'b1;
      7'b0000001: n3491_o = 1'b0;
      default: n3491_o = n3490_o;
    endcase
  assign n3492_o = alu_q[2];
  assign n3493_o = p_out[2];
  assign n3494_o = p_out[2];
  assign n3495_o = p[2];
  /* ./T65/T65.vhd:448:11  */
  assign n3496_o = n3455_o ? n3494_o : n3495_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3497_o = savep ? n3493_o : n3496_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3498_o = ldp ? n3492_o : n3497_o;
  /* ./T65/T65.vhd:469:13  */
  always @*
    case (n3483_o)
      7'b1000000: n3499_o = n3498_o;
      7'b0100000: n3499_o = n3498_o;
      7'b0010000: n3499_o = n3498_o;
      7'b0001000: n3499_o = 1'b1;
      7'b0000100: n3499_o = 1'b0;
      7'b0000010: n3499_o = n3498_o;
      7'b0000001: n3499_o = n3498_o;
      default: n3499_o = n3498_o;
    endcase
  assign n3500_o = alu_q[3];
  assign n3501_o = p_out[3];
  assign n3502_o = p_out[3];
  assign n3503_o = p[3];
  /* ./T65/T65.vhd:448:11  */
  assign n3504_o = n3455_o ? n3502_o : n3503_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3505_o = savep ? n3501_o : n3504_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3506_o = ldp ? n3500_o : n3505_o;
  /* ./T65/T65.vhd:469:13  */
  always @*
    case (n3483_o)
      7'b1000000: n3507_o = 1'b1;
      7'b0100000: n3507_o = 1'b0;
      7'b0010000: n3507_o = n3506_o;
      7'b0001000: n3507_o = n3506_o;
      7'b0000100: n3507_o = n3506_o;
      7'b0000010: n3507_o = n3506_o;
      7'b0000001: n3507_o = n3506_o;
      default: n3507_o = n3506_o;
    endcase
  assign n3508_o = alu_q[6];
  assign n3509_o = p_out[6];
  assign n3510_o = p_out[6];
  assign n3511_o = p[6];
  /* ./T65/T65.vhd:448:11  */
  assign n3512_o = n3455_o ? n3510_o : n3511_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3513_o = savep ? n3509_o : n3512_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3514_o = ldp ? n3508_o : n3513_o;
  /* ./T65/T65.vhd:469:13  */
  always @*
    case (n3483_o)
      7'b1000000: n3515_o = n3514_o;
      7'b0100000: n3515_o = n3514_o;
      7'b0010000: n3515_o = 1'b0;
      7'b0001000: n3515_o = n3514_o;
      7'b0000100: n3515_o = n3514_o;
      7'b0000010: n3515_o = n3514_o;
      7'b0000001: n3515_o = n3514_o;
      default: n3515_o = n3514_o;
    endcase
  assign n3516_o = {n3507_o, n3499_o};
  assign n3517_o = alu_q[0];
  assign n3518_o = p_out[0];
  assign n3519_o = p_out[0];
  assign n3520_o = p[0];
  /* ./T65/T65.vhd:448:11  */
  assign n3521_o = n3455_o ? n3519_o : n3520_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3522_o = savep ? n3518_o : n3521_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3523_o = ldp ? n3517_o : n3522_o;
  /* ./T65/T65.vhd:468:11  */
  assign n3524_o = n3460_o ? n3491_o : n3523_o;
  assign n3533_o = alu_q[6];
  assign n3534_o = p_out[6];
  assign n3535_o = p_out[6];
  assign n3536_o = p[6];
  /* ./T65/T65.vhd:448:11  */
  assign n3537_o = n3455_o ? n3535_o : n3536_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3538_o = savep ? n3534_o : n3537_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3539_o = ldp ? n3533_o : n3538_o;
  /* ./T65/T65.vhd:468:11  */
  assign n3540_o = n3460_o ? n3515_o : n3539_o;
  assign n3555_o = alu_q[1];
  assign n3556_o = p_out[1];
  assign n3557_o = p_out[1];
  assign n3558_o = p[1];
  /* ./T65/T65.vhd:448:11  */
  assign n3559_o = n3455_o ? n3557_o : n3558_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3560_o = savep ? n3556_o : n3559_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3561_o = ldp ? n3555_o : n3560_o;
  assign n3562_o = alu_q[7];
  assign n3563_o = p_out[7];
  assign n3564_o = p_out[7];
  assign n3565_o = p[7];
  /* ./T65/T65.vhd:448:11  */
  assign n3566_o = n3455_o ? n3564_o : n3565_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3567_o = savep ? n3563_o : n3566_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3568_o = ldp ? n3562_o : n3567_o;
  /* ./T65/T65.vhd:488:17  */
  assign n3585_o = ir == 8'b00000000;
  /* ./T65/T65.vhd:488:41  */
  assign n3587_o = mcycle == 3'b100;
  /* ./T65/T65.vhd:488:30  */
  assign n3588_o = n3587_o & n3585_o;
  /* ./T65/T65.vhd:488:62  */
  assign n3589_o = ~rstcycle;
  /* ./T65/T65.vhd:488:49  */
  assign n3590_o = n3589_o & n3588_o;
  assign n3592_o = n3516_o[0];
  assign n3593_o = alu_q[2];
  assign n3594_o = p_out[2];
  assign n3595_o = p_out[2];
  assign n3596_o = p[2];
  /* ./T65/T65.vhd:448:11  */
  assign n3597_o = n3455_o ? n3595_o : n3596_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3598_o = savep ? n3594_o : n3597_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3599_o = ldp ? n3593_o : n3598_o;
  /* ./T65/T65.vhd:468:11  */
  assign n3600_o = n3460_o ? n3592_o : n3599_o;
  /* ./T65/T65.vhd:488:11  */
  assign n3601_o = n3590_o ? 1'b1 : n3600_o;
  assign n3602_o = n3516_o[1];
  assign n3603_o = alu_q[3];
  assign n3604_o = p_out[3];
  assign n3605_o = p_out[3];
  assign n3606_o = p[3];
  /* ./T65/T65.vhd:448:11  */
  assign n3607_o = n3455_o ? n3605_o : n3606_o;
  /* ./T65/T65.vhd:462:11  */
  assign n3608_o = savep ? n3604_o : n3607_o;
  /* ./T65/T65.vhd:465:11  */
  assign n3609_o = ldp ? n3603_o : n3608_o;
  /* ./T65/T65.vhd:468:11  */
  assign n3610_o = n3460_o ? n3602_o : n3609_o;
  assign n3613_o = {1'b0, 1'b1};
  assign n3614_o = {n3610_o, n3601_o};
  /* ./T65/T65.vhd:492:11  */
  assign n3615_o = rstcycle ? n3613_o : n3614_o;
  assign n3617_o = {n3568_o, n3540_o, 1'b1, 1'b1, n3615_o, n3561_o, n3524_o};
  /* ./T65/T65.vhd:447:9  */
  assign n3619_o = n3450_o & really_rdy;
  /* ./T65/T65.vhd:447:9  */
  assign n3621_o = n3452_o & really_rdy;
  /* ./T65/T65.vhd:447:9  */
  assign n3623_o = n3454_o & really_rdy;
  /* ./T65/T65.vhd:503:14  */
  assign n3627_o = ir[4:0];
  /* ./T65/T65.vhd:503:26  */
  assign n3629_o = n3627_o != 5'b10000;
  /* ./T65/T65.vhd:503:43  */
  assign n3631_o = jump != 2'b01;
  /* ./T65/T65.vhd:503:36  */
  assign n3632_o = n3629_o | n3631_o;
  /* ./T65/T65.vhd:503:64  */
  assign n3633_o = ~really_rdy;
  /* ./T65/T65.vhd:503:50  */
  assign n3634_o = n3632_o | n3633_o;
  /* ./T65/T65.vhd:507:14  */
  assign n3636_o = ir[4:0];
  /* ./T65/T65.vhd:507:26  */
  assign n3638_o = n3636_o != 5'b10000;
  /* ./T65/T65.vhd:507:43  */
  assign n3640_o = jump != 2'b01;
  /* ./T65/T65.vhd:507:36  */
  assign n3641_o = n3638_o | n3640_o;
  /* ./T65/T65.vhd:446:7  */
  assign n3644_o = n3619_o & enable;
  /* ./T65/T65.vhd:446:7  */
  assign n3646_o = n3621_o & enable;
  /* ./T65/T65.vhd:446:7  */
  assign n3648_o = n3623_o & enable;
  /* ./T65/T65.vhd:446:7  */
  assign n3649_o = really_rdy & enable;
  /* ./T65/T65.vhd:446:7  */
  assign n3650_o = n3634_o & enable;
  /* ./T65/T65.vhd:446:7  */
  assign n3651_o = n3641_o & enable;
  /* ./T65/T65.vhd:514:42  */
  assign n3653_o = ~so_n;
  /* ./T65/T65.vhd:514:33  */
  assign n3654_o = n3653_o & so_n_o;
  assign n3656_o = n3617_o[6];
  assign n3657_o = p[6];
  /* ./T65/T65.vhd:446:7  */
  assign n3658_o = n3649_o ? n3656_o : n3657_o;
  /* ./T65/T65.vhd:514:17  */
  assign n3659_o = n3654_o ? 1'b1 : n3658_o;
  assign n3660_o = n3617_o[7];
  assign n3661_o = p[7];
  /* ./T65/T65.vhd:446:7  */
  assign n3662_o = n3649_o ? n3660_o : n3661_o;
  assign n3663_o = n3617_o[5:0];
  assign n3664_o = p[5:0];
  /* ./T65/T65.vhd:446:7  */
  assign n3665_o = n3649_o ? n3663_o : n3664_o;
  assign n3672_o = {n3662_o, n3659_o, n3665_o};
  /* ./T65/T65.vhd:529:16  */
  assign n3696_o = ~res_n_i;
  /* ./T65/T65.vhd:545:28  */
  assign n3699_o = set_addr_to_r == 2'b00;
  /* ./T65/T65.vhd:545:63  */
  assign n3701_o = set_addr_to_r == 2'b10;
  /* ./T65/T65.vhd:545:46  */
  assign n3702_o = n3699_o | n3701_o;
  /* ./T65/T65.vhd:546:65  */
  assign n3704_o = di + 8'b00000001;
  /* ./T65/T65.vhd:552:49  */
  assign n3707_o = ad + 8'b00000001;
  /* ./T65/T65.vhd:553:51  */
  assign n3709_o = bal + 9'b000000001;
  /* ./T65/T65.vhd:550:11  */
  assign n3711_o = baadd == 2'b01;
  /* ./T65/T65.vhd:556:56  */
  assign n3712_o = bal[7:0];
  /* ./T65/T65.vhd:556:37  */
  assign n3713_o = {1'b0, n3712_o};  //  uext
  /* ./T65/T65.vhd:556:75  */
  assign n3714_o = {1'b0, busa};  //  uext
  /* ./T65/T65.vhd:556:73  */
  assign n3715_o = n3713_o + n3714_o;
  /* ./T65/T65.vhd:554:11  */
  assign n3717_o = baadd == 2'b10;
  /* ./T65/T65.vhd:559:19  */
  assign n3718_o = bal[8];
  /* ./T65/T65.vhd:562:66  */
  assign n3720_o = bah + 8'b00000001;
  /* ./T65/T65.vhd:562:15  */
  assign n3722_o = baquirk == 2'b00;
  /* ./T65/T65.vhd:563:66  */
  assign n3724_o = bah + 8'b00000001;
  /* ./T65/T65.vhd:563:71  */
  assign n3725_o = n3724_o & do_r;
  /* ./T65/T65.vhd:563:15  */
  assign n3727_o = baquirk == 2'b01;
  /* ./T65/T65.vhd:564:15  */
  assign n3729_o = baquirk == 2'b10;
  assign n3730_o = {n3729_o, n3727_o, n3722_o};
  /* ./T65/T65.vhd:561:15  */
  always @*
    case (n3730_o)
      3'b100: n3731_o = do_r;
      3'b010: n3731_o = n3725_o;
      3'b001: n3731_o = n3720_o;
      default: n3731_o = bah;
    endcase
  /* ./T65/T65.vhd:559:13  */
  assign n3732_o = n3718_o ? n3731_o : bah;
  /* ./T65/T65.vhd:557:11  */
  assign n3734_o = baadd == 2'b11;
  assign n3735_o = {n3734_o, n3717_o, n3711_o};
  /* ./T65/T65.vhd:549:11  */
  always @*
    case (n3735_o)
      3'b100: n3736_o = ad;
      3'b010: n3736_o = ad;
      3'b001: n3736_o = n3707_o;
      default: n3736_o = ad;
    endcase
  /* ./T65/T65.vhd:549:11  */
  always @*
    case (n3735_o)
      3'b100: n3737_o = n3732_o;
      3'b010: n3737_o = bah;
      3'b001: n3737_o = bah;
      default: n3737_o = bah;
    endcase
  /* ./T65/T65.vhd:549:11  */
  always @*
    case (n3735_o)
      3'b100: n3738_o = bal;
      3'b010: n3738_o = n3715_o;
      3'b001: n3738_o = n3709_o;
      default: n3738_o = bal;
    endcase
  /* ./T65/T65.vhd:574:63  */
  assign n3739_o = y[7:0];
  /* ./T65/T65.vhd:574:51  */
  assign n3740_o = ad + n3739_o;
  /* ./T65/T65.vhd:576:63  */
  assign n3741_o = x[7:0];
  /* ./T65/T65.vhd:576:51  */
  assign n3742_o = ad + n3741_o;
  /* ./T65/T65.vhd:573:13  */
  assign n3743_o = addy ? n3740_o : n3742_o;
  /* ./T65/T65.vhd:572:11  */
  assign n3744_o = adadd ? n3743_o : n3736_o;
  /* ./T65/T65.vhd:580:17  */
  assign n3746_o = ir == 8'b00000000;
  /* ./T65/T65.vhd:585:61  */
  assign n3749_o = mcycle == 3'b100;
  /* ./T65/T65.vhd:585:51  */
  assign n3750_o = n3749_o & nmiact;
  /* ./T65/T65.vhd:585:34  */
  assign n3751_o = nmicycle | n3750_o;
  /* ./T65/T65.vhd:585:69  */
  assign n3752_o = n3751_o | nmi_entered;
  /* ./T65/T65.vhd:587:24  */
  assign n3755_o = mcycle == 3'b100;
  /* ./T65/T65.vhd:587:15  */
  assign n3758_o = n3755_o ? 1'b1 : 1'b0;
  /* ./T65/T65.vhd:585:13  */
  assign n3762_o = n3752_o ? n3758_o : 1'b0;
  assign n3765_o = n3764_o[8:3];
  /* ./T65/T65.vhd:583:13  */
  assign n3767_o = rstcycle ? 1'b0 : n3762_o;
  /* ./T65/T65.vhd:593:30  */
  assign n3769_o = set_addr_to_r == 2'b11;
  assign n3771_o = n3747_o[0];
  assign n3772_o = n3753_o[0];
  assign n3773_o = n3759_o[0];
  /* ./T65/T65.vhd:585:13  */
  assign n3774_o = n3752_o ? n3772_o : n3773_o;
  /* ./T65/T65.vhd:583:13  */
  assign n3775_o = rstcycle ? n3771_o : n3774_o;
  /* ./T65/T65.vhd:593:13  */
  assign n3776_o = n3769_o ? 1'b1 : n3775_o;
  assign n3777_o = n3747_o[2:1];
  assign n3778_o = n3753_o[2:1];
  assign n3779_o = n3759_o[2:1];
  /* ./T65/T65.vhd:585:13  */
  assign n3780_o = n3752_o ? n3778_o : n3779_o;
  /* ./T65/T65.vhd:583:13  */
  assign n3781_o = rstcycle ? n3777_o : n3780_o;
  /* ./T65/T65.vhd:580:11  */
  assign n3783_o = n3746_o ? 8'b11111111 : n3737_o;
  assign n3784_o = {n3765_o, n3781_o, n3776_o};
  /* ./T65/T65.vhd:580:11  */
  assign n3787_o = n3746_o ? n3767_o : 1'b0;
  /* ./T65/T65.vhd:598:11  */
  assign n3789_o = lddi ? di : dl;
  /* ./T65/T65.vhd:601:11  */
  assign n3790_o = ldalu ? alu_q : n3789_o;
  /* ./T65/T65.vhd:604:11  */
  assign n3791_o = ldad ? di : n3744_o;
  assign n3792_o = n3784_o[7:0];
  assign n3793_o = n3738_o[7:0];
  /* ./T65/T65.vhd:580:11  */
  assign n3794_o = n3746_o ? n3792_o : n3793_o;
  /* ./T65/T65.vhd:607:11  */
  assign n3795_o = ldbal ? di : n3794_o;
  assign n3796_o = n3784_o[8];
  assign n3797_o = n3738_o[8];
  /* ./T65/T65.vhd:580:11  */
  assign n3798_o = n3746_o ? n3796_o : n3797_o;
  /* ./T65/T65.vhd:610:11  */
  assign n3799_o = ldbah ? di : n3783_o;
  assign n3803_o = {n3798_o, n3795_o};
  /* ./T65/T65.vhd:539:9  */
  assign n3807_o = n3702_o & really_rdy;
  /* ./T65/T65.vhd:538:7  */
  assign n3809_o = really_rdy & enable;
  /* ./T65/T65.vhd:538:7  */
  assign n3810_o = really_rdy & enable;
  /* ./T65/T65.vhd:538:7  */
  assign n3811_o = really_rdy & enable;
  /* ./T65/T65.vhd:538:7  */
  assign n3812_o = really_rdy & enable;
  /* ./T65/T65.vhd:538:7  */
  assign n3813_o = really_rdy & enable;
  /* ./T65/T65.vhd:538:7  */
  assign n3814_o = really_rdy & enable;
  /* ./T65/T65.vhd:538:7  */
  assign n3815_o = n3807_o & enable;
  /* ./T65/T65.vhd:538:7  */
  assign n3816_o = really_rdy & enable;
  /* ./T65/T65.vhd:618:34  */
  assign n3841_o = bal[8];
  /* ./T65/T65.vhd:618:27  */
  assign n3842_o = ~n3841_o;
  /* ./T65/T65.vhd:618:23  */
  assign n3843_o = breakatna & n3842_o;
  /* ./T65/T65.vhd:618:64  */
  assign n3844_o = pcadder[8];
  /* ./T65/T65.vhd:618:53  */
  assign n3845_o = ~n3844_o;
  /* ./T65/T65.vhd:618:49  */
  assign n3846_o = pcadd & n3845_o;
  /* ./T65/T65.vhd:618:39  */
  assign n3847_o = n3843_o | n3846_o;
  /* ./T65/T65.vhd:622:45  */
  assign n3849_o = set_busa_to == 4'b0000;
  /* ./T65/T65.vhd:623:10  */
  assign n3850_o = abc[7:0];
  /* ./T65/T65.vhd:623:45  */
  assign n3852_o = set_busa_to == 4'b0001;
  /* ./T65/T65.vhd:624:8  */
  assign n3853_o = x[7:0];
  /* ./T65/T65.vhd:624:45  */
  assign n3855_o = set_busa_to == 4'b0010;
  /* ./T65/T65.vhd:625:8  */
  assign n3856_o = y[7:0];
  /* ./T65/T65.vhd:625:45  */
  assign n3858_o = set_busa_to == 4'b0011;
  /* ./T65/T65.vhd:626:25  */
  assign n3859_o = s[7:0];
  /* ./T65/T65.vhd:626:45  */
  assign n3861_o = set_busa_to == 4'b0100;
  /* ./T65/T65.vhd:627:45  */
  assign n3863_o = set_busa_to == 4'b0101;
  /* ./T65/T65.vhd:628:10  */
  assign n3864_o = abc[7:0];
  /* ./T65/T65.vhd:628:23  */
  assign n3865_o = n3864_o & di;
  /* ./T65/T65.vhd:628:45  */
  assign n3867_o = set_busa_to == 4'b0110;
  /* ./T65/T65.vhd:629:11  */
  assign n3868_o = abc[7:0];
  /* ./T65/T65.vhd:629:24  */
  assign n3870_o = n3868_o | 8'b11101110;
  /* ./T65/T65.vhd:629:34  */
  assign n3871_o = n3870_o & di;
  /* ./T65/T65.vhd:629:45  */
  assign n3873_o = set_busa_to == 4'b0111;
  /* ./T65/T65.vhd:630:11  */
  assign n3874_o = abc[7:0];
  /* ./T65/T65.vhd:630:24  */
  assign n3876_o = n3874_o | 8'b11101110;
  /* ./T65/T65.vhd:630:34  */
  assign n3877_o = n3876_o & di;
  /* ./T65/T65.vhd:630:46  */
  assign n3878_o = x[7:0];
  /* ./T65/T65.vhd:630:41  */
  assign n3879_o = n3877_o & n3878_o;
  /* ./T65/T65.vhd:630:62  */
  assign n3881_o = set_busa_to == 4'b1000;
  /* ./T65/T65.vhd:631:10  */
  assign n3882_o = abc[7:0];
  /* ./T65/T65.vhd:631:28  */
  assign n3883_o = x[7:0];
  /* ./T65/T65.vhd:631:23  */
  assign n3884_o = n3882_o & n3883_o;
  /* ./T65/T65.vhd:631:45  */
  assign n3886_o = set_busa_to == 4'b1001;
  /* ./T65/T65.vhd:632:45  */
  assign n3889_o = set_busa_to == 4'b1010;
  assign n3890_o = {n3889_o, n3886_o, n3881_o, n3873_o, n3867_o, n3863_o, n3861_o, n3858_o, n3855_o, n3852_o, n3849_o};
  /* ./T65/T65.vhd:620:3  */
  always @*
    case (n3890_o)
      11'b10000000000: n3892_o = 8'bX;
      11'b01000000000: n3892_o = n3884_o;
      11'b00100000000: n3892_o = n3879_o;
      11'b00010000000: n3892_o = n3871_o;
      11'b00001000000: n3892_o = n3865_o;
      11'b00000100000: n3892_o = p;
      11'b00000010000: n3892_o = n3859_o;
      11'b00000001000: n3892_o = n3856_o;
      11'b00000000100: n3892_o = n3853_o;
      11'b00000000010: n3892_o = n3850_o;
      11'b00000000001: n3892_o = di;
      default: n3892_o = 8'bX;
    endcase
  /* ./T65/T65.vhd:636:46  */
  assign n3893_o = s[7:0];
  /* ./T65/T65.vhd:636:26  */
  assign n3895_o = {16'b0000000000000001, n3893_o};
  /* ./T65/T65.vhd:636:87  */
  assign n3897_o = set_addr_to_r == 2'b01;
  /* ./T65/T65.vhd:637:11  */
  assign n3899_o = {dbr, 8'b00000000};
  /* ./T65/T65.vhd:637:24  */
  assign n3900_o = {n3899_o, ad};
  /* ./T65/T65.vhd:637:87  */
  assign n3902_o = set_addr_to_r == 2'b10;
  /* ./T65/T65.vhd:638:18  */
  assign n3904_o = {8'b00000000, bah};
  /* ./T65/T65.vhd:638:29  */
  assign n3905_o = bal[7:0];
  /* ./T65/T65.vhd:638:24  */
  assign n3906_o = {n3904_o, n3905_o};
  /* ./T65/T65.vhd:638:87  */
  assign n3908_o = set_addr_to_r == 2'b11;
  /* ./T65/T65.vhd:639:32  */
  assign n3909_o = pc[15:8];
  /* ./T65/T65.vhd:639:11  */
  assign n3910_o = {pbr, n3909_o};
  /* ./T65/T65.vhd:639:73  */
  assign n3911_o = pcadder[7:0];
  /* ./T65/T65.vhd:639:47  */
  assign n3912_o = {n3910_o, n3911_o};
  /* ./T65/T65.vhd:639:87  */
  assign n3914_o = set_addr_to_r == 2'b00;
  assign n3915_o = {n3914_o, n3908_o, n3902_o, n3897_o};
  /* ./T65/T65.vhd:634:3  */
  always @*
    case (n3915_o)
      4'b1000: n3917_o = n3912_o;
      4'b0100: n3917_o = n3906_o;
      4'b0010: n3917_o = n3900_o;
      4'b0001: n3917_o = n3895_o;
      default: n3917_o = 24'bX;
    endcase
  /* ./T65/T65.vhd:642:14  */
  assign n3919_o = p & 8'b11101111;
  /* ./T65/T65.vhd:642:44  */
  assign n3920_o = irqcycle | nmicycle;
  /* ./T65/T65.vhd:642:25  */
  assign n3921_o = n3920_o ? n3919_o : p;
  /* ./T65/T65.vhd:648:43  */
  assign n3923_o = write_data_r == 4'b0000;
  /* ./T65/T65.vhd:649:10  */
  assign n3924_o = abc[7:0];
  /* ./T65/T65.vhd:649:43  */
  assign n3926_o = write_data_r == 4'b0001;
  /* ./T65/T65.vhd:650:8  */
  assign n3927_o = x[7:0];
  /* ./T65/T65.vhd:650:43  */
  assign n3929_o = write_data_r == 4'b0010;
  /* ./T65/T65.vhd:651:8  */
  assign n3930_o = y[7:0];
  /* ./T65/T65.vhd:651:43  */
  assign n3932_o = write_data_r == 4'b0011;
  /* ./T65/T65.vhd:652:25  */
  assign n3933_o = s[7:0];
  /* ./T65/T65.vhd:652:43  */
  assign n3935_o = write_data_r == 4'b0100;
  /* ./T65/T65.vhd:653:43  */
  assign n3937_o = write_data_r == 4'b0101;
  /* ./T65/T65.vhd:654:26  */
  assign n3938_o = pc[7:0];
  /* ./T65/T65.vhd:654:43  */
  assign n3940_o = write_data_r == 4'b0110;
  /* ./T65/T65.vhd:655:26  */
  assign n3941_o = pc[15:8];
  /* ./T65/T65.vhd:655:43  */
  assign n3943_o = write_data_r == 4'b0111;
  /* ./T65/T65.vhd:656:10  */
  assign n3944_o = abc[7:0];
  /* ./T65/T65.vhd:656:28  */
  assign n3945_o = x[7:0];
  /* ./T65/T65.vhd:656:23  */
  assign n3946_o = n3944_o & n3945_o;
  /* ./T65/T65.vhd:656:43  */
  assign n3948_o = write_data_r == 4'b1000;
  /* ./T65/T65.vhd:657:10  */
  assign n3949_o = abc[7:0];
  /* ./T65/T65.vhd:657:28  */
  assign n3950_o = x[7:0];
  /* ./T65/T65.vhd:657:23  */
  assign n3951_o = n3949_o & n3950_o;
  /* ./T65/T65.vhd:657:41  */
  assign n3952_o = n3951_o & busb_r;
  /* ./T65/T65.vhd:657:64  */
  assign n3954_o = write_data_r == 4'b1001;
  /* ./T65/T65.vhd:658:8  */
  assign n3955_o = x[7:0];
  /* ./T65/T65.vhd:658:21  */
  assign n3956_o = n3955_o & busb_r;
  /* ./T65/T65.vhd:658:44  */
  assign n3958_o = write_data_r == 4'b1010;
  /* ./T65/T65.vhd:659:8  */
  assign n3959_o = y[7:0];
  /* ./T65/T65.vhd:659:21  */
  assign n3960_o = n3959_o & busb_r;
  /* ./T65/T65.vhd:659:44  */
  assign n3962_o = write_data_r == 4'b1011;
  /* ./T65/T65.vhd:660:43  */
  assign n3965_o = write_data_r == 4'b1100;
  assign n3966_o = {n3965_o, n3962_o, n3958_o, n3954_o, n3948_o, n3943_o, n3940_o, n3937_o, n3935_o, n3932_o, n3929_o, n3926_o, n3923_o};
  /* ./T65/T65.vhd:646:3  */
  always @*
    case (n3966_o)
      13'b1000000000000: n3968_o = 8'bX;
      13'b0100000000000: n3968_o = n3960_o;
      13'b0010000000000: n3968_o = n3956_o;
      13'b0001000000000: n3968_o = n3952_o;
      13'b0000100000000: n3968_o = n3946_o;
      13'b0000010000000: n3968_o = n3941_o;
      13'b0000001000000: n3968_o = n3938_o;
      13'b0000000100000: n3968_o = pwithb;
      13'b0000000010000: n3968_o = n3933_o;
      13'b0000000001000: n3968_o = n3930_o;
      13'b0000000000100: n3968_o = n3927_o;
      13'b0000000000010: n3968_o = n3924_o;
      13'b0000000000001: n3968_o = dl;
      default: n3968_o = 8'bX;
    endcase
  /* ./T65/T65.vhd:671:16  */
  assign n3971_o = ~res_n_i;
  /* ./T65/T65.vhd:680:21  */
  assign n3973_o = mcycle == lcycle;
  /* ./T65/T65.vhd:680:30  */
  assign n3974_o = n3973_o | break;
  /* ./T65/T65.vhd:685:35  */
  assign n3976_o = ir != 8'b00000000;
  /* ./T65/T65.vhd:685:29  */
  assign n3977_o = n3976_o & nmiact;
  /* ./T65/T65.vhd:688:27  */
  assign n3978_o = ~irq_n_o;
  /* ./T65/T65.vhd:688:38  */
  assign n3979_o = p[2];
  /* ./T65/T65.vhd:688:47  */
  assign n3980_o = ~n3979_o;
  /* ./T65/T65.vhd:688:33  */
  assign n3981_o = n3980_o & n3978_o;
  /* ./T65/T65.vhd:688:13  */
  assign n3984_o = n3981_o ? 1'b1 : 1'b0;
  /* ./T65/T65.vhd:685:13  */
  assign n3986_o = n3977_o ? 1'b0 : n3984_o;
  /* ./T65/T65.vhd:685:13  */
  assign n3990_o = n3977_o ? 1'b1 : 1'b0;
  /* ./T65/T65.vhd:679:9  */
  assign n3993_o = n4007_o ? 1'b0 : nmiact;
  /* ./T65/T65.vhd:692:57  */
  assign n3995_o = mcycle + 3'b001;
  /* ./T65/T65.vhd:680:11  */
  assign n3997_o = n3974_o ? 3'b000 : n3995_o;
  /* ./T65/T65.vhd:680:11  */
  assign n4002_o = n3977_o & n3974_o;
  /* ./T65/T65.vhd:679:9  */
  assign n4004_o = n3974_o & really_rdy;
  /* ./T65/T65.vhd:679:9  */
  assign n4005_o = n3974_o & really_rdy;
  /* ./T65/T65.vhd:679:9  */
  assign n4006_o = n3974_o & really_rdy;
  /* ./T65/T65.vhd:679:9  */
  assign n4007_o = n4002_o & really_rdy;
  /* ./T65/T65.vhd:696:37  */
  assign n4008_o = ~nmi_n;
  /* ./T65/T65.vhd:696:50  */
  assign n4009_o = ir[4:0];
  /* ./T65/T65.vhd:696:62  */
  assign n4011_o = n4009_o != 5'b10000;
  /* ./T65/T65.vhd:696:79  */
  assign n4013_o = jump != 2'b01;
  /* ./T65/T65.vhd:696:72  */
  assign n4014_o = n4011_o | n4013_o;
  /* ./T65/T65.vhd:696:43  */
  assign n4015_o = n4014_o & n4008_o;
  /* ./T65/T65.vhd:696:26  */
  assign n4016_o = n4015_o & nmi_n_o;
  /* ./T65/T65.vhd:696:9  */
  assign n4018_o = n4016_o ? 1'b1 : n3993_o;
  /* ./T65/T65.vhd:700:9  */
  assign n4020_o = nmi_entered ? 1'b0 : n4018_o;
  /* ./T65/T65.vhd:678:7  */
  assign n4021_o = really_rdy & enable;
  /* ./T65/T65.vhd:678:7  */
  assign n4022_o = n4004_o & enable;
  /* ./T65/T65.vhd:678:7  */
  assign n4023_o = n4005_o & enable;
  /* ./T65/T65.vhd:678:7  */
  assign n4024_o = n4006_o & enable;
  /* ./T65/T65.vhd:439:3  */
  assign n4042_o = ~n3436_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4043_o = n3644_o & n4042_o;
  /* ./T65/T65.vhd:444:5  */
  assign n4044_o = abc[7:0];
  /* ./T65/T65.vhd:444:5  */
  assign n4045_o = n4043_o ? alu_q : n4044_o;
  /* ./T65/T65.vhd:444:5  */
  always @(posedge clk)
    n4046_q <= n4045_o;
  assign n4048_o = {8'bZ, n4046_q};
  /* ./T65/T65.vhd:439:3  */
  assign n4049_o = ~n3436_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4050_o = n3646_o & n4049_o;
  /* ./T65/T65.vhd:444:5  */
  assign n4051_o = x[7:0];
  /* ./T65/T65.vhd:444:5  */
  assign n4052_o = n4050_o ? alu_q : n4051_o;
  /* ./T65/T65.vhd:444:5  */
  always @(posedge clk)
    n4053_q <= n4052_o;
  assign n4055_o = {8'bZ, n4053_q};
  /* ./T65/T65.vhd:439:3  */
  assign n4056_o = ~n3436_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4057_o = n3648_o & n4056_o;
  /* ./T65/T65.vhd:444:5  */
  assign n4058_o = y[7:0];
  /* ./T65/T65.vhd:444:5  */
  assign n4059_o = n4057_o ? alu_q : n4058_o;
  /* ./T65/T65.vhd:444:5  */
  always @(posedge clk)
    n4060_q <= n4059_o;
  assign n4062_o = {8'bZ, n4060_q};
  /* ./T65/T65.vhd:444:5  */
  always @(posedge clk or posedge n3436_o)
    if (n3436_o)
      n4063_q <= 8'b00000000;
    else
      n4063_q <= n3672_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4064_o = n3809_o ? n3791_o : ad;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk or posedge n3696_o)
    if (n3696_o)
      n4065_q <= 8'b00000000;
    else
      n4065_q <= n4064_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4066_o = n3810_o ? n3790_o : dl;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk or posedge n3696_o)
    if (n3696_o)
      n4067_q <= 8'b00000000;
    else
      n4067_q <= n4066_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4068_o = n3811_o ? n3799_o : bah;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk or posedge n3696_o)
    if (n3696_o)
      n4069_q <= 8'b00000000;
    else
      n4069_q <= n4068_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4070_o = n3812_o ? n3803_o : bal;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk or posedge n3696_o)
    if (n3696_o)
      n4071_q <= 9'b000000000;
    else
      n4071_q <= n4070_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4072_o = n3364_o ? 8'b11111111 : pbr;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4073_q <= 8'b00000000;
    else
      n4073_q <= n4072_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4074_o = n3365_o ? 8'b11111111 : dbr;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4075_q <= 8'b00000000;
    else
      n4075_q <= n4074_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4076_o = n3366_o ? n3348_o : pc;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4077_q <= 16'b0000000000000000;
    else
      n4077_q <= n4076_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4078_o = n3367_o ? n3283_o : s;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4079_q <= 16'b0000000000000000;
    else
      n4079_q <= n4078_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4080_o = n3368_o ? 1'b0 : ef_i;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4081_q <= 1'b1;
    else
      n4081_q <= n4080_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4082_o = n3369_o ? 1'b0 : mf_i;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4083_q <= 1'b1;
    else
      n4083_q <= n4082_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4084_o = n3370_o ? 1'b0 : xf_i;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4085_q <= 1'b1;
    else
      n4085_q <= n4084_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4086_o = n3371_o ? n3260_o : ir;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4087_q <= 8'b00000000;
    else
      n4087_q <= n4086_o;
  /* ./T65/T65.vhd:677:5  */
  assign n4088_o = n4021_o ? n3997_o : mcycle;
  /* ./T65/T65.vhd:677:5  */
  always @(posedge clk or posedge n3971_o)
    if (n3971_o)
      n4089_q <= 3'b001;
    else
      n4089_q <= n4088_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4090_o = n3372_o ? mode : mode_r;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4091_q <= 2'b00;
    else
      n4091_q <= n4090_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4092_o = n3373_o ? bcd_en : bcd_en_r;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4093_q <= 1'b1;
    else
      n4093_q <= n4092_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4094_o = n3374_o ? alu_op : alu_op_r;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4095_q <= 5'b01100;
    else
      n4095_q <= n4094_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4096_o = n3375_o ? write_data : write_data_r;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4097_q <= 4'b0000;
    else
      n4097_q <= n4096_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4098_o = n3376_o ? n3270_o : set_addr_to_r;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4099_q <= 2'b00;
    else
      n4099_q <= n4098_o;
  /* ./T65/T65.vhd:677:5  */
  assign n4100_o = n4022_o ? 1'b0 : rstcycle;
  /* ./T65/T65.vhd:677:5  */
  always @(posedge clk or posedge n3971_o)
    if (n3971_o)
      n4101_q <= 1'b1;
    else
      n4101_q <= n4100_o;
  /* ./T65/T65.vhd:677:5  */
  assign n4102_o = n4023_o ? n3986_o : irqcycle;
  /* ./T65/T65.vhd:677:5  */
  always @(posedge clk or posedge n3971_o)
    if (n3971_o)
      n4103_q <= 1'b0;
    else
      n4103_q <= n4102_o;
  /* ./T65/T65.vhd:677:5  */
  assign n4104_o = n4024_o ? n3990_o : nmicycle;
  /* ./T65/T65.vhd:677:5  */
  always @(posedge clk or posedge n3971_o)
    if (n3971_o)
      n4105_q <= 1'b0;
    else
      n4105_q <= n4104_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4106_o = ~n3436_o;
  /* ./T65/T65.vhd:444:5  */
  assign n4107_o = n4106_o ? so_n : so_n_o;
  /* ./T65/T65.vhd:444:5  */
  always @(posedge clk)
    n4108_q <= n4107_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4109_o = ~n3436_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4110_o = n3650_o & n4109_o;
  /* ./T65/T65.vhd:444:5  */
  assign n4111_o = n4110_o ? irq_n : irq_n_o;
  /* ./T65/T65.vhd:444:5  */
  always @(posedge clk)
    n4112_q <= n4111_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4113_o = ~n3436_o;
  /* ./T65/T65.vhd:439:3  */
  assign n4114_o = n3651_o & n4113_o;
  /* ./T65/T65.vhd:444:5  */
  assign n4115_o = n4114_o ? nmi_n : nmi_n_o;
  /* ./T65/T65.vhd:444:5  */
  always @(posedge clk)
    n4116_q <= n4115_o;
  /* ./T65/T65.vhd:677:5  */
  assign n4117_o = enable ? n4020_o : nmiact;
  /* ./T65/T65.vhd:677:5  */
  always @(posedge clk or posedge n3971_o)
    if (n3971_o)
      n4118_q <= 1'b0;
    else
      n4118_q <= n4117_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4119_o = n3813_o ? busa : busa_r;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk or posedge n3696_o)
    if (n3696_o)
      n4120_q <= 8'b00000000;
    else
      n4120_q <= n4119_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4121_o = n3814_o ? di : busb;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk or posedge n3696_o)
    if (n3696_o)
      n4122_q <= 8'b00000000;
    else
      n4122_q <= n4121_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4123_o = n3815_o ? n3704_o : busb_r;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk or posedge n3696_o)
    if (n3696_o)
      n4124_q <= 8'b00000000;
    else
      n4124_q <= n4123_o;
  /* ./T65/T65.vhd:331:5  */
  always @(posedge clk or posedge n3215_o)
    if (n3215_o)
      n4125_q <= 1'b0;
    else
      n4125_q <= res_n_d;
  /* ./T65/T65.vhd:331:5  */
  always @(posedge clk or posedge n3215_o)
    if (n3215_o)
      n4126_q <= 1'b0;
    else
      n4126_q <= 1'b1;
  /* ./T65/T65.vhd:337:3  */
  assign n4127_o = ~n3227_o;
  /* ./T65/T65.vhd:337:3  */
  assign n4128_o = enable & n4127_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4129_o = n4128_o ? n3247_o : rdy_mod;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk)
    n4130_q <= n4129_o;
  /* ./T65/T65.vhd:357:5  */
  assign n4131_o = n3378_o ? n3249_o : wrn_i;
  /* ./T65/T65.vhd:357:5  */
  always @(posedge clk or posedge n3227_o)
    if (n3227_o)
      n4132_q <= 1'b1;
    else
      n4132_q <= n4131_o;
  /* ./T65/T65.vhd:527:3  */
  assign n4133_o = ~n3696_o;
  /* ./T65/T65.vhd:527:3  */
  assign n4134_o = n3816_o & n4133_o;
  /* ./T65/T65.vhd:537:5  */
  assign n4135_o = n4134_o ? n3787_o : nmi_entered;
  /* ./T65/T65.vhd:537:5  */
  always @(posedge clk)
    n4136_q <= n4135_o;
  /* ./T65/T65.vhd:529:5  */
  assign n4137_o = {p, n3176_o, n3175_o, n3174_o, n3173_o, ir};
endmodule

module tia
  (input  vid_clk,
   input  clk,
   input  cs,
   input  r,
   input  [5:0] a,
   input  [7:0] din,
   input  inpt0,
   input  inpt1,
   input  inpt2,
   input  inpt3,
   input  inpt4,
   input  inpt5,
   input  pal,
   input  decomb,
   output [7:0] dout,
   output [6:0] colu,
   output csyn,
   output hsyn,
   output vsyn,
   output ohblank,
   output ovblank,
   output [23:0] rgbx2,
   output rdy,
   output ph0,
   output ph0_en,
   output ph2,
   output ph2_en,
   output au0,
   output au1,
   output [3:0] av0,
   output [3:0] av1,
   output inpt03_chg);
  wire [5:0] h_lfsr_out;
  wire h_lfsr_rst;
  wire h_lfsr_cnt;
  wire [1:0] h_cntr_out;
  wire h_cntr_rst;
  reg hsync;
  reg hblank;
  reg hblank_out;
  reg hmove;
  wire hmove_set;
  reg [3:0] hmove_cntr;
  wire [3:0] hmove_cntr_sl;
  wire p0_rst;
  reg [2:0] p0_nusiz;
  wire p0_reflect;
  wire [7:0] p0_grpnew;
  wire [7:0] p0_grpold;
  reg p0_vdel;
  wire p0_pix;
  reg [6:0] p0_colu;
  reg [6:0] p0_colu_reg;
  wire [3:0] p0_hmove;
  wire p0_count;
  reg p0_ec;
  wire p0_mrst;
  wire p1_rst;
  reg [2:0] p1_nusiz;
  wire p1_reflect;
  wire [7:0] p1_grpnew;
  wire [7:0] p1_grpold;
  reg p1_vdel;
  wire p1_pix;
  reg [6:0] p1_colu;
  reg [6:0] p1_colu_reg;
  wire [3:0] p1_hmove;
  wire p1_count;
  reg p1_ec;
  wire p1_mrst;
  wire m0_rst;
  wire m0_enable;
  reg [1:0] m0_size;
  wire m0_pix;
  wire [3:0] m0_hmove;
  wire m0_count;
  reg m0_ec;
  reg m0_resp0;
  wire m1_rst;
  wire m1_enable;
  reg [1:0] m1_size;
  wire m1_pix;
  wire [3:0] m1_hmove;
  wire m1_count;
  reg m1_ec;
  reg m1_resp1;
  wire bl_rst;
  wire bl_ennew;
  wire bl_enold;
  reg bl_vdel;
  wire [1:0] bl_size;
  wire bl_pix;
  wire [3:0] bl_hmove;
  wire bl_count;
  reg bl_ec;
  wire [19:0] pf_gr;
  reg [4:0] pf_adr;
  wire pf_pix;
  wire pf_mux_out;
  wire pf_reflect;
  wire pf_reverse;
  wire pf_score;
  reg pf_priority;
  reg [6:0] pf_colu;
  reg [6:0] pf_colu_reg;
  reg [6:0] bk_colu;
  reg [6:0] bk_colu_reg;
  reg [4:0] a0_freq;
  reg [3:0] a0_ctrl;
  reg [3:0] a0_vol;
  reg [4:0] a1_freq;
  reg [3:0] a1_ctrl;
  reg [3:0] a1_vol;
  reg wsync;
  reg vsync;
  reg vblank;
  reg center;
  reg pf_cnt;
  reg [14:0] cx;
  wire cx_clr;
  reg [1:0] clk_dvdr;
  reg phi0;
  reg phi0_en;
  reg phi2;
  wire phi2_d;
  wire phi2_en;
  reg inpt45_len;
  wire inpt45_rst;
  reg inpt4_l;
  reg inpt5_l;
  wire au_cnt;
  reg [1:0] sec_dl;
  wire sec;
  wire hh0;
  wire hh0_edge;
  wire hh1_edge;
  reg [6:0] int_colu;
  wire [6:0] vga_colu;
  wire [7:0] floating_bus;
  wire [1:0] h_cntr_o;
  localparam n2096_o = 1'b1;
  wire [5:0] lfsr_o;
  wire pf_mux_o;
  wire n2102_o;
  wire n2103_o;
  wire n2107_o;
  wire n2108_o;
  wire n2112_o;
  wire n2113_o;
  wire aud0_aout ;
  wire aud1_aout ;
  wire n2119_o;
  wire n2121_o;
  wire n2122_o;
  wire n2123_o;
  wire n2124_o;
  wire n2128_o;
  wire n2129_o;
  wire n2132_o;
  wire n2135_o;
  wire n2136_o;
  wire n2138_o;
  wire n2139_o;
  wire n2140_o;
  wire n2145_o;
  wire n2147_o;
  wire n2149_o;
  wire n2151_o;
  wire n2153_o;
  wire n2155_o;
  wire n2157_o;
  wire n2159_o;
  wire n2161_o;
  wire [8:0] n2162_o;
  reg n2163_o;
  reg n2166_o;
  reg n2169_o;
  reg n2172_o;
  reg n2175_o;
  reg n2178_o;
  wire n2179_o;
  wire n2180_o;
  wire n2199_o;
  wire n2200_o;
  wire n2202_o;
  wire n2204_o;
  wire n2211_o;
  wire n2212_o;
  wire n2213_o;
  wire n2214_o;
  wire n2216_o;
  wire n2217_o;
  wire n2219_o;
  wire n2221_o;
  wire n2224_o;
  wire n2225_o;
  wire n2226_o;
  wire n2228_o;
  wire n2234_o;
  wire n2235_o;
  wire n2236_o;
  wire n2237_o;
  wire n2239_o;
  wire n2240_o;
  wire n2241_o;
  wire n2242_o;
  wire n2248_o;
  wire n2250_o;
  wire n2251_o;
  wire [4:0] n2253_o;
  wire [4:0] n2254_o;
  wire [4:0] n2256_o;
  wire n2257_o;
  wire [4:0] n2259_o;
  wire n2261_o;
  wire n2270_o;
  wire n2271_o;
  wire n2273_o;
  wire n2274_o;
  wire n2275_o;
  wire n2276_o;
  wire n2277_o;
  wire n2280_o;
  wire n2281_o;
  wire n2283_o;
  wire n2284_o;
  wire n2285_o;
  wire n2286_o;
  wire n2287_o;
  wire n2290_o;
  wire n2291_o;
  wire n2293_o;
  wire n2294_o;
  wire n2295_o;
  wire n2296_o;
  wire n2297_o;
  wire n2300_o;
  wire n2301_o;
  wire n2303_o;
  wire n2304_o;
  wire n2305_o;
  wire n2306_o;
  wire n2307_o;
  wire n2310_o;
  wire n2311_o;
  wire n2313_o;
  wire n2314_o;
  wire n2315_o;
  wire n2316_o;
  wire n2317_o;
  wire n2320_o;
  wire n2321_o;
  wire n2322_o;
  wire n2323_o;
  wire n2326_o;
  wire n2327_o;
  wire n2328_o;
  wire n2329_o;
  wire n2332_o;
  wire n2333_o;
  wire n2334_o;
  wire n2335_o;
  wire n2338_o;
  wire n2339_o;
  wire n2340_o;
  wire n2341_o;
  wire n2344_o;
  wire n2345_o;
  wire n2346_o;
  wire n2347_o;
  wire n2351_o;
  wire n2352_o;
  wire n2353_o;
  wire n2354_o;
  wire n2355_o;
  wire n2359_o;
  wire n2360_o;
  wire n2361_o;
  wire n2362_o;
  wire n2363_o;
  wire n2367_o;
  wire n2368_o;
  wire n2369_o;
  wire n2370_o;
  wire n2371_o;
  wire n2375_o;
  wire [5:0] n2376_o;
  wire [3:0] n2377_o;
  wire [1:0] n2378_o;
  wire n2380_o;
  wire [1:0] n2381_o;
  wire n2383_o;
  wire [1:0] n2384_o;
  wire n2386_o;
  wire [1:0] n2387_o;
  wire n2389_o;
  wire [1:0] n2390_o;
  wire n2392_o;
  wire [1:0] n2393_o;
  wire n2395_o;
  wire n2396_o;
  wire n2397_o;
  wire n2399_o;
  wire [1:0] n2400_o;
  wire n2402_o;
  wire n2405_o;
  wire n2408_o;
  wire n2411_o;
  wire n2414_o;
  wire n2415_o;
  wire n2418_o;
  wire n2419_o;
  wire n2422_o;
  wire [1:0] n2423_o;
  wire [13:0] n2424_o;
  wire n2425_o;
  wire n2426_o;
  wire n2427_o;
  wire n2428_o;
  wire n2429_o;
  wire n2430_o;
  wire n2431_o;
  wire n2432_o;
  reg n2433_o;
  wire n2434_o;
  wire n2435_o;
  wire n2436_o;
  wire n2437_o;
  wire n2438_o;
  wire n2439_o;
  wire n2440_o;
  wire n2441_o;
  reg n2442_o;
  wire [7:0] n2443_o;
  wire [7:0] n2444_o;
  wire n2445_o;
  wire n2446_o;
  wire n2447_o;
  wire [6:0] n2448_o;
  wire n2450_o;
  wire [6:0] n2451_o;
  wire n2453_o;
  wire [6:0] n2454_o;
  wire n2456_o;
  wire [6:0] n2457_o;
  wire n2459_o;
  wire [3:0] n2460_o;
  reg [6:0] n2461_o;
  reg [6:0] n2462_o;
  reg [6:0] n2463_o;
  reg [6:0] n2464_o;
  wire [6:0] n2465_o;
  wire [6:0] n2466_o;
  wire [6:0] n2467_o;
  wire [6:0] n2468_o;
  wire n2470_o;
  wire n2472_o;
  wire n2473_o;
  wire n2474_o;
  wire n2475_o;
  wire n2476_o;
  wire n2477_o;
  wire n2479_o;
  wire n2480_o;
  wire n2481_o;
  wire n2482_o;
  wire n2484_o;
  wire [3:0] n2485_o;
  wire n2487_o;
  wire n2489_o;
  wire n2491_o;
  wire n2492_o;
  wire n2493_o;
  wire n2494_o;
  wire [1:0] n2495_o;
  wire n2497_o;
  wire [2:0] n2498_o;
  wire [1:0] n2499_o;
  wire n2501_o;
  wire [2:0] n2502_o;
  wire [1:0] n2503_o;
  wire n2505_o;
  wire n2507_o;
  wire [3:0] n2508_o;
  wire n2510_o;
  wire [3:0] n2511_o;
  wire n2513_o;
  wire [3:0] n2514_o;
  wire n2516_o;
  wire [3:0] n2517_o;
  wire n2519_o;
  wire [3:0] n2520_o;
  wire n2522_o;
  wire n2523_o;
  wire n2525_o;
  wire n2526_o;
  wire n2528_o;
  wire n2529_o;
  wire n2531_o;
  wire n2533_o;
  wire n2535_o;
  wire n2536_o;
  wire n2538_o;
  wire n2539_o;
  wire n2541_o;
  wire n2542_o;
  wire n2544_o;
  wire n2545_o;
  wire n2547_o;
  wire n2548_o;
  wire n2550_o;
  wire [4:0] n2551_o;
  wire n2553_o;
  wire [4:0] n2554_o;
  wire n2556_o;
  wire [3:0] n2557_o;
  wire n2559_o;
  wire [3:0] n2560_o;
  wire n2562_o;
  wire [3:0] n2563_o;
  wire n2565_o;
  wire [3:0] n2566_o;
  wire n2568_o;
  wire n2569_o;
  wire n2571_o;
  wire n2572_o;
  wire n2574_o;
  wire [31:0] n2575_o;
  reg n2576_o;
  reg [2:0] n2577_o;
  reg n2578_o;
  reg [7:0] n2579_o;
  reg [7:0] n2580_o;
  reg n2581_o;
  reg [3:0] n2583_o;
  reg [2:0] n2584_o;
  reg n2585_o;
  reg [7:0] n2586_o;
  reg [7:0] n2587_o;
  reg n2588_o;
  reg [3:0] n2590_o;
  reg n2591_o;
  reg [1:0] n2592_o;
  reg [3:0] n2594_o;
  reg n2595_o;
  reg n2596_o;
  reg [1:0] n2597_o;
  reg [3:0] n2599_o;
  reg n2600_o;
  reg n2601_o;
  reg n2602_o;
  reg n2603_o;
  reg [1:0] n2604_o;
  reg [3:0] n2606_o;
  wire [3:0] n2607_o;
  reg [3:0] n2608_o;
  wire [7:0] n2609_o;
  reg [7:0] n2610_o;
  wire [7:0] n2611_o;
  reg [7:0] n2612_o;
  reg n2613_o;
  reg n2614_o;
  reg n2615_o;
  reg [4:0] n2616_o;
  reg [3:0] n2617_o;
  reg [3:0] n2618_o;
  reg [4:0] n2619_o;
  reg [3:0] n2620_o;
  reg [3:0] n2621_o;
  reg n2622_o;
  reg n2623_o;
  reg n2624_o;
  wire [19:0] n2651_o;
  wire n2713_o;
  wire n2714_o;
  wire n2715_o;
  wire n2716_o;
  wire n2717_o;
  wire n2718_o;
  wire n2719_o;
  wire n2720_o;
  wire n2721_o;
  wire n2722_o;
  wire n2723_o;
  wire n2724_o;
  wire [6:0] n2725_o;
  wire n2726_o;
  wire n2727_o;
  wire n2728_o;
  wire n2729_o;
  wire n2730_o;
  wire n2731_o;
  wire n2732_o;
  wire n2733_o;
  wire n2734_o;
  wire [6:0] n2735_o;
  wire [6:0] n2736_o;
  wire [6:0] n2737_o;
  wire [6:0] n2738_o;
  wire [6:0] n2739_o;
  wire [6:0] n2741_o;
  wire [6:0] n2743_o;
  wire n2750_o;
  wire n2751_o;
  wire n2752_o;
  wire n2753_o;
  wire n2754_o;
  wire n2755_o;
  wire n2756_o;
  wire n2757_o;
  wire n2758_o;
  wire [1:0] n2759_o;
  wire [3:0] n2766_o;
  wire [3:0] n2767_o;
  wire n2768_o;
  wire n2769_o;
  wire n2770_o;
  wire [2:0] n2771_o;
  wire [2:0] n2772_o;
  wire n2773_o;
  wire n2774_o;
  wire n2776_o;
  wire n2778_o;
  wire n2779_o;
  wire n2780_o;
  wire n2781_o;
  wire [2:0] n2782_o;
  wire [2:0] n2783_o;
  wire n2784_o;
  wire n2785_o;
  wire n2787_o;
  wire n2789_o;
  wire n2790_o;
  wire n2791_o;
  wire n2792_o;
  wire [2:0] n2793_o;
  wire [2:0] n2794_o;
  wire n2795_o;
  wire n2796_o;
  wire n2798_o;
  wire n2800_o;
  wire n2801_o;
  wire n2802_o;
  wire n2803_o;
  wire [2:0] n2804_o;
  wire [2:0] n2805_o;
  wire n2806_o;
  wire n2807_o;
  wire n2809_o;
  wire n2811_o;
  wire n2812_o;
  wire n2813_o;
  wire n2814_o;
  wire [2:0] n2815_o;
  wire [2:0] n2816_o;
  wire n2817_o;
  wire n2818_o;
  wire n2820_o;
  wire n2822_o;
  wire n2824_o;
  wire n2825_o;
  wire [3:0] n2827_o;
  wire [3:0] n2828_o;
  wire n2844_o;
  wire n2845_o;
  wire n2846_o;
  wire n2847_o;
  wire n2849_o;
  wire n2850_o;
  wire n2851_o;
  wire n2853_o;
  wire n2854_o;
  wire n2855_o;
  wire n2857_o;
  wire n2858_o;
  wire n2859_o;
  wire n2861_o;
  wire n2862_o;
  wire n2863_o;
  wire n2865_o;
  wire n2866_o;
  wire n2867_o;
  wire n2869_o;
  wire n2870_o;
  wire n2871_o;
  wire n2873_o;
  wire n2874_o;
  wire n2875_o;
  wire n2877_o;
  wire n2878_o;
  wire n2879_o;
  wire n2881_o;
  wire n2882_o;
  wire n2883_o;
  wire n2885_o;
  wire n2886_o;
  wire n2887_o;
  wire n2889_o;
  wire n2890_o;
  wire n2891_o;
  wire n2893_o;
  wire n2894_o;
  wire n2895_o;
  wire n2897_o;
  wire n2898_o;
  wire n2899_o;
  wire n2901_o;
  wire n2902_o;
  wire n2903_o;
  wire n2905_o;
  wire n2906_o;
  wire [14:0] n2907_o;
  wire [14:0] n2908_o;
  wire [14:0] n2910_o;
  wire n2917_o;
  wire n2918_o;
  wire n2920_o;
  wire n2922_o;
  wire n2924_o;
  wire [2:0] n2925_o;
  reg [1:0] n2929_o;
  reg n2933_o;
  reg n2936_o;
  wire [1:0] n2938_o;
  wire n2940_o;
  wire n2942_o;
  wire n2953_o;
  wire n2955_o;
  wire n2956_o;
  wire n2958_o;
  wire n2959_o;
  wire n2960_o;
  wire n2962_o;
  wire n2964_o;
  wire [23:0] inst_vgacolortable_outcolor;
  wire [2:0] n2968_o;
  wire [3:0] n2970_o;
  wire [3:0] n2971_o;
  wire [1:0] n2973_o;
  wire n2975_o;
  reg n2976_q;
  wire n2977_o;
  reg n2978_q;
  wire n2979_o;
  reg n2980_q;
  reg n2981_q;
  wire [3:0] n2982_o;
  reg [3:0] n2983_q;
  wire [2:0] n2984_o;
  reg [2:0] n2985_q;
  wire n2986_o;
  reg n2987_q;
  wire [7:0] n2988_o;
  reg [7:0] n2989_q;
  wire [7:0] n2990_o;
  reg [7:0] n2991_q;
  wire n2992_o;
  reg n2993_q;
  reg [6:0] n2994_q;
  wire [3:0] n2995_o;
  reg [3:0] n2996_q;
  wire n2997_o;
  reg n2998_q;
  wire [2:0] n2999_o;
  reg [2:0] n3000_q;
  wire n3001_o;
  reg n3002_q;
  wire [7:0] n3003_o;
  reg [7:0] n3004_q;
  wire [7:0] n3005_o;
  reg [7:0] n3006_q;
  wire n3007_o;
  reg n3008_q;
  reg [6:0] n3009_q;
  wire [3:0] n3010_o;
  reg [3:0] n3011_q;
  wire n3012_o;
  reg n3013_q;
  wire n3014_o;
  reg n3015_q;
  wire [1:0] n3016_o;
  reg [1:0] n3017_q;
  wire [3:0] n3018_o;
  reg [3:0] n3019_q;
  wire n3020_o;
  reg n3021_q;
  wire n3022_o;
  reg n3023_q;
  wire n3024_o;
  reg n3025_q;
  wire [1:0] n3026_o;
  reg [1:0] n3027_q;
  wire [3:0] n3028_o;
  reg [3:0] n3029_q;
  wire n3030_o;
  reg n3031_q;
  wire n3032_o;
  reg n3033_q;
  wire n3034_o;
  reg n3035_q;
  wire n3036_o;
  reg n3037_q;
  wire n3038_o;
  reg n3039_q;
  wire [1:0] n3040_o;
  reg [1:0] n3041_q;
  wire [3:0] n3042_o;
  reg [3:0] n3043_q;
  wire n3044_o;
  reg n3045_q;
  wire [19:0] n3046_o;
  reg [19:0] n3047_q;
  wire [4:0] n3048_o;
  reg [4:0] n3049_q;
  wire n3050_o;
  reg n3051_q;
  wire n3052_o;
  reg n3053_q;
  wire n3054_o;
  reg n3055_q;
  wire n3056_o;
  reg n3057_q;
  wire n3058_o;
  reg n3059_q;
  reg [6:0] n3060_q;
  reg [6:0] n3061_q;
  wire [4:0] n3062_o;
  reg [4:0] n3063_q;
  wire [3:0] n3064_o;
  reg [3:0] n3065_q;
  wire [3:0] n3066_o;
  reg [3:0] n3067_q;
  wire [4:0] n3068_o;
  reg [4:0] n3069_q;
  wire [3:0] n3070_o;
  reg [3:0] n3071_q;
  wire [3:0] n3072_o;
  reg [3:0] n3073_q;
  reg n3074_q;
  wire n3075_o;
  reg n3076_q;
  wire n3077_o;
  reg n3078_q;
  wire n3079_o;
  reg n3080_q;
  wire n3081_o;
  reg n3082_q;
  reg [14:0] n3083_q;
  reg [1:0] n3084_q;
  reg n3085_q;
  reg n3086_q;
  reg n3087_q;
  reg n3088_q;
  reg n3089_q;
  wire n3090_o;
  reg n3091_q;
  reg n3092_q;
  reg n3093_q;
  reg [1:0] n3094_q;
  reg n3095_q;
  reg [6:0] n3099_q;
  wire [7:0] n3103_o;
  reg [7:0] n3104_q;
  reg n3105_q;
  wire n3106_o;
  reg n3107_q;
  wire n3108_o;
  reg n3109_q;
  assign dout = n2444_o;
  assign colu = int_colu;
  assign csyn = n2226_o;
  assign hsyn = hsync;
  assign vsyn = vsync;
  assign ohblank = n3105_q;
  assign ovblank = n3107_q;
  assign rgbx2 = inst_vgacolortable_outcolor;
  assign rdy = n2228_o;
  assign ph0 = phi0;
  assign ph0_en = phi0_en;
  assign ph2 = phi2;
  assign ph2_en = phi2_en;
  assign au0 = aud0_aout ;
  assign au1 = aud1_aout ;
  assign av0 = a0_vol;
  assign av1 = a1_vol;
  assign inpt03_chg = n3109_q;
  /* ./TIA/TIA.vhd:631:12  */
  assign h_lfsr_out = lfsr_o; // (signal)
  /* ./TIA/TIA.vhd:632:12  */
  assign h_lfsr_rst = n2129_o; // (signal)
  /* ./TIA/TIA.vhd:633:12  */
  assign h_lfsr_cnt = n2132_o; // (signal)
  /* ./TIA/TIA.vhd:635:12  */
  assign h_cntr_out = h_cntr_o; // (signal)
  /* ./TIA/TIA.vhd:636:12  */
  assign h_cntr_rst = n2140_o; // (signal)
  /* ./TIA/TIA.vhd:638:12  */
  always @*
    hsync = n2976_q; // (isignal)
  initial
    hsync = 1'b0;
  /* ./TIA/TIA.vhd:640:12  */
  always @*
    hblank = n2978_q; // (isignal)
  initial
    hblank = 1'b1;
  /* ./TIA/TIA.vhd:641:12  */
  always @*
    hblank_out = n2980_q; // (isignal)
  initial
    hblank_out = 1'b1;
  /* ./TIA/TIA.vhd:642:12  */
  always @*
    hmove = n2981_q; // (isignal)
  initial
    hmove = 1'b0;
  /* ./TIA/TIA.vhd:643:12  */
  assign hmove_set = n2355_o; // (signal)
  /* ./TIA/TIA.vhd:644:12  */
  always @*
    hmove_cntr = n2983_q; // (isignal)
  initial
    hmove_cntr = 4'b1111;
  /* ./TIA/TIA.vhd:645:12  */
  assign hmove_cntr_sl = hmove_cntr; // (signal)
  /* ./TIA/TIA.vhd:647:12  */
  assign p0_rst = n2277_o; // (signal)
  /* ./TIA/TIA.vhd:648:12  */
  always @*
    p0_nusiz = n2985_q; // (isignal)
  initial
    p0_nusiz = 3'b000;
  /* ./TIA/TIA.vhd:649:12  */
  assign p0_reflect = n2987_q; // (signal)
  /* ./TIA/TIA.vhd:650:12  */
  assign p0_grpnew = n2989_q; // (signal)
  /* ./TIA/TIA.vhd:651:12  */
  assign p0_grpold = n2991_q; // (signal)
  /* ./TIA/TIA.vhd:652:12  */
  always @*
    p0_vdel = n2993_q; // (isignal)
  initial
    p0_vdel = 1'b0;
  /* ./TIA/TIA.vhd:653:12  */
  /* ./TIA/TIA.vhd:654:12  */
  always @*
    p0_colu = n2465_o; // (isignal)
  initial
    p0_colu = 7'b0000000;
  /* ./TIA/TIA.vhd:655:12  */
  always @*
    p0_colu_reg = n2994_q; // (isignal)
  initial
    p0_colu_reg = 7'b0000000;
  /* ./TIA/TIA.vhd:656:12  */
  assign p0_hmove = n2996_q; // (signal)
  /* ./TIA/TIA.vhd:657:12  */
  assign p0_count = n2323_o; // (signal)
  /* ./TIA/TIA.vhd:658:12  */
  always @*
    p0_ec = n2998_q; // (isignal)
  initial
    p0_ec = 1'b0;
  /* ./TIA/TIA.vhd:659:12  */
  /* ./TIA/TIA.vhd:661:12  */
  assign p1_rst = n2287_o; // (signal)
  /* ./TIA/TIA.vhd:662:12  */
  always @*
    p1_nusiz = n3000_q; // (isignal)
  initial
    p1_nusiz = 3'b000;
  /* ./TIA/TIA.vhd:663:12  */
  assign p1_reflect = n3002_q; // (signal)
  /* ./TIA/TIA.vhd:664:12  */
  assign p1_grpnew = n3004_q; // (signal)
  /* ./TIA/TIA.vhd:665:12  */
  assign p1_grpold = n3006_q; // (signal)
  /* ./TIA/TIA.vhd:666:12  */
  always @*
    p1_vdel = n3008_q; // (isignal)
  initial
    p1_vdel = 1'b0;
  /* ./TIA/TIA.vhd:667:12  */
  /* ./TIA/TIA.vhd:668:12  */
  always @*
    p1_colu = n2466_o; // (isignal)
  initial
    p1_colu = 7'b0000000;
  /* ./TIA/TIA.vhd:669:12  */
  always @*
    p1_colu_reg = n3009_q; // (isignal)
  initial
    p1_colu_reg = 7'b0000000;
  /* ./TIA/TIA.vhd:670:12  */
  assign p1_hmove = n3011_q; // (signal)
  /* ./TIA/TIA.vhd:671:12  */
  assign p1_count = n2329_o; // (signal)
  /* ./TIA/TIA.vhd:672:12  */
  always @*
    p1_ec = n3013_q; // (isignal)
  initial
    p1_ec = 1'b0;
  /* ./TIA/TIA.vhd:673:12  */
  /* ./TIA/TIA.vhd:675:12  */
  assign m0_rst = n2297_o; // (signal)
  /* ./TIA/TIA.vhd:676:12  */
  assign m0_enable = n3015_q; // (signal)
  /* ./TIA/TIA.vhd:677:12  */
  always @*
    m0_size = n3017_q; // (isignal)
  initial
    m0_size = 2'b00;
  /* ./TIA/TIA.vhd:678:12  */
  /* ./TIA/TIA.vhd:679:12  */
  assign m0_hmove = n3019_q; // (signal)
  /* ./TIA/TIA.vhd:680:12  */
  assign m0_count = n2335_o; // (signal)
  /* ./TIA/TIA.vhd:681:12  */
  always @*
    m0_ec = n3021_q; // (isignal)
  initial
    m0_ec = 1'b0;
  /* ./TIA/TIA.vhd:682:12  */
  always @*
    m0_resp0 = n3023_q; // (isignal)
  initial
    m0_resp0 = 1'b0;
  /* ./TIA/TIA.vhd:684:12  */
  assign m1_rst = n2307_o; // (signal)
  /* ./TIA/TIA.vhd:685:12  */
  assign m1_enable = n3025_q; // (signal)
  /* ./TIA/TIA.vhd:686:12  */
  always @*
    m1_size = n3027_q; // (isignal)
  initial
    m1_size = 2'b00;
  /* ./TIA/TIA.vhd:687:12  */
  /* ./TIA/TIA.vhd:688:12  */
  assign m1_hmove = n3029_q; // (signal)
  /* ./TIA/TIA.vhd:689:12  */
  assign m1_count = n2341_o; // (signal)
  /* ./TIA/TIA.vhd:690:12  */
  always @*
    m1_ec = n3031_q; // (isignal)
  initial
    m1_ec = 1'b0;
  /* ./TIA/TIA.vhd:691:12  */
  always @*
    m1_resp1 = n3033_q; // (isignal)
  initial
    m1_resp1 = 1'b0;
  /* ./TIA/TIA.vhd:693:12  */
  assign bl_rst = n2317_o; // (signal)
  /* ./TIA/TIA.vhd:694:12  */
  assign bl_ennew = n3035_q; // (signal)
  /* ./TIA/TIA.vhd:695:12  */
  assign bl_enold = n3037_q; // (signal)
  /* ./TIA/TIA.vhd:696:12  */
  always @*
    bl_vdel = n3039_q; // (isignal)
  initial
    bl_vdel = 1'b0;
  /* ./TIA/TIA.vhd:697:12  */
  assign bl_size = n3041_q; // (signal)
  /* ./TIA/TIA.vhd:698:12  */
  /* ./TIA/TIA.vhd:699:12  */
  assign bl_hmove = n3043_q; // (signal)
  /* ./TIA/TIA.vhd:700:12  */
  assign bl_count = n2347_o; // (signal)
  /* ./TIA/TIA.vhd:701:12  */
  always @*
    bl_ec = n3045_q; // (isignal)
  initial
    bl_ec = 1'b0;
  /* ./TIA/TIA.vhd:703:12  */
  assign pf_gr = n3047_q; // (signal)
  /* ./TIA/TIA.vhd:704:12  */
  always @*
    pf_adr = n3049_q; // (isignal)
  initial
    pf_adr = 5'b00000;
  /* ./TIA/TIA.vhd:705:12  */
  assign pf_pix = n3051_q; // (signal)
  /* ./TIA/TIA.vhd:706:12  */
  assign pf_mux_out = pf_mux_o; // (signal)
  /* ./TIA/TIA.vhd:707:12  */
  assign pf_reflect = n3053_q; // (signal)
  /* ./TIA/TIA.vhd:708:12  */
  assign pf_reverse = n3055_q; // (signal)
  /* ./TIA/TIA.vhd:709:12  */
  assign pf_score = n3057_q; // (signal)
  /* ./TIA/TIA.vhd:710:12  */
  always @*
    pf_priority = n3059_q; // (isignal)
  initial
    pf_priority = 1'b0;
  /* ./TIA/TIA.vhd:711:12  */
  always @*
    pf_colu = n2467_o; // (isignal)
  initial
    pf_colu = 7'b0000000;
  /* ./TIA/TIA.vhd:712:12  */
  always @*
    pf_colu_reg = n3060_q; // (isignal)
  initial
    pf_colu_reg = 7'b0000000;
  /* ./TIA/TIA.vhd:714:12  */
  always @*
    bk_colu = n2468_o; // (isignal)
  initial
    bk_colu = 7'b0000000;
  /* ./TIA/TIA.vhd:715:12  */
  always @*
    bk_colu_reg = n3061_q; // (isignal)
  initial
    bk_colu_reg = 7'b0000000;
  /* ./TIA/TIA.vhd:717:12  */
  always @*
    a0_freq = n3063_q; // (isignal)
  initial
    a0_freq = 5'b00000;
  /* ./TIA/TIA.vhd:718:12  */
  always @*
    a0_ctrl = n3065_q; // (isignal)
  initial
    a0_ctrl = 4'b0000;
  /* ./TIA/TIA.vhd:719:12  */
  always @*
    a0_vol = n3067_q; // (isignal)
  initial
    a0_vol = 4'b0000;
  /* ./TIA/TIA.vhd:721:12  */
  always @*
    a1_freq = n3069_q; // (isignal)
  initial
    a1_freq = 5'b00000;
  /* ./TIA/TIA.vhd:722:12  */
  always @*
    a1_ctrl = n3071_q; // (isignal)
  initial
    a1_ctrl = 4'b0000;
  /* ./TIA/TIA.vhd:723:12  */
  always @*
    a1_vol = n3073_q; // (isignal)
  initial
    a1_vol = 4'b0000;
  /* ./TIA/TIA.vhd:725:12  */
  always @*
    wsync = n3074_q; // (isignal)
  initial
    wsync = 1'b0;
  /* ./TIA/TIA.vhd:727:12  */
  always @*
    vsync = n3076_q; // (isignal)
  initial
    vsync = 1'b0;
  /* ./TIA/TIA.vhd:728:12  */
  always @*
    vblank = n3078_q; // (isignal)
  initial
    vblank = 1'b0;
  /* ./TIA/TIA.vhd:729:12  */
  always @*
    center = n3080_q; // (isignal)
  initial
    center = 1'b0;
  /* ./TIA/TIA.vhd:730:12  */
  always @*
    pf_cnt = n3082_q; // (isignal)
  initial
    pf_cnt = 1'b0;
  /* ./TIA/TIA.vhd:732:12  */
  always @*
    cx = n3083_q; // (isignal)
  initial
    cx = 15'b000000000000000;
  /* ./TIA/TIA.vhd:733:12  */
  assign cx_clr = n2363_o; // (signal)
  /* ./TIA/TIA.vhd:735:12  */
  always @*
    clk_dvdr = n3084_q; // (isignal)
  initial
    clk_dvdr = 2'b01;
  /* ./TIA/TIA.vhd:736:12  */
  always @*
    phi0 = n3085_q; // (isignal)
  initial
    phi0 = 1'b0;
  /* ./TIA/TIA.vhd:737:12  */
  always @*
    phi0_en = n3086_q; // (isignal)
  initial
    phi0_en = 1'b0;
  /* ./TIA/TIA.vhd:738:12  */
  always @*
    phi2 = n3087_q; // (isignal)
  initial
    phi2 = 1'b1;
  /* ./TIA/TIA.vhd:739:12  */
  assign phi2_d = n3088_q; // (signal)
  /* ./TIA/TIA.vhd:740:12  */
  assign phi2_en = n3089_q; // (signal)
  /* ./TIA/TIA.vhd:742:12  */
  always @*
    inpt45_len = n3091_q; // (isignal)
  initial
    inpt45_len = 1'b0;
  /* ./TIA/TIA.vhd:743:12  */
  assign inpt45_rst = n2371_o; // (signal)
  /* ./TIA/TIA.vhd:744:12  */
  always @*
    inpt4_l = n3092_q; // (isignal)
  initial
    inpt4_l = 1'b1;
  /* ./TIA/TIA.vhd:745:12  */
  always @*
    inpt5_l = n3093_q; // (isignal)
  initial
    inpt5_l = 1'b1;
  /* ./TIA/TIA.vhd:747:12  */
  assign au_cnt = n2124_o; // (signal)
  /* ./TIA/TIA.vhd:749:12  */
  always @*
    sec_dl = n3094_q; // (isignal)
  initial
    sec_dl = 2'b00;
  /* ./TIA/TIA.vhd:750:12  */
  assign sec = n3095_q; // (signal)
  /* ./TIA/TIA.vhd:752:12  */
  assign hh0 = n2108_o; // (signal)
  /* ./TIA/TIA.vhd:753:12  */
  assign hh0_edge = n2103_o; // (signal)
  /* ./TIA/TIA.vhd:755:12  */
  assign hh1_edge = n2113_o; // (signal)
  /* ./TIA/TIA.vhd:762:12  */
  always @*
    int_colu = n3099_q; // (isignal)
  initial
    int_colu = 7'b0000000;
  /* ./TIA/TIA.vhd:769:12  */
  assign vga_colu = int_colu; // (signal)
  /* ./TIA/TIA.vhd:771:12  */
  assign floating_bus = n3104_q; // (signal)
  /* ./TIA/TIA.vhd:775:5  */
  cntr2 h_cntr (
    .clk(clk),
    .rst(h_cntr_rst),
    .en(n2096_o),
    .o(h_cntr_o));
  /* ./TIA/TIA.vhd:776:5  */
  lfsr6 lfsr (
    .clk(clk),
    .prst(h_lfsr_rst),
    .cnt(h_lfsr_cnt),
    .o(lfsr_o));
  /* ./TIA/TIA.vhd:777:5  */
  mux20 pf_mux (
    .i(pf_gr),
    .a(pf_adr),
    .rev(pf_reverse),
    .o(pf_mux_o));
  /* ./TIA/TIA.vhd:779:38  */
  assign n2102_o = h_cntr_out == 2'b01;
  /* ./TIA/TIA.vhd:779:21  */
  assign n2103_o = n2102_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:780:33  */
  assign n2107_o = h_cntr_out == 2'b00;
  /* ./TIA/TIA.vhd:780:16  */
  assign n2108_o = n2107_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:781:38  */
  assign n2112_o = h_cntr_out == 2'b10;
  /* ./TIA/TIA.vhd:781:21  */
  assign n2113_o = n2112_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:784:5  */
  audio_argh2600 aud0 (
    .clk(clk),
    .clk_audio(au_cnt),
    .freq(a0_freq),
    .ctrl(a0_ctrl),
    .aout (aud0_aout ));
  /* ./TIA/TIA.vhd:785:5  */
  audio_argh2600 aud1 (
    .clk(clk),
    .clk_audio(au_cnt),
    .freq(a1_freq),
    .ctrl(a1_ctrl),
    .aout (aud1_aout ));
  /* ./TIA/TIA.vhd:790:36  */
  assign n2119_o = h_lfsr_out == 6'b110111;
  /* ./TIA/TIA.vhd:790:61  */
  assign n2121_o = h_lfsr_out == 6'b101100;
  /* ./TIA/TIA.vhd:790:47  */
  assign n2122_o = n2119_o | n2121_o;
  /* ./TIA/TIA.vhd:790:73  */
  assign n2123_o = h_lfsr_cnt & n2122_o;
  /* ./TIA/TIA.vhd:790:19  */
  assign n2124_o = n2123_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:792:40  */
  assign n2128_o = h_lfsr_out == 6'b010100;
  /* ./TIA/TIA.vhd:792:23  */
  assign n2129_o = n2128_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:793:23  */
  assign n2132_o = hh1_edge ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:794:31  */
  assign n2135_o = ~r;
  /* ./TIA/TIA.vhd:794:38  */
  assign n2136_o = cs & n2135_o;
  /* ./TIA/TIA.vhd:794:60  */
  assign n2138_o = a == 6'b000011;
  /* ./TIA/TIA.vhd:794:53  */
  assign n2139_o = n2138_o & n2136_o;
  /* ./TIA/TIA.vhd:794:23  */
  assign n2140_o = n2139_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:801:21  */
  assign n2145_o = h_lfsr_out == 6'b111100;
  /* ./TIA/TIA.vhd:803:21  */
  assign n2147_o = h_lfsr_out == 6'b110111;
  /* ./TIA/TIA.vhd:806:21  */
  assign n2149_o = h_lfsr_out == 6'b001111;
  /* ./TIA/TIA.vhd:808:21  */
  assign n2151_o = h_lfsr_out == 6'b111001;
  /* ./TIA/TIA.vhd:810:21  */
  assign n2153_o = h_lfsr_out == 6'b011100;
  /* ./TIA/TIA.vhd:814:21  */
  assign n2155_o = h_lfsr_out == 6'b010111;
  /* ./TIA/TIA.vhd:816:21  */
  assign n2157_o = h_lfsr_out == 6'b101001;
  /* ./TIA/TIA.vhd:818:21  */
  assign n2159_o = h_lfsr_out == 6'b010100;
  /* ./TIA/TIA.vhd:822:21  */
  assign n2161_o = h_lfsr_out == 6'b011000;
  assign n2162_o = {n2161_o, n2159_o, n2157_o, n2155_o, n2153_o, n2151_o, n2149_o, n2147_o, n2145_o};
  /* ./TIA/TIA.vhd:800:17  */
  always @*
    case (n2162_o)
      9'b100000000: n2163_o = n3107_q;
      9'b010000000: n2163_o = n3107_q;
      9'b001000000: n2163_o = n3107_q;
      9'b000100000: n2163_o = n3107_q;
      9'b000010000: n2163_o = vblank;
      9'b000001000: n2163_o = n3107_q;
      9'b000000100: n2163_o = n3107_q;
      9'b000000010: n2163_o = n3107_q;
      9'b000000001: n2163_o = n3107_q;
      default: n2163_o = n3107_q;
    endcase
  /* ./TIA/TIA.vhd:800:17  */
  always @*
    case (n2162_o)
      9'b100000000: n2166_o = hsync;
      9'b010000000: n2166_o = hsync;
      9'b001000000: n2166_o = hsync;
      9'b000100000: n2166_o = hsync;
      9'b000010000: n2166_o = hsync;
      9'b000001000: n2166_o = hsync;
      9'b000000100: n2166_o = hsync;
      9'b000000010: n2166_o = 1'b0;
      9'b000000001: n2166_o = 1'b1;
      default: n2166_o = hsync;
    endcase
  /* ./TIA/TIA.vhd:800:17  */
  always @*
    case (n2162_o)
      9'b100000000: n2169_o = hblank;
      9'b010000000: n2169_o = 1'b1;
      9'b001000000: n2169_o = hblank;
      9'b000100000: n2169_o = 1'b0;
      9'b000010000: n2169_o = hmove;
      9'b000001000: n2169_o = hblank;
      9'b000000100: n2169_o = hblank;
      9'b000000010: n2169_o = hblank;
      9'b000000001: n2169_o = hblank;
      default: n2169_o = hblank;
    endcase
  /* ./TIA/TIA.vhd:800:17  */
  always @*
    case (n2162_o)
      9'b100000000: n2172_o = hblank_out;
      9'b010000000: n2172_o = 1'b1;
      9'b001000000: n2172_o = hblank_out;
      9'b000100000: n2172_o = hblank_out;
      9'b000010000: n2172_o = 1'b0;
      9'b000001000: n2172_o = hblank_out;
      9'b000000100: n2172_o = hblank_out;
      9'b000000010: n2172_o = hblank_out;
      9'b000000001: n2172_o = hblank_out;
      default: n2172_o = hblank_out;
    endcase
  /* ./TIA/TIA.vhd:800:17  */
  always @*
    case (n2162_o)
      9'b100000000: n2175_o = 1'b1;
      9'b010000000: n2175_o = center;
      9'b001000000: n2175_o = 1'b0;
      9'b000100000: n2175_o = center;
      9'b000010000: n2175_o = center;
      9'b000001000: n2175_o = center;
      9'b000000100: n2175_o = center;
      9'b000000010: n2175_o = center;
      9'b000000001: n2175_o = center;
      default: n2175_o = center;
    endcase
  /* ./TIA/TIA.vhd:800:17  */
  always @*
    case (n2162_o)
      9'b100000000: n2178_o = pf_cnt;
      9'b010000000: n2178_o = 1'b0;
      9'b001000000: n2178_o = pf_cnt;
      9'b000100000: n2178_o = pf_cnt;
      9'b000010000: n2178_o = pf_cnt;
      9'b000001000: n2178_o = 1'b1;
      9'b000000100: n2178_o = pf_cnt;
      9'b000000010: n2178_o = pf_cnt;
      9'b000000001: n2178_o = pf_cnt;
      default: n2178_o = pf_cnt;
    endcase
  /* ./TIA/TIA.vhd:826:13  */
  assign n2179_o = hh0_edge ? hblank_out : n3105_q;
  /* ./TIA/TIA.vhd:799:13  */
  assign n2180_o = hh1_edge ? n3105_q : n2179_o;
  /* ./TIA/TIA.vhd:835:28  */
  assign n2199_o = h_lfsr_out == 6'b101001;
  /* ./TIA/TIA.vhd:835:40  */
  assign n2200_o = hh1_edge & n2199_o;
  /* ./TIA/TIA.vhd:837:13  */
  assign n2202_o = hmove_set ? 1'b1 : hmove;
  /* ./TIA/TIA.vhd:835:13  */
  assign n2204_o = n2200_o ? 1'b0 : n2202_o;
  /* ./TIA/TIA.vhd:846:28  */
  assign n2211_o = h_lfsr_out == 6'b000000;
  /* ./TIA/TIA.vhd:846:39  */
  assign n2212_o = hh1_edge & n2211_o;
  /* ./TIA/TIA.vhd:848:22  */
  assign n2213_o = ~r;
  /* ./TIA/TIA.vhd:848:29  */
  assign n2214_o = cs & n2213_o;
  /* ./TIA/TIA.vhd:848:51  */
  assign n2216_o = a == 6'b000010;
  /* ./TIA/TIA.vhd:848:44  */
  assign n2217_o = n2216_o & n2214_o;
  /* ./TIA/TIA.vhd:848:13  */
  assign n2219_o = n2217_o ? 1'b1 : wsync;
  /* ./TIA/TIA.vhd:846:13  */
  assign n2221_o = n2212_o ? 1'b0 : n2219_o;
  /* ./TIA/TIA.vhd:854:20  */
  assign n2224_o = ~(vsync & hsync);
  /* ./TIA/TIA.vhd:854:43  */
  assign n2225_o = vsync | hsync;
  /* ./TIA/TIA.vhd:854:32  */
  assign n2226_o = n2224_o & n2225_o;
  /* ./TIA/TIA.vhd:858:16  */
  assign n2228_o = wsync ? 1'b0 : 1'b1;
  /* ./TIA/TIA.vhd:860:5  */
  player p0 (
    .clk(clk),
    .prst(p0_rst),
    .count(p0_count),
    .nusiz(p0_nusiz),
    .reflect(p0_reflect),
    .grpnew(p0_grpnew),
    .grpold(p0_grpold),
    .vdel(p0_vdel),
    .mrst(p0_mrst),
    .pix(p0_pix));
  /* ./TIA/TIA.vhd:864:5  */
  player p1 (
    .clk(clk),
    .prst(p1_rst),
    .count(p1_count),
    .nusiz(p1_nusiz),
    .reflect(p1_reflect),
    .grpnew(p1_grpnew),
    .grpold(p1_grpold),
    .vdel(p1_vdel),
    .mrst(p1_mrst),
    .pix(p1_pix));
  /* ./TIA/TIA.vhd:868:5  */
  missile m0 (
    .clk(clk),
    .prst(n2235_o),
    .count(m0_count),
    .enable(n2237_o),
    .nusiz(p0_nusiz),
    .size(m0_size),
    .pix(m0_pix));
  /* ./TIA/TIA.vhd:869:43  */
  assign n2234_o = m0_resp0 & p0_mrst;
  /* ./TIA/TIA.vhd:869:30  */
  assign n2235_o = m0_rst | n2234_o;
  /* ./TIA/TIA.vhd:869:81  */
  assign n2236_o = ~m0_resp0;
  /* ./TIA/TIA.vhd:869:77  */
  assign n2237_o = m0_enable & n2236_o;
  /* ./TIA/TIA.vhd:871:5  */
  missile m1 (
    .clk(clk),
    .prst(n2240_o),
    .count(m1_count),
    .enable(n2242_o),
    .nusiz(p1_nusiz),
    .size(m1_size),
    .pix(m1_pix));
  /* ./TIA/TIA.vhd:872:43  */
  assign n2239_o = m1_resp1 & p1_mrst;
  /* ./TIA/TIA.vhd:872:30  */
  assign n2240_o = m1_rst | n2239_o;
  /* ./TIA/TIA.vhd:872:81  */
  assign n2241_o = ~m1_resp1;
  /* ./TIA/TIA.vhd:872:77  */
  assign n2242_o = m1_enable & n2241_o;
  /* ./TIA/TIA.vhd:874:5  */
  ball bl (
    .clk(clk),
    .prst(bl_rst),
    .count(bl_count),
    .ennew(bl_ennew),
    .enold(bl_enold),
    .vdel(bl_vdel),
    .size(bl_size),
    .pix(bl_pix));
  /* ./TIA/TIA.vhd:882:32  */
  assign n2248_o = pf_adr == 5'b10011;
  /* ./TIA/TIA.vhd:885:39  */
  assign n2250_o = pf_adr == 5'b10011;
  /* ./TIA/TIA.vhd:885:27  */
  assign n2251_o = ~n2250_o;
  /* ./TIA/TIA.vhd:886:42  */
  assign n2253_o = pf_adr + 5'b00001;
  /* ./TIA/TIA.vhd:885:21  */
  assign n2254_o = n2251_o ? n2253_o : pf_adr;
  /* ./TIA/TIA.vhd:882:21  */
  assign n2256_o = n2248_o ? 5'b00000 : n2254_o;
  /* ./TIA/TIA.vhd:882:21  */
  assign n2257_o = n2248_o ? pf_reflect : pf_reverse;
  /* ./TIA/TIA.vhd:881:17  */
  assign n2259_o = pf_cnt ? n2256_o : 5'b00000;
  /* ./TIA/TIA.vhd:881:17  */
  assign n2261_o = pf_cnt ? n2257_o : 1'b0;
  /* ./TIA/TIA.vhd:898:27  */
  assign n2270_o = ~r;
  /* ./TIA/TIA.vhd:898:34  */
  assign n2271_o = cs & n2270_o;
  /* ./TIA/TIA.vhd:898:56  */
  assign n2273_o = a == 6'b010000;
  /* ./TIA/TIA.vhd:898:49  */
  assign n2274_o = n2273_o & n2271_o;
  /* ./TIA/TIA.vhd:898:77  */
  assign n2275_o = ~phi0;
  /* ./TIA/TIA.vhd:898:67  */
  assign n2276_o = n2275_o & n2274_o;
  /* ./TIA/TIA.vhd:898:19  */
  assign n2277_o = n2276_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:899:27  */
  assign n2280_o = ~r;
  /* ./TIA/TIA.vhd:899:34  */
  assign n2281_o = cs & n2280_o;
  /* ./TIA/TIA.vhd:899:56  */
  assign n2283_o = a == 6'b010001;
  /* ./TIA/TIA.vhd:899:49  */
  assign n2284_o = n2283_o & n2281_o;
  /* ./TIA/TIA.vhd:899:77  */
  assign n2285_o = ~phi0;
  /* ./TIA/TIA.vhd:899:67  */
  assign n2286_o = n2285_o & n2284_o;
  /* ./TIA/TIA.vhd:899:19  */
  assign n2287_o = n2286_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:900:27  */
  assign n2290_o = ~r;
  /* ./TIA/TIA.vhd:900:34  */
  assign n2291_o = cs & n2290_o;
  /* ./TIA/TIA.vhd:900:56  */
  assign n2293_o = a == 6'b010010;
  /* ./TIA/TIA.vhd:900:49  */
  assign n2294_o = n2293_o & n2291_o;
  /* ./TIA/TIA.vhd:900:77  */
  assign n2295_o = ~phi0;
  /* ./TIA/TIA.vhd:900:67  */
  assign n2296_o = n2295_o & n2294_o;
  /* ./TIA/TIA.vhd:900:19  */
  assign n2297_o = n2296_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:901:27  */
  assign n2300_o = ~r;
  /* ./TIA/TIA.vhd:901:34  */
  assign n2301_o = cs & n2300_o;
  /* ./TIA/TIA.vhd:901:56  */
  assign n2303_o = a == 6'b010011;
  /* ./TIA/TIA.vhd:901:49  */
  assign n2304_o = n2303_o & n2301_o;
  /* ./TIA/TIA.vhd:901:77  */
  assign n2305_o = ~phi0;
  /* ./TIA/TIA.vhd:901:67  */
  assign n2306_o = n2305_o & n2304_o;
  /* ./TIA/TIA.vhd:901:19  */
  assign n2307_o = n2306_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:902:27  */
  assign n2310_o = ~r;
  /* ./TIA/TIA.vhd:902:34  */
  assign n2311_o = cs & n2310_o;
  /* ./TIA/TIA.vhd:902:56  */
  assign n2313_o = a == 6'b010100;
  /* ./TIA/TIA.vhd:902:49  */
  assign n2314_o = n2313_o & n2311_o;
  /* ./TIA/TIA.vhd:902:77  */
  assign n2315_o = ~phi0;
  /* ./TIA/TIA.vhd:902:67  */
  assign n2316_o = n2315_o & n2314_o;
  /* ./TIA/TIA.vhd:902:19  */
  assign n2317_o = n2316_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:904:34  */
  assign n2320_o = ~hblank;
  /* ./TIA/TIA.vhd:904:57  */
  assign n2321_o = hh0 & p0_ec;
  /* ./TIA/TIA.vhd:904:41  */
  assign n2322_o = n2320_o | n2321_o;
  /* ./TIA/TIA.vhd:904:21  */
  assign n2323_o = n2322_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:905:34  */
  assign n2326_o = ~hblank;
  /* ./TIA/TIA.vhd:905:57  */
  assign n2327_o = hh0 & p1_ec;
  /* ./TIA/TIA.vhd:905:41  */
  assign n2328_o = n2326_o | n2327_o;
  /* ./TIA/TIA.vhd:905:21  */
  assign n2329_o = n2328_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:906:34  */
  assign n2332_o = ~hblank;
  /* ./TIA/TIA.vhd:906:57  */
  assign n2333_o = hh0 & m0_ec;
  /* ./TIA/TIA.vhd:906:41  */
  assign n2334_o = n2332_o | n2333_o;
  /* ./TIA/TIA.vhd:906:21  */
  assign n2335_o = n2334_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:907:34  */
  assign n2338_o = ~hblank;
  /* ./TIA/TIA.vhd:907:57  */
  assign n2339_o = hh0 & m1_ec;
  /* ./TIA/TIA.vhd:907:41  */
  assign n2340_o = n2338_o | n2339_o;
  /* ./TIA/TIA.vhd:907:21  */
  assign n2341_o = n2340_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:908:34  */
  assign n2344_o = ~hblank;
  /* ./TIA/TIA.vhd:908:57  */
  assign n2345_o = hh0 & bl_ec;
  /* ./TIA/TIA.vhd:908:41  */
  assign n2346_o = n2344_o | n2345_o;
  /* ./TIA/TIA.vhd:908:21  */
  assign n2347_o = n2346_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:910:30  */
  assign n2351_o = a == 6'b101010;
  /* ./TIA/TIA.vhd:910:48  */
  assign n2352_o = ~r;
  /* ./TIA/TIA.vhd:910:41  */
  assign n2353_o = n2352_o & n2351_o;
  /* ./TIA/TIA.vhd:910:55  */
  assign n2354_o = cs & n2353_o;
  /* ./TIA/TIA.vhd:910:22  */
  assign n2355_o = n2354_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:911:27  */
  assign n2359_o = a == 6'b101100;
  /* ./TIA/TIA.vhd:911:45  */
  assign n2360_o = ~r;
  /* ./TIA/TIA.vhd:911:38  */
  assign n2361_o = n2360_o & n2359_o;
  /* ./TIA/TIA.vhd:911:52  */
  assign n2362_o = cs & n2361_o;
  /* ./TIA/TIA.vhd:911:19  */
  assign n2363_o = n2362_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:913:31  */
  assign n2367_o = a == 6'b000001;
  /* ./TIA/TIA.vhd:913:50  */
  assign n2368_o = ~r;
  /* ./TIA/TIA.vhd:913:43  */
  assign n2369_o = n2368_o & n2367_o;
  /* ./TIA/TIA.vhd:913:57  */
  assign n2370_o = cs & n2369_o;
  /* ./TIA/TIA.vhd:913:23  */
  assign n2371_o = n2370_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:918:22  */
  assign n2375_o = cs & r;
  /* ./TIA/TIA.vhd:919:45  */
  assign n2376_o = floating_bus[5:0];
  /* ./TIA/TIA.vhd:921:19  */
  assign n2377_o = a[3:0];
  /* ./TIA/TIA.vhd:923:43  */
  assign n2378_o = cx[1:0];
  /* ./TIA/TIA.vhd:922:17  */
  assign n2380_o = n2377_o == 4'b0000;
  /* ./TIA/TIA.vhd:925:43  */
  assign n2381_o = cx[3:2];
  /* ./TIA/TIA.vhd:924:17  */
  assign n2383_o = n2377_o == 4'b0001;
  /* ./TIA/TIA.vhd:927:43  */
  assign n2384_o = cx[5:4];
  /* ./TIA/TIA.vhd:926:17  */
  assign n2386_o = n2377_o == 4'b0010;
  /* ./TIA/TIA.vhd:929:43  */
  assign n2387_o = cx[7:6];
  /* ./TIA/TIA.vhd:928:17  */
  assign n2389_o = n2377_o == 4'b0011;
  /* ./TIA/TIA.vhd:931:43  */
  assign n2390_o = cx[9:8];
  /* ./TIA/TIA.vhd:930:17  */
  assign n2392_o = n2377_o == 4'b0100;
  /* ./TIA/TIA.vhd:933:43  */
  assign n2393_o = cx[11:10];
  /* ./TIA/TIA.vhd:932:17  */
  assign n2395_o = n2377_o == 4'b0101;
  /* ./TIA/TIA.vhd:935:34  */
  assign n2396_o = cx[12];
  /* ./TIA/TIA.vhd:936:44  */
  assign n2397_o = floating_bus[6];
  /* ./TIA/TIA.vhd:934:17  */
  assign n2399_o = n2377_o == 4'b0110;
  /* ./TIA/TIA.vhd:938:43  */
  assign n2400_o = cx[14:13];
  /* ./TIA/TIA.vhd:937:17  */
  assign n2402_o = n2377_o == 4'b0111;
  /* ./TIA/TIA.vhd:939:17  */
  assign n2405_o = n2377_o == 4'b1000;
  /* ./TIA/TIA.vhd:942:17  */
  assign n2408_o = n2377_o == 4'b1001;
  /* ./TIA/TIA.vhd:945:17  */
  assign n2411_o = n2377_o == 4'b1010;
  /* ./TIA/TIA.vhd:948:17  */
  assign n2414_o = n2377_o == 4'b1011;
  /* ./TIA/TIA.vhd:952:21  */
  assign n2415_o = inpt45_len ? inpt4_l : inpt4;
  /* ./TIA/TIA.vhd:951:17  */
  assign n2418_o = n2377_o == 4'b1100;
  /* ./TIA/TIA.vhd:960:21  */
  assign n2419_o = inpt45_len ? inpt5_l : inpt5;
  /* ./TIA/TIA.vhd:959:17  */
  assign n2422_o = n2377_o == 4'b1101;
  /* ./TIA/TIA.vhd:968:53  */
  assign n2423_o = floating_bus[7:6];
  assign n2424_o = {n2422_o, n2418_o, n2414_o, n2411_o, n2408_o, n2405_o, n2402_o, n2399_o, n2395_o, n2392_o, n2389_o, n2386_o, n2383_o, n2380_o};
  assign n2425_o = n2378_o[0];
  assign n2426_o = n2381_o[0];
  assign n2427_o = n2384_o[0];
  assign n2428_o = n2387_o[0];
  assign n2429_o = n2390_o[0];
  assign n2430_o = n2393_o[0];
  assign n2431_o = n2400_o[0];
  assign n2432_o = n2423_o[0];
  /* ./TIA/TIA.vhd:921:13  */
  always @*
    case (n2424_o)
      14'b10000000000000: n2433_o = 1'b0;
      14'b01000000000000: n2433_o = 1'b0;
      14'b00100000000000: n2433_o = 1'b0;
      14'b00010000000000: n2433_o = 1'b0;
      14'b00001000000000: n2433_o = 1'b0;
      14'b00000100000000: n2433_o = 1'b0;
      14'b00000010000000: n2433_o = n2431_o;
      14'b00000001000000: n2433_o = n2397_o;
      14'b00000000100000: n2433_o = n2430_o;
      14'b00000000010000: n2433_o = n2429_o;
      14'b00000000001000: n2433_o = n2428_o;
      14'b00000000000100: n2433_o = n2427_o;
      14'b00000000000010: n2433_o = n2426_o;
      14'b00000000000001: n2433_o = n2425_o;
      default: n2433_o = n2432_o;
    endcase
  assign n2434_o = n2378_o[1];
  assign n2435_o = n2381_o[1];
  assign n2436_o = n2384_o[1];
  assign n2437_o = n2387_o[1];
  assign n2438_o = n2390_o[1];
  assign n2439_o = n2393_o[1];
  assign n2440_o = n2400_o[1];
  assign n2441_o = n2423_o[1];
  /* ./TIA/TIA.vhd:921:13  */
  always @*
    case (n2424_o)
      14'b10000000000000: n2442_o = n2419_o;
      14'b01000000000000: n2442_o = n2415_o;
      14'b00100000000000: n2442_o = inpt3;
      14'b00010000000000: n2442_o = inpt2;
      14'b00001000000000: n2442_o = inpt1;
      14'b00000100000000: n2442_o = inpt0;
      14'b00000010000000: n2442_o = n2440_o;
      14'b00000001000000: n2442_o = n2396_o;
      14'b00000000100000: n2442_o = n2439_o;
      14'b00000000010000: n2442_o = n2438_o;
      14'b00000000001000: n2442_o = n2437_o;
      14'b00000000000100: n2442_o = n2436_o;
      14'b00000000000010: n2442_o = n2435_o;
      14'b00000000000001: n2442_o = n2434_o;
      default: n2442_o = n2441_o;
    endcase
  assign n2443_o = {n2442_o, n2433_o, n2376_o};
  /* ./TIA/TIA.vhd:918:9  */
  assign n2444_o = n2375_o ? n2443_o : floating_bus;
  /* ./TIA/TIA.vhd:979:15  */
  assign n2445_o = ~r;
  /* ./TIA/TIA.vhd:979:22  */
  assign n2446_o = cs & n2445_o;
  /* ./TIA/TIA.vhd:979:37  */
  assign n2447_o = phi2 & n2446_o;
  /* ./TIA/TIA.vhd:982:35  */
  assign n2448_o = din[7:1];
  /* ./TIA/TIA.vhd:981:17  */
  assign n2450_o = a == 6'b000110;
  /* ./TIA/TIA.vhd:984:35  */
  assign n2451_o = din[7:1];
  /* ./TIA/TIA.vhd:983:17  */
  assign n2453_o = a == 6'b000111;
  /* ./TIA/TIA.vhd:986:35  */
  assign n2454_o = din[7:1];
  /* ./TIA/TIA.vhd:985:17  */
  assign n2456_o = a == 6'b001000;
  /* ./TIA/TIA.vhd:988:35  */
  assign n2457_o = din[7:1];
  /* ./TIA/TIA.vhd:987:17  */
  assign n2459_o = a == 6'b001001;
  assign n2460_o = {n2459_o, n2456_o, n2453_o, n2450_o};
  /* ./TIA/TIA.vhd:980:13  */
  always @*
    case (n2460_o)
      4'b1000: n2461_o = p0_colu_reg;
      4'b0100: n2461_o = p0_colu_reg;
      4'b0010: n2461_o = p0_colu_reg;
      4'b0001: n2461_o = n2448_o;
      default: n2461_o = p0_colu_reg;
    endcase
  /* ./TIA/TIA.vhd:980:13  */
  always @*
    case (n2460_o)
      4'b1000: n2462_o = p1_colu_reg;
      4'b0100: n2462_o = p1_colu_reg;
      4'b0010: n2462_o = n2451_o;
      4'b0001: n2462_o = p1_colu_reg;
      default: n2462_o = p1_colu_reg;
    endcase
  /* ./TIA/TIA.vhd:980:13  */
  always @*
    case (n2460_o)
      4'b1000: n2463_o = pf_colu_reg;
      4'b0100: n2463_o = n2454_o;
      4'b0010: n2463_o = pf_colu_reg;
      4'b0001: n2463_o = pf_colu_reg;
      default: n2463_o = pf_colu_reg;
    endcase
  /* ./TIA/TIA.vhd:980:13  */
  always @*
    case (n2460_o)
      4'b1000: n2464_o = n2457_o;
      4'b0100: n2464_o = bk_colu_reg;
      4'b0010: n2464_o = bk_colu_reg;
      4'b0001: n2464_o = bk_colu_reg;
      default: n2464_o = bk_colu_reg;
    endcase
  /* ./TIA/TIA.vhd:979:9  */
  assign n2465_o = n2447_o ? n2461_o : p0_colu_reg;
  /* ./TIA/TIA.vhd:979:9  */
  assign n2466_o = n2447_o ? n2462_o : p1_colu_reg;
  /* ./TIA/TIA.vhd:979:9  */
  assign n2467_o = n2447_o ? n2463_o : pf_colu_reg;
  /* ./TIA/TIA.vhd:979:9  */
  assign n2468_o = n2447_o ? n2464_o : bk_colu_reg;
  /* ./TIA/TIA.vhd:999:19  */
  assign n2470_o = ~cs;
  /* ./TIA/TIA.vhd:1005:19  */
  assign n2472_o = ~r;
  /* ./TIA/TIA.vhd:1005:26  */
  assign n2473_o = cs & n2472_o;
  /* ./TIA/TIA.vhd:1005:53  */
  assign n2474_o = ~phi2_d;
  /* ./TIA/TIA.vhd:1005:59  */
  assign n2475_o = phi2 & n2474_o;
  /* ./TIA/TIA.vhd:1005:41  */
  assign n2476_o = n2475_o & n2473_o;
  /* ./TIA/TIA.vhd:1008:37  */
  assign n2477_o = din[1];
  /* ./TIA/TIA.vhd:1007:21  */
  assign n2479_o = a == 6'b000000;
  /* ./TIA/TIA.vhd:1010:42  */
  assign n2480_o = din[7];
  /* ./TIA/TIA.vhd:1011:42  */
  assign n2481_o = din[6];
  /* ./TIA/TIA.vhd:1012:38  */
  assign n2482_o = din[1];
  /* ./TIA/TIA.vhd:1009:21  */
  assign n2484_o = a == 6'b000001;
  /* ./TIA/TIA.vhd:1014:49  */
  assign n2485_o = din[7:4];
  /* ./TIA/TIA.vhd:1013:21  */
  assign n2487_o = a == 6'b001101;
  /* ./TIA/TIA.vhd:1015:21  */
  assign n2489_o = a == 6'b001110;
  /* ./TIA/TIA.vhd:1017:21  */
  assign n2491_o = a == 6'b001111;
  /* ./TIA/TIA.vhd:1020:42  */
  assign n2492_o = din[0];
  /* ./TIA/TIA.vhd:1021:40  */
  assign n2493_o = din[1];
  /* ./TIA/TIA.vhd:1022:43  */
  assign n2494_o = din[2];
  /* ./TIA/TIA.vhd:1023:39  */
  assign n2495_o = din[5:4];
  /* ./TIA/TIA.vhd:1019:21  */
  assign n2497_o = a == 6'b001010;
  /* ./TIA/TIA.vhd:1025:40  */
  assign n2498_o = din[2:0];
  /* ./TIA/TIA.vhd:1026:39  */
  assign n2499_o = din[5:4];
  /* ./TIA/TIA.vhd:1024:21  */
  assign n2501_o = a == 6'b000100;
  /* ./TIA/TIA.vhd:1028:40  */
  assign n2502_o = din[2:0];
  /* ./TIA/TIA.vhd:1029:39  */
  assign n2503_o = din[5:4];
  /* ./TIA/TIA.vhd:1027:21  */
  assign n2505_o = a == 6'b000101;
  /* ./TIA/TIA.vhd:1030:21  */
  assign n2507_o = a == 6'b101011;
  /* ./TIA/TIA.vhd:1037:40  */
  assign n2508_o = din[7:4];
  /* ./TIA/TIA.vhd:1036:21  */
  assign n2510_o = a == 6'b100000;
  /* ./TIA/TIA.vhd:1039:40  */
  assign n2511_o = din[7:4];
  /* ./TIA/TIA.vhd:1038:21  */
  assign n2513_o = a == 6'b100001;
  /* ./TIA/TIA.vhd:1041:40  */
  assign n2514_o = din[7:4];
  /* ./TIA/TIA.vhd:1040:21  */
  assign n2516_o = a == 6'b100010;
  /* ./TIA/TIA.vhd:1043:40  */
  assign n2517_o = din[7:4];
  /* ./TIA/TIA.vhd:1042:21  */
  assign n2519_o = a == 6'b100011;
  /* ./TIA/TIA.vhd:1045:40  */
  assign n2520_o = din[7:4];
  /* ./TIA/TIA.vhd:1044:21  */
  assign n2522_o = a == 6'b100100;
  /* ./TIA/TIA.vhd:1047:41  */
  assign n2523_o = din[1];
  /* ./TIA/TIA.vhd:1046:21  */
  assign n2525_o = a == 6'b011101;
  /* ./TIA/TIA.vhd:1049:41  */
  assign n2526_o = din[1];
  /* ./TIA/TIA.vhd:1048:21  */
  assign n2528_o = a == 6'b011110;
  /* ./TIA/TIA.vhd:1051:40  */
  assign n2529_o = din[1];
  /* ./TIA/TIA.vhd:1050:21  */
  assign n2531_o = a == 6'b011111;
  /* ./TIA/TIA.vhd:1052:21  */
  assign n2533_o = a == 6'b011011;
  /* ./TIA/TIA.vhd:1055:21  */
  assign n2535_o = a == 6'b011100;
  /* ./TIA/TIA.vhd:1060:42  */
  assign n2536_o = din[3];
  /* ./TIA/TIA.vhd:1059:21  */
  assign n2538_o = a == 6'b001011;
  /* ./TIA/TIA.vhd:1062:42  */
  assign n2539_o = din[3];
  /* ./TIA/TIA.vhd:1061:21  */
  assign n2541_o = a == 6'b001100;
  /* ./TIA/TIA.vhd:1064:39  */
  assign n2542_o = din[0];
  /* ./TIA/TIA.vhd:1063:21  */
  assign n2544_o = a == 6'b100101;
  /* ./TIA/TIA.vhd:1066:39  */
  assign n2545_o = din[0];
  /* ./TIA/TIA.vhd:1065:21  */
  assign n2547_o = a == 6'b100110;
  /* ./TIA/TIA.vhd:1068:39  */
  assign n2548_o = din[0];
  /* ./TIA/TIA.vhd:1067:21  */
  assign n2550_o = a == 6'b100111;
  /* ./TIA/TIA.vhd:1070:39  */
  assign n2551_o = din[4:0];
  /* ./TIA/TIA.vhd:1069:21  */
  assign n2553_o = a == 6'b010111;
  /* ./TIA/TIA.vhd:1072:39  */
  assign n2554_o = din[4:0];
  /* ./TIA/TIA.vhd:1071:21  */
  assign n2556_o = a == 6'b011000;
  /* ./TIA/TIA.vhd:1074:39  */
  assign n2557_o = din[3:0];
  /* ./TIA/TIA.vhd:1073:21  */
  assign n2559_o = a == 6'b010101;
  /* ./TIA/TIA.vhd:1076:39  */
  assign n2560_o = din[3:0];
  /* ./TIA/TIA.vhd:1075:21  */
  assign n2562_o = a == 6'b010110;
  /* ./TIA/TIA.vhd:1078:38  */
  assign n2563_o = din[3:0];
  /* ./TIA/TIA.vhd:1077:21  */
  assign n2565_o = a == 6'b011001;
  /* ./TIA/TIA.vhd:1080:38  */
  assign n2566_o = din[3:0];
  /* ./TIA/TIA.vhd:1079:21  */
  assign n2568_o = a == 6'b011010;
  /* ./TIA/TIA.vhd:1082:40  */
  assign n2569_o = din[1];
  /* ./TIA/TIA.vhd:1081:21  */
  assign n2571_o = a == 6'b101000;
  /* ./TIA/TIA.vhd:1084:40  */
  assign n2572_o = din[1];
  /* ./TIA/TIA.vhd:1083:21  */
  assign n2574_o = a == 6'b101001;
  assign n2575_o = {n2574_o, n2571_o, n2568_o, n2565_o, n2562_o, n2559_o, n2556_o, n2553_o, n2550_o, n2547_o, n2544_o, n2541_o, n2538_o, n2535_o, n2533_o, n2531_o, n2528_o, n2525_o, n2522_o, n2519_o, n2516_o, n2513_o, n2510_o, n2507_o, n2505_o, n2501_o, n2497_o, n2491_o, n2489_o, n2487_o, n2484_o, n2479_o};
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2576_o = n3109_q;
      32'b01000000000000000000000000000000: n2576_o = n3109_q;
      32'b00100000000000000000000000000000: n2576_o = n3109_q;
      32'b00010000000000000000000000000000: n2576_o = n3109_q;
      32'b00001000000000000000000000000000: n2576_o = n3109_q;
      32'b00000100000000000000000000000000: n2576_o = n3109_q;
      32'b00000010000000000000000000000000: n2576_o = n3109_q;
      32'b00000001000000000000000000000000: n2576_o = n3109_q;
      32'b00000000100000000000000000000000: n2576_o = n3109_q;
      32'b00000000010000000000000000000000: n2576_o = n3109_q;
      32'b00000000001000000000000000000000: n2576_o = n3109_q;
      32'b00000000000100000000000000000000: n2576_o = n3109_q;
      32'b00000000000010000000000000000000: n2576_o = n3109_q;
      32'b00000000000001000000000000000000: n2576_o = n3109_q;
      32'b00000000000000100000000000000000: n2576_o = n3109_q;
      32'b00000000000000010000000000000000: n2576_o = n3109_q;
      32'b00000000000000001000000000000000: n2576_o = n3109_q;
      32'b00000000000000000100000000000000: n2576_o = n3109_q;
      32'b00000000000000000010000000000000: n2576_o = n3109_q;
      32'b00000000000000000001000000000000: n2576_o = n3109_q;
      32'b00000000000000000000100000000000: n2576_o = n3109_q;
      32'b00000000000000000000010000000000: n2576_o = n3109_q;
      32'b00000000000000000000001000000000: n2576_o = n3109_q;
      32'b00000000000000000000000100000000: n2576_o = n3109_q;
      32'b00000000000000000000000010000000: n2576_o = n3109_q;
      32'b00000000000000000000000001000000: n2576_o = n3109_q;
      32'b00000000000000000000000000100000: n2576_o = n3109_q;
      32'b00000000000000000000000000010000: n2576_o = n3109_q;
      32'b00000000000000000000000000001000: n2576_o = n3109_q;
      32'b00000000000000000000000000000100: n2576_o = n3109_q;
      32'b00000000000000000000000000000010: n2576_o = n2480_o;
      32'b00000000000000000000000000000001: n2576_o = n3109_q;
      default: n2576_o = n3109_q;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2577_o = p0_nusiz;
      32'b01000000000000000000000000000000: n2577_o = p0_nusiz;
      32'b00100000000000000000000000000000: n2577_o = p0_nusiz;
      32'b00010000000000000000000000000000: n2577_o = p0_nusiz;
      32'b00001000000000000000000000000000: n2577_o = p0_nusiz;
      32'b00000100000000000000000000000000: n2577_o = p0_nusiz;
      32'b00000010000000000000000000000000: n2577_o = p0_nusiz;
      32'b00000001000000000000000000000000: n2577_o = p0_nusiz;
      32'b00000000100000000000000000000000: n2577_o = p0_nusiz;
      32'b00000000010000000000000000000000: n2577_o = p0_nusiz;
      32'b00000000001000000000000000000000: n2577_o = p0_nusiz;
      32'b00000000000100000000000000000000: n2577_o = p0_nusiz;
      32'b00000000000010000000000000000000: n2577_o = p0_nusiz;
      32'b00000000000001000000000000000000: n2577_o = p0_nusiz;
      32'b00000000000000100000000000000000: n2577_o = p0_nusiz;
      32'b00000000000000010000000000000000: n2577_o = p0_nusiz;
      32'b00000000000000001000000000000000: n2577_o = p0_nusiz;
      32'b00000000000000000100000000000000: n2577_o = p0_nusiz;
      32'b00000000000000000010000000000000: n2577_o = p0_nusiz;
      32'b00000000000000000001000000000000: n2577_o = p0_nusiz;
      32'b00000000000000000000100000000000: n2577_o = p0_nusiz;
      32'b00000000000000000000010000000000: n2577_o = p0_nusiz;
      32'b00000000000000000000001000000000: n2577_o = p0_nusiz;
      32'b00000000000000000000000100000000: n2577_o = p0_nusiz;
      32'b00000000000000000000000010000000: n2577_o = p0_nusiz;
      32'b00000000000000000000000001000000: n2577_o = n2498_o;
      32'b00000000000000000000000000100000: n2577_o = p0_nusiz;
      32'b00000000000000000000000000010000: n2577_o = p0_nusiz;
      32'b00000000000000000000000000001000: n2577_o = p0_nusiz;
      32'b00000000000000000000000000000100: n2577_o = p0_nusiz;
      32'b00000000000000000000000000000010: n2577_o = p0_nusiz;
      32'b00000000000000000000000000000001: n2577_o = p0_nusiz;
      default: n2577_o = p0_nusiz;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2578_o = p0_reflect;
      32'b01000000000000000000000000000000: n2578_o = p0_reflect;
      32'b00100000000000000000000000000000: n2578_o = p0_reflect;
      32'b00010000000000000000000000000000: n2578_o = p0_reflect;
      32'b00001000000000000000000000000000: n2578_o = p0_reflect;
      32'b00000100000000000000000000000000: n2578_o = p0_reflect;
      32'b00000010000000000000000000000000: n2578_o = p0_reflect;
      32'b00000001000000000000000000000000: n2578_o = p0_reflect;
      32'b00000000100000000000000000000000: n2578_o = p0_reflect;
      32'b00000000010000000000000000000000: n2578_o = p0_reflect;
      32'b00000000001000000000000000000000: n2578_o = p0_reflect;
      32'b00000000000100000000000000000000: n2578_o = p0_reflect;
      32'b00000000000010000000000000000000: n2578_o = n2536_o;
      32'b00000000000001000000000000000000: n2578_o = p0_reflect;
      32'b00000000000000100000000000000000: n2578_o = p0_reflect;
      32'b00000000000000010000000000000000: n2578_o = p0_reflect;
      32'b00000000000000001000000000000000: n2578_o = p0_reflect;
      32'b00000000000000000100000000000000: n2578_o = p0_reflect;
      32'b00000000000000000010000000000000: n2578_o = p0_reflect;
      32'b00000000000000000001000000000000: n2578_o = p0_reflect;
      32'b00000000000000000000100000000000: n2578_o = p0_reflect;
      32'b00000000000000000000010000000000: n2578_o = p0_reflect;
      32'b00000000000000000000001000000000: n2578_o = p0_reflect;
      32'b00000000000000000000000100000000: n2578_o = p0_reflect;
      32'b00000000000000000000000010000000: n2578_o = p0_reflect;
      32'b00000000000000000000000001000000: n2578_o = p0_reflect;
      32'b00000000000000000000000000100000: n2578_o = p0_reflect;
      32'b00000000000000000000000000010000: n2578_o = p0_reflect;
      32'b00000000000000000000000000001000: n2578_o = p0_reflect;
      32'b00000000000000000000000000000100: n2578_o = p0_reflect;
      32'b00000000000000000000000000000010: n2578_o = p0_reflect;
      32'b00000000000000000000000000000001: n2578_o = p0_reflect;
      default: n2578_o = p0_reflect;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2579_o = p0_grpnew;
      32'b01000000000000000000000000000000: n2579_o = p0_grpnew;
      32'b00100000000000000000000000000000: n2579_o = p0_grpnew;
      32'b00010000000000000000000000000000: n2579_o = p0_grpnew;
      32'b00001000000000000000000000000000: n2579_o = p0_grpnew;
      32'b00000100000000000000000000000000: n2579_o = p0_grpnew;
      32'b00000010000000000000000000000000: n2579_o = p0_grpnew;
      32'b00000001000000000000000000000000: n2579_o = p0_grpnew;
      32'b00000000100000000000000000000000: n2579_o = p0_grpnew;
      32'b00000000010000000000000000000000: n2579_o = p0_grpnew;
      32'b00000000001000000000000000000000: n2579_o = p0_grpnew;
      32'b00000000000100000000000000000000: n2579_o = p0_grpnew;
      32'b00000000000010000000000000000000: n2579_o = p0_grpnew;
      32'b00000000000001000000000000000000: n2579_o = p0_grpnew;
      32'b00000000000000100000000000000000: n2579_o = din;
      32'b00000000000000010000000000000000: n2579_o = p0_grpnew;
      32'b00000000000000001000000000000000: n2579_o = p0_grpnew;
      32'b00000000000000000100000000000000: n2579_o = p0_grpnew;
      32'b00000000000000000010000000000000: n2579_o = p0_grpnew;
      32'b00000000000000000001000000000000: n2579_o = p0_grpnew;
      32'b00000000000000000000100000000000: n2579_o = p0_grpnew;
      32'b00000000000000000000010000000000: n2579_o = p0_grpnew;
      32'b00000000000000000000001000000000: n2579_o = p0_grpnew;
      32'b00000000000000000000000100000000: n2579_o = p0_grpnew;
      32'b00000000000000000000000010000000: n2579_o = p0_grpnew;
      32'b00000000000000000000000001000000: n2579_o = p0_grpnew;
      32'b00000000000000000000000000100000: n2579_o = p0_grpnew;
      32'b00000000000000000000000000010000: n2579_o = p0_grpnew;
      32'b00000000000000000000000000001000: n2579_o = p0_grpnew;
      32'b00000000000000000000000000000100: n2579_o = p0_grpnew;
      32'b00000000000000000000000000000010: n2579_o = p0_grpnew;
      32'b00000000000000000000000000000001: n2579_o = p0_grpnew;
      default: n2579_o = p0_grpnew;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2580_o = p0_grpold;
      32'b01000000000000000000000000000000: n2580_o = p0_grpold;
      32'b00100000000000000000000000000000: n2580_o = p0_grpold;
      32'b00010000000000000000000000000000: n2580_o = p0_grpold;
      32'b00001000000000000000000000000000: n2580_o = p0_grpold;
      32'b00000100000000000000000000000000: n2580_o = p0_grpold;
      32'b00000010000000000000000000000000: n2580_o = p0_grpold;
      32'b00000001000000000000000000000000: n2580_o = p0_grpold;
      32'b00000000100000000000000000000000: n2580_o = p0_grpold;
      32'b00000000010000000000000000000000: n2580_o = p0_grpold;
      32'b00000000001000000000000000000000: n2580_o = p0_grpold;
      32'b00000000000100000000000000000000: n2580_o = p0_grpold;
      32'b00000000000010000000000000000000: n2580_o = p0_grpold;
      32'b00000000000001000000000000000000: n2580_o = p0_grpnew;
      32'b00000000000000100000000000000000: n2580_o = p0_grpold;
      32'b00000000000000010000000000000000: n2580_o = p0_grpold;
      32'b00000000000000001000000000000000: n2580_o = p0_grpold;
      32'b00000000000000000100000000000000: n2580_o = p0_grpold;
      32'b00000000000000000010000000000000: n2580_o = p0_grpold;
      32'b00000000000000000001000000000000: n2580_o = p0_grpold;
      32'b00000000000000000000100000000000: n2580_o = p0_grpold;
      32'b00000000000000000000010000000000: n2580_o = p0_grpold;
      32'b00000000000000000000001000000000: n2580_o = p0_grpold;
      32'b00000000000000000000000100000000: n2580_o = p0_grpold;
      32'b00000000000000000000000010000000: n2580_o = p0_grpold;
      32'b00000000000000000000000001000000: n2580_o = p0_grpold;
      32'b00000000000000000000000000100000: n2580_o = p0_grpold;
      32'b00000000000000000000000000010000: n2580_o = p0_grpold;
      32'b00000000000000000000000000001000: n2580_o = p0_grpold;
      32'b00000000000000000000000000000100: n2580_o = p0_grpold;
      32'b00000000000000000000000000000010: n2580_o = p0_grpold;
      32'b00000000000000000000000000000001: n2580_o = p0_grpold;
      default: n2580_o = p0_grpold;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2581_o = p0_vdel;
      32'b01000000000000000000000000000000: n2581_o = p0_vdel;
      32'b00100000000000000000000000000000: n2581_o = p0_vdel;
      32'b00010000000000000000000000000000: n2581_o = p0_vdel;
      32'b00001000000000000000000000000000: n2581_o = p0_vdel;
      32'b00000100000000000000000000000000: n2581_o = p0_vdel;
      32'b00000010000000000000000000000000: n2581_o = p0_vdel;
      32'b00000001000000000000000000000000: n2581_o = p0_vdel;
      32'b00000000100000000000000000000000: n2581_o = p0_vdel;
      32'b00000000010000000000000000000000: n2581_o = p0_vdel;
      32'b00000000001000000000000000000000: n2581_o = n2542_o;
      32'b00000000000100000000000000000000: n2581_o = p0_vdel;
      32'b00000000000010000000000000000000: n2581_o = p0_vdel;
      32'b00000000000001000000000000000000: n2581_o = p0_vdel;
      32'b00000000000000100000000000000000: n2581_o = p0_vdel;
      32'b00000000000000010000000000000000: n2581_o = p0_vdel;
      32'b00000000000000001000000000000000: n2581_o = p0_vdel;
      32'b00000000000000000100000000000000: n2581_o = p0_vdel;
      32'b00000000000000000010000000000000: n2581_o = p0_vdel;
      32'b00000000000000000001000000000000: n2581_o = p0_vdel;
      32'b00000000000000000000100000000000: n2581_o = p0_vdel;
      32'b00000000000000000000010000000000: n2581_o = p0_vdel;
      32'b00000000000000000000001000000000: n2581_o = p0_vdel;
      32'b00000000000000000000000100000000: n2581_o = p0_vdel;
      32'b00000000000000000000000010000000: n2581_o = p0_vdel;
      32'b00000000000000000000000001000000: n2581_o = p0_vdel;
      32'b00000000000000000000000000100000: n2581_o = p0_vdel;
      32'b00000000000000000000000000010000: n2581_o = p0_vdel;
      32'b00000000000000000000000000001000: n2581_o = p0_vdel;
      32'b00000000000000000000000000000100: n2581_o = p0_vdel;
      32'b00000000000000000000000000000010: n2581_o = p0_vdel;
      32'b00000000000000000000000000000001: n2581_o = p0_vdel;
      default: n2581_o = p0_vdel;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2583_o = p0_hmove;
      32'b01000000000000000000000000000000: n2583_o = p0_hmove;
      32'b00100000000000000000000000000000: n2583_o = p0_hmove;
      32'b00010000000000000000000000000000: n2583_o = p0_hmove;
      32'b00001000000000000000000000000000: n2583_o = p0_hmove;
      32'b00000100000000000000000000000000: n2583_o = p0_hmove;
      32'b00000010000000000000000000000000: n2583_o = p0_hmove;
      32'b00000001000000000000000000000000: n2583_o = p0_hmove;
      32'b00000000100000000000000000000000: n2583_o = p0_hmove;
      32'b00000000010000000000000000000000: n2583_o = p0_hmove;
      32'b00000000001000000000000000000000: n2583_o = p0_hmove;
      32'b00000000000100000000000000000000: n2583_o = p0_hmove;
      32'b00000000000010000000000000000000: n2583_o = p0_hmove;
      32'b00000000000001000000000000000000: n2583_o = p0_hmove;
      32'b00000000000000100000000000000000: n2583_o = p0_hmove;
      32'b00000000000000010000000000000000: n2583_o = p0_hmove;
      32'b00000000000000001000000000000000: n2583_o = p0_hmove;
      32'b00000000000000000100000000000000: n2583_o = p0_hmove;
      32'b00000000000000000010000000000000: n2583_o = p0_hmove;
      32'b00000000000000000001000000000000: n2583_o = p0_hmove;
      32'b00000000000000000000100000000000: n2583_o = p0_hmove;
      32'b00000000000000000000010000000000: n2583_o = p0_hmove;
      32'b00000000000000000000001000000000: n2583_o = n2508_o;
      32'b00000000000000000000000100000000: n2583_o = 4'b0000;
      32'b00000000000000000000000010000000: n2583_o = p0_hmove;
      32'b00000000000000000000000001000000: n2583_o = p0_hmove;
      32'b00000000000000000000000000100000: n2583_o = p0_hmove;
      32'b00000000000000000000000000010000: n2583_o = p0_hmove;
      32'b00000000000000000000000000001000: n2583_o = p0_hmove;
      32'b00000000000000000000000000000100: n2583_o = p0_hmove;
      32'b00000000000000000000000000000010: n2583_o = p0_hmove;
      32'b00000000000000000000000000000001: n2583_o = p0_hmove;
      default: n2583_o = p0_hmove;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2584_o = p1_nusiz;
      32'b01000000000000000000000000000000: n2584_o = p1_nusiz;
      32'b00100000000000000000000000000000: n2584_o = p1_nusiz;
      32'b00010000000000000000000000000000: n2584_o = p1_nusiz;
      32'b00001000000000000000000000000000: n2584_o = p1_nusiz;
      32'b00000100000000000000000000000000: n2584_o = p1_nusiz;
      32'b00000010000000000000000000000000: n2584_o = p1_nusiz;
      32'b00000001000000000000000000000000: n2584_o = p1_nusiz;
      32'b00000000100000000000000000000000: n2584_o = p1_nusiz;
      32'b00000000010000000000000000000000: n2584_o = p1_nusiz;
      32'b00000000001000000000000000000000: n2584_o = p1_nusiz;
      32'b00000000000100000000000000000000: n2584_o = p1_nusiz;
      32'b00000000000010000000000000000000: n2584_o = p1_nusiz;
      32'b00000000000001000000000000000000: n2584_o = p1_nusiz;
      32'b00000000000000100000000000000000: n2584_o = p1_nusiz;
      32'b00000000000000010000000000000000: n2584_o = p1_nusiz;
      32'b00000000000000001000000000000000: n2584_o = p1_nusiz;
      32'b00000000000000000100000000000000: n2584_o = p1_nusiz;
      32'b00000000000000000010000000000000: n2584_o = p1_nusiz;
      32'b00000000000000000001000000000000: n2584_o = p1_nusiz;
      32'b00000000000000000000100000000000: n2584_o = p1_nusiz;
      32'b00000000000000000000010000000000: n2584_o = p1_nusiz;
      32'b00000000000000000000001000000000: n2584_o = p1_nusiz;
      32'b00000000000000000000000100000000: n2584_o = p1_nusiz;
      32'b00000000000000000000000010000000: n2584_o = n2502_o;
      32'b00000000000000000000000001000000: n2584_o = p1_nusiz;
      32'b00000000000000000000000000100000: n2584_o = p1_nusiz;
      32'b00000000000000000000000000010000: n2584_o = p1_nusiz;
      32'b00000000000000000000000000001000: n2584_o = p1_nusiz;
      32'b00000000000000000000000000000100: n2584_o = p1_nusiz;
      32'b00000000000000000000000000000010: n2584_o = p1_nusiz;
      32'b00000000000000000000000000000001: n2584_o = p1_nusiz;
      default: n2584_o = p1_nusiz;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2585_o = p1_reflect;
      32'b01000000000000000000000000000000: n2585_o = p1_reflect;
      32'b00100000000000000000000000000000: n2585_o = p1_reflect;
      32'b00010000000000000000000000000000: n2585_o = p1_reflect;
      32'b00001000000000000000000000000000: n2585_o = p1_reflect;
      32'b00000100000000000000000000000000: n2585_o = p1_reflect;
      32'b00000010000000000000000000000000: n2585_o = p1_reflect;
      32'b00000001000000000000000000000000: n2585_o = p1_reflect;
      32'b00000000100000000000000000000000: n2585_o = p1_reflect;
      32'b00000000010000000000000000000000: n2585_o = p1_reflect;
      32'b00000000001000000000000000000000: n2585_o = p1_reflect;
      32'b00000000000100000000000000000000: n2585_o = n2539_o;
      32'b00000000000010000000000000000000: n2585_o = p1_reflect;
      32'b00000000000001000000000000000000: n2585_o = p1_reflect;
      32'b00000000000000100000000000000000: n2585_o = p1_reflect;
      32'b00000000000000010000000000000000: n2585_o = p1_reflect;
      32'b00000000000000001000000000000000: n2585_o = p1_reflect;
      32'b00000000000000000100000000000000: n2585_o = p1_reflect;
      32'b00000000000000000010000000000000: n2585_o = p1_reflect;
      32'b00000000000000000001000000000000: n2585_o = p1_reflect;
      32'b00000000000000000000100000000000: n2585_o = p1_reflect;
      32'b00000000000000000000010000000000: n2585_o = p1_reflect;
      32'b00000000000000000000001000000000: n2585_o = p1_reflect;
      32'b00000000000000000000000100000000: n2585_o = p1_reflect;
      32'b00000000000000000000000010000000: n2585_o = p1_reflect;
      32'b00000000000000000000000001000000: n2585_o = p1_reflect;
      32'b00000000000000000000000000100000: n2585_o = p1_reflect;
      32'b00000000000000000000000000010000: n2585_o = p1_reflect;
      32'b00000000000000000000000000001000: n2585_o = p1_reflect;
      32'b00000000000000000000000000000100: n2585_o = p1_reflect;
      32'b00000000000000000000000000000010: n2585_o = p1_reflect;
      32'b00000000000000000000000000000001: n2585_o = p1_reflect;
      default: n2585_o = p1_reflect;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2586_o = p1_grpnew;
      32'b01000000000000000000000000000000: n2586_o = p1_grpnew;
      32'b00100000000000000000000000000000: n2586_o = p1_grpnew;
      32'b00010000000000000000000000000000: n2586_o = p1_grpnew;
      32'b00001000000000000000000000000000: n2586_o = p1_grpnew;
      32'b00000100000000000000000000000000: n2586_o = p1_grpnew;
      32'b00000010000000000000000000000000: n2586_o = p1_grpnew;
      32'b00000001000000000000000000000000: n2586_o = p1_grpnew;
      32'b00000000100000000000000000000000: n2586_o = p1_grpnew;
      32'b00000000010000000000000000000000: n2586_o = p1_grpnew;
      32'b00000000001000000000000000000000: n2586_o = p1_grpnew;
      32'b00000000000100000000000000000000: n2586_o = p1_grpnew;
      32'b00000000000010000000000000000000: n2586_o = p1_grpnew;
      32'b00000000000001000000000000000000: n2586_o = din;
      32'b00000000000000100000000000000000: n2586_o = p1_grpnew;
      32'b00000000000000010000000000000000: n2586_o = p1_grpnew;
      32'b00000000000000001000000000000000: n2586_o = p1_grpnew;
      32'b00000000000000000100000000000000: n2586_o = p1_grpnew;
      32'b00000000000000000010000000000000: n2586_o = p1_grpnew;
      32'b00000000000000000001000000000000: n2586_o = p1_grpnew;
      32'b00000000000000000000100000000000: n2586_o = p1_grpnew;
      32'b00000000000000000000010000000000: n2586_o = p1_grpnew;
      32'b00000000000000000000001000000000: n2586_o = p1_grpnew;
      32'b00000000000000000000000100000000: n2586_o = p1_grpnew;
      32'b00000000000000000000000010000000: n2586_o = p1_grpnew;
      32'b00000000000000000000000001000000: n2586_o = p1_grpnew;
      32'b00000000000000000000000000100000: n2586_o = p1_grpnew;
      32'b00000000000000000000000000010000: n2586_o = p1_grpnew;
      32'b00000000000000000000000000001000: n2586_o = p1_grpnew;
      32'b00000000000000000000000000000100: n2586_o = p1_grpnew;
      32'b00000000000000000000000000000010: n2586_o = p1_grpnew;
      32'b00000000000000000000000000000001: n2586_o = p1_grpnew;
      default: n2586_o = p1_grpnew;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2587_o = p1_grpold;
      32'b01000000000000000000000000000000: n2587_o = p1_grpold;
      32'b00100000000000000000000000000000: n2587_o = p1_grpold;
      32'b00010000000000000000000000000000: n2587_o = p1_grpold;
      32'b00001000000000000000000000000000: n2587_o = p1_grpold;
      32'b00000100000000000000000000000000: n2587_o = p1_grpold;
      32'b00000010000000000000000000000000: n2587_o = p1_grpold;
      32'b00000001000000000000000000000000: n2587_o = p1_grpold;
      32'b00000000100000000000000000000000: n2587_o = p1_grpold;
      32'b00000000010000000000000000000000: n2587_o = p1_grpold;
      32'b00000000001000000000000000000000: n2587_o = p1_grpold;
      32'b00000000000100000000000000000000: n2587_o = p1_grpold;
      32'b00000000000010000000000000000000: n2587_o = p1_grpold;
      32'b00000000000001000000000000000000: n2587_o = p1_grpold;
      32'b00000000000000100000000000000000: n2587_o = p1_grpnew;
      32'b00000000000000010000000000000000: n2587_o = p1_grpold;
      32'b00000000000000001000000000000000: n2587_o = p1_grpold;
      32'b00000000000000000100000000000000: n2587_o = p1_grpold;
      32'b00000000000000000010000000000000: n2587_o = p1_grpold;
      32'b00000000000000000001000000000000: n2587_o = p1_grpold;
      32'b00000000000000000000100000000000: n2587_o = p1_grpold;
      32'b00000000000000000000010000000000: n2587_o = p1_grpold;
      32'b00000000000000000000001000000000: n2587_o = p1_grpold;
      32'b00000000000000000000000100000000: n2587_o = p1_grpold;
      32'b00000000000000000000000010000000: n2587_o = p1_grpold;
      32'b00000000000000000000000001000000: n2587_o = p1_grpold;
      32'b00000000000000000000000000100000: n2587_o = p1_grpold;
      32'b00000000000000000000000000010000: n2587_o = p1_grpold;
      32'b00000000000000000000000000001000: n2587_o = p1_grpold;
      32'b00000000000000000000000000000100: n2587_o = p1_grpold;
      32'b00000000000000000000000000000010: n2587_o = p1_grpold;
      32'b00000000000000000000000000000001: n2587_o = p1_grpold;
      default: n2587_o = p1_grpold;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2588_o = p1_vdel;
      32'b01000000000000000000000000000000: n2588_o = p1_vdel;
      32'b00100000000000000000000000000000: n2588_o = p1_vdel;
      32'b00010000000000000000000000000000: n2588_o = p1_vdel;
      32'b00001000000000000000000000000000: n2588_o = p1_vdel;
      32'b00000100000000000000000000000000: n2588_o = p1_vdel;
      32'b00000010000000000000000000000000: n2588_o = p1_vdel;
      32'b00000001000000000000000000000000: n2588_o = p1_vdel;
      32'b00000000100000000000000000000000: n2588_o = p1_vdel;
      32'b00000000010000000000000000000000: n2588_o = n2545_o;
      32'b00000000001000000000000000000000: n2588_o = p1_vdel;
      32'b00000000000100000000000000000000: n2588_o = p1_vdel;
      32'b00000000000010000000000000000000: n2588_o = p1_vdel;
      32'b00000000000001000000000000000000: n2588_o = p1_vdel;
      32'b00000000000000100000000000000000: n2588_o = p1_vdel;
      32'b00000000000000010000000000000000: n2588_o = p1_vdel;
      32'b00000000000000001000000000000000: n2588_o = p1_vdel;
      32'b00000000000000000100000000000000: n2588_o = p1_vdel;
      32'b00000000000000000010000000000000: n2588_o = p1_vdel;
      32'b00000000000000000001000000000000: n2588_o = p1_vdel;
      32'b00000000000000000000100000000000: n2588_o = p1_vdel;
      32'b00000000000000000000010000000000: n2588_o = p1_vdel;
      32'b00000000000000000000001000000000: n2588_o = p1_vdel;
      32'b00000000000000000000000100000000: n2588_o = p1_vdel;
      32'b00000000000000000000000010000000: n2588_o = p1_vdel;
      32'b00000000000000000000000001000000: n2588_o = p1_vdel;
      32'b00000000000000000000000000100000: n2588_o = p1_vdel;
      32'b00000000000000000000000000010000: n2588_o = p1_vdel;
      32'b00000000000000000000000000001000: n2588_o = p1_vdel;
      32'b00000000000000000000000000000100: n2588_o = p1_vdel;
      32'b00000000000000000000000000000010: n2588_o = p1_vdel;
      32'b00000000000000000000000000000001: n2588_o = p1_vdel;
      default: n2588_o = p1_vdel;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2590_o = p1_hmove;
      32'b01000000000000000000000000000000: n2590_o = p1_hmove;
      32'b00100000000000000000000000000000: n2590_o = p1_hmove;
      32'b00010000000000000000000000000000: n2590_o = p1_hmove;
      32'b00001000000000000000000000000000: n2590_o = p1_hmove;
      32'b00000100000000000000000000000000: n2590_o = p1_hmove;
      32'b00000010000000000000000000000000: n2590_o = p1_hmove;
      32'b00000001000000000000000000000000: n2590_o = p1_hmove;
      32'b00000000100000000000000000000000: n2590_o = p1_hmove;
      32'b00000000010000000000000000000000: n2590_o = p1_hmove;
      32'b00000000001000000000000000000000: n2590_o = p1_hmove;
      32'b00000000000100000000000000000000: n2590_o = p1_hmove;
      32'b00000000000010000000000000000000: n2590_o = p1_hmove;
      32'b00000000000001000000000000000000: n2590_o = p1_hmove;
      32'b00000000000000100000000000000000: n2590_o = p1_hmove;
      32'b00000000000000010000000000000000: n2590_o = p1_hmove;
      32'b00000000000000001000000000000000: n2590_o = p1_hmove;
      32'b00000000000000000100000000000000: n2590_o = p1_hmove;
      32'b00000000000000000010000000000000: n2590_o = p1_hmove;
      32'b00000000000000000001000000000000: n2590_o = p1_hmove;
      32'b00000000000000000000100000000000: n2590_o = p1_hmove;
      32'b00000000000000000000010000000000: n2590_o = n2511_o;
      32'b00000000000000000000001000000000: n2590_o = p1_hmove;
      32'b00000000000000000000000100000000: n2590_o = 4'b0000;
      32'b00000000000000000000000010000000: n2590_o = p1_hmove;
      32'b00000000000000000000000001000000: n2590_o = p1_hmove;
      32'b00000000000000000000000000100000: n2590_o = p1_hmove;
      32'b00000000000000000000000000010000: n2590_o = p1_hmove;
      32'b00000000000000000000000000001000: n2590_o = p1_hmove;
      32'b00000000000000000000000000000100: n2590_o = p1_hmove;
      32'b00000000000000000000000000000010: n2590_o = p1_hmove;
      32'b00000000000000000000000000000001: n2590_o = p1_hmove;
      default: n2590_o = p1_hmove;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2591_o = m0_enable;
      32'b01000000000000000000000000000000: n2591_o = m0_enable;
      32'b00100000000000000000000000000000: n2591_o = m0_enable;
      32'b00010000000000000000000000000000: n2591_o = m0_enable;
      32'b00001000000000000000000000000000: n2591_o = m0_enable;
      32'b00000100000000000000000000000000: n2591_o = m0_enable;
      32'b00000010000000000000000000000000: n2591_o = m0_enable;
      32'b00000001000000000000000000000000: n2591_o = m0_enable;
      32'b00000000100000000000000000000000: n2591_o = m0_enable;
      32'b00000000010000000000000000000000: n2591_o = m0_enable;
      32'b00000000001000000000000000000000: n2591_o = m0_enable;
      32'b00000000000100000000000000000000: n2591_o = m0_enable;
      32'b00000000000010000000000000000000: n2591_o = m0_enable;
      32'b00000000000001000000000000000000: n2591_o = m0_enable;
      32'b00000000000000100000000000000000: n2591_o = m0_enable;
      32'b00000000000000010000000000000000: n2591_o = m0_enable;
      32'b00000000000000001000000000000000: n2591_o = m0_enable;
      32'b00000000000000000100000000000000: n2591_o = n2523_o;
      32'b00000000000000000010000000000000: n2591_o = m0_enable;
      32'b00000000000000000001000000000000: n2591_o = m0_enable;
      32'b00000000000000000000100000000000: n2591_o = m0_enable;
      32'b00000000000000000000010000000000: n2591_o = m0_enable;
      32'b00000000000000000000001000000000: n2591_o = m0_enable;
      32'b00000000000000000000000100000000: n2591_o = m0_enable;
      32'b00000000000000000000000010000000: n2591_o = m0_enable;
      32'b00000000000000000000000001000000: n2591_o = m0_enable;
      32'b00000000000000000000000000100000: n2591_o = m0_enable;
      32'b00000000000000000000000000010000: n2591_o = m0_enable;
      32'b00000000000000000000000000001000: n2591_o = m0_enable;
      32'b00000000000000000000000000000100: n2591_o = m0_enable;
      32'b00000000000000000000000000000010: n2591_o = m0_enable;
      32'b00000000000000000000000000000001: n2591_o = m0_enable;
      default: n2591_o = m0_enable;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2592_o = m0_size;
      32'b01000000000000000000000000000000: n2592_o = m0_size;
      32'b00100000000000000000000000000000: n2592_o = m0_size;
      32'b00010000000000000000000000000000: n2592_o = m0_size;
      32'b00001000000000000000000000000000: n2592_o = m0_size;
      32'b00000100000000000000000000000000: n2592_o = m0_size;
      32'b00000010000000000000000000000000: n2592_o = m0_size;
      32'b00000001000000000000000000000000: n2592_o = m0_size;
      32'b00000000100000000000000000000000: n2592_o = m0_size;
      32'b00000000010000000000000000000000: n2592_o = m0_size;
      32'b00000000001000000000000000000000: n2592_o = m0_size;
      32'b00000000000100000000000000000000: n2592_o = m0_size;
      32'b00000000000010000000000000000000: n2592_o = m0_size;
      32'b00000000000001000000000000000000: n2592_o = m0_size;
      32'b00000000000000100000000000000000: n2592_o = m0_size;
      32'b00000000000000010000000000000000: n2592_o = m0_size;
      32'b00000000000000001000000000000000: n2592_o = m0_size;
      32'b00000000000000000100000000000000: n2592_o = m0_size;
      32'b00000000000000000010000000000000: n2592_o = m0_size;
      32'b00000000000000000001000000000000: n2592_o = m0_size;
      32'b00000000000000000000100000000000: n2592_o = m0_size;
      32'b00000000000000000000010000000000: n2592_o = m0_size;
      32'b00000000000000000000001000000000: n2592_o = m0_size;
      32'b00000000000000000000000100000000: n2592_o = m0_size;
      32'b00000000000000000000000010000000: n2592_o = m0_size;
      32'b00000000000000000000000001000000: n2592_o = n2499_o;
      32'b00000000000000000000000000100000: n2592_o = m0_size;
      32'b00000000000000000000000000010000: n2592_o = m0_size;
      32'b00000000000000000000000000001000: n2592_o = m0_size;
      32'b00000000000000000000000000000100: n2592_o = m0_size;
      32'b00000000000000000000000000000010: n2592_o = m0_size;
      32'b00000000000000000000000000000001: n2592_o = m0_size;
      default: n2592_o = m0_size;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2594_o = m0_hmove;
      32'b01000000000000000000000000000000: n2594_o = m0_hmove;
      32'b00100000000000000000000000000000: n2594_o = m0_hmove;
      32'b00010000000000000000000000000000: n2594_o = m0_hmove;
      32'b00001000000000000000000000000000: n2594_o = m0_hmove;
      32'b00000100000000000000000000000000: n2594_o = m0_hmove;
      32'b00000010000000000000000000000000: n2594_o = m0_hmove;
      32'b00000001000000000000000000000000: n2594_o = m0_hmove;
      32'b00000000100000000000000000000000: n2594_o = m0_hmove;
      32'b00000000010000000000000000000000: n2594_o = m0_hmove;
      32'b00000000001000000000000000000000: n2594_o = m0_hmove;
      32'b00000000000100000000000000000000: n2594_o = m0_hmove;
      32'b00000000000010000000000000000000: n2594_o = m0_hmove;
      32'b00000000000001000000000000000000: n2594_o = m0_hmove;
      32'b00000000000000100000000000000000: n2594_o = m0_hmove;
      32'b00000000000000010000000000000000: n2594_o = m0_hmove;
      32'b00000000000000001000000000000000: n2594_o = m0_hmove;
      32'b00000000000000000100000000000000: n2594_o = m0_hmove;
      32'b00000000000000000010000000000000: n2594_o = m0_hmove;
      32'b00000000000000000001000000000000: n2594_o = m0_hmove;
      32'b00000000000000000000100000000000: n2594_o = n2514_o;
      32'b00000000000000000000010000000000: n2594_o = m0_hmove;
      32'b00000000000000000000001000000000: n2594_o = m0_hmove;
      32'b00000000000000000000000100000000: n2594_o = 4'b0000;
      32'b00000000000000000000000010000000: n2594_o = m0_hmove;
      32'b00000000000000000000000001000000: n2594_o = m0_hmove;
      32'b00000000000000000000000000100000: n2594_o = m0_hmove;
      32'b00000000000000000000000000010000: n2594_o = m0_hmove;
      32'b00000000000000000000000000001000: n2594_o = m0_hmove;
      32'b00000000000000000000000000000100: n2594_o = m0_hmove;
      32'b00000000000000000000000000000010: n2594_o = m0_hmove;
      32'b00000000000000000000000000000001: n2594_o = m0_hmove;
      default: n2594_o = m0_hmove;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2595_o = m0_resp0;
      32'b01000000000000000000000000000000: n2595_o = n2569_o;
      32'b00100000000000000000000000000000: n2595_o = m0_resp0;
      32'b00010000000000000000000000000000: n2595_o = m0_resp0;
      32'b00001000000000000000000000000000: n2595_o = m0_resp0;
      32'b00000100000000000000000000000000: n2595_o = m0_resp0;
      32'b00000010000000000000000000000000: n2595_o = m0_resp0;
      32'b00000001000000000000000000000000: n2595_o = m0_resp0;
      32'b00000000100000000000000000000000: n2595_o = m0_resp0;
      32'b00000000010000000000000000000000: n2595_o = m0_resp0;
      32'b00000000001000000000000000000000: n2595_o = m0_resp0;
      32'b00000000000100000000000000000000: n2595_o = m0_resp0;
      32'b00000000000010000000000000000000: n2595_o = m0_resp0;
      32'b00000000000001000000000000000000: n2595_o = m0_resp0;
      32'b00000000000000100000000000000000: n2595_o = m0_resp0;
      32'b00000000000000010000000000000000: n2595_o = m0_resp0;
      32'b00000000000000001000000000000000: n2595_o = m0_resp0;
      32'b00000000000000000100000000000000: n2595_o = m0_resp0;
      32'b00000000000000000010000000000000: n2595_o = m0_resp0;
      32'b00000000000000000001000000000000: n2595_o = m0_resp0;
      32'b00000000000000000000100000000000: n2595_o = m0_resp0;
      32'b00000000000000000000010000000000: n2595_o = m0_resp0;
      32'b00000000000000000000001000000000: n2595_o = m0_resp0;
      32'b00000000000000000000000100000000: n2595_o = m0_resp0;
      32'b00000000000000000000000010000000: n2595_o = m0_resp0;
      32'b00000000000000000000000001000000: n2595_o = m0_resp0;
      32'b00000000000000000000000000100000: n2595_o = m0_resp0;
      32'b00000000000000000000000000010000: n2595_o = m0_resp0;
      32'b00000000000000000000000000001000: n2595_o = m0_resp0;
      32'b00000000000000000000000000000100: n2595_o = m0_resp0;
      32'b00000000000000000000000000000010: n2595_o = m0_resp0;
      32'b00000000000000000000000000000001: n2595_o = m0_resp0;
      default: n2595_o = m0_resp0;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2596_o = m1_enable;
      32'b01000000000000000000000000000000: n2596_o = m1_enable;
      32'b00100000000000000000000000000000: n2596_o = m1_enable;
      32'b00010000000000000000000000000000: n2596_o = m1_enable;
      32'b00001000000000000000000000000000: n2596_o = m1_enable;
      32'b00000100000000000000000000000000: n2596_o = m1_enable;
      32'b00000010000000000000000000000000: n2596_o = m1_enable;
      32'b00000001000000000000000000000000: n2596_o = m1_enable;
      32'b00000000100000000000000000000000: n2596_o = m1_enable;
      32'b00000000010000000000000000000000: n2596_o = m1_enable;
      32'b00000000001000000000000000000000: n2596_o = m1_enable;
      32'b00000000000100000000000000000000: n2596_o = m1_enable;
      32'b00000000000010000000000000000000: n2596_o = m1_enable;
      32'b00000000000001000000000000000000: n2596_o = m1_enable;
      32'b00000000000000100000000000000000: n2596_o = m1_enable;
      32'b00000000000000010000000000000000: n2596_o = m1_enable;
      32'b00000000000000001000000000000000: n2596_o = n2526_o;
      32'b00000000000000000100000000000000: n2596_o = m1_enable;
      32'b00000000000000000010000000000000: n2596_o = m1_enable;
      32'b00000000000000000001000000000000: n2596_o = m1_enable;
      32'b00000000000000000000100000000000: n2596_o = m1_enable;
      32'b00000000000000000000010000000000: n2596_o = m1_enable;
      32'b00000000000000000000001000000000: n2596_o = m1_enable;
      32'b00000000000000000000000100000000: n2596_o = m1_enable;
      32'b00000000000000000000000010000000: n2596_o = m1_enable;
      32'b00000000000000000000000001000000: n2596_o = m1_enable;
      32'b00000000000000000000000000100000: n2596_o = m1_enable;
      32'b00000000000000000000000000010000: n2596_o = m1_enable;
      32'b00000000000000000000000000001000: n2596_o = m1_enable;
      32'b00000000000000000000000000000100: n2596_o = m1_enable;
      32'b00000000000000000000000000000010: n2596_o = m1_enable;
      32'b00000000000000000000000000000001: n2596_o = m1_enable;
      default: n2596_o = m1_enable;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2597_o = m1_size;
      32'b01000000000000000000000000000000: n2597_o = m1_size;
      32'b00100000000000000000000000000000: n2597_o = m1_size;
      32'b00010000000000000000000000000000: n2597_o = m1_size;
      32'b00001000000000000000000000000000: n2597_o = m1_size;
      32'b00000100000000000000000000000000: n2597_o = m1_size;
      32'b00000010000000000000000000000000: n2597_o = m1_size;
      32'b00000001000000000000000000000000: n2597_o = m1_size;
      32'b00000000100000000000000000000000: n2597_o = m1_size;
      32'b00000000010000000000000000000000: n2597_o = m1_size;
      32'b00000000001000000000000000000000: n2597_o = m1_size;
      32'b00000000000100000000000000000000: n2597_o = m1_size;
      32'b00000000000010000000000000000000: n2597_o = m1_size;
      32'b00000000000001000000000000000000: n2597_o = m1_size;
      32'b00000000000000100000000000000000: n2597_o = m1_size;
      32'b00000000000000010000000000000000: n2597_o = m1_size;
      32'b00000000000000001000000000000000: n2597_o = m1_size;
      32'b00000000000000000100000000000000: n2597_o = m1_size;
      32'b00000000000000000010000000000000: n2597_o = m1_size;
      32'b00000000000000000001000000000000: n2597_o = m1_size;
      32'b00000000000000000000100000000000: n2597_o = m1_size;
      32'b00000000000000000000010000000000: n2597_o = m1_size;
      32'b00000000000000000000001000000000: n2597_o = m1_size;
      32'b00000000000000000000000100000000: n2597_o = m1_size;
      32'b00000000000000000000000010000000: n2597_o = n2503_o;
      32'b00000000000000000000000001000000: n2597_o = m1_size;
      32'b00000000000000000000000000100000: n2597_o = m1_size;
      32'b00000000000000000000000000010000: n2597_o = m1_size;
      32'b00000000000000000000000000001000: n2597_o = m1_size;
      32'b00000000000000000000000000000100: n2597_o = m1_size;
      32'b00000000000000000000000000000010: n2597_o = m1_size;
      32'b00000000000000000000000000000001: n2597_o = m1_size;
      default: n2597_o = m1_size;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2599_o = m1_hmove;
      32'b01000000000000000000000000000000: n2599_o = m1_hmove;
      32'b00100000000000000000000000000000: n2599_o = m1_hmove;
      32'b00010000000000000000000000000000: n2599_o = m1_hmove;
      32'b00001000000000000000000000000000: n2599_o = m1_hmove;
      32'b00000100000000000000000000000000: n2599_o = m1_hmove;
      32'b00000010000000000000000000000000: n2599_o = m1_hmove;
      32'b00000001000000000000000000000000: n2599_o = m1_hmove;
      32'b00000000100000000000000000000000: n2599_o = m1_hmove;
      32'b00000000010000000000000000000000: n2599_o = m1_hmove;
      32'b00000000001000000000000000000000: n2599_o = m1_hmove;
      32'b00000000000100000000000000000000: n2599_o = m1_hmove;
      32'b00000000000010000000000000000000: n2599_o = m1_hmove;
      32'b00000000000001000000000000000000: n2599_o = m1_hmove;
      32'b00000000000000100000000000000000: n2599_o = m1_hmove;
      32'b00000000000000010000000000000000: n2599_o = m1_hmove;
      32'b00000000000000001000000000000000: n2599_o = m1_hmove;
      32'b00000000000000000100000000000000: n2599_o = m1_hmove;
      32'b00000000000000000010000000000000: n2599_o = m1_hmove;
      32'b00000000000000000001000000000000: n2599_o = n2517_o;
      32'b00000000000000000000100000000000: n2599_o = m1_hmove;
      32'b00000000000000000000010000000000: n2599_o = m1_hmove;
      32'b00000000000000000000001000000000: n2599_o = m1_hmove;
      32'b00000000000000000000000100000000: n2599_o = 4'b0000;
      32'b00000000000000000000000010000000: n2599_o = m1_hmove;
      32'b00000000000000000000000001000000: n2599_o = m1_hmove;
      32'b00000000000000000000000000100000: n2599_o = m1_hmove;
      32'b00000000000000000000000000010000: n2599_o = m1_hmove;
      32'b00000000000000000000000000001000: n2599_o = m1_hmove;
      32'b00000000000000000000000000000100: n2599_o = m1_hmove;
      32'b00000000000000000000000000000010: n2599_o = m1_hmove;
      32'b00000000000000000000000000000001: n2599_o = m1_hmove;
      default: n2599_o = m1_hmove;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2600_o = n2572_o;
      32'b01000000000000000000000000000000: n2600_o = m1_resp1;
      32'b00100000000000000000000000000000: n2600_o = m1_resp1;
      32'b00010000000000000000000000000000: n2600_o = m1_resp1;
      32'b00001000000000000000000000000000: n2600_o = m1_resp1;
      32'b00000100000000000000000000000000: n2600_o = m1_resp1;
      32'b00000010000000000000000000000000: n2600_o = m1_resp1;
      32'b00000001000000000000000000000000: n2600_o = m1_resp1;
      32'b00000000100000000000000000000000: n2600_o = m1_resp1;
      32'b00000000010000000000000000000000: n2600_o = m1_resp1;
      32'b00000000001000000000000000000000: n2600_o = m1_resp1;
      32'b00000000000100000000000000000000: n2600_o = m1_resp1;
      32'b00000000000010000000000000000000: n2600_o = m1_resp1;
      32'b00000000000001000000000000000000: n2600_o = m1_resp1;
      32'b00000000000000100000000000000000: n2600_o = m1_resp1;
      32'b00000000000000010000000000000000: n2600_o = m1_resp1;
      32'b00000000000000001000000000000000: n2600_o = m1_resp1;
      32'b00000000000000000100000000000000: n2600_o = m1_resp1;
      32'b00000000000000000010000000000000: n2600_o = m1_resp1;
      32'b00000000000000000001000000000000: n2600_o = m1_resp1;
      32'b00000000000000000000100000000000: n2600_o = m1_resp1;
      32'b00000000000000000000010000000000: n2600_o = m1_resp1;
      32'b00000000000000000000001000000000: n2600_o = m1_resp1;
      32'b00000000000000000000000100000000: n2600_o = m1_resp1;
      32'b00000000000000000000000010000000: n2600_o = m1_resp1;
      32'b00000000000000000000000001000000: n2600_o = m1_resp1;
      32'b00000000000000000000000000100000: n2600_o = m1_resp1;
      32'b00000000000000000000000000010000: n2600_o = m1_resp1;
      32'b00000000000000000000000000001000: n2600_o = m1_resp1;
      32'b00000000000000000000000000000100: n2600_o = m1_resp1;
      32'b00000000000000000000000000000010: n2600_o = m1_resp1;
      32'b00000000000000000000000000000001: n2600_o = m1_resp1;
      default: n2600_o = m1_resp1;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2601_o = bl_ennew;
      32'b01000000000000000000000000000000: n2601_o = bl_ennew;
      32'b00100000000000000000000000000000: n2601_o = bl_ennew;
      32'b00010000000000000000000000000000: n2601_o = bl_ennew;
      32'b00001000000000000000000000000000: n2601_o = bl_ennew;
      32'b00000100000000000000000000000000: n2601_o = bl_ennew;
      32'b00000010000000000000000000000000: n2601_o = bl_ennew;
      32'b00000001000000000000000000000000: n2601_o = bl_ennew;
      32'b00000000100000000000000000000000: n2601_o = bl_ennew;
      32'b00000000010000000000000000000000: n2601_o = bl_ennew;
      32'b00000000001000000000000000000000: n2601_o = bl_ennew;
      32'b00000000000100000000000000000000: n2601_o = bl_ennew;
      32'b00000000000010000000000000000000: n2601_o = bl_ennew;
      32'b00000000000001000000000000000000: n2601_o = bl_ennew;
      32'b00000000000000100000000000000000: n2601_o = bl_ennew;
      32'b00000000000000010000000000000000: n2601_o = n2529_o;
      32'b00000000000000001000000000000000: n2601_o = bl_ennew;
      32'b00000000000000000100000000000000: n2601_o = bl_ennew;
      32'b00000000000000000010000000000000: n2601_o = bl_ennew;
      32'b00000000000000000001000000000000: n2601_o = bl_ennew;
      32'b00000000000000000000100000000000: n2601_o = bl_ennew;
      32'b00000000000000000000010000000000: n2601_o = bl_ennew;
      32'b00000000000000000000001000000000: n2601_o = bl_ennew;
      32'b00000000000000000000000100000000: n2601_o = bl_ennew;
      32'b00000000000000000000000010000000: n2601_o = bl_ennew;
      32'b00000000000000000000000001000000: n2601_o = bl_ennew;
      32'b00000000000000000000000000100000: n2601_o = bl_ennew;
      32'b00000000000000000000000000010000: n2601_o = bl_ennew;
      32'b00000000000000000000000000001000: n2601_o = bl_ennew;
      32'b00000000000000000000000000000100: n2601_o = bl_ennew;
      32'b00000000000000000000000000000010: n2601_o = bl_ennew;
      32'b00000000000000000000000000000001: n2601_o = bl_ennew;
      default: n2601_o = bl_ennew;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2602_o = bl_enold;
      32'b01000000000000000000000000000000: n2602_o = bl_enold;
      32'b00100000000000000000000000000000: n2602_o = bl_enold;
      32'b00010000000000000000000000000000: n2602_o = bl_enold;
      32'b00001000000000000000000000000000: n2602_o = bl_enold;
      32'b00000100000000000000000000000000: n2602_o = bl_enold;
      32'b00000010000000000000000000000000: n2602_o = bl_enold;
      32'b00000001000000000000000000000000: n2602_o = bl_enold;
      32'b00000000100000000000000000000000: n2602_o = bl_enold;
      32'b00000000010000000000000000000000: n2602_o = bl_enold;
      32'b00000000001000000000000000000000: n2602_o = bl_enold;
      32'b00000000000100000000000000000000: n2602_o = bl_enold;
      32'b00000000000010000000000000000000: n2602_o = bl_enold;
      32'b00000000000001000000000000000000: n2602_o = bl_ennew;
      32'b00000000000000100000000000000000: n2602_o = bl_enold;
      32'b00000000000000010000000000000000: n2602_o = bl_enold;
      32'b00000000000000001000000000000000: n2602_o = bl_enold;
      32'b00000000000000000100000000000000: n2602_o = bl_enold;
      32'b00000000000000000010000000000000: n2602_o = bl_enold;
      32'b00000000000000000001000000000000: n2602_o = bl_enold;
      32'b00000000000000000000100000000000: n2602_o = bl_enold;
      32'b00000000000000000000010000000000: n2602_o = bl_enold;
      32'b00000000000000000000001000000000: n2602_o = bl_enold;
      32'b00000000000000000000000100000000: n2602_o = bl_enold;
      32'b00000000000000000000000010000000: n2602_o = bl_enold;
      32'b00000000000000000000000001000000: n2602_o = bl_enold;
      32'b00000000000000000000000000100000: n2602_o = bl_enold;
      32'b00000000000000000000000000010000: n2602_o = bl_enold;
      32'b00000000000000000000000000001000: n2602_o = bl_enold;
      32'b00000000000000000000000000000100: n2602_o = bl_enold;
      32'b00000000000000000000000000000010: n2602_o = bl_enold;
      32'b00000000000000000000000000000001: n2602_o = bl_enold;
      default: n2602_o = bl_enold;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2603_o = bl_vdel;
      32'b01000000000000000000000000000000: n2603_o = bl_vdel;
      32'b00100000000000000000000000000000: n2603_o = bl_vdel;
      32'b00010000000000000000000000000000: n2603_o = bl_vdel;
      32'b00001000000000000000000000000000: n2603_o = bl_vdel;
      32'b00000100000000000000000000000000: n2603_o = bl_vdel;
      32'b00000010000000000000000000000000: n2603_o = bl_vdel;
      32'b00000001000000000000000000000000: n2603_o = bl_vdel;
      32'b00000000100000000000000000000000: n2603_o = n2548_o;
      32'b00000000010000000000000000000000: n2603_o = bl_vdel;
      32'b00000000001000000000000000000000: n2603_o = bl_vdel;
      32'b00000000000100000000000000000000: n2603_o = bl_vdel;
      32'b00000000000010000000000000000000: n2603_o = bl_vdel;
      32'b00000000000001000000000000000000: n2603_o = bl_vdel;
      32'b00000000000000100000000000000000: n2603_o = bl_vdel;
      32'b00000000000000010000000000000000: n2603_o = bl_vdel;
      32'b00000000000000001000000000000000: n2603_o = bl_vdel;
      32'b00000000000000000100000000000000: n2603_o = bl_vdel;
      32'b00000000000000000010000000000000: n2603_o = bl_vdel;
      32'b00000000000000000001000000000000: n2603_o = bl_vdel;
      32'b00000000000000000000100000000000: n2603_o = bl_vdel;
      32'b00000000000000000000010000000000: n2603_o = bl_vdel;
      32'b00000000000000000000001000000000: n2603_o = bl_vdel;
      32'b00000000000000000000000100000000: n2603_o = bl_vdel;
      32'b00000000000000000000000010000000: n2603_o = bl_vdel;
      32'b00000000000000000000000001000000: n2603_o = bl_vdel;
      32'b00000000000000000000000000100000: n2603_o = bl_vdel;
      32'b00000000000000000000000000010000: n2603_o = bl_vdel;
      32'b00000000000000000000000000001000: n2603_o = bl_vdel;
      32'b00000000000000000000000000000100: n2603_o = bl_vdel;
      32'b00000000000000000000000000000010: n2603_o = bl_vdel;
      32'b00000000000000000000000000000001: n2603_o = bl_vdel;
      default: n2603_o = bl_vdel;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2604_o = bl_size;
      32'b01000000000000000000000000000000: n2604_o = bl_size;
      32'b00100000000000000000000000000000: n2604_o = bl_size;
      32'b00010000000000000000000000000000: n2604_o = bl_size;
      32'b00001000000000000000000000000000: n2604_o = bl_size;
      32'b00000100000000000000000000000000: n2604_o = bl_size;
      32'b00000010000000000000000000000000: n2604_o = bl_size;
      32'b00000001000000000000000000000000: n2604_o = bl_size;
      32'b00000000100000000000000000000000: n2604_o = bl_size;
      32'b00000000010000000000000000000000: n2604_o = bl_size;
      32'b00000000001000000000000000000000: n2604_o = bl_size;
      32'b00000000000100000000000000000000: n2604_o = bl_size;
      32'b00000000000010000000000000000000: n2604_o = bl_size;
      32'b00000000000001000000000000000000: n2604_o = bl_size;
      32'b00000000000000100000000000000000: n2604_o = bl_size;
      32'b00000000000000010000000000000000: n2604_o = bl_size;
      32'b00000000000000001000000000000000: n2604_o = bl_size;
      32'b00000000000000000100000000000000: n2604_o = bl_size;
      32'b00000000000000000010000000000000: n2604_o = bl_size;
      32'b00000000000000000001000000000000: n2604_o = bl_size;
      32'b00000000000000000000100000000000: n2604_o = bl_size;
      32'b00000000000000000000010000000000: n2604_o = bl_size;
      32'b00000000000000000000001000000000: n2604_o = bl_size;
      32'b00000000000000000000000100000000: n2604_o = bl_size;
      32'b00000000000000000000000010000000: n2604_o = bl_size;
      32'b00000000000000000000000001000000: n2604_o = bl_size;
      32'b00000000000000000000000000100000: n2604_o = n2495_o;
      32'b00000000000000000000000000010000: n2604_o = bl_size;
      32'b00000000000000000000000000001000: n2604_o = bl_size;
      32'b00000000000000000000000000000100: n2604_o = bl_size;
      32'b00000000000000000000000000000010: n2604_o = bl_size;
      32'b00000000000000000000000000000001: n2604_o = bl_size;
      default: n2604_o = bl_size;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2606_o = bl_hmove;
      32'b01000000000000000000000000000000: n2606_o = bl_hmove;
      32'b00100000000000000000000000000000: n2606_o = bl_hmove;
      32'b00010000000000000000000000000000: n2606_o = bl_hmove;
      32'b00001000000000000000000000000000: n2606_o = bl_hmove;
      32'b00000100000000000000000000000000: n2606_o = bl_hmove;
      32'b00000010000000000000000000000000: n2606_o = bl_hmove;
      32'b00000001000000000000000000000000: n2606_o = bl_hmove;
      32'b00000000100000000000000000000000: n2606_o = bl_hmove;
      32'b00000000010000000000000000000000: n2606_o = bl_hmove;
      32'b00000000001000000000000000000000: n2606_o = bl_hmove;
      32'b00000000000100000000000000000000: n2606_o = bl_hmove;
      32'b00000000000010000000000000000000: n2606_o = bl_hmove;
      32'b00000000000001000000000000000000: n2606_o = bl_hmove;
      32'b00000000000000100000000000000000: n2606_o = bl_hmove;
      32'b00000000000000010000000000000000: n2606_o = bl_hmove;
      32'b00000000000000001000000000000000: n2606_o = bl_hmove;
      32'b00000000000000000100000000000000: n2606_o = bl_hmove;
      32'b00000000000000000010000000000000: n2606_o = n2520_o;
      32'b00000000000000000001000000000000: n2606_o = bl_hmove;
      32'b00000000000000000000100000000000: n2606_o = bl_hmove;
      32'b00000000000000000000010000000000: n2606_o = bl_hmove;
      32'b00000000000000000000001000000000: n2606_o = bl_hmove;
      32'b00000000000000000000000100000000: n2606_o = 4'b0000;
      32'b00000000000000000000000010000000: n2606_o = bl_hmove;
      32'b00000000000000000000000001000000: n2606_o = bl_hmove;
      32'b00000000000000000000000000100000: n2606_o = bl_hmove;
      32'b00000000000000000000000000010000: n2606_o = bl_hmove;
      32'b00000000000000000000000000001000: n2606_o = bl_hmove;
      32'b00000000000000000000000000000100: n2606_o = bl_hmove;
      32'b00000000000000000000000000000010: n2606_o = bl_hmove;
      32'b00000000000000000000000000000001: n2606_o = bl_hmove;
      default: n2606_o = bl_hmove;
    endcase
  assign n2607_o = pf_gr[3:0];
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2608_o = n2607_o;
      32'b01000000000000000000000000000000: n2608_o = n2607_o;
      32'b00100000000000000000000000000000: n2608_o = n2607_o;
      32'b00010000000000000000000000000000: n2608_o = n2607_o;
      32'b00001000000000000000000000000000: n2608_o = n2607_o;
      32'b00000100000000000000000000000000: n2608_o = n2607_o;
      32'b00000010000000000000000000000000: n2608_o = n2607_o;
      32'b00000001000000000000000000000000: n2608_o = n2607_o;
      32'b00000000100000000000000000000000: n2608_o = n2607_o;
      32'b00000000010000000000000000000000: n2608_o = n2607_o;
      32'b00000000001000000000000000000000: n2608_o = n2607_o;
      32'b00000000000100000000000000000000: n2608_o = n2607_o;
      32'b00000000000010000000000000000000: n2608_o = n2607_o;
      32'b00000000000001000000000000000000: n2608_o = n2607_o;
      32'b00000000000000100000000000000000: n2608_o = n2607_o;
      32'b00000000000000010000000000000000: n2608_o = n2607_o;
      32'b00000000000000001000000000000000: n2608_o = n2607_o;
      32'b00000000000000000100000000000000: n2608_o = n2607_o;
      32'b00000000000000000010000000000000: n2608_o = n2607_o;
      32'b00000000000000000001000000000000: n2608_o = n2607_o;
      32'b00000000000000000000100000000000: n2608_o = n2607_o;
      32'b00000000000000000000010000000000: n2608_o = n2607_o;
      32'b00000000000000000000001000000000: n2608_o = n2607_o;
      32'b00000000000000000000000100000000: n2608_o = n2607_o;
      32'b00000000000000000000000010000000: n2608_o = n2607_o;
      32'b00000000000000000000000001000000: n2608_o = n2607_o;
      32'b00000000000000000000000000100000: n2608_o = n2607_o;
      32'b00000000000000000000000000010000: n2608_o = n2607_o;
      32'b00000000000000000000000000001000: n2608_o = n2607_o;
      32'b00000000000000000000000000000100: n2608_o = n2485_o;
      32'b00000000000000000000000000000010: n2608_o = n2607_o;
      32'b00000000000000000000000000000001: n2608_o = n2607_o;
      default: n2608_o = n2607_o;
    endcase
  assign n2609_o = pf_gr[11:4];
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2610_o = n2609_o;
      32'b01000000000000000000000000000000: n2610_o = n2609_o;
      32'b00100000000000000000000000000000: n2610_o = n2609_o;
      32'b00010000000000000000000000000000: n2610_o = n2609_o;
      32'b00001000000000000000000000000000: n2610_o = n2609_o;
      32'b00000100000000000000000000000000: n2610_o = n2609_o;
      32'b00000010000000000000000000000000: n2610_o = n2609_o;
      32'b00000001000000000000000000000000: n2610_o = n2609_o;
      32'b00000000100000000000000000000000: n2610_o = n2609_o;
      32'b00000000010000000000000000000000: n2610_o = n2609_o;
      32'b00000000001000000000000000000000: n2610_o = n2609_o;
      32'b00000000000100000000000000000000: n2610_o = n2609_o;
      32'b00000000000010000000000000000000: n2610_o = n2609_o;
      32'b00000000000001000000000000000000: n2610_o = n2609_o;
      32'b00000000000000100000000000000000: n2610_o = n2609_o;
      32'b00000000000000010000000000000000: n2610_o = n2609_o;
      32'b00000000000000001000000000000000: n2610_o = n2609_o;
      32'b00000000000000000100000000000000: n2610_o = n2609_o;
      32'b00000000000000000010000000000000: n2610_o = n2609_o;
      32'b00000000000000000001000000000000: n2610_o = n2609_o;
      32'b00000000000000000000100000000000: n2610_o = n2609_o;
      32'b00000000000000000000010000000000: n2610_o = n2609_o;
      32'b00000000000000000000001000000000: n2610_o = n2609_o;
      32'b00000000000000000000000100000000: n2610_o = n2609_o;
      32'b00000000000000000000000010000000: n2610_o = n2609_o;
      32'b00000000000000000000000001000000: n2610_o = n2609_o;
      32'b00000000000000000000000000100000: n2610_o = n2609_o;
      32'b00000000000000000000000000010000: n2610_o = n2609_o;
      32'b00000000000000000000000000001000: n2610_o = din;
      32'b00000000000000000000000000000100: n2610_o = n2609_o;
      32'b00000000000000000000000000000010: n2610_o = n2609_o;
      32'b00000000000000000000000000000001: n2610_o = n2609_o;
      default: n2610_o = n2609_o;
    endcase
  assign n2611_o = pf_gr[19:12];
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2612_o = n2611_o;
      32'b01000000000000000000000000000000: n2612_o = n2611_o;
      32'b00100000000000000000000000000000: n2612_o = n2611_o;
      32'b00010000000000000000000000000000: n2612_o = n2611_o;
      32'b00001000000000000000000000000000: n2612_o = n2611_o;
      32'b00000100000000000000000000000000: n2612_o = n2611_o;
      32'b00000010000000000000000000000000: n2612_o = n2611_o;
      32'b00000001000000000000000000000000: n2612_o = n2611_o;
      32'b00000000100000000000000000000000: n2612_o = n2611_o;
      32'b00000000010000000000000000000000: n2612_o = n2611_o;
      32'b00000000001000000000000000000000: n2612_o = n2611_o;
      32'b00000000000100000000000000000000: n2612_o = n2611_o;
      32'b00000000000010000000000000000000: n2612_o = n2611_o;
      32'b00000000000001000000000000000000: n2612_o = n2611_o;
      32'b00000000000000100000000000000000: n2612_o = n2611_o;
      32'b00000000000000010000000000000000: n2612_o = n2611_o;
      32'b00000000000000001000000000000000: n2612_o = n2611_o;
      32'b00000000000000000100000000000000: n2612_o = n2611_o;
      32'b00000000000000000010000000000000: n2612_o = n2611_o;
      32'b00000000000000000001000000000000: n2612_o = n2611_o;
      32'b00000000000000000000100000000000: n2612_o = n2611_o;
      32'b00000000000000000000010000000000: n2612_o = n2611_o;
      32'b00000000000000000000001000000000: n2612_o = n2611_o;
      32'b00000000000000000000000100000000: n2612_o = n2611_o;
      32'b00000000000000000000000010000000: n2612_o = n2611_o;
      32'b00000000000000000000000001000000: n2612_o = n2611_o;
      32'b00000000000000000000000000100000: n2612_o = n2611_o;
      32'b00000000000000000000000000010000: n2612_o = din;
      32'b00000000000000000000000000001000: n2612_o = n2611_o;
      32'b00000000000000000000000000000100: n2612_o = n2611_o;
      32'b00000000000000000000000000000010: n2612_o = n2611_o;
      32'b00000000000000000000000000000001: n2612_o = n2611_o;
      default: n2612_o = n2611_o;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2613_o = pf_reflect;
      32'b01000000000000000000000000000000: n2613_o = pf_reflect;
      32'b00100000000000000000000000000000: n2613_o = pf_reflect;
      32'b00010000000000000000000000000000: n2613_o = pf_reflect;
      32'b00001000000000000000000000000000: n2613_o = pf_reflect;
      32'b00000100000000000000000000000000: n2613_o = pf_reflect;
      32'b00000010000000000000000000000000: n2613_o = pf_reflect;
      32'b00000001000000000000000000000000: n2613_o = pf_reflect;
      32'b00000000100000000000000000000000: n2613_o = pf_reflect;
      32'b00000000010000000000000000000000: n2613_o = pf_reflect;
      32'b00000000001000000000000000000000: n2613_o = pf_reflect;
      32'b00000000000100000000000000000000: n2613_o = pf_reflect;
      32'b00000000000010000000000000000000: n2613_o = pf_reflect;
      32'b00000000000001000000000000000000: n2613_o = pf_reflect;
      32'b00000000000000100000000000000000: n2613_o = pf_reflect;
      32'b00000000000000010000000000000000: n2613_o = pf_reflect;
      32'b00000000000000001000000000000000: n2613_o = pf_reflect;
      32'b00000000000000000100000000000000: n2613_o = pf_reflect;
      32'b00000000000000000010000000000000: n2613_o = pf_reflect;
      32'b00000000000000000001000000000000: n2613_o = pf_reflect;
      32'b00000000000000000000100000000000: n2613_o = pf_reflect;
      32'b00000000000000000000010000000000: n2613_o = pf_reflect;
      32'b00000000000000000000001000000000: n2613_o = pf_reflect;
      32'b00000000000000000000000100000000: n2613_o = pf_reflect;
      32'b00000000000000000000000010000000: n2613_o = pf_reflect;
      32'b00000000000000000000000001000000: n2613_o = pf_reflect;
      32'b00000000000000000000000000100000: n2613_o = n2492_o;
      32'b00000000000000000000000000010000: n2613_o = pf_reflect;
      32'b00000000000000000000000000001000: n2613_o = pf_reflect;
      32'b00000000000000000000000000000100: n2613_o = pf_reflect;
      32'b00000000000000000000000000000010: n2613_o = pf_reflect;
      32'b00000000000000000000000000000001: n2613_o = pf_reflect;
      default: n2613_o = pf_reflect;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2614_o = pf_score;
      32'b01000000000000000000000000000000: n2614_o = pf_score;
      32'b00100000000000000000000000000000: n2614_o = pf_score;
      32'b00010000000000000000000000000000: n2614_o = pf_score;
      32'b00001000000000000000000000000000: n2614_o = pf_score;
      32'b00000100000000000000000000000000: n2614_o = pf_score;
      32'b00000010000000000000000000000000: n2614_o = pf_score;
      32'b00000001000000000000000000000000: n2614_o = pf_score;
      32'b00000000100000000000000000000000: n2614_o = pf_score;
      32'b00000000010000000000000000000000: n2614_o = pf_score;
      32'b00000000001000000000000000000000: n2614_o = pf_score;
      32'b00000000000100000000000000000000: n2614_o = pf_score;
      32'b00000000000010000000000000000000: n2614_o = pf_score;
      32'b00000000000001000000000000000000: n2614_o = pf_score;
      32'b00000000000000100000000000000000: n2614_o = pf_score;
      32'b00000000000000010000000000000000: n2614_o = pf_score;
      32'b00000000000000001000000000000000: n2614_o = pf_score;
      32'b00000000000000000100000000000000: n2614_o = pf_score;
      32'b00000000000000000010000000000000: n2614_o = pf_score;
      32'b00000000000000000001000000000000: n2614_o = pf_score;
      32'b00000000000000000000100000000000: n2614_o = pf_score;
      32'b00000000000000000000010000000000: n2614_o = pf_score;
      32'b00000000000000000000001000000000: n2614_o = pf_score;
      32'b00000000000000000000000100000000: n2614_o = pf_score;
      32'b00000000000000000000000010000000: n2614_o = pf_score;
      32'b00000000000000000000000001000000: n2614_o = pf_score;
      32'b00000000000000000000000000100000: n2614_o = n2493_o;
      32'b00000000000000000000000000010000: n2614_o = pf_score;
      32'b00000000000000000000000000001000: n2614_o = pf_score;
      32'b00000000000000000000000000000100: n2614_o = pf_score;
      32'b00000000000000000000000000000010: n2614_o = pf_score;
      32'b00000000000000000000000000000001: n2614_o = pf_score;
      default: n2614_o = pf_score;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2615_o = pf_priority;
      32'b01000000000000000000000000000000: n2615_o = pf_priority;
      32'b00100000000000000000000000000000: n2615_o = pf_priority;
      32'b00010000000000000000000000000000: n2615_o = pf_priority;
      32'b00001000000000000000000000000000: n2615_o = pf_priority;
      32'b00000100000000000000000000000000: n2615_o = pf_priority;
      32'b00000010000000000000000000000000: n2615_o = pf_priority;
      32'b00000001000000000000000000000000: n2615_o = pf_priority;
      32'b00000000100000000000000000000000: n2615_o = pf_priority;
      32'b00000000010000000000000000000000: n2615_o = pf_priority;
      32'b00000000001000000000000000000000: n2615_o = pf_priority;
      32'b00000000000100000000000000000000: n2615_o = pf_priority;
      32'b00000000000010000000000000000000: n2615_o = pf_priority;
      32'b00000000000001000000000000000000: n2615_o = pf_priority;
      32'b00000000000000100000000000000000: n2615_o = pf_priority;
      32'b00000000000000010000000000000000: n2615_o = pf_priority;
      32'b00000000000000001000000000000000: n2615_o = pf_priority;
      32'b00000000000000000100000000000000: n2615_o = pf_priority;
      32'b00000000000000000010000000000000: n2615_o = pf_priority;
      32'b00000000000000000001000000000000: n2615_o = pf_priority;
      32'b00000000000000000000100000000000: n2615_o = pf_priority;
      32'b00000000000000000000010000000000: n2615_o = pf_priority;
      32'b00000000000000000000001000000000: n2615_o = pf_priority;
      32'b00000000000000000000000100000000: n2615_o = pf_priority;
      32'b00000000000000000000000010000000: n2615_o = pf_priority;
      32'b00000000000000000000000001000000: n2615_o = pf_priority;
      32'b00000000000000000000000000100000: n2615_o = n2494_o;
      32'b00000000000000000000000000010000: n2615_o = pf_priority;
      32'b00000000000000000000000000001000: n2615_o = pf_priority;
      32'b00000000000000000000000000000100: n2615_o = pf_priority;
      32'b00000000000000000000000000000010: n2615_o = pf_priority;
      32'b00000000000000000000000000000001: n2615_o = pf_priority;
      default: n2615_o = pf_priority;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2616_o = a0_freq;
      32'b01000000000000000000000000000000: n2616_o = a0_freq;
      32'b00100000000000000000000000000000: n2616_o = a0_freq;
      32'b00010000000000000000000000000000: n2616_o = a0_freq;
      32'b00001000000000000000000000000000: n2616_o = a0_freq;
      32'b00000100000000000000000000000000: n2616_o = a0_freq;
      32'b00000010000000000000000000000000: n2616_o = a0_freq;
      32'b00000001000000000000000000000000: n2616_o = n2551_o;
      32'b00000000100000000000000000000000: n2616_o = a0_freq;
      32'b00000000010000000000000000000000: n2616_o = a0_freq;
      32'b00000000001000000000000000000000: n2616_o = a0_freq;
      32'b00000000000100000000000000000000: n2616_o = a0_freq;
      32'b00000000000010000000000000000000: n2616_o = a0_freq;
      32'b00000000000001000000000000000000: n2616_o = a0_freq;
      32'b00000000000000100000000000000000: n2616_o = a0_freq;
      32'b00000000000000010000000000000000: n2616_o = a0_freq;
      32'b00000000000000001000000000000000: n2616_o = a0_freq;
      32'b00000000000000000100000000000000: n2616_o = a0_freq;
      32'b00000000000000000010000000000000: n2616_o = a0_freq;
      32'b00000000000000000001000000000000: n2616_o = a0_freq;
      32'b00000000000000000000100000000000: n2616_o = a0_freq;
      32'b00000000000000000000010000000000: n2616_o = a0_freq;
      32'b00000000000000000000001000000000: n2616_o = a0_freq;
      32'b00000000000000000000000100000000: n2616_o = a0_freq;
      32'b00000000000000000000000010000000: n2616_o = a0_freq;
      32'b00000000000000000000000001000000: n2616_o = a0_freq;
      32'b00000000000000000000000000100000: n2616_o = a0_freq;
      32'b00000000000000000000000000010000: n2616_o = a0_freq;
      32'b00000000000000000000000000001000: n2616_o = a0_freq;
      32'b00000000000000000000000000000100: n2616_o = a0_freq;
      32'b00000000000000000000000000000010: n2616_o = a0_freq;
      32'b00000000000000000000000000000001: n2616_o = a0_freq;
      default: n2616_o = a0_freq;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2617_o = a0_ctrl;
      32'b01000000000000000000000000000000: n2617_o = a0_ctrl;
      32'b00100000000000000000000000000000: n2617_o = a0_ctrl;
      32'b00010000000000000000000000000000: n2617_o = a0_ctrl;
      32'b00001000000000000000000000000000: n2617_o = a0_ctrl;
      32'b00000100000000000000000000000000: n2617_o = n2557_o;
      32'b00000010000000000000000000000000: n2617_o = a0_ctrl;
      32'b00000001000000000000000000000000: n2617_o = a0_ctrl;
      32'b00000000100000000000000000000000: n2617_o = a0_ctrl;
      32'b00000000010000000000000000000000: n2617_o = a0_ctrl;
      32'b00000000001000000000000000000000: n2617_o = a0_ctrl;
      32'b00000000000100000000000000000000: n2617_o = a0_ctrl;
      32'b00000000000010000000000000000000: n2617_o = a0_ctrl;
      32'b00000000000001000000000000000000: n2617_o = a0_ctrl;
      32'b00000000000000100000000000000000: n2617_o = a0_ctrl;
      32'b00000000000000010000000000000000: n2617_o = a0_ctrl;
      32'b00000000000000001000000000000000: n2617_o = a0_ctrl;
      32'b00000000000000000100000000000000: n2617_o = a0_ctrl;
      32'b00000000000000000010000000000000: n2617_o = a0_ctrl;
      32'b00000000000000000001000000000000: n2617_o = a0_ctrl;
      32'b00000000000000000000100000000000: n2617_o = a0_ctrl;
      32'b00000000000000000000010000000000: n2617_o = a0_ctrl;
      32'b00000000000000000000001000000000: n2617_o = a0_ctrl;
      32'b00000000000000000000000100000000: n2617_o = a0_ctrl;
      32'b00000000000000000000000010000000: n2617_o = a0_ctrl;
      32'b00000000000000000000000001000000: n2617_o = a0_ctrl;
      32'b00000000000000000000000000100000: n2617_o = a0_ctrl;
      32'b00000000000000000000000000010000: n2617_o = a0_ctrl;
      32'b00000000000000000000000000001000: n2617_o = a0_ctrl;
      32'b00000000000000000000000000000100: n2617_o = a0_ctrl;
      32'b00000000000000000000000000000010: n2617_o = a0_ctrl;
      32'b00000000000000000000000000000001: n2617_o = a0_ctrl;
      default: n2617_o = a0_ctrl;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2618_o = a0_vol;
      32'b01000000000000000000000000000000: n2618_o = a0_vol;
      32'b00100000000000000000000000000000: n2618_o = a0_vol;
      32'b00010000000000000000000000000000: n2618_o = n2563_o;
      32'b00001000000000000000000000000000: n2618_o = a0_vol;
      32'b00000100000000000000000000000000: n2618_o = a0_vol;
      32'b00000010000000000000000000000000: n2618_o = a0_vol;
      32'b00000001000000000000000000000000: n2618_o = a0_vol;
      32'b00000000100000000000000000000000: n2618_o = a0_vol;
      32'b00000000010000000000000000000000: n2618_o = a0_vol;
      32'b00000000001000000000000000000000: n2618_o = a0_vol;
      32'b00000000000100000000000000000000: n2618_o = a0_vol;
      32'b00000000000010000000000000000000: n2618_o = a0_vol;
      32'b00000000000001000000000000000000: n2618_o = a0_vol;
      32'b00000000000000100000000000000000: n2618_o = a0_vol;
      32'b00000000000000010000000000000000: n2618_o = a0_vol;
      32'b00000000000000001000000000000000: n2618_o = a0_vol;
      32'b00000000000000000100000000000000: n2618_o = a0_vol;
      32'b00000000000000000010000000000000: n2618_o = a0_vol;
      32'b00000000000000000001000000000000: n2618_o = a0_vol;
      32'b00000000000000000000100000000000: n2618_o = a0_vol;
      32'b00000000000000000000010000000000: n2618_o = a0_vol;
      32'b00000000000000000000001000000000: n2618_o = a0_vol;
      32'b00000000000000000000000100000000: n2618_o = a0_vol;
      32'b00000000000000000000000010000000: n2618_o = a0_vol;
      32'b00000000000000000000000001000000: n2618_o = a0_vol;
      32'b00000000000000000000000000100000: n2618_o = a0_vol;
      32'b00000000000000000000000000010000: n2618_o = a0_vol;
      32'b00000000000000000000000000001000: n2618_o = a0_vol;
      32'b00000000000000000000000000000100: n2618_o = a0_vol;
      32'b00000000000000000000000000000010: n2618_o = a0_vol;
      32'b00000000000000000000000000000001: n2618_o = a0_vol;
      default: n2618_o = a0_vol;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2619_o = a1_freq;
      32'b01000000000000000000000000000000: n2619_o = a1_freq;
      32'b00100000000000000000000000000000: n2619_o = a1_freq;
      32'b00010000000000000000000000000000: n2619_o = a1_freq;
      32'b00001000000000000000000000000000: n2619_o = a1_freq;
      32'b00000100000000000000000000000000: n2619_o = a1_freq;
      32'b00000010000000000000000000000000: n2619_o = n2554_o;
      32'b00000001000000000000000000000000: n2619_o = a1_freq;
      32'b00000000100000000000000000000000: n2619_o = a1_freq;
      32'b00000000010000000000000000000000: n2619_o = a1_freq;
      32'b00000000001000000000000000000000: n2619_o = a1_freq;
      32'b00000000000100000000000000000000: n2619_o = a1_freq;
      32'b00000000000010000000000000000000: n2619_o = a1_freq;
      32'b00000000000001000000000000000000: n2619_o = a1_freq;
      32'b00000000000000100000000000000000: n2619_o = a1_freq;
      32'b00000000000000010000000000000000: n2619_o = a1_freq;
      32'b00000000000000001000000000000000: n2619_o = a1_freq;
      32'b00000000000000000100000000000000: n2619_o = a1_freq;
      32'b00000000000000000010000000000000: n2619_o = a1_freq;
      32'b00000000000000000001000000000000: n2619_o = a1_freq;
      32'b00000000000000000000100000000000: n2619_o = a1_freq;
      32'b00000000000000000000010000000000: n2619_o = a1_freq;
      32'b00000000000000000000001000000000: n2619_o = a1_freq;
      32'b00000000000000000000000100000000: n2619_o = a1_freq;
      32'b00000000000000000000000010000000: n2619_o = a1_freq;
      32'b00000000000000000000000001000000: n2619_o = a1_freq;
      32'b00000000000000000000000000100000: n2619_o = a1_freq;
      32'b00000000000000000000000000010000: n2619_o = a1_freq;
      32'b00000000000000000000000000001000: n2619_o = a1_freq;
      32'b00000000000000000000000000000100: n2619_o = a1_freq;
      32'b00000000000000000000000000000010: n2619_o = a1_freq;
      32'b00000000000000000000000000000001: n2619_o = a1_freq;
      default: n2619_o = a1_freq;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2620_o = a1_ctrl;
      32'b01000000000000000000000000000000: n2620_o = a1_ctrl;
      32'b00100000000000000000000000000000: n2620_o = a1_ctrl;
      32'b00010000000000000000000000000000: n2620_o = a1_ctrl;
      32'b00001000000000000000000000000000: n2620_o = n2560_o;
      32'b00000100000000000000000000000000: n2620_o = a1_ctrl;
      32'b00000010000000000000000000000000: n2620_o = a1_ctrl;
      32'b00000001000000000000000000000000: n2620_o = a1_ctrl;
      32'b00000000100000000000000000000000: n2620_o = a1_ctrl;
      32'b00000000010000000000000000000000: n2620_o = a1_ctrl;
      32'b00000000001000000000000000000000: n2620_o = a1_ctrl;
      32'b00000000000100000000000000000000: n2620_o = a1_ctrl;
      32'b00000000000010000000000000000000: n2620_o = a1_ctrl;
      32'b00000000000001000000000000000000: n2620_o = a1_ctrl;
      32'b00000000000000100000000000000000: n2620_o = a1_ctrl;
      32'b00000000000000010000000000000000: n2620_o = a1_ctrl;
      32'b00000000000000001000000000000000: n2620_o = a1_ctrl;
      32'b00000000000000000100000000000000: n2620_o = a1_ctrl;
      32'b00000000000000000010000000000000: n2620_o = a1_ctrl;
      32'b00000000000000000001000000000000: n2620_o = a1_ctrl;
      32'b00000000000000000000100000000000: n2620_o = a1_ctrl;
      32'b00000000000000000000010000000000: n2620_o = a1_ctrl;
      32'b00000000000000000000001000000000: n2620_o = a1_ctrl;
      32'b00000000000000000000000100000000: n2620_o = a1_ctrl;
      32'b00000000000000000000000010000000: n2620_o = a1_ctrl;
      32'b00000000000000000000000001000000: n2620_o = a1_ctrl;
      32'b00000000000000000000000000100000: n2620_o = a1_ctrl;
      32'b00000000000000000000000000010000: n2620_o = a1_ctrl;
      32'b00000000000000000000000000001000: n2620_o = a1_ctrl;
      32'b00000000000000000000000000000100: n2620_o = a1_ctrl;
      32'b00000000000000000000000000000010: n2620_o = a1_ctrl;
      32'b00000000000000000000000000000001: n2620_o = a1_ctrl;
      default: n2620_o = a1_ctrl;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2621_o = a1_vol;
      32'b01000000000000000000000000000000: n2621_o = a1_vol;
      32'b00100000000000000000000000000000: n2621_o = n2566_o;
      32'b00010000000000000000000000000000: n2621_o = a1_vol;
      32'b00001000000000000000000000000000: n2621_o = a1_vol;
      32'b00000100000000000000000000000000: n2621_o = a1_vol;
      32'b00000010000000000000000000000000: n2621_o = a1_vol;
      32'b00000001000000000000000000000000: n2621_o = a1_vol;
      32'b00000000100000000000000000000000: n2621_o = a1_vol;
      32'b00000000010000000000000000000000: n2621_o = a1_vol;
      32'b00000000001000000000000000000000: n2621_o = a1_vol;
      32'b00000000000100000000000000000000: n2621_o = a1_vol;
      32'b00000000000010000000000000000000: n2621_o = a1_vol;
      32'b00000000000001000000000000000000: n2621_o = a1_vol;
      32'b00000000000000100000000000000000: n2621_o = a1_vol;
      32'b00000000000000010000000000000000: n2621_o = a1_vol;
      32'b00000000000000001000000000000000: n2621_o = a1_vol;
      32'b00000000000000000100000000000000: n2621_o = a1_vol;
      32'b00000000000000000010000000000000: n2621_o = a1_vol;
      32'b00000000000000000001000000000000: n2621_o = a1_vol;
      32'b00000000000000000000100000000000: n2621_o = a1_vol;
      32'b00000000000000000000010000000000: n2621_o = a1_vol;
      32'b00000000000000000000001000000000: n2621_o = a1_vol;
      32'b00000000000000000000000100000000: n2621_o = a1_vol;
      32'b00000000000000000000000010000000: n2621_o = a1_vol;
      32'b00000000000000000000000001000000: n2621_o = a1_vol;
      32'b00000000000000000000000000100000: n2621_o = a1_vol;
      32'b00000000000000000000000000010000: n2621_o = a1_vol;
      32'b00000000000000000000000000001000: n2621_o = a1_vol;
      32'b00000000000000000000000000000100: n2621_o = a1_vol;
      32'b00000000000000000000000000000010: n2621_o = a1_vol;
      32'b00000000000000000000000000000001: n2621_o = a1_vol;
      default: n2621_o = a1_vol;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2622_o = vsync;
      32'b01000000000000000000000000000000: n2622_o = vsync;
      32'b00100000000000000000000000000000: n2622_o = vsync;
      32'b00010000000000000000000000000000: n2622_o = vsync;
      32'b00001000000000000000000000000000: n2622_o = vsync;
      32'b00000100000000000000000000000000: n2622_o = vsync;
      32'b00000010000000000000000000000000: n2622_o = vsync;
      32'b00000001000000000000000000000000: n2622_o = vsync;
      32'b00000000100000000000000000000000: n2622_o = vsync;
      32'b00000000010000000000000000000000: n2622_o = vsync;
      32'b00000000001000000000000000000000: n2622_o = vsync;
      32'b00000000000100000000000000000000: n2622_o = vsync;
      32'b00000000000010000000000000000000: n2622_o = vsync;
      32'b00000000000001000000000000000000: n2622_o = vsync;
      32'b00000000000000100000000000000000: n2622_o = vsync;
      32'b00000000000000010000000000000000: n2622_o = vsync;
      32'b00000000000000001000000000000000: n2622_o = vsync;
      32'b00000000000000000100000000000000: n2622_o = vsync;
      32'b00000000000000000010000000000000: n2622_o = vsync;
      32'b00000000000000000001000000000000: n2622_o = vsync;
      32'b00000000000000000000100000000000: n2622_o = vsync;
      32'b00000000000000000000010000000000: n2622_o = vsync;
      32'b00000000000000000000001000000000: n2622_o = vsync;
      32'b00000000000000000000000100000000: n2622_o = vsync;
      32'b00000000000000000000000010000000: n2622_o = vsync;
      32'b00000000000000000000000001000000: n2622_o = vsync;
      32'b00000000000000000000000000100000: n2622_o = vsync;
      32'b00000000000000000000000000010000: n2622_o = vsync;
      32'b00000000000000000000000000001000: n2622_o = vsync;
      32'b00000000000000000000000000000100: n2622_o = vsync;
      32'b00000000000000000000000000000010: n2622_o = vsync;
      32'b00000000000000000000000000000001: n2622_o = n2477_o;
      default: n2622_o = vsync;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2623_o = vblank;
      32'b01000000000000000000000000000000: n2623_o = vblank;
      32'b00100000000000000000000000000000: n2623_o = vblank;
      32'b00010000000000000000000000000000: n2623_o = vblank;
      32'b00001000000000000000000000000000: n2623_o = vblank;
      32'b00000100000000000000000000000000: n2623_o = vblank;
      32'b00000010000000000000000000000000: n2623_o = vblank;
      32'b00000001000000000000000000000000: n2623_o = vblank;
      32'b00000000100000000000000000000000: n2623_o = vblank;
      32'b00000000010000000000000000000000: n2623_o = vblank;
      32'b00000000001000000000000000000000: n2623_o = vblank;
      32'b00000000000100000000000000000000: n2623_o = vblank;
      32'b00000000000010000000000000000000: n2623_o = vblank;
      32'b00000000000001000000000000000000: n2623_o = vblank;
      32'b00000000000000100000000000000000: n2623_o = vblank;
      32'b00000000000000010000000000000000: n2623_o = vblank;
      32'b00000000000000001000000000000000: n2623_o = vblank;
      32'b00000000000000000100000000000000: n2623_o = vblank;
      32'b00000000000000000010000000000000: n2623_o = vblank;
      32'b00000000000000000001000000000000: n2623_o = vblank;
      32'b00000000000000000000100000000000: n2623_o = vblank;
      32'b00000000000000000000010000000000: n2623_o = vblank;
      32'b00000000000000000000001000000000: n2623_o = vblank;
      32'b00000000000000000000000100000000: n2623_o = vblank;
      32'b00000000000000000000000010000000: n2623_o = vblank;
      32'b00000000000000000000000001000000: n2623_o = vblank;
      32'b00000000000000000000000000100000: n2623_o = vblank;
      32'b00000000000000000000000000010000: n2623_o = vblank;
      32'b00000000000000000000000000001000: n2623_o = vblank;
      32'b00000000000000000000000000000100: n2623_o = vblank;
      32'b00000000000000000000000000000010: n2623_o = n2482_o;
      32'b00000000000000000000000000000001: n2623_o = vblank;
      default: n2623_o = vblank;
    endcase
  /* ./TIA/TIA.vhd:1006:17  */
  always @*
    case (n2575_o)
      32'b10000000000000000000000000000000: n2624_o = inpt45_len;
      32'b01000000000000000000000000000000: n2624_o = inpt45_len;
      32'b00100000000000000000000000000000: n2624_o = inpt45_len;
      32'b00010000000000000000000000000000: n2624_o = inpt45_len;
      32'b00001000000000000000000000000000: n2624_o = inpt45_len;
      32'b00000100000000000000000000000000: n2624_o = inpt45_len;
      32'b00000010000000000000000000000000: n2624_o = inpt45_len;
      32'b00000001000000000000000000000000: n2624_o = inpt45_len;
      32'b00000000100000000000000000000000: n2624_o = inpt45_len;
      32'b00000000010000000000000000000000: n2624_o = inpt45_len;
      32'b00000000001000000000000000000000: n2624_o = inpt45_len;
      32'b00000000000100000000000000000000: n2624_o = inpt45_len;
      32'b00000000000010000000000000000000: n2624_o = inpt45_len;
      32'b00000000000001000000000000000000: n2624_o = inpt45_len;
      32'b00000000000000100000000000000000: n2624_o = inpt45_len;
      32'b00000000000000010000000000000000: n2624_o = inpt45_len;
      32'b00000000000000001000000000000000: n2624_o = inpt45_len;
      32'b00000000000000000100000000000000: n2624_o = inpt45_len;
      32'b00000000000000000010000000000000: n2624_o = inpt45_len;
      32'b00000000000000000001000000000000: n2624_o = inpt45_len;
      32'b00000000000000000000100000000000: n2624_o = inpt45_len;
      32'b00000000000000000000010000000000: n2624_o = inpt45_len;
      32'b00000000000000000000001000000000: n2624_o = inpt45_len;
      32'b00000000000000000000000100000000: n2624_o = inpt45_len;
      32'b00000000000000000000000010000000: n2624_o = inpt45_len;
      32'b00000000000000000000000001000000: n2624_o = inpt45_len;
      32'b00000000000000000000000000100000: n2624_o = inpt45_len;
      32'b00000000000000000000000000010000: n2624_o = inpt45_len;
      32'b00000000000000000000000000001000: n2624_o = inpt45_len;
      32'b00000000000000000000000000000100: n2624_o = inpt45_len;
      32'b00000000000000000000000000000010: n2624_o = n2481_o;
      32'b00000000000000000000000000000001: n2624_o = inpt45_len;
      default: n2624_o = inpt45_len;
    endcase
  assign n2651_o = {n2612_o, n2610_o, n2608_o};
  /* ./TIA/TIA.vhd:1096:53  */
  assign n2713_o = ~hblank_out;
  /* ./TIA/TIA.vhd:1096:59  */
  assign n2714_o = decomb & n2713_o;
  /* ./TIA/TIA.vhd:1096:37  */
  assign n2715_o = ~n2714_o;
  /* ./TIA/TIA.vhd:1096:33  */
  assign n2716_o = n2715_o & hblank;
  /* ./TIA/TIA.vhd:1098:84  */
  assign n2717_o = ~hblank;
  /* ./TIA/TIA.vhd:1098:73  */
  assign n2718_o = n2717_o & bl_pix;
  /* ./TIA/TIA.vhd:1098:56  */
  assign n2719_o = pf_pix | n2718_o;
  /* ./TIA/TIA.vhd:1098:38  */
  assign n2720_o = n2719_o & pf_priority;
  /* ./TIA/TIA.vhd:1100:36  */
  assign n2721_o = pf_pix & pf_score;
  /* ./TIA/TIA.vhd:1100:65  */
  assign n2722_o = ~hblank;
  /* ./TIA/TIA.vhd:1100:54  */
  assign n2723_o = n2722_o & n2721_o;
  /* ./TIA/TIA.vhd:1101:27  */
  assign n2724_o = ~center;
  /* ./TIA/TIA.vhd:1101:17  */
  assign n2725_o = n2724_o ? p0_colu : p1_colu;
  /* ./TIA/TIA.vhd:1106:34  */
  assign n2726_o = p0_pix | m0_pix;
  /* ./TIA/TIA.vhd:1106:62  */
  assign n2727_o = ~hblank;
  /* ./TIA/TIA.vhd:1106:51  */
  assign n2728_o = n2727_o & n2726_o;
  /* ./TIA/TIA.vhd:1108:34  */
  assign n2729_o = p1_pix | m1_pix;
  /* ./TIA/TIA.vhd:1108:62  */
  assign n2730_o = ~hblank;
  /* ./TIA/TIA.vhd:1108:51  */
  assign n2731_o = n2730_o & n2729_o;
  /* ./TIA/TIA.vhd:1110:61  */
  assign n2732_o = ~hblank;
  /* ./TIA/TIA.vhd:1110:50  */
  assign n2733_o = n2732_o & bl_pix;
  /* ./TIA/TIA.vhd:1110:33  */
  assign n2734_o = pf_pix | n2733_o;
  /* ./TIA/TIA.vhd:1110:13  */
  assign n2735_o = n2734_o ? pf_colu : bk_colu;
  /* ./TIA/TIA.vhd:1108:13  */
  assign n2736_o = n2731_o ? p1_colu : n2735_o;
  /* ./TIA/TIA.vhd:1106:13  */
  assign n2737_o = n2728_o ? p0_colu : n2736_o;
  /* ./TIA/TIA.vhd:1100:13  */
  assign n2738_o = n2723_o ? n2725_o : n2737_o;
  /* ./TIA/TIA.vhd:1098:13  */
  assign n2739_o = n2720_o ? pf_colu : n2738_o;
  /* ./TIA/TIA.vhd:1096:13  */
  assign n2741_o = n2716_o ? 7'b0000000 : n2739_o;
  /* ./TIA/TIA.vhd:1094:13  */
  assign n2743_o = vblank ? 7'b0000000 : n2741_o;
  assign n2750_o = sec_dl[1];
  /* ./TIA/TIA.vhd:1125:13  */
  assign n2751_o = sec ? 1'b0 : n2750_o;
  /* ./TIA/TIA.vhd:1123:13  */
  assign n2752_o = hmove_set ? 1'b1 : n2751_o;
  /* ./TIA/TIA.vhd:1130:36  */
  assign n2753_o = sec_dl[1];
  /* ./TIA/TIA.vhd:1132:30  */
  assign n2754_o = sec_dl[0];
  /* ./TIA/TIA.vhd:1131:13  */
  assign n2755_o = hh1_edge ? n2754_o : sec;
  assign n2756_o = sec_dl[0];
  /* ./TIA/TIA.vhd:1129:13  */
  assign n2757_o = hh0_edge ? n2753_o : n2756_o;
  /* ./TIA/TIA.vhd:1129:13  */
  assign n2758_o = hh0_edge ? sec : n2755_o;
  assign n2759_o = {n2752_o, n2757_o};
  /* ./TIA/TIA.vhd:1145:46  */
  assign n2766_o = hmove_cntr + 4'b0001;
  /* ./TIA/TIA.vhd:1144:17  */
  assign n2767_o = sec ? n2766_o : hmove_cntr;
  /* ./TIA/TIA.vhd:1148:29  */
  assign n2768_o = p0_hmove[3];
  /* ./TIA/TIA.vhd:1148:46  */
  assign n2769_o = hmove_cntr[3];
  /* ./TIA/TIA.vhd:1148:33  */
  assign n2770_o = n2768_o != n2769_o;
  /* ./TIA/TIA.vhd:1149:30  */
  assign n2771_o = p0_hmove[2:0];
  /* ./TIA/TIA.vhd:1149:58  */
  assign n2772_o = hmove_cntr_sl[2:0];
  /* ./TIA/TIA.vhd:1149:43  */
  assign n2773_o = n2771_o == n2772_o;
  /* ./TIA/TIA.vhd:1148:51  */
  assign n2774_o = n2773_o & n2770_o;
  /* ./TIA/TIA.vhd:1151:17  */
  assign n2776_o = sec ? 1'b1 : p0_ec;
  /* ./TIA/TIA.vhd:1148:17  */
  assign n2778_o = n2774_o ? 1'b0 : n2776_o;
  /* ./TIA/TIA.vhd:1155:29  */
  assign n2779_o = p1_hmove[3];
  /* ./TIA/TIA.vhd:1155:46  */
  assign n2780_o = hmove_cntr[3];
  /* ./TIA/TIA.vhd:1155:33  */
  assign n2781_o = n2779_o != n2780_o;
  /* ./TIA/TIA.vhd:1156:30  */
  assign n2782_o = p1_hmove[2:0];
  /* ./TIA/TIA.vhd:1156:58  */
  assign n2783_o = hmove_cntr_sl[2:0];
  /* ./TIA/TIA.vhd:1156:43  */
  assign n2784_o = n2782_o == n2783_o;
  /* ./TIA/TIA.vhd:1155:51  */
  assign n2785_o = n2784_o & n2781_o;
  /* ./TIA/TIA.vhd:1158:17  */
  assign n2787_o = sec ? 1'b1 : p1_ec;
  /* ./TIA/TIA.vhd:1155:17  */
  assign n2789_o = n2785_o ? 1'b0 : n2787_o;
  /* ./TIA/TIA.vhd:1162:29  */
  assign n2790_o = m0_hmove[3];
  /* ./TIA/TIA.vhd:1162:46  */
  assign n2791_o = hmove_cntr[3];
  /* ./TIA/TIA.vhd:1162:33  */
  assign n2792_o = n2790_o != n2791_o;
  /* ./TIA/TIA.vhd:1163:30  */
  assign n2793_o = m0_hmove[2:0];
  /* ./TIA/TIA.vhd:1163:58  */
  assign n2794_o = hmove_cntr_sl[2:0];
  /* ./TIA/TIA.vhd:1163:43  */
  assign n2795_o = n2793_o == n2794_o;
  /* ./TIA/TIA.vhd:1162:51  */
  assign n2796_o = n2795_o & n2792_o;
  /* ./TIA/TIA.vhd:1165:17  */
  assign n2798_o = sec ? 1'b1 : m0_ec;
  /* ./TIA/TIA.vhd:1162:17  */
  assign n2800_o = n2796_o ? 1'b0 : n2798_o;
  /* ./TIA/TIA.vhd:1169:29  */
  assign n2801_o = m1_hmove[3];
  /* ./TIA/TIA.vhd:1169:46  */
  assign n2802_o = hmove_cntr[3];
  /* ./TIA/TIA.vhd:1169:33  */
  assign n2803_o = n2801_o != n2802_o;
  /* ./TIA/TIA.vhd:1170:30  */
  assign n2804_o = m1_hmove[2:0];
  /* ./TIA/TIA.vhd:1170:58  */
  assign n2805_o = hmove_cntr_sl[2:0];
  /* ./TIA/TIA.vhd:1170:43  */
  assign n2806_o = n2804_o == n2805_o;
  /* ./TIA/TIA.vhd:1169:51  */
  assign n2807_o = n2806_o & n2803_o;
  /* ./TIA/TIA.vhd:1172:17  */
  assign n2809_o = sec ? 1'b1 : m1_ec;
  /* ./TIA/TIA.vhd:1169:17  */
  assign n2811_o = n2807_o ? 1'b0 : n2809_o;
  /* ./TIA/TIA.vhd:1176:29  */
  assign n2812_o = bl_hmove[3];
  /* ./TIA/TIA.vhd:1176:46  */
  assign n2813_o = hmove_cntr[3];
  /* ./TIA/TIA.vhd:1176:33  */
  assign n2814_o = n2812_o != n2813_o;
  /* ./TIA/TIA.vhd:1177:30  */
  assign n2815_o = bl_hmove[2:0];
  /* ./TIA/TIA.vhd:1177:58  */
  assign n2816_o = hmove_cntr_sl[2:0];
  /* ./TIA/TIA.vhd:1177:43  */
  assign n2817_o = n2815_o == n2816_o;
  /* ./TIA/TIA.vhd:1176:51  */
  assign n2818_o = n2817_o & n2814_o;
  /* ./TIA/TIA.vhd:1179:17  */
  assign n2820_o = sec ? 1'b1 : bl_ec;
  /* ./TIA/TIA.vhd:1176:17  */
  assign n2822_o = n2818_o ? 1'b0 : n2820_o;
  /* ./TIA/TIA.vhd:1183:36  */
  assign n2824_o = hmove_cntr == 4'b0000;
  /* ./TIA/TIA.vhd:1183:20  */
  assign n2825_o = ~n2824_o;
  /* ./TIA/TIA.vhd:1184:46  */
  assign n2827_o = hmove_cntr + 4'b0001;
  /* ./TIA/TIA.vhd:1183:17  */
  assign n2828_o = n2825_o ? n2827_o : n2767_o;
  /* ./TIA/TIA.vhd:1195:26  */
  assign n2844_o = ~hblank;
  /* ./TIA/TIA.vhd:1195:43  */
  assign n2845_o = ~vblank;
  /* ./TIA/TIA.vhd:1195:32  */
  assign n2846_o = n2845_o & n2844_o;
  /* ./TIA/TIA.vhd:1196:34  */
  assign n2847_o = p0_pix & m0_pix;
  assign n2849_o = cx[0];
  /* ./TIA/TIA.vhd:1196:17  */
  assign n2850_o = n2847_o ? 1'b1 : n2849_o;
  /* ./TIA/TIA.vhd:1199:34  */
  assign n2851_o = p1_pix & m0_pix;
  assign n2853_o = cx[1];
  /* ./TIA/TIA.vhd:1199:17  */
  assign n2854_o = n2851_o ? 1'b1 : n2853_o;
  /* ./TIA/TIA.vhd:1202:34  */
  assign n2855_o = p1_pix & m1_pix;
  assign n2857_o = cx[2];
  /* ./TIA/TIA.vhd:1202:17  */
  assign n2858_o = n2855_o ? 1'b1 : n2857_o;
  /* ./TIA/TIA.vhd:1205:34  */
  assign n2859_o = p0_pix & m1_pix;
  assign n2861_o = cx[3];
  /* ./TIA/TIA.vhd:1205:17  */
  assign n2862_o = n2859_o ? 1'b1 : n2861_o;
  /* ./TIA/TIA.vhd:1208:34  */
  assign n2863_o = p0_pix & bl_pix;
  assign n2865_o = cx[4];
  /* ./TIA/TIA.vhd:1208:17  */
  assign n2866_o = n2863_o ? 1'b1 : n2865_o;
  /* ./TIA/TIA.vhd:1211:34  */
  assign n2867_o = p0_pix & pf_pix;
  assign n2869_o = cx[5];
  /* ./TIA/TIA.vhd:1211:17  */
  assign n2870_o = n2867_o ? 1'b1 : n2869_o;
  /* ./TIA/TIA.vhd:1214:33  */
  assign n2871_o = p1_pix & bl_pix;
  assign n2873_o = cx[6];
  /* ./TIA/TIA.vhd:1214:16  */
  assign n2874_o = n2871_o ? 1'b1 : n2873_o;
  /* ./TIA/TIA.vhd:1217:34  */
  assign n2875_o = p1_pix & pf_pix;
  assign n2877_o = cx[7];
  /* ./TIA/TIA.vhd:1217:17  */
  assign n2878_o = n2875_o ? 1'b1 : n2877_o;
  /* ./TIA/TIA.vhd:1220:34  */
  assign n2879_o = m0_pix & bl_pix;
  assign n2881_o = cx[8];
  /* ./TIA/TIA.vhd:1220:17  */
  assign n2882_o = n2879_o ? 1'b1 : n2881_o;
  /* ./TIA/TIA.vhd:1223:34  */
  assign n2883_o = m0_pix & pf_pix;
  assign n2885_o = cx[9];
  /* ./TIA/TIA.vhd:1223:17  */
  assign n2886_o = n2883_o ? 1'b1 : n2885_o;
  /* ./TIA/TIA.vhd:1226:33  */
  assign n2887_o = m1_pix & bl_pix;
  assign n2889_o = cx[10];
  /* ./TIA/TIA.vhd:1226:16  */
  assign n2890_o = n2887_o ? 1'b1 : n2889_o;
  /* ./TIA/TIA.vhd:1229:34  */
  assign n2891_o = m1_pix & pf_pix;
  assign n2893_o = cx[11];
  /* ./TIA/TIA.vhd:1229:17  */
  assign n2894_o = n2891_o ? 1'b1 : n2893_o;
  /* ./TIA/TIA.vhd:1232:34  */
  assign n2895_o = bl_pix & pf_pix;
  assign n2897_o = cx[12];
  /* ./TIA/TIA.vhd:1232:17  */
  assign n2898_o = n2895_o ? 1'b1 : n2897_o;
  /* ./TIA/TIA.vhd:1235:34  */
  assign n2899_o = m1_pix & m0_pix;
  assign n2901_o = cx[13];
  /* ./TIA/TIA.vhd:1235:17  */
  assign n2902_o = n2899_o ? 1'b1 : n2901_o;
  /* ./TIA/TIA.vhd:1238:34  */
  assign n2903_o = p1_pix & p0_pix;
  assign n2905_o = cx[14];
  /* ./TIA/TIA.vhd:1238:17  */
  assign n2906_o = n2903_o ? 1'b1 : n2905_o;
  assign n2907_o = {n2906_o, n2902_o, n2898_o, n2894_o, n2890_o, n2886_o, n2882_o, n2878_o, n2874_o, n2870_o, n2866_o, n2862_o, n2858_o, n2854_o, n2850_o};
  /* ./TIA/TIA.vhd:1195:13  */
  assign n2908_o = n2846_o ? n2907_o : cx;
  /* ./TIA/TIA.vhd:1193:13  */
  assign n2910_o = cx_clr ? 15'b000000000000000 : n2908_o;
  /* ./TIA/TIA.vhd:1256:28  */
  assign n2917_o = h_lfsr_out == 6'b010100;
  /* ./TIA/TIA.vhd:1256:39  */
  assign n2918_o = hh1_edge & n2917_o;
  /* ./TIA/TIA.vhd:1261:21  */
  assign n2920_o = clk_dvdr == 2'b00;
  /* ./TIA/TIA.vhd:1264:21  */
  assign n2922_o = clk_dvdr == 2'b01;
  /* ./TIA/TIA.vhd:1268:21  */
  assign n2924_o = clk_dvdr == 2'b11;
  assign n2925_o = {n2924_o, n2922_o, n2920_o};
  /* ./TIA/TIA.vhd:1260:17  */
  always @*
    case (n2925_o)
      3'b100: n2929_o = 2'b00;
      3'b010: n2929_o = 2'b11;
      3'b001: n2929_o = 2'b01;
      default: n2929_o = clk_dvdr;
    endcase
  /* ./TIA/TIA.vhd:1260:17  */
  always @*
    case (n2925_o)
      3'b100: n2933_o = 1'b1;
      3'b010: n2933_o = 1'b0;
      3'b001: n2933_o = 1'b0;
      default: n2933_o = phi0;
    endcase
  /* ./TIA/TIA.vhd:1260:17  */
  always @*
    case (n2925_o)
      3'b100: n2936_o = 1'b0;
      3'b010: n2936_o = 1'b1;
      3'b001: n2936_o = 1'b0;
      default: n2936_o = 1'b0;
    endcase
  /* ./TIA/TIA.vhd:1256:13  */
  assign n2938_o = n2918_o ? 2'b01 : n2929_o;
  /* ./TIA/TIA.vhd:1256:13  */
  assign n2940_o = n2918_o ? 1'b0 : n2933_o;
  /* ./TIA/TIA.vhd:1256:13  */
  assign n2942_o = n2918_o ? 1'b0 : n2936_o;
  /* ./TIA/TIA.vhd:1285:27  */
  assign n2953_o = ~inpt4;
  /* ./TIA/TIA.vhd:1284:13  */
  assign n2955_o = n2959_o ? 1'b0 : inpt4_l;
  /* ./TIA/TIA.vhd:1288:27  */
  assign n2956_o = ~inpt5;
  /* ./TIA/TIA.vhd:1284:13  */
  assign n2958_o = n2960_o ? 1'b0 : inpt5_l;
  /* ./TIA/TIA.vhd:1284:13  */
  assign n2959_o = n2953_o & inpt45_len;
  /* ./TIA/TIA.vhd:1284:13  */
  assign n2960_o = n2956_o & inpt45_len;
  /* ./TIA/TIA.vhd:1281:13  */
  assign n2962_o = inpt45_rst ? 1'b1 : n2955_o;
  /* ./TIA/TIA.vhd:1281:13  */
  assign n2964_o = inpt45_rst ? 1'b1 : n2958_o;
  /* ./TIA/TIA.vhd:1299:9  */
  vgacolortable inst_vgacolortable (
    .clk(vid_clk),
    .lum(n2970_o),
    .hue(n2971_o),
    .mode(n2973_o),
    .outcolor(inst_vgacolortable_outcolor));
  /* ./TIA/TIA.vhd:1301:34  */
  assign n2968_o = vga_colu[2:0];
  /* ./TIA/TIA.vhd:1301:24  */
  assign n2970_o = {1'b0, n2968_o};
  /* ./TIA/TIA.vhd:1302:28  */
  assign n2971_o = vga_colu[6:3];
  /* ./TIA/TIA.vhd:1303:25  */
  assign n2973_o = {1'b0, pal};
  /* ./TIA/TIA.vhd:798:9  */
  assign n2975_o = hh1_edge ? n2166_o : hsync;
  /* ./TIA/TIA.vhd:798:9  */
  always @(posedge clk)
    n2976_q <= n2975_o;
  initial
    n2976_q = 1'b0;
  /* ./TIA/TIA.vhd:798:9  */
  assign n2977_o = hh1_edge ? n2169_o : hblank;
  /* ./TIA/TIA.vhd:798:9  */
  always @(posedge clk)
    n2978_q <= n2977_o;
  initial
    n2978_q = 1'b1;
  /* ./TIA/TIA.vhd:798:9  */
  assign n2979_o = hh1_edge ? n2172_o : hblank_out;
  /* ./TIA/TIA.vhd:798:9  */
  always @(posedge clk)
    n2980_q <= n2979_o;
  initial
    n2980_q = 1'b1;
  /* ./TIA/TIA.vhd:834:9  */
  always @(posedge clk)
    n2981_q <= n2204_o;
  initial
    n2981_q = 1'b0;
  /* ./TIA/TIA.vhd:1142:9  */
  assign n2982_o = hh0 ? n2828_o : hmove_cntr;
  /* ./TIA/TIA.vhd:1142:9  */
  always @(posedge clk)
    n2983_q <= n2982_o;
  initial
    n2983_q = 4'b1111;
  /* ./TIA/TIA.vhd:993:9  */
  assign n2984_o = n2476_o ? n2577_o : p0_nusiz;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n2985_q <= n2984_o;
  initial
    n2985_q = 3'b000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n2986_o = n2476_o ? n2578_o : p0_reflect;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n2987_q <= n2986_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n2988_o = n2476_o ? n2579_o : p0_grpnew;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n2989_q <= n2988_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n2990_o = n2476_o ? n2580_o : p0_grpold;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n2991_q <= n2990_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n2992_o = n2476_o ? n2581_o : p0_vdel;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n2993_q <= n2992_o;
  initial
    n2993_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n2994_q <= p0_colu;
  initial
    n2994_q = 7'b0000000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n2995_o = n2476_o ? n2583_o : p0_hmove;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n2996_q <= n2995_o;
  /* ./TIA/TIA.vhd:1142:9  */
  assign n2997_o = hh0 ? n2778_o : p0_ec;
  /* ./TIA/TIA.vhd:1142:9  */
  always @(posedge clk)
    n2998_q <= n2997_o;
  initial
    n2998_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n2999_o = n2476_o ? n2584_o : p1_nusiz;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3000_q <= n2999_o;
  initial
    n3000_q = 3'b000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3001_o = n2476_o ? n2585_o : p1_reflect;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3002_q <= n3001_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3003_o = n2476_o ? n2586_o : p1_grpnew;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3004_q <= n3003_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3005_o = n2476_o ? n2587_o : p1_grpold;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3006_q <= n3005_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3007_o = n2476_o ? n2588_o : p1_vdel;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3008_q <= n3007_o;
  initial
    n3008_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3009_q <= p1_colu;
  initial
    n3009_q = 7'b0000000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3010_o = n2476_o ? n2590_o : p1_hmove;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3011_q <= n3010_o;
  /* ./TIA/TIA.vhd:1142:9  */
  assign n3012_o = hh0 ? n2789_o : p1_ec;
  /* ./TIA/TIA.vhd:1142:9  */
  always @(posedge clk)
    n3013_q <= n3012_o;
  initial
    n3013_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3014_o = n2476_o ? n2591_o : m0_enable;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3015_q <= n3014_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3016_o = n2476_o ? n2592_o : m0_size;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3017_q <= n3016_o;
  initial
    n3017_q = 2'b00;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3018_o = n2476_o ? n2594_o : m0_hmove;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3019_q <= n3018_o;
  /* ./TIA/TIA.vhd:1142:9  */
  assign n3020_o = hh0 ? n2800_o : m0_ec;
  /* ./TIA/TIA.vhd:1142:9  */
  always @(posedge clk)
    n3021_q <= n3020_o;
  initial
    n3021_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3022_o = n2476_o ? n2595_o : m0_resp0;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3023_q <= n3022_o;
  initial
    n3023_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3024_o = n2476_o ? n2596_o : m1_enable;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3025_q <= n3024_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3026_o = n2476_o ? n2597_o : m1_size;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3027_q <= n3026_o;
  initial
    n3027_q = 2'b00;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3028_o = n2476_o ? n2599_o : m1_hmove;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3029_q <= n3028_o;
  /* ./TIA/TIA.vhd:1142:9  */
  assign n3030_o = hh0 ? n2811_o : m1_ec;
  /* ./TIA/TIA.vhd:1142:9  */
  always @(posedge clk)
    n3031_q <= n3030_o;
  initial
    n3031_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3032_o = n2476_o ? n2600_o : m1_resp1;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3033_q <= n3032_o;
  initial
    n3033_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3034_o = n2476_o ? n2601_o : bl_ennew;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3035_q <= n3034_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3036_o = n2476_o ? n2602_o : bl_enold;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3037_q <= n3036_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3038_o = n2476_o ? n2603_o : bl_vdel;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3039_q <= n3038_o;
  initial
    n3039_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3040_o = n2476_o ? n2604_o : bl_size;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3041_q <= n3040_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3042_o = n2476_o ? n2606_o : bl_hmove;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3043_q <= n3042_o;
  /* ./TIA/TIA.vhd:1142:9  */
  assign n3044_o = hh0 ? n2822_o : bl_ec;
  /* ./TIA/TIA.vhd:1142:9  */
  always @(posedge clk)
    n3045_q <= n3044_o;
  initial
    n3045_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3046_o = n2476_o ? n2651_o : pf_gr;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3047_q <= n3046_o;
  /* ./TIA/TIA.vhd:879:9  */
  assign n3048_o = h_lfsr_cnt ? n2259_o : pf_adr;
  /* ./TIA/TIA.vhd:879:9  */
  always @(posedge clk)
    n3049_q <= n3048_o;
  initial
    n3049_q = 5'b00000;
  /* ./TIA/TIA.vhd:879:9  */
  assign n3050_o = h_lfsr_cnt ? pf_mux_out : pf_pix;
  /* ./TIA/TIA.vhd:879:9  */
  always @(posedge clk)
    n3051_q <= n3050_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3052_o = n2476_o ? n2613_o : pf_reflect;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3053_q <= n3052_o;
  /* ./TIA/TIA.vhd:879:9  */
  assign n3054_o = h_lfsr_cnt ? n2261_o : pf_reverse;
  /* ./TIA/TIA.vhd:879:9  */
  always @(posedge clk)
    n3055_q <= n3054_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3056_o = n2476_o ? n2614_o : pf_score;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3057_q <= n3056_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3058_o = n2476_o ? n2615_o : pf_priority;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3059_q <= n3058_o;
  initial
    n3059_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3060_q <= pf_colu;
  initial
    n3060_q = 7'b0000000;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3061_q <= bk_colu;
  initial
    n3061_q = 7'b0000000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3062_o = n2476_o ? n2616_o : a0_freq;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3063_q <= n3062_o;
  initial
    n3063_q = 5'b00000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3064_o = n2476_o ? n2617_o : a0_ctrl;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3065_q <= n3064_o;
  initial
    n3065_q = 4'b0000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3066_o = n2476_o ? n2618_o : a0_vol;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3067_q <= n3066_o;
  initial
    n3067_q = 4'b0000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3068_o = n2476_o ? n2619_o : a1_freq;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3069_q <= n3068_o;
  initial
    n3069_q = 5'b00000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3070_o = n2476_o ? n2620_o : a1_ctrl;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3071_q <= n3070_o;
  initial
    n3071_q = 4'b0000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3072_o = n2476_o ? n2621_o : a1_vol;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3073_q <= n3072_o;
  initial
    n3073_q = 4'b0000;
  /* ./TIA/TIA.vhd:845:9  */
  always @(posedge clk)
    n3074_q <= n2221_o;
  initial
    n3074_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3075_o = n2476_o ? n2622_o : vsync;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3076_q <= n3075_o;
  initial
    n3076_q = 1'b0;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3077_o = n2476_o ? n2623_o : vblank;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3078_q <= n3077_o;
  initial
    n3078_q = 1'b0;
  /* ./TIA/TIA.vhd:798:9  */
  assign n3079_o = hh1_edge ? n2175_o : center;
  /* ./TIA/TIA.vhd:798:9  */
  always @(posedge clk)
    n3080_q <= n3079_o;
  initial
    n3080_q = 1'b0;
  /* ./TIA/TIA.vhd:798:9  */
  assign n3081_o = hh1_edge ? n2178_o : pf_cnt;
  /* ./TIA/TIA.vhd:798:9  */
  always @(posedge clk)
    n3082_q <= n3081_o;
  initial
    n3082_q = 1'b0;
  /* ./TIA/TIA.vhd:1192:9  */
  always @(posedge clk)
    n3083_q <= n2910_o;
  initial
    n3083_q = 15'b000000000000000;
  /* ./TIA/TIA.vhd:1252:9  */
  always @(posedge clk)
    n3084_q <= n2938_o;
  initial
    n3084_q = 2'b01;
  /* ./TIA/TIA.vhd:1252:9  */
  always @(posedge clk)
    n3085_q <= n2940_o;
  initial
    n3085_q = 1'b0;
  /* ./TIA/TIA.vhd:1252:9  */
  always @(posedge clk)
    n3086_q <= n2942_o;
  initial
    n3086_q = 1'b0;
  /* ./TIA/TIA.vhd:1252:9  */
  always @(posedge clk)
    n3087_q <= phi0;
  initial
    n3087_q = 1'b1;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3088_q <= phi2;
  /* ./TIA/TIA.vhd:1252:9  */
  always @(posedge clk)
    n3089_q <= phi0_en;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3090_o = n2476_o ? n2624_o : inpt45_len;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3091_q <= n3090_o;
  initial
    n3091_q = 1'b0;
  /* ./TIA/TIA.vhd:1280:9  */
  always @(posedge clk)
    n3092_q <= n2962_o;
  initial
    n3092_q = 1'b1;
  /* ./TIA/TIA.vhd:1280:9  */
  always @(posedge clk)
    n3093_q <= n2964_o;
  initial
    n3093_q = 1'b1;
  /* ./TIA/TIA.vhd:1122:9  */
  always @(posedge clk)
    n3094_q <= n2759_o;
  initial
    n3094_q = 2'b00;
  /* ./TIA/TIA.vhd:1122:9  */
  always @(posedge clk)
    n3095_q <= n2758_o;
  /* ./TIA/TIA.vhd:1093:9  */
  always @(posedge clk)
    n3099_q <= n2743_o;
  initial
    n3099_q = 7'b0000000;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3103_o = n2470_o ? din : floating_bus;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3104_q <= n3103_o;
  /* ./TIA/TIA.vhd:798:9  */
  always @(posedge clk)
    n3105_q <= n2180_o;
  /* ./TIA/TIA.vhd:798:9  */
  assign n3106_o = hh1_edge ? n2163_o : n3107_q;
  /* ./TIA/TIA.vhd:798:9  */
  always @(posedge clk)
    n3107_q <= n3106_o;
  /* ./TIA/TIA.vhd:993:9  */
  assign n3108_o = n2476_o ? n2576_o : n3109_q;
  /* ./TIA/TIA.vhd:993:9  */
  always @(posedge clk)
    n3109_q <= n3108_o;
endmodule

module a6532
  (input  clk,
   input  ph2_en,
   input  r,
   input  rs,
   input  cs,
   input  [7:0] din,
   input  [7:0] pa,
   input  [7:0] pb,
   input  pa7,
   input  [6:0] a,
   output irq,
   output [7:0] dout);
  reg [7:0] pb_reg;
  reg [7:0] pa_ddr;
  reg [7:0] pb_ddr;
  wire [7:0] pa_in;
  wire [7:0] pb_in;
  reg [7:0] timer;
  wire timer_write;
  wire timer_read;
  reg timer_intr;
  reg [1:0] timer_intvl;
  reg [10:0] timer_dvdr;
  wire timer_inc;
  reg timer_irq_en;
  reg edge_pol;
  reg edge_irq_en;
  reg edge_intr_lo;
  reg edge_intr_hi;
  wire edge_intr;
  wire [7:0] ram_d_out;
  wire ram_r;
  wire n1768_o;
  wire n1769_o;
  wire n1770_o;
  wire n1771_o;
  wire n1772_o;
  wire n1773_o;
  wire n1774_o;
  wire n1775_o;
  wire n1776_o;
  wire n1777_o;
  wire n1778_o;
  wire n1779_o;
  wire n1780_o;
  wire n1781_o;
  wire n1782_o;
  wire n1783_o;
  wire n1784_o;
  wire n1785_o;
  wire n1786_o;
  wire n1787_o;
  wire n1788_o;
  wire n1789_o;
  wire n1790_o;
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
  wire n1804_o;
  wire n1805_o;
  wire n1806_o;
  wire n1807_o;
  wire n1808_o;
  wire n1809_o;
  wire n1810_o;
  wire n1811_o;
  wire n1812_o;
  wire n1813_o;
  wire n1814_o;
  wire n1815_o;
  wire n1817_o;
  wire n1818_o;
  wire n1819_o;
  wire n1820_o;
  wire n1821_o;
  wire n1822_o;
  wire n1823_o;
  wire n1824_o;
  wire n1825_o;
  wire n1826_o;
  wire n1827_o;
  wire n1828_o;
  wire n1829_o;
  wire n1830_o;
  wire n1831_o;
  wire n1832_o;
  wire n1833_o;
  wire n1834_o;
  wire n1835_o;
  wire n1842_o;
  wire n1843_o;
  wire n1844_o;
  wire n1845_o;
  wire n1846_o;
  wire n1847_o;
  wire n1850_o;
  wire n1851_o;
  wire n1852_o;
  wire n1853_o;
  wire [1:0] n1854_o;
  wire n1856_o;
  wire n1858_o;
  wire n1860_o;
  wire n1862_o;
  wire [3:0] n1863_o;
  reg [7:0] n1864_o;
  wire n1865_o;
  wire n1866_o;
  wire n1867_o;
  wire [1:0] n1868_o;
  wire [7:0] n1870_o;
  wire [7:0] n1872_o;
  wire [7:0] n1873_o;
  wire [7:0] n1874_o;
  wire [7:0] n1875_o;
  wire [7:0] n1877_o;
  wire n1879_o;
  wire n1881_o;
  wire n1882_o;
  wire [1:0] n1883_o;
  wire n1885_o;
  wire n1887_o;
  wire n1889_o;
  wire n1891_o;
  wire [3:0] n1892_o;
  reg [7:0] n1893_o;
  reg [7:0] n1894_o;
  reg [7:0] n1895_o;
  wire n1896_o;
  wire n1897_o;
  wire n1898_o;
  wire n1899_o;
  wire n1900_o;
  wire n1901_o;
  wire n1905_o;
  wire n1906_o;
  wire n1907_o;
  wire n1908_o;
  wire n1909_o;
  wire n1912_o;
  wire n1914_o;
  wire n1916_o;
  wire n1918_o;
  wire n1920_o;
  wire [7:0] n1923_o;
  wire n1932_o;
  wire n1934_o;
  wire n1935_o;
  wire n1937_o;
  wire n1938_o;
  wire n1940_o;
  wire n1941_o;
  wire n1943_o;
  wire [3:0] n1945_o;
  reg n1946_o;
  wire [10:0] n1952_o;
  wire [10:0] n1954_o;
  wire [7:0] n1956_o;
  wire [1:0] n1957_o;
  wire n1958_o;
  wire n1959_o;
  wire [7:0] n1960_o;
  wire [7:0] n1961_o;
  wire n1963_o;
  wire n1964_o;
  wire [7:0] n1966_o;
  wire [7:0] n1967_o;
  wire [7:0] n1968_o;
  wire [7:0] n1969_o;
  wire [10:0] n1972_o;
  wire n1975_o;
  wire n1976_o;
  wire n1977_o;
  wire n1978_o;
  wire n1979_o;
  wire n1980_o;
  wire n1981_o;
  wire n1983_o;
  wire n1985_o;
  wire n1988_o;
  wire n1991_o;
  wire n1994_o;
  wire n1995_o;
  wire [7:0] n1996_o;
  reg [7:0] n1997_q;
  wire n1998_o;
  wire n1999_o;
  wire [7:0] n2000_o;
  reg [7:0] n2001_q;
  wire n2002_o;
  wire n2003_o;
  wire [7:0] n2004_o;
  reg [7:0] n2005_q;
  wire [7:0] n2006_o;
  wire [7:0] n2007_o;
  wire [7:0] n2008_o;
  reg [7:0] n2009_q;
  wire n2010_o;
  reg n2011_q;
  wire [1:0] n2012_o;
  reg [1:0] n2013_q;
  wire [10:0] n2014_o;
  reg [10:0] n2015_q;
  wire n2016_o;
  reg n2017_q;
  wire n2018_o;
  wire n2019_o;
  wire n2020_o;
  reg n2021_q;
  wire n2022_o;
  wire n2023_o;
  wire n2024_o;
  reg n2025_q;
  assign irq = n1845_o;
  assign dout = n1923_o;
  /* ./A6532.vhd:74:12  */
  always @*
    pb_reg = n1997_q; // (isignal)
  initial
    pb_reg = 8'b00000000;
  /* ./A6532.vhd:75:12  */
  always @*
    pa_ddr = n2001_q; // (isignal)
  initial
    pa_ddr = 8'b00000000;
  /* ./A6532.vhd:76:12  */
  always @*
    pb_ddr = n2005_q; // (isignal)
  initial
    pb_ddr = 8'b00000000;
  /* ./A6532.vhd:77:12  */
  assign pa_in = n2006_o; // (signal)
  /* ./A6532.vhd:78:12  */
  assign pb_in = n2007_o; // (signal)
  /* ./A6532.vhd:80:12  */
  always @*
    timer = n2009_q; // (isignal)
  initial
    timer = 8'b00000000;
  /* ./A6532.vhd:81:12  */
  assign timer_write = n1828_o; // (signal)
  /* ./A6532.vhd:82:12  */
  assign timer_read = n1835_o; // (signal)
  /* ./A6532.vhd:83:12  */
  always @*
    timer_intr = n2011_q; // (isignal)
  initial
    timer_intr = 1'b0;
  /* ./A6532.vhd:84:12  */
  always @*
    timer_intvl = n2013_q; // (isignal)
  initial
    timer_intvl = 2'b11;
  /* ./A6532.vhd:85:12  */
  always @*
    timer_dvdr = n2015_q; // (isignal)
  initial
    timer_dvdr = 11'b00000000001;
  /* ./A6532.vhd:86:12  */
  assign timer_inc = n1946_o; // (signal)
  /* ./A6532.vhd:87:12  */
  always @*
    timer_irq_en = n2017_q; // (isignal)
  initial
    timer_irq_en = 1'b0;
  /* ./A6532.vhd:89:12  */
  always @*
    edge_pol = n2021_q; // (isignal)
  initial
    edge_pol = 1'b0;
  /* ./A6532.vhd:90:12  */
  always @*
    edge_irq_en = n2025_q; // (isignal)
  initial
    edge_irq_en = 1'b0;
  /* ./A6532.vhd:91:12  */
  always @*
    edge_intr_lo = 1'b0; // (isignal)
  initial
    edge_intr_lo = 1'b0;
  /* ./A6532.vhd:92:12  */
  always @*
    edge_intr_hi = 1'b0; // (isignal)
  initial
    edge_intr_hi = 1'b0;
  /* ./A6532.vhd:93:12  */
  assign edge_intr = n1847_o; // (signal)
  /* ./A6532.vhd:97:12  */
  /* ./A6532.vhd:98:12  */
  assign ram_r = n1821_o; // (signal)
  /* ./A6532.vhd:106:23  */
  assign n1768_o = pa[0];
  /* ./A6532.vhd:107:23  */
  assign n1769_o = pb[0];
  /* ./A6532.vhd:107:38  */
  assign n1770_o = pb_ddr[0];
  /* ./A6532.vhd:107:42  */
  assign n1771_o = ~n1770_o;
  /* ./A6532.vhd:107:27  */
  assign n1772_o = n1771_o ? n1769_o : n1773_o;
  /* ./A6532.vhd:107:59  */
  assign n1773_o = pb_reg[0];
  /* ./A6532.vhd:106:23  */
  assign n1774_o = pa[1];
  /* ./A6532.vhd:107:23  */
  assign n1775_o = pb[1];
  /* ./A6532.vhd:107:38  */
  assign n1776_o = pb_ddr[1];
  /* ./A6532.vhd:107:42  */
  assign n1777_o = ~n1776_o;
  /* ./A6532.vhd:107:27  */
  assign n1778_o = n1777_o ? n1775_o : n1779_o;
  /* ./A6532.vhd:107:59  */
  assign n1779_o = pb_reg[1];
  /* ./A6532.vhd:106:23  */
  assign n1780_o = pa[2];
  /* ./A6532.vhd:107:23  */
  assign n1781_o = pb[2];
  /* ./A6532.vhd:107:38  */
  assign n1782_o = pb_ddr[2];
  /* ./A6532.vhd:107:42  */
  assign n1783_o = ~n1782_o;
  /* ./A6532.vhd:107:27  */
  assign n1784_o = n1783_o ? n1781_o : n1785_o;
  /* ./A6532.vhd:107:59  */
  assign n1785_o = pb_reg[2];
  /* ./A6532.vhd:106:23  */
  assign n1786_o = pa[3];
  /* ./A6532.vhd:107:23  */
  assign n1787_o = pb[3];
  /* ./A6532.vhd:107:38  */
  assign n1788_o = pb_ddr[3];
  /* ./A6532.vhd:107:42  */
  assign n1789_o = ~n1788_o;
  /* ./A6532.vhd:107:27  */
  assign n1790_o = n1789_o ? n1787_o : n1791_o;
  /* ./A6532.vhd:107:59  */
  assign n1791_o = pb_reg[3];
  /* ./A6532.vhd:106:23  */
  assign n1792_o = pa[4];
  /* ./A6532.vhd:107:23  */
  assign n1793_o = pb[4];
  /* ./A6532.vhd:107:38  */
  assign n1794_o = pb_ddr[4];
  /* ./A6532.vhd:107:42  */
  assign n1795_o = ~n1794_o;
  /* ./A6532.vhd:107:27  */
  assign n1796_o = n1795_o ? n1793_o : n1797_o;
  /* ./A6532.vhd:107:59  */
  assign n1797_o = pb_reg[4];
  /* ./A6532.vhd:106:23  */
  assign n1798_o = pa[5];
  /* ./A6532.vhd:107:23  */
  assign n1799_o = pb[5];
  /* ./A6532.vhd:107:38  */
  assign n1800_o = pb_ddr[5];
  /* ./A6532.vhd:107:42  */
  assign n1801_o = ~n1800_o;
  /* ./A6532.vhd:107:27  */
  assign n1802_o = n1801_o ? n1799_o : n1803_o;
  /* ./A6532.vhd:107:59  */
  assign n1803_o = pb_reg[5];
  /* ./A6532.vhd:106:23  */
  assign n1804_o = pa[6];
  /* ./A6532.vhd:107:23  */
  assign n1805_o = pb[6];
  /* ./A6532.vhd:107:38  */
  assign n1806_o = pb_ddr[6];
  /* ./A6532.vhd:107:42  */
  assign n1807_o = ~n1806_o;
  /* ./A6532.vhd:107:27  */
  assign n1808_o = n1807_o ? n1805_o : n1809_o;
  /* ./A6532.vhd:107:59  */
  assign n1809_o = pb_reg[6];
  /* ./A6532.vhd:106:23  */
  assign n1810_o = pa[7];
  /* ./A6532.vhd:107:23  */
  assign n1811_o = pb[7];
  /* ./A6532.vhd:107:38  */
  assign n1812_o = pb_ddr[7];
  /* ./A6532.vhd:107:42  */
  assign n1813_o = ~n1812_o;
  /* ./A6532.vhd:107:27  */
  assign n1814_o = n1813_o ? n1811_o : n1815_o;
  /* ./A6532.vhd:107:59  */
  assign n1815_o = pb_reg[7];
  /* ./A6532.vhd:110:5  */
  ramx8_7 ram (
    .clk(clk),
    .r(ram_r),
    .d_in(din),
    .a(a),
    .d_out(ram_d_out));
  /* ./A6532.vhd:112:15  */
  assign n1817_o = ~rs;
  /* ./A6532.vhd:112:22  */
  assign n1818_o = n1817_o & r;
  /* ./A6532.vhd:112:29  */
  assign n1819_o = n1818_o | rs;
  /* ./A6532.vhd:112:38  */
  assign n1820_o = ~cs;
  /* ./A6532.vhd:112:35  */
  assign n1821_o = n1819_o | n1820_o;
  /* ./A6532.vhd:114:21  */
  assign n1822_o = ~r;
  /* ./A6532.vhd:114:28  */
  assign n1823_o = n1822_o & rs;
  /* ./A6532.vhd:114:40  */
  assign n1824_o = a[2];
  /* ./A6532.vhd:114:35  */
  assign n1825_o = n1823_o & n1824_o;
  /* ./A6532.vhd:114:49  */
  assign n1826_o = a[4];
  /* ./A6532.vhd:114:44  */
  assign n1827_o = n1825_o & n1826_o;
  /* ./A6532.vhd:114:53  */
  assign n1828_o = n1827_o & cs;
  /* ./A6532.vhd:115:21  */
  assign n1829_o = r & rs;
  /* ./A6532.vhd:115:33  */
  assign n1830_o = a[2];
  /* ./A6532.vhd:115:28  */
  assign n1831_o = n1829_o & n1830_o;
  /* ./A6532.vhd:115:47  */
  assign n1832_o = a[0];
  /* ./A6532.vhd:115:42  */
  assign n1833_o = ~n1832_o;
  /* ./A6532.vhd:115:37  */
  assign n1834_o = n1831_o & n1833_o;
  /* ./A6532.vhd:115:52  */
  assign n1835_o = n1834_o & cs;
  /* ./A6532.vhd:118:29  */
  assign n1842_o = timer_intr & timer_irq_en;
  /* ./A6532.vhd:118:61  */
  assign n1843_o = edge_intr & edge_irq_en;
  /* ./A6532.vhd:118:47  */
  assign n1844_o = n1842_o | n1843_o;
  /* ./A6532.vhd:118:12  */
  assign n1845_o = ~n1844_o;
  /* ./A6532.vhd:119:45  */
  assign n1846_o = ~edge_pol;
  /* ./A6532.vhd:119:31  */
  assign n1847_o = n1846_o ? edge_intr_lo : edge_intr_hi;
  /* ./A6532.vhd:124:20  */
  assign n1850_o = ~cs;
  /* ./A6532.vhd:126:22  */
  assign n1851_o = ~rs;
  /* ./A6532.vhd:128:20  */
  assign n1852_o = a[2];
  /* ./A6532.vhd:128:24  */
  assign n1853_o = ~n1852_o;
  /* ./A6532.vhd:129:23  */
  assign n1854_o = a[1:0];
  /* ./A6532.vhd:130:21  */
  assign n1856_o = n1854_o == 2'b00;
  /* ./A6532.vhd:132:21  */
  assign n1858_o = n1854_o == 2'b01;
  /* ./A6532.vhd:134:21  */
  assign n1860_o = n1854_o == 2'b10;
  /* ./A6532.vhd:136:21  */
  assign n1862_o = n1854_o == 2'b11;
  assign n1863_o = {n1862_o, n1860_o, n1858_o, n1856_o};
  /* ./A6532.vhd:129:17  */
  always @*
    case (n1863_o)
      4'b1000: n1864_o = pb_ddr;
      4'b0100: n1864_o = pb_in;
      4'b0010: n1864_o = pa_ddr;
      4'b0001: n1864_o = pa_in;
      default: n1864_o = pb_ddr;
    endcase
  /* ./A6532.vhd:141:20  */
  assign n1865_o = a[0];
  /* ./A6532.vhd:141:24  */
  assign n1866_o = ~n1865_o;
  /* ./A6532.vhd:143:20  */
  assign n1867_o = a[0];
  /* ./A6532.vhd:144:36  */
  assign n1868_o = {timer_intr, edge_intr};
  /* ./A6532.vhd:144:48  */
  assign n1870_o = {n1868_o, 6'b000000};
  /* ./A6532.vhd:143:13  */
  assign n1872_o = n1867_o ? n1870_o : 8'b00000000;
  /* ./A6532.vhd:141:13  */
  assign n1873_o = n1866_o ? timer : n1872_o;
  /* ./A6532.vhd:128:13  */
  assign n1874_o = n1853_o ? n1864_o : n1873_o;
  /* ./A6532.vhd:126:13  */
  assign n1875_o = n1851_o ? ram_d_out : n1874_o;
  /* ./A6532.vhd:124:13  */
  assign n1877_o = n1850_o ? 8'b11111111 : n1875_o;
  /* ./A6532.vhd:150:41  */
  assign n1879_o = ph2_en & cs;
  /* ./A6532.vhd:152:25  */
  assign n1881_o = a[2];
  /* ./A6532.vhd:152:29  */
  assign n1882_o = ~n1881_o;
  /* ./A6532.vhd:153:31  */
  assign n1883_o = a[1:0];
  /* ./A6532.vhd:154:29  */
  assign n1885_o = n1883_o == 2'b00;
  /* ./A6532.vhd:156:29  */
  assign n1887_o = n1883_o == 2'b01;
  /* ./A6532.vhd:158:29  */
  assign n1889_o = n1883_o == 2'b10;
  /* ./A6532.vhd:160:29  */
  assign n1891_o = n1883_o == 2'b11;
  assign n1892_o = {n1891_o, n1889_o, n1887_o, n1885_o};
  /* ./A6532.vhd:153:25  */
  always @*
    case (n1892_o)
      4'b1000: n1893_o = pb_reg;
      4'b0100: n1893_o = din;
      4'b0010: n1893_o = pb_reg;
      4'b0001: n1893_o = pb_reg;
      default: n1893_o = pb_reg;
    endcase
  /* ./A6532.vhd:153:25  */
  always @*
    case (n1892_o)
      4'b1000: n1894_o = pa_ddr;
      4'b0100: n1894_o = pa_ddr;
      4'b0010: n1894_o = din;
      4'b0001: n1894_o = pa_ddr;
      default: n1894_o = pa_ddr;
    endcase
  /* ./A6532.vhd:153:25  */
  always @*
    case (n1892_o)
      4'b1000: n1895_o = din;
      4'b0100: n1895_o = pb_ddr;
      4'b0010: n1895_o = pb_ddr;
      4'b0001: n1895_o = pb_ddr;
      default: n1895_o = pb_ddr;
    endcase
  /* ./A6532.vhd:165:28  */
  assign n1896_o = a[4];
  /* ./A6532.vhd:165:32  */
  assign n1897_o = ~n1896_o;
  /* ./A6532.vhd:166:38  */
  assign n1898_o = a[0];
  /* ./A6532.vhd:167:41  */
  assign n1899_o = a[1];
  /* ./A6532.vhd:165:21  */
  assign n1900_o = n1897_o ? n1898_o : edge_pol;
  /* ./A6532.vhd:165:21  */
  assign n1901_o = n1897_o ? n1899_o : edge_irq_en;
  /* ./A6532.vhd:152:21  */
  assign n1905_o = n1882_o ? edge_pol : n1900_o;
  /* ./A6532.vhd:152:21  */
  assign n1906_o = n1882_o ? edge_irq_en : n1901_o;
  /* ./A6532.vhd:151:17  */
  assign n1907_o = n1882_o & rs;
  /* ./A6532.vhd:151:17  */
  assign n1908_o = n1882_o & rs;
  /* ./A6532.vhd:151:17  */
  assign n1909_o = n1882_o & rs;
  /* ./A6532.vhd:150:54  */
  assign n1912_o = n1907_o & n1879_o;
  /* ./A6532.vhd:150:54  */
  assign n1914_o = n1908_o & n1879_o;
  /* ./A6532.vhd:150:54  */
  assign n1916_o = n1909_o & n1879_o;
  /* ./A6532.vhd:150:54  */
  assign n1918_o = rs & n1879_o;
  /* ./A6532.vhd:150:54  */
  assign n1920_o = rs & n1879_o;
  /* ./A6532.vhd:123:9  */
  assign n1923_o = r ? n1877_o : 8'b11111111;
  /* ./A6532.vhd:178:19  */
  assign n1932_o = timer_dvdr[0];
  /* ./A6532.vhd:178:23  */
  assign n1934_o = timer_intvl == 2'b00;
  /* ./A6532.vhd:179:19  */
  assign n1935_o = timer_dvdr[3];
  /* ./A6532.vhd:179:23  */
  assign n1937_o = timer_intvl == 2'b01;
  /* ./A6532.vhd:180:19  */
  assign n1938_o = timer_dvdr[6];
  /* ./A6532.vhd:180:23  */
  assign n1940_o = timer_intvl == 2'b10;
  /* ./A6532.vhd:181:19  */
  assign n1941_o = timer_dvdr[10];
  /* ./A6532.vhd:181:24  */
  assign n1943_o = timer_intvl == 2'b11;
  assign n1945_o = {n1943_o, n1940_o, n1937_o, n1934_o};
  /* ./A6532.vhd:177:5  */
  always @*
    case (n1945_o)
      4'b1000: n1946_o = n1941_o;
      4'b0100: n1946_o = n1938_o;
      4'b0010: n1946_o = n1935_o;
      4'b0001: n1946_o = n1932_o;
      default: n1946_o = 1'bX;
    endcase
  /* ./A6532.vhd:190:42  */
  assign n1952_o = timer_dvdr + 11'b00000000001;
  /* ./A6532.vhd:187:13  */
  assign n1954_o = timer_inc ? 11'b00000000001 : n1952_o;
  /* ./A6532.vhd:194:30  */
  assign n1956_o = din - 8'b00000001;
  /* ./A6532.vhd:195:33  */
  assign n1957_o = a[1:0];
  /* ./A6532.vhd:196:34  */
  assign n1958_o = a[3];
  /* ./A6532.vhd:198:31  */
  assign n1959_o = ~timer_intr;
  /* ./A6532.vhd:199:32  */
  assign n1960_o = {7'b0, timer_inc};  //  uext
  /* ./A6532.vhd:199:32  */
  assign n1961_o = timer - n1960_o;
  /* ./A6532.vhd:200:31  */
  assign n1963_o = timer == 8'b00000000;
  /* ./A6532.vhd:200:20  */
  assign n1964_o = ~n1963_o;
  /* ./A6532.vhd:201:32  */
  assign n1966_o = timer - 8'b00000001;
  /* ./A6532.vhd:200:13  */
  assign n1967_o = n1964_o ? n1966_o : timer;
  /* ./A6532.vhd:198:13  */
  assign n1968_o = n1959_o ? n1961_o : n1967_o;
  /* ./A6532.vhd:193:13  */
  assign n1969_o = timer_write ? n1956_o : n1968_o;
  /* ./A6532.vhd:193:13  */
  assign n1972_o = timer_write ? 11'b00000000001 : n1954_o;
  /* ./A6532.vhd:204:23  */
  assign n1975_o = timer == 8'b00000000;
  /* ./A6532.vhd:204:31  */
  assign n1976_o = timer_inc & n1975_o;
  /* ./A6532.vhd:204:66  */
  assign n1977_o = ~timer_intr;
  /* ./A6532.vhd:204:51  */
  assign n1978_o = n1977_o & n1976_o;
  /* ./A6532.vhd:204:88  */
  assign n1979_o = ~timer_write;
  /* ./A6532.vhd:204:72  */
  assign n1980_o = n1979_o & n1978_o;
  /* ./A6532.vhd:206:37  */
  assign n1981_o = timer_read | timer_write;
  /* ./A6532.vhd:206:13  */
  assign n1983_o = n1981_o ? 1'b0 : timer_intr;
  /* ./A6532.vhd:204:13  */
  assign n1985_o = n1980_o ? 1'b1 : n1983_o;
  /* ./A6532.vhd:186:37  */
  assign n1988_o = timer_write & ph2_en;
  /* ./A6532.vhd:186:37  */
  assign n1991_o = timer_write & ph2_en;
  /* ./A6532.vhd:121:5  */
  assign n1994_o = ~r;
  /* ./A6532.vhd:121:5  */
  assign n1995_o = n1912_o & n1994_o;
  /* ./A6532.vhd:150:13  */
  assign n1996_o = n1995_o ? n1893_o : pb_reg;
  /* ./A6532.vhd:150:13  */
  always @(posedge clk)
    n1997_q <= n1996_o;
  initial
    n1997_q = 8'b00000000;
  /* ./A6532.vhd:121:5  */
  assign n1998_o = ~r;
  /* ./A6532.vhd:121:5  */
  assign n1999_o = n1914_o & n1998_o;
  /* ./A6532.vhd:150:13  */
  assign n2000_o = n1999_o ? n1894_o : pa_ddr;
  /* ./A6532.vhd:150:13  */
  always @(posedge clk)
    n2001_q <= n2000_o;
  initial
    n2001_q = 8'b00000000;
  /* ./A6532.vhd:121:5  */
  assign n2002_o = ~r;
  /* ./A6532.vhd:121:5  */
  assign n2003_o = n1916_o & n2002_o;
  /* ./A6532.vhd:150:13  */
  assign n2004_o = n2003_o ? n1895_o : pb_ddr;
  /* ./A6532.vhd:150:13  */
  always @(posedge clk)
    n2005_q <= n2004_o;
  initial
    n2005_q = 8'b00000000;
  /* ./A6532.vhd:123:9  */
  assign n2006_o = {n1810_o, n1804_o, n1798_o, n1792_o, n1786_o, n1780_o, n1774_o, n1768_o};
  assign n2007_o = {n1814_o, n1808_o, n1802_o, n1796_o, n1790_o, n1784_o, n1778_o, n1772_o};
  /* ./A6532.vhd:186:9  */
  assign n2008_o = ph2_en ? n1969_o : timer;
  /* ./A6532.vhd:186:9  */
  always @(posedge clk)
    n2009_q <= n2008_o;
  initial
    n2009_q = 8'b00000000;
  /* ./A6532.vhd:186:9  */
  assign n2010_o = ph2_en ? n1985_o : timer_intr;
  /* ./A6532.vhd:186:9  */
  always @(posedge clk)
    n2011_q <= n2010_o;
  initial
    n2011_q = 1'b0;
  /* ./A6532.vhd:186:9  */
  assign n2012_o = n1988_o ? n1957_o : timer_intvl;
  /* ./A6532.vhd:186:9  */
  always @(posedge clk)
    n2013_q <= n2012_o;
  initial
    n2013_q = 2'b11;
  /* ./A6532.vhd:186:9  */
  assign n2014_o = ph2_en ? n1972_o : timer_dvdr;
  /* ./A6532.vhd:186:9  */
  always @(posedge clk)
    n2015_q <= n2014_o;
  initial
    n2015_q = 11'b00000000001;
  /* ./A6532.vhd:186:9  */
  assign n2016_o = n1991_o ? n1958_o : timer_irq_en;
  /* ./A6532.vhd:186:9  */
  always @(posedge clk)
    n2017_q <= n2016_o;
  initial
    n2017_q = 1'b0;
  /* ./A6532.vhd:121:5  */
  assign n2018_o = ~r;
  /* ./A6532.vhd:121:5  */
  assign n2019_o = n1918_o & n2018_o;
  /* ./A6532.vhd:150:13  */
  assign n2020_o = n2019_o ? n1905_o : edge_pol;
  /* ./A6532.vhd:150:13  */
  always @(posedge clk)
    n2021_q <= n2020_o;
  initial
    n2021_q = 1'b0;
  /* ./A6532.vhd:121:5  */
  assign n2022_o = ~r;
  /* ./A6532.vhd:121:5  */
  assign n2023_o = n1920_o & n2022_o;
  /* ./A6532.vhd:150:13  */
  assign n2024_o = n2023_o ? n1906_o : edge_irq_en;
  /* ./A6532.vhd:150:13  */
  always @(posedge clk)
    n2025_q <= n2024_o;
  initial
    n2025_q = 1'b0;
endmodule

module a6507
  (input  clk,
   input  clk_en,
   input  rst,
   input  rdy,
   input  [7:0] di,
   output [7:0] do,
   output we,
   output [12:0] ad,
   output r);
  wire [23:0] ad_full;
  wire [7:0] cpudi;
  wire [7:0] cpudo;
  wire cpuwe;
  wire cpuwe_n;
  wire [12:0] n1739_o;
  wire n1740_o;
  wire n1741_o;
  wire cpu_r_w_n;
  wire cpu_sync;
  wire cpu_ef;
  wire cpu_mf;
  wire cpu_xf;
  wire cpu_ml_n;
  wire cpu_vp_n;
  wire cpu_vda;
  wire cpu_vpa;
  wire [23:0] cpu_a;
  wire [7:0] cpu_do;
  wire [63:0] cpu_regs;
  wire [7:0] cpu_debug_i;
  wire [7:0] cpu_debug_a;
  wire [7:0] cpu_debug_x;
  wire [7:0] cpu_debug_y;
  wire [7:0] cpu_debug_s;
  wire [7:0] cpu_debug_p;
  wire cpu_nmi_ack;
  localparam [1:0] n1742_o = 2'b00;
  localparam n1743_o = 1'b1;
  wire n1744_o;
  localparam n1745_o = 1'b1;
  localparam n1746_o = 1'b1;
  localparam n1747_o = 1'b1;
  localparam n1748_o = 1'b1;
  assign do = cpudo;
  assign we = cpuwe;
  assign ad = n1739_o;
  assign r = n1740_o;
  /* ./A6507.vhd:39:12  */
  assign ad_full = cpu_a; // (signal)
  /* ./A6507.vhd:40:12  */
  assign cpudi = di; // (signal)
  /* ./A6507.vhd:41:12  */
  assign cpudo = cpu_do; // (signal)
  /* ./A6507.vhd:42:12  */
  assign cpuwe = n1741_o; // (signal)
  /* ./A6507.vhd:43:16  */
  assign cpuwe_n = cpu_r_w_n; // (signal)
  /* ./A6507.vhd:47:35  */
  assign n1739_o = ad_full[12:0];
  /* ./A6507.vhd:48:10  */
  assign n1740_o = ~cpuwe;
  /* ./A6507.vhd:49:18  */
  assign n1741_o = ~cpuwe_n;
  /* ./A6507.vhd:55:9  */
  t65 cpu (
    .mode(n1742_o),
    .bcd_en(n1743_o),
    .res_n(n1744_o),
    .enable(clk_en),
    .clk(clk),
    .rdy(rdy),
    .abort_n(n1745_o),
    .irq_n(n1746_o),
    .nmi_n(n1747_o),
    .so_n(n1748_o),
    .di(cpudi),
    .r_w_n(cpu_r_w_n),
    .sync(),
    .ef(),
    .mf(),
    .xf(),
    .ml_n(),
    .vp_n(),
    .vda(),
    .vpa(),
    .a(cpu_a),
    .do(cpu_do),
    .regs(),
    .debug_i(),
    .debug_a(),
    .debug_x(),
    .debug_y(),
    .debug_s(),
    .debug_p(),
    .nmi_ack());
  /* ./A6507.vhd:58:26  */
  assign n1744_o = ~rst;
endmodule

module ramx8_11
  (input  clk,
   input  r,
   input  [7:0] d_in,
   input  [10:0] a,
   output [7:0] d_out);
  wire n1728_o;
  reg [7:0] n1733_data; // mem_rd
  assign d_out = n1733_data;
  /* ./A6532.vhd:41:13  */
  assign n1728_o = ~r;
  /* ./A6532.vhd:42:30  */
  reg [7:0] ram[2047:0] ; // memory
  always @(posedge clk)
    if (r)
      n1733_data <= ram[a];
  always @(posedge clk)
    if (n1728_o)
      ram[a] <= d_in;
  /* ./A6532.vhd:40:9  */
  /* ./A6532.vhd:44:21  */
endmodule

module paddle
  (input  clk,
   input  hsync,
   input  [7:0] inp,
   input  rst,
   output o);
  wire hsync_d;
  wire [7:0] uinp;
  wire n1675_o;
  wire n1676_o;
  wire [6:0] n1677_o;
  wire [7:0] n1678_o;
  reg [7:0] n1679_cnt;
  wire [6:0] n1683_o;
  wire [7:0] n1685_o;
  wire [5:0] n1686_o;
  wire [7:0] n1688_o;
  wire [7:0] n1689_o;
  wire n1690_o;
  wire n1691_o;
  wire n1693_o;
  wire n1694_o;
  wire [7:0] n1696_o;
  wire [7:0] n1697_o;
  wire [7:0] n1698_o;
  wire n1702_o;
  wire n1705_o;
  reg [7:0] n1707_q;
  reg n1708_q;
  assign o = n1705_o;
  /* ./TIA/TIA.vhd:424:16  */
  assign hsync_d = n1708_q; // (signal)
  /* ./TIA/TIA.vhd:425:16  */
  assign uinp = n1678_o; // (signal)
  /* ./TIA/TIA.vhd:427:24  */
  assign n1675_o = inp[7];
  /* ./TIA/TIA.vhd:427:17  */
  assign n1676_o = ~n1675_o;
  /* ./TIA/TIA.vhd:427:33  */
  assign n1677_o = inp[6:0];
  /* ./TIA/TIA.vhd:427:28  */
  assign n1678_o = {n1676_o, n1677_o};
  /* ./TIA/TIA.vhd:430:26  */
  always @*
    n1679_cnt = n1707_q; // (isignal)
  initial
    n1679_cnt = 8'bX;
  /* ./TIA/TIA.vhd:435:49  */
  assign n1683_o = uinp[7:1];
  /* ./TIA/TIA.vhd:435:44  */
  assign n1685_o = {1'b0, n1683_o};
  /* ./TIA/TIA.vhd:435:75  */
  assign n1686_o = uinp[7:2];
  /* ./TIA/TIA.vhd:435:70  */
  assign n1688_o = {2'b00, n1686_o};
  /* ./TIA/TIA.vhd:435:63  */
  assign n1689_o = n1685_o + n1688_o;
  /* ./TIA/TIA.vhd:436:40  */
  assign n1690_o = ~hsync_d;
  /* ./TIA/TIA.vhd:436:46  */
  assign n1691_o = hsync & n1690_o;
  /* ./TIA/TIA.vhd:436:70  */
  assign n1693_o = $unsigned(n1679_cnt) < $unsigned(8'b11111111);
  /* ./TIA/TIA.vhd:436:62  */
  assign n1694_o = n1693_o & n1691_o;
  /* ./TIA/TIA.vhd:437:44  */
  assign n1696_o = n1679_cnt + 8'b00000001;
  /* ./TIA/TIA.vhd:436:25  */
  assign n1697_o = n1694_o ? n1696_o : n1679_cnt;
  /* ./TIA/TIA.vhd:434:25  */
  assign n1698_o = rst ? n1689_o : n1697_o;
  /* ./TIA/TIA.vhd:442:24  */
  assign n1702_o = $unsigned(n1707_q) >= $unsigned(8'b11000100);
  /* ./TIA/TIA.vhd:442:17  */
  assign n1705_o = n1702_o ? 1'b1 : 1'b0;
  /* ./TIA/TIA.vhd:432:17  */
  always @(posedge clk)
    n1707_q <= n1698_o;
  /* ./TIA/TIA.vhd:432:17  */
  always @(posedge clk)
    n1708_q <= hsync;
endmodule

module a2601
  (input  vid_clk,
   input  clk,
   input  rst,
   input  pause,
   input  [7:0] d,
   input  [7:0] pa,
   input  [7:0] pb,
   input  inpt0,
   input  inpt1,
   input  inpt2,
   input  inpt3,
   input  inpt4,
   input  inpt5,
   input  pal,
   input  decomb,
   output [7:0] dbus,
   output [12:0] a,
   output r,
   output inpt03_chg,
   output [6:0] colu,
   output csyn,
   output vsyn,
   output hsyn,
   output hblank,
   output vblank,
   output [23:0] rgbx2,
   output au0,
   output au1,
   output [3:0] av0,
   output [3:0] av1,
   output ph0_out,
   output ph0_en_out,
   output ph2_out,
   output ph2_en_out);
  wire rdy;
  wire [12:0] cpu_a;
  wire read;
  wire riot_rs;
  wire riot_cs;
  wire [6:0] riot_a;
  wire tia_cs;
  wire [5:0] tia_a;
  wire ph0;
  wire ph0_en;
  wire ph2;
  wire ph2_en;
  wire [7:0] bus_d;
  wire [7:0] cpu_do;
  wire [7:0] riot_do;
  wire [7:0] tia_do;
  wire cpu_we;
  wire [7:0] cpu_a6507_do;
  wire cpu_a6507_we;
  wire [12:0] cpu_a6507_ad;
  wire cpu_a6507_r;
  wire n1624_o;
  wire n1625_o;
  wire riot_a6532_irq;
  wire [7:0] riot_a6532_dout;
  localparam n1631_o = 1'b0;
  wire [7:0] tia_dout;
  wire [6:0] tia_colu;
  wire tia_csyn;
  wire tia_hsyn;
  wire tia_vsyn;
  wire tia_ohblank;
  wire tia_ovblank;
  wire [23:0] tia_rgbx2;
  wire tia_rdy;
  wire tia_ph0;
  wire tia_ph0_en;
  wire tia_ph2;
  wire tia_ph2_en;
  wire tia_au0;
  wire tia_au1;
  wire [3:0] tia_av0;
  wire [3:0] tia_av1;
  wire tia_inpt03_chg;
  wire [7:0] n1650_o;
  wire [7:0] n1651_o;
  wire [7:0] n1652_o;
  wire n1654_o;
  wire n1655_o;
  wire n1656_o;
  wire n1657_o;
  wire n1658_o;
  wire n1659_o;
  wire n1662_o;
  wire n1663_o;
  wire n1664_o;
  wire n1665_o;
  wire n1666_o;
  wire n1669_o;
  wire n1670_o;
  wire [5:0] n1672_o;
  wire [6:0] n1673_o;
  assign dbus = bus_d;
  assign a = cpu_a;
  assign r = read;
  assign inpt03_chg = tia_inpt03_chg;
  assign colu = tia_colu;
  assign csyn = tia_csyn;
  assign vsyn = tia_vsyn;
  assign hsyn = tia_hsyn;
  assign hblank = tia_ohblank;
  assign vblank = tia_ovblank;
  assign rgbx2 = tia_rgbx2;
  assign au0 = tia_au0;
  assign au1 = tia_au1;
  assign av0 = tia_av0;
  assign av1 = tia_av1;
  assign ph0_out = ph0;
  assign ph0_en_out = ph0_en;
  assign ph2_out = ph2;
  assign ph2_en_out = ph2_en;
  /* ./A2601Core.vhd:64:8  */
  assign rdy = tia_rdy; // (signal)
  /* ./A2601Core.vhd:65:8  */
  assign cpu_a = cpu_a6507_ad; // (signal)
  /* ./A2601Core.vhd:66:8  */
  assign read = cpu_a6507_r; // (signal)
  /* ./A2601Core.vhd:67:8  */
  assign riot_rs = n1670_o; // (signal)
  /* ./A2601Core.vhd:68:8  */
  assign riot_cs = n1666_o; // (signal)
  /* ./A2601Core.vhd:70:8  */
  assign riot_a = n1673_o; // (signal)
  /* ./A2601Core.vhd:71:8  */
  assign tia_cs = n1659_o; // (signal)
  /* ./A2601Core.vhd:72:8  */
  assign tia_a = n1672_o; // (signal)
  /* ./A2601Core.vhd:73:8  */
  assign ph0 = tia_ph0; // (signal)
  /* ./A2601Core.vhd:74:8  */
  assign ph0_en = tia_ph0_en; // (signal)
  /* ./A2601Core.vhd:75:8  */
  assign ph2 = tia_ph2; // (signal)
  /* ./A2601Core.vhd:76:8  */
  assign ph2_en = tia_ph2_en; // (signal)
  /* ./A2601Core.vhd:77:8  */
  assign bus_d = n1650_o; // (signal)
  /* ./A2601Core.vhd:77:15  */
  assign cpu_do = cpu_a6507_do; // (signal)
  /* ./A2601Core.vhd:77:23  */
  assign riot_do = riot_a6532_dout; // (signal)
  /* ./A2601Core.vhd:77:32  */
  assign tia_do = tia_dout; // (signal)
  /* ./A2601Core.vhd:78:8  */
  assign cpu_we = cpu_a6507_we; // (signal)
  /* ./A2601Core.vhd:89:1  */
  a6507 cpu_a6507 (
    .clk(clk),
    .clk_en(ph0_en),
    .rst(rst),
    .rdy(n1625_o),
    .di(bus_d),
    .do(cpu_a6507_do),
    .we(cpu_a6507_we),
    .ad(cpu_a6507_ad),
    .r(cpu_a6507_r));
  /* ./A2601Core.vhd:94:24  */
  assign n1624_o = ~pause;
  /* ./A2601Core.vhd:94:20  */
  assign n1625_o = rdy & n1624_o;
  /* ./A2601Core.vhd:102:1  */
  a6532 riot_a6532 (
    .clk(clk),
    .ph2_en(ph2_en),
    .r(read),
    .rs(riot_rs),
    .cs(riot_cs),
    .din(bus_d),
    .pa(pa),
    .pb(pb),
    .pa7(n1631_o),
    .a(riot_a),
    .irq(),
    .dout(riot_a6532_dout));
  /* ./A2601Core.vhd:118:1  */
  tia tia (
    .vid_clk(vid_clk),
    .clk(clk),
    .cs(tia_cs),
    .r(read),
    .a(tia_a),
    .din(bus_d),
    .inpt0(inpt0),
    .inpt1(inpt1),
    .inpt2(inpt2),
    .inpt3(inpt3),
    .inpt4(inpt4),
    .inpt5(inpt5),
    .pal(pal),
    .decomb(decomb),
    .dout(tia_dout),
    .colu(tia_colu),
    .csyn(tia_csyn),
    .hsyn(tia_hsyn),
    .vsyn(tia_vsyn),
    .ohblank(tia_ohblank),
    .ovblank(tia_ovblank),
    .rgbx2(tia_rgbx2),
    .rdy(tia_rdy),
    .ph0(tia_ph0),
    .ph0_en(tia_ph0_en),
    .ph2(tia_ph2),
    .ph2_en(tia_ph2_en),
    .au0(tia_au0),
    .au1(tia_au1),
    .av0(tia_av0),
    .av1(tia_av1),
    .inpt03_chg(tia_inpt03_chg));
  /* ./A2601Core.vhd:154:17  */
  assign n1650_o = cpu_we ? cpu_do : n1651_o;
  /* ./A2601Core.vhd:154:35  */
  assign n1651_o = tia_cs ? tia_do : n1652_o;
  /* ./A2601Core.vhd:155:35  */
  assign n1652_o = riot_cs ? riot_do : d;
  /* ./A2601Core.vhd:160:26  */
  assign n1654_o = cpu_a[12];
  /* ./A2601Core.vhd:160:31  */
  assign n1655_o = ~n1654_o;
  /* ./A2601Core.vhd:160:48  */
  assign n1656_o = cpu_a[7];
  /* ./A2601Core.vhd:160:52  */
  assign n1657_o = ~n1656_o;
  /* ./A2601Core.vhd:160:38  */
  assign n1658_o = n1657_o & n1655_o;
  /* ./A2601Core.vhd:160:15  */
  assign n1659_o = n1658_o ? 1'b1 : 1'b0;
  /* ./A2601Core.vhd:161:27  */
  assign n1662_o = cpu_a[12];
  /* ./A2601Core.vhd:161:32  */
  assign n1663_o = ~n1662_o;
  /* ./A2601Core.vhd:161:49  */
  assign n1664_o = cpu_a[7];
  /* ./A2601Core.vhd:161:39  */
  assign n1665_o = n1664_o & n1663_o;
  /* ./A2601Core.vhd:161:16  */
  assign n1666_o = n1665_o ? 1'b1 : 1'b0;
  /* ./A2601Core.vhd:162:27  */
  assign n1669_o = cpu_a[9];
  /* ./A2601Core.vhd:162:16  */
  assign n1670_o = n1669_o ? 1'b1 : 1'b0;
  /* ./A2601Core.vhd:164:15  */
  assign n1672_o = cpu_a[5:0];
  /* ./A2601Core.vhd:165:16  */
  assign n1673_o = cpu_a[6:0];
endmodule

module A2601top
  (input  reset,
   input  clk,
   input  vid_clk,
   input  p1_l,
   input  p1_r,
   input  p1_u,
   input  p1_d,
   input  p1_f,
   input  p1_f2,
   input  p2_l,
   input  p2_r,
   input  p2_u,
   input  p2_d,
   input  p2_f,
   input  p2_f2,
   input  p_1,
   input  [7:0] paddle_1,
   input  p_2,
   input  [7:0] paddle_2,
   input  p_3,
   input  [7:0] paddle_3,
   input  p_4,
   input  [7:0] paddle_4,
   input  [1:0] p_type,
   input  p_start,
   input  p_select,
   input  p_color,
   input  sc,
   input  [3:0] force_bs,
   input  [7:0] rom_do,
   input  [16:0] rom_size,
   input  pause,
   input  pal,
   input  [1:0] p_dif,
   input  decomb,
   output [3:0] aud0,
   output [3:0] aud1,
   output O_VSYNC,
   output O_HSYNC,
   output O_HBLANK,
   output O_VBLANK,
   output [7:0] O_VIDEO_R,
   output [7:0] O_VIDEO_G,
   output [7:0] O_VIDEO_B,
   output [6:0] O_COLU,
   output [15:0] rom_a);
  wire [7:0] pa;
  wire [7:0] pb;
  wire inpt4;
  wire inpt5;
  wire au0;
  wire au1;
  wire [3:0] av0;
  wire [3:0] av1;
  reg rst;
  reg old_rst;
  wire ph0_en;
  wire [23:0] rgbx2;
  wire hsyn;
  wire vsyn;
  wire sc_r;
  wire [7:0] sc_d_out;
  wire [10:0] sc_a;
  wire [10:0] clr_a;
  reg [3:0] bank;
  reg [4:0] banks32;
  wire last_1ff0;
  wire [1:0] tf_bank;
  wire [2:0] e0_bank;
  reg [2:0] e0_bank0;
  reg [2:0] e0_bank1;
  reg [2:0] e0_bank2;
  wire fe_latch;
  wire [2:0] e7_bank0;
  wire [1:0] e7_rambank;
  wire [12:0] cpu_a;
  wire [7:0] cpu_d;
  wire [7:0] cart_d;
  reg [3:0] bss;
  reg paddle_ena12;
  reg paddle_ena34;
  wire inpt03_chg;
  wire inpt0;
  wire pd0;
  wire inpt1;
  wire pd1;
  wire inpt2;
  wire pd2;
  wire inpt3;
  wire pd3;
  reg [63:0] soundamplitudes;
  reg [23:0] dpcmusicmodes;
  reg [23:0] dpcmusicflags;
  reg [63:0] dpctops;
  reg [63:0] dpcbottoms;
  reg [63:0] dpcflags;
  reg [87:0] dpccounters;
  reg [7:0] dpcrandom;
  reg [15:0] dpcclocks;
  wire [9:0] dpcclockdivider;
  wire [7:0] ms_a2601_dbus;
  wire [12:0] ms_a2601_a;
  wire ms_a2601_r;
  wire ms_a2601_inpt03_chg;
  wire [6:0] ms_a2601_colu;
  wire ms_a2601_csyn;
  wire ms_a2601_vsyn;
  wire ms_a2601_hsyn;
  wire ms_a2601_hblank;
  wire ms_a2601_vblank;
  wire [23:0] ms_a2601_rgbx2;
  wire ms_a2601_au0;
  wire ms_a2601_au1;
  wire [3:0] ms_a2601_av0;
  wire [3:0] ms_a2601_av1;
  wire ms_a2601_ph0_out;
  wire ms_a2601_ph0_en_out;
  wire ms_a2601_ph2_out;
  wire ms_a2601_ph2_en_out;
  wire [7:0] n48_o;
  wire [7:0] n49_o;
  wire [7:0] n50_o;
  wire n60_o;
  wire n62_o;
  wire n63_o;
  wire n64_o;
  wire n65_o;
  wire n67_o;
  wire n68_o;
  wire n70_o;
  wire n71_o;
  wire n72_o;
  wire n73_o;
  wire n75_o;
  wire n79_o;
  wire n80_o;
  wire [1:0] n84_o;
  wire [2:0] n85_o;
  wire [3:0] n86_o;
  wire n87_o;
  wire [3:0] n88_o;
  wire [1:0] n89_o;
  wire [3:0] n91_o;
  wire [1:0] n92_o;
  wire [2:0] n93_o;
  wire [3:0] n94_o;
  wire n95_o;
  wire [3:0] n96_o;
  wire [1:0] n97_o;
  wire [3:0] n99_o;
  wire paddle0_o;
  wire paddle1_o;
  wire paddle2_o;
  wire paddle3_o;
  wire n104_o;
  wire n106_o;
  wire n107_o;
  wire n109_o;
  wire n110_o;
  wire n111_o;
  wire [3:0] n112_o;
  wire [3:0] n114_o;
  wire [7:0] ram_d_out;
  wire n118_o;
  wire n121_o;
  wire [2:0] n122_o;
  wire n124_o;
  wire n125_o;
  wire n126_o;
  wire n129_o;
  wire [2:0] n130_o;
  wire n132_o;
  wire n133_o;
  wire n134_o;
  wire n137_o;
  wire [4:0] n138_o;
  wire n140_o;
  wire n141_o;
  wire n142_o;
  wire n145_o;
  wire [4:0] n146_o;
  wire n148_o;
  wire n149_o;
  wire n150_o;
  wire n153_o;
  wire [1:0] n154_o;
  wire n156_o;
  wire n157_o;
  wire n158_o;
  wire n160_o;
  wire n161_o;
  wire n162_o;
  wire n163_o;
  wire n166_o;
  wire [2:0] n167_o;
  wire n169_o;
  wire n170_o;
  wire n172_o;
  wire n173_o;
  wire n174_o;
  wire n177_o;
  wire [4:0] n178_o;
  wire n180_o;
  wire n181_o;
  wire n182_o;
  wire n185_o;
  wire [4:0] n186_o;
  wire n188_o;
  wire n189_o;
  wire n190_o;
  wire [5:0] n192_o;
  wire n194_o;
  wire n195_o;
  wire n196_o;
  wire n197_o;
  wire [10:0] n199_o;
  wire [9:0] n200_o;
  wire [10:0] n202_o;
  wire n204_o;
  wire [10:0] n205_o;
  wire [7:0] n206_o;
  wire [10:0] n208_o;
  wire n210_o;
  wire [10:0] n211_o;
  wire [9:0] n212_o;
  wire [10:0] n214_o;
  wire n216_o;
  wire [1:0] n217_o;
  wire n219_o;
  wire n220_o;
  wire [10:0] n221_o;
  wire [2:0] n223_o;
  wire [7:0] n224_o;
  wire [10:0] n225_o;
  wire n227_o;
  wire [3:0] n228_o;
  wire n230_o;
  wire n231_o;
  wire [10:0] n232_o;
  wire [6:0] n233_o;
  wire [10:0] n235_o;
  wire n244_o;
  wire n246_o;
  wire n247_o;
  wire n249_o;
  wire n250_o;
  wire n252_o;
  wire n254_o;
  wire n255_o;
  wire n257_o;
  wire n258_o;
  wire [2:0] n259_o;
  wire [2:0] n262_o;
  wire [7:0] n265_o;
  wire n267_o;
  wire n269_o;
  wire n270_o;
  wire n272_o;
  wire n273_o;
  wire n275_o;
  wire n277_o;
  wire n278_o;
  wire n280_o;
  wire n281_o;
  wire n282_o;
  wire n283_o;
  wire n284_o;
  wire n287_o;
  localparam [2:0] n288_o = 3'b000;
  wire n290_o;
  wire n291_o;
  wire n292_o;
  wire n294_o;
  wire n295_o;
  wire n296_o;
  wire n297_o;
  wire n298_o;
  wire n299_o;
  wire n301_o;
  wire [2:0] n302_o;
  wire [2:0] n305_o;
  wire n309_o;
  wire n311_o;
  wire n312_o;
  wire n314_o;
  wire n315_o;
  wire [2:0] n316_o;
  wire [2:0] n319_o;
  wire n323_o;
  wire n325_o;
  wire n326_o;
  wire n328_o;
  wire n329_o;
  wire n331_o;
  wire [2:0] n332_o;
  wire n334_o;
  wire n335_o;
  wire n337_o;
  wire [2:0] n338_o;
  wire n340_o;
  wire n341_o;
  wire n343_o;
  wire [4:0] n344_o;
  wire n346_o;
  wire n347_o;
  wire n349_o;
  wire [4:0] n350_o;
  wire n352_o;
  wire n353_o;
  wire n355_o;
  wire [2:0] n356_o;
  wire n358_o;
  wire n359_o;
  wire n361_o;
  wire n362_o;
  wire n364_o;
  wire [2:0] n365_o;
  wire n367_o;
  wire n368_o;
  wire n370_o;
  wire n371_o;
  wire n373_o;
  wire [4:0] n374_o;
  wire n376_o;
  wire n377_o;
  wire n379_o;
  wire [4:0] n380_o;
  wire n382_o;
  wire n383_o;
  wire [5:0] n384_o;
  wire n386_o;
  wire n387_o;
  wire [5:0] n388_o;
  wire n390_o;
  wire n391_o;
  wire n392_o;
  wire [7:0] n394_o;
  wire [7:0] n396_o;
  wire [7:0] n397_o;
  wire [7:0] n399_o;
  wire [7:0] n400_o;
  wire [7:0] n402_o;
  wire [7:0] n403_o;
  wire [7:0] n405_o;
  wire [7:0] n406_o;
  wire [7:0] n408_o;
  wire [7:0] n409_o;
  wire [7:0] n411_o;
  wire [7:0] n412_o;
  wire [7:0] n413_o;
  wire [7:0] n416_o;
  wire [7:0] n418_o;
  wire [7:0] n420_o;
  wire [1:0] n424_o;
  wire n426_o;
  wire n428_o;
  wire n430_o;
  wire n433_o;
  wire [3:0] n435_o;
  reg [2:0] n436_o;
  wire [1:0] n437_o;
  wire n438_o;
  wire n439_o;
  wire [1:0] n440_o;
  wire [5:0] n443_o;
  wire [9:0] n444_o;
  wire [15:0] n445_o;
  wire n447_o;
  wire [15:0] n448_o;
  wire [4:0] n450_o;
  wire [10:0] n451_o;
  wire [15:0] n452_o;
  wire n454_o;
  wire [15:0] n455_o;
  wire [2:0] n456_o;
  wire [10:0] n460_o;
  wire [15:0] n462_o;
  wire n464_o;
  wire n466_o;
  wire n467_o;
  wire n469_o;
  wire n470_o;
  wire [15:0] n471_o;
  wire [10:0] n472_o;
  wire [15:0] n474_o;
  wire n476_o;
  wire [15:0] n477_o;
  wire [10:0] n478_o;
  wire [15:0] n480_o;
  wire n482_o;
  wire [15:0] n483_o;
  wire [4:0] n485_o;
  wire [10:0] n486_o;
  wire [15:0] n487_o;
  wire n489_o;
  wire [1:0] n490_o;
  wire n492_o;
  wire n493_o;
  wire [15:0] n494_o;
  wire [10:0] n495_o;
  wire [15:0] n497_o;
  wire n499_o;
  wire [1:0] n500_o;
  wire n502_o;
  wire [2:0] n503_o;
  wire n505_o;
  wire n506_o;
  wire n507_o;
  wire [15:0] n508_o;
  wire [10:0] n509_o;
  wire [15:0] n510_o;
  wire n512_o;
  wire [15:0] n513_o;
  wire [11:0] n514_o;
  wire [15:0] n515_o;
  reg [12:0] bankswch_addr_v;
  wire [10:0] n522_o;
  wire n523_o;
  wire [4:0] n525_o;
  wire [4:0] n526_o;
  wire n528_o;
  wire [4:0] n530_o;
  wire n532_o;
  wire n534_o;
  wire n536_o;
  wire [3:0] n538_o;
  wire [3:0] n540_o;
  wire [3:0] n542_o;
  wire n544_o;
  wire n546_o;
  wire n548_o;
  wire [3:0] n550_o;
  wire [3:0] n552_o;
  wire n554_o;
  wire n556_o;
  wire n558_o;
  wire n560_o;
  wire n562_o;
  wire [3:0] n564_o;
  wire [3:0] n566_o;
  wire [3:0] n568_o;
  wire [3:0] n570_o;
  wire n572_o;
  wire n574_o;
  wire n576_o;
  wire n578_o;
  wire n580_o;
  wire n582_o;
  wire n584_o;
  wire n586_o;
  wire n588_o;
  wire [3:0] n590_o;
  wire [3:0] n592_o;
  wire [3:0] n594_o;
  wire [3:0] n596_o;
  wire [3:0] n598_o;
  wire [3:0] n600_o;
  wire [3:0] n602_o;
  wire [3:0] n604_o;
  wire n606_o;
  wire n607_o;
  wire n608_o;
  wire [2:0] n609_o;
  wire [30:0] n610_o;
  wire [31:0] n611_o;
  wire [6:0] n612_o;
  wire n614_o;
  wire [2:0] n615_o;
  wire n616_o;
  wire n617_o;
  wire [6:0] n618_o;
  wire n619_o;
  wire n620_o;
  wire n621_o;
  wire n622_o;
  wire n623_o;
  wire n624_o;
  wire n625_o;
  wire n626_o;
  wire [7:0] n627_o;
  wire [7:0] n628_o;
  wire n630_o;
  reg [7:0] n631_o;
  wire [2:0] n632_o;
  wire n636_o;
  wire n638_o;
  wire [31:0] n640_o;
  wire [1:0] n641_o;
  wire n644_o;
  wire n645_o;
  wire [2:0] n646_o;
  wire [10:0] n650_o;
  wire [10:0] n651_o;
  wire [2:0] n652_o;
  wire [7:0] n655_o;
  wire [2:0] n656_o;
  wire [2:0] n658_o;
  wire n661_o;
  wire [2:0] n662_o;
  wire [2:0] n664_o;
  wire [7:0] n668_o;
  wire [2:0] n669_o;
  wire [2:0] n671_o;
  wire n674_o;
  wire [2:0] n675_o;
  wire [2:0] n677_o;
  wire [63:0] n681_o;
  wire [63:0] n682_o;
  wire [6:0] n683_o;
  wire n685_o;
  wire [2:0] n686_o;
  wire [2:0] n687_o;
  wire [2:0] n689_o;
  wire [2:0] n692_o;
  wire n695_o;
  wire [2:0] n696_o;
  wire [2:0] n698_o;
  wire [2:0] n702_o;
  wire [2:0] n704_o;
  wire [63:0] n708_o;
  wire n710_o;
  wire [2:0] n711_o;
  wire [2:0] n713_o;
  wire n717_o;
  wire [2:0] n718_o;
  wire n722_o;
  wire [2:0] n723_o;
  wire [2:0] n725_o;
  wire n728_o;
  wire [31:0] n730_o;
  wire [1:0] n731_o;
  wire n733_o;
  wire [3:0] n735_o;
  wire [7:0] n737_o;
  wire [23:0] n739_o;
  wire n741_o;
  wire n743_o;
  wire [4:0] n744_o;
  reg [23:0] n745_o;
  reg [63:0] n746_o;
  reg [63:0] n747_o;
  reg [63:0] n748_o;
  reg [87:0] n749_o;
  reg [7:0] n751_o;
  wire n753_o;
  wire n755_o;
  wire [3:0] n757_o;
  wire [3:0] n759_o;
  wire [3:0] n760_o;
  wire [23:0] n761_o;
  wire [63:0] n762_o;
  wire [63:0] n763_o;
  wire [63:0] n764_o;
  wire [87:0] n765_o;
  wire [7:0] n766_o;
  wire [3:0] n767_o;
  wire [23:0] n768_o;
  wire [63:0] n769_o;
  wire [63:0] n770_o;
  wire [63:0] n771_o;
  wire [87:0] n772_o;
  wire [7:0] n773_o;
  wire [3:0] n775_o;
  wire [23:0] n776_o;
  wire [63:0] n777_o;
  wire [63:0] n778_o;
  wire [63:0] n779_o;
  wire [87:0] n780_o;
  wire [7:0] n781_o;
  wire n784_o;
  wire n785_o;
  wire n786_o;
  wire n787_o;
  wire n788_o;
  wire n789_o;
  wire n790_o;
  wire [12:0] n792_o;
  wire n795_o;
  wire n796_o;
  wire n797_o;
  wire [3:0] n799_o;
  wire [3:0] n800_o;
  wire n802_o;
  wire n805_o;
  wire n807_o;
  wire [8:0] n808_o;
  wire n810_o;
  wire n811_o;
  wire n812_o;
  wire n813_o;
  wire [2:0] n814_o;
  wire [8:0] n815_o;
  wire n817_o;
  wire n818_o;
  wire n819_o;
  wire [2:0] n820_o;
  wire [8:0] n821_o;
  wire n823_o;
  wire n824_o;
  wire n825_o;
  wire n826_o;
  wire [2:0] n827_o;
  wire [2:0] n828_o;
  wire [2:0] n829_o;
  wire [2:0] n830_o;
  wire [2:0] n831_o;
  wire [2:0] n832_o;
  wire [2:0] n833_o;
  wire n835_o;
  wire n837_o;
  wire [1:0] n838_o;
  wire [1:0] n839_o;
  wire [1:0] n840_o;
  wire n842_o;
  wire n844_o;
  wire n846_o;
  wire [3:0] n848_o;
  wire [3:0] n850_o;
  wire n852_o;
  wire [8:0] n853_o;
  wire n855_o;
  wire n856_o;
  wire n857_o;
  wire [2:0] n858_o;
  wire n859_o;
  wire n860_o;
  wire [1:0] n861_o;
  wire [1:0] n862_o;
  wire [2:0] n863_o;
  wire [1:0] n864_o;
  wire n865_o;
  wire [1:0] n866_o;
  wire n868_o;
  wire n870_o;
  wire n871_o;
  wire [3:0] n873_o;
  wire [3:0] n874_o;
  wire n875_o;
  wire n878_o;
  wire n880_o;
  wire [10:0] n881_o;
  wire [1:0] n882_o;
  wire [1:0] n883_o;
  wire [1:0] n884_o;
  wire [1:0] n885_o;
  wire [1:0] n886_o;
  wire [1:0] n887_o;
  wire [1:0] n888_o;
  wire [1:0] n889_o;
  wire [1:0] n890_o;
  reg [1:0] n891_o;
  wire [1:0] n892_o;
  wire [1:0] n893_o;
  wire [1:0] n894_o;
  wire [1:0] n895_o;
  wire [1:0] n896_o;
  wire [1:0] n897_o;
  wire [1:0] n898_o;
  wire [1:0] n899_o;
  wire [1:0] n900_o;
  reg [1:0] n901_o;
  reg n902_o;
  reg [2:0] n903_o;
  reg [2:0] n904_o;
  reg [2:0] n905_o;
  reg n906_o;
  reg [2:0] n907_o;
  reg [1:0] n908_o;
  reg [23:0] n909_o;
  reg [63:0] n910_o;
  reg [63:0] n911_o;
  reg [63:0] n912_o;
  reg [87:0] n913_o;
  reg [7:0] n914_o;
  reg [12:0] n916_o;
  wire [3:0] n918_o;
  wire [3:0] n920_o;
  wire n923_o;
  wire [2:0] n925_o;
  wire [2:0] n927_o;
  wire [2:0] n929_o;
  wire n930_o;
  wire [2:0] n931_o;
  wire [1:0] n932_o;
  wire [23:0] n933_o;
  wire [63:0] n934_o;
  wire [63:0] n935_o;
  wire [63:0] n936_o;
  wire [87:0] n937_o;
  wire [7:0] n938_o;
  wire [12:0] n940_o;
  wire n945_o;
  wire [12:0] n985_o;
  reg [12:0] n986_q;
  wire n992_o;
  wire n994_o;
  wire n996_o;
  wire n998_o;
  wire n1000_o;
  wire n1002_o;
  wire n1004_o;
  wire n1006_o;
  wire n1008_o;
  wire [3:0] n1011_o;
  wire [3:0] n1013_o;
  wire [3:0] n1015_o;
  wire [3:0] n1017_o;
  wire [3:0] n1019_o;
  wire [3:0] n1021_o;
  wire [3:0] n1023_o;
  wire [3:0] n1025_o;
  wire [3:0] n1026_o;
  wire [9:0] n1032_o;
  wire n1034_o;
  wire [9:0] n1036_o;
  wire n1038_o;
  wire [15:0] n1040_o;
  wire [30:0] n1041_o;
  wire [31:0] n1042_o;
  wire [7:0] n1043_o;
  wire [7:0] n1045_o;
  wire [30:0] n1046_o;
  wire [31:0] n1047_o;
  wire [31:0] n1048_o;
  wire [7:0] n1049_o;
  wire [7:0] n1050_o;
  wire n1051_o;
  wire [7:0] n1054_o;
  wire [30:0] n1055_o;
  wire [31:0] n1056_o;
  wire [7:0] n1057_o;
  wire [7:0] n1059_o;
  wire [30:0] n1060_o;
  wire [31:0] n1061_o;
  wire [31:0] n1062_o;
  wire [7:0] n1063_o;
  wire [7:0] n1064_o;
  wire n1065_o;
  wire [7:0] n1068_o;
  wire [30:0] n1069_o;
  wire [31:0] n1070_o;
  wire [7:0] n1071_o;
  wire [7:0] n1073_o;
  wire [30:0] n1074_o;
  wire [31:0] n1075_o;
  wire [31:0] n1076_o;
  wire [7:0] n1077_o;
  wire [7:0] n1078_o;
  wire n1079_o;
  wire [7:0] n1082_o;
  wire [23:0] n1083_o;
  wire [7:0] n1091_o;
  wire [7:0] n1092_o;
  wire n1093_o;
  reg n1094_q;
  wire n1095_o;
  reg n1096_q;
  wire [10:0] n1100_o;
  reg [10:0] n1101_q;
  wire [3:0] n1102_o;
  reg [3:0] n1103_q;
  wire [4:0] n1104_o;
  reg [4:0] n1105_q;
  wire n1106_o;
  reg n1107_q;
  wire [2:0] n1108_o;
  reg [2:0] n1109_q;
  wire [2:0] n1110_o;
  reg [2:0] n1111_q;
  wire [2:0] n1112_o;
  reg [2:0] n1113_q;
  wire n1114_o;
  reg n1115_q;
  wire [2:0] n1116_o;
  reg [2:0] n1117_q;
  wire [1:0] n1118_o;
  reg [1:0] n1119_q;
  reg n1120_q;
  reg n1121_q;
  wire [23:0] n1122_o;
  reg [23:0] n1123_q;
  wire [23:0] n1124_o;
  reg [23:0] n1125_q;
  wire [63:0] n1126_o;
  reg [63:0] n1127_q;
  wire [63:0] n1128_o;
  reg [63:0] n1129_q;
  wire [63:0] n1130_o;
  reg [63:0] n1131_q;
  wire [87:0] n1132_o;
  reg [87:0] n1133_q;
  wire [7:0] n1134_o;
  reg [7:0] n1135_q;
  wire [15:0] n1136_o;
  reg [15:0] n1137_q;
  reg [9:0] n1138_q;
  wire [7:0] n1140_data; // mem_rd
  wire [7:0] n1141_o;
  wire [7:0] n1142_o;
  wire [7:0] n1143_o;
  wire [7:0] n1144_o;
  wire [7:0] n1145_o;
  wire [7:0] n1146_o;
  wire [7:0] n1147_o;
  wire [7:0] n1148_o;
  wire [1:0] n1149_o;
  reg [7:0] n1150_o;
  wire [1:0] n1151_o;
  reg [7:0] n1152_o;
  wire n1153_o;
  wire [7:0] n1154_o;
  wire [7:0] n1155_o;
  wire [7:0] n1156_o;
  wire [7:0] n1157_o;
  wire [7:0] n1158_o;
  wire [7:0] n1159_o;
  wire [7:0] n1160_o;
  wire [7:0] n1161_o;
  wire [7:0] n1162_o;
  wire [1:0] n1163_o;
  reg [7:0] n1164_o;
  wire [1:0] n1165_o;
  reg [7:0] n1166_o;
  wire n1167_o;
  wire [7:0] n1168_o;
  wire [10:0] n1169_o;
  wire [10:0] n1170_o;
  wire [10:0] n1171_o;
  wire [10:0] n1172_o;
  wire [10:0] n1173_o;
  wire [10:0] n1174_o;
  wire [10:0] n1175_o;
  wire [10:0] n1176_o;
  wire [1:0] n1177_o;
  reg [10:0] n1178_o;
  wire [1:0] n1179_o;
  reg [10:0] n1180_o;
  wire n1181_o;
  wire [10:0] n1182_o;
  wire [10:0] n1183_o;
  wire [10:0] n1184_o;
  wire [10:0] n1185_o;
  wire [10:0] n1186_o;
  wire [10:0] n1187_o;
  wire [10:0] n1188_o;
  wire [10:0] n1189_o;
  wire [10:0] n1190_o;
  wire [1:0] n1191_o;
  reg [10:0] n1192_o;
  wire [1:0] n1193_o;
  reg [10:0] n1194_o;
  wire n1195_o;
  wire [10:0] n1196_o;
  wire n1197_o;
  wire n1198_o;
  wire n1199_o;
  wire n1200_o;
  wire n1201_o;
  wire n1202_o;
  wire n1203_o;
  wire [10:0] n1204_o;
  wire [10:0] n1205_o;
  wire [10:0] n1206_o;
  wire [10:0] n1207_o;
  wire [10:0] n1208_o;
  wire [10:0] n1209_o;
  wire [10:0] n1210_o;
  wire [10:0] n1211_o;
  wire [1:0] n1212_o;
  reg [10:0] n1213_o;
  wire [1:0] n1214_o;
  reg [10:0] n1215_o;
  wire n1216_o;
  wire [10:0] n1217_o;
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
  wire [10:0] n1236_o;
  wire [10:0] n1237_o;
  wire [10:0] n1238_o;
  wire [10:0] n1239_o;
  wire [10:0] n1240_o;
  wire [10:0] n1241_o;
  wire [10:0] n1242_o;
  wire [10:0] n1243_o;
  wire [10:0] n1244_o;
  wire [10:0] n1245_o;
  wire [10:0] n1246_o;
  wire [10:0] n1247_o;
  wire [10:0] n1248_o;
  wire [10:0] n1249_o;
  wire [10:0] n1250_o;
  wire [10:0] n1251_o;
  wire [87:0] n1252_o;
  wire [7:0] n1253_o;
  wire [7:0] n1254_o;
  wire [7:0] n1255_o;
  wire [7:0] n1256_o;
  wire [7:0] n1257_o;
  wire [7:0] n1258_o;
  wire [7:0] n1259_o;
  wire [7:0] n1260_o;
  wire [1:0] n1261_o;
  reg [7:0] n1262_o;
  wire [1:0] n1263_o;
  reg [7:0] n1264_o;
  wire n1265_o;
  wire [7:0] n1266_o;
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
  wire [7:0] n1285_o;
  wire [7:0] n1286_o;
  wire [7:0] n1287_o;
  wire [7:0] n1288_o;
  wire [7:0] n1289_o;
  wire [7:0] n1290_o;
  wire [7:0] n1291_o;
  wire [7:0] n1292_o;
  wire [7:0] n1293_o;
  wire [7:0] n1294_o;
  wire [7:0] n1295_o;
  wire [7:0] n1296_o;
  wire [7:0] n1297_o;
  wire [7:0] n1298_o;
  wire [7:0] n1299_o;
  wire [7:0] n1300_o;
  wire [63:0] n1301_o;
  wire [7:0] n1302_o;
  wire [7:0] n1303_o;
  wire [7:0] n1304_o;
  wire [7:0] n1305_o;
  wire [7:0] n1306_o;
  wire [7:0] n1307_o;
  wire [7:0] n1308_o;
  wire [7:0] n1309_o;
  wire [1:0] n1310_o;
  reg [7:0] n1311_o;
  wire [1:0] n1312_o;
  reg [7:0] n1313_o;
  wire n1314_o;
  wire [7:0] n1315_o;
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
  wire [7:0] n1334_o;
  wire [7:0] n1335_o;
  wire [7:0] n1336_o;
  wire [7:0] n1337_o;
  wire [7:0] n1338_o;
  wire [7:0] n1339_o;
  wire [7:0] n1340_o;
  wire [7:0] n1341_o;
  wire [7:0] n1342_o;
  wire [7:0] n1343_o;
  wire [7:0] n1344_o;
  wire [7:0] n1345_o;
  wire [7:0] n1346_o;
  wire [7:0] n1347_o;
  wire [7:0] n1348_o;
  wire [7:0] n1349_o;
  wire [63:0] n1350_o;
  wire n1351_o;
  wire n1352_o;
  wire n1353_o;
  wire n1354_o;
  wire n1355_o;
  wire n1356_o;
  wire n1357_o;
  wire n1358_o;
  wire n1359_o;
  wire n1360_o;
  wire n1361_o;
  wire n1362_o;
  wire n1363_o;
  wire n1364_o;
  wire n1365_o;
  wire n1366_o;
  wire n1367_o;
  wire n1368_o;
  wire [7:0] n1369_o;
  wire [7:0] n1370_o;
  wire [7:0] n1371_o;
  wire [7:0] n1372_o;
  wire [7:0] n1373_o;
  wire [7:0] n1374_o;
  wire [7:0] n1375_o;
  wire [7:0] n1376_o;
  wire [7:0] n1377_o;
  wire [7:0] n1378_o;
  wire [7:0] n1379_o;
  wire [7:0] n1380_o;
  wire [7:0] n1381_o;
  wire [7:0] n1382_o;
  wire [7:0] n1383_o;
  wire [7:0] n1384_o;
  wire [63:0] n1385_o;
  wire [7:0] n1386_o;
  wire [7:0] n1387_o;
  wire [7:0] n1388_o;
  wire [7:0] n1389_o;
  wire [7:0] n1390_o;
  wire [7:0] n1391_o;
  wire [7:0] n1392_o;
  wire [7:0] n1393_o;
  wire [1:0] n1394_o;
  reg [7:0] n1395_o;
  wire [1:0] n1396_o;
  reg [7:0] n1397_o;
  wire n1398_o;
  wire [7:0] n1399_o;
  wire n1400_o;
  wire n1401_o;
  wire n1402_o;
  wire n1403_o;
  wire n1404_o;
  wire n1405_o;
  wire n1406_o;
  wire n1407_o;
  wire n1408_o;
  wire n1409_o;
  wire n1410_o;
  wire n1411_o;
  wire n1412_o;
  wire n1413_o;
  wire n1414_o;
  wire n1415_o;
  wire n1416_o;
  wire n1417_o;
  wire [7:0] n1418_o;
  wire [7:0] n1419_o;
  wire [7:0] n1420_o;
  wire [7:0] n1421_o;
  wire [7:0] n1422_o;
  wire [7:0] n1423_o;
  wire [7:0] n1424_o;
  wire [7:0] n1425_o;
  wire [7:0] n1426_o;
  wire [7:0] n1427_o;
  wire [7:0] n1428_o;
  wire [7:0] n1429_o;
  wire [7:0] n1430_o;
  wire [7:0] n1431_o;
  wire [7:0] n1432_o;
  wire [7:0] n1433_o;
  wire [63:0] n1434_o;
  wire n1435_o;
  wire n1436_o;
  wire n1437_o;
  wire n1438_o;
  wire n1439_o;
  wire n1440_o;
  wire n1441_o;
  wire n1442_o;
  wire n1443_o;
  wire n1444_o;
  wire n1445_o;
  wire n1446_o;
  wire n1447_o;
  wire n1448_o;
  wire n1449_o;
  wire n1450_o;
  wire n1451_o;
  wire n1452_o;
  wire [7:0] n1453_o;
  wire [7:0] n1454_o;
  wire [7:0] n1455_o;
  wire [7:0] n1456_o;
  wire [7:0] n1457_o;
  wire [7:0] n1458_o;
  wire [7:0] n1459_o;
  wire [7:0] n1460_o;
  wire [7:0] n1461_o;
  wire [7:0] n1462_o;
  wire [7:0] n1463_o;
  wire [7:0] n1464_o;
  wire [7:0] n1465_o;
  wire [7:0] n1466_o;
  wire [7:0] n1467_o;
  wire [7:0] n1468_o;
  wire [63:0] n1469_o;
  wire n1470_o;
  wire n1471_o;
  wire n1472_o;
  wire n1473_o;
  wire n1474_o;
  wire n1475_o;
  wire n1476_o;
  wire n1477_o;
  wire n1478_o;
  wire n1479_o;
  wire n1480_o;
  wire n1481_o;
  wire n1482_o;
  wire n1483_o;
  wire n1484_o;
  wire n1485_o;
  wire n1486_o;
  wire n1487_o;
  wire [7:0] n1488_o;
  wire [7:0] n1489_o;
  wire [7:0] n1490_o;
  wire [7:0] n1491_o;
  wire [7:0] n1492_o;
  wire [7:0] n1493_o;
  wire [7:0] n1494_o;
  wire [7:0] n1495_o;
  wire [7:0] n1496_o;
  wire [7:0] n1497_o;
  wire [7:0] n1498_o;
  wire [7:0] n1499_o;
  wire [7:0] n1500_o;
  wire [7:0] n1501_o;
  wire [7:0] n1502_o;
  wire [7:0] n1503_o;
  wire [63:0] n1504_o;
  wire n1505_o;
  wire n1506_o;
  wire n1507_o;
  wire n1508_o;
  wire n1509_o;
  wire n1510_o;
  wire n1511_o;
  wire n1512_o;
  wire n1513_o;
  wire n1514_o;
  wire n1515_o;
  wire n1516_o;
  wire n1517_o;
  wire n1518_o;
  wire n1519_o;
  wire n1520_o;
  wire n1521_o;
  wire n1522_o;
  wire [7:0] n1523_o;
  wire [7:0] n1524_o;
  wire [2:0] n1525_o;
  wire [7:0] n1526_o;
  wire [7:0] n1527_o;
  wire [2:0] n1528_o;
  wire [7:0] n1529_o;
  wire [7:0] n1530_o;
  wire [2:0] n1531_o;
  wire [7:0] n1532_o;
  wire [7:0] n1533_o;
  wire [2:0] n1534_o;
  wire [7:0] n1535_o;
  wire [7:0] n1536_o;
  wire [2:0] n1537_o;
  wire [7:0] n1538_o;
  wire [7:0] n1539_o;
  wire [2:0] n1540_o;
  wire [7:0] n1541_o;
  wire [7:0] n1542_o;
  wire [2:0] n1543_o;
  wire [7:0] n1544_o;
  wire [7:0] n1545_o;
  wire [2:0] n1546_o;
  wire [87:0] n1547_o;
  wire n1548_o;
  wire n1549_o;
  wire n1550_o;
  wire n1551_o;
  wire n1552_o;
  wire n1553_o;
  wire n1554_o;
  wire n1555_o;
  wire n1556_o;
  wire n1557_o;
  wire n1558_o;
  wire n1559_o;
  wire n1560_o;
  wire n1561_o;
  wire n1562_o;
  wire n1563_o;
  wire n1564_o;
  wire n1565_o;
  wire [7:0] n1566_o;
  wire [2:0] n1567_o;
  wire [2:0] n1568_o;
  wire [7:0] n1569_o;
  wire [2:0] n1570_o;
  wire [2:0] n1571_o;
  wire [7:0] n1572_o;
  wire [2:0] n1573_o;
  wire [2:0] n1574_o;
  wire [7:0] n1575_o;
  wire [2:0] n1576_o;
  wire [2:0] n1577_o;
  wire [7:0] n1578_o;
  wire [2:0] n1579_o;
  wire [2:0] n1580_o;
  wire [7:0] n1581_o;
  wire [2:0] n1582_o;
  wire [2:0] n1583_o;
  wire [7:0] n1584_o;
  wire [2:0] n1585_o;
  wire [2:0] n1586_o;
  wire [7:0] n1587_o;
  wire [2:0] n1588_o;
  wire [2:0] n1589_o;
  wire [87:0] n1590_o;
  wire n1591_o;
  wire n1592_o;
  wire n1593_o;
  wire n1594_o;
  wire n1595_o;
  wire n1596_o;
  wire n1597_o;
  wire [7:0] n1598_o;
  wire [7:0] n1599_o;
  wire [7:0] n1600_o;
  wire [7:0] n1601_o;
  wire [7:0] n1602_o;
  wire [7:0] n1603_o;
  wire [23:0] n1604_o;
  assign aud0 = n112_o;
  assign aud1 = n114_o;
  assign O_VSYNC = vsyn;
  assign O_HSYNC = hsyn;
  assign O_HBLANK = ms_a2601_hblank;
  assign O_VBLANK = ms_a2601_vblank;
  assign O_VIDEO_R = n48_o;
  assign O_VIDEO_G = n49_o;
  assign O_VIDEO_B = n50_o;
  assign O_COLU = ms_a2601_colu;
  assign rom_a = n448_o;
  /* ./A2601top.vhd:102:8  */
  assign pa = n1091_o; // (signal)
  /* ./A2601top.vhd:103:8  */
  assign pb = n1092_o; // (signal)
  /* ./A2601top.vhd:104:8  */
  assign inpt4 = n110_o; // (signal)
  /* ./A2601top.vhd:105:8  */
  assign inpt5 = n111_o; // (signal)
  /* ./A2601top.vhd:106:8  */
  assign au0 = ms_a2601_au0; // (signal)
  /* ./A2601top.vhd:107:8  */
  assign au1 = ms_a2601_au1; // (signal)
  /* ./A2601top.vhd:108:8  */
  assign av0 = ms_a2601_av0; // (signal)
  /* ./A2601top.vhd:109:8  */
  assign av1 = ms_a2601_av1; // (signal)
  /* ./A2601top.vhd:111:8  */
  always @*
    rst = n1094_q; // (isignal)
  initial
    rst = 1'b1;
  /* ./A2601top.vhd:112:8  */
  always @*
    old_rst = n1096_q; // (isignal)
  initial
    old_rst = 1'b1;
  /* ./A2601top.vhd:115:8  */
  assign ph0_en = ms_a2601_ph0_en_out; // (signal)
  /* ./A2601top.vhd:117:8  */
  assign rgbx2 = ms_a2601_rgbx2; // (signal)
  /* ./A2601top.vhd:118:8  */
  assign hsyn = ms_a2601_hsyn; // (signal)
  /* ./A2601top.vhd:119:8  */
  assign vsyn = ms_a2601_vsyn; // (signal)
  /* ./A2601top.vhd:126:8  */
  assign sc_r = n118_o; // (signal)
  /* ./A2601top.vhd:127:8  */
  assign sc_d_out = ram_d_out; // (signal)
  /* ./A2601top.vhd:128:8  */
  assign sc_a = n199_o; // (signal)
  /* ./A2601top.vhd:129:8  */
  assign clr_a = n1101_q; // (signal)
  /* ./A2601top.vhd:133:8  */
  always @*
    bank = n1103_q; // (isignal)
  initial
    bank = 4'b0000;
  /* ./A2601top.vhd:134:8  */
  always @*
    banks32 = n1105_q; // (isignal)
  initial
    banks32 = 5'b00000;
  /* ./A2601top.vhd:135:8  */
  assign last_1ff0 = n1107_q; // (signal)
  /* ./A2601top.vhd:136:8  */
  assign tf_bank = n440_o; // (signal)
  /* ./A2601top.vhd:137:8  */
  assign e0_bank = n436_o; // (signal)
  /* ./A2601top.vhd:138:8  */
  always @*
    e0_bank0 = n1109_q; // (isignal)
  initial
    e0_bank0 = 3'b000;
  /* ./A2601top.vhd:139:8  */
  always @*
    e0_bank1 = n1111_q; // (isignal)
  initial
    e0_bank1 = 3'b000;
  /* ./A2601top.vhd:140:8  */
  always @*
    e0_bank2 = n1113_q; // (isignal)
  initial
    e0_bank2 = 3'b000;
  /* ./A2601top.vhd:142:8  */
  assign fe_latch = n1115_q; // (signal)
  /* ./A2601top.vhd:144:8  */
  assign e7_bank0 = n1117_q; // (signal)
  /* ./A2601top.vhd:145:8  */
  assign e7_rambank = n1119_q; // (signal)
  /* ./A2601top.vhd:147:8  */
  assign cpu_a = ms_a2601_a; // (signal)
  /* ./A2601top.vhd:148:8  */
  assign cpu_d = ms_a2601_dbus; // (signal)
  /* ./A2601top.vhd:149:8  */
  assign cart_d = n420_o; // (signal)
  /* ./A2601top.vhd:167:8  */
  always @*
    bss = n1026_o; // (isignal)
  initial
    bss = 4'b0000;
  /* ./A2601top.vhd:169:8  */
  always @*
    paddle_ena12 = n1120_q; // (isignal)
  initial
    paddle_ena12 = 1'b0;
  /* ./A2601top.vhd:170:8  */
  always @*
    paddle_ena34 = n1121_q; // (isignal)
  initial
    paddle_ena34 = 1'b0;
  /* ./A2601top.vhd:172:8  */
  assign inpt03_chg = ms_a2601_inpt03_chg; // (signal)
  /* ./A2601top.vhd:173:8  */
  assign inpt0 = n104_o; // (signal)
  /* ./A2601top.vhd:173:15  */
  assign pd0 = paddle0_o; // (signal)
  /* ./A2601top.vhd:174:8  */
  assign inpt1 = n106_o; // (signal)
  /* ./A2601top.vhd:174:15  */
  assign pd1 = paddle1_o; // (signal)
  /* ./A2601top.vhd:175:8  */
  assign inpt2 = n107_o; // (signal)
  /* ./A2601top.vhd:175:15  */
  assign pd2 = paddle2_o; // (signal)
  /* ./A2601top.vhd:176:8  */
  assign inpt3 = n109_o; // (signal)
  /* ./A2601top.vhd:176:15  */
  assign pd3 = paddle3_o; // (signal)
  /* ./A2601top.vhd:184:8  */
  always @*
    soundamplitudes = 64'b0000000000000100000001010000100100000110000010100000101100001111; // (isignal)
  initial
    soundamplitudes = 64'b0000000000000100000001010000100100000110000010100000101100001111;
  /* ./A2601top.vhd:195:8  */
  always @*
    dpcmusicmodes = n1123_q; // (isignal)
  initial
    dpcmusicmodes = 24'b000000000000000000000000;
  /* ./A2601top.vhd:196:8  */
  always @*
    dpcmusicflags = n1125_q; // (isignal)
  initial
    dpcmusicflags = 24'b000000000000000000000000;
  /* ./A2601top.vhd:197:8  */
  always @*
    dpctops = n1127_q; // (isignal)
  initial
    dpctops = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:198:8  */
  always @*
    dpcbottoms = n1129_q; // (isignal)
  initial
    dpcbottoms = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:199:8  */
  always @*
    dpcflags = n1131_q; // (isignal)
  initial
    dpcflags = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:200:8  */
  always @*
    dpccounters = n1133_q; // (isignal)
  initial
    dpccounters = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:201:8  */
  always @*
    dpcrandom = n1135_q; // (isignal)
  initial
    dpcrandom = 8'b00000001;
  /* ./A2601top.vhd:203:8  */
  always @*
    dpcclocks = n1137_q; // (isignal)
  initial
    dpcclocks = 16'b0000000000000000;
  /* ./A2601top.vhd:205:8  */
  assign dpcclockdivider = n1138_q; // (signal)
  /* ./A2601top.vhd:209:1  */
  a2601 ms_a2601 (
    .vid_clk(vid_clk),
    .clk(clk),
    .rst(rst),
    .pause(pause),
    .d(cart_d),
    .pa(pa),
    .pb(pb),
    .inpt0(inpt0),
    .inpt1(inpt1),
    .inpt2(inpt2),
    .inpt3(inpt3),
    .inpt4(inpt4),
    .inpt5(inpt5),
    .pal(pal),
    .decomb(decomb),
    .dbus(ms_a2601_dbus),
    .a(ms_a2601_a),
    .r(),
    .inpt03_chg(ms_a2601_inpt03_chg),
    .colu(ms_a2601_colu),
    .csyn(),
    .vsyn(ms_a2601_vsyn),
    .hsyn(ms_a2601_hsyn),
    .hblank(ms_a2601_hblank),
    .vblank(ms_a2601_vblank),
    .rgbx2(ms_a2601_rgbx2),
    .au0(ms_a2601_au0),
    .au1(ms_a2601_au1),
    .av0(ms_a2601_av0),
    .av1(ms_a2601_av1),
    .ph0_out(),
    .ph0_en_out(ms_a2601_ph0_en_out),
    .ph2_out(),
    .ph2_en_out());
  /* ./A2601top.vhd:242:19  */
  assign n48_o = rgbx2[23:16];
  /* ./A2601top.vhd:243:19  */
  assign n49_o = rgbx2[15:8];
  /* ./A2601top.vhd:244:19  */
  assign n50_o = rgbx2[7:0];
  /* ./A2601top.vhd:259:25  */
  assign n60_o = ~p1_f;
  /* ./A2601top.vhd:259:17  */
  assign n62_o = n60_o ? 1'b0 : paddle_ena12;
  /* ./A2601top.vhd:260:24  */
  assign n63_o = ~p_1;
  /* ./A2601top.vhd:260:37  */
  assign n64_o = ~p_2;
  /* ./A2601top.vhd:260:30  */
  assign n65_o = n63_o | n64_o;
  /* ./A2601top.vhd:260:17  */
  assign n67_o = n65_o ? 1'b1 : n62_o;
  /* ./A2601top.vhd:261:25  */
  assign n68_o = ~p2_f;
  /* ./A2601top.vhd:261:17  */
  assign n70_o = n68_o ? 1'b0 : paddle_ena34;
  /* ./A2601top.vhd:262:24  */
  assign n71_o = ~p_3;
  /* ./A2601top.vhd:262:37  */
  assign n72_o = ~p_4;
  /* ./A2601top.vhd:262:30  */
  assign n73_o = n71_o | n72_o;
  /* ./A2601top.vhd:262:17  */
  assign n75_o = n73_o ? 1'b1 : n70_o;
  /* ./A2601top.vhd:267:15  */
  assign n79_o = p_dif[0];
  /* ./A2601top.vhd:268:15  */
  assign n80_o = p_dif[1];
  /* ./A2601top.vhd:275:24  */
  assign n84_o = {p1_r, p1_l};
  /* ./A2601top.vhd:275:31  */
  assign n85_o = {n84_o, p1_d};
  /* ./A2601top.vhd:275:38  */
  assign n86_o = {n85_o, p1_u};
  /* ./A2601top.vhd:275:63  */
  assign n87_o = ~paddle_ena12;
  /* ./A2601top.vhd:275:45  */
  assign n88_o = n87_o ? n86_o : n91_o;
  /* ./A2601top.vhd:275:78  */
  assign n89_o = {p_1, p_2};
  /* ./A2601top.vhd:275:84  */
  assign n91_o = {n89_o, 2'b11};
  /* ./A2601top.vhd:276:24  */
  assign n92_o = {p2_r, p2_l};
  /* ./A2601top.vhd:276:31  */
  assign n93_o = {n92_o, p2_d};
  /* ./A2601top.vhd:276:38  */
  assign n94_o = {n93_o, p2_u};
  /* ./A2601top.vhd:276:63  */
  assign n95_o = ~paddle_ena34;
  /* ./A2601top.vhd:276:45  */
  assign n96_o = n95_o ? n94_o : n99_o;
  /* ./A2601top.vhd:276:78  */
  assign n97_o = {p_3, p_4};
  /* ./A2601top.vhd:276:84  */
  assign n99_o = {n97_o, 2'b11};
  /* ./A2601top.vhd:278:1  */
  paddle paddle0 (
    .clk(clk),
    .hsync(hsyn),
    .inp(paddle_1),
    .rst(inpt03_chg),
    .o(paddle0_o));
  /* ./A2601top.vhd:279:1  */
  paddle paddle1 (
    .clk(clk),
    .hsync(hsyn),
    .inp(paddle_2),
    .rst(inpt03_chg),
    .o(paddle1_o));
  /* ./A2601top.vhd:280:1  */
  paddle paddle2 (
    .clk(clk),
    .hsync(hsyn),
    .inp(paddle_3),
    .rst(inpt03_chg),
    .o(paddle2_o));
  /* ./A2601top.vhd:281:1  */
  paddle paddle3 (
    .clk(clk),
    .hsync(hsyn),
    .inp(paddle_4),
    .rst(inpt03_chg),
    .o(paddle3_o));
  /* ./A2601top.vhd:283:14  */
  assign n104_o = paddle_ena12 ? pd0 : 1'b1;
  /* ./A2601top.vhd:284:14  */
  assign n106_o = paddle_ena12 ? pd1 : p1_f2;
  /* ./A2601top.vhd:285:14  */
  assign n107_o = paddle_ena34 ? pd2 : 1'b1;
  /* ./A2601top.vhd:286:14  */
  assign n109_o = paddle_ena34 ? pd3 : p2_f2;
  /* ./A2601top.vhd:287:15  */
  assign n110_o = p1_f | paddle_ena12;
  /* ./A2601top.vhd:288:15  */
  assign n111_o = p2_f | paddle_ena34;
  /* ./A2601top.vhd:290:13  */
  assign n112_o = au0 ? av0 : 4'b0000;
  /* ./A2601top.vhd:291:13  */
  assign n114_o = au1 ? av1 : 4'b0000;
  /* ./A2601top.vhd:293:1  */
  ramx8_11 ram (
    .clk(clk),
    .r(sc_r),
    .d_in(cpu_d),
    .a(sc_a),
    .d_out(ram_d_out));
  /* ./A2601top.vhd:295:13  */
  assign n118_o = rst ? 1'b0 : n126_o;
  /* ./A2601top.vhd:296:22  */
  assign n121_o = bss == 4'b1001;
  /* ./A2601top.vhd:296:40  */
  assign n122_o = cpu_a[12:10];
  /* ./A2601top.vhd:296:55  */
  assign n124_o = n122_o == 3'b100;
  /* ./A2601top.vhd:296:31  */
  assign n125_o = n124_o & n121_o;
  /* ./A2601top.vhd:295:28  */
  assign n126_o = n125_o ? 1'b1 : n134_o;
  /* ./A2601top.vhd:297:22  */
  assign n129_o = bss == 4'b1001;
  /* ./A2601top.vhd:297:40  */
  assign n130_o = cpu_a[12:10];
  /* ./A2601top.vhd:297:55  */
  assign n132_o = n130_o == 3'b101;
  /* ./A2601top.vhd:297:31  */
  assign n133_o = n132_o & n129_o;
  /* ./A2601top.vhd:296:63  */
  assign n134_o = n133_o ? 1'b0 : n142_o;
  /* ./A2601top.vhd:298:22  */
  assign n137_o = bss == 4'b1000;
  /* ./A2601top.vhd:298:40  */
  assign n138_o = cpu_a[12:8];
  /* ./A2601top.vhd:298:55  */
  assign n140_o = n138_o == 5'b10001;
  /* ./A2601top.vhd:298:31  */
  assign n141_o = n140_o & n137_o;
  /* ./A2601top.vhd:297:63  */
  assign n142_o = n141_o ? 1'b1 : n150_o;
  /* ./A2601top.vhd:299:22  */
  assign n145_o = bss == 4'b1000;
  /* ./A2601top.vhd:299:40  */
  assign n146_o = cpu_a[12:8];
  /* ./A2601top.vhd:299:55  */
  assign n148_o = n146_o == 5'b10000;
  /* ./A2601top.vhd:299:31  */
  assign n149_o = n148_o & n145_o;
  /* ./A2601top.vhd:298:65  */
  assign n150_o = n149_o ? 1'b0 : n163_o;
  /* ./A2601top.vhd:300:22  */
  assign n153_o = bss == 4'b1100;
  /* ./A2601top.vhd:300:40  */
  assign n154_o = cpu_a[12:11];
  /* ./A2601top.vhd:300:55  */
  assign n156_o = n154_o == 2'b10;
  /* ./A2601top.vhd:300:31  */
  assign n157_o = n156_o & n153_o;
  /* ./A2601top.vhd:300:72  */
  assign n158_o = cpu_a[10];
  /* ./A2601top.vhd:300:95  */
  assign n160_o = e7_bank0 != 3'b111;
  /* ./A2601top.vhd:300:83  */
  assign n161_o = n158_o | n160_o;
  /* ./A2601top.vhd:300:62  */
  assign n162_o = n161_o & n157_o;
  /* ./A2601top.vhd:299:65  */
  assign n163_o = n162_o ? 1'b1 : n174_o;
  /* ./A2601top.vhd:301:22  */
  assign n166_o = bss == 4'b1100;
  /* ./A2601top.vhd:301:40  */
  assign n167_o = cpu_a[12:10];
  /* ./A2601top.vhd:301:55  */
  assign n169_o = n167_o == 3'b100;
  /* ./A2601top.vhd:301:31  */
  assign n170_o = n169_o & n166_o;
  /* ./A2601top.vhd:301:76  */
  assign n172_o = e7_bank0 == 3'b111;
  /* ./A2601top.vhd:301:63  */
  assign n173_o = n172_o & n170_o;
  /* ./A2601top.vhd:300:105  */
  assign n174_o = n173_o ? 1'b0 : n182_o;
  /* ./A2601top.vhd:302:22  */
  assign n177_o = bss == 4'b1100;
  /* ./A2601top.vhd:302:40  */
  assign n178_o = cpu_a[12:8];
  /* ./A2601top.vhd:302:55  */
  assign n180_o = n178_o == 5'b11001;
  /* ./A2601top.vhd:302:31  */
  assign n181_o = n180_o & n177_o;
  /* ./A2601top.vhd:301:84  */
  assign n182_o = n181_o ? 1'b1 : n190_o;
  /* ./A2601top.vhd:303:22  */
  assign n185_o = bss == 4'b1100;
  /* ./A2601top.vhd:303:40  */
  assign n186_o = cpu_a[12:8];
  /* ./A2601top.vhd:303:55  */
  assign n188_o = n186_o == 5'b11000;
  /* ./A2601top.vhd:303:31  */
  assign n189_o = n188_o & n185_o;
  /* ./A2601top.vhd:302:65  */
  assign n190_o = n189_o ? 1'b0 : n197_o;
  /* ./A2601top.vhd:304:24  */
  assign n192_o = cpu_a[12:7];
  /* ./A2601top.vhd:304:39  */
  assign n194_o = n192_o == 6'b100000;
  /* ./A2601top.vhd:304:50  */
  assign n195_o = sc & n194_o;
  /* ./A2601top.vhd:304:64  */
  assign n196_o = n195_o | reset;
  /* ./A2601top.vhd:303:65  */
  assign n197_o = n196_o ? 1'b0 : 1'b1;
  /* ./A2601top.vhd:306:46  */
  assign n199_o = rst ? clr_a : n205_o;
  /* ./A2601top.vhd:307:20  */
  assign n200_o = cpu_a[9:0];
  /* ./A2601top.vhd:307:13  */
  assign n202_o = {1'b0, n200_o};
  /* ./A2601top.vhd:307:55  */
  assign n204_o = bss == 4'b1001;
  /* ./A2601top.vhd:306:64  */
  assign n205_o = n204_o ? n202_o : n211_o;
  /* ./A2601top.vhd:308:22  */
  assign n206_o = cpu_a[7:0];
  /* ./A2601top.vhd:308:15  */
  assign n208_o = {3'b000, n206_o};
  /* ./A2601top.vhd:308:55  */
  assign n210_o = bss == 4'b1000;
  /* ./A2601top.vhd:307:64  */
  assign n211_o = n210_o ? n208_o : n221_o;
  /* ./A2601top.vhd:309:20  */
  assign n212_o = cpu_a[9:0];
  /* ./A2601top.vhd:309:13  */
  assign n214_o = {1'b0, n212_o};
  /* ./A2601top.vhd:309:55  */
  assign n216_o = bss == 4'b1100;
  /* ./A2601top.vhd:309:73  */
  assign n217_o = cpu_a[12:11];
  /* ./A2601top.vhd:309:88  */
  assign n219_o = n217_o == 2'b10;
  /* ./A2601top.vhd:309:64  */
  assign n220_o = n219_o & n216_o;
  /* ./A2601top.vhd:308:64  */
  assign n221_o = n220_o ? n214_o : n232_o;
  /* ./A2601top.vhd:310:13  */
  assign n223_o = {1'b1, e7_rambank};
  /* ./A2601top.vhd:310:33  */
  assign n224_o = cpu_a[7:0];
  /* ./A2601top.vhd:310:26  */
  assign n225_o = {n223_o, n224_o};
  /* ./A2601top.vhd:310:55  */
  assign n227_o = bss == 4'b1100;
  /* ./A2601top.vhd:310:73  */
  assign n228_o = cpu_a[12:9];
  /* ./A2601top.vhd:310:87  */
  assign n230_o = n228_o == 4'b1100;
  /* ./A2601top.vhd:310:64  */
  assign n231_o = n230_o & n227_o;
  /* ./A2601top.vhd:309:95  */
  assign n232_o = n231_o ? n225_o : n235_o;
  /* ./A2601top.vhd:311:23  */
  assign n233_o = cpu_a[6:0];
  /* ./A2601top.vhd:311:16  */
  assign n235_o = {4'b0000, n233_o};
  /* ./A2601top.vhd:321:17  */
  assign n244_o = bss == 4'b0111;
  /* ./A2601top.vhd:321:36  */
  assign n246_o = $unsigned(cpu_a) >= $unsigned(13'b1000000001000);
  /* ./A2601top.vhd:321:26  */
  assign n247_o = n246_o & n244_o;
  /* ./A2601top.vhd:321:62  */
  assign n249_o = $unsigned(cpu_a) <= $unsigned(13'b1000000001111);
  /* ./A2601top.vhd:321:52  */
  assign n250_o = n249_o & n247_o;
  /* ./A2601top.vhd:323:20  */
  assign n252_o = bss == 4'b0111;
  /* ./A2601top.vhd:323:39  */
  assign n254_o = $unsigned(cpu_a) >= $unsigned(13'b1000000010000);
  /* ./A2601top.vhd:323:29  */
  assign n255_o = n254_o & n252_o;
  /* ./A2601top.vhd:323:65  */
  assign n257_o = $unsigned(cpu_a) <= $unsigned(13'b1000000010111);
  /* ./A2601top.vhd:323:55  */
  assign n258_o = n257_o & n255_o;
  /* ./A2601top.vhd:324:72  */
  assign n259_o = cpu_a[2:0];
  /* ./A2601top.vhd:324:47  */
  assign n262_o = 3'b111 - n259_o;
  /* ./A2601top.vhd:324:34  */
  assign n265_o = rom_do & n1154_o;
  /* ./A2601top.vhd:325:20  */
  assign n267_o = bss == 4'b0111;
  /* ./A2601top.vhd:325:39  */
  assign n269_o = $unsigned(cpu_a) >= $unsigned(13'b1000000000000);
  /* ./A2601top.vhd:325:29  */
  assign n270_o = n269_o & n267_o;
  /* ./A2601top.vhd:325:65  */
  assign n272_o = $unsigned(cpu_a) <= $unsigned(13'b1000000000011);
  /* ./A2601top.vhd:325:55  */
  assign n273_o = n272_o & n270_o;
  /* ./A2601top.vhd:327:20  */
  assign n275_o = bss == 4'b0111;
  /* ./A2601top.vhd:327:39  */
  assign n277_o = $unsigned(cpu_a) >= $unsigned(13'b1000000000100);
  /* ./A2601top.vhd:327:29  */
  assign n278_o = n277_o & n275_o;
  /* ./A2601top.vhd:327:65  */
  assign n280_o = $unsigned(cpu_a) <= $unsigned(13'b1000000000111);
  /* ./A2601top.vhd:327:55  */
  assign n281_o = n280_o & n278_o;
  /* ./A2601top.vhd:330:36  */
  assign n282_o = dpcmusicmodes[4];
  /* ./A2601top.vhd:330:66  */
  assign n283_o = dpcmusicflags[4];
  /* ./A2601top.vhd:330:46  */
  assign n284_o = n283_o & n282_o;
  /* ./A2601top.vhd:330:17  */
  assign n287_o = n284_o ? 1'b1 : 1'b0;
  /* ./A2601top.vhd:331:36  */
  assign n290_o = dpcmusicmodes[12];
  /* ./A2601top.vhd:331:66  */
  assign n291_o = dpcmusicflags[12];
  /* ./A2601top.vhd:331:46  */
  assign n292_o = n291_o & n290_o;
  assign n294_o = n288_o[1];
  /* ./A2601top.vhd:331:17  */
  assign n295_o = n292_o ? 1'b1 : n294_o;
  assign n296_o = n288_o[2];
  /* ./A2601top.vhd:332:36  */
  assign n297_o = dpcmusicmodes[20];
  /* ./A2601top.vhd:332:66  */
  assign n298_o = dpcmusicflags[20];
  /* ./A2601top.vhd:332:46  */
  assign n299_o = n298_o & n297_o;
  /* ./A2601top.vhd:332:17  */
  assign n301_o = n299_o ? 1'b1 : n296_o;
  assign n302_o = {n301_o, n295_o, n287_o};
  /* ./A2601top.vhd:334:43  */
  assign n305_o = 3'b111 - n302_o;
  /* ./A2601top.vhd:336:20  */
  assign n309_o = bss == 4'b0111;
  /* ./A2601top.vhd:336:39  */
  assign n311_o = $unsigned(cpu_a) >= $unsigned(13'b1000000111000);
  /* ./A2601top.vhd:336:29  */
  assign n312_o = n311_o & n309_o;
  /* ./A2601top.vhd:336:65  */
  assign n314_o = $unsigned(cpu_a) <= $unsigned(13'b1000000111111);
  /* ./A2601top.vhd:336:55  */
  assign n315_o = n314_o & n312_o;
  /* ./A2601top.vhd:337:61  */
  assign n316_o = cpu_a[2:0];
  /* ./A2601top.vhd:337:36  */
  assign n319_o = 3'b111 - n316_o;
  /* ./A2601top.vhd:338:20  */
  assign n323_o = bss == 4'b0111;
  /* ./A2601top.vhd:338:39  */
  assign n325_o = $unsigned(cpu_a) >= $unsigned(13'b1000001000000);
  /* ./A2601top.vhd:338:29  */
  assign n326_o = n325_o & n323_o;
  /* ./A2601top.vhd:338:65  */
  assign n328_o = $unsigned(cpu_a) <= $unsigned(13'b1000001111111);
  /* ./A2601top.vhd:338:55  */
  assign n329_o = n328_o & n326_o;
  /* ./A2601top.vhd:341:19  */
  assign n331_o = bss == 4'b1001;
  /* ./A2601top.vhd:341:37  */
  assign n332_o = cpu_a[12:10];
  /* ./A2601top.vhd:341:52  */
  assign n334_o = n332_o == 3'b100;
  /* ./A2601top.vhd:341:28  */
  assign n335_o = n334_o & n331_o;
  /* ./A2601top.vhd:343:19  */
  assign n337_o = bss == 4'b1001;
  /* ./A2601top.vhd:343:37  */
  assign n338_o = cpu_a[12:10];
  /* ./A2601top.vhd:343:52  */
  assign n340_o = n338_o == 3'b101;
  /* ./A2601top.vhd:343:28  */
  assign n341_o = n340_o & n337_o;
  /* ./A2601top.vhd:345:19  */
  assign n343_o = bss == 4'b1000;
  /* ./A2601top.vhd:345:37  */
  assign n344_o = cpu_a[12:8];
  /* ./A2601top.vhd:345:51  */
  assign n346_o = n344_o == 5'b10001;
  /* ./A2601top.vhd:345:28  */
  assign n347_o = n346_o & n343_o;
  /* ./A2601top.vhd:347:19  */
  assign n349_o = bss == 4'b1000;
  /* ./A2601top.vhd:347:37  */
  assign n350_o = cpu_a[12:8];
  /* ./A2601top.vhd:347:51  */
  assign n352_o = n350_o == 5'b10000;
  /* ./A2601top.vhd:347:28  */
  assign n353_o = n352_o & n349_o;
  /* ./A2601top.vhd:350:19  */
  assign n355_o = bss == 4'b1100;
  /* ./A2601top.vhd:350:37  */
  assign n356_o = cpu_a[12:10];
  /* ./A2601top.vhd:350:52  */
  assign n358_o = n356_o == 3'b101;
  /* ./A2601top.vhd:350:28  */
  assign n359_o = n358_o & n355_o;
  /* ./A2601top.vhd:350:73  */
  assign n361_o = e7_bank0 == 3'b111;
  /* ./A2601top.vhd:350:60  */
  assign n362_o = n361_o & n359_o;
  /* ./A2601top.vhd:352:19  */
  assign n364_o = bss == 4'b1100;
  /* ./A2601top.vhd:352:37  */
  assign n365_o = cpu_a[12:10];
  /* ./A2601top.vhd:352:52  */
  assign n367_o = n365_o == 3'b100;
  /* ./A2601top.vhd:352:28  */
  assign n368_o = n367_o & n364_o;
  /* ./A2601top.vhd:352:73  */
  assign n370_o = e7_bank0 == 3'b111;
  /* ./A2601top.vhd:352:60  */
  assign n371_o = n370_o & n368_o;
  /* ./A2601top.vhd:354:19  */
  assign n373_o = bss == 4'b1100;
  /* ./A2601top.vhd:354:37  */
  assign n374_o = cpu_a[12:8];
  /* ./A2601top.vhd:354:51  */
  assign n376_o = n374_o == 5'b11001;
  /* ./A2601top.vhd:354:28  */
  assign n377_o = n376_o & n373_o;
  /* ./A2601top.vhd:356:19  */
  assign n379_o = bss == 4'b1100;
  /* ./A2601top.vhd:356:37  */
  assign n380_o = cpu_a[12:8];
  /* ./A2601top.vhd:356:51  */
  assign n382_o = n380_o == 5'b11000;
  /* ./A2601top.vhd:356:28  */
  assign n383_o = n382_o & n379_o;
  /* ./A2601top.vhd:359:21  */
  assign n384_o = cpu_a[12:7];
  /* ./A2601top.vhd:359:35  */
  assign n386_o = n384_o == 6'b100001;
  /* ./A2601top.vhd:359:46  */
  assign n387_o = sc & n386_o;
  /* ./A2601top.vhd:361:21  */
  assign n388_o = cpu_a[12:7];
  /* ./A2601top.vhd:361:35  */
  assign n390_o = n388_o == 6'b100000;
  /* ./A2601top.vhd:361:46  */
  assign n391_o = sc & n390_o;
  /* ./A2601top.vhd:363:21  */
  assign n392_o = cpu_a[12];
  /* ./A2601top.vhd:363:9  */
  assign n394_o = n392_o ? rom_do : 8'b11111111;
  /* ./A2601top.vhd:361:9  */
  assign n396_o = n391_o ? 8'b11111111 : n394_o;
  /* ./A2601top.vhd:359:9  */
  assign n397_o = n387_o ? sc_d_out : n396_o;
  /* ./A2601top.vhd:356:9  */
  assign n399_o = n383_o ? 8'b11111111 : n397_o;
  /* ./A2601top.vhd:354:9  */
  assign n400_o = n377_o ? sc_d_out : n399_o;
  /* ./A2601top.vhd:352:9  */
  assign n402_o = n371_o ? 8'b11111111 : n400_o;
  /* ./A2601top.vhd:350:9  */
  assign n403_o = n362_o ? sc_d_out : n402_o;
  /* ./A2601top.vhd:347:9  */
  assign n405_o = n353_o ? 8'b11111111 : n403_o;
  /* ./A2601top.vhd:345:9  */
  assign n406_o = n347_o ? sc_d_out : n405_o;
  /* ./A2601top.vhd:343:9  */
  assign n408_o = n341_o ? 8'b11111111 : n406_o;
  /* ./A2601top.vhd:341:9  */
  assign n409_o = n335_o ? sc_d_out : n408_o;
  /* ./A2601top.vhd:338:9  */
  assign n411_o = n329_o ? 8'b11111111 : n409_o;
  /* ./A2601top.vhd:336:9  */
  assign n412_o = n315_o ? n1168_o : n411_o;
  /* ./A2601top.vhd:327:9  */
  assign n413_o = n281_o ? n1140_data : n412_o;
  /* ./A2601top.vhd:325:9  */
  assign n416_o = n273_o ? dpcrandom : n413_o;
  /* ./A2601top.vhd:323:9  */
  assign n418_o = n258_o ? n265_o : n416_o;
  /* ./A2601top.vhd:321:9  */
  assign n420_o = n250_o ? rom_do : n418_o;
  /* ./A2601top.vhd:370:11  */
  assign n424_o = cpu_a[11:10];
  /* ./A2601top.vhd:371:18  */
  assign n426_o = n424_o == 2'b00;
  /* ./A2601top.vhd:372:18  */
  assign n428_o = n424_o == 2'b01;
  /* ./A2601top.vhd:373:18  */
  assign n430_o = n424_o == 2'b10;
  /* ./A2601top.vhd:374:15  */
  assign n433_o = n424_o == 2'b11;
  assign n435_o = {n433_o, n430_o, n428_o, n426_o};
  /* ./A2601top.vhd:370:1  */
  always @*
    case (n435_o)
      4'b1000: n436_o = 3'b111;
      4'b0100: n436_o = e0_bank2;
      4'b0010: n436_o = e0_bank1;
      4'b0001: n436_o = e0_bank0;
      default: n436_o = 3'bX;
    endcase
  /* ./A2601top.vhd:377:16  */
  assign n437_o = bank[1:0];
  /* ./A2601top.vhd:377:40  */
  assign n438_o = cpu_a[11];
  /* ./A2601top.vhd:377:45  */
  assign n439_o = ~n438_o;
  /* ./A2601top.vhd:377:29  */
  assign n440_o = n439_o ? n437_o : 2'b11;
  /* ./A2601top.vhd:379:16  */
  assign n443_o = {3'b000, e0_bank};
  /* ./A2601top.vhd:379:33  */
  assign n444_o = cpu_a[9:0];
  /* ./A2601top.vhd:379:26  */
  assign n445_o = {n443_o, n444_o};
  /* ./A2601top.vhd:379:56  */
  assign n447_o = bss == 4'b0100;
  /* ./A2601top.vhd:379:47  */
  assign n448_o = n447_o ? n445_o : n455_o;
  /* ./A2601top.vhd:380:16  */
  assign n450_o = {3'b000, tf_bank};
  /* ./A2601top.vhd:380:33  */
  assign n451_o = cpu_a[10:0];
  /* ./A2601top.vhd:380:26  */
  assign n452_o = {n450_o, n451_o};
  /* ./A2601top.vhd:380:56  */
  assign n454_o = bss == 4'b0101;
  /* ./A2601top.vhd:379:65  */
  assign n455_o = n454_o ? n452_o : n471_o;
  /* ./A2601top.vhd:381:78  */
  assign n456_o = cpu_a[2:0];
  /* ./A2601top.vhd:381:37  */
  assign n460_o = ~n1182_o;
  /* ./A2601top.vhd:381:18  */
  assign n462_o = {5'b00100, n460_o};
  /* ./A2601top.vhd:382:56  */
  assign n464_o = bss == 4'b0111;
  /* ./A2601top.vhd:382:75  */
  assign n466_o = $unsigned(cpu_a) >= $unsigned(13'b1000000001000);
  /* ./A2601top.vhd:382:65  */
  assign n467_o = n466_o & n464_o;
  /* ./A2601top.vhd:382:101  */
  assign n469_o = $unsigned(cpu_a) <= $unsigned(13'b1000000010111);
  /* ./A2601top.vhd:382:91  */
  assign n470_o = n469_o & n467_o;
  /* ./A2601top.vhd:380:65  */
  assign n471_o = n470_o ? n462_o : n477_o;
  /* ./A2601top.vhd:383:25  */
  assign n472_o = cpu_a[10:0];
  /* ./A2601top.vhd:383:18  */
  assign n474_o = {5'b00000, n472_o};
  /* ./A2601top.vhd:383:56  */
  assign n476_o = bss == 4'b1001;
  /* ./A2601top.vhd:382:117  */
  assign n477_o = n476_o ? n474_o : n483_o;
  /* ./A2601top.vhd:384:25  */
  assign n478_o = cpu_a[10:0];
  /* ./A2601top.vhd:384:18  */
  assign n480_o = {5'b00000, n478_o};
  /* ./A2601top.vhd:384:56  */
  assign n482_o = bss == 4'b1010;
  /* ./A2601top.vhd:383:65  */
  assign n483_o = n482_o ? n480_o : n494_o;
  /* ./A2601top.vhd:385:15  */
  assign n485_o = {2'b00, e7_bank0};
  /* ./A2601top.vhd:385:33  */
  assign n486_o = cpu_a[10:0];
  /* ./A2601top.vhd:385:26  */
  assign n487_o = {n485_o, n486_o};
  /* ./A2601top.vhd:385:56  */
  assign n489_o = bss == 4'b1100;
  /* ./A2601top.vhd:385:74  */
  assign n490_o = cpu_a[12:11];
  /* ./A2601top.vhd:385:89  */
  assign n492_o = n490_o == 2'b10;
  /* ./A2601top.vhd:385:65  */
  assign n493_o = n492_o & n489_o;
  /* ./A2601top.vhd:384:65  */
  assign n494_o = n493_o ? n487_o : n508_o;
  /* ./A2601top.vhd:386:25  */
  assign n495_o = cpu_a[10:0];
  /* ./A2601top.vhd:386:18  */
  assign n497_o = {5'b00111, n495_o};
  /* ./A2601top.vhd:386:56  */
  assign n499_o = bss == 4'b1100;
  /* ./A2601top.vhd:386:75  */
  assign n500_o = cpu_a[12:11];
  /* ./A2601top.vhd:386:90  */
  assign n502_o = n500_o == 2'b11;
  /* ./A2601top.vhd:386:105  */
  assign n503_o = cpu_a[12:10];
  /* ./A2601top.vhd:386:120  */
  assign n505_o = n503_o == 3'b101;
  /* ./A2601top.vhd:386:97  */
  assign n506_o = n502_o | n505_o;
  /* ./A2601top.vhd:386:65  */
  assign n507_o = n506_o & n499_o;
  /* ./A2601top.vhd:385:96  */
  assign n508_o = n507_o ? n497_o : n513_o;
  /* ./A2601top.vhd:387:25  */
  assign n509_o = cpu_a[10:0];
  /* ./A2601top.vhd:387:18  */
  assign n510_o = {banks32, n509_o};
  /* ./A2601top.vhd:387:56  */
  assign n512_o = bss == 4'b1110;
  /* ./A2601top.vhd:386:129  */
  assign n513_o = n512_o ? n510_o : n515_o;
  /* ./A2601top.vhd:388:34  */
  assign n514_o = cpu_a[11:0];
  /* ./A2601top.vhd:388:27  */
  assign n515_o = {bank, n514_o};
  /* ./A2601top.vhd:392:18  */
  always @*
    bankswch_addr_v = n986_q; // (isignal)
  initial
    bankswch_addr_v = 13'bX;
  /* ./A2601top.vhd:398:40  */
  assign n522_o = clr_a + 11'b00000000001;
  /* ./A2601top.vhd:405:44  */
  assign n523_o = ~old_rst;
  /* ./A2601top.vhd:406:60  */
  assign n525_o = banks32 + 5'b00001;
  /* ./A2601top.vhd:405:33  */
  assign n526_o = n523_o ? n525_o : banks32;
  /* ./A2601top.vhd:408:40  */
  assign n528_o = bss != 4'b1110;
  /* ./A2601top.vhd:408:33  */
  assign n530_o = n528_o ? 5'b00000 : n526_o;
  /* ./A2601top.vhd:414:59  */
  assign n532_o = cpu_a == 13'b1111111111000;
  /* ./A2601top.vhd:416:62  */
  assign n534_o = cpu_a == 13'b1111111111001;
  /* ./A2601top.vhd:418:62  */
  assign n536_o = cpu_a == 13'b1111111111010;
  /* ./A2601top.vhd:418:49  */
  assign n538_o = n536_o ? 4'b0010 : bank;
  /* ./A2601top.vhd:416:49  */
  assign n540_o = n534_o ? 4'b0001 : n538_o;
  /* ./A2601top.vhd:414:49  */
  assign n542_o = n532_o ? 4'b0000 : n540_o;
  /* ./A2601top.vhd:413:41  */
  assign n544_o = bss == 4'b1000;
  /* ./A2601top.vhd:422:59  */
  assign n546_o = cpu_a == 13'b1111111111000;
  /* ./A2601top.vhd:424:62  */
  assign n548_o = cpu_a == 13'b1111111111001;
  /* ./A2601top.vhd:424:49  */
  assign n550_o = n548_o ? 4'b0001 : bank;
  /* ./A2601top.vhd:422:49  */
  assign n552_o = n546_o ? 4'b0000 : n550_o;
  /* ./A2601top.vhd:421:41  */
  assign n554_o = bss == 4'b0001;
  /* ./A2601top.vhd:428:59  */
  assign n556_o = cpu_a == 13'b1111111110110;
  /* ./A2601top.vhd:430:62  */
  assign n558_o = cpu_a == 13'b1111111110111;
  /* ./A2601top.vhd:432:62  */
  assign n560_o = cpu_a == 13'b1111111111000;
  /* ./A2601top.vhd:434:62  */
  assign n562_o = cpu_a == 13'b1111111111001;
  /* ./A2601top.vhd:434:49  */
  assign n564_o = n562_o ? 4'b0011 : bank;
  /* ./A2601top.vhd:432:49  */
  assign n566_o = n560_o ? 4'b0010 : n564_o;
  /* ./A2601top.vhd:430:49  */
  assign n568_o = n558_o ? 4'b0001 : n566_o;
  /* ./A2601top.vhd:428:49  */
  assign n570_o = n556_o ? 4'b0000 : n568_o;
  /* ./A2601top.vhd:427:41  */
  assign n572_o = bss == 4'b0010;
  /* ./A2601top.vhd:438:59  */
  assign n574_o = cpu_a == 13'b1111111110100;
  /* ./A2601top.vhd:440:62  */
  assign n576_o = cpu_a == 13'b1111111110101;
  /* ./A2601top.vhd:442:62  */
  assign n578_o = cpu_a == 13'b1111111110110;
  /* ./A2601top.vhd:444:62  */
  assign n580_o = cpu_a == 13'b1111111110111;
  /* ./A2601top.vhd:446:62  */
  assign n582_o = cpu_a == 13'b1111111111000;
  /* ./A2601top.vhd:448:62  */
  assign n584_o = cpu_a == 13'b1111111111001;
  /* ./A2601top.vhd:450:62  */
  assign n586_o = cpu_a == 13'b1111111111010;
  /* ./A2601top.vhd:452:62  */
  assign n588_o = cpu_a == 13'b1111111111011;
  /* ./A2601top.vhd:452:49  */
  assign n590_o = n588_o ? 4'b0111 : bank;
  /* ./A2601top.vhd:450:49  */
  assign n592_o = n586_o ? 4'b0110 : n590_o;
  /* ./A2601top.vhd:448:49  */
  assign n594_o = n584_o ? 4'b0101 : n592_o;
  /* ./A2601top.vhd:446:49  */
  assign n596_o = n582_o ? 4'b0100 : n594_o;
  /* ./A2601top.vhd:444:49  */
  assign n598_o = n580_o ? 4'b0011 : n596_o;
  /* ./A2601top.vhd:442:49  */
  assign n600_o = n578_o ? 4'b0010 : n598_o;
  /* ./A2601top.vhd:440:49  */
  assign n602_o = n576_o ? 4'b0001 : n600_o;
  /* ./A2601top.vhd:438:49  */
  assign n604_o = n574_o ? 4'b0000 : n602_o;
  /* ./A2601top.vhd:437:41  */
  assign n606_o = bss == 4'b0110;
  /* ./A2601top.vhd:456:58  */
  assign n607_o = cpu_a != bankswch_addr_v;
  /* ./A2601top.vhd:459:66  */
  assign n608_o = cpu_a[12];
  /* ./A2601top.vhd:460:103  */
  assign n609_o = cpu_a[2:0];
  /* ./A2601top.vhd:460:78  */
  assign n610_o = {28'b0, n609_o};  //  uext
  /* ./A2601top.vhd:460:65  */
  assign n611_o = {1'b0, n610_o};  //  uext
  /* ./A2601top.vhd:461:74  */
  assign n612_o = cpu_a[12:6];
  /* ./A2601top.vhd:461:88  */
  assign n614_o = n612_o == 7'b1000000;
  /* ./A2601top.vhd:463:83  */
  assign n615_o = cpu_a[5:3];
  /* ./A2601top.vhd:465:97  */
  assign n616_o = cpu_a[2];
  /* ./A2601top.vhd:465:101  */
  assign n617_o = ~n616_o;
  /* ./A2601top.vhd:467:119  */
  assign n618_o = dpcrandom[6:0];
  /* ./A2601top.vhd:467:148  */
  assign n619_o = dpcrandom[7];
  /* ./A2601top.vhd:467:165  */
  assign n620_o = dpcrandom[5];
  /* ./A2601top.vhd:467:152  */
  assign n621_o = n619_o ^ n620_o;
  /* ./A2601top.vhd:467:182  */
  assign n622_o = dpcrandom[4];
  /* ./A2601top.vhd:467:169  */
  assign n623_o = n621_o ^ n622_o;
  /* ./A2601top.vhd:467:199  */
  assign n624_o = dpcrandom[3];
  /* ./A2601top.vhd:467:186  */
  assign n625_o = n623_o ^ n624_o;
  /* ./A2601top.vhd:467:135  */
  assign n626_o = ~n625_o;
  /* ./A2601top.vhd:467:132  */
  assign n627_o = {n618_o, n626_o};
  /* ./A2601top.vhd:465:89  */
  assign n628_o = n617_o ? n627_o : dpcrandom;
  /* ./A2601top.vhd:464:81  */
  assign n630_o = n615_o == 3'b000;
  /* ./A2601top.vhd:463:73  */
  always @*
    case (n630_o)
      1'b1: n631_o = n628_o;
      default: n631_o = dpcrandom;
    endcase
  /* ./A2601top.vhd:473:67  */
  assign n632_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:474:87  */
  assign n636_o = $signed(n611_o) < $signed(32'b00000000000000000000000000000101);
  /* ./A2601top.vhd:474:105  */
  assign n638_o = $signed(n611_o) >= $signed(32'b00000000000000000000000000000101);
  /* ./A2601top.vhd:474:130  */
  assign n640_o = 32'b00000000000000000000000000000101 - n611_o;
  /* ./A2601top.vhd:474:130  */
  assign n641_o = n640_o[1:0];  // trunc
  /* ./A2601top.vhd:474:110  */
  assign n644_o = n1203_o & n638_o;
  /* ./A2601top.vhd:474:91  */
  assign n645_o = n636_o | n644_o;
  /* ./A2601top.vhd:475:111  */
  assign n646_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:475:122  */
  assign n650_o = n1217_o - 11'b00000000001;
  /* ./A2601top.vhd:474:73  */
  assign n651_o = n645_o ? n650_o : n1196_o;
  /* ./A2601top.vhd:478:85  */
  assign n652_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:480:91  */
  assign n655_o = n651_o[7:0];
  /* ./A2601top.vhd:480:114  */
  assign n656_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:480:114  */
  assign n658_o = 3'b111 - n656_o;
  /* ./A2601top.vhd:480:104  */
  assign n661_o = n655_o == n1266_o;
  /* ./A2601top.vhd:481:91  */
  assign n662_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:481:91  */
  assign n664_o = 3'b111 - n662_o;
  /* ./A2601top.vhd:482:94  */
  assign n668_o = n651_o[7:0];
  /* ./A2601top.vhd:482:120  */
  assign n669_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:482:120  */
  assign n671_o = 3'b111 - n669_o;
  /* ./A2601top.vhd:482:107  */
  assign n674_o = n668_o == n1315_o;
  /* ./A2601top.vhd:483:91  */
  assign n675_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:483:91  */
  assign n677_o = 3'b111 - n675_o;
  /* ./A2601top.vhd:482:73  */
  assign n681_o = n674_o ? n1350_o : dpcflags;
  /* ./A2601top.vhd:480:73  */
  assign n682_o = n661_o ? n1301_o : n681_o;
  /* ./A2601top.vhd:486:77  */
  assign n683_o = cpu_a[12:6];
  /* ./A2601top.vhd:486:91  */
  assign n685_o = n683_o == 7'b1000001;
  /* ./A2601top.vhd:487:83  */
  assign n686_o = cpu_a[5:3];
  /* ./A2601top.vhd:490:97  */
  assign n687_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:490:97  */
  assign n689_o = 3'b111 - n687_o;
  /* ./A2601top.vhd:491:61  */
  assign n692_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:491:84  */
  assign n695_o = n1399_o == cpu_d;
  /* ./A2601top.vhd:492:58  */
  assign n696_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:492:58  */
  assign n698_o = 3'b111 - n696_o;
  /* ./A2601top.vhd:494:106  */
  assign n702_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:494:106  */
  assign n704_o = 3'b111 - n702_o;
  /* ./A2601top.vhd:491:45  */
  assign n708_o = n695_o ? n1434_o : n1469_o;
  /* ./A2601top.vhd:488:81  */
  assign n710_o = n686_o == 3'b000;
  /* ./A2601top.vhd:498:100  */
  assign n711_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:498:100  */
  assign n713_o = 3'b111 - n711_o;
  /* ./A2601top.vhd:496:81  */
  assign n717_o = n686_o == 3'b001;
  /* ./A2601top.vhd:501:101  */
  assign n718_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:499:81  */
  assign n722_o = n686_o == 3'b010;
  /* ./A2601top.vhd:504:101  */
  assign n723_o = n610_o[2:0];  // trunc
  /* ./A2601top.vhd:504:133  */
  assign n725_o = cpu_d[2:0];
  /* ./A2601top.vhd:505:102  */
  assign n728_o = $signed(n611_o) >= $signed(32'b00000000000000000000000000000101);
  /* ./A2601top.vhd:506:113  */
  assign n730_o = 32'b00000000000000000000000000000101 - n611_o;
  /* ./A2601top.vhd:506:113  */
  assign n731_o = n730_o[1:0];  // trunc
  /* ./A2601top.vhd:506:142  */
  assign n733_o = cpu_d[4];
  /* ./A2601top.vhd:506:135  */
  assign n735_o = {3'b000, n733_o};
  /* ./A2601top.vhd:506:146  */
  assign n737_o = {n735_o, 4'b0000};
  /* ./A2601top.vhd:505:89  */
  assign n739_o = n728_o ? n1604_o : dpcmusicmodes;
  /* ./A2601top.vhd:502:81  */
  assign n741_o = n686_o == 3'b011;
  /* ./A2601top.vhd:508:81  */
  assign n743_o = n686_o == 3'b110;
  assign n744_o = {n743_o, n741_o, n722_o, n717_o, n710_o};
  /* ./A2601top.vhd:487:73  */
  always @*
    case (n744_o)
      5'b10000: n745_o = dpcmusicmodes;
      5'b01000: n745_o = n739_o;
      5'b00100: n745_o = dpcmusicmodes;
      5'b00010: n745_o = dpcmusicmodes;
      5'b00001: n745_o = dpcmusicmodes;
      default: n745_o = dpcmusicmodes;
    endcase
  /* ./A2601top.vhd:487:73  */
  always @*
    case (n744_o)
      5'b10000: n746_o = dpctops;
      5'b01000: n746_o = dpctops;
      5'b00100: n746_o = dpctops;
      5'b00010: n746_o = dpctops;
      5'b00001: n746_o = n1385_o;
      default: n746_o = dpctops;
    endcase
  /* ./A2601top.vhd:487:73  */
  always @*
    case (n744_o)
      5'b10000: n747_o = dpcbottoms;
      5'b01000: n747_o = dpcbottoms;
      5'b00100: n747_o = dpcbottoms;
      5'b00010: n747_o = n1504_o;
      5'b00001: n747_o = dpcbottoms;
      default: n747_o = dpcbottoms;
    endcase
  /* ./A2601top.vhd:487:73  */
  always @*
    case (n744_o)
      5'b10000: n748_o = dpcflags;
      5'b01000: n748_o = dpcflags;
      5'b00100: n748_o = dpcflags;
      5'b00010: n748_o = dpcflags;
      5'b00001: n748_o = n708_o;
      default: n748_o = dpcflags;
    endcase
  /* ./A2601top.vhd:487:73  */
  always @*
    case (n744_o)
      5'b10000: n749_o = dpccounters;
      5'b01000: n749_o = n1590_o;
      5'b00100: n749_o = n1547_o;
      5'b00010: n749_o = dpccounters;
      5'b00001: n749_o = dpccounters;
      default: n749_o = dpccounters;
    endcase
  /* ./A2601top.vhd:487:73  */
  always @*
    case (n744_o)
      5'b10000: n751_o = 8'b00000001;
      5'b01000: n751_o = dpcrandom;
      5'b00100: n751_o = dpcrandom;
      5'b00010: n751_o = dpcrandom;
      5'b00001: n751_o = dpcrandom;
      default: n751_o = dpcrandom;
    endcase
  /* ./A2601top.vhd:514:83  */
  assign n753_o = cpu_a == 13'b1111111111000;
  /* ./A2601top.vhd:516:86  */
  assign n755_o = cpu_a == 13'b1111111111001;
  /* ./A2601top.vhd:516:73  */
  assign n757_o = n755_o ? 4'b0001 : bank;
  /* ./A2601top.vhd:514:73  */
  assign n759_o = n753_o ? 4'b0000 : n757_o;
  /* ./A2601top.vhd:486:65  */
  assign n760_o = n685_o ? bank : n759_o;
  /* ./A2601top.vhd:486:65  */
  assign n761_o = n685_o ? n745_o : dpcmusicmodes;
  /* ./A2601top.vhd:486:65  */
  assign n762_o = n685_o ? n746_o : dpctops;
  /* ./A2601top.vhd:486:65  */
  assign n763_o = n685_o ? n747_o : dpcbottoms;
  /* ./A2601top.vhd:486:65  */
  assign n764_o = n685_o ? n748_o : dpcflags;
  /* ./A2601top.vhd:486:65  */
  assign n765_o = n685_o ? n749_o : dpccounters;
  /* ./A2601top.vhd:486:65  */
  assign n766_o = n685_o ? n751_o : dpcrandom;
  /* ./A2601top.vhd:461:65  */
  assign n767_o = n614_o ? bank : n760_o;
  /* ./A2601top.vhd:461:65  */
  assign n768_o = n614_o ? dpcmusicmodes : n761_o;
  /* ./A2601top.vhd:461:65  */
  assign n769_o = n614_o ? dpctops : n762_o;
  /* ./A2601top.vhd:461:65  */
  assign n770_o = n614_o ? dpcbottoms : n763_o;
  /* ./A2601top.vhd:461:65  */
  assign n771_o = n614_o ? n682_o : n764_o;
  /* ./A2601top.vhd:461:65  */
  assign n772_o = n614_o ? n1252_o : n765_o;
  /* ./A2601top.vhd:461:65  */
  assign n773_o = n614_o ? n631_o : n766_o;
  /* ./A2601top.vhd:456:49  */
  assign n775_o = n784_o ? n767_o : bank;
  /* ./A2601top.vhd:456:49  */
  assign n776_o = n785_o ? n768_o : dpcmusicmodes;
  /* ./A2601top.vhd:456:49  */
  assign n777_o = n786_o ? n769_o : dpctops;
  /* ./A2601top.vhd:456:49  */
  assign n778_o = n787_o ? n770_o : dpcbottoms;
  /* ./A2601top.vhd:456:49  */
  assign n779_o = n788_o ? n771_o : dpcflags;
  /* ./A2601top.vhd:456:49  */
  assign n780_o = n789_o ? n772_o : dpccounters;
  /* ./A2601top.vhd:456:49  */
  assign n781_o = n790_o ? n773_o : dpcrandom;
  /* ./A2601top.vhd:456:49  */
  assign n784_o = n608_o & n607_o;
  /* ./A2601top.vhd:456:49  */
  assign n785_o = n608_o & n607_o;
  /* ./A2601top.vhd:456:49  */
  assign n786_o = n608_o & n607_o;
  /* ./A2601top.vhd:456:49  */
  assign n787_o = n608_o & n607_o;
  /* ./A2601top.vhd:456:49  */
  assign n788_o = n608_o & n607_o;
  /* ./A2601top.vhd:456:49  */
  assign n789_o = n608_o & n607_o;
  /* ./A2601top.vhd:456:49  */
  assign n790_o = n608_o & n607_o;
  /* ./A2601top.vhd:456:49  */
  assign n792_o = n607_o ? cpu_a : bankswch_addr_v;
  /* ./A2601top.vhd:455:41  */
  assign n795_o = bss == 4'b0111;
  /* ./A2601top.vhd:525:81  */
  assign n796_o = cpu_d[5];
  /* ./A2601top.vhd:525:72  */
  assign n797_o = ~n796_o;
  /* ./A2601top.vhd:525:70  */
  assign n799_o = {3'b000, n797_o};
  /* ./A2601top.vhd:524:49  */
  assign n800_o = fe_latch ? n799_o : bank;
  /* ./A2601top.vhd:529:72  */
  assign n802_o = cpu_a == 13'b0000111111110;
  /* ./A2601top.vhd:529:49  */
  assign n805_o = n802_o ? 1'b1 : 1'b0;
  /* ./A2601top.vhd:522:41  */
  assign n807_o = bss == 4'b0011;
  /* ./A2601top.vhd:535:58  */
  assign n808_o = cpu_a[12:4];
  /* ./A2601top.vhd:535:72  */
  assign n810_o = n808_o == 9'b111111110;
  /* ./A2601top.vhd:535:95  */
  assign n811_o = cpu_a[3];
  /* ./A2601top.vhd:535:99  */
  assign n812_o = ~n811_o;
  /* ./A2601top.vhd:535:86  */
  assign n813_o = n812_o & n810_o;
  /* ./A2601top.vhd:536:74  */
  assign n814_o = cpu_a[2:0];
  /* ./A2601top.vhd:537:61  */
  assign n815_o = cpu_a[12:4];
  /* ./A2601top.vhd:537:75  */
  assign n817_o = n815_o == 9'b111111110;
  /* ./A2601top.vhd:537:98  */
  assign n818_o = cpu_a[3];
  /* ./A2601top.vhd:537:89  */
  assign n819_o = n818_o & n817_o;
  /* ./A2601top.vhd:538:74  */
  assign n820_o = cpu_a[2:0];
  /* ./A2601top.vhd:539:61  */
  assign n821_o = cpu_a[12:4];
  /* ./A2601top.vhd:539:75  */
  assign n823_o = n821_o == 9'b111111111;
  /* ./A2601top.vhd:539:98  */
  assign n824_o = cpu_a[3];
  /* ./A2601top.vhd:539:102  */
  assign n825_o = ~n824_o;
  /* ./A2601top.vhd:539:89  */
  assign n826_o = n825_o & n823_o;
  /* ./A2601top.vhd:540:74  */
  assign n827_o = cpu_a[2:0];
  /* ./A2601top.vhd:539:49  */
  assign n828_o = n826_o ? n827_o : e0_bank2;
  /* ./A2601top.vhd:537:49  */
  assign n829_o = n819_o ? n820_o : e0_bank1;
  /* ./A2601top.vhd:537:49  */
  assign n830_o = n819_o ? e0_bank2 : n828_o;
  /* ./A2601top.vhd:535:49  */
  assign n831_o = n813_o ? n814_o : e0_bank0;
  /* ./A2601top.vhd:535:49  */
  assign n832_o = n813_o ? e0_bank1 : n829_o;
  /* ./A2601top.vhd:535:49  */
  assign n833_o = n813_o ? e0_bank2 : n830_o;
  /* ./A2601top.vhd:534:41  */
  assign n835_o = bss == 4'b0100;
  /* ./A2601top.vhd:543:59  */
  assign n837_o = cpu_a == 13'b0000000111111;
  /* ./A2601top.vhd:544:82  */
  assign n838_o = cpu_d[1:0];
  assign n839_o = bank[1:0];
  /* ./A2601top.vhd:543:49  */
  assign n840_o = n837_o ? n838_o : n839_o;
  /* ./A2601top.vhd:542:41  */
  assign n842_o = bss == 4'b0101;
  /* ./A2601top.vhd:547:59  */
  assign n844_o = cpu_a == 13'b0001000100000;
  /* ./A2601top.vhd:549:62  */
  assign n846_o = cpu_a == 13'b0001001000000;
  /* ./A2601top.vhd:549:49  */
  assign n848_o = n846_o ? 4'b0001 : bank;
  /* ./A2601top.vhd:547:49  */
  assign n850_o = n844_o ? 4'b0000 : n848_o;
  /* ./A2601top.vhd:546:41  */
  assign n852_o = bss == 4'b1011;
  /* ./A2601top.vhd:553:57  */
  assign n853_o = cpu_a[12:4];
  /* ./A2601top.vhd:553:71  */
  assign n855_o = n853_o == 9'b111111110;
  /* ./A2601top.vhd:554:65  */
  assign n856_o = cpu_a[3];
  /* ./A2601top.vhd:554:69  */
  assign n857_o = ~n856_o;
  /* ./A2601top.vhd:555:82  */
  assign n858_o = cpu_a[2:0];
  /* ./A2601top.vhd:556:68  */
  assign n859_o = cpu_a[2];
  /* ./A2601top.vhd:556:72  */
  assign n860_o = ~n859_o;
  /* ./A2601top.vhd:557:84  */
  assign n861_o = cpu_a[1:0];
  /* ./A2601top.vhd:556:57  */
  assign n862_o = n860_o ? n861_o : e7_rambank;
  /* ./A2601top.vhd:553:49  */
  assign n863_o = n865_o ? n858_o : e7_bank0;
  /* ./A2601top.vhd:554:57  */
  assign n864_o = n857_o ? e7_rambank : n862_o;
  /* ./A2601top.vhd:553:49  */
  assign n865_o = n857_o & n855_o;
  /* ./A2601top.vhd:553:49  */
  assign n866_o = n855_o ? n864_o : e7_rambank;
  /* ./A2601top.vhd:552:41  */
  assign n868_o = bss == 4'b1100;
  /* ./A2601top.vhd:561:58  */
  assign n870_o = cpu_a == 13'b1111111110000;
  /* ./A2601top.vhd:562:70  */
  assign n871_o = ~last_1ff0;
  /* ./A2601top.vhd:563:78  */
  assign n873_o = bank + 4'b0001;
  /* ./A2601top.vhd:561:49  */
  assign n874_o = n875_o ? n873_o : bank;
  /* ./A2601top.vhd:561:49  */
  assign n875_o = n871_o & n870_o;
  /* ./A2601top.vhd:561:49  */
  assign n878_o = n870_o ? 1'b1 : 1'b0;
  /* ./A2601top.vhd:560:41  */
  assign n880_o = bss == 4'b1101;
  assign n881_o = {n880_o, n868_o, n852_o, n842_o, n835_o, n807_o, n795_o, n606_o, n572_o, n554_o, n544_o};
  assign n882_o = n542_o[1:0];
  assign n883_o = n552_o[1:0];
  assign n884_o = n570_o[1:0];
  assign n885_o = n604_o[1:0];
  assign n886_o = n775_o[1:0];
  assign n887_o = n800_o[1:0];
  assign n888_o = n850_o[1:0];
  assign n889_o = n874_o[1:0];
  assign n890_o = bank[1:0];
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n891_o = n889_o;
      11'b01000000000: n891_o = n890_o;
      11'b00100000000: n891_o = n888_o;
      11'b00010000000: n891_o = n840_o;
      11'b00001000000: n891_o = n890_o;
      11'b00000100000: n891_o = n887_o;
      11'b00000010000: n891_o = n886_o;
      11'b00000001000: n891_o = n885_o;
      11'b00000000100: n891_o = n884_o;
      11'b00000000010: n891_o = n883_o;
      11'b00000000001: n891_o = n882_o;
      default: n891_o = n890_o;
    endcase
  assign n892_o = n542_o[3:2];
  assign n893_o = n552_o[3:2];
  assign n894_o = n570_o[3:2];
  assign n895_o = n604_o[3:2];
  assign n896_o = n775_o[3:2];
  assign n897_o = n800_o[3:2];
  assign n898_o = n850_o[3:2];
  assign n899_o = n874_o[3:2];
  assign n900_o = bank[3:2];
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n901_o = n899_o;
      11'b01000000000: n901_o = n900_o;
      11'b00100000000: n901_o = n898_o;
      11'b00010000000: n901_o = n900_o;
      11'b00001000000: n901_o = n900_o;
      11'b00000100000: n901_o = n897_o;
      11'b00000010000: n901_o = n896_o;
      11'b00000001000: n901_o = n895_o;
      11'b00000000100: n901_o = n894_o;
      11'b00000000010: n901_o = n893_o;
      11'b00000000001: n901_o = n892_o;
      default: n901_o = n900_o;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n902_o = n878_o;
      11'b01000000000: n902_o = last_1ff0;
      11'b00100000000: n902_o = last_1ff0;
      11'b00010000000: n902_o = last_1ff0;
      11'b00001000000: n902_o = last_1ff0;
      11'b00000100000: n902_o = last_1ff0;
      11'b00000010000: n902_o = last_1ff0;
      11'b00000001000: n902_o = last_1ff0;
      11'b00000000100: n902_o = last_1ff0;
      11'b00000000010: n902_o = last_1ff0;
      11'b00000000001: n902_o = last_1ff0;
      default: n902_o = last_1ff0;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n903_o = e0_bank0;
      11'b01000000000: n903_o = e0_bank0;
      11'b00100000000: n903_o = e0_bank0;
      11'b00010000000: n903_o = e0_bank0;
      11'b00001000000: n903_o = n831_o;
      11'b00000100000: n903_o = e0_bank0;
      11'b00000010000: n903_o = e0_bank0;
      11'b00000001000: n903_o = e0_bank0;
      11'b00000000100: n903_o = e0_bank0;
      11'b00000000010: n903_o = e0_bank0;
      11'b00000000001: n903_o = e0_bank0;
      default: n903_o = e0_bank0;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n904_o = e0_bank1;
      11'b01000000000: n904_o = e0_bank1;
      11'b00100000000: n904_o = e0_bank1;
      11'b00010000000: n904_o = e0_bank1;
      11'b00001000000: n904_o = n832_o;
      11'b00000100000: n904_o = e0_bank1;
      11'b00000010000: n904_o = e0_bank1;
      11'b00000001000: n904_o = e0_bank1;
      11'b00000000100: n904_o = e0_bank1;
      11'b00000000010: n904_o = e0_bank1;
      11'b00000000001: n904_o = e0_bank1;
      default: n904_o = e0_bank1;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n905_o = e0_bank2;
      11'b01000000000: n905_o = e0_bank2;
      11'b00100000000: n905_o = e0_bank2;
      11'b00010000000: n905_o = e0_bank2;
      11'b00001000000: n905_o = n833_o;
      11'b00000100000: n905_o = e0_bank2;
      11'b00000010000: n905_o = e0_bank2;
      11'b00000001000: n905_o = e0_bank2;
      11'b00000000100: n905_o = e0_bank2;
      11'b00000000010: n905_o = e0_bank2;
      11'b00000000001: n905_o = e0_bank2;
      default: n905_o = e0_bank2;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n906_o = fe_latch;
      11'b01000000000: n906_o = fe_latch;
      11'b00100000000: n906_o = fe_latch;
      11'b00010000000: n906_o = fe_latch;
      11'b00001000000: n906_o = fe_latch;
      11'b00000100000: n906_o = n805_o;
      11'b00000010000: n906_o = fe_latch;
      11'b00000001000: n906_o = fe_latch;
      11'b00000000100: n906_o = fe_latch;
      11'b00000000010: n906_o = fe_latch;
      11'b00000000001: n906_o = fe_latch;
      default: n906_o = fe_latch;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n907_o = e7_bank0;
      11'b01000000000: n907_o = n863_o;
      11'b00100000000: n907_o = e7_bank0;
      11'b00010000000: n907_o = e7_bank0;
      11'b00001000000: n907_o = e7_bank0;
      11'b00000100000: n907_o = e7_bank0;
      11'b00000010000: n907_o = e7_bank0;
      11'b00000001000: n907_o = e7_bank0;
      11'b00000000100: n907_o = e7_bank0;
      11'b00000000010: n907_o = e7_bank0;
      11'b00000000001: n907_o = e7_bank0;
      default: n907_o = e7_bank0;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n908_o = e7_rambank;
      11'b01000000000: n908_o = n866_o;
      11'b00100000000: n908_o = e7_rambank;
      11'b00010000000: n908_o = e7_rambank;
      11'b00001000000: n908_o = e7_rambank;
      11'b00000100000: n908_o = e7_rambank;
      11'b00000010000: n908_o = e7_rambank;
      11'b00000001000: n908_o = e7_rambank;
      11'b00000000100: n908_o = e7_rambank;
      11'b00000000010: n908_o = e7_rambank;
      11'b00000000001: n908_o = e7_rambank;
      default: n908_o = e7_rambank;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n909_o = dpcmusicmodes;
      11'b01000000000: n909_o = dpcmusicmodes;
      11'b00100000000: n909_o = dpcmusicmodes;
      11'b00010000000: n909_o = dpcmusicmodes;
      11'b00001000000: n909_o = dpcmusicmodes;
      11'b00000100000: n909_o = dpcmusicmodes;
      11'b00000010000: n909_o = n776_o;
      11'b00000001000: n909_o = dpcmusicmodes;
      11'b00000000100: n909_o = dpcmusicmodes;
      11'b00000000010: n909_o = dpcmusicmodes;
      11'b00000000001: n909_o = dpcmusicmodes;
      default: n909_o = dpcmusicmodes;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n910_o = dpctops;
      11'b01000000000: n910_o = dpctops;
      11'b00100000000: n910_o = dpctops;
      11'b00010000000: n910_o = dpctops;
      11'b00001000000: n910_o = dpctops;
      11'b00000100000: n910_o = dpctops;
      11'b00000010000: n910_o = n777_o;
      11'b00000001000: n910_o = dpctops;
      11'b00000000100: n910_o = dpctops;
      11'b00000000010: n910_o = dpctops;
      11'b00000000001: n910_o = dpctops;
      default: n910_o = dpctops;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n911_o = dpcbottoms;
      11'b01000000000: n911_o = dpcbottoms;
      11'b00100000000: n911_o = dpcbottoms;
      11'b00010000000: n911_o = dpcbottoms;
      11'b00001000000: n911_o = dpcbottoms;
      11'b00000100000: n911_o = dpcbottoms;
      11'b00000010000: n911_o = n778_o;
      11'b00000001000: n911_o = dpcbottoms;
      11'b00000000100: n911_o = dpcbottoms;
      11'b00000000010: n911_o = dpcbottoms;
      11'b00000000001: n911_o = dpcbottoms;
      default: n911_o = dpcbottoms;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n912_o = dpcflags;
      11'b01000000000: n912_o = dpcflags;
      11'b00100000000: n912_o = dpcflags;
      11'b00010000000: n912_o = dpcflags;
      11'b00001000000: n912_o = dpcflags;
      11'b00000100000: n912_o = dpcflags;
      11'b00000010000: n912_o = n779_o;
      11'b00000001000: n912_o = dpcflags;
      11'b00000000100: n912_o = dpcflags;
      11'b00000000010: n912_o = dpcflags;
      11'b00000000001: n912_o = dpcflags;
      default: n912_o = dpcflags;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n913_o = dpccounters;
      11'b01000000000: n913_o = dpccounters;
      11'b00100000000: n913_o = dpccounters;
      11'b00010000000: n913_o = dpccounters;
      11'b00001000000: n913_o = dpccounters;
      11'b00000100000: n913_o = dpccounters;
      11'b00000010000: n913_o = n780_o;
      11'b00000001000: n913_o = dpccounters;
      11'b00000000100: n913_o = dpccounters;
      11'b00000000010: n913_o = dpccounters;
      11'b00000000001: n913_o = dpccounters;
      default: n913_o = dpccounters;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n914_o = dpcrandom;
      11'b01000000000: n914_o = dpcrandom;
      11'b00100000000: n914_o = dpcrandom;
      11'b00010000000: n914_o = dpcrandom;
      11'b00001000000: n914_o = dpcrandom;
      11'b00000100000: n914_o = dpcrandom;
      11'b00000010000: n914_o = n781_o;
      11'b00000001000: n914_o = dpcrandom;
      11'b00000000100: n914_o = dpcrandom;
      11'b00000000010: n914_o = dpcrandom;
      11'b00000000001: n914_o = dpcrandom;
      default: n914_o = dpcrandom;
    endcase
  /* ./A2601top.vhd:412:33  */
  always @*
    case (n881_o)
      11'b10000000000: n916_o = bankswch_addr_v;
      11'b01000000000: n916_o = bankswch_addr_v;
      11'b00100000000: n916_o = bankswch_addr_v;
      11'b00010000000: n916_o = bankswch_addr_v;
      11'b00001000000: n916_o = bankswch_addr_v;
      11'b00000100000: n916_o = bankswch_addr_v;
      11'b00000010000: n916_o = n792_o;
      11'b00000001000: n916_o = bankswch_addr_v;
      11'b00000000100: n916_o = bankswch_addr_v;
      11'b00000000010: n916_o = bankswch_addr_v;
      11'b00000000001: n916_o = bankswch_addr_v;
      default: n916_o = bankswch_addr_v;
    endcase
  assign n918_o = {n901_o, n891_o};
  /* ./A2601top.vhd:399:25  */
  assign n920_o = rst ? 4'b0000 : n918_o;
  /* ./A2601top.vhd:399:25  */
  assign n923_o = rst ? 1'b0 : n902_o;
  /* ./A2601top.vhd:399:25  */
  assign n925_o = rst ? 3'b000 : n903_o;
  /* ./A2601top.vhd:399:25  */
  assign n927_o = rst ? 3'b000 : n904_o;
  /* ./A2601top.vhd:399:25  */
  assign n929_o = rst ? 3'b000 : n905_o;
  /* ./A2601top.vhd:399:25  */
  assign n930_o = rst ? fe_latch : n906_o;
  /* ./A2601top.vhd:399:25  */
  assign n931_o = rst ? e7_bank0 : n907_o;
  /* ./A2601top.vhd:399:25  */
  assign n932_o = rst ? e7_rambank : n908_o;
  /* ./A2601top.vhd:399:25  */
  assign n933_o = rst ? dpcmusicmodes : n909_o;
  /* ./A2601top.vhd:399:25  */
  assign n934_o = rst ? dpctops : n910_o;
  /* ./A2601top.vhd:399:25  */
  assign n935_o = rst ? dpcbottoms : n911_o;
  /* ./A2601top.vhd:399:25  */
  assign n936_o = rst ? dpcflags : n912_o;
  /* ./A2601top.vhd:399:25  */
  assign n937_o = rst ? dpccounters : n913_o;
  /* ./A2601top.vhd:399:25  */
  assign n938_o = rst ? dpcrandom : n914_o;
  /* ./A2601top.vhd:399:25  */
  assign n940_o = rst ? bankswch_addr_v : n916_o;
  /* ./A2601top.vhd:396:17  */
  assign n945_o = rst & ph0_en;
  /* ./A2601top.vhd:395:5  */
  assign n985_o = ph0_en ? n940_o : bankswch_addr_v;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n986_q <= n985_o;
  /* ./A2601top.vhd:580:21  */
  assign n992_o = force_bs != 4'b0000;
  /* ./A2601top.vhd:582:25  */
  assign n994_o = rom_size == 17'b00000000000000000;
  /* ./A2601top.vhd:584:24  */
  assign n996_o = $unsigned(rom_size) <= $unsigned(17'b00000100000000000);
  /* ./A2601top.vhd:586:24  */
  assign n998_o = $unsigned(rom_size) <= $unsigned(17'b00001000000000000);
  /* ./A2601top.vhd:588:24  */
  assign n1000_o = $unsigned(rom_size) <= $unsigned(17'b00010000000000000);
  /* ./A2601top.vhd:590:24  */
  assign n1002_o = $unsigned(rom_size) <= $unsigned(17'b00011000000000000);
  /* ./A2601top.vhd:592:24  */
  assign n1004_o = $unsigned(rom_size) <= $unsigned(17'b00100000000000000);
  /* ./A2601top.vhd:594:24  */
  assign n1006_o = $unsigned(rom_size) <= $unsigned(17'b01000000000000000);
  /* ./A2601top.vhd:596:24  */
  assign n1008_o = $unsigned(rom_size) <= $unsigned(17'b10000000000000000);
  /* ./A2601top.vhd:596:9  */
  assign n1011_o = n1008_o ? 4'b1110 : 4'b0000;
  /* ./A2601top.vhd:594:9  */
  assign n1013_o = n1006_o ? 4'b0110 : n1011_o;
  /* ./A2601top.vhd:592:9  */
  assign n1015_o = n1004_o ? 4'b0010 : n1013_o;
  /* ./A2601top.vhd:590:9  */
  assign n1017_o = n1002_o ? 4'b1000 : n1015_o;
  /* ./A2601top.vhd:588:9  */
  assign n1019_o = n1000_o ? 4'b0001 : n1017_o;
  /* ./A2601top.vhd:586:9  */
  assign n1021_o = n998_o ? 4'b0000 : n1019_o;
  /* ./A2601top.vhd:584:9  */
  assign n1023_o = n996_o ? 4'b1010 : n1021_o;
  /* ./A2601top.vhd:582:9  */
  assign n1025_o = n994_o ? 4'b0000 : n1023_o;
  /* ./A2601top.vhd:580:9  */
  assign n1026_o = n992_o ? force_bs : n1025_o;
  /* ./A2601top.vhd:606:52  */
  assign n1032_o = dpcclockdivider + 10'b0000000001;
  /* ./A2601top.vhd:607:36  */
  assign n1034_o = dpcclockdivider == 10'b0101010110;
  /* ./A2601top.vhd:607:17  */
  assign n1036_o = n1034_o ? 10'b0000000000 : n1032_o;
  /* ./A2601top.vhd:608:36  */
  assign n1038_o = dpcclockdivider == 10'b0000000000;
  /* ./A2601top.vhd:609:48  */
  assign n1040_o = dpcclocks + 16'b0000000000000001;
  /* ./A2601top.vhd:610:28  */
  assign n1041_o = {15'b0, dpcclocks};  //  uext
  /* ./A2601top.vhd:610:60  */
  assign n1042_o = {1'b0, n1041_o};  //  uext
  /* ./A2601top.vhd:610:91  */
  assign n1043_o = dpctops[23:16];
  /* ./A2601top.vhd:610:95  */
  assign n1045_o = n1043_o + 8'b00000001;
  /* ./A2601top.vhd:610:64  */
  assign n1046_o = {23'b0, n1045_o};  //  uext
  /* ./A2601top.vhd:610:60  */
  assign n1047_o = {1'b0, n1046_o};  //  uext
  /* ./A2601top.vhd:610:60  */
  assign n1048_o = n1042_o % n1047_o; // smod
  /* ./A2601top.vhd:610:111  */
  assign n1049_o = dpcbottoms[23:16];
  /* ./A2601top.vhd:610:99  */
  assign n1050_o = n1048_o[7:0];  // trunc
  /* ./A2601top.vhd:610:99  */
  assign n1051_o = $unsigned(n1050_o) > $unsigned(n1049_o);
  /* ./A2601top.vhd:610:25  */
  assign n1054_o = n1051_o ? 8'b11111111 : 8'b00000000;
  /* ./A2601top.vhd:615:28  */
  assign n1055_o = {15'b0, dpcclocks};  //  uext
  /* ./A2601top.vhd:615:60  */
  assign n1056_o = {1'b0, n1055_o};  //  uext
  /* ./A2601top.vhd:615:91  */
  assign n1057_o = dpctops[15:8];
  /* ./A2601top.vhd:615:95  */
  assign n1059_o = n1057_o + 8'b00000001;
  /* ./A2601top.vhd:615:64  */
  assign n1060_o = {23'b0, n1059_o};  //  uext
  /* ./A2601top.vhd:615:60  */
  assign n1061_o = {1'b0, n1060_o};  //  uext
  /* ./A2601top.vhd:615:60  */
  assign n1062_o = n1056_o % n1061_o; // smod
  /* ./A2601top.vhd:615:111  */
  assign n1063_o = dpcbottoms[15:8];
  /* ./A2601top.vhd:615:99  */
  assign n1064_o = n1062_o[7:0];  // trunc
  /* ./A2601top.vhd:615:99  */
  assign n1065_o = $unsigned(n1064_o) > $unsigned(n1063_o);
  /* ./A2601top.vhd:615:25  */
  assign n1068_o = n1065_o ? 8'b11111111 : 8'b00000000;
  /* ./A2601top.vhd:620:28  */
  assign n1069_o = {15'b0, dpcclocks};  //  uext
  /* ./A2601top.vhd:620:60  */
  assign n1070_o = {1'b0, n1069_o};  //  uext
  /* ./A2601top.vhd:620:91  */
  assign n1071_o = dpctops[7:0];
  /* ./A2601top.vhd:620:95  */
  assign n1073_o = n1071_o + 8'b00000001;
  /* ./A2601top.vhd:620:64  */
  assign n1074_o = {23'b0, n1073_o};  //  uext
  /* ./A2601top.vhd:620:60  */
  assign n1075_o = {1'b0, n1074_o};  //  uext
  /* ./A2601top.vhd:620:60  */
  assign n1076_o = n1070_o % n1075_o; // smod
  /* ./A2601top.vhd:620:111  */
  assign n1077_o = dpcbottoms[7:0];
  /* ./A2601top.vhd:620:99  */
  assign n1078_o = n1076_o[7:0];  // trunc
  /* ./A2601top.vhd:620:99  */
  assign n1079_o = $unsigned(n1078_o) > $unsigned(n1077_o);
  /* ./A2601top.vhd:620:25  */
  assign n1082_o = n1079_o ? 8'b11111111 : 8'b00000000;
  assign n1083_o = {n1082_o, n1068_o, n1054_o};
  assign n1091_o = {n88_o, n96_o};
  assign n1092_o = {n80_o, n79_o, 1'b1, 1'b1, p_color, 1'b1, p_select, p_start};
  /* ./A2601top.vhd:250:5  */
  assign n1093_o = ph0_en ? reset : rst;
  /* ./A2601top.vhd:250:5  */
  always @(posedge clk)
    n1094_q <= n1093_o;
  initial
    n1094_q = 1'b1;
  /* ./A2601top.vhd:395:5  */
  assign n1095_o = ph0_en ? rst : old_rst;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1096_q <= n1095_o;
  initial
    n1096_q = 1'b1;
  /* ./A2601top.vhd:395:5  */
  assign n1100_o = ph0_en ? n522_o : clr_a;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1101_q <= n1100_o;
  /* ./A2601top.vhd:395:5  */
  assign n1102_o = ph0_en ? n920_o : bank;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1103_q <= n1102_o;
  initial
    n1103_q = 4'b0000;
  /* ./A2601top.vhd:395:5  */
  assign n1104_o = n945_o ? n530_o : banks32;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1105_q <= n1104_o;
  initial
    n1105_q = 5'b00000;
  /* ./A2601top.vhd:395:5  */
  assign n1106_o = ph0_en ? n923_o : last_1ff0;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1107_q <= n1106_o;
  /* ./A2601top.vhd:395:5  */
  assign n1108_o = ph0_en ? n925_o : e0_bank0;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1109_q <= n1108_o;
  initial
    n1109_q = 3'b000;
  /* ./A2601top.vhd:395:5  */
  assign n1110_o = ph0_en ? n927_o : e0_bank1;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1111_q <= n1110_o;
  initial
    n1111_q = 3'b000;
  /* ./A2601top.vhd:395:5  */
  assign n1112_o = ph0_en ? n929_o : e0_bank2;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1113_q <= n1112_o;
  initial
    n1113_q = 3'b000;
  /* ./A2601top.vhd:395:5  */
  assign n1114_o = ph0_en ? n930_o : fe_latch;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1115_q <= n1114_o;
  /* ./A2601top.vhd:395:5  */
  assign n1116_o = ph0_en ? n931_o : e7_bank0;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1117_q <= n1116_o;
  /* ./A2601top.vhd:395:5  */
  assign n1118_o = ph0_en ? n932_o : e7_rambank;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1119_q <= n1118_o;
  /* ./A2601top.vhd:258:9  */
  always @(posedge clk)
    n1120_q <= n67_o;
  initial
    n1120_q = 1'b0;
  /* ./A2601top.vhd:258:9  */
  always @(posedge clk)
    n1121_q <= n75_o;
  initial
    n1121_q = 1'b0;
  /* ./A2601top.vhd:395:5  */
  assign n1122_o = ph0_en ? n933_o : dpcmusicmodes;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1123_q <= n1122_o;
  initial
    n1123_q = 24'b000000000000000000000000;
  /* ./A2601top.vhd:605:9  */
  assign n1124_o = n1038_o ? n1083_o : dpcmusicflags;
  /* ./A2601top.vhd:605:9  */
  always @(posedge clk)
    n1125_q <= n1124_o;
  initial
    n1125_q = 24'b000000000000000000000000;
  /* ./A2601top.vhd:395:5  */
  assign n1126_o = ph0_en ? n934_o : dpctops;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1127_q <= n1126_o;
  initial
    n1127_q = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:395:5  */
  assign n1128_o = ph0_en ? n935_o : dpcbottoms;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1129_q <= n1128_o;
  initial
    n1129_q = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:395:5  */
  assign n1130_o = ph0_en ? n936_o : dpcflags;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1131_q <= n1130_o;
  initial
    n1131_q = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:395:5  */
  assign n1132_o = ph0_en ? n937_o : dpccounters;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1133_q <= n1132_o;
  initial
    n1133_q = 88'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  /* ./A2601top.vhd:395:5  */
  assign n1134_o = ph0_en ? n938_o : dpcrandom;
  /* ./A2601top.vhd:395:5  */
  always @(posedge clk)
    n1135_q <= n1134_o;
  initial
    n1135_q = 8'b00000001;
  /* ./A2601top.vhd:605:9  */
  assign n1136_o = n1038_o ? n1040_o : dpcclocks;
  /* ./A2601top.vhd:605:9  */
  always @(posedge clk)
    n1137_q <= n1136_o;
  initial
    n1137_q = 16'b0000000000000000;
  /* ./A2601top.vhd:605:9  */
  always @(posedge clk)
    n1138_q <= n1036_o;
  /* ./A2601top.vhd:293:67  */
  reg [7:0] n1139[7:0] ; // memory
  initial begin
    n1139[7] = 8'b00000000;
    n1139[6] = 8'b00000100;
    n1139[5] = 8'b00000101;
    n1139[4] = 8'b00001001;
    n1139[3] = 8'b00000110;
    n1139[2] = 8'b00001010;
    n1139[1] = 8'b00001011;
    n1139[0] = 8'b00001111;
    end
  assign n1140_data = n1139[n305_o];
  /* ./A2601top.vhd:334:43  */
  /* ./A2601top.vhd:334:42  */
  assign n1141_o = dpcflags[7:0];
  /* ./A2601top.vhd:281:71  */
  assign n1142_o = dpcflags[15:8];
  /* ./A2601top.vhd:280:71  */
  assign n1143_o = dpcflags[23:16];
  /* ./A2601top.vhd:279:71  */
  assign n1144_o = dpcflags[31:24];
  /* ./A2601top.vhd:278:71  */
  assign n1145_o = dpcflags[39:32];
  /* ./A2601top.vhd:237:24  */
  assign n1146_o = dpcflags[47:40];
  /* ./A2601top.vhd:236:24  */
  assign n1147_o = dpcflags[55:48];
  /* ./A2601top.vhd:235:24  */
  assign n1148_o = dpcflags[63:56];
  /* ./A2601top.vhd:324:46  */
  assign n1149_o = n262_o[1:0];
  /* ./A2601top.vhd:324:46  */
  always @*
    case (n1149_o)
      2'b00: n1150_o = n1141_o;
      2'b01: n1150_o = n1142_o;
      2'b10: n1150_o = n1143_o;
      2'b11: n1150_o = n1144_o;
    endcase
  /* ./A2601top.vhd:324:46  */
  assign n1151_o = n262_o[1:0];
  /* ./A2601top.vhd:324:46  */
  always @*
    case (n1151_o)
      2'b00: n1152_o = n1145_o;
      2'b01: n1152_o = n1146_o;
      2'b10: n1152_o = n1147_o;
      2'b11: n1152_o = n1148_o;
    endcase
  /* ./A2601top.vhd:324:46  */
  assign n1153_o = n262_o[2];
  /* ./A2601top.vhd:324:46  */
  assign n1154_o = n1153_o ? n1152_o : n1150_o;
  /* ./A2601top.vhd:324:46  */
  assign n1155_o = dpcflags[7:0];
  /* ./A2601top.vhd:324:47  */
  assign n1156_o = dpcflags[15:8];
  /* ./A2601top.vhd:228:24  */
  assign n1157_o = dpcflags[23:16];
  /* ./A2601top.vhd:227:24  */
  assign n1158_o = dpcflags[31:24];
  /* ./A2601top.vhd:220:24  */
  assign n1159_o = dpcflags[39:32];
  /* ./A2601top.vhd:217:24  */
  assign n1160_o = dpcflags[47:40];
  /* ./A2601top.vhd:216:24  */
  assign n1161_o = dpcflags[55:48];
  /* ./A2601top.vhd:87:17  */
  assign n1162_o = dpcflags[63:56];
  /* ./A2601top.vhd:337:35  */
  assign n1163_o = n319_o[1:0];
  /* ./A2601top.vhd:337:35  */
  always @*
    case (n1163_o)
      2'b00: n1164_o = n1155_o;
      2'b01: n1164_o = n1156_o;
      2'b10: n1164_o = n1157_o;
      2'b11: n1164_o = n1158_o;
    endcase
  /* ./A2601top.vhd:337:35  */
  assign n1165_o = n319_o[1:0];
  /* ./A2601top.vhd:337:35  */
  always @*
    case (n1165_o)
      2'b00: n1166_o = n1159_o;
      2'b01: n1166_o = n1160_o;
      2'b10: n1166_o = n1161_o;
      2'b11: n1166_o = n1162_o;
    endcase
  /* ./A2601top.vhd:337:35  */
  assign n1167_o = n319_o[2];
  /* ./A2601top.vhd:337:35  */
  assign n1168_o = n1167_o ? n1166_o : n1164_o;
  /* ./A2601top.vhd:337:35  */
  assign n1169_o = dpccounters[10:0];
  /* ./A2601top.vhd:337:36  */
  assign n1170_o = dpccounters[21:11];
  /* ./A2601top.vhd:45:17  */
  assign n1171_o = dpccounters[32:22];
  /* ./A2601top.vhd:44:17  */
  assign n1172_o = dpccounters[43:33];
  /* ./A2601top.vhd:42:17  */
  assign n1173_o = dpccounters[54:44];
  /* ./A2601top.vhd:41:17  */
  assign n1174_o = dpccounters[65:55];
  assign n1175_o = dpccounters[76:66];
  assign n1176_o = dpccounters[87:77];
  /* ./A2601top.vhd:381:93  */
  assign n1177_o = n456_o[1:0];
  /* ./A2601top.vhd:381:93  */
  always @*
    case (n1177_o)
      2'b00: n1178_o = n1169_o;
      2'b01: n1178_o = n1170_o;
      2'b10: n1178_o = n1171_o;
      2'b11: n1178_o = n1172_o;
    endcase
  /* ./A2601top.vhd:381:93  */
  assign n1179_o = n456_o[1:0];
  /* ./A2601top.vhd:381:93  */
  always @*
    case (n1179_o)
      2'b00: n1180_o = n1173_o;
      2'b01: n1180_o = n1174_o;
      2'b10: n1180_o = n1175_o;
      2'b11: n1180_o = n1176_o;
    endcase
  /* ./A2601top.vhd:381:93  */
  assign n1181_o = n456_o[2];
  /* ./A2601top.vhd:381:93  */
  assign n1182_o = n1181_o ? n1180_o : n1178_o;
  /* ./A2601top.vhd:381:93  */
  assign n1183_o = dpccounters[10:0];
  /* ./A2601top.vhd:381:53  */
  assign n1184_o = dpccounters[21:11];
  assign n1185_o = dpccounters[32:22];
  /* ./A2601top.vhd:578:1  */
  assign n1186_o = dpccounters[43:33];
  /* ./A2601top.vhd:395:5  */
  assign n1187_o = dpccounters[54:44];
  /* ./A2601top.vhd:395:5  */
  assign n1188_o = dpccounters[65:55];
  /* ./A2601top.vhd:395:5  */
  assign n1189_o = dpccounters[76:66];
  /* ./A2601top.vhd:395:5  */
  assign n1190_o = dpccounters[87:77];
  /* ./A2601top.vhd:473:66  */
  assign n1191_o = n632_o[1:0];
  /* ./A2601top.vhd:473:66  */
  always @*
    case (n1191_o)
      2'b00: n1192_o = n1183_o;
      2'b01: n1192_o = n1184_o;
      2'b10: n1192_o = n1185_o;
      2'b11: n1192_o = n1186_o;
    endcase
  /* ./A2601top.vhd:473:66  */
  assign n1193_o = n632_o[1:0];
  /* ./A2601top.vhd:473:66  */
  always @*
    case (n1193_o)
      2'b00: n1194_o = n1187_o;
      2'b01: n1194_o = n1188_o;
      2'b10: n1194_o = n1189_o;
      2'b11: n1194_o = n1190_o;
    endcase
  /* ./A2601top.vhd:473:66  */
  assign n1195_o = n632_o[2];
  /* ./A2601top.vhd:473:66  */
  assign n1196_o = n1195_o ? n1194_o : n1192_o;
  /* ./A2601top.vhd:473:66  */
  assign n1197_o = dpcmusicmodes[4];
  /* ./A2601top.vhd:473:67  */
  assign n1198_o = dpcmusicmodes[12];
  /* ./A2601top.vhd:395:5  */
  assign n1199_o = dpcmusicmodes[20];
  /* ./A2601top.vhd:395:5  */
  assign n1200_o = n641_o[0];
  /* ./A2601top.vhd:474:142  */
  assign n1201_o = n1200_o ? n1198_o : n1197_o;
  /* ./A2601top.vhd:395:5  */
  assign n1202_o = n641_o[1];
  /* ./A2601top.vhd:474:142  */
  assign n1203_o = n1202_o ? n1199_o : n1201_o;
  /* ./A2601top.vhd:474:142  */
  assign n1204_o = dpccounters[10:0];
  /* ./A2601top.vhd:474:130  */
  assign n1205_o = dpccounters[21:11];
  /* ./A2601top.vhd:395:5  */
  assign n1206_o = dpccounters[32:22];
  /* ./A2601top.vhd:395:5  */
  assign n1207_o = dpccounters[43:33];
  /* ./A2601top.vhd:395:5  */
  assign n1208_o = dpccounters[54:44];
  /* ./A2601top.vhd:395:5  */
  assign n1209_o = dpccounters[65:55];
  /* ./A2601top.vhd:395:5  */
  assign n1210_o = dpccounters[76:66];
  /* ./A2601top.vhd:395:5  */
  assign n1211_o = dpccounters[87:77];
  /* ./A2601top.vhd:475:110  */
  assign n1212_o = n646_o[1:0];
  /* ./A2601top.vhd:475:110  */
  always @*
    case (n1212_o)
      2'b00: n1213_o = n1204_o;
      2'b01: n1213_o = n1205_o;
      2'b10: n1213_o = n1206_o;
      2'b11: n1213_o = n1207_o;
    endcase
  /* ./A2601top.vhd:475:110  */
  assign n1214_o = n646_o[1:0];
  /* ./A2601top.vhd:475:110  */
  always @*
    case (n1214_o)
      2'b00: n1215_o = n1208_o;
      2'b01: n1215_o = n1209_o;
      2'b10: n1215_o = n1210_o;
      2'b11: n1215_o = n1211_o;
    endcase
  /* ./A2601top.vhd:475:110  */
  assign n1216_o = n646_o[2];
  /* ./A2601top.vhd:475:110  */
  assign n1217_o = n1216_o ? n1215_o : n1213_o;
  /* ./A2601top.vhd:478:73  */
  assign n1218_o = n652_o[2];
  /* ./A2601top.vhd:478:73  */
  assign n1219_o = ~n1218_o;
  /* ./A2601top.vhd:478:73  */
  assign n1220_o = n652_o[1];
  /* ./A2601top.vhd:478:73  */
  assign n1221_o = ~n1220_o;
  /* ./A2601top.vhd:478:73  */
  assign n1222_o = n1219_o & n1221_o;
  /* ./A2601top.vhd:478:73  */
  assign n1223_o = n1219_o & n1220_o;
  /* ./A2601top.vhd:478:73  */
  assign n1224_o = n1218_o & n1221_o;
  /* ./A2601top.vhd:478:73  */
  assign n1225_o = n1218_o & n1220_o;
  /* ./A2601top.vhd:478:73  */
  assign n1226_o = n652_o[0];
  /* ./A2601top.vhd:478:73  */
  assign n1227_o = ~n1226_o;
  /* ./A2601top.vhd:478:73  */
  assign n1228_o = n1222_o & n1227_o;
  /* ./A2601top.vhd:478:73  */
  assign n1229_o = n1222_o & n1226_o;
  /* ./A2601top.vhd:478:73  */
  assign n1230_o = n1223_o & n1227_o;
  /* ./A2601top.vhd:478:73  */
  assign n1231_o = n1223_o & n1226_o;
  /* ./A2601top.vhd:478:73  */
  assign n1232_o = n1224_o & n1227_o;
  /* ./A2601top.vhd:478:73  */
  assign n1233_o = n1224_o & n1226_o;
  /* ./A2601top.vhd:478:73  */
  assign n1234_o = n1225_o & n1227_o;
  /* ./A2601top.vhd:478:73  */
  assign n1235_o = n1225_o & n1226_o;
  /* ./A2601top.vhd:323:9  */
  assign n1236_o = dpccounters[10:0];
  /* ./A2601top.vhd:478:73  */
  assign n1237_o = n1228_o ? n651_o : n1236_o;
  /* ./A2601top.vhd:327:9  */
  assign n1238_o = dpccounters[21:11];
  /* ./A2601top.vhd:478:73  */
  assign n1239_o = n1229_o ? n651_o : n1238_o;
  /* ./A2601top.vhd:337:36  */
  assign n1240_o = dpccounters[32:22];
  /* ./A2601top.vhd:478:73  */
  assign n1241_o = n1230_o ? n651_o : n1240_o;
  assign n1242_o = dpccounters[43:33];
  /* ./A2601top.vhd:478:73  */
  assign n1243_o = n1231_o ? n651_o : n1242_o;
  /* ./A2601top.vhd:314:1  */
  assign n1244_o = dpccounters[54:44];
  /* ./A2601top.vhd:478:73  */
  assign n1245_o = n1232_o ? n651_o : n1244_o;
  assign n1246_o = dpccounters[65:55];
  /* ./A2601top.vhd:478:73  */
  assign n1247_o = n1233_o ? n651_o : n1246_o;
  assign n1248_o = dpccounters[76:66];
  /* ./A2601top.vhd:478:73  */
  assign n1249_o = n1234_o ? n651_o : n1248_o;
  assign n1250_o = dpccounters[87:77];
  /* ./A2601top.vhd:478:73  */
  assign n1251_o = n1235_o ? n651_o : n1250_o;
  assign n1252_o = {n1251_o, n1249_o, n1247_o, n1245_o, n1243_o, n1241_o, n1239_o, n1237_o};
  /* ./A2601top.vhd:478:85  */
  assign n1253_o = dpctops[7:0];
  /* ./A2601top.vhd:478:73  */
  assign n1254_o = dpctops[15:8];
  /* ./A2601top.vhd:315:18  */
  assign n1255_o = dpctops[23:16];
  assign n1256_o = dpctops[31:24];
  assign n1257_o = dpctops[39:32];
  /* ./A2601top.vhd:257:1  */
  assign n1258_o = dpctops[47:40];
  assign n1259_o = dpctops[55:48];
  /* ./A2601top.vhd:250:5  */
  assign n1260_o = dpctops[63:56];
  /* ./A2601top.vhd:480:113  */
  assign n1261_o = n658_o[1:0];
  /* ./A2601top.vhd:480:113  */
  always @*
    case (n1261_o)
      2'b00: n1262_o = n1253_o;
      2'b01: n1262_o = n1254_o;
      2'b10: n1262_o = n1255_o;
      2'b11: n1262_o = n1256_o;
    endcase
  /* ./A2601top.vhd:480:113  */
  assign n1263_o = n658_o[1:0];
  /* ./A2601top.vhd:480:113  */
  always @*
    case (n1263_o)
      2'b00: n1264_o = n1257_o;
      2'b01: n1264_o = n1258_o;
      2'b10: n1264_o = n1259_o;
      2'b11: n1264_o = n1260_o;
    endcase
  /* ./A2601top.vhd:480:113  */
  assign n1265_o = n658_o[2];
  /* ./A2601top.vhd:480:113  */
  assign n1266_o = n1265_o ? n1264_o : n1262_o;
  /* ./A2601top.vhd:481:82  */
  assign n1267_o = n664_o[2];
  /* ./A2601top.vhd:481:82  */
  assign n1268_o = ~n1267_o;
  /* ./A2601top.vhd:481:82  */
  assign n1269_o = n664_o[1];
  /* ./A2601top.vhd:481:82  */
  assign n1270_o = ~n1269_o;
  /* ./A2601top.vhd:481:82  */
  assign n1271_o = n1268_o & n1270_o;
  /* ./A2601top.vhd:481:82  */
  assign n1272_o = n1268_o & n1269_o;
  /* ./A2601top.vhd:481:82  */
  assign n1273_o = n1267_o & n1270_o;
  /* ./A2601top.vhd:481:82  */
  assign n1274_o = n1267_o & n1269_o;
  /* ./A2601top.vhd:481:82  */
  assign n1275_o = n664_o[0];
  /* ./A2601top.vhd:481:82  */
  assign n1276_o = ~n1275_o;
  /* ./A2601top.vhd:481:82  */
  assign n1277_o = n1271_o & n1276_o;
  /* ./A2601top.vhd:481:82  */
  assign n1278_o = n1271_o & n1275_o;
  /* ./A2601top.vhd:481:82  */
  assign n1279_o = n1272_o & n1276_o;
  /* ./A2601top.vhd:481:82  */
  assign n1280_o = n1272_o & n1275_o;
  /* ./A2601top.vhd:481:82  */
  assign n1281_o = n1273_o & n1276_o;
  /* ./A2601top.vhd:481:82  */
  assign n1282_o = n1273_o & n1275_o;
  /* ./A2601top.vhd:481:82  */
  assign n1283_o = n1274_o & n1276_o;
  /* ./A2601top.vhd:481:82  */
  assign n1284_o = n1274_o & n1275_o;
  assign n1285_o = dpcflags[7:0];
  /* ./A2601top.vhd:481:82  */
  assign n1286_o = n1277_o ? 8'b11111111 : n1285_o;
  assign n1287_o = dpcflags[15:8];
  /* ./A2601top.vhd:481:82  */
  assign n1288_o = n1278_o ? 8'b11111111 : n1287_o;
  assign n1289_o = dpcflags[23:16];
  /* ./A2601top.vhd:481:82  */
  assign n1290_o = n1279_o ? 8'b11111111 : n1289_o;
  assign n1291_o = dpcflags[31:24];
  /* ./A2601top.vhd:481:82  */
  assign n1292_o = n1280_o ? 8'b11111111 : n1291_o;
  assign n1293_o = dpcflags[39:32];
  /* ./A2601top.vhd:481:82  */
  assign n1294_o = n1281_o ? 8'b11111111 : n1293_o;
  assign n1295_o = dpcflags[47:40];
  /* ./A2601top.vhd:481:82  */
  assign n1296_o = n1282_o ? 8'b11111111 : n1295_o;
  assign n1297_o = dpcflags[55:48];
  /* ./A2601top.vhd:481:82  */
  assign n1298_o = n1283_o ? 8'b11111111 : n1297_o;
  assign n1299_o = dpcflags[63:56];
  /* ./A2601top.vhd:481:82  */
  assign n1300_o = n1284_o ? 8'b11111111 : n1299_o;
  assign n1301_o = {n1300_o, n1298_o, n1296_o, n1294_o, n1292_o, n1290_o, n1288_o, n1286_o};
  /* ./A2601top.vhd:481:91  */
  assign n1302_o = dpcbottoms[7:0];
  /* ./A2601top.vhd:481:82  */
  assign n1303_o = dpcbottoms[15:8];
  assign n1304_o = dpcbottoms[23:16];
  assign n1305_o = dpcbottoms[31:24];
  assign n1306_o = dpcbottoms[39:32];
  assign n1307_o = dpcbottoms[47:40];
  assign n1308_o = dpcbottoms[55:48];
  assign n1309_o = dpcbottoms[63:56];
  /* ./A2601top.vhd:482:119  */
  assign n1310_o = n671_o[1:0];
  /* ./A2601top.vhd:482:119  */
  always @*
    case (n1310_o)
      2'b00: n1311_o = n1302_o;
      2'b01: n1311_o = n1303_o;
      2'b10: n1311_o = n1304_o;
      2'b11: n1311_o = n1305_o;
    endcase
  /* ./A2601top.vhd:482:119  */
  assign n1312_o = n671_o[1:0];
  /* ./A2601top.vhd:482:119  */
  always @*
    case (n1312_o)
      2'b00: n1313_o = n1306_o;
      2'b01: n1313_o = n1307_o;
      2'b10: n1313_o = n1308_o;
      2'b11: n1313_o = n1309_o;
    endcase
  /* ./A2601top.vhd:482:119  */
  assign n1314_o = n671_o[2];
  /* ./A2601top.vhd:482:119  */
  assign n1315_o = n1314_o ? n1313_o : n1311_o;
  /* ./A2601top.vhd:483:82  */
  assign n1316_o = n677_o[2];
  /* ./A2601top.vhd:483:82  */
  assign n1317_o = ~n1316_o;
  /* ./A2601top.vhd:483:82  */
  assign n1318_o = n677_o[1];
  /* ./A2601top.vhd:483:82  */
  assign n1319_o = ~n1318_o;
  /* ./A2601top.vhd:483:82  */
  assign n1320_o = n1317_o & n1319_o;
  /* ./A2601top.vhd:483:82  */
  assign n1321_o = n1317_o & n1318_o;
  /* ./A2601top.vhd:483:82  */
  assign n1322_o = n1316_o & n1319_o;
  /* ./A2601top.vhd:483:82  */
  assign n1323_o = n1316_o & n1318_o;
  /* ./A2601top.vhd:483:82  */
  assign n1324_o = n677_o[0];
  /* ./A2601top.vhd:483:82  */
  assign n1325_o = ~n1324_o;
  /* ./A2601top.vhd:483:82  */
  assign n1326_o = n1320_o & n1325_o;
  /* ./A2601top.vhd:483:82  */
  assign n1327_o = n1320_o & n1324_o;
  /* ./A2601top.vhd:483:82  */
  assign n1328_o = n1321_o & n1325_o;
  /* ./A2601top.vhd:483:82  */
  assign n1329_o = n1321_o & n1324_o;
  /* ./A2601top.vhd:483:82  */
  assign n1330_o = n1322_o & n1325_o;
  /* ./A2601top.vhd:483:82  */
  assign n1331_o = n1322_o & n1324_o;
  /* ./A2601top.vhd:483:82  */
  assign n1332_o = n1323_o & n1325_o;
  /* ./A2601top.vhd:483:82  */
  assign n1333_o = n1323_o & n1324_o;
  assign n1334_o = dpcflags[7:0];
  /* ./A2601top.vhd:483:82  */
  assign n1335_o = n1326_o ? 8'b00000000 : n1334_o;
  assign n1336_o = dpcflags[15:8];
  /* ./A2601top.vhd:483:82  */
  assign n1337_o = n1327_o ? 8'b00000000 : n1336_o;
  assign n1338_o = dpcflags[23:16];
  /* ./A2601top.vhd:483:82  */
  assign n1339_o = n1328_o ? 8'b00000000 : n1338_o;
  assign n1340_o = dpcflags[31:24];
  /* ./A2601top.vhd:483:82  */
  assign n1341_o = n1329_o ? 8'b00000000 : n1340_o;
  assign n1342_o = dpcflags[39:32];
  /* ./A2601top.vhd:483:82  */
  assign n1343_o = n1330_o ? 8'b00000000 : n1342_o;
  assign n1344_o = dpcflags[47:40];
  /* ./A2601top.vhd:483:82  */
  assign n1345_o = n1331_o ? 8'b00000000 : n1344_o;
  assign n1346_o = dpcflags[55:48];
  /* ./A2601top.vhd:483:82  */
  assign n1347_o = n1332_o ? 8'b00000000 : n1346_o;
  assign n1348_o = dpcflags[63:56];
  /* ./A2601top.vhd:483:82  */
  assign n1349_o = n1333_o ? 8'b00000000 : n1348_o;
  assign n1350_o = {n1349_o, n1347_o, n1345_o, n1343_o, n1341_o, n1339_o, n1337_o, n1335_o};
  /* ./A2601top.vhd:490:89  */
  assign n1351_o = n689_o[2];
  /* ./A2601top.vhd:490:89  */
  assign n1352_o = ~n1351_o;
  /* ./A2601top.vhd:490:89  */
  assign n1353_o = n689_o[1];
  /* ./A2601top.vhd:490:89  */
  assign n1354_o = ~n1353_o;
  /* ./A2601top.vhd:490:89  */
  assign n1355_o = n1352_o & n1354_o;
  /* ./A2601top.vhd:490:89  */
  assign n1356_o = n1352_o & n1353_o;
  /* ./A2601top.vhd:490:89  */
  assign n1357_o = n1351_o & n1354_o;
  /* ./A2601top.vhd:490:89  */
  assign n1358_o = n1351_o & n1353_o;
  /* ./A2601top.vhd:490:89  */
  assign n1359_o = n689_o[0];
  /* ./A2601top.vhd:490:89  */
  assign n1360_o = ~n1359_o;
  /* ./A2601top.vhd:490:89  */
  assign n1361_o = n1355_o & n1360_o;
  /* ./A2601top.vhd:490:89  */
  assign n1362_o = n1355_o & n1359_o;
  /* ./A2601top.vhd:490:89  */
  assign n1363_o = n1356_o & n1360_o;
  /* ./A2601top.vhd:490:89  */
  assign n1364_o = n1356_o & n1359_o;
  /* ./A2601top.vhd:490:89  */
  assign n1365_o = n1357_o & n1360_o;
  /* ./A2601top.vhd:490:89  */
  assign n1366_o = n1357_o & n1359_o;
  /* ./A2601top.vhd:490:89  */
  assign n1367_o = n1358_o & n1360_o;
  /* ./A2601top.vhd:490:89  */
  assign n1368_o = n1358_o & n1359_o;
  assign n1369_o = dpctops[7:0];
  /* ./A2601top.vhd:490:89  */
  assign n1370_o = n1361_o ? cpu_d : n1369_o;
  assign n1371_o = dpctops[15:8];
  /* ./A2601top.vhd:490:89  */
  assign n1372_o = n1362_o ? cpu_d : n1371_o;
  assign n1373_o = dpctops[23:16];
  /* ./A2601top.vhd:490:89  */
  assign n1374_o = n1363_o ? cpu_d : n1373_o;
  assign n1375_o = dpctops[31:24];
  /* ./A2601top.vhd:490:89  */
  assign n1376_o = n1364_o ? cpu_d : n1375_o;
  assign n1377_o = dpctops[39:32];
  /* ./A2601top.vhd:490:89  */
  assign n1378_o = n1365_o ? cpu_d : n1377_o;
  assign n1379_o = dpctops[47:40];
  /* ./A2601top.vhd:490:89  */
  assign n1380_o = n1366_o ? cpu_d : n1379_o;
  assign n1381_o = dpctops[55:48];
  /* ./A2601top.vhd:490:89  */
  assign n1382_o = n1367_o ? cpu_d : n1381_o;
  assign n1383_o = dpctops[63:56];
  /* ./A2601top.vhd:490:89  */
  assign n1384_o = n1368_o ? cpu_d : n1383_o;
  assign n1385_o = {n1384_o, n1382_o, n1380_o, n1378_o, n1376_o, n1374_o, n1372_o, n1370_o};
  /* ./A2601top.vhd:490:97  */
  assign n1386_o = dpccounters[7:0];
  /* ./A2601top.vhd:490:89  */
  assign n1387_o = dpccounters[18:11];
  assign n1388_o = dpccounters[29:22];
  assign n1389_o = dpccounters[40:33];
  assign n1390_o = dpccounters[51:44];
  assign n1391_o = dpccounters[62:55];
  assign n1392_o = dpccounters[73:66];
  assign n1393_o = dpccounters[84:77];
  /* ./A2601top.vhd:491:71  */
  assign n1394_o = n692_o[1:0];
  /* ./A2601top.vhd:491:71  */
  always @*
    case (n1394_o)
      2'b00: n1395_o = n1386_o;
      2'b01: n1395_o = n1387_o;
      2'b10: n1395_o = n1388_o;
      2'b11: n1395_o = n1389_o;
    endcase
  /* ./A2601top.vhd:491:71  */
  assign n1396_o = n692_o[1:0];
  /* ./A2601top.vhd:491:71  */
  always @*
    case (n1396_o)
      2'b00: n1397_o = n1390_o;
      2'b01: n1397_o = n1391_o;
      2'b10: n1397_o = n1392_o;
      2'b11: n1397_o = n1393_o;
    endcase
  /* ./A2601top.vhd:491:71  */
  assign n1398_o = n692_o[2];
  /* ./A2601top.vhd:491:71  */
  assign n1399_o = n1398_o ? n1397_o : n1395_o;
  /* ./A2601top.vhd:492:49  */
  assign n1400_o = n698_o[2];
  /* ./A2601top.vhd:492:49  */
  assign n1401_o = ~n1400_o;
  /* ./A2601top.vhd:492:49  */
  assign n1402_o = n698_o[1];
  /* ./A2601top.vhd:492:49  */
  assign n1403_o = ~n1402_o;
  /* ./A2601top.vhd:492:49  */
  assign n1404_o = n1401_o & n1403_o;
  /* ./A2601top.vhd:492:49  */
  assign n1405_o = n1401_o & n1402_o;
  /* ./A2601top.vhd:492:49  */
  assign n1406_o = n1400_o & n1403_o;
  /* ./A2601top.vhd:492:49  */
  assign n1407_o = n1400_o & n1402_o;
  /* ./A2601top.vhd:492:49  */
  assign n1408_o = n698_o[0];
  /* ./A2601top.vhd:492:49  */
  assign n1409_o = ~n1408_o;
  /* ./A2601top.vhd:492:49  */
  assign n1410_o = n1404_o & n1409_o;
  /* ./A2601top.vhd:492:49  */
  assign n1411_o = n1404_o & n1408_o;
  /* ./A2601top.vhd:492:49  */
  assign n1412_o = n1405_o & n1409_o;
  /* ./A2601top.vhd:492:49  */
  assign n1413_o = n1405_o & n1408_o;
  /* ./A2601top.vhd:492:49  */
  assign n1414_o = n1406_o & n1409_o;
  /* ./A2601top.vhd:492:49  */
  assign n1415_o = n1406_o & n1408_o;
  /* ./A2601top.vhd:492:49  */
  assign n1416_o = n1407_o & n1409_o;
  /* ./A2601top.vhd:492:49  */
  assign n1417_o = n1407_o & n1408_o;
  assign n1418_o = dpcflags[7:0];
  /* ./A2601top.vhd:492:49  */
  assign n1419_o = n1410_o ? 8'b11111111 : n1418_o;
  assign n1420_o = dpcflags[15:8];
  /* ./A2601top.vhd:492:49  */
  assign n1421_o = n1411_o ? 8'b11111111 : n1420_o;
  assign n1422_o = dpcflags[23:16];
  /* ./A2601top.vhd:492:49  */
  assign n1423_o = n1412_o ? 8'b11111111 : n1422_o;
  assign n1424_o = dpcflags[31:24];
  /* ./A2601top.vhd:492:49  */
  assign n1425_o = n1413_o ? 8'b11111111 : n1424_o;
  assign n1426_o = dpcflags[39:32];
  /* ./A2601top.vhd:492:49  */
  assign n1427_o = n1414_o ? 8'b11111111 : n1426_o;
  assign n1428_o = dpcflags[47:40];
  /* ./A2601top.vhd:492:49  */
  assign n1429_o = n1415_o ? 8'b11111111 : n1428_o;
  assign n1430_o = dpcflags[55:48];
  /* ./A2601top.vhd:492:49  */
  assign n1431_o = n1416_o ? 8'b11111111 : n1430_o;
  assign n1432_o = dpcflags[63:56];
  /* ./A2601top.vhd:492:49  */
  assign n1433_o = n1417_o ? 8'b11111111 : n1432_o;
  assign n1434_o = {n1433_o, n1431_o, n1429_o, n1427_o, n1425_o, n1423_o, n1421_o, n1419_o};
  /* ./A2601top.vhd:494:97  */
  assign n1435_o = n704_o[2];
  /* ./A2601top.vhd:494:97  */
  assign n1436_o = ~n1435_o;
  /* ./A2601top.vhd:494:97  */
  assign n1437_o = n704_o[1];
  /* ./A2601top.vhd:494:97  */
  assign n1438_o = ~n1437_o;
  /* ./A2601top.vhd:494:97  */
  assign n1439_o = n1436_o & n1438_o;
  /* ./A2601top.vhd:494:97  */
  assign n1440_o = n1436_o & n1437_o;
  /* ./A2601top.vhd:494:97  */
  assign n1441_o = n1435_o & n1438_o;
  /* ./A2601top.vhd:494:97  */
  assign n1442_o = n1435_o & n1437_o;
  /* ./A2601top.vhd:494:97  */
  assign n1443_o = n704_o[0];
  /* ./A2601top.vhd:494:97  */
  assign n1444_o = ~n1443_o;
  /* ./A2601top.vhd:494:97  */
  assign n1445_o = n1439_o & n1444_o;
  /* ./A2601top.vhd:494:97  */
  assign n1446_o = n1439_o & n1443_o;
  /* ./A2601top.vhd:494:97  */
  assign n1447_o = n1440_o & n1444_o;
  /* ./A2601top.vhd:494:97  */
  assign n1448_o = n1440_o & n1443_o;
  /* ./A2601top.vhd:494:97  */
  assign n1449_o = n1441_o & n1444_o;
  /* ./A2601top.vhd:494:97  */
  assign n1450_o = n1441_o & n1443_o;
  /* ./A2601top.vhd:494:97  */
  assign n1451_o = n1442_o & n1444_o;
  /* ./A2601top.vhd:494:97  */
  assign n1452_o = n1442_o & n1443_o;
  assign n1453_o = dpcflags[7:0];
  /* ./A2601top.vhd:494:97  */
  assign n1454_o = n1445_o ? 8'b00000000 : n1453_o;
  assign n1455_o = dpcflags[15:8];
  /* ./A2601top.vhd:494:97  */
  assign n1456_o = n1446_o ? 8'b00000000 : n1455_o;
  assign n1457_o = dpcflags[23:16];
  /* ./A2601top.vhd:494:97  */
  assign n1458_o = n1447_o ? 8'b00000000 : n1457_o;
  assign n1459_o = dpcflags[31:24];
  /* ./A2601top.vhd:494:97  */
  assign n1460_o = n1448_o ? 8'b00000000 : n1459_o;
  assign n1461_o = dpcflags[39:32];
  /* ./A2601top.vhd:494:97  */
  assign n1462_o = n1449_o ? 8'b00000000 : n1461_o;
  assign n1463_o = dpcflags[47:40];
  /* ./A2601top.vhd:494:97  */
  assign n1464_o = n1450_o ? 8'b00000000 : n1463_o;
  assign n1465_o = dpcflags[55:48];
  /* ./A2601top.vhd:494:97  */
  assign n1466_o = n1451_o ? 8'b00000000 : n1465_o;
  assign n1467_o = dpcflags[63:56];
  /* ./A2601top.vhd:494:97  */
  assign n1468_o = n1452_o ? 8'b00000000 : n1467_o;
  assign n1469_o = {n1468_o, n1466_o, n1464_o, n1462_o, n1460_o, n1458_o, n1456_o, n1454_o};
  /* ./A2601top.vhd:498:89  */
  assign n1470_o = n713_o[2];
  /* ./A2601top.vhd:498:89  */
  assign n1471_o = ~n1470_o;
  /* ./A2601top.vhd:498:89  */
  assign n1472_o = n713_o[1];
  /* ./A2601top.vhd:498:89  */
  assign n1473_o = ~n1472_o;
  /* ./A2601top.vhd:498:89  */
  assign n1474_o = n1471_o & n1473_o;
  /* ./A2601top.vhd:498:89  */
  assign n1475_o = n1471_o & n1472_o;
  /* ./A2601top.vhd:498:89  */
  assign n1476_o = n1470_o & n1473_o;
  /* ./A2601top.vhd:498:89  */
  assign n1477_o = n1470_o & n1472_o;
  /* ./A2601top.vhd:498:89  */
  assign n1478_o = n713_o[0];
  /* ./A2601top.vhd:498:89  */
  assign n1479_o = ~n1478_o;
  /* ./A2601top.vhd:498:89  */
  assign n1480_o = n1474_o & n1479_o;
  /* ./A2601top.vhd:498:89  */
  assign n1481_o = n1474_o & n1478_o;
  /* ./A2601top.vhd:498:89  */
  assign n1482_o = n1475_o & n1479_o;
  /* ./A2601top.vhd:498:89  */
  assign n1483_o = n1475_o & n1478_o;
  /* ./A2601top.vhd:498:89  */
  assign n1484_o = n1476_o & n1479_o;
  /* ./A2601top.vhd:498:89  */
  assign n1485_o = n1476_o & n1478_o;
  /* ./A2601top.vhd:498:89  */
  assign n1486_o = n1477_o & n1479_o;
  /* ./A2601top.vhd:498:89  */
  assign n1487_o = n1477_o & n1478_o;
  assign n1488_o = dpcbottoms[7:0];
  /* ./A2601top.vhd:498:89  */
  assign n1489_o = n1480_o ? cpu_d : n1488_o;
  assign n1490_o = dpcbottoms[15:8];
  /* ./A2601top.vhd:498:89  */
  assign n1491_o = n1481_o ? cpu_d : n1490_o;
  assign n1492_o = dpcbottoms[23:16];
  /* ./A2601top.vhd:498:89  */
  assign n1493_o = n1482_o ? cpu_d : n1492_o;
  assign n1494_o = dpcbottoms[31:24];
  /* ./A2601top.vhd:498:89  */
  assign n1495_o = n1483_o ? cpu_d : n1494_o;
  assign n1496_o = dpcbottoms[39:32];
  /* ./A2601top.vhd:498:89  */
  assign n1497_o = n1484_o ? cpu_d : n1496_o;
  assign n1498_o = dpcbottoms[47:40];
  /* ./A2601top.vhd:498:89  */
  assign n1499_o = n1485_o ? cpu_d : n1498_o;
  assign n1500_o = dpcbottoms[55:48];
  /* ./A2601top.vhd:498:89  */
  assign n1501_o = n1486_o ? cpu_d : n1500_o;
  assign n1502_o = dpcbottoms[63:56];
  /* ./A2601top.vhd:498:89  */
  assign n1503_o = n1487_o ? cpu_d : n1502_o;
  assign n1504_o = {n1503_o, n1501_o, n1499_o, n1497_o, n1495_o, n1493_o, n1491_o, n1489_o};
  /* ./A2601top.vhd:501:89  */
  assign n1505_o = n718_o[2];
  /* ./A2601top.vhd:501:89  */
  assign n1506_o = ~n1505_o;
  /* ./A2601top.vhd:501:89  */
  assign n1507_o = n718_o[1];
  /* ./A2601top.vhd:501:89  */
  assign n1508_o = ~n1507_o;
  /* ./A2601top.vhd:501:89  */
  assign n1509_o = n1506_o & n1508_o;
  /* ./A2601top.vhd:501:89  */
  assign n1510_o = n1506_o & n1507_o;
  /* ./A2601top.vhd:501:89  */
  assign n1511_o = n1505_o & n1508_o;
  /* ./A2601top.vhd:501:89  */
  assign n1512_o = n1505_o & n1507_o;
  /* ./A2601top.vhd:501:89  */
  assign n1513_o = n718_o[0];
  /* ./A2601top.vhd:501:89  */
  assign n1514_o = ~n1513_o;
  /* ./A2601top.vhd:501:89  */
  assign n1515_o = n1509_o & n1514_o;
  /* ./A2601top.vhd:501:89  */
  assign n1516_o = n1509_o & n1513_o;
  /* ./A2601top.vhd:501:89  */
  assign n1517_o = n1510_o & n1514_o;
  /* ./A2601top.vhd:501:89  */
  assign n1518_o = n1510_o & n1513_o;
  /* ./A2601top.vhd:501:89  */
  assign n1519_o = n1511_o & n1514_o;
  /* ./A2601top.vhd:501:89  */
  assign n1520_o = n1511_o & n1513_o;
  /* ./A2601top.vhd:501:89  */
  assign n1521_o = n1512_o & n1514_o;
  /* ./A2601top.vhd:501:89  */
  assign n1522_o = n1512_o & n1513_o;
  assign n1523_o = dpccounters[7:0];
  /* ./A2601top.vhd:501:89  */
  assign n1524_o = n1515_o ? cpu_d : n1523_o;
  assign n1525_o = dpccounters[10:8];
  assign n1526_o = dpccounters[18:11];
  /* ./A2601top.vhd:501:89  */
  assign n1527_o = n1516_o ? cpu_d : n1526_o;
  assign n1528_o = dpccounters[21:19];
  assign n1529_o = dpccounters[29:22];
  /* ./A2601top.vhd:501:89  */
  assign n1530_o = n1517_o ? cpu_d : n1529_o;
  assign n1531_o = dpccounters[32:30];
  assign n1532_o = dpccounters[40:33];
  /* ./A2601top.vhd:501:89  */
  assign n1533_o = n1518_o ? cpu_d : n1532_o;
  assign n1534_o = dpccounters[43:41];
  assign n1535_o = dpccounters[51:44];
  /* ./A2601top.vhd:501:89  */
  assign n1536_o = n1519_o ? cpu_d : n1535_o;
  assign n1537_o = dpccounters[54:52];
  assign n1538_o = dpccounters[62:55];
  /* ./A2601top.vhd:501:89  */
  assign n1539_o = n1520_o ? cpu_d : n1538_o;
  assign n1540_o = dpccounters[65:63];
  assign n1541_o = dpccounters[73:66];
  /* ./A2601top.vhd:501:89  */
  assign n1542_o = n1521_o ? cpu_d : n1541_o;
  assign n1543_o = dpccounters[76:74];
  assign n1544_o = dpccounters[84:77];
  /* ./A2601top.vhd:501:89  */
  assign n1545_o = n1522_o ? cpu_d : n1544_o;
  assign n1546_o = dpccounters[87:85];
  assign n1547_o = {n1546_o, n1545_o, n1543_o, n1542_o, n1540_o, n1539_o, n1537_o, n1536_o, n1534_o, n1533_o, n1531_o, n1530_o, n1528_o, n1527_o, n1525_o, n1524_o};
  /* ./A2601top.vhd:504:89  */
  assign n1548_o = n723_o[2];
  /* ./A2601top.vhd:504:89  */
  assign n1549_o = ~n1548_o;
  /* ./A2601top.vhd:504:89  */
  assign n1550_o = n723_o[1];
  /* ./A2601top.vhd:504:89  */
  assign n1551_o = ~n1550_o;
  /* ./A2601top.vhd:504:89  */
  assign n1552_o = n1549_o & n1551_o;
  /* ./A2601top.vhd:504:89  */
  assign n1553_o = n1549_o & n1550_o;
  /* ./A2601top.vhd:504:89  */
  assign n1554_o = n1548_o & n1551_o;
  /* ./A2601top.vhd:504:89  */
  assign n1555_o = n1548_o & n1550_o;
  /* ./A2601top.vhd:504:89  */
  assign n1556_o = n723_o[0];
  /* ./A2601top.vhd:504:89  */
  assign n1557_o = ~n1556_o;
  /* ./A2601top.vhd:504:89  */
  assign n1558_o = n1552_o & n1557_o;
  /* ./A2601top.vhd:504:89  */
  assign n1559_o = n1552_o & n1556_o;
  /* ./A2601top.vhd:504:89  */
  assign n1560_o = n1553_o & n1557_o;
  /* ./A2601top.vhd:504:89  */
  assign n1561_o = n1553_o & n1556_o;
  /* ./A2601top.vhd:504:89  */
  assign n1562_o = n1554_o & n1557_o;
  /* ./A2601top.vhd:504:89  */
  assign n1563_o = n1554_o & n1556_o;
  /* ./A2601top.vhd:504:89  */
  assign n1564_o = n1555_o & n1557_o;
  /* ./A2601top.vhd:504:89  */
  assign n1565_o = n1555_o & n1556_o;
  assign n1566_o = dpccounters[7:0];
  assign n1567_o = dpccounters[10:8];
  /* ./A2601top.vhd:504:89  */
  assign n1568_o = n1558_o ? n725_o : n1567_o;
  assign n1569_o = dpccounters[18:11];
  assign n1570_o = dpccounters[21:19];
  /* ./A2601top.vhd:504:89  */
  assign n1571_o = n1559_o ? n725_o : n1570_o;
  assign n1572_o = dpccounters[29:22];
  assign n1573_o = dpccounters[32:30];
  /* ./A2601top.vhd:504:89  */
  assign n1574_o = n1560_o ? n725_o : n1573_o;
  assign n1575_o = dpccounters[40:33];
  assign n1576_o = dpccounters[43:41];
  /* ./A2601top.vhd:504:89  */
  assign n1577_o = n1561_o ? n725_o : n1576_o;
  assign n1578_o = dpccounters[51:44];
  assign n1579_o = dpccounters[54:52];
  /* ./A2601top.vhd:504:89  */
  assign n1580_o = n1562_o ? n725_o : n1579_o;
  assign n1581_o = dpccounters[62:55];
  assign n1582_o = dpccounters[65:63];
  /* ./A2601top.vhd:504:89  */
  assign n1583_o = n1563_o ? n725_o : n1582_o;
  assign n1584_o = dpccounters[73:66];
  assign n1585_o = dpccounters[76:74];
  /* ./A2601top.vhd:504:89  */
  assign n1586_o = n1564_o ? n725_o : n1585_o;
  assign n1587_o = dpccounters[84:77];
  assign n1588_o = dpccounters[87:85];
  /* ./A2601top.vhd:504:89  */
  assign n1589_o = n1565_o ? n725_o : n1588_o;
  assign n1590_o = {n1589_o, n1587_o, n1586_o, n1584_o, n1583_o, n1581_o, n1580_o, n1578_o, n1577_o, n1575_o, n1574_o, n1572_o, n1571_o, n1569_o, n1568_o, n1566_o};
  /* ./A2601top.vhd:506:97  */
  assign n1591_o = n731_o[1];
  /* ./A2601top.vhd:506:97  */
  assign n1592_o = ~n1591_o;
  /* ./A2601top.vhd:506:97  */
  assign n1593_o = n731_o[0];
  /* ./A2601top.vhd:506:97  */
  assign n1594_o = ~n1593_o;
  /* ./A2601top.vhd:506:97  */
  assign n1595_o = n1592_o & n1594_o;
  /* ./A2601top.vhd:506:97  */
  assign n1596_o = n1592_o & n1593_o;
  /* ./A2601top.vhd:506:97  */
  assign n1597_o = n1591_o & n1594_o;
  assign n1598_o = dpcmusicmodes[7:0];
  /* ./A2601top.vhd:506:97  */
  assign n1599_o = n1595_o ? n737_o : n1598_o;
  assign n1600_o = dpcmusicmodes[15:8];
  /* ./A2601top.vhd:506:97  */
  assign n1601_o = n1596_o ? n737_o : n1600_o;
  assign n1602_o = dpcmusicmodes[23:16];
  /* ./A2601top.vhd:506:97  */
  assign n1603_o = n1597_o ? n737_o : n1602_o;
  assign n1604_o = {n1603_o, n1601_o, n1599_o};
endmodule

