`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 00:42:54
// Design Name: 
// Module Name: timer_control
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


module timer_control(
    input clk, rst,
    input a, btn,
    input left, right, up, down,
    input [3:0] t_sec0,t_sec1,t_min0,t_min1,t_hrs0,t_hrs1, // 현재 타이머 상태
    output reg [3:0] n_sec0,n_sec1,n_min0,n_min1,n_hrs0,n_hrs1,
    output reg [5:0] cursor,
    output [5:0] cursor_blink
    );
    
    wire clk_1hz;
    
    clk_divider clk_div_inst1(clk,rst,clk_1hz);
    
// cursor 회전
    always @(posedge clk or posedge rst) begin
        if (rst) cursor <= 6'b100000;
        else if (btn && a) begin
            if (left)  cursor <= {cursor[4:0], cursor[5]};
            else if (right) cursor <= {cursor[0], cursor[5:1]};
        end
    end

    // cursor 위치 기준으로 n_* 갱신
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            n_sec0 <= 0; n_sec1 <= 0; n_min0 <= 0;
            n_min1 <= 0; n_hrs0 <= 0; n_hrs1 <= 0;
        end else if (btn && a) begin
            case (cursor)
                6'b000001: begin
                    if (up)   n_sec0 <= (t_sec0 == 9) ? 0 : t_sec0 + 1;
                    else if (down) n_sec0 <= (t_sec0 == 0) ? 9 : t_sec0 - 1;
                end
                6'b000010: begin
                    if (up)   n_sec1 <= (t_sec1 == 5) ? 0 : t_sec1 + 1;
                    else if (down) n_sec1 <= (t_sec1 == 0) ? 5 : t_sec1 - 1;
                end
                6'b000100: begin
                    if (up)   n_min0 <= (t_min0 == 9) ? 0 : t_min0 + 1;
                    else if (down) n_min0 <= (t_min0 == 0) ? 9 : t_min0 - 1;
                end
                6'b001000: begin
                    if (up)   n_min1 <= (t_min1 == 5) ? 0 : t_min1 + 1;
                    else if (down) n_min1 <= (t_min1 == 0) ? 5 : t_min1 - 1;
                end
                6'b010000: begin
                    if (up)   n_hrs0 <= (t_hrs0 == 9) ? 0 : t_hrs0 + 1;
                    else if (down) n_hrs0 <= (t_hrs0 == 0) ? 9 : t_hrs0 - 1;
                end
                6'b100000: begin
                    if (up)   n_hrs1 <= (t_hrs1 == 2) ? 0 : t_hrs1 + 1;
                    else if (down) n_hrs1 <= (t_hrs1 == 0) ? 2 : t_hrs1 - 1;
                end
            endcase
        end
    end

    assign cursor_blink = cursor & {6{clk_1hz}};
    
endmodule
