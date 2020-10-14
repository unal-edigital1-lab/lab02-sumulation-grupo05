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