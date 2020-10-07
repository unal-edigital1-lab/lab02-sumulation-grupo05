`timescale 1ns / 1ps
module BCDtoSSegx4_TB;

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
	