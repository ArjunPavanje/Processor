module sl #(
	parameter N = 0 // number of shifts = 2**N
)(
	input wire [63:0] in,
	input wire en, // enable

	output wire [63:0] out
);
	wire [63:0] out_choice; // if en == 1 then this will be chosen
	assign out_choice[63:(2**N)] = in[(63 - (2**N)):0];
	assign out_choice[((2**N) - 1):0] = {(2**N){1'b0}};
	assign out = en ? out_choice: in;
endmodule