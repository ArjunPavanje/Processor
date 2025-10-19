`include "shift/sl/sl.v"
`include "shift/sr/sr.v"
`include "shift/accum_decoder.v"

module shift_left (
    input wire [52:0] in,
    input wire [10:0] amt, // shift amount

    output wire [52:0] out
);
  wire [52:0] enables;  // each shift block is enabled or not

  accum_decoder #(
      .N(11)
  ) sl_enables_decoder (
      .in (amt),
      .set(1'b0),
      .out(enables)
  );

  genvar i;

  generate
    for (i = 0; i < 53; i = i + 1) begin : sl_internal
      // This loop creates 53 separate internal wires
      // sl_internal[i].sl_stage_bus
      wire [52:0] sl_stage_bus;
    end
  endgenerate

  sl unit_shift (
      .in (in),
      .en (enables[0]),
      .out(sl_internal[0].sl_stage_bus)
  );

  generate
    for (i = 1; i < 53; i = i + 1) begin : sl_blocks
      sl unit_shift (
          .in (sl_internal[i-1].sl_stage_bus),
          .en (enables[i]),
          .out(sl_internal[i].sl_stage_bus)
      );
    end
  endgenerate

  assign out = sl_internal[52].sl_stage_bus;
endmodule

module shift_right (
    input wire [52:0] in,
    input wire [10:0] amt, // shift amount

    input wire arithmetic,  // arithmetic shift or not
    output wire [52:0] out
);
  wire [53:0] enables;  // each shift block is enabled or not

  accum_decoder #(
      .N(11)
  ) sr_enables_decoder (
      .in (amt),
      .set(1'b0),
      .out(enables)
  );

  genvar i;

  generate
    for (i = 0; i < 53; i = i + 1) begin : sr_internal
      // This loop creates 53 separate internal wires
      // sr_internal[i].sr_stage_bus
      wire [52:0] sr_stage_bus;
    end
  endgenerate

  sr unit_shift (
      .in(in),
      .en(enables[0]),
      .arithmetic(1'b0),
      .out(sr_internal[0].sr_stage_bus)
  );

  generate
    for (i = 1; i < 53; i = i + 1) begin : sr_blocks
      sr unit_shift (
          .in(sr_internal[i-1].sr_stage_bus),
          .en(enables[i]),
          .arithmetic(arithmetic),
          .out(sr_internal[i].sr_stage_bus)
      );
    end
  endgenerate

  assign out = sr_internal[52].sr_stage_bus;
endmodule
