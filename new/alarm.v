`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/14 14:27:41
// Design Name: 
// Module Name: alarm
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


module alarm(
    input clk, rst, btn,c,
    input [5:0] cursor,
    input [3:0] n_min0,n_min1,n_hrs0,n_hrs1,
    input [3:0] min0,min1,hrs0,hrs1,
    output reg [3:0] c_min0,c_min1,c_hrs0,c_hrs1,
    output alert
    );
    
    
    reg [3:0] same;
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin // 특정한 숫자를 정한 후에 알람이 울릴 수 있게 없는 시간 넣어놓기
            c_min0 <= 0;
            c_min1 <= 0;
            c_hrs0 <= 0;
            c_hrs1 <= 0;
        end
        else if(btn&c) begin
            case(cursor)
            6'b000100 : c_min0 <= n_min0;
            6'b001000 : c_min1 <= n_min1;
            6'b010000 : c_hrs0 <= n_hrs0;
            6'b100000 : c_hrs1 <= n_hrs1;
            endcase
        end
            
    end
    
    always @ (*) begin
        if(c) begin
            same[0] = (c_min0 == min0)? 1 : 0;
            same[1] = (c_min1 == min1)? 1 : 0;
            same[2] = (c_hrs0 == hrs0)? 1 : 0;
            same[3] = (c_hrs1 == hrs1)? 1 : 0;
        end
        else begin 
            same[0] = 0;
            same[1] = 0;
            same[2] = 0;
            same[3] = 0;
        end
    end
    
    assign alert = (same == 4'b1111)? 1 : 0;
    
endmodule
