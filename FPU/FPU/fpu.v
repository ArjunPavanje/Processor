module FPU #(
    parameter BUS_WIDTH = 64,
    parameter OP_LEN = 5
) (
    input wire [BUS_WIDTH-1:0] in1,
    input wire [BUS_WIDTH-1:0] in2,

    input wire [OP_LEN-1:0] fpu_op,

    //output reg fpu_rd,
    //output reg fpu_rs1,
    output reg [BUS_WIDTH-1:0] out
);

  wire [BUS_WIDTH-1:0] sum_d;
  wire [BUS_WIDTH-1:0] difference_d;
  wire [BUS_WIDTH-1:0] product_d;
  wire [BUS_WIDTH-1:0] quotient_d;
  wire [BUS_WIDTH-1:0] sqrt_d;
  wire [BUS_WIDTH-1:0] fcvt_ld;
  wire [BUS_WIDTH-1:0] fcvt_dl;

  wire [BUS_WIDTH-1:0] sum_s;
  wire [BUS_WIDTH-1:0] difference_s;
  wire [BUS_WIDTH-1:0] product_s;
  wire [BUS_WIDTH-1:0] quotient_s;
  wire [BUS_WIDTH-1:0] sqrt_s;

  FPAdder #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_addition_d (
      .in1(in1),
      .in2(in2),
      .out(sum_d)
  );
  FPSub #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_subtraction_d (
      .in1(in1),
      .in2(in2),
      .out(difference_d)
  );
  FPMul #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_multiplication_d (
      .in1(in1),
      .in2(in2),
      .out(product_d)
  );
  FPDiv #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_division_d (
      .in1(in1),
      .in2(in2),
      .out(quotient_d)
  );
  FSQRT #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_sqrt_d (
      .in1(in1),
      .out(sqrt_d)
  );
  FCVT_int #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_ld (
      .in1(in1),
      .out(fcvt_ld)
  );
  FCVT_fp #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_dl (
      .in1(in1),
      .out(fcvt_dl)
  );
  FPAdder #(
      .BUS_WIDTH(32)
  ) fp_addition_s (
      .in1(in1),
      .in2(in2),
      .out(sum_s)
  );
  FPSub #(
      .BUS_WIDTH(32)
  ) fp_subtraction_s (
      .in1(in1),
      .in2(in2),
      .out(difference_s)
  );
  FPMul #(
      .BUS_WIDTH(32)
  ) fp_multiplication_s (
      .in1(in1),
      .in2(in2),
      .out(product_s)
  );
  FPDiv #(
      .BUS_WIDTH(32)
  ) fp_division_s (
      .in1(in1),
      .in2(in2),
      .out(quotient_s)
  );
  FSQRT #(
      .BUS_WIDTH(32)
  ) fp_sqrt_s (
      .in1(in1),
      .out(sqrt_s)
  );

  always @(*) begin
    case (fpu_op)
      5'b00000: begin
        out = sum_d;
        //fpu_rd = 1;
        //fpu_rs1 = 1;
      end
      5'b00001: begin
        out = difference_d;
        //fpu_rd = 1;
        //fpu_rs1 = 1;
      end
      5'b00010: begin
        out = product_d;
        //fpu_rs1 = 1;
        //fpu_rd = 1;
      end
      5'b00011: begin
        out = quotient_d;
        //fpu_rd = 1;
        //fpu_rs1 = 1;
      end
      5'b00100: begin
        out = sqrt_d;
        //fpu_rd = 1;
        //fpu_rs1 = 1;
      end
      5'b00101: begin
        out = fcvt_ld;
        //fpu_rd = 0;
        //fpu_rs1 = 1;
      end
      5'b00110: begin
        out = fcvt_dl;
        // fpu_rd = 1;
        // fpu_rs1 = 0;
      end
      5'b00111: begin
        // fmv.x.d
        out = in1;
        // fpu_rd = 0;
        // fpu_rs1 = 1;
      end
      5'b01000: begin
        out = in1;
        // fpu_rd = 1;
        // fpu_rs1 = 0;
      end
      5'b01001: begin
        out = sum_s;
      end
      5'b01010: begin
        out = difference_s;
      end
      5'b01011: begin
        out = product_s;
      end
      5'b01100: begin
        out = quotient_s;
      end
      5'b01101: begin
        out = sqrt_s;
      end
    endcase
  end

endmodule
