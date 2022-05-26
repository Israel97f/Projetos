import lib.fases as fases
import math
from time import sleep
from random import randint

fases.IntConect()
#fases.pouso()#

fases.test(-67.6)
fases.Disconect()
def tup ():
	v = (randint(0, 50), randint(0, 50), randint(0, 50))
	return v


cont = 0
while True:
	cont += 1
	v = tup()
	print(v)
	if cont > 50: break

	print(math.pi)
