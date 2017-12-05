`timescale 1ns/1ps


module ads1293(
	
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

parameter DATA_CONV_START_ADDR = 16'h00;

parameter FLEX_CH1_CN_ADDR  = 16'h01;
parameter FLEX_CH2_CN_ADDR  = 16'h02; 
parameter FLEX_CH3_CN_ADDR  = 16'h03;
parameter FLEX_PACE_CN_ADDR = 16'h04;
//parameter FLEX_VBAT_CN_ADDR = 16'h05;

parameter LOD_CN_ADDR = 16'h06;
parameter LOD_EN_ADDR = 16'h07;
parameter LOD_CURRENT_ADDR = 16'h08;

parameter REF_CN_ADDR  = 16'h11;
parameter OSC_CN_ADDR  = 16'h12;

parameter AFE_RES_ADDR = 16'h13;
//parameter AFE_SHDN_CN = 16'h14; 
parameter AFE_FAULT_CN_ADDR = 16'h15;
parameter AFE_PACE_CN_ADDR = 16'h17;
parameter ERROR_LOD_ADDR = 16'h18;
parameter ERROR_STATUS_ADDR = 16'h19;


parameter DIGO_STRENGTH_ADDR = 16'h1F;
parameter R2_RATE_ADDR = 16'h21;
parameter R3_RATE_CH1_ADDR = 16'h22;
parameter R3_RATE_CH2_ADDR = 16'h23;
parameter R3_RATE_CH3_ADDR = 16'h24;
parameter R1_RATE_ADDR = 16'h25;
parameter DIS_EFILTER_ADDR = 16'h26;
parameter DRDYB_SRC_ADDR = 16'h27;
parameter SYNCB_CN_ADDR = 16'h28;
parameter MASK_DRDYB_ADDR = 16'h29;

parameter CH_CNFG_ADDR = 16'h2F;
parameter DATA_STATUS_ADDR = 16'h30;

parameter DATA_CH1_PACE_U_ADDR = 16'h31;
parameter DATA_CH1_PACE_L_ADDR = 16'h32;

parameter DATA_CH2_PACE_U_ADDR = 16'h33;
parameter DATA_CH2_PACE_L_ADDR = 16'h34;

parameter DATA_CH3_PACE_U_ADDR = 16'h35;
parameter DATA_CH3_PACE_L_ADDR = 16'h36;

parameter DATA_CH1_ECG_U_ADDR = 16'h37;
parameter DATA_CH1_ECG_M_ADDR = 16'h38;
parameter DATA_CH1_ECG_L_ADDR = 16'h39;

parameter DATA_CH2_ECG_U_ADDR = 16'h3A;
parameter DATA_CH2_ECG_M_ADDR = 16'h3B;
parameter DATA_CH2_ECG_L_ADDR = 16'h3C;

parameter DATA_CH3_ECG_U_ADDR = 16'h3D;
parameter DATA_CH3_ECG_M_ADDR = 16'h3E;
parameter DATA_CH3_ECG_L_ADDR = 16'h3F;

parameter DATA_LOOP_ADDR = 16'h50;





input clk;
input rst_n;
input en;

input miso;

output mosi;
output cs;
output sck;

output done;
output [7:0] data_out;

reg spi_done_buff;
reg [7:0] data_out;



wire [7:0] spi_data;

reg spi_en;
reg spi_RW;
reg [6:0] addr;
reg [7:0] data;
wire cs;
wire mosi;


wire spi_done;

wire spi_done_failing;

assign spi_done_failing = (spi_done_buff && !spi_done)? 1: 0;

always @(posedge clk) 
	spi_done_buff <= spi_done;


spi spi_driver(
	.clk(clk),
	.rst_n(rst_n),
	.en(spi_en),
	.RW(spi_RW),
	
	.addr_in(addr),
	.data_in(data),
	
	.miso(miso),
	.mosi(mosi),	
	.cs(cs),
	.sck(sck),
	
	.done(spi_done)
);



// `include "ads1293.h"
localparam FLEX_CH1_CN_VALUE = 8'b00_010_011;
localparam FLEX_CH2_CN_VALUE = 8'b00_101_110;

localparam LOD_CN_VALUE = 8'b000_0_0_0_00;
localparam LOD_EN_VALUE = 8'b00_000000;
localparam REF_CN_VALUE = 8'b000000_00;
localparam OSC_CN_VALUE = 8'b00000_100;

localparam AFE_RES_VALUE = 8'b00_111_111;

// localparam AFE_SHDN_CN_VALUE = 8'b00000000;				/*default*/
// localparam AFE_FAULT_CN_VALUE = 8'b0000_0000;			/*default*/
// localparam AFE_PACE_CN_VALUE = 8'b0000_0000;				/*default*/
// localparam ERROR_LOD_VALUE = 8'b0000_0000;				/*read*/ 
// localparam ERROR_STATUS_VALUE = 8'b0000_0000; 			/*read*/


// localparam DIGO_STRENGTH_VALUE = 8'b000000_11;			/*default*/

// localparam R2_RATE_VALUE = 8'b0000_0000;

