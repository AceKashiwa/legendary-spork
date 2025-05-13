module OutputLogic(
    input [2:0] current_state,
    input AnotZero,
    output reg IRload,
    output reg JNZmux,
    output reg PCload,
    output reg INmux,
    output reg Aload,
    output reg OutE
);
    always @(*) begin
        // Default values
        IRload = 0;
        JNZmux = 0;
        PCload = 0;
        INmux = 0;
        Aload = 0;
        OutE = 0;

        case (current_state)
            3'b000: begin // FETCH
                IRload = 1;
                PCload = 1;
            end
            3'b011: begin // EXECUTE_IN
                INmux = 1;
                Aload = 1;
            end
            3'b100: begin // EXECUTE_OUT
                OutE = 1;
            end
            3'b101: begin // EXECUTE_DEC
                Aload = 1;
            end
            3'b110: begin // EXECUTE_JNZ
                PCload = AnotZero ? 1 : 0;
                JNZmux = 1;
            end
            3'b111: begin // HALT
                // No action
            end
        endcase
    end
endmodule