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

    input wire [2:0] fpu_op,

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
      3'b000: out = sum;
      3'b001: out = difference;
      3'b010: out = product;
      3'b011: out = quotient;
      3'b100: out = sqrt;
      3'b101: out = fcvt_ld;
      3'b110: out = fcvt_dl;
    endcase
  end

endmodule
