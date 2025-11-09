`timescale 1ns / 1ps

module tb_FSGNJX;

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
  FSGNJX #(
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
    test_num = 1;
    pass_count = 0;
    fail_count = 0;

    $display("========================================");
    $display("FSGNJX Testbench - BUS_WIDTH = %0d", BUS_WIDTH);
    $display("========================================\n");

    if (BUS_WIDTH == 64) begin
      // ========== 64-bit Double Precision Tests ==========

      // Test 1: Positive XOR Positive = Positive (0 XOR 0 = 0)
      $display("Test 1: Positive + Positive -> Positive (0^0=0)");
      in1 = 64'h3FF0000000000000; // +1.0 (sign=0)
      in2 = 64'h4000000000000000; // +2.0 (sign=0)
      expected = 64'h3FF0000000000000; // +1.0 (sign=0^0=0)
      check_result(expected);

      // Test 2: Positive XOR Negative = Negative (0 XOR 1 = 1)
      $display("Test 2: Positive + Negative -> Negative (0^1=1)");
      in1 = 64'h3FF0000000000000; // +1.0 (sign=0)
      in2 = 64'hC000000000000000; // -2.0 (sign=1)
      expected = 64'hBFF0000000000000; // -1.0 (sign=0^1=1)
      check_result(expected);

      // Test 3: Negative XOR Positive = Negative (1 XOR 0 = 1)
      $display("Test 3: Negative + Positive -> Negative (1^0=1)");
      in1 = 64'hBFF0000000000000; // -1.0 (sign=1)
      in2 = 64'h4000000000000000; // +2.0 (sign=0)
      expected = 64'hBFF0000000000000; // -1.0 (sign=1^0=1)
      check_result(expected);

      // Test 4: Negative XOR Negative = Positive (1 XOR 1 = 0)
      $display("Test 4: Negative + Negative -> Positive (1^1=0)");
      in1 = 64'hBFF0000000000000; // -1.0 (sign=1)
      in2 = 64'hC000000000000000; // -2.0 (sign=1)
      expected = 64'h3FF0000000000000; // +1.0 (sign=1^1=0)
      check_result(expected);

      // Test 5: Positive Zero XOR Positive Zero = Positive Zero
      $display("Test 5: Positive Zero + Positive Zero -> Positive Zero");
      in1 = 64'h0000000000000000; // +0.0 (sign=0)
      in2 = 64'h0000000000000000; // +0.0 (sign=0)
      expected = 64'h0000000000000000; // +0.0 (sign=0^0=0)
      check_result(expected);

      // Test 6: Positive Zero XOR Negative Zero = Negative Zero
      $display("Test 6: Positive Zero + Negative Zero -> Negative Zero");
      in1 = 64'h0000000000000000; // +0.0 (sign=0)
      in2 = 64'h8000000000000000; // -0.0 (sign=1)
      expected = 64'h8000000000000000; // -0.0 (sign=0^1=1)
      check_result(expected);

      // Test 7: Negative Zero XOR Positive Zero = Negative Zero
      $display("Test 7: Negative Zero + Positive Zero -> Negative Zero");
      in1 = 64'h8000000000000000; // -0.0 (sign=1)
      in2 = 64'h0000000000000000; // +0.0 (sign=0)
      expected = 64'h8000000000000000; // -0.0 (sign=1^0=1)
      check_result(expected);

      // Test 8: Negative Zero XOR Negative Zero = Positive Zero
      $display("Test 8: Negative Zero + Negative Zero -> Positive Zero");
      in1 = 64'h8000000000000000; // -0.0 (sign=1)
      in2 = 64'h8000000000000000; // -0.0 (sign=1)
      expected = 64'h0000000000000000; // +0.0 (sign=1^1=0)
      check_result(expected);

      // Test 9: Positive Infinity XOR Positive = Positive Infinity
      $display("Test 9: Positive Infinity + Positive -> Positive Infinity");
      in1 = 64'h7FF0000000000000; // +Inf (sign=0)
      in2 = 64'h3FF0000000000000; // +1.0 (sign=0)
      expected = 64'h7FF0000000000000; // +Inf (sign=0^0=0)
      check_result(expected);

      // Test 10: Positive Infinity XOR Negative = Negative Infinity
      $display("Test 10: Positive Infinity + Negative -> Negative Infinity");
      in1 = 64'h7FF0000000000000; // +Inf (sign=0)
      in2 = 64'hBFF0000000000000; // -1.0 (sign=1)
      expected = 64'hFFF0000000000000; // -Inf (sign=0^1=1)
      check_result(expected);

      // Test 11: Negative Infinity XOR Positive = Negative Infinity
      $display("Test 11: Negative Infinity + Positive -> Negative Infinity");
      in1 = 64'hFFF0000000000000; // -Inf (sign=1)
      in2 = 64'h3FF0000000000000; // +1.0 (sign=0)
      expected = 64'hFFF0000000000000; // -Inf (sign=1^0=1)
      check_result(expected);

      // Test 12: Negative Infinity XOR Negative = Positive Infinity
      $display("Test 12: Negative Infinity + Negative -> Positive Infinity");
      in1 = 64'hFFF0000000000000; // -Inf (sign=1)
      in2 = 64'hBFF0000000000000; // -1.0 (sign=1)
      expected = 64'h7FF0000000000000; // +Inf (sign=1^1=0)
      check_result(expected);

      // Test 13: Normal + Quiet NaN -> Return in1 unchanged
      $display("Test 13: Normal + Quiet NaN -> Return in1");
      in1 = 64'h3FF0000000000000; // +1.0
      in2 = 64'h7FF8000000000000; // qNaN
      expected = 64'h3FF0000000000000; // +1.0 (unchanged)
      check_result(expected);

      // Test 14: Normal + Signaling NaN -> Return in1 unchanged
      $display("Test 14: Normal + Signaling NaN -> Return in1");
      in1 = 64'hBFF0000000000000; // -1.0
      in2 = 64'h7FF4000000000000; // sNaN
      expected = 64'hBFF0000000000000; // -1.0 (unchanged)
      check_result(expected);

      // Test 15: Normal + NaN (max payload) -> Return in1
      $display("Test 15: Normal + NaN (max payload) -> Return in1");
      in1 = 64'h4000000000000000; // +2.0
      in2 = 64'h7FFFFFFFFFFFFFFF; // NaN with max payload
      expected = 64'h4000000000000000; // +2.0 (unchanged)
      check_result(expected);

      // Test 16: Normal + Negative NaN -> Return in1
      $display("Test 16: Normal + Negative NaN -> Return in1");
      in1 = 64'h4008000000000000; // +3.0
      in2 = 64'hFFF8000000000000; // -qNaN
      expected = 64'h4008000000000000; // +3.0 (unchanged)
      check_result(expected);

      // Test 17: Positive NaN XOR Negative sign -> Negative NaN
      $display("Test 17: Positive NaN + Negative -> Negative NaN (0^1=1)");
      in1 = 64'h7FF8000000000000; // qNaN (sign=0)
      in2 = 64'hBFF0000000000000; // -1.0 (sign=1)
      expected = 64'hFFF8000000000000; // Negative NaN (sign=0^1=1)
      check_result(expected);

      // Test 18: Negative NaN XOR Positive sign -> Negative NaN
      $display("Test 18: Negative NaN + Positive -> Negative NaN (1^0=1)");
      in1 = 64'hFFF8000000000000; // -qNaN (sign=1)
      in2 = 64'h3FF0000000000000; // +1.0 (sign=0)
      expected = 64'hFFF8000000000000; // Negative NaN (sign=1^0=1)
      check_result(expected);

      // Test 19: Both NaN -> Return in1
      $display("Test 19: NaN + NaN -> Return in1");
      in1 = 64'h7FF8000000000000; // qNaN
      in2 = 64'h7FFC000000000000; // qNaN
      expected = 64'h7FF8000000000000; // in1 (unchanged)
      check_result(expected);

      // Test 20: FABS pseudoinstruction - Positive value
      $display("Test 20: FABS Pseudoinstruction (+1.0, +1.0 -> +1.0)");
      in1 = 64'h3FF0000000000000; // +1.0 (sign=0)
      in2 = 64'h3FF0000000000000; // +1.0 (sign=0)
      expected = 64'h3FF0000000000000; // +1.0 (sign=0^0=0)
      check_result(expected);

      // Test 21: FABS pseudoinstruction - Negative value -> Positive
      $display("Test 21: FABS Pseudoinstruction (-5.0, -5.0 -> +5.0)");
      in1 = 64'hC014000000000000; // -5.0 (sign=1)
      in2 = 64'hC014000000000000; // -5.0 (sign=1)
      expected = 64'h4014000000000000; // +5.0 (sign=1^1=0)
      check_result(expected);

      // Test 22: Denormalized positive XOR positive = positive denorm
      $display("Test 22: Denorm Positive + Positive -> Positive Denorm");
      in1 = 64'h0008000000000000; // Denormalized positive (sign=0)
      in2 = 64'h3FF0000000000000; // +1.0 (sign=0)
      expected = 64'h0008000000000000; // Denormalized positive (sign=0^0=0)
      check_result(expected);

      // Test 23: Denormalized positive XOR negative = negative denorm
      $display("Test 23: Denorm Positive + Negative -> Negative Denorm");
      in1 = 64'h0008000000000000; // Denormalized positive (sign=0)
      in2 = 64'hBFF0000000000000; // -1.0 (sign=1)
      expected = 64'h8008000000000000; // Denormalized negative (sign=0^1=1)
      check_result(expected);

      // Test 24: Denormalized negative XOR negative = positive denorm
      $display("Test 24: Denorm Negative + Negative -> Positive Denorm");
      in1 = 64'h8008000000000000; // Denormalized negative (sign=1)
      in2 = 64'hBFF0000000000000; // -1.0 (sign=1)
      expected = 64'h0008000000000000; // Denormalized positive (sign=1^1=0)
      check_result(expected);

      // Test 25: Max normal positive XOR negative zero = negative max
      $display("Test 25: Max Normal Positive + Negative Zero -> Negative Max");
      in1 = 64'h7FEFFFFFFFFFFFFF; // Max normal positive (sign=0)
      in2 = 64'h8000000000000000; // -0.0 (sign=1)
      expected = 64'hFFEFFFFFFFFFFFFF; // Max normal negative (sign=0^1=1)
      check_result(expected);

      // Test 26: Min normal positive XOR negative = negative min
      $display("Test 26: Min Normal Positive + Negative -> Negative Min");
      in1 = 64'h0010000000000000; // Min normal positive (sign=0)
      in2 = 64'hC000000000000000; // -2.0 (sign=1)
      expected = 64'h8010000000000000; // Min normal negative (sign=0^1=1)
      check_result(expected);

      // Test 27: Infinity + NaN -> Return in1
      $display("Test 27: Infinity + NaN -> Return in1");
      in1 = 64'h7FF0000000000000; // +Inf
      in2 = 64'h7FF8000000000000; // qNaN
      expected = 64'h7FF0000000000000; // +Inf (unchanged)
      check_result(expected);

      // Test 28: Zero + NaN -> Return in1
      $display("Test 28: Zero + NaN -> Return in1");
      in1 = 64'h0000000000000000; // +0.0
      in2 = 64'hFFF8000000000000; // -qNaN
      expected = 64'h0000000000000000; // +0.0 (unchanged)
      check_result(expected);

      // Test 29: PI XOR Negative -> Negative PI
      $display("Test 29: PI + Negative -> -PI (0^1=1)");
      in1 = 64'h40091EB851EB851F; // PI (3.14159..., sign=0)
      in2 = 64'hC008000000000000; // -3.0 (sign=1)
      expected = 64'hC0091EB851EB851F; // -PI (sign=0^1=1)
      check_result(expected);

      // Test 30: -1/3 XOR Negative -> Positive 1/3
      $display("Test 30: -1/3 + Negative -> +1/3 (1^1=0)");
      in1 = 64'hBFD5555555555555; // -1/3 approx (sign=1)
      in2 = 64'hC000000000000000; // -2.0 (sign=1)
      expected = 64'h3FD5555555555555; // +1/3 approx (sign=1^1=0)
      check_result(expected);

      // Test 31: FABS on negative infinity -> positive infinity
      $display("Test 31: FABS on -Inf (-Inf, -Inf -> +Inf)");
      in1 = 64'hFFF0000000000000; // -Inf (sign=1)
      in2 = 64'hFFF0000000000000; // -Inf (sign=1)
      expected = 64'h7FF0000000000000; // +Inf (sign=1^1=0)
      check_result(expected);

      // Test 32: FABS on negative zero -> positive zero
      $display("Test 32: FABS on -0.0 (-0.0, -0.0 -> +0.0)");
      in1 = 64'h8000000000000000; // -0.0 (sign=1)
      in2 = 64'h8000000000000000; // -0.0 (sign=1)
      expected = 64'h0000000000000000; // +0.0 (sign=1^1=0)
      check_result(expected);

    end else if (BUS_WIDTH == 32) begin
      // ========== 32-bit Single Precision Tests ==========

      // Test 1: Positive XOR Positive = Positive
      $display("Test 1: Positive + Positive -> Positive (0^0=0)");
      in1 = 32'h3F800000; // +1.0 (sign=0)
      in2 = 32'h40000000; // +2.0 (sign=0)
      expected = 32'h3F800000; // +1.0 (sign=0^0=0)
      check_result(expected);

      // Test 2: Positive XOR Negative = Negative
      $display("Test 2: Positive + Negative -> Negative (0^1=1)");
      in1 = 32'h3F800000; // +1.0 (sign=0)
      in2 = 32'hC0000000; // -2.0 (sign=1)
      expected = 32'hBF800000; // -1.0 (sign=0^1=1)
      check_result(expected);

      // Test 3: Negative XOR Positive = Negative
      $display("Test 3: Negative + Positive -> Negative (1^0=1)");
      in1 = 32'hBF800000; // -1.0 (sign=1)
      in2 = 32'h40000000; // +2.0 (sign=0)
      expected = 32'hBF800000; // -1.0 (sign=1^0=1)
      check_result(expected);

      // Test 4: Negative XOR Negative = Positive
      $display("Test 4: Negative + Negative -> Positive (1^1=0)");
      in1 = 32'hBF800000; // -1.0 (sign=1)
      in2 = 32'hC0000000; // -2.0 (sign=1)
      expected = 32'h3F800000; // +1.0 (sign=1^1=0)
      check_result(expected);

      // Test 5: Zero operations
      $display("Test 5: Positive Zero + Negative Zero -> Negative Zero");
      in1 = 32'h00000000; // +0.0 (sign=0)
      in2 = 32'h80000000; // -0.0 (sign=1)
      expected = 32'h80000000; // -0.0 (sign=0^1=1)
      check_result(expected);

      // Test 6: Infinity XOR Positive = Positive Infinity
      $display("Test 6: Positive Infinity + Positive -> Positive Infinity");
      in1 = 32'h7F800000; // +Inf (sign=0)
      in2 = 32'h3F800000; // +1.0 (sign=0)
      expected = 32'h7F800000; // +Inf (sign=0^0=0)
      check_result(expected);

      // Test 7: Infinity XOR Negative = Negative Infinity
      $display("Test 7: Positive Infinity + Negative -> Negative Infinity");
      in1 = 32'h7F800000; // +Inf (sign=0)
      in2 = 32'hBF800000; // -1.0 (sign=1)
      expected = 32'hFF800000; // -Inf (sign=0^1=1)
      check_result(expected);

      // Test 8: Quiet NaN as in2
      $display("Test 8: Normal + Quiet NaN -> Return in1");
      in1 = 32'h3F800000; // +1.0
      in2 = 32'h7FC00000; // qNaN
      expected = 32'h3F800000; // +1.0 (unchanged)
      check_result(expected);

      // Test 9: Signaling NaN as in2
      $display("Test 9: Normal + Signaling NaN -> Return in1");
      in1 = 32'hBF800000; // -1.0
      in2 = 32'h7FA00000; // sNaN
      expected = 32'hBF800000; // -1.0 (unchanged)
      check_result(expected);

      // Test 10: NaN XOR sign
      $display("Test 10: NaN + Negative -> Negative NaN (0^1=1)");
      in1 = 32'h7FC00000; // qNaN (sign=0)
      in2 = 32'hBF800000; // -1.0 (sign=1)
      expected = 32'hFFC00000; // Negative NaN (sign=0^1=1)
      check_result(expected);

      // Test 11: Both NaN
      $display("Test 11: NaN + NaN -> Return in1");
      in1 = 32'h7FC00000; // qNaN
      in2 = 32'h7FE00000; // qNaN
      expected = 32'h7FC00000; // in1 unchanged
      check_result(expected);

      // Test 12: FABS pseudoinstruction - negative value
      $display("Test 12: FABS (-1.0, -1.0 -> +1.0)");
      in1 = 32'hBF800000; // -1.0 (sign=1)
      in2 = 32'hBF800000; // -1.0 (sign=1)
      expected = 32'h3F800000; // +1.0 (sign=1^1=0)
      check_result(expected);

      // Test 13: Denormalized number
      $display("Test 13: Denorm + Negative -> Negative Denorm");
      in1 = 32'h00400000; // Denormalized (sign=0)
      in2 = 32'hBF800000; // -1.0 (sign=1)
      expected = 32'h80400000; // Negative denormalized (sign=0^1=1)
      check_result(expected);

      // Test 14: Max normal value
      $display("Test 14: Max Normal + Negative Zero -> Negative Max");
      in1 = 32'h7F7FFFFF; // Max normal positive (sign=0)
      in2 = 32'h80000000; // -0.0 (sign=1)
      expected = 32'hFF7FFFFF; // Max normal negative (sign=0^1=1)
      check_result(expected);

      // Test 15: FABS PI value
      $display("Test 15: FABS on -PI (-PI, -PI -> +PI)");
      in1 = 32'hC0490FDB; // -PI (sign=1)
      in2 = 32'hC0490FDB; // -PI (sign=1)
      expected = 32'h40490FDB; // +PI (sign=1^1=0)
      check_result(expected);

    end

    // Print summary
    $display("\n========================================");
    $display("Test Summary:");
    $display("  Total Tests: %0d", test_num - 1);
    $display("  Passed: %0d", pass_count);
    $display("  Failed: %0d", fail_count);
    if (fail_count == 0)
      $display("  Result: ALL TESTS PASSED!");
    else
      $display("  Result: SOME TESTS FAILED!");
    $display("========================================");

    $finish;
  end

endmodule

