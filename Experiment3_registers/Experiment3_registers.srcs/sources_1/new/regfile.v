`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: regfile.v
//   > ����  ���Ĵ�����ģ�飬ͬ��д���첽��
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module regfile(
    input             clk,
    // �Ķ�
    input       [3:0]    wen,
    input       [1:0]    ren,
    input      [4 :0] raddr1,
    input      [4 :0] raddr2,
    input      [4 :0] waddr,
    input      [31:0] wdata,
    output reg [31:0] rdata1,
    output reg [31:0] rdata2,
    input      [4 :0] test_addr,
    output reg [31:0] test_data
    );
    reg [31:0] rf[31:0];
     
    // three ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 0 hardwired to 0

// �Ķ�
    always @(posedge clk)
    begin
         case (wen)
               4'd1 : rf[waddr]  <= {24'b0,wdata[7:0]};
               4'd2 : rf[waddr]  <= {16'b0,wdata[15:8],8'b0};
               4'd3 : rf[waddr]  <= {16'b0,wdata[15:0]};
               4'd4 : rf[waddr]  <= {8'b0,wdata[23:16],8'b0};
               4'd5 : rf[waddr]  <= {8'b0,wdata[23:16],8'b0,wdata[7:0]};
               4'd6 : rf[waddr]  <= {8'b0,wdata[23:8],8'b0};
               4'd7 : rf[waddr]  <= {8'b0,wdata[23:0]};
               4'd8 : rf[waddr]  <= {wdata[31:24],24'b0};
               4'd9 : rf[waddr]  <= {wdata[31:24],16'b0,wdata[7:0]};
               4'd10: rf[waddr]  <= {wdata[31:24],8'b0,wdata[15:8],8'b0};
               4'd11: rf[waddr]  <= {wdata[31:24],8'b0,wdata[15:0]};
               4'd12: rf[waddr]  <= {wdata[31:16],16'b0};
               4'd13: rf[waddr]  <= {wdata[31:16],8'b0,wdata[7:0]};
               4'd14: rf[waddr]  <= {wdata[31:8],8'b0};
               4'd15: rf[waddr]  <= wdata;
               default: rf[waddr] <= 32'b0;
               endcase
    end
     
    //���˿�1
    always @(*)
    begin
    if(ren[1])
        case (raddr1)
            5'd1 : rdata1 <= rf[1 ];
            5'd2 : rdata1 <= rf[2 ];
            5'd3 : rdata1 <= rf[3 ];
            5'd4 : rdata1 <= rf[4 ];
            5'd5 : rdata1 <= rf[5 ];
            5'd6 : rdata1 <= rf[6 ];
            5'd7 : rdata1 <= rf[7 ];
            5'd8 : rdata1 <= rf[8 ];
            5'd9 : rdata1 <= rf[9 ];
            5'd10: rdata1 <= rf[10];
            5'd11: rdata1 <= rf[11];
            5'd12: rdata1 <= rf[12];
            5'd13: rdata1 <= rf[13];
            5'd14: rdata1 <= rf[14];
            5'd15: rdata1 <= rf[15];
            5'd16: rdata1 <= rf[16];
            5'd17: rdata1 <= rf[17];
            5'd18: rdata1 <= rf[18];
            5'd19: rdata1 <= rf[19];
            5'd20: rdata1 <= rf[20];
            5'd21: rdata1 <= rf[21];
            5'd22: rdata1 <= rf[22];
            5'd23: rdata1 <= rf[23];
            5'd24: rdata1 <= rf[24];
            5'd25: rdata1 <= rf[25];
            5'd26: rdata1 <= rf[26];
            5'd27: rdata1 <= rf[27];
            5'd28: rdata1 <= rf[28];
            5'd29: rdata1 <= rf[29];
            5'd30: rdata1 <= rf[30];
            5'd31: rdata1 <= rf[31];
            default : rdata1 <= 32'd0;
        endcase
    else
         case (raddr1)
                5'd1 : rdata1 <={16'd0, rf[1 ][15:0]};
                5'd2 : rdata1 <= {16'd0,rf[2 ][15:0]};
                5'd3 : rdata1 <= {16'd0,rf[3 ][15:0]};
                5'd4 : rdata1 <= {16'd0,rf[4 ][15:0]};
                5'd5 : rdata1 <= {16'd0,rf[5 ][15:0]};
                5'd6 : rdata1 <= {16'd0,rf[6 ][15:0]};
                5'd7 : rdata1 <= {16'd0,rf[7 ][15:0]};
                5'd8 : rdata1 <= {16'd0,rf[8 ][15:0]};
                5'd9 : rdata1 <= {16'd0,rf[9 ][15:0]};
                5'd10: rdata1 <= {16'd0,rf[10][15:0]};
                5'd11: rdata1 <= {16'd0,rf[11][15:0]};
                5'd12: rdata1 <= {16'd0,rf[12][15:0]};
                5'd13: rdata1 <= {16'd0,rf[13][15:0]};
                5'd14: rdata1 <= {16'd0,rf[14][15:0]};
                5'd15: rdata1 <= {16'd0,rf[15][15:0]};
                5'd16: rdata1 <= {16'd0,rf[16][15:0]};
                5'd17: rdata1 <= {16'd0,rf[17][15:0]};
                5'd18: rdata1 <= {16'd0,rf[18][15:0]};
                5'd19: rdata1 <= {16'd0,rf[19][15:0]};
                5'd20: rdata1 <= {16'd0,rf[20][15:0]};
                5'd21: rdata1 <= {16'd0,rf[21][15:0]};
                5'd22: rdata1 <= {16'd0,rf[22][15:0]};
                5'd23: rdata1 <= {16'd0,rf[23][15:0]};
                5'd24: rdata1 <= {16'd0,rf[24][15:0]};
                5'd25: rdata1 <= {16'd0,rf[25][15:0]};
                5'd26: rdata1 <= {16'd0,rf[26][15:0]};
                5'd27: rdata1 <= {16'd0,rf[27][15:0]};
                5'd28: rdata1 <= {16'd0,rf[28][15:0]};
                5'd29: rdata1 <= {16'd0,rf[29][15:0]};
                5'd30: rdata1 <= {16'd0,rf[30][15:0]};
                5'd31: rdata1 <= {16'd0,rf[31][15:0]};
                default : rdata1 <= 32'd0;
        endcase
    end
    //���˿�2
    always @(*)
    begin
    if(ren[0])
        case (raddr2)
            5'd1 : rdata2 <= rf[1 ];
            5'd2 : rdata2 <= rf[2 ];
            5'd3 : rdata2 <= rf[3 ];
            5'd4 : rdata2 <= rf[4 ];
            5'd5 : rdata2 <= rf[5 ];
            5'd6 : rdata2 <= rf[6 ];
            5'd7 : rdata2 <= rf[7 ];
            5'd8 : rdata2 <= rf[8 ];
            5'd9 : rdata2 <= rf[9 ];
            5'd10: rdata2 <= rf[10];
            5'd11: rdata2 <= rf[11];
            5'd12: rdata2 <= rf[12];
            5'd13: rdata2 <= rf[13];
            5'd14: rdata2 <= rf[14];
            5'd15: rdata2 <= rf[15];
            5'd16: rdata2 <= rf[16];
            5'd17: rdata2 <= rf[17];
            5'd18: rdata2 <= rf[18];
            5'd19: rdata2 <= rf[19];
            5'd20: rdata2 <= rf[20];
            5'd21: rdata2 <= rf[21];
            5'd22: rdata2 <= rf[22];
            5'd23: rdata2 <= rf[23];
            5'd24: rdata2 <= rf[24];
            5'd25: rdata2 <= rf[25];
            5'd26: rdata2 <= rf[26];
            5'd27: rdata2 <= rf[27];
            5'd28: rdata2 <= rf[28];
            5'd29: rdata2 <= rf[29];
            5'd30: rdata2 <= rf[30];
            5'd31: rdata2 <= rf[31];
            default : rdata2 <= 32'd0;
        endcase
    else
         case (raddr2)
                5'd1 : rdata2 <={16'd0, rf[1 ][15:0]};
                5'd2 : rdata2 <= {16'd0,rf[2 ][15:0]};
                5'd3 : rdata2 <= {16'd0,rf[3 ][15:0]};
                5'd4 : rdata2 <= {16'd0,rf[4 ][15:0]};
                5'd5 : rdata2 <= {16'd0,rf[5 ][15:0]};
                5'd6 : rdata2 <= {16'd0,rf[6 ][15:0]};
                5'd7 : rdata2 <= {16'd0,rf[7 ][15:0]};
                5'd8 : rdata2 <= {16'd0,rf[8 ][15:0]};
                5'd9 : rdata2 <= {16'd0,rf[9 ][15:0]};
                5'd10: rdata2 <= {16'd0,rf[10][15:0]};
                5'd11: rdata2 <= {16'd0,rf[11][15:0]};
                5'd12: rdata2 <= {16'd0,rf[12][15:0]};
                5'd13: rdata2 <= {16'd0,rf[13][15:0]};
                5'd14: rdata2 <= {16'd0,rf[14][15:0]};
                5'd15: rdata2 <= {16'd0,rf[15][15:0]};
                5'd16: rdata2 <= {16'd0,rf[16][15:0]};
                5'd17: rdata2 <= {16'd0,rf[17][15:0]};
                5'd18: rdata2 <= {16'd0,rf[18][15:0]};
                5'd19: rdata2 <= {16'd0,rf[19][15:0]};
                5'd20: rdata2 <= {16'd0,rf[20][15:0]};
                5'd21: rdata2 <= {16'd0,rf[21][15:0]};
                5'd22: rdata2 <= {16'd0,rf[22][15:0]};
                5'd23: rdata2 <= {16'd0,rf[23][15:0]};
                5'd24: rdata2 <= {16'd0,rf[24][15:0]};
                5'd25: rdata2 <= {16'd0,rf[25][15:0]};
                5'd26: rdata2 <= {16'd0,rf[26][15:0]};
                5'd27: rdata2 <= {16'd0,rf[27][15:0]};
                5'd28: rdata2 <= {16'd0,rf[28][15:0]};
                5'd29: rdata2 <= {16'd0,rf[29][15:0]};
                5'd30: rdata2 <= {16'd0,rf[30][15:0]};
                5'd31: rdata2 <= {16'd0,rf[31][15:0]};
                default : rdata2 <= 32'd0;
        endcase
    end
     //���Զ˿ڣ������Ĵ���ֵ��ʾ�ڴ�������
    always @(*)
    begin
        case (test_addr)
            5'd1 : test_data <= rf[1 ];
            5'd2 : test_data <= rf[2 ];
            5'd3 : test_data <= rf[3 ];
            5'd4 : test_data <= rf[4 ];
            5'd5 : test_data <= rf[5 ];
            5'd6 : test_data <= rf[6 ];
            5'd7 : test_data <= rf[7 ];
            5'd8 : test_data <= rf[8 ];
            5'd9 : test_data <= rf[9 ];
            5'd10: test_data <= rf[10];
            5'd11: test_data <= rf[11];
            5'd12: test_data <= rf[12];
            5'd13: test_data <= rf[13];
            5'd14: test_data <= rf[14];
            5'd15: test_data <= rf[15];
            5'd16: test_data <= rf[16];
            5'd17: test_data <= rf[17];
            5'd18: test_data <= rf[18];
            5'd19: test_data <= rf[19];
            5'd20: test_data <= rf[20];
            5'd21: test_data <= rf[21];
            5'd22: test_data <= rf[22];
            5'd23: test_data <= rf[23];
            5'd24: test_data <= rf[24];
            5'd25: test_data <= rf[25];
            5'd26: test_data <= rf[26];
            5'd27: test_data <= rf[27];
            5'd28: test_data <= rf[28];
            5'd29: test_data <= rf[29];
            5'd30: test_data <= rf[30];
            5'd31: test_data <= rf[31];
            default : test_data <= 32'd0;
        endcase
    end
endmodule
