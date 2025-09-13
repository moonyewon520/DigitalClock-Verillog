`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 02:02:13
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    input clk,
    input [2:0] btn,
    output reg a,b,c,d
    );
    
    always @ (btn) begin
            case(btn)
                3'b001 : begin a = 1; b = 0; c = 0; d = 0; end
                3'b010 : begin a = 0; b = 1; c = 0; d = 0; end
                3'b100 : begin a = 0; b = 0; c = 1; d = 0; end
                default : begin a = 0; b = 0; c = 0; d = 1; end
            endcase
    end
endmodule
