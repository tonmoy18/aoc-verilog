from collections import defaultdict
import sys
import re
from collections import defaultdict

card_count = defaultdict(int)

with open(sys.argv[1]) as f:
  for line in f:
    c, l = line.rstrip().split(':')
    _, cid = re.split(r' +', c)
    l1, l2 = l.split('|')
    wins   = re.split(r' +', l1.lstrip().rstrip())
    hands  = re.split(r' +', l2.lstrip().rstrip())

    _, c = re.split(r' +', c)
    c = int(c)
    card_count[c] += 1

    # for i in range (0, card_count[c]):
    #   num_wins = 0
    #   for h in hands:
    #     if h in wins:
    #       num_wins += 1

    #   for i in range(c+1, c+1+num_wins):
    #     card_count[i] += 1

    num_wins = 0
    for h in hands:
      if h in wins:
        num_wins += 1

    for i in range(c+1, c+1+num_wins):
      card_count[i] += card_count[c]




    print(c, card_count[c])

total = 0
for k in card_count:
  total += (card_count[k])

print("Result: ", total)
