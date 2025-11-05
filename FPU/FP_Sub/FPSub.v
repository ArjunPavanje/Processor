`include "/Users/arjunpavanje/Documents/Github/Processor/FPU/FP_Adder/FPAdder.v"
module FPSub #(
    parameter BUS_WIDTH = 64
) (
    input  [BUS_WIDTH-1:0] A,
    input  [BUS_WIDTH-1:0] B,
    output [BUS_WIDTH-1:0] out
);
  localparam NEGATE = (BUS_WIDTH == 64) ? 64'h8000000000000000 : 32'h80000000;
  FPAdder #(
      .BUS_WIDTH(BUS_WIDTH)
  ) FP_subtraction (
      .B  (A),
      .A  (B ^ NEGATE),
      .out(out)
  );
endmodule
