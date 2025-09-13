`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/01 00:36:48
// Design Name: 
// Module Name: Counter
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


module Counter(
    input clk, rst, btn,
    input [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,
    input [5:0] cursor,
    output reg [3:0] sec0,sec1,min0,min1,hrs0,hrs1
    );
    
    wire [4:0] trig;
    
   
    always @ (posedge clk, posedge rst) begin
        if(rst) sec0 <= 0;
        else if(btn) begin
            if(cursor == 6'b000001) sec0 <= n_sec0;
        end
        else begin 
            if(sec0 == 9) sec0<=0;
            else sec0 <= sec0 + 1;
        end     
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) sec1 <= 0;
        else if(btn) begin
            if(cursor == 6'b000010) sec1 <= n_sec1;
        end
        else if(trig[0]) begin
            if(sec1 == 5) sec1<=0;
            else sec1 <= sec1 + 1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) min0 <= 0;
        else if(btn) begin
            if(cursor == 6'b000100) min0 <= n_min0;
        end
        else if(trig[1]) begin
            if(min0 == 9) min0<=0;
            else min0 <= min0 + 1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) min1 <= 0;
        else if(btn) begin
            if(cursor == 6'b001000) min1 <= n_min1;
        end
        else if(trig[2]) begin
            if(min1 == 5) min1<=0;
            else min1 <= min1 + 1;
        end
    end
    always @ (posedge clk, posedge rst) begin
        if(rst) hrs0 <= 0;
        else if(btn) begin
            if(cursor == 6'b010000) hrs0 <= n_hrs0;
        end
        else if(trig[3]) begin
            if(hrs0 == 9) hrs0<=0;
            else if((hrs0 == 3) && (hrs1 == 2)) hrs0<=0;
            else hrs0 <= hrs0 + 1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) hrs1 <= 0;
        else if(btn) begin
            if(cursor == 6'b100000)  hrs1 <= n_hrs1;
        end
        else if(trig[4]) begin
            if((hrs1 == 2) && (hrs0 == 3)) hrs1 <= 0;
            else if(hrs0 == 9) hrs1 <= hrs1 + 1;
        end
    end
   
    
    assign trig[0] = (sec0 == 9)? 1 : 0;
    assign trig[1] = ((sec1 == 5)&&(trig[0]==1))? 1 : 0;
    assign trig[2] = ((min0 == 9)&&(trig[1]==1))? 1 : 0;
    assign trig[3] = ((min1 == 5)&&(trig[2]==1))? 1 : 0;
    assign trig[4] = (((hrs0 == 9)||(hrs0==3)) && (trig[3]==1))? 1 : 0;

    
endmodule
