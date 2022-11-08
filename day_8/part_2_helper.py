import sys

def listify(it):
    return '[' + ', '.join(it) + ']'

for line in sys.stdin:
    patterns, outputs = [i.strip() for i in line.split('|')]
    patterns = [listify(i) for i in patterns.split(' ')]
    outputs = [listify(i) for i in outputs.split(' ')]
    print('to_solve(' + listify(patterns) + ', ' + listify(outputs) + ').')
