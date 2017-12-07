module spi_uart(
	clk,
	rst_n,
	
	spi_clk,
	spi_cs,
	spi_in,
	spi_out,
	
	tx
);

input clk;
input rst_n;
	
output spi_clk;
output spi_cs;
input spi_in;
output spi_out;

output tx;

wire [7:0] spi_data;

reg spi_en;
reg spi_RW;
reg [6:0] addr;
reg [7:0] data;
reg cs;

wire spi_done;

spi spi_module(
	.clk(clk),
	.rst_n(rst_n),
	.en(spi_en),
	.RW(RW),
	
	.addr_in(addr),
	.data_in(data),
	
	.miso(spi_in),
	.mosi(spi_out),	
	.cs(cs),
	.sck(spi_clk),
	
	.done(spi_done)
);

wire tx;
wire done;


uart_module uart(
	.clk(clk),
	.rst(rst_n),
	
	.EN(1'b1),
	.data_in(data),
	.tx(tx),
	.done(done)
	
);

endmodule
