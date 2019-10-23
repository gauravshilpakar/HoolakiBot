module servo_pwm (
	input clk,
	input [2:0] value,
	output reg angle	
	);

parameter constant = 2000000; 
reg [20:0] counter;
reg [17:0] decoded;

initial begin
	counter = 0;
	decoded = 0;
end

always @ (posedge clk)
begin
	if (counter == constant - 1)
		counter <= 0;
	else 
		counter <= counter + 1;
	if (counter < decoded)
	   angle <= 1;
	else 
	   angle <= 0; 
	
end


always @ (value) 
	begin
		case(value)
			3'd1 : decoded = 18'd230000;
			3'd2 : decoded = 18'd190000;
			3'd3 : decoded = 18'd150000;
			3'd4 : decoded = 18'd110000;
			3'd5 : decoded = 18'd70000;
			default : decoded = 18'd0;
		endcase
	end



endmodule