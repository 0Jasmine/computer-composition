`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/15 18:46:32
// Design Name: 
// Module Name: tb_adder32
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


module tb_adder32;
// Inputs
reg [31:0] operand1;
reg [31:0] operand2;
reg cin;

// Outputs
wire [31:0] result;
wire cout;
// Instantiate the Unit Under Test (UUT)
Adder32 sum (
    .ai     (operand1), 
    .bi     (operand2), 
    .ci     (cin), 
    .so     (result), 
    .co     (cout)
);
initial begin
    // Initialize Inputs
    operand1 = 0;
    operand2 = 0;
    cin = 0;
    // Wait 100 ns for global reset to finish
    #100;
    // Add stimulus here
end
always #10 operand1 = $random;  //$randomΪϵͳ���񣬲���һ�������32λ��
always #10 operand2 = $random;  //#10 ��ʾ�ȴ�10����λʱ��(10ns)����ÿ��10ns����ֵһ�������32λ��
always #10 cin = {$random} % 2; //����ƴ�ӷ���{$random}����һ���Ǹ�������2ȡ��õ�0��1
endmodule
