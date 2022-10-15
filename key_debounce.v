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


module key_debounce(
    input		XTAL_OSC,			//外置晶振@100MHz
    input		rst,				//外部复位信号，低有效 
	input		mode,				//模式选择
	input		inc,				//置数信号
	
    output reg  key_flag,			//按键数据有效信号
	output reg  mode_out,			//按键消抖后的数据 
	output reg  inc_out				//按键消抖后的数据      
    );

reg [31:0] delay_cnt;
reg        mode_reg;
reg        inc_reg;

/***主程序段***/

always @(posedge XTAL_OSC or negedge rst) begin 
    if (!rst) begin 
		mode_reg <= 1'b1;
		inc_reg <= 1'b1;
		delay_cnt <= 32'd0;
	end
    else begin
        inc_reg <= inc;
        mode_reg <= mode;
        if(inc_reg!=inc || mode_reg!=mode) delay_cnt <= 32'd1_000_000; 
		//一旦检测到有按键被按下或释放,便给延时计数器重新装载初始值
		else if(inc_reg==inc && mode_reg==mode) begin  //在按键状态稳定时，计数器递减，持续20ms
            if(delay_cnt > 32'd0) delay_cnt <= delay_cnt-1'b1;
			else delay_cnt <= delay_cnt;
        end           
    end   
end

always @(posedge XTAL_OSC or negedge rst) begin 
    if (!rst) begin 
		key_flag <= 1'b0;
		mode_out <= 1'b1;
		inc_out <= 1'b1;
    end
    else begin
        if(delay_cnt == 32'd1) begin   //当计数器值到1时，说明按键状态维持了20ms
            key_flag <= 1'b1;         //消抖结束，写入按键标志位
            mode_out <= mode;
            inc_out <= inc;
        end
        else begin
            key_flag <= 1'b0;
            mode_out <= mode_out;
            inc_out <= inc_out;
        end  
    end   
end
    
endmodule 