
`timescale 1ns / 1ps

module FPDiv_tb;

  reg [63:0] N1;
  reg [63:0] N2;
  wire [63:0] out;
  wire [63:0] temp1;
  wire [63:0] temp2;
  wire [51:0] M1;
  wire [51:0] M2;
  wire [127:0] mantissa_product;
  wire [63:0] mantissa_normalized;
  wire [52:0] mantissa_renormalized;
  wire [52:0] mantissa_rounded;
  wire round;
  FPDiv uut (
      .N1 (N1),
      .N2 (N2),
      .out(out)
  );
  assign mantissa_product = uut.mantissa_product;
  assign mantissa_normalized = uut.mantissa_normalized;
  assign mantissa_renormalized = uut.mantissa_renormalized;
  assign mantissa_rounded = uut.mantissa_rounded;
  assign M1 = uut.M_1;
  assign M2 = uut.M_2;
  assign round = uut.round;
  initial begin
    $dumpvars(0, FPDiv_tb);

    // Test 1: 2.0 div 3.0
    N2 = 64'h4000000000000000;  // 2.0
    N1 = 64'h4008000000000000;  // 3.0
    #10;
    $display("Test 1: 3.0 div 2.0, Output: %h", out);
    //$display("M1: %h", M1);
    //$display("M2: %h", M2);
    //$display("Mantissa Quotient %h", mantissa_product);
    //$display("Normalized Mantissa: %h", mantissa_normalized);
    /*
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);
    //$display("Mantissa Normlized: %h", mantissa_normalized);
    //$display("Mantissa Rounded: %h", mantissa_rounded);
    //$display("Round or not: %h", round);
    //$display("Mantissa REnormalized: %h", mantissa_renormalized);
    */

    // Test 2: 2.0 div 123.0
    N1 = 64'h4000000000000000;  // 2.0
    N2 = 64'h405ec00000000000;  // 123.0
    #10;
    $display("Test 2: 2.0 div 123.0, Output: %h", out);
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);


    // Test 3: 1.5 div 5.0
    N1 = 64'h3ff8000000000000;  // 1.5
    N2 = 64'h4014000000000000;  // 5.0
    #10;
    $display("Test 3: 1.5 div 5.0, Output: %h", out);
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);


    // Test 4: -2.0 div 3.0
    N1 = 64'hc000000000000000;  // -2.0
    N2 = 64'h4008000000000000;  // 3.0
    #10;
    $display("Test 4: -2.0 div 3.0, Output: %h", out);
    //$display("temp1: %h", temp1);
    //$display("temp2: %h", temp2);
    //$display("Mantissa Product: %h", mantissa_product);

    /*
    // Test 5: 0.0 div 0.0
    N1 = 64'h0000000000000000;  // 0.0
    N2 = 64'h0000000000000000;  // 0.0
    #10;
    $display("Test 5: 5.0 div 2.0, Output: %h", out[51:0]);
    */

    // Test 6: 1.0 div 1.0
    N1 = 64'h4014000000000000;  // 5.0
    N2 = 64'h4000000000000000;  // 2.0
    #10;
    $display("Test 6: 1.0 div 1.0, Output: %h", out);

    // Test 7: 10.0 div 0.1
    N1 = 64'h4024000000000000;  // 10.0
    N2 = 64'h3fb999999999999a;  // 0.1
    #10;
    $display("Test 7: 10.0 div 0.1, Output: %h", out);

    // Test 8: -5.0 div -5.0
    N1 = 64'hc014000000000000;  // -5.0
    N2 = 64'hc014000000000000;  // -5.0
    #10;
    $display("Test 8: -5.0 div -5.0, Output: %h", out);

    $finish;
  end
endmodule
