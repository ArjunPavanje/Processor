module FPDiv (
    input  [63:0] in1,
    input  [63:0] in2,
    output [63:0] out
);

  // Extracting Sign, Exponent, Mantissa
  wire [51:0] M_1;
  wire [51:0] M_2;
  wire [10:0] E_1;
  wire [10:0] E_2;
  wire S_1;
  wire S_2;
  assign M_1 = in1[51:0];
  assign M_2 = in2[51:0];

  assign E_1 = in1[62:52];
  assign E_2 = in2[62:52];

  assign S_1 = in1[63];
  assign S_2 = in2[63];

  // Subtracting exponnts E_1, E_2 then adding bias
  wire [ 11:0] exponent_1 = E_1 - E_2;
  wire [ 11:0] exponent_2 = exponent_1 + 10'd1023;


  // Dividing M_1 and M_2
  wire [127:0] mantissa_product;
  assign mantissa_product = (({12'b1, M_1}) << 52) / ({12'b1, M_2});

  // Normalizing mantissa, updating exponent (if needed)
  wire [63:0] mantissa_normalized;
  wire round;
  wire [11:0] exponent_3;

  mantissa_normalize FPdiv_normalize (
      .mantissa_product(mantissa_product),
      .exponent_init(exponent_2),
      .mantissa_normalized(mantissa_normalized),
      .round(round),
      .exponent_modified(exponent_3)
  );

  // Rounding
  wire [52:0] mantissa_normalized_shifted;
  assign mantissa_normalized_shifted = mantissa_normalized[52:0];
  wire [63:0] mantissa_rounded = mantissa_normalized + ((round) ? (64'b1) : (64'b0));

  // Renormalizing
  wire [51:0] mantissa_renormalized = (mantissa_rounded[53]) ? mantissa_rounded[52:1] : mantissa_rounded[51:0];
  // Updating exponent (if needed) after normalizing
  wire [11:0] exponent_4 = exponent_3 + ((mantissa_rounded[53]) ? 12'b1 : 12'b0);


  // Checking exponent overflow
  wire exp_overflow = (exponent_4 >= 12'd2047);
  wire exp_underflow = exponent_4[11] | (exponent_4 == 12'b0);

  // Checking A, B for infinities
  wire is_inf_1 = (E_1 == 11'h7FF) && (|M_1 == 1'b0);
  wire is_inf_2 = (E_2 == 11'h7FF) && (|M_2 == 1'b0);


  //wire is_inf = ((is_inf_1 | is_inf_2) & !is_NaN) | exp_overflow;


  //wire is_NaN = (is_inf_1 & is_inf_2);
  wire is_NaN = (is_inf_1 & is_inf_2) | (~(|E_1) & ~(|E_2));


  //wire is_inf = ~is_NaN & ((is_inf_1 | (|M_2)) | exp_overflow);
  wire is_inf = ~is_NaN & (is_inf_1 | ~(|in2[62:0]) | exp_overflow);


  //(is_inf_1 & |E_2) | (is_inf_2 & |E_1);  // 0 * infinity
  // Checking for multiplication by 0

  //wire is_zero = ~is_NaN & (is_inf_2 | (|M_1) | exp_underflow);

  //wire is_zero = ~is_NaN & (~(|in1[62:0]) | exp_underflow);
  wire is_zero = ~is_NaN & (~(|in1[62:0]) & (|in2[62:0]));
  //(~(|E_1)) | (~(|E_2)) | exp_underflow;


  wire [63:0] out_1 = {S_1 ^ S_2, exponent_4[10:0], mantissa_renormalized};

  wire [63:0] out_2 = 64'h7ff8000000000000;  // NaN
  wire [63:0] out_3 = (S_1 ^ S_2) ? 64'hFFF0000000000000 : 64'h7FF0000000000000;
  //(is_inf_1)?((S_1)?(64'hFFF0000000000000):(64'h7FF0000000000000)):((is_inf_2)?((S_2)?(64'hFFF0000000000000):(64'h7FF0000000000000)):(64'b1));  // infinity


  assign out = (is_zero) ? (64'b0) : ((is_NaN) ? (out_2) : ((is_inf) ? (out_3) : (out_1)));
  /*
  // Final values of mantissa. exponent
  assign out[51:0] = mantissa_renormalized;
  assign out[62:52] = exponent_4;
  assign out[63] = S_1 ^ S_2;
  */

endmodule
