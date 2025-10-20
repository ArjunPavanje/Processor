// always sr by one - 64 bit numbers
module asr (
	input wire [63:0] in,
    input wire sign, // 0 -> unsigned, 1 -> signed numbers
	output wire [63:0] out
);
	assign out[62:] = in[63:1];
	assign out[63] = sign ? in[63] : 1'b0;
endmodule