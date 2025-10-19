`include "shift/shift.v"
`include "addsub/addsub.v"

module FPAdder1 (
    input  [63:0] A,
    input  [63:0] B,
    output [51:0] out
);

  // Extracting Sign, Exponent, Mantissa
  wire [51:0] M_A;
  wire [51:0] M_B;
  wire [10:0] E_A;
  wire [10:0] E_B;
  wire S_A;
  wire S_B;
  assign M_A = A[51:0];
  assign M_B = B[51:0];

  assign E_A = A[62:52];
  assign E_B = B[62:52];

  assign S_A = A[63];
  assign S_B = B[63];

  wire [10:0] result1;
  wire [10:0] result2;
  wire cout;
  wire sel;
  wire cout1;
  wire cout2;
  wire cntrl;
  wire [10:0] shift_amt;
  assign sel = 1'b1;

  addsub diff_AB (
      .a(E_A),
      .b(E_B),
      .sel(sel),
      .res(result1),
      .cout(cout)
  );
  addsub diff_BA (
      .a(E_B),
      .b(E_A),
      .sel(sel),
      .res(result2),
      .cout(cout1)
  );
  assign cntrl = result1[10];

  // Find amount to right shift by
  assign shift_amt = (cntrl) ? result2 : result1;

  // Find the smaller number
  wire [51:0] M_small;
  wire [51:0] M_large;
  assign M_small = (cntrl) ? M_B : M_A;
  assign M_large = (~cntrl) ? M_B : M_A;

  // Prepare 53-bit values for shifter and adder
  wire [52:0] M1;
  wire [52:0] M2;
  assign M1 = {1'b1, M_small};
  assign M2 = {1'b1, M_large};

  // Shifting smaller number (use your shift_right module)
  wire [52:0] M1_shifted;
  shift_right shift_smaller (
      .in(M1),
      .amt(shift_amt),
      .arithmetic(1'b0),
      .out(M1_shifted)
  );

  // Add or subtract mantissas
  wire [52:0] temp_mantissa;
  addsub1 add_sub (
      .a(M2),
      .b(M1_shifted),
      .sel(S_A ^ S_B),
      .res(temp_mantissa),
      .cout(cout2)
  );

  // Rounding (simple round-to-nearest, can be improved)
  wire [52:0] shifted_mantissa;
  wire [52:0] rounded_mantissa;
  wire cout3;
  assign shifted_mantissa = cout2 ? {1'b1, temp_mantissa[52:1]} : temp_mantissa;
  addsub1 round (
      .a(shifted_mantissa),
      .b({52'b0, temp_mantissa[0] & temp_mantissa[1]}),
      .sel(1'b0),
      .res(rounded_mantissa),
      .cout(cout3)
  );

  // Normalization after rounding (use your shift_left module)
  // Find leading zeros (up to 52)
  wire [5:0] lz;
  assign lz = (rounded_mantissa[52]) ? 0 :
              (rounded_mantissa[51]) ? 1 :
              (rounded_mantissa[50]) ? 2 :
              (rounded_mantissa[49]) ? 3 :
              (rounded_mantissa[48]) ? 4 :
              (rounded_mantissa[47]) ? 5 :
              (rounded_mantissa[46]) ? 6 :
              (rounded_mantissa[45]) ? 7 :
              (rounded_mantissa[44]) ? 8 :
              (rounded_mantissa[43]) ? 9 :
              (rounded_mantissa[42]) ? 10 :
              (rounded_mantissa[41]) ? 11 :
              (rounded_mantissa[40]) ? 12 :
              (rounded_mantissa[39]) ? 13 :
              (rounded_mantissa[38]) ? 14 :
              (rounded_mantissa[37]) ? 15 :
              (rounded_mantissa[36]) ? 16 :
              (rounded_mantissa[35]) ? 17 :
              (rounded_mantissa[34]) ? 18 :
              (rounded_mantissa[33]) ? 19 :
              (rounded_mantissa[32]) ? 20 :
              (rounded_mantissa[31]) ? 21 :
              (rounded_mantissa[30]) ? 22 :
              (rounded_mantissa[29]) ? 23 :
              (rounded_mantissa[28]) ? 24 :
              (rounded_mantissa[27]) ? 25 :
              (rounded_mantissa[26]) ? 26 :
              (rounded_mantissa[25]) ? 27 :
              (rounded_mantissa[24]) ? 28 :
              (rounded_mantissa[23]) ? 29 :
              (rounded_mantissa[22]) ? 30 :
              (rounded_mantissa[21]) ? 31 :
              (rounded_mantissa[20]) ? 32 :
              (rounded_mantissa[19]) ? 33 :
              (rounded_mantissa[18]) ? 34 :
              (rounded_mantissa[17]) ? 35 :
              (rounded_mantissa[16]) ? 36 :
              (rounded_mantissa[15]) ? 37 :
              (rounded_mantissa[14]) ? 38 :
              (rounded_mantissa[13]) ? 39 :
              (rounded_mantissa[12]) ? 40 :
              (rounded_mantissa[11]) ? 41 :
              (rounded_mantissa[10]) ? 42 :
              (rounded_mantissa[9])  ? 43 :
              (rounded_mantissa[8])  ? 44 :
              (rounded_mantissa[7])  ? 45 :
              (rounded_mantissa[6])  ? 46 :
              (rounded_mantissa[5])  ? 47 :
              (rounded_mantissa[4])  ? 48 :
              (rounded_mantissa[3])  ? 49 :
              (rounded_mantissa[2])  ? 50 :
              (rounded_mantissa[1])  ? 51 :
              (rounded_mantissa[0])  ? 52 : 53;

  wire [52:0] norm_mantissa;
  shift_left norm_shift (
      .in (rounded_mantissa),
      .amt(lz),
      .out(norm_mantissa)
  );

  // Output normalized mantissa
  assign out = norm_mantissa[52:1];

endmodule
