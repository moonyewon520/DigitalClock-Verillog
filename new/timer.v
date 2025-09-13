`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 02:42:15
// Design Name: 
// Module Name: timer
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


module timer(
    input clk,rst,en,btn,
    input [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,
    input [5:0] cursor,
    output blink,
    output reg [3:0] t_sec0,t_sec1,t_min0,t_min1,t_hrs0,t_hrs1
    );
    
    wire [4:0] m_trig;
    wire clk_1hz;
    
    clk_divider clk_div_inst1(clk,rst,clk_1hz);
    
    always @ (posedge clk, posedge rst) begin
        if(rst) t_sec0 <= 0;
        else if(btn && en) begin
            if(cursor == 6'b000001) t_sec0 <= n_sec0;
        end
        else if(~btn && en) begin
            if(blink) t_sec0 <= 0;
            else if(t_sec0 == 0) t_sec0 <= 9;
            else t_sec0 <= t_sec0 - 1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) t_sec1 <= 0;
        else if(btn && cursor == 6'b000010) t_sec1 <= n_sec1;
        else if(~btn && m_trig[0]) begin
            if(blink) t_sec1 <= 0;
            else if(t_sec1 == 0) t_sec1 <= 5;
            else t_sec1 <= t_sec1 - 1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) t_min0 <= 0;
        else if(btn && cursor == 6'b000100) t_min0 <= n_min0;
        else if(~btn && m_trig[1]) begin
            if(blink) t_min0 <= 0;
            else if(t_min0 == 0) t_min0 <= 9;
            else t_min0 <= t_min0 - 1; 
       end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) t_min1 <= 0;
        else if(btn && cursor == 6'b001000) t_min1 <= n_min1;
        else if(~btn && m_trig[2]) begin
            if(blink) t_min1 <= 0;
            else if(t_min1 == 0) t_min1 <= 5;
            else t_min1 <= t_min1 - 1;
          
       end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) t_hrs0 <= 0;
        else if(btn && cursor == 6'b010000) t_hrs0 <= n_hrs0;
        else if(~btn && m_trig[3]) begin
            if(blink) t_hrs0 <= 0;
            else if(t_hrs0 == 0) t_hrs0 <= 9;
            else t_hrs0 <= t_hrs0 - 1;
       end
    end
    
    always @ (posedge clk, posedge rst) begin
        if(rst) t_hrs1 <= 0;
        else if(btn && cursor == 6'b100000) t_hrs1 <= n_hrs1;
        else if(~btn && m_trig[4]) begin
            if(blink) t_hrs1 <= 0;
            else if(t_hrs1 == 0) t_hrs1 <= 9;
            else t_hrs1 <= t_hrs1 - 1;
       end
    end
    
        
    assign m_trig[0] = (t_sec0 == 0)? 1 : 0;
    assign m_trig[1] = ((t_sec1 == 0)&&(m_trig[0]==1))? 1 : 0;
    assign m_trig[2] = ((t_min0 == 0)&&(m_trig[1]==1))? 1 : 0;
    assign m_trig[3] = ((t_min1 == 0)&&(m_trig[2]==1))? 1 : 0;
    assign m_trig[4] = ((t_hrs0 == 0)&&(m_trig[3]==1))? 1 : 0;
    
    assign blink = ((m_trig[4] == 1) && (t_hrs1 == 0))? 1 : 0;
    
    
   
endmodule
