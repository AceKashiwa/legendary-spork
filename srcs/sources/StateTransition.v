module FSM(
    input [2:0] current_state,
    input [2:0] IR,
    input AnotZero,
    output reg [2:0] next_state
);
    parameter FETCH = 3'b000,
              DECODE = 3'b001,
              EXECUTE_IN = 3'b011,
              EXECUTE_OUT = 3'b100,
              EXECUTE_DEC = 3'b101,
              EXECUTE_JNZ = 3'b110,
              HALT = 3'b111;

    always @(*) begin
        case (current_state)
            FETCH: next_state = DECODE;
            DECODE: next_state = IR > 3'b010 ? IR : FETCH;
            HALT: next_state = HALT;
            default: next_state = FETCH;
        endcase
    end
endmodule