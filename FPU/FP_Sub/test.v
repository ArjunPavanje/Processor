`timescale 1ns / 1ps

module FPSub_tb;

  reg [63:0] A;
  reg [63:0] B;
  wire [63:0] out;
  reg [63:0] expected;

  integer passed = 0;
  integer failed = 0;
  integer total = 0;

  // Instantiate the FPSub module
  FPSub uut (
      .A  (A),
      .B  (B),
      .out(out)
  );
  // Task to check result
  task check_result;
    input [63:0] exp;
    input [8*80:1] test_desc;
    begin
      #10;  // Wait for result
      if (out === exp) begin
        $display("Test %2d: PASS - %s", total, test_desc);
        passed = passed + 1;
      end else begin
        $display("Test %2d: FAIL - %s", total, test_desc);
        $display("         Expected: %h, Got: %h", exp, out);
        failed = failed + 1;
      end
      total = total + 1;
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, FPSub_tb);

    A = 64'h4043800000000000;
    B = 64'h4024000000000000;
    expected = 64'h403D000000000000;
    check_result(expected, "39.0 - 10.0 = 29.0");

    A = 64'h402E000000000000;
    B = 64'hC014000000000000;
    expected = 64'h4034000000000000;
    check_result(expected, "15.0 - (-5.0) = 20.0");

    A = 64'h4014000000000000;
    B = 64'hC02E000000000000;
    expected = 64'h4034000000000000;
    check_result(expected, "5.0 - (-15.0) = 20.0");

    A = 64'hC024000000000000;
    B = 64'hC014000000000000;
    expected = 64'hC014000000000000;
    check_result(expected, "-10.0 - (-5.0) = -5.0");

    A = 64'h4004000000000000;
    B = 64'h400C000000000000;
    expected = 64'hBFF0000000000000;
    check_result(expected, "2.5 - 3.5 = -1.0");

    A = 64'h0000000000000000;
    B = 64'h3FF0000000000000;
    expected = 64'hBFF0000000000000;
    check_result(expected, "0.0 - 1.0 = -1.0");

    A = 64'h0000000000000000;
    B = 64'hBFF0000000000000;
    expected = 64'h3FF0000000000000;
    check_result(expected, "  0.0 - (-1.0) = 1.0");

    A = 64'h4014000000000000;
    B = 64'h0000000000000000;
    expected = 64'h4014000000000000;
    check_result(expected, "5.0 - 0.0 = 5.0");

    A = 64'hC014000000000000;
    B = 64'h0000000000000000;
    expected = 64'hC014000000000000;
    check_result(expected, "-5.0 - 0.0 = -5.0");

    A = 64'h0000000000000000;
    B = 64'h0000000000000000;
    expected = 64'h0000000000000000;
    check_result(expected, "0.0 - 0.0 = 0.0");

    A = 64'h3FF0000000000000;
    B = 64'h3FF0000000000000;
    expected = 64'h0000000000000000;
    check_result(expected, "1.0 - 1.0 = 0.0");

    A = 64'h4059000000000000;
    B = 64'h4059000000000000;
    expected = 64'h0000000000000000;
    check_result(expected, "100.0 - 100.0 = 0.0");

    A = 64'hC049000000000000;
    B = 64'hC049000000000000;
    expected = 64'h0000000000000000;
    check_result(expected, "-50.0 - (-50.0) = 0.0");

    A = 64'h4202A05F20000000;
    B = 64'h4202A05F20000000;
    expected = 64'h0000000000000000;
    check_result(expected, "1e10 - 1e10 = 0.0");

    A = 64'h3DDB7CDFD9D7BDBB;
    B = 64'h3DDB7CDFD9D7BDBB;
    expected = 64'h0000000000000000;
    check_result(expected, "1e-10 - 1e-10 = 0.0");

    A = 64'h408F400000000000;
    B = 64'h3F847AE147AE147B;
    expected = 64'h408F3FEB851EB852;
    check_result(expected, "1000.0 - 0.01 = 999.99");

    A = 64'h408F400000000000;
    B = 64'hC08F400000000000;
    expected = 64'h409F400000000000;
    check_result(expected, "1000.0 - (-1000.0) = 2000.0");

    A = 64'h3F847AE147AE147B;
    B = 64'hBF847AE147AE147B;
    expected = 64'h3F947AE147AE147B;
    check_result(expected, "0.01 - (-0.01) = 0.02");

    A = 64'h430C6BF526340000;
    B = 64'h3FF0000000000000;
    expected = 64'h430c6bf52633fff8;
    check_result(expected, "1e15 - 1.0 = 1-1e15");

    A = 64'h3FF0000000000000;
    B = 64'h430C6BF526340000;
    expected = 64'hc30c6bf52633fff8;
    check_result(expected, "1.0 - 1e15 = -1e15+1");

    A = 64'h01A56E1FC2F8F359;
    B = 64'h01A56E1FC2F8F359;
    expected = 64'h0000000000000000;
    check_result(expected, "1e-300 - 1e-300 = 0.0");

    A = 64'h2B2BFF2EE48E0530;
    B = 64'h2AF665BF1D3E6A8D;
    expected = 64'h2B29327700E637DE;
    check_result(expected, "1e-100 - 1e-101 = 9e-101");

    A = 64'h3FE0000000000000;
    B = 64'h3FD0000000000000;
    expected = 64'h3FD0000000000000;
    check_result(expected, "0.5 - 0.25 = 0.25");

    A = 64'h3FC0000000000000;
    B = 64'h3FB0000000000000;
    expected = 64'h3FB0000000000000;
    check_result(expected, "0.125 - 0.0625 = 0.0625");

    A = 64'h54B249AD2594C37D;
    B = 64'h547D42AEA2879F2E;
    expected = 64'h54b075823b6c498a;
    check_result(expected, "1e100 - 1e99 = 9e99");

    A = 64'h6974E718D7D7625A;
    B = 64'h6940B8E0ACAC4EAF;
    expected = 64'h6972CFFCC241D884;
    check_result(expected, "1e200 - 1e199 = 9e199");

    A = 64'hD4B249AD2594C37D;
    B = 64'h54B249AD2594C37D;
    expected = 64'hD4C249AD2594C37D;
    check_result(expected, "-1e100 - 1e100 = -2e100");

    A = 64'h4A511B0EC57E649A;
    B = 64'hCA511B0EC57E649A;
    expected = 64'h4A611B0EC57E649A;
    check_result(expected, "1e50 - (-1e50) = 2e50");

    A = 64'h7FE19F61BA578180;
    B = 64'hFFE19F61BA578180;
    expected = 64'h7FF0000000000000;
    check_result(expected, "9.9e307 - (-9.9e307) = +inf");

    A = 64'h3FB999999999999A;
    B = 64'h3FC999999999999A;
    expected = 64'hBFB999999999999A;
    check_result(expected, "0.1 - 0.2 = -0.1");

    A = 64'h3FE6666666666666;
    B = 64'h3FD3333333333333;
    expected = 64'h3FD999999999999A;
    check_result(expected, "0.7 - 0.3 = 0.4");

    A = 64'h3FF8000000000000;
    B = 64'h3FE0000000000000;
    expected = 64'h3FF0000000000000;
    check_result(expected, "1.5 - 0.5 = 1.0");

    A = 64'h400921f9f01b866e;
    B = 64'h4005bf0995aaf790;
    expected = 64'h3fdb1782d38476f3;
    check_result(expected, "pi - e = 0.42331");

    A = 64'h40590010624DD2F2;
    B = 64'h4059000000000000;
    expected = 64'h3F50624DD2F1A9FC;
    check_result(expected, "100.001 - 100.0 = 0.001");

    A = 64'h3FF0000000000000;
    B = 64'h4000000000000000;
    expected = 64'hBFF0000000000000;
    check_result(expected, "1.0 - 2.0 = -1.0");

    A = 64'h4024000000000000;
    B = 64'h4034000000000000;
    expected = 64'hC024000000000000;
    check_result(expected, "10.0 - 20.0 = -10.0");

    A = 64'hC014000000000000;
    B = 64'h4014000000000000;
    expected = 64'hC024000000000000;
    check_result(expected, "-5.0 - 5.0 = -10.0");

    A = 64'h3F50624DD2F1A9FC;
    B = 64'h3F60624DD2F1A9FC;
    expected = 64'hBF50624DD2F1A9FC;
    check_result(expected, "0.001 - 0.002 = -0.001");

    A = 64'hC059000000000000;
    B = 64'h4049000000000000;
    expected = 64'hC062C00000000000;
    check_result(expected, "-100.0 - 50.0 = -150.0");

    A = 64'h40934A456D5CFAAD;
    B = 64'h3F1A36E2EB1C432D;
    expected = 64'h40934A45532617C2;
    check_result(expected, "1234.5678 - 0.0001 = 1234.5677");

    A = 64'h3F1A36E2EB1C432D;
    B = 64'h40934A456D5CFAAD;
    expected = 64'hc0934a45532617c2;
    check_result(expected, "0.0001 - 1234.5678 = -1234.5678");

    A = 64'h408F3FFDF3B645A2;
    B = 64'h3FEFF7CED916872B;
    expected = 64'h408F380000000000;
    check_result(expected, "999.999 - 0.999 = 999.0");

    A = 64'h412E848000000000;
    B = 64'h3FF0000000000000;
    expected = 64'h412E847E00000000;
    check_result(expected, "1e6 - 1.0 = 999999.0");

    A = 64'h3FF0000000000000;
    B = 64'h3EB0C6F7A0B5ED8D;
    expected = 64'h3FEFFFFDE7210BE9;
    check_result(expected, "1.0 - 1e-6 = 0.999999");

    A = 64'h7FEFFFFFFFFFFFFF;
    B = 64'h3FF0000000000000;
    expected = 64'h7FEFFFFFFFFFFFFF;
    check_result(expected, "DBL_MAX - 1.0 = DBL_MAX");

    A = 64'h0010000000000000;
    B = 64'h000730D67819E8D2;
    expected = 64'h0008CF2987E6172E;
    check_result(expected, "2.225e-308 - 1e-308 = 1.225e-308");

    A = 64'h405EDD2F1A9FBE77;
    B = 64'h405EDD2F1A9FBE77;
    expected = 64'h0000000000000000;
    check_result(expected, "123.456 - 123.456 = 0.0");

    A = 64'h401C000000000000;
    B = 64'h4008000000000000;
    expected = 64'h4010000000000000;
    check_result(expected, "7.0 - 3.0 = 4.0");

    A = 64'hC01C000000000000;
    B = 64'hC008000000000000;
    expected = 64'hC010000000000000;
    check_result(expected, "-7.0 - (-3.0) = -4.0");


    // Print summary
    $display("");
    $display("========================================");
    $display("Test Summary:");
    $display("  Total:  %2d", total);
    $display("  Passed: %2d", passed);
    $display("  Failed: %2d", failed);
    $display("========================================");

    $finish;
  end

endmodule
