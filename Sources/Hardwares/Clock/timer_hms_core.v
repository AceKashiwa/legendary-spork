module timer_hms_core(
    input clk_1hz,           // 1Hz 时钟
    input rst_n,             // 低有效复位
    output reg [31:0] hms_hex // 8位16进制数，00HHMMSS
);

    reg [7:0] sec;
    reg [7:0] min;
    reg [7:0] hour;

    // 时分秒计数
    always @(posedge clk_1hz or negedge rst_n) begin
        if (!rst_n) begin
            sec  <= 0;
            min  <= 0;
            hour <= 0;
        end else begin
            if (sec == 59) begin
                sec <= 0;
                if (min == 59) begin
                    min <= 0;
                    if (hour == 23)
                        hour <= 0;
                    else
                        hour <= hour + 1;
                end else
                    min <= min + 1;
            end else
                sec <= sec + 1;
        end
    end

    // 二进制转BCD
    function [7:0] to_bcd(input [7:0] bin);
        to_bcd = { (bin / 10), (bin % 10) };
    endfunction

    // 输出格式：00HHMMSS（每字节为BCD）
    always @(posedge clk_1hz or negedge rst_n) begin
        if (!rst_n)
            hms_hex <= 32'h00000000;
        else
            hms_hex <= {8'h00, to_bcd(hour), to_bcd(min), to_bcd(sec)};
    end

endmodule