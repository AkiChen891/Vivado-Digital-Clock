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
module clocks(
	input			XTAL_OSC,
	input			en,			//暂停信号
	input			mode,		//模式选择
	input			inc,		//置数信号
    input			rst, 		//复位信号
    input			alarm, 		//闹钟信号
    output [5:0] 	sel ,       //数码管位选
    output [7:0] 	seg_l,      //低位数码管段选
	output [7:0] 	seg_h,		//高位数码管段选
    output       	led         //数码管通电状态
    );
	
wire clk_1Hz;
wire clk_1KHz;
wire clk_10Hz;
wire key_flag;
wire inc_out;
wire mode_out;

wire [7:0] hour;
wire [7:0] min;
wire [7:0] sec;
wire [7:0] alarm_hour;
wire [7:0] alarm_min;
wire chime;
wire [1:0]state;   

 clkdiv my_clkdiv(
    .XTAL_OSC    (XTAL_OSC),
    .clk_1Hz     (clk_1Hz),
    .clk_1KHz    (clk_1KHz),
    .clk_10Hz    (clk_10Hz),
    .rst         (~rst)
);   

clocks_ctrl my_clocks_ctrl(
    .clk_1Hz     (clk_1Hz),
    .clk_10Hz    (clk_10Hz),
    .XTAL_OSC    (XTAL_OSC),
    .key_flag    (key_flag),
    .en          (en),
    .mode        (mode_out),
    .inc         (inc_out),
    .rst         (~rst),
    .hour        (hour),
    .min         (min),
    .sec         (sec),
    .state       (state), 
    .chime       (chime),
    .alarm       (alarm),
    .led         (led),
    .alarm_hour  (alarm_hour),
    .alarm_min   (alarm_min)   
);

led my_led(
    .clk_1KHz    (clk_1KHz),
    .clk_1Hz     (clk_1Hz),
    .rst         (~rst),
    .state       (state),
    .hour        (hour),
    .min         (min),
    .sec         (sec),
    .chime       (chime),
    .sel         (sel),
    .seg_h       (seg_h),
    .alarm_hour  (alarm_hour),
    .alarm_min   (alarm_min),
    .alarm       (alarm),
    .seg_l       (seg_l)
);

key_debounce my_key_debounce(
    .XTAL_OSC    (XTAL_OSC),
    .rst         (~rst),
    .inc         (~inc),
    .mode        (~mode),
    .key_flag    (key_flag),
    .mode_out    (mode_out),
    .inc_out     (inc_out)
);
endmodule


