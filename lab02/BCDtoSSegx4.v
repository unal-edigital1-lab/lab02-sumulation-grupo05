`timescale 1ns / 1ps
module BCDtoSSegx4(
    input [13:0] innum,
    input clk,//Frecuencia de entrada del oscilador
    output [0:6] sseg,//Salida
    output reg [3:0] an,//Variable de control,anodo comun
	 
	 input rst,
	 output led
    );

reg [3:0]bcd=0;//Entrada BCD
wire [3:0] thousands;
wire[3:0] hundreds;
wire[3:0] tens;
wire[3:0] ones;
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));//Instancia el display
Binary2BCD binary2BCD(.binary(innum), .thousands(thousands), .hundreds(hundreds), .tens(tens), .ones(ones));

reg [26:0] cfreq=0;
wire enable;

assign enable = cfreq[16];
assign led =enable;
always @(posedge clk) begin
  if(rst==1) begin
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1;
	end
end

reg [1:0] count =0;//Variable de control del multiplexor
always @(posedge enable) begin // flip flop interno, funciona ante un flanco de subida
		if(rst==1) begin
			count<= 0;
			an<=4'b1111; 
		end else begin 
			count<= count+1;//Trunca en 2 bits
			an<=4'b1101; 
			case (count) 
				2'h0: begin bcd <= ones;   an<=4'b1110; end //se prende el display 1
				2'h1: begin bcd <= tens;   an<=4'b1101; end 
				2'h2: begin bcd <= hundreds;  an<=4'b1011; end 
				2'h3: begin bcd <= thousands; an<=4'b0111; end 
			endcase
		end
end

endmodule