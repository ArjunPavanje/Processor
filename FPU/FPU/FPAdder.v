module FPAdder (
    input  [63:0] in1,
    input  [63:0] in2,
    output [63:0] out
);

  // Extracting Sign, Exponent, Mantissa
  wire [51:0] M_A;
  wire [51:0] M_B;
  wire [10:0] E_A;
  wire [10:0] E_B;
  wire S_A;
  wire S_B;
  assign M_A = in1[51:0];
  assign M_B = in2[51:0];

  assign E_A = in1[62:52];
  assign E_B = in2[62:52];

  assign S_A = in1[63];
  assign S_B = in2[63];

  // Shifting smaller number

  // Setting control bit
  wire cntrl = (E_A < E_B);
  // Amount to shift smaller number by
  wire [11:0] shift_amt = (cntrl) ? (E_B - E_A) : (E_A - E_B);


  // Setting M_1, M_2 as operands of Add/Sub unit
  wire [51:0] M = (cntrl) ? M_A : M_B;
  wire [51:0] M2 = (~cntrl) ? M_A : M_B;
  wire [11:0] exp_1 = (cntrl) ? {1'b0, E_B} : {1'b0, E_A};

  wire [52:0] M1 = {(cntrl) ? |E_A : |E_B, M};
  wire [52:0] M_2 = {(cntrl) ? |E_B : |E_A, M2};
  wire [52:0] M_1 = M1 >> shift_amt;


  // Performing addition/subtraction
  wire add = ~(S_A ^ S_B);
  wire [53:0] temp_mantissa = ~add ? ({1'b0, M_2} - {1'b0, M_1}) : ({1'b0, M_2} + {1'b0, M_1});

  // Setting sign bit
  wire zer0;
  assign zer0 = ~|temp_mantissa;
  wire temp1 = (~(S_A ^ S_B) & (S_A & S_B));
  wire temp2 = ((S_A ^ S_B) & (((~cntrl) & S_A) | (cntrl & S_B)));
  wire temp3 = zer0 ? 0 : temp1 | temp2;

  // Normalizing mantissa
  wire [6:0] shift_amt_1;
  shift_amount shift_amont (
      .A(temp_mantissa),
      .add(add),
      .shift_amoont(shift_amt_1)
  );

  wire [53:0] sub_shift = temp_mantissa << shift_amt_1;
  wire [53:0] add_shift = temp_mantissa >> shift_amt_1;
  wire [52:0] shifted_mantissa = (add) ? (add_shift[52:0]) : (sub_shift[52:0]);
  wire [52:0] shifted_temp_mantissa;

  // Updating exponent based on mantissa shift
  wire [11:0] add_exp = exp_1 + ((temp_mantissa[53]) ? 12'b1 : 12'b0);
  wire [11:0] sub_exp = exp_1 - (shift_amt_1);
  wire [11:0] exp_2 = add ? add_exp : sub_exp;

  /*
  // Rounding and renormalizing (updating exponent accordingly)
  wire [53:0] rounded_mantissa_cout = shifted_mantissa + {52'b0, temp_mantissa[0] & temp_mantissa[1]};
  wire [52:0] rounded_mantissa = rounded_mantissa_cout[52:0];
  wire cout = rounded_mantissa_cout[53];
  wire [11:0] exp_rnorm = exp_2 + (cout ? 12'b1 : 12'b0);
  */

  wire L = shifted_mantissa[0];
  wire G = add ? add_shift[0] : sub_shift[0];
  wire [53:0] rounded_mantissa_cout = shifted_mantissa + {52'b0, G};
  wire [52:0] rounded_mantissa = rounded_mantissa_cout[52:0];
  wire cout = rounded_mantissa_cout[53];
  wire [11:0] exp_rnorm = exp_2 + (cout ? 12'b1 : 12'b0);


  // Checking for 0's
  wire [11:0] exp_3 = zer0 ? 12'b0 : exp_rnorm;

  // Checking exponent overflow
  wire exp_overflow = (exp_3 >= 12'd2047);

  // Checking A, B for infinities
  wire is_inf_A = (E_A == 11'h7FF) && (|M_A == 1'b0);
  wire is_inf_B = (E_B == 11'h7FF) && (|M_B == 1'b0);

  wire is_NaN = (S_A^S_B)&(is_inf_A & is_inf_B); // Both A, B are infinities and of opposite signs
  wire is_inf = ((is_inf_A | is_inf_B) & !is_NaN) | exp_overflow;

  wire [63:0] out_1 = {temp3, exp_3[10:0], cout ? rounded_mantissa[52:1] : rounded_mantissa[51:0]};
  wire [63:0] out_2 = 64'h7ff8000000000000;  // NaN
  //wire [63:0] out_3 = (is_inf_A)?((S_A)?(64'hFFF0000000000000):(64'h7FF0000000000000)):((is_inf_B)?((S_B)?(64'hFFF0000000000000):(64'h7FF0000000000000)):(64'b1));  // infinity
  wire [63:0] out_3 = (is_inf_A) ? ((S_A) ? (64'hFFF0000000000000) : (64'h7FF0000000000000)) :
                    ((is_inf_B) ? ((S_B) ? (64'hFFF0000000000000) : (64'h7FF0000000000000)) :
                    ((temp3) ? (64'hFFF0000000000000) : (64'h7FF0000000000000)));

  assign out = (is_NaN) ? (out_2) : ((is_inf) ? (out_3) : (out_1));
  /*
  // Findal values of mantissa and exponent
  assign out[62:52] = exp_3;
  assign out[51:0]  = cout ? rounded_mantissa[52:1] : rounded_mantissa[51:0];
  */


endmodule
