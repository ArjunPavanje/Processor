module mantissa_normalize #(
    parameter MANTISSA_SIZE = 52,
    parameter EXPONENT_SIZE = 11,
    parameter BUS_WIDTH = 64
) (
    input wire [2*BUS_WIDTH -1:0] mantissa_product,
    input wire [EXPONENT_SIZE:0] exponent_init,
    output wire [BUS_WIDTH-1:0] mantissa_normalized,
    output wire round,
    output wire [EXPONENT_SIZE:0] exponent_modified
);

  // ---- Generating lead_index via MUX tree ----
  /*
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
     */

  localparam SHIFT_SIZE_MAX = 7;
  localparam SHIFT_INIT = 7'd0;
  localparam NO_ROUND = 1'b0;
  reg [SHIFT_SIZE_MAX-1:0] lead_index;
  integer i;

  always @* begin
    lead_index = SHIFT_INIT;
    for (i = 0; i < 2 * BUS_WIDTH; i = i + 1) begin
      if (mantissa_product[i]) lead_index = i;
    end
  end

  // Finding shift direction, shifting accordingly
  wire left_shift = (lead_index < MANTISSA_SIZE);
  wire [2*BUS_WIDTH-1:0] if_left_shifted = mantissa_product << (MANTISSA_SIZE - lead_index);
  wire [2*BUS_WIDTH-1:0] if_right_shifted = mantissa_product << (lead_index - MANTISSA_SIZE);
  wire [EXPONENT_SIZE:0] shift_amt = (left_shift) ? (MANTISSA_SIZE - lead_index) : (lead_index - MANTISSA_SIZE);
  // Updating exponent
  assign exponent_modified = (left_shift)?(exponent_init - shift_amt):(exponent_init + shift_amt);

  // To round or to not round that is the question
  // Again, following RTNE (rount to nearest integer)
  // Calculated using kmaps made from LSB, Guard, ROund, Sticky bits
  wire L = mantissa_product[BUS_WIDTH];
  wire G = mantissa_product[BUS_WIDTH-1];
  wire R = mantissa_product[BUS_WIDTH-2];
  wire S = |mantissa_product[BUS_WIDTH-3];

  assign round = (left_shift) ? (NO_ROUND) : (G & (R | S)) | (L & G & (~R) & (~S));
  assign mantissa_normalized = (left_shift)?(mantissa_product << shift_amt):(mantissa_product >> shift_amt);

endmodule
