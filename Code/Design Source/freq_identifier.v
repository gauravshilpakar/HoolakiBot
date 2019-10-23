module freq_identifier(
	input [9:0] data_in,
	output wire [9:0] dst
	);


reg [9:0] temp_dst;

initial begin
	temp_dst = 0;
end

always @ (data_in)
begin
	if (data_in > 10'd7 && data_in < 10'd20)
		temp_dst <= 10'd10;
	else if (data_in >10'd50 && data_in < 10'd150)
		temp_dst <= 10'd100;
	else if (data_in > 10'd300 && data_in < 10'd1023)
		temp_dst <= 10'd1000;
	else 
		temp_dst <= 10'd0;
end

assign dst = temp_dst[9:0];

endmodule