module FSQRT (
    input  [63:0] in,
    output [63:0] out
);
  wire [63:0] y_1;
  wire [63:0] quotient;
  FPDiv FSQRT_div (
      .in1(64'h3ff0000000000000),
      .in2(in),
      .out(quotient)
  );
  quake3 FSQRT_quake (
      .x(quotient),
      .y(y_1)
  );
  wire is_underflow = (y_1[62:52] == 11'b0) & (|y_1[51:0]);
  wire is_inf = (in == 64'h7ff0000000000000);
  wire is_zero = ~(|in[62:0]) | is_underflow;
  wire is_neg = in[63];

  assign out = (is_neg)?(64'h7ff8000000000000):(is_zero?(64'b0):(is_inf?(64'h7ff0000000000000):(y_1)));

endmodule
