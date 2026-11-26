`timescale 1ns / 1ps
// Orphan NES: the ARM link (Ardzy's register bus on GP0, FCLK0 = 100 MHz) plus ONE DDR read port, the PS's HP2,
// on its own clock (hp_clk). orphan_nes_block clocks HP2 with the console clock (21.48 MHz): its cart cache reads
// the DDR without crossing clocks, and the paths to the PS edge have 46 ns instead of 10.
// Wiring after Ardzy's ardzy_ps7 / ardzy_bus_ddr (by chryso, GPL-3.0); the bus state machine is the same as
// ardzy_bus. Only reading: the FPGA can not change Linux's memory through HP2.
// The HP ports read the DDR, not the ARM's caches: the ARM writes its caches back before the FPGA reads.
// by JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money.
module orphan_bus_hp (
    output wire        clk,                 // 100 MHz (FCLK0)
    output wire        rstn,
    output reg  [15:0] bus_addr = 16'd0,
    output reg  [31:0] bus_wdata = 32'd0,
    output reg  [3:0]  bus_wstrb = 4'd0,
    output reg         bus_we = 1'b0,
    output reg         bus_re = 1'b0,
    input  wire [31:0] bus_rdata,
    // HP2 read channels (AXI3, 64-bit), clocked by hp_clk
    input  wire        hp_clk,
    input  wire [31:0] hp_araddr,
    input  wire [3:0]  hp_arlen,
    input  wire        hp_arvalid,
    output wire        hp_arready,
    output wire [63:0] hp_rdata,
    output wire        hp_rvalid,
    output wire        hp_rlast,
    output wire [1:0]  hp_rresp,
    input  wire        hp_rready
);
    wire [31:0] awaddr, wdata, araddr, rdata;
    wire [3:0]  awlen, wstrb, arlen;
    wire [1:0]  awsize, awburst, arsize, arburst, bresp, rresp;
    wire [11:0] awid, arid, bid, rid;
    wire awvalid, awready, wlast, wvalid, wready, bvalid, bready, arvalid, arready, rlast, rvalid, rready;

    // ---------------------------------------------------------------- PS7
    wire [3:0] fclk, fclk_rstn;
    (* keep *) wire ardzy_fclk;                 // FCLK0 after its BUFG: the Ardzy build finds the ARM side by this name
    assign ardzy_fclk = clk;
    wire [63:0] ardzy_gpio_o;
`ifdef ARDZY_ILA
    (* keep *) wire [15:0] ardzy_ila_ctl;
    (* keep *) wire [31:0] ardzy_ila_dout;
    assign ardzy_ila_ctl = ardzy_gpio_o[31:16];
`endif
`ifdef ARDZY_EMIO_ENET0
    (* keep *) wire [3:0] ardzy_eth_txd, ardzy_eth_rxd;
    (* keep *) wire ardzy_eth_txen, ardzy_eth_txclk, ardzy_eth_rxclk, ardzy_eth_rxdv, ardzy_eth_mdc, ardzy_eth_mdio;
    (* keep *) wire ardzy_eth_phyclk;
    (* keep *) wire ardzy_led_red, ardzy_led_green;
    wire [7:0] ardzy_eth_txd8;
    wire ardzy_eth_mdo, ardzy_eth_mdt;
    assign ardzy_eth_txd = ardzy_eth_txd8[3:0];
    assign ardzy_eth_mdio = ardzy_eth_mdt ? 1'bz : ardzy_eth_mdo;
    assign ardzy_eth_phyclk = fclk[3];
    assign ardzy_led_red = ardzy_gpio_o[0];
    assign ardzy_led_green = ardzy_gpio_o[1];
