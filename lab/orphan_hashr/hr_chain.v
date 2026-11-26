`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: one hashboard chain, the way Bitmain's FPGA drives it.
//
//   Sender     a work FIFO (16 works of 13 words: tag, tag2, tail[3], midstate[8]) and a microsecond timer: every
//              TIMEOUT us (bmminer: 2^24/128*4/MHz*0.9) the next work goes out as the BM1387 job packet
//              21 36 jid 01 00000000 tail[12] midstate[32] crc16 (CRC-16/CCITT-FALSE, big-endian); {tag, tag2} is kept
//              in a 128-entry job table at jid so a nonce can be traced back to the work that made it.
//   Commands   bytes from Linux (addressing, PLL, misc, ticket, temperature I2C) wait in a command FIFO and leave only
//              between packets, one committed command at a time. A baud entry switches the bit time for TX and RX
//              once the transmitter is completely idle.
//   Collector  slides a 7-byte window over the received bytes; a frame counts when CRC5 over its first 51 bits
//              (init 0x1F, bmminer CRC5 / cgminer bmcrc) equals byte 6's low 5 bits, and for a register reply byte 6 bits 6:5
//              are 0 (a nonce may set them: the L3+ BM1485 does, stock L3+ cgminer checks only bit 7 + CRC5). Byte 6
//              bit 7 set: nonce (chip = byte 0 >> 2, job id = byte 5 & 0x7F, tags from the job table); clear:
//              register reply (value = bytes 0..3, chip = byte 4, register = byte 5). A failed window drops one byte.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.

module hr_chain (
    input  wire         clk,
    input  wire         rstn,
    input  wire         us_tick,          // one clock every microsecond
    output wire         tx_line,
    input  wire         rx_line,
    // control
    input  wire         run,
    input  wire [16:0]  timeout,
    input  wire         cpb_we,           // set the bit time at once (use only while idle)
    input  wire [15:0]  cpb_wdata,
    output reg  [15:0]  cpb = 16'd864,
    input  wire         cmd_byte_we,      // append one byte to the open command
    input  wire [7:0]   cmd_byte,
    input  wire         cmd_commit,       // close the open command: it may now be sent
    input  wire         cmd_baud_we,      // queue a bit-time change behind everything queued before it
    input  wire [15:0]  cmd_baud,
    input  wire         work_word_we,     // stage word idx (0 tag, 1 tag2, 2..4 tail, 5..12 midstate)
    input  wire [3:0]   work_word_idx,
    input  wire [31:0]  work_word,
    input  wire         work_push,        // commit the staged work
    input  wire [2:0]   flush,            // [0] works, [1] commands, [2] register replies
    // nonces (one waiting record, taken by nonce_ack)
    output reg          nonce_valid = 1'b0,
    output reg  [6:0]   n_jid = 7'd0,
    output reg  [5:0]   n_chip = 6'd0,
    output reg  [31:0]  n_nonce = 32'd0,
    output reg  [31:0]  n_tag = 32'd0,
    output reg  [31:0]  n_tag2 = 32'd0,
    input  wire         nonce_ack,
    // register replies (64-entry FIFO, head shown, popped by reg_ack)
    output wire         reg_valid,
    output wire [7:0]   r_chip,
    output wire [7:0]   r_reg,
    output wire [31:0]  r_value,
    input  wire         reg_ack,
    // status
    output wire [31:0]  stat,
    output reg  [31:0]  c_sent = 32'd0,
    output reg  [31:0]  c_nonces = 32'd0,
    output reg  [31:0]  c_crcerr = 32'd0,
    output reg  [31:0]  c_frames = 32'd0,
    output reg  [31:0]  c_rxovf = 32'd0,
    output reg  [6:0]   last_jid = 7'd0
);
    // ------------------------------------------------------------------ work FIFO (BRAM, 16 x 16 words)
    reg [31:0] wmem [0:255];
    reg [3:0]  wwp = 4'd0, wrp = 4'd0;
    reg [4:0]  wcnt = 5'd0;
    reg [7:0]  wr_addr = 8'd0;
    reg [31:0] wq = 32'd0;
    always @(posedge clk) begin
        if (work_word_we) wmem[{wwp, work_word_idx}] <= work_word;
        wq <= wmem[wr_addr];
    end

    // ------------------------------------------------------------------ job table (128 x {tag, tag2})
    reg [63:0] jtab [0:127];
    reg        jt_we = 1'b0;
    reg [6:0]  jt_wa = 7'd0;
    reg [63:0] jt_wd = 64'd0;
    reg [6:0]  jt_ra = 7'd0;
    reg [63:0] jt_q = 64'd0;
    always @(posedge clk) begin
        if (jt_we) jtab[jt_wa] <= jt_wd;
        jt_q <= jtab[jt_ra];
    end

    // ------------------------------------------------------------------ command FIFO (1024 x 18)
    // entry [17] end-of-command marker, [16] baud entry (data = bit time), else [7:0] a byte to send
    reg [17:0] cmem [0:1023];
    reg [9:0]  cwp = 10'd0, crp = 10'd0;
    reg [10:0] ccnt = 11'd0;
    reg [10:0] ccommitted = 11'd0;         // whole commands ready to send (never more than ccnt)
    reg [17:0] cq = 18'd0;
    wire       c_full = (ccnt == 11'd1024);
    reg        c_pop = 1'b0;
    wire       c_push = (cmd_byte_we || cmd_commit || cmd_baud_we) && !c_full;
    wire [17:0] c_in = cmd_baud_we ? {2'b01, cmd_baud} : (cmd_commit ? {2'b10, 16'd0} : {10'd0, cmd_byte});
    always @(posedge clk) begin
        if (c_push) cmem[cwp] <= c_in;
        cq <= cmem[crp];
    end

    // ------------------------------------------------------------------ UART
    reg        tstart = 1'b0, tstart_d = 1'b0;
    reg [7:0]  tbyte = 8'd0;
    wire       tbusy;
    wire       tx_idle = !tbusy && !tstart && !tstart_d;
    hr_uart_tx u_tx (.clk(clk), .rst(!rstn), .cpb(cpb), .start(tstart), .d(tbyte), .line(tx_line), .busy(tbusy));
    wire       rv, rferr;
    wire [7:0] rd8;
    hr_uart_rx u_rx (.clk(clk), .rst(!rstn), .cpb(cpb), .line(rx_line), .v(rv), .d(rd8), .ferr(rferr));

    // ------------------------------------------------------------------ CRC-16 of the packet
    reg        crc_init = 1'b0, crc_en = 1'b0;
    reg [7:0]  crc_d = 8'd0;
    wire [15:0] crc;
    hr_crc16 u_crc (.clk(clk), .init(crc_init), .en(crc_en), .d(crc_d), .crc(crc));

    // ------------------------------------------------------------------ pacing timer
    reg [16:0] tmr = 17'd0;
    reg        due = 1'b1;

    // ------------------------------------------------------------------ sender
    localparam S_IDLE = 4'd0, S_CMD_RD = 4'd1, S_CMD_WAIT = 4'd2, S_CMD = 4'd3, S_CMD_TX = 4'd4,
               S_LOAD = 4'd5, S_LOAD_W = 4'd6, S_PKT = 4'd7, S_PKT_TX = 4'd8, S_CRC1 = 4'd9, S_CRC2 = 4'd10,
               S_DONE = 4'd11;
    reg [3:0]   st = S_IDLE;
    reg [31:0]  wbuf = 32'd0;             // the packet word being sent (tail and midstate stream from BRAM)
    reg         ld = 1'b0;                // tag word being loaded (0 tag, 1 tag2)
    reg [5:0]   bi = 6'd0;                // packet byte index
    reg         wpop_r = 1'b0;            // one clock: the work's last byte is out, free its FIFO slot
    reg [6:0]   next_jid = 7'd0;
    reg [63:0]  tags = 64'd0;
    reg         cmd_done = 1'b0;            // one clock: a whole command (or a baud entry) has been sent

    always @(posedge clk) begin
        tstart <= 1'b0;
        tstart_d <= tstart;
        crc_init <= 1'b0;
        crc_en <= 1'b0;
        jt_we <= 1'b0;
        c_pop <= 1'b0;
        cmd_done <= 1'b0;
        wpop_r <= 1'b0;
        if (us_tick) begin
            if (tmr != 17'd0) tmr <= tmr - 1'b1;
            else due <= 1'b1;
        end
        if (cpb_we) cpb <= (cpb_wdata < 16'd8) ? 16'd8 : cpb_wdata;
        if (!rstn) begin
            st <= S_IDLE; next_jid <= 7'd0; due <= 1'b1; tmr <= 17'd0;
        end else case (st)
            S_IDLE:
                if (ccommitted != 11'd0 && tx_idle) st <= S_CMD_RD;
                else if (run && due && wcnt != 5'd0 && tx_idle && !flush[0]) begin
                    tmr <= timeout; due <= 1'b0;
                    ld <= 1'b0; wr_addr <= {wrp, 4'd0}; st <= S_LOAD_W;
                end
            // ---- one command: bytes until the marker, or a single baud entry
            S_CMD_RD:   st <= S_CMD_WAIT;                       // cq follows crp one clock later
            S_CMD_WAIT: st <= S_CMD;
            S_CMD:
                if (cq[17]) begin                               // end of this command
                    c_pop <= 1'b1; cmd_done <= 1'b1; st <= S_DONE;
                end else if (cq[16]) begin                      // bit-time change: the transmitter is idle here
                    if (tx_idle) begin
                        cpb <= (cq[15:0] < 16'd8) ? 16'd8 : cq[15:0];
                        c_pop <= 1'b1; cmd_done <= 1'b1; st <= S_DONE;
                    end
                end else if (tx_idle) begin
                    tbyte <= cq[7:0]; tstart <= 1'b1; c_pop <= 1'b1; st <= S_CMD_TX;
                end
            S_CMD_TX:   st <= S_CMD_RD;                         // next entry (the pop has moved crp)
            // ---- one packet
            S_LOAD_W: begin                                     // wq = word ld after this clock
                st <= S_LOAD;
                wr_addr <= wr_addr + 1'b1;
            end
            S_LOAD: begin                                       // tags first; wq then holds word 2 (tail)
                if (!ld) begin
                    tags[63:32] <= wq; ld <= 1'b1; wr_addr <= wr_addr + 1'b1;
                end else begin
                    jt_we <= 1'b1; jt_wa <= next_jid; jt_wd <= {tags[63:32], wq};
                    last_jid <= next_jid;
                    crc_init <= 1'b1; bi <= 6'd0; st <= S_PKT;
                end
            end
            S_PKT:
                if (tx_idle) begin
                    case (bi)
                        6'd0: tbyte <= 8'h21;
                        6'd1: tbyte <= 8'h36;
                        6'd2: tbyte <= {1'b0, next_jid};
                        6'd3: tbyte <= 8'h01;
                        6'd4, 6'd5, 6'd6, 6'd7: tbyte <= 8'h00;
                        default: tbyte <= (bi[1:0] == 2'b00) ? wq[31:24] : wbuf[31:24];
                    endcase
                    case (bi)
                        6'd0: crc_d <= 8'h21;
                        6'd1: crc_d <= 8'h36;
                        6'd2: crc_d <= {1'b0, next_jid};
                        6'd3: crc_d <= 8'h01;
                        6'd4, 6'd5, 6'd6, 6'd7: crc_d <= 8'h00;
                        default: crc_d <= (bi[1:0] == 2'b00) ? wq[31:24] : wbuf[31:24];
                    endcase
                    if (bi >= 6'd8) begin
                        if (bi[1:0] == 2'b00) begin                 // take the next word, fetch the one after
                            wbuf <= {wq[23:0], 8'd0};
                            wr_addr <= wr_addr + 1'b1;
                        end else wbuf <= {wbuf[23:0], 8'd0};
                    end
                    tstart <= 1'b1; crc_en <= 1'b1;
                    bi <= bi + 1'b1;
                    if (bi == 6'd51) begin wpop_r <= 1'b1; st <= S_CRC1; end
                    else st <= S_PKT_TX;
                end
            S_PKT_TX:   st <= S_PKT;
            S_CRC1:
                if (tx_idle) begin tbyte <= crc[15:8]; tstart <= 1'b1; st <= S_CRC2; end
            S_CRC2:
                if (tx_idle) begin
                    tbyte <= crc[7:0]; tstart <= 1'b1;
                    next_jid <= next_jid + 1'b1;
                    c_sent <= c_sent + 1'b1;
                    st <= S_DONE;
                end
            default:    st <= S_IDLE;                           // S_DONE: one clock for the FIFO counters
        endcase
        // a command flush stops the command being sent (the byte on the wire finishes); without this the sender
        // kept reading the emptied FIFO and its counters wrapped below zero, replaying stale commands
        if (rstn && flush[1] && (st == S_CMD_RD || st == S_CMD_WAIT || st == S_CMD || st == S_CMD_TX)) begin
            st <= S_DONE; c_pop <= 1'b0; cmd_done <= 1'b0;
        end
    end

    // ------------------------------------------------------------------ FIFO counters
    reg  w_orph = 1'b0;                    // the packet in flight was flushed: its end frees nothing
    wire in_pkt = (st == S_LOAD_W) || (st == S_LOAD) || (st == S_PKT) || (st == S_PKT_TX);
    wire wpop = wpop_r && !w_orph;
    always @(posedge clk) begin
        if (!rstn) w_orph <= 1'b0;
        else if (flush[0]) w_orph <= in_pkt;
        else if (wpop_r) w_orph <= 1'b0;
        if (!rstn || flush[0]) begin
            // a packet being sent finishes, then is forgotten; until then its slot is still being read, so the
            // FIFO restarts at the slot after it (new works must not overwrite a packet on the wire)
            wwp <= (rstn && in_pkt) ? wr_addr[7:4] + 4'd1 : 4'd0;
            wrp <= (rstn && in_pkt) ? wr_addr[7:4] + 4'd1 : 4'd0;
            wcnt <= 5'd0;
        end else begin
            if (wpop) wrp <= wrp + 1'b1;
            if (work_push && wcnt != 5'd16) wwp <= wwp + 1'b1;
            wcnt <= wcnt + ((work_push && wcnt != 5'd16) ? 5'd1 : 5'd0) - (wpop ? 5'd1 : 5'd0);
        end
        if (!rstn || flush[1]) begin
            cwp <= 10'd0; crp <= 10'd0; ccnt <= 11'd0; ccommitted <= 11'd0;
        end else begin
            if (c_push) cwp <= cwp + 1'b1;
            if (c_pop) crp <= crp + 1'b1;
            ccnt <= ccnt + (c_push ? 11'd1 : 11'd0) - (c_pop ? 11'd1 : 11'd0);
            ccommitted <= ccommitted + (((cmd_commit || cmd_baud_we) && !c_full) ? 11'd1 : 11'd0)
                                     - (cmd_done ? 11'd1 : 11'd0);
        end
    end

    // ------------------------------------------------------------------ collector
    reg [55:0] win = 56'd0;
    reg [2:0]  wn = 3'd0;                 // bytes in the window (0..7)
    reg        chk = 1'b0;
    wire       ok5;
    hr_crc5_check u_c5 (.frame(win), .ok(ok5));
    reg        frame_ok = 1'b0;           // registered: the 51-bit CRC is too deep to decide on in the same clock
    reg        chk2 = 1'b0;
    always @(posedge clk) begin frame_ok <= ok5 && (win[7] || win[6:5] == 2'b00); chk2 <= chk; end
    reg        look = 1'b0, look2 = 1'b0; // a nonce waits two clocks for its job-table read
    reg [55:0] nwin = 56'd0;

    // register reply FIFO (64 x 48)
    reg [47:0] rmem [0:63];
    reg [5:0]  rwp = 6'd0, rrp = 6'd0;
    reg [6:0]  rcnt = 7'd0;
    wire       r_push = chk2 && frame_ok && !win[7] && rcnt != 7'd64;
    wire       r_pop = reg_ack && rcnt != 7'd0;
    always @(posedge clk) if (r_push) rmem[rwp] <= {win[23:16], win[15:8], win[55:24]};
    assign reg_valid = (rcnt != 7'd0);
    assign {r_chip, r_reg, r_value} = rmem[rrp];

    always @(posedge clk) begin
        chk <= 1'b0;
        look <= 1'b0;
        look2 <= look;
        if (nonce_ack) nonce_valid <= 1'b0;
        if (!rstn) begin
            wn <= 3'd0; nonce_valid <= 1'b0;
        end else begin
            if (rv) begin
                win <= {win[47:0], rd8};
                if (wn != 3'd7) wn <= wn + 1'b1;
                chk <= (wn >= 3'd6);
            end else if (chk2) begin
                if (frame_ok) begin
                    wn <= 3'd0;
                    c_frames <= c_frames + 1'b1;
                    if (win[7]) begin                       // nonce
                        jt_ra <= win[14:8];
                        nwin <= win;
                        look <= 1'b1;
                    end else if (rcnt == 7'd64) c_rxovf <= c_rxovf + 1'b1;
                end else begin
                    wn <= 3'd6;                             // drop the oldest byte, keep sliding
                    c_crcerr <= c_crcerr + 1'b1;
                end
            end
            if (look2) begin                                // jt_q holds the tags of this job id now
                if (nonce_valid && !nonce_ack) c_rxovf <= c_rxovf + 1'b1;
                else begin
                    nonce_valid <= 1'b1;
                    n_nonce <= nwin[55:24];
                    n_chip <= nwin[55:50];
                    n_jid <= nwin[14:8];
                    {n_tag, n_tag2} <= jt_q;
                    c_nonces <= c_nonces + 1'b1;
                end
            end
        end
    end
    always @(posedge clk) begin
        if (!rstn || flush[2]) begin rwp <= 6'd0; rrp <= 6'd0; rcnt <= 7'd0; end
        else begin
            if (r_push) rwp <= rwp + 1'b1;
            if (r_pop) rrp <= rrp + 1'b1;
            rcnt <= rcnt + (r_push ? 7'd1 : 7'd0) - (r_pop ? 7'd1 : 7'd0);
        end
    end

    assign stat = {14'd0, (wcnt == 5'd16), (st != S_IDLE), 3'd0, (ccommitted > 6'd31 ? 5'd31 : ccommitted[4:0]),
                   3'd0, wcnt};
endmodule
