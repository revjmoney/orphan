// [orphan] Orphan Games: the Sega Master System / Game Gear core for the S9 control board FPGA.
// This file is MACHINE-GENERATED Verilog: GHDL 4.1 synthesized it from the VHDL of the MiSTer SMS core
// (https://github.com/MiSTer-devel/SMS_MiSTer, GPL-2.0-or-later; patched copies in games/sms_vhdl,
// converter games/ghdl_convert.sh). Its licence follows the VHDL it was made from. See LICENSES.md here.
// GHDL escaped names (a backslash name such as u0 reg) were renamed for Yosys (*_esc). by JMSCNC, makers of RotatoCAM (the glue).
//
// The SMS VDP from the MiSTer SMS core (GPL-2.0-or-later).

module vpd_sprite_shifter
  (input  clk_sys,
   input  ce_pix,
   input  [7:0] x,
   input  [7:0] spr_x,
   input  load,
   input  x248,
   input  x224,
   input  m4,
   input  wide_n,
   input  [7:0] spr_d0,
   input  [7:0] spr_d1,
   input  [7:0] spr_d2,
   input  [7:0] spr_d3,
   input  ss_regs_set,
   output [3:0] color,
   output active);
  reg wideclock;
  reg [7:0] shift0;
  reg [7:0] shift1;
  reg [7:0] shift2;
  reg [7:0] shift3;
  wire n4175_o;
  wire n4176_o;
  wire n4177_o;
  wire n4178_o;
  wire n4179_o;
  wire n4180_o;
  wire n4181_o;
  wire n4182_o;
  wire n4183_o;
  wire [7:0] n4185_o;
  wire n4186_o;
  wire n4187_o;
  wire n4189_o;
  wire n4190_o;
  wire n4191_o;
  wire n4192_o;
  wire [6:0] n4193_o;
  wire [6:0] n4195_o;
  wire [7:0] n4197_o;
  wire n4198_o;
  wire n4199_o;
  wire [7:0] n4200_o;
  wire [6:0] n4201_o;
  wire [7:0] n4203_o;
  wire [6:0] n4204_o;
  wire [7:0] n4206_o;
  wire [7:0] n4207_o;
  wire [7:0] n4208_o;
  wire [7:0] n4209_o;
  wire [7:0] n4210_o;
  wire n4211_o;
  wire n4212_o;
  wire n4214_o;
  wire [7:0] n4215_o;
  wire [7:0] n4216_o;
  wire [7:0] n4217_o;
  wire [7:0] n4218_o;
  wire n4219_o;
  wire [7:0] n4220_o;
  wire [7:0] n4221_o;
  wire [7:0] n4222_o;
  wire [7:0] n4223_o;
  wire n4225_o;
  wire [7:0] n4227_o;
  wire [7:0] n4229_o;
  wire [7:0] n4231_o;
  wire [7:0] n4233_o;
  wire n4242_o;
  wire n4243_o;
  wire [1:0] n4244_o;
  wire n4245_o;
  wire [2:0] n4246_o;
  wire n4247_o;
  wire [3:0] n4248_o;
  wire n4249_o;
  wire n4250_o;
  wire n4251_o;
  wire n4252_o;
  wire n4253_o;
  wire n4254_o;
  wire n4255_o;
  wire n4256_o;
  wire [3:0] n4257_o;
  wire [3:0] n4259_o;
  wire n4260_o;
  wire [3:0] n4261_o;
  wire n4262_o;
  reg n4264_q;
  reg [7:0] n4265_q;
  reg [7:0] n4266_q;
  reg [7:0] n4267_q;
  reg [7:0] n4268_q;
  assign color = n4261_o;
  assign active = n4262_o;
  /* ./vdp_sprite_shifter.vhd:28:11  */
  always @*
    wideclock = n4264_q; // (isignal)
  initial
    wideclock = 1'b0;
  /* ./vdp_sprite_shifter.vhd:29:16  */
  always @*
    shift0 = n4265_q; // (isignal)
  initial
    shift0 = 8'b00000000;
  /* ./vdp_sprite_shifter.vhd:30:16  */
  always @*
    shift1 = n4266_q; // (isignal)
  initial
    shift1 = 8'b00000000;
  /* ./vdp_sprite_shifter.vhd:31:16  */
  always @*
    shift2 = n4267_q; // (isignal)
  initial
    shift2 = 8'b00000000;
  /* ./vdp_sprite_shifter.vhd:32:16  */
  always @*
    shift3 = n4268_q; // (isignal)
  initial
    shift3 = 8'b00000000;
  /* ./vdp_sprite_shifter.vhd:49:42  */
  assign n4175_o = spr_x == x;
  /* ./vdp_sprite_shifter.vhd:49:73  */
  assign n4176_o = spr_d3[7];
  /* ./vdp_sprite_shifter.vhd:49:76  */
  assign n4177_o = ~n4176_o;
  /* ./vdp_sprite_shifter.vhd:49:64  */
  assign n4178_o = m4 | n4177_o;
  /* ./vdp_sprite_shifter.vhd:49:56  */
  assign n4179_o = n4178_o & load;
  /* ./vdp_sprite_shifter.vhd:50:90  */
  assign n4180_o = spr_d3[7];
  /* ./vdp_sprite_shifter.vhd:50:80  */
  assign n4181_o = n4180_o & x224;
  /* ./vdp_sprite_shifter.vhd:49:83  */
  assign n4182_o = n4179_o | n4181_o;
  /* ./vdp_sprite_shifter.vhd:49:45  */
  assign n4183_o = n4182_o & n4175_o;
  /* ./vdp_sprite_shifter.vhd:51:50  */
  assign n4185_o = x + 8'b00001000;
  /* ./vdp_sprite_shifter.vhd:51:48  */
  assign n4186_o = spr_x == n4185_o;
  /* ./vdp_sprite_shifter.vhd:51:53  */
  assign n4187_o = x248 & n4186_o;
  /* ./vdp_sprite_shifter.vhd:51:72  */
  assign n4189_o = spr_x != 8'b11111111;
  /* ./vdp_sprite_shifter.vhd:51:63  */
  assign n4190_o = n4189_o & n4187_o;
  /* ./vdp_sprite_shifter.vhd:50:101  */
  assign n4191_o = n4183_o | n4190_o;
  /* ./vdp_sprite_shifter.vhd:58:52  */
  assign n4192_o = wide_n | wideclock;
  /* ./vdp_sprite_shifter.vhd:59:77  */
  assign n4193_o = shift0[6:0];
  /* ./vdp_sprite_shifter.vhd:62:73  */
  assign n4195_o = shift3[6:0];
  /* ./vdp_sprite_shifter.vhd:62:85  */
  assign n4197_o = {n4195_o, 1'b0};
  /* ./vdp_sprite_shifter.vhd:64:76  */
  assign n4198_o = shift1[7];
  /* ./vdp_sprite_shifter.vhd:60:49  */
  assign n4199_o = m4 ? 1'b0 : n4198_o;
  /* ./vdp_sprite_shifter.vhd:58:41  */
  assign n4200_o = n4211_o ? n4197_o : shift3;
  /* ./vdp_sprite_shifter.vhd:66:65  */
  assign n4201_o = shift1[6:0];
  /* ./vdp_sprite_shifter.vhd:66:77  */
  assign n4203_o = {n4201_o, 1'b0};
  /* ./vdp_sprite_shifter.vhd:67:65  */
  assign n4204_o = shift2[6:0];
  /* ./vdp_sprite_shifter.vhd:67:77  */
  assign n4206_o = {n4204_o, 1'b0};
  assign n4207_o = {n4193_o, n4199_o};
  /* ./vdp_sprite_shifter.vhd:58:41  */
  assign n4208_o = n4192_o ? n4207_o : shift0;
  /* ./vdp_sprite_shifter.vhd:58:41  */
  assign n4209_o = n4192_o ? n4203_o : shift1;
  /* ./vdp_sprite_shifter.vhd:58:41  */
  assign n4210_o = n4192_o ? n4206_o : shift2;
  /* ./vdp_sprite_shifter.vhd:58:41  */
  assign n4211_o = m4 & n4192_o;
  /* ./vdp_sprite_shifter.vhd:69:54  */
  assign n4212_o = ~wideclock;
  /* ./vdp_sprite_shifter.vhd:49:33  */
  assign n4214_o = n4191_o ? 1'b0 : n4212_o;
  /* ./vdp_sprite_shifter.vhd:49:33  */
  assign n4215_o = n4191_o ? spr_d0 : n4208_o;
  /* ./vdp_sprite_shifter.vhd:49:33  */
  assign n4216_o = n4191_o ? spr_d1 : n4209_o;
  /* ./vdp_sprite_shifter.vhd:49:33  */
  assign n4217_o = n4191_o ? spr_d2 : n4210_o;
  /* ./vdp_sprite_shifter.vhd:49:33  */
  assign n4218_o = n4191_o ? spr_d3 : n4200_o;
  /* ./vdp_sprite_shifter.vhd:44:25  */
  assign n4219_o = ce_pix ? n4214_o : wideclock;
  /* ./vdp_sprite_shifter.vhd:44:25  */
  assign n4220_o = ce_pix ? n4215_o : shift0;
  /* ./vdp_sprite_shifter.vhd:44:25  */
  assign n4221_o = ce_pix ? n4216_o : shift1;
  /* ./vdp_sprite_shifter.vhd:44:25  */
  assign n4222_o = ce_pix ? n4217_o : shift2;
  /* ./vdp_sprite_shifter.vhd:44:25  */
  assign n4223_o = ce_pix ? n4218_o : shift3;
  /* ./vdp_sprite_shifter.vhd:38:25  */
  assign n4225_o = ss_regs_set ? 1'b0 : n4219_o;
  /* ./vdp_sprite_shifter.vhd:38:25  */
  assign n4227_o = ss_regs_set ? 8'b00000000 : n4220_o;
  /* ./vdp_sprite_shifter.vhd:38:25  */
  assign n4229_o = ss_regs_set ? 8'b00000000 : n4221_o;
  /* ./vdp_sprite_shifter.vhd:38:25  */
  assign n4231_o = ss_regs_set ? 8'b00000000 : n4222_o;
  /* ./vdp_sprite_shifter.vhd:38:25  */
  assign n4233_o = ss_regs_set ? 8'b00000000 : n4223_o;
  /* ./vdp_sprite_shifter.vhd:77:40  */
  assign n4242_o = shift3[7];
  /* ./vdp_sprite_shifter.vhd:77:50  */
  assign n4243_o = shift2[7];
  /* ./vdp_sprite_shifter.vhd:77:43  */
  assign n4244_o = {n4242_o, n4243_o};
  /* ./vdp_sprite_shifter.vhd:77:60  */
  assign n4245_o = shift1[7];
  /* ./vdp_sprite_shifter.vhd:77:53  */
  assign n4246_o = {n4244_o, n4245_o};
  /* ./vdp_sprite_shifter.vhd:77:70  */
  assign n4247_o = shift0[7];
  /* ./vdp_sprite_shifter.vhd:77:63  */
  assign n4248_o = {n4246_o, n4247_o};
  /* ./vdp_sprite_shifter.vhd:78:41  */
  assign n4249_o = shift3[7];
  /* ./vdp_sprite_shifter.vhd:78:54  */
  assign n4250_o = shift2[7];
  /* ./vdp_sprite_shifter.vhd:78:45  */
  assign n4251_o = n4249_o | n4250_o;
  /* ./vdp_sprite_shifter.vhd:78:67  */
  assign n4252_o = shift1[7];
  /* ./vdp_sprite_shifter.vhd:78:58  */
  assign n4253_o = n4251_o | n4252_o;
  /* ./vdp_sprite_shifter.vhd:78:80  */
  assign n4254_o = shift0[7];
  /* ./vdp_sprite_shifter.vhd:78:71  */
  assign n4255_o = n4253_o | n4254_o;
  /* ./vdp_sprite_shifter.vhd:80:34  */
  assign n4256_o = shift0[7];
  /* ./vdp_sprite_shifter.vhd:81:48  */
  assign n4257_o = shift3[3:0];
  /* ./vdp_sprite_shifter.vhd:80:25  */
  assign n4259_o = n4256_o ? n4257_o : 4'b0000;
  /* ./vdp_sprite_shifter.vhd:85:41  */
  assign n4260_o = shift0[7];
  /* ./vdp_sprite_shifter.vhd:76:17  */
  assign n4261_o = m4 ? n4248_o : n4259_o;
  /* ./vdp_sprite_shifter.vhd:76:17  */
  assign n4262_o = m4 ? n4255_o : n4260_o;
  /* ./vdp_sprite_shifter.vhd:37:17  */
  always @(posedge clk_sys)
    n4264_q <= n4225_o;
  initial
    n4264_q = 1'b0;
  /* ./vdp_sprite_shifter.vhd:37:17  */
  always @(posedge clk_sys)
    n4265_q <= n4227_o;
  initial
    n4265_q = 8'b00000000;
  /* ./vdp_sprite_shifter.vhd:37:17  */
  always @(posedge clk_sys)
    n4266_q <= n4229_o;
  initial
    n4266_q = 8'b00000000;
  /* ./vdp_sprite_shifter.vhd:37:17  */
  always @(posedge clk_sys)
    n4267_q <= n4231_o;
  initial
    n4267_q = 8'b00000000;
  /* ./vdp_sprite_shifter.vhd:37:17  */
  always @(posedge clk_sys)
    n4268_q <= n4233_o;
  initial
    n4268_q = 8'b00000000;
endmodule

module vdp_sprites_7
  (input  clk_sys,
   input  ce_vdp,
   input  ce_pix,
   input  ce_sp,
   input  sp64,
   input  [6:0] table_address,
   input  [2:0] char_high_bits,
   input  tall,
   input  wide,
   input  shift,
   input  smode_m1,
   input  smode_m3,
   input  smode_m4,
   input  [7:0] vram_d,
   input  [8:0] x,
   input  [8:0] y,
   input  ss_regs_set,
   output [13:0] vram_a,
   output collide,
   output overflow,
   output [3:0] color);
  reg [2:0] state;
  wire [6:0] count;
  wire [5:0] index;
  wire [13:0] data_address;
  wire ce_spload;
  wire [7:0] m2_flags;
  wire [7:0] enable;
  wire [63:0] spr_x;
  wire [63:0] spr_d0;
  wire [63:0] spr_d1;
  wire [63:0] spr_d2;
  wire [63:0] spr_d3;
  wire [31:0] spr_color;
  wire [7:0] spr_active;
  wire [3:0] shifters_n1_shifter_color;
  wire shifters_n1_shifter_active;
  wire [7:0] n2681_o;
  wire [7:0] n2682_o;
  wire n2683_o;
  wire n2685_o;
  wire n2687_o;
  wire n2688_o;
  wire n2689_o;
  wire n2690_o;
  wire n2692_o;
  wire n2693_o;
  wire n2694_o;
  wire n2695_o;
  wire n2697_o;
  wire n2699_o;
  wire n2700_o;
  wire n2701_o;
  wire n2702_o;
  wire n2703_o;
  wire n2705_o;
  wire n2707_o;
  wire n2708_o;
  wire n2709_o;
  wire n2710_o;
  wire [7:0] n2711_o;
  wire [7:0] n2712_o;
  wire [7:0] n2713_o;
  wire [7:0] n2714_o;
  wire [3:0] shifters_n2_shifter_color;
  wire shifters_n2_shifter_active;
  wire [7:0] n2717_o;
  wire [7:0] n2718_o;
  wire n2719_o;
  wire n2721_o;
  wire n2723_o;
  wire n2724_o;
  wire n2725_o;
  wire n2726_o;
  wire n2728_o;
  wire n2729_o;
  wire n2730_o;
  wire n2731_o;
  wire n2733_o;
  wire n2735_o;
  wire n2736_o;
  wire n2737_o;
  wire n2738_o;
  wire n2739_o;
  wire n2741_o;
  wire n2743_o;
  wire n2744_o;
  wire n2745_o;
  wire n2746_o;
  wire [7:0] n2747_o;
  wire [7:0] n2748_o;
  wire [7:0] n2749_o;
  wire [7:0] n2750_o;
  wire [3:0] shifters_n3_shifter_color;
  wire shifters_n3_shifter_active;
  wire [7:0] n2753_o;
  wire [7:0] n2754_o;
  wire n2755_o;
  wire n2757_o;
  wire n2759_o;
  wire n2760_o;
  wire n2761_o;
  wire n2762_o;
  wire n2764_o;
  wire n2765_o;
  wire n2766_o;
  wire n2767_o;
  wire n2769_o;
  wire n2771_o;
  wire n2772_o;
  wire n2773_o;
  wire n2774_o;
  wire n2775_o;
  wire n2777_o;
  wire n2779_o;
  wire n2780_o;
  wire n2781_o;
  wire n2782_o;
  wire [7:0] n2783_o;
  wire [7:0] n2784_o;
  wire [7:0] n2785_o;
  wire [7:0] n2786_o;
  wire [3:0] shifters_n4_shifter_color;
  wire shifters_n4_shifter_active;
  wire [7:0] n2789_o;
  wire [7:0] n2790_o;
  wire n2791_o;
  wire n2793_o;
  wire n2795_o;
  wire n2796_o;
  wire n2797_o;
  wire n2798_o;
  wire n2800_o;
  wire n2801_o;
  wire n2802_o;
  wire n2803_o;
  wire n2805_o;
  wire n2807_o;
  wire n2808_o;
  wire n2809_o;
  wire n2810_o;
  wire n2811_o;
  wire n2813_o;
  wire n2815_o;
  wire n2816_o;
  wire n2817_o;
  wire n2818_o;
  wire [7:0] n2819_o;
  wire [7:0] n2820_o;
  wire [7:0] n2821_o;
  wire [7:0] n2822_o;
  wire [3:0] shifters_n5_shifter_color;
  wire shifters_n5_shifter_active;
  wire [7:0] n2825_o;
  wire [7:0] n2826_o;
  wire n2827_o;
  wire n2829_o;
  wire n2831_o;
  wire n2832_o;
  wire n2833_o;
  wire n2834_o;
  wire n2836_o;
  wire n2837_o;
  wire n2838_o;
  wire n2839_o;
  wire n2841_o;
  wire n2843_o;
  wire n2844_o;
  wire n2845_o;
  wire n2846_o;
  wire n2847_o;
  wire n2849_o;
  wire n2851_o;
  wire n2852_o;
  wire n2853_o;
  wire n2854_o;
  wire [7:0] n2855_o;
  wire [7:0] n2856_o;
  wire [7:0] n2857_o;
  wire [7:0] n2858_o;
  wire [3:0] shifters_n6_shifter_color;
  wire shifters_n6_shifter_active;
  wire [7:0] n2861_o;
  wire [7:0] n2862_o;
  wire n2863_o;
  wire n2865_o;
  wire n2867_o;
  wire n2868_o;
  wire n2869_o;
  wire n2870_o;
  wire n2872_o;
  wire n2873_o;
  wire n2874_o;
  wire n2875_o;
  wire n2877_o;
  wire n2879_o;
  wire n2880_o;
  wire n2881_o;
  wire n2882_o;
  wire n2883_o;
  wire n2885_o;
  wire n2887_o;
  wire n2888_o;
  wire n2889_o;
  wire n2890_o;
  wire [7:0] n2891_o;
  wire [7:0] n2892_o;
  wire [7:0] n2893_o;
  wire [7:0] n2894_o;
  wire [3:0] shifters_n7_shifter_color;
  wire shifters_n7_shifter_active;
  wire [7:0] n2897_o;
  wire [7:0] n2898_o;
  wire n2899_o;
  wire n2901_o;
  wire n2903_o;
  wire n2904_o;
  wire n2905_o;
  wire n2906_o;
  wire n2908_o;
  wire n2909_o;
  wire n2910_o;
  wire n2911_o;
  wire n2913_o;
  wire n2915_o;
  wire n2916_o;
  wire n2917_o;
  wire n2918_o;
  wire n2919_o;
  wire n2921_o;
  wire n2923_o;
  wire n2924_o;
  wire n2925_o;
  wire n2926_o;
  wire [7:0] n2927_o;
  wire [7:0] n2928_o;
  wire [7:0] n2929_o;
  wire [7:0] n2930_o;
  wire [3:0] shifters_n8_shifter_color;
  wire shifters_n8_shifter_active;
  wire [7:0] n2933_o;
  wire [7:0] n2934_o;
  wire n2935_o;
  wire n2937_o;
  wire n2939_o;
  wire n2940_o;
  wire n2941_o;
  wire n2942_o;
  wire n2944_o;
  wire n2945_o;
  wire n2946_o;
  wire n2947_o;
  wire n2949_o;
  wire n2951_o;
  wire n2952_o;
  wire n2953_o;
  wire n2954_o;
  wire n2955_o;
  wire n2957_o;
  wire n2959_o;
  wire n2960_o;
  wire n2961_o;
  wire n2962_o;
  wire [7:0] n2963_o;
  wire [7:0] n2964_o;
  wire [7:0] n2965_o;
  wire [7:0] n2966_o;
  wire n2971_o;
  wire n2973_o;
  wire [4:0] n2974_o;
  wire [11:0] n2975_o;
  wire [13:0] n2977_o;
  wire n2979_o;
  wire [4:0] n2980_o;
  wire [11:0] n2981_o;
  wire [13:0] n2983_o;
  wire n2985_o;
  wire [4:0] n2986_o;
  wire [11:0] n2987_o;
  wire [13:0] n2989_o;
  wire n2991_o;
  wire [4:0] n2992_o;
  wire [11:0] n2993_o;
  wire [13:0] n2995_o;
  wire n2997_o;
  wire n2999_o;
  wire [13:0] n3001_o;
  wire [13:0] n3002_o;
  wire [13:0] n3003_o;
  wire [13:0] n3004_o;
  wire [13:0] n3005_o;
  wire [13:0] n3006_o;
  wire n3008_o;
  wire [5:0] n3009_o;
  wire [7:0] n3011_o;
  wire [13:0] n3012_o;
  wire n3014_o;
  wire [5:0] n3015_o;
  wire [6:0] n3017_o;
  wire [12:0] n3018_o;
  wire [13:0] n3020_o;
  wire n3022_o;
  wire [5:0] n3023_o;
  wire [6:0] n3025_o;
  wire [12:0] n3026_o;
  wire [13:0] n3028_o;
  wire n3030_o;
  wire [11:0] n3031_o;
  wire [13:0] n3033_o;
  wire n3035_o;
  wire [11:0] n3036_o;
  wire [13:0] n3038_o;
  wire n3040_o;
  wire [11:0] n3041_o;
  wire [13:0] n3043_o;
  wire n3045_o;
  wire [11:0] n3046_o;
  wire [13:0] n3048_o;
  wire [13:0] n3050_o;
  wire [13:0] n3051_o;
  wire [13:0] n3052_o;
  wire [13:0] n3053_o;
  wire [13:0] n3054_o;
  wire [13:0] n3055_o;
  wire [13:0] n3056_o;
  wire [13:0] n3058_o;
  wire [13:0] n3059_o;
  wire n3063_o;
  wire n3111_o;
  wire n3113_o;
  wire [8:0] n3115_o;
  wire n3117_o;
  wire [8:0] n3119_o;
  wire [8:0] n3120_o;
  wire [8:0] n3121_o;
  wire [3:0] n3122_o;
  wire n3124_o;
  wire n3125_o;
  wire n3126_o;
  wire n3127_o;
  wire n3128_o;
  wire [3:0] n3129_o;
  wire n3131_o;
  wire n3132_o;
  wire n3133_o;
  wire n3134_o;
  wire n3135_o;
  wire n3136_o;
  wire n3137_o;
  wire n3138_o;
  wire n3139_o;
  wire n3140_o;
  wire n3141_o;
  wire [3:0] n3142_o;
  wire [3:0] n3143_o;
  wire [3:0] n3144_o;
  wire [31:0] n3145_o;
  wire n3147_o;
  wire n3149_o;
  wire n3151_o;
  wire n3152_o;
  wire n3153_o;
  wire n3155_o;
  wire n3156_o;
  wire n3157_o;
  wire n3158_o;
  wire n3160_o;
  wire [31:0] n3161_o;
  wire n3163_o;
  wire [31:0] n3164_o;
  wire n3166_o;
  wire n3167_o;
  wire n3168_o;
  wire [2:0] n3171_o;
  wire n3173_o;
  wire [5:0] n3175_o;
  wire [2:0] n3177_o;
  wire [5:0] n3178_o;
  wire n3179_o;
  wire [2:0] n3180_o;
  wire [5:0] n3181_o;
  wire [3:0] n3182_o;
  wire [3:0] n3183_o;
  wire n3184_o;
  wire [2:0] n3186_o;
  wire [5:0] n3187_o;
  wire [3:0] n3188_o;
  wire [3:0] n3189_o;
  wire n3191_o;
  wire n3192_o;
  wire [6:0] n3193_o;
  wire n3194_o;
  wire n3195_o;
  wire n3196_o;
  wire n3197_o;
  wire n3199_o;
  wire [2:0] n3200_o;
  wire [2:0] n3202_o;
  wire [7:0] n3205_o;
  wire n3208_o;
  wire [2:0] n3209_o;
  wire [2:0] n3211_o;
  wire n3215_o;
  wire [2:0] n3216_o;
  wire [2:0] n3218_o;
  wire n3222_o;
  wire [2:0] n3223_o;
  wire [2:0] n3225_o;
  wire n3229_o;
  wire [2:0] n3230_o;
  wire [2:0] n3232_o;
  wire [2:0] n3235_o;
  wire [2:0] n3237_o;
  wire [5:0] n3242_o;
  wire [31:0] n3243_o;
  wire [31:0] n3245_o;
  wire [6:0] n3246_o;
  wire n3248_o;
  wire n3250_o;
  wire [3:0] n3251_o;
  wire n3253_o;
  wire n3254_o;
  wire n3255_o;
  wire n3256_o;
  wire n3257_o;
  wire n3258_o;
  wire n3259_o;
  wire n3260_o;
  wire n3261_o;
  wire n3262_o;
  wire n3263_o;
  wire [3:0] n3264_o;
  wire [3:0] n3265_o;
  wire [3:0] n3266_o;
  wire [31:0] n3267_o;
  wire n3269_o;
  wire [31:0] n3270_o;
  wire n3272_o;
  wire n3273_o;
  wire n3274_o;
  wire [2:0] n3277_o;
  wire n3279_o;
  wire [5:0] n3281_o;
  wire [2:0] n3283_o;
  wire [5:0] n3284_o;
  wire [2:0] n3285_o;
  wire [5:0] n3286_o;
  wire [3:0] n3287_o;
  wire [3:0] n3288_o;
  wire [2:0] n3289_o;
  wire [2:0] n3290_o;
  wire [2:0] n3292_o;
  wire [5:0] n3293_o;
  wire [3:0] n3294_o;
  wire [3:0] n3295_o;
  wire [2:0] n3296_o;
  wire [2:0] n3297_o;
  wire n3299_o;
  wire [6:0] n3300_o;
  wire n3301_o;
  wire n3302_o;
  wire n3303_o;
  wire [6:0] n3304_o;
  wire [6:0] n3305_o;
  wire n3307_o;
  wire n3309_o;
  wire n3310_o;
  wire n3311_o;
  wire [2:0] n3312_o;
  wire [2:0] n3314_o;
  wire [7:0] n3317_o;
  wire [2:0] n3319_o;
  wire [2:0] n3321_o;
  wire [7:0] n3324_o;
  wire [63:0] n3326_o;
  wire n3328_o;
  wire [2:0] n3329_o;
  wire [2:0] n3331_o;
  wire [2:0] n3334_o;
  wire [2:0] n3336_o;
  wire [2:0] n3340_o;
  wire [2:0] n3342_o;
  wire [2:0] n3346_o;
  wire [2:0] n3348_o;
  wire [6:0] n3351_o;
  wire [6:0] n3353_o;
  wire n3355_o;
  wire [2:0] n3356_o;
  wire [2:0] n3358_o;
  wire [63:0] n3361_o;
  wire [2:0] n3362_o;
  wire [2:0] n3364_o;
  wire [5:0] n3369_o;
  wire [31:0] n3370_o;
  wire [31:0] n3372_o;
  wire [6:0] n3373_o;
  wire n3375_o;
  wire [12:0] n3376_o;
  reg n3377_o;
  reg [2:0] n3389_o;
  reg [6:0] n3390_o;
  reg [5:0] n3391_o;
  wire [1:0] n3392_o;
  wire [1:0] n3393_o;
  reg [1:0] n3394_o;
  wire n3395_o;
  wire n3396_o;
  wire n3397_o;
  reg n3398_o;
  wire n3399_o;
  wire n3400_o;
  wire n3401_o;
  reg n3402_o;
  wire n3403_o;
  wire n3404_o;
  wire n3405_o;
  wire n3406_o;
  reg n3407_o;
  wire n3408_o;
  wire n3409_o;
  wire n3410_o;
  wire n3411_o;
  reg n3412_o;
  wire [4:0] n3413_o;
  wire [4:0] n3414_o;
  wire [4:0] n3415_o;
  wire [4:0] n3416_o;
  reg [4:0] n3417_o;
  wire [1:0] n3418_o;
  wire [1:0] n3419_o;
  wire [1:0] n3420_o;
  reg [1:0] n3421_o;
  wire n3422_o;
  wire n3423_o;
  reg n3424_o;
  reg [7:0] n3425_o;
  reg [7:0] n3426_o;
  reg [63:0] n3427_o;
  reg [63:0] n3428_o;
  reg [63:0] n3429_o;
  reg [63:0] n3430_o;
  reg [63:0] n3431_o;
  wire n3432_o;
  wire [2:0] n3434_o;
  wire [6:0] n3435_o;
  wire [5:0] n3436_o;
  wire [13:0] n3437_o;
  wire [13:0] n3438_o;
  wire [7:0] n3439_o;
  wire [7:0] n3440_o;
  wire [63:0] n3441_o;
  wire [63:0] n3442_o;
  wire [63:0] n3443_o;
  wire [63:0] n3444_o;
  wire [63:0] n3445_o;
  wire n3450_o;
  wire [2:0] n3452_o;
  wire [6:0] n3454_o;
  wire [5:0] n3456_o;
  wire [13:0] n3457_o;
  wire [7:0] n3458_o;
  wire [7:0] n3460_o;
  wire [63:0] n3461_o;
  wire [63:0] n3462_o;
  wire [63:0] n3463_o;
  wire [63:0] n3464_o;
  wire [63:0] n3465_o;
  wire n3469_o;
  wire [2:0] n3470_o;
  wire [6:0] n3471_o;
  wire [5:0] n3472_o;
  wire [13:0] n3473_o;
  wire [7:0] n3474_o;
  wire [7:0] n3475_o;
  wire [63:0] n3476_o;
  wire [63:0] n3477_o;
  wire [63:0] n3478_o;
  wire [63:0] n3479_o;
  wire [63:0] n3480_o;
  wire n3485_o;
  wire [2:0] n3487_o;
  wire [6:0] n3489_o;
  wire [5:0] n3491_o;
  wire [13:0] n3492_o;
  wire [7:0] n3493_o;
  wire [7:0] n3495_o;
  wire [63:0] n3496_o;
  wire [63:0] n3497_o;
  wire [63:0] n3498_o;
  wire [63:0] n3499_o;
  wire [63:0] n3500_o;
  wire [63:0] n3501_o;
  wire [63:0] n3502_o;
  wire [63:0] n3503_o;
  wire [63:0] n3504_o;
  wire [63:0] n3505_o;
  wire n3532_o;
  wire n3533_o;
  wire n3534_o;
  wire [3:0] n3536_o;
  wire [3:0] n3538_o;
  wire n3541_o;
  localparam [7:0] n3542_o = 8'b00000000;
  wire n3544_o;
  wire n3545_o;
  wire n3546_o;
  wire [3:0] n3548_o;
  wire [3:0] n3549_o;
  wire n3550_o;
  wire n3551_o;
  wire n3553_o;
  wire n3554_o;
  wire n3555_o;
  wire [3:0] n3557_o;
  wire [3:0] n3558_o;
  wire n3559_o;
  wire n3560_o;
  wire n3562_o;
  wire n3563_o;
  wire n3564_o;
  wire [3:0] n3566_o;
  wire [3:0] n3567_o;
  wire n3568_o;
  wire n3569_o;
  wire n3571_o;
  wire n3572_o;
  wire n3573_o;
  wire [3:0] n3575_o;
  wire [3:0] n3576_o;
  wire n3577_o;
  wire n3578_o;
  wire n3580_o;
  wire n3581_o;
  wire n3582_o;
  wire [3:0] n3584_o;
  wire [3:0] n3585_o;
  wire n3586_o;
  wire n3587_o;
  wire n3589_o;
  wire n3590_o;
  wire n3591_o;
  wire [3:0] n3593_o;
  wire [3:0] n3594_o;
  wire n3595_o;
  wire n3596_o;
  wire n3597_o;
  wire n3598_o;
  wire n3599_o;
  wire n3600_o;
  wire [3:0] n3602_o;
  wire [3:0] n3603_o;
  wire n3604_o;
  wire [7:0] n3605_o;
  wire n3607_o;
  wire n3609_o;
  wire n3610_o;
  wire n3612_o;
  wire n3613_o;
  wire n3615_o;
  wire n3616_o;
  wire n3618_o;
  wire n3619_o;
  wire n3621_o;
  wire n3622_o;
  wire n3624_o;
  wire n3625_o;
  wire n3627_o;
  wire n3628_o;
  wire n3630_o;
  wire n3631_o;
  wire n3633_o;
  wire n3635_o;
  wire n3636_o;
  wire n3637_o;
  wire n3639_o;
  wire n3640_o;
  wire n3641_o;
  wire n3642_o;
  wire n3643_o;
  wire n3646_o;
  reg n3648_o;
  reg [2:0] n3657_q;
  reg [6:0] n3658_q;
  reg [5:0] n3659_q;
  reg [13:0] n3660_q;
  reg [7:0] n3661_q;
  reg [7:0] n3662_q;
  reg [63:0] n3663_q;
  reg [63:0] n3664_q;
  reg [63:0] n3665_q;
  reg [63:0] n3666_q;
  reg [63:0] n3667_q;
  wire [31:0] n3668_o;
  wire [7:0] n3669_o;
  wire n3670_o;
  reg n3671_q;
  reg n3672_q;
  wire [3:0] n3673_o;
  reg [3:0] n3674_q;
  wire n3675_o;
  wire n3676_o;
  wire n3677_o;
  wire n3678_o;
  wire n3679_o;
  wire n3680_o;
  wire n3681_o;
  wire n3682_o;
  wire n3683_o;
  wire n3684_o;
  wire n3685_o;
  wire n3686_o;
  wire n3687_o;
  wire n3688_o;
  wire n3689_o;
  wire n3690_o;
  wire n3691_o;
  wire n3692_o;
  wire [7:0] n3693_o;
  wire [7:0] n3694_o;
  wire [7:0] n3695_o;
  wire [7:0] n3696_o;
  wire [7:0] n3697_o;
  wire [7:0] n3698_o;
  wire [7:0] n3699_o;
  wire [7:0] n3700_o;
  wire [7:0] n3701_o;
  wire [7:0] n3702_o;
  wire [7:0] n3703_o;
  wire [7:0] n3704_o;
  wire [7:0] n3705_o;
  wire [7:0] n3706_o;
  wire [7:0] n3707_o;
  wire [7:0] n3708_o;
  wire [63:0] n3709_o;
  wire n3710_o;
  wire n3711_o;
  wire n3712_o;
  wire n3713_o;
  wire n3714_o;
  wire n3715_o;
  wire n3716_o;
  wire n3717_o;
  wire n3718_o;
  wire n3719_o;
  wire n3720_o;
  wire n3721_o;
  wire n3722_o;
  wire n3723_o;
  wire n3724_o;
  wire n3725_o;
  wire n3726_o;
  wire n3727_o;
  wire [7:0] n3728_o;
  wire [7:0] n3729_o;
  wire [7:0] n3730_o;
  wire [7:0] n3731_o;
  wire [7:0] n3732_o;
  wire [7:0] n3733_o;
  wire [7:0] n3734_o;
  wire [7:0] n3735_o;
  wire [7:0] n3736_o;
  wire [7:0] n3737_o;
  wire [7:0] n3738_o;
  wire [7:0] n3739_o;
  wire [7:0] n3740_o;
  wire [7:0] n3741_o;
  wire [7:0] n3742_o;
  wire [7:0] n3743_o;
  wire [63:0] n3744_o;
  wire n3745_o;
  wire n3746_o;
  wire n3747_o;
  wire n3748_o;
  wire n3749_o;
  wire n3750_o;
  wire n3751_o;
  wire n3752_o;
  wire n3753_o;
  wire n3754_o;
  wire n3755_o;
  wire n3756_o;
  wire n3757_o;
  wire n3758_o;
  wire n3759_o;
  wire n3760_o;
  wire n3761_o;
  wire n3762_o;
  wire [7:0] n3763_o;
  wire [7:0] n3764_o;
  wire [7:0] n3765_o;
  wire [7:0] n3766_o;
  wire [7:0] n3767_o;
  wire [7:0] n3768_o;
  wire [7:0] n3769_o;
  wire [7:0] n3770_o;
  wire [7:0] n3771_o;
  wire [7:0] n3772_o;
  wire [7:0] n3773_o;
  wire [7:0] n3774_o;
  wire [7:0] n3775_o;
  wire [7:0] n3776_o;
  wire [7:0] n3777_o;
  wire [7:0] n3778_o;
  wire [63:0] n3779_o;
  wire n3780_o;
  wire n3781_o;
  wire n3782_o;
  wire n3783_o;
  wire n3784_o;
  wire n3785_o;
  wire n3786_o;
  wire n3787_o;
  wire n3788_o;
  wire n3789_o;
  wire n3790_o;
  wire n3791_o;
  wire n3792_o;
  wire n3793_o;
  wire n3794_o;
  wire n3795_o;
  wire n3796_o;
  wire n3797_o;
  wire [7:0] n3798_o;
  wire [7:0] n3799_o;
  wire [7:0] n3800_o;
  wire [7:0] n3801_o;
  wire [7:0] n3802_o;
  wire [7:0] n3803_o;
  wire [7:0] n3804_o;
  wire [7:0] n3805_o;
  wire [7:0] n3806_o;
  wire [7:0] n3807_o;
  wire [7:0] n3808_o;
  wire [7:0] n3809_o;
  wire [7:0] n3810_o;
  wire [7:0] n3811_o;
  wire [7:0] n3812_o;
  wire [7:0] n3813_o;
  wire [63:0] n3814_o;
  wire n3815_o;
  wire n3816_o;
  wire n3817_o;
  wire n3818_o;
  wire n3819_o;
  wire n3820_o;
  wire n3821_o;
  wire n3822_o;
  wire n3823_o;
  wire n3824_o;
  wire n3825_o;
  wire n3826_o;
  wire n3827_o;
  wire n3828_o;
  wire n3829_o;
  wire n3830_o;
  wire n3831_o;
  wire n3832_o;
  wire [7:0] n3833_o;
  wire [7:0] n3834_o;
  wire [7:0] n3835_o;
  wire [7:0] n3836_o;
  wire [7:0] n3837_o;
  wire [7:0] n3838_o;
  wire [7:0] n3839_o;
  wire [7:0] n3840_o;
  wire [7:0] n3841_o;
  wire [7:0] n3842_o;
  wire [7:0] n3843_o;
  wire [7:0] n3844_o;
  wire [7:0] n3845_o;
  wire [7:0] n3846_o;
  wire [7:0] n3847_o;
  wire [7:0] n3848_o;
  wire [63:0] n3849_o;
  wire n3850_o;
  wire n3851_o;
  wire n3852_o;
  wire n3853_o;
  wire n3854_o;
  wire n3855_o;
  wire n3856_o;
  wire n3857_o;
  wire n3858_o;
  wire n3859_o;
  wire n3860_o;
  wire n3861_o;
  wire n3862_o;
  wire n3863_o;
  wire n3864_o;
  wire n3865_o;
  wire n3866_o;
  wire n3867_o;
  wire n3868_o;
  wire n3869_o;
  wire n3870_o;
  wire n3871_o;
  wire n3872_o;
  wire n3873_o;
  wire n3874_o;
  wire n3875_o;
  wire n3876_o;
  wire n3877_o;
  wire n3878_o;
  wire n3879_o;
  wire n3880_o;
  wire n3881_o;
  wire n3882_o;
  wire n3883_o;
  wire [7:0] n3884_o;
  wire n3885_o;
  wire n3886_o;
  wire n3887_o;
  wire n3888_o;
  wire n3889_o;
  wire n3890_o;
  wire n3891_o;
  wire n3892_o;
  wire n3893_o;
  wire n3894_o;
  wire n3895_o;
  wire n3896_o;
  wire n3897_o;
  wire n3898_o;
  wire n3899_o;
  wire n3900_o;
  wire n3901_o;
  wire n3902_o;
  wire [7:0] n3903_o;
  wire [7:0] n3904_o;
  wire [7:0] n3905_o;
  wire [7:0] n3906_o;
  wire [7:0] n3907_o;
  wire [7:0] n3908_o;
  wire [7:0] n3909_o;
  wire [7:0] n3910_o;
  wire [7:0] n3911_o;
  wire [7:0] n3912_o;
  wire [7:0] n3913_o;
  wire [7:0] n3914_o;
  wire [7:0] n3915_o;
  wire [7:0] n3916_o;
  wire [7:0] n3917_o;
  wire [7:0] n3918_o;
  wire [63:0] n3919_o;
  wire n3920_o;
  wire n3921_o;
  wire n3922_o;
  wire n3923_o;
  wire n3924_o;
  wire n3925_o;
  wire n3926_o;
  wire n3927_o;
  wire n3928_o;
  wire n3929_o;
  wire n3930_o;
  wire n3931_o;
  wire n3932_o;
  wire n3933_o;
  wire n3934_o;
  wire n3935_o;
  wire n3936_o;
  wire n3937_o;
  wire [7:0] n3938_o;
  wire [7:0] n3939_o;
  wire [7:0] n3940_o;
  wire [7:0] n3941_o;
  wire [7:0] n3942_o;
  wire [7:0] n3943_o;
  wire [7:0] n3944_o;
  wire [7:0] n3945_o;
  wire [7:0] n3946_o;
  wire [7:0] n3947_o;
  wire [7:0] n3948_o;
  wire [7:0] n3949_o;
  wire [7:0] n3950_o;
  wire [7:0] n3951_o;
  wire [7:0] n3952_o;
  wire [7:0] n3953_o;
  wire [63:0] n3954_o;
  wire n3955_o;
  wire n3956_o;
  wire n3957_o;
  wire n3958_o;
  wire n3959_o;
  wire n3960_o;
  wire n3961_o;
  wire n3962_o;
  wire n3963_o;
  wire n3964_o;
  wire n3965_o;
  wire n3966_o;
  wire n3967_o;
  wire n3968_o;
  wire n3969_o;
  wire n3970_o;
  wire n3971_o;
  wire n3972_o;
  wire [7:0] n3973_o;
  wire [7:0] n3974_o;
  wire [7:0] n3975_o;
  wire [7:0] n3976_o;
  wire [7:0] n3977_o;
  wire [7:0] n3978_o;
  wire [7:0] n3979_o;
  wire [7:0] n3980_o;
  wire [7:0] n3981_o;
  wire [7:0] n3982_o;
  wire [7:0] n3983_o;
  wire [7:0] n3984_o;
  wire [7:0] n3985_o;
  wire [7:0] n3986_o;
  wire [7:0] n3987_o;
  wire [7:0] n3988_o;
  wire [63:0] n3989_o;
  wire n3990_o;
  wire n3991_o;
  wire n3992_o;
  wire n3993_o;
  wire n3994_o;
  wire n3995_o;
  wire n3996_o;
  wire n3997_o;
  wire n3998_o;
  wire n3999_o;
  wire n4000_o;
  wire n4001_o;
  wire n4002_o;
  wire n4003_o;
  wire n4004_o;
  wire n4005_o;
  wire n4006_o;
  wire n4007_o;
  wire [7:0] n4008_o;
  wire [7:0] n4009_o;
  wire [7:0] n4010_o;
  wire [7:0] n4011_o;
  wire [7:0] n4012_o;
  wire [7:0] n4013_o;
  wire [7:0] n4014_o;
  wire [7:0] n4015_o;
  wire [7:0] n4016_o;
  wire [7:0] n4017_o;
  wire [7:0] n4018_o;
  wire [7:0] n4019_o;
  wire [7:0] n4020_o;
  wire [7:0] n4021_o;
  wire [7:0] n4022_o;
  wire [7:0] n4023_o;
  wire [63:0] n4024_o;
  wire n4025_o;
  wire n4026_o;
  wire n4027_o;
  wire n4028_o;
  wire n4029_o;
  wire n4030_o;
  wire n4031_o;
  wire n4032_o;
  wire n4033_o;
  wire n4034_o;
  wire n4035_o;
  wire n4036_o;
  wire n4037_o;
  wire n4038_o;
  wire n4039_o;
  wire n4040_o;
  wire n4041_o;
  wire n4042_o;
  wire [7:0] n4043_o;
  wire [7:0] n4044_o;
  wire [7:0] n4045_o;
  wire [7:0] n4046_o;
  wire [7:0] n4047_o;
  wire [7:0] n4048_o;
  wire [7:0] n4049_o;
  wire [7:0] n4050_o;
  wire [7:0] n4051_o;
  wire [7:0] n4052_o;
  wire [7:0] n4053_o;
  wire [7:0] n4054_o;
  wire [7:0] n4055_o;
  wire [7:0] n4056_o;
  wire [7:0] n4057_o;
  wire [7:0] n4058_o;
  wire [63:0] n4059_o;
  wire n4060_o;
  wire n4061_o;
  wire n4062_o;
  wire n4063_o;
  wire n4064_o;
  wire n4065_o;
  wire n4066_o;
  wire n4067_o;
  wire n4068_o;
  wire n4069_o;
  wire n4070_o;
  wire n4071_o;
  wire n4072_o;
  wire n4073_o;
  wire n4074_o;
  wire n4075_o;
  wire n4076_o;
  wire n4077_o;
  wire [7:0] n4078_o;
  wire [7:0] n4079_o;
  wire [7:0] n4080_o;
  wire [7:0] n4081_o;
  wire [7:0] n4082_o;
  wire [7:0] n4083_o;
  wire [7:0] n4084_o;
  wire [7:0] n4085_o;
  wire [7:0] n4086_o;
  wire [7:0] n4087_o;
  wire [7:0] n4088_o;
  wire [7:0] n4089_o;
  wire [7:0] n4090_o;
  wire [7:0] n4091_o;
  wire [7:0] n4092_o;
  wire [7:0] n4093_o;
  wire [63:0] n4094_o;
  wire n4095_o;
  wire n4096_o;
  wire n4097_o;
  wire n4098_o;
  wire n4099_o;
  wire n4100_o;
  wire n4101_o;
  wire n4102_o;
  wire n4103_o;
  wire n4104_o;
  wire n4105_o;
  wire n4106_o;
  wire n4107_o;
  wire n4108_o;
  wire n4109_o;
  wire n4110_o;
  wire n4111_o;
  wire n4112_o;
  wire [7:0] n4113_o;
  wire [7:0] n4114_o;
  wire [7:0] n4115_o;
  wire [7:0] n4116_o;
  wire [7:0] n4117_o;
  wire [7:0] n4118_o;
  wire [7:0] n4119_o;
  wire [7:0] n4120_o;
  wire [7:0] n4121_o;
  wire [7:0] n4122_o;
  wire [7:0] n4123_o;
  wire [7:0] n4124_o;
  wire [7:0] n4125_o;
  wire [7:0] n4126_o;
  wire [7:0] n4127_o;
  wire [7:0] n4128_o;
  wire [63:0] n4129_o;
  wire n4130_o;
  wire n4131_o;
  wire n4132_o;
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
  wire n4145_o;
  wire n4146_o;
  wire n4147_o;
  wire n4148_o;
  wire n4149_o;
  wire n4150_o;
  wire n4151_o;
  wire n4152_o;
  wire n4153_o;
  wire n4154_o;
  wire n4155_o;
  wire n4156_o;
  wire n4157_o;
  wire n4158_o;
  wire n4159_o;
  wire n4160_o;
  wire n4161_o;
  wire n4162_o;
  wire n4163_o;
  wire [7:0] n4164_o;
  assign vram_a = n3059_o;
  assign collide = n3671_q;
  assign overflow = n3672_q;
  assign color = n3674_q;
  /* ./vdp_sprites.vhd:46:16  */
  always @*
    state = n3657_q; // (isignal)
  initial
    state = 3'b000;
  /* ./vdp_sprites.vhd:47:16  */
  assign count = n3658_q; // (signal)
  /* ./vdp_sprites.vhd:48:16  */
  assign index = n3659_q; // (signal)
  /* ./vdp_sprites.vhd:49:16  */
  assign data_address = n3660_q; // (signal)
  /* ./vdp_sprites.vhd:50:16  */
  assign ce_spload = n3063_o; // (signal)
  /* ./vdp_sprites.vhd:51:16  */
  assign m2_flags = n3661_q; // (signal)
  /* ./vdp_sprites.vhd:56:16  */
  assign enable = n3662_q; // (signal)
  /* ./vdp_sprites.vhd:57:16  */
  assign spr_x = n3663_q; // (signal)
  /* ./vdp_sprites.vhd:58:16  */
  assign spr_d0 = n3664_q; // (signal)
  /* ./vdp_sprites.vhd:59:16  */
  assign spr_d1 = n3665_q; // (signal)
  /* ./vdp_sprites.vhd:60:16  */
  assign spr_d2 = n3666_q; // (signal)
  /* ./vdp_sprites.vhd:61:16  */
  assign spr_d3 = n3667_q; // (signal)
  /* ./vdp_sprites.vhd:64:16  */
  assign spr_color = n3668_o; // (signal)
  /* ./vdp_sprites.vhd:65:16  */
  assign spr_active = n3669_o; // (signal)
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n1_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2681_o),
    .spr_x(n2682_o),
    .load(n2695_o),
    .x248(n2702_o),
    .x224(n2709_o),
    .m4(smode_m4),
    .wide_n(n2710_o),
    .spr_d0(n2711_o),
    .spr_d1(n2712_o),
    .spr_d2(n2713_o),
    .spr_d3(n2714_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n1_shifter_color),
    .active(shifters_n1_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2681_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2682_o = spr_x[63:56];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2683_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2685_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2687_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2688_o = n2685_o | n2687_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2689_o = n2688_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2690_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2692_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2693_o = n2692_o & n2690_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2694_o = n2689_o | n2693_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2695_o = n2694_o & n2683_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2697_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2699_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2700_o = n2697_o | n2699_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2701_o = n2700_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2702_o = smode_m4 & n2701_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2703_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2705_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2707_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2708_o = n2705_o | n2707_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2709_o = n2708_o & n2703_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2710_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2711_o = spr_d0[63:56];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2712_o = spr_d1[63:56];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2713_o = spr_d2[63:56];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2714_o = spr_d3[63:56];
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n2_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2717_o),
    .spr_x(n2718_o),
    .load(n2731_o),
    .x248(n2738_o),
    .x224(n2745_o),
    .m4(smode_m4),
    .wide_n(n2746_o),
    .spr_d0(n2747_o),
    .spr_d1(n2748_o),
    .spr_d2(n2749_o),
    .spr_d3(n2750_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n2_shifter_color),
    .active(shifters_n2_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2717_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2718_o = spr_x[55:48];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2719_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2721_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2723_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2724_o = n2721_o | n2723_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2725_o = n2724_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2726_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2728_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2729_o = n2728_o & n2726_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2730_o = n2725_o | n2729_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2731_o = n2730_o & n2719_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2733_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2735_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2736_o = n2733_o | n2735_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2737_o = n2736_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2738_o = smode_m4 & n2737_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2739_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2741_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2743_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2744_o = n2741_o | n2743_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2745_o = n2744_o & n2739_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2746_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2747_o = spr_d0[55:48];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2748_o = spr_d1[55:48];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2749_o = spr_d2[55:48];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2750_o = spr_d3[55:48];
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n3_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2753_o),
    .spr_x(n2754_o),
    .load(n2767_o),
    .x248(n2774_o),
    .x224(n2781_o),
    .m4(smode_m4),
    .wide_n(n2782_o),
    .spr_d0(n2783_o),
    .spr_d1(n2784_o),
    .spr_d2(n2785_o),
    .spr_d3(n2786_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n3_shifter_color),
    .active(shifters_n3_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2753_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2754_o = spr_x[47:40];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2755_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2757_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2759_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2760_o = n2757_o | n2759_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2761_o = n2760_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2762_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2764_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2765_o = n2764_o & n2762_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2766_o = n2761_o | n2765_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2767_o = n2766_o & n2755_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2769_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2771_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2772_o = n2769_o | n2771_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2773_o = n2772_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2774_o = smode_m4 & n2773_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2775_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2777_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2779_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2780_o = n2777_o | n2779_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2781_o = n2780_o & n2775_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2782_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2783_o = spr_d0[47:40];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2784_o = spr_d1[47:40];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2785_o = spr_d2[47:40];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2786_o = spr_d3[47:40];
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n4_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2789_o),
    .spr_x(n2790_o),
    .load(n2803_o),
    .x248(n2810_o),
    .x224(n2817_o),
    .m4(smode_m4),
    .wide_n(n2818_o),
    .spr_d0(n2819_o),
    .spr_d1(n2820_o),
    .spr_d2(n2821_o),
    .spr_d3(n2822_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n4_shifter_color),
    .active(shifters_n4_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2789_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2790_o = spr_x[39:32];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2791_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2793_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2795_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2796_o = n2793_o | n2795_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2797_o = n2796_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2798_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2800_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2801_o = n2800_o & n2798_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2802_o = n2797_o | n2801_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2803_o = n2802_o & n2791_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2805_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2807_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2808_o = n2805_o | n2807_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2809_o = n2808_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2810_o = smode_m4 & n2809_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2811_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2813_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2815_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2816_o = n2813_o | n2815_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2817_o = n2816_o & n2811_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2818_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2819_o = spr_d0[39:32];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2820_o = spr_d1[39:32];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2821_o = spr_d2[39:32];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2822_o = spr_d3[39:32];
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n5_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2825_o),
    .spr_x(n2826_o),
    .load(n2839_o),
    .x248(n2846_o),
    .x224(n2853_o),
    .m4(smode_m4),
    .wide_n(n2854_o),
    .spr_d0(n2855_o),
    .spr_d1(n2856_o),
    .spr_d2(n2857_o),
    .spr_d3(n2858_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n5_shifter_color),
    .active(shifters_n5_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2825_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2826_o = spr_x[31:24];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2827_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2829_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2831_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2832_o = n2829_o | n2831_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2833_o = n2832_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2834_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2836_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2837_o = n2836_o & n2834_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2838_o = n2833_o | n2837_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2839_o = n2838_o & n2827_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2841_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2843_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2844_o = n2841_o | n2843_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2845_o = n2844_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2846_o = smode_m4 & n2845_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2847_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2849_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2851_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2852_o = n2849_o | n2851_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2853_o = n2852_o & n2847_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2854_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2855_o = spr_d0[31:24];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2856_o = spr_d1[31:24];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2857_o = spr_d2[31:24];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2858_o = spr_d3[31:24];
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n6_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2861_o),
    .spr_x(n2862_o),
    .load(n2875_o),
    .x248(n2882_o),
    .x224(n2889_o),
    .m4(smode_m4),
    .wide_n(n2890_o),
    .spr_d0(n2891_o),
    .spr_d1(n2892_o),
    .spr_d2(n2893_o),
    .spr_d3(n2894_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n6_shifter_color),
    .active(shifters_n6_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2861_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2862_o = spr_x[23:16];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2863_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2865_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2867_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2868_o = n2865_o | n2867_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2869_o = n2868_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2870_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2872_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2873_o = n2872_o & n2870_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2874_o = n2869_o | n2873_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2875_o = n2874_o & n2863_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2877_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2879_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2880_o = n2877_o | n2879_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2881_o = n2880_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2882_o = smode_m4 & n2881_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2883_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2885_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2887_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2888_o = n2885_o | n2887_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2889_o = n2888_o & n2883_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2890_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2891_o = spr_d0[23:16];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2892_o = spr_d1[23:16];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2893_o = spr_d2[23:16];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2894_o = spr_d3[23:16];
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n7_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2897_o),
    .spr_x(n2898_o),
    .load(n2911_o),
    .x248(n2918_o),
    .x224(n2925_o),
    .m4(smode_m4),
    .wide_n(n2926_o),
    .spr_d0(n2927_o),
    .spr_d1(n2928_o),
    .spr_d2(n2929_o),
    .spr_d3(n2930_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n7_shifter_color),
    .active(shifters_n7_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2897_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2898_o = spr_x[15:8];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2899_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2901_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2903_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2904_o = n2901_o | n2903_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2905_o = n2904_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2906_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2908_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2909_o = n2908_o & n2906_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2910_o = n2905_o | n2909_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2911_o = n2910_o & n2899_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2913_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2915_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2916_o = n2913_o | n2915_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2917_o = n2916_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2918_o = smode_m4 & n2917_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2919_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2921_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2923_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2924_o = n2921_o | n2923_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2925_o = n2924_o & n2919_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2926_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2927_o = spr_d0[15:8];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2928_o = spr_d1[15:8];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2929_o = spr_d2[15:8];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2930_o = spr_d3[15:8];
  /* ./vdp_sprites.vhd:71:17  */
  vpd_sprite_shifter shifters_n8_shifter (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .x(n2933_o),
    .spr_x(n2934_o),
    .load(n2947_o),
    .x248(n2954_o),
    .x224(n2961_o),
    .m4(smode_m4),
    .wide_n(n2962_o),
    .spr_d0(n2963_o),
    .spr_d1(n2964_o),
    .spr_d2(n2965_o),
    .spr_d3(n2966_o),
    .ss_regs_set(ss_regs_set),
    .color(shifters_n8_shifter_color),
    .active(shifters_n8_shifter_active));
  /* ./vdp_sprites.vhd:75:45  */
  assign n2933_o = x[7:0];
  /* ./vdp_sprites.vhd:76:41  */
  assign n2934_o = spr_x[7:0];
  /* ./vdp_sprites.vhd:82:39  */
  assign n2935_o = ~shift;
  /* ./vdp_sprites.vhd:82:69  */
  assign n2937_o = $unsigned(x) < $unsigned(9'b011111111);
  /* ./vdp_sprites.vhd:82:78  */
  assign n2939_o = x == 9'b111111111;
  /* ./vdp_sprites.vhd:82:74  */
  assign n2940_o = n2937_o | n2939_o;
  /* ./vdp_sprites.vhd:82:63  */
  assign n2941_o = n2940_o & smode_m4;
  /* ./vdp_sprites.vhd:83:83  */
  assign n2942_o = ~smode_m4;
  /* ./vdp_sprites.vhd:83:93  */
  assign n2944_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp_sprites.vhd:83:88  */
  assign n2945_o = n2944_o & n2942_o;
  /* ./vdp_sprites.vhd:82:85  */
  assign n2946_o = n2941_o | n2945_o;
  /* ./vdp_sprites.vhd:82:44  */
  assign n2947_o = n2946_o & n2935_o;
  /* ./vdp_sprites.vhd:84:50  */
  assign n2949_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_sprites.vhd:84:59  */
  assign n2951_o = $unsigned(x) >= $unsigned(9'b111111000);
  /* ./vdp_sprites.vhd:84:55  */
  assign n2952_o = n2949_o | n2951_o;
  /* ./vdp_sprites.vhd:84:44  */
  assign n2953_o = n2952_o & shift;
  /* ./vdp_sprites.vhd:84:66  */
  assign n2954_o = smode_m4 & n2953_o;
  /* ./vdp_sprites.vhd:85:42  */
  assign n2955_o = ~smode_m4;
  /* ./vdp_sprites.vhd:85:53  */
  assign n2957_o = $unsigned(x) < $unsigned(9'b011011111);
  /* ./vdp_sprites.vhd:85:62  */
  assign n2959_o = $unsigned(x) >= $unsigned(9'b111100000);
  /* ./vdp_sprites.vhd:85:58  */
  assign n2960_o = n2957_o | n2959_o;
  /* ./vdp_sprites.vhd:85:47  */
  assign n2961_o = n2960_o & n2955_o;
  /* ./vdp_sprites.vhd:87:40  */
  assign n2962_o = ~wide;
  /* ./vdp_sprites.vhd:88:40  */
  assign n2963_o = spr_d0[7:0];
  /* ./vdp_sprites.vhd:89:40  */
  assign n2964_o = spr_d1[7:0];
  /* ./vdp_sprites.vhd:90:40  */
  assign n2965_o = spr_d2[7:0];
  /* ./vdp_sprites.vhd:91:40  */
  assign n2966_o = spr_d3[7:0];
  /* ./vdp_sprites.vhd:102:29  */
  assign n2971_o = ~smode_m4;
  /* ./vdp_sprites.vhd:103:34  */
  assign n2973_o = state == 3'b001;
  /* ./vdp_sprites.vhd:103:78  */
  assign n2974_o = index[4:0];
  /* ./vdp_sprites.vhd:103:72  */
  assign n2975_o = {table_address, n2974_o};
  /* ./vdp_sprites.vhd:103:90  */
  assign n2977_o = {n2975_o, 2'b00};
  /* ./vdp_sprites.vhd:104:37  */
  assign n2979_o = state == 3'b010;
  /* ./vdp_sprites.vhd:104:80  */
  assign n2980_o = index[4:0];
  /* ./vdp_sprites.vhd:104:74  */
  assign n2981_o = {table_address, n2980_o};
  /* ./vdp_sprites.vhd:104:92  */
  assign n2983_o = {n2981_o, 2'b10};
  /* ./vdp_sprites.vhd:105:37  */
  assign n2985_o = state == 3'b011;
  /* ./vdp_sprites.vhd:105:80  */
  assign n2986_o = index[4:0];
  /* ./vdp_sprites.vhd:105:74  */
  assign n2987_o = {table_address, n2986_o};
  /* ./vdp_sprites.vhd:105:92  */
  assign n2989_o = {n2987_o, 2'b01};
  /* ./vdp_sprites.vhd:106:37  */
  assign n2991_o = state == 3'b100;
  /* ./vdp_sprites.vhd:106:80  */
  assign n2992_o = index[4:0];
  /* ./vdp_sprites.vhd:106:74  */
  assign n2993_o = {table_address, n2992_o};
  /* ./vdp_sprites.vhd:106:92  */
  assign n2995_o = {n2993_o, 2'b11};
  /* ./vdp_sprites.vhd:107:37  */
  assign n2997_o = state == 3'b101;
  /* ./vdp_sprites.vhd:108:37  */
  assign n2999_o = state == 3'b110;
  /* ./vdp_sprites.vhd:108:25  */
  assign n3001_o = n2999_o ? data_address : 14'b00000000000000;
  /* ./vdp_sprites.vhd:107:25  */
  assign n3002_o = n2997_o ? data_address : n3001_o;
  /* ./vdp_sprites.vhd:106:25  */
  assign n3003_o = n2991_o ? n2995_o : n3002_o;
  /* ./vdp_sprites.vhd:105:25  */
  assign n3004_o = n2985_o ? n2989_o : n3003_o;
  /* ./vdp_sprites.vhd:104:25  */
  assign n3005_o = n2979_o ? n2983_o : n3004_o;
  /* ./vdp_sprites.vhd:103:25  */
  assign n3006_o = n2973_o ? n2977_o : n3005_o;
  /* ./vdp_sprites.vhd:111:34  */
  assign n3008_o = state == 3'b001;
  /* ./vdp_sprites.vhd:111:72  */
  assign n3009_o = table_address[6:1];
  /* ./vdp_sprites.vhd:111:85  */
  assign n3011_o = {n3009_o, 2'b00};
  /* ./vdp_sprites.vhd:111:90  */
  assign n3012_o = {n3011_o, index};
  /* ./vdp_sprites.vhd:112:37  */
  assign n3014_o = state == 3'b010;
  /* ./vdp_sprites.vhd:112:74  */
  assign n3015_o = table_address[6:1];
  /* ./vdp_sprites.vhd:112:87  */
  assign n3017_o = {n3015_o, 1'b1};
  /* ./vdp_sprites.vhd:112:91  */
  assign n3018_o = {n3017_o, index};
  /* ./vdp_sprites.vhd:112:97  */
  assign n3020_o = {n3018_o, 1'b1};
  /* ./vdp_sprites.vhd:113:37  */
  assign n3022_o = state == 3'b011;
  /* ./vdp_sprites.vhd:113:74  */
  assign n3023_o = table_address[6:1];
  /* ./vdp_sprites.vhd:113:87  */
  assign n3025_o = {n3023_o, 1'b1};
  /* ./vdp_sprites.vhd:113:91  */
  assign n3026_o = {n3025_o, index};
  /* ./vdp_sprites.vhd:113:97  */
  assign n3028_o = {n3026_o, 1'b0};
  /* ./vdp_sprites.vhd:114:37  */
  assign n3030_o = state == 3'b100;
  /* ./vdp_sprites.vhd:114:73  */
  assign n3031_o = data_address[13:2];
  /* ./vdp_sprites.vhd:114:86  */
  assign n3033_o = {n3031_o, 2'b00};
  /* ./vdp_sprites.vhd:115:37  */
  assign n3035_o = state == 3'b101;
  /* ./vdp_sprites.vhd:115:73  */
  assign n3036_o = data_address[13:2];
  /* ./vdp_sprites.vhd:115:86  */
  assign n3038_o = {n3036_o, 2'b01};
  /* ./vdp_sprites.vhd:116:37  */
  assign n3040_o = state == 3'b110;
  /* ./vdp_sprites.vhd:116:73  */
  assign n3041_o = data_address[13:2];
  /* ./vdp_sprites.vhd:116:86  */
  assign n3043_o = {n3041_o, 2'b10};
  /* ./vdp_sprites.vhd:117:37  */
  assign n3045_o = state == 3'b111;
  /* ./vdp_sprites.vhd:117:73  */
  assign n3046_o = data_address[13:2];
  /* ./vdp_sprites.vhd:117:86  */
  assign n3048_o = {n3046_o, 2'b11};
  /* ./vdp_sprites.vhd:117:25  */
  assign n3050_o = n3045_o ? n3048_o : 14'b00000000000000;
  /* ./vdp_sprites.vhd:116:25  */
  assign n3051_o = n3040_o ? n3043_o : n3050_o;
  /* ./vdp_sprites.vhd:115:25  */
  assign n3052_o = n3035_o ? n3038_o : n3051_o;
  /* ./vdp_sprites.vhd:114:25  */
  assign n3053_o = n3030_o ? n3033_o : n3052_o;
  /* ./vdp_sprites.vhd:113:25  */
  assign n3054_o = n3022_o ? n3028_o : n3053_o;
  /* ./vdp_sprites.vhd:112:25  */
  assign n3055_o = n3014_o ? n3020_o : n3054_o;
  /* ./vdp_sprites.vhd:111:25  */
  assign n3056_o = n3008_o ? n3012_o : n3055_o;
  /* ./vdp_sprites.vhd:110:17  */
  assign n3058_o = smode_m4 ? n3056_o : 14'b00000000000000;
  /* ./vdp_sprites.vhd:102:17  */
  assign n3059_o = n2971_o ? n3006_o : n3058_o;
  /* ./vdp_sprites.vhd:122:29  */
  assign n3063_o = 1'b1 ? ce_vdp : ce_sp;
  /* ./vdp_sprites.vhd:147:37  */
  assign n3111_o = x == 9'b100000001;
  /* ./vdp_sprites.vhd:156:40  */
  assign n3113_o = x == 9'b111110000;
  /* ./vdp_sprites.vhd:161:50  */
  assign n3115_o = {1'b0, vram_d};
  /* ./vdp_sprites.vhd:162:46  */
  assign n3117_o = $unsigned(n3115_o) >= $unsigned(9'b011110000);
  /* ./vdp_sprites.vhd:163:57  */
  assign n3119_o = n3115_o - 9'b100000000;
  /* ./vdp_sprites.vhd:162:41  */
  assign n3120_o = n3117_o ? n3119_o : n3115_o;
  /* ./vdp_sprites.vhd:165:52  */
  assign n3121_o = y - n3120_o;
  /* ./vdp_sprites.vhd:168:55  */
  assign n3122_o = {smode_m4, state};
  /* ./vdp_sprites.vhd:170:54  */
  assign n3124_o = n3120_o == 9'b011010000;
  /* ./vdp_sprites.vhd:170:71  */
  assign n3125_o = ~smode_m1;
  /* ./vdp_sprites.vhd:170:59  */
  assign n3126_o = n3125_o & n3124_o;
  /* ./vdp_sprites.vhd:170:88  */
  assign n3127_o = ~smode_m3;
  /* ./vdp_sprites.vhd:170:76  */
  assign n3128_o = n3127_o & n3126_o;
  /* ./vdp_sprites.vhd:173:60  */
  assign n3129_o = n3121_o[8:5];
  /* ./vdp_sprites.vhd:173:72  */
  assign n3131_o = n3129_o == 4'b0000;
  /* ./vdp_sprites.vhd:174:71  */
  assign n3132_o = n3121_o[4];
  /* ./vdp_sprites.vhd:174:74  */
  assign n3133_o = ~n3132_o;
  /* ./vdp_sprites.vhd:174:92  */
  assign n3134_o = wide & tall;
  /* ./vdp_sprites.vhd:174:79  */
  assign n3135_o = n3133_o | n3134_o;
  /* ./vdp_sprites.vhd:173:80  */
  assign n3136_o = n3135_o & n3131_o;
  /* ./vdp_sprites.vhd:175:71  */
  assign n3137_o = n3121_o[3];
  /* ./vdp_sprites.vhd:175:74  */
  assign n3138_o = ~n3137_o;
  /* ./vdp_sprites.vhd:175:79  */
  assign n3139_o = n3138_o | tall;
  /* ./vdp_sprites.vhd:175:91  */
  assign n3140_o = n3139_o | wide;
  /* ./vdp_sprites.vhd:174:107  */
  assign n3141_o = n3140_o & n3136_o;
  /* ./vdp_sprites.vhd:177:98  */
  assign n3142_o = n3121_o[4:1];
  /* ./vdp_sprites.vhd:179:98  */
  assign n3143_o = n3121_o[3:0];
  /* ./vdp_sprites.vhd:176:57  */
  assign n3144_o = wide ? n3142_o : n3143_o;
  /* ./vdp_sprites.vhd:181:66  */
  assign n3145_o = {25'b0, count};  //  uext
  /* ./vdp_sprites.vhd:181:66  */
  assign n3147_o = $signed(n3145_o) >= $signed(32'b00000000000000000000000000001000);
  /* ./vdp_sprites.vhd:181:77  */
  assign n3149_o = $unsigned(y) < $unsigned(9'b011000000);
  /* ./vdp_sprites.vhd:181:87  */
  assign n3151_o = $unsigned(y) < $unsigned(9'b011100000);
  /* ./vdp_sprites.vhd:181:92  */
  assign n3152_o = smode_m1 & n3151_o;
  /* ./vdp_sprites.vhd:181:82  */
  assign n3153_o = n3149_o | n3152_o;
  /* ./vdp_sprites.vhd:181:115  */
  assign n3155_o = $unsigned(y) < $unsigned(9'b011110000);
  /* ./vdp_sprites.vhd:181:120  */
  assign n3156_o = smode_m3 & n3155_o;
  /* ./vdp_sprites.vhd:181:110  */
  assign n3157_o = n3153_o | n3156_o;
  /* ./vdp_sprites.vhd:181:70  */
  assign n3158_o = n3157_o & n3147_o;
  /* ./vdp_sprites.vhd:173:49  */
  assign n3160_o = n3179_o ? 1'b1 : n3672_q;
  /* ./vdp_sprites.vhd:184:67  */
  assign n3161_o = {25'b0, count};  //  uext
  /* ./vdp_sprites.vhd:184:67  */
  assign n3163_o = $signed(n3161_o) < $signed(32'b00000000000000000000000000001000);
  /* ./vdp_sprites.vhd:184:90  */
  assign n3164_o = {25'b0, count};  //  uext
  /* ./vdp_sprites.vhd:184:90  */
  assign n3166_o = $signed(n3164_o) < $signed(32'b00000000000000000000000000001000);
  /* ./vdp_sprites.vhd:184:93  */
  assign n3167_o = n3166_o | sp64;
  /* ./vdp_sprites.vhd:184:80  */
  assign n3168_o = n3167_o & n3163_o;
  /* ./vdp_sprites.vhd:184:57  */
  assign n3171_o = n3168_o ? 3'b010 : 3'b000;
  /* ./vdp_sprites.vhd:190:65  */
  assign n3173_o = $unsigned(index) < $unsigned(6'b111111);
  /* ./vdp_sprites.vhd:191:79  */
  assign n3175_o = index + 6'b000001;
  /* ./vdp_sprites.vhd:190:57  */
  assign n3177_o = n3173_o ? state : 3'b000;
  /* ./vdp_sprites.vhd:190:57  */
  assign n3178_o = n3173_o ? n3175_o : index;
  /* ./vdp_sprites.vhd:173:49  */
  assign n3179_o = n3158_o & n3141_o;
  /* ./vdp_sprites.vhd:173:49  */
  assign n3180_o = n3141_o ? n3171_o : n3177_o;
  /* ./vdp_sprites.vhd:173:49  */
  assign n3181_o = n3141_o ? index : n3178_o;
  assign n3182_o = data_address[5:2];
  /* ./vdp_sprites.vhd:173:49  */
  assign n3183_o = n3141_o ? n3144_o : n3182_o;
  /* ./vdp_sprites.vhd:170:49  */
  assign n3184_o = n3128_o ? n3672_q : n3160_o;
  /* ./vdp_sprites.vhd:170:49  */
  assign n3186_o = n3128_o ? 3'b000 : n3180_o;
  /* ./vdp_sprites.vhd:170:49  */
  assign n3187_o = n3128_o ? index : n3181_o;
  assign n3188_o = data_address[5:2];
  /* ./vdp_sprites.vhd:170:49  */
  assign n3189_o = n3128_o ? n3188_o : n3183_o;
  /* ./vdp_sprites.vhd:169:41  */
  assign n3191_o = n3122_o == 4'b1001;
  /* ./vdp_sprites.vhd:198:83  */
  assign n3192_o = char_high_bits[2];
  /* ./vdp_sprites.vhd:199:84  */
  assign n3193_o = vram_d[7:1];
  /* ./vdp_sprites.vhd:200:56  */
  assign n3194_o = ~tall;
  /* ./vdp_sprites.vhd:202:82  */
  assign n3195_o = vram_d[0];
  assign n3196_o = data_address[5];
  /* ./vdp_sprites.vhd:200:49  */
  assign n3197_o = n3194_o ? n3195_o : n3196_o;
  /* ./vdp_sprites.vhd:197:41  */
  assign n3199_o = n3122_o == 4'b1010;
  /* ./vdp_sprites.vhd:207:55  */
  assign n3200_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:207:55  */
  assign n3202_o = 3'b111 - n3200_o;
  /* ./vdp_sprites.vhd:207:74  */
  assign n3205_o = vram_d - 8'b00000001;
  /* ./vdp_sprites.vhd:206:41  */
  assign n3208_o = n3122_o == 4'b1011;
  /* ./vdp_sprites.vhd:211:56  */
  assign n3209_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:211:56  */
  assign n3211_o = 3'b111 - n3209_o;
  /* ./vdp_sprites.vhd:210:41  */
  assign n3215_o = n3122_o == 4'b1100;
  /* ./vdp_sprites.vhd:215:56  */
  assign n3216_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:215:56  */
  assign n3218_o = 3'b111 - n3216_o;
  /* ./vdp_sprites.vhd:214:41  */
  assign n3222_o = n3122_o == 4'b1101;
  /* ./vdp_sprites.vhd:219:56  */
  assign n3223_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:219:56  */
  assign n3225_o = 3'b111 - n3223_o;
  /* ./vdp_sprites.vhd:218:41  */
  assign n3229_o = n3122_o == 4'b1110;
  /* ./vdp_sprites.vhd:223:56  */
  assign n3230_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:223:56  */
  assign n3232_o = 3'b111 - n3230_o;
  /* ./vdp_sprites.vhd:224:56  */
  assign n3235_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:224:56  */
  assign n3237_o = 3'b111 - n3235_o;
  /* ./vdp_sprites.vhd:226:65  */
  assign n3242_o = index + 6'b000001;
  /* ./vdp_sprites.vhd:227:65  */
  assign n3243_o = {25'b0, count};  //  uext
  /* ./vdp_sprites.vhd:227:65  */
  assign n3245_o = n3243_o + 32'b00000000000000000000000000000001;
  /* ./vdp_sprites.vhd:227:60  */
  assign n3246_o = n3245_o[6:0];  // trunc
  /* ./vdp_sprites.vhd:222:41  */
  assign n3248_o = n3122_o == 4'b1111;
  /* ./vdp_sprites.vhd:232:54  */
  assign n3250_o = n3120_o == 9'b011010000;
  /* ./vdp_sprites.vhd:234:60  */
  assign n3251_o = n3121_o[8:5];
  /* ./vdp_sprites.vhd:234:72  */
  assign n3253_o = n3251_o == 4'b0000;
  /* ./vdp_sprites.vhd:235:71  */
  assign n3254_o = n3121_o[4];
  /* ./vdp_sprites.vhd:235:74  */
  assign n3255_o = ~n3254_o;
  /* ./vdp_sprites.vhd:235:92  */
  assign n3256_o = wide & tall;
  /* ./vdp_sprites.vhd:235:79  */
  assign n3257_o = n3255_o | n3256_o;
  /* ./vdp_sprites.vhd:234:80  */
  assign n3258_o = n3257_o & n3253_o;
  /* ./vdp_sprites.vhd:236:71  */
  assign n3259_o = n3121_o[3];
  /* ./vdp_sprites.vhd:236:74  */
  assign n3260_o = ~n3259_o;
  /* ./vdp_sprites.vhd:236:79  */
  assign n3261_o = n3260_o | tall;
  /* ./vdp_sprites.vhd:236:91  */
  assign n3262_o = n3261_o | wide;
  /* ./vdp_sprites.vhd:235:107  */
  assign n3263_o = n3262_o & n3258_o;
  /* ./vdp_sprites.vhd:239:98  */
  assign n3264_o = n3121_o[4:1];
  /* ./vdp_sprites.vhd:241:98  */
  assign n3265_o = n3121_o[3:0];
  /* ./vdp_sprites.vhd:238:57  */
  assign n3266_o = wide ? n3264_o : n3265_o;
  /* ./vdp_sprites.vhd:243:67  */
  assign n3267_o = {25'b0, count};  //  uext
  /* ./vdp_sprites.vhd:243:67  */
  assign n3269_o = $signed(n3267_o) < $signed(32'b00000000000000000000000000100000);
  /* ./vdp_sprites.vhd:243:82  */
  assign n3270_o = {25'b0, count};  //  uext
  /* ./vdp_sprites.vhd:243:82  */
  assign n3272_o = $signed(n3270_o) < $signed(32'b00000000000000000000000000000100);
  /* ./vdp_sprites.vhd:243:85  */
  assign n3273_o = n3272_o | sp64;
  /* ./vdp_sprites.vhd:243:72  */
  assign n3274_o = n3273_o & n3269_o;
  /* ./vdp_sprites.vhd:243:57  */
  assign n3277_o = n3274_o ? 3'b010 : 3'b000;
  /* ./vdp_sprites.vhd:249:65  */
  assign n3279_o = $unsigned(index) < $unsigned(6'b011111);
  /* ./vdp_sprites.vhd:250:79  */
  assign n3281_o = index + 6'b000001;
  /* ./vdp_sprites.vhd:249:57  */
  assign n3283_o = n3279_o ? state : 3'b000;
  /* ./vdp_sprites.vhd:249:57  */
  assign n3284_o = n3279_o ? n3281_o : index;
  /* ./vdp_sprites.vhd:234:49  */
  assign n3285_o = n3263_o ? n3277_o : n3283_o;
  /* ./vdp_sprites.vhd:234:49  */
  assign n3286_o = n3263_o ? index : n3284_o;
  assign n3287_o = data_address[3:0];
  /* ./vdp_sprites.vhd:234:49  */
  assign n3288_o = n3263_o ? n3266_o : n3287_o;
  assign n3289_o = data_address[13:11];
  /* ./vdp_sprites.vhd:234:49  */
  assign n3290_o = n3263_o ? char_high_bits : n3289_o;
  /* ./vdp_sprites.vhd:232:49  */
  assign n3292_o = n3250_o ? 3'b000 : n3285_o;
  /* ./vdp_sprites.vhd:232:49  */
  assign n3293_o = n3250_o ? index : n3286_o;
  assign n3294_o = data_address[3:0];
  /* ./vdp_sprites.vhd:232:49  */
  assign n3295_o = n3250_o ? n3294_o : n3288_o;
  assign n3296_o = data_address[13:11];
  /* ./vdp_sprites.vhd:232:49  */
  assign n3297_o = n3250_o ? n3296_o : n3290_o;
  /* ./vdp_sprites.vhd:231:41  */
  assign n3299_o = n3122_o == 4'b0001;
  /* ./vdp_sprites.vhd:258:92  */
  assign n3300_o = vram_d[7:1];
  assign n3301_o = vram_d[0];
  assign n3302_o = data_address[3];
  /* ./vdp_sprites.vhd:257:49  */
  assign n3303_o = tall ? n3302_o : n3301_o;
  assign n3304_o = vram_d[7:1];
  /* ./vdp_sprites.vhd:257:49  */
  assign n3305_o = tall ? n3300_o : n3304_o;
  /* ./vdp_sprites.vhd:256:41  */
  assign n3307_o = n3122_o == 4'b0010;
  /* ./vdp_sprites.vhd:264:41  */
  assign n3309_o = n3122_o == 4'b0100;
  /* ./vdp_sprites.vhd:272:60  */
  assign n3310_o = m2_flags[7];
  /* ./vdp_sprites.vhd:272:63  */
  assign n3311_o = ~n3310_o;
  /* ./vdp_sprites.vhd:273:63  */
  assign n3312_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:273:63  */
  assign n3314_o = 3'b111 - n3312_o;
  /* ./vdp_sprites.vhd:273:82  */
  assign n3317_o = vram_d - 8'b00000001;
  /* ./vdp_sprites.vhd:275:63  */
  assign n3319_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:275:63  */
  assign n3321_o = 3'b111 - n3319_o;
  /* ./vdp_sprites.vhd:275:82  */
  assign n3324_o = vram_d - 8'b00100001;
  /* ./vdp_sprites.vhd:272:49  */
  assign n3326_o = n3311_o ? n3919_o : n3954_o;
  /* ./vdp_sprites.vhd:271:41  */
  assign n3328_o = n3122_o == 4'b0011;
  /* ./vdp_sprites.vhd:282:56  */
  assign n3329_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:282:56  */
  assign n3331_o = 3'b111 - n3329_o;
  /* ./vdp_sprites.vhd:283:56  */
  assign n3334_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:283:56  */
  assign n3336_o = 3'b111 - n3334_o;
  /* ./vdp_sprites.vhd:284:56  */
  assign n3340_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:284:56  */
  assign n3342_o = 3'b111 - n3340_o;
  /* ./vdp_sprites.vhd:285:56  */
  assign n3346_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:285:56  */
  assign n3348_o = 3'b111 - n3346_o;
  /* ./vdp_sprites.vhd:286:90  */
  assign n3351_o = data_address[10:4];
  /* ./vdp_sprites.vhd:286:103  */
  assign n3353_o = n3351_o + 7'b0000001;
  /* ./vdp_sprites.vhd:279:41  */
  assign n3355_o = n3122_o == 4'b0101;
  /* ./vdp_sprites.vhd:291:64  */
  assign n3356_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:291:64  */
  assign n3358_o = 3'b111 - n3356_o;
  /* ./vdp_sprites.vhd:290:49  */
  assign n3361_o = tall ? n4129_o : spr_d1;
  /* ./vdp_sprites.vhd:293:56  */
  assign n3362_o = count[2:0];  // trunc
  /* ./vdp_sprites.vhd:293:56  */
  assign n3364_o = 3'b111 - n3362_o;
  /* ./vdp_sprites.vhd:295:65  */
  assign n3369_o = index + 6'b000001;
  /* ./vdp_sprites.vhd:296:65  */
  assign n3370_o = {25'b0, count};  //  uext
  /* ./vdp_sprites.vhd:296:65  */
  assign n3372_o = n3370_o + 32'b00000000000000000000000000000001;
  /* ./vdp_sprites.vhd:296:60  */
  assign n3373_o = n3372_o[6:0];  // trunc
  /* ./vdp_sprites.vhd:289:41  */
  assign n3375_o = n3122_o == 4'b0110;
  assign n3376_o = {n3375_o, n3355_o, n3328_o, n3309_o, n3307_o, n3299_o, n3248_o, n3229_o, n3222_o, n3215_o, n3208_o, n3199_o, n3191_o};
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3377_o = n3672_q;
      13'b0100000000000: n3377_o = n3672_q;
      13'b0010000000000: n3377_o = n3672_q;
      13'b0001000000000: n3377_o = n3672_q;
      13'b0000100000000: n3377_o = n3672_q;
      13'b0000010000000: n3377_o = n3672_q;
      13'b0000001000000: n3377_o = n3672_q;
      13'b0000000100000: n3377_o = n3672_q;
      13'b0000000010000: n3377_o = n3672_q;
      13'b0000000001000: n3377_o = n3672_q;
      13'b0000000000100: n3377_o = n3672_q;
      13'b0000000000010: n3377_o = n3672_q;
      13'b0000000000001: n3377_o = n3184_o;
      default: n3377_o = n3672_q;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3389_o = 3'b001;
      13'b0100000000000: n3389_o = 3'b110;
      13'b0010000000000: n3389_o = 3'b101;
      13'b0001000000000: n3389_o = 3'b011;
      13'b0000100000000: n3389_o = 3'b100;
      13'b0000010000000: n3389_o = n3292_o;
      13'b0000001000000: n3389_o = 3'b001;
      13'b0000000100000: n3389_o = 3'b111;
      13'b0000000010000: n3389_o = 3'b110;
      13'b0000000001000: n3389_o = 3'b101;
      13'b0000000000100: n3389_o = 3'b100;
      13'b0000000000010: n3389_o = 3'b011;
      13'b0000000000001: n3389_o = n3186_o;
      default: n3389_o = state;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3390_o = n3373_o;
      13'b0100000000000: n3390_o = count;
      13'b0010000000000: n3390_o = count;
      13'b0001000000000: n3390_o = count;
      13'b0000100000000: n3390_o = count;
      13'b0000010000000: n3390_o = count;
      13'b0000001000000: n3390_o = n3246_o;
      13'b0000000100000: n3390_o = count;
      13'b0000000010000: n3390_o = count;
      13'b0000000001000: n3390_o = count;
      13'b0000000000100: n3390_o = count;
      13'b0000000000010: n3390_o = count;
      13'b0000000000001: n3390_o = count;
      default: n3390_o = count;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3391_o = n3369_o;
      13'b0100000000000: n3391_o = index;
      13'b0010000000000: n3391_o = index;
      13'b0001000000000: n3391_o = index;
      13'b0000100000000: n3391_o = index;
      13'b0000010000000: n3391_o = n3293_o;
      13'b0000001000000: n3391_o = n3242_o;
      13'b0000000100000: n3391_o = index;
      13'b0000000010000: n3391_o = index;
      13'b0000000001000: n3391_o = index;
      13'b0000000000100: n3391_o = index;
      13'b0000000000010: n3391_o = index;
      13'b0000000000001: n3391_o = n3187_o;
      default: n3391_o = index;
    endcase
  assign n3392_o = n3295_o[1:0];
  assign n3393_o = data_address[1:0];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3394_o = n3393_o;
      13'b0100000000000: n3394_o = n3393_o;
      13'b0010000000000: n3394_o = n3393_o;
      13'b0001000000000: n3394_o = n3393_o;
      13'b0000100000000: n3394_o = n3393_o;
      13'b0000010000000: n3394_o = n3392_o;
      13'b0000001000000: n3394_o = n3393_o;
      13'b0000000100000: n3394_o = n3393_o;
      13'b0000000010000: n3394_o = n3393_o;
      13'b0000000001000: n3394_o = n3393_o;
      13'b0000000000100: n3394_o = n3393_o;
      13'b0000000000010: n3394_o = n3393_o;
      13'b0000000000001: n3394_o = n3393_o;
      default: n3394_o = n3393_o;
    endcase
  assign n3395_o = n3189_o[0];
  assign n3396_o = n3295_o[2];
  assign n3397_o = data_address[2];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3398_o = n3397_o;
      13'b0100000000000: n3398_o = n3397_o;
      13'b0010000000000: n3398_o = n3397_o;
      13'b0001000000000: n3398_o = n3397_o;
      13'b0000100000000: n3398_o = n3397_o;
      13'b0000010000000: n3398_o = n3396_o;
      13'b0000001000000: n3398_o = n3397_o;
      13'b0000000100000: n3398_o = n3397_o;
      13'b0000000010000: n3398_o = n3397_o;
      13'b0000000001000: n3398_o = n3397_o;
      13'b0000000000100: n3398_o = n3397_o;
      13'b0000000000010: n3398_o = n3397_o;
      13'b0000000000001: n3398_o = n3395_o;
      default: n3398_o = n3397_o;
    endcase
  assign n3399_o = n3189_o[1];
  assign n3400_o = n3295_o[3];
  assign n3401_o = data_address[3];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3402_o = n3401_o;
      13'b0100000000000: n3402_o = n3401_o;
      13'b0010000000000: n3402_o = n3401_o;
      13'b0001000000000: n3402_o = n3401_o;
      13'b0000100000000: n3402_o = n3303_o;
      13'b0000010000000: n3402_o = n3400_o;
      13'b0000001000000: n3402_o = n3401_o;
      13'b0000000100000: n3402_o = n3401_o;
      13'b0000000010000: n3402_o = n3401_o;
      13'b0000000001000: n3402_o = n3401_o;
      13'b0000000000100: n3402_o = n3401_o;
      13'b0000000000010: n3402_o = n3401_o;
      13'b0000000000001: n3402_o = n3399_o;
      default: n3402_o = n3401_o;
    endcase
  assign n3403_o = n3189_o[2];
  assign n3404_o = n3305_o[0];
  assign n3405_o = n3353_o[0];
  assign n3406_o = data_address[4];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3407_o = n3406_o;
      13'b0100000000000: n3407_o = n3405_o;
      13'b0010000000000: n3407_o = n3406_o;
      13'b0001000000000: n3407_o = n3406_o;
      13'b0000100000000: n3407_o = n3404_o;
      13'b0000010000000: n3407_o = n3406_o;
      13'b0000001000000: n3407_o = n3406_o;
      13'b0000000100000: n3407_o = n3406_o;
      13'b0000000010000: n3407_o = n3406_o;
      13'b0000000001000: n3407_o = n3406_o;
      13'b0000000000100: n3407_o = n3406_o;
      13'b0000000000010: n3407_o = n3406_o;
      13'b0000000000001: n3407_o = n3403_o;
      default: n3407_o = n3406_o;
    endcase
  assign n3408_o = n3189_o[3];
  assign n3409_o = n3305_o[1];
  assign n3410_o = n3353_o[1];
  assign n3411_o = data_address[5];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3412_o = n3411_o;
      13'b0100000000000: n3412_o = n3410_o;
      13'b0010000000000: n3412_o = n3411_o;
      13'b0001000000000: n3412_o = n3411_o;
      13'b0000100000000: n3412_o = n3409_o;
      13'b0000010000000: n3412_o = n3411_o;
      13'b0000001000000: n3412_o = n3411_o;
      13'b0000000100000: n3412_o = n3411_o;
      13'b0000000010000: n3412_o = n3411_o;
      13'b0000000001000: n3412_o = n3411_o;
      13'b0000000000100: n3412_o = n3411_o;
      13'b0000000000010: n3412_o = n3197_o;
      13'b0000000000001: n3412_o = n3408_o;
      default: n3412_o = n3411_o;
    endcase
  assign n3413_o = n3193_o[4:0];
  assign n3414_o = n3305_o[6:2];
  assign n3415_o = n3353_o[6:2];
  assign n3416_o = data_address[10:6];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3417_o = n3416_o;
      13'b0100000000000: n3417_o = n3415_o;
      13'b0010000000000: n3417_o = n3416_o;
      13'b0001000000000: n3417_o = n3416_o;
      13'b0000100000000: n3417_o = n3414_o;
      13'b0000010000000: n3417_o = n3416_o;
      13'b0000001000000: n3417_o = n3416_o;
      13'b0000000100000: n3417_o = n3416_o;
      13'b0000000010000: n3417_o = n3416_o;
      13'b0000000001000: n3417_o = n3416_o;
      13'b0000000000100: n3417_o = n3416_o;
      13'b0000000000010: n3417_o = n3413_o;
      13'b0000000000001: n3417_o = n3416_o;
      default: n3417_o = n3416_o;
    endcase
  assign n3418_o = n3193_o[6:5];
  assign n3419_o = n3297_o[1:0];
  assign n3420_o = data_address[12:11];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3421_o = n3420_o;
      13'b0100000000000: n3421_o = n3420_o;
      13'b0010000000000: n3421_o = n3420_o;
      13'b0001000000000: n3421_o = n3420_o;
      13'b0000100000000: n3421_o = n3420_o;
      13'b0000010000000: n3421_o = n3419_o;
      13'b0000001000000: n3421_o = n3420_o;
      13'b0000000100000: n3421_o = n3420_o;
      13'b0000000010000: n3421_o = n3420_o;
      13'b0000000001000: n3421_o = n3420_o;
      13'b0000000000100: n3421_o = n3420_o;
      13'b0000000000010: n3421_o = n3418_o;
      13'b0000000000001: n3421_o = n3420_o;
      default: n3421_o = n3420_o;
    endcase
  assign n3422_o = n3297_o[2];
  assign n3423_o = data_address[13];
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3424_o = n3423_o;
      13'b0100000000000: n3424_o = n3423_o;
      13'b0010000000000: n3424_o = n3423_o;
      13'b0001000000000: n3424_o = n3423_o;
      13'b0000100000000: n3424_o = n3423_o;
      13'b0000010000000: n3424_o = n3422_o;
      13'b0000001000000: n3424_o = n3423_o;
      13'b0000000100000: n3424_o = n3423_o;
      13'b0000000010000: n3424_o = n3423_o;
      13'b0000000001000: n3424_o = n3423_o;
      13'b0000000000100: n3424_o = n3423_o;
      13'b0000000000010: n3424_o = n3192_o;
      13'b0000000000001: n3424_o = n3423_o;
      default: n3424_o = n3423_o;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3425_o = m2_flags;
      13'b0100000000000: n3425_o = m2_flags;
      13'b0010000000000: n3425_o = m2_flags;
      13'b0001000000000: n3425_o = vram_d;
      13'b0000100000000: n3425_o = m2_flags;
      13'b0000010000000: n3425_o = m2_flags;
      13'b0000001000000: n3425_o = m2_flags;
      13'b0000000100000: n3425_o = m2_flags;
      13'b0000000010000: n3425_o = m2_flags;
      13'b0000000001000: n3425_o = m2_flags;
      13'b0000000000100: n3425_o = m2_flags;
      13'b0000000000010: n3425_o = m2_flags;
      13'b0000000000001: n3425_o = m2_flags;
      default: n3425_o = m2_flags;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3426_o = n4164_o;
      13'b0100000000000: n3426_o = enable;
      13'b0010000000000: n3426_o = enable;
      13'b0001000000000: n3426_o = enable;
      13'b0000100000000: n3426_o = enable;
      13'b0000010000000: n3426_o = enable;
      13'b0000001000000: n3426_o = n3884_o;
      13'b0000000100000: n3426_o = enable;
      13'b0000000010000: n3426_o = enable;
      13'b0000000001000: n3426_o = enable;
      13'b0000000000100: n3426_o = enable;
      13'b0000000000010: n3426_o = enable;
      13'b0000000000001: n3426_o = enable;
      default: n3426_o = enable;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3427_o = spr_x;
      13'b0100000000000: n3427_o = spr_x;
      13'b0010000000000: n3427_o = n3326_o;
      13'b0001000000000: n3427_o = spr_x;
      13'b0000100000000: n3427_o = spr_x;
      13'b0000010000000: n3427_o = spr_x;
      13'b0000001000000: n3427_o = spr_x;
      13'b0000000100000: n3427_o = spr_x;
      13'b0000000010000: n3427_o = spr_x;
      13'b0000000001000: n3427_o = spr_x;
      13'b0000000000100: n3427_o = n3709_o;
      13'b0000000000010: n3427_o = spr_x;
      13'b0000000000001: n3427_o = spr_x;
      default: n3427_o = spr_x;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3428_o = spr_d0;
      13'b0100000000000: n3428_o = n3989_o;
      13'b0010000000000: n3428_o = spr_d0;
      13'b0001000000000: n3428_o = spr_d0;
      13'b0000100000000: n3428_o = spr_d0;
      13'b0000010000000: n3428_o = spr_d0;
      13'b0000001000000: n3428_o = spr_d0;
      13'b0000000100000: n3428_o = spr_d0;
      13'b0000000010000: n3428_o = spr_d0;
      13'b0000000001000: n3428_o = n3744_o;
      13'b0000000000100: n3428_o = spr_d0;
      13'b0000000000010: n3428_o = spr_d0;
      13'b0000000000001: n3428_o = spr_d0;
      default: n3428_o = spr_d0;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3429_o = n3361_o;
      13'b0100000000000: n3429_o = n4024_o;
      13'b0010000000000: n3429_o = spr_d1;
      13'b0001000000000: n3429_o = spr_d1;
      13'b0000100000000: n3429_o = spr_d1;
      13'b0000010000000: n3429_o = spr_d1;
      13'b0000001000000: n3429_o = spr_d1;
      13'b0000000100000: n3429_o = spr_d1;
      13'b0000000010000: n3429_o = n3779_o;
      13'b0000000001000: n3429_o = spr_d1;
      13'b0000000000100: n3429_o = spr_d1;
      13'b0000000000010: n3429_o = spr_d1;
      13'b0000000000001: n3429_o = spr_d1;
      default: n3429_o = spr_d1;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3430_o = spr_d2;
      13'b0100000000000: n3430_o = n4059_o;
      13'b0010000000000: n3430_o = spr_d2;
      13'b0001000000000: n3430_o = spr_d2;
      13'b0000100000000: n3430_o = spr_d2;
      13'b0000010000000: n3430_o = spr_d2;
      13'b0000001000000: n3430_o = spr_d2;
      13'b0000000100000: n3430_o = n3814_o;
      13'b0000000010000: n3430_o = spr_d2;
      13'b0000000001000: n3430_o = spr_d2;
      13'b0000000000100: n3430_o = spr_d2;
      13'b0000000000010: n3430_o = spr_d2;
      13'b0000000000001: n3430_o = spr_d2;
      default: n3430_o = spr_d2;
    endcase
  /* ./vdp_sprites.vhd:168:41  */
  always @*
    case (n3376_o)
      13'b1000000000000: n3431_o = spr_d3;
      13'b0100000000000: n3431_o = n4094_o;
      13'b0010000000000: n3431_o = spr_d3;
      13'b0001000000000: n3431_o = spr_d3;
      13'b0000100000000: n3431_o = spr_d3;
      13'b0000010000000: n3431_o = spr_d3;
      13'b0000001000000: n3431_o = n3849_o;
      13'b0000000100000: n3431_o = spr_d3;
      13'b0000000010000: n3431_o = spr_d3;
      13'b0000000001000: n3431_o = spr_d3;
      13'b0000000000100: n3431_o = spr_d3;
      13'b0000000000010: n3431_o = spr_d3;
      13'b0000000000001: n3431_o = spr_d3;
      default: n3431_o = spr_d3;
    endcase
  /* ./vdp_sprites.vhd:156:33  */
  assign n3432_o = n3113_o ? n3672_q : n3377_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3434_o = n3113_o ? 3'b000 : n3389_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3435_o = n3113_o ? count : n3390_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3436_o = n3113_o ? index : n3391_o;
  assign n3437_o = {n3424_o, n3421_o, n3417_o, n3412_o, n3407_o, n3402_o, n3398_o, n3394_o};
  /* ./vdp_sprites.vhd:156:33  */
  assign n3438_o = n3113_o ? data_address : n3437_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3439_o = n3113_o ? m2_flags : n3425_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3440_o = n3113_o ? enable : n3426_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3441_o = n3113_o ? spr_x : n3427_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3442_o = n3113_o ? spr_d0 : n3428_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3443_o = n3113_o ? spr_d1 : n3429_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3444_o = n3113_o ? spr_d2 : n3430_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3445_o = n3113_o ? spr_d3 : n3431_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3450_o = n3111_o ? 1'b0 : n3432_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3452_o = n3111_o ? 3'b001 : n3434_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3454_o = n3111_o ? 7'b0000000 : n3435_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3456_o = n3111_o ? 6'b000000 : n3436_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3457_o = n3111_o ? data_address : n3438_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3458_o = n3111_o ? m2_flags : n3439_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3460_o = n3111_o ? 8'b00000000 : n3440_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3461_o = n3111_o ? spr_x : n3441_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3462_o = n3111_o ? spr_d0 : n3442_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3463_o = n3111_o ? spr_d1 : n3443_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3464_o = n3111_o ? spr_d2 : n3444_o;
  /* ./vdp_sprites.vhd:147:33  */
  assign n3465_o = n3111_o ? spr_d3 : n3445_o;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3469_o = ce_spload ? n3450_o : n3672_q;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3470_o = ce_spload ? n3452_o : state;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3471_o = ce_spload ? n3454_o : count;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3472_o = ce_spload ? n3456_o : index;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3473_o = ce_spload ? n3457_o : data_address;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3474_o = ce_spload ? n3458_o : m2_flags;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3475_o = ce_spload ? n3460_o : enable;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3476_o = ce_spload ? n3461_o : spr_x;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3477_o = ce_spload ? n3462_o : spr_d0;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3478_o = ce_spload ? n3463_o : spr_d1;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3479_o = ce_spload ? n3464_o : spr_d2;
  /* ./vdp_sprites.vhd:145:25  */
  assign n3480_o = ce_spload ? n3465_o : spr_d3;
  /* ./vdp_sprites.vhd:132:25  */
  assign n3485_o = ss_regs_set ? 1'b0 : n3469_o;
  /* ./vdp_sprites.vhd:132:25  */
  assign n3487_o = ss_regs_set ? 3'b000 : n3470_o;
  /* ./vdp_sprites.vhd:132:25  */
  assign n3489_o = ss_regs_set ? 7'b0000000 : n3471_o;
  /* ./vdp_sprites.vhd:132:25  */
  assign n3491_o = ss_regs_set ? 6'b000000 : n3472_o;
  /* ./vdp_sprites.vhd:132:25  */
  assign n3492_o = ss_regs_set ? data_address : n3473_o;
  /* ./vdp_sprites.vhd:132:25  */
  assign n3493_o = ss_regs_set ? m2_flags : n3474_o;
  /* ./vdp_sprites.vhd:132:25  */
  assign n3495_o = ss_regs_set ? 8'b00000000 : n3475_o;
  assign n3496_o = {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
  /* ./vdp_sprites.vhd:132:25  */
  assign n3497_o = ss_regs_set ? n3496_o : n3476_o;
  assign n3498_o = {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
  /* ./vdp_sprites.vhd:132:25  */
  assign n3499_o = ss_regs_set ? n3498_o : n3477_o;
  assign n3500_o = {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
  /* ./vdp_sprites.vhd:132:25  */
  assign n3501_o = ss_regs_set ? n3500_o : n3478_o;
  assign n3502_o = {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
  /* ./vdp_sprites.vhd:132:25  */
  assign n3503_o = ss_regs_set ? n3502_o : n3479_o;
  assign n3504_o = {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};
  /* ./vdp_sprites.vhd:132:25  */
  assign n3505_o = ss_regs_set ? n3504_o : n3480_o;
  /* ./vdp_sprites.vhd:318:50  */
  assign n3532_o = enable[0];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3533_o = spr_active[0];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3534_o = n3533_o & n3532_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3536_o = spr_color[3:0];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3538_o = n3534_o ? n3536_o : 4'b0000;
  /* ./vdp_sprites.vhd:318:41  */
  assign n3541_o = n3534_o ? 1'b1 : 1'b0;
  /* ./vdp_sprites.vhd:318:50  */
  assign n3544_o = enable[1];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3545_o = spr_active[1];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3546_o = n3545_o & n3544_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3548_o = spr_color[7:4];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3549_o = n3546_o ? n3548_o : n3538_o;
  assign n3550_o = n3542_o[6];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3551_o = n3546_o ? 1'b1 : n3550_o;
  /* ./vdp_sprites.vhd:318:50  */
  assign n3553_o = enable[2];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3554_o = spr_active[2];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3555_o = n3554_o & n3553_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3557_o = spr_color[11:8];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3558_o = n3555_o ? n3557_o : n3549_o;
  assign n3559_o = n3542_o[5];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3560_o = n3555_o ? 1'b1 : n3559_o;
  /* ./vdp_sprites.vhd:318:50  */
  assign n3562_o = enable[3];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3563_o = spr_active[3];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3564_o = n3563_o & n3562_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3566_o = spr_color[15:12];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3567_o = n3564_o ? n3566_o : n3558_o;
  assign n3568_o = n3542_o[4];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3569_o = n3564_o ? 1'b1 : n3568_o;
  /* ./vdp_sprites.vhd:318:50  */
  assign n3571_o = enable[4];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3572_o = spr_active[4];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3573_o = n3572_o & n3571_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3575_o = spr_color[19:16];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3576_o = n3573_o ? n3575_o : n3567_o;
  assign n3577_o = n3542_o[3];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3578_o = n3573_o ? 1'b1 : n3577_o;
  /* ./vdp_sprites.vhd:318:50  */
  assign n3580_o = enable[5];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3581_o = spr_active[5];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3582_o = n3581_o & n3580_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3584_o = spr_color[23:20];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3585_o = n3582_o ? n3584_o : n3576_o;
  assign n3586_o = n3542_o[2];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3587_o = n3582_o ? 1'b1 : n3586_o;
  /* ./vdp_sprites.vhd:318:50  */
  assign n3589_o = enable[6];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3590_o = spr_active[6];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3591_o = n3590_o & n3589_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3593_o = spr_color[27:24];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3594_o = n3591_o ? n3593_o : n3585_o;
  assign n3595_o = n3542_o[1];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3596_o = n3591_o ? 1'b1 : n3595_o;
  assign n3597_o = n3542_o[0];
  /* ./vdp_sprites.vhd:318:50  */
  assign n3598_o = enable[7];
  /* ./vdp_sprites.vhd:318:68  */
  assign n3599_o = spr_active[7];
  /* ./vdp_sprites.vhd:318:54  */
  assign n3600_o = n3599_o & n3598_o;
  /* ./vdp_sprites.vhd:320:67  */
  assign n3602_o = spr_color[31:28];
  /* ./vdp_sprites.vhd:318:41  */
  assign n3603_o = n3600_o ? n3602_o : n3594_o;
  /* ./vdp_sprites.vhd:318:41  */
  assign n3604_o = n3600_o ? 1'b1 : n3597_o;
  assign n3605_o = {n3541_o, n3551_o, n3560_o, n3569_o, n3578_o, n3587_o, n3596_o, n3604_o};
  /* ./vdp_sprites.vhd:324:33  */
  assign n3607_o = n3605_o == 8'b00000000;
  /* ./vdp_sprites.vhd:324:44  */
  assign n3609_o = n3605_o == 8'b00000001;
  /* ./vdp_sprites.vhd:324:44  */
  assign n3610_o = n3607_o | n3609_o;
  /* ./vdp_sprites.vhd:324:52  */
  assign n3612_o = n3605_o == 8'b00000010;
  /* ./vdp_sprites.vhd:324:52  */
  assign n3613_o = n3610_o | n3612_o;
  /* ./vdp_sprites.vhd:324:60  */
  assign n3615_o = n3605_o == 8'b00000100;
  /* ./vdp_sprites.vhd:324:60  */
  assign n3616_o = n3613_o | n3615_o;
  /* ./vdp_sprites.vhd:324:68  */
  assign n3618_o = n3605_o == 8'b00001000;
  /* ./vdp_sprites.vhd:324:68  */
  assign n3619_o = n3616_o | n3618_o;
  /* ./vdp_sprites.vhd:324:76  */
  assign n3621_o = n3605_o == 8'b00010000;
  /* ./vdp_sprites.vhd:324:76  */
  assign n3622_o = n3619_o | n3621_o;
  /* ./vdp_sprites.vhd:324:84  */
  assign n3624_o = n3605_o == 8'b00100000;
  /* ./vdp_sprites.vhd:324:84  */
  assign n3625_o = n3622_o | n3624_o;
  /* ./vdp_sprites.vhd:324:92  */
  assign n3627_o = n3605_o == 8'b01000000;
  /* ./vdp_sprites.vhd:324:92  */
  assign n3628_o = n3625_o | n3627_o;
  /* ./vdp_sprites.vhd:324:100  */
  assign n3630_o = n3605_o == 8'b10000000;
  /* ./vdp_sprites.vhd:324:100  */
  assign n3631_o = n3628_o | n3630_o;
  /* ./vdp_sprites.vhd:327:47  */
  assign n3633_o = $unsigned(y) < $unsigned(9'b011000000);
  /* ./vdp_sprites.vhd:327:57  */
  assign n3635_o = $unsigned(y) < $unsigned(9'b011100000);
  /* ./vdp_sprites.vhd:327:62  */
  assign n3636_o = smode_m1 & n3635_o;
  /* ./vdp_sprites.vhd:327:52  */
  assign n3637_o = n3633_o | n3636_o;
  /* ./vdp_sprites.vhd:327:85  */
  assign n3639_o = $unsigned(y) < $unsigned(9'b011110000);
  /* ./vdp_sprites.vhd:327:90  */
  assign n3640_o = smode_m3 & n3639_o;
  /* ./vdp_sprites.vhd:327:80  */
  assign n3641_o = n3637_o | n3640_o;
  /* ./vdp_sprites.vhd:327:112  */
  assign n3642_o = y[8];
  /* ./vdp_sprites.vhd:327:108  */
  assign n3643_o = n3641_o | n3642_o;
  /* ./vdp_sprites.vhd:327:41  */
  assign n3646_o = n3643_o ? 1'b1 : 1'b0;
  /* ./vdp_sprites.vhd:323:33  */
  always @*
    case (n3631_o)
      1'b1: n3648_o = 1'b0;
      default: n3648_o = n3646_o;
    endcase
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3657_q <= n3487_o;
  initial
    n3657_q = 3'b000;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3658_q <= n3489_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3659_q <= n3491_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3660_q <= n3492_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3661_q <= n3493_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3662_q <= n3495_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3663_q <= n3497_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3664_q <= n3499_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3665_q <= n3501_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3666_q <= n3503_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3667_q <= n3505_o;
  /* ./vdp_sprites.vhd:129:17  */
  assign n3668_o = {shifters_n1_shifter_color, shifters_n2_shifter_color, shifters_n3_shifter_color, shifters_n4_shifter_color, shifters_n5_shifter_color, shifters_n6_shifter_color, shifters_n7_shifter_color, shifters_n8_shifter_color};
  assign n3669_o = {shifters_n1_shifter_active, shifters_n2_shifter_active, shifters_n3_shifter_active, shifters_n4_shifter_active, shifters_n5_shifter_active, shifters_n6_shifter_active, shifters_n7_shifter_active, shifters_n8_shifter_active};
  /* ./vdp_sprites.vhd:308:17  */
  assign n3670_o = ce_pix ? n3648_o : n3671_q;
  /* ./vdp_sprites.vhd:308:17  */
  always @(posedge clk_sys)
    n3671_q <= n3670_o;
  /* ./vdp_sprites.vhd:129:17  */
  always @(posedge clk_sys)
    n3672_q <= n3485_o;
  /* ./vdp_sprites.vhd:308:17  */
  assign n3673_o = ce_pix ? n3603_o : n3674_q;
  /* ./vdp_sprites.vhd:308:17  */
  always @(posedge clk_sys)
    n3674_q <= n3673_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3675_o = n3202_o[2];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3676_o = ~n3675_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3677_o = n3202_o[1];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3678_o = ~n3677_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3679_o = n3676_o & n3678_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3680_o = n3676_o & n3677_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3681_o = n3675_o & n3678_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3682_o = n3675_o & n3677_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3683_o = n3202_o[0];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3684_o = ~n3683_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3685_o = n3679_o & n3684_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3686_o = n3679_o & n3683_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3687_o = n3680_o & n3684_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3688_o = n3680_o & n3683_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3689_o = n3681_o & n3684_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3690_o = n3681_o & n3683_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3691_o = n3682_o & n3684_o;
  /* ./vdp_sprites.vhd:207:49  */
  assign n3692_o = n3682_o & n3683_o;
  /* ./vdp_sprites.vhd:28:9  */
  assign n3693_o = spr_x[7:0];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3694_o = n3685_o ? n3205_o : n3693_o;
  assign n3695_o = spr_x[15:8];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3696_o = n3686_o ? n3205_o : n3695_o;
  /* ./vdp_sprites.vhd:308:17  */
  assign n3697_o = spr_x[23:16];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3698_o = n3687_o ? n3205_o : n3697_o;
  /* ./vdp_sprites.vhd:308:17  */
  assign n3699_o = spr_x[31:24];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3700_o = n3688_o ? n3205_o : n3699_o;
  assign n3701_o = spr_x[39:32];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3702_o = n3689_o ? n3205_o : n3701_o;
  assign n3703_o = spr_x[47:40];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3704_o = n3690_o ? n3205_o : n3703_o;
  assign n3705_o = spr_x[55:48];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3706_o = n3691_o ? n3205_o : n3705_o;
  assign n3707_o = spr_x[63:56];
  /* ./vdp_sprites.vhd:207:49  */
  assign n3708_o = n3692_o ? n3205_o : n3707_o;
  /* ./vdp_sprites.vhd:306:26  */
  assign n3709_o = {n3708_o, n3706_o, n3704_o, n3702_o, n3700_o, n3698_o, n3696_o, n3694_o};
  /* ./vdp_sprites.vhd:211:49  */
  assign n3710_o = n3211_o[2];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3711_o = ~n3710_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3712_o = n3211_o[1];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3713_o = ~n3712_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3714_o = n3711_o & n3713_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3715_o = n3711_o & n3712_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3716_o = n3710_o & n3713_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3717_o = n3710_o & n3712_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3718_o = n3211_o[0];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3719_o = ~n3718_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3720_o = n3714_o & n3719_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3721_o = n3714_o & n3718_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3722_o = n3715_o & n3719_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3723_o = n3715_o & n3718_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3724_o = n3716_o & n3719_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3725_o = n3716_o & n3718_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3726_o = n3717_o & n3719_o;
  /* ./vdp_sprites.vhd:211:49  */
  assign n3727_o = n3717_o & n3718_o;
  /* ./vdp_sprites.vhd:156:33  */
  assign n3728_o = spr_d0[7:0];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3729_o = n3720_o ? vram_d : n3728_o;
  /* ./vdp_sprites.vhd:127:26  */
  assign n3730_o = spr_d0[15:8];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3731_o = n3721_o ? vram_d : n3730_o;
  /* ./vdp_sprites.vhd:126:26  */
  assign n3732_o = spr_d0[23:16];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3733_o = n3722_o ? vram_d : n3732_o;
  /* ./vdp_sprites.vhd:125:26  */
  assign n3734_o = spr_d0[31:24];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3735_o = n3723_o ? vram_d : n3734_o;
  assign n3736_o = spr_d0[39:32];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3737_o = n3724_o ? vram_d : n3736_o;
  /* ./vdp_sprites.vhd:100:9  */
  assign n3738_o = spr_d0[47:40];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3739_o = n3725_o ? vram_d : n3738_o;
  assign n3740_o = spr_d0[55:48];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3741_o = n3726_o ? vram_d : n3740_o;
  assign n3742_o = spr_d0[63:56];
  /* ./vdp_sprites.vhd:211:49  */
  assign n3743_o = n3727_o ? vram_d : n3742_o;
  assign n3744_o = {n3743_o, n3741_o, n3739_o, n3737_o, n3735_o, n3733_o, n3731_o, n3729_o};
  /* ./vdp_sprites.vhd:215:49  */
  assign n3745_o = n3218_o[2];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3746_o = ~n3745_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3747_o = n3218_o[1];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3748_o = ~n3747_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3749_o = n3746_o & n3748_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3750_o = n3746_o & n3747_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3751_o = n3745_o & n3748_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3752_o = n3745_o & n3747_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3753_o = n3218_o[0];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3754_o = ~n3753_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3755_o = n3749_o & n3754_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3756_o = n3749_o & n3753_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3757_o = n3750_o & n3754_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3758_o = n3750_o & n3753_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3759_o = n3751_o & n3754_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3760_o = n3751_o & n3753_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3761_o = n3752_o & n3754_o;
  /* ./vdp_sprites.vhd:215:49  */
  assign n3762_o = n3752_o & n3753_o;
  assign n3763_o = spr_d1[7:0];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3764_o = n3755_o ? vram_d : n3763_o;
  assign n3765_o = spr_d1[15:8];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3766_o = n3756_o ? vram_d : n3765_o;
  assign n3767_o = spr_d1[23:16];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3768_o = n3757_o ? vram_d : n3767_o;
  assign n3769_o = spr_d1[31:24];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3770_o = n3758_o ? vram_d : n3769_o;
  assign n3771_o = spr_d1[39:32];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3772_o = n3759_o ? vram_d : n3771_o;
  assign n3773_o = spr_d1[47:40];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3774_o = n3760_o ? vram_d : n3773_o;
  assign n3775_o = spr_d1[55:48];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3776_o = n3761_o ? vram_d : n3775_o;
  assign n3777_o = spr_d1[63:56];
  /* ./vdp_sprites.vhd:215:49  */
  assign n3778_o = n3762_o ? vram_d : n3777_o;
  assign n3779_o = {n3778_o, n3776_o, n3774_o, n3772_o, n3770_o, n3768_o, n3766_o, n3764_o};
  /* ./vdp_sprites.vhd:219:49  */
  assign n3780_o = n3225_o[2];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3781_o = ~n3780_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3782_o = n3225_o[1];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3783_o = ~n3782_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3784_o = n3781_o & n3783_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3785_o = n3781_o & n3782_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3786_o = n3780_o & n3783_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3787_o = n3780_o & n3782_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3788_o = n3225_o[0];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3789_o = ~n3788_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3790_o = n3784_o & n3789_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3791_o = n3784_o & n3788_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3792_o = n3785_o & n3789_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3793_o = n3785_o & n3788_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3794_o = n3786_o & n3789_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3795_o = n3786_o & n3788_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3796_o = n3787_o & n3789_o;
  /* ./vdp_sprites.vhd:219:49  */
  assign n3797_o = n3787_o & n3788_o;
  assign n3798_o = spr_d2[7:0];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3799_o = n3790_o ? vram_d : n3798_o;
  assign n3800_o = spr_d2[15:8];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3801_o = n3791_o ? vram_d : n3800_o;
  assign n3802_o = spr_d2[23:16];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3803_o = n3792_o ? vram_d : n3802_o;
  assign n3804_o = spr_d2[31:24];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3805_o = n3793_o ? vram_d : n3804_o;
  assign n3806_o = spr_d2[39:32];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3807_o = n3794_o ? vram_d : n3806_o;
  assign n3808_o = spr_d2[47:40];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3809_o = n3795_o ? vram_d : n3808_o;
  assign n3810_o = spr_d2[55:48];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3811_o = n3796_o ? vram_d : n3810_o;
  assign n3812_o = spr_d2[63:56];
  /* ./vdp_sprites.vhd:219:49  */
  assign n3813_o = n3797_o ? vram_d : n3812_o;
  assign n3814_o = {n3813_o, n3811_o, n3809_o, n3807_o, n3805_o, n3803_o, n3801_o, n3799_o};
  /* ./vdp_sprites.vhd:223:49  */
  assign n3815_o = n3232_o[2];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3816_o = ~n3815_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3817_o = n3232_o[1];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3818_o = ~n3817_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3819_o = n3816_o & n3818_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3820_o = n3816_o & n3817_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3821_o = n3815_o & n3818_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3822_o = n3815_o & n3817_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3823_o = n3232_o[0];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3824_o = ~n3823_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3825_o = n3819_o & n3824_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3826_o = n3819_o & n3823_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3827_o = n3820_o & n3824_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3828_o = n3820_o & n3823_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3829_o = n3821_o & n3824_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3830_o = n3821_o & n3823_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3831_o = n3822_o & n3824_o;
  /* ./vdp_sprites.vhd:223:49  */
  assign n3832_o = n3822_o & n3823_o;
  assign n3833_o = spr_d3[7:0];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3834_o = n3825_o ? vram_d : n3833_o;
  assign n3835_o = spr_d3[15:8];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3836_o = n3826_o ? vram_d : n3835_o;
  assign n3837_o = spr_d3[23:16];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3838_o = n3827_o ? vram_d : n3837_o;
  assign n3839_o = spr_d3[31:24];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3840_o = n3828_o ? vram_d : n3839_o;
  assign n3841_o = spr_d3[39:32];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3842_o = n3829_o ? vram_d : n3841_o;
  assign n3843_o = spr_d3[47:40];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3844_o = n3830_o ? vram_d : n3843_o;
  assign n3845_o = spr_d3[55:48];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3846_o = n3831_o ? vram_d : n3845_o;
  assign n3847_o = spr_d3[63:56];
  /* ./vdp_sprites.vhd:223:49  */
  assign n3848_o = n3832_o ? vram_d : n3847_o;
  assign n3849_o = {n3848_o, n3846_o, n3844_o, n3842_o, n3840_o, n3838_o, n3836_o, n3834_o};
  /* ./vdp_sprites.vhd:224:49  */
  assign n3850_o = n3237_o[2];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3851_o = ~n3850_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3852_o = n3237_o[1];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3853_o = ~n3852_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3854_o = n3851_o & n3853_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3855_o = n3851_o & n3852_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3856_o = n3850_o & n3853_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3857_o = n3850_o & n3852_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3858_o = n3237_o[0];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3859_o = ~n3858_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3860_o = n3854_o & n3859_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3861_o = n3854_o & n3858_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3862_o = n3855_o & n3859_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3863_o = n3855_o & n3858_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3864_o = n3856_o & n3859_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3865_o = n3856_o & n3858_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3866_o = n3857_o & n3859_o;
  /* ./vdp_sprites.vhd:224:49  */
  assign n3867_o = n3857_o & n3858_o;
  assign n3868_o = enable[0];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3869_o = n3860_o ? 1'b1 : n3868_o;
  assign n3870_o = enable[1];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3871_o = n3861_o ? 1'b1 : n3870_o;
  assign n3872_o = enable[2];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3873_o = n3862_o ? 1'b1 : n3872_o;
  assign n3874_o = enable[3];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3875_o = n3863_o ? 1'b1 : n3874_o;
  assign n3876_o = enable[4];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3877_o = n3864_o ? 1'b1 : n3876_o;
  assign n3878_o = enable[5];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3879_o = n3865_o ? 1'b1 : n3878_o;
  assign n3880_o = enable[6];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3881_o = n3866_o ? 1'b1 : n3880_o;
  assign n3882_o = enable[7];
  /* ./vdp_sprites.vhd:224:49  */
  assign n3883_o = n3867_o ? 1'b1 : n3882_o;
  assign n3884_o = {n3883_o, n3881_o, n3879_o, n3877_o, n3875_o, n3873_o, n3871_o, n3869_o};
  /* ./vdp_sprites.vhd:273:57  */
  assign n3885_o = n3314_o[2];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3886_o = ~n3885_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3887_o = n3314_o[1];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3888_o = ~n3887_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3889_o = n3886_o & n3888_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3890_o = n3886_o & n3887_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3891_o = n3885_o & n3888_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3892_o = n3885_o & n3887_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3893_o = n3314_o[0];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3894_o = ~n3893_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3895_o = n3889_o & n3894_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3896_o = n3889_o & n3893_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3897_o = n3890_o & n3894_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3898_o = n3890_o & n3893_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3899_o = n3891_o & n3894_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3900_o = n3891_o & n3893_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3901_o = n3892_o & n3894_o;
  /* ./vdp_sprites.vhd:273:57  */
  assign n3902_o = n3892_o & n3893_o;
  assign n3903_o = spr_x[7:0];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3904_o = n3895_o ? n3317_o : n3903_o;
  assign n3905_o = spr_x[15:8];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3906_o = n3896_o ? n3317_o : n3905_o;
  assign n3907_o = spr_x[23:16];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3908_o = n3897_o ? n3317_o : n3907_o;
  assign n3909_o = spr_x[31:24];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3910_o = n3898_o ? n3317_o : n3909_o;
  assign n3911_o = spr_x[39:32];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3912_o = n3899_o ? n3317_o : n3911_o;
  assign n3913_o = spr_x[47:40];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3914_o = n3900_o ? n3317_o : n3913_o;
  assign n3915_o = spr_x[55:48];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3916_o = n3901_o ? n3317_o : n3915_o;
  assign n3917_o = spr_x[63:56];
  /* ./vdp_sprites.vhd:273:57  */
  assign n3918_o = n3902_o ? n3317_o : n3917_o;
  assign n3919_o = {n3918_o, n3916_o, n3914_o, n3912_o, n3910_o, n3908_o, n3906_o, n3904_o};
  /* ./vdp_sprites.vhd:275:57  */
  assign n3920_o = n3321_o[2];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3921_o = ~n3920_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3922_o = n3321_o[1];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3923_o = ~n3922_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3924_o = n3921_o & n3923_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3925_o = n3921_o & n3922_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3926_o = n3920_o & n3923_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3927_o = n3920_o & n3922_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3928_o = n3321_o[0];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3929_o = ~n3928_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3930_o = n3924_o & n3929_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3931_o = n3924_o & n3928_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3932_o = n3925_o & n3929_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3933_o = n3925_o & n3928_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3934_o = n3926_o & n3929_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3935_o = n3926_o & n3928_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3936_o = n3927_o & n3929_o;
  /* ./vdp_sprites.vhd:275:57  */
  assign n3937_o = n3927_o & n3928_o;
  assign n3938_o = spr_x[7:0];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3939_o = n3930_o ? n3324_o : n3938_o;
  assign n3940_o = spr_x[15:8];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3941_o = n3931_o ? n3324_o : n3940_o;
  assign n3942_o = spr_x[23:16];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3943_o = n3932_o ? n3324_o : n3942_o;
  assign n3944_o = spr_x[31:24];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3945_o = n3933_o ? n3324_o : n3944_o;
  assign n3946_o = spr_x[39:32];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3947_o = n3934_o ? n3324_o : n3946_o;
  assign n3948_o = spr_x[47:40];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3949_o = n3935_o ? n3324_o : n3948_o;
  assign n3950_o = spr_x[55:48];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3951_o = n3936_o ? n3324_o : n3950_o;
  assign n3952_o = spr_x[63:56];
  /* ./vdp_sprites.vhd:275:57  */
  assign n3953_o = n3937_o ? n3324_o : n3952_o;
  assign n3954_o = {n3953_o, n3951_o, n3949_o, n3947_o, n3945_o, n3943_o, n3941_o, n3939_o};
  /* ./vdp_sprites.vhd:282:49  */
  assign n3955_o = n3331_o[2];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3956_o = ~n3955_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3957_o = n3331_o[1];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3958_o = ~n3957_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3959_o = n3956_o & n3958_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3960_o = n3956_o & n3957_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3961_o = n3955_o & n3958_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3962_o = n3955_o & n3957_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3963_o = n3331_o[0];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3964_o = ~n3963_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3965_o = n3959_o & n3964_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3966_o = n3959_o & n3963_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3967_o = n3960_o & n3964_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3968_o = n3960_o & n3963_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3969_o = n3961_o & n3964_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3970_o = n3961_o & n3963_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3971_o = n3962_o & n3964_o;
  /* ./vdp_sprites.vhd:282:49  */
  assign n3972_o = n3962_o & n3963_o;
  assign n3973_o = spr_d0[7:0];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3974_o = n3965_o ? vram_d : n3973_o;
  assign n3975_o = spr_d0[15:8];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3976_o = n3966_o ? vram_d : n3975_o;
  assign n3977_o = spr_d0[23:16];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3978_o = n3967_o ? vram_d : n3977_o;
  assign n3979_o = spr_d0[31:24];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3980_o = n3968_o ? vram_d : n3979_o;
  assign n3981_o = spr_d0[39:32];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3982_o = n3969_o ? vram_d : n3981_o;
  assign n3983_o = spr_d0[47:40];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3984_o = n3970_o ? vram_d : n3983_o;
  assign n3985_o = spr_d0[55:48];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3986_o = n3971_o ? vram_d : n3985_o;
  assign n3987_o = spr_d0[63:56];
  /* ./vdp_sprites.vhd:282:49  */
  assign n3988_o = n3972_o ? vram_d : n3987_o;
  assign n3989_o = {n3988_o, n3986_o, n3984_o, n3982_o, n3980_o, n3978_o, n3976_o, n3974_o};
  /* ./vdp_sprites.vhd:283:49  */
  assign n3990_o = n3336_o[2];
  /* ./vdp_sprites.vhd:283:49  */
  assign n3991_o = ~n3990_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n3992_o = n3336_o[1];
  /* ./vdp_sprites.vhd:283:49  */
  assign n3993_o = ~n3992_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n3994_o = n3991_o & n3993_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n3995_o = n3991_o & n3992_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n3996_o = n3990_o & n3993_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n3997_o = n3990_o & n3992_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n3998_o = n3336_o[0];
  /* ./vdp_sprites.vhd:283:49  */
  assign n3999_o = ~n3998_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4000_o = n3994_o & n3999_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4001_o = n3994_o & n3998_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4002_o = n3995_o & n3999_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4003_o = n3995_o & n3998_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4004_o = n3996_o & n3999_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4005_o = n3996_o & n3998_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4006_o = n3997_o & n3999_o;
  /* ./vdp_sprites.vhd:283:49  */
  assign n4007_o = n3997_o & n3998_o;
  assign n4008_o = spr_d1[7:0];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4009_o = n4000_o ? 8'b00000000 : n4008_o;
  assign n4010_o = spr_d1[15:8];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4011_o = n4001_o ? 8'b00000000 : n4010_o;
  assign n4012_o = spr_d1[23:16];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4013_o = n4002_o ? 8'b00000000 : n4012_o;
  assign n4014_o = spr_d1[31:24];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4015_o = n4003_o ? 8'b00000000 : n4014_o;
  assign n4016_o = spr_d1[39:32];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4017_o = n4004_o ? 8'b00000000 : n4016_o;
  assign n4018_o = spr_d1[47:40];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4019_o = n4005_o ? 8'b00000000 : n4018_o;
  assign n4020_o = spr_d1[55:48];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4021_o = n4006_o ? 8'b00000000 : n4020_o;
  assign n4022_o = spr_d1[63:56];
  /* ./vdp_sprites.vhd:283:49  */
  assign n4023_o = n4007_o ? 8'b00000000 : n4022_o;
  assign n4024_o = {n4023_o, n4021_o, n4019_o, n4017_o, n4015_o, n4013_o, n4011_o, n4009_o};
  /* ./vdp_sprites.vhd:284:49  */
  assign n4025_o = n3342_o[2];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4026_o = ~n4025_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4027_o = n3342_o[1];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4028_o = ~n4027_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4029_o = n4026_o & n4028_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4030_o = n4026_o & n4027_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4031_o = n4025_o & n4028_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4032_o = n4025_o & n4027_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4033_o = n3342_o[0];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4034_o = ~n4033_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4035_o = n4029_o & n4034_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4036_o = n4029_o & n4033_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4037_o = n4030_o & n4034_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4038_o = n4030_o & n4033_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4039_o = n4031_o & n4034_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4040_o = n4031_o & n4033_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4041_o = n4032_o & n4034_o;
  /* ./vdp_sprites.vhd:284:49  */
  assign n4042_o = n4032_o & n4033_o;
  assign n4043_o = spr_d2[7:0];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4044_o = n4035_o ? 8'b00000000 : n4043_o;
  assign n4045_o = spr_d2[15:8];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4046_o = n4036_o ? 8'b00000000 : n4045_o;
  assign n4047_o = spr_d2[23:16];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4048_o = n4037_o ? 8'b00000000 : n4047_o;
  assign n4049_o = spr_d2[31:24];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4050_o = n4038_o ? 8'b00000000 : n4049_o;
  assign n4051_o = spr_d2[39:32];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4052_o = n4039_o ? 8'b00000000 : n4051_o;
  assign n4053_o = spr_d2[47:40];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4054_o = n4040_o ? 8'b00000000 : n4053_o;
  assign n4055_o = spr_d2[55:48];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4056_o = n4041_o ? 8'b00000000 : n4055_o;
  assign n4057_o = spr_d2[63:56];
  /* ./vdp_sprites.vhd:284:49  */
  assign n4058_o = n4042_o ? 8'b00000000 : n4057_o;
  assign n4059_o = {n4058_o, n4056_o, n4054_o, n4052_o, n4050_o, n4048_o, n4046_o, n4044_o};
  /* ./vdp_sprites.vhd:285:49  */
  assign n4060_o = n3348_o[2];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4061_o = ~n4060_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4062_o = n3348_o[1];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4063_o = ~n4062_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4064_o = n4061_o & n4063_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4065_o = n4061_o & n4062_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4066_o = n4060_o & n4063_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4067_o = n4060_o & n4062_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4068_o = n3348_o[0];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4069_o = ~n4068_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4070_o = n4064_o & n4069_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4071_o = n4064_o & n4068_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4072_o = n4065_o & n4069_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4073_o = n4065_o & n4068_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4074_o = n4066_o & n4069_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4075_o = n4066_o & n4068_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4076_o = n4067_o & n4069_o;
  /* ./vdp_sprites.vhd:285:49  */
  assign n4077_o = n4067_o & n4068_o;
  assign n4078_o = spr_d3[7:0];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4079_o = n4070_o ? m2_flags : n4078_o;
  assign n4080_o = spr_d3[15:8];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4081_o = n4071_o ? m2_flags : n4080_o;
  assign n4082_o = spr_d3[23:16];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4083_o = n4072_o ? m2_flags : n4082_o;
  assign n4084_o = spr_d3[31:24];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4085_o = n4073_o ? m2_flags : n4084_o;
  assign n4086_o = spr_d3[39:32];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4087_o = n4074_o ? m2_flags : n4086_o;
  assign n4088_o = spr_d3[47:40];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4089_o = n4075_o ? m2_flags : n4088_o;
  assign n4090_o = spr_d3[55:48];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4091_o = n4076_o ? m2_flags : n4090_o;
  assign n4092_o = spr_d3[63:56];
  /* ./vdp_sprites.vhd:285:49  */
  assign n4093_o = n4077_o ? m2_flags : n4092_o;
  assign n4094_o = {n4093_o, n4091_o, n4089_o, n4087_o, n4085_o, n4083_o, n4081_o, n4079_o};
  /* ./vdp_sprites.vhd:291:57  */
  assign n4095_o = n3358_o[2];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4096_o = ~n4095_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4097_o = n3358_o[1];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4098_o = ~n4097_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4099_o = n4096_o & n4098_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4100_o = n4096_o & n4097_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4101_o = n4095_o & n4098_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4102_o = n4095_o & n4097_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4103_o = n3358_o[0];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4104_o = ~n4103_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4105_o = n4099_o & n4104_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4106_o = n4099_o & n4103_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4107_o = n4100_o & n4104_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4108_o = n4100_o & n4103_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4109_o = n4101_o & n4104_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4110_o = n4101_o & n4103_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4111_o = n4102_o & n4104_o;
  /* ./vdp_sprites.vhd:291:57  */
  assign n4112_o = n4102_o & n4103_o;
  assign n4113_o = spr_d1[7:0];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4114_o = n4105_o ? vram_d : n4113_o;
  assign n4115_o = spr_d1[15:8];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4116_o = n4106_o ? vram_d : n4115_o;
  assign n4117_o = spr_d1[23:16];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4118_o = n4107_o ? vram_d : n4117_o;
  assign n4119_o = spr_d1[31:24];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4120_o = n4108_o ? vram_d : n4119_o;
  assign n4121_o = spr_d1[39:32];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4122_o = n4109_o ? vram_d : n4121_o;
  assign n4123_o = spr_d1[47:40];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4124_o = n4110_o ? vram_d : n4123_o;
  assign n4125_o = spr_d1[55:48];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4126_o = n4111_o ? vram_d : n4125_o;
  assign n4127_o = spr_d1[63:56];
  /* ./vdp_sprites.vhd:291:57  */
  assign n4128_o = n4112_o ? vram_d : n4127_o;
  assign n4129_o = {n4128_o, n4126_o, n4124_o, n4122_o, n4120_o, n4118_o, n4116_o, n4114_o};
  /* ./vdp_sprites.vhd:293:49  */
  assign n4130_o = n3364_o[2];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4131_o = ~n4130_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4132_o = n3364_o[1];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4133_o = ~n4132_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4134_o = n4131_o & n4133_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4135_o = n4131_o & n4132_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4136_o = n4130_o & n4133_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4137_o = n4130_o & n4132_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4138_o = n3364_o[0];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4139_o = ~n4138_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4140_o = n4134_o & n4139_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4141_o = n4134_o & n4138_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4142_o = n4135_o & n4139_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4143_o = n4135_o & n4138_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4144_o = n4136_o & n4139_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4145_o = n4136_o & n4138_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4146_o = n4137_o & n4139_o;
  /* ./vdp_sprites.vhd:293:49  */
  assign n4147_o = n4137_o & n4138_o;
  assign n4148_o = enable[0];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4149_o = n4140_o ? 1'b1 : n4148_o;
  assign n4150_o = enable[1];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4151_o = n4141_o ? 1'b1 : n4150_o;
  assign n4152_o = enable[2];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4153_o = n4142_o ? 1'b1 : n4152_o;
  assign n4154_o = enable[3];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4155_o = n4143_o ? 1'b1 : n4154_o;
  assign n4156_o = enable[4];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4157_o = n4144_o ? 1'b1 : n4156_o;
  assign n4158_o = enable[5];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4159_o = n4145_o ? 1'b1 : n4158_o;
  assign n4160_o = enable[6];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4161_o = n4146_o ? 1'b1 : n4160_o;
  assign n4162_o = enable[7];
  /* ./vdp_sprites.vhd:293:49  */
  assign n4163_o = n4147_o ? 1'b1 : n4162_o;
  assign n4164_o = {n4163_o, n4161_o, n4159_o, n4157_o, n4155_o, n4153_o, n4151_o, n4149_o};
endmodule

module vdp_background
  (input  clk_sys,
   input  ce_pix,
   input  reset,
   input  [8:0] screen_x,
   input  [3:0] table_address,
   input  [2:0] pt_address,
   input  [7:0] ct_address,
   input  [7:0] scroll_x_latched,
   input  disable_hscroll,
   input  mode_m1_raw,
   input  mode_m2_raw,
   input  mode_m3_raw,
   input  smode_m1,
   input  smode_m3,
   input  smode_m4,
   input  ysj_quirk,
   input  legacy_ext_nt,
   input  [7:0] y,
   input  [8:0] screen_y,
   input  [3:0] text_fg_color,
   input  [3:0] overscan,
   input  ss_restore,
   input  [7:0] vram_d,
   output [13:0] vram_a,
   output [4:0] color,
   output priority);
  wire [8:0] tile_index;
  wire [7:0] x;
  wire [2:0] tile_y;
  wire palette;
  wire palette_shift;
  wire priority_latch;
  wire flip_x;
  wire [7:0] datac;
  wire [7:0] data0;
  wire [7:0] data1;
  wire [7:0] data2;
  wire [7:0] data3;
  wire [7:0] shift0;
  wire [7:0] shift1;
  wire [7:0] shift2;
  wire [7:0] shift3;
  reg [5:0] text_shift;
  reg [7:0] text_tile_index;
  reg [7:0] text_pattern;
  reg [2:0] text_phase;
  reg [5:0] text_column;
  wire text_mode;
  wire gfx1_mode;
  wire n1681_o;
  wire n1682_o;
  wire n1683_o;
  wire n1684_o;
  wire n1685_o;
  wire n1686_o;
  wire n1687_o;
  wire n1690_o;
  wire n1691_o;
  wire n1692_o;
  wire n1693_o;
  wire n1694_o;
  wire n1695_o;
  wire n1696_o;
  wire n1697_o;
  wire n1702_o;
  wire n1703_o;
  wire n1705_o;
  wire n1706_o;
  wire [7:0] n1708_o;
  wire [7:0] n1710_o;
  wire [7:0] n1712_o;
  wire n1713_o;
  wire n1714_o;
  wire n1716_o;
  wire n1717_o;
  wire [7:0] n1719_o;
  wire [7:0] n1721_o;
  wire [7:0] n1723_o;
  wire [7:0] n1725_o;
  wire [7:0] n1726_o;
  wire [7:0] n1727_o;
  wire [7:0] n1728_o;
  wire n1734_o;
  wire n1735_o;
  wire [31:0] n1736_o;
  wire n1738_o;
  wire [31:0] n1739_o;
  wire n1741_o;
  wire [31:0] n1742_o;
  wire n1744_o;
  wire n1745_o;
  wire n1747_o;
  wire [5:0] n1749_o;
  wire [2:0] n1751_o;
  wire [2:0] n1753_o;
  wire [5:0] n1754_o;
  wire [2:0] n1756_o;
  wire [5:0] n1758_o;
  wire [2:0] n1760_o;
  wire [5:0] n1762_o;
  wire [2:0] n1764_o;
  wire [5:0] n1766_o;
  wire [2:0] n1767_o;
  wire [5:0] n1768_o;
  wire [2:0] n1770_o;
  wire [5:0] n1772_o;
  wire [31:0] n1784_o;
  wire [4:0] n1785_o;
  wire [31:0] n1786_o;
  wire n1788_o;
  wire [31:0] n1790_o;
  wire [9:0] n1791_o;
  wire [13:0] n1792_o;
  wire n1794_o;
  wire [10:0] n1795_o;
  wire [2:0] n1796_o;
  wire [13:0] n1797_o;
  wire n1799_o;
  wire [1:0] n1800_o;
  reg [13:0] n1801_o;
  wire n1803_o;
  wire n1805_o;
  wire n1806_o;
  wire n1808_o;
  wire [31:0] n1810_o;
  wire [31:0] n1811_o;
  wire [31:0] n1812_o;
  wire [31:0] n1814_o;
  wire [9:0] n1815_o;
  wire [13:0] n1816_o;
  wire [13:0] n1817_o;
  wire n1820_o;
  wire n1822_o;
  wire [10:0] n1823_o;
  wire [2:0] n1824_o;
  wire [13:0] n1825_o;
  wire [13:0] n1826_o;
  wire n1828_o;
  wire [1:0] n1829_o;
  reg [13:0] n1830_o;
  wire [13:0] n1832_o;
  wire [13:0] n1834_o;
  wire n1836_o;
  wire n1837_o;
  wire n1838_o;
  wire [1:0] n1839_o;
  wire [4:0] n1840_o;
  wire [5:0] n1842_o;
  wire [5:0] n1843_o;
  wire [7:0] n1844_o;
  wire [2:0] n1845_o;
  wire n1846_o;
  wire n1847_o;
  wire n1848_o;
  wire [3:0] n1849_o;
  wire n1850_o;
  wire [3:0] n1851_o;
  wire [4:0] n1852_o;
  wire [4:0] n1853_o;
  wire [4:0] n1854_o;
  wire [7:0] n1855_o;
  wire [7:0] n1856_o;
  wire [4:0] n1857_o;
  wire [4:0] n1859_o;
  wire [11:0] n1860_o;
  wire [2:0] n1861_o;
  wire [12:0] n1862_o;
  wire [13:0] n1864_o;
  wire n1866_o;
  wire [12:0] n1867_o;
  wire [13:0] n1869_o;
  wire n1871_o;
  wire [13:0] n1873_o;
  wire n1875_o;
  wire [13:0] n1877_o;
  wire n1879_o;
  wire [13:0] n1881_o;
  wire n1883_o;
  wire [13:0] n1885_o;
  wire n1887_o;
  wire [5:0] n1888_o;
  reg [13:0] n1889_o;
  wire [2:0] n1890_o;
  wire [4:0] n1891_o;
  wire [8:0] n1892_o;
  wire [4:0] n1893_o;
  wire [13:0] n1894_o;
  wire n1896_o;
  wire [7:0] n1897_o;
  wire [10:0] n1898_o;
  wire [2:0] n1899_o;
  wire [13:0] n1900_o;
  wire n1901_o;
  wire [1:0] n1902_o;
  wire [1:0] n1903_o;
  wire [1:0] n1904_o;
  wire [2:0] n1905_o;
  wire [7:0] n1906_o;
  wire [10:0] n1907_o;
  wire [2:0] n1908_o;
  wire [13:0] n1909_o;
  wire [13:0] n1910_o;
  wire n1912_o;
  wire [8:0] n1914_o;
  wire [4:0] n1915_o;
  wire [13:0] n1916_o;
  wire n1917_o;
  wire [1:0] n1918_o;
  wire [4:0] n1919_o;
  wire [6:0] n1920_o;
  wire [6:0] n1921_o;
  wire [6:0] n1922_o;
  wire [7:0] n1923_o;
  wire [2:0] n1924_o;
  wire [10:0] n1925_o;
  wire [2:0] n1926_o;
  wire [13:0] n1927_o;
  wire [13:0] n1928_o;
  wire n1930_o;
  wire [2:0] n1931_o;
  reg [13:0] n1932_o;
  wire [13:0] n1933_o;
  wire [13:0] n1937_o;
  wire [31:0] n1964_o;
  wire n1966_o;
  wire [31:0] n1967_o;
  wire n1969_o;
  wire [31:0] n1970_o;
  wire n1972_o;
  wire [31:0] n1973_o;
  wire n1975_o;
  wire n1976_o;
  wire n1978_o;
  wire [7:0] n1979_o;
  wire n1981_o;
  wire n1983_o;
  wire [7:0] n1984_o;
  wire n1986_o;
  wire [1:0] n1987_o;
  reg [7:0] n1988_o;
  reg [7:0] n1989_o;
  wire [7:0] n1990_o;
  wire [7:0] n1991_o;
  wire [7:0] n1992_o;
  wire [7:0] n1993_o;
  wire [7:0] n1994_o;
  wire [7:0] n1995_o;
  wire [2:0] n1996_o;
  wire n1998_o;
  wire n1999_o;
  wire n2000_o;
  wire n2001_o;
  wire n2002_o;
  wire n2003_o;
  wire n2004_o;
  wire n2005_o;
  wire n2006_o;
  wire n2007_o;
  wire n2008_o;
  wire n2009_o;
  wire n2010_o;
  wire n2011_o;
  wire n2013_o;
  wire n2015_o;
  wire n2017_o;
  wire n2019_o;
  wire [4:0] n2020_o;
  wire [7:0] n2021_o;
  reg [7:0] n2022_o;
  wire n2023_o;
  reg n2024_o;
  wire n2025_o;
  reg n2026_o;
  wire n2027_o;
  reg n2028_o;
  wire n2029_o;
  reg n2030_o;
  reg n2031_o;
  reg n2032_o;
  reg n2033_o;
  reg [7:0] n2034_o;
  reg [7:0] n2035_o;
  reg [7:0] n2036_o;
  wire [2:0] n2037_o;
  wire n2039_o;
  wire n2041_o;
  wire n2042_o;
  wire n2043_o;
  wire n2044_o;
  wire n2045_o;
  wire n2046_o;
  wire n2047_o;
  wire n2048_o;
  wire n2049_o;
  wire n2050_o;
  wire n2051_o;
  wire n2052_o;
  wire n2053_o;
  wire n2054_o;
  wire n2055_o;
  wire n2056_o;
  wire n2057_o;
  wire n2058_o;
  wire n2059_o;
  wire n2060_o;
  wire n2061_o;
  wire n2062_o;
  wire n2063_o;
  wire n2064_o;
  wire n2065_o;
  wire n2066_o;
  wire n2067_o;
  wire n2068_o;
  wire n2069_o;
  wire n2070_o;
  wire n2071_o;
  wire n2072_o;
  wire n2073_o;
  wire n2074_o;
  wire n2075_o;
  wire n2076_o;
  wire n2077_o;
  wire n2078_o;
  wire n2079_o;
  wire n2080_o;
  wire n2081_o;
  wire n2082_o;
  wire n2083_o;
  wire n2084_o;
  wire n2085_o;
  wire n2086_o;
  wire n2087_o;
  wire n2088_o;
  wire n2089_o;
  wire n2090_o;
  wire n2091_o;
  wire n2092_o;
  wire n2093_o;
  wire n2094_o;
  wire n2095_o;
  wire n2096_o;
  wire n2097_o;
  wire n2098_o;
  wire n2099_o;
  wire n2100_o;
  wire n2101_o;
  wire n2102_o;
  wire n2103_o;
  wire n2104_o;
  wire n2105_o;
  wire n2106_o;
  wire n2107_o;
  wire n2108_o;
  wire n2109_o;
  wire n2110_o;
  wire n2111_o;
  wire n2112_o;
  wire n2113_o;
  wire n2114_o;
  wire n2115_o;
  wire n2116_o;
  wire n2117_o;
  wire n2118_o;
  wire n2119_o;
  wire n2120_o;
  wire n2121_o;
  wire n2122_o;
  wire n2123_o;
  wire n2124_o;
  wire n2125_o;
  wire n2126_o;
  wire n2127_o;
  wire n2128_o;
  wire n2129_o;
  wire n2130_o;
  wire n2131_o;
  wire n2132_o;
  wire n2133_o;
  wire n2134_o;
  wire n2135_o;
  wire n2136_o;
  wire n2137_o;
  wire n2138_o;
  wire n2139_o;
  wire n2140_o;
  wire n2141_o;
  wire n2142_o;
  wire n2143_o;
  wire n2144_o;
  wire n2145_o;
  wire n2146_o;
  wire n2147_o;
  wire n2148_o;
  wire n2149_o;
  wire n2150_o;
  wire n2151_o;
  wire n2152_o;
  wire n2153_o;
  wire n2154_o;
  wire n2155_o;
  wire n2156_o;
  wire n2157_o;
  wire n2158_o;
  wire n2159_o;
  wire n2160_o;
  wire n2161_o;
  wire n2162_o;
  wire n2163_o;
  wire n2164_o;
  wire n2165_o;
  wire n2166_o;
  wire n2167_o;
  wire n2168_o;
  wire n2169_o;
  wire n2170_o;
  wire n2171_o;
  wire n2172_o;
  wire n2173_o;
  wire n2174_o;
  wire n2175_o;
  wire n2176_o;
  wire n2177_o;
  wire n2178_o;
  wire n2179_o;
  wire n2180_o;
  wire n2181_o;
  wire n2182_o;
  wire n2183_o;
  wire n2184_o;
  wire n2185_o;
  wire n2186_o;
  wire n2187_o;
  wire n2188_o;
  wire n2189_o;
  wire n2190_o;
  wire n2191_o;
  wire n2192_o;
  wire n2193_o;
  wire n2194_o;
  wire n2195_o;
  wire n2196_o;
  wire n2197_o;
  wire n2198_o;
  wire n2199_o;
  wire n2200_o;
  wire n2201_o;
  wire n2202_o;
  wire n2203_o;
  wire n2204_o;
  wire n2205_o;
  wire n2206_o;
  wire n2207_o;
  wire n2208_o;
  wire n2209_o;
  wire n2210_o;
  wire n2211_o;
  wire n2212_o;
  wire n2213_o;
  wire n2214_o;
  wire n2215_o;
  wire n2216_o;
  wire n2217_o;
  wire n2218_o;
  wire n2219_o;
  wire n2220_o;
  wire n2221_o;
  wire n2222_o;
  wire n2223_o;
  wire n2224_o;
  wire n2225_o;
  wire n2226_o;
  wire n2227_o;
  wire n2228_o;
  wire n2229_o;
  wire n2230_o;
  wire n2231_o;
  wire n2232_o;
  wire n2233_o;
  wire n2234_o;
  wire n2235_o;
  wire n2236_o;
  wire n2237_o;
  wire n2238_o;
  wire n2239_o;
  wire n2240_o;
  wire n2241_o;
  wire n2242_o;
  wire n2243_o;
  wire n2244_o;
  wire n2245_o;
  wire n2246_o;
  wire n2247_o;
  wire n2248_o;
  wire n2249_o;
  wire n2250_o;
  wire n2251_o;
  wire n2252_o;
  wire n2253_o;
  wire n2254_o;
  wire n2255_o;
  wire n2256_o;
  wire n2257_o;
  wire n2258_o;
  wire n2259_o;
  wire n2260_o;
  wire n2261_o;
  wire n2262_o;
  wire n2263_o;
  wire n2264_o;
  wire n2265_o;
  wire n2266_o;
  wire n2267_o;
  wire n2268_o;
  wire n2269_o;
  wire n2270_o;
  wire n2271_o;
  wire n2272_o;
  wire n2273_o;
  wire n2274_o;
  wire n2275_o;
  wire n2276_o;
  wire n2277_o;
  wire n2278_o;
  wire n2279_o;
  wire n2280_o;
  wire n2281_o;
  wire n2282_o;
  wire n2283_o;
  wire n2284_o;
  wire n2285_o;
  wire n2286_o;
  wire n2287_o;
  wire n2288_o;
  wire n2289_o;
  wire n2290_o;
  wire n2291_o;
  wire n2292_o;
  wire n2293_o;
  wire n2294_o;
  wire n2295_o;
  wire n2296_o;
  wire n2297_o;
  wire n2299_o;
  wire [2:0] n2300_o;
  wire [7:0] n2301_o;
  reg [7:0] n2302_o;
  reg n2304_o;
  reg n2306_o;
  reg n2308_o;
  reg [7:0] n2309_o;
  wire n2310_o;
  reg n2311_o;
  wire n2312_o;
  reg n2313_o;
  wire n2314_o;
  reg n2315_o;
  wire n2316_o;
  reg n2317_o;
  wire n2318_o;
  reg n2319_o;
  wire n2320_o;
  reg n2321_o;
  wire n2322_o;
  reg n2323_o;
  wire n2324_o;
  reg n2325_o;
  wire n2326_o;
  reg n2327_o;
  wire n2328_o;
  reg n2329_o;
  wire n2330_o;
  reg n2331_o;
  wire n2332_o;
  reg n2333_o;
  wire n2334_o;
  reg n2335_o;
  wire n2336_o;
  reg n2337_o;
  wire n2338_o;
  reg n2339_o;
  wire n2340_o;
  reg n2341_o;
  wire n2342_o;
  reg n2343_o;
  wire n2344_o;
  reg n2345_o;
  wire n2346_o;
  reg n2347_o;
  wire n2348_o;
  reg n2349_o;
  wire n2350_o;
  reg n2351_o;
  wire n2352_o;
  reg n2353_o;
  wire n2354_o;
  reg n2355_o;
  wire n2356_o;
  reg n2357_o;
  wire n2358_o;
  reg n2359_o;
  wire n2360_o;
  reg n2361_o;
  wire n2362_o;
  reg n2363_o;
  wire n2364_o;
  reg n2365_o;
  wire n2366_o;
  reg n2367_o;
  wire n2368_o;
  reg n2369_o;
  wire n2370_o;
  reg n2371_o;
  wire n2372_o;
  reg n2373_o;
  wire [8:0] n2374_o;
  wire [7:0] n2375_o;
  wire [7:0] n2376_o;
  wire n2377_o;
  wire n2378_o;
  wire n2379_o;
  wire [2:0] n2380_o;
  wire [2:0] n2381_o;
  wire n2382_o;
  wire n2383_o;
  wire n2384_o;
  wire [7:0] n2385_o;
  wire [7:0] n2386_o;
  wire [7:0] n2387_o;
  wire [7:0] n2388_o;
  wire [7:0] n2389_o;
  wire [7:0] n2390_o;
  wire [7:0] n2391_o;
  wire [7:0] n2392_o;
  wire [7:0] n2393_o;
  wire [8:0] n2394_o;
  wire [8:0] n2395_o;
  wire [2:0] n2396_o;
  wire n2397_o;
  wire n2398_o;
  wire n2399_o;
  wire [7:0] n2400_o;
  wire [7:0] n2401_o;
  wire [7:0] n2402_o;
  wire [7:0] n2403_o;
  wire [7:0] n2404_o;
  wire [7:0] n2405_o;
  wire [7:0] n2406_o;
  wire [8:0] n2407_o;
  wire [2:0] n2408_o;
  wire n2409_o;
  wire n2410_o;
  wire n2411_o;
  wire [7:0] n2412_o;
  wire [7:0] n2413_o;
  wire [7:0] n2414_o;
  wire [7:0] n2415_o;
  wire [7:0] n2416_o;
  wire n2417_o;
  wire n2418_o;
  wire [8:0] n2420_o;
  wire [2:0] n2422_o;
  wire n2424_o;
  wire n2426_o;
  wire n2428_o;
  wire [7:0] n2430_o;
  wire [7:0] n2432_o;
  wire [7:0] n2434_o;
  wire [7:0] n2436_o;
  wire [7:0] n2438_o;
  wire [7:0] n2440_o;
  wire [7:0] n2442_o;
  wire [31:0] n2459_o;
  wire n2461_o;
  wire [5:0] n2462_o;
  wire [31:0] n2463_o;
  wire n2465_o;
  wire [31:0] n2466_o;
  wire n2468_o;
  wire n2469_o;
  wire n2471_o;
  wire [5:0] n2472_o;
  wire [4:0] n2473_o;
  wire n2476_o;
  wire [5:0] n2477_o;
  wire [5:0] n2478_o;
  wire n2480_o;
  wire [5:0] n2482_o;
  wire n2484_o;
  wire [5:0] n2485_o;
  wire [2:0] n2486_o;
  wire n2487_o;
  wire [7:0] n2488_o;
  wire n2489_o;
  wire n2490_o;
  wire [1:0] n2491_o;
  wire n2492_o;
  wire [2:0] n2493_o;
  wire n2494_o;
  wire [3:0] n2495_o;
  wire n2496_o;
  wire [4:0] n2497_o;
  wire n2498_o;
  wire [5:0] n2499_o;
  wire n2500_o;
  wire [6:0] n2501_o;
  wire n2502_o;
  wire [7:0] n2503_o;
  wire n2504_o;
  wire n2505_o;
  wire [1:0] n2506_o;
  wire n2507_o;
  wire [2:0] n2508_o;
  wire n2509_o;
  wire [3:0] n2510_o;
  wire n2511_o;
  wire [4:0] n2512_o;
  wire n2513_o;
  wire [5:0] n2514_o;
  wire n2515_o;
  wire [6:0] n2516_o;
  wire n2517_o;
  wire [7:0] n2518_o;
  wire n2519_o;
  wire n2520_o;
  wire [1:0] n2521_o;
  wire n2522_o;
  wire [2:0] n2523_o;
  wire n2524_o;
  wire [3:0] n2525_o;
  wire n2526_o;
  wire [4:0] n2527_o;
  wire n2528_o;
  wire [5:0] n2529_o;
  wire n2530_o;
  wire [6:0] n2531_o;
  wire n2532_o;
  wire [7:0] n2533_o;
  wire n2534_o;
  wire n2535_o;
  wire [1:0] n2536_o;
  wire n2537_o;
  wire [2:0] n2538_o;
  wire n2539_o;
  wire [3:0] n2540_o;
  wire n2541_o;
  wire [4:0] n2542_o;
  wire n2543_o;
  wire [5:0] n2544_o;
  wire n2545_o;
  wire [6:0] n2546_o;
  wire n2547_o;
  wire [7:0] n2548_o;
  wire [7:0] n2549_o;
  wire [7:0] n2550_o;
  wire [7:0] n2551_o;
  wire [7:0] n2552_o;
  wire n2554_o;
  wire [6:0] n2555_o;
  wire [6:0] n2556_o;
  wire [6:0] n2557_o;
  wire [6:0] n2558_o;
  reg n2559_o;
  reg n2560_o;
  wire n2561_o;
  wire n2562_o;
  reg n2563_o;
  wire [6:0] n2564_o;
  reg [6:0] n2565_o;
  wire n2566_o;
  wire n2567_o;
  reg n2568_o;
  wire [6:0] n2569_o;
  reg [6:0] n2570_o;
  wire n2571_o;
  wire n2572_o;
  reg n2573_o;
  wire [6:0] n2574_o;
  reg [6:0] n2575_o;
  wire n2576_o;
  wire n2577_o;
  reg n2578_o;
  wire [6:0] n2579_o;
  reg [6:0] n2580_o;
  wire n2581_o;
  wire n2582_o;
  wire [7:0] n2583_o;
  wire [7:0] n2584_o;
  wire [7:0] n2585_o;
  wire [7:0] n2586_o;
  wire [7:0] n2587_o;
  wire [7:0] n2588_o;
  wire [7:0] n2589_o;
  wire [7:0] n2590_o;
  wire [5:0] n2591_o;
  wire n2592_o;
  wire n2593_o;
  wire [7:0] n2594_o;
  wire [7:0] n2595_o;
  wire [7:0] n2596_o;
  wire [7:0] n2597_o;
  wire n2598_o;
  wire n2600_o;
  wire n2602_o;
  wire [7:0] n2604_o;
  wire [7:0] n2606_o;
  wire [7:0] n2608_o;
  wire [7:0] n2610_o;
  wire [5:0] n2612_o;
  wire n2621_o;
  wire n2622_o;
  wire n2623_o;
  wire n2624_o;
  wire n2625_o;
  wire n2626_o;
  wire n2627_o;
  wire n2628_o;
  wire n2629_o;
  wire n2630_o;
  wire n2631_o;
  wire n2632_o;
  wire n2633_o;
  wire n2634_o;
  wire n2635_o;
  wire n2636_o;
  wire n2637_o;
  wire n2638_o;
  wire n2639_o;
  wire n2640_o;
  wire n2641_o;
  wire n2642_o;
  wire n2643_o;
  wire n2644_o;
  wire n2645_o;
  wire n2646_o;
  wire n2647_o;
  wire n2648_o;
  wire n2650_o;
  reg [8:0] n2651_q;
  reg [7:0] n2652_q;
  reg [2:0] n2653_q;
  reg n2654_q;
  reg n2655_q;
  reg n2656_q;
  reg n2657_q;
  reg [7:0] n2658_q;
  reg [7:0] n2659_q;
  reg [7:0] n2660_q;
  reg [7:0] n2661_q;
  reg [7:0] n2662_q;
  reg [7:0] n2663_q;
  reg [7:0] n2664_q;
  reg [7:0] n2665_q;
  reg [7:0] n2666_q;
  reg [5:0] n2667_q;
  reg [7:0] n2668_q;
  reg [7:0] n2669_q;
  reg [2:0] n2670_q;
  reg [5:0] n2671_q;
  wire [13:0] n2672_o;
  reg [13:0] n2673_q;
  wire [4:0] n2674_o;
  reg n2675_q;
  assign vram_a = n2673_q;
  assign color = n2674_o;
  assign priority = n2675_q;
  /* ./vdp_background.vhd:41:16  */
  assign tile_index = n2651_q; // (signal)
  /* ./vdp_background.vhd:42:16  */
  assign x = n2652_q; // (signal)
  /* ./vdp_background.vhd:43:16  */
  assign tile_y = n2653_q; // (signal)
  /* ./vdp_background.vhd:44:16  */
  assign palette = n2654_q; // (signal)
  /* ./vdp_background.vhd:45:16  */
  assign palette_shift = n2655_q; // (signal)
  /* ./vdp_background.vhd:46:16  */
  assign priority_latch = n2656_q; // (signal)
  /* ./vdp_background.vhd:47:16  */
  assign flip_x = n2657_q; // (signal)
  /* ./vdp_background.vhd:54:16  */
  assign datac = n2658_q; // (signal)
  /* ./vdp_background.vhd:55:16  */
  assign data0 = n2659_q; // (signal)
  /* ./vdp_background.vhd:56:16  */
  assign data1 = n2660_q; // (signal)
  /* ./vdp_background.vhd:57:16  */
  assign data2 = n2661_q; // (signal)
  /* ./vdp_background.vhd:58:16  */
  assign data3 = n2662_q; // (signal)
  /* ./vdp_background.vhd:60:16  */
  assign shift0 = n2663_q; // (signal)
  /* ./vdp_background.vhd:61:16  */
  assign shift1 = n2664_q; // (signal)
  /* ./vdp_background.vhd:62:16  */
  assign shift2 = n2665_q; // (signal)
  /* ./vdp_background.vhd:63:16  */
  assign shift3 = n2666_q; // (signal)
  /* ./vdp_background.vhd:65:16  */
  always @*
    text_shift = n2667_q; // (isignal)
  initial
    text_shift = 6'b000000;
  /* ./vdp_background.vhd:66:16  */
  always @*
    text_tile_index = n2668_q; // (isignal)
  initial
    text_tile_index = 8'b00000000;
  /* ./vdp_background.vhd:67:16  */
  always @*
    text_pattern = n2669_q; // (isignal)
  initial
    text_pattern = 8'b00000000;
  /* ./vdp_background.vhd:68:16  */
  always @*
    text_phase = n2670_q; // (isignal)
  initial
    text_phase = 3'b000;
  /* ./vdp_background.vhd:69:16  */
  always @*
    text_column = n2671_q; // (isignal)
  initial
    text_column = 6'b000000;
  /* ./vdp_background.vhd:71:16  */
  assign text_mode = n1687_o; // (signal)
  /* ./vdp_background.vhd:72:16  */
  assign gfx1_mode = n1697_o; // (signal)
  /* ./vdp_background.vhd:76:39  */
  assign n1681_o = ~smode_m4;
  /* ./vdp_background.vhd:76:44  */
  assign n1682_o = mode_m1_raw & n1681_o;
  /* ./vdp_background.vhd:76:79  */
  assign n1683_o = ~mode_m2_raw;
  /* ./vdp_background.vhd:76:64  */
  assign n1684_o = n1683_o & n1682_o;
  /* ./vdp_background.vhd:76:99  */
  assign n1685_o = ~mode_m3_raw;
  /* ./vdp_background.vhd:76:84  */
  assign n1686_o = n1685_o & n1684_o;
  /* ./vdp_background.vhd:76:26  */
  assign n1687_o = n1686_o ? 1'b1 : 1'b0;
  /* ./vdp_background.vhd:77:39  */
  assign n1690_o = ~smode_m4;
  /* ./vdp_background.vhd:77:59  */
  assign n1691_o = ~mode_m1_raw;
  /* ./vdp_background.vhd:77:44  */
  assign n1692_o = n1691_o & n1690_o;
  /* ./vdp_background.vhd:77:79  */
  assign n1693_o = ~mode_m2_raw;
  /* ./vdp_background.vhd:77:64  */
  assign n1694_o = n1693_o & n1692_o;
  /* ./vdp_background.vhd:77:99  */
  assign n1695_o = ~mode_m3_raw;
  /* ./vdp_background.vhd:77:84  */
  assign n1696_o = n1695_o & n1694_o;
  /* ./vdp_background.vhd:77:26  */
  assign n1697_o = n1696_o ? 1'b1 : 1'b0;
  /* ./vdp_background.vhd:85:44  */
  assign n1702_o = ~smode_m4;
  /* ./vdp_background.vhd:87:54  */
  assign n1703_o = ~disable_hscroll;
  /* ./vdp_background.vhd:87:70  */
  assign n1705_o = $unsigned(screen_y) >= $unsigned(9'b000010000);
  /* ./vdp_background.vhd:87:59  */
  assign n1706_o = n1703_o | n1705_o;
  /* ./vdp_background.vhd:88:49  */
  assign n1708_o = 8'b11101000 - scroll_x_latched;
  /* ./vdp_background.vhd:87:33  */
  assign n1710_o = n1706_o ? n1708_o : 8'b11101000;
  /* ./vdp_background.vhd:85:33  */
  assign n1712_o = n1702_o ? 8'b11110000 : n1710_o;
  /* ./vdp_background.vhd:94:52  */
  assign n1713_o = ~smode_m4;
  /* ./vdp_background.vhd:101:62  */
  assign n1714_o = ~disable_hscroll;
  /* ./vdp_background.vhd:101:78  */
  assign n1716_o = $unsigned(screen_y) >= $unsigned(9'b000010000);
  /* ./vdp_background.vhd:101:67  */
  assign n1717_o = n1714_o | n1716_o;
  /* ./vdp_background.vhd:104:57  */
  assign n1719_o = 8'b11101000 - scroll_x_latched;
  /* ./vdp_background.vhd:101:41  */
  assign n1721_o = n1717_o ? n1719_o : 8'b11101000;
  /* ./vdp_background.vhd:94:41  */
  assign n1723_o = n1713_o ? 8'b11110000 : n1721_o;
  /* ./vdp_background.vhd:109:48  */
  assign n1725_o = x + 8'b00000001;
  /* ./vdp_background.vhd:93:33  */
  assign n1726_o = reset ? n1723_o : n1725_o;
  /* ./vdp_background.vhd:92:25  */
  assign n1727_o = ce_pix ? n1726_o : x;
  /* ./vdp_background.vhd:84:25  */
  assign n1728_o = ss_restore ? n1712_o : n1727_o;
  /* ./vdp_background.vhd:124:58  */
  assign n1734_o = ~text_mode;
  /* ./vdp_background.vhd:124:46  */
  assign n1735_o = reset | n1734_o;
  /* ./vdp_background.vhd:127:39  */
  assign n1736_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:127:61  */
  assign n1738_o = n1736_o == 32'b00000000000000000000000000000111;
  /* ./vdp_background.vhd:130:39  */
  assign n1739_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:130:61  */
  assign n1741_o = $signed(n1739_o) >= $signed(32'b00000000000000000000000000001000);
  /* ./vdp_background.vhd:130:69  */
  assign n1742_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:130:91  */
  assign n1744_o = $signed(n1742_o) < $signed(32'b00000000000000000000000011110111);
  /* ./vdp_background.vhd:130:65  */
  assign n1745_o = n1744_o & n1741_o;
  /* ./vdp_background.vhd:131:54  */
  assign n1747_o = text_phase == 3'b101;
  /* ./vdp_background.vhd:133:76  */
  assign n1749_o = text_column + 6'b000001;
  /* ./vdp_background.vhd:135:74  */
  assign n1751_o = text_phase + 3'b001;
  /* ./vdp_background.vhd:131:41  */
  assign n1753_o = n1747_o ? 3'b000 : n1751_o;
  /* ./vdp_background.vhd:131:41  */
  assign n1754_o = n1747_o ? n1749_o : text_column;
  /* ./vdp_background.vhd:130:33  */
  assign n1756_o = n1745_o ? n1753_o : 3'b000;
  /* ./vdp_background.vhd:130:33  */
  assign n1758_o = n1745_o ? n1754_o : 6'b000000;
  /* ./vdp_background.vhd:127:33  */
  assign n1760_o = n1738_o ? 3'b000 : n1756_o;
  /* ./vdp_background.vhd:127:33  */
  assign n1762_o = n1738_o ? 6'b000000 : n1758_o;
  /* ./vdp_background.vhd:124:33  */
  assign n1764_o = n1735_o ? 3'b000 : n1760_o;
  /* ./vdp_background.vhd:124:33  */
  assign n1766_o = n1735_o ? 6'b000000 : n1762_o;
  /* ./vdp_background.vhd:123:25  */
  assign n1767_o = ce_pix ? n1764_o : text_phase;
  /* ./vdp_background.vhd:123:25  */
  assign n1768_o = ce_pix ? n1766_o : text_column;
  /* ./vdp_background.vhd:120:25  */
  assign n1770_o = ss_restore ? 3'b000 : n1767_o;
  /* ./vdp_background.vhd:120:25  */
  assign n1772_o = ss_restore ? 6'b000000 : n1768_o;
  /* ./vdp_background.vhd:157:39  */
  assign n1784_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:160:67  */
  assign n1785_o = y[7:3];
  /* ./vdp_background.vhd:160:53  */
  assign n1786_o = {27'b0, n1785_o};  //  uext
  /* ./vdp_background.vhd:161:47  */
  assign n1788_o = $signed(n1784_o) < $signed(32'b00000000000000000000000000001000);
  /* ./vdp_background.vhd:164:114  */
  assign n1790_o = n1786_o * 32'b00000000000000000000000000101000; // smul
  /* ./vdp_background.vhd:164:83  */
  assign n1791_o = n1790_o[9:0];  // trunc
  /* ./vdp_background.vhd:164:81  */
  assign n1792_o = {table_address, n1791_o};
  /* ./vdp_background.vhd:163:49  */
  assign n1794_o = n1784_o == 32'b00000000000000000000000000000000;
  /* ./vdp_background.vhd:166:78  */
  assign n1795_o = {pt_address, text_tile_index};
  /* ./vdp_background.vhd:166:99  */
  assign n1796_o = y[2:0];
  /* ./vdp_background.vhd:166:96  */
  assign n1797_o = {n1795_o, n1796_o};
  /* ./vdp_background.vhd:165:49  */
  assign n1799_o = n1784_o == 32'b00000000000000000000000000000010;
  assign n1800_o = {n1799_o, n1794_o};
  /* ./vdp_background.vhd:162:49  */
  always @*
    case (n1800_o)
      2'b10: n1801_o = n1797_o;
      2'b01: n1801_o = n1792_o;
      default: n1801_o = n2673_q;
    endcase
  /* ./vdp_background.vhd:170:50  */
  assign n1803_o = $signed(n1784_o) >= $signed(32'b00000000000000000000000000001000);
  /* ./vdp_background.vhd:170:62  */
  assign n1805_o = $signed(n1784_o) < $signed(32'b00000000000000000000000011111000);
  /* ./vdp_background.vhd:170:55  */
  assign n1806_o = n1805_o & n1803_o;
  /* ./vdp_background.vhd:173:72  */
  assign n1808_o = $unsigned(text_column) < $unsigned(6'b100111);
  /* ./vdp_background.vhd:174:88  */
  assign n1810_o = n1786_o * 32'b00000000000000000000000000101000; // smul
  /* ./vdp_background.vhd:174:96  */
  assign n1811_o = {26'b0, text_column};  //  uext
  /* ./vdp_background.vhd:174:94  */
  assign n1812_o = n1810_o + n1811_o;
  /* ./vdp_background.vhd:174:122  */
  assign n1814_o = n1812_o + 32'b00000000000000000000000000000001;
  /* ./vdp_background.vhd:175:91  */
  assign n1815_o = n1814_o[9:0];  // trunc
  /* ./vdp_background.vhd:175:89  */
  assign n1816_o = {table_address, n1815_o};
  /* ./vdp_background.vhd:173:57  */
  assign n1817_o = n1808_o ? n1816_o : n2673_q;
  /* ./vdp_background.vhd:172:49  */
  assign n1820_o = text_phase == 3'b000;
  /* ./vdp_background.vhd:178:72  */
  assign n1822_o = $unsigned(text_column) < $unsigned(6'b100111);
  /* ./vdp_background.vhd:179:86  */
  assign n1823_o = {pt_address, text_tile_index};
  /* ./vdp_background.vhd:179:107  */
  assign n1824_o = y[2:0];
  /* ./vdp_background.vhd:179:104  */
  assign n1825_o = {n1823_o, n1824_o};
  /* ./vdp_background.vhd:178:57  */
  assign n1826_o = n1822_o ? n1825_o : n2673_q;
  /* ./vdp_background.vhd:177:49  */
  assign n1828_o = text_phase == 3'b010;
  assign n1829_o = {n1828_o, n1820_o};
  /* ./vdp_background.vhd:171:49  */
  always @*
    case (n1829_o)
      2'b10: n1830_o = n1826_o;
      2'b01: n1830_o = n1817_o;
      default: n1830_o = n2673_q;
    endcase
  /* ./vdp_background.vhd:170:41  */
  assign n1832_o = n1806_o ? n1830_o : n2673_q;
  /* ./vdp_background.vhd:161:41  */
  assign n1834_o = n1788_o ? n1801_o : n1832_o;
  /* ./vdp_background.vhd:189:58  */
  assign n1836_o = smode_m1 | smode_m3;
  /* ./vdp_background.vhd:189:92  */
  assign n1837_o = ~legacy_ext_nt;
  /* ./vdp_background.vhd:189:75  */
  assign n1838_o = n1837_o & n1836_o;
  /* ./vdp_background.vhd:190:91  */
  assign n1839_o = table_address[3:2];
  /* ./vdp_background.vhd:190:121  */
  assign n1840_o = y[7:3];
  /* ./vdp_background.vhd:190:118  */
  assign n1842_o = {1'b0, n1840_o};  //  uext
  /* ./vdp_background.vhd:190:118  */
  assign n1843_o = 6'b011100 + n1842_o;
  /* ./vdp_background.vhd:190:106  */
  assign n1844_o = {n1839_o, n1843_o};
  /* ./vdp_background.vhd:192:92  */
  assign n1845_o = table_address[3:1];
  /* ./vdp_background.vhd:194:89  */
  assign n1846_o = table_address[0];
  /* ./vdp_background.vhd:194:99  */
  assign n1847_o = y[7];
  /* ./vdp_background.vhd:194:94  */
  assign n1848_o = n1846_o & n1847_o;
  /* ./vdp_background.vhd:195:86  */
  assign n1849_o = y[6:3];
  /* ./vdp_background.vhd:197:77  */
  assign n1850_o = y[7];
  /* ./vdp_background.vhd:198:86  */
  assign n1851_o = y[6:3];
  assign n1852_o = {n1850_o, n1851_o};
  assign n1853_o = {n1848_o, n1849_o};
  /* ./vdp_background.vhd:193:49  */
  assign n1854_o = ysj_quirk ? n1853_o : n1852_o;
  assign n1855_o = {n1845_o, n1854_o};
  /* ./vdp_background.vhd:189:41  */
  assign n1856_o = n1838_o ? n1844_o : n1855_o;
  /* ./vdp_background.vhd:201:70  */
  assign n1857_o = x[7:3];
  /* ./vdp_background.vhd:201:83  */
  assign n1859_o = n1857_o + 5'b00001;
  /* ./vdp_background.vhd:202:81  */
  assign n1860_o = {tile_index, tile_y};
  /* ./vdp_background.vhd:204:47  */
  assign n1861_o = x[2:0];
  assign n1862_o = {n1856_o, n1859_o};
  /* ./vdp_background.vhd:205:78  */
  assign n1864_o = {n1862_o, 1'b0};
  /* ./vdp_background.vhd:205:41  */
  assign n1866_o = n1861_o == 3'b000;
  assign n1867_o = {n1856_o, n1859_o};
  /* ./vdp_background.vhd:206:78  */
  assign n1869_o = {n1867_o, 1'b1};
  /* ./vdp_background.vhd:206:41  */
  assign n1871_o = n1861_o == 3'b001;
  /* ./vdp_background.vhd:207:78  */
  assign n1873_o = {n1860_o, 2'b00};
  /* ./vdp_background.vhd:207:41  */
  assign n1875_o = n1861_o == 3'b011;
  /* ./vdp_background.vhd:208:78  */
  assign n1877_o = {n1860_o, 2'b01};
  /* ./vdp_background.vhd:208:41  */
  assign n1879_o = n1861_o == 3'b100;
  /* ./vdp_background.vhd:209:78  */
  assign n1881_o = {n1860_o, 2'b10};
  /* ./vdp_background.vhd:209:41  */
  assign n1883_o = n1861_o == 3'b101;
  /* ./vdp_background.vhd:210:78  */
  assign n1885_o = {n1860_o, 2'b11};
  /* ./vdp_background.vhd:210:41  */
  assign n1887_o = n1861_o == 3'b110;
  assign n1888_o = {n1887_o, n1883_o, n1879_o, n1875_o, n1871_o, n1866_o};
  /* ./vdp_background.vhd:204:41  */
  always @*
    case (n1888_o)
      6'b100000: n1889_o = n1885_o;
      6'b010000: n1889_o = n1881_o;
      6'b001000: n1889_o = n1877_o;
      6'b000100: n1889_o = n1873_o;
      6'b000010: n1889_o = n1869_o;
      6'b000001: n1889_o = n1864_o;
      default: n1889_o = n2673_q;
    endcase
  /* ./vdp_background.vhd:220:47  */
  assign n1890_o = x[2:0];
  /* ./vdp_background.vhd:221:82  */
  assign n1891_o = y[7:3];
  /* ./vdp_background.vhd:221:79  */
  assign n1892_o = {table_address, n1891_o};
  /* ./vdp_background.vhd:221:98  */
  assign n1893_o = x[7:3];
  /* ./vdp_background.vhd:221:95  */
  assign n1894_o = {n1892_o, n1893_o};
  /* ./vdp_background.vhd:221:41  */
  assign n1896_o = n1890_o == 3'b000;
  /* ./vdp_background.vhd:225:90  */
  assign n1897_o = tile_index[7:0];
  /* ./vdp_background.vhd:225:78  */
  assign n1898_o = {pt_address, n1897_o};
  /* ./vdp_background.vhd:225:106  */
  assign n1899_o = y[2:0];
  /* ./vdp_background.vhd:225:103  */
  assign n1900_o = {n1898_o, n1899_o};
  /* ./vdp_background.vhd:228:77  */
  assign n1901_o = pt_address[2];
  /* ./vdp_background.vhd:228:86  */
  assign n1902_o = y[7:6];
  /* ./vdp_background.vhd:228:113  */
  assign n1903_o = pt_address[1:0];
  /* ./vdp_background.vhd:228:99  */
  assign n1904_o = n1902_o & n1903_o;
  /* ./vdp_background.vhd:228:82  */
  assign n1905_o = {n1901_o, n1904_o};
  /* ./vdp_background.vhd:229:85  */
  assign n1906_o = tile_index[7:0];
  /* ./vdp_background.vhd:228:129  */
  assign n1907_o = {n1905_o, n1906_o};
  /* ./vdp_background.vhd:229:101  */
  assign n1908_o = y[2:0];
  /* ./vdp_background.vhd:229:98  */
  assign n1909_o = {n1907_o, n1908_o};
  /* ./vdp_background.vhd:223:49  */
  assign n1910_o = gfx1_mode ? n1900_o : n1909_o;
  /* ./vdp_background.vhd:222:41  */
  assign n1912_o = n1890_o == 3'b010;
  /* ./vdp_background.vhd:234:91  */
  assign n1914_o = {ct_address, 1'b0};
  /* ./vdp_background.vhd:234:109  */
  assign n1915_o = tile_index[7:3];
  /* ./vdp_background.vhd:234:97  */
  assign n1916_o = {n1914_o, n1915_o};
  /* ./vdp_background.vhd:237:77  */
  assign n1917_o = ct_address[7];
  /* ./vdp_background.vhd:238:78  */
  assign n1918_o = y[7:6];
  /* ./vdp_background.vhd:238:103  */
  assign n1919_o = tile_index[7:3];
  /* ./vdp_background.vhd:238:91  */
  assign n1920_o = {n1918_o, n1919_o};
  /* ./vdp_background.vhd:238:131  */
  assign n1921_o = ct_address[6:0];
  /* ./vdp_background.vhd:238:117  */
  assign n1922_o = n1920_o & n1921_o;
  /* ./vdp_background.vhd:237:82  */
  assign n1923_o = {n1917_o, n1922_o};
  /* ./vdp_background.vhd:239:85  */
  assign n1924_o = tile_index[2:0];
  /* ./vdp_background.vhd:238:146  */
  assign n1925_o = {n1923_o, n1924_o};
  /* ./vdp_background.vhd:239:101  */
  assign n1926_o = y[2:0];
  /* ./vdp_background.vhd:239:98  */
  assign n1927_o = {n1925_o, n1926_o};
  /* ./vdp_background.vhd:232:49  */
  assign n1928_o = gfx1_mode ? n1916_o : n1927_o;
  /* ./vdp_background.vhd:231:41  */
  assign n1930_o = n1890_o == 3'b011;
  assign n1931_o = {n1930_o, n1912_o, n1896_o};
  /* ./vdp_background.vhd:220:41  */
  always @*
    case (n1931_o)
      3'b100: n1932_o = n1928_o;
      3'b010: n1932_o = n1910_o;
      3'b001: n1932_o = n1894_o;
      default: n1932_o = n2673_q;
    endcase
  /* ./vdp_background.vhd:186:33  */
  assign n1933_o = smode_m4 ? n1889_o : n1932_o;
  /* ./vdp_background.vhd:159:33  */
  assign n1937_o = text_mode ? n1834_o : n1933_o;
  /* ./vdp_background.vhd:268:44  */
  assign n1964_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:268:66  */
  assign n1966_o = n1964_o == 32'b00000000000000000000000000000001;
  /* ./vdp_background.vhd:270:47  */
  assign n1967_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:270:69  */
  assign n1969_o = n1967_o == 32'b00000000000000000000000000000011;
  /* ./vdp_background.vhd:272:47  */
  assign n1970_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:272:69  */
  assign n1972_o = $signed(n1970_o) >= $signed(32'b00000000000000000000000000001000);
  /* ./vdp_background.vhd:272:77  */
  assign n1973_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:272:99  */
  assign n1975_o = $signed(n1973_o) < $signed(32'b00000000000000000000000011111000);
  /* ./vdp_background.vhd:272:73  */
  assign n1976_o = n1975_o & n1972_o;
  /* ./vdp_background.vhd:275:72  */
  assign n1978_o = $unsigned(text_column) < $unsigned(6'b100111);
  /* ./vdp_background.vhd:275:57  */
  assign n1979_o = n1978_o ? vram_d : text_tile_index;
  /* ./vdp_background.vhd:274:49  */
  assign n1981_o = text_phase == 3'b001;
  /* ./vdp_background.vhd:279:72  */
  assign n1983_o = $unsigned(text_column) < $unsigned(6'b100111);
  /* ./vdp_background.vhd:279:57  */
  assign n1984_o = n1983_o ? vram_d : text_pattern;
  /* ./vdp_background.vhd:278:49  */
  assign n1986_o = text_phase == 3'b011;
  assign n1987_o = {n1986_o, n1981_o};
  /* ./vdp_background.vhd:273:49  */
  always @*
    case (n1987_o)
      2'b10: n1988_o = text_tile_index;
      2'b01: n1988_o = n1979_o;
      default: n1988_o = text_tile_index;
    endcase
  /* ./vdp_background.vhd:273:49  */
  always @*
    case (n1987_o)
      2'b10: n1989_o = n1984_o;
      2'b01: n1989_o = text_pattern;
      default: n1989_o = text_pattern;
    endcase
  /* ./vdp_background.vhd:272:41  */
  assign n1990_o = n1976_o ? n1988_o : text_tile_index;
  /* ./vdp_background.vhd:272:41  */
  assign n1991_o = n1976_o ? n1989_o : text_pattern;
  /* ./vdp_background.vhd:270:41  */
  assign n1992_o = n1969_o ? text_tile_index : n1990_o;
  /* ./vdp_background.vhd:270:41  */
  assign n1993_o = n1969_o ? vram_d : n1991_o;
  /* ./vdp_background.vhd:268:41  */
  assign n1994_o = n1966_o ? vram_d : n1992_o;
  /* ./vdp_background.vhd:268:41  */
  assign n1995_o = n1966_o ? text_pattern : n1993_o;
  /* ./vdp_background.vhd:288:47  */
  assign n1996_o = x[2:0];
  /* ./vdp_background.vhd:289:41  */
  assign n1998_o = n1996_o == 3'b001;
  /* ./vdp_background.vhd:292:72  */
  assign n1999_o = vram_d[0];
  /* ./vdp_background.vhd:293:72  */
  assign n2000_o = vram_d[1];
  /* ./vdp_background.vhd:294:67  */
  assign n2001_o = y[0];
  /* ./vdp_background.vhd:294:81  */
  assign n2002_o = vram_d[2];
  /* ./vdp_background.vhd:294:71  */
  assign n2003_o = n2001_o ^ n2002_o;
  /* ./vdp_background.vhd:295:67  */
  assign n2004_o = y[1];
  /* ./vdp_background.vhd:295:81  */
  assign n2005_o = vram_d[2];
  /* ./vdp_background.vhd:295:71  */
  assign n2006_o = n2004_o ^ n2005_o;
  /* ./vdp_background.vhd:296:67  */
  assign n2007_o = y[2];
  /* ./vdp_background.vhd:296:81  */
  assign n2008_o = vram_d[2];
  /* ./vdp_background.vhd:296:71  */
  assign n2009_o = n2007_o ^ n2008_o;
  /* ./vdp_background.vhd:297:72  */
  assign n2010_o = vram_d[3];
  /* ./vdp_background.vhd:298:72  */
  assign n2011_o = vram_d[4];
  /* ./vdp_background.vhd:291:41  */
  assign n2013_o = n1996_o == 3'b010;
  /* ./vdp_background.vhd:299:41  */
  assign n2015_o = n1996_o == 3'b100;
  /* ./vdp_background.vhd:301:41  */
  assign n2017_o = n1996_o == 3'b101;
  /* ./vdp_background.vhd:303:41  */
  assign n2019_o = n1996_o == 3'b110;
  assign n2020_o = {n2019_o, n2017_o, n2015_o, n2013_o, n1998_o};
  assign n2021_o = tile_index[7:0];
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2022_o = n2021_o;
      5'b01000: n2022_o = n2021_o;
      5'b00100: n2022_o = n2021_o;
      5'b00010: n2022_o = n2021_o;
      5'b00001: n2022_o = vram_d;
      default: n2022_o = n2021_o;
    endcase
  assign n2023_o = tile_index[8];
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2024_o = n2023_o;
      5'b01000: n2024_o = n2023_o;
      5'b00100: n2024_o = n2023_o;
      5'b00010: n2024_o = n1999_o;
      5'b00001: n2024_o = n2023_o;
      default: n2024_o = n2023_o;
    endcase
  assign n2025_o = tile_y[0];
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2026_o = n2025_o;
      5'b01000: n2026_o = n2025_o;
      5'b00100: n2026_o = n2025_o;
      5'b00010: n2026_o = n2003_o;
      5'b00001: n2026_o = n2025_o;
      default: n2026_o = n2025_o;
    endcase
  assign n2027_o = tile_y[1];
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2028_o = n2027_o;
      5'b01000: n2028_o = n2027_o;
      5'b00100: n2028_o = n2027_o;
      5'b00010: n2028_o = n2006_o;
      5'b00001: n2028_o = n2027_o;
      default: n2028_o = n2027_o;
    endcase
  assign n2029_o = tile_y[2];
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2030_o = n2029_o;
      5'b01000: n2030_o = n2029_o;
      5'b00100: n2030_o = n2029_o;
      5'b00010: n2030_o = n2009_o;
      5'b00001: n2030_o = n2029_o;
      default: n2030_o = n2029_o;
    endcase
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2031_o = palette;
      5'b01000: n2031_o = palette;
      5'b00100: n2031_o = palette;
      5'b00010: n2031_o = n2010_o;
      5'b00001: n2031_o = palette;
      default: n2031_o = palette;
    endcase
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2032_o = priority_latch;
      5'b01000: n2032_o = priority_latch;
      5'b00100: n2032_o = priority_latch;
      5'b00010: n2032_o = n2011_o;
      5'b00001: n2032_o = priority_latch;
      default: n2032_o = priority_latch;
    endcase
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2033_o = flip_x;
      5'b01000: n2033_o = flip_x;
      5'b00100: n2033_o = flip_x;
      5'b00010: n2033_o = n2000_o;
      5'b00001: n2033_o = flip_x;
      default: n2033_o = flip_x;
    endcase
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2034_o = data0;
      5'b01000: n2034_o = data0;
      5'b00100: n2034_o = vram_d;
      5'b00010: n2034_o = data0;
      5'b00001: n2034_o = data0;
      default: n2034_o = data0;
    endcase
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2035_o = data1;
      5'b01000: n2035_o = vram_d;
      5'b00100: n2035_o = data1;
      5'b00010: n2035_o = data1;
      5'b00001: n2035_o = data1;
      default: n2035_o = data1;
    endcase
  /* ./vdp_background.vhd:288:41  */
  always @*
    case (n2020_o)
      5'b10000: n2036_o = vram_d;
      5'b01000: n2036_o = data2;
      5'b00100: n2036_o = data2;
      5'b00010: n2036_o = data2;
      5'b00001: n2036_o = data2;
      default: n2036_o = data2;
    endcase
  /* ./vdp_background.vhd:319:47  */
  assign n2037_o = x[2:0];
  /* ./vdp_background.vhd:320:41  */
  assign n2039_o = n2037_o == 3'b001;
  /* ./vdp_background.vhd:322:41  */
  assign n2041_o = n2037_o == 3'b011;
  /* ./vdp_background.vhd:332:75  */
  assign n2042_o = datac[0];
  /* ./vdp_background.vhd:332:89  */
  assign n2043_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2044_o = n2042_o & n2043_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2045_o = datac[0];
  /* ./vdp_background.vhd:332:98  */
  assign n2046_o = ~n2045_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2047_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2048_o = n2046_o & n2047_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2049_o = n2044_o | n2048_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2050_o = datac[0];
  /* ./vdp_background.vhd:333:89  */
  assign n2051_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2052_o = n2050_o & n2051_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2053_o = datac[0];
  /* ./vdp_background.vhd:333:98  */
  assign n2054_o = ~n2053_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2055_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2056_o = n2054_o & n2055_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2057_o = n2052_o | n2056_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2058_o = datac[0];
  /* ./vdp_background.vhd:334:89  */
  assign n2059_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2060_o = n2058_o & n2059_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2061_o = datac[0];
  /* ./vdp_background.vhd:334:98  */
  assign n2062_o = ~n2061_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2063_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2064_o = n2062_o & n2063_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2065_o = n2060_o | n2064_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2066_o = datac[0];
  /* ./vdp_background.vhd:335:89  */
  assign n2067_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2068_o = n2066_o & n2067_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2069_o = datac[0];
  /* ./vdp_background.vhd:335:98  */
  assign n2070_o = ~n2069_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2071_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2072_o = n2070_o & n2071_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2073_o = n2068_o | n2072_o;
  /* ./vdp_background.vhd:332:75  */
  assign n2074_o = datac[1];
  /* ./vdp_background.vhd:332:89  */
  assign n2075_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2076_o = n2074_o & n2075_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2077_o = datac[1];
  /* ./vdp_background.vhd:332:98  */
  assign n2078_o = ~n2077_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2079_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2080_o = n2078_o & n2079_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2081_o = n2076_o | n2080_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2082_o = datac[1];
  /* ./vdp_background.vhd:333:89  */
  assign n2083_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2084_o = n2082_o & n2083_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2085_o = datac[1];
  /* ./vdp_background.vhd:333:98  */
  assign n2086_o = ~n2085_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2087_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2088_o = n2086_o & n2087_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2089_o = n2084_o | n2088_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2090_o = datac[1];
  /* ./vdp_background.vhd:334:89  */
  assign n2091_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2092_o = n2090_o & n2091_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2093_o = datac[1];
  /* ./vdp_background.vhd:334:98  */
  assign n2094_o = ~n2093_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2095_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2096_o = n2094_o & n2095_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2097_o = n2092_o | n2096_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2098_o = datac[1];
  /* ./vdp_background.vhd:335:89  */
  assign n2099_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2100_o = n2098_o & n2099_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2101_o = datac[1];
  /* ./vdp_background.vhd:335:98  */
  assign n2102_o = ~n2101_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2103_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2104_o = n2102_o & n2103_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2105_o = n2100_o | n2104_o;
  /* ./vdp_background.vhd:332:75  */
  assign n2106_o = datac[2];
  /* ./vdp_background.vhd:332:89  */
  assign n2107_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2108_o = n2106_o & n2107_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2109_o = datac[2];
  /* ./vdp_background.vhd:332:98  */
  assign n2110_o = ~n2109_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2111_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2112_o = n2110_o & n2111_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2113_o = n2108_o | n2112_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2114_o = datac[2];
  /* ./vdp_background.vhd:333:89  */
  assign n2115_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2116_o = n2114_o & n2115_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2117_o = datac[2];
  /* ./vdp_background.vhd:333:98  */
  assign n2118_o = ~n2117_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2119_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2120_o = n2118_o & n2119_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2121_o = n2116_o | n2120_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2122_o = datac[2];
  /* ./vdp_background.vhd:334:89  */
  assign n2123_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2124_o = n2122_o & n2123_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2125_o = datac[2];
  /* ./vdp_background.vhd:334:98  */
  assign n2126_o = ~n2125_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2127_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2128_o = n2126_o & n2127_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2129_o = n2124_o | n2128_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2130_o = datac[2];
  /* ./vdp_background.vhd:335:89  */
  assign n2131_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2132_o = n2130_o & n2131_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2133_o = datac[2];
  /* ./vdp_background.vhd:335:98  */
  assign n2134_o = ~n2133_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2135_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2136_o = n2134_o & n2135_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2137_o = n2132_o | n2136_o;
  /* ./vdp_background.vhd:332:75  */
  assign n2138_o = datac[3];
  /* ./vdp_background.vhd:332:89  */
  assign n2139_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2140_o = n2138_o & n2139_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2141_o = datac[3];
  /* ./vdp_background.vhd:332:98  */
  assign n2142_o = ~n2141_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2143_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2144_o = n2142_o & n2143_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2145_o = n2140_o | n2144_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2146_o = datac[3];
  /* ./vdp_background.vhd:333:89  */
  assign n2147_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2148_o = n2146_o & n2147_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2149_o = datac[3];
  /* ./vdp_background.vhd:333:98  */
  assign n2150_o = ~n2149_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2151_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2152_o = n2150_o & n2151_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2153_o = n2148_o | n2152_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2154_o = datac[3];
  /* ./vdp_background.vhd:334:89  */
  assign n2155_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2156_o = n2154_o & n2155_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2157_o = datac[3];
  /* ./vdp_background.vhd:334:98  */
  assign n2158_o = ~n2157_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2159_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2160_o = n2158_o & n2159_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2161_o = n2156_o | n2160_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2162_o = datac[3];
  /* ./vdp_background.vhd:335:89  */
  assign n2163_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2164_o = n2162_o & n2163_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2165_o = datac[3];
  /* ./vdp_background.vhd:335:98  */
  assign n2166_o = ~n2165_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2167_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2168_o = n2166_o & n2167_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2169_o = n2164_o | n2168_o;
  /* ./vdp_background.vhd:332:75  */
  assign n2170_o = datac[4];
  /* ./vdp_background.vhd:332:89  */
  assign n2171_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2172_o = n2170_o & n2171_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2173_o = datac[4];
  /* ./vdp_background.vhd:332:98  */
  assign n2174_o = ~n2173_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2175_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2176_o = n2174_o & n2175_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2177_o = n2172_o | n2176_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2178_o = datac[4];
  /* ./vdp_background.vhd:333:89  */
  assign n2179_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2180_o = n2178_o & n2179_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2181_o = datac[4];
  /* ./vdp_background.vhd:333:98  */
  assign n2182_o = ~n2181_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2183_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2184_o = n2182_o & n2183_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2185_o = n2180_o | n2184_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2186_o = datac[4];
  /* ./vdp_background.vhd:334:89  */
  assign n2187_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2188_o = n2186_o & n2187_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2189_o = datac[4];
  /* ./vdp_background.vhd:334:98  */
  assign n2190_o = ~n2189_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2191_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2192_o = n2190_o & n2191_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2193_o = n2188_o | n2192_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2194_o = datac[4];
  /* ./vdp_background.vhd:335:89  */
  assign n2195_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2196_o = n2194_o & n2195_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2197_o = datac[4];
  /* ./vdp_background.vhd:335:98  */
  assign n2198_o = ~n2197_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2199_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2200_o = n2198_o & n2199_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2201_o = n2196_o | n2200_o;
  /* ./vdp_background.vhd:332:75  */
  assign n2202_o = datac[5];
  /* ./vdp_background.vhd:332:89  */
  assign n2203_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2204_o = n2202_o & n2203_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2205_o = datac[5];
  /* ./vdp_background.vhd:332:98  */
  assign n2206_o = ~n2205_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2207_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2208_o = n2206_o & n2207_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2209_o = n2204_o | n2208_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2210_o = datac[5];
  /* ./vdp_background.vhd:333:89  */
  assign n2211_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2212_o = n2210_o & n2211_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2213_o = datac[5];
  /* ./vdp_background.vhd:333:98  */
  assign n2214_o = ~n2213_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2215_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2216_o = n2214_o & n2215_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2217_o = n2212_o | n2216_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2218_o = datac[5];
  /* ./vdp_background.vhd:334:89  */
  assign n2219_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2220_o = n2218_o & n2219_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2221_o = datac[5];
  /* ./vdp_background.vhd:334:98  */
  assign n2222_o = ~n2221_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2223_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2224_o = n2222_o & n2223_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2225_o = n2220_o | n2224_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2226_o = datac[5];
  /* ./vdp_background.vhd:335:89  */
  assign n2227_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2228_o = n2226_o & n2227_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2229_o = datac[5];
  /* ./vdp_background.vhd:335:98  */
  assign n2230_o = ~n2229_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2231_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2232_o = n2230_o & n2231_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2233_o = n2228_o | n2232_o;
  /* ./vdp_background.vhd:332:75  */
  assign n2234_o = datac[6];
  /* ./vdp_background.vhd:332:89  */
  assign n2235_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2236_o = n2234_o & n2235_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2237_o = datac[6];
  /* ./vdp_background.vhd:332:98  */
  assign n2238_o = ~n2237_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2239_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2240_o = n2238_o & n2239_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2241_o = n2236_o | n2240_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2242_o = datac[6];
  /* ./vdp_background.vhd:333:89  */
  assign n2243_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2244_o = n2242_o & n2243_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2245_o = datac[6];
  /* ./vdp_background.vhd:333:98  */
  assign n2246_o = ~n2245_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2247_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2248_o = n2246_o & n2247_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2249_o = n2244_o | n2248_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2250_o = datac[6];
  /* ./vdp_background.vhd:334:89  */
  assign n2251_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2252_o = n2250_o & n2251_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2253_o = datac[6];
  /* ./vdp_background.vhd:334:98  */
  assign n2254_o = ~n2253_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2255_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2256_o = n2254_o & n2255_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2257_o = n2252_o | n2256_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2258_o = datac[6];
  /* ./vdp_background.vhd:335:89  */
  assign n2259_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2260_o = n2258_o & n2259_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2261_o = datac[6];
  /* ./vdp_background.vhd:335:98  */
  assign n2262_o = ~n2261_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2263_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2264_o = n2262_o & n2263_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2265_o = n2260_o | n2264_o;
  /* ./vdp_background.vhd:332:75  */
  assign n2266_o = datac[7];
  /* ./vdp_background.vhd:332:89  */
  assign n2267_o = vram_d[4];
  /* ./vdp_background.vhd:332:79  */
  assign n2268_o = n2266_o & n2267_o;
  /* ./vdp_background.vhd:332:107  */
  assign n2269_o = datac[7];
  /* ./vdp_background.vhd:332:98  */
  assign n2270_o = ~n2269_o;
  /* ./vdp_background.vhd:332:121  */
  assign n2271_o = vram_d[0];
  /* ./vdp_background.vhd:332:111  */
  assign n2272_o = n2270_o & n2271_o;
  /* ./vdp_background.vhd:332:94  */
  assign n2273_o = n2268_o | n2272_o;
  /* ./vdp_background.vhd:333:75  */
  assign n2274_o = datac[7];
  /* ./vdp_background.vhd:333:89  */
  assign n2275_o = vram_d[5];
  /* ./vdp_background.vhd:333:79  */
  assign n2276_o = n2274_o & n2275_o;
  /* ./vdp_background.vhd:333:107  */
  assign n2277_o = datac[7];
  /* ./vdp_background.vhd:333:98  */
  assign n2278_o = ~n2277_o;
  /* ./vdp_background.vhd:333:121  */
  assign n2279_o = vram_d[1];
  /* ./vdp_background.vhd:333:111  */
  assign n2280_o = n2278_o & n2279_o;
  /* ./vdp_background.vhd:333:94  */
  assign n2281_o = n2276_o | n2280_o;
  /* ./vdp_background.vhd:334:75  */
  assign n2282_o = datac[7];
  /* ./vdp_background.vhd:334:89  */
  assign n2283_o = vram_d[6];
  /* ./vdp_background.vhd:334:79  */
  assign n2284_o = n2282_o & n2283_o;
  /* ./vdp_background.vhd:334:107  */
  assign n2285_o = datac[7];
  /* ./vdp_background.vhd:334:98  */
  assign n2286_o = ~n2285_o;
  /* ./vdp_background.vhd:334:121  */
  assign n2287_o = vram_d[2];
  /* ./vdp_background.vhd:334:111  */
  assign n2288_o = n2286_o & n2287_o;
  /* ./vdp_background.vhd:334:94  */
  assign n2289_o = n2284_o | n2288_o;
  /* ./vdp_background.vhd:335:75  */
  assign n2290_o = datac[7];
  /* ./vdp_background.vhd:335:89  */
  assign n2291_o = vram_d[7];
  /* ./vdp_background.vhd:335:79  */
  assign n2292_o = n2290_o & n2291_o;
  /* ./vdp_background.vhd:335:107  */
  assign n2293_o = datac[7];
  /* ./vdp_background.vhd:335:98  */
  assign n2294_o = ~n2293_o;
  /* ./vdp_background.vhd:335:121  */
  assign n2295_o = vram_d[3];
  /* ./vdp_background.vhd:335:111  */
  assign n2296_o = n2294_o & n2295_o;
  /* ./vdp_background.vhd:335:94  */
  assign n2297_o = n2292_o | n2296_o;
  /* ./vdp_background.vhd:325:41  */
  assign n2299_o = n2037_o == 3'b100;
  assign n2300_o = {n2299_o, n2041_o, n2039_o};
  assign n2301_o = tile_index[7:0];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2302_o = n2301_o;
      3'b010: n2302_o = n2301_o;
      3'b001: n2302_o = vram_d;
      default: n2302_o = n2301_o;
    endcase
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2304_o = 1'b0;
      3'b010: n2304_o = palette;
      3'b001: n2304_o = palette;
      default: n2304_o = palette;
    endcase
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2306_o = 1'b0;
      3'b010: n2306_o = priority_latch;
      3'b001: n2306_o = priority_latch;
      default: n2306_o = priority_latch;
    endcase
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2308_o = 1'b0;
      3'b010: n2308_o = flip_x;
      3'b001: n2308_o = flip_x;
      default: n2308_o = flip_x;
    endcase
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2309_o = datac;
      3'b010: n2309_o = vram_d;
      3'b001: n2309_o = datac;
      default: n2309_o = datac;
    endcase
  assign n2310_o = data0[0];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2311_o = n2049_o;
      3'b010: n2311_o = n2310_o;
      3'b001: n2311_o = n2310_o;
      default: n2311_o = n2310_o;
    endcase
  assign n2312_o = data0[1];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2313_o = n2081_o;
      3'b010: n2313_o = n2312_o;
      3'b001: n2313_o = n2312_o;
      default: n2313_o = n2312_o;
    endcase
  assign n2314_o = data0[2];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2315_o = n2113_o;
      3'b010: n2315_o = n2314_o;
      3'b001: n2315_o = n2314_o;
      default: n2315_o = n2314_o;
    endcase
  assign n2316_o = data0[3];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2317_o = n2145_o;
      3'b010: n2317_o = n2316_o;
      3'b001: n2317_o = n2316_o;
      default: n2317_o = n2316_o;
    endcase
  assign n2318_o = data0[4];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2319_o = n2177_o;
      3'b010: n2319_o = n2318_o;
      3'b001: n2319_o = n2318_o;
      default: n2319_o = n2318_o;
    endcase
  assign n2320_o = data0[5];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2321_o = n2209_o;
      3'b010: n2321_o = n2320_o;
      3'b001: n2321_o = n2320_o;
      default: n2321_o = n2320_o;
    endcase
  assign n2322_o = data0[6];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2323_o = n2241_o;
      3'b010: n2323_o = n2322_o;
      3'b001: n2323_o = n2322_o;
      default: n2323_o = n2322_o;
    endcase
  assign n2324_o = data0[7];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2325_o = n2273_o;
      3'b010: n2325_o = n2324_o;
      3'b001: n2325_o = n2324_o;
      default: n2325_o = n2324_o;
    endcase
  assign n2326_o = data1[0];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2327_o = n2057_o;
      3'b010: n2327_o = n2326_o;
      3'b001: n2327_o = n2326_o;
      default: n2327_o = n2326_o;
    endcase
  assign n2328_o = data1[1];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2329_o = n2089_o;
      3'b010: n2329_o = n2328_o;
      3'b001: n2329_o = n2328_o;
      default: n2329_o = n2328_o;
    endcase
  assign n2330_o = data1[2];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2331_o = n2121_o;
      3'b010: n2331_o = n2330_o;
      3'b001: n2331_o = n2330_o;
      default: n2331_o = n2330_o;
    endcase
  assign n2332_o = data1[3];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2333_o = n2153_o;
      3'b010: n2333_o = n2332_o;
      3'b001: n2333_o = n2332_o;
      default: n2333_o = n2332_o;
    endcase
  assign n2334_o = data1[4];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2335_o = n2185_o;
      3'b010: n2335_o = n2334_o;
      3'b001: n2335_o = n2334_o;
      default: n2335_o = n2334_o;
    endcase
  assign n2336_o = data1[5];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2337_o = n2217_o;
      3'b010: n2337_o = n2336_o;
      3'b001: n2337_o = n2336_o;
      default: n2337_o = n2336_o;
    endcase
  assign n2338_o = data1[6];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2339_o = n2249_o;
      3'b010: n2339_o = n2338_o;
      3'b001: n2339_o = n2338_o;
      default: n2339_o = n2338_o;
    endcase
  assign n2340_o = data1[7];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2341_o = n2281_o;
      3'b010: n2341_o = n2340_o;
      3'b001: n2341_o = n2340_o;
      default: n2341_o = n2340_o;
    endcase
  assign n2342_o = data2[0];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2343_o = n2065_o;
      3'b010: n2343_o = n2342_o;
      3'b001: n2343_o = n2342_o;
      default: n2343_o = n2342_o;
    endcase
  assign n2344_o = data2[1];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2345_o = n2097_o;
      3'b010: n2345_o = n2344_o;
      3'b001: n2345_o = n2344_o;
      default: n2345_o = n2344_o;
    endcase
  assign n2346_o = data2[2];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2347_o = n2129_o;
      3'b010: n2347_o = n2346_o;
      3'b001: n2347_o = n2346_o;
      default: n2347_o = n2346_o;
    endcase
  assign n2348_o = data2[3];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2349_o = n2161_o;
      3'b010: n2349_o = n2348_o;
      3'b001: n2349_o = n2348_o;
      default: n2349_o = n2348_o;
    endcase
  assign n2350_o = data2[4];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2351_o = n2193_o;
      3'b010: n2351_o = n2350_o;
      3'b001: n2351_o = n2350_o;
      default: n2351_o = n2350_o;
    endcase
  assign n2352_o = data2[5];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2353_o = n2225_o;
      3'b010: n2353_o = n2352_o;
      3'b001: n2353_o = n2352_o;
      default: n2353_o = n2352_o;
    endcase
  assign n2354_o = data2[6];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2355_o = n2257_o;
      3'b010: n2355_o = n2354_o;
      3'b001: n2355_o = n2354_o;
      default: n2355_o = n2354_o;
    endcase
  assign n2356_o = data2[7];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2357_o = n2289_o;
      3'b010: n2357_o = n2356_o;
      3'b001: n2357_o = n2356_o;
      default: n2357_o = n2356_o;
    endcase
  assign n2358_o = data3[0];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2359_o = n2073_o;
      3'b010: n2359_o = n2358_o;
      3'b001: n2359_o = n2358_o;
      default: n2359_o = n2358_o;
    endcase
  assign n2360_o = data3[1];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2361_o = n2105_o;
      3'b010: n2361_o = n2360_o;
      3'b001: n2361_o = n2360_o;
      default: n2361_o = n2360_o;
    endcase
  assign n2362_o = data3[2];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2363_o = n2137_o;
      3'b010: n2363_o = n2362_o;
      3'b001: n2363_o = n2362_o;
      default: n2363_o = n2362_o;
    endcase
  assign n2364_o = data3[3];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2365_o = n2169_o;
      3'b010: n2365_o = n2364_o;
      3'b001: n2365_o = n2364_o;
      default: n2365_o = n2364_o;
    endcase
  assign n2366_o = data3[4];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2367_o = n2201_o;
      3'b010: n2367_o = n2366_o;
      3'b001: n2367_o = n2366_o;
      default: n2367_o = n2366_o;
    endcase
  assign n2368_o = data3[5];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2369_o = n2233_o;
      3'b010: n2369_o = n2368_o;
      3'b001: n2369_o = n2368_o;
      default: n2369_o = n2368_o;
    endcase
  assign n2370_o = data3[6];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2371_o = n2265_o;
      3'b010: n2371_o = n2370_o;
      3'b001: n2371_o = n2370_o;
      default: n2371_o = n2370_o;
    endcase
  assign n2372_o = data3[7];
  /* ./vdp_background.vhd:319:41  */
  always @*
    case (n2300_o)
      3'b100: n2373_o = n2297_o;
      3'b010: n2373_o = n2372_o;
      3'b001: n2373_o = n2372_o;
      default: n2373_o = n2372_o;
    endcase
  assign n2374_o = {n2024_o, n2022_o};
  assign n2375_o = n2374_o[7:0];
  /* ./vdp_background.vhd:287:33  */
  assign n2376_o = smode_m4 ? n2375_o : n2302_o;
  assign n2377_o = n2374_o[8];
  assign n2378_o = tile_index[8];
  /* ./vdp_background.vhd:287:33  */
  assign n2379_o = smode_m4 ? n2377_o : n2378_o;
  assign n2380_o = {n2030_o, n2028_o, n2026_o};
  /* ./vdp_background.vhd:287:33  */
  assign n2381_o = smode_m4 ? n2380_o : tile_y;
  /* ./vdp_background.vhd:287:33  */
  assign n2382_o = smode_m4 ? n2031_o : n2304_o;
  /* ./vdp_background.vhd:287:33  */
  assign n2383_o = smode_m4 ? n2032_o : n2306_o;
  /* ./vdp_background.vhd:287:33  */
  assign n2384_o = smode_m4 ? n2033_o : n2308_o;
  /* ./vdp_background.vhd:287:33  */
  assign n2385_o = smode_m4 ? datac : n2309_o;
  assign n2386_o = {n2325_o, n2323_o, n2321_o, n2319_o, n2317_o, n2315_o, n2313_o, n2311_o};
  /* ./vdp_background.vhd:287:33  */
  assign n2387_o = smode_m4 ? n2034_o : n2386_o;
  assign n2388_o = {n2341_o, n2339_o, n2337_o, n2335_o, n2333_o, n2331_o, n2329_o, n2327_o};
  /* ./vdp_background.vhd:287:33  */
  assign n2389_o = smode_m4 ? n2035_o : n2388_o;
  assign n2390_o = {n2357_o, n2355_o, n2353_o, n2351_o, n2349_o, n2347_o, n2345_o, n2343_o};
  /* ./vdp_background.vhd:287:33  */
  assign n2391_o = smode_m4 ? n2036_o : n2390_o;
  assign n2392_o = {n2373_o, n2371_o, n2369_o, n2367_o, n2365_o, n2363_o, n2361_o, n2359_o};
  /* ./vdp_background.vhd:287:33  */
  assign n2393_o = smode_m4 ? data3 : n2392_o;
  assign n2394_o = {n2379_o, n2376_o};
  /* ./vdp_background.vhd:267:33  */
  assign n2395_o = text_mode ? tile_index : n2394_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2396_o = text_mode ? tile_y : n2381_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2397_o = text_mode ? palette : n2382_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2398_o = text_mode ? priority_latch : n2383_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2399_o = text_mode ? flip_x : n2384_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2400_o = text_mode ? datac : n2385_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2401_o = text_mode ? data0 : n2387_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2402_o = text_mode ? data1 : n2389_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2403_o = text_mode ? data2 : n2391_o;
  /* ./vdp_background.vhd:267:33  */
  assign n2404_o = text_mode ? data3 : n2393_o;
  /* ./vdp_background.vhd:266:25  */
  assign n2405_o = n2417_o ? n1994_o : text_tile_index;
  /* ./vdp_background.vhd:266:25  */
  assign n2406_o = n2418_o ? n1995_o : text_pattern;
  /* ./vdp_background.vhd:266:25  */
  assign n2407_o = ce_pix ? n2395_o : tile_index;
  /* ./vdp_background.vhd:266:25  */
  assign n2408_o = ce_pix ? n2396_o : tile_y;
  /* ./vdp_background.vhd:266:25  */
  assign n2409_o = ce_pix ? n2397_o : palette;
  /* ./vdp_background.vhd:266:25  */
  assign n2410_o = ce_pix ? n2398_o : priority_latch;
  /* ./vdp_background.vhd:266:25  */
  assign n2411_o = ce_pix ? n2399_o : flip_x;
  /* ./vdp_background.vhd:266:25  */
  assign n2412_o = ce_pix ? n2400_o : datac;
  /* ./vdp_background.vhd:266:25  */
  assign n2413_o = ce_pix ? n2401_o : data0;
  /* ./vdp_background.vhd:266:25  */
  assign n2414_o = ce_pix ? n2402_o : data1;
  /* ./vdp_background.vhd:266:25  */
  assign n2415_o = ce_pix ? n2403_o : data2;
  /* ./vdp_background.vhd:266:25  */
  assign n2416_o = ce_pix ? n2404_o : data3;
  /* ./vdp_background.vhd:266:25  */
  assign n2417_o = text_mode & ce_pix;
  /* ./vdp_background.vhd:266:25  */
  assign n2418_o = text_mode & ce_pix;
  /* ./vdp_background.vhd:253:25  */
  assign n2420_o = ss_restore ? 9'b000000000 : n2407_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2422_o = ss_restore ? 3'b000 : n2408_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2424_o = ss_restore ? 1'b0 : n2409_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2426_o = ss_restore ? 1'b0 : n2410_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2428_o = ss_restore ? 1'b0 : n2411_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2430_o = ss_restore ? 8'b00000000 : n2412_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2432_o = ss_restore ? 8'b00000000 : n2413_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2434_o = ss_restore ? 8'b00000000 : n2414_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2436_o = ss_restore ? 8'b00000000 : n2415_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2438_o = ss_restore ? 8'b00000000 : n2416_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2440_o = ss_restore ? 8'b00000000 : n2405_o;
  /* ./vdp_background.vhd:253:25  */
  assign n2442_o = ss_restore ? 8'b00000000 : n2406_o;
  /* ./vdp_background.vhd:359:44  */
  assign n2459_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:359:66  */
  assign n2461_o = n2459_o == 32'b00000000000000000000000000000111;
  /* ./vdp_background.vhd:360:75  */
  assign n2462_o = text_pattern[7:2];
  /* ./vdp_background.vhd:362:47  */
  assign n2463_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:362:69  */
  assign n2465_o = $signed(n2463_o) >= $signed(32'b00000000000000000000000000001000);
  /* ./vdp_background.vhd:362:77  */
  assign n2466_o = {23'b0, screen_x};  //  uext
  /* ./vdp_background.vhd:362:99  */
  assign n2468_o = $signed(n2466_o) < $signed(32'b00000000000000000000000011111000);
  /* ./vdp_background.vhd:362:73  */
  assign n2469_o = n2468_o & n2465_o;
  /* ./vdp_background.vhd:363:62  */
  assign n2471_o = text_phase == 3'b101;
  /* ./vdp_background.vhd:364:83  */
  assign n2472_o = text_pattern[7:2];
  /* ./vdp_background.vhd:367:93  */
  assign n2473_o = text_shift[4:0];
  /* ./vdp_background.vhd:363:49  */
  assign n2476_o = n2471_o ? 1'b0 : n2675_q;
  assign n2477_o = {n2473_o, 1'b0};
  /* ./vdp_background.vhd:363:49  */
  assign n2478_o = n2471_o ? n2472_o : n2477_o;
  /* ./vdp_background.vhd:362:41  */
  assign n2480_o = n2469_o ? n2476_o : 1'b0;
  /* ./vdp_background.vhd:362:41  */
  assign n2482_o = n2469_o ? n2478_o : 6'b000000;
  /* ./vdp_background.vhd:359:41  */
  assign n2484_o = n2461_o ? 1'b0 : n2480_o;
  /* ./vdp_background.vhd:359:41  */
  assign n2485_o = n2461_o ? n2462_o : n2482_o;
  /* ./vdp_background.vhd:375:47  */
  assign n2486_o = x[2:0];
  /* ./vdp_background.vhd:377:58  */
  assign n2487_o = ~flip_x;
  /* ./vdp_background.vhd:381:57  */
  assign n2488_o = smode_m4 ? vram_d : data3;
  /* ./vdp_background.vhd:387:72  */
  assign n2489_o = data0[0];
  /* ./vdp_background.vhd:387:81  */
  assign n2490_o = data0[1];
  /* ./vdp_background.vhd:387:75  */
  assign n2491_o = {n2489_o, n2490_o};
  /* ./vdp_background.vhd:387:90  */
  assign n2492_o = data0[2];
  /* ./vdp_background.vhd:387:84  */
  assign n2493_o = {n2491_o, n2492_o};
  /* ./vdp_background.vhd:387:99  */
  assign n2494_o = data0[3];
  /* ./vdp_background.vhd:387:93  */
  assign n2495_o = {n2493_o, n2494_o};
  /* ./vdp_background.vhd:387:108  */
  assign n2496_o = data0[4];
  /* ./vdp_background.vhd:387:102  */
  assign n2497_o = {n2495_o, n2496_o};
  /* ./vdp_background.vhd:387:117  */
  assign n2498_o = data0[5];
  /* ./vdp_background.vhd:387:111  */
  assign n2499_o = {n2497_o, n2498_o};
  /* ./vdp_background.vhd:387:126  */
  assign n2500_o = data0[6];
  /* ./vdp_background.vhd:387:120  */
  assign n2501_o = {n2499_o, n2500_o};
  /* ./vdp_background.vhd:387:135  */
  assign n2502_o = data0[7];
  /* ./vdp_background.vhd:387:129  */
  assign n2503_o = {n2501_o, n2502_o};
  /* ./vdp_background.vhd:388:72  */
  assign n2504_o = data1[0];
  /* ./vdp_background.vhd:388:81  */
  assign n2505_o = data1[1];
  /* ./vdp_background.vhd:388:75  */
  assign n2506_o = {n2504_o, n2505_o};
  /* ./vdp_background.vhd:388:90  */
  assign n2507_o = data1[2];
  /* ./vdp_background.vhd:388:84  */
  assign n2508_o = {n2506_o, n2507_o};
  /* ./vdp_background.vhd:388:99  */
  assign n2509_o = data1[3];
  /* ./vdp_background.vhd:388:93  */
  assign n2510_o = {n2508_o, n2509_o};
  /* ./vdp_background.vhd:388:108  */
  assign n2511_o = data1[4];
  /* ./vdp_background.vhd:388:102  */
  assign n2512_o = {n2510_o, n2511_o};
  /* ./vdp_background.vhd:388:117  */
  assign n2513_o = data1[5];
  /* ./vdp_background.vhd:388:111  */
  assign n2514_o = {n2512_o, n2513_o};
  /* ./vdp_background.vhd:388:126  */
  assign n2515_o = data1[6];
  /* ./vdp_background.vhd:388:120  */
  assign n2516_o = {n2514_o, n2515_o};
  /* ./vdp_background.vhd:388:135  */
  assign n2517_o = data1[7];
  /* ./vdp_background.vhd:388:129  */
  assign n2518_o = {n2516_o, n2517_o};
  /* ./vdp_background.vhd:389:72  */
  assign n2519_o = data2[0];
  /* ./vdp_background.vhd:389:81  */
  assign n2520_o = data2[1];
  /* ./vdp_background.vhd:389:75  */
  assign n2521_o = {n2519_o, n2520_o};
  /* ./vdp_background.vhd:389:90  */
  assign n2522_o = data2[2];
  /* ./vdp_background.vhd:389:84  */
  assign n2523_o = {n2521_o, n2522_o};
  /* ./vdp_background.vhd:389:99  */
  assign n2524_o = data2[3];
  /* ./vdp_background.vhd:389:93  */
  assign n2525_o = {n2523_o, n2524_o};
  /* ./vdp_background.vhd:389:108  */
  assign n2526_o = data2[4];
  /* ./vdp_background.vhd:389:102  */
  assign n2527_o = {n2525_o, n2526_o};
  /* ./vdp_background.vhd:389:117  */
  assign n2528_o = data2[5];
  /* ./vdp_background.vhd:389:111  */
  assign n2529_o = {n2527_o, n2528_o};
  /* ./vdp_background.vhd:389:126  */
  assign n2530_o = data2[6];
  /* ./vdp_background.vhd:389:120  */
  assign n2531_o = {n2529_o, n2530_o};
  /* ./vdp_background.vhd:389:135  */
  assign n2532_o = data2[7];
  /* ./vdp_background.vhd:389:129  */
  assign n2533_o = {n2531_o, n2532_o};
  /* ./vdp_background.vhd:390:73  */
  assign n2534_o = vram_d[0];
  /* ./vdp_background.vhd:390:83  */
  assign n2535_o = vram_d[1];
  /* ./vdp_background.vhd:390:76  */
  assign n2536_o = {n2534_o, n2535_o};
  /* ./vdp_background.vhd:390:93  */
  assign n2537_o = vram_d[2];
  /* ./vdp_background.vhd:390:86  */
  assign n2538_o = {n2536_o, n2537_o};
  /* ./vdp_background.vhd:390:103  */
  assign n2539_o = vram_d[3];
  /* ./vdp_background.vhd:390:96  */
  assign n2540_o = {n2538_o, n2539_o};
  /* ./vdp_background.vhd:390:113  */
  assign n2541_o = vram_d[4];
  /* ./vdp_background.vhd:390:106  */
  assign n2542_o = {n2540_o, n2541_o};
  /* ./vdp_background.vhd:390:123  */
  assign n2543_o = vram_d[5];
  /* ./vdp_background.vhd:390:116  */
  assign n2544_o = {n2542_o, n2543_o};
  /* ./vdp_background.vhd:390:133  */
  assign n2545_o = vram_d[6];
  /* ./vdp_background.vhd:390:126  */
  assign n2546_o = {n2544_o, n2545_o};
  /* ./vdp_background.vhd:390:143  */
  assign n2547_o = vram_d[7];
  /* ./vdp_background.vhd:390:136  */
  assign n2548_o = {n2546_o, n2547_o};
  /* ./vdp_background.vhd:377:49  */
  assign n2549_o = n2487_o ? data0 : n2503_o;
  /* ./vdp_background.vhd:377:49  */
  assign n2550_o = n2487_o ? data1 : n2518_o;
  /* ./vdp_background.vhd:377:49  */
  assign n2551_o = n2487_o ? data2 : n2533_o;
  /* ./vdp_background.vhd:377:49  */
  assign n2552_o = n2487_o ? n2488_o : n2548_o;
  /* ./vdp_background.vhd:376:41  */
  assign n2554_o = n2486_o == 3'b111;
  /* ./vdp_background.vhd:395:77  */
  assign n2555_o = shift0[6:0];
  /* ./vdp_background.vhd:396:77  */
  assign n2556_o = shift1[6:0];
  /* ./vdp_background.vhd:397:77  */
  assign n2557_o = shift2[6:0];
  /* ./vdp_background.vhd:398:77  */
  assign n2558_o = shift3[6:0];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2559_o = priority_latch;
      default: n2559_o = n2675_q;
    endcase
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2560_o = palette;
      default: n2560_o = palette_shift;
    endcase
  assign n2561_o = n2549_o[0];
  assign n2562_o = shift0[0];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2563_o = n2561_o;
      default: n2563_o = n2562_o;
    endcase
  assign n2564_o = n2549_o[7:1];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2565_o = n2564_o;
      default: n2565_o = n2555_o;
    endcase
  assign n2566_o = n2550_o[0];
  assign n2567_o = shift1[0];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2568_o = n2566_o;
      default: n2568_o = n2567_o;
    endcase
  assign n2569_o = n2550_o[7:1];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2570_o = n2569_o;
      default: n2570_o = n2556_o;
    endcase
  assign n2571_o = n2551_o[0];
  assign n2572_o = shift2[0];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2573_o = n2571_o;
      default: n2573_o = n2572_o;
    endcase
  assign n2574_o = n2551_o[7:1];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2575_o = n2574_o;
      default: n2575_o = n2557_o;
    endcase
  assign n2576_o = n2552_o[0];
  assign n2577_o = shift3[0];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2578_o = n2576_o;
      default: n2578_o = n2577_o;
    endcase
  assign n2579_o = n2552_o[7:1];
  /* ./vdp_background.vhd:375:41  */
  always @*
    case (n2554_o)
      1'b1: n2580_o = n2579_o;
      default: n2580_o = n2558_o;
    endcase
  /* ./vdp_background.vhd:358:33  */
  assign n2581_o = text_mode ? n2484_o : n2559_o;
  /* ./vdp_background.vhd:358:33  */
  assign n2582_o = text_mode ? palette_shift : n2560_o;
  assign n2583_o = {n2565_o, n2563_o};
  /* ./vdp_background.vhd:358:33  */
  assign n2584_o = text_mode ? shift0 : n2583_o;
  assign n2585_o = {n2570_o, n2568_o};
  /* ./vdp_background.vhd:358:33  */
  assign n2586_o = text_mode ? shift1 : n2585_o;
  assign n2587_o = {n2575_o, n2573_o};
  /* ./vdp_background.vhd:358:33  */
  assign n2588_o = text_mode ? shift2 : n2587_o;
  assign n2589_o = {n2580_o, n2578_o};
  /* ./vdp_background.vhd:358:33  */
  assign n2590_o = text_mode ? shift3 : n2589_o;
  /* ./vdp_background.vhd:357:25  */
  assign n2591_o = n2598_o ? n2485_o : text_shift;
  /* ./vdp_background.vhd:357:25  */
  assign n2592_o = ce_pix ? n2581_o : n2675_q;
  /* ./vdp_background.vhd:357:25  */
  assign n2593_o = ce_pix ? n2582_o : palette_shift;
  /* ./vdp_background.vhd:357:25  */
  assign n2594_o = ce_pix ? n2584_o : shift0;
  /* ./vdp_background.vhd:357:25  */
  assign n2595_o = ce_pix ? n2586_o : shift1;
  /* ./vdp_background.vhd:357:25  */
  assign n2596_o = ce_pix ? n2588_o : shift2;
  /* ./vdp_background.vhd:357:25  */
  assign n2597_o = ce_pix ? n2590_o : shift3;
  /* ./vdp_background.vhd:357:25  */
  assign n2598_o = text_mode & ce_pix;
  /* ./vdp_background.vhd:349:25  */
  assign n2600_o = ss_restore ? 1'b0 : n2592_o;
  /* ./vdp_background.vhd:349:25  */
  assign n2602_o = ss_restore ? 1'b0 : n2593_o;
  /* ./vdp_background.vhd:349:25  */
  assign n2604_o = ss_restore ? 8'b00000000 : n2594_o;
  /* ./vdp_background.vhd:349:25  */
  assign n2606_o = ss_restore ? 8'b00000000 : n2595_o;
  /* ./vdp_background.vhd:349:25  */
  assign n2608_o = ss_restore ? 8'b00000000 : n2596_o;
  /* ./vdp_background.vhd:349:25  */
  assign n2610_o = ss_restore ? 8'b00000000 : n2597_o;
  /* ./vdp_background.vhd:349:25  */
  assign n2612_o = ss_restore ? 6'b000000 : n2591_o;
  /* ./vdp_background.vhd:405:27  */
  assign n2621_o = shift0[7];
  /* ./vdp_background.vhd:405:45  */
  assign n2622_o = ~text_mode;
  /* ./vdp_background.vhd:405:31  */
  assign n2623_o = n2622_o ? n2621_o : n2626_o;
  /* ./vdp_background.vhd:405:68  */
  assign n2624_o = text_fg_color[0];
  /* ./vdp_background.vhd:405:87  */
  assign n2625_o = text_shift[5];
  /* ./vdp_background.vhd:405:50  */
  assign n2626_o = n2625_o ? n2624_o : n2627_o;
  /* ./vdp_background.vhd:405:108  */
  assign n2627_o = overscan[0];
  /* ./vdp_background.vhd:406:27  */
  assign n2628_o = shift1[7];
  /* ./vdp_background.vhd:406:45  */
  assign n2629_o = ~text_mode;
  /* ./vdp_background.vhd:406:31  */
  assign n2630_o = n2629_o ? n2628_o : n2633_o;
  /* ./vdp_background.vhd:406:68  */
  assign n2631_o = text_fg_color[1];
  /* ./vdp_background.vhd:406:87  */
  assign n2632_o = text_shift[5];
  /* ./vdp_background.vhd:406:50  */
  assign n2633_o = n2632_o ? n2631_o : n2634_o;
  /* ./vdp_background.vhd:406:108  */
  assign n2634_o = overscan[1];
  /* ./vdp_background.vhd:407:27  */
  assign n2635_o = shift2[7];
  /* ./vdp_background.vhd:407:45  */
  assign n2636_o = ~text_mode;
  /* ./vdp_background.vhd:407:31  */
  assign n2637_o = n2636_o ? n2635_o : n2640_o;
  /* ./vdp_background.vhd:407:68  */
  assign n2638_o = text_fg_color[2];
  /* ./vdp_background.vhd:407:87  */
  assign n2639_o = text_shift[5];
  /* ./vdp_background.vhd:407:50  */
  assign n2640_o = n2639_o ? n2638_o : n2641_o;
  /* ./vdp_background.vhd:407:108  */
  assign n2641_o = overscan[2];
  /* ./vdp_background.vhd:408:27  */
  assign n2642_o = shift3[7];
  /* ./vdp_background.vhd:408:45  */
  assign n2643_o = ~text_mode;
  /* ./vdp_background.vhd:408:31  */
  assign n2644_o = n2643_o ? n2642_o : n2647_o;
  /* ./vdp_background.vhd:408:68  */
  assign n2645_o = text_fg_color[3];
  /* ./vdp_background.vhd:408:87  */
  assign n2646_o = text_shift[5];
  /* ./vdp_background.vhd:408:50  */
  assign n2647_o = n2646_o ? n2645_o : n2648_o;
  /* ./vdp_background.vhd:408:108  */
  assign n2648_o = overscan[3];
  /* ./vdp_background.vhd:409:25  */
  assign n2650_o = text_mode ? 1'b0 : palette_shift;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2651_q <= n2420_o;
  /* ./vdp_background.vhd:83:17  */
  always @(posedge clk_sys)
    n2652_q <= n1728_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2653_q <= n2422_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2654_q <= n2424_o;
  /* ./vdp_background.vhd:348:17  */
  always @(posedge clk_sys)
    n2655_q <= n2602_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2656_q <= n2426_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2657_q <= n2428_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2658_q <= n2430_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2659_q <= n2432_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2660_q <= n2434_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2661_q <= n2436_o;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2662_q <= n2438_o;
  /* ./vdp_background.vhd:348:17  */
  always @(posedge clk_sys)
    n2663_q <= n2604_o;
  /* ./vdp_background.vhd:348:17  */
  always @(posedge clk_sys)
    n2664_q <= n2606_o;
  /* ./vdp_background.vhd:348:17  */
  always @(posedge clk_sys)
    n2665_q <= n2608_o;
  /* ./vdp_background.vhd:348:17  */
  always @(posedge clk_sys)
    n2666_q <= n2610_o;
  /* ./vdp_background.vhd:348:17  */
  always @(posedge clk_sys)
    n2667_q <= n2612_o;
  initial
    n2667_q = 6'b000000;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2668_q <= n2440_o;
  initial
    n2668_q = 8'b00000000;
  /* ./vdp_background.vhd:252:17  */
  always @(posedge clk_sys)
    n2669_q <= n2442_o;
  initial
    n2669_q = 8'b00000000;
  /* ./vdp_background.vhd:119:17  */
  always @(posedge clk_sys)
    n2670_q <= n1770_o;
  initial
    n2670_q = 3'b000;
  /* ./vdp_background.vhd:119:17  */
  always @(posedge clk_sys)
    n2671_q <= n1772_o;
  initial
    n2671_q = 6'b000000;
  /* ./vdp_background.vhd:155:17  */
  assign n2672_o = ce_pix ? n1937_o : n2673_q;
  /* ./vdp_background.vhd:155:17  */
  always @(posedge clk_sys)
    n2673_q <= n2672_o;
  /* ./vdp_background.vhd:155:17  */
  assign n2674_o = {n2650_o, n2644_o, n2637_o, n2630_o, n2623_o};
  /* ./vdp_background.vhd:348:17  */
  always @(posedge clk_sys)
    n2675_q <= n2600_o;
endmodule

module vdp_cram
  (input  cpu_clk,
   input  cpu_we,
   input  [4:0] cpu_a,
   input  [11:0] cpu_d,
   input  vdp_clk,
   input  [4:0] vdp_a,
   input  ss_wr,
   input  [4:0] ss_a,
   input  [11:0] ss_wd,
   output [11:0] vdp_d,
   output [383:0] ss_d);
  reg [383:0] ram;
  wire [4:0] n1285_o;
  wire [4:0] n1290_o;
  wire [383:0] n1293_o;
  wire [383:0] n1295_o;
  wire [11:0] n1301_o;
  wire [11:0] n1302_o;
  wire [11:0] n1303_o;
  wire [11:0] n1304_o;
  wire [11:0] n1305_o;
  wire [11:0] n1306_o;
  wire [11:0] n1307_o;
  wire [11:0] n1308_o;
  wire [11:0] n1309_o;
  wire [11:0] n1310_o;
  wire [11:0] n1311_o;
  wire [11:0] n1312_o;
  wire [11:0] n1313_o;
  wire [11:0] n1314_o;
  wire [11:0] n1315_o;
  wire [11:0] n1316_o;
  wire [11:0] n1317_o;
  wire [11:0] n1318_o;
  wire [11:0] n1319_o;
  wire [11:0] n1320_o;
  wire [11:0] n1321_o;
  wire [11:0] n1322_o;
  wire [11:0] n1323_o;
  wire [11:0] n1324_o;
  wire [11:0] n1325_o;
  wire [11:0] n1326_o;
  wire [11:0] n1327_o;
  wire [11:0] n1328_o;
  wire [11:0] n1329_o;
  wire [11:0] n1330_o;
  wire [11:0] n1331_o;
  wire [11:0] n1332_o;
  wire [4:0] n1339_o;
  reg [383:0] n1345_q;
  reg [11:0] n1346_q;
  wire [383:0] n1347_o;
  wire n1348_o;
  wire n1349_o;
  wire n1350_o;
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
  wire n1369_o;
  wire n1370_o;
  wire n1371_o;
  wire n1372_o;
  wire n1373_o;
  wire n1374_o;
  wire n1375_o;
  wire n1376_o;
  wire n1377_o;
  wire n1378_o;
  wire n1379_o;
  wire n1380_o;
  wire n1381_o;
  wire n1382_o;
  wire n1383_o;
  wire n1384_o;
  wire n1385_o;
  wire n1386_o;
  wire n1387_o;
  wire n1388_o;
  wire n1389_o;
  wire n1390_o;
  wire n1391_o;
  wire n1392_o;
  wire n1393_o;
  wire n1394_o;
  wire n1395_o;
  wire n1396_o;
  wire n1397_o;
  wire n1398_o;
  wire n1399_o;
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
  wire [11:0] n1418_o;
  wire [11:0] n1419_o;
  wire [11:0] n1420_o;
  wire [11:0] n1421_o;
  wire [11:0] n1422_o;
  wire [11:0] n1423_o;
  wire [11:0] n1424_o;
  wire [11:0] n1425_o;
  wire [11:0] n1426_o;
  wire [11:0] n1427_o;
  wire [11:0] n1428_o;
  wire [11:0] n1429_o;
  wire [11:0] n1430_o;
  wire [11:0] n1431_o;
  wire [11:0] n1432_o;
  wire [11:0] n1433_o;
  wire [11:0] n1434_o;
  wire [11:0] n1435_o;
  wire [11:0] n1436_o;
  wire [11:0] n1437_o;
  wire [11:0] n1438_o;
  wire [11:0] n1439_o;
  wire [11:0] n1440_o;
  wire [11:0] n1441_o;
  wire [11:0] n1442_o;
  wire [11:0] n1443_o;
  wire [11:0] n1444_o;
  wire [11:0] n1445_o;
  wire [11:0] n1446_o;
  wire [11:0] n1447_o;
  wire [11:0] n1448_o;
  wire [11:0] n1449_o;
  wire [11:0] n1450_o;
  wire [11:0] n1451_o;
  wire [11:0] n1452_o;
  wire [11:0] n1453_o;
  wire [11:0] n1454_o;
  wire [11:0] n1455_o;
  wire [11:0] n1456_o;
  wire [11:0] n1457_o;
  wire [11:0] n1458_o;
  wire [11:0] n1459_o;
  wire [11:0] n1460_o;
  wire [11:0] n1461_o;
  wire [11:0] n1462_o;
  wire [11:0] n1463_o;
  wire [11:0] n1464_o;
  wire [11:0] n1465_o;
  wire [11:0] n1466_o;
  wire [11:0] n1467_o;
  wire [11:0] n1468_o;
  wire [11:0] n1469_o;
  wire [11:0] n1470_o;
  wire [11:0] n1471_o;
  wire [11:0] n1472_o;
  wire [11:0] n1473_o;
  wire [11:0] n1474_o;
  wire [11:0] n1475_o;
  wire [11:0] n1476_o;
  wire [11:0] n1477_o;
  wire [11:0] n1478_o;
  wire [11:0] n1479_o;
  wire [11:0] n1480_o;
  wire [11:0] n1481_o;
  wire [383:0] n1482_o;
  wire n1483_o;
  wire n1484_o;
  wire n1485_o;
  wire n1486_o;
  wire n1487_o;
  wire n1488_o;
  wire n1489_o;
  wire n1490_o;
  wire n1491_o;
  wire n1492_o;
  wire n1493_o;
  wire n1494_o;
  wire n1495_o;
  wire n1496_o;
  wire n1497_o;
  wire n1498_o;
  wire n1499_o;
  wire n1500_o;
  wire n1501_o;
  wire n1502_o;
  wire n1503_o;
  wire n1504_o;
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
  wire n1523_o;
  wire n1524_o;
  wire n1525_o;
  wire n1526_o;
  wire n1527_o;
  wire n1528_o;
  wire n1529_o;
  wire n1530_o;
  wire n1531_o;
  wire n1532_o;
  wire n1533_o;
  wire n1534_o;
  wire n1535_o;
  wire n1536_o;
  wire n1537_o;
  wire n1538_o;
  wire n1539_o;
  wire n1540_o;
  wire n1541_o;
  wire n1542_o;
  wire n1543_o;
  wire n1544_o;
  wire n1545_o;
  wire n1546_o;
  wire n1547_o;
  wire n1548_o;
  wire n1549_o;
  wire n1550_o;
  wire n1551_o;
  wire n1552_o;
  wire [11:0] n1553_o;
  wire [11:0] n1554_o;
  wire [11:0] n1555_o;
  wire [11:0] n1556_o;
  wire [11:0] n1557_o;
  wire [11:0] n1558_o;
  wire [11:0] n1559_o;
  wire [11:0] n1560_o;
  wire [11:0] n1561_o;
  wire [11:0] n1562_o;
  wire [11:0] n1563_o;
  wire [11:0] n1564_o;
  wire [11:0] n1565_o;
  wire [11:0] n1566_o;
  wire [11:0] n1567_o;
  wire [11:0] n1568_o;
  wire [11:0] n1569_o;
  wire [11:0] n1570_o;
  wire [11:0] n1571_o;
  wire [11:0] n1572_o;
  wire [11:0] n1573_o;
  wire [11:0] n1574_o;
  wire [11:0] n1575_o;
  wire [11:0] n1576_o;
  wire [11:0] n1577_o;
  wire [11:0] n1578_o;
  wire [11:0] n1579_o;
  wire [11:0] n1580_o;
  wire [11:0] n1581_o;
  wire [11:0] n1582_o;
  wire [11:0] n1583_o;
  wire [11:0] n1584_o;
  wire [11:0] n1585_o;
  wire [11:0] n1586_o;
  wire [11:0] n1587_o;
  wire [11:0] n1588_o;
  wire [11:0] n1589_o;
  wire [11:0] n1590_o;
  wire [11:0] n1591_o;
  wire [11:0] n1592_o;
  wire [11:0] n1593_o;
  wire [11:0] n1594_o;
  wire [11:0] n1595_o;
  wire [11:0] n1596_o;
  wire [11:0] n1597_o;
  wire [11:0] n1598_o;
  wire [11:0] n1599_o;
  wire [11:0] n1600_o;
  wire [11:0] n1601_o;
  wire [11:0] n1602_o;
  wire [11:0] n1603_o;
  wire [11:0] n1604_o;
  wire [11:0] n1605_o;
  wire [11:0] n1606_o;
  wire [11:0] n1607_o;
  wire [11:0] n1608_o;
  wire [11:0] n1609_o;
  wire [11:0] n1610_o;
  wire [11:0] n1611_o;
  wire [11:0] n1612_o;
  wire [11:0] n1613_o;
  wire [11:0] n1614_o;
  wire [11:0] n1615_o;
  wire [11:0] n1616_o;
  wire [383:0] n1617_o;
  wire [11:0] n1618_o;
  wire [11:0] n1619_o;
  wire [11:0] n1620_o;
  wire [11:0] n1621_o;
  wire [11:0] n1622_o;
  wire [11:0] n1623_o;
  wire [11:0] n1624_o;
  wire [11:0] n1625_o;
  wire [11:0] n1626_o;
  wire [11:0] n1627_o;
  wire [11:0] n1628_o;
  wire [11:0] n1629_o;
  wire [11:0] n1630_o;
  wire [11:0] n1631_o;
  wire [11:0] n1632_o;
  wire [11:0] n1633_o;
  wire [11:0] n1634_o;
  wire [11:0] n1635_o;
  wire [11:0] n1636_o;
  wire [11:0] n1637_o;
  wire [11:0] n1638_o;
  wire [11:0] n1639_o;
  wire [11:0] n1640_o;
  wire [11:0] n1641_o;
  wire [11:0] n1642_o;
  wire [11:0] n1643_o;
  wire [11:0] n1644_o;
  wire [11:0] n1645_o;
  wire [11:0] n1646_o;
  wire [11:0] n1647_o;
  wire [11:0] n1648_o;
  wire [11:0] n1649_o;
  wire [1:0] n1650_o;
  reg [11:0] n1651_o;
  wire [1:0] n1652_o;
  reg [11:0] n1653_o;
  wire [1:0] n1654_o;
  reg [11:0] n1655_o;
  wire [1:0] n1656_o;
  reg [11:0] n1657_o;
  wire [1:0] n1658_o;
  reg [11:0] n1659_o;
  wire [1:0] n1660_o;
  reg [11:0] n1661_o;
  wire [1:0] n1662_o;
  reg [11:0] n1663_o;
  wire [1:0] n1664_o;
  reg [11:0] n1665_o;
  wire [1:0] n1666_o;
  reg [11:0] n1667_o;
  wire [1:0] n1668_o;
  reg [11:0] n1669_o;
  wire n1670_o;
  wire [11:0] n1671_o;
  assign vdp_d = n1346_q;
  assign ss_d = n1347_o;
  /* ./vdp_cram.vhd:26:16  */
  always @*
    ram = n1345_q; // (isignal)
  initial
    ram = 384'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
  /* ./vdp_cram.vhd:36:37  */
  assign n1285_o = 5'b11111 - ss_a;
  /* ./vdp_cram.vhd:39:37  */
  assign n1290_o = 5'b11111 - cpu_a;
  /* ./vdp_cram.vhd:37:25  */
  assign n1293_o = cpu_we ? n1617_o : ram;
  /* ./vdp_cram.vhd:34:25  */
  assign n1295_o = ss_wr ? n1482_o : n1293_o;
  /* ./vdp_cram.vhd:46:53  */
  assign n1301_o = ram[383:372];
  /* ./vdp_cram.vhd:46:53  */
  assign n1302_o = ram[371:360];
  /* ./vdp_cram.vhd:46:53  */
  assign n1303_o = ram[359:348];
  /* ./vdp_cram.vhd:46:53  */
  assign n1304_o = ram[347:336];
  /* ./vdp_cram.vhd:46:53  */
  assign n1305_o = ram[335:324];
  /* ./vdp_cram.vhd:46:53  */
  assign n1306_o = ram[323:312];
  /* ./vdp_cram.vhd:46:53  */
  assign n1307_o = ram[311:300];
  /* ./vdp_cram.vhd:46:53  */
  assign n1308_o = ram[299:288];
  /* ./vdp_cram.vhd:46:53  */
  assign n1309_o = ram[287:276];
  /* ./vdp_cram.vhd:46:53  */
  assign n1310_o = ram[275:264];
  /* ./vdp_cram.vhd:46:53  */
  assign n1311_o = ram[263:252];
  /* ./vdp_cram.vhd:46:53  */
  assign n1312_o = ram[251:240];
  /* ./vdp_cram.vhd:46:53  */
  assign n1313_o = ram[239:228];
  /* ./vdp_cram.vhd:46:53  */
  assign n1314_o = ram[227:216];
  /* ./vdp_cram.vhd:46:53  */
  assign n1315_o = ram[215:204];
  /* ./vdp_cram.vhd:46:53  */
  assign n1316_o = ram[203:192];
  /* ./vdp_cram.vhd:46:53  */
  assign n1317_o = ram[191:180];
  /* ./vdp_cram.vhd:46:53  */
  assign n1318_o = ram[179:168];
  /* ./vdp_cram.vhd:46:53  */
  assign n1319_o = ram[167:156];
  /* ./vdp_cram.vhd:46:53  */
  assign n1320_o = ram[155:144];
  /* ./vdp_cram.vhd:46:53  */
  assign n1321_o = ram[143:132];
  /* ./vdp_cram.vhd:46:53  */
  assign n1322_o = ram[131:120];
  /* ./vdp_cram.vhd:46:53  */
  assign n1323_o = ram[119:108];
  /* ./vdp_cram.vhd:46:53  */
  assign n1324_o = ram[107:96];
  /* ./vdp_cram.vhd:46:53  */
  assign n1325_o = ram[95:84];
  /* ./vdp_cram.vhd:46:53  */
  assign n1326_o = ram[83:72];
  /* ./vdp_cram.vhd:46:53  */
  assign n1327_o = ram[71:60];
  /* ./vdp_cram.vhd:46:53  */
  assign n1328_o = ram[59:48];
  /* ./vdp_cram.vhd:46:53  */
  assign n1329_o = ram[47:36];
  /* ./vdp_cram.vhd:46:53  */
  assign n1330_o = ram[35:24];
  /* ./vdp_cram.vhd:46:53  */
  assign n1331_o = ram[23:12];
  /* ./vdp_cram.vhd:46:53  */
  assign n1332_o = ram[11:0];
  /* ./vdp_cram.vhd:54:38  */
  assign n1339_o = 5'b11111 - vdp_a;
  /* ./vdp_cram.vhd:33:17  */
  always @(posedge cpu_clk)
    n1345_q <= n1295_o;
  initial
    n1345_q = 384'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
  /* ./vdp_cram.vhd:52:17  */
  always @(posedge vdp_clk)
    n1346_q <= n1671_o;
  /* ./vdp_cram.vhd:52:17  */
  assign n1347_o = {n1332_o, n1331_o, n1330_o, n1329_o, n1328_o, n1327_o, n1326_o, n1325_o, n1324_o, n1323_o, n1322_o, n1321_o, n1320_o, n1319_o, n1318_o, n1317_o, n1316_o, n1315_o, n1314_o, n1313_o, n1312_o, n1311_o, n1310_o, n1309_o, n1308_o, n1307_o, n1306_o, n1305_o, n1304_o, n1303_o, n1302_o, n1301_o};
  /* ./vdp_cram.vhd:36:33  */
  assign n1348_o = n1285_o[4];
  /* ./vdp_cram.vhd:36:33  */
  assign n1349_o = ~n1348_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1350_o = n1285_o[3];
  /* ./vdp_cram.vhd:36:33  */
  assign n1351_o = ~n1350_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1352_o = n1349_o & n1351_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1353_o = n1349_o & n1350_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1354_o = n1348_o & n1351_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1355_o = n1348_o & n1350_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1356_o = n1285_o[2];
  /* ./vdp_cram.vhd:36:33  */
  assign n1357_o = ~n1356_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1358_o = n1352_o & n1357_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1359_o = n1352_o & n1356_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1360_o = n1353_o & n1357_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1361_o = n1353_o & n1356_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1362_o = n1354_o & n1357_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1363_o = n1354_o & n1356_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1364_o = n1355_o & n1357_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1365_o = n1355_o & n1356_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1366_o = n1285_o[1];
  /* ./vdp_cram.vhd:36:33  */
  assign n1367_o = ~n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1368_o = n1358_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1369_o = n1358_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1370_o = n1359_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1371_o = n1359_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1372_o = n1360_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1373_o = n1360_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1374_o = n1361_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1375_o = n1361_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1376_o = n1362_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1377_o = n1362_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1378_o = n1363_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1379_o = n1363_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1380_o = n1364_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1381_o = n1364_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1382_o = n1365_o & n1367_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1383_o = n1365_o & n1366_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1384_o = n1285_o[0];
  /* ./vdp_cram.vhd:36:33  */
  assign n1385_o = ~n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1386_o = n1368_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1387_o = n1368_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1388_o = n1369_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1389_o = n1369_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1390_o = n1370_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1391_o = n1370_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1392_o = n1371_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1393_o = n1371_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1394_o = n1372_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1395_o = n1372_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1396_o = n1373_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1397_o = n1373_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1398_o = n1374_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1399_o = n1374_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1400_o = n1375_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1401_o = n1375_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1402_o = n1376_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1403_o = n1376_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1404_o = n1377_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1405_o = n1377_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1406_o = n1378_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1407_o = n1378_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1408_o = n1379_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1409_o = n1379_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1410_o = n1380_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1411_o = n1380_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1412_o = n1381_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1413_o = n1381_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1414_o = n1382_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1415_o = n1382_o & n1384_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1416_o = n1383_o & n1385_o;
  /* ./vdp_cram.vhd:36:33  */
  assign n1417_o = n1383_o & n1384_o;
  assign n1418_o = ram[11:0];
  /* ./vdp_cram.vhd:36:33  */
  assign n1419_o = n1386_o ? ss_wd : n1418_o;
  assign n1420_o = ram[23:12];
  /* ./vdp_cram.vhd:36:33  */
  assign n1421_o = n1387_o ? ss_wd : n1420_o;
  assign n1422_o = ram[35:24];
  /* ./vdp_cram.vhd:36:33  */
  assign n1423_o = n1388_o ? ss_wd : n1422_o;
  assign n1424_o = ram[47:36];
  /* ./vdp_cram.vhd:36:33  */
  assign n1425_o = n1389_o ? ss_wd : n1424_o;
  assign n1426_o = ram[59:48];
  /* ./vdp_cram.vhd:36:33  */
  assign n1427_o = n1390_o ? ss_wd : n1426_o;
  assign n1428_o = ram[71:60];
  /* ./vdp_cram.vhd:36:33  */
  assign n1429_o = n1391_o ? ss_wd : n1428_o;
  assign n1430_o = ram[83:72];
  /* ./vdp_cram.vhd:36:33  */
  assign n1431_o = n1392_o ? ss_wd : n1430_o;
  assign n1432_o = ram[95:84];
  /* ./vdp_cram.vhd:36:33  */
  assign n1433_o = n1393_o ? ss_wd : n1432_o;
  assign n1434_o = ram[107:96];
  /* ./vdp_cram.vhd:36:33  */
  assign n1435_o = n1394_o ? ss_wd : n1434_o;
  assign n1436_o = ram[119:108];
  /* ./vdp_cram.vhd:36:33  */
  assign n1437_o = n1395_o ? ss_wd : n1436_o;
  assign n1438_o = ram[131:120];
  /* ./vdp_cram.vhd:36:33  */
  assign n1439_o = n1396_o ? ss_wd : n1438_o;
  assign n1440_o = ram[143:132];
  /* ./vdp_cram.vhd:36:33  */
  assign n1441_o = n1397_o ? ss_wd : n1440_o;
  assign n1442_o = ram[155:144];
  /* ./vdp_cram.vhd:36:33  */
  assign n1443_o = n1398_o ? ss_wd : n1442_o;
  assign n1444_o = ram[167:156];
  /* ./vdp_cram.vhd:36:33  */
  assign n1445_o = n1399_o ? ss_wd : n1444_o;
  assign n1446_o = ram[179:168];
  /* ./vdp_cram.vhd:36:33  */
  assign n1447_o = n1400_o ? ss_wd : n1446_o;
  assign n1448_o = ram[191:180];
  /* ./vdp_cram.vhd:36:33  */
  assign n1449_o = n1401_o ? ss_wd : n1448_o;
  assign n1450_o = ram[203:192];
  /* ./vdp_cram.vhd:36:33  */
  assign n1451_o = n1402_o ? ss_wd : n1450_o;
  assign n1452_o = ram[215:204];
  /* ./vdp_cram.vhd:36:33  */
  assign n1453_o = n1403_o ? ss_wd : n1452_o;
  assign n1454_o = ram[227:216];
  /* ./vdp_cram.vhd:36:33  */
  assign n1455_o = n1404_o ? ss_wd : n1454_o;
  assign n1456_o = ram[239:228];
  /* ./vdp_cram.vhd:36:33  */
  assign n1457_o = n1405_o ? ss_wd : n1456_o;
  assign n1458_o = ram[251:240];
  /* ./vdp_cram.vhd:36:33  */
  assign n1459_o = n1406_o ? ss_wd : n1458_o;
  assign n1460_o = ram[263:252];
  /* ./vdp_cram.vhd:36:33  */
  assign n1461_o = n1407_o ? ss_wd : n1460_o;
  assign n1462_o = ram[275:264];
  /* ./vdp_cram.vhd:36:33  */
  assign n1463_o = n1408_o ? ss_wd : n1462_o;
  assign n1464_o = ram[287:276];
  /* ./vdp_cram.vhd:36:33  */
  assign n1465_o = n1409_o ? ss_wd : n1464_o;
  assign n1466_o = ram[299:288];
  /* ./vdp_cram.vhd:36:33  */
  assign n1467_o = n1410_o ? ss_wd : n1466_o;
  assign n1468_o = ram[311:300];
  /* ./vdp_cram.vhd:36:33  */
  assign n1469_o = n1411_o ? ss_wd : n1468_o;
  assign n1470_o = ram[323:312];
  /* ./vdp_cram.vhd:36:33  */
  assign n1471_o = n1412_o ? ss_wd : n1470_o;
  assign n1472_o = ram[335:324];
  /* ./vdp_cram.vhd:36:33  */
  assign n1473_o = n1413_o ? ss_wd : n1472_o;
  assign n1474_o = ram[347:336];
  /* ./vdp_cram.vhd:36:33  */
  assign n1475_o = n1414_o ? ss_wd : n1474_o;
  assign n1476_o = ram[359:348];
  /* ./vdp_cram.vhd:36:33  */
  assign n1477_o = n1415_o ? ss_wd : n1476_o;
  assign n1478_o = ram[371:360];
  /* ./vdp_cram.vhd:36:33  */
  assign n1479_o = n1416_o ? ss_wd : n1478_o;
  assign n1480_o = ram[383:372];
  /* ./vdp_cram.vhd:36:33  */
  assign n1481_o = n1417_o ? ss_wd : n1480_o;
  assign n1482_o = {n1481_o, n1479_o, n1477_o, n1475_o, n1473_o, n1471_o, n1469_o, n1467_o, n1465_o, n1463_o, n1461_o, n1459_o, n1457_o, n1455_o, n1453_o, n1451_o, n1449_o, n1447_o, n1445_o, n1443_o, n1441_o, n1439_o, n1437_o, n1435_o, n1433_o, n1431_o, n1429_o, n1427_o, n1425_o, n1423_o, n1421_o, n1419_o};
  /* ./vdp_cram.vhd:39:33  */
  assign n1483_o = n1290_o[4];
  /* ./vdp_cram.vhd:39:33  */
  assign n1484_o = ~n1483_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1485_o = n1290_o[3];
  /* ./vdp_cram.vhd:39:33  */
  assign n1486_o = ~n1485_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1487_o = n1484_o & n1486_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1488_o = n1484_o & n1485_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1489_o = n1483_o & n1486_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1490_o = n1483_o & n1485_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1491_o = n1290_o[2];
  /* ./vdp_cram.vhd:39:33  */
  assign n1492_o = ~n1491_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1493_o = n1487_o & n1492_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1494_o = n1487_o & n1491_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1495_o = n1488_o & n1492_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1496_o = n1488_o & n1491_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1497_o = n1489_o & n1492_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1498_o = n1489_o & n1491_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1499_o = n1490_o & n1492_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1500_o = n1490_o & n1491_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1501_o = n1290_o[1];
  /* ./vdp_cram.vhd:39:33  */
  assign n1502_o = ~n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1503_o = n1493_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1504_o = n1493_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1505_o = n1494_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1506_o = n1494_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1507_o = n1495_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1508_o = n1495_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1509_o = n1496_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1510_o = n1496_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1511_o = n1497_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1512_o = n1497_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1513_o = n1498_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1514_o = n1498_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1515_o = n1499_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1516_o = n1499_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1517_o = n1500_o & n1502_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1518_o = n1500_o & n1501_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1519_o = n1290_o[0];
  /* ./vdp_cram.vhd:39:33  */
  assign n1520_o = ~n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1521_o = n1503_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1522_o = n1503_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1523_o = n1504_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1524_o = n1504_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1525_o = n1505_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1526_o = n1505_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1527_o = n1506_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1528_o = n1506_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1529_o = n1507_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1530_o = n1507_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1531_o = n1508_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1532_o = n1508_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1533_o = n1509_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1534_o = n1509_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1535_o = n1510_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1536_o = n1510_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1537_o = n1511_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1538_o = n1511_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1539_o = n1512_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1540_o = n1512_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1541_o = n1513_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1542_o = n1513_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1543_o = n1514_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1544_o = n1514_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1545_o = n1515_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1546_o = n1515_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1547_o = n1516_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1548_o = n1516_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1549_o = n1517_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1550_o = n1517_o & n1519_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1551_o = n1518_o & n1520_o;
  /* ./vdp_cram.vhd:39:33  */
  assign n1552_o = n1518_o & n1519_o;
  assign n1553_o = ram[11:0];
  /* ./vdp_cram.vhd:39:33  */
  assign n1554_o = n1521_o ? cpu_d : n1553_o;
  assign n1555_o = ram[23:12];
  /* ./vdp_cram.vhd:39:33  */
  assign n1556_o = n1522_o ? cpu_d : n1555_o;
  assign n1557_o = ram[35:24];
  /* ./vdp_cram.vhd:39:33  */
  assign n1558_o = n1523_o ? cpu_d : n1557_o;
  assign n1559_o = ram[47:36];
  /* ./vdp_cram.vhd:39:33  */
  assign n1560_o = n1524_o ? cpu_d : n1559_o;
  assign n1561_o = ram[59:48];
  /* ./vdp_cram.vhd:39:33  */
  assign n1562_o = n1525_o ? cpu_d : n1561_o;
  assign n1563_o = ram[71:60];
  /* ./vdp_cram.vhd:39:33  */
  assign n1564_o = n1526_o ? cpu_d : n1563_o;
  assign n1565_o = ram[83:72];
  /* ./vdp_cram.vhd:39:33  */
  assign n1566_o = n1527_o ? cpu_d : n1565_o;
  assign n1567_o = ram[95:84];
  /* ./vdp_cram.vhd:39:33  */
  assign n1568_o = n1528_o ? cpu_d : n1567_o;
  assign n1569_o = ram[107:96];
  /* ./vdp_cram.vhd:39:33  */
  assign n1570_o = n1529_o ? cpu_d : n1569_o;
  assign n1571_o = ram[119:108];
  /* ./vdp_cram.vhd:39:33  */
  assign n1572_o = n1530_o ? cpu_d : n1571_o;
  assign n1573_o = ram[131:120];
  /* ./vdp_cram.vhd:39:33  */
  assign n1574_o = n1531_o ? cpu_d : n1573_o;
  assign n1575_o = ram[143:132];
  /* ./vdp_cram.vhd:39:33  */
  assign n1576_o = n1532_o ? cpu_d : n1575_o;
  assign n1577_o = ram[155:144];
  /* ./vdp_cram.vhd:39:33  */
  assign n1578_o = n1533_o ? cpu_d : n1577_o;
  assign n1579_o = ram[167:156];
  /* ./vdp_cram.vhd:39:33  */
  assign n1580_o = n1534_o ? cpu_d : n1579_o;
  assign n1581_o = ram[179:168];
  /* ./vdp_cram.vhd:39:33  */
  assign n1582_o = n1535_o ? cpu_d : n1581_o;
  assign n1583_o = ram[191:180];
  /* ./vdp_cram.vhd:39:33  */
  assign n1584_o = n1536_o ? cpu_d : n1583_o;
  assign n1585_o = ram[203:192];
  /* ./vdp_cram.vhd:39:33  */
  assign n1586_o = n1537_o ? cpu_d : n1585_o;
  assign n1587_o = ram[215:204];
  /* ./vdp_cram.vhd:39:33  */
  assign n1588_o = n1538_o ? cpu_d : n1587_o;
  assign n1589_o = ram[227:216];
  /* ./vdp_cram.vhd:39:33  */
  assign n1590_o = n1539_o ? cpu_d : n1589_o;
  assign n1591_o = ram[239:228];
  /* ./vdp_cram.vhd:39:33  */
  assign n1592_o = n1540_o ? cpu_d : n1591_o;
  assign n1593_o = ram[251:240];
  /* ./vdp_cram.vhd:39:33  */
  assign n1594_o = n1541_o ? cpu_d : n1593_o;
  assign n1595_o = ram[263:252];
  /* ./vdp_cram.vhd:39:33  */
  assign n1596_o = n1542_o ? cpu_d : n1595_o;
  assign n1597_o = ram[275:264];
  /* ./vdp_cram.vhd:39:33  */
  assign n1598_o = n1543_o ? cpu_d : n1597_o;
  assign n1599_o = ram[287:276];
  /* ./vdp_cram.vhd:39:33  */
  assign n1600_o = n1544_o ? cpu_d : n1599_o;
  assign n1601_o = ram[299:288];
  /* ./vdp_cram.vhd:39:33  */
  assign n1602_o = n1545_o ? cpu_d : n1601_o;
  assign n1603_o = ram[311:300];
  /* ./vdp_cram.vhd:39:33  */
  assign n1604_o = n1546_o ? cpu_d : n1603_o;
  assign n1605_o = ram[323:312];
  /* ./vdp_cram.vhd:39:33  */
  assign n1606_o = n1547_o ? cpu_d : n1605_o;
  assign n1607_o = ram[335:324];
  /* ./vdp_cram.vhd:39:33  */
  assign n1608_o = n1548_o ? cpu_d : n1607_o;
  assign n1609_o = ram[347:336];
  /* ./vdp_cram.vhd:39:33  */
  assign n1610_o = n1549_o ? cpu_d : n1609_o;
  assign n1611_o = ram[359:348];
  /* ./vdp_cram.vhd:39:33  */
  assign n1612_o = n1550_o ? cpu_d : n1611_o;
  assign n1613_o = ram[371:360];
  /* ./vdp_cram.vhd:39:33  */
  assign n1614_o = n1551_o ? cpu_d : n1613_o;
  assign n1615_o = ram[383:372];
  /* ./vdp_cram.vhd:39:33  */
  assign n1616_o = n1552_o ? cpu_d : n1615_o;
  assign n1617_o = {n1616_o, n1614_o, n1612_o, n1610_o, n1608_o, n1606_o, n1604_o, n1602_o, n1600_o, n1598_o, n1596_o, n1594_o, n1592_o, n1590_o, n1588_o, n1586_o, n1584_o, n1582_o, n1580_o, n1578_o, n1576_o, n1574_o, n1572_o, n1570_o, n1568_o, n1566_o, n1564_o, n1562_o, n1560_o, n1558_o, n1556_o, n1554_o};
  /* ./vdp_cram.vhd:39:37  */
  assign n1618_o = ram[11:0];
  /* ./vdp_cram.vhd:39:33  */
  assign n1619_o = ram[23:12];
  assign n1620_o = ram[35:24];
  assign n1621_o = ram[47:36];
  assign n1622_o = ram[59:48];
  assign n1623_o = ram[71:60];
  assign n1624_o = ram[83:72];
  assign n1625_o = ram[95:84];
  assign n1626_o = ram[107:96];
  assign n1627_o = ram[119:108];
  assign n1628_o = ram[131:120];
  assign n1629_o = ram[143:132];
  assign n1630_o = ram[155:144];
  assign n1631_o = ram[167:156];
  assign n1632_o = ram[179:168];
  assign n1633_o = ram[191:180];
  assign n1634_o = ram[203:192];
  assign n1635_o = ram[215:204];
  assign n1636_o = ram[227:216];
  assign n1637_o = ram[239:228];
  assign n1638_o = ram[251:240];
  assign n1639_o = ram[263:252];
  assign n1640_o = ram[275:264];
  assign n1641_o = ram[287:276];
  assign n1642_o = ram[299:288];
  assign n1643_o = ram[311:300];
  assign n1644_o = ram[323:312];
  assign n1645_o = ram[335:324];
  assign n1646_o = ram[347:336];
  assign n1647_o = ram[359:348];
  assign n1648_o = ram[371:360];
  assign n1649_o = ram[383:372];
  /* ./vdp_cram.vhd:54:37  */
  assign n1650_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1650_o)
      2'b00: n1651_o = n1618_o;
      2'b01: n1651_o = n1619_o;
      2'b10: n1651_o = n1620_o;
      2'b11: n1651_o = n1621_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1652_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1652_o)
      2'b00: n1653_o = n1622_o;
      2'b01: n1653_o = n1623_o;
      2'b10: n1653_o = n1624_o;
      2'b11: n1653_o = n1625_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1654_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1654_o)
      2'b00: n1655_o = n1626_o;
      2'b01: n1655_o = n1627_o;
      2'b10: n1655_o = n1628_o;
      2'b11: n1655_o = n1629_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1656_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1656_o)
      2'b00: n1657_o = n1630_o;
      2'b01: n1657_o = n1631_o;
      2'b10: n1657_o = n1632_o;
      2'b11: n1657_o = n1633_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1658_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1658_o)
      2'b00: n1659_o = n1634_o;
      2'b01: n1659_o = n1635_o;
      2'b10: n1659_o = n1636_o;
      2'b11: n1659_o = n1637_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1660_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1660_o)
      2'b00: n1661_o = n1638_o;
      2'b01: n1661_o = n1639_o;
      2'b10: n1661_o = n1640_o;
      2'b11: n1661_o = n1641_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1662_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1662_o)
      2'b00: n1663_o = n1642_o;
      2'b01: n1663_o = n1643_o;
      2'b10: n1663_o = n1644_o;
      2'b11: n1663_o = n1645_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1664_o = n1339_o[1:0];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1664_o)
      2'b00: n1665_o = n1646_o;
      2'b01: n1665_o = n1647_o;
      2'b10: n1665_o = n1648_o;
      2'b11: n1665_o = n1649_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1666_o = n1339_o[3:2];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1666_o)
      2'b00: n1667_o = n1651_o;
      2'b01: n1667_o = n1653_o;
      2'b10: n1667_o = n1655_o;
      2'b11: n1667_o = n1657_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1668_o = n1339_o[3:2];
  /* ./vdp_cram.vhd:54:37  */
  always @*
    case (n1668_o)
      2'b00: n1669_o = n1659_o;
      2'b01: n1669_o = n1661_o;
      2'b10: n1669_o = n1663_o;
      2'b11: n1669_o = n1665_o;
    endcase
  /* ./vdp_cram.vhd:54:37  */
  assign n1670_o = n1339_o[4];
  /* ./vdp_cram.vhd:54:37  */
  assign n1671_o = n1670_o ? n1669_o : n1667_o;
endmodule

module dpram_15_8_f8d0212558df9752eb44381ca87663907f59d33e
  (input  [14:0] address_a,
   input  [14:0] address_b,
   input  clock_a,
   input  clock_b,
   input  [7:0] data_a,
   input  [7:0] data_b,
   input  wren_a,
   input  wren_b,
   output [7:0] q_a,
   output [7:0] q_b);
  wire [13:0] n1240_o;
  wire [13:0] n1247_o;
  wire [13:0] n1259_o;
  reg [7:0] n1272_data; // mem_rd
  reg [7:0] n1274_data; // mem_rd
  assign q_a = n1274_data;
  assign q_b = n1272_data;
  /* ./dpram.vhd:23:79  */
  assign n1240_o = address_a[13:0];
  /* ./dpram.vhd:24:65  */
  assign n1247_o = address_a[13:0];
  /* ./dpram.vhd:28:86  */
  assign n1259_o = address_b[13:0];
  /* ./dpram.vhd:24:36  */
  reg [7:0] mem[16383:0] ; // memory
  always @(posedge clock_b)
    if (1'b1)
      n1272_data <= mem[n1259_o];
  always @(posedge clock_a)
    if (1'b1)
      n1274_data <= mem[n1247_o];
  always @(posedge clock_a)
    if (wren_a)
      mem[n1240_o] <= data_a;
  /* ./dpram.vhd:24:36  */
  /* ./dpram.vhd:28:56  */
  /* ./dpram.vhd:23:50  */
endmodule

module vdp_main_7
  (input  clk_sys,
   input  ce_vdp,
   input  ce_pix,
   input  ce_sp,
   input  ggres,
   input  sp64,
   input  legacy_ext_nt,
   input  [7:0] vram_d,
   input  [11:0] cram_d,
   input  [8:0] x,
   input  [8:0] y,
   input  palettemode,
   input  display_on,
   input  mask_column0,
   input  black_column,
   input  mode_m1_raw,
   input  mode_m2_raw,
   input  mode_m3_raw,
   input  smode_m1,
   input  smode_m3,
   input  smode_m4,
   input  ysj_quirk,
   input  [3:0] overscan,
   input  [3:0] text_fg_color,
   input  [3:0] bg_address,
   input  [2:0] m2mg_address,
   input  [7:0] m2ct_address,
   input  [7:0] bg_scroll_x,
   input  [7:0] bg_scroll_y,
   input  disable_hscroll,
   input  disable_vscroll,
   input  [6:0] spr_address,
   input  [2:0] spr_high_bits,
   input  spr_shift,
   input  spr_tall,
   input  spr_wide,
   input  ss_regs_set,
   output [13:0] vram_a,
   output [4:0] cram_a,
   output [11:0] color,
   output y1,
   output spr_collide,
   output spr_overflow);
  wire [7:0] bg_y;
  wire [13:0] bg_vram_a;
  wire [4:0] bg_color;
  wire bg_priority;
  wire [3:0] out_color;
  wire [13:0] spr_vram_a;
  wire [3:0] spr_color;
  wire text_mode;
  wire line_reset;
  wire n904_o;
  wire n905_o;
  wire n906_o;
  wire n907_o;
  wire n908_o;
  wire n909_o;
  wire n910_o;
  wire n915_o;
  wire [8:0] n917_o;
  wire n919_o;
  wire n920_o;
  wire [8:0] n922_o;
  wire [8:0] n923_o;
  wire n924_o;
  wire n925_o;
  wire n926_o;
  wire n928_o;
  wire [8:0] n930_o;
  wire [8:0] n931_o;
  wire n932_o;
  wire [7:0] n933_o;
  wire [7:0] n934_o;
  wire [7:0] n935_o;
  wire n940_o;
  wire n941_o;
  wire [13:0] vdp_bg_inst_vram_a;
  wire [4:0] vdp_bg_inst_color;
  wire vdp_bg_inst_priority;
  wire n943_o;
  wire [13:0] vdp_spr_inst_vram_a;
  wire vdp_spr_inst_collide;
  wire vdp_spr_inst_overflow;
  wire [3:0] vdp_spr_inst_color;
  wire n956_o;
  wire n958_o;
  wire n959_o;
  wire n960_o;
  wire n961_o;
  wire n963_o;
  wire n964_o;
  wire n966_o;
  wire n967_o;
  wire n968_o;
  wire n969_o;
  wire n970_o;
  wire n971_o;
  wire n973_o;
  wire n974_o;
  wire n976_o;
  wire n977_o;
  wire n978_o;
  wire n979_o;
  wire n981_o;
  wire n982_o;
  wire n983_o;
  wire n984_o;
  wire n986_o;
  wire n988_o;
  wire n989_o;
  wire n990_o;
  wire n991_o;
  wire n993_o;
  wire n995_o;
  wire n996_o;
  wire n997_o;
  wire n998_o;
  wire n999_o;
  wire n1001_o;
  wire n1002_o;
  wire n1003_o;
  wire n1005_o;
  wire n1006_o;
  wire n1007_o;
  wire n1008_o;
  wire n1009_o;
  wire n1011_o;
  wire n1012_o;
  wire n1013_o;
  wire n1014_o;
  wire n1015_o;
  wire n1016_o;
  wire n1018_o;
  wire n1019_o;
  wire n1020_o;
  wire [3:0] n1021_o;
  wire n1023_o;
  wire n1024_o;
  wire n1025_o;
  wire n1026_o;
  wire n1027_o;
  wire n1028_o;
  wire [4:0] n1030_o;
  wire n1031_o;
  wire n1032_o;
  wire n1033_o;
  wire n1034_o;
  wire n1035_o;
  wire [4:0] n1037_o;
  wire [3:0] n1038_o;
  wire n1040_o;
  wire [3:0] n1041_o;
  wire [3:0] n1042_o;
  wire [4:0] n1043_o;
  wire [3:0] n1044_o;
  wire [4:0] n1045_o;
  wire n1048_o;
  wire [3:0] n1049_o;
  wire [4:0] n1051_o;
  wire [4:0] n1052_o;
  wire n1054_o;
  wire [3:0] n1055_o;
  wire [4:0] n1059_o;
  wire [4:0] n1060_o;
  wire n1062_o;
  wire n1064_o;
  wire n1069_o;
  wire n1071_o;
  wire n1072_o;
  wire [13:0] n1073_o;
  wire n1075_o;
  wire n1077_o;
  wire n1078_o;
  wire n1080_o;
  wire n1081_o;
  wire [11:0] n1082_o;
  wire [11:0] n1083_o;
  wire n1086_o;
  wire n1088_o;
  wire n1089_o;
  wire [11:0] n1090_o;
  wire n1093_o;
  wire n1094_o;
  wire n1095_o;
  wire [11:0] n1096_o;
  wire n1099_o;
  wire n1100_o;
  wire n1101_o;
  wire [11:0] n1102_o;
  wire n1105_o;
  wire n1106_o;
  wire n1107_o;
  wire [11:0] n1108_o;
  wire n1111_o;
  wire n1112_o;
  wire n1113_o;
  wire [11:0] n1114_o;
  wire n1117_o;
  wire n1118_o;
  wire n1119_o;
  wire [11:0] n1120_o;
  wire n1123_o;
  wire n1124_o;
  wire n1125_o;
  wire [11:0] n1126_o;
  wire n1129_o;
  wire n1130_o;
  wire n1131_o;
  wire [11:0] n1132_o;
  wire n1135_o;
  wire n1136_o;
  wire n1137_o;
  wire [11:0] n1138_o;
  wire n1141_o;
  wire n1142_o;
  wire n1143_o;
  wire [11:0] n1144_o;
  wire n1147_o;
  wire n1148_o;
  wire n1149_o;
  wire [11:0] n1150_o;
  wire n1153_o;
  wire n1154_o;
  wire n1155_o;
  wire [11:0] n1156_o;
  wire n1159_o;
  wire n1160_o;
  wire n1161_o;
  wire [11:0] n1162_o;
  wire n1165_o;
  wire n1166_o;
  wire n1167_o;
  wire [11:0] n1168_o;
  wire n1171_o;
  wire n1172_o;
  wire [11:0] n1173_o;
  wire n1176_o;
  wire n1177_o;
  wire [11:0] n1178_o;
  wire n1181_o;
  wire n1182_o;
  wire [11:0] n1183_o;
  wire n1186_o;
  wire n1187_o;
  wire [11:0] n1188_o;
  wire n1191_o;
  wire n1192_o;
  wire [11:0] n1193_o;
  wire n1196_o;
  wire n1197_o;
  wire [11:0] n1198_o;
  wire n1201_o;
  wire n1202_o;
  wire [11:0] n1203_o;
  wire n1206_o;
  wire n1207_o;
  wire [11:0] n1208_o;
  wire n1211_o;
  wire n1212_o;
  wire [11:0] n1213_o;
  wire n1216_o;
  wire n1217_o;
  wire [11:0] n1218_o;
  wire n1221_o;
  wire n1222_o;
  wire [11:0] n1223_o;
  wire n1226_o;
  wire n1227_o;
  wire [11:0] n1228_o;
  wire n1231_o;
  wire n1232_o;
  wire [11:0] n1233_o;
  assign vram_a = n1073_o;
  assign cram_a = n1060_o;
  assign color = n1082_o;
  assign y1 = n1062_o;
  assign spr_collide = vdp_spr_inst_collide;
  assign spr_overflow = vdp_spr_inst_overflow;
  /* ./vdp_main.vhd:64:16  */
  assign bg_y = n935_o; // (signal)
  /* ./vdp_main.vhd:65:16  */
  assign bg_vram_a = vdp_bg_inst_vram_a; // (signal)
  /* ./vdp_main.vhd:66:16  */
  assign bg_color = vdp_bg_inst_color; // (signal)
  /* ./vdp_main.vhd:67:16  */
  assign bg_priority = vdp_bg_inst_priority; // (signal)
  /* ./vdp_main.vhd:68:16  */
  assign out_color = n1055_o; // (signal)
  /* ./vdp_main.vhd:69:16  */
  assign spr_vram_a = vdp_spr_inst_vram_a; // (signal)
  /* ./vdp_main.vhd:70:16  */
  assign spr_color = vdp_spr_inst_color; // (signal)
  /* ./vdp_main.vhd:71:16  */
  assign text_mode = n910_o; // (signal)
  /* ./vdp_main.vhd:73:16  */
  assign line_reset = n941_o; // (signal)
  /* ./vdp_main.vhd:78:39  */
  assign n904_o = ~smode_m4;
  /* ./vdp_main.vhd:78:44  */
  assign n905_o = mode_m1_raw & n904_o;
  /* ./vdp_main.vhd:78:79  */
  assign n906_o = ~mode_m2_raw;
  /* ./vdp_main.vhd:78:64  */
  assign n907_o = n906_o & n905_o;
  /* ./vdp_main.vhd:78:99  */
  assign n908_o = ~mode_m3_raw;
  /* ./vdp_main.vhd:78:84  */
  assign n909_o = n908_o & n907_o;
  /* ./vdp_main.vhd:78:26  */
  assign n910_o = n909_o ? 1'b1 : 1'b0;
  /* ./vdp_main.vhd:83:36  */
  assign n915_o = ~disable_vscroll;
  /* ./vdp_main.vhd:83:46  */
  assign n917_o = x + 9'b000010000;
  /* ./vdp_main.vhd:83:50  */
  assign n919_o = $unsigned(n917_o) < $unsigned(9'b011001000);
  /* ./vdp_main.vhd:83:42  */
  assign n920_o = n915_o | n919_o;
  /* ./vdp_main.vhd:84:38  */
  assign n922_o = {1'b0, bg_scroll_y};
  /* ./vdp_main.vhd:84:33  */
  assign n923_o = y + n922_o;
  /* ./vdp_main.vhd:85:36  */
  assign n924_o = ~smode_m1;
  /* ./vdp_main.vhd:85:53  */
  assign n925_o = ~smode_m3;
  /* ./vdp_main.vhd:85:41  */
  assign n926_o = n925_o & n924_o;
  /* ./vdp_main.vhd:86:40  */
  assign n928_o = $unsigned(n923_o) >= $unsigned(9'b011100000);
  /* ./vdp_main.vhd:86:62  */
  assign n930_o = n923_o - 9'b011100000;
  /* ./vdp_main.vhd:85:25  */
  assign n931_o = n932_o ? n930_o : n923_o;
  /* ./vdp_main.vhd:85:25  */
  assign n932_o = n928_o & n926_o;
  /* ./vdp_main.vhd:91:36  */
  assign n933_o = n931_o[7:0];
  /* ./vdp_main.vhd:93:34  */
  assign n934_o = y[7:0];
  /* ./vdp_main.vhd:83:17  */
  assign n935_o = n920_o ? n933_o : n934_o;
  /* ./vdp_main.vhd:98:33  */
  assign n940_o = x == 9'b111101000;
  /* ./vdp_main.vhd:98:27  */
  assign n941_o = n940_o ? 1'b1 : 1'b0;
  /* ./vdp_main.vhd:100:9  */
  vdp_background vdp_bg_inst (
    .clk_sys(clk_sys),
    .ce_pix(ce_pix),
    .reset(n943_o),
    .screen_x(x),
    .table_address(bg_address),
    .pt_address(m2mg_address),
    .ct_address(m2ct_address),
    .scroll_x_latched(bg_scroll_x),
    .disable_hscroll(disable_hscroll),
    .mode_m1_raw(mode_m1_raw),
    .mode_m2_raw(mode_m2_raw),
    .mode_m3_raw(mode_m3_raw),
    .smode_m1(smode_m1),
    .smode_m3(smode_m3),
    .smode_m4(smode_m4),
    .ysj_quirk(ysj_quirk),
    .legacy_ext_nt(legacy_ext_nt),
    .y(bg_y),
    .screen_y(y),
    .text_fg_color(text_fg_color),
    .overscan(overscan),
    .ss_restore(ss_regs_set),
    .vram_d(vram_d),
    .vram_a(vdp_bg_inst_vram_a),
    .color(vdp_bg_inst_color),
    .priority(vdp_bg_inst_priority));
  /* ./vdp_main.vhd:107:63  */
  assign n943_o = line_reset | ss_regs_set;
  /* ./vdp_main.vhd:130:9  */
  vdp_sprites_7 vdp_spr_inst (
    .clk_sys(clk_sys),
    .ce_vdp(ce_vdp),
    .ce_pix(ce_pix),
    .ce_sp(ce_sp),
    .sp64(sp64),
    .table_address(spr_address),
    .char_high_bits(spr_high_bits),
    .tall(spr_tall),
    .wide(spr_wide),
    .shift(spr_shift),
    .smode_m1(smode_m1),
    .smode_m3(smode_m3),
    .smode_m4(smode_m4),
    .vram_d(vram_d),
    .x(x),
    .y(y),
    .ss_regs_set(ss_regs_set),
    .vram_a(vdp_spr_inst_vram_a),
    .collide(vdp_spr_inst_collide),
    .overflow(vdp_spr_inst_overflow),
    .color(vdp_spr_inst_color));
  /* ./vdp_main.vhd:162:23  */
  assign n956_o = $unsigned(x) > $unsigned(9'b000110000);
  /* ./vdp_main.vhd:162:32  */
  assign n958_o = $unsigned(x) <= $unsigned(9'b011010000);
  /* ./vdp_main.vhd:162:27  */
  assign n959_o = n958_o & n956_o;
  /* ./vdp_main.vhd:163:49  */
  assign n960_o = ~ggres;
  /* ./vdp_main.vhd:163:40  */
  assign n961_o = n960_o & text_mode;
  /* ./vdp_main.vhd:163:59  */
  assign n963_o = $unsigned(x) > $unsigned(9'b000000111);
  /* ./vdp_main.vhd:163:54  */
  assign n964_o = n963_o & n961_o;
  /* ./vdp_main.vhd:163:67  */
  assign n966_o = $unsigned(x) < $unsigned(9'b011111000);
  /* ./vdp_main.vhd:163:62  */
  assign n967_o = n966_o & n964_o;
  /* ./vdp_main.vhd:162:39  */
  assign n968_o = n959_o | n967_o;
  /* ./vdp_main.vhd:164:35  */
  assign n969_o = ~text_mode;
  /* ./vdp_main.vhd:164:49  */
  assign n970_o = ~ggres;
  /* ./vdp_main.vhd:164:40  */
  assign n971_o = n970_o & n969_o;
  /* ./vdp_main.vhd:164:59  */
  assign n973_o = $unsigned(x) <= $unsigned(9'b100000000);
  /* ./vdp_main.vhd:164:54  */
  assign n974_o = n973_o & n971_o;
  /* ./vdp_main.vhd:164:70  */
  assign n976_o = $unsigned(x) > $unsigned(9'b000000000);
  /* ./vdp_main.vhd:164:65  */
  assign n977_o = n976_o & n974_o;
  /* ./vdp_main.vhd:163:73  */
  assign n978_o = n968_o | n977_o;
  /* ./vdp_main.vhd:165:38  */
  assign n979_o = ~mask_column0;
  /* ./vdp_main.vhd:165:47  */
  assign n981_o = $unsigned(x) >= $unsigned(9'b000001001);
  /* ./vdp_main.vhd:165:43  */
  assign n982_o = n979_o | n981_o;
  /* ./vdp_main.vhd:164:75  */
  assign n983_o = n982_o & n978_o;
  /* ./vdp_main.vhd:165:52  */
  assign n984_o = display_on & n983_o;
  /* ./vdp_main.vhd:166:32  */
  assign n986_o = $unsigned(y) >= $unsigned(9'b000011000);
  /* ./vdp_main.vhd:166:42  */
  assign n988_o = $unsigned(y) < $unsigned(9'b010101000);
  /* ./vdp_main.vhd:166:37  */
  assign n989_o = n988_o & n986_o;
  /* ./vdp_main.vhd:166:60  */
  assign n990_o = ~smode_m1;
  /* ./vdp_main.vhd:166:48  */
  assign n991_o = n990_o & n989_o;
  /* ./vdp_main.vhd:167:39  */
  assign n993_o = $unsigned(y) >= $unsigned(9'b000101000);
  /* ./vdp_main.vhd:167:49  */
  assign n995_o = $unsigned(y) < $unsigned(9'b010111000);
  /* ./vdp_main.vhd:167:44  */
  assign n996_o = n995_o & n993_o;
  /* ./vdp_main.vhd:167:55  */
  assign n997_o = smode_m1 & n996_o;
  /* ./vdp_main.vhd:167:33  */
  assign n998_o = n991_o | n997_o;
  /* ./vdp_main.vhd:168:42  */
  assign n999_o = ~ggres;
  /* ./vdp_main.vhd:168:52  */
  assign n1001_o = $unsigned(y) < $unsigned(9'b011000000);
  /* ./vdp_main.vhd:168:47  */
  assign n1002_o = n1001_o & n999_o;
  /* ./vdp_main.vhd:168:33  */
  assign n1003_o = n998_o | n1002_o;
  /* ./vdp_main.vhd:169:55  */
  assign n1005_o = $unsigned(y) < $unsigned(9'b011100000);
  /* ./vdp_main.vhd:169:50  */
  assign n1006_o = n1005_o & smode_m1;
  /* ./vdp_main.vhd:169:69  */
  assign n1007_o = ~ggres;
  /* ./vdp_main.vhd:169:60  */
  assign n1008_o = n1007_o & n1006_o;
  /* ./vdp_main.vhd:169:33  */
  assign n1009_o = n1003_o | n1008_o;
  /* ./vdp_main.vhd:170:55  */
  assign n1011_o = $unsigned(y) < $unsigned(9'b011110000);
  /* ./vdp_main.vhd:170:50  */
  assign n1012_o = n1011_o & smode_m3;
  /* ./vdp_main.vhd:170:69  */
  assign n1013_o = ~ggres;
  /* ./vdp_main.vhd:170:60  */
  assign n1014_o = n1013_o & n1012_o;
  /* ./vdp_main.vhd:170:33  */
  assign n1015_o = n1009_o | n1014_o;
  /* ./vdp_main.vhd:172:61  */
  assign n1016_o = ~text_mode;
  /* ./vdp_main.vhd:172:84  */
  assign n1018_o = spr_color == 4'b0000;
  /* ./vdp_main.vhd:172:70  */
  assign n1019_o = ~n1018_o;
  /* ./vdp_main.vhd:172:66  */
  assign n1020_o = n1019_o & n1016_o;
  /* ./vdp_main.vhd:173:65  */
  assign n1021_o = bg_color[3:0];
  /* ./vdp_main.vhd:173:77  */
  assign n1023_o = n1021_o == 4'b0000;
  /* ./vdp_main.vhd:173:52  */
  assign n1024_o = ~n1023_o;
  /* ./vdp_main.vhd:174:36  */
  assign n1025_o = ~n1020_o;
  /* ./vdp_main.vhd:174:55  */
  assign n1026_o = ~n1024_o;
  /* ./vdp_main.vhd:174:51  */
  assign n1027_o = n1026_o & n1025_o;
  /* ./vdp_main.vhd:176:59  */
  assign n1028_o = bg_color[4];
  /* ./vdp_main.vhd:176:62  */
  assign n1030_o = {n1028_o, 4'b0000};
  /* ./vdp_main.vhd:178:51  */
  assign n1031_o = ~bg_priority;
  /* ./vdp_main.vhd:178:56  */
  assign n1032_o = n1020_o & n1031_o;
  /* ./vdp_main.vhd:178:96  */
  assign n1033_o = ~n1024_o;
  /* ./vdp_main.vhd:178:92  */
  assign n1034_o = n1033_o & bg_priority;
  /* ./vdp_main.vhd:178:72  */
  assign n1035_o = n1032_o | n1034_o;
  /* ./vdp_main.vhd:180:54  */
  assign n1037_o = {1'b1, spr_color};
  /* ./vdp_main.vhd:183:52  */
  assign n1038_o = bg_color[3:0];
  /* ./vdp_main.vhd:183:64  */
  assign n1040_o = n1038_o == 4'b0000;
  /* ./vdp_main.vhd:186:70  */
  assign n1041_o = bg_color[3:0];
  /* ./vdp_main.vhd:183:41  */
  assign n1042_o = n1040_o ? overscan : n1041_o;
  /* ./vdp_main.vhd:178:33  */
  assign n1043_o = n1035_o ? n1037_o : bg_color;
  /* ./vdp_main.vhd:178:33  */
  assign n1044_o = n1035_o ? spr_color : n1042_o;
  /* ./vdp_main.vhd:174:33  */
  assign n1045_o = n1027_o ? n1030_o : n1043_o;
  /* ./vdp_main.vhd:174:33  */
  assign n1048_o = n1027_o ? 1'b0 : 1'b1;
  /* ./vdp_main.vhd:174:33  */
  assign n1049_o = n1027_o ? overscan : n1044_o;
  /* ./vdp_main.vhd:190:46  */
  assign n1051_o = {1'b1, overscan};
  /* ./vdp_main.vhd:166:25  */
  assign n1052_o = n1015_o ? n1045_o : n1051_o;
  /* ./vdp_main.vhd:166:25  */
  assign n1054_o = n1015_o ? n1048_o : 1'b1;
  /* ./vdp_main.vhd:162:17  */
  assign n1055_o = n1064_o ? n1049_o : overscan;
  /* ./vdp_main.vhd:194:38  */
  assign n1059_o = {1'b1, overscan};
  /* ./vdp_main.vhd:162:17  */
  assign n1060_o = n984_o ? n1052_o : n1059_o;
  /* ./vdp_main.vhd:162:17  */
  assign n1062_o = n984_o ? n1054_o : 1'b1;
  /* ./vdp_main.vhd:162:17  */
  assign n1064_o = n1015_o & n984_o;
  /* ./vdp_main.vhd:199:36  */
  assign n1069_o = $unsigned(x) >= $unsigned(9'b100000000);
  /* ./vdp_main.vhd:199:47  */
  assign n1071_o = $unsigned(x) < $unsigned(9'b111110000);
  /* ./vdp_main.vhd:199:42  */
  assign n1072_o = n1071_o & n1069_o;
  /* ./vdp_main.vhd:199:30  */
  assign n1073_o = n1072_o ? spr_vram_a : bg_vram_a;
  /* ./vdp_main.vhd:200:55  */
  assign n1075_o = mask_column0 & black_column;
  /* ./vdp_main.vhd:200:81  */
  assign n1077_o = $unsigned(x) > $unsigned(9'b000000000);
  /* ./vdp_main.vhd:200:76  */
  assign n1078_o = n1077_o & n1075_o;
  /* ./vdp_main.vhd:200:89  */
  assign n1080_o = $unsigned(x) < $unsigned(9'b000001001);
  /* ./vdp_main.vhd:200:84  */
  assign n1081_o = n1080_o & n1078_o;
  /* ./vdp_main.vhd:200:33  */
  assign n1082_o = n1081_o ? 12'b000000000000 : n1083_o;
  /* ./vdp_main.vhd:200:92  */
  assign n1083_o = smode_m4 ? cram_d : n1090_o;
  /* ./vdp_main.vhd:203:48  */
  assign n1086_o = out_color == 4'b0000;
  /* ./vdp_main.vhd:203:68  */
  assign n1088_o = out_color == 4'b0001;
  /* ./vdp_main.vhd:203:56  */
  assign n1089_o = n1086_o | n1088_o;
  /* ./vdp_main.vhd:201:50  */
  assign n1090_o = n1089_o ? 12'b000000000000 : n1096_o;
  /* ./vdp_main.vhd:204:47  */
  assign n1093_o = out_color == 4'b0010;
  /* ./vdp_main.vhd:204:70  */
  assign n1094_o = ~palettemode;
  /* ./vdp_main.vhd:204:55  */
  assign n1095_o = n1094_o & n1093_o;
  /* ./vdp_main.vhd:203:76  */
  assign n1096_o = n1095_o ? 12'b010010100010 : n1102_o;
  /* ./vdp_main.vhd:205:47  */
  assign n1099_o = out_color == 4'b0011;
  /* ./vdp_main.vhd:205:70  */
  assign n1100_o = ~palettemode;
  /* ./vdp_main.vhd:205:55  */
  assign n1101_o = n1100_o & n1099_o;
  /* ./vdp_main.vhd:204:76  */
  assign n1102_o = n1101_o ? 12'b011111100110 : n1108_o;
  /* ./vdp_main.vhd:206:47  */
  assign n1105_o = out_color == 4'b0100;
  /* ./vdp_main.vhd:206:70  */
  assign n1106_o = ~palettemode;
  /* ./vdp_main.vhd:206:55  */
  assign n1107_o = n1106_o & n1105_o;
  /* ./vdp_main.vhd:205:76  */
  assign n1108_o = n1107_o ? 12'b111101010101 : n1114_o;
  /* ./vdp_main.vhd:207:47  */
  assign n1111_o = out_color == 4'b0101;
  /* ./vdp_main.vhd:207:70  */
  assign n1112_o = ~palettemode;
  /* ./vdp_main.vhd:207:55  */
  assign n1113_o = n1112_o & n1111_o;
  /* ./vdp_main.vhd:206:76  */
  assign n1114_o = n1113_o ? 12'b111110001000 : n1120_o;
  /* ./vdp_main.vhd:208:47  */
  assign n1117_o = out_color == 4'b0110;
  /* ./vdp_main.vhd:208:70  */
  assign n1118_o = ~palettemode;
  /* ./vdp_main.vhd:208:55  */
  assign n1119_o = n1118_o & n1117_o;
  /* ./vdp_main.vhd:207:76  */
  assign n1120_o = n1119_o ? 12'b010101011101 : n1126_o;
  /* ./vdp_main.vhd:209:47  */
  assign n1123_o = out_color == 4'b0111;
  /* ./vdp_main.vhd:209:70  */
  assign n1124_o = ~palettemode;
  /* ./vdp_main.vhd:209:55  */
  assign n1125_o = n1124_o & n1123_o;
  /* ./vdp_main.vhd:208:76  */
  assign n1126_o = n1125_o ? 12'b111111110100 : n1132_o;
  /* ./vdp_main.vhd:210:47  */
  assign n1129_o = out_color == 4'b1000;
  /* ./vdp_main.vhd:210:70  */
  assign n1130_o = ~palettemode;
  /* ./vdp_main.vhd:210:55  */
  assign n1131_o = n1130_o & n1129_o;
  /* ./vdp_main.vhd:209:76  */
  assign n1132_o = n1131_o ? 12'b010101011111 : n1138_o;
  /* ./vdp_main.vhd:211:47  */
  assign n1135_o = out_color == 4'b1001;
  /* ./vdp_main.vhd:211:70  */
  assign n1136_o = ~palettemode;
  /* ./vdp_main.vhd:211:55  */
  assign n1137_o = n1136_o & n1135_o;
  /* ./vdp_main.vhd:210:76  */
  assign n1138_o = n1137_o ? 12'b100010001111 : n1144_o;
  /* ./vdp_main.vhd:212:47  */
  assign n1141_o = out_color == 4'b1010;
  /* ./vdp_main.vhd:212:70  */
  assign n1142_o = ~palettemode;
  /* ./vdp_main.vhd:212:55  */
  assign n1143_o = n1142_o & n1141_o;
  /* ./vdp_main.vhd:211:76  */
  assign n1144_o = n1143_o ? 12'b010111011101 : n1150_o;
  /* ./vdp_main.vhd:213:47  */
  assign n1147_o = out_color == 4'b1011;
  /* ./vdp_main.vhd:213:70  */
  assign n1148_o = ~palettemode;
  /* ./vdp_main.vhd:213:55  */
  assign n1149_o = n1148_o & n1147_o;
  /* ./vdp_main.vhd:212:76  */
  assign n1150_o = n1149_o ? 12'b100011011110 : n1156_o;
  /* ./vdp_main.vhd:214:47  */
  assign n1153_o = out_color == 4'b1100;
  /* ./vdp_main.vhd:214:70  */
  assign n1154_o = ~palettemode;
  /* ./vdp_main.vhd:214:55  */
  assign n1155_o = n1154_o & n1153_o;
  /* ./vdp_main.vhd:213:76  */
  assign n1156_o = n1155_o ? 12'b010010110010 : n1162_o;
  /* ./vdp_main.vhd:215:47  */
  assign n1159_o = out_color == 4'b1101;
  /* ./vdp_main.vhd:215:70  */
  assign n1160_o = ~palettemode;
  /* ./vdp_main.vhd:215:55  */
  assign n1161_o = n1160_o & n1159_o;
  /* ./vdp_main.vhd:214:76  */
  assign n1162_o = n1161_o ? 12'b101001101011 : n1168_o;
  /* ./vdp_main.vhd:216:47  */
  assign n1165_o = out_color == 4'b1110;
  /* ./vdp_main.vhd:216:70  */
  assign n1166_o = ~palettemode;
  /* ./vdp_main.vhd:216:55  */
  assign n1167_o = n1166_o & n1165_o;
  /* ./vdp_main.vhd:215:76  */
  assign n1168_o = n1167_o ? 12'b101110111011 : n1173_o;
  /* ./vdp_main.vhd:218:47  */
  assign n1171_o = out_color == 4'b0010;
  /* ./vdp_main.vhd:218:55  */
  assign n1172_o = palettemode & n1171_o;
  /* ./vdp_main.vhd:216:76  */
  assign n1173_o = n1172_o ? 12'b010011000010 : n1178_o;
  /* ./vdp_main.vhd:219:47  */
  assign n1176_o = out_color == 4'b0011;
  /* ./vdp_main.vhd:219:55  */
  assign n1177_o = palettemode & n1176_o;
  /* ./vdp_main.vhd:218:76  */
  assign n1178_o = n1177_o ? 12'b011111010101 : n1183_o;
  /* ./vdp_main.vhd:220:47  */
  assign n1181_o = out_color == 4'b0100;
  /* ./vdp_main.vhd:220:55  */
  assign n1182_o = palettemode & n1181_o;
  /* ./vdp_main.vhd:219:76  */
  assign n1183_o = n1182_o ? 12'b111001010101 : n1188_o;
  /* ./vdp_main.vhd:221:47  */
  assign n1186_o = out_color == 4'b0101;
  /* ./vdp_main.vhd:221:55  */
  assign n1187_o = palettemode & n1186_o;
  /* ./vdp_main.vhd:220:76  */
  assign n1188_o = n1187_o ? 12'b111101110111 : n1193_o;
  /* ./vdp_main.vhd:222:47  */
  assign n1191_o = out_color == 4'b0110;
  /* ./vdp_main.vhd:222:55  */
  assign n1192_o = palettemode & n1191_o;
  /* ./vdp_main.vhd:221:76  */
  assign n1193_o = n1192_o ? 12'b010001011101 : n1198_o;
  /* ./vdp_main.vhd:223:47  */
  assign n1196_o = out_color == 4'b0111;
  /* ./vdp_main.vhd:223:55  */
  assign n1197_o = palettemode & n1196_o;
  /* ./vdp_main.vhd:222:76  */
  assign n1198_o = n1197_o ? 12'b111111100100 : n1203_o;
  /* ./vdp_main.vhd:224:47  */
  assign n1201_o = out_color == 4'b1000;
  /* ./vdp_main.vhd:224:55  */
  assign n1202_o = palettemode & n1201_o;
  /* ./vdp_main.vhd:223:76  */
  assign n1203_o = n1202_o ? 12'b010101011111 : n1208_o;
  /* ./vdp_main.vhd:225:47  */
  assign n1206_o = out_color == 4'b1001;
  /* ./vdp_main.vhd:225:55  */
  assign n1207_o = palettemode & n1206_o;
  /* ./vdp_main.vhd:224:76  */
  assign n1208_o = n1207_o ? 12'b011101111111 : n1213_o;
  /* ./vdp_main.vhd:226:47  */
  assign n1211_o = out_color == 4'b1010;
  /* ./vdp_main.vhd:226:55  */
  assign n1212_o = palettemode & n1211_o;
  /* ./vdp_main.vhd:225:76  */
  assign n1213_o = n1212_o ? 12'b010111001101 : n1218_o;
  /* ./vdp_main.vhd:227:47  */
  assign n1216_o = out_color == 4'b1011;
  /* ./vdp_main.vhd:227:55  */
  assign n1217_o = palettemode & n1216_o;
  /* ./vdp_main.vhd:226:76  */
  assign n1218_o = n1217_o ? 12'b100011001110 : n1223_o;
  /* ./vdp_main.vhd:228:47  */
  assign n1221_o = out_color == 4'b1100;
  /* ./vdp_main.vhd:228:55  */
  assign n1222_o = palettemode & n1221_o;
  /* ./vdp_main.vhd:227:76  */
  assign n1223_o = n1222_o ? 12'b001110110010 : n1228_o;
  /* ./vdp_main.vhd:229:47  */
  assign n1226_o = out_color == 4'b1101;
  /* ./vdp_main.vhd:229:55  */
  assign n1227_o = palettemode & n1226_o;
  /* ./vdp_main.vhd:228:76  */
  assign n1228_o = n1227_o ? 12'b101101011100 : n1233_o;
  /* ./vdp_main.vhd:230:47  */
  assign n1231_o = out_color == 4'b1110;
  /* ./vdp_main.vhd:230:55  */
  assign n1232_o = palettemode & n1231_o;
  /* ./vdp_main.vhd:229:76  */
  assign n1233_o = n1232_o ? 12'b110011001100 : 12'b111111111111;
endmodule

module vdp
  (input  clk_sys,
   input  ce_vdp,
   input  ce_pix,
   input  ce_sp,
   input  gg,
   input  ggres,
   input  se_bank,
   input  sp64,
   input  HL,
   input  mask_line_irq,
   input  capture_cpu_edges,
   input  legacy_ext_nt,
   input  RD_n,
   input  WR_n,
   input  WR_direct,
   input  [5:0] A_direct,
   input  [7:0] A,
   input  [7:0] D_in,
   input  [8:0] x,
   input  [8:0] y,
   input  [7:0] vcounter_cpu,
   input  palettemode,
   input  black_column,
   input  ysj_quirk,
   input  reset_n,
   input  [127:0] ss_regs_in,
   input  ss_regs_set,
   input  ss_cram_wr,
   input  [4:0] ss_cram_A,
   input  [11:0] ss_cram_D,
   input  ss_vram_en,
   input  [14:0] ss_vram_A,
   input  ss_vram_WE,
   input  [14:0] ss_vram_WA,
   input  [7:0] ss_vram_WD,
   output IRQ_n,
   output [7:0] D_out,
   output [11:0] color,
   output y1,
   output mask_column,
   output smode_M1,
   output smode_M2,
   output smode_M3,
   output smode_M4,
   output [127:0] ss_regs_out,
   output [383:0] ss_cram_out,
   output [7:0] ss_vram_D);
  wire old_rd_n;
  wire old_wr_n;
  wire old_hl;
  wire old_wr_direct;
  wire data_write;
  reg address_ff;
  reg to_cram;
  wire spr_collide;
  wire spr_overflow;
  wire [14:0] vram_cpu_a;
  wire [13:0] xram_cpu_a;
  wire vram_cpu_we;
  wire cram_cpu_we;
  wire [7:0] vram_cpu_d_out;
  wire [7:0] vram_cpu_d_out_raw;
  wire [7:0] vram_cpu_d_outl;
  reg [7:0] cpu_write_data;
  reg xram_cpu_a_incr;
  reg xram_cpu_read;
  wire [14:0] vram_porta_address;
  wire vram_porta_wren;
  wire [7:0] vram_porta_data;
  wire [13:0] vram_vdp_a;
  wire [7:0] vram_vdp_d;
  wire [4:0] cram_vdp_a;
  wire [11:0] cram_vdp_d;
  wire [4:0] cram_vdp_a_in;
  wire [11:0] cram_vdp_d_in;
  reg display_on;
  reg disable_hscroll;
  reg disable_vscroll;
  reg mask_column0;
  reg [3:0] overscan;
  reg irq_frame_en;
  reg irq_line_en;
  reg [7:0] irq_line_count;
  reg [3:0] bg_address;
  reg [2:0] m2mg_address;
  reg [7:0] m2ct_address;
  reg [7:0] bg_scroll_x;
  reg [7:0] bg_scroll_x_latched;
  reg [7:0] bg_scroll_y;
  reg [6:0] spr_address;
  reg spr_shift;
  reg spr_tall;
  reg spr_wide;
  reg [2:0] spr_high_bits;
  reg [3:0] legacy_fg_color;
  reg last_x0;
  wire reset_flags;
  reg [2:0] irq_delay;
  reg collide_flag;
  reg [13:0] xspr_collide_shift;
  reg overflow_flag;
  reg line_overflow;
  reg [7:0] hbl_counter;
  wire vbl_irq;
  wire hbl_irq;
  wire [7:0] latched_x;
  wire [7:0] cram_latch;
  wire mode_m1;
  wire mode_m2;
  wire mode_m3;
  wire mode_m4;
  wire xmode_m1;
  wire xmode_m3;
  wire xmode_m4;
  wire n45_o;
  wire n46_o;
  wire [13:0] vdp_main_inst_vram_a;
  wire [4:0] vdp_main_inst_cram_a;
  wire [11:0] vdp_main_inst_color;
  wire vdp_main_inst_y1;
  wire vdp_main_inst_spr_collide;
  wire vdp_main_inst_spr_overflow;
  wire [14:0] n53_o;
  wire [14:0] n54_o;
  wire n55_o;
  wire n56_o;
  wire n57_o;
  wire [7:0] n58_o;
  wire [7:0] vdp_vram_inst_q_a;
  wire [7:0] vdp_vram_inst_q_b;
  wire [14:0] n59_o;
  localparam [7:0] n60_o = 8'b00000000;
  localparam n61_o = 1'b0;
  wire [11:0] vdp_cram_inst_vdp_d;
  wire [383:0] vdp_cram_inst_ss_d;
  wire [4:0] n66_o;
  wire n67_o;
  wire [4:0] n68_o;
  wire [4:0] n69_o;
  wire [1:0] n70_o;
  wire [1:0] n71_o;
  wire [3:0] n72_o;
  wire [1:0] n73_o;
  wire [5:0] n74_o;
  wire [1:0] n75_o;
  wire [7:0] n76_o;
  wire [1:0] n77_o;
  wire [9:0] n78_o;
  wire [1:0] n79_o;
  wire [11:0] n80_o;
  wire n81_o;
  wire [11:0] n82_o;
  wire [3:0] n83_o;
  wire [11:0] n84_o;
  wire n85_o;
  wire n86_o;
  wire n87_o;
  wire n88_o;
  wire n89_o;
  wire n90_o;
  wire n91_o;
  wire n93_o;
  wire n94_o;
  wire n95_o;
  wire n97_o;
  wire [6:0] n98_o;
  wire [14:0] n99_o;
  wire [14:0] n100_o;
  wire [14:0] n101_o;
  wire n103_o;
  wire n106_o;
  wire n108_o;
  wire n109_o;
  wire n113_o;
  wire n115_o;
  wire n116_o;
  wire n117_o;
  wire n118_o;
  wire n119_o;
  wire n120_o;
  wire n121_o;
  wire n122_o;
  wire n123_o;
  wire n124_o;
  wire n125_o;
  wire n126_o;
  wire n127_o;
  wire [3:0] n128_o;
  wire [2:0] n129_o;
  wire [7:0] n130_o;
  wire [7:0] n131_o;
  wire [7:0] n132_o;
  wire [6:0] n133_o;
  wire [2:0] n134_o;
  wire [3:0] n135_o;
  wire [3:0] n136_o;
  wire [7:0] n137_o;
  wire [13:0] n138_o;
  wire n139_o;
  wire n140_o;
  wire [7:0] n141_o;
  wire [7:0] n142_o;
  wire n143_o;
  wire n144_o;
  wire n145_o;
  wire n147_o;
  wire n148_o;
  wire n149_o;
  wire [13:0] n150_o;
  wire [7:0] n151_o;
  wire [7:0] n152_o;
  wire n154_o;
  wire n155_o;
  wire n156_o;
  wire n157_o;
  wire n158_o;
  wire n159_o;
  wire [3:0] n160_o;
  wire n161_o;
  wire n162_o;
  wire [7:0] n163_o;
  wire [3:0] n164_o;
  wire [2:0] n165_o;
  wire [7:0] n166_o;
  wire [7:0] n167_o;
  wire [7:0] n168_o;
  wire [6:0] n169_o;
  wire n170_o;
  wire n171_o;
  wire n172_o;
  wire [2:0] n173_o;
  wire [3:0] n174_o;
  wire n176_o;
  wire [7:0] n177_o;
  wire n178_o;
  wire n179_o;
  wire n180_o;
  wire n181_o;
  wire n182_o;
  wire n183_o;
  wire [7:0] n184_o;
  wire n186_o;
  wire n187_o;
  wire n188_o;
  wire n189_o;
  wire n190_o;
  wire n193_o;
  wire [7:0] n194_o;
  wire n195_o;
  wire n196_o;
  wire n197_o;
  wire n198_o;
  wire n199_o;
  wire n200_o;
  wire n201_o;
  wire [7:0] n202_o;
  wire n203_o;
  wire [5:0] n204_o;
  wire [1:0] n205_o;
  wire n207_o;
  wire [1:0] n208_o;
  wire n210_o;
  wire n212_o;
  wire [1:0] n213_o;
  wire [3:0] n214_o;
  wire [5:0] n215_o;
  wire n216_o;
  wire n217_o;
  wire n218_o;
  wire n219_o;
  wire n220_o;
  wire n221_o;
  wire n222_o;
  wire n224_o;
  wire n225_o;
  wire n226_o;
  wire n227_o;
  wire n228_o;
  wire n229_o;
  wire n230_o;
  wire n232_o;
  wire [3:0] n233_o;
  wire n235_o;
  wire [7:0] n236_o;
  wire n238_o;
  wire [2:0] n239_o;
  wire n241_o;
  wire [6:0] n242_o;
  wire n244_o;
  wire [2:0] n245_o;
  wire n247_o;
  wire [3:0] n248_o;
  wire [3:0] n249_o;
  wire n251_o;
  wire [7:0] n252_o;
  wire n254_o;
  wire [7:0] n255_o;
  wire n257_o;
  wire [7:0] n258_o;
  wire n260_o;
  wire [10:0] n261_o;
  reg n262_o;
  reg n263_o;
  reg n264_o;
  reg n265_o;
  reg [3:0] n266_o;
  reg n267_o;
  reg n268_o;
  reg [7:0] n269_o;
  reg [3:0] n270_o;
  reg [2:0] n271_o;
  reg [7:0] n272_o;
  reg [7:0] n273_o;
  reg [7:0] n274_o;
  reg [6:0] n275_o;
  reg n276_o;
  reg n277_o;
  reg n278_o;
  reg [2:0] n279_o;
  reg [3:0] n280_o;
  reg n281_o;
  reg n282_o;
  reg n283_o;
  reg n284_o;
  wire n285_o;
  wire [7:0] n286_o;
  wire [7:0] n287_o;
  wire [7:0] n288_o;
  wire [7:0] n289_o;
  wire [5:0] n290_o;
  wire [5:0] n291_o;
  wire [5:0] n292_o;
  wire [5:0] n293_o;
  wire n294_o;
  wire n295_o;
  wire n296_o;
  wire n297_o;
  wire n298_o;
  wire [3:0] n299_o;
  wire n300_o;
  wire n301_o;
  wire [7:0] n302_o;
  wire [3:0] n303_o;
  wire [2:0] n304_o;
  wire [7:0] n305_o;
  wire [7:0] n306_o;
  wire [7:0] n307_o;
  wire [6:0] n308_o;
  wire n309_o;
  wire n310_o;
  wire n311_o;
  wire [2:0] n312_o;
  wire [3:0] n313_o;
  wire n314_o;
  wire n315_o;
  wire n316_o;
  wire n317_o;
  wire n318_o;
  wire n320_o;
  wire n322_o;
  wire n323_o;
  wire [13:0] n324_o;
  wire [13:0] n325_o;
  wire [7:0] n326_o;
  wire [7:0] n327_o;
  wire n329_o;
  wire n330_o;
  wire n331_o;
  wire n332_o;
  wire n333_o;
  wire n334_o;
  wire [3:0] n335_o;
  wire n336_o;
  wire n337_o;
  wire [7:0] n338_o;
  wire [3:0] n339_o;
  wire [2:0] n340_o;
  wire [7:0] n341_o;
  wire [7:0] n342_o;
  wire [7:0] n343_o;
  wire [6:0] n344_o;
  wire n345_o;
  wire n346_o;
  wire n347_o;
  wire [2:0] n348_o;
  wire [3:0] n349_o;
  wire n350_o;
  wire n351_o;
  wire n352_o;
  wire n353_o;
  wire n354_o;
  wire n355_o;
  wire n356_o;
  wire [1:0] n357_o;
  wire n358_o;
  wire [2:0] n359_o;
  wire n361_o;
  wire n363_o;
  wire n365_o;
  wire n368_o;
  wire [3:0] n369_o;
  wire [4:0] n370_o;
  wire [4:0] n371_o;
  wire [4:0] n372_o;
  wire [4:0] n373_o;
  reg [4:0] n374_o;
  wire n375_o;
  wire n376_o;
  wire n377_o;
  wire n378_o;
  reg n379_o;
  wire n380_o;
  wire n381_o;
  wire n382_o;
  wire n383_o;
  reg n384_o;
  wire n385_o;
  wire n386_o;
  wire n387_o;
  wire n388_o;
  reg n389_o;
  reg n392_o;
  reg n394_o;
  reg n396_o;
  reg n398_o;
  reg n401_o;
  wire [13:0] n403_o;
  wire [7:0] n404_o;
  wire n406_o;
  wire [13:0] n407_o;
  wire n408_o;
  wire n410_o;
  wire n412_o;
  wire [7:0] n413_o;
  wire [7:0] n414_o;
  wire n415_o;
  wire [13:0] n416_o;
  wire [7:0] n417_o;
  wire n418_o;
  wire n419_o;
  wire n420_o;
  wire n422_o;
  wire [7:0] n423_o;
  wire n424_o;
  wire n425_o;
  wire n426_o;
  wire [13:0] n427_o;
  wire [7:0] n428_o;
  wire n429_o;
  wire n430_o;
  wire n431_o;
  wire n432_o;
  wire n433_o;
  wire n434_o;
  wire n435_o;
  wire [3:0] n436_o;
  wire n437_o;
  wire n438_o;
  wire [7:0] n439_o;
  wire [3:0] n440_o;
  wire [2:0] n441_o;
  wire [7:0] n442_o;
  wire [7:0] n443_o;
  wire [7:0] n444_o;
  wire [6:0] n445_o;
  wire n446_o;
  wire n447_o;
  wire n448_o;
  wire [2:0] n449_o;
  wire [3:0] n450_o;
  wire n451_o;
  wire n452_o;
  wire n453_o;
  wire n454_o;
  wire n455_o;
  wire n456_o;
  wire n458_o;
  wire n459_o;
  wire n461_o;
  wire n463_o;
  wire n464_o;
  wire n465_o;
  wire n467_o;
  wire n469_o;
  wire n470_o;
  wire [13:0] n471_o;
  wire [7:0] n472_o;
  wire [7:0] n473_o;
  wire n474_o;
  wire n475_o;
  wire n476_o;
  wire n477_o;
  wire n478_o;
  wire n479_o;
  wire n480_o;
  wire n481_o;
  wire n482_o;
  wire n483_o;
  wire n484_o;
  wire n485_o;
  wire n486_o;
  wire n487_o;
  wire n488_o;
  wire n489_o;
  wire n490_o;
  wire n491_o;
  wire n492_o;
  wire n493_o;
  wire n494_o;
  wire n495_o;
  wire n496_o;
  wire n497_o;
  wire n498_o;
  wire n499_o;
  wire n500_o;
  wire n620_o;
  wire n622_o;
  wire n624_o;
  wire n625_o;
  wire n627_o;
  wire n628_o;
  wire n629_o;
  wire n631_o;
  wire n632_o;
  wire n633_o;
  wire n634_o;
  wire n635_o;
  wire n636_o;
  wire n637_o;
  wire n638_o;
  wire n639_o;
  wire n640_o;
  wire n641_o;
  wire n643_o;
  wire n645_o;
  wire n646_o;
  wire n647_o;
  wire n653_o;
  wire [7:0] n654_o;
  wire n655_o;
  wire n656_o;
  wire n658_o;
  wire n659_o;
  wire n660_o;
  wire n661_o;
  wire n662_o;
  wire n664_o;
  wire n666_o;
  wire n667_o;
  wire n668_o;
  wire n670_o;
  wire n671_o;
  wire n672_o;
  wire n674_o;
  wire n675_o;
  wire n677_o;
  wire n678_o;
  wire [7:0] n680_o;
  wire [7:0] n681_o;
  wire n682_o;
  wire [7:0] n683_o;
  wire n684_o;
  wire n686_o;
  wire [7:0] n687_o;
  wire n688_o;
  wire n689_o;
  wire n690_o;
  wire n691_o;
  wire n692_o;
  wire [7:0] n693_o;
  wire n694_o;
  wire [2:0] n702_o;
  wire n703_o;
  wire n704_o;
  wire n705_o;
  wire n706_o;
  wire n707_o;
  wire n708_o;
  wire n709_o;
  wire n710_o;
  wire n711_o;
  wire n712_o;
  wire n713_o;
  wire n714_o;
  wire [2:0] n715_o;
  wire n717_o;
  wire n720_o;
  wire n722_o;
  wire n723_o;
  wire n725_o;
  wire n727_o;
  wire n728_o;
  wire n730_o;
  wire n732_o;
  wire n733_o;
  wire n734_o;
  wire n735_o;
  wire n736_o;
  wire n738_o;
  wire n740_o;
  wire n741_o;
  wire n743_o;
  wire n744_o;
  wire n745_o;
  wire [12:0] n746_o;
  wire n748_o;
  wire n750_o;
  wire n751_o;
  wire n752_o;
  wire n754_o;
  wire n755_o;
  wire n756_o;
  wire n757_o;
  wire n759_o;
  wire n760_o;
  wire n761_o;
  wire n762_o;
  wire n764_o;
  wire n766_o;
  wire n768_o;
  wire n770_o;
  wire n771_o;
  wire n772_o;
  wire n773_o;
  wire n774_o;
  wire n775_o;
  wire n776_o;
  wire n777_o;
  wire n779_o;
  wire [2:0] n781_o;
  wire n783_o;
  wire [2:0] n784_o;
  wire n786_o;
  wire [2:0] n788_o;
  wire n789_o;
  wire [2:0] n790_o;
  wire n791_o;
  wire [13:0] n792_o;
  wire [13:0] n793_o;
  wire n794_o;
  wire n795_o;
  wire n796_o;
  wire [2:0] n797_o;
  wire n798_o;
  wire [13:0] n800_o;
  wire n801_o;
  wire n802_o;
  wire n813_o;
  wire [7:0] n814_o;
  wire n816_o;
  wire [7:0] n817_o;
  wire n818_o;
  wire [7:0] n819_o;
  wire [7:0] n821_o;
  reg n824_q;
  reg n825_q;
  reg n826_q;
  reg n827_q;
  wire n828_o;
  wire n829_o;
  reg n830_q;
  reg n831_q;
  wire n832_o;
  wire n833_o;
  reg n834_q;
  wire n835_o;
  wire [13:0] n836_o;
  reg [13:0] n837_q;
  wire n838_o;
  wire [7:0] n839_o;
  reg [7:0] n840_q;
  reg [7:0] n841_q;
  wire n842_o;
  wire n843_o;
  reg n844_q;
  reg n845_q;
  reg n846_q;
  reg n847_q;
  reg n848_q;
  reg n849_q;
  reg [3:0] n850_q;
  reg n851_q;
  reg n852_q;
  reg [7:0] n853_q;
  reg [3:0] n854_q;
  wire n855_o;
  wire [2:0] n856_o;
  reg [2:0] n857_q;
  wire n858_o;
  wire [7:0] n859_o;
  reg [7:0] n860_q;
  reg [7:0] n861_q;
  reg [7:0] n862_q;
  reg [7:0] n863_q;
  reg [6:0] n864_q;
  reg n865_q;
  reg n866_q;
  reg n867_q;
  reg [2:0] n868_q;
  reg [3:0] n869_q;
  reg n870_q;
  reg n871_q;
  reg [2:0] n872_q;
  reg n873_q;
  reg [13:0] n874_q;
  reg n875_q;
  reg n876_q;
  reg [7:0] n877_q;
  reg n878_q;
  reg n879_q;
  wire n880_o;
  wire n881_o;
  wire [7:0] n882_o;
  reg [7:0] n883_q;
  wire n884_o;
  wire [7:0] n885_o;
  reg [7:0] n886_q;
  reg n887_q;
  reg n888_q;
  reg n889_q;
  reg n890_q;
  reg n891_q;
  wire n892_o;
  wire n893_o;
  wire [7:0] n894_o;
  reg [7:0] n895_q;
  wire [127:0] n896_o;
  assign IRQ_n = n891_q;
  assign D_out = n895_q;
  assign color = vdp_main_inst_color;
  assign y1 = vdp_main_inst_y1;
  assign mask_column = mask_column0;
  assign smode_M1 = n108_o;
  assign smode_M2 = mode_m2;
  assign smode_M3 = n109_o;
  assign smode_M4 = mode_m4;
  assign ss_regs_out = n896_o;
  assign ss_cram_out = vdp_cram_inst_ss_d;
  assign ss_vram_D = vram_cpu_d_out_raw;
  /* ./vdp.vhd:118:16  */
  assign old_rd_n = n824_q; // (signal)
  /* ./vdp.vhd:119:16  */
  assign old_wr_n = n825_q; // (signal)
  /* ./vdp.vhd:120:16  */
  assign old_hl = n826_q; // (signal)
  /* ./vdp.vhd:121:16  */
  assign old_wr_direct = n827_q; // (signal)
  /* ./vdp.vhd:124:16  */
  assign data_write = n830_q; // (signal)
  /* ./vdp.vhd:125:16  */
  always @*
    address_ff = n831_q; // (isignal)
  initial
    address_ff = 1'b0;
  /* ./vdp.vhd:126:16  */
  always @*
    to_cram = n834_q; // (isignal)
  initial
    to_cram = 1'b0;
  /* ./vdp.vhd:127:16  */
  assign spr_collide = vdp_main_inst_spr_collide; // (signal)
  /* ./vdp.vhd:128:16  */
  assign spr_overflow = vdp_main_inst_spr_overflow; // (signal)
  /* ./vdp.vhd:131:16  */
  assign vram_cpu_a = n100_o; // (signal)
  /* ./vdp.vhd:132:16  */
  assign xram_cpu_a = n837_q; // (signal)
  /* ./vdp.vhd:133:16  */
  assign vram_cpu_we = n95_o; // (signal)
  /* ./vdp.vhd:134:16  */
  assign cram_cpu_we = n91_o; // (signal)
  /* ./vdp.vhd:135:16  */
  assign vram_cpu_d_out = vram_cpu_d_out_raw; // (signal)
  /* ./vdp.vhd:136:16  */
  assign vram_cpu_d_out_raw = vdp_vram_inst_q_a; // (signal)
  /* ./vdp.vhd:137:16  */
  assign vram_cpu_d_outl = n840_q; // (signal)
  /* ./vdp.vhd:138:16  */
  always @*
    cpu_write_data = n841_q; // (isignal)
  initial
    cpu_write_data = 8'b00000000;
  /* ./vdp.vhd:139:16  */
  always @*
    xram_cpu_a_incr = n844_q; // (isignal)
  initial
    xram_cpu_a_incr = 1'b0;
  /* ./vdp.vhd:140:16  */
  always @*
    xram_cpu_read = n845_q; // (isignal)
  initial
    xram_cpu_read = 1'b0;
  /* ./vdp.vhd:143:16  */
  assign vram_porta_address = n53_o; // (signal)
  /* ./vdp.vhd:144:16  */
  assign vram_porta_wren = n57_o; // (signal)
  /* ./vdp.vhd:145:16  */
  assign vram_porta_data = n58_o; // (signal)
  /* ./vdp.vhd:148:16  */
  assign vram_vdp_a = vdp_main_inst_vram_a; // (signal)
  /* ./vdp.vhd:149:16  */
  assign vram_vdp_d = vdp_vram_inst_q_b; // (signal)
  /* ./vdp.vhd:150:16  */
  assign cram_vdp_a = vdp_main_inst_cram_a; // (signal)
  /* ./vdp.vhd:151:16  */
  assign cram_vdp_d = vdp_cram_inst_vdp_d; // (signal)
  /* ./vdp.vhd:152:16  */
  assign cram_vdp_a_in = n68_o; // (signal)
  /* ./vdp.vhd:153:16  */
  assign cram_vdp_d_in = n82_o; // (signal)
  /* ./vdp.vhd:156:16  */
  always @*
    display_on = n846_q; // (isignal)
  initial
    display_on = 1'b1;
  /* ./vdp.vhd:157:16  */
  always @*
    disable_hscroll = n847_q; // (isignal)
  initial
    disable_hscroll = 1'b0;
  /* ./vdp.vhd:158:16  */
  always @*
    disable_vscroll = n848_q; // (isignal)
  initial
    disable_vscroll = 1'b0;
  /* ./vdp.vhd:159:16  */
  always @*
    mask_column0 = n849_q; // (isignal)
  initial
    mask_column0 = 1'b0;
  /* ./vdp.vhd:160:16  */
  always @*
    overscan = n850_q; // (isignal)
  initial
    overscan = 4'b0000;
  /* ./vdp.vhd:161:16  */
  always @*
    irq_frame_en = n851_q; // (isignal)
  initial
    irq_frame_en = 1'b0;
  /* ./vdp.vhd:162:16  */
  always @*
    irq_line_en = n852_q; // (isignal)
  initial
    irq_line_en = 1'b0;
  /* ./vdp.vhd:163:16  */
  always @*
    irq_line_count = n853_q; // (isignal)
  initial
    irq_line_count = 8'b11111111;
  /* ./vdp.vhd:164:16  */
  always @*
    bg_address = n854_q; // (isignal)
  initial
    bg_address = 4'b0000;
  /* ./vdp.vhd:165:16  */
  always @*
    m2mg_address = n857_q; // (isignal)
  initial
    m2mg_address = 3'b000;
  /* ./vdp.vhd:166:16  */
  always @*
    m2ct_address = n860_q; // (isignal)
  initial
    m2ct_address = 8'b11111111;
  /* ./vdp.vhd:167:16  */
  always @*
    bg_scroll_x = n861_q; // (isignal)
  initial
    bg_scroll_x = 8'b00000000;
  /* ./vdp.vhd:168:16  */
  always @*
    bg_scroll_x_latched = n862_q; // (isignal)
  initial
    bg_scroll_x_latched = 8'b00000000;
  /* ./vdp.vhd:169:16  */
  always @*
    bg_scroll_y = n863_q; // (isignal)
  initial
    bg_scroll_y = 8'b00000000;
  /* ./vdp.vhd:170:16  */
  always @*
    spr_address = n864_q; // (isignal)
  initial
    spr_address = 7'b0000000;
  /* ./vdp.vhd:171:16  */
  always @*
    spr_shift = n865_q; // (isignal)
  initial
    spr_shift = 1'b0;
  /* ./vdp.vhd:172:16  */
  always @*
    spr_tall = n866_q; // (isignal)
  initial
    spr_tall = 1'b0;
  /* ./vdp.vhd:173:16  */
  always @*
    spr_wide = n867_q; // (isignal)
  initial
    spr_wide = 1'b0;
  /* ./vdp.vhd:174:16  */
  always @*
    spr_high_bits = n868_q; // (isignal)
  initial
    spr_high_bits = 3'b000;
  /* ./vdp.vhd:175:16  */
  always @*
    legacy_fg_color = n869_q; // (isignal)
  initial
    legacy_fg_color = 4'b0000;
  /* ./vdp.vhd:178:16  */
  always @*
    last_x0 = n870_q; // (isignal)
  initial
    last_x0 = 1'b0;
  /* ./vdp.vhd:179:16  */
  assign reset_flags = n871_q; // (signal)
  /* ./vdp.vhd:180:16  */
  always @*
    irq_delay = n872_q; // (isignal)
  initial
    irq_delay = 3'b111;
  /* ./vdp.vhd:181:16  */
  always @*
    collide_flag = n873_q; // (isignal)
  initial
    collide_flag = 1'b0;
  /* ./vdp.vhd:183:16  */
  always @*
    xspr_collide_shift = n874_q; // (isignal)
  initial
    xspr_collide_shift = 14'b00000000000000;
  /* ./vdp.vhd:184:16  */
  always @*
    overflow_flag = n875_q; // (isignal)
  initial
    overflow_flag = 1'b0;
  /* ./vdp.vhd:185:16  */
  always @*
    line_overflow = n876_q; // (isignal)
  initial
    line_overflow = 1'b0;
  /* ./vdp.vhd:186:16  */
  always @*
    hbl_counter = n877_q; // (isignal)
  initial
    hbl_counter = 8'b00000000;
  /* ./vdp.vhd:187:16  */
  assign vbl_irq = n878_q; // (signal)
  /* ./vdp.vhd:188:16  */
  assign hbl_irq = n879_q; // (signal)
  /* ./vdp.vhd:189:16  */
  assign latched_x = n883_q; // (signal)
  /* ./vdp.vhd:191:16  */
  assign cram_latch = n886_q; // (signal)
  /* ./vdp.vhd:192:16  */
  assign mode_m1 = n887_q; // (signal)
  /* ./vdp.vhd:193:16  */
  assign mode_m2 = n888_q; // (signal)
  /* ./vdp.vhd:194:16  */
  assign mode_m3 = n889_q; // (signal)
  /* ./vdp.vhd:195:16  */
  assign mode_m4 = n890_q; // (signal)
  /* ./vdp.vhd:196:16  */
  assign xmode_m1 = n45_o; // (signal)
  /* ./vdp.vhd:197:16  */
  assign xmode_m3 = n46_o; // (signal)
  /* ./vdp.vhd:198:16  */
  assign xmode_m4 = mode_m4; // (signal)
  /* ./vdp.vhd:203:28  */
  assign n45_o = mode_m1 & mode_m2;
  /* ./vdp.vhd:204:28  */
  assign n46_o = mode_m3 & mode_m2;
  /* ./vdp.vhd:207:9  */
  vdp_main_7 vdp_main_inst (
    .clk_sys(clk_sys),
    .ce_vdp(ce_vdp),
    .ce_pix(ce_pix),
    .ce_sp(ce_sp),
    .ggres(ggres),
    .sp64(sp64),
    .legacy_ext_nt(legacy_ext_nt),
    .vram_d(vram_vdp_d),
    .cram_d(cram_vdp_d),
    .x(x),
    .y(y),
    .palettemode(palettemode),
    .display_on(display_on),
    .mask_column0(mask_column0),
    .black_column(black_column),
    .mode_m1_raw(mode_m1),
    .mode_m2_raw(mode_m2),
    .mode_m3_raw(mode_m3),
    .smode_m1(xmode_m1),
    .smode_m3(xmode_m3),
    .smode_m4(xmode_m4),
    .ysj_quirk(ysj_quirk),
    .overscan(overscan),
    .text_fg_color(legacy_fg_color),
    .bg_address(bg_address),
    .m2mg_address(m2mg_address),
    .m2ct_address(m2ct_address),
    .bg_scroll_x(bg_scroll_x_latched),
    .bg_scroll_y(bg_scroll_y),
    .disable_hscroll(disable_hscroll),
    .disable_vscroll(disable_vscroll),
    .spr_address(spr_address),
    .spr_high_bits(spr_high_bits),
    .spr_shift(spr_shift),
    .spr_tall(spr_tall),
    .spr_wide(spr_wide),
    .ss_regs_set(ss_regs_set),
    .vram_a(vdp_main_inst_vram_a),
    .cram_a(vdp_main_inst_cram_a),
    .color(vdp_main_inst_color),
    .y1(vdp_main_inst_y1),
    .spr_collide(vdp_main_inst_spr_collide),
    .spr_overflow(vdp_main_inst_spr_overflow));
  /* ./vdp.vhd:263:42  */
  assign n53_o = ss_vram_WE ? ss_vram_WA : n54_o;
  /* ./vdp.vhd:263:62  */
  assign n54_o = ss_vram_en ? ss_vram_A : vram_cpu_a;
  /* ./vdp.vhd:266:62  */
  assign n55_o = ~ss_vram_en;
  /* ./vdp.vhd:266:58  */
  assign n56_o = vram_cpu_we & n55_o;
  /* ./vdp.vhd:266:42  */
  assign n57_o = ss_vram_WE | n56_o;
  /* ./vdp.vhd:267:42  */
  assign n58_o = ss_vram_WE ? ss_vram_WD : cpu_write_data;
  /* ./vdp.vhd:269:9  */
  dpram_15_8_f8d0212558df9752eb44381ca87663907f59d33e vdp_vram_inst (
    .address_a(vram_porta_address),
    .address_b(n59_o),
    .clock_a(clk_sys),
    .clock_b(clk_sys),
    .data_a(vram_porta_data),
    .data_b(n60_o),
    .wren_a(vram_porta_wren),
    .wren_b(n61_o),
    .q_a(vdp_vram_inst_q_a),
    .q_b(vdp_vram_inst_q_b));
  /* ./vdp.vhd:285:44  */
  assign n59_o = {se_bank, vram_vdp_a};
  /* ./vdp.vhd:295:9  */
  vdp_cram vdp_cram_inst (
    .cpu_clk(clk_sys),
    .cpu_we(cram_cpu_we),
    .cpu_a(cram_vdp_a_in),
    .cpu_d(cram_vdp_d_in),
    .vdp_clk(clk_sys),
    .vdp_a(cram_vdp_a),
    .ss_wr(ss_cram_wr),
    .ss_a(ss_cram_A),
    .ss_wd(ss_cram_D),
    .vdp_d(vdp_cram_inst_vdp_d),
    .ss_d(vdp_cram_inst_ss_d));
  /* ./vdp.vhd:310:36  */
  assign n66_o = xram_cpu_a[4:0];
  /* ./vdp.vhd:310:56  */
  assign n67_o = ~gg;
  /* ./vdp.vhd:310:49  */
  assign n68_o = n67_o ? n66_o : n69_o;
  /* ./vdp.vhd:310:76  */
  assign n69_o = xram_cpu_a[5:1];
  /* ./vdp.vhd:311:41  */
  assign n70_o = cpu_write_data[5:4];
  /* ./vdp.vhd:311:70  */
  assign n71_o = cpu_write_data[5:4];
  /* ./vdp.vhd:311:54  */
  assign n72_o = {n70_o, n71_o};
  /* ./vdp.vhd:312:43  */
  assign n73_o = cpu_write_data[3:2];
  /* ./vdp.vhd:311:83  */
  assign n74_o = {n72_o, n73_o};
  /* ./vdp.vhd:312:72  */
  assign n75_o = cpu_write_data[3:2];
  /* ./vdp.vhd:312:56  */
  assign n76_o = {n74_o, n75_o};
  /* ./vdp.vhd:313:43  */
  assign n77_o = cpu_write_data[1:0];
  /* ./vdp.vhd:312:85  */
  assign n78_o = {n76_o, n77_o};
  /* ./vdp.vhd:313:72  */
  assign n79_o = cpu_write_data[1:0];
  /* ./vdp.vhd:313:56  */
  assign n80_o = {n78_o, n79_o};
  /* ./vdp.vhd:314:64  */
  assign n81_o = ~gg;
  /* ./vdp.vhd:314:57  */
  assign n82_o = n81_o ? n80_o : n84_o;
  /* ./vdp.vhd:314:89  */
  assign n83_o = cpu_write_data[3:0];
  /* ./vdp.vhd:314:102  */
  assign n84_o = {n83_o, cram_latch};
  /* ./vdp.vhd:315:56  */
  assign n85_o = ~gg;
  /* ./vdp.vhd:315:76  */
  assign n86_o = xram_cpu_a[0];
  /* ./vdp.vhd:315:62  */
  assign n87_o = n85_o | n86_o;
  /* ./vdp.vhd:315:48  */
  assign n88_o = n87_o & to_cram;
  /* ./vdp.vhd:315:99  */
  assign n89_o = ~WR_direct;
  /* ./vdp.vhd:315:86  */
  assign n90_o = n89_o & n88_o;
  /* ./vdp.vhd:315:35  */
  assign n91_o = n90_o ? data_write : 1'b0;
  /* ./vdp.vhd:316:58  */
  assign n93_o = ~to_cram;
  /* ./vdp.vhd:316:55  */
  assign n94_o = WR_direct | n93_o;
  /* ./vdp.vhd:316:35  */
  assign n95_o = n94_o ? data_write : 1'b0;
  /* ./vdp.vhd:317:23  */
  assign n97_o = ~se_bank;
  /* ./vdp.vhd:317:35  */
  assign n98_o = {n97_o, A_direct};
  /* ./vdp.vhd:317:46  */
  assign n99_o = {n98_o, A};
  /* ./vdp.vhd:317:50  */
  assign n100_o = WR_direct ? n99_o : n101_o;
  /* ./vdp.vhd:317:82  */
  assign n101_o = {se_bank, xram_cpu_a};
  /* ./vdp.vhd:347:48  */
  assign n103_o = to_cram ? 1'b1 : 1'b0;
  /* ./vdp.vhd:351:48  */
  assign n106_o = reset_flags ? 1'b1 : 1'b0;
  /* ./vdp.vhd:361:29  */
  assign n108_o = mode_m1 & mode_m2;
  /* ./vdp.vhd:363:29  */
  assign n109_o = mode_m3 & mode_m2;
  /* ./vdp.vhd:369:27  */
  assign n113_o = ~reset_n;
  /* ./vdp.vhd:406:62  */
  assign n115_o = ss_regs_in[0];
  /* ./vdp.vhd:407:62  */
  assign n116_o = ss_regs_in[1];
  /* ./vdp.vhd:408:62  */
  assign n117_o = ss_regs_in[2];
  /* ./vdp.vhd:409:62  */
  assign n118_o = ss_regs_in[3];
  /* ./vdp.vhd:410:62  */
  assign n119_o = ss_regs_in[4];
  /* ./vdp.vhd:411:62  */
  assign n120_o = ss_regs_in[5];
  /* ./vdp.vhd:412:62  */
  assign n121_o = ss_regs_in[6];
  /* ./vdp.vhd:413:62  */
  assign n122_o = ss_regs_in[7];
  /* ./vdp.vhd:414:62  */
  assign n123_o = ss_regs_in[8];
  /* ./vdp.vhd:415:62  */
  assign n124_o = ss_regs_in[9];
  /* ./vdp.vhd:416:62  */
  assign n125_o = ss_regs_in[10];
  /* ./vdp.vhd:417:62  */
  assign n126_o = ss_regs_in[11];
  /* ./vdp.vhd:418:62  */
  assign n127_o = ss_regs_in[12];
  /* ./vdp.vhd:419:62  */
  assign n128_o = ss_regs_in[16:13];
  /* ./vdp.vhd:420:62  */
  assign n129_o = ss_regs_in[19:17];
  /* ./vdp.vhd:421:62  */
  assign n130_o = ss_regs_in[27:20];
  /* ./vdp.vhd:422:62  */
  assign n131_o = ss_regs_in[35:28];
  /* ./vdp.vhd:423:62  */
  assign n132_o = ss_regs_in[43:36];
  /* ./vdp.vhd:424:62  */
  assign n133_o = ss_regs_in[50:44];
  /* ./vdp.vhd:425:62  */
  assign n134_o = ss_regs_in[53:51];
  /* ./vdp.vhd:426:62  */
  assign n135_o = ss_regs_in[57:54];
  /* ./vdp.vhd:427:62  */
  assign n136_o = ss_regs_in[61:58];
  /* ./vdp.vhd:428:62  */
  assign n137_o = ss_regs_in[69:62];
  /* ./vdp.vhd:429:62  */
  assign n138_o = ss_regs_in[83:70];
  /* ./vdp.vhd:430:62  */
  assign n139_o = ss_regs_in[84];
  /* ./vdp.vhd:431:63  */
  assign n140_o = ss_regs_in[85];
  /* ./vdp.vhd:432:62  */
  assign n141_o = ss_regs_in[93:86];
  /* ./vdp.vhd:433:62  */
  assign n142_o = ss_regs_in[101:94];
  /* ./vdp.vhd:434:62  */
  assign n143_o = ss_regs_in[102];
  /* ./vdp.vhd:405:25  */
  assign n144_o = ss_regs_set ? RD_n : old_rd_n;
  /* ./vdp.vhd:405:25  */
  assign n145_o = ss_regs_set ? WR_n : old_wr_n;
  /* ./vdp.vhd:405:25  */
  assign n147_o = ss_regs_set ? WR_direct : old_wr_direct;
  /* ./vdp.vhd:405:25  */
  assign n148_o = ss_regs_set ? n139_o : address_ff;
  /* ./vdp.vhd:405:25  */
  assign n149_o = ss_regs_set ? n140_o : to_cram;
  /* ./vdp.vhd:405:25  */
  assign n150_o = ss_regs_set ? n138_o : xram_cpu_a;
  /* ./vdp.vhd:405:25  */
  assign n151_o = ss_regs_set ? n141_o : vram_cpu_d_outl;
  /* ./vdp.vhd:405:25  */
  assign n152_o = ss_regs_set ? D_in : cpu_write_data;
  /* ./vdp.vhd:405:25  */
  assign n154_o = ss_regs_set ? 1'b0 : xram_cpu_a_incr;
  /* ./vdp.vhd:405:25  */
  assign n155_o = ss_regs_set ? n143_o : xram_cpu_read;
  /* ./vdp.vhd:405:25  */
  assign n156_o = ss_regs_set ? n122_o : display_on;
  /* ./vdp.vhd:405:25  */
  assign n157_o = ss_regs_set ? n115_o : disable_hscroll;
  /* ./vdp.vhd:405:25  */
  assign n158_o = ss_regs_set ? n116_o : disable_vscroll;
  /* ./vdp.vhd:405:25  */
  assign n159_o = ss_regs_set ? n117_o : mask_column0;
  /* ./vdp.vhd:405:25  */
  assign n160_o = ss_regs_set ? n136_o : overscan;
  /* ./vdp.vhd:405:25  */
  assign n161_o = ss_regs_set ? n123_o : irq_frame_en;
  /* ./vdp.vhd:405:25  */
  assign n162_o = ss_regs_set ? n118_o : irq_line_en;
  /* ./vdp.vhd:405:25  */
  assign n163_o = ss_regs_set ? n137_o : irq_line_count;
  /* ./vdp.vhd:405:25  */
  assign n164_o = ss_regs_set ? n128_o : bg_address;
  /* ./vdp.vhd:405:25  */
  assign n165_o = ss_regs_set ? n129_o : m2mg_address;
  /* ./vdp.vhd:405:25  */
  assign n166_o = ss_regs_set ? n130_o : m2ct_address;
  /* ./vdp.vhd:405:25  */
  assign n167_o = ss_regs_set ? n131_o : bg_scroll_x;
  /* ./vdp.vhd:405:25  */
  assign n168_o = ss_regs_set ? n132_o : bg_scroll_y;
  /* ./vdp.vhd:405:25  */
  assign n169_o = ss_regs_set ? n133_o : spr_address;
  /* ./vdp.vhd:405:25  */
  assign n170_o = ss_regs_set ? n119_o : spr_shift;
  /* ./vdp.vhd:405:25  */
  assign n171_o = ss_regs_set ? n126_o : spr_tall;
  /* ./vdp.vhd:405:25  */
  assign n172_o = ss_regs_set ? n127_o : spr_wide;
  /* ./vdp.vhd:405:25  */
  assign n173_o = ss_regs_set ? n134_o : spr_high_bits;
  /* ./vdp.vhd:405:25  */
  assign n174_o = ss_regs_set ? n135_o : legacy_fg_color;
  /* ./vdp.vhd:405:25  */
  assign n176_o = ss_regs_set ? 1'b0 : reset_flags;
  /* ./vdp.vhd:405:25  */
  assign n177_o = ss_regs_set ? n142_o : cram_latch;
  /* ./vdp.vhd:405:25  */
  assign n178_o = ss_regs_set ? n124_o : mode_m1;
  /* ./vdp.vhd:405:25  */
  assign n179_o = ss_regs_set ? n121_o : mode_m2;
  /* ./vdp.vhd:405:25  */
  assign n180_o = ss_regs_set ? n125_o : mode_m3;
  /* ./vdp.vhd:405:25  */
  assign n181_o = ss_regs_set ? n120_o : mode_m4;
  /* ./vdp.vhd:451:35  */
  assign n182_o = ~old_hl;
  /* ./vdp.vhd:451:41  */
  assign n183_o = HL & n182_o;
  /* ./vdp.vhd:452:47  */
  assign n184_o = x[8:1];
  /* ./vdp.vhd:459:66  */
  assign n186_o = old_wr_n != WR_n;
  /* ./vdp.vhd:459:53  */
  assign n187_o = n186_o & capture_cpu_edges;
  /* ./vdp.vhd:458:41  */
  assign n188_o = ce_vdp | n187_o;
  /* ./vdp.vhd:464:50  */
  assign n189_o = ~old_wr_direct;
  /* ./vdp.vhd:464:56  */
  assign n190_o = WR_direct & n189_o;
  /* ./vdp.vhd:464:33  */
  assign n193_o = n190_o ? 1'b1 : 1'b0;
  /* ./vdp.vhd:464:33  */
  assign n194_o = n190_o ? D_in : n152_o;
  /* ./vdp.vhd:468:59  */
  assign n195_o = ~WR_n;
  /* ./vdp.vhd:468:51  */
  assign n196_o = n195_o & old_wr_n;
  /* ./vdp.vhd:469:45  */
  assign n197_o = A[0];
  /* ./vdp.vhd:469:48  */
  assign n198_o = ~n197_o;
  /* ./vdp.vhd:475:75  */
  assign n199_o = xram_cpu_a[0];
  /* ./vdp.vhd:475:78  */
  assign n200_o = ~n199_o;
  /* ./vdp.vhd:475:61  */
  assign n201_o = n200_o & to_cram;
  /* ./vdp.vhd:458:25  */
  assign n202_o = n496_o ? D_in : n177_o;
  /* ./vdp.vhd:479:62  */
  assign n203_o = ~address_ff;
  /* ./vdp.vhd:482:88  */
  assign n204_o = D_in[5:0];
  /* ./vdp.vhd:483:72  */
  assign n205_o = D_in[7:6];
  /* ./vdp.vhd:483:84  */
  assign n207_o = n205_o == 2'b11;
  /* ./vdp.vhd:484:64  */
  assign n208_o = D_in[7:6];
  /* ./vdp.vhd:484:76  */
  assign n210_o = n208_o == 2'b00;
  /* ./vdp.vhd:484:57  */
  assign n212_o = n210_o ? 1'b1 : n155_o;
  /* ./vdp.vhd:487:66  */
  assign n213_o = D_in[7:6];
  /* ./vdp.vhd:487:83  */
  assign n214_o = D_in[3:0];
  /* ./vdp.vhd:487:78  */
  assign n215_o = {n213_o, n214_o};
  /* ./vdp.vhd:489:94  */
  assign n216_o = xram_cpu_a[7];
  /* ./vdp.vhd:490:93  */
  assign n217_o = xram_cpu_a[6];
  /* ./vdp.vhd:491:94  */
  assign n218_o = xram_cpu_a[5];
  /* ./vdp.vhd:492:102  */
  assign n219_o = xram_cpu_a[4];
  /* ./vdp.vhd:493:102  */
  assign n220_o = xram_cpu_a[3];
  /* ./vdp.vhd:494:110  */
  assign n221_o = xram_cpu_a[2];
  /* ./vdp.vhd:495:110  */
  assign n222_o = xram_cpu_a[1];
  /* ./vdp.vhd:488:57  */
  assign n224_o = n215_o == 6'b100000;
  /* ./vdp.vhd:497:102  */
  assign n225_o = xram_cpu_a[6];
  /* ./vdp.vhd:498:94  */
  assign n226_o = xram_cpu_a[5];
  /* ./vdp.vhd:499:110  */
  assign n227_o = xram_cpu_a[4];
  /* ./vdp.vhd:500:110  */
  assign n228_o = xram_cpu_a[3];
  /* ./vdp.vhd:501:110  */
  assign n229_o = xram_cpu_a[1];
  /* ./vdp.vhd:502:110  */
  assign n230_o = xram_cpu_a[0];
  /* ./vdp.vhd:496:57  */
  assign n232_o = n215_o == 6'b100001;
  /* ./vdp.vhd:504:102  */
  assign n233_o = xram_cpu_a[3:0];
  /* ./vdp.vhd:503:57  */
  assign n235_o = n215_o == 6'b100010;
  /* ./vdp.vhd:506:94  */
  assign n236_o = xram_cpu_a[7:0];
  /* ./vdp.vhd:505:57  */
  assign n238_o = n215_o == 6'b100011;
  /* ./vdp.vhd:508:94  */
  assign n239_o = xram_cpu_a[2:0];
  /* ./vdp.vhd:507:57  */
  assign n241_o = n215_o == 6'b100100;
  /* ./vdp.vhd:510:102  */
  assign n242_o = xram_cpu_a[6:0];
  /* ./vdp.vhd:509:57  */
  assign n244_o = n215_o == 6'b100101;
  /* ./vdp.vhd:512:94  */
  assign n245_o = xram_cpu_a[2:0];
  /* ./vdp.vhd:511:57  */
  assign n247_o = n215_o == 6'b100110;
  /* ./vdp.vhd:514:94  */
  assign n248_o = xram_cpu_a[7:4];
  /* ./vdp.vhd:515:110  */
  assign n249_o = xram_cpu_a[3:0];
  /* ./vdp.vhd:513:57  */
  assign n251_o = n215_o == 6'b100111;
  /* ./vdp.vhd:517:102  */
  assign n252_o = xram_cpu_a[7:0];
  /* ./vdp.vhd:516:57  */
  assign n254_o = n215_o == 6'b101000;
  /* ./vdp.vhd:519:102  */
  assign n255_o = xram_cpu_a[7:0];
  /* ./vdp.vhd:518:57  */
  assign n257_o = n215_o == 6'b101001;
  /* ./vdp.vhd:521:94  */
  assign n258_o = xram_cpu_a[7:0];
  /* ./vdp.vhd:520:57  */
  assign n260_o = n215_o == 6'b101010;
  assign n261_o = {n260_o, n257_o, n254_o, n251_o, n247_o, n244_o, n241_o, n238_o, n235_o, n232_o, n224_o};
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n262_o = n156_o;
      11'b01000000000: n262_o = n156_o;
      11'b00100000000: n262_o = n156_o;
      11'b00010000000: n262_o = n156_o;
      11'b00001000000: n262_o = n156_o;
      11'b00000100000: n262_o = n156_o;
      11'b00000010000: n262_o = n156_o;
      11'b00000001000: n262_o = n156_o;
      11'b00000000100: n262_o = n156_o;
      11'b00000000010: n262_o = n225_o;
      11'b00000000001: n262_o = n156_o;
      default: n262_o = n156_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n263_o = n157_o;
      11'b01000000000: n263_o = n157_o;
      11'b00100000000: n263_o = n157_o;
      11'b00010000000: n263_o = n157_o;
      11'b00001000000: n263_o = n157_o;
      11'b00000100000: n263_o = n157_o;
      11'b00000010000: n263_o = n157_o;
      11'b00000001000: n263_o = n157_o;
      11'b00000000100: n263_o = n157_o;
      11'b00000000010: n263_o = n157_o;
      11'b00000000001: n263_o = n217_o;
      default: n263_o = n157_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n264_o = n158_o;
      11'b01000000000: n264_o = n158_o;
      11'b00100000000: n264_o = n158_o;
      11'b00010000000: n264_o = n158_o;
      11'b00001000000: n264_o = n158_o;
      11'b00000100000: n264_o = n158_o;
      11'b00000010000: n264_o = n158_o;
      11'b00000001000: n264_o = n158_o;
      11'b00000000100: n264_o = n158_o;
      11'b00000000010: n264_o = n158_o;
      11'b00000000001: n264_o = n216_o;
      default: n264_o = n158_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n265_o = n159_o;
      11'b01000000000: n265_o = n159_o;
      11'b00100000000: n265_o = n159_o;
      11'b00010000000: n265_o = n159_o;
      11'b00001000000: n265_o = n159_o;
      11'b00000100000: n265_o = n159_o;
      11'b00000010000: n265_o = n159_o;
      11'b00000001000: n265_o = n159_o;
      11'b00000000100: n265_o = n159_o;
      11'b00000000010: n265_o = n159_o;
      11'b00000000001: n265_o = n218_o;
      default: n265_o = n159_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n266_o = n160_o;
      11'b01000000000: n266_o = n160_o;
      11'b00100000000: n266_o = n160_o;
      11'b00010000000: n266_o = n249_o;
      11'b00001000000: n266_o = n160_o;
      11'b00000100000: n266_o = n160_o;
      11'b00000010000: n266_o = n160_o;
      11'b00000001000: n266_o = n160_o;
      11'b00000000100: n266_o = n160_o;
      11'b00000000010: n266_o = n160_o;
      11'b00000000001: n266_o = n160_o;
      default: n266_o = n160_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n267_o = n161_o;
      11'b01000000000: n267_o = n161_o;
      11'b00100000000: n267_o = n161_o;
      11'b00010000000: n267_o = n161_o;
      11'b00001000000: n267_o = n161_o;
      11'b00000100000: n267_o = n161_o;
      11'b00000010000: n267_o = n161_o;
      11'b00000001000: n267_o = n161_o;
      11'b00000000100: n267_o = n161_o;
      11'b00000000010: n267_o = n226_o;
      11'b00000000001: n267_o = n161_o;
      default: n267_o = n161_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n268_o = n162_o;
      11'b01000000000: n268_o = n162_o;
      11'b00100000000: n268_o = n162_o;
      11'b00010000000: n268_o = n162_o;
      11'b00001000000: n268_o = n162_o;
      11'b00000100000: n268_o = n162_o;
      11'b00000010000: n268_o = n162_o;
      11'b00000001000: n268_o = n162_o;
      11'b00000000100: n268_o = n162_o;
      11'b00000000010: n268_o = n162_o;
      11'b00000000001: n268_o = n219_o;
      default: n268_o = n162_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n269_o = n258_o;
      11'b01000000000: n269_o = n163_o;
      11'b00100000000: n269_o = n163_o;
      11'b00010000000: n269_o = n163_o;
      11'b00001000000: n269_o = n163_o;
      11'b00000100000: n269_o = n163_o;
      11'b00000010000: n269_o = n163_o;
      11'b00000001000: n269_o = n163_o;
      11'b00000000100: n269_o = n163_o;
      11'b00000000010: n269_o = n163_o;
      11'b00000000001: n269_o = n163_o;
      default: n269_o = n163_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n270_o = n164_o;
      11'b01000000000: n270_o = n164_o;
      11'b00100000000: n270_o = n164_o;
      11'b00010000000: n270_o = n164_o;
      11'b00001000000: n270_o = n164_o;
      11'b00000100000: n270_o = n164_o;
      11'b00000010000: n270_o = n164_o;
      11'b00000001000: n270_o = n164_o;
      11'b00000000100: n270_o = n233_o;
      11'b00000000010: n270_o = n164_o;
      11'b00000000001: n270_o = n164_o;
      default: n270_o = n164_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n271_o = n165_o;
      11'b01000000000: n271_o = n165_o;
      11'b00100000000: n271_o = n165_o;
      11'b00010000000: n271_o = n165_o;
      11'b00001000000: n271_o = n165_o;
      11'b00000100000: n271_o = n165_o;
      11'b00000010000: n271_o = n239_o;
      11'b00000001000: n271_o = n165_o;
      11'b00000000100: n271_o = n165_o;
      11'b00000000010: n271_o = n165_o;
      11'b00000000001: n271_o = n165_o;
      default: n271_o = n165_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n272_o = n166_o;
      11'b01000000000: n272_o = n166_o;
      11'b00100000000: n272_o = n166_o;
      11'b00010000000: n272_o = n166_o;
      11'b00001000000: n272_o = n166_o;
      11'b00000100000: n272_o = n166_o;
      11'b00000010000: n272_o = n166_o;
      11'b00000001000: n272_o = n236_o;
      11'b00000000100: n272_o = n166_o;
      11'b00000000010: n272_o = n166_o;
      11'b00000000001: n272_o = n166_o;
      default: n272_o = n166_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n273_o = n167_o;
      11'b01000000000: n273_o = n167_o;
      11'b00100000000: n273_o = n252_o;
      11'b00010000000: n273_o = n167_o;
      11'b00001000000: n273_o = n167_o;
      11'b00000100000: n273_o = n167_o;
      11'b00000010000: n273_o = n167_o;
      11'b00000001000: n273_o = n167_o;
      11'b00000000100: n273_o = n167_o;
      11'b00000000010: n273_o = n167_o;
      11'b00000000001: n273_o = n167_o;
      default: n273_o = n167_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n274_o = n168_o;
      11'b01000000000: n274_o = n255_o;
      11'b00100000000: n274_o = n168_o;
      11'b00010000000: n274_o = n168_o;
      11'b00001000000: n274_o = n168_o;
      11'b00000100000: n274_o = n168_o;
      11'b00000010000: n274_o = n168_o;
      11'b00000001000: n274_o = n168_o;
      11'b00000000100: n274_o = n168_o;
      11'b00000000010: n274_o = n168_o;
      11'b00000000001: n274_o = n168_o;
      default: n274_o = n168_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n275_o = n169_o;
      11'b01000000000: n275_o = n169_o;
      11'b00100000000: n275_o = n169_o;
      11'b00010000000: n275_o = n169_o;
      11'b00001000000: n275_o = n169_o;
      11'b00000100000: n275_o = n242_o;
      11'b00000010000: n275_o = n169_o;
      11'b00000001000: n275_o = n169_o;
      11'b00000000100: n275_o = n169_o;
      11'b00000000010: n275_o = n169_o;
      11'b00000000001: n275_o = n169_o;
      default: n275_o = n169_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n276_o = n170_o;
      11'b01000000000: n276_o = n170_o;
      11'b00100000000: n276_o = n170_o;
      11'b00010000000: n276_o = n170_o;
      11'b00001000000: n276_o = n170_o;
      11'b00000100000: n276_o = n170_o;
      11'b00000010000: n276_o = n170_o;
      11'b00000001000: n276_o = n170_o;
      11'b00000000100: n276_o = n170_o;
      11'b00000000010: n276_o = n170_o;
      11'b00000000001: n276_o = n220_o;
      default: n276_o = n170_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n277_o = n171_o;
      11'b01000000000: n277_o = n171_o;
      11'b00100000000: n277_o = n171_o;
      11'b00010000000: n277_o = n171_o;
      11'b00001000000: n277_o = n171_o;
      11'b00000100000: n277_o = n171_o;
      11'b00000010000: n277_o = n171_o;
      11'b00000001000: n277_o = n171_o;
      11'b00000000100: n277_o = n171_o;
      11'b00000000010: n277_o = n229_o;
      11'b00000000001: n277_o = n171_o;
      default: n277_o = n171_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n278_o = n172_o;
      11'b01000000000: n278_o = n172_o;
      11'b00100000000: n278_o = n172_o;
      11'b00010000000: n278_o = n172_o;
      11'b00001000000: n278_o = n172_o;
      11'b00000100000: n278_o = n172_o;
      11'b00000010000: n278_o = n172_o;
      11'b00000001000: n278_o = n172_o;
      11'b00000000100: n278_o = n172_o;
      11'b00000000010: n278_o = n230_o;
      11'b00000000001: n278_o = n172_o;
      default: n278_o = n172_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n279_o = n173_o;
      11'b01000000000: n279_o = n173_o;
      11'b00100000000: n279_o = n173_o;
      11'b00010000000: n279_o = n173_o;
      11'b00001000000: n279_o = n245_o;
      11'b00000100000: n279_o = n173_o;
      11'b00000010000: n279_o = n173_o;
      11'b00000001000: n279_o = n173_o;
      11'b00000000100: n279_o = n173_o;
      11'b00000000010: n279_o = n173_o;
      11'b00000000001: n279_o = n173_o;
      default: n279_o = n173_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n280_o = n174_o;
      11'b01000000000: n280_o = n174_o;
      11'b00100000000: n280_o = n174_o;
      11'b00010000000: n280_o = n248_o;
      11'b00001000000: n280_o = n174_o;
      11'b00000100000: n280_o = n174_o;
      11'b00000010000: n280_o = n174_o;
      11'b00000001000: n280_o = n174_o;
      11'b00000000100: n280_o = n174_o;
      11'b00000000010: n280_o = n174_o;
      11'b00000000001: n280_o = n174_o;
      default: n280_o = n174_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n281_o = n178_o;
      11'b01000000000: n281_o = n178_o;
      11'b00100000000: n281_o = n178_o;
      11'b00010000000: n281_o = n178_o;
      11'b00001000000: n281_o = n178_o;
      11'b00000100000: n281_o = n178_o;
      11'b00000010000: n281_o = n178_o;
      11'b00000001000: n281_o = n178_o;
      11'b00000000100: n281_o = n178_o;
      11'b00000000010: n281_o = n227_o;
      11'b00000000001: n281_o = n178_o;
      default: n281_o = n178_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n282_o = n179_o;
      11'b01000000000: n282_o = n179_o;
      11'b00100000000: n282_o = n179_o;
      11'b00010000000: n282_o = n179_o;
      11'b00001000000: n282_o = n179_o;
      11'b00000100000: n282_o = n179_o;
      11'b00000010000: n282_o = n179_o;
      11'b00000001000: n282_o = n179_o;
      11'b00000000100: n282_o = n179_o;
      11'b00000000010: n282_o = n179_o;
      11'b00000000001: n282_o = n222_o;
      default: n282_o = n179_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n283_o = n180_o;
      11'b01000000000: n283_o = n180_o;
      11'b00100000000: n283_o = n180_o;
      11'b00010000000: n283_o = n180_o;
      11'b00001000000: n283_o = n180_o;
      11'b00000100000: n283_o = n180_o;
      11'b00000010000: n283_o = n180_o;
      11'b00000001000: n283_o = n180_o;
      11'b00000000100: n283_o = n180_o;
      11'b00000000010: n283_o = n228_o;
      11'b00000000001: n283_o = n180_o;
      default: n283_o = n180_o;
    endcase
  /* ./vdp.vhd:487:57  */
  always @*
    case (n261_o)
      11'b10000000000: n284_o = n181_o;
      11'b01000000000: n284_o = n181_o;
      11'b00100000000: n284_o = n181_o;
      11'b00010000000: n284_o = n181_o;
      11'b00001000000: n284_o = n181_o;
      11'b00000100000: n284_o = n181_o;
      11'b00000010000: n284_o = n181_o;
      11'b00000001000: n284_o = n181_o;
      11'b00000000100: n284_o = n181_o;
      11'b00000000010: n284_o = n181_o;
      11'b00000000001: n284_o = n221_o;
      default: n284_o = n181_o;
    endcase
  /* ./vdp.vhd:479:49  */
  assign n285_o = n203_o ? n149_o : n207_o;
  assign n286_o = ss_regs_in[77:70];
  assign n287_o = xram_cpu_a[7:0];
  /* ./vdp.vhd:405:25  */
  assign n288_o = ss_regs_set ? n286_o : n287_o;
  /* ./vdp.vhd:479:49  */
  assign n289_o = n203_o ? D_in : n288_o;
  assign n290_o = ss_regs_in[83:78];
  assign n291_o = xram_cpu_a[13:8];
  /* ./vdp.vhd:405:25  */
  assign n292_o = ss_regs_set ? n290_o : n291_o;
  /* ./vdp.vhd:479:49  */
  assign n293_o = n203_o ? n292_o : n204_o;
  /* ./vdp.vhd:479:49  */
  assign n294_o = n203_o ? n155_o : n212_o;
  /* ./vdp.vhd:479:49  */
  assign n295_o = n203_o ? n156_o : n262_o;
  /* ./vdp.vhd:479:49  */
  assign n296_o = n203_o ? n157_o : n263_o;
  /* ./vdp.vhd:479:49  */
  assign n297_o = n203_o ? n158_o : n264_o;
  /* ./vdp.vhd:479:49  */
  assign n298_o = n203_o ? n159_o : n265_o;
  /* ./vdp.vhd:479:49  */
  assign n299_o = n203_o ? n160_o : n266_o;
  /* ./vdp.vhd:479:49  */
  assign n300_o = n203_o ? n161_o : n267_o;
  /* ./vdp.vhd:479:49  */
  assign n301_o = n203_o ? n162_o : n268_o;
  /* ./vdp.vhd:479:49  */
  assign n302_o = n203_o ? n163_o : n269_o;
  /* ./vdp.vhd:479:49  */
  assign n303_o = n203_o ? n164_o : n270_o;
  /* ./vdp.vhd:479:49  */
  assign n304_o = n203_o ? n165_o : n271_o;
  /* ./vdp.vhd:479:49  */
  assign n305_o = n203_o ? n166_o : n272_o;
  /* ./vdp.vhd:479:49  */
  assign n306_o = n203_o ? n167_o : n273_o;
  /* ./vdp.vhd:479:49  */
  assign n307_o = n203_o ? n168_o : n274_o;
  /* ./vdp.vhd:479:49  */
  assign n308_o = n203_o ? n169_o : n275_o;
  /* ./vdp.vhd:479:49  */
  assign n309_o = n203_o ? n170_o : n276_o;
  /* ./vdp.vhd:479:49  */
  assign n310_o = n203_o ? n171_o : n277_o;
  /* ./vdp.vhd:479:49  */
  assign n311_o = n203_o ? n172_o : n278_o;
  /* ./vdp.vhd:479:49  */
  assign n312_o = n203_o ? n173_o : n279_o;
  /* ./vdp.vhd:479:49  */
  assign n313_o = n203_o ? n174_o : n280_o;
  /* ./vdp.vhd:479:49  */
  assign n314_o = n203_o ? n178_o : n281_o;
  /* ./vdp.vhd:479:49  */
  assign n315_o = n203_o ? n179_o : n282_o;
  /* ./vdp.vhd:479:49  */
  assign n316_o = n203_o ? n180_o : n283_o;
  /* ./vdp.vhd:479:49  */
  assign n317_o = n203_o ? n181_o : n284_o;
  /* ./vdp.vhd:525:63  */
  assign n318_o = ~address_ff;
  /* ./vdp.vhd:468:33  */
  assign n320_o = n424_o ? 1'b1 : n193_o;
  /* ./vdp.vhd:469:41  */
  assign n322_o = n198_o ? 1'b0 : n318_o;
  /* ./vdp.vhd:469:41  */
  assign n323_o = n198_o ? n149_o : n285_o;
  assign n324_o = {n293_o, n289_o};
  /* ./vdp.vhd:469:41  */
  assign n325_o = n198_o ? n150_o : n324_o;
  /* ./vdp.vhd:469:41  */
  assign n326_o = n198_o ? D_in : n151_o;
  /* ./vdp.vhd:468:33  */
  assign n327_o = n429_o ? D_in : n194_o;
  /* ./vdp.vhd:469:41  */
  assign n329_o = n198_o ? 1'b1 : n154_o;
  /* ./vdp.vhd:469:41  */
  assign n330_o = n198_o ? n155_o : n294_o;
  /* ./vdp.vhd:469:41  */
  assign n331_o = n198_o ? n156_o : n295_o;
  /* ./vdp.vhd:469:41  */
  assign n332_o = n198_o ? n157_o : n296_o;
  /* ./vdp.vhd:469:41  */
  assign n333_o = n198_o ? n158_o : n297_o;
  /* ./vdp.vhd:469:41  */
  assign n334_o = n198_o ? n159_o : n298_o;
  /* ./vdp.vhd:469:41  */
  assign n335_o = n198_o ? n160_o : n299_o;
  /* ./vdp.vhd:469:41  */
  assign n336_o = n198_o ? n161_o : n300_o;
  /* ./vdp.vhd:469:41  */
  assign n337_o = n198_o ? n162_o : n301_o;
  /* ./vdp.vhd:469:41  */
  assign n338_o = n198_o ? n163_o : n302_o;
  /* ./vdp.vhd:469:41  */
  assign n339_o = n198_o ? n164_o : n303_o;
  /* ./vdp.vhd:469:41  */
  assign n340_o = n198_o ? n165_o : n304_o;
  /* ./vdp.vhd:469:41  */
  assign n341_o = n198_o ? n166_o : n305_o;
  /* ./vdp.vhd:469:41  */
  assign n342_o = n198_o ? n167_o : n306_o;
  /* ./vdp.vhd:469:41  */
  assign n343_o = n198_o ? n168_o : n307_o;
  /* ./vdp.vhd:469:41  */
  assign n344_o = n198_o ? n169_o : n308_o;
  /* ./vdp.vhd:469:41  */
  assign n345_o = n198_o ? n170_o : n309_o;
  /* ./vdp.vhd:469:41  */
  assign n346_o = n198_o ? n171_o : n310_o;
  /* ./vdp.vhd:469:41  */
  assign n347_o = n198_o ? n172_o : n311_o;
  /* ./vdp.vhd:469:41  */
  assign n348_o = n198_o ? n173_o : n312_o;
  /* ./vdp.vhd:469:41  */
  assign n349_o = n198_o ? n174_o : n313_o;
  /* ./vdp.vhd:469:41  */
  assign n350_o = n201_o & n198_o;
  /* ./vdp.vhd:469:41  */
  assign n351_o = n198_o ? n178_o : n314_o;
  /* ./vdp.vhd:469:41  */
  assign n352_o = n198_o ? n179_o : n315_o;
  /* ./vdp.vhd:469:41  */
  assign n353_o = n198_o ? n180_o : n316_o;
  /* ./vdp.vhd:469:41  */
  assign n354_o = n198_o ? n181_o : n317_o;
  /* ./vdp.vhd:528:62  */
  assign n355_o = ~RD_n;
  /* ./vdp.vhd:528:54  */
  assign n356_o = n355_o & old_rd_n;
  /* ./vdp.vhd:529:47  */
  assign n357_o = A[7:6];
  /* ./vdp.vhd:529:61  */
  assign n358_o = A[0];
  /* ./vdp.vhd:529:59  */
  assign n359_o = {n357_o, n358_o};
  /* ./vdp.vhd:530:41  */
  assign n361_o = n359_o == 3'b010;
  /* ./vdp.vhd:532:41  */
  assign n363_o = n359_o == 3'b011;
  /* ./vdp.vhd:534:41  */
  assign n365_o = n359_o == 3'b100;
  /* ./vdp.vhd:540:41  */
  assign n368_o = n359_o == 3'b101;
  assign n369_o = {n368_o, n365_o, n363_o, n361_o};
  assign n370_o = vcounter_cpu[4:0];
  assign n371_o = latched_x[4:0];
  assign n372_o = vram_cpu_d_outl[4:0];
  assign n373_o = n895_q[4:0];
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n374_o = 5'b11111;
      4'b0100: n374_o = n372_o;
      4'b0010: n374_o = n371_o;
      4'b0001: n374_o = n370_o;
      default: n374_o = n373_o;
    endcase
  assign n375_o = vcounter_cpu[5];
  assign n376_o = latched_x[5];
  assign n377_o = vram_cpu_d_outl[5];
  assign n378_o = n895_q[5];
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n379_o = collide_flag;
      4'b0100: n379_o = n377_o;
      4'b0010: n379_o = n376_o;
      4'b0001: n379_o = n375_o;
      default: n379_o = n378_o;
    endcase
  assign n380_o = vcounter_cpu[6];
  assign n381_o = latched_x[6];
  assign n382_o = vram_cpu_d_outl[6];
  assign n383_o = n895_q[6];
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n384_o = overflow_flag;
      4'b0100: n384_o = n382_o;
      4'b0010: n384_o = n381_o;
      4'b0001: n384_o = n380_o;
      default: n384_o = n383_o;
    endcase
  assign n385_o = vcounter_cpu[7];
  assign n386_o = latched_x[7];
  assign n387_o = vram_cpu_d_outl[7];
  assign n388_o = n895_q[7];
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n389_o = vbl_irq;
      4'b0100: n389_o = n387_o;
      4'b0010: n389_o = n386_o;
      4'b0001: n389_o = n385_o;
      default: n389_o = n388_o;
    endcase
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n392_o = 1'b0;
      4'b0100: n392_o = 1'b0;
      4'b0010: n392_o = n148_o;
      4'b0001: n392_o = n148_o;
      default: n392_o = n148_o;
    endcase
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n394_o = n154_o;
      4'b0100: n394_o = 1'b1;
      4'b0010: n394_o = n154_o;
      4'b0001: n394_o = n154_o;
      default: n394_o = n154_o;
    endcase
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n396_o = n155_o;
      4'b0100: n396_o = 1'b1;
      4'b0010: n396_o = n155_o;
      4'b0001: n396_o = n155_o;
      default: n396_o = n155_o;
    endcase
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n398_o = 1'b1;
      4'b0100: n398_o = n176_o;
      4'b0010: n398_o = n176_o;
      4'b0001: n398_o = n176_o;
      default: n398_o = n176_o;
    endcase
  /* ./vdp.vhd:529:41  */
  always @*
    case (n369_o)
      4'b1000: n401_o = 1'b1;
      4'b0100: n401_o = 1'b0;
      4'b0010: n401_o = 1'b0;
      4'b0001: n401_o = 1'b0;
      default: n401_o = 1'b0;
    endcase
  /* ./vdp.vhd:551:66  */
  assign n403_o = xram_cpu_a + 14'b00000000000001;
  /* ./vdp.vhd:550:33  */
  assign n404_o = n408_o ? vram_cpu_d_out : n151_o;
  /* ./vdp.vhd:557:33  */
  assign n406_o = xram_cpu_read ? 1'b1 : n154_o;
  /* ./vdp.vhd:550:33  */
  assign n407_o = xram_cpu_a_incr ? n403_o : n150_o;
  /* ./vdp.vhd:550:33  */
  assign n408_o = xram_cpu_read & xram_cpu_a_incr;
  /* ./vdp.vhd:550:33  */
  assign n410_o = xram_cpu_a_incr ? 1'b0 : n406_o;
  /* ./vdp.vhd:550:33  */
  assign n412_o = xram_cpu_a_incr ? 1'b0 : n155_o;
  assign n413_o = {n389_o, n384_o, n379_o, n374_o};
  /* ./vdp.vhd:528:33  */
  assign n414_o = n356_o ? n413_o : n895_q;
  /* ./vdp.vhd:528:33  */
  assign n415_o = n356_o ? n392_o : n148_o;
  /* ./vdp.vhd:528:33  */
  assign n416_o = n356_o ? n150_o : n407_o;
  /* ./vdp.vhd:528:33  */
  assign n417_o = n356_o ? n151_o : n404_o;
  /* ./vdp.vhd:528:33  */
  assign n418_o = n356_o ? n394_o : n410_o;
  /* ./vdp.vhd:528:33  */
  assign n419_o = n356_o ? n396_o : n412_o;
  /* ./vdp.vhd:528:33  */
  assign n420_o = n356_o ? n398_o : n176_o;
  /* ./vdp.vhd:528:33  */
  assign n422_o = n356_o ? n401_o : 1'b0;
  /* ./vdp.vhd:468:33  */
  assign n423_o = n196_o ? n895_q : n414_o;
  /* ./vdp.vhd:468:33  */
  assign n424_o = n198_o & n196_o;
  /* ./vdp.vhd:468:33  */
  assign n425_o = n196_o ? n322_o : n415_o;
  /* ./vdp.vhd:458:25  */
  assign n426_o = n470_o ? n323_o : n149_o;
  /* ./vdp.vhd:468:33  */
  assign n427_o = n196_o ? n325_o : n416_o;
  /* ./vdp.vhd:468:33  */
  assign n428_o = n196_o ? n326_o : n417_o;
  /* ./vdp.vhd:468:33  */
  assign n429_o = n198_o & n196_o;
  /* ./vdp.vhd:468:33  */
  assign n430_o = n196_o ? n329_o : n418_o;
  /* ./vdp.vhd:468:33  */
  assign n431_o = n196_o ? n330_o : n419_o;
  /* ./vdp.vhd:458:25  */
  assign n432_o = n476_o ? n331_o : n156_o;
  /* ./vdp.vhd:458:25  */
  assign n433_o = n477_o ? n332_o : n157_o;
  /* ./vdp.vhd:458:25  */
  assign n434_o = n478_o ? n333_o : n158_o;
  /* ./vdp.vhd:458:25  */
  assign n435_o = n479_o ? n334_o : n159_o;
  /* ./vdp.vhd:458:25  */
  assign n436_o = n480_o ? n335_o : n160_o;
  /* ./vdp.vhd:458:25  */
  assign n437_o = n481_o ? n336_o : n161_o;
  /* ./vdp.vhd:458:25  */
  assign n438_o = n482_o ? n337_o : n162_o;
  /* ./vdp.vhd:458:25  */
  assign n439_o = n483_o ? n338_o : n163_o;
  /* ./vdp.vhd:458:25  */
  assign n440_o = n484_o ? n339_o : n164_o;
  /* ./vdp.vhd:458:25  */
  assign n441_o = n485_o ? n340_o : n165_o;
  /* ./vdp.vhd:458:25  */
  assign n442_o = n486_o ? n341_o : n166_o;
  /* ./vdp.vhd:458:25  */
  assign n443_o = n487_o ? n342_o : n167_o;
  /* ./vdp.vhd:458:25  */
  assign n444_o = n488_o ? n343_o : n168_o;
  /* ./vdp.vhd:458:25  */
  assign n445_o = n489_o ? n344_o : n169_o;
  /* ./vdp.vhd:458:25  */
  assign n446_o = n490_o ? n345_o : n170_o;
  /* ./vdp.vhd:458:25  */
  assign n447_o = n491_o ? n346_o : n171_o;
  /* ./vdp.vhd:458:25  */
  assign n448_o = n492_o ? n347_o : n172_o;
  /* ./vdp.vhd:458:25  */
  assign n449_o = n493_o ? n348_o : n173_o;
  /* ./vdp.vhd:458:25  */
  assign n450_o = n494_o ? n349_o : n174_o;
  /* ./vdp.vhd:468:33  */
  assign n451_o = n196_o ? n176_o : n420_o;
  /* ./vdp.vhd:468:33  */
  assign n452_o = n350_o & n196_o;
  /* ./vdp.vhd:458:25  */
  assign n453_o = n497_o ? n351_o : n178_o;
  /* ./vdp.vhd:458:25  */
  assign n454_o = n498_o ? n352_o : n179_o;
  /* ./vdp.vhd:458:25  */
  assign n455_o = n499_o ? n353_o : n180_o;
  /* ./vdp.vhd:458:25  */
  assign n456_o = n500_o ? n354_o : n181_o;
  /* ./vdp.vhd:468:33  */
  assign n458_o = n196_o ? 1'b0 : n422_o;
  /* ./vdp.vhd:560:37  */
  assign n459_o = ~n458_o;
  /* ./vdp.vhd:560:33  */
  assign n461_o = n459_o ? 1'b0 : n451_o;
  /* ./vdp.vhd:458:25  */
  assign n463_o = n188_o ? RD_n : n144_o;
  /* ./vdp.vhd:458:25  */
  assign n464_o = n188_o ? WR_n : n145_o;
  /* ./vdp.vhd:458:25  */
  assign n465_o = n188_o ? WR_direct : n147_o;
  /* ./vdp.vhd:458:25  */
  assign n467_o = n188_o ? n320_o : 1'b0;
  /* ./vdp.vhd:458:25  */
  assign n469_o = n188_o ? n425_o : n148_o;
  /* ./vdp.vhd:458:25  */
  assign n470_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n471_o = n188_o ? n427_o : n150_o;
  /* ./vdp.vhd:458:25  */
  assign n472_o = n188_o ? n428_o : n151_o;
  /* ./vdp.vhd:458:25  */
  assign n473_o = n188_o ? n327_o : n152_o;
  /* ./vdp.vhd:458:25  */
  assign n474_o = n188_o ? n430_o : n154_o;
  /* ./vdp.vhd:458:25  */
  assign n475_o = n188_o ? n431_o : n155_o;
  /* ./vdp.vhd:458:25  */
  assign n476_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n477_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n478_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n479_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n480_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n481_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n482_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n483_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n484_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n485_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n486_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n487_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n488_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n489_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n490_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n491_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n492_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n493_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n494_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n495_o = n188_o ? n461_o : n176_o;
  /* ./vdp.vhd:458:25  */
  assign n496_o = n452_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n497_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n498_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n499_o = n196_o & n188_o;
  /* ./vdp.vhd:458:25  */
  assign n500_o = n196_o & n188_o;
  /* ./vdp.vhd:572:54  */
  assign n620_o = ss_regs_in[115];
  /* ./vdp.vhd:575:42  */
  assign n622_o = x == 9'b111100101;
  /* ./vdp.vhd:575:54  */
  assign n624_o = y == 9'b011100000;
  /* ./vdp.vhd:575:59  */
  assign n625_o = xmode_m1 & n624_o;
  /* ./vdp.vhd:576:48  */
  assign n627_o = y == 9'b011110000;
  /* ./vdp.vhd:576:53  */
  assign n628_o = xmode_m3 & n627_o;
  /* ./vdp.vhd:576:43  */
  assign n629_o = n625_o | n628_o;
  /* ./vdp.vhd:577:48  */
  assign n631_o = y == 9'b011000000;
  /* ./vdp.vhd:577:65  */
  assign n632_o = ~xmode_m1;
  /* ./vdp.vhd:577:53  */
  assign n633_o = n632_o & n631_o;
  /* ./vdp.vhd:577:82  */
  assign n634_o = ~xmode_m3;
  /* ./vdp.vhd:577:70  */
  assign n635_o = n634_o & n633_o;
  /* ./vdp.vhd:577:43  */
  assign n636_o = n629_o | n635_o;
  /* ./vdp.vhd:575:47  */
  assign n637_o = n636_o & n622_o;
  /* ./vdp.vhd:578:69  */
  assign n638_o = x[0];
  /* ./vdp.vhd:578:57  */
  assign n639_o = last_x0 == n638_o;
  /* ./vdp.vhd:578:45  */
  assign n640_o = ~n639_o;
  /* ./vdp.vhd:578:41  */
  assign n641_o = n640_o & n637_o;
  /* ./vdp.vhd:580:33  */
  assign n643_o = reset_flags ? 1'b0 : vbl_irq;
  /* ./vdp.vhd:575:33  */
  assign n645_o = n641_o ? 1'b1 : n643_o;
  /* ./vdp.vhd:573:25  */
  assign n646_o = ce_vdp ? n645_o : vbl_irq;
  /* ./vdp.vhd:570:25  */
  assign n647_o = ss_regs_set ? n620_o : n646_o;
  /* ./vdp.vhd:591:55  */
  assign n653_o = x[0];
  /* ./vdp.vhd:593:58  */
  assign n654_o = ss_regs_in[111:104];
  /* ./vdp.vhd:594:54  */
  assign n655_o = ss_regs_in[116];
  /* ./vdp.vhd:596:55  */
  assign n656_o = x[0];
  /* ./vdp.vhd:597:37  */
  assign n658_o = x == 9'b111100110;
  /* ./vdp.vhd:597:70  */
  assign n659_o = x[0];
  /* ./vdp.vhd:597:58  */
  assign n660_o = last_x0 == n659_o;
  /* ./vdp.vhd:597:46  */
  assign n661_o = ~n660_o;
  /* ./vdp.vhd:597:42  */
  assign n662_o = n661_o & n658_o;
  /* ./vdp.vhd:598:45  */
  assign n664_o = $unsigned(y) < $unsigned(9'b011000000);
  /* ./vdp.vhd:598:55  */
  assign n666_o = $unsigned(y) < $unsigned(9'b011110000);
  /* ./vdp.vhd:598:60  */
  assign n667_o = xmode_m3 & n666_o;
  /* ./vdp.vhd:598:50  */
  assign n668_o = n664_o | n667_o;
  /* ./vdp.vhd:598:83  */
  assign n670_o = $unsigned(y) < $unsigned(9'b011100000);
  /* ./vdp.vhd:598:88  */
  assign n671_o = xmode_m1 & n670_o;
  /* ./vdp.vhd:598:78  */
  assign n672_o = n668_o | n671_o;
  /* ./vdp.vhd:598:110  */
  assign n674_o = y == 9'b111111111;
  /* ./vdp.vhd:598:106  */
  assign n675_o = n672_o | n674_o;
  /* ./vdp.vhd:599:63  */
  assign n677_o = hbl_counter == 8'b00000000;
  /* ./vdp.vhd:600:76  */
  assign n678_o = hbl_irq | irq_line_en;
  /* ./vdp.vhd:603:83  */
  assign n680_o = hbl_counter - 8'b00000001;
  /* ./vdp.vhd:599:49  */
  assign n681_o = n677_o ? irq_line_count : n680_o;
  /* ./vdp.vhd:598:41  */
  assign n682_o = n684_o ? n678_o : hbl_irq;
  /* ./vdp.vhd:598:41  */
  assign n683_o = n675_o ? n681_o : irq_line_count;
  /* ./vdp.vhd:598:41  */
  assign n684_o = n677_o & n675_o;
  /* ./vdp.vhd:608:33  */
  assign n686_o = reset_flags ? 1'b0 : hbl_irq;
  /* ./vdp.vhd:595:25  */
  assign n687_o = n690_o ? n683_o : hbl_counter;
  /* ./vdp.vhd:597:33  */
  assign n688_o = n662_o ? n682_o : n686_o;
  /* ./vdp.vhd:595:25  */
  assign n689_o = ce_vdp ? n656_o : last_x0;
  /* ./vdp.vhd:595:25  */
  assign n690_o = n662_o & ce_vdp;
  /* ./vdp.vhd:595:25  */
  assign n691_o = ce_vdp ? n688_o : hbl_irq;
  /* ./vdp.vhd:590:25  */
  assign n692_o = ss_regs_set ? n653_o : n689_o;
  /* ./vdp.vhd:590:25  */
  assign n693_o = ss_regs_set ? n654_o : n687_o;
  /* ./vdp.vhd:590:25  */
  assign n694_o = ss_regs_set ? n655_o : n691_o;
  /* ./vdp.vhd:619:60  */
  assign n702_o = ss_regs_in[114:112];
  /* ./vdp.vhd:620:60  */
  assign n703_o = ss_regs_in[117];
  /* ./vdp.vhd:621:60  */
  assign n704_o = ss_regs_in[118];
  /* ./vdp.vhd:622:60  */
  assign n705_o = ss_regs_in[119];
  /* ./vdp.vhd:625:48  */
  assign n706_o = ss_regs_in[115];
  /* ./vdp.vhd:625:74  */
  assign n707_o = ss_regs_in[8];
  /* ./vdp.vhd:625:60  */
  assign n708_o = n707_o & n706_o;
  /* ./vdp.vhd:626:48  */
  assign n709_o = ss_regs_in[116];
  /* ./vdp.vhd:626:74  */
  assign n710_o = ss_regs_in[3];
  /* ./vdp.vhd:626:60  */
  assign n711_o = n710_o & n709_o;
  /* ./vdp.vhd:626:102  */
  assign n712_o = ~mask_line_irq;
  /* ./vdp.vhd:626:84  */
  assign n713_o = n712_o & n711_o;
  /* ./vdp.vhd:625:85  */
  assign n714_o = n708_o | n713_o;
  /* ./vdp.vhd:627:54  */
  assign n715_o = ss_regs_in[114:112];
  /* ./vdp.vhd:627:71  */
  assign n717_o = n715_o == 3'b000;
  /* ./vdp.vhd:627:41  */
  assign n720_o = n717_o ? 1'b0 : 1'b1;
  /* ./vdp.vhd:625:33  */
  assign n722_o = n714_o ? n720_o : 1'b1;
  /* ./vdp.vhd:638:43  */
  assign n723_o = ~ce_vdp;
  /* ./vdp.vhd:639:46  */
  assign n725_o = $unsigned(x) < $unsigned(9'b100000000);
  /* ./vdp.vhd:639:55  */
  assign n727_o = $unsigned(x) > $unsigned(9'b111100101);
  /* ./vdp.vhd:639:51  */
  assign n728_o = n725_o | n727_o;
  /* ./vdp.vhd:639:67  */
  assign n730_o = $unsigned(y) < $unsigned(9'b011101010);
  /* ./vdp.vhd:639:76  */
  assign n732_o = $unsigned(y) >= $unsigned(9'b111110000);
  /* ./vdp.vhd:639:72  */
  assign n733_o = n730_o | n732_o;
  /* ./vdp.vhd:639:61  */
  assign n734_o = n733_o & n728_o;
  /* ./vdp.vhd:640:86  */
  assign n735_o = ~line_overflow;
  /* ./vdp.vhd:640:69  */
  assign n736_o = n735_o & spr_overflow;
  /* ./vdp.vhd:638:33  */
  assign n738_o = n744_o ? 1'b1 : overflow_flag;
  /* ./vdp.vhd:640:49  */
  assign n740_o = n736_o ? 1'b1 : line_overflow;
  /* ./vdp.vhd:639:41  */
  assign n741_o = n736_o & n734_o;
  /* ./vdp.vhd:639:41  */
  assign n743_o = n734_o ? n740_o : 1'b0;
  /* ./vdp.vhd:638:33  */
  assign n744_o = n741_o & n723_o;
  /* ./vdp.vhd:638:33  */
  assign n745_o = n723_o ? n743_o : line_overflow;
  /* ./vdp.vhd:650:94  */
  assign n746_o = xspr_collide_shift[12:0];
  /* ./vdp.vhd:651:46  */
  assign n748_o = $unsigned(x) <= $unsigned(9'b100000000);
  /* ./vdp.vhd:651:41  */
  assign n750_o = n748_o ? spr_collide : 1'b0;
  /* ./vdp.vhd:656:62  */
  assign n751_o = xspr_collide_shift[13];
  /* ./vdp.vhd:656:71  */
  assign n752_o = display_on & n751_o;
  /* ./vdp.vhd:658:51  */
  assign n754_o = $unsigned(y) < $unsigned(9'b011101010);
  /* ./vdp.vhd:658:68  */
  assign n755_o = ~xmode_m1;
  /* ./vdp.vhd:658:85  */
  assign n756_o = ~xmode_m3;
  /* ./vdp.vhd:658:73  */
  assign n757_o = n756_o & n755_o;
  /* ./vdp.vhd:658:95  */
  assign n759_o = $unsigned(y) >= $unsigned(9'b111110000);
  /* ./vdp.vhd:658:90  */
  assign n760_o = n759_o & n757_o;
  /* ./vdp.vhd:658:56  */
  assign n761_o = n754_o | n760_o;
  /* ./vdp.vhd:657:64  */
  assign n762_o = n761_o & n752_o;
  /* ./vdp.vhd:656:41  */
  assign n764_o = n762_o ? 1'b1 : collide_flag;
  /* ./vdp.vhd:663:41  */
  assign n766_o = reset_flags ? 1'b0 : n764_o;
  /* ./vdp.vhd:649:33  */
  assign n768_o = n794_o ? 1'b0 : n738_o;
  /* ./vdp.vhd:649:33  */
  assign n770_o = n795_o ? 1'b1 : n745_o;
  /* ./vdp.vhd:669:58  */
  assign n771_o = irq_frame_en & vbl_irq;
  /* ./vdp.vhd:670:58  */
  assign n772_o = irq_line_en & hbl_irq;
  /* ./vdp.vhd:670:95  */
  assign n773_o = ~mask_line_irq;
  /* ./vdp.vhd:670:78  */
  assign n774_o = n773_o & n772_o;
  /* ./vdp.vhd:669:80  */
  assign n775_o = n771_o | n774_o;
  /* ./vdp.vhd:671:53  */
  assign n776_o = ~reset_flags;
  /* ./vdp.vhd:671:49  */
  assign n777_o = n776_o & n775_o;
  /* ./vdp.vhd:672:62  */
  assign n779_o = irq_delay == 3'b000;
  /* ./vdp.vhd:675:80  */
  assign n781_o = irq_delay - 3'b001;
  /* ./vdp.vhd:672:49  */
  assign n783_o = n779_o ? 1'b0 : n891_q;
  /* ./vdp.vhd:672:49  */
  assign n784_o = n779_o ? irq_delay : n781_o;
  /* ./vdp.vhd:669:41  */
  assign n786_o = n777_o ? n783_o : 1'b1;
  /* ./vdp.vhd:669:41  */
  assign n788_o = n777_o ? n784_o : 3'b111;
  /* ./vdp.vhd:649:33  */
  assign n789_o = ce_vdp ? n786_o : n891_q;
  /* ./vdp.vhd:649:33  */
  assign n790_o = ce_vdp ? n788_o : irq_delay;
  /* ./vdp.vhd:649:33  */
  assign n791_o = ce_vdp ? n766_o : collide_flag;
  assign n792_o = {n746_o, n750_o};
  /* ./vdp.vhd:649:33  */
  assign n793_o = ce_vdp ? n792_o : xspr_collide_shift;
  /* ./vdp.vhd:649:33  */
  assign n794_o = reset_flags & ce_vdp;
  /* ./vdp.vhd:649:33  */
  assign n795_o = reset_flags & ce_vdp;
  /* ./vdp.vhd:618:25  */
  assign n796_o = ss_regs_set ? n722_o : n789_o;
  /* ./vdp.vhd:618:25  */
  assign n797_o = ss_regs_set ? n702_o : n790_o;
  /* ./vdp.vhd:618:25  */
  assign n798_o = ss_regs_set ? n703_o : n791_o;
  /* ./vdp.vhd:618:25  */
  assign n800_o = ss_regs_set ? 14'b00000000000000 : n793_o;
  /* ./vdp.vhd:618:25  */
  assign n801_o = ss_regs_set ? n704_o : n768_o;
  /* ./vdp.vhd:618:25  */
  assign n802_o = ss_regs_set ? n705_o : n770_o;
  /* ./vdp.vhd:692:36  */
  assign n813_o = ~reset_n;
  /* ./vdp.vhd:696:66  */
  assign n814_o = ss_regs_in[127:120];
  /* ./vdp.vhd:698:38  */
  assign n816_o = x == 9'b111100111;
  /* ./vdp.vhd:697:25  */
  assign n817_o = n818_o ? bg_scroll_x : bg_scroll_x_latched;
  /* ./vdp.vhd:697:25  */
  assign n818_o = n816_o & ce_pix;
  /* ./vdp.vhd:694:25  */
  assign n819_o = ss_regs_set ? n814_o : n817_o;
  /* ./vdp.vhd:692:25  */
  assign n821_o = n813_o ? 8'b00000000 : n819_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n824_q <= 1'b1;
    else
      n824_q <= n463_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n825_q <= 1'b1;
    else
      n825_q <= n464_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n826_q <= 1'b0;
    else
      n826_q <= HL;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n827_q <= 1'b0;
    else
      n827_q <= n465_o;
  /* ./vdp.vhd:366:9  */
  assign n828_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n829_o = n828_o ? n467_o : data_write;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n830_q <= n829_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n831_q <= 1'b0;
    else
      n831_q <= n469_o;
  /* ./vdp.vhd:366:9  */
  assign n832_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n833_o = n832_o ? n426_o : to_cram;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n834_q <= n833_o;
  initial
    n834_q = 1'b0;
  /* ./vdp.vhd:366:9  */
  assign n835_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n836_o = n835_o ? n471_o : xram_cpu_a;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n837_q <= n836_o;
  /* ./vdp.vhd:366:9  */
  assign n838_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n839_o = n838_o ? n472_o : vram_cpu_d_outl;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n840_q <= n839_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n841_q <= 8'b00000000;
    else
      n841_q <= n473_o;
  /* ./vdp.vhd:366:9  */
  assign n842_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n843_o = n842_o ? n474_o : xram_cpu_a_incr;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n844_q <= n843_o;
  initial
    n844_q = 1'b0;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n845_q <= 1'b0;
    else
      n845_q <= n475_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n846_q <= 1'b0;
    else
      n846_q <= n432_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n847_q <= 1'b0;
    else
      n847_q <= n433_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n848_q <= 1'b0;
    else
      n848_q <= n434_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n849_q <= 1'b1;
    else
      n849_q <= n435_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n850_q <= 4'b0000;
    else
      n850_q <= n436_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n851_q <= 1'b0;
    else
      n851_q <= n437_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n852_q <= 1'b1;
    else
      n852_q <= n438_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n853_q <= 8'b11111111;
    else
      n853_q <= n439_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n854_q <= 4'b1110;
    else
      n854_q <= n440_o;
  /* ./vdp.vhd:366:9  */
  assign n855_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n856_o = n855_o ? n441_o : m2mg_address;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n857_q <= n856_o;
  initial
    n857_q = 3'b000;
  /* ./vdp.vhd:366:9  */
  assign n858_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n859_o = n858_o ? n442_o : m2ct_address;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n860_q <= n859_o;
  initial
    n860_q = 8'b11111111;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n861_q <= 8'b00000000;
    else
      n861_q <= n443_o;
  /* ./vdp.vhd:691:17  */
  always @(posedge clk_sys)
    n862_q <= n821_o;
  initial
    n862_q = 8'b00000000;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n863_q <= 8'b00000000;
    else
      n863_q <= n444_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n864_q <= 7'b1111111;
    else
      n864_q <= n445_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n865_q <= 1'b0;
    else
      n865_q <= n446_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n866_q <= 1'b0;
    else
      n866_q <= n447_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n867_q <= 1'b0;
    else
      n867_q <= n448_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n868_q <= 3'b000;
    else
      n868_q <= n449_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n869_q <= 4'b0000;
    else
      n869_q <= n450_o;
  /* ./vdp.vhd:589:17  */
  always @(posedge clk_sys)
    n870_q <= n692_o;
  initial
    n870_q = 1'b0;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n871_q <= 1'b1;
    else
      n871_q <= n495_o;
  /* ./vdp.vhd:617:17  */
  always @(posedge clk_sys)
    n872_q <= n797_o;
  initial
    n872_q = 3'b111;
  /* ./vdp.vhd:617:17  */
  always @(posedge clk_sys)
    n873_q <= n798_o;
  initial
    n873_q = 1'b0;
  /* ./vdp.vhd:617:17  */
  always @(posedge clk_sys)
    n874_q <= n800_o;
  initial
    n874_q = 14'b00000000000000;
  /* ./vdp.vhd:617:17  */
  always @(posedge clk_sys)
    n875_q <= n801_o;
  initial
    n875_q = 1'b0;
  /* ./vdp.vhd:617:17  */
  always @(posedge clk_sys)
    n876_q <= n802_o;
  initial
    n876_q = 1'b0;
  /* ./vdp.vhd:589:17  */
  always @(posedge clk_sys)
    n877_q <= n693_o;
  initial
    n877_q = 8'b00000000;
  /* ./vdp.vhd:569:17  */
  always @(posedge clk_sys)
    n878_q <= n647_o;
  /* ./vdp.vhd:589:17  */
  always @(posedge clk_sys)
    n879_q <= n694_o;
  /* ./vdp.vhd:366:9  */
  assign n880_o = ~n113_o;
  /* ./vdp.vhd:366:9  */
  assign n881_o = n183_o & n880_o;
  /* ./vdp.vhd:400:17  */
  assign n882_o = n881_o ? n184_o : latched_x;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n883_q <= n882_o;
  /* ./vdp.vhd:366:9  */
  assign n884_o = ~n113_o;
  /* ./vdp.vhd:400:17  */
  assign n885_o = n884_o ? n202_o : cram_latch;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n886_q <= n885_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n887_q <= 1'b0;
    else
      n887_q <= n453_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n888_q <= 1'b0;
    else
      n888_q <= n454_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n889_q <= 1'b0;
    else
      n889_q <= n455_o;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys or posedge n113_o)
    if (n113_o)
      n890_q <= 1'b1;
    else
      n890_q <= n456_o;
  /* ./vdp.vhd:617:17  */
  always @(posedge clk_sys)
    n891_q <= n796_o;
  /* ./vdp.vhd:366:9  */
  assign n892_o = ~n113_o;
  /* ./vdp.vhd:366:9  */
  assign n893_o = n188_o & n892_o;
  /* ./vdp.vhd:400:17  */
  assign n894_o = n893_o ? n423_o : n895_q;
  /* ./vdp.vhd:400:17  */
  always @(posedge clk_sys)
    n895_q <= n894_o;
  /* ./vdp.vhd:369:17  */
  assign n896_o = {bg_scroll_x_latched, line_overflow, overflow_flag, collide_flag, hbl_irq, vbl_irq, irq_delay, hbl_counter, n106_o, xram_cpu_read, cram_latch, vram_cpu_d_outl, n103_o, address_ff, xram_cpu_a, irq_line_count, overscan, legacy_fg_color, spr_high_bits, spr_address, bg_scroll_y, bg_scroll_x, m2ct_address, m2mg_address, bg_address, spr_wide, spr_tall, mode_m3, mode_m1, irq_frame_en, display_on, mode_m2, mode_m4, spr_shift, irq_line_en, mask_column0, disable_vscroll, disable_hscroll};
endmodule

