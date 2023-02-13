`timescale 1ns / 1ps

module tb;
  
//inputs
  
reg give_clk,give_reset;
reg[2:0] baud_select = 111;
reg Tx_WR=1; 
  reg [7:0] Tx_DATA =  8'b10101000;
reg TX_EN = 1;
reg RX_EN = 1;

  
//outputs
wire TxD; 
wire TX_BUSY;
wire [7:0] Rx_DATA;
wire Rx_FERROR, Rx_PERROR, Rx_VALID;
  
  
uart test (give_reset, give_clk, Tx_DATA, baud_select, Tx_WR, TX_EN, TxD, TX_BUSY, Rx_DATA, RX_EN, TxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

initial begin
	//$dumpfile("dump.vcd"); 
  	//$dumpvars;
  	
	give_clk = 0; // our clock is initialy set to 0
	give_reset = 1; // our reset signal is initialy set to 1
  	#20;
  	give_reset = 0;
  
      case(baud_select)
       3'b000: #(10417*20);   //one cycle
       3'b001: #(2604*20);
       3'b010: #(651*20);
       3'b011: #(326*20);
       3'b100: #(163*20);
       3'b101: #(81*20);
       3'b110: #(54*20);
       3'b111: #(27*20);
      endcase
  	Tx_WR = 0;
     case(baud_select)
       3'b000: #(10417*20*16*11);   
       3'b001: #(2604*20*16*11);
       3'b010: #(651*20*16*11);
       3'b011: #(326*20*16*11);
       3'b100: #(163*20*16*11);
       3'b101: #(81*20*16*11);
       3'b110: #(54*20*16*11);
       3'b111: #(27*20*16*11);
      endcase
  	
  	Tx_WR = 1;
	Tx_DATA =  8'b10001000;
	case(baud_select)
       3'b000: #(10417*20);   
       3'b001: #(2604*20);
       3'b010: #(651*20);
       3'b011: #(326*20);
       3'b100: #(163*20);
       3'b101: #(81*20);
       3'b110: #(54*20);
      3'b111: #(27*20);
      endcase
  	Tx_WR = 0;
  
	#241920 $finish;
end
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns


  
endmodule

