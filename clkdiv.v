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
module clkdiv(
input       XTAL_OSC,	//���þ���@100MHz
output reg  clk_1Hz,	//1Hz���
output reg  clk_10Hz,	//10Hz���
output reg  clk_1KHz,	//1KHz���
input       rst			//��λ�ź�
);

reg [27:0]  cnt_1Hz;//1Hz��Ƶ������
reg [27:0]  cnt_10Hz;//10Hz��Ƶ������
reg [27:0]  cnt_1KHz;//1KHz��Ƶ������

/***�������***/

//1Hz
always@(posedge XTAL_OSC or negedge rst) begin
	if(!rst) begin
			cnt_1Hz <= 28'd0;
			clk_1Hz <= 1'd0;
		end
	else if (cnt_1Hz == 28'd49_999_999) begin
			cnt_1Hz <= 28'd0;
			clk_1Hz <= ~clk_1Hz;
		end
	else cnt_1Hz <= cnt_1Hz+1'b1;
end

//10Hz
always@(posedge XTAL_OSC or negedge rst)
begin
	if(!rst) begin
			cnt_10Hz <= 28'd0;
			clk_10Hz <= 1'd0;
		end
	else if (cnt_10Hz == 28'd4_999_999 ) begin
			cnt_10Hz <= 28'd0;
			clk_10Hz <= ~clk_10Hz;
		end
	else cnt_10Hz  <= cnt_10Hz + 1'b1;
end

//1KHz
always@(posedge XTAL_OSC or negedge rst) begin
	if(!rst) begin
			cnt_1KHz <= 28'd0;
			clk_1KHz <= 1'd0;
		end
	else if (cnt_1KHz == 28'd49_999 ) begin
			cnt_1KHz <= 28'd0;
			clk_1KHz <= ~clk_1KHz;
		end
	else cnt_1KHz  <= cnt_1KHz+1'b1;
end

endmodule