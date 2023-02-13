`timescale 1ns / 1ps

module tb;
  
//inputs
  
reg give_clk,give_reset;
reg[2:0] baud_select = 111;
reg Tx_WR; 
reg [7:0] Tx_DATA;
reg TX_EN = 1;
reg RX_EN = 1;

  
//outputs
wire a, b, c, d, e, f, g, dp;
wire TX_BUSY;
wire Rx_FERROR, Rx_PERROR, Rx_VALID;
integer k;

final_circuit test (give_reset, give_clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp, baud_select, Tx_WR, TX_EN, TX_BUSY, Tx_DATA, RX_EN, Rx_FERROR, Rx_PERROR, Rx_VALID);

initial begin
	//$dumpfile("dump.vcd"); 
  	//$dumpvars;
  	
	give_clk = 0; // our clock is initialy set to 0
	give_reset = 1; // our reset signal is initialy set to 1
	  	#20;
  	give_reset = 0;
  for (k = 0; k < 4; k = k+1)
    begin
      Tx_WR=1;
      if (k==0) 
	  Tx_DATA = 8'b10101000; // -8
      else if (k==1) 
	  Tx_DATA =  8'b10001000; // 88
      else if (k == 2)
       	  Tx_DATA = 8'b11000001; // 'space'1
      else if (k == 3)
       	  Tx_DATA = 8'b00100011; // 23
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
    end
	#483840 $finish;	 
end
	
always #10 give_clk = ~ give_clk; // create our clock, with a period of 20ns

endmodule
