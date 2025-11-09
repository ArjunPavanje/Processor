`timescale 1ns / 1ps

module tb_FCVT_S_D;

  // Parameters
  parameter BUS_WIDTH = 64;
  parameter INPUT_WIDTH = 32;
  parameter OUTPUT_WIDTH = 64;

  // Testbench signals
  reg [INPUT_WIDTH-1:0] in1;
  wire [OUTPUT_WIDTH-1:0] out;

  // Expected output for comparison
  reg [OUTPUT_WIDTH-1:0] expected;
  reg [255:0] test_name;
  integer test_num;
  integer pass_count;
  integer fail_count;

  // Instantiate the Unit Under Test (UUT)
  FCVT_S_D #(
      .BUS_WIDTH(BUS_WIDTH),
      .INPUT_WIDTH(INPUT_WIDTH),
      .OUTPUT_WIDTH(OUTPUT_WIDTH)
  ) uut (
      .in1(in1),
      .out(out)
  );

  // Task to check results
  task check_result;
    input [OUTPUT_WIDTH-1:0] expected_val;
    input [255:0] description;
    begin
      #10;  // Wait for output to stabilize
      if (out === expected_val) begin
        $display("[PASS] Test %0d: %s", test_num, description);
        $display("       Input:    0x%08h", in1);
        $display("       Expected: 0x%016h", expected_val);
        $display("       Got:      0x%016h", out);
        pass_count = pass_count + 1;
      end else begin
        $display("[FAIL] Test %0d: %s", test_num, description);
        $display("       Input:    0x%08h", in1);
        $display("       Expected: 0x%016h", expected_val);
        $display("       Got:      0x%016h", out);
        fail_count = fail_count + 1;
      end
      $display("");
      test_num = test_num + 1;
    end
  endtask

  initial begin
    // Initialize counters
    test_num   = 1;
    pass_count = 0;
    fail_count = 0;

    $display("========================================");
    $display("IEEE-754 Single to Double Precision Converter");
    $display("========================================\n");

    // ===================================
    // Test 1: Positive Zero
    // ===================================
    in1 = 32'h00000000;
    expected = 64'h0000000000000000;
    check_result(expected, "Positive Zero");

    // ===================================
    // Test 2: Negative Zero
    // ===================================
    in1 = 32'h80000000;
    expected = 64'h8000000000000000;
    check_result(expected, "Negative Zero");

    // ===================================
    // Test 3: Positive Infinity
    // ===================================
    in1 = 32'h7f800000;
    expected = 64'h7ff0000000000000;
    check_result(expected, "Positive Infinity");

    // ===================================
    // Test 4: Negative Infinity
    // ===================================
    in1 = 32'hff800000;
    expected = 64'hfff0000000000000;
    check_result(expected, "Negative Infinity");

    // ===================================
    // Test 5: NaN (quiet)
    // ===================================
    in1 = 32'h7fc00000;
    expected = 64'h7ff8000000000000;
    check_result(expected, "Quiet NaN");

    // ===================================
    // Test 6: NaN (signaling)
    // ===================================
    in1 = 32'h7fa00000;
    expected = 64'h7ff4000000000000;
    check_result(expected, "Signaling NaN");

    // ===================================
    // Test 7: Positive One (1.0)
    // ===================================
    in1 = 32'h3f800000;
    expected = 64'h3ff0000000000000;
    check_result(expected, "Positive 1.0");

    // ===================================
    // Test 8: Negative One (-1.0)
    // ===================================
    in1 = 32'hbf800000;
    expected = 64'hbff0000000000000;
    check_result(expected, "Negative -1.0");

    // ===================================
    // Test 9: Positive Two (2.0)
    // ===================================
    in1 = 32'h40000000;
    expected = 64'h4000000000000000;
    check_result(expected, "Positive 2.0");

    // ===================================
    // Test 10: Positive 0.5
    // ===================================
    in1 = 32'h3f000000;
    expected = 64'h3fe0000000000000;
    check_result(expected, "Positive 0.5");

    // ===================================
    // Test 11: Pi (3.14159...)
    // ===================================
    in1 = 32'h40490fdb;
    expected = 64'h400921fb60000000;
    check_result(expected, "Pi (3.14159...)");

    // ===================================
    // Test 12: Negative Pi (-3.14159...)
    // ===================================
    in1 = 32'hc0490fdb;
    expected = 64'hc00921fb60000000;
    check_result(expected, "Negative Pi (-3.14159...)");

    // ===================================
    // Test 13: 100.0
    // ===================================
    in1 = 32'h42c80000;
    expected = 64'h4059000000000000;
    check_result(expected, "100.0");

    // ===================================
    // Test 14: -100.0
    // ===================================
    in1 = 32'hc2c80000;
    expected = 64'hc059000000000000;
    check_result(expected, "-100.0");

    // ===================================
    // Test 15: 0.1
    // ===================================
    in1 = 32'h3dcccccd;
    expected = 64'h3fb99999a0000000;
    check_result(expected, "0.1");

    // ===================================
    // Test 16: -0.1
    // ===================================
    in1 = 32'hbdcccccd;
    expected = 64'hbfb999999a000000;
    check_result(expected, "-0.1");

    // ===================================
    // Test 17: Max single-precision normal
    // ===================================
    in1 = 32'h7f7fffff;
    expected = 64'h47efffffe0000000;
    check_result(expected, "Max single-precision normal");

    // ===================================
    // Test 18: Min single-precision normal
    // ===================================
    in1 = 32'h00800000;
    expected = 64'h3810000000000000;
    check_result(expected, "Min single-precision normal");

    // ===================================
    // Test 19: Min single-precision denormal
    // ===================================
    in1 = 32'h00000001;
    expected = 64'h36a0000000000000;
    check_result(expected, "Min single-precision denormal");

    // ===================================
    // Test 20: 1.5
    // ===================================
    in1 = 32'h3fc00000;
    expected = 64'h3ff8000000000000;
    check_result(expected, "1.5");

    // ===================================
    // Test 21: -1.5
    // ===================================
    in1 = 32'hbfc00000;
    expected = 64'hbff8000000000000;
    check_result(expected, "-1.5");

    // ===================================
    // Test 22: 0.25
    // ===================================
    in1 = 32'h3e800000;
    expected = 64'h3fd0000000000000;
    check_result(expected, "0.25");

    // ===================================
    // Test 23: -0.25
    // ===================================
    in1 = 32'hbe800000;
    expected = 64'hbfd0000000000000;
    check_result(expected, "-0.25");

    // ===================================
    // Test 24: 1000.0
    // ===================================
    in1 = 32'h447a0000;
    expected = 64'h408f400000000000;
    check_result(expected, "1000.0");

    // ===================================
    // Test 25: -1000.0
    // ===================================
    in1 = 32'hc47a0000;
    expected = 64'hc08f400000000000;
    check_result(expected, "-1000.0");

    // ===================================
    // Test 26: 0.0625 (2^-4)
    // ===================================
    in1 = 32'h3d800000;
    expected = 64'h3fb0000000000000;
    check_result(expected, "0.0625");

    // ===================================
    // Test 27: 16.0 (2^4)
    // ===================================
    in1 = 32'h41800000;
    expected = 64'h4030000000000000;
    check_result(expected, "16.0");

    // ===================================
    // Test 28: 256.0 (2^8)
    // ===================================
    in1 = 32'h43800000;
    expected = 64'h4070000000000000;
    check_result(expected, "256.0");

    // ===================================
    // Test 29: 0.75
    // ===================================
    in1 = 32'h3f400000;
    expected = 64'h3fe8000000000000;
    check_result(expected, "0.75");

    // ===================================
    // Test 30: -0.75
    // ===================================
    in1 = 32'hbf400000;
    expected = 64'hbfe8000000000000;
    check_result(expected, "-0.75");

    // ===================================
    // Test 31: 42.0
    // ===================================
    in1 = 32'h42280000;
    expected = 64'h4045000000000000;
    check_result(expected, "42.0");

    // ===================================
    // Test 32: -42.0
    // ===================================
    in1 = 32'hc2280000;
    expected = 64'hc045000000000000;
    check_result(expected, "-42.0");

    // ===================================
    // Test 33: 0.03125 (2^-5)
    // ===================================
    in1 = 32'h3d000000;
    expected = 64'h3fa0000000000000;
    check_result(expected, "0.03125");

    // ===================================
    // Test 34: 1.234567
    // ===================================
    in1 = 32'h3f9e0652;
    expected = 64'h3ff3c0ca40000000;
    check_result(expected, "1.234567");

    // ===================================
    // Test 35: -1.234567
    // ===================================
    in1 = 32'hbf9e0652;
    expected = 64'hbff3c0ca40000000;
    check_result(expected, "-1.234567");

    // ===================================
    // Test 36: 1024.0
    // ===================================
    in1 = 32'h44800000;
    expected = 64'h4090000000000000;
    check_result(expected, "1024.0");

    // ===================================
    // Test 37: 0.015625 (2^-6)
    // ===================================
    in1 = 32'h3c800000;
    expected = 64'h3f90000000000000;
    check_result(expected, "0.015625");

    // ===================================
    // Test 38: Euler's number e (2.71828...)
    // ===================================
    in1 = 32'h402df854;
    expected = 64'h4005bf0a80000000;
    check_result(expected, "Euler's number e");

    // ===================================
    // Test 39: Square root of 2 (1.41421...)
    // ===================================
    in1 = 32'h3fb504f3;
    expected = 64'h3ff6a09e60000000;
    check_result(expected, "Square root of 2");

    // ===================================
    // Test 40: -0.5
    // ===================================
    in1 = 32'hbf000000;
    expected = 64'hbfe0000000000000;
    check_result(expected, "-0.5");

    // ===================================
    // Test 41: Very small denormal
    // ===================================
    in1 = 32'h00000010;
    expected = 64'h36b0000000000000;
    check_result(expected, "Very small denormal");

    // ===================================
    // Test 42: Large denormal
    // ===================================
    in1 = 32'h007fffff;
    expected = 64'h380fffffe0000000;
    check_result(expected, "Large denormal");

    // ===================================
    // Summary
    // ===================================
    $display("========================================");
    $display("Test Summary:");
    $display("========================================");
    $display("Total Tests: %0d", test_num - 1);
    $display("Passed:      %0d", pass_count);
    $display("Failed:      %0d", fail_count);
    $display("========================================");

    if (fail_count == 0) $display("ALL TESTS PASSED!");
    else $display("SOME TESTS FAILED!");

    $display("");
    $finish;
  end

endmodule
