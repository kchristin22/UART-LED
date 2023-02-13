`timescale 1ns / 1ps

`include "baud_controller.v"



module transmitter_uart(reset, clk, Tx_DATA, baud_select, Tx_WR, TX_EN, TxD, TX_BUSY);

input clk, reset;

input [7:0] Tx_DATA;

input [2:0] baud_select;

input TX_EN;

input Tx_WR;     

output reg TxD = 1;

output reg TX_BUSY;     


reg[3:0] counter;  // counter 

reg[3:0] bitIndex=0;

reg flag = 1; 



 

 baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);



  

reg[2:0] current_state, next_state;

reg [2:0] IDLE = 3'b000, TSTART = 3'b001,TDATA = 3'b010,TPARITY = 3'b011,TSTOP = 3'b100;



always@(posedge Tx_sample_ENABLE or posedge reset)

begin //State Memory

  if(reset)

    begin

      current_state <= IDLE;

    end

  else 

    begin

      current_state <= next_state;

    end 

end	

  

always@(current_state or TX_EN or Tx_WR or counter)

begin //Next State Logic

  case(current_state) 

    IDLE: if(TX_EN == 1 && Tx_WR==1) begin

      next_state = TSTART;

    end

    else

      next_state = IDLE;

    

    TSTART: if(counter == 15) begin

      next_state = TDATA;

    end

    TDATA: if(counter == 15 && bitIndex < 8) begin

      next_state = TDATA;

    end

    else if(counter == 15 && bitIndex == 8)

      next_state = TPARITY; 



    TPARITY:if(counter == 15) begin

      next_state = TSTOP;

    end



    TSTOP: if(counter == 15) begin

      if (Tx_WR==0)

      	next_state = IDLE;

      else 

      	next_state = TSTART;

    end

    endcase   

end



  always@(current_state or counter)

 begin //OUTPUT LOGIC

  case(current_state)

    IDLE: begin

     	TX_BUSY = 0;

		TxD = 1;

    end

    TSTART: begin

      TX_BUSY = 1; 

      TxD = 0;

      bitIndex = 0;

    end

    TDATA: if(counter == 0 && bitIndex<8) begin

      TxD = Tx_DATA[bitIndex];

      bitIndex = bitIndex+1;

    end

    TPARITY: if(counter == 0) begin

      TxD = ^Tx_DATA;

    end

    TSTOP:if(counter == 0) begin

      TxD = 1;

    end

   

  endcase

 end

  

  

////counter////

  always@(posedge Tx_sample_ENABLE or posedge reset)

begin

  if (reset)

	begin

		counter = 0;

	end	

	else 

	begin

      if(next_state == TSTART && flag) begin

        counter = 0;

        flag = 0;

      end

      else if (next_state == IDLE)

        flag = 1;

      else if (counter == 15)

		begin 			

			counter = 0;

		end

	  else

		begin

			counter = counter + 1;

		end

	end

end



endmodule


