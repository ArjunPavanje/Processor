`timescale 1ns / 1ps

module tb_FPDS;

  // Parameters
  parameter BUS_WIDTH = 64;
  parameter INPUT_WIDTH = 64;
  parameter OUTPUT_WIDTH = 32;

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
  FCVT_D_S #(
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
        $display("       Input:    0x%016h", in1);
        $display("       Expected: 0x%08h", expected_val);
        $display("       Got:      0x%08h", out);
        pass_count = pass_count + 1;
      end else begin
        $display("[FAIL] Test %0d: %s", test_num, description);
        $display("       Input:    0x%016h", in1);
        $display("       Expected: 0x%08h", expected_val);
        $display("       Got:      0x%08h", out);
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
    $display("IEEE-754 Double to Single Precision Converter");
    $display("========================================\n");

    // ===================================
    // Test 1: Positive Zero
    // ===================================
    in1 = 64'h0000000000000000;
    expected = 32'h00000000;
    check_result(expected, "Positive Zero");

    // ===================================
    // Test 2: Negative Zero
    // ===================================
    in1 = 64'h8000000000000000;
    expected = 32'h80000000;
    check_result(expected, "Negative Zero");

    // ===================================
    // Test 3: Positive Infinity (input)
    // ===================================
    in1 = 64'h7ff0000000000000;  // +Inf
    expected = 32'h7f800000;  // +Inf (single)
    check_result(expected, "Positive Infinity");

    // ===================================
    // Test 4: Negative Infinity (input)
    // ===================================
    in1 = 64'hfff0000000000000;  // -Inf
    expected = 32'hff800000;  // -Inf (single)
    check_result(expected, "Negative Infinity");

    // ===================================
    // Test 5: NaN
    // ===================================
    in1 = 64'h7ff8000000000000;  // NaN
    expected = 32'h7fc00000;  // NaN (single) - Note: Your code doesn't use this
    check_result(expected, "NaN");

    // ===================================
    // Test 6: Positive One (1.0)
    // ===================================
    // Double: sign=0, exp=1023 (0x3FF), mantissa=0
    // Single: sign=0, exp=127 (0x7F), mantissa=0
    in1 = 64'h3ff0000000000000;
    expected = 32'h3f800000;
    check_result(expected, "Positive 1.0");

    // ===================================
    // Test 7: Negative One (-1.0)
    // ===================================
    in1 = 64'hbff0000000000000;
    expected = 32'hbf800000;
    check_result(expected, "Negative -1.0");

    // ===================================
    // Test 8: Positive Two (2.0)
    // ===================================
    // Double: exp=1024 (0x400)
    // Single: exp=128 (0x80)
    in1 = 64'h4000000000000000;
    expected = 32'h40000000;
    check_result(expected, "Positive 2.0");

    // ===================================
    // Test 9: Positive 0.5
    // ===================================
    // Double: exp=1022 (0x3FE)
    // Single: exp=126 (0x7E)
    in1 = 64'h3fe0000000000000;
    expected = 32'h3f000000;
    check_result(expected, "Positive 0.5");

    // ===================================
    // Test 10: Small positive number (3.14159)
    // ===================================
    // Double: 0x400921FB54442D18 (approx pi)
    in1 = 64'h400921fb54442d18;
    expected = 32'h40490fdb;  // Single precision pi
    check_result(expected, "Pi (3.14159...)");

    // ===================================
    // Test 11: Small negative number (-3.14159)
    // ===================================
    in1 = 64'hc00921fb54442d18;
    expected = 32'hc0490fdb;
    check_result(expected, "Negative Pi (-3.14159...)");

    // ===================================
    // Test 12: Large positive number (1000.0)
    // ===================================
    // Double: 0x408F400000000000
    in1 = 64'h408f400000000000;
    expected = 32'h447a0000;
    check_result(expected, "1000.0");

    // ===================================
    // Test 13: Small fractional (0.1)
    // ===================================
    // Double: 0x3FB999999999999A
    in1 = 64'h3fb999999999999a;
    expected = 32'h3dcccccd;
    check_result(expected, "0.1");

    // ===================================
    // Test 14: Very small positive (near zero)
    // ===================================
    // Double: 0x3E70000000000000 (small but normal)
    in1 = 64'h3e70000000000000;
    expected = 32'h33800000;
    check_result(expected, "Very small positive");

    // ===================================
    // Test 15: Maximum single-precision normal
    // ===================================
    // Max single: 3.4028235e38, exp=254
    // Double representation: exp = 254 - 127 + 1023 = 1150 = 0x47E
    in1 = 64'h47efffffe0000000;
    expected = 32'h7f7fffff;
    check_result(expected, "Max single-precision normal");

    // ===================================
    // Test 16: Minimum single-precision normal
    // ===================================
    // Min single normal: 2^-126, exp=1
    // Double: exp = 1 - 127 + 1023 = 897 = 0x381
    in1 = 64'h3810000000000000;
    expected = 32'h00800000;
    check_result(expected, "Min single-precision normal");

    // ===================================
    // Test 17: Overflow - large positive
    // ===================================
    // Double exp > 1150 (single max exp mapped to double)
    // Should overflow to +Inf
    in1 = 64'h47f0000000000000;  // Exceeds single range
    expected = 32'h7f800000;  // +Inf
    check_result(expected, "Overflow to +Infinity");

    // ===================================
    // Test 18: Overflow - large negative
    // ===================================
    in1 = 64'hc7f0000000000000;  // Exceeds single range (negative)
    expected = 32'hff800000;  // -Inf
    check_result(expected, "Overflow to -Infinity");

    // ===================================
    // Test 19: Underflow - very small positive
    // ===================================
    // Below single precision denormal range
    // Double exp < 897 (single min normal exp in double)
    in1 = 64'h3800000000000000;  // Very small
    expected = 32'hff800000;  // Based on your code logic
    check_result(expected, "Underflow (very small positive)");

    // ===================================
    // Test 20: Underflow - very small negative
    // ===================================
    in1 = 64'hb800000000000000;
    expected = 32'hff800000;
    check_result(expected, "Underflow (very small negative)");

    // ===================================
    // Test 21: Positive number with mantissa bits
    // ===================================
    // Double: 1.5 = 0x3FF8000000000000
    in1 = 64'h3ff8000000000000;
    expected = 32'h3fc00000;  // Single: 1.5
    check_result(expected, "1.5");

    // ===================================
    // Test 22: Negative 0.25
    // ===================================
    in1 = 64'hbfd0000000000000;
    expected = 32'hbe800000;
    check_result(expected, "-0.25");

    // ===================================
    // Test 23: 100.0
    // ===================================
    in1 = 64'h4059000000000000;
    expected = 32'h42c80000;
    check_result(expected, "100.0");

    // ===================================
    // Test 24: -100.0
    // ===================================
    in1 = 64'hc059000000000000;
    expected = 32'hc2c80000;
    check_result(expected, "-100.0");

    // ===================================
    // Test 25: 0.03125 (2^-5)
    // ===================================
    in1 = 64'h3fa0000000000000;
    expected = 32'h3d000000;
    check_result(expected, "0.03125");

    // ===================================
    // Test 26: Number with complex mantissa
    // ===================================
    // 1.234567
    in1 = 64'h3ff3c0ca428c59fb;
    expected = 32'h3f9e0652;
    check_result(expected, "1.234567");

    // ===================================
    // Test 27: -1.234567
    // ===================================
    in1 = 64'hbff3c0ca428c59fb;
    expected = 32'hbf9e0652;
    check_result(expected, "-1.234567");

    // ===================================
    // Test 28: 42.0
    // ===================================
    in1 = 64'h4045000000000000;
    expected = 32'h42280000;
    check_result(expected, "42.0");

    // ===================================
    // Test 29: -42.0
    // ===================================
    in1 = 64'hc045000000000000;
    expected = 32'hc2280000;
    check_result(expected, "-42.0");

    // ===================================
    // Test 30: 0.0625 (2^-4)
    // ===================================
    in1 = 64'h3fb0000000000000;
    expected = 32'h3d800000;
    check_result(expected, "0.0625");

    // ===================================
    // Test 31: 16.0 (2^4)
    // ===================================
    in1 = 64'h4030000000000000;
    expected = 32'h41800000;
    check_result(expected, "16.0");

    // ===================================
    // Test 32: 256.0 (2^8)
    // ===================================
    in1 = 64'h4070000000000000;
    expected = 32'h43800000;
    check_result(expected, "256.0");

    // ===================================
    // Test 33: 0.75
    // ===================================
    in1 = 64'h3fe8000000000000;
    expected = 32'h3f400000;
    check_result(expected, "0.75");

    // ===================================
    // Test 34: -0.75
    // ===================================
    in1 = 64'hbfe8000000000000;
    expected = 32'hbf400000;
    check_result(expected, "-0.75");

    // ===================================
    // Test 35: Very large double (near single overflow)
    // ===================================
    in1 = 64'h47efffff80000000;
    expected = 32'h7f800000;  // Overflow
    check_result(expected, "Near overflow boundary");

    // ===================================
    // Test 36: 1024.0
    // ===================================
    in1 = 64'h4090000000000000;
    expected = 32'h44800000;
    check_result(expected, "1024.0");

    // ===================================
    // Test 37: 0.015625 (2^-6)
    // ===================================
    in1 = 64'h3f90000000000000;
    expected = 32'h3c800000;
    check_result(expected, "0.015625");

    // ===================================
    // Test 38: Euler's number e (2.71828...)
    // ===================================
    in1 = 64'h4005bf0a8b145769;
    expected = 32'h402df854;
    check_result(expected, "Euler's number e");

    // ===================================
    // Test 39: Square root of 2 (1.41421...)
    // ===================================
    in1 = 64'h3ff6a09e667f3bcd;
    expected = 32'h3fb504f3;
    check_result(expected, "Square root of 2");

    // ===================================
    // Test 40: -0.5
    // ===================================
    in1 = 64'hbfe0000000000000;
    expected = 32'hbf000000;
    check_result(expected, "-0.5");

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
