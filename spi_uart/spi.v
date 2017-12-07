
`timescale 1ns/1ps

module spi(
	clk,
	rst_n,
	en,
	RW,
	
	addr_in,
	data_in,
	
	data_out,
	miso,
	mosi,	
	cs,
	sck,
	
	done
);

input clk, rst_n, en, RW;
input [6:0] addr_in;
input [7:0] data_in;
//读取数据存取的寄存器 和 写出数据的寄存器
//read data register & wirte data register

input miso;

output mosi, sck, cs;
output done;
output [7:0] data_out;

reg [6:0] addr;
reg [7:0] data;

reg mosi;
reg sck;
reg cs;
reg done_r;
reg [7:0] counter;
reg [7:0] data_out = 8'd0;

assign done = done_r;

//reg sck_buff;
//wire sck_failing;
//wire sck_rising;
//
//always @(posedge clk or negedge rst_n) begin
//	sck_buff <= sck;
//end
//
//
//
//
//always @(posedge clk or negedge rst_n) begin
//	
//
//end


reg sck_fail;
reg sck_rise;


//always @(posedge clk or negedge rst_n) begin	
//	if (!rst_n) begin
//		addr <= 7'd0;
//	end
//	else begin
//		addr <= addr_in;
//		
//	end
//	
//end


always @(posedge clk or negedge rst_n) begin
	if (!rst_n ) begin
		counter <= 8'd0;
		data <= 8'd0;
		addr <= 7'd0;
		data_out <= 8'd0;
		
		cs <= 1'b1;
		done_r <= 1'b0;
	end
	else if (!en) 
		counter <= 8'd0;
	else if (en) begin
		case (counter)
			0: begin
					if (sck_fail) begin
						mosi <= RW;
						data <= data_in;
						addr <= addr_in;
						cs <= 1'b0;
						
						counter <= counter + 8'd1;
						done_r <= 1'b0;
					end
				end
			
			1, 2, 3, 4, 5, 6, 7: 
				begin
					if (sck_fail) begin
						mosi <= addr[7 - counter];
						counter <= counter + 8'd1;
					end
				end
		
			8:	begin
					if (sck_fail)  
						counter <= counter + 8'd1;
				end
				
			9, 10, 11, 12, 13, 14, 15, 16:
				begin
					if (sck_rise) begin
						if (!RW)
							mosi <= data[16 - counter];
						else
							data_out[16 - counter] <= miso;
							
						counter <= counter + 8'd1;
						
					end
				end
				
			 17: begin	
					if (sck_rise) begin
						cs <= 1'b1;
						done_r <= 1'b1;
						counter <= 8'd0;
					end
				end
		endcase
	end

end


reg [31:0] div_cnt;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		div_cnt <= 32'd0;		
	end
	else begin
	
		if (div_cnt == 32'd100) begin
			div_cnt <= 32'd0;
		end
		else begin
			div_cnt <= div_cnt + 32'd1;
		end
		
		if (div_cnt == 32'd50) begin
			sck <= 0;
			sck_fail <= 1;
		end
		else if (div_cnt == 32'd100) begin
			sck <= 1;
			sck_rise <= 1;
		end
		else begin
			sck_fail <= 0;
			sck_rise <= 0;
		end
	end
end

endmodule
