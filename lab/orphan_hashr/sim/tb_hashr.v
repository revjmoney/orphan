`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR simulation bench for hashr.v: behavioural UART receiver/sender on header J8 (h = 7) and a
// behavioural I2C slave (a PIC at 0x57 that ACKs and answers 0x03). Prints PASS/FAIL lines, then DONE <fails>.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module tb;
    reg clk = 0, rstn = 0;
    always #5 clk = ~clk;                       // 100 MHz
    reg  [15:0] addr = 0;
    reg  [31:0] wdata = 0;
    reg  we = 0, re = 0;
    wire [31:0] rdata;
    reg  [35:0] pin_in = {36{1'b1}};
    wire [35:0] pin_o, pin_oe;
    wire s1o, d1o, s2o, d2o, act;
    reg  slave_sda_low = 0;
    wire scl1 = !s1o;                           // wired-AND bus with pull-ups (slave never stretches)
    wire sda1 = !d1o && !slave_sda_low;
    hashr #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
        .bus_rdata(rdata), .pin_in(pin_in), .pin_o(pin_o), .pin_oe(pin_oe),
        .i2c1_scl_oe(s1o), .i2c1_sda_oe(d1o), .i2c1_scl_in(scl1), .i2c1_sda_in(sda1),
        .i2c2_scl_oe(s2o), .i2c2_sda_oe(d2o), .i2c2_scl_in(!s2o), .i2c2_sda_in(!d2o), .active(act));

    integer fails = 0;
    task check(input [255:0] name, input ok);
        begin if (ok) $display("PASS %0s", name); else begin $display("FAIL %0s", name); fails = fails + 1; end end
    endtask
    task wr(input [9:0] i, input [31:0] v);
        begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end
    endtask
    reg [31:0] rv;
    task rd(input [9:0] i);
        begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0; @(posedge clk); rv = rdata;
              repeat (4) @(posedge clk); end
    endtask

    // ---- UART receiver on J8 TXD (pin index 29): decodes what the core sends
    localparam H = 7;
    wire txd = pin_oe[4*H+1] ? pin_o[4*H+1] : 1'b1;
    reg [7:0] got [0:15];
    integer ngot = 0, cpb_rx = 864;
    integer b;
    reg [7:0] sh;
    initial forever begin
        @(negedge txd);
        #(cpb_rx * 10 / 2);                     // middle of the start bit
        for (b = 0; b < 8; b = b + 1) begin #(cpb_rx * 10); sh[b] = txd; end
        #(cpb_rx * 10);
        if (txd) begin got[ngot] = sh; ngot = ngot + 1; end
    end

    // ---- UART sender into J8 RXD (pin index 30)
    task send_byte(input [7:0] v, input integer cpb);
        integer i;
        begin
            pin_in[4*H+2] = 0; #(cpb * 10);
            for (i = 0; i < 8; i = i + 1) begin pin_in[4*H+2] = v[i]; #(cpb * 10); end
            pin_in[4*H+2] = 1; #(cpb * 10);
        end
    endtask

    // ---- I2C slave at 0x57: ACKs its address and every written byte, answers reads with 0x03
    // Bits are counted on SCL rising edges (sample), the slave changes SDA on falling edges.
    reg [7:0] ish; integer ibit = 0; reg iactive = 0, irw = 0, iaddr_phase = 0, isel = 0, idone = 0;
    reg [7:0] ireply = 8'h03;
    always @(negedge sda1) if (scl1) begin iactive = 1; ibit = 0; iaddr_phase = 1; isel = 0; idone = 0;
                                           slave_sda_low = 0; end
    always @(posedge sda1) if (scl1) begin iactive = 0; slave_sda_low = 0; end
    always @(posedge scl1) if (iactive) begin
        if (ibit < 8) ish = {ish[6:0], sda1};
        else if (!iaddr_phase && irw && sda1) idone = 1;      // master NACKed our byte: stop sending
        ibit = ibit + 1;
    end
    always @(negedge scl1) if (iactive) begin
        slave_sda_low = 0;
        if (ibit == 8) begin
            if (iaddr_phase) begin isel = (ish[7:1] == 7'h57); irw = ish[0]; end
            slave_sda_low = isel && (iaddr_phase || !irw);  // ACK the address and written bytes
        end else if (ibit == 9) begin
            ibit = 0; iaddr_phase = 0;
        end
        if (!iaddr_phase && irw && isel && !idone && ibit < 8) slave_sda_low = !ireply[7 - ibit];
    end

    integer i, t0;
    reg ok;
    initial begin
        repeat (5) @(posedge clk); rstn = 1; repeat (5) @(posedge clk);

        // GO = 0: no output enabled anywhere
        wr(16 + 8*H, 32'h1);                     // EN, RST low
        repeat (4) @(posedge clk);
        check("test_go_gates_outputs", pin_oe == 36'd0);

        // RST level with GO + EN
        wr(0, 1);
        repeat (4) @(posedge clk);
        check("test_rst_low_when_held", pin_oe[4*H+3] && pin_o[4*H+3] == 0);
        wr(16 + 8*H, 32'h3);
        repeat (4) @(posedge clk);
        check("test_rst_high_when_run", pin_oe[4*H+3] && pin_o[4*H+3] == 1 && pin_oe[4*H+1]);
        check("test_other_headers_quiet", (pin_oe & ~(36'hF << (4*H))) == 36'd0);

        // UART TX at 115.7 k (864 clocks/bit): 55 05 00 00 10
        wr(16 + 8*H + 1, 864); cpb_rx = 864; ngot = 0;
        wr(16 + 8*H + 2, 8'h55); wr(16 + 8*H + 2, 8'h05); wr(16 + 8*H + 2, 8'h00);
        wr(16 + 8*H + 2, 8'h00); wr(16 + 8*H + 2, 8'h10);
        t0 = $time; while (ngot < 5 && $time - t0 < 1000000) #1000;
        check("test_uart_tx_115200", ngot == 5 && got[0] == 8'h55 && got[1] == 8'h05 && got[2] == 8'h00
                                     && got[3] == 8'h00 && got[4] == 8'h10);

        // UART RX at 1.5625 M (64 clocks/bit): 7 bytes
        wr(16 + 8*H + 1, 64);
        wr(16 + 8*H, 32'h3 | 32'h4);             // flush RX
        send_byte(8'h13, 64); send_byte(8'h87, 64); send_byte(8'h90, 64); send_byte(8'h00, 64);
        send_byte(8'h00, 64); send_byte(8'h00, 64); send_byte(8'h1A, 64);
        #2000;
        rd(16 + 8*H + 4);
        check("test_uart_rx_count", (rv & 32'hFFF) == 7);
        ok = 1;
        rd(16 + 8*H + 3); ok = ok && rv[8] && rv[7:0] == 8'h13 && !rv[9];
        rd(16 + 8*H + 3); ok = ok && rv[8] && rv[7:0] == 8'h87;
        for (i = 0; i < 4; i = i + 1) rd(16 + 8*H + 3);
        rd(16 + 8*H + 3); ok = ok && rv[8] && rv[7:0] == 8'h1A;
        rd(16 + 8*H + 3); ok = ok && !rv[8];
        check("test_uart_rx_1m5625", ok);
        rd(16 + 8*H + 5);
        check("test_uart_rx_no_framing_errors", rv == 0);

        // TX at 1.5625 M too
        cpb_rx = 64; ngot = 0;
        wr(16 + 8*H + 2, 8'hA5); wr(16 + 8*H + 2, 8'h3C);
        t0 = $time; while (ngot < 2 && $time - t0 < 100000) #100;
        check("test_uart_tx_1m5625", ngot == 2 && got[0] == 8'hA5 && got[1] == 8'h3C);

        // I2C: write 0x57 (ACK), then read 1 byte = 0x03
        wr(5, 10);                                // fast SCL for the sim
        wr(3, (0 << 8) | (8'h57 << 1));          // START + addr write
        t0 = $time; rd(3); while (rv[31]) rd(3);
        check("test_i2c_addr_ack", !rv[8]);
        wr(3, (1 << 8) | (1 << 10) | 8'h17);     // write 0x17 + STOP
        rd(3); while (rv[31]) rd(3);
        check("test_i2c_write_ack", !rv[8]);
        wr(3, (0 << 8) | ((8'h57 << 1) | 1));    // START + addr read
        rd(3); while (rv[31]) rd(3);
        wr(3, (3 << 8) | (1 << 10));             // read + NACK + STOP
        rd(3); while (rv[31]) rd(3);
        check("test_i2c_read_03", rv[7:0] == 8'h03);
        wr(3, (0 << 8) | (8'h22 << 1) | (1 << 10));  // nobody at 0x22
        rd(3); while (rv[31]) rd(3);
        check("test_i2c_nack", rv[8]);

        rd(127);
        check("test_id", rv == 32'h48535231);
        wr(0, 0);
        repeat (4) @(posedge clk);
        check("test_go_off_releases", pin_oe == 36'd0);
        $display("DONE %0d", fails);
        $finish;
    end
    initial begin #20000000; $display("TIMEOUT"); $finish; end
endmodule
