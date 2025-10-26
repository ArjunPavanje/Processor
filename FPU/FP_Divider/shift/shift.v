
`include "shift/sl/sl.v"
`include "shift/sr/sr.v"
module shift_left (
    input wire [63:0] in,
    input wire [ 5:0] amt, // shift amount

    output wire [63:0] out
);
  wire [63:0] sl_internal[0:5];

  sl #(
      .N(0)
  ) sub_sl (
      .in (in),
      .en (amt[0]),
      .out(sl_internal[0])
  );

  sl #(
      .N(1)
  ) sub_sl_2 (
      .in (sl_internal[0]),
      .en (amt[0]),
      .out(sl_internal[1])
  );

  sl #(
      .N(2)
  ) sub_sl_4 (
      .in (sl_internal[1]),
      .en (amt[0]),
      .out(sl_internal[2])
  );

  sl #(
      .N(3)
  ) sub_sl_8 (
      .in (sl_internal[2]),
      .en (amt[0]),
      .out(sl_internal[3])
  );

  sl #(
      .N(4)
  ) sub_sl_16 (
      .in (sl_internal[3]),
      .en (amt[0]),
      .out(sl_internal[4])
  );

  sl #(
      .N(5)
  ) sub_sl_32 (
      .in (sl_internal[4]),
      .en (amt[0]),
      .out(sl_internal[5])
  );



  assign out = sl_internal[5];
endmodule
/*
module shift_right (
    input wire [63:0] in,
    input wire [ 5:0] amt, // shift amount

    input wire arithmetic,  // arithmetic shift or not
    output wire [63:0] out
);
  wire [63:0] enables;  // each shift block is enabled or not

  accum_decoder #(
      .N(6)
  ) sr_enables_decoder (
      .in (amt),
      .set(1'b0),
      .out(enables)
  );

  genvar i;

  generate
    for (i = 0; i < 64; i = i + 1) begin : sr_internal
      // This loop creates 64 separate internal wires
      // sr_internal[i].sr_stage_bus
      wire [63:0] sr_stage_bus;
    end
  endgenerate

  sr unit_shift (
      .in(in),
      .en(enables[0]),
      .arithmetic(arithmetic),
      .out(sr_internal[0].sr_stage_bus)
  );

  generate
    for (i = 1; i < 64; i = i + 1) begin : sr_blocks
      sr unit_shift (
          .in(sr_internal[i-1].sr_stage_bus),
          .en(enables[i]),
          .arithmetic(arithmetic),
          .out(sr_internal[i].sr_stage_bus)
      );
    end
  endgenerate

  assign out = sr_internal[63].sr_stage_bus;
endmodule
*/
