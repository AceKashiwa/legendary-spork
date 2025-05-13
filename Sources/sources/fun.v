`timescale 1ns / 1ps
module fun(
    input clk,in,reset,reset2,
    output [7:0] lump,
    output out,outreset
);
wire clk_500ms;
clk_div c1(.clk(clk), .reset(reset), .clk_500ms(clk_500ms));
work w1(.clk_500ms(clk_500ms),.reset2(reset2),.in(in),.lump(lump),.out(out),.outreset(outreset));
endmodule


module work(
    input clk_500ms,reset2,in,
    output reg [7:0] lump,
    output reg out,outreset
);
reg [10:0] cnt;
reg flag;
always @(posedge clk_500ms or posedge reset2 or posedge in)
begin
    if(reset2) begin
        outreset <=1;
        lump<= 8'b10000000;
        cnt <=0;
        out <=0;
        flag<=0;
    end
    else if(in) begin
        outreset <=0;
        flag <= 1;
        lump<= 8'b10000000;
        cnt <=0;
        out <=0;
    end
    else if(flag==1) begin
        outreset <=0;
        cnt<=cnt+1;
        if(cnt==1) begin lump<= 8'b01000000;out<=0;end
        else if(cnt==2) begin lump<= 8'b00100000;out<=0;end
        else if(cnt==3) begin lump<= 8'b00010000;out<=0;end
        else if(cnt==4) begin lump<= 8'b00001000;out<=0;end
        else if(cnt==5) begin lump<= 8'b00000100;out<=0;end
        else if(cnt==6) begin lump<= 8'b00000010;out<=0;end
        else if(cnt==7) begin lump<= 8'b00000001;out<=0;end
        else if(cnt==8) begin lump<= 8'b00000000;out<=1;flag<=0;cnt<=0;end
    end
    else begin
        outreset <=0;
        lump<= 8'b00000000;
        out <=0;
    end
end
endmodule


module clk_div(
    input wire clk,
    input wire reset,
    output reg clk_500ms
);
reg [30:0] count;
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        clk_500ms <= 0;
        count <= 0;
    end
    else if (count < 49999999) count <= count + 1;
    else if (count == 49999999) begin
        count <= 0;
        clk_500ms = ~clk_500ms;
    end
end
endmodule