`timescale 1ns / 1ps

module tb_fcvt_fp64_to_int64;

  reg  [63:0] fp;
  wire [63:0] in;

  // Instantiate DUT using module name and port names
  FCVT_int uut (
      .fp(fp),
      .in(in)
  );

  // Array of test input values and expected outputs
  reg     [63:0] test_fp      [0:18];
  reg     [63:0] test_expected[0:18];
  real           test_real    [0:18];

  integer        i;
  integer        pass_count;
  integer        fail_count;

  initial begin
    // Initialize test cases (bit patterns for doubles and expected integers)
    test_fp[0] = 64'h0000000000000000;
    test_expected[0] = 64'd0;
    test_real[0] = 0.0;
    test_fp[1] = 64'h3FE8000000000000;
    test_expected[1] = 64'd0;
    test_real[1] = 0.75;
    test_fp[2] = 64'h4045000000000000;
    test_expected[2] = 64'd42;
    test_real[2] = 42.0;
    test_fp[3] = 64'h4333BCA400000000;
    test_expected[3] = 64'd1000000000000;
    test_real[3] = 1e12;
    test_fp[4] = 64'hC0C81C0000000000;
    test_expected[4] = -64'd12345;
    test_real[4] = -12345.0;
    test_fp[5] = 64'hBFE0000000000000;
    test_expected[5] = 64'd0;
    test_real[5] = -0.5;
    test_fp[6] = 64'h43EFFFFFFFFFFFFF;
    test_expected[6] = 64'h7FFFFFFFFFFFFFFF;
    test_real[6] = 1.7e19;
    test_fp[7] = 64'hC3EFFFFFFFFFFFFF;
    test_expected[7] = 64'h8000000000000000;
    test_real[7] = -1.7e19;
    test_fp[8] = 64'h0008000000000000;
    test_expected[8] = 64'd0;
    test_real[8] = 5e-324;
    test_fp[9] = 64'hC3EDECA3EA570000;
    test_expected[9] = -64'd492235527954;
    test_real[9] = -4.9223552795475836e+11;
    test_fp[10] = 64'hC3EDF69C8FB6C000;
    test_expected[10] = -64'd937421291108;
    test_real[10] = -9.374212911087974e+11;
    test_fp[11] = 64'h432A6C5C6BC0C000;
    test_expected[11] = 64'd293761957240;
    test_real[11] = 2.9376195724009644e+11;
    test_fp[12] = 64'h4329CF0AE8B40000;
    test_expected[12] = 64'd202208947582;
    test_real[12] = 2.022089475829851e+11;
    test_fp[13] = 64'h4304B2D5AD710000;
    test_expected[13] = 64'd18321183059;
    test_real[13] = 1.8321183059768433e+10;
    test_fp[14] = 64'h432BCDFCA1E20000;
    test_expected[14] = 64'd783505121197;
    test_real[14] = 7.835051211978247e+11;
    test_fp[15] = 64'h432AA7B448A80000;
    test_expected[15] = 64'd364807470353;
    test_real[15] = 3.6480747035346533e+11;
    test_fp[16] = 64'hC3EE629EEA500000;
    test_expected[16] = -64'd979620854254;
    test_real[16] = -9.796208542545022e+11;
    test_fp[17] = 64'hC3ECD8C19B980000;
    test_expected[17] = -64'd695317524510;
    test_real[17] = -6.953175245100383e+11;
    test_fp[18] = 64'h432AA7E69E000000;
    test_expected[18] = 64'd365132210960;
    test_real[18] = 3.651322109602517e+11;

    pass_count = 0;
    fail_count = 0;

    $display("Starting fcvt_fp64_to_int64 testbench.");

    for (i = 0; i < 19; i = i + 1) begin
      fp = test_fp[i];
      #10;  // Let DUT output settle
      if (in === test_expected[i]) begin
        $display("Test %0d PASS: FP %h (%0f) -> INT %0d", i, fp, test_real[i], in);
        pass_count = pass_count + 1;
      end else begin
        $display("Test %0d FAIL: FP %h (%0f) -> Expected %0d but got %0d", i, fp, test_real[i],
                 test_expected[i], in);
        fail_count = fail_count + 1;
      end
    end

    if (fail_count == 0) $display("ALL TESTS PASSED.");
    else $display("TESTS COMPLETED WITH %0d FAILURES.", fail_count);

    $finish;
  end

endmodule
