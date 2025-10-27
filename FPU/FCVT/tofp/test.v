`timescale 1ns/1ps

module tb_FCVT_fp;

  reg  [63:0] in;
  wire [63:0] fp;

  // Instantiate the DUT (Device Under Test)
  FCVT_fp uut (
      .in(in),
      .fp(fp)
  );

  // Helper signals for debug
  real fp_real;
  real int_real;

  // Task to display results nicely
  task show_result;
    begin
      fp_real = $bitstoreal(fp);
      int_real = $itor($signed(in));
      $display("-----------------------------------------------------");
      $display("Integer Input  : %0d (0x%h)", $signed(in), in);
      $display("FP Output (hex): 0x%h", fp);
      $display("FP Output (real): %f", fp_real);
    end
  endtask

  initial begin
    $display("==== FCVT_fp Testbench Start ====");

    // Test cases
    in = 64'd0;       #10 show_result();    // zero
    in = 64'd1;       #10 show_result();    // smallest positive
    in = 64'd2;       #10 show_result();
    in = 64'd10;      #10 show_result();
    in = 64'd123456;  #10 show_result();
    in = 64'd987654321; #10 show_result();
    in = 64'd4294967295; #10 show_result(); // 2^32-1
    in = 64'd9223372036854775807; #10 show_result(); // max positive 64-bit int

    // Negative numbers
    in = -64'd1;      #10 show_result();
    in = -64'd2;      #10 show_result();
    in = -64'd10;     #10 show_result();
    in = -64'd123456; #10 show_result();
    in = -64'd987654321; #10 show_result();
    in = -64'd4294967295; #10 show_result();
    in = -64'd9223372036854775808; #10 show_result(); // min negative 64-bit int

    $display("==== FCVT_fp Testbench End ====");
    $finish;
  end

endmodule

