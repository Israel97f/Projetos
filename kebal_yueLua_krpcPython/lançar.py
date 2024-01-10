import ControladorPython
import time


ControladorPython.Conect()
#ControladorPython.test()
#ControladorPython.LaunchOrbital (90000, 'Equatorial', 90)
#ControladorPython.LaunchSubOrbital(10000, 1)
ControladorPython.Landing()
#ControladorPython.test()
time.sleep(2)
ControladorPython.Desconect()
