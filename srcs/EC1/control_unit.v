module control_unit(
    input clk, Reset,
    input [2:0] IR,
    input AnotZero,
    output reg IRload, JNZmux, PCload, INmux, Aload, OutE,
    output H
);

    reg [2:0] current_state, next_state;
    parameter FETCH = 3'b000, DECODE = 3'b001, IN = 3'b011, OUT = 3'b100, DEC = 3'b101, JNZ = 3'b110, HALT = 3'b111;

    // Next-state logic
    always @(*) begin
        case (current_state)
            FETCH: next_state = DECODE;
            DECODE: begin
                case (IR)
                    IN, OUT, DEC, JNZ, HALT: next_state = IR;
                    default: next_state = FETCH;
                endcase
            end
            IN, OUT, DEC, JNZ: next_state = FETCH;
            HALT: next_state = HALT;
            default: next_state = FETCH;
        endcase
    end

    always @(posedge clk or posedge Reset) begin
        if (Reset)
            current_state <= FETCH;
        else
            current_state <= next_state;
    end

    // Output logic
    always @(*) begin
        IRload = 0;
        JNZmux = 0;
        PCload = 0;
        INmux = 0;
        Aload = 0;
        OutE = 0;
        case (current_state)
            FETCH: begin 
                IRload = 1; 
                PCload = 1; 
            end
            IN: begin 
                INmux = 1; 
                Aload = 1; 
            end
            OUT: begin 
                OutE = 1; 
            end
            DEC: begin 
                Aload = 1; 
            end
            JNZ: begin 
                JNZmux = 1; 
                PCload = AnotZero ? 1 : 0; 
            end
        endcase
    end

    assign H = (current_state == HALT);
endmodule