`timescale 1ns / 1ps

module hazard_detection_unit_tb;

  // Testbench signals
  reg [5:0] rs1_IF_ID;
  reg [5:0] rs2_IF_ID;
  reg [5:0] rd_ID_EX;
  reg mem_read_ID_EX;
  reg clk;
  reg rst;
  wire stall;

  // Instantiate the Unit Under Test (UUT)
  hazard_detection_unit uut (
      .rs1_IF_ID(rs1_IF_ID),
      .rs2_IF_ID(rs2_IF_ID),
      .rd_ID_EX(rd_ID_EX),
      .mem_read_ID_EX(mem_read_ID_EX),
      .clk(clk),
      .rst(rst),
      .stall(stall)
  );
  wire curr_state = uut.curr_stage;
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period, 100MHz clock
  end

  // Test stimulus
  initial begin
    // Initialize waveform dump (for viewing in simulation)
    $dumpfile("hazard_detection_unit_tb.vcd");
    $dumpvars(0, hazard_detection_unit_tb);

    // Monitor output
    $monitor("Time=%0t | rst=%b | mem_read=%b | rd=%h | rs1=%h | rs2=%h | stall=%b", $time, rst,
             mem_read_ID_EX, rd_ID_EX, rs1_IF_ID, rs2_IF_ID, stall);

    // Initialize all inputs
    rst = 1;
    mem_read_ID_EX = 0;
    rd_ID_EX = 6'b000000;
    rs1_IF_ID = 6'b000000;
    rs2_IF_ID = 6'b000000;

    // Apply reset
    #20;
    rst = 0;
    #10;

    // ============================================
    // Test Case 1: No hazard (no mem_read)
    // ============================================
    $display("\n=== Test Case 1: No Hazard (mem_read=0) ===");
    mem_read_ID_EX = 0;
    rd_ID_EX = 6'b000001;
    rs1_IF_ID = 6'b000001;
    rs2_IF_ID = 6'b000010;
    #20;  // INSERT YOUR OWN VALUES HERE

    // ============================================
    // Test Case 2: RAW hazard on rs1 with load
    // ============================================
    $display("\n=== Test Case 2: RAW Hazard on rs1 ===");
    mem_read_ID_EX = 1;
    rd_ID_EX = 6'b000101;
    rs1_IF_ID = 6'b000101;  // Matches rd_ID_EX
    rs2_IF_ID = 6'b000010;
    #40;  // INSERT YOUR OWN VALUES HERE

    // ============================================
    // Test Case 3: RAW hazard on rs2 with load
    // ============================================
    $display("\n=== Test Case 3: RAW Hazard on rs2 ===");
    mem_read_ID_EX = 1;
    rd_ID_EX = 6'b001010;
    rs1_IF_ID = 6'b000001;
    rs2_IF_ID = 6'b001010;  // Matches rd_ID_EX
    #40;  // INSERT YOUR OWN VALUES HERE

    // ============================================
    // Test Case 4: RAW hazard on both rs1 and rs2
    // ============================================
    $display("\n=== Test Case 4: RAW Hazard on Both rs1 and rs2 ===");
    mem_read_ID_EX = 1;
    rd_ID_EX = 6'b001111;
    rs1_IF_ID = 6'b001111;  // Matches rd_ID_EX
    rs2_IF_ID = 6'b001111;  // Also matches rd_ID_EX
    #40;  // INSERT YOUR OWN VALUES HERE

    // ============================================
    // Test Case 5: No hazard (different registers)
    // ============================================
    $display("\n=== Test Case 5: No Hazard (Different Registers) ===");
    mem_read_ID_EX = 0;
    rd_ID_EX = 6'b010101;
    rs1_IF_ID = 6'b010101;
    rs2_IF_ID = 6'b000010;
    #20;  // INSERT YOUR OWN VALUES HERE

    // // =================i===========================
    // // Test Case 6: INSERT YOUR OWN TEST CASE
    // // ============================================
    // $display("\n=== Test Case 6: Custom Test ===");
    // mem_read_ID_EX = /* INSERT VALUE */;
    // rd_ID_EX = /* INSERT VALUE */;
    // rs1_IF_ID = /* INSERT VALUE */;
    // rs2_IF_ID = /* INSERT VALUE */;
    // #20;
    //
    // // ============================================
    // // Test Case 7: INSERT YOUR OWN TEST CASE
    // // ============================================
    // $display("\n=== Test Case 7: Custom Test ===");
    // mem_read_ID_EX = /* INSERT VALUE */;
    // rd_ID_EX = /* INSERT VALUE */;
    // rs1_IF_ID = /* INSERT VALUE */;
    // rs2_IF_ID = /* INSERT VALUE */;
    // #20;
    //
    // // ============================================
    // // Test Case 8: INSERT YOUR OWN TEST CASE
    // // ============================================
    // $display("\n=== Test Case 8: Custom Test ===");
    // mem_read_ID_EX = /* INSERT VALUE */;
    // rd_ID_EX = /* INSERT VALUE */;
    // rs1_IF_ID = /* INSERT VALUE */;
    // rs2_IF_ID = /* INSERT VALUE */;
    // #20;
    //
    // // ============================================
    // // Reset test
    // // ============================================
    // $display("\n=== Reset Test ===");
    // rst = 1;
    // #20;
    // rst = 0;
    // #20;
    //
    // End simulation
    $display("\n=== Simulation Complete ===");
    $finish;
  end

endmodule
