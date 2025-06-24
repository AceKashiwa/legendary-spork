import re

def convert_c_to_verilog(c_file_path, verilog_file_path):
    with open(c_file_path, 'r') as c_file:
        c_content = c_file.read()

    # 提取字库数组
    font_array = re.search(r'static const unsigned char  font\[\] PROGMEM = \{(.*?)\};', c_content, re.DOTALL)
    if not font_array:
        print("未找到字库数组")
        return

    # 获取字库数据
    font_data = font_array.group(1)
    font_data = font_data.replace('\n', '').replace(' ', '').replace('\t', '')
    font_bytes = font_data.split(',')

    # 生成Verilog格式
    verilog_lines = []
    verilog_lines.append("module font_rom (output reg [7:0] data, input [7:0] addr);")
    verilog_lines.append("always @(*) begin")
    verilog_lines.append("    case (addr)")

    for i, byte in enumerate(font_bytes):
        byte_value = int(byte, 16)  # 将十六进制字符串转换为整数
        verilog_lines.append(f"        8'h{i:02X}: data = 8'h{byte_value:02X};")

    verilog_lines.append("        default: data = 8'h00;")
    verilog_lines.append("    endcase")
    verilog_lines.append("end")
    verilog_lines.append("endmodule")

    # 写入Verilog文件
    with open(verilog_file_path, 'w') as verilog_file:
        verilog_file.write('\n'.join(verilog_lines))

    print(f"转换完成，已生成 {verilog_file_path}")

# 使用示例
c_file_path = 'glcdfont.c'  # C文件路径
verilog_file_path = 'font_rom.v'  # 输出的Verilog文件路径
convert_c_to_verilog(c_file_path, verilog_file_path)