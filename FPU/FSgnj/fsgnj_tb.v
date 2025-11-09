`timescale 1ns / 1ps

module tb_FSGNJ;

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
  FSGNJ #(
      .BUS_WIDTH(BUS_WIDTH)
  ) dut (
      .in1(in1),
      .in2(in2),
      .out(out)
  );

  // Task to check results (Pure Verilog - no string parameter)
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
    $display("FSGNJ Testbench - BUS_WIDTH = %0d", BUS_WIDTH);
    $display("========================================\n");

    if (BUS_WIDTH == 64) begin
      // Test 1: Positive + Positive
      $display("Test 1: Positive + Positive -> Positive");
      in1 = 64'h3FF0000000000000;
      in2 = 64'h4000000000000000;
      expected = 64'h3FF0000000000000;
      check_result(expected);

      // Test 2: Positive + Negative
      $display("Test 2: Positive + Negative -> Negative");
      in1 = 64'h3FF0000000000000;
      in2 = 64'hC000000000000000;
      expected = 64'hBFF0000000000000;
      check_result(expected);

      // Test 3: Negative + Positive
      $display("Test 3: Negative + Positive -> Positive");
      in1 = 64'hBFF0000000000000;
      in2 = 64'h4000000000000000;
      expected = 64'h3FF0000000000000;
      check_result(expected);

      // Test 4: Negative + Negative
      $display("Test 4: Negative + Negative -> Negative");
      in1 = 64'hBFF0000000000000;
      in2 = 64'hC000000000000000;
      expected = 64'hBFF0000000000000;
      check_result(expected);

      // Test 5: Positive Zero + Positive Zero
      $display("Test 5: Positive Zero + Positive Zero");
      in1 = 64'h0000000000000000;
      in2 = 64'h0000000000000000;
      expected = 64'h0000000000000000;
      check_result(expected);

      // Test 6: Positive Zero + Negative Zero
      $display("Test 6: Positive Zero + Negative Zero");
      in1 = 64'h0000000000000000;
      in2 = 64'h8000000000000000;
      expected = 64'h8000000000000000;
      check_result(expected);

      // Test 7: Negative Zero + Positive Zero
      $display("Test 7: Negative Zero + Positive Zero");
      in1 = 64'h8000000000000000;
      in2 = 64'h0000000000000000;
      expected = 64'h0000000000000000;
      check_result(expected);

      // Test 8: Negative Zero + Negative Zero
      $display("Test 8: Negative Zero + Negative Zero");
      in1 = 64'h8000000000000000;
      in2 = 64'h8000000000000000;
      expected = 64'h8000000000000000;
      check_result(expected);

      // Test 9: Positive Infinity + Positive
      $display("Test 9: Positive Infinity + Positive");
      in1 = 64'h7FF0000000000000;
      in2 = 64'h3FF0000000000000;
      expected = 64'h7FF0000000000000;
      check_result(expected);

      // Test 10: Positive Infinity + Negative
      $display("Test 10: Positive Infinity + Negative");
      in1 = 64'h7FF0000000000000;
      in2 = 64'hBFF0000000000000;
      expected = 64'hFFF0000000000000;
      check_result(expected);

      // Test 11: Negative Infinity + Positive
      $display("Test 11: Negative Infinity + Positive");
      in1 = 64'hFFF0000000000000;
      in2 = 64'h3FF0000000000000;
      expected = 64'h7FF0000000000000;
      check_result(expected);

      // Test 12: Negative Infinity + Negative
      $display("Test 12: Negative Infinity + Negative");
      in1 = 64'hFFF0000000000000;
      in2 = 64'hBFF0000000000000;
      expected = 64'hFFF0000000000000;
      check_result(expected);

      // Test 13: Normal + Quiet NaN -> Return in1
      $display("Test 13: Normal + Quiet NaN -> Return in1");
      in1 = 64'h3FF0000000000000;
      in2 = 64'h7FF8000000000000;
      expected = 64'h3FF0000000000000;
      check_result(expected);

      // Test 14: Normal + Signaling NaN -> Return in1
      $display("Test 14: Normal + Signaling NaN -> Return in1");
      in1 = 64'hBFF0000000000000;
      in2 = 64'h7FF4000000000000;
      expected = 64'hBFF0000000000000;
      check_result(expected);

      // Test 15: Normal + NaN (max payload) -> Return in1
      $display("Test 15: Normal + NaN (max payload) -> Return in1");
      in1 = 64'h4000000000000000;
      in2 = 64'h7FFFFFFFFFFFFFFF;
      expected = 64'h4000000000000000;
      check_result(expected);

      // Test 16: Normal + Negative NaN -> Return in1
      $display("Test 16: Normal + Negative NaN -> Return in1");
      in1 = 64'h4008000000000000;
      in2 = 64'hFFF8000000000000;
      expected = 64'h4008000000000000;
      check_result(expected);

      // Test 17: NaN + Negative -> Negative NaN
      $display("Test 17: NaN + Negative -> Negative NaN");
      in1 = 64'h7FF8000000000000;
      in2 = 64'hBFF0000000000000;
      expected = 64'hFFF8000000000000;
      check_result(expected);

      // Test 18: Negative NaN + Positive -> Positive NaN
      $display("Test 18: Negative NaN + Positive -> Positive NaN");
      in1 = 64'hFFF8000000000000;
      in2 = 64'h3FF0000000000000;
      expected = 64'h7FF8000000000000;
      check_result(expected);

      // Test 19: NaN + NaN -> Return in1
      $display("Test 19: NaN + NaN -> Return in1");
      in1 = 64'h7FF8000000000000;
      in2 = 64'h7FFC000000000000;
      expected = 64'h7FF8000000000000;
      check_result(expected);

      // Test 20: Denorm + Positive -> Positive Denorm
      $display("Test 20: Denorm + Positive -> Positive Denorm");
      in1 = 64'h0008000000000000;
      in2 = 64'h3FF0000000000000;
      expected = 64'h0008000000000000;
      check_result(expected);

      // Test 21: Denorm + Negative -> Negative Denorm
      $display("Test 21: Denorm + Negative -> Negative Denorm");
      in1 = 64'h0008000000000000;
      in2 = 64'hBFF0000000000000;
      expected = 64'h8008000000000000;
      check_result(expected);

      // Test 22: Max Normal Positive + Negative Zero
      $display("Test 22: Max Normal Positive + Negative Zero");
      in1 = 64'h7FEFFFFFFFFFFFFF;
      in2 = 64'h8000000000000000;
      expected = 64'hFFEFFFFFFFFFFFFF;
      check_result(expected);

      // Test 23: Min Normal Positive + Negative
      $display("Test 23: Min Normal Positive + Negative");
      in1 = 64'h0010000000000000;
      in2 = 64'hC000000000000000;
      expected = 64'h8010000000000000;
      check_result(expected);

      // Test 24: Same Value (Positive)
      $display("Test 24: Same Value (Positive)");
      in1 = 64'h4014000000000000;
      in2 = 64'h4014000000000000;
      expected = 64'h4014000000000000;
      check_result(expected);

      // Test 25: Infinity + NaN -> Return in1
      $display("Test 25: Infinity + NaN -> Return in1");
      in1 = 64'h7FF0000000000000;
      in2 = 64'h7FF8000000000000;
      expected = 64'h7FF0000000000000;
      check_result(expected);

      // Test 26: Zero + NaN -> Return in1
      $display("Test 26: Zero + NaN -> Return in1");
      in1 = 64'h0000000000000000;
      in2 = 64'hFFF8000000000000;
      expected = 64'h0000000000000000;
      check_result(expected);

      // Test 27: PI + Negative -> -PI
      $display("Test 27: PI + Negative -> -PI");
      in1 = 64'h40091EB851EB851F;
      in2 = 64'hC008000000000000;
      expected = 64'hC0091EB851EB851F;
      check_result(expected);

      // Test 28: -1/3 + Positive -> +1/3
      $display("Test 28: -1/3 + Positive -> +1/3");
      in1 = 64'hBFD5555555555555;
      in2 = 64'h4000000000000000;
      expected = 64'h3FD5555555555555;
      check_result(expected);

    end else if (BUS_WIDTH == 32) begin
      // 32-bit tests (abbreviated for space)
      $display("Test 1: Positive + Positive -> Positive");
      in1 = 32'h3F800000;
      in2 = 32'h40000000;
      expected = 32'h3F800000;
      check_result(expected);

      $display("Test 2: Positive + Negative -> Negative");
      in1 = 32'h3F800000;
      in2 = 32'hC0000000;
      expected = 32'hBF800000;
      check_result(expected);

      // Add remaining 32-bit tests...
    end

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
