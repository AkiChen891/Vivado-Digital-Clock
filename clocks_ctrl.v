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
module clocks_ctrl(
	input 			clk_1Hz,		//1Hz输入	
	input			clk_10Hz,		//10Hz输入	
	input			XTAL_OSC,		//100MHz输入	
	input			en,				//暂停信号
	input			mode,			//模式选择
	input 			inc,			//置数信号
    input 			rst,  			//复位信号
    input 			key_flag,		//按键状态
    input 			alarm,			//闹钟设定
	output reg [7:0] hour,			//小时输出
	output reg [7:0] min,			//分钟输出
	output reg [7:0] sec,			//秒输出
	output reg       chime,  		//整点报时标记信号 
    output reg [1:0] state,			//时钟工作状态
    output reg       led,			//显示使能
    output reg [7:0] alarm_hour,	//闹钟的小时位
	output reg [7:0] alarm_min		//闹钟的分钟位
   );
   
reg [1:0]   chime_flag;				//报时状态位
reg [27:0]  cnt_1Hz;				//用于

//定义始终工作状态参数
parameter 	counting=2'b00;	//计时状态
parameter   set_hour=2'b01;	//设置小时
parameter   set_min=2'b10;	//设置分钟

/***主程序段***/


//工作
always@(posedge XTAL_OSC or negedge rst) begin
    if(!rst) begin
        hour <= 8'b0;
        min <= 8'b0;
        sec <= 8'b0;
        cnt_1Hz <= 1'b0;
    end
    else if(state == counting || alarm) begin
        if(cnt_1Hz == 28'd99_999_999) begin 
            cnt_1Hz <= 1'b0;
            if(~en) begin
				if(sec == 8'd59) begin
					sec <= 8'b0;
					if(min == 8'd59) begin
						min <= 8'b0;
						if(hour == 8'd23) hour <= 8'b0;
						else hour <= hour+1'b1;
					end           
					else min <= min+1'b1;
				end  
				else sec <= sec+1'b1;
			end
			else begin
				hour <= hour;
				min <= min;
				sec <= sec;
			end   
		end  
        else cnt_1Hz <= cnt_1Hz+1'b1;
    end           
    else if (state == set_hour&&(~alarm)) begin
        if(key_flag && (~inc)) begin
			sec <= 8'd0;
            if(hour == 8'd23) hour <= 8'b0;
            else hour <= hour+1'b1;
        end
        else hour <= hour;
    end
	else if(state == set_min&&(~alarm)) begin
        if(key_flag && (~inc)) begin
			sec <= 8'd0;
            if(min == 8'd59) min <= 8'b0;
            else min <= min+1'b1;
        end   
        else min <= min;
    end 
end       

//设置切换 
always@(posedge XTAL_OSC or negedge rst) begin
    if(!rst) state <= 2'b0;
    else if(key_flag && (~mode)) begin    
		if(state != set_min ) state <= state+1'b1;
		else state <= counting;
	end
	else state <= state;
end
     
//闹钟设置
always@(posedge XTAL_OSC or negedge rst) begin
    if(!rst) begin
        alarm_hour <= 1'b0;
        alarm_min <= 1'b0;
    end
    else if(state == set_min&&alarm) begin
		if(key_flag && (~inc)) begin
				if(alarm_min == 8'd59) alarm_min <= 8'b0;
				else alarm_min <= alarm_min+1'b1;
		end   
        else alarm_min <= alarm_min;
    end
    else if(state == set_hour && alarm) begin
        if(key_flag && (~inc)) begin
            if(alarm_hour == 8'd23) alarm_hour <= 8'b0;
            else alarm_hour <= alarm_hour+1'b1;
        end
        else alarm_hour <= alarm_hour;
    end
end
 
//闹钟触发
always@(posedge clk_10Hz or negedge rst) begin
    if(!rst) led<=1'b0;
    else if(alarm_hour==hour && alarm_min==min && alarm) led<=1'b1;
    else led<=1'b0;     
end

//整点报时
always@(posedge clk_10Hz or negedge rst) begin
    if(!rst) begin  
		chime <= 1'b0; 
		chime_flag <= 1'b0;
	end
    else if(min==59 && sec>=55) begin
		if(chime_flag == 2'b0) chime <= ~chime;
		else chime_flag <= chime_flag+1'b1;
    end
    else chime <= 1'b0;
end     
endmodule
