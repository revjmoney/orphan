`timescale 1ns / 1ps
// [orphan] MIMIK: the chip emulator. The I2C target bus engine: the FPGA answers as an I2C memory chip (24Cxx EEPROM
// family) or any register-file chip, at the chip's own speed, from a 32 KB image in block RAM.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
// The I2C bus state machine is Alex Forencich's i2c_slave.v (verilog-i2c, MIT licence, see NOTICE); this file adds
// the chip behaviour around it.
//
// Chip behaviour (24Cxx style, set by registers so most chips need no Verilog):
//   A write transaction: the first byte (two bytes when ABYTES2 is set) sets the word pointer; the next bytes are
//   stored at the pointer, which counts up inside its page (PAGE = page size - 1, it wraps like a real EEPROM page).
//   A read: bytes come from the pointer, which counts up through the whole chip (SIZE = size - 1, it wraps).
//   One-byte chips bigger than 256 bytes (24C04 / 08 / 16) take the high address bits from the device address:
//   the address bits outside DEVMASK pick the 256-byte block.
//   WP set: writes are acknowledged but not stored (like the chip's WP pin).
//   TWR: after a write, for TWR microseconds the chip does not answer its address (the real write cycle; drivers
//   poll for the ACK). 0 = no write cycle.
//
// Registers (word index, slot SLOT):
//   0 CTRL    [0] enable  [1] write protect  [2] two-byte word address  [4:3] register width (0 bytes: memory
//             chips; 1: 16-bit registers; 2: 32-bit)  [14:8] device address  [22:16] DEVMASK
//   1 SIZE    memory size - 1 (address mask, up to 32767)      2 PAGE   page size - 1 (address mask inside a page)
//   3 TWR     write cycle time in microseconds (0 = off)
//   4 STATUS  (read) [0] busy [1] addressed [2] bus active [3] write cycle running [14:8] the address on the bus
//             [31:16] events waiting
//   5 PTR     (read) the word pointer
//   6 EVENT   (read) take the oldest event: [31] 1 = an event was there  [30:28] kind  [22:8] address  [7:0] data
//             kinds: 1 addressed (address = the 7-bit bus address)  2 pointer set  3 byte written  4 byte read
//                    5 write blocked by WP
//   7 COUNTS  (read) [15:0] bytes read by the bus master  [31:16] bytes written (write 0 to clear)
//   8 MEMADDR (write) the ARM's image pointer (reads the byte there ahead)
//   9 MEMDATA read: the byte at MEMADDR, then MEMADDR + 1   write: store the byte at MEMADDR, then MEMADDR + 1
//   10 PINS   [5:0] SCL pin  [13:8] SDA pin: 0..35 = header pins (J1.5 J1.11 J1.12 J1.15, J2.5 .. J9.15),
//             36 / 37 = the board's own I2C bus SCL / SDA (pins 3 / 4 of J1..J8). Default 36 / 37.
//   11 RO     (write) [14:0] image address, [16] 1 = read-only for the bus master (writes ACKed, dropped, logged as 5)
//   127 ID    "MMK1"
// Register chips (register width 1 or 2, LM75 / TMP102 / BH1750 / MLX90614 style): the byte after the address picks a
// register; reads and writes then stream the bytes of that one register (image address = register * width + byte),
// wrapping inside it, and the pointer stays on that register.
// Pins are open drain: pins_low[p] = 1 pulls pin p low, else it floats (pull-ups on the target's bus).
module mimik_i2c #(parameter [3:0] SLOT = 4'd1, parameter integer NPINS = 38) (
    input  wire             clk,                // 100 MHz
    input  wire             rstn,
    input  wire [15:0]      bus_addr,
    input  wire [31:0]      bus_wdata,
    input  wire             bus_we,
    input  wire             bus_re,
    output reg  [31:0]      bus_rdata = 32'd0,
    input  wire [NPINS-1:0] pins_in,
    output wire [NPINS-1:0] pins_low,
    output wire             led_active
);
    reg [15:0] a_r = 16'd0;
    reg [31:0] wd = 32'd0;
    reg        we_r = 1'b0, re_r = 1'b0;
    always @(posedge clk) begin a_r <= bus_addr; wd <= bus_wdata; we_r <= bus_we; re_r <= bus_re; end
    wire sel = (a_r[15:12] == SLOT);
    wire [9:0] idx = a_r[11:2];
    wire wr = we_r && sel;
    wire rd = re_r && sel;

    // ---- settings
    reg        en = 1'b0, wp = 1'b0, ab2 = 1'b0;
    reg [1:0]  regw = 2'd0;            // register width: 0 = bytes (memory chips), 1 = 2 bytes, 2 = 4 bytes
    reg [6:0]  dev = 7'h50, devmask = 7'h7f;
    reg [14:0] size = 15'd255, page = 15'd7;
    reg [15:0] twr = 16'd0;
    reg [5:0]  scl_sel = 6'd36, sda_sel = 6'd37;
    always @(posedge clk) if (wr) begin
        if (idx == 10'd0) begin en <= wd[0]; wp <= wd[1]; ab2 <= wd[2]; regw <= (wd[4:3] == 2'd3) ? 2'd2 : wd[4:3];
                                dev <= wd[14:8]; devmask <= wd[22:16]; end
        if (idx == 10'd1) size <= wd[14:0];
        if (idx == 10'd2) page <= wd[14:0];
        if (idx == 10'd3) twr <= wd[15:0];
        if (idx == 10'd10) begin
            scl_sel <= (wd[5:0] >= NPINS) ? 6'd36 : wd[5:0];
            sda_sel <= (wd[13:8] >= NPINS) ? 6'd37 : wd[13:8];
        end
    end

    // ---- pins: two flip-flops on the chosen inputs, open-drain outputs on the chosen pins
    reg [1:0] scl_s = 2'b11, sda_s = 2'b11;
    always @(posedge clk) begin scl_s <= {scl_s[0], pins_in[scl_sel]}; sda_s <= {sda_s[0], pins_in[sda_sel]}; end
    wire scl_o, sda_o, scl_t, sda_t;
    genvar g;
    generate for (g = 0; g < NPINS; g = g + 1) begin : drv
        assign pins_low[g] = (scl_sel == g && !scl_o) || (sda_sel == g && !sda_o);
    end endgenerate

    // ---- the write cycle timer: the chip does not answer while it "programs"
    reg [6:0]  us_div = 7'd0;
    reg [15:0] twr_left = 16'd0;
    reg        twr_start = 1'b0;
    always @(posedge clk) begin
        us_div <= (us_div == 7'd99) ? 7'd0 : us_div + 1'b1;
        if (twr_start) twr_left <= twr;
        else if (us_div == 7'd99 && twr_left != 16'd0) twr_left <= twr_left - 1'b1;
    end

    // ---- the bus engine (Alex Forencich's i2c_slave)
    wire [7:0] m_data;
    wire       m_valid, m_last, s_ready;
    reg  [7:0] s_data = 8'd0;
    reg        s_valid = 1'b0;
    wire       busy, addressed, active;
    wire [6:0] bus_address;
    i2c_slave #(.FILTER_LEN(4)) u_i2c (
        .clk(clk), .rst(!rstn), .release_bus(1'b0),
        .s_axis_data_tdata(s_data), .s_axis_data_tvalid(s_valid), .s_axis_data_tready(s_ready),
        .s_axis_data_tlast(1'b0),
        .m_axis_data_tdata(m_data), .m_axis_data_tvalid(m_valid), .m_axis_data_tready(1'b1),
        .m_axis_data_tlast(m_last),
        .scl_i(scl_s[1]), .scl_o(scl_o), .scl_t(scl_t), .sda_i(sda_s[1]), .sda_o(sda_o), .sda_t(sda_t),
        .busy(busy), .bus_address(bus_address), .bus_addressed(addressed), .bus_active(active),
        .enable(en && twr_left == 16'd0), .device_address(dev), .device_address_mask(devmask));

    // ---- the image: 32 KB block RAM, one port shared by the bus side (first) and the ARM side
    reg [7:0]  mem [0:32767];
    reg [14:0] m_addr = 15'd0;
    reg [7:0]  m_wdat = 8'd0, m_q = 8'd0;
    reg        m_we = 1'b0;
    always @(posedge clk) begin
        if (m_we) mem[m_addr] <= m_wdat;
        m_q <= mem[m_addr];
    end

    // ---- read-only bits, one per image byte (a sensor's measurement and ID registers): the bus master's writes there
    //      are ACKed and dropped, like the real chip. Set by the ARM through RO (word 11).
    reg        ro_mem [0:32767];
    reg [14:0] ro_addr = 15'd0;
    reg        ro_q = 1'b0;
    // (block RAM starts at 0: every byte writable; the simulation bench clears it the same way)
    always @(posedge clk) begin
        if (wr && idx == 10'd11) ro_mem[wd[14:0]] <= wd[16];
        ro_q <= ro_mem[ro_addr];
    end

    // ---- events (a 512-deep FIFO the page drains)
    reg [31:0] ev [0:511];
    reg [8:0]  ev_w = 9'd0, ev_r = 9'd0;
    wire [8:0] ev_n = ev_w - ev_r;
    reg        ev_push = 1'b0;
    reg [31:0] ev_word = 32'd0;
    reg [31:0] ev_q = 32'd0;
    always @(posedge clk) begin
        if (ev_push && ev_n != 9'd511) begin ev[ev_w] <= ev_word; ev_w <= ev_w + 1'b1; end
        ev_q <= ev[ev_r];
        if (rd && idx == 10'd6 && ev_n != 9'd0) ev_r <= ev_r + 1'b1;
    end

    // ---- chip behaviour
    reg [14:0] ptr = 15'd0;
    reg [1:0]  acnt = 2'd0;           // address bytes seen in this write (0 = the next byte is the pointer)
    reg        wrote = 1'b0;          // data stored in this write (starts the write cycle at the end)
    reg [1:0]  rph = 2'd0;            // read: 0 idle, 1 address set, 2 data out of the RAM, 3 handed to the engine
    reg        addr_d = 1'b0;
    reg [15:0] n_rd = 16'd0, n_wr = 16'd0;
    reg [14:0] arm_ptr = 15'd0;
    reg [7:0]  arm_q = 8'd0, arm_wdat = 8'd0;
    reg        arm_wr_req = 1'b0, arm_rd_req = 1'b0;
    reg [1:0]  arm_ph = 2'd0;
    wire [14:0] blk = {5'd0, bus_address & ~devmask, 8'd0} & {15{!ab2}};
    wire [14:0] pnext = (ptr & ~page) | ((ptr + 1'b1) & page);
    // register chips: the pointer picks a register, the bytes of one access stream inside it (they wrap)
    reg  [1:0]  bi = 2'd0;
    wire [1:0]  bimask = (regw == 2'd0) ? 2'd0 : (regw == 2'd1) ? 2'd1 : 2'd3;
    wire [14:0] eff = ((regw == 2'd0) ? ptr : ((ptr << regw) | {13'd0, bi & bimask})) & size;
    reg  [1:0]  wph = 2'd0;            // a written byte: 1 = read-only bit being looked up, 2 = store it
    reg  [14:0] w_addr = 15'd0;
    reg  [7:0]  w_dat = 8'd0;

    always @(posedge clk) begin
        m_we <= 1'b0; ev_push <= 1'b0; twr_start <= 1'b0;
        addr_d <= addressed;
        if (wr && idx == 10'd7) begin n_rd <= 16'd0; n_wr <= 16'd0; end
        if (wr && idx == 10'd1) ptr <= 15'd0;           // a new chip size: the pointer starts at 0
        if (wr && idx == 10'd8) begin arm_ptr <= wd[14:0]; arm_rd_req <= 1'b1; end
        if (wr && idx == 10'd9) begin arm_wdat <= wd[7:0]; arm_wr_req <= 1'b1; end
        if (rd && idx == 10'd9) begin arm_ptr <= arm_ptr + 1'b1; arm_rd_req <= 1'b1; end
        if (!rstn) begin
            acnt <= 2'd0; rph <= 2'd0; s_valid <= 1'b0; wrote <= 1'b0;
        end else if (addressed && !addr_d) begin
            bi <= 2'd0;                                  // a new access starts at the register's first byte
            ev_push <= 1'b1; ev_word <= {1'b1, 3'd1, 5'd0, 8'd0, bus_address, 8'd0};
        end else if (m_valid) begin                     // a byte written by the bus master
            if (acnt == 2'd0 && regw != 2'd0) begin      // register chip: the byte is the register number
                ptr <= {7'd0, m_data}; acnt <= 2'd2; bi <= 2'd0;
                ev_push <= 1'b1; ev_word <= {1'b1, 3'd2, 5'd0, 7'd0, m_data, m_data};
            end else if (acnt == 2'd0 && !ab2) begin
                ptr <= (blk | {7'd0, m_data}) & size; acnt <= 2'd2;
                ev_push <= 1'b1; ev_word <= {1'b1, 3'd2, 5'd0, (blk | {7'd0, m_data}) & size, m_data};
            end else if (acnt == 2'd0) begin
                ptr <= {m_data[6:0], 8'd0}; acnt <= 2'd1;
            end else if (acnt == 2'd1) begin
                ptr <= (ptr | {7'd0, m_data}) & size; acnt <= 2'd2;
                ev_push <= 1'b1; ev_word <= {1'b1, 3'd2, 5'd0, (ptr | {7'd0, m_data}) & size, m_data};
            end else begin
                w_addr <= eff; w_dat <= m_data; ro_addr <= eff; wph <= 2'd1;   // stored once its RO bit is known
                if (regw != 2'd0) bi <= (bi + 1'b1) & bimask; else ptr <= pnext;
                n_wr <= n_wr + 1'b1;
                if (!wp) wrote <= 1'b1;
            end
            if (m_last) begin                            // the end of this write
                acnt <= 2'd0;
                if ((wrote || (acnt == 2'd2 && !wp)) && twr != 16'd0) twr_start <= 1'b1;
                wrote <= 1'b0;
            end
        end else if (wph == 2'd1) wph <= 2'd2;
        else if (wph == 2'd2) begin
            wph <= 2'd0;
            if (!wp && !ro_q) begin m_addr <= w_addr; m_wdat <= w_dat; m_we <= 1'b1; end
            ev_push <= 1'b1; ev_word <= {1'b1, (wp || ro_q) ? 3'd5 : 3'd3, 5'd0, w_addr, w_dat};
        end else if (rph == 2'd0 && s_ready && !s_valid) begin   // the engine wants the next byte to send
            m_addr <= eff; rph <= 2'd1;
        end else if (rph == 2'd1) rph <= 2'd2;                     // RAM reading
        else if (rph == 2'd2) begin
            s_data <= m_q; s_valid <= 1'b1; rph <= 2'd3;
            ev_push <= 1'b1; ev_word <= {1'b1, 3'd4, 5'd0, m_addr, m_q};
            if (regw != 2'd0) bi <= (bi + 1'b1) & bimask; else ptr <= ((ptr & size) + 1'b1) & size;
            n_rd <= n_rd + 1'b1;
        end else if (rph == 2'd3) begin
            if (s_ready && s_valid) begin s_valid <= 1'b0; rph <= 2'd0; end
            if (!busy) begin s_valid <= 1'b0; rph <= 2'd0; end
        end else if (arm_wr_req) begin                   // the ARM side gets the RAM when the bus side is quiet
            m_addr <= arm_ptr; m_wdat <= arm_wdat; m_we <= 1'b1; arm_wr_req <= 1'b0;
            arm_ptr <= arm_ptr + 1'b1; arm_rd_req <= 1'b1;
        end else if (arm_rd_req && arm_ph == 2'd0) begin
            m_addr <= arm_ptr; arm_ph <= 2'd1;
        end else if (arm_ph == 2'd1) arm_ph <= 2'd2;                // RAM reading
        else if (arm_ph == 2'd2) begin
            arm_ph <= 2'd0;
            if (m_addr == arm_ptr) begin arm_q <= m_q; arm_rd_req <= 1'b0; end   // else again (the bus used it)
        end
        if (!busy && rph != 2'd0 && !s_ready) begin rph <= 2'd0; s_valid <= 1'b0; end
    end

    // ---- register reads
    always @(posedge clk) begin
        bus_rdata <= 32'd0;
        if (re_r && sel) case (idx)
            10'd0:   bus_rdata <= {9'd0, devmask, 1'b0, dev, 3'd0, regw, ab2, wp, en};
            10'd1:   bus_rdata <= {17'd0, size};
            10'd2:   bus_rdata <= {17'd0, page};
            10'd3:   bus_rdata <= {16'd0, twr};
            10'd4:   bus_rdata <= {7'd0, ev_n, 1'b0, bus_address, 4'd0, twr_left != 16'd0, active, addressed, busy};
            10'd5:   bus_rdata <= {17'd0, ptr};
            10'd6:   bus_rdata <= (ev_n != 9'd0) ? ev_q : 32'd0;
            10'd7:   bus_rdata <= {n_wr, n_rd};
            10'd8:   bus_rdata <= {17'd0, arm_ptr};
            10'd9:   bus_rdata <= {24'd0, arm_q};
            10'd10:  bus_rdata <= {18'd0, sda_sel, 2'd0, scl_sel};
            10'd127: bus_rdata <= "MMK1";
            default: ;
        endcase
    end
    assign led_active = addressed;
endmodule
