module adder_tree #(
    // number of total inputs to single level of tree
    // N can only be powers of 2
    parameter N = 64
) (
    input wire [(128*N - 1):0] in,  // flattened
    output wire [127:0] sum  // 128 bit result
);
  // "sub" sum of N/2 elements passed into next recursion step
  wire [(128*(N/2) - 1):0] subsum;

  genvar i;

  generate
    if (N == 2) begin
      extended_adder adder_128 (
          .a  (in[127:0]),
          .b  (in[255:128]),
          .sum(sum)
      );
    end else begin
      for (i = 0; i < N; i = i + 2) begin
        extended_adder adder_128 (
            .a  (in[(128*(i+1)-1):(128*(i))]),
            .b  (in[(128*(i+2)-1):(128*(i+1))]),
            .sum(subsum[(128*(i+2)/2-1):(128*(i)/2)])
        );
      end

      adder_tree #(
          .N(N / 2)
      ) sub_tree (
          .in (subsum),
          .sum(sum)
      );
    end
  endgenerate
endmodule
