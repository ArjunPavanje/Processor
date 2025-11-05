module hdu (
    // input  [128:0] ID_EX,
    // input  [128:0] EX_MEM,
    // input  [128:0] MEM_WB,
    input reg_write_EX_MEM,
    input reg_write_MEM_WB,
    input rs1_ID_EX,
    input [5:0] rs1_ID_EX,
    input [5:0] rs2_ID_EX,
    input [5:0] rsd_EX_MEM,
    input [5:0] rsd_MEM_WB,
    input [31:0] instr_IF_ID,
    input [31:0] instr_ID_EX,

    output [1:0] forward_A,
    output [1:0] forward_B,
    output jump
);
  // Temproary, will change
  // wire [31:0] instr_ID_EX = ID_EX[31:0];
  // wire reg_write_EX_MEM = EX_MEM[32];
  // wire reg_write_MEM_WB = MEM_WB[32];
  //
  // wire [4:0] rsd_EX_MEM = EX_MEM[11:7];
  // wire [4:0] rsd_MEM_WB = MEM_WB[11:7];
  // wire [4:0] rs1_ID_EX = ID_EX[19:15];
  // wire [4:0] rs2_ID_EX = ID_EX[24:20];


  // Checking write enabled
  wire write_enabled_EX_MEM = reg_write_EX_MEM;
  wire write_enabled_MEM_WB = reg_write_MEM_WB;

  // Checking for write to x0
  wire write_to_x0_EX_MEM = rsd_EX_MEM == 5'd0;
  wire write_to_x0_MEM_WB = rsd_MEM_WB == 5'd0;

  // Checking if register values match that of rd of EX_MEM
  wire reg_eq_EX_MEM_A = rsd_EX_MEM == rs1_ID_EX;
  wire reg_eq_EX_MEM_B = rsd_EX_MEM == rs2_ID_EX;

  // Checking if register values match that of rd of MEM_WB
  wire reg_eq_MEM_WB_A = (rsd_MEM_WB == rs1_ID_EX);
  wire reg_eq_MEM_WB_B = (rsd_MEM_WB == rs2_ID_EX);

  // Checking if forward from EX_MEM/MEM_WB is valid (write enabled & non x0 write)
  wire forward_EX_MEM_valid = write_enabled_EX_MEM & (~write_to_x0_EX_MEM);
  wire forward_MEM_WB_valid = write_enabled_MEM_WB & (~write_to_x0_MEM_WB) & (~(reg_write_EX_MEM & write_enabled_EX_MEM));

  // Forward A

  // forward from EX_MEM
  write from_EX_MEM_A = forward_EX_MEM_valid & reg_eq_EX_MEM_A;
  // forward from MEM_WB
  write from_MEM_WB_A = forward_MEM_WB_valid & reg_eq_MEM_WB_A;

  // forward_A =
  // 10 -> from EX/MEM
  // 01 -> from MEM/WB
  // 00 -> Neither
  assign forward_A = (from_EX_MEM_A) ? (2'b10) : ((from_MEM_WB_A) ? (2'b01) : 2'd0);

  // Forward B

  // forward from EX_MEM
  write from_EX_MEM_B = forward_EX_MEM_valid & reg_eq_EX_MEM_B;
  // forward from MEM_WB
  write from_MEM_WB_B = forward_MEM_WB_valid & reg_eq_MEM_WB_B;

  // forward_B =
  // 10 -> from EX/MEM
  // 01 -> from MEM/WB
  // 00 -> Neither
  assign forward_B = (from_EX_MEM_B) ? (2'b10) : ((from_MEM_WB_B) ? (2'b01) : 2'd0);


  // Analyzing instruction
  wire [6:0] opcode_ID_EX = instr_ID_EX[6:0];
  wire [4:0] rd = instr_ID_EX[11:7];
  wire is_riuj = (opcode_ID_EX == 7'b0110011 | opcode_ID_EX == 7'b0010011 | opcode_ID_EX == 7'b0110111 | opcode_ID_EX == 7'b1101111 | opcode_ID_EX== 7'b1100111 | opcode_ID_EX == 7'b1110011);  // R, I, U, J type

  //~(opcode_ID_EX == 7'b0100011 | opcode_ID_EX == 7'b1100011);  // Not S or B type
  //(opcode_ID_EX == 7'b0110011 | opcode_ID_EX == 7'b0010011 | opcode_ID_EX == 7'b0110111 | opcode_ID_EX == 7'b1101111 | opcode_ID_EX== 7'b1100111 | opcode_ID_EX == 7'b1110011);  // R, I, U, J type

  wire [6:0] opcode_IF_ID = instr_IF_ID[6:0];
  wire [2:0] funct3 = instr_IF_ID[14:12];
  wire [4:0] rs1 = instr_IF_ID[19:15];

  wire is_jalr = (opcode_IF_ID == 7'b1100111 & funct3 == 3'b000) ? (1'b1) : (1'b0);

  wire reg_eq = rs1 == rd;

  assign jump = (is_jalr & is_riuj & reg_eq);
  // assign jump = (is_jalr & reg_eq_jalr) | (is_jal & reg_eq_jal);


  // wire [1:0] forward_A_EX_MEM = (reg_write_EX_MEM)?((rsd_EX_MEM != 5'd0):((rsd_EX_MEM == rs1_ID_EX)?2'b10:2'd0):2'd0):2'd0;
  // wire [1:0] forward_B_EX_MEM = (reg_write_EX_MEM)?((rsd_EX_MEM != 5'd0):((rsd_EX_MEM == rs2_ID_EX)?2'b10:2'd0):2'd0):2'd0;
  //
  // assign forward_A = (reg_write_MEM_WB)?((rsd_MEM_WB != 5'd0)?((~(reg_write_EX_MEM & rsd_EX_MEM !=5'd0))?((rsd_MEM_WB == rs1_ID_EX)?2'b10:forward_A_EX_MEM):forward_A_EX_MEM ):forward_A_EX_MEM):forward_A_EX_MEM;
  // assign forward_B = (reg_write_MEM_WB)?((rsd_MEM_WB != 5'd0)?((~(reg_write_EX_MEM & rsd_EX_MEM !=5'd0))?((rsd_MEM_WB == rs2_ID_EX)?2'b10:forward_A_EX_MEM):forward_A_EX_MEM ):forward_A_EX_MEM):forward_A_EX_MEM;
endmodule
