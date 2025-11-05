module FCVT_fp #(
    parameter BUS_WIDTH = 64
) (
    input  [BUS_WIDTH-1:0] in1,
    output [BUS_WIDTH-1:0] out
);
  // Main parameters
  localparam MANTISSA_SIZE = (BUS_WIDTH == 64) ? 52 : 23;
  localparam EXPONENT_SIZE = (BUS_WIDTH == 64) ? 11 : 8;
  localparam BIAS = (BUS_WIDTH == 64) ? 1023 : 127;

  // Other parameters
  localparam PAD_ONE = (BUS_WIDTH == 64) ? 64'b1 : 32'b1;
  localparam EXP_PAD = (BUS_WIDTH == 64) ? 11'd0 : 8'd0;
  localparam MANTISSA_PAD = (BUS_WIDTH == 64) ? 52'd0 : 23'd0;
  localparam ZERO = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;

  // Checking sign
  wire S = in1[BUS_WIDTH-1];
  wire [BUS_WIDTH-1:0] mod = (S) ? (~in1 + PAD_ONE) : in1;

  // Finding leading 1
  wire [EXPONENT_SIZE-1:0] index;

  leading_1 #(
      .BUS_WIDTH(BUS_WIDTH)
  ) FCVT (
      .num  (mod),
      .index(index)
  );

  wire [EXPONENT_SIZE-1:0] idex = (|mod) ? (index) : (EXP_PAD);
  wire [EXPONENT_SIZE-1:0] E = idex + BIAS;
  wire [BUS_WIDTH-1:0] mantissa_shifted = mod << (BUS_WIDTH - 1 - index);
  wire [MANTISSA_SIZE-1:0] M = (|mod) ? mantissa_shifted[BUS_WIDTH-2:EXPONENT_SIZE] : MANTISSA_PAD;

  wire is_zero = ~|in1[BUS_WIDTH-1:0];
  assign out = (is_zero) ? ZERO : ({S, E, M});

endmodule
