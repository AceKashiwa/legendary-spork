module control_FSM(
    clk, rst,
    N_equal_0, N0_equal_0, Count_equal_4,
    NMUX, CountMUX, NLoad, CountLoad, OutputMUX, OE
    );

    input clk, rst;
    input N_equal_0, N0_equal_0, Count_equal_4;
    output reg NMUX, CountMUX, NLoad, CountLoad, OutputMUX, OE;

    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;

    reg [2:0] state, next_state;
    always @(*) begin
        case (state)
            S0: begin
                next_state = S1;
            end
            S1: begin
                if (!N_equal_0) begin
                    if (!N0_equal_0) begin
                        next_state = S2;
                    end else begin
                        next_state = S3;
                    end
                end else begin
                    if (!Count_equal_4) begin
                        next_state = S4;
                    end else begin
                        next_state = S5;
                    end
                end
            end
            S2: begin
                next_state = S3;
            end
            S3: begin
                next_state = S1;
            end
            S4: begin
                next_state = S4;
            end
            S5: begin
                next_state = S5;
            end
            default:
                next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (rst) state = 0;
        else state = next_state;
    end

    always @(*) begin
        case (state)
            S0: begin
                NMUX = 1;
                CountMUX = 1;
                NLoad = 1;
                CountLoad = 1;
                OE = 0;
            end
            S1: begin
                NLoad = 0;
                CountLoad = 0;
                OE = 0;
            end
            S2: begin
                CountMUX = 0;
                NLoad = 0;
                CountLoad = 1;
                OE = 0;
            end
            S3: begin
                NMUX = 0;
                NLoad = 1;
                CountLoad = 0;
                OE = 0;
            end
            S4: begin
                NLoad = 0;
                CountLoad = 0;
                OutputMUX = 0;
                OE = 1;
            end
            S5: begin
                NLoad = 0;
                CountLoad = 0;
                OutputMUX = 1;
                OE = 1;
            end
            default: begin
                NMUX = 1;
                CountMUX = 1;
                NLoad = 1;
                CountLoad = 1;
                OutputMUX = 0;
                OE = 0;
            end
        endcase
    end
endmodule