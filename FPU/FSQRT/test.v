`timescale 1ns / 1ps

module quake3_tb;

  reg  [63:0] x;
  wire [63:0] y;

  // Instantiate your FSQRT module (assumed to be in FSQRT.v)
  FSQRT uut (
      .x(x),
      .y(y)
  );

  // loop/index vars (declare at module scope)
  integer i;
  integer j, k;  // moved out of initial block
  real input_val, output_val, expected_val, error, tolerance;
  real cumulative_error;

  real errors           [0:49];  // array to store abs errors
  real max_error, min_error;
  real        temp;  // moved out of initial block for swapping

  reg  [63:0] test_values                                      [0:49];  // Array for 50 test values

  // Task to check sqrt result and print table row
  task check_sqrt;
    input [63:0] input_fp;
    begin
      x = input_fp;
      #10;

      input_val = $bitstoreal(input_fp);
      output_val = $bitstoreal(y);
      expected_val = $sqrt(input_val);

      if (expected_val != 0.0) error = (output_val - expected_val) / expected_val;
      else error = output_val;

      $display("%016h  %14.7g  %016h  %14.7g  %10.6f%%", input_fp, input_val, y, output_val,
               error * 100.0);

      cumulative_error = cumulative_error + (error < 0 ? -error : error);
      errors[i] = (error < 0 ? -error : error);
    end
  endtask

  initial begin
    // Initialize test values: 50 arbitrary doubles with decimals + some integers
    test_values[0]   = 64'h405edd2f1a9fbe77;  // 123.4567
    test_values[1]   = 64'h402830e147ae147b;  // 12.1
    test_values[2]   = 64'h40450ae147ae147b;  // 42.35478
    test_values[3]   = 64'h4016800000000000;  // 5.75
    test_values[4]   = 64'h4039000000000000;  // 25.0 (int-like)
    test_values[5]   = 64'h3ff199999999999a;  // 1.1
    test_values[6]   = 64'h405999999999999a;  // 100.6
    test_values[7]   = 64'h4014000000000000;  // 5.0
    test_values[8]   = 64'h4044cccccccccccd;  // 42.2
    test_values[9]   = 64'h3fef333333333333;  // 0.484375
    test_values[10]  = 64'h4066666666666666;  // 180.4
    test_values[11]  = 64'h40a4000000000000;  // 512.0 (int)
    test_values[12]  = 64'h409999999999999a;  // 400.1
    test_values[13]  = 64'h4053333333333333;  // 70.1
    test_values[14]  = 64'h4008000000000000;  // 3.0
    test_values[15]  = 64'h4000000000000000;  // 2.0
    test_values[16]  = 64'h3ff0000000000000;  // 1.0
    test_values[17]  = 64'h4072d00000000000;  // 945.0
    test_values[18]  = 64'h4062400000000000;  // 132.0
    test_values[19]  = 64'h403f000000000000;  // 30.0
    test_values[20]  = 64'h400c28f5c28f5c29;  // 3.1415927 (pi approx)
    test_values[21]  = 64'h4005bf0a8b145769;  // 2.71828 (e approx)
    test_values[22]  = 64'h404c000000000000;  // 51.0
    test_values[23]  = 64'h4038000000000000;  // 24.0
    test_values[24]  = 64'h3fe0000000000000;  // 0.5
    test_values[25]  = 64'h3ff8000000000000;  // 1.5
    test_values[26]  = 64'h405999999999999a;  // 100.6 (repeat)
    test_values[27]  = 64'h40a0000000000000;  // 512 (repeat)
    test_values[28]  = 64'h4069000000000000;  // 180.0
    test_values[29]  = 64'h4032800000000000;  // 18.0
    test_values[30]  = 64'h4029000000000000;  // 12.5
    test_values[31]  = 64'h401e000000000000;  // 7.5
    test_values[32]  = 64'h4040000000000000;  // 32.0
    test_values[33]  = 64'h4048000000000000;  // 42.0
    test_values[34]  = 64'h403c000000000000;  // 28.0
    test_values[35]  = 64'h4010000000000000;  // 4.0
    test_values[36]  = 64'h4024000000000000;  // 10.0
    test_values[37]  = 64'h403e000000000000;  // 30.0 (repeat)
    test_values[38]  = 64'h4030000000000000;  // 16.0
    test_values[39]  = 64'h4036000000000000;  // 22.0
    test_values[40]  = 64'h402d000000000000;  // 13.0
    test_values[41]  = 64'h4009000000000000;  // 3.125
    test_values[42]  = 64'h3fe999999999999a;  // 0.8
    test_values[43]  = 64'h3ff4000000000000;  // 1.25
    test_values[44]  = 64'h4002000000000000;  // 2.25
    test_values[45]  = 64'h4000000000000000;  // 2.0 (repeat)
    test_values[46]  = 64'h4032800000000000;  // 18.0 (repeat)
    test_values[47]  = 64'h4008000000000000;  // 3.0 (repeat)
    test_values[48]  = 64'h4038000000000000;  // 24.0 (repeat)
    test_values[49]  = 64'h404c000000000000;  // 51.0 (repeat)

    cumulative_error = 0.0;

    $dumpvars(0, quake3_tb);
    $display(
        "\n======================================================================================");
    $display(
        "       Input Hex       Input Dec       Output Hex       Output Dec       Percentage Error");
    $display(
        "======================================================================================");

    for (i = 0; i < 50; i = i + 1) begin
      check_sqrt(test_values[i]);
    end

    // Sort errors array for median (simple bubble-like sort)
    for (j = 0; j < 50; j = j + 1) begin
      for (k = j + 1; k < 50; k = k + 1) begin
        if (errors[k] < errors[j]) begin
          temp = errors[j];
          errors[j] = errors[k];
          errors[k] = temp;
        end
      end
    end

    max_error = errors[49];
    min_error = errors[0];

    $display(
        "======================================================================================");
    $display("Mean absolute error   : %10.6f%%", (cumulative_error / 50.0) * 100.0);
    // For 0-based 50 elements median is average of [24] and [25]. Use [25] as you requested earlier.
    $display("Median absolute error : %10.6f%%", errors[25] * 100.0);
    $display("Worst case error      : %10.6f%%", max_error * 100.0);
    $display("Best case error       : %10.6f%%", min_error * 100.0);
    $display(
        "======================================================================================");

    $finish;
  end

endmodule


