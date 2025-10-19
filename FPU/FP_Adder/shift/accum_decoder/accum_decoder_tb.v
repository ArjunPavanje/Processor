`timescale 1ns/1ps

module tb_accum_decoder;

	// Testbench parameter for input width N
	parameter N = 2;
	
	reg [N-1:0] in;
	reg set;
	wire [(1 << N) - 1:0] out;
	
	// Instantiate the DUT
	accum_decoder #(.N(N)) dut (
		.in(in),
		.set(set),
		.out(out)
	);
	
	integer i;
	
	initial begin
		// Test case 1: set = 0, cycle through all input values
		set = 0;
		for(i = 0; i < (1 << N); i = i + 1) begin
			in = i;
			#10;
			$display("Set: %b, Input: %b, Output: %b", set, in, out);
		end
		
		// Test case 2: set = 1, cycle through all input values
		set = 1;
		for(i = 0; i < (1 << N); i = i + 1) begin
			in = i;
			#10;
			$display("Set: %b, Input: %b, Output: %b", set, in, out);
		end
		
		$finish;
	end
endmodule
