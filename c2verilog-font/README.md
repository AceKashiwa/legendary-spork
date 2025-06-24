### Python脚本

```python
import re

def convert_c_to_verilog(c_file_path, verilog_file_path):
    with open(c_file_path, 'r') as c_file:
        c_content = c_file.read()

    # 提取字库数组
    font_array = re.search(r'static const unsigned char  font\[\] PROGMEM = \{(.*?)\};', c_content, re.DOTALL)
    
    if font_array:
        font_data = font_array.group(1)
        # 清理数据，去掉空格和换行
        font_data = re.sub(r'\s+', '', font_data)
        # 将数据按逗号分割
        font_bytes = font_data.split(',')

        # 转换为Verilog格式
        verilog_data = "reg [7:0] font_data[0:" + str(len(font_bytes) - 1) + "];\n\n"
        verilog_data += "initial begin\n"
        for i, byte in enumerate(font_bytes):
            verilog_data += f"    font_data[{i}] = 8'h{byte.strip()};\n"
        verilog_data += "end\n"

        # 写入Verilog文件
        with open(verilog_file_path, 'w') as verilog_file:
            verilog_file.write(verilog_data)
        print(f"转换完成，已保存至 {verilog_file_path}")
    else:
        print("未找到字库数组。")

# 使用示例
c_file_path = 'glcdfont.c'  # C语言字库文件路径
verilog_file_path = 'font_data.v'  # 输出的Verilog文件路径
convert_c_to_verilog(c_file_path, verilog_file_path)
```

### 使用说明

1. 将上述Python脚本保存为`convert.py`。
2. 确保你的C语言字库文件（如`glcdfont.c`）与脚本在同一目录下，或者修改`c_file_path`为正确的路径。
3. 运行脚本：
   ```bash
   python convert.py
   ```
4. 脚本会生成一个名为`font_data.v`的Verilog文件，里面包含了转换后的字库数据。

### 生成的Verilog文件示例

生成的Verilog文件将类似于以下内容：

```verilog
reg [7:0] font_data[0:255];

initial begin
    font_data[0] = 8'h00;
    font_data[1] = 8'h00;
    font_data[2] = 8'h00;
    ...
    font_data[255] = 8'hFF;
end
```

请根据需要调整脚本中的路径和数组大小。