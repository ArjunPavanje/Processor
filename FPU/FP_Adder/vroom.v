`timescale 1ns / 1ps

module FPAdder_tb;

  reg [63:0] A;
  reg [63:0] B;
  wire [63:0] out;

  integer passed;
  integer failed;
  integer i;

  // Instantiate the FPAdder
  new_FPAdder uut (
      .A  (A),
      .B  (B),
      .out(out)
  );
  wire [106:0] temp_mantissa = uut.temp_mantissa;
  wire [106:0] shifted_mantissa = uut.shifted_mantissa;
  wire [106:0] rounded_mantissa = uut.rounded_mantissa;
  wire [106:0] M_1 = uut.M_1;
  wire [106:0] M_2 = uut.M_2;
  wire exp_overflow = uut.exp_overflow;
  wire [11:0] exp_3 = uut.exp_3;
  // Test case structure: A, B, expected_output
  reg [63:0] test_A[0:50];
  reg [63:0] test_B[0:50];
  reg [63:0] expected[0:50];
  reg [255:0] test_name[0:50];

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, FPAdder_tb);

    passed = 0;
    failed = 0;

    // Test 0: 39.0 + 10.0 = 49.0
    test_A[0] = 64'h4043800000000000;
    test_B[0] = 64'h4024000000000000;
    expected[0] = 64'h4048800000000000;
    test_name[0] = "39.0 + 10.0 = 49.0";

    // Test 1: 15.0 + (-5.0) = 10.0
    test_A[1] = 64'h402e000000000000;
    test_B[1] = 64'hc014000000000000;
    expected[1] = 64'h4024000000000000;
    test_name[1] = "15.0 + (-5.0) = 10.0";

    // Test 2: 5.0 + (-15.0) = -10.0
    test_A[2] = 64'h4014000000000000;
    test_B[2] = 64'hc02e000000000000;
    expected[2] = 64'hc024000000000000;
    test_name[2] = "5.0 + (-15.0) = -10.0";

    // Test 3: -10.0 + (-5.0) = -15.0
    test_A[3] = 64'hc024000000000000;
    test_B[3] = 64'hc014000000000000;
    expected[3] = 64'hc02e000000000000;
    test_name[3] = "-10.0 + (-5.0) = -15.0";

    // Test 4: 0.0 + 1.0 = 1.0
    test_A[4] = 64'h0000000000000000;
    test_B[4] = 64'h3ff0000000000000;
    expected[4] = 64'h3ff0000000000000;
    test_name[4] = "0.0 + 1.0 = 1.0";

    // Test 5: 0.0 + (-1.0) = -1.0
    test_A[5] = 64'h0000000000000000;
    test_B[5] = 64'hbff0000000000000;
    expected[5] = 64'hbff0000000000000;
    test_name[5] = "0.0 + (-1.0) = -1.0";

    // Test 6: 1000.0 + 0.01 = 1000.01
    test_A[6] = 64'h408f400000000000;
    test_B[6] = 64'h3f847ae147ae147b;
    expected[6] = 64'h408f40147ae147ae;
    test_name[6] = "1000.0 + 0.01 = 1000.01";

    // Test 7: 1000.0 + (-1000.0) = 0.0
    test_A[7] = 64'h408f400000000000;
    test_B[7] = 64'hc08f400000000000;
    expected[7] = 64'h0000000000000000;
    test_name[7] = "1000.0 + (-1000.0) = 0.0";

    // Test 8: 0.01 + (-0.01) = 0.0
    test_A[8] = 64'h3f847ae147ae147b;
    test_B[8] = 64'hbf847ae147ae147b;
    expected[8] = 64'h0000000000000000;
    test_name[8] = "0.01 + (-0.01) = 0.0";

    // Test 9: 2.5 + 3.5 = 6.0
    test_A[9] = 64'h4004000000000000;
    test_B[9] = 64'h400c000000000000;
    expected[9] = 64'h4018000000000000;
    test_name[9] = "2.5 + 3.5 = 6.0";

    // Test 10: 1.0 + 1.0 = 2.0
    test_A[10] = 64'h3ff0000000000000;
    test_B[10] = 64'h3ff0000000000000;
    expected[10] = 64'h4000000000000000;
    test_name[10] = "1.0 + 1.0 = 2.0";

    // Test 11: -1.0 + (-1.0) = -2.0
    test_A[11] = 64'hbff0000000000000;
    test_B[11] = 64'hbff0000000000000;
    expected[11] = 64'hc000000000000000;
    test_name[11] = "-1.0 + (-1.0) = -2.0";

    // Test 12: 100.5 + 200.25 = 300.75
    test_A[12] = 64'h4059200000000000;
    test_B[12] = 64'h4069080000000000;
    expected[12] = 64'h4072cc0000000000;
    test_name[12] = "100.5 + 200.25 = 300.75";

    // Test 13: 0.125 + 0.25 = 0.375
    test_A[13] = 64'h3fc0000000000000;
    test_B[13] = 64'h3fd0000000000000;
    expected[13] = 64'h3fd8000000000000;
    test_name[13] = "0.125 + 0.25 = 0.375";

    // Test 14: 1.5 + (-0.5) = 1.0
    test_A[14] = 64'h3ff8000000000000;
    test_B[14] = 64'hbfe0000000000000;
    expected[14] = 64'h3ff0000000000000;
    test_name[14] = "1.5 + (-0.5) = 1.0";

    // Test 15: +inf + 1.0 = +inf
    test_A[15] = 64'h7ff0000000000000;
    test_B[15] = 64'h3ff0000000000000;
    expected[15] = 64'h7ff0000000000000;
    test_name[15] = "+inf + 1.0 = +inf";

    // Test 16: -inf + 1.0 = -inf
    test_A[16] = 64'hfff0000000000000;
    test_B[16] = 64'h3ff0000000000000;
    expected[16] = 64'hfff0000000000000;
    test_name[16] = "-inf + 1.0 = -inf";

    // Test 17: +inf + (-1.0) = +inf
    test_A[17] = 64'h7ff0000000000000;
    test_B[17] = 64'hbff0000000000000;
    expected[17] = 64'h7ff0000000000000;
    test_name[17] = "+inf + (-1.0) = +inf";

    // Test 18: +inf + (+inf) = +inf
    test_A[18] = 64'h7ff0000000000000;
    test_B[18] = 64'h7ff0000000000000;
    expected[18] = 64'h7ff0000000000000;
    test_name[18] = "+inf + (+inf) = +inf";

    // Test 19: -inf + (-inf) = -inf
    test_A[19] = 64'hfff0000000000000;
    test_B[19] = 64'hfff0000000000000;
    expected[19] = 64'hfff0000000000000;
    test_name[19] = "-inf + (-inf) = -inf";

    // Test 20: +inf + (-inf) = NaN
    test_A[20] = 64'h7ff0000000000000;
    test_B[20] = 64'hfff0000000000000;
    expected[20] = 64'h7ff8000000000000;
    test_name[20] = "+inf + (-inf) = NaN";

    // Test 21: 0.5 + 0.5 = 1.0
    test_A[21] = 64'h3fe0000000000000;
    test_B[21] = 64'h3fe0000000000000;
    expected[21] = 64'h3ff0000000000000;
    test_name[21] = "0.5 + 0.5 = 1.0";

    // Test 22: 7.0 + 8.0 = 15.0
    test_A[22] = 64'h401c000000000000;
    test_B[22] = 64'h4020000000000000;
    expected[22] = 64'h402e000000000000;
    test_name[22] = "7.0 + 8.0 = 15.0";

    // Test 23: -7.0 + 8.0 = 1.0
    test_A[23] = 64'hc01c000000000000;
    test_B[23] = 64'h4020000000000000;
    expected[23] = 64'h3ff0000000000000;
    test_name[23] = "-7.0 + 8.0 = 1.0";

    // Test 24: 7.0 + (-8.0) = -1.0
    test_A[24] = 64'h401c000000000000;
    test_B[24] = 64'hc020000000000000;
    expected[24] = 64'hbff0000000000000;
    test_name[24] = "7.0 + (-8.0) = -1.0";

    // Test 25: 123.456 + 789.024 ≈ 912.48
    test_A[25] = 64'h405edd2f1a9fbe77;
    test_B[25] = 64'h4088a83126e978d5;
    expected[25] = 64'h408c83d70a3d70a4;
    test_name[25] = "123.456 + 789.024 = 912.48";

    // Test 26: 0.0 + 0.0 = 0.0
    test_A[26] = 64'h0000000000000000;
    test_B[26] = 64'h0000000000000000;
    expected[26] = 64'h0000000000000000;
    test_name[26] = "0.0 + 0.0 = 0.0";

    // Test 27: -0.0 + 0.0 = 0.0
    test_A[27] = 64'h8000000000000000;
    test_B[27] = 64'h0000000000000000;
    expected[27] = 64'h0000000000000000;
    test_name[27] = "-0.0 + 0.0 = 0.0";

    // Test 28: 1e10 + 1e10 = 2e10
    test_A[28] = 64'h4202a05f20000000;
    test_B[28] = 64'h4202a05f20000000;
    expected[28] = 64'h4212a05f20000000;
    test_name[28] = "1e10 + 1e10 = 2e10";

    // Test 29: 1e-10 + 1e-10 = 2e-10
    test_A[29] = 64'h3ddb7cdfd9d7bdbb;
    test_B[29] = 64'h3ddb7cdfd9d7bdbb;
    expected[29] = 64'h3deb7cdfd9d7bdbb;
    test_name[29] = "1e-10 + 1e-10 = 2e-10";

    // Test 30: Very small + very large
    test_A[30] = 64'h3e7ad7f29abcaf48;  // ~1e-7
    test_B[30] = 64'h4197d78400000000;  // ~1e8
    expected[30] = 64'h4197d78400000007;  // ~1e8 (small value absorbed)
    test_name[30] = "1e-7 + 1e8 = 1e8";

    // Test 31: 16.0 + 16.0 = 32.0
    test_A[31] = 64'h4030000000000000;
    test_B[31] = 64'h4030000000000000;
    expected[31] = 64'h4040000000000000;
    test_name[31] = "16.0 + 16.0 = 32.0";

    // Test 32: 0.0625 + 0.0625 = 0.125
    test_A[32] = 64'h3fb0000000000000;
    test_B[32] = 64'h3fb0000000000000;
    expected[32] = 64'h3fc0000000000000;
    test_name[32] = "0.0625 + 0.0625 = 0.125";

    // Test 33: 3.14159 + 2.71828 ≈ 5.85987
    test_A[33] = 64'h400921f9f01b866e;
    //400921fb54442d18;
    test_B[33] = 64'h4005bf0995aaf790;
    //4005bf0a8b145769;
    expected[33] = 64'h40177081c2e33eff;
    test_name[33] = "pi + e = 5.85987";

    // Test 34: Large same exponent
    test_A[34] = 64'h4330000000000000;  // 2^52
    test_B[34] = 64'h4330000000000000;  // 2^52
    expected[34] = 64'h4340000000000000;  // 2^53
    test_name[34] = "2^52 + 2^52 = 2^53";

    // Test 35: 99.99 + 0.01 = 100.0
    test_A[35] = 64'h4058ff5c28f5c28f;
    test_B[35] = 64'h3f847ae147ae147b;
    expected[35] = 64'h4059000000000000;
    test_name[35] = "99.99 + 0.01 = 100.0";

    // Test 36: 256.0 + 256.0 = 512.0
    test_A[36] = 64'h4070000000000000;
    test_B[36] = 64'h4070000000000000;
    expected[36] = 64'h4080000000000000;
    test_name[36] = "256.0 + 256.0 = 512.0";

    // Test 37: 1024.0 + (-1024.0) = 0.0
    test_A[37] = 64'h4090000000000000;
    test_B[37] = 64'hc090000000000000;
    expected[37] = 64'h0000000000000000;
    test_name[37] = "1024.0 + (-1024.0) = 0.0";

    // Test 38: 0.001 + 0.002 = 0.003
    test_A[38] = 64'h3f50624dd2f1a9fc;
    test_B[38] = 64'h3f60624dd2f1a9fc;
    expected[38] = 64'h3f689374bc6a7efa;
    test_name[38] = "0.001 + 0.002 = 0.003";

    // Test 39: 555.555 + 444.445 = 1000.0
    test_A[39] = 64'h40815c70a3d70a3d;
    test_B[39] = 64'h407bc71eb851eb85;
    expected[39] = 64'h408f400000000000;
    test_name[39] = "555.555 + 444.445 = 1000.0";

    // Test 40: 1.0 + 0.0 = 1.0
    test_A[40] = 64'h3ff0000000000000;
    test_B[40] = 64'h0000000000000000;
    expected[40] = 64'h3ff0000000000000;
    test_name[40] = "1.0 + 0.0 = 1.0";

    // Test 41: 128.0 + 128.0 = 256.0
    test_A[41] = 64'h4060000000000000;
    test_B[41] = 64'h4060000000000000;
    expected[41] = 64'h4070000000000000;
    test_name[41] = "128.0 + 128.0 = 256.0";

    // Test 42: 64.5 + 64.5 = 129.0
    test_A[42] = 64'h4050200000000000;
    test_B[42] = 64'h4050200000000000;
    expected[42] = 64'h4060200000000000;
    test_name[42] = "64.5 + 64.5 = 129.0";

    // Test 43: 0.75 + 0.25 = 1.0
    test_A[43] = 64'h3fe8000000000000;
    test_B[43] = 64'h3fd0000000000000;
    expected[43] = 64'h3ff0000000000000;
    test_name[43] = "0.75 + 0.25 = 1.0";

    // Test 44: 1.0e308 + 1.0e308 = overflow to infinity
    test_A[44] = 64'h7fe0000000000000;
    test_B[44] = 64'h7fe0000000000000;
    expected[44] = 64'h7ff0000000000000;
    test_name[44] = "1e308 + 1e308 = +inf (overflow)";

    // Test 44: 1.0e308 + 1.0e308 = overflow to infinity
    test_A[45] = 64'h54B249AD2594C37D;
    test_B[45] = 64'hd47d42aea2879f2e;
    expected[45] = 64'h54b075823b6c498a;
    test_name[45] = "1e100 + (-1e99) = 9e99";

    // Test 44: 1.0e308 + 1.0e308 = overflow to infinity
    test_A[46] = 64'h408F400000000000;
    test_B[46] = 64'hBF847AE147AE147B;
    expected[46] = 64'h408F3FEB851EB852;
    test_name[46] = "1000 + (0.01) = 999.99";

    // Test 47: 0.7 + (-0.3) = 0.4
    test_A[47] = 64'h3FE6666666666666;
    test_B[47] = 64'hBFD3333333333333;
    expected[47] = 64'h3FD999999999999A;
    test_name[47] = "0.7 + (-0.3) = 0.4";

    // Test 48: 3.14159 + (-2.71828) = 0.42331
    test_A[48] = 64'h400921FB54442D18;
    test_B[48] = 64'hC005BF0A8B145769;
    expected[48] = 64'h3FDB11F1A0000000;
    test_name[48] = "3.14159 + (-2.71828) = 0.42331";

    // Test 49: 100.001 + (-100) = 0.001
    test_A[49] = 64'h40590010624dd2f2;
    test_B[49] = 64'hC059000000000000;
    expected[49] = 64'h3F50624DD2F1A9FC;
    test_name[49] = "100.001 + (-100) = 0.001";

    // Test 50: 1.0 + (-1e-6) = 0.999999
    test_A[50] = 64'h3FF0000000000000;
    test_B[50] = 64'hBEB0C6F7A0B5ED8D;
    expected[50] = 64'h3FEFFFFFD6FFE120;
    test_name[50] = "1.0 + (-1e-6) = 0.999999";


    // Run all tests
    for (i = 0; i <= 50; i = i + 1) begin
      A = test_A[i];
      B = test_B[i];
      #10;

      if (out == expected[i]) begin
        $display("Test %2d: PASS - %s", i, test_name[i]);
        passed = passed + 1;
      end else begin
        $display("Test %2d: FAIL - %s", i, test_name[i]);
        $display("         Expected: %h, Got: %h", expected[i], out);
        $display("debugging....");
        $display("M_5: %b %b", rounded_mantissa[106:53], rounded_mantissa[52:0]);
        $display("M_4: %b %b", shifted_mantissa[106:53], shifted_mantissa[52:0]);
        $display("M_3: %b %b", temp_mantissa[106:53], temp_mantissa[52:0]);
        $display("M_2: %b %b", M_2[106:53], M_2[52:0]);
        $display("M_1: %b %b", M_1[106:53], M_1[52:0]);
        /*
        $display("M_3: %b", temp_mantissa);
        $display("M_4: %b", shifted_mantissa);
        $display("Added?: %b", add);
        $display("Shifted G, R, S: %b %b %b", G_1, R_1, S_1);
        $display("ROunded in subtraction? %b", round_sub);
        */
        failed = failed + 1;
      end
    end

    $display("\n========================================");
    $display("Test Summary:");
    $display("  Total:  %2d", passed + failed);
    $display("  Passed: %2d", passed);
    $display("  Failed: %2d", failed);
    $display("========================================");

    $finish;
  end

endmodule
