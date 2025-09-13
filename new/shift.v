`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/01 22:04:30
// Design Name: 
// Module Name: shift
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


module shift(
    input clk,
    input rst,
    input en,
    input [47:0] seg_data_array,
    output reg [7:0] seg_data,
    output reg [5:0] seg_com
    );
    
    always @ (posedge clk, posedge rst) begin
        if(rst) seg_com[5:0] <= 6'b000001;
        else if(en) seg_com[5:0] <= {seg_com[4:0],seg_com[5]};
    end
    
    always @ (*) begin
        case(seg_com)
            6'b000001 : seg_data[7:0] = seg_data_array[7:0];
            6'b000010 : seg_data[7:0] = seg_data_array[15:8];
            6'b000100 : seg_data[7:0] = seg_data_array[23:16];
            6'b001000 : seg_data[7:0] = seg_data_array[31:24];
            6'b010000 : seg_data[7:0] = seg_data_array[39:32];
            6'b100000 : seg_data[7:0] = seg_data_array[47:40];
            default : seg_data[7:0] = 8'b0;
        endcase    
    end
endmodule
