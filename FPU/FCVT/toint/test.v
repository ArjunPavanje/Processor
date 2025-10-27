module tb_FCVT_int;

  reg  [63:0] fp;
  wire [63:0] in;

  FCVT_int uut (
      .fp(fp),
      .in(in)
  );

  // Compare expected output (as signed 64-bit integer)
  task run_test(input [255:0] label, input [63:0] fp_val, input signed [63:0] expected);
    begin
      fp = fp_val;
      #10;
      if ($signed(in) === expected) $display("%-40s : PASS", label);
      else $display("%-40s : FAIL (Got %0d, Expected %0d)", label, $signed(in), expected);
    end
  endtask

  initial begin
    $display("\n===================== FCVT_int Testbench =====================\n");

    // 1. Simple integer values
    run_test("Test 1: +1.0", 64'h3FF0000000000000, 64'sd1);
    run_test("Test 2: +2.0", 64'h4000000000000000, 64'sd2);
    run_test("Test 3: -2.0", 64'hC000000000000000, -64'sd2);
    run_test("Test 4: +10.0", 64'h4024000000000000, 64'sd10);
    run_test("Test 5: -10.0", 64'hC024000000000000, -64'sd10);

    // 2. Fractional numbers (truncate)
    run_test("Test 6: +0.5", 64'h3FE0000000000000, 64'sd0);
    run_test("Test 7: +1.5", 64'h3FF8000000000000, 64'sd1);
    run_test("Test 8: -1.5", 64'hBFF8000000000000, -64'sd1);

    // 3. Medium/large numbers
    run_test("Test 9: +42.0", 64'h4045000000000000, 64'sd42);
    run_test("Test 10: +1e12", 64'h426d1a94a2000000, 64'sd1000000000000);
    run_test("Test 11: -9.796e11", 64'hc26c82be7f3dd012, -64'sd979620854254);

    // 4. Overflow tests
    run_test("Test 12: +1e40", 64'h47F0000000000000, 64'sh7fffffffffffffff);
    run_test("Test 13: -1e40", 64'hC7F0000000000000, -64'sh8000000000000000);

    // 5. Misc
    run_test("Test 14: +1.2", 64'h3FF3333333333333, 64'sd1);
    run_test("Test 15: +99.0", 64'h4058C00000000000, 64'sd99);
    run_test("Test 16: -99.0", 64'hC058C00000000000, -64'sd99);
    run_test("Test 17: +100000.0", 64'h40F86A0000000000, 64'sd100000);
    run_test("Test 18: -100000.0", 64'hC0F86A0000000000, -64'sd100000);

    $display("\n==============================================================\n");
    $finish;
  end

endmodule
