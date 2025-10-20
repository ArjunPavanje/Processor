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
    input wire [63:0] a,  // input #1
    input wire [63:0] b,  // input #2
    input wire cin,  // carry in
    output wire [63:0] sum,
    output wire cout  // carry out
);
  // inner wiring to make the to transfer carry
  wire cinner[64:0];
  assign cinner[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin
      full_adder fa (
          .a(a[i]),
          .b(b[i]),
          .cin(cinner[i]),
          .sum(sum[i]),
          .cout(cinner[i+1])
      );
    end
  endgenerate

  assign cout = cinner[64];
endmodule

// extended_adder -> adder with inputs 128 bit
// used in mul, has no cin wire
module extended_adder (
    input wire [127:0] a,  // input #1
    input wire [127:0] b,  // input #2

    output wire [127:0] sum
);
  // inner wiring to make the to transfer carry
  wire cinner[128:0];
  assign cinner[0] = 1'b0;

  genvar i;
  generate
    for (i = 0; i < 128; i = i + 1) begin
      full_adder fa (
          .a(a[i]),
          .b(b[i]),
          .cin(cinner[i]),
          .sum(sum[i]),
          .cout(cinner[i+1])
      );
    end
  endgenerate

  assign cout = cinner[128];
endmodule
