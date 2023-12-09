import sys
import re

total_points = 0
with open(sys.argv[1]) as f:
  for line in f:
    c, l = line.rstrip().split(':')
    _, cid = re.split(r' +', c)
    l1, l2 = l.split('|')
    wins   = re.split(r' +', l1.lstrip().rstrip())
    hands  = re.split(r' +', l2.lstrip().rstrip())

    points = 0
    for h in hands:
      if h in wins:
        if points == 0:
          points = 1
        else:
          points *= 2


    print(c, wins, hands, points)

    total_points += points


print(total_points)