`timescale 1ns / 1ps

/**
	测试，将data generation 部分取消注释，将端口声明 in 以及input in注释，
	将 in 作为输入的地方换成data_in，data_in取消注释

*/


module syntax_test(
		
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
	
	
	//data generation.
//	reg data_in;
//	reg [7:0] count;
//	
//	always @(posedge divclk or negedge rst)
//	begin
//		if(!rst)
//			count <= 0;
//			
//		else if(count == 7)
//			count <= 0;
//		
//		else
//			count <= count + 1;
//	end
//	
//	
//	always @(posedge divclk)
//	begin
//		case(count)
//			
//			8'd0: data_in <= 1;
//			8'd1: data_in <= 0;
//			8'd2: data_in <= 1;
//			8'd3: data_in <= 0;
//			8'd4: data_in <= 0;
//			8'd5: data_in <= 1;
//			8'd6: data_in <= 0;
//			8'd7: data_in <= 1;
//			
//			default: data_in <= 0;
//			
//		endcase
//		
//	end
	
	
	
	//div clk module.
	
	clkdiv div_module (
		.clk(clk),
		.rst_n(rst),
		
		.div_clk(divclk)
	
	);
	
	
	// shift registers module
	shift shift_module (
		
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
		in_shift <= data_in;
		start_req <= in_shift && (~data_in)? 1:0;

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


