module SPI_OLED(
    input   clk_in,
    input   rst_in,
    input   key,  
    output  oled_SCL,
    output  oled_SDA,
    output  oled_RES,
    output  oled_DC
);

// 使用已有分频模块
wire dri_clk;
clk_self #(
    .DIV(50)
) u_clk_self (
    .clk(clk_in),
    .clk_out(dri_clk)
);

wire key_value;
wire key_flag;

oled_display u_oled_display(
    .clk_in         (dri_clk),                  //使用系统时钟仿真
    .sys_rst_n      (rst_in),                   //复位信号
    .key            (key_value),
    .key_flag       (key_flag),
    //oled接口                          
    .oled_SCL       (oled_SCL),    // SPI时钟输出
    .oled_SDA       (oled_SDA),    // SPI数据输出
    .oled_RES       (oled_RES),    // OLED复位
    .oled_DC        (oled_DC)      // 数据/命令选择
);

key_debounce u_key(
    .sys_clk    (dri_clk),         //使用系统时钟仿真
    .sys_rst_n  (rst_in),        //外部复位信号，低有效
    
    .key        (key),              //外部按键输入
    .key_flag   (key_flag),         //按键数据有效信号
    .key_value  (key_value)       //按键消抖后的数据  
    );

endmodule