`endif
    BUFG u_bufg (.I(fclk[0]), .O(clk));
    reg [2:0] rs = 3'b000;
    always @(posedge clk) rs <= {rs[1:0], fclk_rstn[0]};
    assign rstn = rs[2];

    PS7 u_ps7 (
`ifdef ARDZY_EMIO_ENET0
        .EMIOENET0GMIITXD(ardzy_eth_txd8), .EMIOENET0GMIITXEN(ardzy_eth_txen), .EMIOENET0GMIITXCLK(ardzy_eth_txclk),
        .EMIOENET0GMIIRXCLK(ardzy_eth_rxclk), .EMIOENET0GMIIRXD({4'b0000, ardzy_eth_rxd}), .EMIOENET0GMIIRXDV(ardzy_eth_rxdv),
        .EMIOENET0GMIIRXER(1'b0), .EMIOENET0GMIICOL(1'b0), .EMIOENET0GMIICRS(1'b0),
        .EMIOENET0MDIOMDC(ardzy_eth_mdc), .EMIOENET0MDIOO(ardzy_eth_mdo), .EMIOENET0MDIOTN(ardzy_eth_mdt),
        .EMIOENET0MDIOI(ardzy_eth_mdio),
`endif
`ifdef ARDZY_ILA
        .EMIOGPIOO(ardzy_gpio_o), .EMIOGPIOI({ardzy_ila_dout, 32'd0}),
`elsif ARDZY_EMIO_ENET0
        .EMIOGPIOO(ardzy_gpio_o), .EMIOGPIOI(64'd0),
`endif
        .FCLKCLK(fclk), .FCLKRESETN(fclk_rstn), .FCLKCLKTRIGN(4'b0000),
        .MAXIGP0ACLK(clk),
        .SAXIACPARVALID(1'b0), .SAXIACPAWVALID(1'b0), .SAXIACPWVALID(1'b0),
        .SAXIHP0ARVALID(1'b0), .SAXIHP0AWVALID(1'b0), .SAXIHP0WVALID(1'b0),
        .SAXIHP1ARVALID(1'b0), .SAXIHP1AWVALID(1'b0), .SAXIHP1WVALID(1'b0),
        .SAXIHP2ACLK(hp_clk), .SAXIHP2ARADDR(hp_araddr), .SAXIHP2ARLEN(hp_arlen), .SAXIHP2ARSIZE(2'd3), .SAXIHP2ARBURST(2'd1),
        .SAXIHP2ARCACHE(4'b0011), .SAXIHP2ARID(6'd0), .SAXIHP2RDISSUECAP1EN(1'b0), .SAXIHP2WRISSUECAP1EN(1'b0),
        .SAXIHP2ARPROT(3'd0), .SAXIHP2ARQOS(4'd0), .SAXIHP2ARLOCK(2'd0),
        .SAXIHP2ARVALID(hp_arvalid), .SAXIHP2ARREADY(hp_arready), .SAXIHP2RDATA(hp_rdata), .SAXIHP2RVALID(hp_rvalid),
        .SAXIHP2RLAST(hp_rlast), .SAXIHP2RRESP(hp_rresp), .SAXIHP2RREADY(hp_rready),
        .SAXIHP2AWVALID(1'b0), .SAXIHP2WVALID(1'b0), .SAXIHP2BREADY(1'b1),
        .SAXIHP3ARVALID(1'b0), .SAXIHP3AWVALID(1'b0), .SAXIHP3WVALID(1'b0),
        .MAXIGP0AWADDR(awaddr), .MAXIGP0AWLEN(awlen), .MAXIGP0AWSIZE(awsize), .MAXIGP0AWBURST(awburst),
        .MAXIGP0AWID(awid), .MAXIGP0AWVALID(awvalid), .MAXIGP0AWREADY(awready),
        .MAXIGP0WDATA(wdata), .MAXIGP0WSTRB(wstrb), .MAXIGP0WLAST(wlast), .MAXIGP0WVALID(wvalid),
        .MAXIGP0WREADY(wready),
        .MAXIGP0BID(bid), .MAXIGP0BRESP(bresp), .MAXIGP0BVALID(bvalid), .MAXIGP0BREADY(bready),
        .MAXIGP0ARADDR(araddr), .MAXIGP0ARLEN(arlen), .MAXIGP0ARSIZE(arsize), .MAXIGP0ARBURST(arburst),
        .MAXIGP0ARID(arid), .MAXIGP0ARVALID(arvalid), .MAXIGP0ARREADY(arready),
        .MAXIGP0RID(rid), .MAXIGP0RDATA(rdata), .MAXIGP0RRESP(rresp), .MAXIGP0RLAST(rlast),
        .MAXIGP0RVALID(rvalid), .MAXIGP0RREADY(rready)
    );

    // ---------------------------------------------------------------- AXI3 -> lite -> the register bus (as ardzy_bus)
    wire [31:0] l_awaddr, l_wdata, l_araddr;
    reg  [31:0] l_rdata = 32'd0;
    wire [3:0]  l_wstrb;
    wire l_awvalid, l_wvalid, l_bready, l_arvalid, l_rready;
    reg  l_awready = 1'b0, l_wready = 1'b0, l_bvalid = 1'b0, l_arready = 1'b0, l_rvalid = 1'b0;
    ardzy_axi3_lite u_bridge (
        .clk(clk), .rstn(rstn),
        .awaddr(awaddr), .awlen(awlen), .awsize(awsize), .awburst(awburst), .awid(awid), .awvalid(awvalid), .awready(awready),
        .wdata(wdata), .wstrb(wstrb), .wlast(wlast), .wvalid(wvalid), .wready(wready),
        .bid(bid), .bresp(bresp), .bvalid(bvalid), .bready(bready),
        .araddr(araddr), .arlen(arlen), .arsize(arsize), .arburst(arburst), .arid(arid), .arvalid(arvalid), .arready(arready),
        .rid(rid), .rdata(rdata), .rresp(rresp), .rlast(rlast), .rvalid(rvalid), .rready(rready),
        .m_awaddr(l_awaddr), .m_awvalid(l_awvalid), .m_awready(l_awready),
        .m_wdata(l_wdata), .m_wstrb(l_wstrb), .m_wvalid(l_wvalid), .m_wready(l_wready),
        .m_bvalid(l_bvalid), .m_bready(l_bready),
        .m_araddr(l_araddr), .m_arvalid(l_arvalid), .m_arready(l_arready),
        .m_rdata(l_rdata), .m_rvalid(l_rvalid), .m_rready(l_rready));

    localparam IDLE = 3'd0, W1 = 3'd1, W2 = 3'd2, R1 = 3'd3, R2 = 3'd4, R3 = 3'd5, R1B = 3'd6;
    reg [2:0] st = IDLE;
    reg rwin = 1'b0;
    always @(posedge clk) begin
        bus_we <= 1'b0;
        bus_re <= 1'b0;
        if (!rstn) begin
            st <= IDLE; l_awready <= 1'b0; l_wready <= 1'b0; l_bvalid <= 1'b0; l_arready <= 1'b0; l_rvalid <= 1'b0;
        end else case (st)
        IDLE:
            if (l_awvalid && l_wvalid) begin
                l_awready <= 1'b1; l_wready <= 1'b1;
                bus_we <= (l_awaddr[31:16] == 16'h43C0);
                bus_addr <= l_awaddr[15:0]; bus_wdata <= l_wdata; bus_wstrb <= l_wstrb;
                st <= W1;
            end else if (l_arvalid) begin
                l_arready <= 1'b1;
                bus_re <= (l_araddr[31:16] == 16'h43C0);
                rwin <= (l_araddr[31:16] == 16'h43C0);
                bus_addr <= l_araddr[15:0];
                st <= R1;
            end
        W1: begin l_awready <= 1'b0; l_wready <= 1'b0; l_bvalid <= 1'b1; st <= W2; end
        W2: if (l_bready) begin l_bvalid <= 1'b0; st <= IDLE; end
        R1: begin l_arready <= 1'b0; st <= R1B; end
        R1B: st <= R2;
        R2: begin l_rdata <= rwin ? bus_rdata : 32'd0; l_rvalid <= 1'b1; st <= R3; end
        R3: if (l_rready) begin l_rvalid <= 1'b0; st <= IDLE; end
        default: st <= IDLE;
        endcase
    end
endmodule
