/*
Instructions supported:
1. fadd.d (00000)
2. fsub.d (00001)
3. fmul.d (00010)
4. fdiv.d (00011)
5. fsqrt.d (100)
6. fcvt.l.d (double to long) (00101)
7. fcvt.d.l (long to double) (00110)
8. fmv.x.d (double to long) (00111)
9. fmv.d.x (long to double) (01000)
*/
/*
* Flags to be added
* fpu_rd -> 1 if destination resistor is fp
* fpu_rs1 -> 1 if input resistor 1 is rs
*/
module fpu_cntrl (
    input [31:0] instruction,
    output reg [4:0] fpu_op
);
  wire [ 4:0] funct5 = instruction[31:27];
  wire [ 1:0] fmt = instruction[26:25];
  wire [ 6:0] opcode = instruction[6:0];

  wire [13:0] diff = {funct5, fmt, opcode};
  always @(*) begin
    case (diff)
      14'b00000011010011: fpu_op = 5'b00000;
      14'b00001011010011: fpu_op = 5'b00001;
      14'b00010011010011: fpu_op = 5'b00010;
      14'b00011011010011: fpu_op = 5'b00011;
      14'b01011011010011: fpu_op = 5'b00100;
      14'b11000011010011: fpu_op = 5'b00101;
      14'b11010011010011: fpu_op = 5'b00110;
      14'b11100011010011: fpu_op = 5'b00111;  // fmv.x.d
      14'b11110011010011: fpu_op = 5'b01000;  // fmv.d.x
      default: fpu_op = 5'b11111;
    endcase
  end
endmodule
