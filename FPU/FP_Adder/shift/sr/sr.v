module sr (
	input wire [63:0] in,
	input wire en, // enable

	input wire arithmetic, // arithmetic shift or not
	output wire [63:0] out
);
	wire [63:0] out_choice; // if en == 1 then this will be chosen
	assign out_choice[62:0] = in[63:1];
	assign out_choice[63] = arithmetic ? in[63]: 1'b0;
	assign out = en ? out_choice: in;
endmodule