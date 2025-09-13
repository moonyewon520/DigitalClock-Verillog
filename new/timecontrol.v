`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/01 23:59:50
// Design Name: 
// Module Name: timecontrol
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


module timecontrol(
    input left, right, up, down,
    input clk, rst, btn,
    input [3:0] sec0,sec1,min0,min1,hrs0,hrs1,
    output reg [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,
    output reg [5:0] cursor,
    output [5:0] cursor_blink
    );    
    
    wire clk_1hz;
    
    clk_divider clk_div_inst1(clk,rst,clk_1hz);
    
    always @ (posedge clk, posedge rst) begin
        if(rst) begin n_sec0 <= 0;
                n_sec1 <= 0;
                n_min0 <= 0;
                n_min1 <= 0;
                n_hrs0 <= 0;
                n_hrs1 <= 0;end
        else if(btn) begin
            if(cursor == 6'b000001) begin
                if(up) begin
                    if(sec0 == 9) n_sec0 <= 0;
                    else n_sec0 <= sec0 + 1;
                end
                else if(down) begin
                    if(sec0 == 0) n_sec0 <= 9;
                    else n_sec0 <= sec0 - 1;
               end
            end
            else if(cursor == 6'b000010) begin
                if(up) begin
                    if(sec1 == 5) n_sec1<=0;
                    else n_sec1 <= sec1 + 1;
                end
                else if(down) begin
                    if(sec1 == 0) n_sec1 <= 5;
                    else n_sec1 <= sec1 - 1;
               end
           end
           else if(cursor == 6'b000100) begin
                if(up) begin
                    if(min0== 9) n_min0<=0;
                    else n_min0 <= min0 + 1;
                end
                else if(down) begin
                    if(min0 == 0) n_min0 <= 9;
                    else n_min0 <= min0 - 1;
               end
           end
           else if(cursor == 6'b001000) begin
                if(up) begin
                    if(min1== 5) n_min1<=0;
                    else n_min1<= min1 + 1;
                end
                else if(down) begin
                    if(min1 == 0) n_min1 <= 5;
                    else n_min1 <= min1 - 1;
               end
            end
            else if(cursor == 6'b010000) begin
                if(up) begin
                    if(hrs0 == 9) n_hrs0 <= 0;
                    else n_hrs0 <= hrs0 + 1;
                end
                else if(down) begin
                    if(hrs0 == 0) n_hrs0 <= 9;
                    else n_hrs0 <= hrs0 - 1;
               end
            end
            else if(cursor == 6'b100000) begin
                if(up) begin
                    if(hrs1== 2) n_hrs1 <= 0;
                    else n_hrs1 <= hrs1 + 1;
                end
                else if(down) begin
                    if(hrs1 == 0) n_hrs1 <= 2;
                    else n_hrs1 <= hrs1 - 1;
               end
           end
           else begin n_sec0 <= sec0; 
                n_sec1 <= sec1;
                n_min0 <= min0;
                n_min1 <= min1;
                n_hrs0 <= hrs0;
                n_hrs1 <= hrs1; end
        end
        else begin n_sec0 <= sec0; 
                n_sec1 <= sec1;
                n_min0 <= min0;
                n_min1 <= min1;
                n_hrs0 <= hrs0;
                n_hrs1 <= hrs1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) cursor <= 6'b100000;
        else if(btn) begin
            if (left) cursor <= {cursor[4:0], cursor[5]};
            else if (right) cursor <= {cursor[0], cursor[5:1]};
        end
    end
    
    assign cursor_blink = cursor & {6{clk_1hz}};
    
    
endmodule
