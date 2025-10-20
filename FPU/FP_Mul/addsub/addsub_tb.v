`timescale 1ns/1ps

module addsub_tb;

  // Inputs
  reg [63:0] a;
  reg [63:0] b;
  reg sel;

  // Outputs
  wire [63:0] res;
  wire cout;

  // Instantiate DUT (Device Under Test)
  addsub dut (
    .a(a),
    .b(b),
    .sel(sel),
    .res(res),
    .cout(cout)
  );

  initial begin
    $display("Starting addsub testbench...");
    $monitor("T=%0t | sel=%b | a=%h | b=%h | res=%h | cout=%b", 
             $time, sel, a, b, res, cout);

    // Test 1: Addition of small numbers
    sel = 0; a = 64'h0000_0000_0000_0005; b = 64'h0000_0000_0000_0003; #10;

    // Test 2: Subtraction (a > b)
    sel = 1; a = 64'h0000_0000_0000_000A; b = 64'h0000_0000_0000_0003; #10;

    // Test 3: Subtraction (a < b)
    sel = 1; a = 64'h5; b = 64'hA; #10;

    // Test 4: Large unsigned addition
    sel = 0; a = 64'hFFFF_FFFF_FFFF_F000; b = 64'h0000_0000_0000_0FFF; #10;

    // Test 5: Random test patterns
    repeat (5) begin
      sel = $random;
      a = $random;
      b = $random;
      #10;
    end

    $display("Testbench completed.");
    #10 $finish;
  end

endmodule
