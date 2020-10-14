# Lab 02- BCD2SSEG
laboratorio 02 simulación

Integrantes:
* Paula Sofia Medina
* Johan Sebastian Molina
* Maria Alejandra Salgado

El código:
A continuación se definio el modulo BCDtoSSeg, el cual tiene como entrada BCD y como salida SSeg como se define a continuación: 
         
	 module BCDtoSSeg (BCD, SSeg);
    input [3:0] BCD;
    output reg [6:0] SSeg;
  
Luego de esto se definio un always con el fin de que realice la acción en el siguente bloque:
             
    always @ ( * ) begin

En este bloque se asignan los valores correspondientes al registro de salida SSEG dependiendo de los valores de entrada que se tengan en BCD, para permitir la visualización de los números en el display siete segmentos.
Se define al comienzo de cada caso el comando 4'b que quiere decir que ese valor es de cuatro bits y será un valor binario, lo cual convierte a un numero de 7   bits en binario por medio de la instrucción 7'b.

   
    case (BCD)
     4'b0000: SSeg = 7'b0000001; // "0"  
	4'b0001: SSeg = 7'b1001111; // "1" 
	4'b0010: SSeg = 7'b0010010; // "2" 
	4'b0011: SSeg = 7'b0000110; // "3" 
	4'b0100: SSeg = 7'b1001100; // "4" 
	4'b0101: SSeg = 7'b0100100; // "5" 
	4'b0110: SSeg = 7'b0100000; // "6" 
	4'b0111: SSeg = 7'b0001111; // "7" 
	4'b1000: SSeg = 7'b0000000; // "8"  
	4'b1001: SSeg = 7'b0000100; // "9"
    default:
    SSeg = 0;
    endcase
    end

--------------------------------------------------------------------------------------------------------------------
module Binary2BCD(
    input [13:0] binary,
    output  [3:0] thousands  ,
    output  [3:0] hundreds  ,
    output  [3:0] tens ,
    output  [3:0] ones 
    ); 
reg [29:0]shifter=0;

 reg [3:0]D4;
 reg [3:0]D3;
 reg [3:0]D2;
 reg [3:0]D1;

 assign thousands=D4;
 assign hundreds=D3;
 assign  tens =D2;
 assign ones =D1;
 
integer i; 
always@(binary) 
begin 
     D4 = binary / 1000;
		D3= (binary-1000*D4)/100;
		D2= ((binary-1000*D4)-(D3*100))/10;
		D1= (binary-1000*D4)-(D3*100)-D2*10;

end
endmodule

-----------------------------------------------------------------------------------------------------------

 Se creó el archivo BCDtoSSegx4 el cual tiene como función 
`timescale 1ns / 1ps
module BCDtoSSegx4(
    input [13:0] innum,
    input clk,//Frecuencia de entrada del oscilador
    output [0:6] sseg,//Salida
    output reg [3:0] an,//Varieble de control,anodo comun
	 
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
always @(posedge enable) begin // flip flop interno, funciona ante un flanco
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

---------------------------------------------------------------------------------------------------------------------------
El siguiente modulo 

BCDtoSSegx4_TB;

	// Inputs
	reg [15:0] innum;
	reg clk2;
	reg rst;

	// Outputs
	wire [0:6] sseg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	BCDtoSSegx4 uut (
		.innum(innum), 
		.clk(clk2), 
		.sseg(sseg), 
		.an(an), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk2= 0;
		rst = 1;
		#10 rst =0;
		
		innum = 16'd4321;
        
	end
      

	always #1 clk2 = ~clk2;
	endmodule
-------------------------------------------------------------------------------------------------------
