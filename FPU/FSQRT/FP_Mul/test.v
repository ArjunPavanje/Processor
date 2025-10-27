
`timescale 1ns / 1ps

module FPMul_tb;

  reg [63:0] N1;
  reg [63:0] N2;
  wire [63:0] out;
  wire [63:0] temp1;
  wire [63:0] temp2;
  wire [127:0] mantissa_product;
  wire [52:0] mantissa_normalized;
  wire [52:0] mantissa_renormalized;
  wire [52:0] mantissa_rounded;
  wire round;
  FPMul uut (
      .N1 (N1),
      .N2 (N2),
      .out(out)
  );
  assign temp1 = uut.temp1;
  assign temp2 = uut.temp2;
  assign mantissa_product = uut.mantissa_product;
  assign mantissa_normalized = uut.mantissa_normalized;
  assign mantissa_renormalized = uut.mantissa_renormalized;
  assign mantissa_rounded = uut.mantissa_rounded;
  assign round = uut.round;
  initial begin
    $dumpvars(0, FPMul_tb);

    // Test 1: 2.0 * 3.0
    N1 = 64'h4000000000000000;  // 2.0
    N2 = 64'h4008000000000000;  // 3.0
    #10;
    $display("Test 1: 2.0 * 3.0, Output: %h", out);
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);
    //$display("Mantissa Normlized: %h", mantissa_normalized);
    //$display("Mantissa Rounded: %h", mantissa_rounded);
    //$display("Round or not: %h", round);
    //$display("Mantissa REnormalized: %h", mantissa_renormalized);


    // Test 2: 0.0 * 123.0
    N1 = 64'h0000000000000000;  // 0.0
    N2 = 64'h405ec00000000000;  // 123.0
    #10;
    $display("Test 2: 0.0 * 123.0, Output: %h", out);
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);


    // Test 3: 1.5 * 5.0
    N1 = 64'h3ff8000000000000;  // 1.5
    N2 = 64'h4014000000000000;  // 5.0
    #10;
    $display("Test 3: 1.5 * 5.0, Output: %h", out);
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);


    // Test 4: -2.0 * 3.0
    N1 = 64'hc000000000000000;  // -2.0
    N2 = 64'h4008000000000000;  // 3.0
    #10;
    $display("Test 4: -2.0 * 3.0, Output: %h", out);
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);


    // Test 5: 0.0 * 0.0
    N1 = 64'h0000000000000000;  // 0.0
    N2 = 64'h0000000000000000;  // 0.0
    #10;
    $display("Test 5: 0.0 * 0.0, Output: %h", out);

    // Test 6: 1.0 * 1.0
    N1 = 64'h3ff0000000000000;  // 1.0
    N2 = 64'h3ff0000000000000;  // 1.0
    #10;
    $display("Test 6: 1.0 * 1.0, Output: %h", out);

    // Test 7: 10.0 * 0.1
    N1 = 64'h4024000000000000;  // 10.0
    N2 = 64'h3fb999999999999a;  // 0.1
    #10;
    $display("Test 7: 10.0 * 0.1, Output: %h", out);

    // Test 8: -5.0 * -5.0
    N1 = 64'hc014000000000000;  // -5.0
    N2 = 64'hc014000000000000;  // -5.0
    #10;
    $display("Test 8: -5.0 * -5.0, Output: %h", out);


    $finish;
  end
endmodule
