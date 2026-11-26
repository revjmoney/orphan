`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR (HASHR): S9 hashboard tester core (slot 1). JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026]
// GPL-3.0-or-later.
//
// Gives Linux the 9 hashboard headers J1..J9: per header the EN/RST/SWAP control and gating of TX (pin 11) and RST
// (pin 15), and the raw level of every pin. Plus two byte-level I2C masters for the
// hashboard PICs (SCL1/SDA1 and SCL2/SDA2). Nothing is driven until GO, and a header drives TX/RST only when its EN bit
// is set; otherwise the pins float (the FPGA pull-ups keep them idle).
//
// Registers (word index inside the slot):
//   0 CTRL      [0] GO
//   1 PINS_LO   raw levels hdr[31:0]       2 PINS_HI  [3:0] hdr[35:32]
//   3 I2C1      4 I2C2  write: [7:0] data, [9:8] op (0 START+write, 1 write, 2 read+ACK, 3 read+NACK), [10] STOP after
//                       read:  [31] busy, [8] NACK seen on the last write, [7:0] last read byte
//   5 I2C_DIV   clocks per quarter SCL period (default 250 = 100 kHz at 100 MHz)
//   16+8h+0 HCTRL [0] EN drive, [1] RST level (0 = chips held in reset),
//                 [4] SWAP: transmit on pin 12 and receive on pin 11 (for boards that name TXD/RXD the other way)
//   The chain UARTs (TX, RX, baud) are in hr_disp (slot 2), which owns each line completely.
//   127 ID      "HSR1"
// Header pin order (same as SPEKTOR): hdr[4*h + k], k = 0 PLUG (pin 5), 1 TXD (pin 11), 2 RXD (pin 12), 3 RST (pin 15).
module hashr #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    input  wire [35:0] pin_in,
    output wire [35:0] pin_o,
    output wire [35:0] pin_oe,
    output wire        i2c1_scl_oe, output wire i2c1_sda_oe, input wire i2c1_scl_in, input wire i2c1_sda_in,
    output wire        i2c2_scl_oe, output wire i2c2_sda_oe, input wire i2c2_scl_in, input wire i2c2_sda_in,
    output wire        active,
    input  wire [8:0]  chain_tx,           // the chain TX lines from hr_disp (slot 2)
    output wire [8:0]  chain_rx            // the chain RX lines to hr_disp (SWAP applied)
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];
    wire wr = bus_we && sel;
    wire rd = bus_re && sel;

    reg go = 1'b0;
    reg [15:0] i2c_div = 16'd250;

    // input synchronizers for every pin
    reg [35:0] s1 = {36{1'b1}}, s2 = {36{1'b1}};
    always @(posedge clk) begin s1 <= pin_in; s2 <= s1; end

    // ---------------- per-header control (the chain UARTs live in hr_disp, slot 2) ----------------
    wire [8:0]  h_en, h_rst, h_swap;

    genvar h;
    generate for (h = 0; h < 9; h = h + 1) begin : hdr
        wire base = (idx == (10'd16 + 8*h));
        reg en = 1'b0, rstl = 1'b0, swap = 1'b0;
        always @(posedge clk) begin
            if (!rstn) begin en <= 1'b0; rstl <= 1'b0; swap <= 1'b0; end
            else if (wr && base) begin en <= bus_wdata[0]; rstl <= bus_wdata[1]; swap <= bus_wdata[4]; end
        end
        assign h_en[h] = en;
        assign h_swap[h] = swap;
        assign h_rst[h] = rstl;
        assign chain_rx[h] = swap ? s2[4*h + 1] : s2[4*h + 2];

        // pins: PLUG and RXD are inputs; TXD and RST drive only with GO and EN
        assign pin_o[4*h + 0] = 1'b0;  assign pin_oe[4*h + 0] = 1'b0;
        assign pin_o[4*h + 1] = chain_tx[h];  assign pin_oe[4*h + 1] = go & en & !swap;
        assign pin_o[4*h + 2] = chain_tx[h];  assign pin_oe[4*h + 2] = go & en & swap;
        assign pin_o[4*h + 3] = rstl;  assign pin_oe[4*h + 3] = go & en;
    end endgenerate

    // ---------------- I2C ----------------
    wire [31:0] i2c1_st, i2c2_st;
    hr_i2c u_i2c1 (.clk(clk), .rstn(rstn), .div(i2c_div), .cmd_v(wr && idx == 10'd3), .cmd(bus_wdata[10:0]),
                   .status(i2c1_st), .scl_oe(i2c1_scl_oe), .sda_oe(i2c1_sda_oe), .scl_in(i2c1_scl_in), .sda_in(i2c1_sda_in));
    hr_i2c u_i2c2 (.clk(clk), .rstn(rstn), .div(i2c_div), .cmd_v(wr && idx == 10'd4), .cmd(bus_wdata[10:0]),
                   .status(i2c2_st), .scl_oe(i2c2_scl_oe), .sda_oe(i2c2_sda_oe), .scl_in(i2c2_scl_in), .sda_in(i2c2_sda_in));

    assign active = go & (|h_en);

    // ---------------- bus ----------------
    integer k;
    always @(posedge clk) begin
        if (!rstn) begin go <= 1'b0; i2c_div <= 16'd250; end
        else if (wr && idx == 10'd0) go <= bus_wdata[0];
        else if (wr && idx == 10'd5) i2c_div <= (bus_wdata[15:0] < 16'd4) ? 16'd4 : bus_wdata[15:0];
    end
    always @(posedge clk) begin
        if (rd) begin
            bus_rdata <= 32'd0;
            case (idx)
                10'd0:   bus_rdata <= {31'd0, go};
                10'd1:   bus_rdata <= s2[31:0];
                10'd2:   bus_rdata <= {28'd0, s2[35:32]};
                10'd3:   bus_rdata <= i2c1_st;
                10'd4:   bus_rdata <= i2c2_st;
                10'd5:   bus_rdata <= {16'd0, i2c_div};
                10'd127: bus_rdata <= 32'h48535231;
                default: for (k = 0; k < 9; k = k + 1)
                    if (idx == 16 + 8*k) bus_rdata <= {27'd0, h_swap[k], 2'd0, h_rst[k], h_en[k]};
            endcase
        end else if (!sel) bus_rdata <= 32'd0;
    end
endmodule

// Byte-level I2C master. One command per write: op 0 START + write byte, 1 write byte, 2 read byte + ACK,
// 3 read byte + NACK; bit 10 = STOP after the byte. Open drain: *_oe = 1 pulls the line low.
// Honors clock stretching (waits for SCL to go high after releasing it).
module hr_i2c (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] div,
    input  wire        cmd_v,
    input  wire [10:0] cmd,
    output wire [31:0] status,
    output reg         scl_oe = 1'b0,
    output reg         sda_oe = 1'b0,
    input  wire        scl_in,
    input  wire        sda_in
);
    localparam IDLE = 3'd0, START = 3'd1, BIT = 3'd2, ACK = 3'd3, STOP = 3'd4;
    reg [2:0]  st = IDLE;
    reg [1:0]  ph = 2'd0;              // quarter phase inside one SCL period
    reg [15:0] c = 16'd0;
    reg [3:0]  n = 4'd0;
    reg [7:0]  sh = 8'd0, rdata = 8'd0;
    reg [1:0]  op = 2'd0;
    reg        stop_after = 1'b0, nack = 1'b0;
    reg [1:0]  ss = 2'b11, ds = 2'b11;
    always @(posedge clk) begin ss <= {ss[0], scl_in}; ds <= {ds[0], sda_in}; end
    wire scl = ss[1], sda = ds[1];
    wire reading = op[1];
    assign status = {st != IDLE, 22'd0, nack, rdata};
    wire tick = (c == 16'd0);

    always @(posedge clk) begin
        if (!rstn) begin st <= IDLE; scl_oe <= 1'b0; sda_oe <= 1'b0; nack <= 1'b0; end
        else begin
            if (!tick) c <= c - 1'b1;
            case (st)
            IDLE: if (cmd_v) begin
                    op <= cmd[9:8]; stop_after <= cmd[10]; sh <= cmd[7:0]; n <= 4'd0; ph <= 2'd0; c <= div;
                    st <= (cmd[9:8] == 2'd0) ? START : BIT;
                  end
            START: if (tick) begin                       // SDA high, SCL high -> SDA low -> SCL low
                    c <= div; ph <= ph + 1'b1;
                    case (ph)
                      2'd0: begin sda_oe <= 1'b0; scl_oe <= 1'b0; end
                      2'd1: if (!scl) begin c <= 16'd0; ph <= ph; end   // wait for SCL high (stretch)
                            else sda_oe <= 1'b1;
                      2'd2: scl_oe <= 1'b1;
                      2'd3: begin st <= BIT; ph <= 2'd0; end
                    endcase
                  end
            BIT: if (tick) begin                         // ph0 set SDA, ph1 SCL up, ph2 sample, ph3 SCL down
                    c <= div; ph <= ph + 1'b1;
                    case (ph)
                      2'd0: sda_oe <= reading ? 1'b0 : !sh[7];
                      2'd1: scl_oe <= 1'b0;
                      2'd2: if (!scl) begin c <= 16'd0; ph <= ph; end
                            else if (reading) rdata <= {rdata[6:0], sda};
                      2'd3: begin
                              scl_oe <= 1'b1; sh <= {sh[6:0], 1'b0}; n <= n + 1'b1;
                              if (n == 4'd7) st <= ACK;
                            end
                    endcase
                  end
            ACK: if (tick) begin
                    c <= div; ph <= ph + 1'b1;
                    case (ph)
                      2'd0: sda_oe <= reading ? (op == 2'd2) : 1'b0;     // master ACKs a read with op 2
                      2'd1: scl_oe <= 1'b0;
                      2'd2: if (!scl) begin c <= 16'd0; ph <= ph; end
                            else if (!reading) nack <= sda;
                      2'd3: begin scl_oe <= 1'b1; ph <= 2'd0; st <= stop_after ? STOP : IDLE;
                                  if (!stop_after) sda_oe <= 1'b0; end
                    endcase
                  end
            STOP: if (tick) begin                        // SDA low, SCL up, SDA up
                    c <= div; ph <= ph + 1'b1;
                    case (ph)
                      2'd0: sda_oe <= 1'b1;
                      2'd1: scl_oe <= 1'b0;
                      2'd2: if (!scl) begin c <= 16'd0; ph <= ph; end
                            else sda_oe <= 1'b0;
                      2'd3: begin st <= IDLE; ph <= 2'd0; end
                    endcase
                  end
            default: st <= IDLE;
            endcase
        end
    end
endmodule
