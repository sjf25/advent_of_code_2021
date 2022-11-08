#!/usr/bin/env python3

def all_paths(graph, current_path, seen, acc):
    if current_path[-1] == 'end':
        acc.append(list(current_path))
        return

    for to_visit in graph[current_path[-1]]:
        if to_visit in seen or to_visit == 'start':
            continue

        current_path.append(to_visit)
        if to_visit.islower():
            seen.add(to_visit)

        all_paths(graph, current_path, seen, acc)

        del current_path[-1]
        if to_visit.islower():
            seen.remove(to_visit)

import sys

lines = [i for i in sys.stdin]

graph = dict()

for p in lines:
    u, v = [i.strip() for i in p.split('-')]
    if u not in graph:
        graph[u] = []
    if v not in graph:
        graph[v] = []
    graph[u].append(v)
    graph[v].append(u)

res = []
all_paths(graph, ['start'], set(), res)

print(len(res))
