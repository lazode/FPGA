
module shift_mode(
			
			clk,
			rst,
			in,
			dir_sel,
			en,
			
			out
		);
	
	parameter width = 7;
	
	
	input clk;
	input rst;
	input in;
	input dir_sel;
	input en;
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
			
			if(dir_sel)
				buffer <= (buffer << 1);
			else
				buffer <= (buffer >> 1);
				
			buffer[0] <= in;
		
		end

	end

	
endmodule


