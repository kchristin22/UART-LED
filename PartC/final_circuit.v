`include "uart.v"
`include "FourDigitLEDdriver.v"

`timescale 1ns / 1ps

module final_circuit(reset, clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp, baud_select, Tx_WR, TX_EN, TX_BUSY, Tx_DATA, RX_EN, Rx_FERROR, Rx_PERROR, Rx_VALID);
  
//inputs and outputs of the first part  
input clk, reset; // add more inputs if needed
output wire an3, an2, an1, an0; // our anodes
output wire a, b, c, d, e, f, g, dp;	//	our signals

//inputs and outputs of the second part 
input [7:0] Tx_DATA;
input [2:0] baud_select;
input TX_EN;
input Tx_WR;     

output wire TX_BUSY;  
input RX_EN; 

output wire Rx_FERROR; // Framing Error //
output wire Rx_PERROR; // Parity Error //
output wire Rx_VALID; // Rx_DATA is Valid //  

  reg [2:0] packets = 0; // counts the UART 8-bit packets that have been received
  
  wire [7:0] Rx_DATA;
  reg [15:0] output_data = 16'b1100110011001100; // saves the final data and sends them to the LED driver 
  
  reg[15:0] current_data = 0; // saves the UART packets temporarily
  wire TxD;

  uart uart(reset, clk, Tx_DATA, baud_select, Tx_WR, TX_EN, TxD, TX_BUSY, Rx_DATA, RX_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

  always @(*) begin
	if (Rx_VALID)
	begin	
		packets = packets + 1;
		if (packets == 1)
			current_data[15:8] = Rx_DATA;
		 else if(packets == 2) begin
			current_data[7:0] = Rx_DATA;
			output_data = current_data;
			packets = 0;	
		 end
	end
	if(Rx_FERROR || Rx_PERROR)  
		output_data[15:0] = 16'b1011101110111011;
  end  
  
FourDigitLEDdriver led_driver(reset, clk, output_data, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

endmodule
