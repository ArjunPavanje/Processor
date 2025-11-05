module shift_amount #(
    parameter MANTISSA_SIZE = 52,
    parameter EXPONENT_SIZE = 11,
    parameter BUS_WIDTH = 64,
    parameter SHIFT_MAX = 7
) (
    input [MANTISSA_SIZE+1:0] A,
    input add,
    output [SHIFT_MAX-1:0] shift_amoont
);

  localparam SHIFT_ADD_1 = 7'd1;
  localparam SHIFT_ADD_0 = 7'd0;
  localparam NOT_FOUND = 1'b0;
  localparam SHIFT_INIT = 7'd53;
  // For the case of Adddition
  wire [SHIFT_MAX-1:0] shift_amount_2 = (A[MANTISSA_SIZE+1]) ? SHIFT_ADD_1 : SHIFT_ADD_0;

  reg [SHIFT_MAX-1:0] shift_amount_1;
  integer i;
  reg found;

  always @(*) begin
    shift_amount_1 = SHIFT_INIT;
    found = NOT_FOUND;

    // Scan from MSB down to LSB
    for (i = MANTISSA_SIZE; i >= 0; i = i - 1) begin
      if (!found && A[i]) begin
        shift_amount_1 = MANTISSA_SIZE - i;
        found = ~NOT_FOUND;  // stop updating after first 1
      end
    end
  end
  // For the case of Subtraction
  // Finding leading 1
  // wire [6:0] shift_amount_1 = (A[52]) ? 7'd0 :
  //                      (A[51]) ? 7'd1 :
  //                      (A[50]) ? 7'd2 :
  //                      (A[49]) ? 7'd3 :
  //                      (A[48]) ? 7'd4 :
  //                      (A[47]) ? 7'd5 :
  //                      (A[46]) ? 7'd6 :
  //                      (A[45]) ? 7'd7 :
  //                      (A[44]) ? 7'd8 :
  //                      (A[43]) ? 7'd9 :
  //                      (A[42]) ? 7'd10 :
  //                      (A[41]) ? 7'd11 :
  //                      (A[40]) ? 7'd12 :
  //                      (A[39]) ? 7'd13 :
  //                      (A[38]) ? 7'd14 :
  //                      (A[37]) ? 7'd15 :
  //                      (A[36]) ? 7'd16 :
  //                      (A[35]) ? 7'd17 :
  //                      (A[34]) ? 7'd18 :
  //                      (A[33]) ? 7'd19 :
  //                      (A[32]) ? 7'd20 :
  //                      (A[31]) ? 7'd21 :
  //                      (A[30]) ? 7'd22 :
  //                      (A[29]) ? 7'd23 :
  //                      (A[28]) ? 7'd24 :
  //                      (A[27]) ? 7'd25 :
  //                      (A[26]) ? 7'd26 :
  //                      (A[25]) ? 7'd27 :
  //                      (A[24]) ? 7'd28 :
  //                      (A[23]) ? 7'd29 :
  //                      (A[22]) ? 7'd30 :
  //                      (A[21]) ? 7'd31 :
  //                      (A[20]) ? 7'd32 :
  //                      (A[19]) ? 7'd33 :
  //                      (A[18]) ? 7'd34 :
  //                      (A[17]) ? 7'd35 :
  //                      (A[16]) ? 7'd36 :
  //                      (A[15]) ? 7'd37 :
  //                      (A[14]) ? 7'd38 :
  //                      (A[13]) ? 7'd39 :
  //                      (A[12]) ? 7'd40 :
  //                      (A[11]) ? 7'd41 :
  //                      (A[10]) ? 7'd42 :
  //                      (A[9])  ? 7'd43 :
  //                      (A[8])  ? 7'd44 :
  //                      (A[7])  ? 7'd45 :
  //                      (A[6])  ? 7'd46 :
  //                      (A[5])  ? 7'd47 :
  //                      (A[4])  ? 7'd48 :
  //                      (A[3])  ? 7'd49 :
  //                      (A[2])  ? 7'd50 :
  //                      (A[1])  ? 7'd51 :
  //                      (A[0])  ? 7'd52 : 11'd53;
  //
  // Accordingly setting shift amount
  assign shift_amoont = (add) ? shift_amount_2 : shift_amount_1;
endmodule
