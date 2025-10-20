`timescale 1ns / 1ps

module tb_shift_modules();
    // Inputs
    reg [63:0] in;
    reg [5:0] amt;
    reg arithmetic;

    // Outputs
    wire [63:0] out_left;
    wire [63:0] out_right;

    // Instantiate the DUTs
    shift_left uut_left (
        .in(in),
        .amt(amt),
        .out(out_left)
    );

    shift_right uut_right (
        .in(in),
        .amt(amt),
        .arithmetic(arithmetic),
        .out(out_right)
    );

    // Task to show results in binary
    task show_results;
        input [63:0] in_val;
        input [5:0] amt_val;
        input arith_val;
        begin
            in = in_val;
            amt = amt_val;
            arithmetic = arith_val;
            #10;
            $display("Shift = %0d | Arithmetic = %b", amt, arithmetic);
            $display("IN  = %064b", in);
            $display("LFT = %064b", out_left);
            $display("RGT = %064b\n", out_right);
        end
    endtask

    initial begin
        $display("Starting combined shift module testbench (binary output)...\n");

        // Basic deterministic tests
        show_results(64'h0000_0000_0000_0001, 6'd0, 1'b0);
        show_results(64'h0000_0000_0000_0001, 6'd1, 1'b0);
        show_results(64'h0000_0000_0000_0001, 6'd4, 1'b0);
        show_results(64'hFFFF_FFFF_FFFF_FFFF, 6'd4, 1'b0);
        show_results(64'h8000_0000_0000_0000, 6'd1, 1'b1);
        show_results(64'hF000_0000_0000_0000, 6'd8, 1'b1);
        show_results(64'h0000_00F0_F0F0_F0F0, 6'd8, 1'b0);

        // Randomized tests
        repeat (5) begin
            in = $urandom;
            amt = $urandom_range(0, 63);
            arithmetic = $random % 2;
            #10;
            $display("Shift = %0d | Arithmetic = %b", amt, arithmetic);
            $display("IN  = %064b", in);
            $display("LFT = %064b", out_left);
            $display("RGT = %064b\n", out_right);
        end

        $display("Testbench completed.\n");
        $finish;
    end

endmodule

