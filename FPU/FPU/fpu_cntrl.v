/*
* Arithmetic
1.  fadd.d     6'b000000
2.  fadd.s     6'b000001
3.  fsub.d     6'b000010
4.  fsub.s     6'b000011
5.  fmul.d     6'b000100
6.  fmul.s     6'b000101
7.  fdiv.d     6'b000110
8.  fdiv.s     6'b000111
9.  fsqrt.d    6'b001000
10. fsqrt.s    6'b001001

* Min/Max
11. fmin.d     6'b010000
12. fmin.s     6'b010001
13. fmax.d     6'b010010
14. fmax.s     6'b010011

* Comparission
15. feq.d      6'b010100
16. feq.s      6'b010101
17. flt.d      6'b010110
18. flt.s      6'b010111
19. fge.d      6'b011000
20. fge.s      6'b011001

* Sign Injection
21. fsgnj.d    6'b011010
22. fsgnj.s    6'b011011
23. fsgnjn.d   6'b011100
24. fsgnjn.s   6'b011101
25. fsgnjx.d   6'b011110
26. fsgnjx.s   6'b011111

* MV

27. fmv.x.d    6'b100000
28. fmv.d.x    6'b100001

*/
/*
* Flags to be added
* fpu_rd -> 1 if destination resistor is fp
* fpu_rs1 -> 1 if input resistor 1 is rs
*/
module fpu_cntrl #(
    parameter BUS_WIDTH  = 64,
    parameter INSTR_LEN  = 32,
    parameter FPU_OP_LEN = 6
) (
    input [INSTR_LEN-1:0] instruction,
    output reg [FPU_OP_LEN-1:0] fpu_op,
    output reg fpu_rs1,
    output reg fpu_rd
);
  wire [ 4:0] funct5 = instruction[31:27];
  wire [ 1:0] fmt = instruction[26:25];
  wire [ 6:0] opcode = instruction[6:0];
  wire [ 2:0] rm = instruction[14:12];
  wire [16:0] diff = {funct5, fmt, rm, opcode};

  always @(*) begin
    casez (diff)
      {  // fadd.d
        5'b00000, 2'b01, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000000;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fadd.s
        5'b00000, 2'b00, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000001;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsub.d
        5'b00001, 2'b01, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000010;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsub.s
        5'b00001, 2'b00, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000011;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fmul.d
        5'b00010, 2'b01, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000100;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fmul.s
        5'b00010, 2'b00, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000101;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fdiv.d
        5'b00011, 2'b01, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000110;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fdv.s
        5'b00011, 2'b00, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b000111;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsqrt.d
        5'b01011, 2'b01, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b001000;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsqrt.s
        5'b01011, 2'b00, 3'bz, 7'b1010011
      } : begin
        fpu_op  = 6'b001001;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end


      {  // fmin.d
        5'b00101, 2'b01, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b010000;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fmin.s
        5'b00101, 2'b00, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b010001;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fmax.d
        5'b00101, 2'b01, 3'b001, 7'b1010011
      } : begin
        fpu_op  = 6'b010010;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fmax.s
        5'b00101, 2'b00, 3'b001, 7'b1010011
      } : begin
        fpu_op  = 6'b010011;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end


      {  // feq.d
        5'b10100, 2'b01, 3'b010, 7'b1010011
      } : begin
        fpu_op  = 6'b010100;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end
      {  // fmax.s
        5'b10100, 2'b00, 3'b010, 7'b1010011
      } : begin
        fpu_op  = 6'b010101;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end

      {  // flt.d
        5'b10100, 2'b01, 3'b001, 7'b1010011
      } : begin
        fpu_op  = 6'b010110;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end
      {  // flt.s
        5'b10100, 2'b00, 3'b001, 7'b1010011
      } : begin
        fpu_op  = 6'b010111;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end

      {  // fle.d
        5'b10100, 2'b01, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b011000;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end
      {  // fle.s
        5'b10100, 2'b00, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b011001;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end


      {  // fsgnj.d
        5'b00100, 2'b01, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b011010;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsgnj.s
        5'b00100, 2'b00, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b011011;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsgnjn.d
        5'b00100, 2'b01, 3'b001, 7'b1010011
      } : begin
        fpu_op  = 6'b011100;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsgnj.s
        5'b00100, 2'b00, 3'b001, 7'b1010011
      } : begin
        fpu_op  = 6'b011101;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsgnjx.d
        5'b00100, 2'b01, 3'b010, 7'b1010011
      } : begin
        fpu_op  = 6'b011110;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
      {  // fsgnjs.s
        5'b00100, 2'b00, 3'b010, 7'b1010011
      } : begin
        fpu_op  = 6'b011111;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end

      {  // fmv.x.d
        5'b11100, 2'b01, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b100000;
        fpu_rd  = 0;
        fpu_rs1 = 1;
      end
      {  // fmv.d.x
        5'b11110, 2'b00, 3'b000, 7'b1010011
      } : begin
        fpu_op  = 6'b100001;
        fpu_rd  = 1;
        fpu_rs1 = 1;
      end
    endcase




    // case (diff)
    //   14'b00000011010011: begin
    //     fpu_op  = 6'b000000;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end
    //   14'b00001011010011: begin
    //     fpu_op  = 6'b000001;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end
    //   14'b00010011010011: begin
    //     fpu_op  = 6'b000010;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end
    //   14'b00011011010011: begin
    //     fpu_op  = 6'b000011;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end
    //   14'b01011011010011: begin
    //     fpu_op  = 6'b000100;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end
    //   14'b11000011010011: begin
    //     fpu_op  = 6'b000101;
    //     fpu_rd  = 0;
    //     fpu_rs1 = 1;
    //   end
    //   14'b11010011010011: begin
    //     fpu_op  = 6'b000110;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 0;
    //   end
    //   14'b11100011010011: begin
    //     fpu_op  = 6'b000111;
    //     fpu_rd  = 0;
    //     fpu_rs1 = 1;
    //   end  // fmv.x.d
    //   14'b11110011010011: begin
    //     fpu_op  = 6'b001000;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 0;
    //   end  // fmv.d.x
    //   14'b00000001010011: begin
    //     fpu_op  = 6'b001001;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end  // fadd.s
    //   14'b00001001010011: begin
    //     fpu_op  = 6'b001010;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end  // fsub.s
    //   14'b00010001010011: begin
    //     fpu_op  = 6'b001011;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end  // fmul.s
    //   14'b00011001010011: begin
    //     fpu_op  = 6'b001100;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end  // fdiv.s
    //   // fsqrt.s
    //   14'b01011001010011: begin
    //     fpu_op  = 6'b001101;
    //     fpu_rd  = 1;
    //     fpu_rs1 = 1;
    //   end
    //   // fmin.s
    //   14'b00101001010011: begin
    //     fpu_op = 6'b001110;
    //     fpu_rd = 1;
    //     fpu_rs1 = 1;
    //   end
    //   // fmax.s
    //   14'b
    // endcase
  end
  // always @(*) begin
  //   case (diff)
  //     14'b00000011010011: fpu_op = 6'b000000;
  //     14'b00001011010011: fpu_op = 6'b000001;
  //     14'b00010011010011: fpu_op = 6'b000010;
  //     14'b00011011010011: fpu_op = 6'b000011;
  //     14'b01011011010011: fpu_op = 6'b000100;
  //     14'b11000011010011: fpu_op = 6'b000101;
  //     14'b11010011010011: fpu_op = 6'b000110;
  //     14'b11100011010011: fpu_op = 6'b000111;  // fmv.x.d
  //     14'b11110011010011: fpu_op = 6'b001000;  // fmv.d.x
  //     14'b00000001010011: fpu_op = 6'b001001;  //fadd.s
  //     14'b00001001010011: fpu_op = 6'b001010;  //fsub.s
  //     14'b00010001010011: fpu_op = 6'b001011;  //fmul.s
  //     14'b00011001010011: fpu_op = 6'b001100;  //fdiv.s
  //     14'b01011001010011: fpu_op = 6'b001101;  //fsqrt.s
  //     default: fpu_op = 6'b011111;
  //   endcase
  // end
  // always @(*) begin
  //   case (fpu_op)
  //     6'b000000: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     6'b000001: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     6'b000010: begin
  //       fpu_rs1 = 1;
  //       fpu_rd  = 1;
  //     end
  //     6'b000011: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     6'b000100: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     6'b000101: begin
  //       fpu_rd  = 0;
  //       fpu_rs1 = 1;
  //     end
  //     6'b000110: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 0;
  //     end
  //     6'b000111: begin
  //       // fmv.x.d
  //       fpu_rd  = 0;
  //       fpu_rs1 = 1;
  //     end
  //     6'b001000: begin
  //       fpu_rd  = 1;
  //       fpu_rs1 = 0;
  //     end
  //     6'b001001: begin  //fadd.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     6'b001010: begin  //fsub.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     6'b001011: begin  //fmul.s
  //       fpu_rs1 = 1;
  //       fpu_rd  = 1;
  //     end
  //     6'b001100: begin  //fdiv.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //     6'b001101: begin  //fsqrt.s
  //       fpu_rd  = 1;
  //       fpu_rs1 = 1;
  //     end
  //   endcase
  // end
endmodule
