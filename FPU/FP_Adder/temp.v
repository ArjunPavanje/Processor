`include "/Users/arjunpavanje/Documents/Github/Processor/FPU/FP_Adder/shift_amount.v"
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

  // Setting control bit
  wire cntrl = (E_A < E_B);
  // Amount to shift smaller number by
  wire [11:0] shift_amt = (cntrl) ? (E_B - E_A) : (E_A - E_B);

  // Setting M_1, M_2 as operands of Add/Sub unit
  wire [51:0] M = (cntrl) ? M_A : M_B;
  wire [51:0] M2 = (~cntrl) ? M_A : M_B;
  wire [11:0] exp_1 = (cntrl) ? {1'b0, E_B} : {1'b0, E_A};

  // Extended mantissas with 3 extra bits for guard, round, sticky
  wire [55:0] M1_ext = {1'b1, M, 3'b0};      // 1 + 52 + 3 = 56 bits
  wire [55:0] M2_ext = {1'b1, M2, 3'b0};     // 1 + 52 + 3 = 56 bits

  // Align mantissas - shift smaller one right, preserve bits for sticky
  wire [55:0] M_1_shifted = M1_ext >> shift_amt;

  // Calculate sticky bit from alignment shift (OR of all bits shifted out)
  wire [55:0] sticky_mask = (56'hFFFFFFFFFFFFFFFF >> (56 - shift_amt));
  wire sticky_align = |(M1_ext & sticky_mask);

  // M_1 with sticky bit incorporated
  wire [55:0] M_1 = M_1_shifted | {55'b0, sticky_align};
  wire [55:0] M_2 = M2_ext;

  // Performing addition/subtraction
  wire add = ~(S_A ^ S_B);
  wire [56:0] temp_mantissa = ~add ? ({1'b0, M_2} - {1'b0, M_1}) : ({1'b0, M_2} + {1'b0, M_1});

  // Setting sign bit
  wire zer0;
  assign zer0 = ~|temp_mantissa;
  wire temp1 = (~(S_A ^ S_B) & (S_A & S_B));
  wire temp2 = ((S_A ^ S_B) & (((~cntrl) & S_A) | (cntrl & S_B)));
  wire temp3 = zer0 ? 1'b0 : temp1 | temp2;

  // Normalizing mantissa
  wire [6:0] shift_amt_1;
  shift_amount shift_amont (
      .A(temp_mantissa[56:3]),  // Pass upper 54 bits to shift_amount module
      .add(add),
      .shift_amoont(shift_amt_1)
  );

  // Normalize with extra bits preserved
  wire [56:0] sub_shift = temp_mantissa << shift_amt_1;
  wire [56:0] add_shift = temp_mantissa >> shift_amt_1;
  wire [56:0] shifted_mantissa_full = (add) ? add_shift : sub_shift;

  // Extract mantissa and GRS bits
  wire [52:0] shifted_mantissa = shifted_mantissa_full[55:3];  // 53-bit mantissa
  wire guard_bit = shifted_mantissa_full[2];
  wire round_bit = shifted_mantissa_full[1];
  wire sticky_bit_norm = shifted_mantissa_full[0];

  // Additional sticky from right shift in addition
  wire [56:0] sticky_mask_add = (57'h1FFFFFFFFFFFFFF >> (57 - shift_amt_1 - 1));
  wire sticky_add = add ? |(temp_mantissa & sticky_mask_add) : 1'b0;
  wire sticky_bit = sticky_bit_norm | sticky_add;

  // Updating exponent based on mantissa shift
  wire [11:0] add_exp = exp_1 + ((temp_mantissa[56]) ? 12'b1 : 12'b0);
  wire [11:0] sub_exp = exp_1 - {5'b0, shift_amt_1};
  wire [11:0] exp_2 = add ? add_exp : sub_exp;

  // IEEE 754 Round to Nearest, Ties to Even
  wire lsb = shifted_mantissa[0];  // LSB of mantissa
  wire round_up = guard_bit & (round_bit | sticky_bit | lsb);

  // Rounding and renormalizing
  wire [53:0] rounded_mantissa_cout = {1'b0, shifted_mantissa} + {53'b0, round_up};
  wire [52:0] rounded_mantissa = rounded_mantissa_cout[52:0];
  wire cout = rounded_mantissa_cout[53];
  wire [11:0] exp_rnorm = exp_2 + (cout ? 12'b1 : 12'b0);

  // Checking for 0's
  wire [11:0] exp_3 = zer0 ? 12'b0 : exp_rnorm;

  // Checking exponent overflow
  wire exp_overflow = (exp_3 >= 12'd2047);

  // Checking A, B for infinities
  wire is_inf_A = (E_A == 11'h7FF) && (M_A == 52'b0);
  wire is_inf_B = (E_B == 11'h7FF) && (M_B == 52'b0);

  // NaN: Both A, B are infinities and of opposite signs
  wire is_NaN = (S_A != S_B) && is_inf_A && is_inf_B;

  // At least one input is infinity (but not the NaN case)
  wire is_inf = ((is_inf_A | is_inf_B) & !is_NaN) | exp_overflow;

  // Outputs
  wire [51:0] final_mantissa = cout ? rounded_mantissa[52:1] : rounded_mantissa[51:0];
  wire [10:0] final_exp = exp_overflow ? 11'h7FF : exp_3[10:0];
  wire [51:0] final_mant = exp_overflow ? 52'b0 : final_mantissa;

  wire [63:0] out_1 = {temp3, final_exp, final_mant};
  wire [63:0] out_2 = 64'h7FF8000000000000;  // NaN
  wire [63:0] out_3 = is_inf_A ?
                      (S_A ? 64'hFFF0000000000000 : 64'h7FF0000000000000) :
                      (S_B ? 64'hFFF0000000000000 : 64'h7FF0000000000000);

  assign out = is_NaN ? out_2 : is_inf ? out_3 : out_1;

endmodule

