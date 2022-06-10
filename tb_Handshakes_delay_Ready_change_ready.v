// -----------------------------------------------------------------------------
// Copyright (c) 2014-2022 All rights reserved
// -----------------------------------------------------------------------------
// Author : 1598491517@qq.com
// File   : tb_Handshakes_delay_Ready_change_ready.v
// Create : 2022-06-09 16:34:58
// Revise : 2022-06-10 22:49:51
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module tb_Handshakes_delay_Ready();
reg clk;
reg rst_n;
reg up_valid;
reg [7:0] up_data;
reg down_ready;
wire down_valid;
wire [7:0]down_data;
wire up_ready;

initial begin
	clk = 1'b0;
	rst_n = 1'b0;
	up_valid = 1'b0;
	up_data = 'd0;
	down_ready = 1'b0;
	#35
	rst_n = 1'b1;
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
	#20
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
	#20
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
	#20
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
	#20
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
	#20
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
	#20
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
	#20
	down_ready = 1'b0;
	#20
	down_ready = 1'b1;
end

always @(posedge clk)begin
	if(!rst_n)begin
		up_data <= 'd0;
		up_valid <= 1'b1;
	end
	else if(up_ready && up_valid)begin
		up_data <= {$random}%256;
		up_valid <= {$random}%2;
	end
	else if (up_valid == 1'b0)begin
		up_data <= {$random}%256;
		up_valid <= {$random}%2;
	end
end


always #10 clk = ~clk;

	Handshakes_delay_Ready #(
			.WORD_WIDTH(8)
		) inst_Handshakes_delay_Ready (
			.clk        (clk),
			.rst_n      (rst_n),
			.up_valid   (up_valid),
			.up_data    (up_data),
			.down_ready (down_ready),
			.down_valid (down_valid),
			.down_data  (down_data),
			.up_ready   (up_ready)
		);


endmodule