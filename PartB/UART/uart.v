`include "baud_controller.v"
`include "receiver_uart.v"
`include "transmitter_uart.v"

`timescale 1ns / 1ps

module uart(reset, clk, Tx_DATA, baud_select, Tx_WR, TX_EN, TxD, TX_BUSY, Rx_DATA, RX_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
  
  input clk, reset;
  input [7:0] Tx_DATA;
  input [2:0] baud_select;
  input TX_EN;
  input Tx_WR;
  output wire TxD; // not an actual output

  output wire TX_BUSY;  
  input RX_EN;
  input RxD; // not an actual input

  output wire [7:0] Rx_DATA;
  output wire Rx_FERROR; // Framing Error //
  output wire Rx_PERROR; // Parity Error //
  output wire Rx_VALID; // Rx_DATA is Valid //


transmitter_uart T(reset, clk, Tx_DATA, baud_select, Tx_WR, TX_EN, TxD, TX_BUSY);
receiver_uart R(reset, clk, Rx_DATA, baud_select, RX_EN, TxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

endmodule



