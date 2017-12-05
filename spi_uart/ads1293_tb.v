`timescale 1ns/1ps


module ads1293_tb();

reg clk;
reg rst_n;
	
reg en;
	
wire [7:0] data_out;

reg miso;
wire mosi;	
wire cs;
wire sck;

wire done;	


ads1293 u1(
	
	clk,
	rst_n,
	
	en,
	
	data_out,

	miso,
	mosi,	
	cs,
	sck,

	done	

);

reg [7:0] counter;


initial begin
	#10;
	rst_n = 0;
	#25;
	
	en = 1'b1;
	clk = 0;
	counter = 8'd0;
	
	rst_n = 1;
	
end



always @(negedge sck) begin
	if (cs == 1'b0) begin
	
		if (counter == 8'd4)
			counter <= 8'd0;
		else begin
			case (counter)
				0:	miso <= 1;
					
				1: miso <= 0;
				
				2: miso <= 1;
				
				3: miso <= 1;
				
			endcase 
		end
	end
end


always begin
	#10;
	clk = ~clk;
end

endmodule
