
`timescale 1ns / 1ps

module receiver_tb;

reg give_clk,give_reset;
reg [2:0] baud_select = 111;
reg serial_input =1 ;
reg enable = 1;
wire ferror,perror,valid;
wire [7:0] data ;
  
reg[10:0] rx_bits; // register to facilitate data testing
integer i=0;
integer k;
  
receiverUART test (give_reset, give_clk, data, baud_select, enable, serial_input, ferror, perror,valid); // instatiate decoder test

initial begin
	//$dumpfile("dump.vcd"); 
  	//$dumpvars;
  
	give_clk = 0; // our clock is initialy set to 0
	give_reset = 1; // our reset signal is initialy set to 1
  
  #20;

  give_reset = 0;

  rx_bits[0]= 0; // start bit
  rx_bits[1]= 1; // data 0
  rx_bits[2]= 1; // data 1
  rx_bits[3]= 0; // data 2
  rx_bits[4]= 0; // data 3
  rx_bits[5]= 1; // data 4
  rx_bits[6]= 0; // data 5
  rx_bits[7]= 1; // data 6
  rx_bits[8]= 1; // data 7
  rx_bits[9]= 1; // parity bit
  rx_bits[10]= 1; // stop bit
  
  for (k = 0; k < 2; k = k+1)
    begin
      for (i = 0; i < 11; i=i+1) 
        begin
		  
	  case(baud_select)
            3'b000: #3333440;   
            3'b001: #833280;
            3'b010: #208000;
            3'b011: #104320;
            3'b100: #52160;
            3'b101: #25920;
            3'b110: #17280;
            3'b111: #8640;
            endcase
          serial_input = rx_bits[i];
        end
      #540;
      rx_bits[3] = 1; // change any data you want to test
      rx_bits[9] = 0; // set the parity bit again after the changes
    end
  
  	
  
	#241920 $finish;	
end
	
  always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns

  
endmodule



