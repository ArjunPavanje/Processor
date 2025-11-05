module FCVT_int (
    input  [63:0] in,
    output [63:0] out
);

  wire [51:0] M = in[51:0];
  wire [10:0] E = in[62:52];
  wire S = in[63];

  wire [11:0] exponent = {1'b0, E} - 12'd1023;

  //wire too_large = |exponent[11:6];

  wire too_large = (exponent[11] == 0) && (|exponent[10:6]);
  wire [63:0] overflow = (S) ? 64'h8000000000000000 : 64'h7fffffffffffffff;

  wire neg_exp = exponent[11];

  wire [63:0] mantissa = {12'd1, M};  // 64-bit mantissa with leading 1

  // Shift left if exponent >= 52, else shift right
  wire [63:0] num_shifted_left = mantissa << (exponent[5:0] - 6'd52);
  wire [63:0] num_shifted_right = mantissa >> (6'd52 - exponent[5:0]);


  // Choose left/right shift without comparisons
  wire shift_left = (exponent[11] == 0) & (exponent[5:0] >= 6'd52);
  wire [63:0] num = exponent[11] ? 64'd0 :  // exponent negative → value <1 → truncate to 0
  shift_left ? num_shifted_left :  // exponent > 63 → use left shift (overflow handled naturally)
  num_shifted_right;

  wire is_inf = (E == 11'h7FF) & (~|M);
  wire is_NaN = (E == 11'h7FF) & (|M);
  wire is_zero = (E == 11'd0) && (M == 52'd0);

  assign out = (is_NaN)?(64'd0):((is_zero)?(64'd0):((is_inf) ? (overflow) : ((too_large) ? (overflow) : (S ? (~num + 64'b1) : num))));

endmodule
