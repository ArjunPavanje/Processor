`timescale 1ns/1ps

module FGE_tb;
  parameter BUS_WIDTH = 64;

  reg [BUS_WIDTH-1:0] in1, in2;
  wire [BUS_WIDTH-1:0] out;  // BUS_WIDTH bits output

  integer pass_count, fail_count, test_num;
  real val1, val2;
  reg [BUS_WIDTH-1:0] expected;

  // Instantiate DUT
  FGE #(.BUS_WIDTH(BUS_WIDTH)) dut (
    .in1(in1),
    .in2(in2),
    .out(out)
  );

  // Helper function to compute expected result
  function [BUS_WIDTH-1:0] compute_fge;
    input [BUS_WIDTH-1:0] a, b;
    real ra, rb;
    begin
      ra = $bitstoreal(a);
      rb = $bitstoreal(b);

      // NaN comparisons always return false (0 for greater-equal)
      if (a[62:52] == 11'h7FF && a[51:0] != 0) // a is NaN
        compute_fge = 0;
      else if (b[62:52] == 11'h7FF && b[51:0] != 0) // b is NaN
        compute_fge = 0;
      else if (ra >= rb)
        compute_fge = 1;  // GE = 1
      else
        compute_fge = 0;  // LT = 0
    end
  endfunction

  // Test case procedure
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

      if (out === expected) begin
        $display("[PASS] Test %2d: %-45s | in1: %15.6e | in2: %15.6e | Result: %d",
                 test_num, description, val1, val2, out[0]);
        pass_count = pass_count + 1;
      end else begin
        $display("[FAIL] Test %2d: %-45s", test_num, description);
        $display("       in1:       %15.6e  (0x%016h)", val1, in1);
        $display("       in2:       %15.6e  (0x%016h)", val2, in2);
        $display("       Expected:  %d (0x%016h) [GE=1, LT=0]", expected[0], expected);
        $display("       Got:       %d (0x%016h)", out[0], out);
        $display("");
        fail_count = fail_count + 1;
      end
    end
  endtask

  initial begin
    pass_count = 0;
    fail_count = 0;
    test_num = 0;

    $display("================================================================================");
    $display("                       FGE (Greater-or-Equal) Testbench (64-bit)");
    $display("================================================================================");
    $display("");

    // Test 1-5: Basic positive comparisons
    run_test($realtobits(1.0), $realtobits(2.0), 64'd0,
             "Basic: 1.0 >= 2.0 (false)");
    run_test($realtobits(2.0), $realtobits(1.0), 64'd1,
             "Basic: 2.0 >= 1.0 (true)");
    run_test($realtobits(1.5), $realtobits(1.5), 64'd1,
             "Basic: 1.5 >= 1.5 (true - equal)");
    run_test($realtobits(0.001), $realtobits(0.1), 64'd0,
             "Basic: 0.001 >= 0.1 (false)");
    run_test($realtobits(100.0), $realtobits(50.0), 64'd1,
             "Basic: 100.0 >= 50.0 (true)");

    // Test 6-10: Negative comparisons
    run_test($realtobits(-1.0), $realtobits(-2.0), 64'd1,
             "Negative: -1.0 >= -2.0 (true)");
    run_test($realtobits(-2.0), $realtobits(-1.0), 64'd0,
             "Negative: -2.0 >= -1.0 (false)");
    run_test($realtobits(-5.5), $realtobits(-5.5), 64'd1,
             "Negative: -5.5 >= -5.5 (true - equal)");
    run_test($realtobits(-100.0), $realtobits(-50.0), 64'd0,
             "Negative: -100.0 >= -50.0 (false)");
    run_test($realtobits(-0.001), $realtobits(-0.1), 64'd1,
             "Negative: -0.001 >= -0.1 (true)");

    // Test 11-15: Mixed sign comparisons
    run_test($realtobits(-1.0), $realtobits(1.0), 64'd0,
             "Mixed: -1.0 >= 1.0 (false)");
    run_test($realtobits(1.0), $realtobits(-1.0), 64'd1,
             "Mixed: 1.0 >= -1.0 (true)");
    run_test($realtobits(-100.0), $realtobits(0.01), 64'd0,
             "Mixed: -100.0 >= 0.01 (false)");
    run_test($realtobits(0.01), $realtobits(-100.0), 64'd1,
             "Mixed: 0.01 >= -100.0 (true)");
    run_test($realtobits(-0.0001), $realtobits(0.0001), 64'd0,
             "Mixed: -0.0001 >= 0.0001 (false)");

    // Test 16-20: Zero cases
    run_test($realtobits(0.0), $realtobits(1.0), 64'd0,
             "Zero: 0.0 >= 1.0 (false)");
    run_test($realtobits(1.0), $realtobits(0.0), 64'd1,
             "Zero: 1.0 >= 0.0 (true)");
    run_test($realtobits(0.0), $realtobits(0.0), 64'd1,
             "Zero: 0.0 >= 0.0 (true - equal)");
    run_test($realtobits(-1.0), $realtobits(0.0), 64'd0,
             "Zero: -1.0 >= 0.0 (false)");
    run_test($realtobits(0.0), $realtobits(-1.0), 64'd1,
             "Zero: 0.0 >= -1.0 (true)");

    // Test 21-25: Signed zeros
    run_test(64'h0000000000000000, 64'h8000000000000000, 64'd1,
             "Signed Zero: +0.0 >= -0.0 (true)");
    run_test(64'h8000000000000000, 64'h0000000000000000, 64'd1,
             "Signed Zero: -0.0 >= +0.0 (true - equal)");
    run_test(64'h0000000000000000, $realtobits(0.0), 64'd1,
             "Signed Zero: +0.0 >= +0.0 (true)");
    run_test($realtobits(-0.0), $realtobits(1.0), 64'd0,
             "Signed Zero: -0.0 >= 1.0 (false)");
    run_test($realtobits(0.0), $realtobits(-0.0), 64'd1,
             "Signed Zero: +0.0 >= -0.0 (true)");

    // Test 26-30: Infinity cases
    run_test(64'h7FF0000000000000, $realtobits(1.0), 64'd1,
             "Infinity: +Inf >= 1.0 (true)");
    run_test($realtobits(1.0), 64'h7FF0000000000000, 64'd0,
             "Infinity: 1.0 >= +Inf (false)");
    run_test(64'hFFF0000000000000, $realtobits(1.0), 64'd0,
             "Infinity: -Inf >= 1.0 (false)");
    run_test($realtobits(1.0), 64'hFFF0000000000000, 64'd1,
             "Infinity: 1.0 >= -Inf (true)");
    run_test(64'h7FF0000000000000, 64'hFFF0000000000000, 64'd1,
             "Infinity: +Inf >= -Inf (true)");

    // Test 31-35: Infinity edge cases
    run_test(64'hFFF0000000000000, 64'hFFF0000000000000, 64'd1,
             "Infinity: -Inf >= -Inf (true - equal)");
    run_test(64'h7FF0000000000000, 64'h7FF0000000000000, 64'd1,
             "Infinity: +Inf >= +Inf (true - equal)");
    run_test(64'hFFF0000000000000, 64'h7FF0000000000000, 64'd0,
             "Infinity: -Inf >= +Inf (false)");
    run_test($realtobits(-1e308), 64'hFFF0000000000000, 64'd1,
             "Infinity: -1e308 >= -Inf (true)");
    run_test($realtobits(1e308), 64'h7FF0000000000000, 64'd0,
             "Infinity: 1e308 >= +Inf (false)");

    // Test 36-40: NaN cases - all return false (0)
    run_test(64'h7FF8000000000000, $realtobits(1.0), 64'd0,
             "NaN: NaN >= 1.0 (false - IEEE754)");
    run_test($realtobits(1.0), 64'h7FF8000000000000, 64'd0,
             "NaN: 1.0 >= NaN (false - IEEE754)");
    run_test(64'h7FF8000000000000, 64'h7FF0000000000000, 64'd0,
             "NaN: NaN >= +Inf (false - IEEE754)");
    run_test(64'h7FF0000000000000, 64'h7FF8000000000000, 64'd0,
             "NaN: +Inf >= NaN (false - IEEE754)");
    run_test(64'h7FF8000000000000, 64'h7FF8000000000000, 64'd0,
             "NaN: NaN >= NaN (false - IEEE754)");

    // Test 41-45: Very small differences
    run_test($realtobits(1.0), 64'h3FF0000000000001, 64'd0,
             "Precision: 1.0 >= 1.0+ε (false)");
    run_test(64'h3FF0000000000001, $realtobits(1.0), 64'd1,
             "Precision: 1.0+ε >= 1.0 (true)");
    run_test($realtobits(1e-10), $realtobits(1e-11), 64'd1,
             "Precision: 1e-10 >= 1e-11 (true)");
    run_test($realtobits(1e-11), $realtobits(1e-10), 64'd0,
             "Precision: 1e-11 >= 1e-10 (false)");
    run_test($realtobits(0.99999), $realtobits(1.00001), 64'd0,
             "Precision: 0.99999 >= 1.00001 (false)");

    // Test 46-50: Very large/small numbers
    run_test($realtobits(1e308), $realtobits(1e307), 64'd1,
             "Extreme: 1e308 >= 1e307 (true)");
    run_test($realtobits(1e307), $realtobits(1e308), 64'd0,
             "Extreme: 1e307 >= 1e308 (false)");
    run_test($realtobits(-1e308), $realtobits(-1e307), 64'd0,
             "Extreme: -1e308 >= -1e307 (false)");
    run_test($realtobits(2.225074e-308), $realtobits(1.0), 64'd0,
             "Extreme: Min normal >= 1.0 (false)");
    run_test($realtobits(1.797693e308), $realtobits(1e100), 64'd1,
             "Extreme: Max double >= 1e100 (true)");

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

    if (fail_count == 0)
      $display("\n✓ ALL TESTS PASSED\n");
    else
      $display("\n✗ SOME TESTS FAILED - Review failures above\n");

    $finish;
  end

endmodule

