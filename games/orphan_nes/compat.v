// Modified for Orphan Games by JMSCNC (Rev. J. Money), 2026-11-22: builds with Yosys/nextpnr (no `include,
// standard number literals, always @* instead of always, own MUXCY/XORCY copies renamed nes_*, a wire declared
// before use, the PPU palette start values inline, a debug print removed). Original: github.com/strigeus/fpganes
// Copyright (c) 2012-2013 Ludvig Strigeus
// This program is GPL Licensed. See COPYING for the full license.
module nes_muxcy(output O, input CI, input DI, input S);
  assign O = S ? CI : DI;
endmodule
module nes_muxcy_l(output LO, input CI, input DI, input S);
  assign LO = S ? CI : DI;
endmodule
module nes_muxcy_d(output LO, output O, input CI, input DI, input S);
  assign LO = S ? CI : DI;
  assign O = LO;
endmodule
module nes_xorcy(output O, input CI, input LI);
  assign O = CI ^ LI;
endmodule
module nes_xor2(output O, input I0, input I1);
  assign O = I0 ^ I1;
endmodule