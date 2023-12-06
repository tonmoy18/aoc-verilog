import sys
import re
from xmlrpc.client import MAXINT

st = 0
seeds = []
other_maps = []
with open(sys.argv[1]) as f:
  for line in f:
    if line.rstrip() == '':
      st += 1
      if (st > 0):
        other_maps.append([])
      next(f)
    elif st == 0:
      seeds_str = line.rstrip().split(" ")
      seeds = [int(x) for x in seeds_str[1:]]
    elif st >= 1:
      other_maps[-1].append([int(x) for x in line.rstrip().split(' ')])

found_seed = -1
lowest_loc = MAXINT
for seed in seeds:
  item = seed
  for single_map in other_maps:
    for map_line in single_map:
      if item >= map_line[1] and item < map_line[1] + map_line[2]:
        new_item = map_line[0] + (item - map_line[1])
        # print("Mapped {} to {}".format(item, new_item))
        item = new_item
        break
  loc = item
  print("New location: {}".format(loc))
  if loc < lowest_loc:
    lowest_loc = loc
    found_seed = seed

print(lowest_loc)

