`timescale 1ns / 1ps

/**


*/


module uart_module(
		
						clk,
						rst,
						
						EN,
						data_in,
//						sdata,
						tx,
						done
						
//						state,
//						out
		);
		
	input clk;
	input rst;
	input EN;
	
//	output [7:0] out;
//	output [2:0] state;
	
	input [7:0] data_in;
	output done;	
	output tx;
	
	reg done;
	reg tx;
	
	parameter IDLE     = 0;
	parameter START    = 1;
	parameter STOP     = 2;
	parameter TRANSFER = 4;
	
		
	reg  in_shift;
	wire clk_shift;
	wire receive;
	
	wire divclk;
	reg tx_ld;
	wire rx_ld;
	wire [7:0] tx_out;
	
	reg en_shift;
	
	reg start_req; 
	wire stop_req;

	reg [7:0] cnt;
	reg [2:0] pre_state;
	
	reg [7:0] tx_buffer; 
	
	
	reg [7:0] data_g;

//out[7:0] wire for debug
//	assign out = tx_buffer;
	
	//div clk module.
	
	clkdiv_mode div_module (
		.clk(clk),
		.rst_n(rst),
		
		.clkout(divclk)
	
	);
	
	
	assign clk_shift = divclk;
//	assign state = pre_state;
	
	assign receive = en_shift;
//	assign sdata = tx_buffer[0];
		 
/******************************************

	data loader

*******************************************/	
	always @(posedge clk or negedge rst) begin
		if (!rst) 
			data_g <= 8'd0;
		else if (EN && done)
			data_g <= data_in;
	end
	
	
/******************************************
	
	TX buffer&shifter control & statements

*******************************************/	
	
	shift_mode shift_tx (
		
		.clk(divclk),
		.dir_sel(0),
		.in(0),
		.out(tx_out),
		.en(en_shift),
		.ld(tx_ld),
		.in_parralle(tx_buffer),
		
		.rst(rst)
	);
	
	//TX buffer initialization & assignment.
	always @(posedge divclk or negedge rst) begin
	
	if(!rst)
		begin
			tx_buffer <= 8'd0;
		end

	else if(EN) begin
	
			case(pre_state)
				
				START:	  begin
								tx_ld <= 1'b0;
								tx_buffer <= (tx_buffer >> 1);
								
							  end
							 
				TRANSFER:  tx_buffer <= (tx_buffer >> 1);
				
				STOP:		  begin
								 
								 tx_buffer <= data_g;
								 tx_ld <= 1'b1;
								 
							  end
				
			endcase
		end
	end
		
	
	//enable the shift module.
	always @(posedge divclk) begin
		
		if(pre_state == STOP)
			en_shift <= 1'b0;
		else if(pre_state == START)
			en_shift <= 1'b1;
		
	end
	

	
	
/*******************************************
	
		state signal generation.

********************************************/
	
		
//start signal generation.
	always @(posedge divclk or negedge rst)
	begin
		if(!rst)
			start_req <= 1'b0;
		else begin
			if(done && EN)
				start_req <= 1'b1;
			else
				start_req <= 1'b0;
		end
	end
	
//stop signal generation.
//	always @(posedge divclk)
//	begin
//	
	assign stop_req = (cnt == 8'd7)? 1:0;
//	end

	
	
	//cnt
	always @(posedge divclk or negedge rst)
	begin
		if(!rst)
			cnt <= 0;
		
		else if(pre_state == START)
			cnt <= 0;
		else if(pre_state == TRANSFER)
			cnt <= cnt + 8'd1;

	end
	
	
	
/*******************************************
	
		state machine part

********************************************/
	
	
	
	//state machine transition.
	always @(posedge divclk )
	begin
			
		case (pre_state)
			
			IDLE:	 begin
						
					 	 if(start_req)
						 begin
							 pre_state <= START;
						 end
						 else
							 pre_state <= IDLE;
						
					 end
					
			START: begin
					
						 pre_state <= TRANSFER;
						
					 end
			
			TRANSFER:begin
						
						if(stop_req)
						begin
							pre_state <= STOP;
							
						end						
					  end
			
			STOP: begin
			
						 if(start_req)
						 begin
							pre_state <= START;
							
						 end
						 else 
						 begin
							pre_state <= IDLE;
							
						 end
					end
					
			default: pre_state <= IDLE;
		endcase
					
	end
	
	//state machine actions
	always @(posedge divclk or negedge rst)
	begin
		
//		if(pre_state == START)
//		begin
//			tx <= 1'b0;
//			  
//		end
//	
//		else if(stop_req && (pre_state == TRANSFER))		
//			tx <= 1'b1;
//		
//		else
//			tx <= tx_buffer[0];
		
		if(!rst) begin
			tx <= 1'b1;
			done <= 1'b1;
		end
		
		else begin
			
			case(pre_state)
			
				IDLE:		 begin
								if(start_req)
									tx <= 1'b0;
								else
									tx <= 1'b1;
									
								done <= 1'b0;
							 end
		
					
				TRANSFER: begin
						
								if(stop_req) 
									tx <= 1'b1;
								else
									tx <= tx_buffer[0];
							 end
						
				START:	 begin
								tx <= tx_buffer[0];
								
							 end
							 
				STOP:		 begin
								done <= 1'b1;
								
								if(start_req)
									tx <= 1'b0;
								else
									tx <= 1'b1;
							 end
				
				
				default:	   tx <= 1'b1;
			
			endcase
		end				
	end
	
endmodule


