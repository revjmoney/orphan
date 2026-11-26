`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: the two BM1387 CRCs.
//   hr_crc16       CRC-16/CCITT-FALSE (poly 0x1021, init 0xFFFF), one byte per enable; the job packet's checksum
//                  (cgminer driver-gekko crc16_false; sent big-endian after the 52 packet bytes).
//   hr_crc5_check  reply check: CRC5 over the first 51 bits of a 7-byte frame, init 0x1F, bit-serial like bmminer's
//                  CRC5 and cgminer's bmcrc; ok when it equals the low 5 bits of byte 6.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.

module hr_crc16 (
    input  wire        clk,
    input  wire        init,          // one clock: crc <= 0xFFFF
    input  wire        en,            // one clock: fold in d
    input  wire [7:0]  d,
    output reg  [15:0] crc = 16'hFFFF
);
    function [15:0] step(input [15:0] c, input [7:0] b);
        integer i;
        reg [15:0] x;
        begin
            x = c ^ {b, 8'd0};
            for (i = 0; i < 8; i = i + 1) x = x[15] ? ({x[14:0], 1'b0} ^ 16'h1021) : {x[14:0], 1'b0};
            step = x;
        end
    endfunction
    always @(posedge clk) begin
        if (init) crc <= 16'hFFFF;
        else if (en) crc <= step(crc, d);
    end
endmodule

module hr_crc5_check (
    input  wire [55:0] frame,          // byte 0 in [55:48]
    output wire        ok
);
    function [4:0] crc5_51(input [55:0] f);
        integer i;
        reg [4:0] c;
        reg bit_, c1;
        begin
            c = 5'h1F;                                      // c[0] .. c[4] as in bmminer's CRC5
            for (i = 0; i < 51; i = i + 1) begin
                bit_ = f[55 - i];
                c1 = c[1];
                c[1] = c[0];
                c[0] = c[4] ^ bit_;
                c[4] = c[3];
                c[3] = c[2];
                c[2] = c1 ^ c[0];
            end
            crc5_51 = {c[4], c[3], c[2], c[1], c[0]};
        end
    endfunction
    assign ok = (crc5_51(frame) == frame[4:0]);
endmodule
