// -----------------------------------------------------------------------------
// Copyright (c) 2014-2022 All rights reserved
// -----------------------------------------------------------------------------
// Author : 1598491517@qq.com
// File   : Handshakes_delay_Ready.v
// Create : 2022-06-09 15:37:03
// Revise : 2022-06-10 14:11:04
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------

module Handshakes_delay_Ready #
(
	parameter	WORD_WIDTH = 32

)
(
	input	wire						clk,
	input	wire						rst_n,
	input	wire						up_valid,
	input	wire	[WORD_WIDTH-1:0]	up_data,
	input	wire						down_ready,
	output	wire						down_valid,
	output	wire	[WORD_WIDTH-1:0]	down_data,
	output	wire						up_ready
);

reg						reg_fill;
reg 					buf_valid;
reg	[WORD_WIDTH-1:0]	buf_data;
reg						buf_ready;				
//缓存Data和valid的主要作用是为了防止气泡！假设不缓存，valid和ready同时有效，destination端读取第一个数完成，
//sourse端还在等延后一拍的ready_delay，它认为没有建立握手，所以它仍然保持之前的值不变，
//这会导致 destination 紧接着的第二拍又读取重复的值

always@(posedge clk)begin
	if(!rst_n)begin
		reg_fill <= 1'b0;
	end
	else if((reg_fill == 1'b0)&&(down_ready == 1'b0)&&(up_valid == 1'b1))begin
		reg_fill <= 1'b1;
	end
	else if(down_ready == 1'b1)begin
		reg_fill <= 1'b0;
	end
	else begin
		reg_fill <= reg_fill;
	end
end

always@(posedge clk)begin
	if(!rst_n)begin
		buf_valid <= 'd0;
	end
	else if((reg_fill == 1'b0)&&(down_ready == 1'b0)&&(up_valid == 1'b1))begin
		buf_valid <= 1'b1;
	end
	else if(down_ready == 1'b1)begin
		buf_valid <= 1'b0;
	end
	else begin
		buf_valid <= buf_valid;
	end
end

always@(posedge clk)begin
	if(!rst_n)begin
		buf_data <= 'd0;
	end
	else if((reg_fill == 1'b0)&&(down_ready == 1'b0)&&(up_valid == 1'b1))begin
		buf_data <= up_data;
	end
	else if(down_ready == 1'b1)begin
		buf_data <= 'd0;
	end
	else begin
		buf_data <= buf_data;
	end
end

assign down_valid = (reg_fill == 1'b1)? buf_valid:up_valid;
assign down_data = (reg_fill == 1'b1)? buf_data:up_data;

always@(posedge clk)begin
	if(!rst_n)begin
		buf_ready <= 1'b0;
	end
	else begin
		buf_ready <= down_ready;
	end
end
assign up_ready = buf_ready|(reg_fill == 1'b0);

endmodule