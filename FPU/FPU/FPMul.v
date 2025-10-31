module FPMul (
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


  wire [63:0] temp1 = {11'b0, |E_1, M_1};
  wire [63:0] temp2 = {11'b0, |E_2, M_2};


  // Adding exponnts E_1, E_2 and subtracting bias
  wire [63:0] exponent_1 = {53'b0, E_1} + {53'b0, E_2};
  wire [63:0] exponent_2 = exponent_1 - 64'd1023;

  // Multiplying mantissas M_1 and M_2
  wire [127:0] mantissa_product = {64'b0, 11'b0, |E_1, M_1} * {64'b0, 11'b0, |E_2, M_2};

  // Normalizing mantissa (LSB, Guard, Round, Sticky)
  // Round to nearest even has been followed
  // Also setting LSB, Guard, Round, Sticky bits
  wire [52:0] mantissa_normalized = (mantissa_product[105])?mantissa_product[105:53]:mantissa_product[104:52];
  wire L = (mantissa_product[105]) ? mantissa_product[53] : mantissa_product[52];
  wire G = (mantissa_product[105]) ? mantissa_product[52] : mantissa_product[51];
  wire R = (mantissa_product[105]) ? mantissa_product[51] : mantissa_product[50];
  wire S = (mantissa_product[105]) ? |mantissa_product[50:0] : |mantissa_product[49:0];

  // Updating exponent (if needed) after normalizing
  wire [63:0] exponent_3 = exponent_2 + (mantissa_product[105] ? 64'b1 : 64'b0);

  // To add up or not to reach nearest even

  //wire round = (G & (R | S)) | (L & G & (~R) & (~S));
  wire round = G & (L | R | S);


  wire [64:0] mantissa_rounded_cout = {12'b0, mantissa_normalized} + (round ? 65'b1 : 65'b0);

  // Renormalizing
  wire [63:0] mantissa_rounded = mantissa_rounded_cout[63:0];
  wire cout = mantissa_rounded_cout[64];
  // Updating exponent value after renormalizing
  wire [63:0] exponent_4 = exponent_3 + ((cout) ? 64'b1 : 64'b0);
  wire [51:0] mantissa_renormalized = (cout) ? mantissa_rounded[52:1] : mantissa_rounded[51:0];

  // Checking exponent overflow
  //wire exp_overflow = (exponent_4 >= 12'd2047);
  wire exp_overflow = (exponent_4[10:0] >= 11'd2047) & ~exponent_4[63];

  wire exp_underflow = exponent_4[63];

  // Checking A, B for infinities
  wire is_inf_1 = (E_1 == 11'h7FF) && (|M_1 == 1'b0);
  wire is_inf_2 = (E_2 == 11'h7FF) && (|M_2 == 1'b0);


  wire is_inf = ((is_inf_1 | is_inf_2) & !is_NaN) | exp_overflow;
  wire is_NaN = (is_inf_1 & |E_2) | (is_inf_2 & |E_1);  // 0 * infinity
  // Checking for multiplication by 0
  wire is_zero = (~(|E_1)) | (~(|E_2)) | exp_underflow;


  wire [63:0] out_1 = {S_1 ^ S_2, exponent_4[10:0], mantissa_renormalized};

  wire [63:0] out_2 = 64'h7ff8000000000000;  // NaN
  //wire [63:0] out_3 = (is_inf_1)?((S_1)?(64'hFFF0000000000000):(64'h7FF0000000000000)):((is_inf_2)?((S_2)?(64'hFFF0000000000000):(64'h7FF0000000000000)):(64'b1));  // infinity
  wire [63:0] out_3 = {S_1 ^ S_2, 11'h7FF, 52'h0};


  assign out = (is_zero) ? (64'b0) : ((is_NaN) ? (out_2) : ((is_inf) ? (out_3) : (out_1)));

  /*
  // Final exponent and mantissa values
  assign out[51:0] = mantissa_renormalized;
  assign out[62:52] = exponent_4[10:0];
  assign out[63] = S_1 ^ S_2;
  */

endmodule
