
`timescale 1ns / 1ps



module baud_controller(reset, clk, baud_select, sample_ENABLE);

input clk, reset;

input [2:0] baud_select;

output reg sample_ENABLE = 0;



reg[13:0] max_value;

reg[13:0] counter;  

always @(baud_select) begin

    case(baud_select)

	3'b000:max_value = 10417;   // the actual max value is one less, this was not changed for readability issues

      	3'b001:max_value = 2604;

        3'b010:max_value = 651;

        3'b011:max_value = 326; 

        3'b100:max_value = 163;

        3'b101:max_value = 81;

        3'b110:max_value = 54;

        3'b111:max_value = 27;

    endcase        

end

  

  

always@(posedge clk or posedge reset)

begin

	if (reset)

	begin

		counter = 0;

      	sample_ENABLE = 0;

	end	

	else 

	begin

      if (counter == max_value -1)

        begin

          	sample_ENABLE = 0;

          	counter = 0;

        end

	  else

        begin

          if (counter == max_value -2)

			begin

          		sample_ENABLE = 1;

			end

			counter = counter + 1;

		end

	end

end



endmodule
