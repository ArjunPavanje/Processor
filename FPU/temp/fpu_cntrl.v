/*
Instructions supported:
1. fadd.d (000)
2. fsub.d (001)
3. fmul.d (010)
4. fdiv.d (011)
5. fsqrt.d (100)
6. fcvt.l.d (double to long) (101)
7. fcvt.d.l (long to double) (110)
*/

module fpu_cntrl (
    input [31:0] instruction,
    output reg [2:0] fpu_op
);
  wire [ 4:0] funct5 = instruction[31:27];
  wire [ 1:0] fmt = instruction[26:25];
  wire [ 6:0] opcode = instruction[6:0];

  wire [13:0] diff = {funct5, fmt, opcode};
  always @(*) begin
    case (diff)
      14'b00000011010011: fpu_op = 3'b000;
      14'b00001011010011: fpu_op = 3'b001;
      14'b00010011010011: fpu_op = 3'b010;
      14'b00011011010011: fpu_op = 3'b011;
      14'b01011011010011: fpu_op = 3'b100;
      14'b11000011010011: fpu_op = 3'b101;
      14'b11010011010011: fpu_op = 3'b110;
      default: fpu_op = 3'b111;
    endcase
  end
endmodule
