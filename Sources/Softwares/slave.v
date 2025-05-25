`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 14:25:52
// Design Name: 
// Module Name: slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module slave_fsm (
    input clk,          // ʱ���ź�
    input reset,        // �첽��λ�źţ��ߵ�ƽ��Ч��
    input alarm_recv,   // ���������źţ�����״̬ת����
    input caught,       // �����źţ��������壩
    output reg [1:0] state_out // ��ǰ״̬���
);

    parameter RESET      = 2'b00;  // ��λ״̬
    parameter FAST_SLAVE = 2'b01;  // ������Ӧ״̬
    parameter STOP       = 2'b10;  // ֹͣ״̬

    reg [1:0] current_state, next_state;

    // ״̬�Ĵ������£�ʱ���߼���
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= RESET;  // �첽��λ
        else 
            current_state <= next_state;  // ״̬ת��
    end

    // ״̬ת���߼�������߼���
    always @(*) begin
        // Ĭ�ϱ��ֵ�ǰ״̬
        next_state = current_state;  
        
        case (current_state)
            RESET:
                // �յ������ź�ʱ���������Ӧ״̬
                if (alarm_recv) 
                    next_state = FAST_SLAVE;
            
            FAST_SLAVE:
                // ������ʧ���յ������ź�ʱ����ֹͣ״̬
                if (!alarm_recv || caught) 
                    next_state = STOP;
            
            STOP: 
                // ֹͣ״̬���֣���Ҫ��λ�����˳�
                next_state = STOP;
                
            default:
                next_state = RESET;  // �쳣����ص���λ״̬
        endcase
    end

    // ״̬���������߼���
    always @(*) begin
        state_out = current_state;
    end

endmodule
