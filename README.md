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
A continuación se declara el modulo Binary2BCD, el cual tiene como entrada un número binario de 14 bits que representa un número decimal, que brinda el usuario y tiene como salida 4 registros cada de cuatro bits, en donde "thousands" corresponde a las milesimas, "hundreds" corresponde a las centenas, "tens" a las decenas y "ones" a unidades del número a representar en BCD.

    module Binary2BCD(
    input [13:0] binary,
    output  [3:0] thousands,
    output  [3:0] hundreds,
    output  [3:0] tens ,
    output  [3:0] ones 
    );
    
Luego se definen 4 registros que serán modificados para asignarlos a los registros de salida     

    reg [3:0]D4;
    reg [3:0]D3;
    reg [3:0]D2;
    reg [3:0]D1;

    assign thousands=D4;
    assign hundreds=D3;
    assign  tens =D2;
    assign ones =D1;

Finalmente se establece la condicion de que se llevaran a cabo las siguientes operaciones cuando "binary" tenga algun valor, con estas operaciones se va desglosando cada uno de los numeros que corresponderan al mismo numero de display que representa el registro ("D4", "D3", "D2", "D1").

    always@(binary) 
    begin 
     D4 = binary / 1000;
		D3= (binary-1000*D4)/100;
		D2= ((binary-1000*D4)-(D3*100))/10;
		D1= (binary-1000*D4)-(D3*100)-D2*10;
    end


-----------------------------------------------------------------------------------------------------------

 A continuación se creo el archivo TOP BCDtoSSegx4, el cual tiene como entradas innum que es el número decimal representado en binario digitado por el usuario y clk el cual es la frecuencia de entrada del oscilador. También tiene como salida sseg que es el número a representar en el display, además de el registro  de salida "an", el cual sirve como variable de control.


    module BCDtoSSegx4(
    input [13:0] innum,
    input clk,//Frecuencia de entrada del oscilador
    output [0:6] sseg,//Salida
    output reg [3:0] an,//Varieble de control, anodo comun
	 input rst,
    );

Se establece el registro que almacenará la entrada "bcd" para la instanciación vista más adelante en "BCDtoSSeg" y además se establecen las conexiones que llevarán la información de las salidas de la instanciacón de " binary2BCD".

    reg [3:0]bcd=0;//Entrada BCD
    wire [3:0] thousands;
    wire[3:0] hundreds;
    wire[3:0] tens;
    wire[3:0] ones;
 
 Se instancian el modulo de " BCDtoSSeg" que corresponde a la configuración de un display siete segmentos y el modulo "Binary2BCD" el cual convierte el número decimal representado en binario a BCD
 
    BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));//Instancia el display
    Binary2BCD binary2BCD(.binary(innum), .thousands(thousands), .hundreds(hundreds), .tens(tens), .ones(ones));

    reg [26:0] cfreq=0;
    wire enable;

Se hace a continuación el divisor de frecuencia

    assign enable = cfreq[16];
    
    always @(posedge clk) begin
    if(rst==1) begin
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1;
	end
    end

Se crea el registro "count" de dos bits y se inicializa en 0, este perpitirá variar entre cada uno de los displays, además se establece que se ejecutará los siguientes comandos cada vez que haya un flanco de subida positivo. 

    reg [1:0] count =0; //Variable de control del multiplexor
    always @(posedge enable) begin // flip flop interno, funciona ante un flanco
    
   Se contemplan cuatro casos que permiten la asignación de cada uno de los displays de manera ordenada por milesimas, centenas, decenas y unidades, utilizando el aumento del registro count 
    
	 	if(rst==1) begin
			count<= 0;
			an<=4'b1111; 
		end
		else begin 
			count<= count+1; //Trunca en 2 bits
			an<=4'b1101; 
			case (count) 
				2'h0: begin bcd <= ones;   an<=4'b1110; end //se prende el display 1
				2'h1: begin bcd <= tens;   an<=4'b1101; end 
				2'h2: begin bcd <= hundreds;  an<=4'b1011; end 
				2'h3: begin bcd <= thousands; an<=4'b0111; end 
			endcase
		end
      end



---------------------------------------------------------------------------------------------------------------------------
El siguiente modulo solo es utilizado para estimular la simulación de los modulos anteriormente vistos 

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
	
Se inicializan los registros de entrada, incluyendo el número digitado por el usuario en decimal "innum"

	initial begin
		// Initialize Inputs
		clk2= 0;
		rst = 1;
		#10 rst =0;
		
		innum = 14'd4321;
        
	end
      

	always #1 clk2 = ~clk2;
	endmodule
-------------------------------------------------------------------------------------------------------
