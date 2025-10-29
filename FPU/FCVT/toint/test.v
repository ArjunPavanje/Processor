module tb_FCVT_int;

  reg  [63:0] fp;
  wire [63:0] in;

  FCVT_int uut (
      .fp(fp),
      .in(in)
  );

  integer pass_count;
  integer fail_count;
  integer test_num;

  // Compare expected output (as signed 64-bit integer)
  task run_test;
    input [255:0] label;
    input [63:0] fp_val;
    input signed [63:0] expected;
    begin
      test_num = test_num + 1;
      fp = fp_val;
      #10;
      if ($signed(in) === expected) begin
        $display("[PASS] Test %2d: %-35s", test_num, label);
        pass_count = pass_count + 1;
      end else begin
        $display("[FAIL] Test %2d: %-35s (Got %0d, Expected %0d)", test_num, label, $signed(in),
                 expected);
        fail_count = fail_count + 1;
      end
    end
  endtask

  initial begin
    pass_count = 0;
    fail_count = 0;
    test_num   = 0;

    $display("\n==============================================================");
    $display("                 FCVT_int Testbench Start");
    $display("==============================================================\n");

    // 1. Special values: Zero
    run_test("Positive zero (+0.0)", 64'h0000000000000000, 64'sd0);
    run_test("Negative zero (-0.0)", 64'h8000000000000000, 64'sd0);

    // 2. Special values: Infinity
    run_test("Positive infinity (+Inf)", 64'h7FF0000000000000, 64'sh7FFFFFFFFFFFFFFF);
    run_test("Negative infinity (-Inf)", 64'hFFF0000000000000, -64'sh8000000000000000);

    // 3. Special values: NaN
    run_test("Quiet NaN", 64'h7FF8000000000000, 64'sd0);
    run_test("Signaling NaN", 64'h7FF0000000000001, 64'sd0);

    // 4. Small positive integers
    run_test("One (+1.0)", 64'h3FF0000000000000, 64'sd1);
    run_test("Two (+2.0)", 64'h4000000000000000, 64'sd2);
    run_test("Three (+3.0)", 64'h4008000000000000, 64'sd3);
    run_test("Ten (+10.0)", 64'h4024000000000000, 64'sd10);
    run_test("Forty-two (+42.0)", 64'h4045000000000000, 64'sd42);
    run_test("One hundred (+100.0)", 64'h4059000000000000, 64'sd100);

    // 5. Small negative integers
    run_test("Negative one (-1.0)", 64'hBFF0000000000000, -64'sd1);
    run_test("Negative two (-2.0)", 64'hC000000000000000, -64'sd2);
    run_test("Negative ten (-10.0)", 64'hC024000000000000, -64'sd10);
    run_test("Negative forty-two (-42.0)", 64'hC045000000000000, -64'sd42);

    // 6. Fractional values (should truncate to integer)
    run_test("Half (+0.5)", 64'h3FE0000000000000, 64'sd0);
    run_test("One and half (+1.5)", 64'h3FF8000000000000, 64'sd1);
    run_test("Negative half (-0.5)", 64'hBFE0000000000000, 64'sd0);
    run_test("Negative one and half (-1.5)", 64'hBFF8000000000000, -64'sd1);
    run_test("1.99999 (truncate to 1)", 64'h3FFFFFFFFFFFFFFF, 64'sd1);
    run_test("2.25", 64'h4002000000000000, 64'sd2);
    run_test("99.99", 64'h4058FF5C28F5C28F, 64'sd99);

    // 7. Powers of 2
    run_test("Four (+4.0 = 2^2)", 64'h4010000000000000, 64'sd4);
    run_test("Sixteen (+16.0 = 2^4)", 64'h4030000000000000, 64'sd16);
    run_test("256 (+256.0 = 2^8)", 64'h4070000000000000, 64'sd256);
    run_test("1024 (+1024.0 = 2^10)", 64'h4090000000000000, 64'sd1024);
    run_test("65536 (+65536.0 = 2^16)", 64'h40F0000000000000, 64'sd65536);
    run_test("2^20 (1048576)", 64'h4130000000000000, 64'sd1048576);
    run_test("2^30 (1073741824)", 64'h41D0000000000000, 64'sd1073741824);

    // 8. Large positive values
    run_test("One million (1e6)", 64'h412E848000000000, 64'sd1000000);
    run_test("One billion (1e9)", 64'h41CDCD6500000000, 64'sd1000000000);
    run_test("One trillion (1e12)", 64'h426D1A94A2000000, 64'sd1000000000000);
    run_test("2^32-1 (4294967295)", 64'h41EFFFFFFFE00000, 64'sd4294967295);
    run_test("2^32 (4294967296)", 64'h41F0000000000000, 64'sd4294967296);
    run_test("2^40 (1099511627776)", 64'h4270000000000000, 64'sd1099511627776);
    run_test("2^50 (1125899906842624)", 64'h4310000000000000, 64'sd1125899906842624);

    // 9. Large negative values
    run_test("Negative one million (-1e6)", 64'hC12E848000000000, -64'sd1000000);
    run_test("Negative one billion (-1e9)", 64'hC1CDCD6500000000, -64'sd1000000000);
    run_test("Negative trillion (-1e12)", 64'hC26D1A94A2000000, -64'sd1000000000000);

    // 10. Near-max/min values
    run_test("2^62 (4611686018427387904)", 64'h43D0000000000000, 64'sd4611686018427387904);
    run_test("2^63-1024 (near max int64)", 64'h43DFFFFFFFFFFFFF, 64'sd9223372036854774784);
    run_test("-2^62", 64'hC3D0000000000000, -64'sd4611686018427387904);

    // 11. Overflow cases
    run_test("1e40 (overflow to max)", 64'h4863B2C620C29E00, 64'sh7FFFFFFFFFFFFFFF);
    run_test("-1e40 (overflow to min)", 64'hC863B2C620C29E00, -64'sh8000000000000000);
    run_test("2^100 (overflow)", 64'h4630000000000000, 64'sh7FFFFFFFFFFFFFFF);
    run_test("-2^100 (overflow)", 64'hC630000000000000, -64'sh8000000000000000);

    // Summary
    $display("\n==============================================================");
    $display("                    Test Summary");
    $display("==============================================================");
    $display("Total Tests: %0d", test_num);
    $display("Passed:      %0d", pass_count);
    $display("Failed:      %0d", fail_count);
    if (test_num > 0) $display("Success Rate: %.1f%%", (pass_count * 100.0) / test_num);
    $display("==============================================================");

    if (fail_count == 0) $display("\n*** ALL TESTS PASSED! ***\n");
    else $display("\n*** %0d TESTS FAILED ***\n", fail_count);

    $finish;
  end

endmodule
