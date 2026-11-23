`timescale 1ns / 1ps
// INTERSEKTOR simulation bench (Icarus). Device A and device B are behavioural UARTs written here with their own
// timing (real-number delays, not the core's clock or divider): A sends on J6.5, B on J7.5, each can run fast or
// slow; two independent receivers decode what the bridge puts on J7.11 (to B) and J6.11 (to A).
// Prints "PASS name" / "FAIL name ..." and "DONE n_failed". Run with test_ik.py.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module uart_mon (input wire line);
    real bitns = 8680.555;
    reg [7:0] mem [0:1023];
    integer n = 0, ferr = 0, i;
    reg [7:0] b;
    always begin
        @(negedge line);
        #(bitns / 2.0);
        if (!line) begin
            for (i = 0; i < 8; i = i + 1) begin #(bitns); b[i] = line; end
            #(bitns);
            if (!line) ferr = ferr + 1;
            else begin mem[n] = b; n = n + 1; end
        end
    end
endmodule

module tb_ik;
    reg clk = 1'b0;
    always #5 clk = !clk;
    reg rstn = 1'b0;
    initial begin repeat (10) @(posedge clk); rstn = 1'b1; end

    reg  [15:0] addr = 16'd0;
    reg  [31:0] wdata = 32'd0;
    reg         we = 1'b0, re = 1'b0;
    wire [31:0] rdata;
    wire [35:0] po, poe, pad;
    reg  [35:0] ext = {36{1'b1}};           // what the outside world drives (pull-ups when idle)
    genvar g;
    generate for (g = 0; g < 36; g = g + 1) begin : pads
        assign pad[g] = poe[g] ? po[g] : ext[g];
    end endgenerate
    wire led;
    intersektor #(.SLOT(4'd2), .HB_US(18'd3000)) dut (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rdata),
        .pins_in(pad), .pins_o(po), .pins_oe(poe), .led_act(led));
    uart_mon monB (.line(pad[25]));         // J7.11: what device B receives
    uart_mon monA (.line(pad[21]));         // J6.11: what device A receives

    localparam real BIT = 8680.555;         // 115200 baud
    localparam A_TX = 20, B_TX = 24;
    integer fails = 0;
    task check(input [8*64-1:0] name, input ok);
        begin if (ok) $display("PASS %0s", name); else begin $display("FAIL %0s", name); fails = fails + 1; end end
    endtask

    task bw(input [9:0] i, input [31:0] v);
        begin @(posedge clk); addr <= {4'd2, i, 2'b00}; wdata <= v; we <= 1'b1; @(posedge clk); we <= 1'b0;
              repeat (3) @(posedge clk); end
    endtask
    reg [31:0] rv;
    task br(input [9:0] i);
        begin @(posedge clk); addr <= {4'd2, i, 2'b00}; re <= 1'b1; @(posedge clk); re <= 1'b0;
              @(posedge clk); #1 rv = rdata; repeat (2) @(posedge clk); end
    endtask

    task automatic send(input integer pin, input [7:0] b, input real bitns);
        integer i;
        begin ext[pin] = 1'b0; #(bitns);
              for (i = 0; i < 8; i = i + 1) begin ext[pin] = b[i]; #(bitns); end
              ext[pin] = 1'b1; #(bitns); end
    endtask
    task automatic sends(input integer pin, input [8*64-1:0] s, input integer len, input real bitns);
        integer i;
        for (i = len - 1; i >= 0; i = i - 1) send(pin, s[8*i +: 8], bitns);
    endtask
    task wait_us(input integer us); begin #(us * 1000.0); end endtask

    // the log, read into arrays
    integer ln = 0;
    reg [2:0] lk [0:1023];
    reg       ldir [0:1023];
    reg [7:0] lout [0:1023], lbyte [0:1023];
    reg [31:0] lts [0:1023];
    task read_log;
        begin ln = 0; br(4);
              while (rv[31]) begin lk[ln] = rv[30:28]; ldir[ln] = rv[27]; lout[ln] = rv[15:8]; lbyte[ln] = rv[7:0];
                  br(5); lts[ln] = rv; ln = ln + 1; br(4); end
        end
    endtask
    function integer count_kind(input integer k, input integer d);
        integer i;
        begin count_kind = 0; for (i = 0; i < ln; i = i + 1) if (lk[i] == k && ldir[i] == d) count_kind = count_kind + 1; end
    endfunction

    function [8*64-1:0] got(input integer which, input integer from, input integer len);
        integer i;
        begin got = 0;
              for (i = 0; i < len; i = i + 1) got = {got[8*63-1:0], which ? monB.mem[from + i] : monA.mem[from + i]}; end
    endfunction

    integer i, b0, a0, ok, sd;
    reg [7:0] rnd [0:255];
    initial begin
        @(posedge rstn); repeat (5) @(posedge clk);
        br(127); check("ID reads IKT1", rv == 32'h494B5431);
        bw(16, 2); bw(24, 2);               // both directions RELAY
        repeat (10) @(posedge clk);
        check("GO off: no pin is driven", poe == 36'd0);
        bw(0, 1);                           // GO
        repeat (5) @(posedge clk);
        check("GO on: only J7.11 and J6.11 are driven", poe == ((36'd1 << 25) | (36'd1 << 21)));
        check("idle transmit pins are high", pad[25] && pad[21]);

        // ---- RELAY, sender 2 % fast, back to back
        bw(0, 32'h101);                     // clear the log
        b0 = monB.n;
        sends(A_TX, "Hello, INTERSEKTOR!", 19, BIT * 0.98);
        wait_us(300);
        check("RELAY A->B: 19 bytes from a 2% fast sender", monB.n - b0 == 19 && got(1, b0, 19) == "Hello, INTERSEKTOR!");
        check("nothing came back to A", monA.n == 0);
`ifdef QUICK
        $display("monB n=%0d ferr=%0d", monB.n - b0, monB.ferr);
        for (i = 0; i < monB.n; i = i + 1) $write("%02x ", monB.mem[i]); $display("");
        read_log; for (i = 0; i < ln; i = i + 1) $display("log k%0d d%0d out %02x b %02x t %0d", lk[i], ldir[i], lout[i], lbyte[i], lts[i]);
        $finish;
