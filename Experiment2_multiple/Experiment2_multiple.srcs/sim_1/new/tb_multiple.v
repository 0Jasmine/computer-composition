`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/27 14:38:11
// Design Name: 
// Module Name: tb_multiple
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


module tb_multiple();
    // Inputs
    reg clk;
    reg mult_begin;
    reg [31:0] mult_op1;
    reg [31:0] mult_op2;

    // Outputs
    wire [63:0] product;
    wire mult_end;

    // Instantiate the Unit Under Test (UUT)
    multiply uut (
        .clk(clk), 
        .mult_begin(mult_begin), 
        .mult_op1(mult_op1), 
        .mult_op2(mult_op2), 
        .product(product), 
        .mult_end(mult_end)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        mult_begin = 0;
        mult_op1 = 0;
        mult_op2 = 0;

        // Wait 100 ns for global reset to finish
        #100;
        mult_begin = 1;
        mult_op1 = 32'H00000021;
        mult_op2 = 32'H80000001;
        #400;
        mult_begin = 0;
        #500;
        mult_begin = 1;
        mult_op1 = 32'HFFFFFFFF;
        mult_op2 = 32'H11111111;
        #400;
        mult_begin = 0;
        #500;
        mult_begin = 1;
        mult_op1 = 32'H00000021;
        mult_op2 = 32'H80000001;
        #400;
        mult_begin = 0;
        #500;
        mult_begin = 1;
        mult_op1 = 32'H00000000;
        mult_op2 = 32'H80000001;
        #400;
        mult_begin = 0;
        // Add stimulus here
    end
   always #5 clk = ~clk;
endmodule

