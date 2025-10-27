//`include "shift/shift.v"
//`include "addsub/addsub.v"
//`include "mul/mul.v"

module FPMul (
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


  wire [63:0] temp1;
  wire [63:0] temp2;
  assign temp1 = {12'b1, M_1};
  assign temp2 = {12'b1, M_2};


  // Adding exponnts E_1, E_2
  wire [63:0] exponent_1 = {53'b0, E_1} + {53'b0, E_2};
  wire cout1;
  wire cout2;
  wire [63:0] exponent_2 = exponent_1 - 64'd1023;

  /*
  addsub FPmul_exponent_sum (
      .a({53'b0, E_1}),
      .b({53'b0, E_2}),
      .sel(1'b0),
      .res(exponent_1),
      .cout(cout1)
  );
  */
  // Then subtracting bias
  /*
  addsub FPmul_exponent_bias (
      .a({exponent_1}),
      .b({64'd1023}),
      .sel(1'b1),
      .res(exponent_2),
      .cout(cout2)
  );
  */


  // Multiplying mantissas M_1 and M_2
  wire [127:0] mantissa_product = {64'b0, 12'b1, M_1} * {64'b0, 12'b1, M_2};
  /*
  mul FPmul_mantissa (
      .a({12'b1, M_1}),
      .b({12'b1, M_2}),
      .sign(1'b0),
      .res(mantissa_product)
  );
  */
  // Normalizing mantissa
  wire [52:0] mantissa_normalized;
  wire L;
  wire G;
  wire R;
  wire S;
  wire round;

  // Also setting LSB, Guard, Round, Sticky bits
  assign mantissa_normalized = (mantissa_product[105])?mantissa_product[105:53]:mantissa_product[104:52];
  assign L = (mantissa_product[105]) ? mantissa_product[53] : mantissa_product[52];
  assign G = (mantissa_product[105]) ? mantissa_product[52] : mantissa_product[51];
  assign R = (mantissa_product[105]) ? mantissa_product[51] : mantissa_product[50];
  assign S = (mantissa_product[105]) ? |mantissa_product[50:0] : |mantissa_product[49:0];

  // Updating exponent (if needed) after normalizing
  wire [63:0] exponent_3 = exponent_2 + (mantissa_product[105] ? 64'b1 : 64'b0);
  wire cout3;
  /*
  addsub FPmul_exponent_norm (
      .a(exponent_2),
      .b(mantissa_product[105] ? 64'b1 : 64'b0),
      .sel(1'b0),
      .res(exponent_3),
      .cout(cout3)
  );
  */

  assign round = (G & (R | S)) | (L & G & (~R) & (~S));
  wire [64:0] mantissa_rounded_cout = {12'b0, mantissa_normalized} + (round ? 65'b1 : 65'b0);
  wire [63:0] mantissa_rounded = mantissa_rounded_cout[63:0];
  wire cout = mantissa_rounded_cout[64];
  /*
  addsub FPmul_round (
      .a({11'b0, mantissa_normalized}),
      .b((round) ? {63'b0, 1'b1} : {63'b0, 1'b0}),
      .sel(1'b0),
      .cout(cout),
      .res(mantissa_rounded)
  );
  */

  wire [51:0] mantissa_renormalized;
  wire [63:0] exponent_4 = exponent_3 + ((cout) ? 64'b1 : 64'b0);
  wire cout4;

  /*
  addsub FPmul_exponent_renorm (
      .a(exponent_3),
      .b((cout) ? 64'b1 : 64'b0),
      .sel(1'b0),
      .res(exponent_4),
      .cout(cout4)
  );*/

  assign mantissa_renormalized = (cout) ? mantissa_rounded[52:1] : mantissa_rounded[51:0];
  assign out[51:0] = mantissa_renormalized;
  assign out[62:52] = exponent_4[10:0];
  assign out[63] = S_1 ^ S_2;

endmodule
