`timescale 1ns / 1ps

module tb_FSGNJN;

  // Parameters
  parameter BUS_WIDTH = 64;
  parameter CLOCK_PERIOD = 10;

  // Testbench signals
  reg [BUS_WIDTH-1:0] in1;
  reg [BUS_WIDTH-1:0] in2;
  wire [BUS_WIDTH-1:0] out;
  reg [BUS_WIDTH-1:0] expected;

  integer test_num;
  integer pass_count;
  integer fail_count;

  // Instantiate the module
  FSGNJN #(
      .BUS_WIDTH(BUS_WIDTH)
  ) dut (
      .in1(in1),
      .in2(in2),
      .out(out)
  );

  // Task to check results
  task check_result;
    input [BUS_WIDTH-1:0] exp;
    begin
      #1;
      if (out === exp) begin
        $display("Test %0d PASS", test_num);
        $display("  in1=%h, in2=%h, out=%h (expected=%h)", in1, in2, out, exp);
        pass_count = pass_count + 1;
      end else begin
        $display("Test %0d FAIL", test_num);
        $display("  in1=%h, in2=%h, out=%h, expected=%h", in1, in2, out, exp);
        fail_count = fail_count + 1;
      end
      test_num = test_num + 1;
      #CLOCK_PERIOD;
    end
  endtask

  initial begin
    test_num   = 1;
    pass_count = 0;
    fail_count = 0;

    $display("========================================");
    $display("FSGNJN Testbench - BUS_WIDTH = %0d", BUS_WIDTH);
    $display("========================================\n");

    if (BUS_WIDTH == 64) begin
      // ========== 64-bit Double Precision Tests ==========

      // Test 1: Positive magnitude with POSITIVE sign -> NEGATIVE result
      $display("Test 1: Positive + Positive -> Negative (negated sign)");
      in1 = 64'h3FF0000000000000;  // +1.0
      in2 = 64'h4000000000000000;  // +2.0 (positive sign)
      expected = 64'hBFF0000000000000;  // -1.0 (negated to negative)
      check_result(expected);

      // Test 2: Positive magnitude with NEGATIVE sign -> POSITIVE result
      $display("Test 2: Positive + Negative -> Positive (negated sign)");
      in1 = 64'h3FF0000000000000;  // +1.0
      in2 = 64'hC000000000000000;  // -2.0 (negative sign)
      expected = 64'h3FF0000000000000;  // +1.0 (negated to positive)
      check_result(expected);

      // Test 3: Negative magnitude with POSITIVE sign -> NEGATIVE result
      $display("Test 3: Negative + Positive -> Negative (negated sign)");
      in1 = 64'hBFF0000000000000;  // -1.0
      in2 = 64'h4000000000000000;  // +2.0 (positive sign)
      expected = 64'hBFF0000000000000;  // -1.0 (negated to negative)
      check_result(expected);

      // Test 4: Negative magnitude with NEGATIVE sign -> POSITIVE result
      $display("Test 4: Negative + Negative -> Positive (negated sign)");
      in1 = 64'hBFF0000000000000;  // -1.0
      in2 = 64'hC000000000000000;  // -2.0 (negative sign)
      expected = 64'h3FF0000000000000;  // +1.0 (negated to positive)
      check_result(expected);

      // Test 5: Zero with positive zero -> negative zero
      $display("Test 5: Positive Zero + Positive Zero -> Negative Zero");
      in1 = 64'h0000000000000000;  // +0.0
      in2 = 64'h0000000000000000;  // +0.0 (positive)
      expected = 64'h8000000000000000;  // -0.0 (negated)
      check_result(expected);

      // Test 6: Zero with negative zero -> positive zero
      $display("Test 6: Positive Zero + Negative Zero -> Positive Zero");
      in1 = 64'h0000000000000000;  // +0.0
      in2 = 64'h8000000000000000;  // -0.0 (negative)
      expected = 64'h0000000000000000;  // +0.0 (negated)
      check_result(expected);

      // Test 7: Negative zero with positive zero -> negative zero
      $display("Test 7: Negative Zero + Positive Zero -> Negative Zero");
      in1 = 64'h8000000000000000;  // -0.0
      in2 = 64'h0000000000000000;  // +0.0 (positive)
      expected = 64'h8000000000000000;  // -0.0 (negated)
      check_result(expected);

      // Test 8: Negative zero with negative zero -> positive zero
      $display("Test 8: Negative Zero + Negative Zero -> Positive Zero");
      in1 = 64'h8000000000000000;  // -0.0
      in2 = 64'h8000000000000000;  // -0.0 (negative)
      expected = 64'h0000000000000000;  // +0.0 (negated)
      check_result(expected);

      // Test 9: Positive infinity with positive sign -> negative infinity
      $display("Test 9: Positive Infinity + Positive -> Negative Infinity");
      in1 = 64'h7FF0000000000000;  // +Inf
      in2 = 64'h3FF0000000000000;  // +1.0 (positive)
      expected = 64'hFFF0000000000000;  // -Inf (negated)
      check_result(expected);

      // Test 10: Positive infinity with negative sign -> positive infinity
      $display("Test 10: Positive Infinity + Negative -> Positive Infinity");
      in1 = 64'h7FF0000000000000;  // +Inf
      in2 = 64'hBFF0000000000000;  // -1.0 (negative)
      expected = 64'h7FF0000000000000;  // +Inf (negated to positive)
      check_result(expected);

      // Test 11: Negative infinity with positive sign -> negative infinity
      $display("Test 11: Negative Infinity + Positive -> Negative Infinity");
      in1 = 64'hFFF0000000000000;  // -Inf
      in2 = 64'h3FF0000000000000;  // +1.0 (positive)
      expected = 64'hFFF0000000000000;  // -Inf (negated)
      check_result(expected);

      // Test 12: Negative infinity with negative sign -> positive infinity
      $display("Test 12: Negative Infinity + Negative -> Positive Infinity");
      in1 = 64'hFFF0000000000000;  // -Inf
      in2 = 64'hBFF0000000000000;  // -1.0 (negative)
      expected = 64'h7FF0000000000000;  // +Inf (negated to positive)
      check_result(expected);

      // Test 13: Normal + Quiet NaN -> Return in1 unchanged
      $display("Test 13: Normal + Quiet NaN -> Return in1");
      in1 = 64'h3FF0000000000000;  // +1.0
      in2 = 64'h7FF8000000000000;  // qNaN
      expected = 64'h3FF0000000000000;  // +1.0 (unchanged)
      check_result(expected);

      // Test 14: Normal + Signaling NaN -> Return in1 unchanged
      $display("Test 14: Normal + Signaling NaN -> Return in1");
      in1 = 64'hBFF0000000000000;  // -1.0
      in2 = 64'h7FF4000000000000;  // sNaN
      expected = 64'hBFF0000000000000;  // -1.0 (unchanged)
      check_result(expected);

      // Test 15: Normal + NaN (max payload) -> Return in1
      $display("Test 15: Normal + NaN (max payload) -> Return in1");
      in1 = 64'h4000000000000000;  // +2.0
      in2 = 64'h7FFFFFFFFFFFFFFF;  // NaN with max payload
      expected = 64'h4000000000000000;  // +2.0 (unchanged)
      check_result(expected);

      // Test 16: Normal + Negative NaN -> Return in1
      $display("Test 16: Normal + Negative NaN -> Return in1");
      in1 = 64'h4008000000000000;  // +3.0
      in2 = 64'hFFF8000000000000;  // -qNaN
      expected = 64'h4008000000000000;  // +3.0 (unchanged)
      check_result(expected);

      // Test 17: NaN + Negative -> Positive NaN (negated sign)
      $display("Test 17: NaN + Negative -> Positive NaN");
      in1 = 64'h7FF8000000000000;  // qNaN
      in2 = 64'hBFF0000000000000;  // -1.0 (negative)
      expected = 64'h7FF8000000000000;  // Positive NaN (negated to positive)
      check_result(expected);

      // Test 18: Negative NaN + Positive -> Negative NaN (negated sign)
      $display("Test 18: Negative NaN + Positive -> Negative NaN");
      in1 = 64'hFFF8000000000000;  // -qNaN
      in2 = 64'h3FF0000000000000;  // +1.0 (positive)
      expected = 64'hFFF8000000000000;  // Negative NaN (negated to negative)
      check_result(expected);

      // Test 19: Both NaN -> Return in1
      $display("Test 19: NaN + NaN -> Return in1");
      in1 = 64'h7FF8000000000000;  // qNaN
      in2 = 64'h7FFC000000000000;  // qNaN
      expected = 64'h7FF8000000000000;  // in1 (unchanged)
      check_result(expected);

      // Test 20: Denorm + Positive -> Negative Denorm (negated)
      $display("Test 20: Denorm + Positive -> Negative Denorm");
      in1 = 64'h0008000000000000;  // Denormalized positive
      in2 = 64'h3FF0000000000000;  // +1.0 (positive)
      expected = 64'h8008000000000000;  // Denormalized negative (negated)
      check_result(expected);

      // Test 21: Denorm + Negative -> Positive Denorm (negated)
      $display("Test 21: Denorm + Negative -> Positive Denorm");
      in1 = 64'h0008000000000000;  // Denormalized positive
      in2 = 64'hBFF0000000000000;  // -1.0 (negative)
      expected = 64'h0008000000000000;  // Denormalized positive (negated)
      check_result(expected);

      // Test 22: Max Normal + Negative Zero -> Positive Max
      $display("Test 22: Max Normal Positive + Negative Zero -> Positive");
      in1 = 64'h7FEFFFFFFFFFFFFF;  // Max normal positive
      in2 = 64'h8000000000000000;  // -0.0 (negative)
      expected = 64'h7FEFFFFFFFFFFFFF;  // Max normal positive (negated)
      check_result(expected);

      // Test 23: Min Normal + Negative -> Positive Min
      $display("Test 23: Min Normal Positive + Negative -> Positive");
      in1 = 64'h0010000000000000;  // Min normal positive
      in2 = 64'hC000000000000000;  // -2.0 (negative)
      expected = 64'h0010000000000000;  // Min normal positive (negated)
      check_result(expected);

      // Test 24: Same value - FNEG pseudoinstruction (negate operation)
      $display("Test 24: FNEG Pseudoinstruction (+5.0, +5.0 -> -5.0)");
      in1 = 64'h4014000000000000;  // +5.0
      in2 = 64'h4014000000000000;  // +5.0 (positive sign)
      expected = 64'hC014000000000000;  // -5.0 (negated)
      check_result(expected);

      // Test 25: Infinity + NaN -> Return in1
      $display("Test 25: Infinity + NaN -> Return in1");
      in1 = 64'h7FF0000000000000;  // +Inf
      in2 = 64'h7FF8000000000000;  // qNaN
      expected = 64'h7FF0000000000000;  // +Inf (unchanged)
      check_result(expected);

      // Test 26: Zero + NaN -> Return in1
      $display("Test 26: Zero + NaN -> Return in1");
      in1 = 64'h0000000000000000;  // +0.0
      in2 = 64'hFFF8000000000000;  // -qNaN
      expected = 64'h0000000000000000;  // +0.0 (unchanged)
      check_result(expected);

      // Test 27: PI + Negative -> PI (negated to positive)
      $display("Test 27: PI + Negative -> PI (negated)");
      in1 = 64'h40091EB851EB851F;  // PI (3.14159...)
      in2 = 64'hC008000000000000;  // -3.0 (negative)
      expected = 64'h40091EB851EB851F;  // +PI (negated to positive)
      check_result(expected);

      // Test 28: -1/3 + Positive -> -1/3 (negated to negative)
      $display("Test 28: -1/3 + Positive -> -1/3");
      in1 = 64'hBFD5555555555555;  // -1/3 approx
      in2 = 64'h4000000000000000;  // +2.0 (positive)
      expected = 64'hBFD5555555555555;  // -1/3 (negated to negative)
      check_result(expected);

      // Test 29: Large negative + positive -> Large negative
      $display("Test 29: Large Negative + Positive -> Large Negative");
      in1 = 64'hC3E0000000000000;  // Large negative
      in2 = 64'h3FF0000000000000;  // +1.0 (positive)
      expected = 64'hC3E0000000000000;  // Large negative (negated)
      check_result(expected);

      // Test 30: Small positive + negative -> Small positive
      $display("Test 30: Small Positive + Negative -> Small Positive");
      in1 = 64'h3E70000000000000;  // Small positive
      in2 = 64'hBFF0000000000000;  // -1.0 (negative)
      expected = 64'h3E70000000000000;  // Small positive (negated)
      check_result(expected);

    end else if (BUS_WIDTH == 32) begin
      // ========== 32-bit Single Precision Tests ==========

      // Test 1: Positive + Positive -> Negative (negated)
      $display("Test 1: Positive + Positive -> Negative");
      in1 = 32'h3F800000;  // +1.0
      in2 = 32'h40000000;  // +2.0 (positive)
      expected = 32'hBF800000;  // -1.0 (negated)
      check_result(expected);

      // Test 2: Positive + Negative -> Positive (negated)
      $display("Test 2: Positive + Negative -> Positive");
      in1 = 32'h3F800000;  // +1.0
      in2 = 32'hC0000000;  // -2.0 (negative)
      expected = 32'h3F800000;  // +1.0 (negated to positive)
      check_result(expected);

      // Test 3: Negative + Positive -> Negative (negated)
      $display("Test 3: Negative + Positive -> Negative");
      in1 = 32'hBF800000;  // -1.0
      in2 = 32'h40000000;  // +2.0 (positive)
      expected = 32'hBF800000;  // -1.0 (negated)
      check_result(expected);

      // Test 4: Negative + Negative -> Positive (negated)
      $display("Test 4: Negative + Negative -> Positive");
      in1 = 32'hBF800000;  // -1.0
      in2 = 32'hC0000000;  // -2.0 (negative)
      expected = 32'h3F800000;  // +1.0 (negated to positive)
      check_result(expected);

      // Test 5: Zero operations
      $display("Test 5: Positive Zero + Negative Zero -> Positive Zero");
      in1 = 32'h00000000;  // +0.0
      in2 = 32'h80000000;  // -0.0 (negative)
      expected = 32'h00000000;  // +0.0 (negated)
      check_result(expected);

      // Test 6: Infinity + Positive -> Negative Infinity
      $display("Test 6: Positive Infinity + Positive -> Negative Infinity");
      in1 = 32'h7F800000;  // +Inf
      in2 = 32'h3F800000;  // +1.0 (positive)
      expected = 32'hFF800000;  // -Inf (negated)
      check_result(expected);

      // Test 7: Infinity + Negative -> Positive Infinity
      $display("Test 7: Positive Infinity + Negative -> Positive Infinity");
      in1 = 32'h7F800000;  // +Inf
      in2 = 32'hBF800000;  // -1.0 (negative)
      expected = 32'h7F800000;  // +Inf (negated to positive)
      check_result(expected);

      // Test 8: Quiet NaN as in2
      $display("Test 8: Normal + Quiet NaN -> Return in1");
      in1 = 32'h3F800000;  // +1.0
      in2 = 32'h7FC00000;  // qNaN
      expected = 32'h3F800000;  // +1.0 (unchanged)
      check_result(expected);

      // Test 9: Signaling NaN as in2
      $display("Test 9: Normal + Signaling NaN -> Return in1");
      in1 = 32'hBF800000;  // -1.0
      in2 = 32'h7FA00000;  // sNaN
      expected = 32'hBF800000;  // -1.0 (unchanged)
      check_result(expected);

      // Test 10: NaN + Normal (negated sign injection)
      $display("Test 10: NaN + Negative -> Positive NaN");
      in1 = 32'h7FC00000;  // qNaN
      in2 = 32'hBF800000;  // -1.0 (negative)
      expected = 32'h7FC00000;  // Positive NaN (negated)
      check_result(expected);

      // Test 11: Both NaN
      $display("Test 11: NaN + NaN -> Return in1");
      in1 = 32'h7FC00000;  // qNaN
      in2 = 32'h7FE00000;  // qNaN
      expected = 32'h7FC00000;  // in1 unchanged
      check_result(expected);

      // Test 12: Denormalized number
      $display("Test 12: Denorm + Negative -> Positive Denorm");
      in1 = 32'h00400000;  // Denormalized
      in2 = 32'hBF800000;  // -1.0 (negative)
      expected = 32'h00400000;  // Positive denormalized (negated)
      check_result(expected);

      // Test 13: Max normal value
      $display("Test 13: Max Normal + Negative Zero -> Positive Max");
      in1 = 32'h7F7FFFFF;  // Max normal positive
      in2 = 32'h80000000;  // -0.0 (negative)
      expected = 32'h7F7FFFFF;  // Max normal positive (negated)
      check_result(expected);

      // Test 14: FNEG pseudoinstruction - negate PI
      $display("Test 14: FNEG PI (PI, PI -> -PI)");
      in1 = 32'h40490FDB;  // PI
      in2 = 32'h40490FDB;  // PI (positive)
      expected = 32'hC0490FDB;  // -PI (negated)
      check_result(expected);

      // Test 15: Small value
      $display("Test 15: Small Value + Positive Zero -> Negative Small");
      in1 = 32'h3DCCCCCD;  // 0.1 approx
      in2 = 32'h00000000;  // +0.0 (positive)
      expected = 32'hBDCCCCCD;  // -0.1 approx (negated)
      check_result(expected);

    end

    // Print summary
    $display("\n========================================");
    $display("Test Summary:");
    $display("  Total Tests: %0d", test_num - 1);
    $display("  Passed: %0d", pass_count);
    $display("  Failed: %0d", fail_count);
    if (fail_count == 0) $display("  Result: ALL TESTS PASSED!");
    else $display("  Result: SOME TESTS FAILED!");
    $display("========================================");

    $finish;
  end

endmodule
