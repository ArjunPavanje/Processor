module newton_ralphson (
    input  [63:0] x,
    input  [63:0] y,
    output [63:0] y_nr
);
  wire [63:0] y_sq;
  wire [63:0] y_2;
  wire [63:0] y_3;
  wire [63:0] y_4;
  wire [63:0] y_5;

  // y^2
  FPMul quake3_y_sq (
      .in1(y),
      .in2(y),
      .out(y_sq)
  );

  // Y^2/2
  FPMul quake3_mul1 (
      .in1(y_sq),
      .in2(64'h3fe0000000000000),
      .out(y_2)
  );

  // xy^2/2
  FPMul quake3_mul2 (
      .in1(y_2),
      .in2(x),
      .out(y_3)
  );

  // 3/2 - (xy^2/2)
  assign y_4 = y_3 ^ 64'h8000000000000000;
  FPAdder quake_add_1 (
      .in1(64'h3ff8000000000000),
      .in2(y_4),
      .out(y_5)
  );

  // y*(3/2 - (xy^2/2))
  FPMul quake_mul3 (
      .in1(y),
      .in2(y_5),
      .out(y_nr)
  );
endmodule
