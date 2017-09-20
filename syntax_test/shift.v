
module shift(
			
			clk,
			rst,
			in,
			dir_sel,
			en,
			
			ld,
			in_parralle,
			out
		);
	
	parameter width = 7;
	
	
	input clk;
	input rst;
	input in;
	input [width:0] in_parralle;
	
	input dir_sel;
	input en;
	input ld;
	
	output [width:0] out;

	
	reg [width:0] buffer;
	
	assign out = buffer;

	
	// data shift.
	always @(posedge clk or negedge rst)		
	begin	
		
		if(!rst)
			buffer <= 0;
			
		else if(en)
		begin
			if(ld)
				buffer <= in_parralle;
			
			else if(dir_sel)
				buffer <= (buffer << 1);
			else
				buffer <= (buffer >> 1);
				
			buffer[0] <= in;
		
		end

	end

	
endmodule


