module oled_display(
    input           clk_in,
    input           sys_rst_n,
    input           key,
    input           key_flag,
    output          oled_SCL,
    output          oled_SDA,
    output          oled_RES,
    output          oled_DC,
    input  [1343:0] str_data    // 8行，每行21字符，每字符8位，8*21*8=1344
);

wire         ready;
reg          data_clk;
wire         dc;
reg  [7:0 ]  OLED_data;
reg  [4:0 ]  OLED_state;
reg  [7:0 ]  xpos_count;
reg  [2:0 ]  ypos_count;

parameter X_BORDER = 2; // 左右边框像素
parameter Y_BORDER = 0; // 上下边框页数（每页8像素）;

// 自动刷新定时器（1Hz，每次拉高10ms，适配1MHz时钟）
reg [19:0] refresh_cnt = 0;
reg [13:0] auto_refresh_cnt = 0;  // 修改位宽以适应新的计数值
reg        auto_refresh_flag = 0;

// 刷新触发条件：手动或自动
wire refresh_trig = (key_flag && (!key)) || auto_refresh_flag;

always @(posedge clk_in or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        refresh_cnt <= 0;
        auto_refresh_cnt <= 0;
        auto_refresh_flag <= 0;
    end else if(refresh_cnt == 20'd999_999) begin // 1Hz, 1MHz*1s
        refresh_cnt <= 0;
        auto_refresh_cnt <= 14'd9_999; // 10ms脉宽，从100ms改为10ms
        auto_refresh_flag <= 1;
    end else if(auto_refresh_cnt > 0) begin
        auto_refresh_cnt <= auto_refresh_cnt - 1;
        auto_refresh_flag <= 1;
    end else if(refresh_trig && ready) begin
        auto_refresh_flag <= 0;
        refresh_cnt <= 0;
    end else begin
        refresh_cnt <= refresh_cnt + 1;
        auto_refresh_flag <= 0;
    end
end

// 写数据控制
always @(posedge clk_in or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        OLED_state <= 5'b0;
    end
    else begin
        if(OLED_state < 5'd25 && ready)begin  //小于25
            OLED_state <= OLED_state + 1'b1;
        end
        else if(OLED_state >= 5'd26 && OLED_state < 5'd30 && ready) begin  //26-29
            OLED_state <= OLED_state + 1'b1;
        end
        else begin
            if((xpos_count == 8'd129) && (ypos_count <= 3'b111) && (OLED_state == 5'd30) && ready)begin //30
                OLED_state <= 5'd27;
            end
            else if((xpos_count == 8'd129) && (ypos_count == 3'b111) && (OLED_state == 5'd30))begin//30
                OLED_state <= 5'd31;
            end
            else begin  //25或31
                if(refresh_trig && ready)
                    OLED_state <= 5'd26;
                else
                    OLED_state <= OLED_state;
            end
        end
    end
end

// DC控制
assign dc = (OLED_state >= 30);

// data_en控制
always @(posedge clk_in or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        data_clk <= 1'b0;
    end
    else begin
        if(OLED_state < 5'd25 || (OLED_state>=26 && OLED_state <=30))
            data_clk <= 1'b1;
        else
            data_clk <= 1'b0;
    end
end

// 坐标
always @(posedge clk_in or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        xpos_count <= 1'b0;
        ypos_count <= 1'b0;
    end
    else begin
        if(OLED_state == 5'd30 && ready)begin //30
            if(xpos_count < 8'd129)begin
                xpos_count <= xpos_count + 1'b1;
                ypos_count <= ypos_count;
            end
            else begin
                if(ypos_count < 3'b111)begin
                    xpos_count <= 1'b0;
                    ypos_count <= ypos_count + 1'b1;
                end
                else begin
                    xpos_count <= 1'b0;
                    ypos_count <= 1'b0;
                end
            end
        end
        else if(OLED_state == 5'd31 && ready)begin
            xpos_count <= 1'b0;
            ypos_count <= 1'b0;
        end
        else begin
            xpos_count <= xpos_count;
            ypos_count <= ypos_count;
        end
    end
end

integer char_idx, col_idx, line_base;

// 字模ROM
wire [7:0] font_data;
reg  [7:0] curr_char;
reg  [2:0] curr_col;

font_rom font_inst (
    .char_code(curr_char),
    .col_idx(curr_col),
    .data(font_data)
);

// 动态字符串显示（支持8行）
always @(*)begin
    if (!sys_rst_n)
        OLED_data = 8'b0;
    else begin
        case (OLED_state)
            5'd1 : OLED_data = 8'hae; //关闭显示
            5'd2 : OLED_data = 8'hd5; //设置时钟分频因子,震荡频率
            5'd3 : OLED_data = 8'h80; //[3:0],分频因子;[7:4],震荡频率
            5'd4 : OLED_data = 8'ha8; //设置驱动路数
            5'd5 : OLED_data = 8'h3f; //默认0X3f(1/64) 0x1f(1/32) 
            5'd6 : OLED_data = 8'hd3; //设置显示偏移
            5'd7 : OLED_data = 8'h00; //默认为0
            5'd8 : OLED_data = 8'h40; //设置显示开始行 [5:0],行数.
            5'd9 : OLED_data = 8'h8d; //电荷泵设置
            5'd10: OLED_data = 8'h14; //bit2，开启/关闭
            5'd11: OLED_data = 8'h20; //设置内存地址模式
            5'd12: OLED_data = 8'h02; //[1:0],00，列地址模式;01，行地址模式;10,页地址模式;默认10;
            5'd13: OLED_data = 8'ha1; //段重定义设置,bit0:0,0->0;1,0->127;
            5'd14: OLED_data = 8'hc8; //设置COM扫描方向
            5'd15: OLED_data = 8'hda; //设置COM硬件引脚配置
            5'd16: OLED_data = 8'h12; //0.91英寸128*64分辨率
            5'd17: OLED_data = 8'h81; //对比度设置
            5'd18: OLED_data = 8'hef; //1~255(亮度设置,越大越亮)
            5'd19: OLED_data = 8'hd9; //设置预充电周期
            5'd20: OLED_data = 8'hf1; //[3:0],PHASE 1;[7:4],PHASE 2;
            5'd21: OLED_data = 8'hdb; //设置VCOMH 电压倍率
            5'd22: OLED_data = 8'h30; //[6:4] 000,0.65*vcc;001,0.77*vcc;011,0.83*vcc;
            5'd23: OLED_data = 8'ha4; //全局显示开启;bit0:1,开启;0,关闭;(白屏/黑屏)
            5'd24: OLED_data = 8'ha6; //设置显示方式;bit0:1,反相显示;0,正常显示
            5'd25: OLED_data = 8'haf; //开启显示
            5'd27: begin case (ypos_count)
                        3'd0: OLED_data = 8'hb0;
                        3'd1: OLED_data = 8'hb1;
                        3'd2: OLED_data = 8'hb2;
                        3'd3: OLED_data = 8'hb3;
                        3'd4: OLED_data = 8'hb4;
                        3'd5: OLED_data = 8'hb5;
                        3'd6: OLED_data = 8'hb6;
                        3'd7: OLED_data = 8'hb7;
                   endcase
                   end
            5'd28: OLED_data = 8'h00;
            5'd29: OLED_data = 8'h10;
            5'd30: begin
                if (xpos_count < X_BORDER || xpos_count >= (128 - X_BORDER)) begin
                    OLED_data = 8'b0;
                end else if (ypos_count < Y_BORDER || ypos_count >= (8 + Y_BORDER)) begin
                    OLED_data = 8'b0;
                end else begin
                    char_idx = (xpos_count - X_BORDER) / 6;
                    col_idx  = (xpos_count - X_BORDER) % 6;
                    case (ypos_count)
                        3'd0: line_base = 0;
                        3'd1: line_base = 21;
                        3'd2: line_base = 42;
                        3'd3: line_base = 63;
                        3'd4: line_base = 84;
                        3'd5: line_base = 105;
                        3'd6: line_base = 126;
                        3'd7: line_base = 147;
                        default: line_base = 0;
                    endcase
                    if (char_idx < 21) begin
                        if (col_idx < 5) begin
                            curr_char = str_data[8*(line_base+20-char_idx) +: 8];
                            curr_col  = col_idx[2:0];
                            OLED_data = font_data;
                        end else
                            OLED_data = 8'b0;
                    end else
                        OLED_data = 8'b0;
                end
            end
            default: OLED_data = 8'b0;
        endcase
    end
end

// OLED驱动模块
oled_write_data u_oled_write_data(
    .clk_in         (clk_in),
    .sys_rst_n      (sys_rst_n),
    .data           (OLED_data),
    .dc             (dc),
    .enable         (data_clk),
    .oled_SCL       (oled_SCL),
    .oled_SDA       (oled_SDA),
    .oled_RES       (oled_RES),
    .oled_DC        (oled_DC),
    .ready          (ready)
);

endmodule