`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 13:25:18
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(
    input clk, rst, btn,b,
    output reg [3:0] sec0,sec1,min0,min1,hrs0,hrs1
    );
    
    reg toggle = 0;
    wire [4:0] trig;
    wire clk_1hz;
    
    clk_divider clk_div_inst1(clk,rst,clk_1hz);
        
    always @ (posedge clk_1hz, posedge rst) begin
        if(rst) sec0 <= 0;
        else if(~toggle & b) begin
            if(sec0 == 9) sec0<=0;
            else sec0 <= sec0 + 1;
            end
    end
    
    always @ (posedge clk_1hz, posedge rst) begin
        if(rst) sec1 <= 0;
        else if(~toggle & b) begin
            if(trig[0]) begin
                if(sec1 == 5) sec1<=0;
                else sec1 <= sec1 + 1;
            end
        end
    end
    
    always @ (posedge clk_1hz, posedge rst) begin
        if(rst) min0 <= 0;
        else if(~toggle & b) begin
            if(trig[1]) begin
                if(min0 == 9) min0<=0;
                else min0 <= min0 + 1;
            end
        end
    end
    
    always @ (posedge clk_1hz, posedge rst) begin
        if(rst) min1 <= 0;
        else if(~toggle & b) begin
            if(trig[1]) begin
                if(min1 == 5) min1<=0;
                else min1 <= min1 + 1;
            end
        end
    end    
    
    always @ (posedge clk_1hz, posedge rst) begin
        if(rst) hrs0 <= 0;
        else if(~toggle & b) begin
            if(trig[1]) begin
                if(hrs0 == 9) hrs0<=0;
                else if((hrs0 == 3) && (hrs1 == 2)) hrs0<=0;
                else hrs0 <= hrs0 + 1;
            end
        end
    end
    
    always @ (posedge clk_1hz, posedge rst) begin
        if(rst) hrs1 <= 0;
        else if(~toggle & b) begin
            if(trig[1]) begin
                if((hrs1 == 2) && (hrs0 == 3)) hrs1 <= 0;
                else if(hrs0 == 9) hrs1 <= hrs1 + 1;
            end
        end
    end
    
    assign trig[0] = (sec0 == 9)? 1 : 0;
    assign trig[1] = ((sec1 == 5)&&(trig[0]==1))? 1 : 0;
    assign trig[2] = ((min0 == 9)&&(trig[1]==1))? 1 : 0;
    assign trig[3] = ((min1 == 5)&&(trig[2]==1))? 1 : 0;
    assign trig[4] = (((hrs0 == 9)||(hrs0==3)) && (trig[3]==1))? 1 : 0;
    
    
    always @ (posedge clk, posedge rst) begin
        if(rst) toggle <= 0;
        else if(btn) toggle <= ~toggle;
    end
    
endmodule
