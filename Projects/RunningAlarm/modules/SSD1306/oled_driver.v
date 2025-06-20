module oled_write_data(
    input           clk_in,      //oled模块驱动时钟
    input           sys_rst_n,    //复位信号
    input   [7:0]   data,   //像素点数据
    input           dc,   //像素点横坐标
    input           reset,
    input           enable,
    //oled接口                          
    output          oled_SCL,       //SPI的驱动时钟，上升沿有效
    output          oled_SDA,       //OLED的数据引脚
    output          oled_RES,       //OLED的复位引脚
    output          oled_DC,        //数据、命令选择，高电平数据，低电平命令
    output          ready
    );  

//负责reset引脚控制
reg [19:0] rst_count = 20'd1_000_000; //10ms复位计时
assign oled_RES = sys_rst_n && (rst_count < 20'd2);

always @(posedge clk_in or negedge sys_rst_n)begin
    if(!sys_rst_n)
        rst_count <= 20'd1_000_000;
    else begin
        if(rst_count > 20'b0)
            rst_count <= rst_count - 1'b1;
        else
            rst_count <= rst_count;
    end
end

//数据传输
reg data_end;
reg [2:0] data_count = 3'b111;

assign oled_SCL = clk_in && (~ready) && (rst_count < 20'd1);
assign oled_DC  = dc || ready;
assign oled_SDA = data[data_count];
assign ready = oled_RES && data_end;

always @(negedge clk_in or negedge oled_RES)begin
    if(!oled_RES)begin
        data_count <= 1'b0;
        data_end <= 1'b0;
    end
    else begin
        if(ready && enable)begin
            data_end <= 1'b0;
            data_count <= 3'b111;
        end
        else begin
            if((~ready)&&(data_count > 1'b0)) begin
                data_count <= data_count - 1'b1;
                data_end <= 1'b0;
            end
            else begin
                data_count <= 3'b111;
                data_end <= 1'b1;
            end
        end
    end
end

endmodule