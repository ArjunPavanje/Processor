module leading_1 #(
    parameter BUS_WIDTH = 64,
    parameter INDEX_MAX = 11
) (
    input [BUS_WIDTH-1:0] num,
    output reg [INDEX_MAX-1:0] index
);

  localparam INDEX_INIT = 11'd0;
  localparam NOT_FOUND = 1'b0;

  integer i;
  reg found;

  always @(*) begin
    index = 11'd0;
    found = NOT_FOUND;

    for (i = BUS_WIDTH - 1; i >= 0; i = i - 1) begin
      if (!found && num[i]) begin
        index = i[INDEX_MAX-1:0];
        found = ~NOT_FOUND;
      end
    end
  end


  // assign index =
  //   num[63] ? 11'd63 :
  //   num[62] ? 11'd62 :
  //   num[61] ? 11'd61 :
  //   num[60] ? 11'd60 :
  //   num[59] ? 11'd59 :
  //   num[58] ? 11'd58 :
  //   num[57] ? 11'd57 :
  //   num[56] ? 11'd56 :
  //   num[55] ? 11'd55 :
  //   num[54] ? 11'd54 :
  //   num[53] ? 11'd53 :
  //   num[52] ? 11'd52 :
  //   num[51] ? 11'd51 :
  //   num[50] ? 11'd50 :
  //   num[49] ? 11'd49 :
  //   num[48] ? 11'd48 :
  //   num[47] ? 11'd47 :
  //   num[46] ? 11'd46 :
  //   num[45] ? 11'd45 :
  //   num[44] ? 11'd44 :
  //   num[43] ? 11'd43 :
  //   num[42] ? 11'd42 :
  //   num[41] ? 11'd41 :
  //   num[40] ? 11'd40 :
  //   num[39] ? 11'd39 :
  //   num[38] ? 11'd38 :
  //   num[37] ? 11'd37 :
  //   num[36] ? 11'd36 :
  //   num[35] ? 11'd35 :
  //   num[34] ? 11'd34 :
  //   num[33] ? 11'd33 :
  //   num[32] ? 11'd32 :
  //   num[31] ? 11'd31 :
  //   num[30] ? 11'd30 :
  //   num[29] ? 11'd29 :
  //   num[28] ? 11'd28 :
  //   num[27] ? 11'd27 :
  //   num[26] ? 11'd26 :
  //   num[25] ? 11'd25 :
  //   num[24] ? 11'd24 :
  //   num[23] ? 11'd23 :
  //   num[22] ? 11'd22 :
  //   num[21] ? 11'd21 :
  //   num[20] ? 11'd20 :
  //   num[19] ? 11'd19 :
  //   num[18] ? 11'd18 :
  //   num[17] ? 11'd17 :
  //   num[16] ? 11'd16 :
  //   num[15] ? 11'd15 :
  //   num[14] ? 11'd14 :
  //   num[13] ? 11'd13 :
  //   num[12] ? 11'd12 :
  //   num[11] ? 11'd11 :
  //   num[10] ? 11'd10 :
  //   num[9]  ? 11'd9  :
  //   num[8]  ? 11'd8  :
  //   num[7]  ? 11'd7  :
  //   num[6]  ? 11'd6  :
  //   num[5]  ? 11'd5  :
  //   num[4]  ? 11'd4  :
  //   num[3]  ? 11'd3  :
  //   num[2]  ? 11'd2  :
  //   num[1]  ? 11'd1  :
  //   num[0]  ? 11'd0  :
  //   11'd0;

endmodule
