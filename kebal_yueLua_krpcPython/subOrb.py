import ControladorPython
import time


ControladorPython.Conect()
ControladorPython.LaunchOrbital (80000, 'Equatorial', 90)
#ControladorPython.LaunchSubOrbital(80000, 1)
#ControladorPython.test()
time.sleep(2)
ControladorPython.Desconect()
