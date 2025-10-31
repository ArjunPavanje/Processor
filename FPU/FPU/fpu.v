/*
`include "../FP_Adder/FPAdder.v"
`include "../FP_Sub/FPSub.v"
`include "../FP_Mul/FPMul.v"
`include "../FP_Divider/FPDiv.v"
`include "../FSQRT/FSQRT.v"
`include "../FCVT/tofp/FCVT_fp.v"
`include "../FCVT/toint/FCVT_int.v"
*/

module FPU (
    input wire [63:0] in1,
    input wire [63:0] in2,

    input wire [4:0] fpu_op,

    output reg fpu_rd,
    output reg fpu_rs1,
    output reg [63:0] out
);

  wire [63:0] sum;
  wire [63:0] difference;
  wire [63:0] product;
  wire [63:0] quotient;
  wire [63:0] sqrt;
  wire [63:0] fcvt_ld;
  wire [63:0] fcvt_dl;

  FPAdder fp_addition (
      .in1(in1),
      .in2(in2),
      .out(sum)
  );
  FPSub fp_subtraction (
      .in1(in1),
      .in2(in2),
      .out(difference)
  );
  FPMul fp_multiplication (
      .in1(in1),
      .in2(in2),
      .out(product)
  );
  FPDiv fp_division (
      .in1(in1),
      .in2(in2),
      .out(quotient)
  );
  FSQRT fp_sqrt (
      .in (in1),
      .out(sqrt)
  );
  FCVT_int fp_ld (
      .in (in1),
      .out(fcvt_ld)
  );
  FCVT_fp fp_dl (
      .in (in1),
      .out(fcvt_dl)
  );

  always @(*) begin
    case (fpu_op)
      5'b00000: begin
        out = sum;
        fpu_rd = 1;
        fpu_rs1 = 1;
      end
      5'b00001: begin
        out = difference;
        fpu_rd = 1;
        fpu_rs1 = 1;
      end
      5'b00010: begin
        out = product;
        fpu_rs1 = 1;
        fpu_rd = 1;
      end
      5'b00011: begin
        out = quotient;
        fpu_rd = 1;
        fpu_rs1 = 1;
      end
      5'b00100: begin
        out = sqrt;
        fpu_rd = 1;
        fpu_rs1 = 1;
      end
      5'b00101: begin
        out = fcvt_ld;
        fpu_rd = 0;
        fpu_rs1 = 1;
      end
      5'b00110: begin
        out = fcvt_dl;
        fpu_rd = 1;
        fpu_rs1 = 0;
      end
      5'b00111: begin
        // fmv.x.d
        out = in1;
        fpu_rd = 0;
        fpu_rs1 = 1;
      end
      5'b01000: begin
        out = in1;
        fpu_rd = 1;
        fpu_rs1 = 0;
      end
    endcase
  end

endmodule
