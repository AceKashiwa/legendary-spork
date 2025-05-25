`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/24
// Design Name: 
// Module Name: music_score_ROM_xxx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 小星星乐谱ROM，只读、组合逻辑输出
// 
//////////////////////////////////////////////////////////////////////////////////

module music_score_ROM_xxx #(
    parameter ROM_WIDTH = 12,      // {high[3:0], med[3:0], low[3:0]}
    parameter ROM_DEPTH = 128,     // 32*4=128
    parameter ADDR_WIDTH = 7
)(
    input  [ADDR_WIDTH-1:0] addr,
    output [ROM_WIDTH-1:0]  data
);
    reg [ROM_WIDTH-1:0] Mem[0:ROM_DEPTH-1];

    // 小星星简谱：1 1 5 5 6 6 5 | 4 4 3 3 2 2 1 | 5 5 4 4 3 3 2 | 5 5 4 4 3 3 2 | 1 1 5 5 6 6 5 | 4 4 3 3 2 2 1
    // 只用C调，1=C，2=D，3=E，4=F，5=G，6=A
    // 低音：{4'h0, 4'h0, 4'hX}，X为音符
    // 静音：{4'h0, 4'h0, 4'h0}
    initial begin
        integer i, j, k;
        reg [7:0] base[0:31];
        // 原始32拍乐谱
        base[ 0]=1; base[ 1]=1; base[ 2]=5; base[ 3]=5; base[ 4]=6; base[ 5]=6; base[ 6]=5; base[ 7]=0;
        base[ 8]=4; base[ 9]=4; base[10]=3; base[11]=3; base[12]=2; base[13]=2; base[14]=1; base[15]=0;
        base[16]=5; base[17]=5; base[18]=4; base[19]=4; base[20]=3; base[21]=3; base[22]=2; base[23]=0;
        base[24]=5; base[25]=5; base[26]=4; base[27]=4; base[28]=3; base[29]=3; base[30]=2; base[31]=0;
        // 展开为每音3拍+1空拍
        k = 0;
        for(i=0;i<32;i=i+1) begin
            for(j=0;j<3;j=j+1) begin
                if(base[i]==0)
                    Mem[k] = {4'h0, 4'h0, 4'h0}; // 空
                else
                    Mem[k] = {4'h0, 4'h0, base[i][3:0]};
                k = k + 1;
            end
            Mem[k] = {4'h0, 4'h0, 4'h0}; // 空
            k = k + 1;
        end
    end

    assign data = Mem[addr];

endmodule