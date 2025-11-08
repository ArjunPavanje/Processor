module FEQ #(
    parameter BUS_WIDTH = 64
) (
    input  [BUS_WIDTH-1:0] in1,
    input  [BUS_WIDTH-1:0] in2,
    output [BUS_WIDTH-1:0] out
);
  localparam EQUAL = (BUS_WIDTH == 64) ? 64'd1 : 32'd1;
  localparam NOT_EQUAL = (BUS_WIDTH == 64) ? 64'd0 : 32'd0;

  assign out = (in1 == in2) ? EQUAL : NOT_EQUAL;
endmodule
