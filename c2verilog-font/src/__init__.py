import re

def convert_c_to_verilog(c_file_path, verilog_file_path):
    with open(c_file_path, 'r') as c_file:
        c_content = c_file.read()

    # 提取字库数组
    font_array_match = re.search(r'static const unsigned char\s+font\[\]\s*PROGMEM\s*=\s*{([^}]*)}', c_content, re.DOTALL)
    
    if not font_array_match:
        print("未找到字库数组")
        return

    font_data = font_array_match.group(1)
    
    # 清理数据并转换为Verilog格式
    font_data = font_data.replace('\n', '').replace(' ', '').replace('\t', '')
    font_bytes = font_data.split(',')

    # 生成Verilog数组
    verilog_array = ["    8'h" + byte.strip() for byte in font_bytes if byte.strip()]
    
    # 写入Verilog文件
    with open(verilog_file_path, 'w') as verilog_file:
        verilog_file.write("module font_rom (\n")
        verilog_file.write("    input [7:0] addr,\n")
        verilog_file.write("    output reg [7:0] data\n")
        verilog_file.write(");\n\n")
        
        verilog_file.write("    reg [7:0] font_data [0:" + str(len(verilog_array) - 1) + "];\n\n")
        
        verilog_file.write("    initial begin\n")
        for i, byte in enumerate(verilog_array):
            verilog_file.write(f"        font_data[{i}] = {byte};\n")
        verilog_file.write("    end\n\n")
        
        verilog_file.write("    always @(*) begin\n")
        verilog_file.write("        data = font_data[addr];\n")
        verilog_file.write("    end\n")
        
        verilog_file.write("endmodule\n")

# 使用示例
convert_c_to_verilog('glcdfont.c', 'font_rom.v')