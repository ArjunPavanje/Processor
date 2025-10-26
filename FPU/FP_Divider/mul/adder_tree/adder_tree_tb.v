`timescale 1ns/1ps

module tb_adder_tree;
	// Choose total number of inputs
	parameter N = 8; // Try 8, 16, 32, 64, 128
	
	// Declare as unpacked array to match module port
	reg [127:0] in [0:(N-1)];
	wire [127:0] sum;

	// Reference model
	reg [255:0] refsum; // Use extended width to avoid overflow while summing

	// DUT instantiation
	adder_tree #(.N(N)) dut (.in(in), .sum(sum));

	integer i;
	reg [127:0] temp;

	initial begin
		$display("Starting adder_tree test for N = %0d", N);

		// Test several random patterns
		repeat (10) begin
			// Drive random inputs to each element of unpacked array
			for (i = 0; i < N; i = i + 1)
				in[i] = {$random, $random, $random, $random};

			// Compute reference sum (128-bit addition circularly truncated)
			refsum = 0;
			for (i = 0; i < N; i = i + 1)
				refsum = refsum + in[i];

			#5; // wait for combinational settle
			temp = refsum[127:0];

			if (sum !== temp)
				$display("Mismatch! expected=%h, got=%h", temp, sum);
			else
				$display("PASS: input group sum %h", sum);
		end

		$display("All tests finished.");
		$finish;
	end
endmodule
