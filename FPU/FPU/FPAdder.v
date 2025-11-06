module FPAdder #(
    parameter BUS_WIDTH = 64
) (
    input  [BUS_WIDTH-1:0] in1,
    input  [BUS_WIDTH-1:0] in2,
    output [BUS_WIDTH-1:0] out
);

  // Main parameters
  localparam MANTISSA_SIZE = (BUS_WIDTH == 64) ? 52 : 23;
  localparam EXPONENT_SIZE = (BUS_WIDTH == 64) ? 11 : 8;
  localparam BIAS = (BUS_WIDTH == 64) ? 1023 : 127;

  // Other non-important parameters
  localparam LEADING_ONE = (BUS_WIDTH == 64) ? 12'd1 : 9'd1;
  localparam PRODUCT_PAD = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;
  localparam ROUND_UP = (BUS_WIDTH == 64) ? 64'd1 : 32'd1;
  localparam PAD_ZERO = 1'b0;
  localparam ROUND_DOWN = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;
  localparam MANTISSA_PAD = (BUS_WIDTH == 64) ? 52'd0 : 23'd0;
  localparam MANTISSA_SHIFT = (BUS_WIDTH == 64) ? 11'd1 : 8'd1;
  localparam EXPONENT_INC = (BUS_WIDTH == 64) ? 12'd1 : 9'd1;
  localparam EXPONENT_NO_CHANGE = (BUS_WIDTH == 64) ? 12'd0 : 9'd0;
  localparam PAD_2 = (BUS_WIDTH == 64) ? 12'd0 : 9'd0;
  localparam SHIFT_MAX = 7;
  localparam IS_INFINITY = (BUS_WIDTH == 64) ? 11'h7FF : 8'hFF;
  localparam NAN = (BUS_WIDTH == 64) ? 64'h7ff8000000000000 : 32'h7fc00000;
  localparam INFINITY_P = (BUS_WIDTH == 64) ? 64'h7ff0000000000000 : 32'h7f800000;
  localparam INFINITY_N = (BUS_WIDTH == 64) ? 64'hfff0000000000000 : 32'hff800000;
  localparam ZERO = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;

  // Extracting Sign, Exponent, Mantissa
  wire [MANTISSA_SIZE-1:0] M_A;
  wire [MANTISSA_SIZE-1:0] M_B;
  wire [EXPONENT_SIZE-1:0] E_A;
  wire [EXPONENT_SIZE-1:0] E_B;
  wire S_A;
  wire S_B;
  assign M_A = in1[MANTISSA_SIZE-1:0];
  assign M_B = in2[MANTISSA_SIZE-1:0];

  assign E_A = in1[BUS_WIDTH-2:MANTISSA_SIZE];
  assign E_B = in2[BUS_WIDTH-2:MANTISSA_SIZE];

  assign S_A = in1[BUS_WIDTH-1];
  assign S_B = in2[BUS_WIDTH-1];

  // Shifting smaller number

  // Setting control bit
  wire cntrl = (E_A < E_B);
  // Amount to shift smaller number by
  wire [EXPONENT_SIZE:0] shift_amt = (cntrl) ? (E_B - E_A) : (E_A - E_B);


  // Setting M_1, M_2 as operands of Add/Sub unit
  wire [MANTISSA_SIZE-1:0] M = (cntrl) ? M_A : M_B;
  wire [MANTISSA_SIZE-1:0] M2 = (~cntrl) ? M_A : M_B;
  wire [EXPONENT_SIZE:0] exp_1 = (cntrl) ? {PAD_ZERO, E_B} : {PAD_ZERO, E_A};

  wire [MANTISSA_SIZE:0] M1 = {(cntrl) ? |E_A : |E_B, M};
  wire [MANTISSA_SIZE:0] M_2 = {(cntrl) ? |E_B : |E_A, M2};


  // Before shifting smaller number, properly accounting for truncation so it doesn't bit me in the ass later
  wire [MANTISSA_SIZE:0] temp_1 = M1 >> (shift_amt) - MANTISSA_SHIFT;
  wire G_1 = (shift_amt >= MANTISSA_SHIFT) ? (temp_1[0]) : (PAD_ZERO);  // Guard Bit

  wire [MANTISSA_SIZE:0] temp_2 = M1 >> (shift_amt) - (MANTISSA_SHIFT + 1);
  wire R_1 = (shift_amt >= MANTISSA_SHIFT + 1) ? (temp_2[0]) : (PAD_ZERO);  // Round Bit

  wire [MANTISSA_SIZE:0] temp_3 = M1 << (MANTISSA_SIZE + 1) - (shift_amt);
  wire [MANTISSA_SIZE:0] shifted = temp3 >> (MANTISSA_SIZE + 1) - shift_amt;
  wire S_1 = (shift_amt >= (MANTISSA_SHIFT + 2)) ? (|temp_3) : (PAD_ZERO);  // Sticky Bit

  wire [MANTISSA_SIZE:0] M_1 = M1 >> shift_amt;


  // Performing addition/subtraction
  wire add = ~(S_A ^ S_B);
  wire [MANTISSA_SIZE+1:0] temp_mantissa = ~add ? ({PAD_ZERO, M_2} - {PAD_ZERO, M_1}) : ({PAD_ZERO, M_2} + {PAD_ZERO, M_1});

  // Setting sign bit
  wire zer0;
  assign zer0 = ~|temp_mantissa;
  wire temp1 = (~(S_A ^ S_B) & (S_A & S_B));
  wire temp2 = ((S_A ^ S_B) & (((~cntrl) & S_A) | (cntrl & S_B)));
  wire temp3 = zer0 ? 0 : temp1 | temp2;

  // Normalizing mantissa
  wire [SHIFT_MAX-1:0] shift_amt_1;
  shift_amount #(
      .MANTISSA_SIZE(MANTISSA_SIZE),
      .EXPONENT_SIZE(EXPONENT_SIZE),
      .BUS_WIDTH(BUS_WIDTH)
  ) shift_amont (
      .A(temp_mantissa),
      .add(add),
      .shift_amoont(shift_amt_1)
  );

  wire [MANTISSA_SIZE+1:0] sub_shift = temp_mantissa << shift_amt_1;
  wire [MANTISSA_SIZE+1:0] add_shift = temp_mantissa >> shift_amt_1;


  wire [MANTISSA_SIZE:0] shifted_mantissa = (add) ? (add_shift[MANTISSA_SIZE:0]) : (sub_shift[MANTISSA_SIZE:0]);
  wire [MANTISSA_SIZE:0] shifted_temp_mantissa;

  // Updating exponent based on mantissa shift
  wire [EXPONENT_SIZE:0] add_exp = exp_1 + ((temp_mantissa[MANTISSA_SIZE+1]) ? EXPONENT_INC : EXPONENT_NO_CHANGE);
  wire [EXPONENT_SIZE:0] sub_exp = exp_1 - (shift_amt_1);
  wire [EXPONENT_SIZE:0] exp_2 = add ? add_exp : sub_exp;

  // Rounding Logic
  //wire L = shifted_mantissa[1];
  //wire G = shifted_mantissa[0];
  //
  wire L = (temp_mantissa[MANTISSA_SIZE+1]) ? (temp_mantissa[1]) : (temp_mantissa[0]);
  wire G = (temp_mantissa[MANTISSA_SIZE+1]) ? (temp_mantissa[0]) : G_1;
  wire R = (temp_mantissa[MANTISSA_SIZE+1]) ? (G_1) : R_1;
  wire S = (temp_mantissa[MANTISSA_SIZE+1]) ? (R_1 | S_1) : S_1;

  wire round_add = (add) ? ((L & G & (~R) & (~S)) | (G & (R | S))) : PAD_ZERO;
  wire round_sub = ((G_1 == 1)) ? (~PAD_ZERO) : (PAD_ZERO);
  //wire round = (add) ? (temp_mantissa[53] ? ((G & L) ? (1'b1) : (1'b0)) : (1'b0)) : 1'b0;


  wire [MANTISSA_SIZE+1:0] rounded_mantissa_cout = (add)?(shifted_mantissa + {MANTISSA_PAD, round_add}):(shifted_mantissa - {MANTISSA_PAD, round_sub});


  //wire [53:0] rounded_mantissa_cout =
  //shifted_mantissa + (add?{MANTISSA_SIZE'd0, round_add}:{52'd0});
  wire [MANTISSA_SIZE:0] rounded_mantissa = rounded_mantissa_cout[MANTISSA_SIZE:0];
  wire cout = rounded_mantissa_cout[MANTISSA_SIZE+1];
  wire [EXPONENT_SIZE:0] exp_rnorm = exp_2 + (cout ? EXPONENT_INC : EXPONENT_NO_CHANGE);

  // Checking for 0's
  wire [EXPONENT_SIZE:0] exp_3 = zer0 ? EXPONENT_NO_CHANGE : exp_rnorm;

  // Checking exponent overflow
  wire exp_overflow = (exp_3 >= 2 * BIAS + 1);

  // Checking A, B for infinities
  wire is_inf_A = (E_A == IS_INFINITY) && ~(|M_A);
  wire is_inf_B = (E_B == IS_INFINITY) && ~(|M_B);

  wire is_NaN = (S_A^S_B)&(is_inf_A & is_inf_B); // Both A, B are infinities and of opposite signs
  wire is_inf = ((is_inf_A | is_inf_B) & !is_NaN) | exp_overflow;

  wire [BUS_WIDTH-1:0] out_1 = {
    temp3,
    exp_3[EXPONENT_SIZE-1:0],
    cout ? rounded_mantissa[MANTISSA_SIZE:1] : rounded_mantissa[MANTISSA_SIZE-1:0]
  };
  wire [BUS_WIDTH-1:0] out_2 = NAN;  // NaN
  //wire [BUS_WIDTH-1:0] out_3 = (is_inf_A)?((S_A)?(64'hFFF0000000000000):(64'h7FF0000000000000)):((is_inf_B)?((S_B)?(64'hFFF0000000000000):(64'h7FF0000000000000)):(64'b1));  // infinity
  wire [BUS_WIDTH-1:0] out_3 = (is_inf_A) ? ((S_A) ? (INFINITY_N) : (INFINITY_P)) :
                    ((is_inf_B) ? ((S_B) ? (INFINITY_N) : (INFINITY_P)) :
                    ((temp3) ? (INFINITY_N) : (INFINITY_P)));

  assign out = (is_NaN) ? (out_2) : ((is_inf) ? (out_3) : (out_1));
  /*
  // Findal values of mantissa and exponent
  assign out[BUS_WIDTH-2:MANTISSA_SIZE] = exp_3;
  assign out[MANTISSA_SIZE-1:0]  = cout ? rounded_mantissa[MANTISSA_SIZE:1] : rounded_mantissa[MANTISSA_SIZE-1:0];
  */


endmodule
