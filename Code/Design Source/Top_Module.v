`timescale 1ns / 1ps

module Top_Module(
	input clk,reset,
	input [1:0] IPS,
	input midIPS,
	input [1:0] IR,
    output [1:0] leftmotor,rightmotor,
    output [1:0] enable,
    output [3:0] digit,
    output [6:0] seg,
    output dp,
    output [1:0] servo,
    output [2:0] gripper
    );
wire [9:0] data_out;
wire [9:0] dst;
wire [15:0] pdata;


IR_frequency freq_counter(.clk(clk),.reset(reset),.signal(IR[1:0]),.b_out(data_out[9:0]));
freq_identifier destination(.data_in(data_out[9:0]),.dst(dst[9:0]));
Binary2BCD BCD_dataout(.number(dst[9:0]),.thousands(pdata[15:12]),.hundreds(pdata[11:8]),.tens(pdata[7:4]),.ones(pdata[3:0]));
seven_seg display(.data(pdata[15:0]),.clk(clk),.reset(reset),.ssOut(seg[6:0]),.temp_digit(digit[3:0]));
servo servos(.clk(clk),.reset(reset),.IR(IR[1:0]),.dst(dst[9:0]),.servo(servo[1:0]),.gripper(gripper[2:0]));





motor_mv motormovement(.clk(clk),.reset(reset),.IPS(IPS[1:0]),
						.midIPS(midIPS),.IR(IR[1:0]),.outDirectionL(leftmotor[1:0]),
						.outDirectionR(rightmotor[1:0]),.enable(enable[1:0]));


assign dp = 1'b1;

endmodule
