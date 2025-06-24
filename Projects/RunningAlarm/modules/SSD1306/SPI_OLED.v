module SPI_OLED(
    input   clk_in,
    input   rst_in,
    input   key,  
    output  oled_SCL,
    output  oled_SDA,
    output  oled_RES,
    output  oled_DC
);

wire dri_clk;
clk_self #(
    .DIV(50)
) u_clk_self (
    .clk(clk_in),
    .clk_out(dri_clk)
);

wire key_value;
wire key_flag;

// 8行，每行21字符
wire [167:0] line0 = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U"};
wire [167:0] line1 = {"V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"};
wire [167:0] line2 = {"q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9"," "};
wire [167:0] line3 = {"!","@","#","$","%","^","&","*","(",")","-","_","+","=","[","]","{","}",";",":"," "};
wire [167:0] line4 = {"1","2","3","4","5","6","7","8","9","0","A","B","C","D","E","F","G","H","I","J","K"};
wire [167:0] line5 = {"L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f"};
wire [167:0] line6 = {"g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"," "};
wire [167:0] line7 = {"!","@","#","$","%","^","&","*","(",")","-","_","+","=","[","]","{","}",";",":"," "};

wire [1343:0] str_data = {line7, line6, line5, line4, line3, line2, line1, line0}; // 8行

oled_display u_oled_display(
    .clk_in     (dri_clk),
    .sys_rst_n  (rst_in),
    .key        (key_value),
    .key_flag   (key_flag),
    .oled_SCL   (oled_SCL),
    .oled_SDA   (oled_SDA),
    .oled_RES   (oled_RES),
    .oled_DC    (oled_DC),
    .str_data   (str_data)
);

key_debounce u_key(
    .sys_clk    (dri_clk),
    .sys_rst_n  (rst_in),
    .key        (key),
    .key_flag   (key_flag),
    .key_value  (key_value)
);

endmodule
