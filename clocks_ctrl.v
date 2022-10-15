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
	input 			clk_1Hz,		//1Hz����	
	input			clk_10Hz,		//10Hz����	
	input			XTAL_OSC,		//100MHz����	
	input			en,				//��ͣ�ź�
	input			mode,			//ģʽѡ��
	input 			inc,			//�����ź�
    input 			rst,  			//��λ�ź�
    input 			key_flag,		//����״̬
    input 			alarm,			//�����趨
	output reg [7:0] hour,			//Сʱ���
	output reg [7:0] min,			//�������
	output reg [7:0] sec,			//�����
	output reg       chime,  		//���㱨ʱ����ź� 
    output reg [1:0] state,			//ʱ�ӹ���״̬
    output reg       led,			//��ʾʹ��
    output reg [7:0] alarm_hour,	//���ӵ�Сʱλ
	output reg [7:0] alarm_min		//���ӵķ���λ
   );
   
reg [1:0]   chime_flag;				//��ʱ״̬λ
reg [27:0]  cnt_1Hz;				//����

//����ʼ�չ���״̬����
parameter 	counting=2'b00;	//��ʱ״̬
parameter   set_hour=2'b01;	//����Сʱ
parameter   set_min=2'b10;	//���÷���

/***�������***/


//����
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

//�����л� 
always@(posedge XTAL_OSC or negedge rst) begin
    if(!rst) state <= 2'b0;
    else if(key_flag && (~mode)) begin    
		if(state != set_min ) state <= state+1'b1;
		else state <= counting;
	end
	else state <= state;
end
     
//��������
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
 
//���Ӵ���
always@(posedge clk_10Hz or negedge rst) begin
    if(!rst) led<=1'b0;
    else if(alarm_hour==hour && alarm_min==min && alarm) led<=1'b1;
    else led<=1'b0;     
end

//���㱨ʱ
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
