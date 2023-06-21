`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 14:09:20
// Design Name: 
// Module Name: single_cycle_cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define STARTADDR 32'd0  // 程序起始地址
module single_cycle_cpu(
    input clk,    // 时钟
    input resetn,  // 复位信号，低电平有效

    //display data
    input  [ 4:0] rf_addr,
    input  [31:0] mem_addr,
    output [31:0] rf_data,
    output [31:0] mem_data,
    output [31:0] cpu_pc,
    output [31:0] cpu_inst,
    output [3:0] control,
    output [31:0] result
    );

//---------------------------------{取指}begin------------------------------------//
    reg  [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] seq_pc;
    wire [31:0] jbr_target;
    wire jbr_taken;

    // 下一指令地址： seq_pc=pc+4
    assign seq_pc[31:2]    = pc[31:2] + 1'b1;
    assign seq_pc[1:0]     = pc[1:0];
    // 新指令：若指令跳转，为跳转地址；否则为下一指令
    assign next_pc = jbr_taken ? jbr_target : seq_pc;
    always @ (posedge clk)    // PC 程序计数器
    begin
        if (!resetn) begin
            pc <= `STARTADDR; // 复位，取程序起始地址
        end
        else begin
            pc <= next_pc;    // 不复位，取新指令
        end
    end

    wire [31:0] inst_addr;
    wire [31:0] inst;
    assign inst_addr = pc;  // 指令地址：指令长度32位
    inst_rom inst_rom_module(         // 指令存储器
        .addr      (inst_addr[6:2]),  // I, 5,指令地址
        .inst      (inst          )   // O, 32,指令
    );
    assign cpu_pc = pc;       //display pc
    assign cpu_inst = inst;
//----------------------------------{取指}end-------------------------------------//

