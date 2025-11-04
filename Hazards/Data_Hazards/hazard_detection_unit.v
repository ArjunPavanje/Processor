module hazard_detection_unit (
    input [5:0] rs1_IF_ID,
    input [5:0] rs2_IF_ID,
    input [5:0] rd_ID_EX,
    input mem_read_ID_EX,
    input clk,
    input rst,
    output reg stall
);

  reg reg_eq_A;
  reg reg_eq_B;
  reg to_stall;
  reg curr_stage;

  always @(posedge clk) begin
    if (rst) begin
      stall <= 1'b0;
    end else begin
      stall <= to_stall;
      curr_stage <= to_stall;
    end
  end

  always @(*) begin
    reg_eq_A = (rd_ID_EX == rs1_IF_ID);
    reg_eq_B = (rd_ID_EX == rs2_IF_ID);

    to_stall = (curr_stage) ? (1'b0) : ( (mem_read_ID_EX) ? (((reg_eq_A) | (reg_eq_B)) ? (1'b1) : (1'b0)) : (1'b0));
  end

endmodule
