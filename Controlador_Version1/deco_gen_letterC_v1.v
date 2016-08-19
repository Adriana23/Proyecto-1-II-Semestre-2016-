`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: César Ortega Valverde
// 
// Create Date:    23:26:13 08/15/2016 
// Design Name: 	 Circuito Generador de Pixeles
// Module Name:    deco_gen 
// Project Name: 	 Controlador VGA
// Target Devices: Spartan 3E
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module deco_gen_letterC(
	input wire video_on,
	input wire [9:0] pix_x, pix_y,
	input wire [2:0] sw_rgb,
	output reg [2:0] graph_rgb
    );

	// constant and signal declaration
	// x, y coordinates (0.0) to (639,479)
	localparam MAX_X = 640;
	localparam MAX_Y = 480;
	//-----------------------------------------------
	// letterC square
	//-----------------------------------------------
	localparam letterC_SIZE = 8;
	// letterC left, right boundary
	localparam letterC_X_L = 320;
	localparam letterC_X_R = letterC_X_L+letterC_SIZE-1;
	// letterC top, bottom boundary
	localparam letterC_Y_T = 240;
	localparam letterC_Y_B = letterC_Y_T+letterC_SIZE-1;
	//-------------------------------------------------
	// letterC
	//-------------------------------------------------
	wire [2:0] romC_addr, romC_col;
	reg [7:0] romC_data;
	wire romC_bit;
	//----------------------------------------------
	// object output signals
	//-----------------------------------------------
	wire sq_letterC_on, map_letterC_on;
	wire [2:0] letterC_rgb;
	//----------------------------------------------
	// body
	//----------------------------------------------
	// letterC image ROM
	always @*
	case (romC_addr)
		3'h0: romC_data = 8'b 00111110; //  ***** 
		3'h1: romC_data = 8'b 01111111; // *******
		3'h2: romC_data = 8'b 11100011; //***   **
		3'h3: romC_data = 8'b 11000000; //**
		3'h4: romC_data = 8'b 11000000; //**
		3'h5: romC_data = 8'b 11100011; //***   **
		3'h6: romC_data = 8'b 01111111; // *******
		3'h7: romC_data = 8'b 00111110; //  *****
	endcase
	//-----------------------------------------------
	// letterC square
	//------------------------------------------------------
	// pixel within letterC
	assign sq_letterC_on =
				(letterC_X_L<=pix_x) && (pix_x<=letterC_X_R) &&
				(letterC_Y_T<=pix_y) && (pix_y<=letterC_Y_B);
	// map current pixel location to ROM addr/col
	assign romC_addr = pix_y[2:0] - letterC_Y_T[2:0];
	assign romC_col = pix_x[2:0] - letterC_X_L[2:0];
	assign romC_bit = romC_data [romC_col];
	// pixel within letterC
	assign map_letterC_on = sq_letterC_on & romC_bit;
	// letterC rgb output
	assign letterC_rgb = sw_rgb; // red
	//-------------------------------------------------
	// rgb multiplexing circuit
	//---------------------------------------------------
	always @*
		if (~video_on)
			graph_rgb = 3'b111; // black
		else
			if (map_letterC_on)
				graph_rgb = letterC_rgb;
			else
				graph_rgb = 3'b000; // white background

endmodule


