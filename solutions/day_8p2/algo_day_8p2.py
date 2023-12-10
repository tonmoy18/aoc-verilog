import sys
import re
import math

def lcm(a,b):
  return a*b // math.gcd(a,b)


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

current_nodes = []
for n in network:
  if n.endswith('A'):
    current_nodes.append(n)

num_steps = []
for current_node in current_nodes:
  num_step = 0
  while True:
    if current_node.endswith('Z'):
      break

    move = moves[num_step % len(moves)]
    current_node = network[current_node][move]
    num_step += 1
  num_steps.append(num_step)


running_lcm = 1
for num_step in num_steps:
  running_lcm = lcm(running_lcm, num_step)


print(running_lcm)
