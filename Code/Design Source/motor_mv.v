`timescale 1ns / 1ps

module motor_mv(
	input clk,reset,
	input [1:0] IPS,
	input midIPS,
	input [1:0] IR,
	output [1:0] outDirectionL,
	output [1:0] outDirectionR,
	output [1:0] enable
    );


reg [3:0] motorDirection;
parameter on_line = 3'b001, lost = 3'b010, beaconfound = 3'b011, deadend = 3'b100;
reg [2:0] state;
parameter forward = 4'b1001, backward = 4'b0110,left = 4'b0101,right = 4'b1010, stop = 4'b0000;
wire [1:0] enable1;


always @(posedge(clk))
begin
	if (state ==0 )
		state <= on_line;

	else if (IPS != 2'b11  && state == on_line)
		state <= lost;

	else

	begin
		case(state)
			on_line : begin 
						motorDirection = forward;
						if (IR != 2'b00)
							state <=beaconfound;
					end

			lost : begin
				if (midIPS == 0 && IPS == 2'b11)
					state <= on_line;

				 else 

				 begin
				case(IPS)
					2'b00 : state <= deadend;
					2'b01 : motorDirection = left;
					2'b10 : motorDirection = right;
					default : state <= lost;
				endcase
				end
			end


			beaconfound :begin 
							motorDirection = stop;
							if (IR != 2'b00 )
								state <= on_line;
		    end

			deadend : begin 
						motorDirection = stop;
						if (IPS != 2'b00)
							state <= on_line;
			end
			
			default : state <= on_line;
		endcase
	end
end

reg [2:0] powerlevelL;
reg [2:0] powerlevelR;

always @(motorDirection)
begin
	case(motorDirection)
		forward : begin
				powerlevelL <= 2;
				powerlevelR <= 2;	
		end

		left : begin
			powerlevelL <= 6;
			powerlevelR <= 6;
		end

		right : begin
			powerlevelL <= 6;
			powerlevelR <= 6;
		end

		stop : begin
			powerlevelL <= 0;
			powerlevelR <= 0;
		end

		default : begin
			powerlevelL <= 0;
			powerlevelR <= 0;
		end
	endcase
end

pwm leftmotor(.clk(clk),.value(powerlevelL[2:0]),.pwm_out(enable1[0]));
pwm rightmotor(.clk(clk),.value(powerlevelR[2:0]),.pwm_out(enable1[1]));

assign outDirectionL = motorDirection[1:0];
assign outDirectionR = motorDirection[3:2];
assign enable = enable1[1:0];
endmodule
