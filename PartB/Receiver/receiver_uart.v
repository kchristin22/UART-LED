
`include "baud_controller.v"

`timescale 1ns / 1ns

module receiverUART(reset, clk, Rx_DATA, baud_select, RX_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

  	input clk, reset;
	input [2:0] baud_select;
	input RX_EN; 
	input RxD;
	output reg [7:0] Rx_DATA = 0;
	output reg Rx_FERROR = 0; // Framing Error //
	output reg Rx_PERROR = 0; // Parity Error //
	output reg Rx_VALID = 0; // Rx_DATA is Valid //
  
  	reg [3:0] counter = 0;
  	reg [7:0] check_data; // stores the data temporarily to check their validity before sending them to the system
  	reg [2:0] value;
   	reg [3:0] misses = 0;

  	
	baud_controller baud_controller_rx_instance(reset, clk, baud_select, Rx_sample_ENABLE);
  
  reg[3:0] current_state, next_state, bitIndex;
  reg [2:0] IDLE = 3'b000, RSTART = 3'b001,RDATA = 3'b010,RPARITY = 3'b011,RSTOP = 3'b100;
  

always@(posedge Rx_sample_ENABLE or posedge reset)
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
  
  always@(current_state or RX_EN or counter) 
begin //Next State Logic 
  case(current_state) 
    IDLE: if(RX_EN == 1 && RxD==0) begin
      next_state = RSTART;
    end
    else
      next_state = IDLE;
    
    RSTART:if(counter == 7) begin
      next_state = RDATA;    
    end
    RDATA: if(counter == 7 && bitIndex < 7) begin
      next_state = RDATA;
    end
    else if(counter == 7 && bitIndex == 7)
      next_state = RPARITY; 

    RPARITY:if(counter == 7) begin
      next_state = RSTOP;
    end

    RSTOP: if(counter == 7) begin
      next_state = IDLE;
    end
    endcase   
end

  always@(current_state or counter)
 begin //OUTPUT LOGIC
  case(current_state)
    RSTART: begin
      Rx_PERROR = 0;
      Rx_FERROR = 0;
      Rx_VALID = 0;
      bitIndex = 0;
    end
    RDATA: if(^counter== 1) begin
      if(counter == 9)
      	value = RxD; // first sample
      if(RxD != value) begin 
        misses = misses + 1; // search for errors due to noise
        Rx_FERROR = 1;
      end
      if(counter == 7) begin
         check_data[bitIndex] = RxD;
      	 bitIndex = bitIndex+1;
      end
      if(counter==13) begin
        if(value == check_data[bitIndex]) begin // check if the sample in the middle is the actual value of the bit
          if(misses>4) begin
            check_data[bitIndex] = ~value;
          end
        end
      	else
          if(misses<4)begin
            check_data[bitIndex] = value;
          end
       end
    end
    RPARITY: if(counter == 7) begin
      if (RxD != ^check_data)
      	Rx_PERROR = 1;
    end
    RSTOP:if(counter == 7) begin
      if (RxD != 1)
        Rx_FERROR = 1;
      else
        if (Rx_PERROR ==0)
          Rx_VALID = 1;
      Rx_DATA[7:0] = check_data[7:0];
    end
    
   
  endcase
 end
  
  
  
////counter////
  always@(posedge Rx_sample_ENABLE or posedge reset)
begin
	if (reset)
	begin
		counter = 0;
	end	
	else 
	begin
      if (counter == 15)
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
