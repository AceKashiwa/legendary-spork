import re

with open("font_sv.txt", "r", encoding="utf-8") as fin, open("font_verilog.txt", "w", encoding="utf-8") as fout:
    for line in fin:
        m = re.match(r"font_rom\[(\d+)\]\s*=\s*'\{([^\}]*)\};(.*)", line)
        if m:
            idx = m.group(1)
            values = [v.strip() for v in m.group(2).split(",")]
            comment = m.group(3)
            for i, v in enumerate(values):
                fout.write(f"font_rom[{idx}][{i}] = {v};{comment if i==0 else ''}\n")
        else:
            fout.write(line)