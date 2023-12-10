import sys
import re

network = {}
with open(sys.argv[1]) as f:
  move_line = next(f)
  moves = [0 if x == 'L' else 1  for x in list(move_line.rstrip())]
  next(f)

  for line in f:
    m = re.match(r'(...) = \((...), (...)\)', line.rstrip())
    node_name   = m.group(1)
    left_name   = m.group(2)
    right_name  = m.group(3)
    network[node_name] = (left_name, right_name)


current_node = 'AAA'
num_steps = 0
while current_node != 'ZZZ':
  move = moves[num_steps % len(moves)]
  current_node = network[current_node][move]
  num_steps += 1

print(num_steps)
