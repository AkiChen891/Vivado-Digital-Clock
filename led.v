//
// Company: 
// Engineer: Liu Yangguang 		
// Create Date: 
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     
// Dependencies: 
//     
// Revision:
module led(
    input	clk_1KHz,
    input	clk_1Hz,
    input	rst,
    input [1:0]	state,	//显示状态
    input [7:0] hour,
    input [7:0] min,
    input [7:0] sec,	
    input [7:0] alarm_hour,
    input [7:0] alarm_min,
    input	alarm,
    input	chime,
    output reg [5:0] sel,
    output reg [7:0] seg_l,
	output reg [7:0] seg_h
    );
reg [2:0] sel_cnt;	//位选计数器
reg [3:0] data; 	//数据缓存
reg flash_flag;		//数码管闪烁标志位

/***主程序段***/

always@(posedge clk_1KHz or negedge rst) begin
    if(~rst) sel_cnt <= 3'b0;
    else if(sel_cnt == 3'b101) sel_cnt <= 3'b0;
    else sel_cnt <= sel_cnt + 1'b1;
end

always@(posedge clk_1KHz or negedge rst)    begin
    if (~rst) begin
        sel     <=  4'd0;
        data    <=  4'd0;
    end
    else if((~alarm) || (alarm&&(state==2'b00))) begin
		case(sel_cnt)     
			3'b000:
				begin
					sel  <= 6'b000001; 
					data <= sec % 10;
				end
			3'b001:
				begin
					sel  <= 6'b000010;     
					data <= sec / 10;                                     
				end
			3'b010:
				begin
					sel  <= 6'b000100; 
					data <= min % 10;   
				end
			3'b011:
				begin
					sel  <= 6'b001000;
					data <= min / 10;        
				end
			3'b100:
				begin
					sel  <= 6'b010000;
					data <= hour % 10;
				end
			3'b101:
				begin
					sel <=6'b100000;
					data <= hour / 10;   
				end
		endcase        
    end
    else begin
		case(sel_cnt)     
			3'b000:
				begin
					sel  <= 6'b000001; 
					data <=  1'b0;
				end
			3'b001:
				begin
					sel  <= 6'b000010;     
					data <= 1'b0;                                     
				end
			3'b010:
				begin
					sel  <= 6'b000100; 
					data <= alarm_min % 10;   
				end
			3'b011:
				begin
					sel <= 6'b001000;
					data <=alarm_min / 10;        
				end
			3'b100:
				begin
					sel <= 6'b010000;
					data <= alarm_hour % 10;
				end
			3'b101:
				begin
					sel <= 6'b100000;
					data <= alarm_hour / 10;   
				end
		endcase        
    end
end

//
//7段数码管显示计数输出
always @(data) begin	
    if (~rst) begin
        seg_l      <=  8'd0;
		seg_h     <=  8'd0;
    end
    else begin
		case(state)
			2'b00:
				begin
					if(chime) begin
						seg_l  <= 8'b00000000;
						seg_h <= 8'b00000000;
					end
					else begin
						case (data) 
						4'b0000:
							begin
								seg_l <= 8'b11111100; //0
								seg_h <= 8'b11111100; //0 
							end
						4'b0001: 
							begin
								seg_l <= 8'b01100000; //1
								seg_h <= 8'b01100000; //1
							end
						4'b0010:
							begin
								seg_l <= 8'b11011010; //2
								seg_h <= 8'b11011010; //2
								end
						4'b0011:
							begin
								seg_l <= 8'b11110010; //3
								seg_h <= 8'b11110010; //3
							end
						4'b0100:
							begin
								seg_l <= 8'b01100110; //4
								seg_h <= 8'b01100110; //4
							end
						4'b0101: 
							begin
								seg_l <= 8'b10110110; //5
								seg_h <= 8'b10110110; //5
							end
						4'b0110: 
							begin
								seg_l <= 8'b10111110; //6
								seg_h <= 8'b10111110; //6
							end
						4'b0111:
							begin
								seg_l <= 8'b11100000; //7
								seg_h <= 8'b11100000; //7
							end
						4'b1000:
							begin
								seg_l <= 8'b11111110; //8
								seg_h <= 8'b11111110; //8
							end
						4'b1001: 
							begin
								seg_l <= 8'b11110110; //9
								seg_h <= 8'b11110110; //9
							end
						default:
							begin
								seg_l <= 8'b00000000; //默认不发光
								seg_h <= 8'b00000000; //默认不发光
							end
						endcase
					end
				 end
			2'b01:
				begin
					if((sel == 6'b100000 || sel ==6 'b010000)&&flash_flag) begin
						seg_l <= 8'b00000000;
						seg_h <= 8'b00000000;
					end
					else begin
						case (data) 
						4'b0000:
							begin
								seg_l <= 8'b11111100; //0
								seg_h <= 8'b11111100; //0 
							end
						4'b0001: 
						begin
								seg_l <= 8'b01100000; //1
								seg_h <= 8'b01100000; //1
							end
						4'b0010: 
							begin
								seg_l <= 8'b11011010; //2
								seg_h <= 8'b11011010; //2
							end
						4'b0011: 
							begin
								seg_l <= 8'b11110010; //3
								seg_h <= 8'b11110010; //3
							end
						4'b0100:
							begin
								seg_l <= 8'b01100110; //4
								seg_h <= 8'b01100110; //4
							end
						4'b0101: 
							begin
								seg_l <= 8'b10110110; //5
								seg_h <= 8'b10110110; //5
							end
						4'b0110: 
							begin
								seg_l <= 8'b10111110; //6
								seg_h <= 8'b10111110; //6
							end
						4'b0111:
							begin
								seg_l <= 8'b11100000; //7
								seg_h <= 8'b11100000; //7
								end
						4'b1000:
							begin
								seg_l <= 8'b11111110; //8
								seg_h <= 8'b11111110; //8
							end
						4'b1001: 
							begin
								seg_l <= 8'b11110110; //9
								seg_h <= 8'b11110110; //9
							end
						default:
							begin
								seg_l <= 8'b00000000; //默认不发光
								seg_h <= 8'b00000000; //默认不发光
							end
						endcase
					end
				end
			2'b10:
				begin
					if((sel == 6'b000100 || sel ==6 'b001000)&&flash_flag) begin
						seg_l <= 8'b00000000;
						seg_h <= 8'b00000000;
					end
					else begin
						case (data) 
						4'b0000:
							begin
								seg_l <= 8'b11111100; //0
								seg_h <= 8'b11111100; //0 
							end
						4'b0001:
							begin
								seg_l <= 8'b01100000; //1
								seg_h <= 8'b01100000; //1
							end
						4'b0010:
							begin
								seg_l <= 8'b11011010; //2
								seg_h <= 8'b11011010; //2
							end
						4'b0011: 
							begin
								seg_l <= 8'b11110010; //3
								seg_h <= 8'b11110010; //3
							end
						4'b0100:
							begin
								seg_l <= 8'b01100110; //4
								seg_h <= 8'b01100110; //4
							end
						4'b0101: 
							begin
								seg_l <= 8'b10110110; //5
								seg_h <= 8'b10110110; //5
							end
						4'b0110:
							begin
								seg_l <= 8'b10111110; //6
								seg_h <= 8'b10111110; //6
							end
						4'b0111:
							begin
								seg_l <= 8'b11100000; //7
								seg_h <= 8'b11100000; //7
							end
						4'b1000:
							begin
								seg_l <= 8'b11111110; //8
								seg_h <= 8'b11111110; //8
							end
						4'b1001: 
							begin
								seg_l <= 8'b11110110; //9
								seg_h <= 8'b11110110; //9
							end
						default:
							begin
								seg_l <= 8'b00000000; //默认不发光
								seg_h <= 8'b00000000; //默认不发光
							end
							endcase
						end
				end
			2'b11:
				begin
					seg_l <=  8'b00000000;
					seg_h <= 8'b00000000;
				end					
		endcase
	end
end			

//闪烁切换
always @(posedge clk_1Hz or negedge rst) begin
    if(!rst) flash_flag<=1'b0;   
    else flash_flag=~flash_flag;
end

endmodule

