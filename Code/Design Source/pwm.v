`timescale 1ns / 1ps

module pwm(
	input clk,
	input [2:0] value,
	output reg pwm_out
);

reg [15:0] counter;
reg [15:0] speed;
localparam freq = 50000;

initial begin
	counter = 0;
end

always @(posedge(clk))
begin
	if(counter == freq - 1)
		counter <= 0;
	else begin
		counter <= counter +1;
	end

	if(counter < speed)
		pwm_out <= 1;
	else 
		pwm_out <= 0;
end



always @ (*) 
	begin
		case(value)
			3'd0 : speed = 16'd0;
			3'd1 : speed = 16'd25000;
			3'd2 : speed = 16'd30000;
			3'd3 : speed = 16'd35000;
			3'd4: speed = 16'd40000;
			3'd5 : speed = 16'd45000;
			3'd6 : speed = 16'd50000;
			default : speed = 16'd0;
		endcase
	end





endmodule