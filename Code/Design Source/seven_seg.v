`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2019 04:00:10 PM
// Design Name: 
// Module Name: seven_seg
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

module seven_seg(
	input [15:0] data,
	input clk,reset,
	output reg [6:0] ssOut,
	output reg [3:0] temp_digit
    );
reg [31:0] count;
reg [1:0] counter;
reg [6:0] temp_seg;
reg clk_div;



localparam constantNumber = 10000; 
initial begin
    counter =0;
    count =0;
end


// Clock Division for 7 Segment Display Multiplexing
always @ (posedge(clk), posedge(reset))
begin
    if (reset == 1)
        count <= 32'b0;
    else if (count == constantNumber - 1)
        count <= 32'b0;               
    else
        count <= count + 1;
end

always @ (posedge(clk), posedge(reset))
begin
    if (reset == 1'b1)
        clk_div <= 1'b0;
    else if (count == constantNumber - 1)
        clk_div <= ~clk_div;
    else
        clk_div <= clk_div;

end

always @(posedge(clk_div))
begin
	 if(counter== 2'b11)
	 	counter <= 2'b00;
	 else 
	 	counter <= counter +1'b1;
end





// Multiplexing for powering all the digit
always @ (*)
 begin
  case(counter[1:0]) //using only the 2 MSB's of the counter 
    
   2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
     temp_seg = data[3:0];
     temp_digit = 4'b1110;
    end
    
   2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
     temp_seg = data[7:4];
     temp_digit = 4'b1101;
    end
    
   2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
     temp_seg = data[11:8];
     temp_digit = 4'b1011;
    end
     
   2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
     temp_seg = data[15:12];
     temp_digit = 4'b0111;
    end
  endcase
 end




// writes data to segment port
always @(temp_seg)
    case (temp_seg)
      5'h0: ssOut = 7'b1000000;
      5'h1: ssOut = 7'b1111001;
      5'h2: ssOut = 7'b0100100;
      5'h3: ssOut = 7'b0110000;
      5'h4: ssOut = 7'b0011001;
      5'h5: ssOut = 7'b0010010;
      5'h6: ssOut = 7'b0000010;
      5'h7: ssOut = 7'b1111000;
      5'h8: ssOut = 7'b0000000;
      5'h9: ssOut = 7'b0011000;
      5'hA: ssOut = 7'b0001000;
      5'hB: ssOut = 7'b0111111;
      5'hC: ssOut = 7'b1000110;
      5'hD: ssOut = 7'b0100001;
      5'hE: ssOut = 7'b0000110;
      5'hF: ssOut = 7'b0101111;
      default: ssOut = 7'b0111111;
    endcase


endmodule


