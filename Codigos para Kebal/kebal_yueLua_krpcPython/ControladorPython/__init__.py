import sys
sys.path.append("")
import ControladorPython.lib.fases as krpc
import gerenciador_tmp.temporary_file_manager as file

def LaunchOrbital (alt, type, dir):
    krpc.Lauch(5000)
    krpc.Orbitador(alt, type, dir)

def LaunchSubOrbital (alt, sas):
    if sas == "false":
        sas = False
    else:
        sas = True
        
    krpc.Lauch(alt, sas)

def Landing ():
    krpc.verticalLanding()

def Conect ():
    krpc.IntConect()

def Desconect ():
    krpc.Disconect()

try:
    data = file.ReadData()

    if data[1] == "Orbital":
        LaunchSubOrbital(data[3], data[2])
    elif data[1] == "SubOrbital":
        LaunchSubOrbital(data[3], data[2])
    elif data[1] == 0:
        pass
    else:
        pass
except:
    pass

def test ():         
    krpc.test()
    