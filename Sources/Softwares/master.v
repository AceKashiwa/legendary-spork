module master_fsm (
    input clk,                // ʱ���ź�
    input reset,              // ��λ�źţ��ߵ�ƽ��Ч��
    input [1:0] data_in,      // 2-bit �����ź�
    input time_eq_settime,    // ʱ������趨ʱ���־
    input selfcaught,         // �Բ����־
    input stop,              // ֹͣ��־
    input caught,             // �����־
    input time_ge_ddl,        // ʱ�䳬����ֹʱ���־
    output reg [2:0] state_out, // ��ǰ״̬�������ã�
    output reg [7:0] win_counter,  // 8-bit ʤ����������0~255��
    output reg [7:0] lose_counter  // 8-bit ʧ�ܼ�������0~255��
);

    // ״̬����
    parameter RESET       = 3'b000; // ��λ״̬
    parameter TIM         = 3'b001; // ��ʼ״̬
    parameter TASK_MASTER = 3'b010; // ����ִ��״̬
    parameter CAUGHT      = 3'b011; // ������״̬
    parameter STOP        = 3'b100; // �������״̬
    parameter FAILED      = 3'b101; // ����ʧ��״̬

    reg [2:0] current_state, next_state; // ��ǰ״̬����һ״̬
    reg win_pulse, lose_pulse;           // �����źţ�����������������

    // ״̬�Ĵ�������
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RESET;
            win_counter <= 8'd0;    // ��λʱ����
            lose_counter <= 8'd0;
        end else begin
            current_state <= next_state;
            
            // ʤ������������� win_pulse �����أ�
            if (win_pulse) begin
                if (win_counter < 8'd255) // ��ֹ���
                    win_counter <= win_counter + 1;
            end
            
            // ʧ�ܼ���������� lose_pulse �����أ�
            if (lose_pulse) begin
                if (lose_counter < 8'd255) // ��ֹ���
                    lose_counter <= lose_counter + 1;
            end
        end
    end

    // ״̬ת���߼�
    always @(*) begin
        next_state = current_state; // Ĭ�ϱ��ֵ�ǰ״̬
        win_pulse = 0;
        lose_pulse = 0;

        case (current_state)
            RESET:
                if (data_in == 2'b01) next_state = TIM;
            
            TIM:
                if (time_eq_settime) begin
                    next_state = TASK_MASTER;
                end else if (selfcaught == 0 && time_ge_ddl) begin
                    next_state = FAILED;
                    lose_pulse = 1; // ����ʧ�ܼ�����
                end
            
            TASK_MASTER:
                if (caught) begin
                    next_state = CAUGHT;
                end else if (stop) begin
                    next_state = STOP;
                    win_pulse = 1; // ����ʤ��������
                end
            
            CAUGHT:
                if (caught == 0) begin
                    if (stop) begin
                        next_state = STOP;
                        win_pulse = 1;
                    end else begin
                        next_state = TASK_MASTER;
                    end
                end
            
            STOP:
                if (data_in == 2'b01) next_state = TIM;
            
            FAILED:
                if (data_in == 2'b01) next_state = TIM;
        endcase
    end

    // ״̬����������ã�
    always @(*) begin
        state_out = current_state;
    end

endmodule
