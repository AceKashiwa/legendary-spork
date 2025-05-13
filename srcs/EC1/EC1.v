module EC1(
    input [7:0] A,
    input clk, Reset,
    output [7:0] led,
    output H
);
    wire clk_2s;
    clk_div div1(.clk(clk), .reset(Reset), .clk_2s(clk_2s));

    wire IRload, JNZmux, PCload, INmux, Aload, OutE;
    wire AnotZero;
    wire [2:0] IR;
    
    datapath u_datapath(
        .IRload   (IRload   ),
        .JNZmux   (JNZmux   ),
        .PCload   (PCload   ),
        .INmux    (INmux    ),
        .Aload    (Aload    ),
        .Reset    (Reset    ),
        .clk      (clk_2s   ),
        .OutE     (OutE     ),
        .INPUT    (A        ),
        .IR       (IR       ),
        .AnotZero (AnotZero ),
        .OUTPUT   (led      )
    );
    
    control_unit u_control_unit(
        .clk      (clk_2s   ),
        .Reset    (Reset    ),
        .AnotZero (AnotZero ),
        .IR       (IR       ),
        .IRload   (IRload   ),
        .JNZmux   (JNZmux   ),
        .PCload   (PCload   ),
        .INmux    (INmux    ),
        .Aload    (Aload    ),
        .OutE     (OutE     ),
        .H        (H        ) 
    );
endmodule