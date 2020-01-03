`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2019 15:47:11
// Design Name: 
// Module Name: vending_machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vending_machine(
input clock,
input reset,
input [2:0]coin,
output reg vend,
output state,
output reg change
    );
wire [2:0]coin;
parameter [2:0]nickel=3'b001; 
parameter [2:0]dime=3'b010; 
parameter [2:0]nickel_dime=3'b011; 
parameter [2:0]dime_dime=3'b100; 
parameter [2:0]quarter=3'b101;

reg [2:0] state;
reg [2:0] next_state;
parameter [2:0]idle=3'b000; 
parameter [2:0]five=3'b001; 
parameter [2:0]ten=3'b010; 
parameter [2:0]fifteen=3'b011; 
parameter [2:0]twenty=3'b100; 
parameter [2:0]twentyfive=3'b101;

always @(state or coin) 
begin 
next_state=3'b000;
case(state) 

idle: 
case(coin)
nickel: next_state=five; 
dime: next_state=ten; 
quarter: next_state=twentyfive; 
default: next_state=idle; 
endcase

five: 
case(coin)
nickel: next_state=ten; 
dime: next_state=fifteen; 
quarter: next_state=twentyfive;
default: next_state=five; 
endcase 
ten: 
case(coin)
nickel: next_state=fifteen; 
dime: next_state=twenty; 
quarter: next_state=twentyfive;
default: next_state=ten; 
endcase 
fifteen: 
case(coin)
nickel: next_state=twenty; 
dime: next_state=twentyfive; 
quarter: next_state=twentyfive;
default: next_state=fifteen;
endcase
twenty: 
case(coin)
nickel: next_state=twentyfive;
dime: next_state=twentyfive;
default: next_state=twenty; 
endcase 
twentyfive: 
next_state=idle;
default : next_state=idle;
endcase 
end

always @(clock) 
begin 
if(reset) 
begin 
state <= idle; 
vend <= 1'b0;
end
else 
state <= next_state;
case (state) 
idle: 
begin 
vend <= 1'b0; 
change <=3'b000; 
end 
five: 
begin 
vend <= 1'b0; 
if (coin==quarter) 
change <=nickel; 
else 
change <=3'd000; 
end 
ten: 
begin 
vend <= 1'b0; 
if (coin==quarter) 
change <=dime; 
else 
change <= 3'b000;
end 
fifteen: 
begin 
vend <= 1'b0; 
if (coin==quarter) 
change <=nickel_dime; 
else 
change <= 3'b000; 
end 
twenty: 
begin 
vend <= 1'b0; 
if (coin==dime) 
change <=nickel; 
else 
if (coin==quarter) 
change <=dime_dime; 
else 
change <= 3'b000; 
end 
twentyfive: 
begin 
vend <= 1'b1; 
change <=3'b000; 
end 
default: state <= idle; 
endcase
end 
endmodule