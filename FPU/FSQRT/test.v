`timescale 1ns / 1ps

module quake3_tb;

  reg  [63:0] x;
  wire [63:0] y;

  FSQRT uut (
      .x(x),
      .y(y)
  );

  integer pass_count;
  integer fail_count;
  integer test_num;

  // Task to check sqrt result
  task check_sqrt;
    input [255:0] label;
    input [63:0] input_fp;
    real input_val;
    real output_val;
    real expected_val;
    real error;
    real tolerance;
    begin
      test_num = test_num + 1;
      x = input_fp;
      #10;

      input_val = $bitstoreal(input_fp);
      output_val = $bitstoreal(y);
      expected_val = $sqrt(input_val);

      // Calculate relative error
      if (expected_val != 0.0) error = (output_val - expected_val) / expected_val;
      else error = output_val;

      // Tolerance: 0.1% for approximation algorithms
      tolerance = 0.05;

      if ((error < tolerance) && (error > -tolerance)) begin
        $display("[PASS] Test %2d: %-30s", test_num, label);
        pass_count = pass_count + 1;
      end else begin
        $display("[FAIL] Test %2d: %-30s", test_num, label);
        $display("       Input:    %.17g (0x%h)", input_val, input_fp);
        $display("       Expected: %.17g", expected_val);
        $display("       Got:      %.17g (0x%h)", output_val, y);
        $display("       Error:    %.6f%%", error * 100.0);
        fail_count = fail_count + 1;
      end
    end
  endtask

  initial begin
    pass_count = 0;
    fail_count = 0;
    test_num   = 0;

    $dumpvars(0, quake3_tb);
    $display("\n==============================================================");
    $display("            FSQRT Testbench Start");
    $display("==============================================================\n");

    // 1. Special values: Zero
    check_sqrt("Positive zero (+0.0)", 64'h0000000000000000);

    // 2. Small positive values
    check_sqrt("Tiny value (2^-100)", 64'h39B0000000000000);
    check_sqrt("Small value (0.001)", 64'h3F50624DD2F1A9FC);
    check_sqrt("0.1", 64'h3FB999999999999A);
    check_sqrt("0.25", 64'h3FD0000000000000);
    check_sqrt("0.5", 64'h3FE0000000000000);

    // 3. Values near 1
    check_sqrt("0.9", 64'h3FECCCCCCCCCCCCD);
    check_sqrt("1.0", 64'h3FF0000000000000);
    check_sqrt("1.1", 64'h3FF199999999999A);
    check_sqrt("1.5", 64'h3FF8000000000000);

    // 4. Small integers
    check_sqrt("2.0", 64'h4000000000000000);
    check_sqrt("3.0", 64'h4008000000000000);
    check_sqrt("4.0", 64'h4010000000000000);
    check_sqrt("5.0", 64'h4014000000000000);
    check_sqrt("9.0", 64'h4022000000000000);
    check_sqrt("10.0", 64'h4024000000000000);

    // 5. Perfect squares
    check_sqrt("16.0 (4^2)", 64'h4030000000000000);
    check_sqrt("25.0 (5^2)", 64'h4039000000000000);
    check_sqrt("36.0 (6^2)", 64'h4042000000000000);
    check_sqrt("49.0 (7^2)", 64'h4048800000000000);
    check_sqrt("64.0 (8^2)", 64'h4050000000000000);
    check_sqrt("81.0 (9^2)", 64'h4054400000000000);
    check_sqrt("100.0 (10^2)", 64'h4059000000000000);

    // 6. Powers of 2
    check_sqrt("128.0 (2^7)", 64'h4060000000000000);
    check_sqrt("256.0 (2^8)", 64'h4070000000000000);
    check_sqrt("512.0 (2^9)", 64'h4080000000000000);
    check_sqrt("1024.0 (2^10)", 64'h4090000000000000);
    check_sqrt("4096.0 (2^12)", 64'h40B0000000000000);
    check_sqrt("65536.0 (2^16)", 64'h40F0000000000000);

    // 7. Large values
    check_sqrt("1000.0", 64'h408F400000000000);
    check_sqrt("10000.0", 64'h40C3880000000000);
    check_sqrt("100000.0", 64'h40F86A0000000000);
    check_sqrt("1000000.0", 64'h412E848000000000);
    check_sqrt("1e9", 64'h41CDCD6500000000);
    check_sqrt("1e12", 64'h426D1A94A2000000);

    // 8. Random values
    check_sqrt("42.0", 64'h4045000000000000);
    check_sqrt("123.456", 64'h405EDD2F1A9FBE77);
    check_sqrt("999.999", 64'h408F3FF972474538);
    check_sqrt("3.14159 (pi)", 64'h400921FB54442D18);
    check_sqrt("2.71828 (e)", 64'h4005BF0A8B145769);

    // 9. Very large values
    check_sqrt("1e20", 64'h44B52D02C7E14AF6);
    check_sqrt("1e50", 64'h4A6E1D6E1D6E1D6E);
    check_sqrt("1e100", 64'h54B249AD2594C37D);


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
