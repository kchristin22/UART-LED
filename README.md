# UART-LED
Display of values of a sensor on LEDs by the use of UART communication and a LED driver


This is a project implemented in Verilog that concers the display of values acquired from a sensor on four LEDs. The sensor's values are given as an input to a UART transmitter whose receiver is connected to the LED driver, responsible for calling a decoder to decode the values and driving the necessary signals to showcase these values on the LEDs.

The project is split into three parts:

A) The implementation of the LED decoder and driver

B) The implementation of the UART communication

C) The implementation of the whole circuit
