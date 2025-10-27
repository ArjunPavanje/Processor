`include "shift_amount.v"
module FPAdder (
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] out
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

  // Shifting smaller number

  // Setting control bit
  wire cntrl = (E_A < E_B);
  // Amount to shift smaller number by
  wire [10:0] shift_amt = (cntrl) ? (E_B - E_A) : (E_A - E_B);


  // Setting M_1, M_2 as operands of Add/Sub unit
  wire [51:0] M = (cntrl) ? M_A : M_B;
  wire [51:0] M2 = (~cntrl) ? M_A : M_B;
  wire [10:0] exp_1 = (cntrl) ? E_B : E_A;

  wire [52:0] M_1 = M1 >> shift_amt;
  wire [52:0] M1 = {1'b1, M};
  wire [52:0] M_2 = {1'b1, M2};


  // Performing addition/subtraction
  wire add = ~(S_A ^ S_B);
  wire [53:0] temp_mantissa = ~add ? ({1'b0, M_2} - {1'b0, M_1}) : ({1'b0, M_2} + {1'b0, M_1});

  // Setting sign bit
  wire zer0;
  assign zer0 = ~|temp_mantissa;
  wire temp1 = (~(S_A ^ S_B) & (S_A & S_B));
  wire temp2 = ((S_A ^ S_B) & (((~cntrl) & S_A) | (cntrl & S_B)));
  assign out[63] = zer0 ? 0 : temp1 | temp2;

  // Normalizing mantissa
  wire [6:0] shift_amt_1;
  shift_amount shift_amont (
      .A(temp_mantissa),
      .add(add),
      .shift_amount(shift_amt_1)
  );

  wire [53:0] sub_shift = temp_mantissa << shift_amt_1;
  wire [53:0] add_shift = temp_mantissa >> shift_amt_1;
  wire [52:0] shifted_mantissa = (add) ? (add_shift[52:0]) : (sub_shift[52:0]);
  wire [52:0] shifted_temp_mantissa;

  // Updating exponent based on mantissa shift
  wire [11:0] add_exp = exp_1 + ((temp_mantissa[53]) ? 11'b1 : 11'b0);
  wire [11:0] sub_exp = exp_1 - (shift_amt_1);
  wire [10:0] exp_2 = add ? add_exp : sub_exp;

  // Rounding and renormalizing (updating exponent accordingly)
  wire [53:0] rounded_mantissa_cout = shifted_mantissa + {52'b0, temp_mantissa[0] & temp_mantissa[1]};
  wire [52:0] rounded_mantissa = rounded_mantissa_cout[52:0];
  wire cout = rounded_mantissa_cout[53];
  wire [10:0] exp_rnorm = exp_2 + (cout ? 11'b1 : 11'b0);

  // Findal values of mantissa and exponent
  assign out[62:52] = zer0 ? 11'b0 : exp_rnorm;
  assign out[51:0]  = cout ? rounded_mantissa[52:1] : rounded_mantissa[51:0];


endmodule
