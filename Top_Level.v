`timescale 1ns / 1ps

module Top_Level(TxD_Enable, clk, reset, Data, TxD, TxD_debug, Enable_debug, clk_debug, reset_debug);

input TxD_Enable, clk, reset;
input [7:0] Data;
output TxD;
output TxD_debug;
output Enable_debug;
output clk_debug;
output reset_debug;

wire W1;

Debouncer D1(TxD_Enable, clk, reset, W1);
Transmitter T1(clk, reset, W1, Data, TxD); 

assign TxD_debug = TxD;
assign Enable_debug = TxD_Enable;
assign clk_debug = clk;
assign reset_debug = reset;

endmodule
