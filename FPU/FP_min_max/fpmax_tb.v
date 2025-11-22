`timescale 1ns / 1ps

module FPmax_tb;
  parameter BUS_WIDTH = 64;

  reg [BUS_WIDTH-1:0] in1, in2;
  wire [BUS_WIDTH-1:0] out;
  reg  [BUS_WIDTH-1:0] expected;

  integer pass_count, fail_count, test_num;
  real val1, val2, result_real, expected_real;

  // Instantiate DUT
  FPMax #(
      .BUS_WIDTH(BUS_WIDTH)
  ) dut (
      .in1(in1),
      .in2(in2),
      .out(out)
  );
  wire is_infinity = dut.is_infinity;
  wire is_nan = dut.is_nan;
  wire sign_eq = dut.sign_eq;
  wire in1_pos = dut.in1_pos;
  wire equal_exp = dut.equal_exp;

  // Helper function to compute expected maximum
  // IEEE 754 fmax behavior: NaN is treated as missing data
  function [BUS_WIDTH-1:0] compute_fmax;
    input [BUS_WIDTH-1:0] a, b;
    real ra, rb;
    begin
      ra = $bitstoreal(a);
      rb = $bitstoreal(b);

      // Handle NaN cases - return non-NaN value (IEEE 754 fmax semantics)
      if (a[62:52] == 11'h7FF && a[51:0] != 0) begin
        // a is NaN, return b (even if b is also NaN)
        compute_fmax = b;
      end else if (b[62:52] == 11'h7FF && b[51:0] != 0) begin
        // b is NaN (and a is not), return a
        compute_fmax = a;
      end else if (ra > rb) begin
        compute_fmax = a;
      end else begin
        compute_fmax = b;
      end
    end
  endfunction

  // Test case procedure with better formatting
  task run_test;
    input [BUS_WIDTH-1:0] test_in1, test_in2;
    input [BUS_WIDTH-1:0] test_expected;
    input [200*8:1] description;
    begin
      test_num = test_num + 1;
      in1 = test_in1;
      in2 = test_in2;
      expected = test_expected;
      #10;

      val1 = $bitstoreal(in1);
      val2 = $bitstoreal(in2);
      result_real = $bitstoreal(out);
      expected_real = $bitstoreal(expected);

      if (out === expected) begin
        $display("[PASS] Test %2d: %-40s | In1: %15.6e | In2: %15.6e | Out: %15.6e", test_num,
                 description, val1, val2, result_real);
        pass_count = pass_count + 1;
      end else begin
        $display("[FAIL] Test %2d: %-40s", test_num, description);
        $display("       In1:      %15.6e  (0x%016h)", val1, in1);
        $display("       In2:      %15.6e  (0x%016h)", val2, in2);
        $display("       Expected: %15.6e  (0x%016h)", expected_real, expected);
        $display("       Got:      %15.6e  (0x%016h)", result_real, out);
        $display("Infinity: %b, NaN: %b", is_infinity, is_nan);
        $display("Equal Sign: %b, Equal_exp: %b, in1 positive: %b", sign_eq, equal_exp, in1_pos);
        $display("");
        fail_count = fail_count + 1;
      end
    end
  endtask

  initial begin
    pass_count = 0;
    fail_count = 0;
    test_num   = 0;

    $display("================================================================================");
    $display("                          FPmax Testbench (64-bit)");
    $display("================================================================================");
    $display("");

    // Test 1-5: Basic positive number comparisons
    run_test($realtobits(1.0), $realtobits(2.0), compute_fmax($realtobits(1.0), $realtobits(2.0)),
             "Basic: 1.0 vs 2.0");
    run_test($realtobits(5.5), $realtobits(3.2), compute_fmax($realtobits(5.5), $realtobits(3.2)),
             "Basic: 5.5 vs 3.2");
    run_test($realtobits(100.0), $realtobits(50.0), compute_fmax(
             $realtobits(100.0), $realtobits(50.0)), "Basic: 100.0 vs 50.0");
    run_test($realtobits(0.001), $realtobits(0.1), compute_fmax($realtobits(0.001), $realtobits(0.1)
             ), "Basic: 0.001 vs 0.1");
    run_test($realtobits(1234.5678), $realtobits(1234.5677), compute_fmax(
             $realtobits(1234.5678), $realtobits(1234.5677)), "Basic: 1234.5678 vs 1234.5677");

    // Test 6-10: Negative number comparisons
    run_test($realtobits(-1.0), $realtobits(-2.0), compute_fmax($realtobits(-1.0), $realtobits(-2.0)
             ), "Negative: -1.0 vs -2.0");
    run_test($realtobits(-5.5), $realtobits(-3.2), compute_fmax($realtobits(-5.5), $realtobits(-3.2)
             ), "Negative: -5.5 vs -3.2");
    run_test($realtobits(-100.0), $realtobits(-50.0), compute_fmax(
             $realtobits(-100.0), $realtobits(-50.0)), "Negative: -100.0 vs -50.0");
    run_test($realtobits(-0.001), $realtobits(-0.1), compute_fmax(
             $realtobits(-0.001), $realtobits(-0.1)), "Negative: -0.001 vs -0.1");
    run_test($realtobits(-1234.5678), $realtobits(-1234.5677), compute_fmax(
             $realtobits(-1234.5678), $realtobits(-1234.5677)),
             "Negative: -1234.5678 vs -1234.5677");

    // Test 11-15: Mixed positive/negative
    run_test($realtobits(1.0), $realtobits(-1.0), compute_fmax($realtobits(1.0), $realtobits(-1.0)),
             "Mixed: 1.0 vs -1.0");
    run_test($realtobits(-1.0), $realtobits(1.0), compute_fmax($realtobits(-1.0), $realtobits(1.0)),
             "Mixed: -1.0 vs 1.0");
    run_test($realtobits(100.0), $realtobits(-0.01), compute_fmax(
             $realtobits(100.0), $realtobits(-0.01)), "Mixed: 100.0 vs -0.01");
    run_test($realtobits(-1000.0), $realtobits(0.001), compute_fmax(
             $realtobits(-1000.0), $realtobits(0.001)), "Mixed: -1000.0 vs 0.001");
    run_test($realtobits(3.14159), $realtobits(-2.71828), compute_fmax(
             $realtobits(3.14159), $realtobits(-2.71828)), "Mixed: π vs -e");

    // Test 16-20: Same exponent, different mantissa
    run_test(64'h4000000000000000, 64'h4000000000000001, compute_fmax(
             64'h4000000000000000, 64'h4000000000000001), "Same Exp: 2.0 vs 2.0+ε");
    run_test(64'h3FF0000000000000, 64'h3FF0000000000001, compute_fmax(
             64'h3FF0000000000000, 64'h3FF0000000000001), "Same Exp: 1.0 vs 1.0+ε");
    run_test(64'h3FE0000000000000, 64'h3FE0000000000001, compute_fmax(
             64'h3FE0000000000000, 64'h3FE0000000000001), "Same Exp: 0.5 vs 0.5+ε");
    run_test(64'hBFF0000000000000, 64'hBFF0000000000001, compute_fmax(
             64'hBFF0000000000000, 64'hBFF0000000000001), "Same Exp: -1.0 vs -1.0-ε");
    run_test(64'hC000000000000001, 64'hC000000000000000, compute_fmax(
             64'hC000000000000001, 64'hC000000000000000), "Same Exp: -2.0-ε vs -2.0");

    // Test 21-25: Equal values
    run_test($realtobits(1.0), $realtobits(1.0), compute_fmax($realtobits(1.0), $realtobits(1.0)),
             "Equal: 1.0 vs 1.0");
    run_test($realtobits(-5.5), $realtobits(-5.5), compute_fmax($realtobits(-5.5), $realtobits(-5.5)
             ), "Equal: -5.5 vs -5.5");
    run_test($realtobits(0.0), $realtobits(0.0), compute_fmax($realtobits(0.0), $realtobits(0.0)),
             "Equal: 0.0 vs 0.0");
    run_test($realtobits(1e10), $realtobits(1e10), compute_fmax($realtobits(1e10), $realtobits(1e10)
             ), "Equal: 1e10 vs 1e10");
    run_test($realtobits(-1e-10), $realtobits(-1e-10), compute_fmax(
             $realtobits(-1e-10), $realtobits(-1e-10)), "Equal: -1e-10 vs -1e-10");

    // Test 26-30: Zero cases
    run_test($realtobits(0.0), $realtobits(1.0), compute_fmax($realtobits(0.0), $realtobits(1.0)),
             "Zero: 0.0 vs 1.0");
    run_test($realtobits(1.0), $realtobits(0.0), compute_fmax($realtobits(1.0), $realtobits(0.0)),
             "Zero: 1.0 vs 0.0");
    run_test($realtobits(0.0), $realtobits(-1.0), compute_fmax($realtobits(0.0), $realtobits(-1.0)),
             "Zero: 0.0 vs -1.0");
    run_test($realtobits(-1.0), $realtobits(0.0), compute_fmax($realtobits(-1.0), $realtobits(0.0)),
             "Zero: -1.0 vs 0.0");
    run_test(64'h0000000000000000, 64'h8000000000000000, 64'd0, "Zero: +0.0 vs -0.0");

    // Test 31-35: Infinity cases
    run_test(64'h7FF0000000000000, $realtobits(1.0), compute_fmax(
             64'h7FF0000000000000, $realtobits(1.0)), "Infinity: +Inf vs 1.0");
    run_test($realtobits(1.0), 64'h7FF0000000000000, compute_fmax(
             $realtobits(1.0), 64'h7FF0000000000000), "Infinity: 1.0 vs +Inf");
    run_test(64'hFFF0000000000000, $realtobits(1.0), compute_fmax(
             64'hFFF0000000000000, $realtobits(1.0)), "Infinity: -Inf vs 1.0");
    run_test($realtobits(1.0), 64'hFFF0000000000000, compute_fmax(
             $realtobits(1.0), 64'hFFF0000000000000), "Infinity: 1.0 vs -Inf");
    run_test(64'h7FF0000000000000, 64'hFFF0000000000000, compute_fmax(
             64'h7FF0000000000000, 64'hFFF0000000000000), "Infinity: +Inf vs -Inf");

    // Test 36-40: NaN cases - IEEE 754 fmax behavior (return non-NaN value)
    run_test(64'h7FF8000000000000, $realtobits(1.0), $realtobits(1.0),
             "NaN: NaN vs 1.0 → return 1.0");
    run_test($realtobits(1.0), 64'h7FF8000000000000, $realtobits(1.0),
             "NaN: 1.0 vs NaN → return 1.0");
    run_test(64'h7FF8000000000000, 64'h7FF0000000000000, 64'h7FF0000000000000,
             "NaN: NaN vs +Inf → return +Inf");
    run_test(64'h7FF0000000000000, 64'h7FF8000000000000, 64'h7FF0000000000000,
             "NaN: +Inf vs NaN → return +Inf");
    run_test(64'h7FF8000000000000, 64'h7FFFFFFFFFFFFFFF, 64'h7FFFFFFFFFFFFFFF,
             "NaN: NaN vs NaN → return NaN");

    // Test 41-45: Very large/small numbers
    run_test($realtobits(1e308), $realtobits(1e307), compute_fmax(
             $realtobits(1e308), $realtobits(1e307)), "Extreme: 1e308 vs 1e307");
    run_test($realtobits(1e-308), $realtobits(1e-307), compute_fmax(
             $realtobits(1e-308), $realtobits(1e-307)), "Extreme: 1e-308 vs 1e-307");
    run_test($realtobits(-1e308), $realtobits(-1e307), compute_fmax(
             $realtobits(-1e308), $realtobits(-1e307)), "Extreme: -1e308 vs -1e307");
    run_test($realtobits(1e100), $realtobits(-1e100), compute_fmax(
             $realtobits(1e100), $realtobits(-1e100)), "Extreme: 1e100 vs -1e100");
    run_test($realtobits(1e-100), $realtobits(-1e-100), compute_fmax(
             $realtobits(1e-100), $realtobits(-1e-100)), "Extreme: 1e-100 vs -1e-100");

    // Test 46-50: Additional edge cases
    run_test($realtobits(2.2250738585072014e-308), $realtobits(1.0), 64'h3ff0000000000000,
             "Edge: Min normal vs 1.0");
    run_test($realtobits(1.7976931348623157e308), $realtobits(1.0), compute_fmax(
             $realtobits(1.7976931348623157e308), $realtobits(1.0)), "Edge: Max double vs 1.0");
    run_test($realtobits(-1.7976931348623157e308), $realtobits(-1.0), compute_fmax(
             $realtobits(-1.7976931348623157e308), $realtobits(-1.0)), "Edge: Min double vs -1.0");
    run_test(64'h0010000000000000, 64'h000FFFFFFFFFFFFF, compute_fmax(
             64'h0010000000000000, 64'h000FFFFFFFFFFFFF), "Edge: Min normal vs max denormal");
    run_test($realtobits(0.99999999999), $realtobits(1.00000000001), compute_fmax(
             $realtobits(0.99999999999), $realtobits(1.00000000001)), "Edge: 0.999... vs 1.000...");

    // Summary
    $display("");
    $display("================================================================================");
    $display("                              Test Summary");
    $display("================================================================================");
    $display("Total Tests:  %2d", test_num);
    $display("Passed:       %2d", pass_count);
    $display("Failed:       %2d", fail_count);
    $display("Pass Rate:    %0.1f%%", (pass_count * 100.0) / test_num);
    $display("================================================================================");

    if (fail_count == 0) $display("\n✓ ALL TESTS PASSED\n");
    else $display("\n✗ SOME TESTS FAILED - Review failures above\n");

    $finish;
  end

endmodule

