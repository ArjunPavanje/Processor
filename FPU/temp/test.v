module fpu_cntrl_tb;
  reg  [31:0] instruction;
  wire [ 2:0] fpu_op;

  // Instantiate DUT
  fpu_cntrl dut (
      .instruction(instruction),
      .fpu_op(fpu_op)
  );

  initial begin
    // Test fadd.d f1, f2, f3;
    instruction = 32'h023170d3;  // funct5[31:27], fmt[26:25], x [24:7], opcode[6:0]
    #10;
    $display("fadd.d op = %b (expected: 000)", fpu_op);

    // Test fsub.d f11, f20, f13;
    instruction = 32'h0ada75d3;
    #10;
    $display("fsub.d op = %b (expected: 001)", fpu_op);

    // Test fmul.d f21, f7, f9;
    instruction = 32'h1293fad3;
    #10;
    $display("fmul.d op = %b (expected: 010)", fpu_op);

    // Test fdiv.d f30, f16, f15;
    instruction = 32'h1af87f53;
    #10;
    $display("fdiv.d op = %b (expected: 011)", fpu_op);

    // Test fsqrt.d f23, f3;
    instruction = 32'h5a01fbd3;
    #10;
    $display("fsqrt.d op = %b (expected: 100)", fpu_op);

    // Test fcvt.l.d x19, f11;
    instruction = 32'hc225f9d3;
    #10;
    $display("fcvt.l.d op = %b (expected: 101)", fpu_op);

    // Test fcvt.d.l f27, x12;
    instruction = 32'hd2267dd3;
    #10;
    $display("fcvt.d.l op = %b (expected: 110)", fpu_op);

    /*
    // Test unknown instruction (default)
    instruction = 32'b11111_00_xxxxxxxxxxxxxxxxxxxxxxxxxxx_0000000;
    #10;
    $display("unknown op = %b (expected: 111)", fpu_op);
    */
    $finish;
  end
endmodule
