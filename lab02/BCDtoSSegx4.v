`timescale 1ns / 1ps
module BCDtoSSegx4(
    input [15:0] innum,
    input clk,//Frecuencia de entrada del oscilador
    output [0:6] sseg,//Salida
    output reg [3:0] an,//Varieble de control,anodo comun
	 input rst,
	 output led
    );

reg [3:0]bcd=0;//Entrada BCD
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));//Instancia el display

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
always @(posedge enable) begin // flip flop interno, funciona ante un flanco
		if(rst==1) begin
			count<= 0;
			an<=4'b1111; 
		end else begin 
			count<= count+1;//Trunca en 2 bits
			an<=4'b1101; 
			case (count) 
				2'h0: begin bcd <= innum[3:0];   an<=4'b1110; end //se prende el display 1
				2'h1: begin bcd <= innum[7:4];   an<=4'b1101; end 
				2'h2: begin bcd <= innum[11:8];  an<=4'b1011; end 
				2'h3: begin bcd <= innum[15:12]; an<=4'b0111; end 
			endcase
		end
end

endmodule