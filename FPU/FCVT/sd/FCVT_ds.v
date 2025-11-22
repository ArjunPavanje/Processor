module FPMul #(
    parameter BUS_WIDTH = 64, 
    parameter INPUT_WIDTH = 64,
    parameter OUTPUT_WIDTH = 32
) (
    input  [INPUT_WIDTH-1:0] in1,
    output [OUTPUT_WIDTH-1:0] out
);

  // Main parameters
  localparam INPUT_MANTISSA_SIZE = 52; 
  localparam OUTPUT_MANTISSA_SIZE = 23;
  localparam INPUT_EXPONENT_SIZE =  11;
  localparam OUTPUT_EXPONENT_SIZE =  8;
  localparam INPUT_BIAS = 1023; 
  localparam OUTPUT_BIAS = 127; 

  // localparam EXPONENT_SIZE = (BUS_WIDTH == 64) ? 11 : 8;
  // localparam BIAS = (BUS_WIDTH == 64) ? 1023 : 127;

  // Other non-important parameters
  localparam LEADING_ONE = (BUS_WIDTH == 64) ? 12'd1 : 9'd1;
  localparam PRODUCT_PAD = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;
  localparam ROUND_UP = (BUS_WIDTH == 64) ? 64'd1 : 32'd1;
  localparam PAD_ZERO = 1'b0;
  localparam ROUND_DOWN = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;
  localparam EXPONENT_INC = (BUS_WIDTH == 64) ? 12'd1 : 9'd1;
  localparam EXPONENT_NO_CHANGE = (BUS_WIDTH == 64) ? 12'd0 : 9'd0;
  localparam PAD_2 = (BUS_WIDTH == 64) ? 12'd0 : 9'd0;
  localparam IS_INFINITY = (BUS_WIDTH == 64) ? 11'h7FF : 8'hFF;
  localparam NAN = (BUS_WIDTH == 64) ? 64'h7ff8000000000000 : 32'h7fc00000;
  localparam INFINITY_P = (BUS_WIDTH == 64) ? 64'h7ff0000000000000 : 32'h7f800000;
  localparam INFINITY_N = (BUS_WIDTH == 64) ? 64'hfff0000000000000 : 32'hff800000;
  localparam ZERO = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;

  // Extracting Sign, Exponent, Mantissa
  wire [INPUT_MANTISSA_SIZE-1:0] M_1;
  wire [OUTPUT_MANTISSA_SIZE-1:0] M_2;
  wire [INPUT_EXPONENT_SIZE-1:0] E_1;
  wire [OUTPUT_EXPONENT_SIZE-1:0] E_2;
  wire S_1;
  wire S_2;
  assign M_1 = in1[INPUT_MANTISSA_SIZE-1:0];
  assign M_2 = in2[MANTISSA_SIZE-1:0];

  assign E_1 = in1[BUS_WIDTH-2:MANTISSA_SIZE];
  assign E_2 = in2[BUS_WIDTH-2:MANTISSA_SIZE];

  assign S_1 = in1[BUS_WIDTH-1];
  assign S_2 = in2[BUS_WIDTH-1];
endmodule
