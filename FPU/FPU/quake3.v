module quake3 #(
    parameter BUS_WIDTH = 64
) (
    input  [BUS_WIDTH-1:0] x,
    output [BUS_WIDTH-1:0] y
);
  localparam MAGIC_NUMBER = (BUS_WIDTH == 64) ? 64'h5FE6EB50C7B537A9 : 32'h5f3759df;
  wire [BUS_WIDTH-1:0] y_1 = (MAGIC_NUMBER) - (x >> 1'b1);
  // wire [BUS_WIDTH-1:0] y_nr_1;
  // //wire [63:0] y_nr_2;
  // newton_ralphson nr_1 (
  //     .x(x),
  //     .y(y_1),
  //     .y_nr(y_nr_1)
  // );
  /*
  newton_ralphson nr_2 (
      .x(x),
      .y(y_nr_1),
      .y_nr(y_nr_2)
  );
  */
  assign y = y_1;
endmodule
