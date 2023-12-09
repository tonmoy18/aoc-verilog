from cmath import sqrt
import sys
import re

with open(sys.argv[1]) as f:
  _, *times  = re.split(' +', next(f).rstrip())
  _, *dists  = re.split(' +', next(f).rstrip())

t = float(''.join(times))
d = float(''.join(dists))

sol1 = (t - sqrt(t*t-4.0*d)) / 2
sol2 = (t + sqrt(t*t-4.0*d)) / 2

sol1 = ((sol1.real))
sol2 = ((sol2.real))

print(sol1, sol2)

if (sol1.__ceil__() == sol1):
  sol1 = sol1 + 1
else:
  sol1 = sol1.__ceil__()

if (sol2.__floor__() == sol2):
  sol2 = sol2 - 1
else:
  sol2 = sol2.__floor__()

if t > sol2:
  print(f'margin for {t} is {(sol2 - sol1 + 1)}')
  margin = (sol2 - sol1 + 1)
else:
  print(f'margin for {t} is {t - sol1 + 1}')
  margin = (t - sol1 + 1)


print(margin)
