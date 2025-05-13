`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Dedicate_MicroProcessor(
    input clk,
    input rst,
    input [7:0] N,
    output led
    );

    wire NMUX, CountMUX, NLoad, CountLoad, OE, OutputMUX;
    wire N_equal_0, N0_equal_0, Count_equal_4;

    control_FSM CU(
        .clk           (clk           ),
        .rst           (rst           ),
        .N_equal_0     (N_equal_0     ),
        .N0_equal_0    (N0_equal_0    ),
        .Count_equal_4 (Count_equal_4 ),
        .NMUX          (NMUX          ),
        .CountMUX      (CountMUX      ),
        .NLoad         (NLoad         ),
        .CountLoad     (CountLoad     ),
        .OutputMUX     (OutputMUX     ),
        .OE            (OE            )
    );
    
    DataPath u_DataPath(
        .N             (N             ),
        .clk           (clk           ),
        .rst           (rst           ),
        .NMUX          (NMUX          ),
        .CountMUX      (CountMUX      ),
        .NLoad         (NLoad         ),
        .CountLoad     (CountLoad     ),
        .OutputMUX     (OutputMUX     ),
        .OE            (OE            ),
        .N_equal_0     (N_equal_0     ),
        .N0_equal_0    (N0_equal_0    ),
        .Count_equal_4 (Count_equal_4 ),
        .out           (led           )
    );
endmodule