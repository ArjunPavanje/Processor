`timescale 1ns/1ps

module adder_tb;
    // Inputs
    reg [63:0] a;
    reg [63:0] b;
    reg cin;

    // Outputs
    wire [63:0] sum;
    wire cout;

    // Instantiate the adder module
    adder DUT (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // Test procedure
    initial begin
        $display("a\tb\tcin\tsum\tcout");
        $monitor("%h\t%h\t%b\t%h\t%b", a, b, cin, sum, cout);

        // Test 1: Small values
        a = 63'd0; b = 64'd0; cin = 0; #10;

        // Test 2: Simple add
        a = 64'd5; b = 64'd3; cin = 0; #10;

        // Test 3: Include carry
        a = 64'd10; b = 64'd7; cin = 1; #10;

        // Test 4: Large numbers
        a = 64'hFFFFFFFFFFFFFFFF; b = 64'd1; cin = 0; #10;

        // Test 5: Random values
        a = 64'h123456789ABCDEF; b = 64'hFEDCBA987654321; cin = 1; #10;

        // Test 6: Maximum values (all 1s)
        a = {64{1'b1}}; b = {64{1'b1}}; cin = 1; #10;

        $finish;
    end

endmodule
