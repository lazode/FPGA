`timescale 1ns / 1ps

/**


*/


module uart_module(
		
						clk,
						rst,
						in,
					
						sdata,
						state,
						out
		);
		
	input clk;
	input rst;
	input in;
	
	output [7:0] out;
	output sdata;
	output [1:0] state;
	
	parameter IDLE    = 0;
	parameter START   = 1;
	parameter STOP    = 2;
	parameter RECEIVE = 3;
	
		
	reg  in_shift;
	wire clk_shift;
//	wire stop_wire;
	wire receive;
	
	wire divclk;
	
	reg en_shift;
	
	reg start_req; 
	reg stop_req;
//	reg idle_req;

	reg [7:0] cnt;
	reg [1:0] curr_state;
	reg [1:0] pre_state;
	
	//div clk module.
	
	clkdiv_mode div_module (
		.clk(clk),
		.rst_n(rst),
		
		.div_clk(divclk)
	
	);
	
	
	// shift registers module
	shift_mode shift_module (
		
		.clk(divclk),
		.dir_sel(1),
		.in(in_shift),
		.out(out),
		.en(en_shift),
		
		.rst(rst)
	);
 
	//assign stop_wire = out[]
	
	assign clk_shift = divclk;
	assign state = curr_state;
	
	assign receive = en_shift;
	assign sdata = out[7];
	
	
	//check the start signal.
	always @(posedge divclk)
	begin
		in_shift <= in;
		start_req <= in_shift && (~in)? 1:0;

	end
	
	
	
	//enable the shift module.
	always @(posedge divclk)
	begin
		if(stop_req)
			en_shift <= 1'b0;
		else if(start_req)
			en_shift <= 1'b1;
		
	end
	
	//initial the state machine.
	always @(posedge divclk or negedge rst)
	begin
		if(!rst)
		begin
			curr_state <= IDLE; 
		end
		else
		begin
			curr_state <= pre_state;
			
		end	
			
	end


	always @(posedge divclk)
	begin
	
		// stop signal control. 	
//		if((cnt == 8'd9) && (in_shift == 1'b1))
//			stop_req <= 1'b1;
//		else
//			stop_req <= 1'b0;
			stop_req  <= (cnt == 8'd9) && (in_shift == 1'b1)? 1:0;
	end
	
	
	always @(posedge divclk or negedge rst)
	begin
		if(!rst)
			cnt <= 0;
		
		else if(pre_state == START)
			cnt <= 0;
		else if(pre_state == RECEIVE)
			cnt <= cnt + 8'd1;

	end
	
	//state machine.
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
					
						pre_state <= RECEIVE;
						
					 end
			
			RECEIVE:begin
						
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
	
		
endmodule


