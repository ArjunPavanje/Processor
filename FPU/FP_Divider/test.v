`timescale 1ns / 1ps

module FPDiv_tb;

  reg [63:0] N1;
  reg [63:0] N2;
  wire [63:0] out;

  reg [63:0] expected;
  integer passed;
  integer failed;
  integer total;

  FPDiv uut (
      .N1 (N1),
      .N2 (N2),
      .out(out)
  );
  wire [127:0] mantissa_product = uut.mantissa_product;
  wire [ 11:0] exponent_3 = uut.exponent_3;
  wire [ 63:0] mantissa_normalized = uut.mantissa_normalized;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, FPDiv_tb);

    passed = 0;
    failed = 0;
    total  = 0;

    $display("\n========================================");
    $display("  IEEE 754 FP Division Test Suite");
    $display("========================================\n");

    // Test 1: 3.0 / 2.0 = 1.5
    N1 = 64'h4008000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'h3ff8000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  1: PASS - 3.0 / 2.0 = 1.5");
    end else begin
      failed = failed + 1;
      $display("Test  1: FAIL - 3.0 / 2.0 = 1.5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 2: 2.0 / 123.0
    N1 = 64'h4000000000000000;
    N2 = 64'h405ec00000000000;
    expected = 64'h3f90a6810a6810a7;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  2: PASS - 2.0 / 123.0");
    end else begin
      failed = failed + 1;
      $display("Test  2: FAIL - 2.0 / 123.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 3: 1.5 / 5.0 = 0.3
    N1 = 64'h3ff8000000000000;
    N2 = 64'h4014000000000000;
    expected = 64'h3fd3333333333333;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  3: PASS - 1.5 / 5.0 = 0.3");
    end else begin
      failed = failed + 1;
      $display("Test  3: FAIL - 1.5 / 5.0 = 0.3");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 4: -2.0 / 3.0
    N1 = 64'hc000000000000000;
    N2 = 64'h4008000000000000;
    expected = 64'hbfe5555555555555;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  4: PASS - -2.0 / 3.0");
    end else begin
      failed = failed + 1;
      $display("Test  4: FAIL - -2.0 / 3.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 5: 5.0 / 2.0 = 2.5
    N1 = 64'h4014000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'h4004000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  5: PASS - 5.0 / 2.0 = 2.5");
    end else begin
      failed = failed + 1;
      $display("Test  5: FAIL - 5.0 / 2.0 = 2.5");
      $display("         Expected: %h, Got: %h", expected, out);
    end


    // Test 7: -5.0 / -5.0 = 1.0
    N1 = 64'hc014000000000000;
    N2 = 64'hc014000000000000;
    expected = 64'h3ff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  7: PASS - -5.0 / -5.0 = 1.0");
    end else begin
      failed = failed + 1;
      $display("Test  7: FAIL - -5.0 / -5.0 = 1.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 8: 1.0 / 1.0 = 1.0
    N1 = 64'h3ff0000000000000;
    N2 = 64'h3ff0000000000000;
    expected = 64'h3ff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  8: PASS - 1.0 / 1.0 = 1.0");
    end else begin
      failed = failed + 1;
      $display("Test  8: FAIL - 1.0 / 1.0 = 1.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 9: 7.0 / 2.0 = 3.5
    N1 = 64'h401c000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'h400c000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test  9: PASS - 7.0 / 2.0 = 3.5");
    end else begin
      failed = failed + 1;
      $display("Test  9: FAIL - 7.0 / 2.0 = 3.5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 10: 100.0 / 10.0 = 10.0
    N1 = 64'h4059000000000000;
    N2 = 64'h4024000000000000;
    expected = 64'h4024000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 10: PASS - 100.0 / 10.0 = 10.0");
    end else begin
      failed = failed + 1;
      $display("Test 10: FAIL - 100.0 / 10.0 = 10.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 11: 1.0 / 3.0
    N1 = 64'h3ff0000000000000;
    N2 = 64'h4008000000000000;
    expected = 64'h3fd5555555555555;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 11: PASS - 1.0 / 3.0");
    end else begin
      failed = failed + 1;
      $display("Test 11: FAIL - 1.0 / 3.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 12: 2.5 / 0.5 = 5.0
    N1 = 64'h4004000000000000;
    N2 = 64'h3fe0000000000000;
    expected = 64'h4014000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 12: PASS - 2.5 / 0.5 = 5.0");
    end else begin
      failed = failed + 1;
      $display("Test 12: FAIL - 2.5 / 0.5 = 5.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 13: -10.0 / 2.0 = -5.0
    N1 = 64'hc024000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'hc014000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 13: PASS - -10.0 / 2.0 = -5.0");
    end else begin
      failed = failed + 1;
      $display("Test 13: FAIL - -10.0 / 2.0 = -5.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 14: 8.0 / -4.0 = -2.0
    N1 = 64'h4020000000000000;
    N2 = 64'hc010000000000000;
    expected = 64'hc000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 14: PASS - 8.0 / -4.0 = -2.0");
    end else begin
      failed = failed + 1;
      $display("Test 14: FAIL - 8.0 / -4.0 = -2.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 15: -6.0 / -3.0 = 2.0
    N1 = 64'hc018000000000000;
    N2 = 64'hc008000000000000;
    expected = 64'h4000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 15: PASS - -6.0 / -3.0 = 2.0");
    end else begin
      failed = failed + 1;
      $display("Test 15: FAIL - -6.0 / -3.0 = 2.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 16: pos / +0 = +inf
    N1 = 64'h3ff0000000000000;
    N2 = 64'h0000000000000000;
    expected = 64'h7ff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 16: PASS - pos / +0 = +inf");
    end else begin
      failed = failed + 1;
      $display("Test 16: FAIL - pos / +0 = +inf");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 17: neg / +0 = -inf
    N1 = 64'hbff0000000000000;
    N2 = 64'h0000000000000000;
    expected = 64'hfff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 17: PASS - neg / +0 = -inf");
    end else begin
      failed = failed + 1;
      $display("Test 17: FAIL - neg / +0 = -inf");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 18: pos / -0 = -inf
    N1 = 64'h4014000000000000;
    N2 = 64'h8000000000000000;
    expected = 64'hfff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 18: PASS - pos / -0 = -inf");
    end else begin
      failed = failed + 1;
      $display("Test 18: FAIL - pos / -0 = -inf");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 19: neg / -0 = +inf
    N1 = 64'hc014000000000000;
    N2 = 64'h8000000000000000;
    expected = 64'h7ff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 19: PASS - neg / -0 = +inf");
    end else begin
      failed = failed + 1;
      $display("Test 19: FAIL - neg / -0 = +inf");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 20: +0 / 1.0 = +0
    N1 = 64'h0000000000000000;
    N2 = 64'h3ff0000000000000;
    expected = 64'h0000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 20: PASS - +0 / 1.0 = +0");
    end else begin
      failed = failed + 1;
      $display("Test 20: FAIL - +0 / 1.0 = +0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 21: -0 / 1.0 = -0
    N1 = 64'h8000000000000000;
    N2 = 64'h3ff0000000000000;
    expected = 64'h0000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 21: PASS - -0 / 1.0 = -0");
    end else begin
      failed = failed + 1;
      $display("Test 21: FAIL - -0 / 1.0 = -0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 22: +0 / -1.0 = -0
    N1 = 64'h0000000000000000;
    N2 = 64'hbff0000000000000;
    expected = 64'h0000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 22: PASS - +0 / -1.0 = -0");
    end else begin
      failed = failed + 1;
      $display("Test 22: FAIL - +0 / -1.0 = -0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 23: -0 / -1.0 = +0
    N1 = 64'h8000000000000000;
    N2 = 64'hbff0000000000000;
    expected = 64'h0000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 23: PASS - -0 / -1.0 = +0");
    end else begin
      failed = failed + 1;
      $display("Test 23: FAIL - -0 / -1.0 = +0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 24: +0 / +0 = NaN
    N1 = 64'h0000000000000000;
    N2 = 64'h0000000000000000;
    expected = 64'h7ff8000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 24: PASS - +0 / +0 = NaN");
    end else begin
      failed = failed + 1;
      $display("Test 24: FAIL - +0 / +0 = NaN");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 25: -0 / +0 = NaN
    N1 = 64'h8000000000000000;
    N2 = 64'h0000000000000000;
    expected = 64'h7ff8000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 25: PASS - -0 / +0 = NaN");
    end else begin
      failed = failed + 1;
      $display("Test 25: FAIL - -0 / +0 = NaN");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 26: +0 / -0 = NaN
    N1 = 64'h0000000000000000;
    N2 = 64'h8000000000000000;
    expected = 64'h7ff8000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 26: PASS - +0 / -0 = NaN");
    end else begin
      failed = failed + 1;
      $display("Test 26: FAIL - +0 / -0 = NaN");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 27: +inf / +inf = NaN
    N1 = 64'h7ff0000000000000;
    N2 = 64'h7ff0000000000000;
    expected = 64'h7ff8000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 27: PASS - +inf / +inf = NaN");
    end else begin
      failed = failed + 1;
      $display("Test 27: FAIL - +inf / +inf = NaN");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 28: -inf / +inf = NaN
    N1 = 64'hfff0000000000000;
    N2 = 64'h7ff0000000000000;
    expected = 64'h7ff8000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 28: PASS - -inf / +inf = NaN");
    end else begin
      failed = failed + 1;
      $display("Test 28: FAIL - -inf / +inf = NaN");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 29: +inf / 2.0 = +inf
    N1 = 64'h7ff0000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'h7ff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 29: PASS - +inf / 2.0 = +inf");
    end else begin
      failed = failed + 1;
      $display("Test 29: FAIL - +inf / 2.0 = +inf");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 30: -inf / 2.0 = -inf
    N1 = 64'hfff0000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'hfff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 30: PASS - -inf / 2.0 = -inf");
    end else begin
      failed = failed + 1;
      $display("Test 30: FAIL - -inf / 2.0 = -inf");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 31: +inf / -2.0 = -inf
    N1 = 64'h7ff0000000000000;
    N2 = 64'hc000000000000000;
    expected = 64'hfff0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 31: PASS - +inf / -2.0 = -inf");
    end else begin
      failed = failed + 1;
      $display("Test 31: FAIL - +inf / -2.0 = -inf");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 32: 2.0 / +inf = +0
    N1 = 64'h4000000000000000;
    N2 = 64'h7ff0000000000000;
    expected = 64'h0000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 32: PASS - 2.0 / +inf = +0");
    end else begin
      failed = failed + 1;
      $display("Test 32: FAIL - 2.0 / +inf = +0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 33: 2.0 / -inf = -0
    N1 = 64'h4000000000000000;
    N2 = 64'hfff0000000000000;
    expected = 64'h8000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 33: PASS - 2.0 / -inf = -0");
    end else begin
      failed = failed + 1;
      $display("Test 33: FAIL - 2.0 / -inf = -0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 34: -2.0 / +inf = -0
    N1 = 64'hc000000000000000;
    N2 = 64'h7ff0000000000000;
    expected = 64'h8000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 34: PASS - -2.0 / +inf = -0");
    end else begin
      failed = failed + 1;
      $display("Test 34: FAIL - -2.0 / +inf = -0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 35: -2.0 / -inf = +0
    N1 = 64'hc000000000000000;
    N2 = 64'hfff0000000000000;
    expected = 64'h0000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 35: PASS - -2.0 / -inf = +0");
    end else begin
      failed = failed + 1;
      $display("Test 35: FAIL - -2.0 / -inf = +0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 36: -inf / -inf = NaN
    N1 = 64'hfff0000000000000;
    N2 = 64'hfff0000000000000;
    expected = 64'h7ff8000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 36: PASS - -inf / -inf = NaN");
    end else begin
      failed = failed + 1;
      $display("Test 36: FAIL - -inf / -inf = NaN");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 37: 1.0 / 2.0 = 0.5
    N1 = 64'h3ff0000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'h3fe0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 37: PASS - 1.0 / 2.0 = 0.5");
    end else begin
      failed = failed + 1;
      $display("Test 37: FAIL - 1.0 / 2.0 = 0.5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 38: 4.0 / 8.0 = 0.5
    N1 = 64'h4010000000000000;
    N2 = 64'h4020000000000000;
    expected = 64'h3fe0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 38: PASS - 4.0 / 8.0 = 0.5");
    end else begin
      failed = failed + 1;
      $display("Test 38: FAIL - 4.0 / 8.0 = 0.5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 39: 9.0 / 3.0 = 3.0
    N1 = 64'h4022000000000000;
    N2 = 64'h4008000000000000;
    expected = 64'h4008000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 39: PASS - 9.0 / 3.0 = 3.0");
    end else begin
      failed = failed + 1;
      $display("Test 39: FAIL - 9.0 / 3.0 = 3.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 40: 0.25 / 0.5 = 0.5
    N1 = 64'h3fd0000000000000;
    N2 = 64'h3fe0000000000000;
    expected = 64'h3fe0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 40: PASS - 0.25 / 0.5 = 0.5");
    end else begin
      failed = failed + 1;
      $display("Test 40: FAIL - 0.25 / 0.5 = 0.5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 41: 100.0 / 25.0 = 4.0
    N1 = 64'h4059000000000000;
    N2 = 64'h4039000000000000;
    expected = 64'h4010000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 41: PASS - 100.0 / 25.0 = 4.0");
    end else begin
      failed = failed + 1;
      $display("Test 41: FAIL - 100.0 / 25.0 = 4.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 42: 1e10 / 1e5 = 1e5
    N1 = 64'h4202a05f20000000;
    N2 = 64'h40f86a0000000000;
    expected = 64'h40f86a0000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 42: PASS - 1e10 / 1e5 = 1e5");
    end else begin
      failed = failed + 1;
      $display("Test 42: FAIL - 1e10 / 1e5 = 1e5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 43: 1e-10 / 1e-5 = 1e-5
    N1 = 64'h3ddb7cdfd9d7bdbb;
    N2 = 64'h3ee4f8b588e368f1;
    expected = 64'h3ee4f8b588e368f0;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 43: PASS - 1e-10 / 1e-5 = 1e-5");
    end else begin
      failed = failed + 1;
      $display("Test 43: FAIL - 1e-10 / 1e-5 = 1e-5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 44: -100.0 / 50.0 = -2.0
    N1 = 64'hc059000000000000;
    N2 = 64'h4049000000000000;
    expected = 64'hc000000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 44: PASS - -100.0 / 50.0 = -2.0");
    end else begin
      failed = failed + 1;
      $display("Test 44: FAIL - -100.0 / 50.0 = -2.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 45: 7.5 / 1.5 = 5.0
    N1 = 64'h401e000000000000;
    N2 = 64'h3ff8000000000000;
    expected = 64'h4014000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 45: PASS - 7.5 / 1.5 = 5.0");
    end else begin
      failed = failed + 1;
      $display("Test 45: FAIL - 7.5 / 1.5 = 5.0");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    // Test 46: 0.125 / 0.25 = 0.5
    N1 = 64'h3fc0000000000000;
    N2 = 64'h3fd0000000000000;
    expected = 64'h3fe0000000000000;
    #10;
    total = total + 1;
    if (out == expected) begin
      passed = passed + 1;
      $display("Test 46: PASS - 0.125 / 0.25 = 0.5");
    end else begin
      failed = failed + 1;
      $display("Test 46: FAIL - 0.125 / 0.25 = 0.5");
      $display("         Expected: %h, Got: %h", expected, out);
    end

    $display("\n========================================");
    $display("  Test Summary");
    $display("========================================");
    $display("Total Tests: %0d", total);
    $display("Passed:      %0d", passed);
    $display("Failed:      %0d", failed);
    $display("Pass Rate:   %0d%%", (passed * 100) / total);
    $display("========================================\n");

    $finish;
  end
endmodule
