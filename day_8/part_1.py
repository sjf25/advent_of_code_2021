import sys

count = 0
for line in sys.stdin:
    outputs = line.split("| ")[-1].split(" ")
    count += sum(1 for i in outputs if len(i.strip()) in [2, 3, 4, 7])

print(count)
