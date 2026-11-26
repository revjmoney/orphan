`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: one SHA-256 compression (512-bit block, 64 rounds, 2 clocks a round, 129 clocks).
// This core is Ardzy's 13_sha256 lab (by chryso, GPL-3.0, https://github.com/chrysovalantischryso/ardzy), copied
// from miners-work/orphan_btc/sha_miner.v with two changes: the module name (sha256_core -> hr_sha256, so it can
// never clash with another copy in the same design), and the block is shifted in one word a clock (win_we, win,
// W0 first) straight into the message schedule instead of arriving as a 512-bit port, which saves the caller a
// 512-bit block register (area: the S9 control board's xc7z010 is small). Used by hr_build.v. GPL-3.0-or-later.

module hr_sha256 (
    input  wire         clk,
    input  wire         start,          // one clock: take h_in; the 16 words shifted in before are the block
    input  wire [255:0] h_in,           // {H0, H1, ..., H7}  (H0 in the top bits)
    input  wire         win_we,         // while not busy: shift one block word in (W0 first, W15 last)
    input  wire [31:0]  win,
    output reg          busy = 1'b0,
    output reg          done = 1'b0,    // one clock when h_out is ready
    output reg  [255:0] h_out = 256'd0
);
    function [31:0] kc(input [5:0] t);
        case (t)
            6'd0: kc = 32'h428a2f98;
            6'd1: kc = 32'h71374491;
            6'd2: kc = 32'hb5c0fbcf;
            6'd3: kc = 32'he9b5dba5;
            6'd4: kc = 32'h3956c25b;
            6'd5: kc = 32'h59f111f1;
            6'd6: kc = 32'h923f82a4;
            6'd7: kc = 32'hab1c5ed5;
            6'd8: kc = 32'hd807aa98;
            6'd9: kc = 32'h12835b01;
            6'd10: kc = 32'h243185be;
            6'd11: kc = 32'h550c7dc3;
            6'd12: kc = 32'h72be5d74;
            6'd13: kc = 32'h80deb1fe;
            6'd14: kc = 32'h9bdc06a7;
            6'd15: kc = 32'hc19bf174;
            6'd16: kc = 32'he49b69c1;
            6'd17: kc = 32'hefbe4786;
            6'd18: kc = 32'h0fc19dc6;
            6'd19: kc = 32'h240ca1cc;
            6'd20: kc = 32'h2de92c6f;
            6'd21: kc = 32'h4a7484aa;
            6'd22: kc = 32'h5cb0a9dc;
            6'd23: kc = 32'h76f988da;
            6'd24: kc = 32'h983e5152;
            6'd25: kc = 32'ha831c66d;
            6'd26: kc = 32'hb00327c8;
            6'd27: kc = 32'hbf597fc7;
            6'd28: kc = 32'hc6e00bf3;
            6'd29: kc = 32'hd5a79147;
            6'd30: kc = 32'h06ca6351;
            6'd31: kc = 32'h14292967;
            6'd32: kc = 32'h27b70a85;
            6'd33: kc = 32'h2e1b2138;
            6'd34: kc = 32'h4d2c6dfc;
            6'd35: kc = 32'h53380d13;
            6'd36: kc = 32'h650a7354;
            6'd37: kc = 32'h766a0abb;
            6'd38: kc = 32'h81c2c92e;
            6'd39: kc = 32'h92722c85;
            6'd40: kc = 32'ha2bfe8a1;
            6'd41: kc = 32'ha81a664b;
            6'd42: kc = 32'hc24b8b70;
            6'd43: kc = 32'hc76c51a3;
            6'd44: kc = 32'hd192e819;
            6'd45: kc = 32'hd6990624;
            6'd46: kc = 32'hf40e3585;
            6'd47: kc = 32'h106aa070;
            6'd48: kc = 32'h19a4c116;
            6'd49: kc = 32'h1e376c08;
            6'd50: kc = 32'h2748774c;
            6'd51: kc = 32'h34b0bcb5;
            6'd52: kc = 32'h391c0cb3;
            6'd53: kc = 32'h4ed8aa4a;
            6'd54: kc = 32'h5b9cca4f;
            6'd55: kc = 32'h682e6ff3;
            6'd56: kc = 32'h748f82ee;
            6'd57: kc = 32'h78a5636f;
            6'd58: kc = 32'h84c87814;
            6'd59: kc = 32'h8cc70208;
            6'd60: kc = 32'h90befffa;
            6'd61: kc = 32'ha4506ceb;
            6'd62: kc = 32'hbef9a3f7;
            6'd63: kc = 32'hc67178f2;
        endcase
    endfunction
    function [31:0] rotr(input [31:0] x, input [4:0] n); rotr = (x >> n) | (x << (6'd32 - n)); endfunction

    reg [31:0] a, b, c, d, e, f, g, h;
    reg [31:0] hkw;                     // h + K[t] + W[t] for the round being done
    reg [31:0] kw;                      // K[t + 1] + W[t + 1], made in the first half
    reg [31:0] kn;                      // K[t + 1], looked up a round ahead (the table and the adder each get a clock)
    reg [31:0] t1r, t2r, wnr;           // the first half's results
    (* keep *) reg [511:0] wv = 512'd0;         // W[t] .. W[t + 15], W[t] in the top bits. keep: Yosys
                                        // maps this shift into SRL16Es that hash wrong (netlist sim, "abc")
    wire [31:0] w0 = wv[511:480], w1 = wv[479:448], w9 = wv[223:192], w14 = wv[63:32];
    reg [5:0]  t = 6'd0;
    reg        half = 1'b0;             // 0: first half of a round, 1: second half
    reg [255:0] h0 = 256'd0;
    integer i;

    // first half: T1 = (h + K[t] + W[t]) + S1(e) + Ch(e, f, g)     T2 = S0(a) + Maj(a, b, c)
    //             and W[t + 16] = s1(W[t + 14]) + W[t + 9] + s0(W[t + 1]) + W[t]
    wire [31:0] s1  = rotr(e, 5'd6) ^ rotr(e, 5'd11) ^ rotr(e, 5'd25);
    wire [31:0] ch  = (e & f) ^ (~e & g);
    wire [31:0] s0  = rotr(a, 5'd2) ^ rotr(a, 5'd13) ^ rotr(a, 5'd22);
    wire [31:0] maj = (a & b) ^ (a & c) ^ (b & c);
    wire [31:0] ws0 = rotr(w1, 5'd7) ^ rotr(w1, 5'd18) ^ (w1 >> 3);
    wire [31:0] ws1 = rotr(w14, 5'd17) ^ rotr(w14, 5'd19) ^ (w14 >> 10);

    always @(posedge clk) begin
        done <= 1'b0;
        if (start && !busy) begin
            busy <= 1'b1;
            t <= 6'd0;
            half <= 1'b0;
            h0 <= h_in;
            {a, b, c, d, e, f, g, h} <= h_in;
            hkw <= h_in[31:0] + kc(6'd0) + w0;
            kn <= kc(6'd1);
        end else if (win_we && !busy) begin
            wv <= {wv[479:0], win};
        end else if (busy && !half) begin
            t1r <= hkw + s1 + ch;
            t2r <= s0 + maj;
            wnr <= ws1 + w9 + ws0 + w0;
            kw  <= kn + w1;
            half <= 1'b1;
        end else if (busy) begin
            // second half: the new working variables
            h <= g; g <= f; f <= e; e <= d + t1r;
            d <= c; c <= b; b <= a; a <= t1r + t2r;
            wv <= {wv[479:0], wnr};
            hkw <= g + kw;                // the next round's h is today's g
            kn <= kc(t + 6'd2);           // K for the round after next
            half <= 1'b0;
            t <= t + 6'd1;
            if (t == 6'd63) begin
                busy <= 1'b0;
                done <= 1'b1;
                h_out <= {h0[255:224] + t1r + t2r, h0[223:192] + a, h0[191:160] + b, h0[159:128] + c,
                          h0[127:96] + d + t1r, h0[95:64] + e, h0[63:32] + f, h0[31:0] + g};
            end
        end
    end
endmodule
