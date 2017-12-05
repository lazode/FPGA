module spi_tb();

reg clk;
reg rst_n;
reg en;
reg RW;
	
reg [6:0] addr_in;
reg [7:0] data_in;
	
reg miso;
wire mosi;	
wire cs;
wire sck;
wire done;


spi u1(
	.clk(clk),
	.rst_n(rst_n),
	.en(en),
	.RW(RW),
	
	.addr_in(addr_in),
	.data_in(data_in),
	
	.miso(miso),
	.mosi(mosi),	
	.cs(cs),
	.sck(sck),
	
	.done(done)
);


initial begin
	rst_n = 0;
	#10
	clk = 0;
	addr_in <= 7'b1110010;
	data_in <= 8'b10100011;
	RW <= 1'b0;
	
	en <= 1'b1;

	#10
	rst_n = 1;
	
	
end


always begin
	#10 clk = ~clk;
end

endmodule
