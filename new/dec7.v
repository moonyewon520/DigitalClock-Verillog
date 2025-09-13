`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/01 21:12:24
// Design Name: 
// Module Name: dec7
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


module dec7(
    input [3:0] dec_in,
    output reg [6:0] dec_out
    );
    
    always @ (dec_in) begin
        case(dec_in)
            4'b0000 : dec_out = 7'b1111110;
            4'b0001 : dec_out = 7'b0110000;
            4'b0010 : dec_out = 7'b1101101;
            4'b0011 : dec_out = 7'b1111001;
            4'b0100 : dec_out = 7'b0110011;
            4'b0101 : dec_out = 7'b1011011;
            4'b0110 : dec_out = 7'b1011111;
            4'b0111 : dec_out = 7'b1110010;
            4'b1000 : dec_out = 7'b1111111;
            4'b1001 : dec_out = 7'b1111011;
            default : dec_out = 7'b0;
        endcase 
    end
endmodule
