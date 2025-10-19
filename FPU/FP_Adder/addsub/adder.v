// full adder
module full_adder (
    input  wire a,    // input #1
    input  wire b,    // input #2
    input  wire cin,  // carry in
    output wire sum,
    output wire cout  // carry out
);
  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder (
    input wire [10:0] a,  // input #1
    input wire [10:0] b,  // input #2
    input wire cin,  // carry in
    output wire [10:0] sum,
    output wire cout  // carry out
);
  // inner wiring to make the to transfer carry
  wire cinner[11:0];
  assign cinner[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 11; i = i + 1) begin
      full_adder fa (
          .a(a[i]),
          .b(b[i]),
          .cin(cinner[i]),
          .sum(sum[i]),
          .cout(cinner[i+1])
      );
    end
  endgenerate

  assign cout = cinner[11];
endmodule

module adder1 (
    input wire [52:0] a,  // input #1
    input wire [52:0] b,  // input #2
    input wire cin,  // carry in
    output wire [52:0] sum,
    output wire cout  // carry out
);
  // inner wiring to make the to transfer carry
  wire cinner[53:0];
  assign cinner[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 53; i = i + 1) begin
      full_adder fa (
          .a(a[i]),
          .b(b[i]),
          .cin(cinner[i]),
          .sum(sum[i]),
          .cout(cinner[i+1])
      );
    end
  endgenerate

  assign cout = cinner[53];
endmodule
