`timescale 1ns/1ps

module secondCounter(
	input clk,reset,
	output reg n_clk
);
	

	localparam constant = 300000000;
	reg [31:0] counter;
	initial begin
		counter = 0;
	end

	always @(posedge(clk), posedge(reset))
	begin
		if(reset)
		begin
			counter <= 0;
		end
		else if (counter == constant -1 )
			counter <= 0;
		else 
			counter <= counter + 1'b1;


	end

	always @ (posedge (clk))
	begin
		if (counter == constant -1 )
			n_clk <= ~n_clk;
		else 
			n_clk <= n_clk;
	end




endmodule