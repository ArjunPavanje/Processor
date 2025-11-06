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
10. fadd.s (01001)
11. fsub.s (01010)
12. fmul.s (01011)
13. fdiv.s (01100)
14. fsqrt.s (01101)
15. fmin.s (01110)
16. fmax.s (01111)
17. fmin.d (10000)
18. fmax.d (10001)
19. feq.s (10010)
20. flt.s (10011)
21. fge.s (10100)
22. feq.d (10101)
23. flt.d (10110)
24. fge.d (10111)

25. fsgnj.s (11000)
26. fsgnjn.s (11001)
27. fsgnjx.s (11010)
28. fsgnj.d (11011)
29. fsgnjn.d (11100)
30. fsgnjx.d (11101)

*/
/*
* Flags to be added
* fpu_rd -> 1 if destination resistor is fp
* fpu_rs1 -> 1 if input resistor 1 is rs
*/
module fpu_cntrl (
    input [31:0] instruction,
    output reg [4:0] fpu_op,
    output reg fpu_rs1,
    output reg fpu_rd
);
  wire [ 4:0] funct5 = instruction[31:27];
  wire [ 1:0] fmt = instruction[26:25];
  wire [ 6:0] opcode = instruction[6:0];

  wire [13:0] diff = {funct5, fmt, opcode};

  always @(*) begin
    case (diff)
      14'b00000011010011: begin
        fpu_op  = 5'b00000;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      14'b00001011010011: begin
        fpu_op  = 5'b00001;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      14'b00010011010011: begin
        fpu_op  = 5'b00010;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      14'b00011011010011: begin
        fpu_op  = 5'b00011;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      14'b01011011010011: begin
        fpu_op  = 5'b00100;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      14'b11000011010011: begin
        fpu_op  = 5'b00101;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end
      14'b11010011010011: begin
        fpu_op  = 5'b00110;
        fpu_rd  = 1;
        fpu_rs1 = 0;
      end
      14'b11100011010011: begin
        fpu_op  = 5'b00111;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end  // fmv.x.d
      14'b11110011010011: begin
        fpu_op  = 5'b01000;
        fpu_rd  = 1;
        fpu_rs1 = 0;
      end  // fmv.d.x
      14'b00000001010011: begin
        fpu_op  = 5'b01001;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end  // fadd.s
      14'b00001001010011: begin
        fpu_op  = 5'b01010;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end  // fsub.s
      14'b00010001010011: begin
        fpu_op  = 5'b01011;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end  // fmul.s
      14'b00011001010011: begin
        fpu_op  = 5'b01100;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end  // fdiv.s
      14'b01011001010011: begin
        fpu_op  = 5'b01101;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end  // fsqrt.s
      default: begin
        fpu_op  = 5'b11111;
        fpu_rd  = 0;
        fpu_rs1 = 0;
      end
    endcase
  end
  // always @(*) begin
  //   case (diff)
  //     14'b00000011010011: fpu_op = 5'b00000;
  //     14'b00001011010011: fpu_op = 5'b00001;
  //     14'b00010011010011: fpu_op = 5'b00010;
  //     14'b00011011010011: fpu_op = 5'b00011;
  //     14'b01011011010011: fpu_op = 5'b00100;
  //     14'b11000011010011: fpu_op = 5'b00101;
  //     14'b11010011010011: fpu_op = 5'b00110;
  //     14'b11100011010011: fpu_op = 5'b00111;  // fmv.x.d
  //     14'b11110011010011: fpu_op = 5'b01000;  // fmv.d.x
  //     14'b00000001010011: fpu_op = 5'b01001;  //fadd.s
  //     14'b00001001010011: fpu_op = 5'b01010;  //fsub.s
  //     14'b00010001010011: fpu_op = 5'b01011;  //fmul.s
  //     14'b00011001010011: fpu_op = 5'b01100;  //fdiv.s
  //     14'b01011001010011: fpu_op = 5'b01101;  //fsqrt.s
  //     default: fpu_op = 5'b11111;
  //   endcase
  // end
  // always @(*) begin
  //   case (fpu_op)
  //     5'b00000: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     5'b00001: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     5'b00010: begin
  //       fpu_rs1 = 1;
  //       fpu_rd  = 1;
  //     end
  //     5'b00011: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     5'b00100: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     5'b00101: begin
  //       fpu_rd  = 0;
  //       fpu_rs1 = 1;
  //     end
  //     5'b00110: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 0;
  //     end
  //     5'b00111: begin
  //       // fmv.x.d
  //       fpu_rd  = 0;
  //       fpu_rs1 = 1;
  //     end
  //     5'b01000: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 0;
  //     end
  //     5'b01001: begin  //fadd.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     5'b01010: begin  //fsub.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     5'b01011: begin  //fmul.s
  //       fpu_rs1 = 1;
  //       fpu_rd  = 1;
  //     end
  //     5'b01100: begin  //fdiv.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     5'b01101: begin  //fsqrt.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //   endcase
  // end
endmodule
