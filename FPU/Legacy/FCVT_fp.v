module FCVT_fp (
    input  [63:0] in,
    output [63:0] out
);
  // Checking sign
  wire S = in[63];
  wire [63:0] mod = (S) ? (~in + 64'b1) : in;

  // Finding leading 1
  wire [10:0] index;

  leading_1 FCVT (
      .num  (mod),
      .index(index)
  );

  wire [10:0] idex = (|mod) ? (index) : (11'd0);
  wire [10:0] E = idex + 11'd1023;
  wire [63:0] mantissa_shifted = mod << (11'd63 - index);
  wire [51:0] M = (|mod) ? mantissa_shifted[62:11] : 52'd0;

  wire is_zero = ~|in[63:0];
  assign out = (is_zero) ? (64'd0) : ({S, E, M});

endmodule
