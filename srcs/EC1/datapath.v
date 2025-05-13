module datapath(
    input IRload, JNZmux, PCload, INmux, Aload, Reset, clk, OutE,
    input [7:0] INPUT,
    output [2:0] IR,
    output AnotZero,
    output [7:0] OUTPUT
);
    // 描述A累加器
    wire [7:0] DecOut, Ain, Aout;
    mux2to1 #(.N(8)) Amux(.mux(INmux), .Ina(DecOut), .Inb(INPUT), .out(Ain));
    Register #(.N(8)) Areg(.clk(clk), .load(Aload), .clear(Reset), .loaddata(Ain), .outdata(Aout));
    Decrement #(.N(8)) Adec(.DecInput(Aout), .DecOutput(DecOut));

    // 描述指令ROM
    wire [3:0] PCaddress;
    wire [7:0] instruction;
    InstructionROM ROM(.ina(PCaddress), .out(instruction));

    // 描述指令寄存器
    wire [7:0] reg_instruction;
    Register #(.N(8)) InReg(.clk(clk), .load(IRload), .clear(Reset), .loaddata(instruction), .outdata(reg_instruction));

    // 描述PC寄存器
    wire [3:0] Incout, PCin, PCout;
    mux2to1 #(.N(4)) PCmux(.mux(JNZmux), .Ina(Incout), .Inb(reg_instruction[3:0]), .out(PCin));
    Register #(.N(4)) PCreg(.clk(clk), .load(PCload), .clear(Reset), .loaddata(PCin), .outdata(PCout));
    Increment #(.N(4)) PCinc(.IncInput(PCout), .IncOutput(Incout));
    assign PCaddress = PCout;
    
    // 描述输出
    assign IR = reg_instruction[7:5];
    assign AnotZero = (Aout != 0);
    assign OUTPUT = OutE ? Aout : 8'b0;
endmodule