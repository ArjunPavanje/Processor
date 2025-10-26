`include "shift/sl/asl.v"
//`include "adder/adder.v"
`include "mul/adder_tree/adder_tree.v"

module mul (
    input wire [63:0] a,  // input #1
    input wire [63:0] b,  // input #2
    input wire sign,  // 0 -> unsigned, 1 -> signed number

    output wire [127:0] res  // 128 bit result
);
  wire [127:0] in_128;

  // sign extend one of the inputs, if sign == 1
  assign in_128 = {(sign ? {64{a[63]}} : 64'b0), a};

  // flattened and shifted input to the add tree
  wire [(128*64 - 1):0] flat_shift;

  genvar i;

  assign flat_shift[127:0] = in_128;

  generate
    for (i = 1; i < 64; i = i + 1) begin
      asl asl1 (
          .in (flat_shift[(128*i-1):(128*(i-1))]),
          .out(flat_shift[(128*(i+1)-1):(128*i)])
      );
    end
  endgenerate


  wire [(128*64 - 1):0] flat_shift_enabled;  // after and-ing with bits of b

  generate
    for (i = 0; i < 64; i = i + 1) begin
      assign flat_shift_enabled[(128*(i + 1) - 1):(128*i)] = flat_shift[(128*(i + 1) - 1):(128*i)] & {128{b[i]}};
    end
  endgenerate


  adder_tree tree (
      .in (flat_shift_enabled),
      .sum(res)
  );

endmodule
