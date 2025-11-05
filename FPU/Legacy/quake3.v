module quake3 (
    input  [63:0] x,
    output [63:0] y
);
  wire [63:0] y_1 = (64'h5FE6EB50C7B537A9) - (x >> 1'b1);
  wire [63:0] y_nr_1;
  wire [63:0] y_nr_2;
  newton_ralphson nr_1 (
      .x(x),
      .y(y_1),
      .y_nr(y_nr_1)
  );
  newton_ralphson nr_2 (
      .x(x),
      .y(y_nr_1),
      .y_nr(y_nr_2)
  );

  assign y = y_nr_2;
endmodule
