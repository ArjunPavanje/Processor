`include "/Users/arjunpavanje/Documents/Github/Processor/FPU/FP_Divider/FPDiv.v"
`include "/Users/arjunpavanje/Documents/Github/Processor/FPU/FSQRT/quake3.v"

module FSQRT (
    input  [63:0] x,
    output [63:0] y
);
  wire [63:0] y_1;
  wire [63:0] quotient;
  FPDiv FSQRT_div (
      .N1 (64'h3ff0000000000000),
      .N2 (x),
      .out(quotient)
  );
  quake3 FSQRT_quake (
      .x(quotient),
      .y(y_1)
  );
  wire is_underflow = (y_1[62:52] == 11'b0) & (|y_1[51:0]);
  wire is_inf = (x == 64'h7ff0000000000000);
  wire is_zero = ~(|x[62:0]) | is_underflow;
  wire is_neg = x[63];

  assign y = (is_neg)?(64'h7ff8000000000000):(is_zero?(64'b0):(is_inf?(64'h7ff0000000000000):(y_1)));

endmodule
