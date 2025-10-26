`include "adder/adder.v"

module addsub (
    input wire [63:0] a,  // input #1
    input wire [63:0] b,  // input #2
    input wire sel,  // 0 for add, 1 for sub

    output wire [63:0] res,
    output wire cout  // carry out
);
  // inner wiring to make the to transfer carry
  wire cinner[64:0];
  assign cinner[0] = sel;

  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : adders
      full_adder fa (
          .a(a[i]),
          .b(sel ? (~b[i]) : b[i]),
          .cin(cinner[i]),
          .sum(res[i]),
          .cout(cinner[i+1])
      );
    end
  endgenerate

  assign cout = cinner[64];
endmodule
