`timescale 1ns / 1ps

module FPDiv_formal_tb;

  reg  [63:0] N1;
  reg  [63:0] N2;
  wire [63:0] out;

  FPDiv_Quake3 uut (
      .N1 (N1),
      .N2 (N2),
      .out(out)
  );

  integer i;
  integer j, k;

  real n1_dec, n2_dec, out_dec, exp_dec;
  real err, cumulative_error;

  real errors[0:49];
  real max_error, min_error;
  real temp;

  // Test vectors - 50 test cases
  reg [63:0] N1_list[0:49];
  reg [63:0] N2_list[0:49];
  reg [63:0] EXP_list[0:49];

  // ----------------------------------------
  //  Convert hex → real
  // ----------------------------------------
  function real fp_to_real(input [63:0] a);
    begin
      fp_to_real = $bitstoreal(a);
    end
  endfunction

  // ----------------------------------------
  //  Check test case i
  // ----------------------------------------
  task run_test;
    input integer idx;
    begin
      N1 = N1_list[idx];
      N2 = N2_list[idx];
      #10;

      n1_dec  = fp_to_real(N1);
      n2_dec  = fp_to_real(N2);
      out_dec = fp_to_real(out);
      exp_dec = fp_to_real(EXP_list[idx]);

      // ----------------------------------------
      // Error Calculation
      // ----------------------------------------
      if (EXP_list[idx][62:52] == 11'h7ff && EXP_list[idx][51:0] != 0) begin
        // Expected NaN
        if (out[62:52] == 11'h7ff && out[51:0] != 0) err = 0;
        else err = 1;
      end else if (EXP_list[idx][62:52] == 11'h7ff && EXP_list[idx][51:0] == 0) begin
        // Expected ±inf
        if (out == EXP_list[idx]) err = 0;
        else err = 1;
      end else if (exp_dec == 0.0) begin
        err = (out_dec < 0 ? -out_dec : out_dec);
      end else begin
        err = (out_dec - exp_dec) / exp_dec;
        if (err < 0) err = -err;
      end

      cumulative_error = cumulative_error + err;
      errors[idx] = err;

      // ----------------------------------------
      // Output Row
      // ----------------------------------------
      $display("%16h  %20.10g  %16h  %20.10g  %16h  %20.10g  %16h  %20.10g  %15.7f%%", N1, n1_dec,
               N2, n2_dec, out, out_dec, EXP_list[idx], exp_dec, err * 100.0);

    end
  endtask

  initial begin
    // ------------------------------------------------------------
    // Load 50 diverse division test cases
    // ------------------------------------------------------------
    // Division test cases - 50 diverse floating-point divisions
    N1_list[0] = 64'h40231810624dd2f2;
    N2_list[0] = 64'h4008000000000000;
    EXP_list[0] = 64'h4009756b2dbd1943;
    N1_list[1] = 64'h3ff0000000000000;
    N2_list[1] = 64'h4069000000000000;
    EXP_list[1] = 64'h3f747ae147ae147b;
    N1_list[2] = 64'h4029000000000000;
    N2_list[2] = 64'h4024000000000000;
    EXP_list[2] = 64'h3ff4000000000000;
    N1_list[3] = 64'h401e000000000000;
    N2_list[3] = 64'h4009000000000000;
    EXP_list[3] = 64'h4003333333333333;
    N1_list[4] = 64'h4069000000000000;
    N2_list[4] = 64'h4002000000000000;
    EXP_list[4] = 64'h405638e38e38e38e;
    N1_list[5] = 64'h405999999999999a;
    N2_list[5] = 64'h4069000000000000;
    EXP_list[5] = 64'h3fe0624dd2f1a9fc;
    N1_list[6] = 64'hc038000000000000;
    N2_list[6] = 64'h3fe8000000000000;
    EXP_list[6] = 64'hc040000000000000;
    N1_list[7] = 64'h4000000000000000;
    N2_list[7] = 64'h400921f9f01b866e;
    EXP_list[7] = 64'h3fe45f318e7adaf5;
    N1_list[8] = 64'h4040000000000000;
    N2_list[8] = 64'h3ff199999999999a;
    EXP_list[8] = 64'h403d1745d1745d17;
    N1_list[9] = 64'h3ff0000000000000;
    N2_list[9] = 64'h4000000000000000;
    EXP_list[9] = 64'h3fe0000000000000;
    N1_list[10] = 64'h4019f2f837b4a234;
    N2_list[10] = 64'h401e000000000000;
    EXP_list[10] = 64'h3febadd590c0ad04;
    N1_list[11] = 64'h3fd0000000000000;
    N2_list[11] = 64'h4012000000000000;
    EXP_list[11] = 64'h3fac71c71c71c71c;
    N1_list[12] = 64'h3ff0000000000000;
    N2_list[12] = 64'h3fef333333333333;
    EXP_list[12] = 64'h3ff0690690690691;
    N1_list[13] = 64'h4016800000000000;
    N2_list[13] = 64'h4062400000000000;
    EXP_list[13] = 64'h3fa3b9dcee773b9e;
    N1_list[14] = 64'h4053333333333333;
    N2_list[14] = 64'h405edd2f1a9fbe77;
    EXP_list[14] = 64'h3fe3e81caa66b7f0;
    N1_list[15] = 64'h3fe8000000000000;
    N2_list[15] = 64'h403f000000000000;
    EXP_list[15] = 64'h3f98c6318c6318c6;
    N1_list[16] = 64'h401e000000000000;
    N2_list[16] = 64'h40450ae147ae147b;
    EXP_list[16] = 64'h3fc6cf9c3d700461;
    N1_list[17] = 64'h400921f9f01b866e;
    N2_list[17] = 64'h4029000000000000;
    EXP_list[17] = 64'h3fd015beae261898;
    N1_list[18] = 64'hbff199999999999a;
    N2_list[18] = 64'h3fe999999999999a;
    EXP_list[18] = 64'hbff6000000000000;
    N1_list[19] = 64'h4072d00000000000;
    N2_list[19] = 64'h4010000000000000;
    EXP_list[19] = 64'h4052d00000000000;
    N1_list[20] = 64'h405edd2f1a9fbe77;
    N2_list[20] = 64'h4040000000000000;
    EXP_list[20] = 64'h400edd2f1a9fbe77;
    N1_list[21] = 64'h4036000000000000;
    N2_list[21] = 64'h4029000000000000;
    EXP_list[21] = 64'h3ffc28f5c28f5c29;
    N1_list[22] = 64'h400c28f5c28f5c29;
    N2_list[22] = 64'h4019f2f837b4a234;
    EXP_list[22] = 64'h3fe15cfc284b6556;
    N1_list[23] = 64'h4072d00000000000;
    N2_list[23] = 64'h4036000000000000;
    EXP_list[23] = 64'h402b5d1745d1745d;
    N1_list[24] = 64'h4002000000000000;
    N2_list[24] = 64'h4000000000000000;
    EXP_list[24] = 64'h3ff2000000000000;
    N1_list[25] = 64'h403c000000000000;
    N2_list[25] = 64'h4002000000000000;
    EXP_list[25] = 64'h4028e38e38e38e39;
    N1_list[26] = 64'h4038000000000000;
    N2_list[26] = 64'h4038000000000000;
    EXP_list[26] = 64'h3ff0000000000000;
    N1_list[27] = 64'h4012000000000000;
    N2_list[27] = 64'h4028000000000000;
    EXP_list[27] = 64'h3fd8000000000000;
    N1_list[28] = 64'hbff199999999999a;
    N2_list[28] = 64'h3ff199999999999a;
    EXP_list[28] = 64'hbff0000000000000;
    N1_list[29] = 64'h4066666666666666;
    N2_list[29] = 64'h4048000000000000;
    EXP_list[29] = 64'h400ddddddddddddd;
    N1_list[30] = 64'h3fe8000000000000;
    N2_list[30] = 64'h4008000000000000;
    EXP_list[30] = 64'h3fd0000000000000;
    N1_list[31] = 64'h403c000000000000;
    N2_list[31] = 64'h4000000000000000;
    EXP_list[31] = 64'h402c000000000000;
    N1_list[32] = 64'h3fef333333333333;
    N2_list[32] = 64'h402d000000000000;
    EXP_list[32] = 64'h3fb136bb25136bb2;
    N1_list[33] = 64'hc014000000000000;
    N2_list[33] = 64'h40231810624dd2f2;
    EXP_list[33] = 64'hbfe0c25a5d9554c3;
    N1_list[34] = 64'h401999999999999a;
    N2_list[34] = 64'h4039000000000000;
    EXP_list[34] = 64'h3fd0624dd2f1a9fc;
    N1_list[35] = 64'h4005bf0aa21a719b;
    N2_list[35] = 64'h4016800000000000;
    EXP_list[35] = 64'h3fdeed91f79d135a;
    N1_list[36] = 64'h4062400000000000;
    N2_list[36] = 64'h3ff8000000000000;
    EXP_list[36] = 64'h4058555555555555;
    N1_list[37] = 64'h3ff199999999999a;
    N2_list[37] = 64'h4059000000000000;
    EXP_list[37] = 64'h3f86872b020c49bb;
    N1_list[38] = 64'h401e000000000000;
    N2_list[38] = 64'h409999999999999a;
    EXP_list[38] = 64'h3f72c00000000000;
    N1_list[39] = 64'h402d000000000000;
    N2_list[39] = 64'h4000000000000000;
    EXP_list[39] = 64'h401d000000000000;
    N1_list[40] = 64'hc024000000000000;
    N2_list[40] = 64'h401e000000000000;
    EXP_list[40] = 64'hbff5555555555555;
    N1_list[41] = 64'hc029000000000000;
    N2_list[41] = 64'h4002000000000000;
    EXP_list[41] = 64'hc01638e38e38e38e;
    N1_list[42] = 64'h403c000000000000;
    N2_list[42] = 64'h4029000000000000;
    EXP_list[42] = 64'h4001eb851eb851ec;
    N1_list[43] = 64'h4048000000000000;
    N2_list[43] = 64'h40231810624dd2f2;
    EXP_list[43] = 64'h40141c6c704ccc1d;
    N1_list[44] = 64'hc014000000000000;
    N2_list[44] = 64'h4039000000000000;
    EXP_list[44] = 64'hbfc999999999999a;
    N1_list[45] = 64'h4010000000000000;
    N2_list[45] = 64'h4039000000000000;
    EXP_list[45] = 64'h3fc47ae147ae147b;
    N1_list[46] = 64'h4038000000000000;
    N2_list[46] = 64'h4019f2f837b4a234;
    EXP_list[46] = 64'h400d98add051f85e;
    N1_list[47] = 64'h4059000000000000;
    N2_list[47] = 64'h4029000000000000;
    EXP_list[47] = 64'h4020000000000000;
    N1_list[48] = 64'h405edd2f1a9fbe77;
    N2_list[48] = 64'h405999999999999a;
    EXP_list[48] = 64'h3ff34a3d70a3d70a;
    N1_list[49] = 64'h4053333333333333;
    N2_list[49] = 64'h3ff8000000000000;
    EXP_list[49] = 64'h4049999999999999;

    // ------------------------------------------------------------
    cumulative_error = 0.0;

    $dumpvars(0, FPDiv_formal_tb);

    $display(
        "\n=======================================================================================================================================================================================================");
    $display(
        "      N1 Hex              N1 Dec            N2 Hex              N2 Dec             Out Hex             Out Dec             Exp Hex             Exp Dec      Percentage Error");
    $display(
        "=======================================================================================================================================================================================================");

    // ------------------------------------------------------------
    for (i = 0; i < 50; i = i + 1) run_test(i);

    // ------------------------------------------------------------
    // Sort errors for median
    for (j = 0; j < 50; j = j + 1)
    for (k = j + 1; k < 50; k = k + 1)
    if (errors[k] < errors[j]) begin
      temp = errors[j];
      errors[j] = errors[k];
      errors[k] = temp;
    end

    max_error = errors[49];
    min_error = errors[0];

    $display(
        "=======================================================================================================================================================================================================");
    $display("Mean absolute error   : %10.6f%%", (cumulative_error / 50.0) * 100.0);
    $display("Median absolute error : %10.6f%%", errors[25] * 100.0);
    $display("Worst case error      : %10.6f%%", max_error * 100.0);
    $display("Best case error       : %10.6f%%", min_error * 100.0);
    $display(
        "=======================================================================================================================================================================================================\n");

    $finish;
  end

endmodule

