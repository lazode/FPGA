module spi_uart_tb();

reg clk;
reg rst_n;
wire spi_in;

wire spi_clk;
wire spi_cs;
wire spi_out;


spi_uart u1(
	.clk(clk),
	.rst_n(rst_n),
	
	.spi_clk(spi_clk),
	.spi_cs(spi_cs),
	.spi_in(spi_in),
	.spi_out(spi_out),
	
	.tx(tx)
);


initial begin
	rst_n = 0;
	#10
	
	clk = 0;
	rst_n = 1;
	
end


always begin
	#10 clk = ~clk;
end


endmodule
