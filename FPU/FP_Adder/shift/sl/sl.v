module sl (
	input wire [63:0] in,
	input wire en, // enable

	output wire [63:0] out
);
	wire [63:0] out_choice; // if en == 1 then this will be chosen
	assign out_choice[63:1] = in[62:0];
	assign out_choice[0] = 1'b0;
	assign out = en ? out_choice: in;
endmodule

// TODO
/* extended_sl -> 128 bit shift left
*/

/*
module extended_sl (
	input wire [127:0] in,
	output wire [127:0] out
);
	assign out[127:1] = in[126:0];
	assign out[0] = 1'b0;
endmodule
*/