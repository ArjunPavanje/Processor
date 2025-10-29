module FPSub (
    input  [63:0] in1,
    input  [63:0] in2,
    output [63:0] out
);
  FPAdder FP_subtraction (
      .in1(in1),
      .in2(in2 ^ 64'h8000000000000000),
      .out(out)
  );
endmodule
