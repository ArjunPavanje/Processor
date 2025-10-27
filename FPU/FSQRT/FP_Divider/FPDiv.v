`include "FP_Divider/normalize.v"

module FPDiv (
    input  [63:0] N1,
    input  [63:0] N2,
    output [63:0] out
);

  // Extracting Sign, Exponent, Mantissa
  wire [51:0] M_1;
  wire [51:0] M_2;
  wire [10:0] E_1;
  wire [10:0] E_2;
  wire S_1;
  wire S_2;
  assign M_1 = N1[51:0];
  assign M_2 = N2[51:0];

  assign E_1 = N1[62:52];
  assign E_2 = N2[62:52];

  assign S_1 = N1[63];
  assign S_2 = N2[63];

  // Subtracting exponnts E_1, E_2 then adding bias
  wire [ 10:0] exponent_1 = E_1 - E_2;
  wire [ 10:0] exponent_2 = exponent_1 + 10'd1023;


  // Dividing M_1 and M_2
  wire [127:0] mantissa_product;
  assign mantissa_product = (({12'b1, M_1}) << 52) / ({12'b1, M_2});

  // Normalizing mantissa, updating exponent (if needed)
  wire [63:0] mantissa_normalized;
  wire round;
  wire [10:0] exponent_3;

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
  wire [10:0] exponent_4 = exponent_3 + ((mantissa_rounded[53]) ? 11'b1 : 11'b0);

  // Final values of mantissa. exponent
  assign out[51:0] = mantissa_renormalized;
  assign out[62:52] = exponent_4;
  assign out[63] = S_1 ^ S_2;

endmodule
