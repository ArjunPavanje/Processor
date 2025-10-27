`timescale 1ns / 1ps

module FPAdder_tb;

  reg [63:0] A;
  reg [63:0] B;
  wire [63:0] out;

  // Internal temporary variables within FPAdder for observation
  wire [52:0] M_1;
  wire [52:0] M_2;
  wire [10:0] shift_amt;
  wire [10:0] E_A;
  wire [10:0] E_B;
  wire cout;
  wire [53:0] temp_mantissa;


  wire addorsub;
  // Instantiate the FPAdder
  FPSub uut (
      .A  (A),
      .B  (B),
      .out(out)
  );

  // Hierarchical references to internal nets (depends on your simulator)
  /*
  assign M_1 = uut.M_1;
  assign M_2 = uut.M_2;
  assign shift_amt = uut.shift_amt;
  assign addorsub = uut.S_A ^ uut.S_B;
  assign E_A = uut.E_A;
  assign E_B = uut.E_B;
  assign cout = uut.cout;
  assign temp_mantissa = uut.temp_mantissa;
  wire [6:0] shift_amt_1 = uut.shift_amt_1;
  wire add = uut.add;
  wire [52:0] shifted_mantissa = uut.shifted_mantissa;
  */

  initial begin
    $dumpvars(0, FPAdder_tb);

    // Test case 1: simple numbers
    A = 64'h4043800000000000;  // 39.0
    B = 64'h4024000000000000;  // 10.0
    #10;
    $display("Test 1: 39.0 - 10.0");
    $display("Result: %h", out);

    // Test case 2: positive and negative
    A = 64'h402e000000000000;  // 15.0
    B = 64'hc014000000000000;  // -5.0
    #10;
    $display("Test 2: 15.0 - (-5.0)");
    $display("Result: %h", out);

    // Test case 3: positive and negative, larger negative
    A = 64'h4014000000000000;  // 5.0
    B = 64'hc02e000000000000;  // -15.0
    #10;
    $display("Test 3: 5.0 - (-15.0)");
    $display("Result: %h", out);


    // Test case 4: both negative
    A = 64'hc024000000000000;  // -10.0
    B = 64'hc014000000000000;  // -5.0
    #10;
    $display("Test 4: -10.0 - (-5.0)");
    $display("Result: %h", out);

    // Test case 5: zero and positive
    A = 64'h0000000000000000;  // 0.0
    B = 64'h3ff0000000000000;  // 1.0
    #10;
    $display("Test 5: 0.0 - 1.0");
    $display("Result: %h", out);

    // Test case 6: zero and negative
    A = 64'h0000000000000000;  // 0.0
    B = 64'hbff0000000000000;  // -1.0
    #10;
    $display("Test 6: 0.0 - (-1.0)");
    $display("Result: %h", out);

    // Test case 7: large and small positive
    A = 64'h408f400000000000;  // 1000.0
    B = 64'h3f847ae147ae147b;  // 0.01
    #10;
    $display("Test 7: 1000.0 - 0.01");
    $display("Result: %h", out);

    // Test case 8: large positive and large negative
    A = 64'h408f400000000000;  // 1000.0
    B = 64'hc08f400000000000;  // -1000.0
    #10;
    $display("Test 8: 1000.0 - (-1000.0)");
    $display("Result: %h", out);

    // Test case 9: small positive and small negative
    A = 64'h3f847ae147ae147b;  // 0.01
    B = 64'hbf847ae147ae147b;  // -0.01
    #10;
    $display("Test 9: 0.01 - (-0.01)");
    $display("Result: %h", out);

    // Test case 10: small positive and small negative
    A = 64'h4004000000000000;  // 2.5
    B = 64'h400c000000000000;  // 3.5
    #10;
    $display("Test 9: 2.5 - 3.5");
    $display("Result: %h", out);


    $finish;
  end


endmodule
