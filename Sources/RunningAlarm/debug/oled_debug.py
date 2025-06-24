import numpy as np
from PIL import Image
import re

# SSD1306 GDDRAM: 8页，每页128字节
gddram = np.zeros((8, 128), dtype=np.uint8)

# 当前页和列指针
page = 0
col = 0

# SPI状态
prev_scl = 1
bit_count = 0
byte_val = 0


# 解析SSD1306命令
def process_command(cmd):
    global page, col
    if 0xB0 <= cmd <= 0xB7:
        page = cmd & 0x07
        col = 0
    elif 0x00 <= cmd <= 0x0F:
        col = (col & 0xF0) | (cmd & 0x0F)
    elif 0x10 <= cmd <= 0x1F:
        col = (col & 0x0F) | ((cmd & 0x0F) << 4)
    # 其他命令可根据需要补充


# 读取仿真输出
with open(
    "D:\\Github\\Verilog\\legendary-spork\\Projects\\RunningAlarm\\modules\\SSD1306\\spi_output.txt",
    "r",
) as f:
    lines = f.readlines()

# 记录上一时刻信号
last_dc = 1
last_res = 1

for line in lines:
    m = re.search(r"SCL=(\d) SDA=(\d) RES=(\d) DC=(\d)", line)
    if not m:
        continue
    scl = int(m.group(1))
    sda = int(m.group(2))
    res = int(m.group(3))
    dc = int(m.group(4))

    # 复位信号处理
    if res == 0:
        page = 0
        col = 0
        bit_count = 0
        byte_val = 0
        continue

    # SPI模式0: SCL上升沿采样
    if prev_scl == 0 and scl == 1:
        byte_val = (byte_val << 1) | sda
        bit_count += 1
        if bit_count == 8:
            print(f"byte: {byte_val:02X}, DC={dc}, page={page}, col={col}")  # 调试输出
            if dc == 0:
                # 命令
                process_command(byte_val)
            else:
                # 数据
                if 0 <= page < 8 and 0 <= col < 128:
                    gddram[page, col] = byte_val
                    col = (col + 1) % 128
            bit_count = 0
            byte_val = 0
    prev_scl = scl

print(gddram)
# 生成像素矩阵（不做上下翻转）
pixels = np.zeros((64, 128), dtype=np.uint8)
for page in range(8):
    for col in range(128):
        byte = gddram[page, col]
        for bit in range(8):
            pixels[page * 8 + bit, col] = (byte >> bit) & 1  # 不做上下翻转

img = Image.fromarray(pixels * 255).convert("L")
img.save("oled_output.png")
print("oled_output.png 已生成")
