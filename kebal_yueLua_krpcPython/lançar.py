import ControladorPython
import time


ControladorPython.Conect()
#ControladorPython.LaunchOrbital (90000, 'Equatorial', 90)
#ControladorPython.LaunchSubOrbital(50000, 1)
ControladorPython.Landing()
#ControladorPython.test()
time.sleep(12)
ControladorPython.Desconect()
