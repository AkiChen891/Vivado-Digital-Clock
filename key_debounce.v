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
    input		XTAL_OSC,			//���þ���@100MHz
    input		rst,				//�ⲿ��λ�źţ�����Ч 
	input		mode,				//ģʽѡ��
	input		inc,				//�����ź�
	
    output reg  key_flag,			//����������Ч�ź�
	output reg  mode_out,			//��������������� 
	output reg  inc_out				//���������������      
    );

reg [31:0] delay_cnt;
reg        mode_reg;
reg        inc_reg;

/***�������***/

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
		//һ����⵽�а��������»��ͷ�,�����ʱ����������װ�س�ʼֵ
		else if(inc_reg==inc && mode_reg==mode) begin  //�ڰ���״̬�ȶ�ʱ���������ݼ�������20ms
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
        if(delay_cnt == 32'd1) begin   //��������ֵ��1ʱ��˵������״̬ά����20ms
            key_flag <= 1'b1;         //����������д�밴����־λ
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