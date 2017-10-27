`timescale 1ns / 1ps

//	clkdiv module

module clkdiv_mode(
		
		clk, 
	   rst_n,
		
		clkout
	
);
	input rst_n;
	input clk;

	output reg clkout;
	
	reg [15:0] count;
	
	
	always @(posedge clk or negedge rst_n)
	begin
		
		if(!rst_n)	
		begin
			count <= 16'b0;
			clkout <= 0;
		end
			
		else if(count == 16'd2604)
		begin
			clkout <= 1'b1;
			count <= count + 16'd1;
		end
		else if(count == 16'd5208)
		begin
			clkout <= 1'b0;
			count <= 16'd0;
		
		end
		
		else 
		begin
			count <= count + 16'd1;
		end
	
	end

endmodule
