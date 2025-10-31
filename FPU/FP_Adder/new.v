`include "/Users/arjunpavanje/Documents/Github/Processor/FPU/FP_Adder/v.v"
module new_FPAdder (
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
  wire cntrl = (E_A < E_B) | ((E_A == E_B) & (M_A < M_B));
  // Amount to shift smaller number by
  wire [11:0] shift_amt = (cntrl) ? (E_B - E_A) : (E_A - E_B);

  wire [11:0] exp_1 = (cntrl) ? {1'b0, E_B} : {1'b0, E_A};

  // Setting smaller and larger numbers
  wire [51:0] smaller = cntrl ? M_A : M_B;
  wire [51:0] larger = (~cntrl) ? M_A : M_B;

  wire [106:0] M_1_unshifted = {2'd1, smaller, 53'b0};
  wire [106:0] M_2 = {2'd1, larger, 53'b0};
  wire [106:0] M_1 = M_1_unshifted >> shift_amt;

  wire add = ~(S_A ^ S_B);
  wire [106:0] temp_mantissa = (add) ? (M_1 + M_2) : (M_2 - M_1);

  // Normalizing mantissa
  wire [6:0] normalize_shift;
  addsub_shift_amount normalizing (
      .A(temp_mantissa),
      .add(add),
      .normalize_shift(normalize_shift)
  );

  // Updating exponent based on mantissa shift
  wire [11:0] add_exp = exp_1 + ((temp_mantissa[106]) ? 12'b1 : 12'b0);
  wire [11:0] sub_exp = exp_1 - (normalize_shift);
  wire [11:0] exp_2 = add ? add_exp : sub_exp;


  wire [106:0] shifted_mantissa = (add)?(temp_mantissa >> normalize_shift):(temp_mantissa << normalize_shift);

  wire L = shifted_mantissa[53];
  wire G = shifted_mantissa[52];
  wire R = shifted_mantissa[51];
  wire S = |shifted_mantissa[50:0];


  // For addition: use after-shift bits as before
  wire L_add = shifted_mantissa[53];
  wire G_add = shifted_mantissa[52];
  wire R_add = shifted_mantissa[51];
  wire S_add = |shifted_mantissa[50:0];

  wire round = (L & G & (~R) & (~S)) | (G & (R | S));
  wire [106:0] rounded_mantissa = shifted_mantissa + {53'd0, round, 53'b0};

  // Renormalizing
  wire [106:0] renormalized_mantissa = (rounded_mantissa[106])?(rounded_mantissa >> 1'b1):(rounded_mantissa);
  wire [11:0] exp_3 = exp_2 + ((rounded_mantissa[106]) ? 12'd1 : 12'd0);

  wire temp1 = (~(S_A ^ S_B) & (S_A & S_B));
  wire temp2 = ((S_A ^ S_B) & (((~cntrl) & S_A) | (cntrl & S_B)));
  wire temp3 = temp1 | temp2;


  wire exp_underflow = (exp_3 == 12'd0) | (exp_3[11] == 1'b1);
  wire [63:0] out_1 = {temp3, exp_3[10:0], renormalized_mantissa[104:53]};
  wire zer0_num = ((~(|A[62:0])) & (~(|B[62:0])));
  // Checking exponent overflow
  wire exp_overflow = (exp_3 >= 12'd2047) & (~zer0_num);
  // Checking A, B for infinities
  wire is_inf_A = (E_A == 11'h7FF) && (|M_A == 1'b0);
  wire is_inf_B = (E_B == 11'h7FF) && (|M_B == 1'b0);

  wire is_NaN = (S_A^S_B)&(is_inf_A & is_inf_B); // Both A, B are infinities and of opposite signs
  wire is_inf = ((is_inf_A | is_inf_B) & !is_NaN) | exp_overflow;

  wire is_zero = (~is_NaN) & (~is_inf) & (zer0_num | (~|temp_mantissa));
  //wire [63:0] out_1 = {temp3, exp_3[10:0], cout ? rounded_mantissa[52:1] : rounded_mantissa[51:0]};
  wire [63:0] out_2 = 64'h7ff8000000000000;  // NaN
  //wire [63:0] out_3 = (is_inf_A)?((S_A)?(64'hFFF0000000000000):(64'h7FF0000000000000)):((is_inf_B)?((S_B)?(64'hFFF0000000000000):(64'h7FF0000000000000)):(64'b1));  // infinity
  wire [63:0] out_3 = ((is_inf_A) ? ((S_A) ? (64'hFFF0000000000000) : (64'h7FF0000000000000)) :
                    ((is_inf_B) ? ((S_B) ? (64'hFFF0000000000000) : (64'h7FF0000000000000)) :
                    ((temp3) ? (64'hFFF0000000000000) : (64'h7FF0000000000000))));

  assign out = (is_zero) ? (64'd0) : ((is_NaN) ? (out_2) : ((is_inf) ? (out_3) : (out_1)));


endmodule
