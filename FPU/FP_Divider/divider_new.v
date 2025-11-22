`include "/Users/arjunpavanje/Documents/Github/Processor/FPU/FP_Divider/quake3_div.v"
module FPDiv_Quake3 #(
    parameter BUS_WIDTH = 64
) (
    input  [BUS_WIDTH-1:0] in1,
    input  [BUS_WIDTH-1:0] in2,
    output [BUS_WIDTH-1:0] out
);

  localparam MANTISSA_SIZE = (BUS_WIDTH == 64) ? 52 : 23;
  localparam EXPONENT_SIZE = (BUS_WIDTH == 64) ? 11 : 8;
  localparam BIAS = (BUS_WIDTH == 64) ? 1023 : 127;
  localparam IS_INFINITY = (BUS_WIDTH == 64) ? 11'h7FF : 8'hFF;
  localparam NAN = (BUS_WIDTH == 64) ? 64'h7ff8000000000000 : 32'h7fc00000;
  localparam INFINITY_P = (BUS_WIDTH == 64) ? 64'h7ff0000000000000 : 32'h7f800000;
  localparam INFINITY_N = (BUS_WIDTH == 64) ? 64'hfff0000000000000 : 32'hff800000;
  localparam ZERO = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;

  wire [MANTISSA_SIZE-1:0] M_1 = in1[MANTISSA_SIZE-1:0];
  wire [MANTISSA_SIZE-1:0] M_2 = in2[MANTISSA_SIZE-1:0];
  wire [EXPONENT_SIZE-1:0] E_1 = in1[BUS_WIDTH-2:MANTISSA_SIZE];
  wire [EXPONENT_SIZE-1:0] E_2 = in2[BUS_WIDTH-2:MANTISSA_SIZE];
  wire S_1 = in1[BUS_WIDTH-1];
  wire S_2 = in2[BUS_WIDTH-1];

  // Compute reciprocal of b using: 1/b = 1/sqrt(b^2) * sign(b)
  // First get b^2
  wire [BUS_WIDTH-1:0] divisor_sq;
  FPMul #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fpdiv_divisor_square (
      .in1(in2),
      .in2(in2),
      .out(divisor_sq)
  );

  // Get 1/sqrt(b^2) using Quake3
  wire [BUS_WIDTH-1:0] inv_abs_divisor;
  quake3_div #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fpdiv_quake3 (
      .x(divisor_sq),
      .y(inv_abs_divisor)
  );

  // Fix the sign: if b was negative, flip sign of 1/|b|
  wire [BUS_WIDTH-1:0] inv_divisor;
  assign inv_divisor = {S_2, inv_abs_divisor[BUS_WIDTH-2:0]};

  // Multiply a * (1/b)
  wire [BUS_WIDTH-1:0] out_1;
  FPMul #(
      .BUS_WIDTH(BUS_WIDTH)
  ) fpdiv_fpmul (
      .in1(in1),
      .in2(inv_divisor),
      .out(out_1)
  );

  // Special case handling
  wire is_inf_1 = (E_1 == IS_INFINITY) && ~(|M_1);
  wire is_inf_2 = (E_2 == IS_INFINITY) && ~(|M_2);
  wire is_nan_1 = (E_1 == IS_INFINITY) && (|M_1);
  wire is_nan_2 = (E_2 == IS_INFINITY) && (|M_2);
  wire is_zero_1 = ~(|in1[BUS_WIDTH-2:0]);
  wire is_zero_2 = ~(|in2[BUS_WIDTH-2:0]);

  wire [EXPONENT_SIZE-1:0] exp_result = out_1[BUS_WIDTH-2:MANTISSA_SIZE];
  wire exp_overflow = (exp_result == IS_INFINITY);
  wire exp_underflow = ~(|exp_result) && ~(|out_1[MANTISSA_SIZE-1:0]);

  // NaN cases: 0/0, inf/inf, NaN inputs
  wire is_NaN = (is_zero_1 & is_zero_2) | (is_inf_1 & is_inf_2) | is_nan_1 | is_nan_2;

  // Infinity cases: non-zero/0, inf/(non-inf)
  wire is_inf = ~is_NaN & (is_inf_1 | (is_zero_2 & ~is_zero_1) | exp_overflow);

  // Zero cases: 0/(non-zero), (non-inf)/inf
  wire is_zero = ~is_NaN & ((is_zero_1 & ~is_zero_2) | (is_inf_2 & ~is_inf_1) | exp_underflow);

  wire [BUS_WIDTH-1:0] out_inf = (S_1 ^ S_2) ? INFINITY_N : INFINITY_P;

  assign out = is_NaN ? NAN : (is_inf ? out_inf : (is_zero ? ZERO : out_1));

endmodule
