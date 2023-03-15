`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/15 18:26:49
// Design Name: 
// Module Name: Adder16
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
module Adder32(
    input [31:0] ai,
    input [31:0] bi,
    input ci,
    output [31:0] so,
    output co);
    wire co_lower;
    Adder16 lower(
    .ai     (ai[15:0]),
    .bi     (bi[15:0]),
    .ci     (ci),
    .so     (so[15:0]),
    .co     (co_lower));
    Adder16 higher(
        .ai     (ai[31:16]),
        .bi     (bi[31:16]),
        .ci     (co_lower),
        .so     (so[31:16]),
        .co     (co));
endmodule

module Adder16(
    input [15:0] ai,
    input [15:0] bi,
    input ci,
    output [15:0] so,
    output co
    );
    assign {co,so}= ai+bi+ci;
endmodule
