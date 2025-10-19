`include "addsub/adder.v"

module addsub (
    input wire [10:0] a,  // input #1
    input wire [10:0] b,  // input #2
    input wire sel,  // 0 for add, 1 for sub

    output wire [10:0] res,
    output wire cout  // carry out
);
  // inner wiring to make the to transfer carry
  wire cinner[11:0];
  assign cinner[0] = sel;

  genvar i;
  generate
    for (i = 0; i < 11; i = i + 1) begin : adders
      full_adder fa (
          .a(a[i]),
          .b(sel ? (~b[i]) : b[i]),
          .cin(cinner[i]),
          .sum(res[i]),
          .cout(cinner[i+1])
      );
    end
  endgenerate

  assign cout = cinner[11];
endmodule

module addsub1 (
    input wire [52:0] a,  // input #1
    input wire [52:0] b,  // input #2
    input wire sel,  // 0 for add, 1 for sub

    output wire [52:0] res,
    output wire cout  // carry out
);
  // inner wiring to make the to transfer carry
  wire cinner[53:0];
  assign cinner[0] = sel;

  genvar i;
  generate
    for (i = 0; i < 53; i = i + 1) begin : adders
      full_adder fa (
          .a(a[i]),
          .b(sel ? (~b[i]) : b[i]),
          .cin(cinner[i]),
          .sum(res[i]),
          .cout(cinner[i+1])
      );
    end
  endgenerate

  assign cout = cinner[53];
endmodule
