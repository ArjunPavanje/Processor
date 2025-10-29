`timescale 1ns / 1ps

module tb_FCVT_fp;

  reg  [63:0] in;
  wire [63:0] fp;

  FCVT_fp uut (
      .in(in),
      .fp(fp)
  );

  integer pass_count;
  integer fail_count;
  integer test_num;

  // Manually compute expected IEEE 754 double from 64-bit integer
  function [63:0] int64_to_double;
    input [63:0] val;
    reg sign;
    reg [63:0] abs_val;
    reg [10:0] leading_pos;
    reg [10:0] exp;
    reg [51:0] mant;
    integer i;
    begin
      // Handle zero
      if (val == 64'd0) begin
        int64_to_double = 64'd0;
      end else begin
        // Extract sign and absolute value
        sign = val[63];
        abs_val = sign ? (~val + 1'b1) : val;

        // Find leading 1 position
        leading_pos = 0;
        for (i = 63; i >= 0; i = i - 1) begin
          if (abs_val[i]) begin
            leading_pos = i;
            i = -1;  // Break
          end
        end

        // Compute exponent
        exp = leading_pos + 11'd1023;

        // Extract mantissa (shift to align MSB at bit 62, take bits [62:11])
        abs_val = abs_val << (63 - leading_pos);
        mant = abs_val[62:11];

        // Assemble IEEE 754
        int64_to_double = {sign, exp, mant};
      end
    end
  endfunction

  task check_result;
    input [63:0] test_input;
    reg [63:0] expected;
    begin
      test_num = test_num + 1;
      expected = int64_to_double(test_input);

      if (fp === expected) begin
        $display("[PASS] Test %0d: Input=%0d (0x%h)", test_num, $signed(test_input), test_input);
        pass_count = pass_count + 1;
      end else begin
        $display("[FAIL] Test %0d: Input=%0d (0x%h)", test_num, $signed(test_input), test_input);
        $display("       Expected: 0x%h", expected);
        $display("       Got:      0x%h", fp);
        fail_count = fail_count + 1;
      end
    end
  endtask

  initial begin
    pass_count = 0;
    fail_count = 0;
    test_num   = 0;

    $display("==============================================================");
    $display("             FCVT_fp Testbench Start");
    $display("==============================================================\n");

    // Test cases
    in = 64'd0;
    #10 check_result(in);
    in = 64'd1;
    #10 check_result(in);
    in = 64'd2;
    #10 check_result(in);
    in = 64'd3;
    #10 check_result(in);
    in = 64'd10;
    #10 check_result(in);
    in = 64'd16;
    #10 check_result(in);
    in = 64'd256;
    #10 check_result(in);
    in = 64'd1024;
    #10 check_result(in);
    in = 64'd65536;
    #10 check_result(in);
    in = 64'd1048576;
    #10 check_result(in);
    in = 64'd42;
    #10 check_result(in);
    in = 64'd100;
    #10 check_result(in);
    in = 64'd999;
    #10 check_result(in);
    in = 64'd12345;
    #10 check_result(in);
    in = 64'd123456;
    #10 check_result(in);
    in = 64'd987654321;
    #10 check_result(in);
    in = 64'd1000000000;
    #10 check_result(in);
    in = 64'd4294967295;
    #10 check_result(in);
    in = 64'd4294967296;
    #10 check_result(in);
    in = 64'd1099511627776;
    #10 check_result(in);
    in = 64'd72057594037927936;
    #10 check_result(in);
    in = 64'd144115188075855872;
    #10 check_result(in);
    in = 64'd288230376151711744;
    #10 check_result(in);
    in = 64'd4611686018427387904;
    #10 check_result(in);
    in = 64'd9223372036854775807;
    #10 check_result(in);

    // Negative tests
    in = -64'd1;
    #10 check_result(in);
    in = -64'd2;
    #10 check_result(in);
    in = -64'd3;
    #10 check_result(in);
    in = -64'd10;
    #10 check_result(in);
    in = -64'd42;
    #10 check_result(in);
    in = -64'd16;
    #10 check_result(in);
    in = -64'd256;
    #10 check_result(in);
    in = -64'd1024;
    #10 check_result(in);
    in = -64'd65536;
    #10 check_result(in);
    in = -64'd1048576;
    #10 check_result(in);
    in = -64'd123456;
    #10 check_result(in);
    in = -64'd987654321;
    #10 check_result(in);
    in = -64'd4294967295;
    #10 check_result(in);
    in = -64'd4611686018427387904;
    #10 check_result(in);
    in = -64'd9223372036854775808;
    #10 check_result(in);

    $display("\n==============================================================");
    $display("                    Test Summary");
    $display("==============================================================");
    $display("Total Tests: %0d", test_num);
    $display("Passed:      %0d", pass_count);
    $display("Failed:      %0d", fail_count);
    if (test_num > 0) $display("Success Rate: %.1f%%", (pass_count * 100.0) / test_num);
    $display("==============================================================");

    if (fail_count == 0) $display("ALL TESTS PASSED!");
    else $display("SOME TESTS FAILED!");

    $finish;
  end

endmodule
