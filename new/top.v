`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/02 01:15:44
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst,
    input [7:0] btn,
    output [7:0] seg_data,
    output [5:0] seg_com        
    );
    wire clk_6mhz, clk_1hz, clk_600hz;
    wire [3:0] sec0,sec1,min0,min1,hrs0,hrs1;
    wire [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1;
    wire [3:0] t_sec0,t_sec1,t_min0,t_min1,t_hrs0,t_hrs1;
    wire [3:0] nt_sec0,nt_sec1,nt_min0,nt_min1,nt_hrs0,nt_hrs1;
    wire [3:0] s_sec0,s_sec1,s_min0,s_min1,s_hrs0,s_hrs1;
    wire [3:0] na_sec0,na_sec1,na_min0,na_min1,na_hrs0,na_hrs1;
    wire [3:0] c_min0,c_min1,c_hrs0,c_hrs1;
    reg [3:0] d_sec0,d_sec1,d_min0,d_min1,d_hrs0,d_hrs1;
    wire [6:0] seg_sec0,seg_sec1,seg_min0,seg_min1,seg_hrs0,seg_hrs1;
    reg [47:0] seg_data_array;
    wire [7:0] btn_out, btn_out_pulse;//button수의 따라 조절
    wire [5:0] cursor,t_cursor,a_cursor;
    wire [5:0] cursor_blink,t_cursor_blink,a_cursor_blink;
    wire a,b,c,d;
    wire [6:0] b_seg_sec0,b_seg_sec1,b_seg_min0,b_seg_min1,b_seg_hrs0,b_seg_hrs1;
    wire blink;
    wire alert;
    
    
    //module clk_wiz_0(output clk_out1,input reset,output locked,input clk_in1);
    clk_wiz_0 clk_inst(clk_6mhz,rst, ,clk);
    
    //module clk_divider(input clk_in,input rst,output reg clk_out);
    clk_divider clk_div_inst1(clk_6mhz,rst,clk_1hz);
    clk_divider #(.DIVISOR(10000)) clk_div_inst2(clk_6mhz,rst,clk_600hz);
    
    
    //시계
    //module Counter(input clk, rst, btn,input [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,input [5:0] cursor,output reg [3:0] sec0,sec1,min0,min1,hrs0,hrs1);
    Counter counter_inst(clk_1hz, rst, ~btn_out[4],n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,cursor,sec0,sec1,min0,min1,hrs0,hrs1);
    //module timecontrol(input left, right, up, down,input clk, rst, btn,input [3:0] sec0,sec1,min0,min1,hrs0,hrs1,output reg [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,output reg [5:0] cursor,output [5:0] cursor_blink);  
    timecontrol tcc_inst(btn_out_pulse[3],btn_out_pulse[2],btn_out_pulse[1],btn_out_pulse[0],clk_6mhz,rst,~btn_out[4]&d,sec0,sec1,min0,min1,hrs0,hrs1,n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,cursor,cursor_blink);
    
    
    //타이머
    timecontrol tct_inst(btn_out_pulse[3],btn_out_pulse[2],btn_out_pulse[1],btn_out_pulse[0],clk_6mhz,rst,~btn_out[4]&a,t_sec0,t_sec1,t_min0,t_min1,t_hrs0,t_hrs1,nt_sec0,nt_sec1,nt_min0,nt_min1,nt_hrs0,nt_hrs1,t_cursor,t_cursor_blink);
    //module timer(input clk,rst,en,btn,input [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,input [5:0] cursor,output blink,output reg [3:0] t_sec0,t_sec1,t_min0,t_min1,t_hrs0,t_hrs1);
    timer timer_inst(clk_1hz,rst,a,~btn_out[4],nt_sec0,nt_sec1,nt_min0,nt_min1,nt_hrs0,nt_hrs1,t_cursor,blink,t_sec0,t_sec1,t_min0,t_min1,t_hrs0,t_hrs1);
    
    
    //스탑워치
    //module stopwatch(input clk, rst, btn,b,output reg [3:0] sec0,sec1,min0,min1,hrs0,hrs1);
    stopwatch sw_inst(clk_6mhz, rst, btn_out_pulse[1],b,s_sec0,s_sec1,s_min0,s_min1,s_hrs0,s_hrs1);
    
    
    //알람
    //module alarm(input clk, rst, btn,c,input [5:0] cursor,input [3:0] n_min0,n_min1,n_hrs0,n_hrs1,input [3:0] min0,min1,hrs0,hrs1,output reg [3:0] c_min0,c_min1,c_hrs0,c_hrs1,output alert);
    alarm(clk_6mhz, rst,~btn_out[4],c,a_cursor, na_min0,na_min1,na_hrs0,na_hrs1,min0,min1,hrs0,hrs1,c_min0,c_min1,c_hrs0,c_hrs1,alert);
    timecontrol tca_inst(btn_out_pulse[3],btn_out_pulse[2],btn_out_pulse[1],btn_out_pulse[0],clk_6mhz,rst,~btn_out[4]&c, , ,c_min0,c_min1,c_hrs0,c_hrs1, , ,na_min0,na_min1,na_hrs0,na_hrs1,a_cursor,a_cursor_blink);
    
    
    //module ctrl(input clk,input [2:0] btn,output reg a,b,c);
    ctrl ctrl_inst(clk_6mhz,~btn_out[7:5],a,b,c,d);
    
    
    always @ (*) begin
        if(a == 1) begin
            d_sec0 = t_sec0; 
            d_sec1 = t_sec1;
            d_min0 = t_min0;
            d_min1 = t_min1;
            d_hrs0 = t_hrs0;
            d_hrs1 = t_hrs1;
        end
        else if(b == 1) begin
            d_sec0 = s_sec0; 
            d_sec1 = s_sec1;
            d_min0 = s_min0;
            d_min1 = s_min1;
            d_hrs0 = s_hrs0;
            d_hrs1 = s_hrs1;
        end
        else if(c == 1 && ~btn_out[4]) begin
            d_sec0 = 4'b0; 
            d_sec1 = 4'b0;
            d_min0 = c_min0;
            d_min1 = c_min1;
            d_hrs0 = c_hrs0;
            d_hrs1 = c_hrs1;
        end
        else begin
            d_sec0 = sec0;
            d_sec1 = sec1;
            d_min0 = min0;
            d_min1 = min1;
            d_hrs0 = hrs0;
            d_hrs1 = hrs1;
        end
    end
    
    //module dec7(input [3:0] dec_in,output reg [6:0] dec_out);
    dec7 dec7_inst0(d_sec0,seg_sec0);
    dec7 dec7_inst1(d_sec1,seg_sec1);
    dec7 dec7_inst2(d_min0,seg_min0);
    dec7 dec7_inst3(d_min1,seg_min1);
    dec7 dec7_inst4(d_hrs0,seg_hrs0);
    dec7 dec7_inst5(d_hrs1,seg_hrs1);
    
    
    
    assign b_seg_sec0 = seg_sec0 & {7{clk_1hz}};
    assign b_seg_sec1 = seg_sec1 & {7{clk_1hz}};
    assign b_seg_min0 = seg_min0 & {7{clk_1hz}};
    assign b_seg_min1 = seg_min1 & {7{clk_1hz}};
    assign b_seg_hrs0 = seg_hrs0 & {7{clk_1hz}};
    assign b_seg_hrs1 = seg_hrs1 & {7{clk_1hz}};
    
    
    
    always @ (*) begin
        if(~btn_out[4]&d) seg_data_array = {seg_hrs1,cursor_blink[5],seg_hrs0,cursor_blink[4],seg_min1,cursor_blink[3],seg_min0,cursor_blink[2],seg_sec1,cursor_blink[1],seg_sec0,cursor_blink[0]};
        else if(a == 1 && btn_out[4]) begin
            if(blink) seg_data_array = {b_seg_hrs1,1'b0,b_seg_hrs0,clk_1hz,b_seg_min1,1'b0,b_seg_min0,clk_1hz,b_seg_sec1,1'b0,b_seg_sec0,1'b0};
            else seg_data_array = {seg_hrs1,1'b0,seg_hrs0,1'b1,seg_min1,1'b0,seg_min0,1'b1,seg_sec1,1'b0,seg_sec0,1'b0};
        end
        else if(a == 1 && ~btn_out[4]) seg_data_array = {seg_hrs1,t_cursor_blink[5],seg_hrs0,t_cursor_blink[4],seg_min1,t_cursor_blink[3],seg_min0,t_cursor_blink[2],seg_sec1,t_cursor_blink[1],seg_sec0,t_cursor_blink[0]};
        else if (c == 1 && ~btn_out[4]) seg_data_array = {seg_hrs1,a_cursor_blink[5],seg_hrs0,a_cursor_blink[4],seg_min1,a_cursor_blink[3],seg_min0,a_cursor_blink[2],seg_sec1,a_cursor_blink[1],seg_sec0,a_cursor_blink[0]};
        else if (c == 1 && btn_out[4]) begin
            if(alert) seg_data_array = {b_seg_hrs1,1'b0,b_seg_hrs0,clk_1hz,b_seg_min1,1'b0,b_seg_min0,clk_1hz,b_seg_sec1,1'b0,b_seg_sec0,1'b0};
            else seg_data_array = {seg_hrs1,1'b0,seg_hrs0,1'b1,seg_min1,1'b0,seg_min0,1'b1,seg_sec1,1'b0,seg_sec0,1'b0};
        end
        else seg_data_array = {seg_hrs1,1'b0,seg_hrs0,1'b1,seg_min1,1'b0,seg_min0,1'b1,seg_sec1,1'b0,seg_sec0,1'b0};
    end
    
    //module shift(input clk,input rst,input en,input [47:0] seg_data_array,output reg [7:0] seg_data,output reg [5:0] seg_com);
    shift shift_inst(clk_600hz,rst,1'b1,seg_data_array,seg_data,seg_com);
    
    //module debounce(clk, rst, btn_in, btn_out, btn_out_pulse); //버튼 수의 따라 btn_width 조절
    debounce #(.BTN_WIDTH(8)) db_inst(clk_6mhz, rst, btn, btn_out, btn_out_pulse); 
    
endmodule