`endif
        read_log;
        check("log: 19 passed entries", count_kind(1, 0) == 19);
        check("log: 19 OUT entries (read back from the pin)", count_kind(6, 0) == 19);
        ok = 1; for (i = 1; i < ln; i = i + 1) if (lts[i] < lts[i - 1]) ok = 0;
        check("log time stamps never go backwards", ok);
        ok = 0; for (i = 0; i < ln; i = i + 1) if (lk[i] == 1 && ldir[i] == 0 && lbyte[i] == "H") ok = 1;
        check("log holds the byte values", ok);

        // a long burst, 200 random bytes 2.4 % fast, back to back: nothing may be lost
        sd = 7; for (i = 0; i < 200; i = i + 1) rnd[i] = $random(sd);
        b0 = monB.n;
        for (i = 0; i < 200; i = i + 1) send(A_TX, rnd[i], BIT * 0.976);
        wait_us(400);
        ok = monB.n - b0 == 200; for (i = 0; i < 200 && ok; i = i + 1) if (monB.mem[b0 + i] != rnd[i]) ok = 0;
        check("200-byte burst 2.4% fast: all bytes, in order", ok);
        br(22); check("no byte lost (ERRS)", rv[15:8] == 0);
        check("receiver B saw no framing errors", monB.ferr == 0);
        // a slow sender, B -> A
        a0 = monA.n;
        sends(B_TX, "slow side 2%", 12, BIT * 1.02);
        wait_us(300);
        check("RELAY B->A: 2% slow sender", monA.n - a0 == 12 && got(0, a0, 12) == "slow side 2%");

        // ---- the swap table
        bw(2, (1 << 16) | ("L" << 8) | "l");           // d0: l -> L
        bw(2, (1 << 17) | "o");                        // d0: drop o
        bw(3, "l"); br(3); check("table reads back (l -> L)", rv == {22'd0, 2'b01, "L"});
        b0 = monB.n;
        sends(A_TX, "hello world", 11, BIT);
        wait_us(300);
        check("swap l->L and drop o: hello world -> heLL wrLd", monB.n - b0 == 9 && got(1, b0, 9) == "heLL wrLd");
        a0 = monA.n;
        sends(B_TX, "lol", 3, BIT);
        wait_us(200);
        check("the table is per direction (B->A untouched)", monA.n - a0 == 3 && got(0, a0, 3) == "lol");
        br(22); check("ERRS counts 3 swapped, 2 dropped", rv[31:24] == 3 && rv[23:16] == 2);
        bw(2, "l"); bw(2, "o");                        // back to pass

        // ---- inject
        a0 = monA.n;
        bw(27, "I"); bw(27, "N"); bw(27, "J");
        wait_us(300);
        check("inject B->A: INJ arrives at A", monA.n - a0 == 3 && got(0, a0, 3) == "INJ");
        // inject while relaying: both streams arrive whole and in their own order
        b0 = monB.n;
        fork
            sends(A_TX, "abcdefgh", 8, BIT);
            begin wait_us(150); bw(19, "X"); bw(19, "Y"); bw(19, "Z"); end
        join
        wait_us(400);
        ok = monB.n - b0 == 11;
        begin : order
            integer r, x;
            r = 0; x = 0;
            for (i = 0; i < 11; i = i + 1) begin
                if (monB.mem[b0 + i] == "a" + r) r = r + 1;
                else if (monB.mem[b0 + i] == "X" + x) x = x + 1;
                else ok = 0;
            end
            if (r != 8 || x != 3) ok = 0;
        end
        check("inject during traffic: 8 relayed + 3 injected, each in order", ok);

        // ---- WIRE: bit-level pass-through at a baud the core is not set to
        bw(16, 1);
        repeat (20) @(posedge clk);
        br(16); check("mode change to WIRE takes effect when idle", rv[5:4] == 2'd1);
        monB.bitns = 104166.67;                         // 9600 baud
        b0 = monB.n;
        sends(A_TX, "wire", 4, 104166.67);
        wait_us(1500);
        check("WIRE passes 9600 baud bit by bit (core set to 115200)", monB.n - b0 == 4 && got(1, b0, 4) == "wire");
        monB.bitns = BIT;
        // WIRE delay: an edge on A's TX reaches J7.11 within 100 ns
        ext[A_TX] = 1'b0; #100; check("WIRE delay under 100 ns", pad[25] == 1'b0); ext[A_TX] = 1'b1; #200;
        wait_us(100);

        // ---- HOLD: bytes go only to the log; the tb (the ARM) forwards an edited copy
        bw(16, 3);
        repeat (20) @(posedge clk);
        bw(0, 32'h101);
        b0 = monB.n;
        sends(A_TX, "HOLD", 4, BIT);
        wait_us(150);
        check("HOLD: nothing forwarded by itself", monB.n == b0);
        read_log;
        check("HOLD: 4 held entries in the log", count_kind(4, 0) == 4 && lbyte[0] == "H");
        bw(0, 1); bw(19, "H"); bw(19, "0"); bw(19, "L"); bw(19, "D");
        wait_us(450);
        check("HOLD: the edited copy H0LD goes out", monB.n - b0 == 4 && got(1, b0, 4) == "H0LD");
        // failsafe: no heartbeat for 3 ms (250 ms on the board)
        wait_us(3200);
        br(1); check("FAILSAFE flag after the heartbeat stops", rv[18] == 1'b1);
        b0 = monB.n;
        sends(A_TX, "FS", 2, BIT);
        wait_us(200);
        check("FAILSAFE relays bytes", monB.n - b0 == 2 && got(1, b0, 2) == "FS");
        bw(0, 1); br(1); check("a heartbeat ends FAILSAFE", rv[18] == 1'b0);

        // ---- a break: logged as a framing error, not forwarded
        bw(16, 2); repeat (20) @(posedge clk);
        bw(0, 32'h301);
        b0 = monB.n;
        ext[A_TX] = 1'b0; wait_us(300); ext[A_TX] = 1'b1; wait_us(200);
        read_log;
        check("break: framing error logged", count_kind(5, 0) >= 1);
        check("break: nothing forwarded", monB.n == b0 && monB.ferr == 0);
        br(22); check("break: ERRS framing count", rv[7:0] >= 1);

        // ---- the baud finder
        bw(21, 0);
        sends(A_TX, 8'h55, 1, BIT);                     // 0x55: every bit is one bit long
        wait_us(100);
        br(21); check("MINP = one bit at 115200 (868 clocks)", rv >= 864 && rv <= 872);

        // ---- pin conflict: d1 transmits on d0's receive pin
        bw(26, (20 << 8) | 24);
        repeat (5) @(posedge clk);
        br(1); check("conflict flag when a transmit pin is a receive pin", rv[17] == 1'b1 && rv[25] == 1'b0);
        check("the conflicting pin is not driven", poe[20] == 1'b0);
        bw(26, (21 << 8) | 24);
        repeat (5) @(posedge clk);
        br(1); check("conflict clears", rv[17] == 1'b0 && rv[25] == 1'b1);

        // ---- TEST mode: the built-in test transmitters replace A and B
        bw(0, 3);
        b0 = monB.n; a0 = monA.n;
        bw(23, "T"); bw(23, "1"); bw(31, "t"); bw(31, "2");
        wait_us(300);
        check("TEST: test transmitter A reaches B", monB.n - b0 == 2 && got(1, b0, 2) == "T1");
        check("TEST: test transmitter B reaches A", monA.n - a0 == 2 && got(0, a0, 2) == "t2");
        bw(0, 1);

        // ---- OFF: listen only
        bw(16, 0); bw(24, 0); repeat (20) @(posedge clk);
        check("OFF: pins released", poe == 36'd0);
        bw(0, 32'h101);
        sends(A_TX, "sniff", 5, BIT);
        wait_us(100);
        read_log;
        check("OFF still logs (sniffing)", count_kind(1, 0) == 5);

        $display("DONE %0d", fails);
        $finish;
    end
    integer z;
    initial for (z = 0; z < 256; z = z + 1) begin dut.tbl0[z] = 10'd0; dut.tbl1[z] = 10'd0; end   // the ARM clears them at start
    initial begin #200000000; $display("TIMEOUT"); $finish; end
endmodule
