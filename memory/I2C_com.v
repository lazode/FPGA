/*************************************
	
			I2C master


**************************************/


module I2C_com(
	
	output SCL,
	inout SDA,
	
	output[7:0]rx_data,
	input [7:0]tx_data,
	input [7:0]addr,
	
	input RW,
	input EN,
		
	input clk,
	input rst_n

);

		
reg [7:0] data;
reg [7:0] buffer;

reg RW_r;

reg tx_r;
reg SCL;
reg SDA;

reg ACK;

reg [2:0] state;
reg start_req;
reg stop_req;

wire idle_w;

parameter IDLE     = 0;
parameter START    = 1;
parameter TRANSFER = 2;
parameter STOP     = 3;


assign RW = RW_r;
assign idle_w = ((SDA == 1'b1) && (SCL == 1'b1)) ? 1:0;

/***********************

		start signal

***********************/

always @(posedge clk or negedge rst_n) begin
  
  if (!rst_n) begin
		
		SCL  <= 1'b1;
		SDA  <= 1'b1;
			
		data <= 8'd0;
		RW_r <= 1'b0;
		tx_r <= 1'b0;
  end
  
  else if(EN) begin
		SCL  <= 1'b0;
		
  end

end



/*****************************
	state machine

*****************************/

//state jump condition

always @(posedge clk) begin
	if ()
	
end


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		
		
	end
	
	else if (EN) begin
		
		
		
	end
end



// state jump.

always @(posedge clk or negedge rst_n)	begin
	
	if(!rst_n)	begin
		state <= IDLE;
		
	end
	
	else if (EN) begin
		
		case (state)
			
			IDLE:		begin
							
							if (start_req)
								state <= START;
							else if(idle_w && )
								state <= IDLE;
						end
			
			START:	begin
							
							state <= TRANSFER;
							
						end
			
			TRANSFER:begin
			
							if (stop_req)
								state <= STOP;
				
						end
			
			STOP:		begin							
							state <= IDLE;
							
						end
		
		endcase
		
	end

end


// state change action
always @(posedge clk or negedge rst_n)	begin
	
	if(!rst_n)	begin
		
	end
	
	else begin
		
		case (state)
			
			IDLE:		begin
							if (start_req)
								
							else	begin
								SDA <= 1'b1;
								SCL <= 1'b1;
							end
						end
			
			TRANSFER:begin
							if (stop_req)
								SDA 
							
						end
			
			STOP:		begin
							if (start_req)
								
							else	begin
								SDA <= 1'b1;
								SCL <= 1'b1;

							end
						end
		
		endcase
	end

end
	
endmodule		