// localparam R3_RATE_CH1_VALUE = 8'b0000_0000;			/*max rate- default value*/
// localparam R3_RATE_CH2_VALUE = 8'b0000_0000;	
// localparam R3_RATE_CH3_VALUE = 8'b0000_0000;

// localparam R1_RATE_VALUE = 8'b0000_0000;

// localparam DIS_EFILTER_VALUE = 8'b00000_000;				/*default*/
localparam DRDYB_SRC_VALUE = 8'b00_000001;
// localparam SYNCB_CN_VALUE = 8'b0000_0000;				/*not use*/

//----!!!-------------------
// localparam MASK_DRDYB_VALUE = 8'b0000_0000;		


/*MASK?   ->  Write RTL code -> simulation -> Test on board*/


localparam CH_CNFG_VALUE = 8'b0_000_011_0;
// localparam DATA_STATUS_VALUE = 8'b0000_0000;				/*read*/

// localparam DATA_CH1_PACE_U_VALUE = 8'b0000_0000;
// localparam DATA_CH1_PACE_L_VALUE = 8'b0000_0000;

// localparam DATA_CH2_PACE_U_VALUE = 8'b0000_0000;
// localparam DATA_CH2_PACE_L_VALUE = 8'b0000_0000;

// localparam DATA_CH3_PACE_U_VALUE = 8'b0000_0000;
// localparam DATA_CH3_PACE_L_VALUE = 8'b0000_0000;			/*---read---*/

// localparam DATA_CH1_ECG_U_VALUE = 8'b0000_0000;
// localparam DATA_CH1_ECG_M_VALUE = 8'b0000_0000;
// localparam DATA_CH1_ECG_L_VALUE = 8'b0000_0000;

// localparam DATA_CH2_ECG_U_VALUE = 8'b0000_0000;
// localparam DATA_CH2_ECG_M_VALUE = 8'b0000_0000;
// localparam DATA_CH2_ECG_L_VALUE = 8'b0000_0000;

// localparam DATA_CH3_ECG_U_VALUE = 8'b0000_0000;
// localparam DATA_CH3_ECG_M_VALUE = 8'b0000_0000;
// localparam DATA_CH3_ECG_L_VALUE = 8'b0000_0000;

// localparam DATA_LOOP_VALUE = 8'b0000_0000;

localparam DATA_CONV_START = 8'b0000_0001;

reg dataRDY;
reg [15:0] data_ch1_pace;
reg [15:0] data_ch2_pace;

reg [23:0] data_ch1_ECG;
reg [23:0] data_ch2_ECG;

reg [7:0] counter;


// always @(posedge clk or negedge rst_n) begin
// 	if (!rst_n) begin
// 		// reset
// 		dataRDY <= 1'b0;		
// 	end
// 	else if () begin
		
// 	end
// end

localparam READ  = 1'b1;
localparam WRITE = 1'b0;

always @(posedge clk or negedge rst_n) begin
	
	if (!rst_n) begin
//		data_out <= 8'd0;
		data_ch1_pace <= 16'd0;

		counter <= 8'd0;
		
		spi_en <= 1'b0;
	end
	else if (!en) begin
		counter <= 8'd0;
	end
	else begin
		case (counter)
			0: begin
				// stop the data conversion to enable access registers
				spi_en <= 1'b1;
				
				spi_RW <= WRITE;
				addr <= DATA_CONV_START_ADDR;
				data <= 8'd0;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;
			end

			1: begin
				spi_RW <= WRITE;
				addr <= FLEX_CH1_CN_ADDR;
				data <= FLEX_CH1_CN_VALUE;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;
			end
			
			2: begin
				spi_RW <= WRITE;
				addr <= FLEX_CH2_CN_ADDR;
				data <= FLEX_CH2_CN_VALUE;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;					
			end
			
			3: begin
				spi_RW <= WRITE;
				addr <= LOD_CN_ADDR;
				data <= LOD_CN_VALUE;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;
				
			end
			
			4: begin
				spi_RW <= WRITE;
				addr <= REF_CN_ADDR;
				data <= REF_CN_VALUE;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;
			end
			
			5: begin
				spi_RW <= WRITE;
				addr <= AFE_RES_ADDR;
				data <= AFE_RES_VALUE;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;
			end
			
			6: begin
				spi_RW <= WRITE;
				addr <= DRDYB_SRC_ADDR;
				data <= DRDYB_SRC_VALUE;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;

			end

			7: begin
				spi_RW <= WRITE;
				addr <= CH_CNFG_ADDR;
				data <= CH_CNFG_VALUE;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;				
			end

			// start data conversion.
			8: begin
				spi_RW <= WRITE;
				addr <= DATA_CONV_START_ADDR;
				data <= DATA_CONV_START;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;
			end

			// recieve data 
			9: begin
				spi_RW <= READ;
				addr <= DATA_CH1_PACE_U_ADDR;
				data_ch1_pace[15:8] <= data_out;
				
				if (spi_done_failing == 1'b1)
					counter <= counter + 8'd1;
			end

			10: begin
				spi_RW <= READ;
				addr <= DATA_CH1_PACE_L_ADDR; 
				data_ch1_pace[7:0] <= data_out;
			end

		endcase
	
	end
	
end


endmodule

