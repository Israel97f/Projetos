import krpc
import math
from time import sleep


def IntConect():
    i = 0
    while True:
        i +=1
        try:
            global conn 
            conn = krpc.connect()
        except:
            print(f'\033[31m{"-" * 8}Erro ao executar a conexão{"-" * 8}\033[m')
            if i > 9 :
                break
            else:
                continue
        else:
            print(f'\033[32m{"-" * 8}Conexão feita com sucesso{"-" * 8}\033[m')
            break


def Lauch():
    global conn
    global vessel
    vessel = conn.space_center.active_vessel
    vessel.control.throttle = 1
    vessel.control.activate_next_stage()


def Orbitador(alt=70000):
    global vessel
    global altitude
    #Twr = vessel.thrust / vessel.mass
    altitude = addStream(vessel.flight(), 'mean_altitude')
    apoastro = addStream(vessel.orbit, 'apoapsis_altitude')
    periastro = addStream(vessel.orbit, 'periapsis_altitude')
    vessel.auto_pilot.sas = False
    vessel.auto_pilot.engage()
    while True:
        vessel.auto_pilot.target_pitch_and_heading(90 - (90 * (alt / altitude())), 90)
        vessel.control.throttle = vessel.mass * 9.6 * 1.4 /( vessel.max_thrust)
        if apoastro() > alt:
            vessel.control.throttle = 0
            break
        
    while True:
        if periastro() - apoastro() < 100:
            if apoastro() - altitude() < 300:
                vessel.control.throttle = 1
            else:
                vessel.control.throttle = 0
                sleep(3)
        else:
            vessel.control.throttle = 0
            break

    vessel.auto_pilot.disengage()



def verticalLanding():
    global vessel
    vessel.auto_pilot.sas = True
    vessel.auto_pilot.sas_mode = vessel.auto_pilot.sas_mode.retrograde
    vessel.control.throttle = 0
    #abs()
    pass



def direction_movement():
    pass


def addStream(classe, metodo):
    global conn
    return conn.add_stream(getattr, classe, metodo )
