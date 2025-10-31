`include "/Users/arjunpavanje/Documents/Github/Processor/FPU/FP_Adder/FPAdder.v"
module FPSub (
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] out
);
  FPAdder FP_subtraction (
      .B  (A),
      .A  (B ^ 64'h8000000000000000),
      .out(out)
  );
endmodule
