import re


def convert_c_to_verilog(c_file_path, verilog_file_path):
    with open(c_file_path, "r") as c_file:
        lines = c_file.readlines()

    # 提取字库数据
    font_data = []
    for line in lines:
        # 匹配字库数据行
        match = re.search(r"0x([0-9A-Fa-f]{2})", line)
        if match:
            font_data.append(match.group(1))

    # 将数据转换为Verilog格式
    verilog_data = []
    for i in range(0, len(font_data), 5):
        # 每5个字节为一行
        line_data = font_data[i : i + 5]
        verilog_line = "    8'h" + ", 8'h".join(line_data) + ","
        verilog_data.append(verilog_line)

    # 写入Verilog文件
    with open(verilog_file_path, "w") as verilog_file:
        verilog_file.write("module font_data (\n")
        verilog_file.write(
            "    output reg [7:0] font [0:255][0:4] // 256 characters, 5 bytes each\n"
        )
        verilog_file.write(");\n\n")
        verilog_file.write("initial begin\n")
        for i, line in enumerate(verilog_data):
            verilog_file.write(f"    font[{i}] = {{ {line} }};\n")
        verilog_file.write("end\n")
        verilog_file.write("endmodule\n")


def convert_c_to_verilog_2d(c_file_path, verilog_file_path):
    with open(c_file_path, "r") as c_file:
        content = c_file.read()

    # 提取所有 0xXX
    font_data = re.findall(r"0x([0-9A-Fa-f]{2})", content)
    if len(font_data) < 256 * 5:
        print("Warning: 字模数据不足 256*5 个字节！自动补零。")
        font_data += ["00"] * (256 * 5 - len(font_data))
    font_data = font_data[: 256 * 5]  # 截断多余部分

    with open(verilog_file_path, "w", encoding="utf-8") as f:
        f.write("module font_rom(\n")
        f.write("    input  [7:0] char_code,\n")
        f.write("    input  [2:0] col_idx,\n")
        f.write("    output [7:0] data\n")
        f.write(");\n")
        f.write("    reg [7:0] font [0:255][0:4];\n")
        f.write("    initial begin\n")
        for char in range(256):
            # 获取可显示字符
            if 32 <= char <= 126:
                ch = chr(char)
            else:
                ch = "."
            # 收集5字节
            bytes5 = []
            for col in range(5):
                idx = char * 5 + col
                if idx < len(font_data):
                    bytes5.append(font_data[idx])
            # 写注释
            f.write(f"        // ASCII {char:3d} (0x{char:02X}): '{ch}'\n")
            # 写数据
            for col, b in enumerate(bytes5):
                f.write(f"        font[{char}][{col}] = 8'h{b};\n")
            # 点阵注释
            for bit in range(8):
                row = ""
                for b in bytes5:
                    val = int(b, 16)
                    row += "*" if (val >> bit) & 1 else "."
                f.write(f"        // {row}\n")
        f.write("    end\n")
        f.write("    assign data = font[char_code][col_idx];\n")
        f.write("endmodule\n")


# 使用示例
c_file_path = "D:\\Backup\\Docs\\中控杯\\stm32\\WHEELTEC\\1.WHEELTEC ROS机器人通用资料\\3.STM32底层源码讲解教程\\12.源码讲解：人机交互\\OLED显示屏模块附送资料\\OLED显示屏模块附送资料\\2.ArduinoUNO例程\\SSD1306\\glcdfont.c"  # C语言字库文件路径
verilog_file_path = "font_data.v"  # 输出的Verilog文件路径
convert_c_to_verilog(c_file_path, verilog_file_path)

verilog_file_path_2d = "font_rom.v"  # 输出的Verilog文件路径（2D）
convert_c_to_verilog_2d(c_file_path, verilog_file_path_2d)
