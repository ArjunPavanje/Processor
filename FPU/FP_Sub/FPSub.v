`include "FPAdder.v"
module FPSub (
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] out
);
  FPAdder FP_subtraction (
      .A  (A),
      .B  (B ^ 64'h8000000000000000),
      .out(out)
  );
endmodule
