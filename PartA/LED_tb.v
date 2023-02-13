`timescale 1ns / 1ps

module tb;

reg give_clk,give_reset;
reg[15:0] data = 16'b1100110011001100; //keno
wire a,b,c,d,e,f,g,dp;
wire an3,an2,an1,an0;

FourDigitLEDdriver test (give_reset, give_clk, data, an3, an2, an1, an0, a, b, c, d, e, f, g, dp); // instatiate decoder test
initial begin
	//$dumpfile("dump.vcd"); 
  	//$dumpvars;
  
	give_clk = 0; // our clock is initialy set to 0
	give_reset = 1; // our reset signal is initialy set to 1
	
  	#20;
  	give_reset = 0;
	
	
	data = 16'b1010100010001000; //-888
	
	#320;
	data = 16'b1100000100100011; // 123
	
	
	#320;
	data = 16'b1010001000110111; //-237
	
	
	#320;
	data = 16'b1011101110111011; //FFFF
  
	#1280 $finish;	 // after 1280ns, finish our simulation
end
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns
  
  
endmodule

