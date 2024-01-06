`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2023 05:35:09 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Create
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output LEDA,
    output LEDB,
    output [4:0] LEDX,
    
    output a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,
    output [7:0]an
);
    
wire divided_clk;
wire BTN_A;
wire BTN_B;
wire [55:0] SSD;
clk_divider clk_dvd(clk, rst, divided_clk);

debouncer debA(divided_clk, rst, BTNA, BTN_A);
debouncer debB(.clk(divided_clk), .rst(rst), .noisy_in(BTNB), .clean_out(BTN_B));

hockey hockey(divided_clk, rst, BTN_A, BTN_B, DIRA, DIRB, YA, YB, LEDA, LEDB, LEDX, SSD[55:49], SSD[48:42], SSD[41:35], SSD[34:28],SSD[27:21], SSD[20:14], SSD[13:7], SSD[6:0]);

ssd ssd(clk, rst, SSD[55:49], SSD[48:42], SSD[41:35], SSD[34:28], SSD[27:21], SSD[20:14], SSD[13:7], SSD[6:0], a_out, b_out, c_out, d_out, e_out, f_out, g_out, p_out, an);

   
	
endmodule
