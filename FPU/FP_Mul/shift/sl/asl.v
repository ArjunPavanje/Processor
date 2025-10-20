// always sl by one - 128 bit numbers
module asl (
	input wire [127:0] in,
	output wire [127:0] out
);
	assign out[127:1] = in[126:0];
	assign out[0] = 1'b0;
endmodule