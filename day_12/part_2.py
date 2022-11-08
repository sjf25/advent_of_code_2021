#!/usr/bin/env python3
import sys

def all_paths(graph, current_path, seen, gone_twice, acc):
    if current_path[-1] == 'end':
        acc.append(list(current_path))
        return

    for to_visit in graph[current_path[-1]]:
        old_gone_twice = gone_twice
        if to_visit == 'start':
            continue
        elif to_visit in seen and gone_twice:
            continue
        elif to_visit in seen:
            gone_twice = True

        current_path.append(to_visit)
        if to_visit.islower():
            seen.append(to_visit)

        all_paths(graph, current_path, seen, gone_twice, acc)

        del current_path[-1]
        if to_visit.islower():
            del seen[-1]
        gone_twice = old_gone_twice

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
all_paths(graph, ['start'], [], False, res)

print(len(res))
