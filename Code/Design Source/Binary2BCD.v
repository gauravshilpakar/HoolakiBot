`timescale 1ns / 1ps

module Binary2BCD (
     input  [9:0] number,
   output reg [3:0] thousands,
   output reg [3:0] hundreds,
   output reg [3:0] tens,
   output reg [3:0] ones
  ); 
   // Internal variable for storing bits
   reg [25:0] shift;
   integer i;
   
   always @(number)
   begin
      // Clear previous number and store new number in shift register
      shift[25:9] = 0;
      shift[9:0] = number;
      
      // Loop eight times
      for (i=0; i<10; i=i+1) begin
         if (shift[13:10] >= 5)
            shift[13:10] = shift[13:10] + 3;
            
         if (shift[17:14] >= 5)
            shift[17:14] = shift[17:14] + 3;
            
         if (shift[21:18] >= 5)
            shift[21:18] = shift[21:18] + 3;
         
         if (shift[25:22] >= 5)
            shift[25:22] = shift[25:22] + 3;
         
         

         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
      thousands = shift[25:22];
      hundreds = shift[21:18];
      tens     = shift[17:14];
      ones     = shift[13:10];
   end
 
endmodule
