//`include "adder/dder.v"
//`include "shift/shift.v"
//`include "addsub/addsub.v"

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

  wire [10:0] result1 = E_A - E_B;
  wire [10:0] result2 = E_B - E_A;
  wire cout;
  wire [10:0] exp_1;
  wire sel;
  wire cout1;
  wire cout2;
  wire cntrl;
  wire [10:0] shift_amt;
  assign sel   = 1'b1;
  /*
  addsub diff_AB (
      .a(E_A),
      .b(E_B),
      .sel(sel),
      .res(result1),
      .cout(cout)
  );
  */
  /*
  addsub diff_BA (
      .a(E_B),
      .b(E_A),
      .sel(sel),
      .res(result2),
      .cout(cout1)
  );
  */

  assign cntrl = result1[10];

  // Setting sign bit
  wire temp1;
  wire temp2;
  //assign temp1 = (~(S_A ^ S_B) & ((S_A & S_B) | ((~S_A) & (~S_B))));
  //assign temp2 = ((S_A ^ S_B) & (((~cntrl) & S_A) | (cntrl & S_B)));
  //assign out[63] = temp1 | temp2;


  // Finding amopunt to right shift by
  assign shift_amt = (cntrl) ? result2 : result1;

  // Finding the smaller number
  wire [52:0] M1;
  wire [51:0] M;
  wire [51:0] M2;


  // 'cntrl' = MSB of E_A - E_B (from your addsub)
  assign shift_amt = (cntrl) ? result2 : result1;

  // Smaller number (to shift)
  //wire [51:0] M_small;
  //wire [51:0] M_large;

  //assign M_small = (cntrl) ? M_B : M_A;  // pick the smaller exponent mantissa
  //assign M_large = (~cntrl) ? M_B : M_A;  // pick the larger exponent mantissa

  // Prepare 53-bit values for shifter and adder
  //assign M = {1'b1, M_small};  // to be shifted
  //assign M_2 = {1'b1, M_large};  // not shifted
  assign M = (cntrl) ? M_A : M_B;
  assign M2 = (~cntrl) ? M_A : M_B;
  assign exp_1 = (cntrl) ? E_B : E_A;

  wire [52:0] M_1 = M1 >> shift_amt;
  wire [52:0] M_2;
  assign M1  = {1'b1, M};
  assign M_2 = {1'b1, M2};

  /*
  // Shifting smaller number
  shift_right shift_smaller (
      .in(M1),
      .amt(shift_amt),
      .arithmetic(1'b0),
      .out(M_1)
  );
  */


  //assign M_1 = {1'b1, M1};

  wire [52:0] temp_mantissa = (S_A ^ S_B) ? (M_2 - M_1) : (M_2 + M_1);

  /*
  addsub1 add_sub (
      .a(M_2),
      .b(M_1),
      .sel(S_A ^ S_B),
      .res(temp_mantissa),
      .cout(cout2)
  );
  */

  wire zer0;
  wire [10:0] shift_amt_1;
  assign zer0 = ~|temp_mantissa;
  assign temp1 = (~(S_A ^ S_B) & (S_A & S_B));
  assign temp2 = ((S_A ^ S_B) & (((~cntrl) & S_A) | (cntrl & S_B)));

  assign out[63] = zer0 ? 0 : temp1 | temp2;

  assign shift_amt_1 = (temp_mantissa[52]) ? 0 :
                       (temp_mantissa[51]) ? 1 :
                       (temp_mantissa[50]) ? 2 :
                       (temp_mantissa[49]) ? 3 :
                       (temp_mantissa[48]) ? 4 :
                       (temp_mantissa[47]) ? 5 :
                       (temp_mantissa[46]) ? 6 :
                       (temp_mantissa[45]) ? 7 :
                       (temp_mantissa[44]) ? 8 :
                       (temp_mantissa[43]) ? 9 :
                       (temp_mantissa[42]) ? 10 :
                       (temp_mantissa[41]) ? 11 :
                       (temp_mantissa[40]) ? 12 :
                       (temp_mantissa[39]) ? 13 :
                       (temp_mantissa[38]) ? 14 :
                       (temp_mantissa[37]) ? 15 :
                       (temp_mantissa[36]) ? 16 :
                       (temp_mantissa[35]) ? 17 :
                       (temp_mantissa[34]) ? 18 :
                       (temp_mantissa[33]) ? 19 :
                       (temp_mantissa[32]) ? 20 :
                       (temp_mantissa[31]) ? 21 :
                       (temp_mantissa[30]) ? 22 :
                       (temp_mantissa[29]) ? 23 :
                       (temp_mantissa[28]) ? 24 :
                       (temp_mantissa[27]) ? 25 :
                       (temp_mantissa[26]) ? 26 :
                       (temp_mantissa[25]) ? 27 :
                       (temp_mantissa[24]) ? 28 :
                       (temp_mantissa[23]) ? 29 :
                       (temp_mantissa[22]) ? 30 :
                       (temp_mantissa[21]) ? 31 :
                       (temp_mantissa[20]) ? 32 :
                       (temp_mantissa[19]) ? 33 :
                       (temp_mantissa[18]) ? 34 :
                       (temp_mantissa[17]) ? 35 :
                       (temp_mantissa[16]) ? 36 :
                       (temp_mantissa[15]) ? 37 :
                       (temp_mantissa[14]) ? 38 :
                       (temp_mantissa[13]) ? 39 :
                       (temp_mantissa[12]) ? 40 :
                       (temp_mantissa[11]) ? 41 :
                       (temp_mantissa[10]) ? 42 :
                       (temp_mantissa[9])  ? 43 :
                       (temp_mantissa[8])  ? 44 :
                       (temp_mantissa[7])  ? 45 :
                       (temp_mantissa[6])  ? 46 :
                       (temp_mantissa[5])  ? 47 :
                       (temp_mantissa[4])  ? 48 :
                       (temp_mantissa[3])  ? 49 :
                       (temp_mantissa[2])  ? 50 :
                       (temp_mantissa[1])  ? 51 :
                       (temp_mantissa[0])  ? 52 : 53;

  wire guard;
  wire [52:0] shifted_mantissa = temp_mantissa << shift_amt_1;
  wire [52:0] shifted_temp_mantissa;

  //wire cout3;

  /*
  shift_left shift_mantissa (
      .in (temp_mantissa),
      .amt(shift_amt_1),
      .out(shifted_mantissa)
  );
  */
  //wire [11:0] temp = exp_1 - shift_amt_1;

  wire [10:0] exp_2 = exp_1 - shift_amt_1;
  //wire cout4 = temp[11];
  wire cout5;

  /*
  addsub exp_mantissa (
      .a(exp_1),
      .b(shift_amt_1),
      .sel(1'b1),
      .res(exp_2),
      .cout(cout4)
  );
  */

  //assign shifted_mantissa = cout2 ? {1'b1, temp_mantissa[52:1]} : temp_mantissa;

  wire [53:0] rounded_mantissa_cout = shifted_mantissa + {52'b0, temp_mantissa[0] & temp_mantissa[1]};
  wire [52:0] rounded_mantissa = rounded_mantissa_cout[52:0];
  wire cout3 = rounded_mantissa_cout[53];
  /*
  addsub1 round (
      .a(shifted_mantissa),
      .b({52'b0, temp_mantissa[0] & temp_mantissa[1]}),
      .sel(1'b0),
      .res(rounded_mantissa),
      .cout(cout3)
  );
  */
  wire [10:0] exp_rnorm = exp_2 + (cout3 ? 11'b1 : 11'b0);
  /*
  addsub exp_renorm (
      .a(exp_2),
      .b(cout3 ? 11'b1 : 11'b0),
      .sel(1'b0),
      .res(exp_rnorm),
      .cout(cout4)
  );
  */
  assign out[62:52] = zer0 ? 11'b0 : exp_rnorm;


  assign out[51:0]  = cout3 ? rounded_mantissa[52:1] : rounded_mantissa[51:0];


  //assign out = shifted_mantissa[51:0];

endmodule
