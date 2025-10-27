`timescale 1ns / 1ps

module quake3_tb;

  reg  [63:0] x;
  wire [63:0] y;

  // Instantiate the Unit Under Test (UUT)
  FSQRT uut (
      .x(x),
      .y(y)
  );

  initial begin
    $dumpvars(0, quake3_tb);
    $display("\n==============================================");
    $display("       Quake3 Fast Inverse Sqrt Testbench     ");
    $display("==============================================");

    // -------------------------------------------------------
    //  Each 'x' below is a 64-bit IEEE-754 double
    //  Comment shows the floating-point value represented
    // -------------------------------------------------------

    // Test 1: x = 1.0
    x = 64'h3FF0000000000000;
    #10;
    $display("Test 1: x = %h (1.0),       y = %h", x, y);

    // Test 2: x = 2.0
    x = 64'h4000000000000000;
    #10;
    $display("Test 2: x = %h (2.0),       y = %h", x, y);

    // Test 3: x = 4.0
    x = 64'h4010000000000000;
    #10;
    $display("Test 3: x = %h (4.0),       y = %h", x, y);

    // Test 4: x = 0.5
    x = 64'h3FE0000000000000;
    #10;
    $display("Test 4: x = %h (0.5),       y = %h", x, y);

    // Test 5: x = 10.0
    x = 64'h4024000000000000;
    #10;
    $display("Test 5: x = %h (10.0),      y = %h", x, y);

    $display("==============================================");
    $display("Simulation complete.\n");
    $finish;
  end

endmodule
