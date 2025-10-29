`timescale 1ns / 1ps

module FPMul_tb;

  reg [63:0] N1;
  reg [63:0] N2;
  wire [63:0] out;
  reg [63:0] expected;
  integer pass_count;
  integer fail_count;

  FPMul uut (
      .N1 (N1),
      .N2 (N2),
      .out(out)
  );

  initial begin
    pass_count = 0;
    fail_count = 0;

    // Test 1: 2.0 * 3.0
    N1 = 64'h4000000000000000;
    N2 = 64'h4008000000000000;
    expected = 64'h4018000000000000;
    #10;
    if (out == expected) begin
      $display("Test 1: PASS - 2.0 * 3.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 1: FAIL - 2.0 * 3.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 2: 1.5 * 5.0
    N1 = 64'h3ff8000000000000;
    N2 = 64'h4014000000000000;
    expected = 64'h401e000000000000;
    #10;
    if (out == expected) begin
      $display("Test 2: PASS - 1.5 * 5.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 2: FAIL - 1.5 * 5.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 3: 1.0 * 1.0
    N1 = 64'h3ff0000000000000;
    N2 = 64'h3ff0000000000000;
    expected = 64'h3ff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 3: PASS - 1.0 * 1.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 3: FAIL - 1.0 * 1.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 4: 10.0 * 0.1
    N1 = 64'h4024000000000000;
    N2 = 64'h3fb999999999999a;
    expected = 64'h3ff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 4: PASS - 10.0 * 0.1");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 4: FAIL - 10.0 * 0.1 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 5: 0.5 * 0.5
    N1 = 64'h3fe0000000000000;
    N2 = 64'h3fe0000000000000;
    expected = 64'h3fd0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 5: PASS - 0.5 * 0.5");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 5: FAIL - 0.5 * 0.5 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 6: 7.0 * 8.0
    N1 = 64'h401c000000000000;
    N2 = 64'h4020000000000000;
    expected = 64'h404c000000000000;
    #10;
    if (out == expected) begin
      $display("Test 6: PASS - 7.0 * 8.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 6: FAIL - 7.0 * 8.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 7: 100.0 * 0.01
    N1 = 64'h4059000000000000;
    N2 = 64'h3f847ae147ae147b;
    expected = 64'h3ff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 7: PASS - 100.0 * 0.01");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 7: FAIL - 100.0 * 0.01 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 8: 2.5 * 4.0
    N1 = 64'h4004000000000000;
    N2 = 64'h4010000000000000;
    expected = 64'h4024000000000000;
    #10;
    if (out == expected) begin
      $display("Test 8: PASS - 2.5 * 4.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 8: FAIL - 2.5 * 4.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 9: pi * 2.0
    N1 = 64'h400921f9f01b866e;
    N2 = 64'h4000000000000000;
    expected = 64'h401921f9f01b866e;
    #10;
    if (out == expected) begin
      $display("Test 9: PASS - pi * 2.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 9: FAIL - pi * 2.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 10: 1.234567 * 8.901234
    N1 = 64'h3ff3c0c9539b8887;
    N2 = 64'h4021cd6e8af81627;
    expected = 64'h4025f9a75b18c176;
    #10;
    if (out == expected) begin
      $display("Test 10: PASS - 1.234567 * 8.901234");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 10: FAIL - 1.234567 * 8.901234 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 11: -2.0 * 3.0
    N1 = 64'hc000000000000000;
    N2 = 64'h4008000000000000;
    expected = 64'hc018000000000000;
    #10;
    if (out == expected) begin
      $display("Test 11: PASS - -2.0 * 3.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 11: FAIL - -2.0 * 3.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 12: 2.0 * -3.0
    N1 = 64'h4000000000000000;
    N2 = 64'hc008000000000000;
    expected = 64'hc018000000000000;
    #10;
    if (out == expected) begin
      $display("Test 12: PASS - 2.0 * -3.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 12: FAIL - 2.0 * -3.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 13: -2.0 * -3.0
    N1 = 64'hc000000000000000;
    N2 = 64'hc008000000000000;
    expected = 64'h4018000000000000;
    #10;
    if (out == expected) begin
      $display("Test 13: PASS - -2.0 * -3.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 13: FAIL - -2.0 * -3.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 14: -5.0 * -5.0
    N1 = 64'hc014000000000000;
    N2 = 64'hc014000000000000;
    expected = 64'h4039000000000000;
    #10;
    if (out == expected) begin
      $display("Test 14: PASS - -5.0 * -5.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 14: FAIL - -5.0 * -5.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 15: -1.0 * 1.0
    N1 = 64'hbff0000000000000;
    N2 = 64'h3ff0000000000000;
    expected = 64'hbff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 15: PASS - -1.0 * 1.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 15: FAIL - -1.0 * 1.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 16: -0.5 * 4.0
    N1 = 64'hbfe0000000000000;
    N2 = 64'h4010000000000000;
    expected = 64'hc000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 16: PASS - -0.5 * 4.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 16: FAIL - -0.5 * 4.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 17: 7.5 * -2.0
    N1 = 64'h401e000000000000;
    N2 = 64'hc000000000000000;
    expected = 64'hc02e000000000000;
    #10;
    if (out == expected) begin
      $display("Test 17: PASS - 7.5 * -2.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 17: FAIL - 7.5 * -2.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 18: -10.0 * -0.1
    N1 = 64'hc024000000000000;
    N2 = 64'hbfb999999999999a;
    expected = 64'h3ff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 18: PASS - -10.0 * -0.1");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 18: FAIL - -10.0 * -0.1 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 19: -1.5 * -1.5
    N1 = 64'hbff8000000000000;
    N2 = 64'hbff8000000000000;
    expected = 64'h4002000000000000;
    #10;
    if (out == expected) begin
      $display("Test 19: PASS - -1.5 * -1.5");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 19: FAIL - -1.5 * -1.5 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 20: 100.0 * -0.5
    N1 = 64'h4059000000000000;
    N2 = 64'hbfe0000000000000;
    expected = 64'hc049000000000000;
    #10;
    if (out == expected) begin
      $display("Test 20: PASS - 100.0 * -0.5");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 20: FAIL - 100.0 * -0.5 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 21: 0.0 * 0.0
    N1 = 64'h0000000000000000;
    N2 = 64'h0000000000000000;
    expected = 64'h0000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 21: PASS - 0.0 * 0.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 21: FAIL - 0.0 * 0.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 22: 0.0 * 123.0
    N1 = 64'h0000000000000000;
    N2 = 64'h405ec00000000000;
    expected = 64'h0000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 22: PASS - 0.0 * 123.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 22: FAIL - 0.0 * 123.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 23: 456.0 * 0.0
    N1 = 64'h407c800000000000;
    N2 = 64'h0000000000000000;
    expected = 64'h0000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 23: PASS - 456.0 * 0.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 23: FAIL - 456.0 * 0.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 24: -0.0 * 5.0
    N1 = 64'h8000000000000000;
    N2 = 64'h4014000000000000;
    expected = 64'h0000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 24: PASS - -0.0 * 5.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 24: FAIL - -0.0 * 5.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 25: 0.0 * -7.0
    N1 = 64'h0000000000000000;
    N2 = 64'hc01c000000000000;
    expected = 64'h0000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 25: PASS - 0.0 * -7.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 25: FAIL - 0.0 * -7.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 26: 1e-100 * 1e-100
    N1 = 64'h2b2bff2ee48e0530;
    N2 = 64'h2b2bff2ee48e0530;
    expected = 64'h16687e92154ef7ac;
    #10;
    if (out == expected) begin
      $display("Test 26: PASS - 1e-100 * 1e-100");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 26: FAIL - 1e-100 * 1e-100 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 27: 1e-150 * 2.0
    N1 = 64'h20ca2fe76a3f9475;
    N2 = 64'h4000000000000000;
    expected = 64'h20da2fe76a3f9475;
    #10;
    if (out == expected) begin
      $display("Test 27: PASS - 1e-150 * 2.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 27: FAIL - 1e-150 * 2.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 28: 1e-200 * 1e-200 (underflow)
    N1 = 64'h16687e92154ef7ac;
    N2 = 64'h16687e92154ef7ac;
    expected = 64'h0000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 28: PASS - 1e-200 * 1e-200 (underflow)");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 28: FAIL - 1e-200 * 1e-200 (underflow) (Expected: %h, Got: %h)", expected,
               out);
      fail_count = fail_count + 1;
    end

    // Test 29: near min * 0.5
    N1 = 64'h000fffdd31a00c6d;
    N2 = 64'h3fe0000000000000;
    expected = 64'h0000000000000000;
    #10;
    if (out == expected) begin
      $display("Test 29: PASS - near min * 0.5");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 29: FAIL - near min * 0.5 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 30: 1e-50 * 1e-50
    N1 = 64'h358dee7a4ad4b81f;
    N2 = 64'h358dee7a4ad4b81f;
    expected = 64'h2b2bff2ee48e0530;
    #10;
    if (out == expected) begin
      $display("Test 30: PASS - 1e-50 * 1e-50");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 30: FAIL - 1e-50 * 1e-50 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 31: 1e100 * 1e100
    N1 = 64'h54b249ad2594c37d;
    N2 = 64'h54b249ad2594c37d;
    expected = 64'h6974e718d7d7625a;
    #10;
    if (out == expected) begin
      $display("Test 31: PASS - 1e100 * 1e100");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 31: FAIL - 1e100 * 1e100 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 32: 1e200 * 2.0
    N1 = 64'h6974e718d7d7625a;
    N2 = 64'h4000000000000000;
    expected = 64'h6984e718d7d7625a;
    #10;
    if (out == expected) begin
      $display("Test 32: PASS - 1e200 * 2.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 32: FAIL - 1e200 * 2.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 33: 1e308 * 2.0 (overflow)
    N1 = 64'h7fe1ccf385ebc8a0;
    N2 = 64'h4000000000000000;
    expected = 64'h7ff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 33: PASS - 1e308 * 2.0 (overflow)");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 33: FAIL - 1e308 * 2.0 (overflow) (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 34: 1e150 * 1e150
    N1 = 64'h5f138d352e5096af;
    N2 = 64'h5f138d352e5096af;
    expected = 64'h7e37e43c8800759c;
    #10;
    if (out == expected) begin
      $display("Test 34: PASS - 1e150 * 1e150");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 34: FAIL - 1e150 * 1e150 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 35: 1e154 * 1e154 (overflow)
    N1 = 64'h5fe7dddf6b095ff1;
    N2 = 64'h5fe7dddf6b095ff1;
    expected = 64'h7fe1ccf385ebc8a0;
    #10;
    if (out == expected) begin
      $display("Test 35: PASS - 1e154 * 1e154 (overflow)");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 35: FAIL - 1e154 * 1e154 (overflow) (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 36: 2.0 * 2.0
    N1 = 64'h4000000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'h4010000000000000;
    #10;
    if (out == expected) begin
      $display("Test 36: PASS - 2.0 * 2.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 36: FAIL - 2.0 * 2.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 37: 4.0 * 4.0
    N1 = 64'h4010000000000000;
    N2 = 64'h4010000000000000;
    expected = 64'h4030000000000000;
    #10;
    if (out == expected) begin
      $display("Test 37: PASS - 4.0 * 4.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 37: FAIL - 4.0 * 4.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 38: 0.125 * 8.0
    N1 = 64'h3fc0000000000000;
    N2 = 64'h4020000000000000;
    expected = 64'h3ff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 38: PASS - 0.125 * 8.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 38: FAIL - 0.125 * 8.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 39: 16.0 * 0.0625
    N1 = 64'h4030000000000000;
    N2 = 64'h3fb0000000000000;
    expected = 64'h3ff0000000000000;
    #10;
    if (out == expected) begin
      $display("Test 39: PASS - 16.0 * 0.0625");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 39: FAIL - 16.0 * 0.0625 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 40: 1024.0 * 1024.0
    N1 = 64'h4090000000000000;
    N2 = 64'h4090000000000000;
    expected = 64'h4130000000000000;
    #10;
    if (out == expected) begin
      $display("Test 40: PASS - 1024.0 * 1024.0");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 40: FAIL - 1024.0 * 1024.0 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 41: 1.0000001 * 1.0000001
    N1 = 64'h3ff000001ad7f29b;
    N2 = 64'h3ff000001ad7f29b;
    expected = 64'h3ff0000035afe6f8;
    #10;
    if (out == expected) begin
      $display("Test 41: PASS - 1.0000001 * 1.0000001");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 41: FAIL - 1.0000001 * 1.0000001 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 42: 0.9999999 * 0.9999999
    N1 = 64'h3fefffffca501acb;
    N2 = 64'h3fefffffca501acb;
    expected = 64'h3fefffff94a0391a;
    #10;
    if (out == expected) begin
      $display("Test 42: PASS - 0.9999999 * 0.9999999");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 42: FAIL - 0.9999999 * 0.9999999 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 43: 1.5 * (2/3)
    N1 = 64'h3ff8000000000000;
    N2 = 64'h3fe5555555555555;
    expected = 64'h3fefffffffffffff;
    #10;
    if (out == expected) begin
      $display("Test 43: PASS - 1.5 * (2/3)");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 43: FAIL - 1.5 * (2/3) (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 44: 3.0 * (1/3)
    N1 = 64'h4008000000000000;
    N2 = 64'h3fd5555555555555;
    expected = 64'h3fefffffffffffff;
    #10;
    if (out == expected) begin
      $display("Test 44: PASS - 3.0 * (1/3)");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 44: FAIL - 3.0 * (1/3) (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 45: 1.1 * 1.1
    N1 = 64'h3ff199999999999a;
    N2 = 64'h3ff199999999999a;
    expected = 64'h3ff35c28f5c28f5c;
    #10;
    if (out == expected) begin
      $display("Test 45: PASS - 1.1 * 1.1");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 45: FAIL - 1.1 * 1.1 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 46: max * 0.5
    N1 = 64'h7fefffffffffffff;
    N2 = 64'h3fe0000000000000;
    expected = 64'h7fdfffffffffffff;
    #10;
    if (out == expected) begin
      $display("Test 46: PASS - max * 0.5");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 46: FAIL - max * 0.5 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 47: min_normal * 2
    N1 = 64'h0010000000000000;
    N2 = 64'h4000000000000000;
    expected = 64'h0020000000000000;
    #10;
    if (out == expected) begin
      $display("Test 47: PASS - min_normal * 2");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 47: FAIL - min_normal * 2 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 48: 123.456 * 789.012
    N1 = 64'h405edd2f1a9fbe77;
    N2 = 64'h4088a8189374bc6a;
    expected = 64'h40f7c8043f5f9160;
    #10;
    if (out == expected) begin
      $display("Test 48: PASS - 123.456 * 789.012");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 48: FAIL - 123.456 * 789.012 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 49: 9.999 * 9.999
    N1 = 64'h4023ff7ced916873;
    N2 = 64'h4023ff7ced916873;
    expected = 64'h4058feb8561d4308;
    #10;
    if (out == expected) begin
      $display("Test 49: PASS - 9.999 * 9.999");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 49: FAIL - 9.999 * 9.999 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    // Test 50: 0.001 * 0.001
    N1 = 64'h3f50624dd2f1a9fc;
    N2 = 64'h3f50624dd2f1a9fc;
    expected = 64'h3eb0c6f7a0b5ed8d;
    #10;
    if (out == expected) begin
      $display("Test 50: PASS - 0.001 * 0.001");
      pass_count = pass_count + 1;
    end else begin
      $display("Test 50: FAIL - 0.001 * 0.001 (Expected: %h, Got: %h)", expected, out);
      fail_count = fail_count + 1;
    end

    $display("==================================================");
    $display("Test Summary: %0d PASSED, %0d FAILED", pass_count, fail_count);
    $display("==================================================");

    $finish;
  end
endmodule
