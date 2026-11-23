`timescale 1ns / 1ps
// MIMIK simulation bench (Icarus, through tb_run.v): Ardzy's I2C master (ardzy_i2c, slot 2) and the MIMIK I2C target (slot 1)
// on one open-drain bus with pull-ups, driven by a script of register reads / writes (prog.hex, made by
// test_i2c.py). Every scripted read is shown on log_v / log_d for the checker.
//   script word pairs: {op[31:28], addr[15:0]} then data.  op 1 write, 2 read (to the log), 3 wait for the
//   I2C master to finish its queue, 4 wait <data> clocks, 0 end.
module tb_mimik (
    input  wire        clk,
    output reg         log_v = 1'b0,
    output reg  [31:0] log_d = 32'd0,
    output reg         done = 1'b0
);
    reg [3:0] rc = 4'd0;
    always @(posedge clk) if (rc != 4'd15) rc <= rc + 1'b1;
    wire rstn = (rc == 4'd15);

    reg  [15:0] addr = 16'd0;
    reg  [31:0] wdata = 32'd0;
    reg         we = 1'b0, re = 1'b0;
    wire [31:0] rd_m, rd_t;
    wire        m_scl_low, m_sda_low;
    wire [37:0] t_low;
    wire        scl = !(m_scl_low | t_low[36]);           // the wired-AND bus with its pull-ups
    wire        sda = !(m_sda_low | t_low[37]);
    wire        led;

    ardzy_i2c #(.SLOT(2)) u_m (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_m),
        .scl_low(m_scl_low), .sda_low(m_sda_low), .scl_in(scl), .sda_in(sda));
    mimik_i2c #(.SLOT(1)) u_t (
        .clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rd_t),
        .pins_in({sda, scl, 36'hfffffffff}), .pins_low(t_low), .led_active(led));

    reg [31:0] prog [0:4095];
    initial $readmemh("prog.hex", prog);
    reg [11:0] pc = 12'd0;
    reg [3:0]  ph = 4'd0;
    reg [31:0] cnt = 32'd0, acc = 32'd0;
    wire [31:0] op = prog[pc], arg = prog[pc + 1'b1];
    always @(posedge clk) begin
        we <= 1'b0; re <= 1'b0; log_v <= 1'b0;
        if (rstn && !done) case (op[31:28])
            4'd0: done <= 1'b1;
            4'd1: if (ph == 4'd0) begin addr <= op[15:0]; wdata <= arg; we <= 1'b1; ph <= 4'd1; end
                  else if (ph == 4'd4) begin ph <= 4'd0; pc <= pc + 2'd2; end
                  else ph <= ph + 1'b1;
            4'd2: if (ph == 4'd0) begin addr <= op[15:0]; re <= 1'b1; ph <= 4'd1; end
                  else if (ph == 4'd5) begin log_v <= 1'b1; log_d <= acc; ph <= 4'd0; pc <= pc + 2'd2; end
                  else begin ph <= ph + 1'b1; acc <= (ph == 4'd1) ? 32'd0 : acc | rd_m | rd_t; end   // data in ph 2..4
            4'd3: if (ph == 4'd0) begin addr <= 16'h2008; re <= 1'b1; ph <= 4'd1; end      // master STATUS
                  else if (ph == 4'd4) begin
                      if (!rd_m[16] && rd_m[4:0] == 5'd0) pc <= pc + 2'd2;
                      ph <= 4'd0;
                  end else ph <= ph + 1'b1;
            4'd4: if (cnt >= arg) begin cnt <= 32'd0; pc <= pc + 2'd2; end else cnt <= cnt + 1'b1;
            default: done <= 1'b1;
        endcase
    end
endmodule
