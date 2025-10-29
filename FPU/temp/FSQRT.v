module FSQRT (
    input  [63:0] x,
    output [63:0] y
);
  wire [63:0] quotient;
  FPDiv FSQRT_div (
      .N1 (64'h3ff0000000000000),
      .N2 (x),
      .out(quotient)
  );
  quake3 FSQRT_quake (
      .x(quotient),
      .y(y)
  );

endmodule
