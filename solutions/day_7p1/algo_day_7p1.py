from functools import cmp_to_key
import sys
from collections import defaultdict

def card_val(c):
  if c == 'T':
    return 10
  if c == 'J':
    return 11
  if c == 'Q':
    return 12
  if c == 'K':
    return 13
  if c == 'A':
    return 14
  return int(c)

def my_f(x):
  if len(set(x)) == 1:
    return 99
  if len(set(x)) == 2:
    for c in set(x):
      if x.count(c) == 4:
        return 88
    return 77
  if len(set(x)) == 3:
    for c in set(x):
      if x.count(c) == 3:
        return 66
    return 55
  if len(set(x)) == 4:
    return 44
  return 0


def compare(a, b):
  if my_f(a[0]) > my_f(b[0]):
    return 1
  elif my_f(b[0]) > my_f(a[0]):
    return -1
  else:
    for a_c, b_c in zip(a[0],b[0]):
      if card_val(a_c) < card_val(b_c):
        return -1
      elif card_val(a_c) > card_val(b_c):
        return 1
  return 0

hands = []
with open(sys.argv[1]) as f:
  for line in f:
    hand, bid = line.rstrip().split(' ')
    hands.append([hand, int(bid)])

winnings = 0
for rank, hand in enumerate(sorted(hands, key = cmp_to_key(compare))):
  print(f'{hand[0]} with bid {hand[1]} had rank {rank + 1}')
  winnings += (rank+1) * hand[1]

print(winnings)