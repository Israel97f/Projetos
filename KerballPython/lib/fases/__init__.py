from logging import exception
import krpc
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
            global vessel
            vessel = conn.space_center.active_vessel
            print(f'\033[32m{"-" * 8}Conexão feita com sucesso{"-" * 8}\033[m')
            break

def Disconect():
    global conn
    conn.close()


def Lauch(alt=0, sas=False):
    global conn
    global vessel
    global apoastro
    
    #vessel = conn.space_center.active_vessel
    apoastro = addStream(vessel.orbit, 'apoapsis_altitude')
    vessel.control.throttle = 1
    vessel.control.activate_next_stage()
    vessel.auto_pilot.sas = sas
    while True:
        if apoastro() >= alt:
            vessel.control.throttle = 0
            break
        

def Orbitador(alt=70000):
    global vessel
    global altitude
    altitude = addStream(vessel.flight(), 'mean_altitude')
    apoastro = addStream(vessel.orbit, 'apoapsis_altitude')
    periastro = addStream(vessel.orbit, 'periapsis_altitude')
    vessel.auto_pilot.sas = False
    vessel.auto_pilot.engage()
    while True:
        vessel.auto_pilot.target_pitch_and_heading(90 - int(90 * ( altitude() / alt)), 90)
        #vessel.auto_pilot.target_pitch_and_heading(75, 90)
        vessel.control.throttle = vessel.mass * 9.6 * 1.4 /( vessel.max_thrust)
        if apoastro() > alt:
            vessel.control.throttle = 0
            break
        
    while True:
        if periastro() - apoastro() > -100:
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
    global veloref 
    veloref = vessel.orbit.body.reference_frame
    Speed = addStream(vessel.flight(veloref), 'speed')
    surface_altitude = addStream(vessel.flight(), 'surface_altitude')
    vessel.auto_pilot.sas = True
    
    vessel.control.throttle = 0
    
    while True:
        if direction_movement() == -1:
            vessel.auto_pilot.sas_mode = vessel.auto_pilot.sas_mode.retrograde
            try:
                d = ((Speed() ** 2 - 2500)/ (2*(vessel.max_thrust / vessel.mass - 9.6))) + 200
            except:
                d = 1000
            print('-' * 20)
            print(d)
            print(Speed())
            print(Speed() ** 2)
            print(Speed() * Speed())

            if surface_altitude() <= d:
                vessel.control.throttle = 1
                break


    while True:
        try:
            delta = ((3 ** 2 - 50 ** 2) / ((-2) * (((vessel.max_thrust / vessel.mass ) * 0.8) - (9.81))))
        except:
            delta = 250

        print(delta)

        if surface_altitude() < (delta + 200):
            pouso()
            break
        
        if Speed() <= 50.00 and direction_movement() == -1:
            vessel.control.throttle = 0.94 * 9.6 * vessel.mass / vessel.max_thrust
           

def direction_movement():
    altitude = addStream(vessel.flight(), 'mean_altitude')
    altitude_anterior = altitude()
    ret = 0
    while True:
        if abs(altitude() - altitude_anterior) > 0:
            
            if altitude() - altitude_anterior > 0:
                ret = 1
            else:
                ret = -1

            altitude_anterior = altitude()
            break
    return ret
       

def addStream(classe, metodo):
    global conn
    return conn.add_stream(getattr, classe, metodo )


def pouso():
    global vessel
    vessel = conn.space_center.active_vessel
    veloref = vessel.orbit.body.reference_frame
    Speed = addStream(vessel.flight(veloref), 'speed')
    vessel.auto_pilot.engage()
    vessel.auto_pilot.target_pitch_and_heading(90, 90)
    #vessel.control.activate_next_stage()
    vessel.control.gear = True
    sleep(0.1)
    
    
    while True:
        if Speed() > 5.0 and direction_movement() == -1:
            vessel.control.throttle = 0.8 #2.17 * 9.6 * vessel.mass / vessel.max_thrust
        elif direction_movement() == 1:
            vessel.control.throttle = 0.93 * 9.6 * vessel.mass / vessel.max_thrust
        else:
            vessel.control.throttle = 9.6 * vessel.mass / vessel.max_thrust
            if Speed() < 0.5:
                vessel.control.throttle = 0
                break  

def testegear():
    global vessel
    vessel = conn.space_center.active_vessel
    vessel.control.gear = True
    sleep(10)
    vessel.control.gear = False
