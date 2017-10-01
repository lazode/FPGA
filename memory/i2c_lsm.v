
module i2c_lsm(
	
	output SCL,
	inout SDA,
	
	output[7:0]rx,
	input [7:0]tx,
	input [7:0]addr_device_w,
	input [7:0]addr_reg_w,
	
	output DONE,
	input RW,
	input EN,
		
	input clk,
	input rst_n

);



reg [7:0] rx_data;
reg [7:0] tx_data;

reg [7:0] addr_device;
reg [7:0] addr_reg;
reg [7:0] buffer;
reg [8:0] cnt;

reg RW_r;
reg DONE_r;

reg tx_r;
reg SCL_r;
reg SDA_r;

reg dev_reg;
reg ACK;
reg nACK;

reg [7:0] state_cnt;
reg [2:0] reg_cnt; 

assign rx  = rx_data;


assign DONE= DONE_r;
assign SDA = SDA_r;
assign SCL = SCL_r; 

//assign RW = RW_r;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		RW_r <= 0;
		addr_device <= 8'd0;
		addr_reg <= 8'd0;
		tx_data <= 8'd0;
	end
	else begin
		RW_r <= RW;
		addr_device <= addr_device_w;
		addr_reg <= addr_reg_w;
		tx_data <= tx;
	end
end
	

always @(posedge clk or negedge rst_n) begin
	
	if(!rst_n) begin
		
		SDA_r  <= 1;
		SCL_r  <= 1;
		
	  buffer<= 0;
		
	reg_cnt <= 0;
		cnt  <= 0;
		DONE_r <= 0;
		tx_r <= 0;
		ACK  <= 0;
		nACK <= 0;
		
	end
	else begin
		if(EN) begin
			
			case (state_cnt)
				
				0:	begin	//start signal.
					
						SCL_r <= 1;
						SDA_r <= 1;
						
						if (cnt == 100)
							SDA_r <= 1;
						else if (cnt == 300)
							SDA_r <= 0; 
						
						if (cnt == 100) 
							SCL_r <= 1;
						else if ( cnt == 400) begin						
							SCL_r <= 0;
							cnt <= 9'd0;
							state_cnt <= state_cnt + 8'd1;
						end
						else 
							cnt <= cnt + 9'd1;
					
					end
				
				1: begin	//write device address to buffer.
						
						buffer <= addr_device;
						state_cnt <= 8'd6; // send buffer to slave
						dev_reg <= 1;      // addr of device or register
					end
					
				2: begin //write register address to buffer.
						buffer <= addr_reg; 
						state_cnt <= 8'd6; // send buffer to slave
						dev_reg <= 0; 		 // addr of device or register  &addr = dev_reg? device: register
					end
				
				3: begin //read data from slave 
						SCL_r <= 0;
						SDA_r <= 1'bz;
						
						if (cnt == 100) begin
							SCL_r <= 1;
						end
						else if (cnt == 200) begin							
							rx_data[7 - reg_cnt] <= SDA;
							reg_cnt <= reg_cnt + 1;
						end
						else if (cnt == 300) begin
							SCL_r <= 0;
							cnt <= 9'd0;
						end
						
						if (cnt == 300) begin
							
							if (reg_cnt == 7) begin
								reg_cnt <= 8'd0;
								state_cnt <= state_cnt + 8'd1;
							end
							else begin
								cnt <= cnt + 9'd1;
							end
						end
						
					end
									
				4: begin // send a ack signal.
						SCL_r <= 0;
						SDA_r <= 1;
						
						if (cnt == 100) begin
							SDA_r <= 0;
						end
						else if (cnt == 200) begin
							SCL_r <= 1;
						end
						else if (cnt == 300) begin
							SCL_r <= 0;
							SDA_r <= 1'bz;							
						end	
						
						if (cnt == 300) begin
							cnt <= 9'd0;
							state_cnt <= 8'd10;
						end
					
					end
				
				5: begin // or go to next state 
						if (dev_reg)
							state_cnt <= 8'd2;
						else
							state_cnt <= state_cnt + 1;					
					end
			
				6: begin	//write the buffer to slave.
						SCL_r <= 0;
						
						if (cnt == 100) begin
							SDA_r <= buffer[7 - reg_cnt];
						end
						else if (cnt == 200) begin
							SCL_r <= 1; 							
							reg_cnt <= reg_cnt + 1;
						end
						else if (cnt == 300) begin
							SCL_r <= 0;
							cnt <= 9'd0;
						end
						
						
						if (cnt == 300) begin
						
							if (reg_cnt == 7) begin
								reg_cnt <= 3'd0;
								state_cnt <= 8'd7; //to get the ack or nack.
							end
							else begin
								cnt <= cnt + 9'd1;
							end
						end
						
					end

				
				7: begin //read ack or nack
						SDA_r <= 1'bz;
						SCL_r <= 0;
						
						if (cnt == 200) begin
							if(SDA) begin
								nACK <= 1;
								state_cnt <= 4'd0;	//no ACK restart the communication
							end
							else begin
								ACK  <= 1;
								state_cnt <= state_cnt + 1;
							end
						end 
						
						if (cnt == 100)
							SCL_r <= 1;
						else if (cnt == 300) begin
							SCL_r <= 0;
							cnt   <= 9'd0;
						end
						
						if (cnt == 300) 
							cnt <= 9'd0;
						else begin
							cnt <= cnt + 9'd1;
						end
						
					end
					
				8: begin
						if (dev_reg) 
							state_cnt <= 8'd2;
						else
							state_cnt <= state_cnt + 1;
						
					end
				
				9: begin
						if (RW_r) begin
							buffer <= tx_data;
							state_cnt <= 8'd4;
							
						end
						else begin
							 state_cnt <= 8'd3;
						end
						
					end
				
				10: begin //i2c stop
						SCL_r <= 0;
						
						if (cnt == 100) begin
							SCL_r <= 0;
							SDA_r <= 0;
						end
						else if (cnt == 200) begin
							SCL_r <= 1;
						end
						else if (cnt == 300)
							SDA_r <= 1;
						
					 end
	
			endcase
		end	
	end
end

endmodule


