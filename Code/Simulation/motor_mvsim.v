`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2019 12:54:57 AM
// Design Name: 
// Module Name: motor_mvsim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module motor_mvsim();
	reg clk,reset;
	reg [1:0] IPS;
	reg midIPS;
	reg IR;
	wire [1:0] L,R,pwm_out;
    

motor_mv motorsim(.clk(clk),.reset(reset),.IPS(IPS[1:0]),
						.midIPS(midIPS),.IR(IR),.outDirectionL(L[1:0]),
						.outDirectionR(R[1:0]),.enable(pwm_out[1:0]));

initial begin
	clk =0;
	reset=0;
	IPS =2'b11;
	IR =0;
	midIPS = 0;
end
always@ (posedge clk)
begin
#100
	midIPS = 1;
    IPS = 2'b10;
    IR = 0;

#100
	midIPS = 1;
    IPS = 2'b01;

#100
	midIPS = 0;
    IPS = 2'b11;
     
#100
	midIPS = 0;
    IPS = 2'b00;

#100
	IPS = 2'b11;
	IR = 0;
#100 reset = 1;

end

always
#5 clk =~ clk;

endmodule

