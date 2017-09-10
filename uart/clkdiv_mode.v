`timescale 1ns / 1ps

//	clkdiv module

module clkdiv_mode(
		
		clk, 
	   rst_n,
		
		div_clk
	
);
	input rst_n;
	input clk;

	output reg div_clk;
	
	reg [15:0] count;
	
	
	always @(posedge clk or negedge rst_n)
	begin
		
		if(!rst_n)	
		begin
			count <= 16'b0;
			div_clk <= 0;
		end
			
		else if(count == 16'd162)
		begin
			div_clk <= ~div_clk;
			count <= 16'd0;
		end
		else
		begin
		
			count <= count + 1;
		
		end
	
	end

endmodule
