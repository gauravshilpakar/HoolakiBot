`timescale 1ns/ 1ps

module IR_frequency(
	input clk,reset,
	input [1:0] signal,
	output wire [9:0] b_out
);

localparam constantNumber = 100000000;
reg [31:0] counter;
reg [9:0] temp_data;
reg [9:0] out_data;

initial begin
	counter = 0;
	temp_data =0;
	out_data = 0;
end

always @ (posedge(clk))
begin
    if (reset == 1)
        counter <= 32'b0;
    else if (counter == constantNumber - 1)
        counter <= 32'b0;
    else
        counter <= counter + 1;

end

reg last_signal1 = 0;
reg last_signal2 = 0;

always @(posedge(clk))
begin
	last_signal1 <= signal[0];
	last_signal2 <= signal [1];
end




always @(posedge(clk))
begin
	if(counter == constantNumber - 1)
		begin
			out_data <= temp_data;
			temp_data <= 0;
		end
	else if(~last_signal1 & signal[0] || ~last_signal2 & signal[1])
		temp_data <= temp_data + 1;
end


assign b_out = out_data;
endmodule