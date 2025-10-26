`include "shift/shift.v"
`include "addsub/addsub.v"
`include "mul/mul.v"

// Full bidirectional mantissa normalization (MUX-based)
// Checks [127:53] for upper leading-one → left shift
// Else checks [52:0] → right shift.
// Output: 64-bit normalized mantissa.

module mantissa_normalize_mux (
    input wire [127:0] mantissa_product,
    input wire [10:0] exponent_init,
    output wire [63:0] mantissa_normalized,
    output wire round,
    output wire [10:0] exponent_modified
);

  // ---- Generate lead_index via MUX tree ----
  wire [6:0] lead_index;
  assign lead_index =
       (mantissa_product[127]) ? 7'd127 :
       (mantissa_product[126]) ? 7'd126 :
       (mantissa_product[125]) ? 7'd125 :
       (mantissa_product[124]) ? 7'd124 :
       (mantissa_product[123]) ? 7'd123 :
       (mantissa_product[122]) ? 7'd122 :
       (mantissa_product[121]) ? 7'd121 :
       (mantissa_product[120]) ? 7'd120 :
       (mantissa_product[119]) ? 7'd119 :
       (mantissa_product[118]) ? 7'd118 :
       (mantissa_product[117]) ? 7'd117 :
       (mantissa_product[116]) ? 7'd116 :
       (mantissa_product[115]) ? 7'd115 :
       (mantissa_product[114]) ? 7'd114 :
       (mantissa_product[113]) ? 7'd113 :
       (mantissa_product[112]) ? 7'd112 :
       (mantissa_product[111]) ? 7'd111 :
       (mantissa_product[110]) ? 7'd110 :
       (mantissa_product[109]) ? 7'd109 :
       (mantissa_product[108]) ? 7'd108 :
       (mantissa_product[107]) ? 7'd107 :
       (mantissa_product[106]) ? 7'd106 :
       (mantissa_product[105]) ? 7'd105 :
       (mantissa_product[104]) ? 7'd104 :
       (mantissa_product[103]) ? 7'd103 :
       (mantissa_product[102]) ? 7'd102 :
       (mantissa_product[101]) ? 7'd101 :
       (mantissa_product[100]) ? 7'd100 :
       (mantissa_product[99])  ? 7'd99  :
       (mantissa_product[98])  ? 7'd98  :
       (mantissa_product[97])  ? 7'd97  :
       (mantissa_product[96])  ? 7'd96  :
       (mantissa_product[95])  ? 7'd95  :
       (mantissa_product[94])  ? 7'd94  :
       (mantissa_product[93])  ? 7'd93  :
       (mantissa_product[92])  ? 7'd92  :
       (mantissa_product[91])  ? 7'd91  :
       (mantissa_product[90])  ? 7'd90  :
       (mantissa_product[89])  ? 7'd89  :
       (mantissa_product[88])  ? 7'd88  :
       (mantissa_product[87])  ? 7'd87  :
       (mantissa_product[86])  ? 7'd86  :
       (mantissa_product[85])  ? 7'd85  :
       (mantissa_product[84])  ? 7'd84  :
       (mantissa_product[83])  ? 7'd83  :
       (mantissa_product[82])  ? 7'd82  :
       (mantissa_product[81])  ? 7'd81  :
       (mantissa_product[80])  ? 7'd80  :
       (mantissa_product[79])  ? 7'd79  :
       (mantissa_product[78])  ? 7'd78  :
       (mantissa_product[77])  ? 7'd77  :
       (mantissa_product[76])  ? 7'd76  :
       (mantissa_product[75])  ? 7'd75  :
       (mantissa_product[74])  ? 7'd74  :
       (mantissa_product[73])  ? 7'd73  :
       (mantissa_product[72])  ? 7'd72  :
       (mantissa_product[71])  ? 7'd71  :
       (mantissa_product[70])  ? 7'd70  :
       (mantissa_product[69])  ? 7'd69  :
       (mantissa_product[68])  ? 7'd68  :
       (mantissa_product[67])  ? 7'd67  :
       (mantissa_product[66])  ? 7'd66  :
       (mantissa_product[65])  ? 7'd65  :
       (mantissa_product[64])  ? 7'd64  :
       (mantissa_product[63])  ? 7'd63  :
       (mantissa_product[62])  ? 7'd62  :
       (mantissa_product[61])  ? 7'd61  :
       (mantissa_product[60])  ? 7'd60  :
       (mantissa_product[59])  ? 7'd59  :
       (mantissa_product[58])  ? 7'd58  :
       (mantissa_product[57])  ? 7'd57  :
       (mantissa_product[56])  ? 7'd56  :
       (mantissa_product[55])  ? 7'd55  :
       (mantissa_product[54])  ? 7'd54  :
       (mantissa_product[53])  ? 7'd53  :
       (mantissa_product[52])  ? 7'd52  :
       (mantissa_product[51])  ? 7'd51  :
       (mantissa_product[50])  ? 7'd50  :
       (mantissa_product[49])  ? 7'd49  :
       (mantissa_product[48])  ? 7'd48  :
       (mantissa_product[47])  ? 7'd47  :
       (mantissa_product[46])  ? 7'd46  :
       (mantissa_product[45])  ? 7'd45  :
       (mantissa_product[44])  ? 7'd44  :
       (mantissa_product[43])  ? 7'd43  :
       (mantissa_product[42])  ? 7'd42  :
       (mantissa_product[41])  ? 7'd41  :
       (mantissa_product[40])  ? 7'd40  :
       (mantissa_product[39])  ? 7'd39  :
       (mantissa_product[38])  ? 7'd38  :
       (mantissa_product[37])  ? 7'd37  :
       (mantissa_product[36])  ? 7'd36  :
       (mantissa_product[35])  ? 7'd35  :
       (mantissa_product[34])  ? 7'd34  :
       (mantissa_product[33])  ? 7'd33  :
       (mantissa_product[32])  ? 7'd32  :
       (mantissa_product[31])  ? 7'd31  :
       (mantissa_product[30])  ? 7'd30  :
       (mantissa_product[29])  ? 7'd29  :
       (mantissa_product[28])  ? 7'd28  :
       (mantissa_product[27])  ? 7'd27  :
       (mantissa_product[26])  ? 7'd26  :
       (mantissa_product[25])  ? 7'd25  :
       (mantissa_product[24])  ? 7'd24  :
       (mantissa_product[23])  ? 7'd23  :
       (mantissa_product[22])  ? 7'd22  :
       (mantissa_product[21])  ? 7'd21  :
       (mantissa_product[20])  ? 7'd20  :
       (mantissa_product[19])  ? 7'd19  :
       (mantissa_product[18])  ? 7'd18  :
       (mantissa_product[17])  ? 7'd17  :
       (mantissa_product[16])  ? 7'd16  :
       (mantissa_product[15])  ? 7'd15  :
       (mantissa_product[14])  ? 7'd14  :
       (mantissa_product[13])  ? 7'd13  :
       (mantissa_product[12])  ? 7'd12  :
       (mantissa_product[11])  ? 7'd11  :
       (mantissa_product[10])  ? 7'd10  :
       (mantissa_product[9])   ? 7'd9   :
       (mantissa_product[8])   ? 7'd8   :
       (mantissa_product[7])   ? 7'd7   :
       (mantissa_product[6])   ? 7'd6   :
       (mantissa_product[5])   ? 7'd5   :
       (mantissa_product[4])   ? 7'd4   :
       (mantissa_product[3])   ? 7'd3   :
       (mantissa_product[2])   ? 7'd2   :
       (mantissa_product[1])   ? 7'd1   :
       (mantissa_product[0])   ? 7'd0   : 7'd127;


  // ---- Determine shift direction ----
  wire left_shift = (lead_index < 7'd52);
  wire [127:0] if_left_shifted = mantissa_product << (7'd52 - lead_index);
  wire [127:0] if_right_shifted = mantissa_product << (lead_index - 7'd52);
  wire [10:0] shift_amt = (left_shift) ? (11'd52 - lead_index) : (lead_index - 11'd52);
  assign exponent_modified = (left_shift)?(exponent_init - shift_amt):(exponent_init + shift_amt);
  //wire [127:0] round_right_shifted = mantissa_product << (7'd127 - lead_index);

  wire L = mantissa_product[64];
  wire G = mantissa_product[63];
  wire R = mantissa_product[62];
  wire S = |mantissa_product[61];

  assign round = (left_shift) ? (1'b0) : (G & (R | S)) | (L & G & (~R) & (~S));

  //assign mantissa_normalized = (left_shift) ? (if_left_shifted[63:0]) : (if_right_shifted[52:0]);
  assign mantissa_normalized = (left_shift)?(mantissa_product << shift_amt):(mantissa_product >> shift_amt);
  /*
  wire [6:0] shift_amt_left = (need_left) ? ((lead_index - 7'd52) & 7'h7F) : 7'd0;
  wire [6:0] shift_amt_right = (need_right) ? ((7'd52 - lead_index) & 7'h7F) : 7'd0;


  wire [128:0] left_shifted = mantissa_product << shift_amt_left;
  wire [128:0] right_shifted = mantissa_product >> shift_amt_right;

  // ---- Select shifted result ----
  wire [128:0] mantissa_shifted = need_left ? left_shifted :
                                  need_right ? right_shifted :
                                  mantissa_product;

  // Output 64 bits
  assign mantissa_normalized = mantissa_shifted[63:0];
     */
endmodule



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


  wire [63:0] temp1;
  wire [63:0] temp2;
  assign temp1 = {12'b1, M_1};
  assign temp2 = {12'b1, M_2};


  // Adding exponnts E_1, E_2
  wire [ 10:0] exponent_1 = E_1 - E_2;
  wire [ 10:0] exponent_2 = exponent_1 + 10'd1023;
  /*
  wire cout1;
  wire cout2;
  wire [63:0] exponent_2;
  addsub FPdiv_exponent_sum (
      .a({53'b0, E_1}),
      .b({53'b0, E_2}),
      .sel(1'b0),
      .res(exponent_1),
      .cout(cout1)
  );
  // Then subtracting bias
  addsub FPdiv_exponent_bias (
      .a({exponent_1}),
      .b({64'd1023}),
      .sel(1'b1),
      .res(exponent_2),
      .cout(cout2)
  );
  */

  // Multiplying mantissas M_1 and M_2
  wire [127:0] mantissa_product;
  /*
  mul FPdiv_mantissa (
      .a({12'b1, M_1}),
      .b({12'b1, M_2}),
      .sign(1'b0),
      .res(mantissa_product)
  );
  */
  assign mantissa_product = (({12'b1, M_1}) << 52) / ({12'b1, M_2});
  // Normalizing mantissa
  wire [63:0] mantissa_normalized;
  wire round;
  wire [10:0] exponent_3;
  mantissa_normalize_mux FPdiv_normalize (
      .mantissa_product(mantissa_product),
      .exponent_init(exponent_2),
      .mantissa_normalized(mantissa_normalized),
      .round(round),
      .exponent_modified(exponent_3)
  );

  wire L;
  wire G;
  wire R;
  wire S;

  // Also setting LSB, Guard, Round, Sticky bits
  //assign L = (mantissa_product[105]) ? mantissa_product[53] : mantissa_product[52];
  //assign G = (mantissa_product[105]) ? mantissa_product[52] : mantissa_product[51];
  //assign R = (mantissa_product[105]) ? mantissa_product[51] : mantissa_product[50];
  //assign S = (mantissa_product[105]) ? |mantissa_product[50:0] : |mantissa_product[49:0];

  assign L = mantissa_normalized[11];
  assign G = mantissa_normalized[10];
  assign R = mantissa_normalized[9];
  assign S = |mantissa_normalized[8];

  wire [52:0] mantissa_normalized_shifted;
  assign mantissa_normalized_shifted = mantissa_normalized[52:0];
  // Updating exponent (if needed) after normalizing
  //wire [63:0] exponent_3;
  wire cout3;
  /*
  addsub FPdiv_exponent_norm (
      .a(exponent_2),
      .b(mantissa_product[105] ? 64'b1 : 64'b0),
      .sel(1'b0),
      .res(exponent_3),
      .cout(cout3)
  );
  */

  //wire [63:0] mantissa_rounded;
  wire cout;
  /*
  addsub FPdiv_round (
      .a({11'b0, mantissa_normalized_shifted}),
      .b((round) ? {63'b0, 1'b1} : {63'b0, 1'b0}),
      .sel(1'b0),
      .cout(cout),
      .res(mantissa_rounded)
  );
  */
  wire [63:0] mantissa_rounded = mantissa_normalized + ((round) ? (64'b1) : (64'b0));

  wire [51:0] mantissa_renormalized;
  wire [10:0] exponent_4;
  wire cout4;
  /*
  addsub FPdiv_exponent_renorm (
      .a(exponent_3),
      .b((cout) ? 64'b1 : 64'b0),
      .sel(1'b0),
      .res(exponent_4),
      .cout(cout4)
  );
  */

  assign mantissa_renormalized = (mantissa_rounded[53]) ? mantissa_rounded[52:1] : mantissa_rounded[51:0];
  assign exponent_4 = exponent_3 + ((mantissa_rounded[53]) ? 11'b1 : 11'b0);
  //assign out[51:0] = mantissa_normalized_shifted[51:0];
  assign out[51:0] = mantissa_renormalized;
  assign out[62:52] = exponent_4;
  assign out[63] = S_1 ^ S_2;

endmodule
