import lib.fases
from time import sleep


lib.fases.IntConect()
sleep(9)
lib.fases.Lauch(7000, True)
lib.fases.verticalLanding()
lib.fases.Disconect()
print('ok')