from functools import cmp_to_key
import sys
from collections import defaultdict

def card_val(c):
  if c == 'T':
    return 10
  if c == 'J':
    return 1
  if c == 'Q':
    return 11
  if c == 'K':
    return 12
  if c == 'A':
    return 13
  return int(c)

def resolve_joker(s):
  best_c_cnt = 0
  best_c = ''

  counts = defaultdict(int)

  for c in s:
    counts[c] += 1
  
  for c in counts:
    if c == 'J':
      continue
    if counts[c] > best_c_cnt:
      best_c = c
      best_c_cnt = counts[c]
    elif counts[c] == best_c_cnt:
      if card_val(c) > card_val(best_c):
        best_c = c
        best_c_cnt = counts[c]
  
  if best_c == '':
    return 'AAAAA'
  
  return s.replace('J', best_c)


def my_f(x_pre_joker):
  x = resolve_joker(x_pre_joker)

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