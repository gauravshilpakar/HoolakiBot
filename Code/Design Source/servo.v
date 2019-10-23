module servo(
		input clk,reset,
		input [1:0] IR,
		input [9:0] dst,
		output [1:0] servo,
		output [2:0] gripper
	);


parameter servo1 = 3'b001, servo2 = 3'b010, gripper1= 3'b011,gripper2= 3'b100 , gripper3= 3'b101,rst = 3'b110,
            zero=1, fortyfive=2,ninety=3,hundred35=4, hundred80=5;
            
localparam left = 2'b01, right = 2'b10;
wire time1;
secondCounter delay(.clk(clk),.reset(reset),.n_clk(time1));
reg [1:0] side; 
reg [2:0] servoturn;
reg [2:0] angle_value1,angle_value2,angle_gp1,angle_gp2,angle_gp3;

initial begin
	angle_value1 = ninety;
	angle_value2 = ninety;
	angle_gp1 = fortyfive;
	angle_gp1 = fortyfive;
	angle_gp1 = fortyfive;
end


always @ (time1)
begin
	
	if (IR != 2'b00 && servoturn == rst)
		servoturn <= servo2;
	else if (IR != 2'b00 && servoturn == servo2)
		servoturn <= servo1;
	else if (IR != 2'b00 && servoturn == servo1)
	begin
		case (dst)
			10'd10: servoturn <= gripper1;
			10'd100: servoturn <= gripper2;
			10'd1000: servoturn <= gripper3;
			default : servoturn <= rst;
		endcase	
	end
	else 
		servoturn <= rst;

end

always @(posedge clk) 
begin
	if (IR) 
	begin
		case (IR)
			2'b01: side <= left;
			2'b10:	side <= right;
			default: side <= 0; 
		endcase
	end

	else 
		side <= 0;
end

always @ (servoturn)
begin
	case (servoturn)
		servo1: begin
			case (side)
				left: angle_value1 <= fortyfive;
				right: angle_value1 <= hundred35;
				default: angle_value1 <= 0;
			endcase
		end
		servo2: begin
			case (side)
				left: begin
					case (dst)
						10'd10: angle_value2 <= hundred80;
						10'd100: angle_value2 <= hundred35;
						10'd1000: angle_value2 <= ninety;
						default : angle_value2 <= 0;
					endcase
				end
				right: begin
					case (dst)
						10'd10: angle_value2 <= ninety;
						10'd100: angle_value2 <= hundred35;
						10'd1000: angle_value2 <= hundred80;
						default : angle_value2 <= 0;
					endcase
				end
				default: angle_value2 <= 0;
			endcase
		end
		gripper1: angle_gp1 <= hundred35;
		gripper2: angle_gp2 <= hundred35;
		gripper3: angle_gp3 <= hundred35;
		rst: begin
			angle_value1 <= ninety;
			angle_value2 <= ninety;

		end
		default: begin
			angle_value1 <= 0;
			angle_value2 <= 0;
			angle_gp1 <= 0;
			angle_gp2 <= 0;
			angle_gp3 <= 0;
		end
	endcase
end

wire [1:0] temp_servo;
wire [2:0] temp_gripper;


servo_pwm servo_1(.clk(clk),.value(angle_value1[2:0]),.angle(temp_servo[0]));
servo_pwm servo_2(.clk(clk),.value(angle_value2[2:0]),.angle(temp_servo[1]));
servo_pwm gripper_1(.clk(clk),.value(angle_gp1[2:0]),.angle(temp_gripper[0]));
servo_pwm gripper_2(.clk(clk),.value(angle_gp2[2:0]),.angle(temp_gripper[1]));
servo_pwm gripper_3(.clk(clk),.value(angle_gp3[2:0]),.angle(temp_gripper[2]));

assign servo = temp_servo[1:0];
assign gripper = temp_gripper[2:0];

endmodule