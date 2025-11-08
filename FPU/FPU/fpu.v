module FPU #(
    parameter BUS_WIDTH = 64,
    parameter OP_LEN = 6
) (
    input wire [BUS_WIDTH-1:0] in1,
    input wire [BUS_WIDTH-1:0] in2,

    input wire [OP_LEN-1:0] fpu_op,

    //output reg fpu_rd,
    //output reg fpu_rs1,
    output reg [BUS_WIDTH-1:0] out
);
  localparam PAD_ZERO = 32'd0;

  wire [BUS_WIDTH-1:0] sum_d;
  wire [BUS_WIDTH-1:0] difference_d;
  wire [BUS_WIDTH-1:0] product_d;
  wire [BUS_WIDTH-1:0] quotient_d;
  wire [BUS_WIDTH-1:0] sqrt_d;
  wire [BUS_WIDTH-1:0] fcvt_ld;
  wire [BUS_WIDTH-1:0] fcvt_dl;

  wire [BUS_WIDTH-1:0] fpmin_d;
  wire [BUS_WIDTH-1:0] fpmax_d;
  wire [BUS_WIDTH-1:0] feq_d;
  wire [BUS_WIDTH-1:0] flt_d;
  wire [BUS_WIDTH-1:0] fle_d;
  wire [BUS_WIDTH-1:0] fsgnj_d;
  wire [BUS_WIDTH-1:0] fsgnjn_d;
  wire [BUS_WIDTH-1:0] fsgnjx_d;

  wire [31:0] sum_s;
  wire [31:0] difference_s;
  wire [31:0] product_s;
  wire [31:0] quotient_s;
  wire [31:0] sqrt_s;

  wire [31:0] fpmin_s;
  wire [31:0] fpmax_s;
  wire [31:0] feq_s;
  wire [31:0] flt_s;
  wire [31:0] fle_s;
  wire [31:0] fsgnj_s;
  wire [31:0] fsgnjn_s;
  wire [31:0] fsgnjx_s;

  FPAdder #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_addition_d (
      .in1(in1),
      .in2(in2),
      .out(sum_d)
  );
  FPSub #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_subtraction_d (
      .in1(in1),
      .in2(in2),
      .out(difference_d)
  );
  FPMul #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_multiplication_d (
      .in1(in1),
      .in2(in2),
      .out(product_d)
  );
  FPDiv #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_division_d (
      .in1(in1),
      .in2(in2),
      .out(quotient_d)
  );
  FSQRT #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_sqrt_d (
      .in1(in1),
      .out(sqrt_d)
  );

  // Min/Max
  FPMin #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_min_d (
      .in1(in1),
      .in2(in2),
      .out(fpmin_d)
  );
  FPMax #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_max_d (
      .in1(in1),
      .in2(in2),
      .out(fpmax_d)
  );
  FPMin #(
      .BUS_WIDTH(32)
  ) fp_min_s (
      .in1(in1),
      .in2(in2),
      .out(fpmin_s)
  );
  FPMax #(
      .BUS_WIDTH(32)
  ) fp_max_s (
      .in1(in1),
      .in2(in2),
      .out(fpmax_s)
  );

  // Comparison
  FEQ #(
      .BUS_WIDTH(BUS_WIDTH)
  ) f_eq_d (
      .in1(in1),
      .in2(in2),
      .out(feq_d)
  );
  FLT #(
      .BUS_WIDTH(BUS_WIDTH)
  ) f_lt_d (
      .in1(in1),
      .in2(in2),
      .out(flt_d)
  );
  FLE #(
      .BUS_WIDTH(BUS_WIDTH)
  ) f_le_d (
      .in1(in1),
      .in2(in2),
      .out(fle_d)
  );

  FEQ #(
      .BUS_WIDTH(32)
  ) f_eq_s (
      .in1(in1),
      .in2(in2),
      .out(feq_s)
  );
  FLT #(
      .BUS_WIDTH(32)
  ) f_lt_s (
      .in1(in1),
      .in2(in2),
      .out(flt_s)
  );
  FLE #(
      .BUS_WIDTH(32)
  ) f_le_s (
      .in1(in1),
      .in2(in2),
      .out(fle_s)
  );

  // FCVT
  FCVT_int #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_ld (
      .in1(in1),
      .out(fcvt_ld)
  );
  FCVT_fp #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fp_dl (
      .in1(in1),
      .out(fcvt_dl)
  );
  FPAdder #(
      .BUS_WIDTH(32)
  ) fp_addition_s (
      .in1(in1),
      .in2(in2),
      .out(sum_s)
  );
  FPSub #(
      .BUS_WIDTH(32)
  ) fp_subtraction_s (
      .in1(in1),
      .in2(in2),
      .out(difference_s)
  );
  FPMul #(
      .BUS_WIDTH(32)
  ) fp_multiplication_s (
      .in1(in1),
      .in2(in2),
      .out(product_s)
  );
  FPDiv #(
      .BUS_WIDTH(32)
  ) fp_division_s (
      .in1(in1),
      .in2(in2),
      .out(quotient_s)
  );
  FSQRT #(
      .BUS_WIDTH(32)
  ) fp_sqrt_s (
      .in1(in1),
      .out(sqrt_s)
  );

  // Sign Injection

  FSGNJ #(
      .BUS_WIDTH(BUS_WIDTH)
  ) f_sgnj_d (
      .in1(in1),
      .in2(in2),
      .out(fsgnj_d)
  );
  FSGNJ #(
      .BUS_WIDTH(BUS_WIDTH)
  ) f_sgnjn_d (
      .in1(in1),
      .in2(in2),
      .out(fsgnjn_d)
  );
  FSGNJX #(
      .BUS_WIDTH(BUS_WIDTH)
  ) f_sgnjx_d (
      .in1(in1),
      .in2(in2),
      .out(fsgnjx_d)
  );

  FSGNJ #(
      .BUS_WIDTH(32)
  ) f_sgnj_s (
      .in1(in1),
      .in2(in2),
      .out(fsgnj_s)
  );
  FSGNJ #(
      .BUS_WIDTH(32)
  ) f_sgnjn_s (
      .in1(in1),
      .in2(in2),
      .out(fsgnjn_s)
  );
  FSGNJX #(
      .BUS_WIDTH(32)
  ) f_sgnjx_s (
      .in1(in1),
      .in2(in2),
      .out(fsgnjx_s)
  );
  always @(*) begin
    case (fpu_op)

      // Arithmetic
      6'b000000: begin
        out = sum_d;
      end
      6'b000001: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, sum_s} : sum_s;
      end
      6'b000010: begin
        out = difference_d;
      end
      6'b000011: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, difference_s} : difference_s;
      end
      6'b000100: begin
        out = product_d;
      end
      6'b000101: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, product_s} : product_s;
      end
      6'b000110: begin
        out = quotient_d;
      end
      6'b000111: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, quotient_s} : quotient_s;
      end
      6'b001000: begin
        out = sqrt_d;
      end
      6'b001001: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, sqrt_s} : sqrt_s;
      end

      // Min/Max
      6'b010000: begin
        out = fpmin_d;
      end
      6'b010001: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, fpmin_s} : fpmin_s;
      end
      6'b010010: begin
        out = fpmax_d;
      end
      6'b010011: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, fpmax_s} : fpmax_s;
      end

      // Comparison
      6'b010100: begin
        out = feq_d;
      end
      6'b010101: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, feq_s} : feq_s;
      end
      6'b010110: begin
        out = flt_d;
      end
      6'b010111: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, flt_s} : flt_s;
      end
      6'b011000: begin
        out = fle_d;
      end
      6'b011001: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, fle_s} : fle_s;
      end

      // Sign Injection
      6'b011010: begin
        out = fsgnj_d;
      end
      6'b011011: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, fsgnj_s} : fsgnj_s;
      end
      6'b011100: begin
        out = fsgnjn_d;
      end
      6'b011101: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, fsgnjn_s} : fsgnjn_s;
      end
      6'b011110: begin
        out = fsgnjx_d;
      end
      6'b011111: begin
        out = (BUS_WIDTH == 64) ? {PAD_ZERO, fsgnjx_s} : fsgnjx_s;
      end

      // Move Operations
      6'b100000: begin
        out = in1;
      end
      6'b100001: begin
        out = in1;
      end

      default: begin
        out = 64'b0;
      end
    endcase
  end





  // always @(*) begin
  //   case (fpu_op)
  //     5'b00000: begin
  //       out = sum_d;
  //       //fpu_rd = 1;
  //       //fpu_rs1 = 1;
  //     end
  //     5'b00001: begin
  //       out = difference_d;
  //       //fpu_rd = 1;
  //       //fpu_rs1 = 1;
  //     end
  //     5'b00010: begin
  //       out = product_d;
  //       //fpu_rs1 = 1;
  //       //fpu_rd = 1;
  //     end
  //     5'b00011: begin
  //       out = quotient_d;
  //       //fpu_rd = 1;
  //       //fpu_rs1 = 1;
  //     end
  //     5'b00100: begin
  //       out = sqrt_d;
  //       //fpu_rd = 1;
  //       //fpu_rs1 = 1;
  //     end
  //     5'b00101: begin
  //       out = fcvt_ld;
  //       //fpu_rd = 0;
  //       //fpu_rs1 = 1;
  //     end
  //     5'b00110: begin
  //       out = fcvt_dl;
  //       // fpu_rd = 1;
  //       // fpu_rs1 = 0;
  //     end
  //     5'b00111: begin
  //       // fmv.x.d
  //       out = in1;
  //       // fpu_rd = 0;
  //       // fpu_rs1 = 1;
  //     end
  //     5'b01000: begin
  //       out = in1;
  //       // fpu_rd = 1;
  //       // fpu_rs1 = 0;
  //     end
  //     5'b01001: begin
  //       out = sum_s;
  //     end
  //     5'b01010: begin
  //       out = difference_s;
  //     end
  //     5'b01011: begin
  //       out = product_s;
  //     end
  //     5'b01100: begin
  //       out = quotient_s;
  //     end
  //     5'b01101: begin
  //       out = sqrt_s;
  //     end
  //   endcase
  // end

endmodule
