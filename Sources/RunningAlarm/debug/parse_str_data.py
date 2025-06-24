def binstr_to_ascii(binstr):
    # binstr: 1344 bits, e.g. '0100000101000010...'
    chars = []
    for i in range(0, len(binstr), 8):
        byte = binstr[i : i + 8]
        chars.append(chr(int(byte, 2)))
    return "".join(chars)


def print_lines(ascii_str, line_len=21):
    lines = [ascii_str[i : i + line_len] for i in range(0, len(ascii_str), line_len)]
    # 不再使用reversed，直接按顺序输出
    for line in lines:
        print(line)


if __name__ == "__main__":
    binstr = input("请输入str_data的二进制字符串（共1344位）:\n").strip()
    if len(binstr) != 1344:
        print("输入长度不是1344位！")
        exit(1)
    ascii_str = binstr_to_ascii(binstr)
    print("\n=== OLED Display Content ===")
    print_lines(ascii_str)
    print("==========================")