//---------------------------------{译码}begin------------------------------------//
    wire [5:0] op;       
    wire [4:0] rs;       
    wire [4:0] rt;       
    wire [4:0] rd;       
    wire [4:0] sa;      
    wire [5:0] funct;    
    wire [15:0] imm;     
    wire [15:0] offset;  
    wire [25:0] target;  

    assign op     = inst[31:26];  // 操作码
    assign rs     = inst[25:21];  // 源操作数1
    assign rt     = inst[20:16];  // 源操作数2
    assign rd     = inst[15:11];  // 目标操作数
    assign sa     = inst[10:6];   // 特殊域，可能存放偏移量
    assign funct  = inst[5:0];    // 功能码
    assign imm    = inst[15:0];   // 立即数
    assign offset = inst[15:0];   // 地址偏移量
    assign target = inst[25:0];   // 目标地址

    wire op_zero;  // 操作码全0
    wire sa_zero;  // sa域全0
    assign op_zero = ~(|op);
    assign sa_zero = ~(|sa);
    
    // 实现指令列表
    wire inst_ADDU, inst_SUBU , inst_SLT, inst_AND;
    wire inst_NOR , inst_OR   , inst_XOR, inst_SLL;
    wire inst_SRL , inst_ADDIU, inst_BEQ, inst_BNE;
    wire inst_LW  , inst_SW   , inst_LUI, inst_J;
    
    // 扩展指令 分别对应 j 型、 r 型、 i 型
    wire inst_JAL   ,   inst_SRA   ,   inst_SLTIU;

    assign inst_ADDU  = op_zero & sa_zero    & (funct == 6'b100001);// 无符号加法
    assign inst_SUBU  = op_zero & sa_zero    & (funct == 6'b100011);// 无符号减法
    assign inst_SLT   = op_zero & sa_zero    & (funct == 6'b101010);// 小于则置位
    assign inst_AND   = op_zero & sa_zero    & (funct == 6'b100100);// 逻辑与运算
    assign inst_NOR   = op_zero & sa_zero    & (funct == 6'b100111);// 逻辑或非运算
    assign inst_OR    = op_zero & sa_zero    & (funct == 6'b100101);// 逻辑或运算
    assign inst_XOR   = op_zero & sa_zero    & (funct == 6'b100110);// 逻辑异或运算
    assign inst_SLL   = op_zero & (rs==5'd0) & (funct == 6'b000000);// 逻辑左移
    assign inst_SRL   = op_zero & (rs==5'd0) & (funct == 6'b000010);// 逻辑右移
    assign inst_ADDIU = (op == 6'b001001);                  // 立即数无符号加法
    assign inst_BEQ   = (op == 6'b000100);                  // 判断相等跳转
    assign inst_BNE   = (op == 6'b000101);                  // 判断不等跳转
    assign inst_LW    = (op == 6'b100011);                  // 从内存装载
    assign inst_SW    = (op == 6'b101011);                  // 向内存存储
    assign inst_LUI   = (op == 6'b001111);                  // 立即数装载高半字节
    assign inst_J     = (op == 6'b000010);                  // 直接跳转
    
    assign inst_JAL  = (op == 6'b000011);    // jump and link 
    assign inst_SRA = op_zero & (funct == 6'b000011);  //  算术右移
    assign inst_SLTIU = (op == 6'b001011); // 无符号小于立即数置位

    // 无条件跳转判断
    wire        j_taken;
    wire [31:0] j_target;
    assign j_taken  = inst_J;
    // 无条件跳转目标地址：PC={PC[31:28],target<<2}
    assign j_target = {pc[31:28], target, 2'b00};

    // 寄存器堆
    wire rf_wen;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;
    wire [31:0] rs_value, rt_value;


    //分支跳转
    wire        beq_taken;
    wire        bne_taken;
    wire [31:0] br_target;
    assign beq_taken = (rs_value == rt_value);       // BEQ跳转条件：GPR[rs]=GPR[rt]
    assign bne_taken = ~beq_taken;                   // BNE跳转条件：GPR[rs]≠GPR[rt]
    assign br_target[31:2] = pc[31:2] + {{14{offset[15]}}, offset};
    assign br_target[1:0]  = pc[1:0];    // 分支跳转目标地址：PC=PC+offset<<2


    regfile rf_module(
        .clk    (clk      ),  // I, 1
        .wen    (rf_wen   ),  // I, 1
        .raddr1 (rs       ),  // I, 5
        .raddr2 (rt       ),  // I, 5
        .waddr  (rf_waddr ),  // I, 5
        .wdata  (rf_wdata ),  // I, 32
        .rdata1 (rs_value ),  // O, 32
        .rdata2 (rt_value ),   // O, 32

        //display rf
        .test_addr(rf_addr),
        .test_data(rf_data)
    );
    
    
    // 传递到执行模块的 ALU 源操作数和操作码
    wire inst_add, inst_sub, inst_slt,inst_sltu;
    wire inst_and, inst_nor, inst_or, inst_xor;
    wire inst_sll, inst_srl, inst_sra,inst_lui;
    wire inst_jal, inst_sltiu , inst_beq;
    assign inst_add = inst_ADDU | inst_ADDIU | inst_LW | inst_SW; // 做加法运算指令
    assign inst_sub = inst_SUBU; // 减法
    assign inst_slt = inst_SLT;  // 小于置位
    assign inst_sltu= 1'b0;      // 暂未实现
    assign inst_and = inst_AND;  // 逻辑与
    assign inst_nor = inst_NOR;  // 逻辑或非
    assign inst_or  = inst_OR;   // 逻辑或
    assign inst_xor = inst_XOR;  // 逻辑异或
    assign inst_sll = inst_SLL;  // 逻辑左移
    assign inst_srl = inst_SRL;  // 逻辑右移
    assign inst_sra = inst_SRA;  // 算数右移
    assign inst_lui = inst_LUI;  // 立即数装载高位
    assign inst_jal = inst_JAL; // jump and link
    assign inst_sltiu = inst_SLTIU; // 无符号小于立即数置位
    assign inst_beq = 1'b0;

    wire [31:0] sext_imm;
    wire   inst_shf_sa;    //使用sa域作为偏移量的指令
    wire   inst_imm_sign;  //对立即数作符号扩展的指令
    assign sext_imm      = {{16{imm[15]}}, imm};// 立即数符号扩展
    assign inst_shf_sa   = inst_SLL | inst_SRL | inst_SRA;
    assign inst_imm_sign = inst_ADDIU | inst_LUI | inst_LW | inst_SW | inst_SLTIU;
    
    wire [31:0] alu_operand1;
    wire [31:0] alu_operand2;
    wire [3:0] alu_control;
    assign alu_operand1 = inst_shf_sa ? {27'd0,sa} : rs_value;
    assign alu_operand2 = inst_imm_sign ? sext_imm : rt_value;
    assign alu_control = inst_add ? 4'd1 : 
    inst_sub?  4'd2 :
    inst_slt?  4'd3 :
    inst_sltu? 4'd4 :
    inst_and?  4'd5 :
    inst_nor?  4'd6 :
    inst_or?   4'd7 :
    inst_xor?  4'd8 :
    inst_sll?  4'd9 :
    inst_srl?  4'd10:
    inst_sra?  4'd11:
    inst_lui?  4'd12:
    inst_jal?  4'd13:
    inst_sltiu?4'd14:
    inst_beq?  4'd15 : 0;
    
//----------------------------------{译码}end-------------------------------------//

//---------------------------------{执行}begin------------------------------------//
    wire [31:0] alu_result;

    alu alu_module(
        .alu_control  (alu_control ),  // I, 4, ALU控制信号
        .alu_src1     (alu_operand1),  // I, 32, ALU操作数1
        .alu_src2     (alu_operand2),  // I, 32, ALU操作数2
        .alu_result   (alu_result  )   // O, 32, ALU结果
    );
//----------------------------------{执行}end-------------------------------------//
    
 //跳转指令的跳转信号和跳转目标地址
assign jbr_taken = j_taken              // 指令跳转：无条件跳转 或 满足分支跳转条件
                 | inst_BEQ & beq_taken
                 | inst_BNE & bne_taken
                 | inst_JAL ;
assign jbr_target = j_taken ? j_target : inst_JAL ? {pc[31:28],alu_result[27:0]} : br_target;
    
//---------------------------------{访存}begin------------------------------------//
    wire [3 :0] dm_wen;
    wire [31:0] dm_addr;
    wire [31:0] dm_wdata;
    wire [31:0] dm_rdata;
    assign dm_wen   = {4{inst_SW}} & resetn;    // 内存写使能,非resetn状态下有效
    assign dm_addr  = alu_result;               // 内存写地址，为ALU结果
    assign dm_wdata = rt_value;                 // 内存写数据，为rt寄存器值
    data_ram data_ram_module(
        .clk   (clk         ),  // I, 1,  时钟
        .wen   (dm_wen      ),  // I, 1,  写使能
        .addr  (dm_addr[6:2]),  // I, 32, 读地址
        .wdata (dm_wdata    ),  // I, 32, 写数据
        .rdata (dm_rdata    ),  // O, 32, 读数据

        //display mem
        .test_addr(mem_addr[6:2]),
        .test_data(mem_data     )
    );
//----------------------------------{访存}end-------------------------------------//
    assign control = alu_control;
    assign result = alu_result;

//---------------------------------{写回}begin------------------------------------//
    wire inst_wdest_rt;   // 寄存器堆写入地址为rt的指令
    wire inst_wdest_rd;   // 寄存器堆写入地址为rd的指令
    assign inst_wdest_rt = inst_ADDIU | inst_LW | inst_LUI | inst_SLTIU;
    assign inst_wdest_rd = inst_ADDU | inst_SUBU | inst_SLT | inst_AND | inst_NOR
                          | inst_OR   | inst_XOR  | inst_SLL | inst_SRL | inst_SRA;                   
    // 寄存器堆写使能信号，非复位状态下有效
    assign rf_wen   = (inst_wdest_rt | inst_wdest_rd | inst_jal) & resetn;
    assign rf_waddr = inst_wdest_rd ? rd : inst_jal? 5'd31 :rt;        // 寄存器堆写地址 rd 、 rt 或 ra
    assign rf_wdata = inst_LW ? dm_rdata : inst_jal? seq_pc : alu_result;// 写回结果可能为 load 结果、 ALU 结果以及当前 pc 下一条指令地址
//----------------------------------{写回}end-------------------------------------//
endmodule
