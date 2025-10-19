// full adder
module full_adder(
	input wire a, // input #1
	input wire b, // input #2
	input wire cin, // carry in
	output wire sum,
	output wire cout // carry out
);
	assign sum = a ^ b ^ cin;
	assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder(
	input wire [63:0] a, // input #1
	input wire [63:0] b, // input #2
	input wire cin, // carry in
	output wire [63:0] sum,
	output wire cout // carry out
);
	// inner wiring to make the to transfer carry
	wire cinner [64:0];
	assign cinner[0] = cin;

	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin
			full_adder fa (
				.a(a[i]),
				.b(b[i]),
				.cin(cinner[i]),
				.sum(sum[i]),
				.cout(cinner[i + 1])
			);
		end
	endgenerate

	assign cout = cinner[64];
endmodule

/* extended_adder -> adder with inputs 128 bit and 64 bit
*/
module extended_adder (
	input wire [127:0] a, // input #1
	input wire [63:0] b, // input #2
	input wire cin, // carry in

	output wire [127:0] sum,
	output wire cout // carry out
);
	// inner wiring to make the to transfer carry
	wire cinner;

	// adds 64 bits of b to first 64 bits of a
	adder adder_1 (
		.a(a[63:0]),
		.b(b),
		.cin(cin),
		.sum(sum[63:0]),
		.cout(cinner)
	);

	// all zeros
	wire [63:0] dummy_zeros;
	assign dummy_zeroes = 64'b0;

	adder adder_2 (
		.a(a[127:64]),
		.b(dummy_zeroes),
		.cin(cinner),
		.sum(sum[127:64]),
		.cout(cout)
	);
endmodule