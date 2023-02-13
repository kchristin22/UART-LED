`timescale 1ns / 1ps

module FourDigitLEDdriver(reset, clk, data, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
input clk, reset; // add more inputs if needed
input wire [15:0] data;

output an3, an2, an1, an0; // our anodes
output a, b, c, d, e, f, g, dp;	//	our signals
reg a,b,c,d,e,f,g,dp;
reg an3,an2,an1,an0;

//		    a
//   	 ------
//    f |	   |  b
//	    |   g  |
//	  	 ------
//      |      |
//	  e |	   |  c
//	     ------ 
//			d


wire [6:0] LED;
reg [3:0] char; // based on your received message, use this 4bit signal to drive our decoder
reg [3:0] counter; // counter to compute the time that the anodes will be active

/////////////////////////////////////////////////////////////////////		
//	Set char values to present them at the correct anode at a time //
/////////////////////////////////////////////////////////////////////	
  always@(posedge clk or posedge reset)
begin
	if (reset)
	begin
		char = data[15:12];             
	end
  else if (counter == 4'b0000) 
	begin
      char = data[15:12];              
	end 
  else if (counter == 4'b1100) 
	begin
      char = data[11:8];              
	end      
  else if (counter == 4'b1000) 
	begin
      char = data[7:4];           
	end
  else if (counter == 4'b0100) 
	begin
      char = data[3:0];        
	end 
  	else
	begin
		char = char;  
	end
end

//////////////////////////
//		Anodes Set		//
//////////////////////////
always@(posedge clk or posedge reset)
begin
	if (reset)
	begin
		an3 = 1'b1;
		an2 = 1'b1;
		an1 = 1'b1;
		an0 = 1'b1;
      	
	end
	else if (counter == 4'b1110) // add the required code to drive the anodes
	begin
		an3 = 1'b0;
		an2 = 1'b1;
		an1 = 1'b1;
		an0 = 1'b1;		
	end
	// add the required code to drive the anodes  
	else if (counter == 4'b1010) 
	begin
		an3 = 1'b1;
		an2 = 1'b0;
		an1 = 1'b1;
		an0 = 1'b1;
      			
	end
	else if (counter == 4'b0110) 
	begin
		an3 = 1'b1;
		an2 = 1'b1;
		an1 = 1'b0;
		an0 = 1'b1;
      			
	end 
	else if (counter == 4'b0010) 
	begin
		an3 = 1'b1;
		an2 = 1'b1;
		an1 = 1'b1;
		an0 = 1'b0;      	
 	end
	else
	begin
		an3 = 1'b1;
		an2 = 1'b1;
		an1 = 1'b1;
		an0 = 1'b1;
      	
	end
end

////////////////////////////////
//	Decoder	Instantiation	  //
////////////////////////////////
  
LEDdecoder LEDdecoderINSTANCE (.char(char),.LED(LED));

always@(LED)
begin
a = LED[6];
b = LED[5];
c = LED[4];
d = LED[3];
e = LED[2];
f = LED[1];
g = LED[0];
dp = 1'b1;
end

//////////////////////////////////////////////////
//		Counter for the 16 states of anodes		//
//////////////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if (reset)
	begin
		counter = 4'b1111;
	end	
	else 
	begin
		if (counter == 4'b0000)
		begin
			counter = 4'b1111;
		end
		else
		begin
			counter = counter - 1'b1;
		end
	end
end	

endmodule
