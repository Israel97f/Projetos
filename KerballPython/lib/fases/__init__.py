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
            __telemetry()
            print(f'\033[32m{"-" * 8}Conexão feita com sucesso{"-" * 8}\033[m')
            break


def Disconect():
    global conn
    conn.close()


def Lauch(alt=0, sas=False):
    global vessel
    global apoastro

    vessel.control.throttle = 1
    vessel.control.activate_next_stage()
    vessel.auto_pilot.sas = sas
    while True:
        if apoastro() >= alt:
            vessel.control.throttle = 0
            break

        __fuel_chek()
        

def Orbitador(alt=70000):
    global vessel
    global altitude   
    global apoastro 
    global periastro 
    global Speed 

    vessel.auto_pilot.sas = False
    vessel.auto_pilot.engage()
    vessel.control.throttle = 1
    first_stage = 0

    while True:
        __fuel_chek()       
        frac = altitude()/45000
        if frac > 1:
            frac = 1

        vessel.auto_pilot.target_pitch_and_heading(90 - int(90 * frac), 90)
        
        if apoastro() > (alt * 0.9):
            vessel.control.throttle = vessel.mass * 9.6 * 1.4 /( vessel.max_thrust)

        if apoastro() > alt:
            vessel.control.throttle = 0
            break
        
    while True:
        __fuel_chek()
        if abs(periastro() - apoastro()) > 10000 or periastro() < 70000:
            if apoastro() - altitude() < 700:
                if Speed() > 1900 and first_stage == 0:
                    vessel.control.throttle = 0
                    sleep(0.1)
                    vessel.control.activate_next_stage()
                    sleep(2)
                    first_stage = 1

                vessel.control.throttle = 1
                print(Speed())
            else:
                vessel.control.throttle = 0
                sleep(1)
        else:
            vessel.control.throttle = 0
            break

    vessel.auto_pilot.disengage()


def verticalLanding():
    global vessel
    global Speed
    global vertical_speed 
    global surface_altitude

    vessel.auto_pilot.sas = True    
    vessel.control.throttle = 0
    
    while True:
        if vertical_speed() > 0:
            vessel.auto_pilot.sas_mode = vessel.auto_pilot.sas_mode.retrograde
            try:
                d = ((Speed() ** 2 - 2500)/ (2*(vessel.max_thrust / vessel.mass - 9.6))) + 100
            except:
                d = 1000
            
            if surface_altitude() <= d and d < 12000:
                vessel.control.throttle = 1
                break


    while True:
        try:
            delta = ((3 ** 2 - 50 ** 2) / ((-2) * (((vessel.max_thrust / vessel.mass ) * 0.8) - (9.81))))
        except:
            delta = 250
    
        if surface_altitude() < (delta + 50):
            pouso()
            break
        
        if Speed() <= 50.00 and vertical_speed() > 0:
            vessel.control.throttle = 0.94 * 9.6 * vessel.mass / vessel.max_thrust
                 

def  __addStream(classe, metodo):
    global conn
    return conn.add_stream(getattr, classe, metodo )


def pouso():
    global vessel
    global surface_altitude   
    global vertical_speed 
    global horizontal_speed 

    vessel.auto_pilot.engage()
    vessel.auto_pilot.target_pitch_and_heading(90, 90) 
    vessel.control.gear = True
    sleep(0.1) 
    
    while True:
        
        if vertical_speed() < -5.0:
            vessel.control.throttle = 0.8 #2.17 * 9.6 * vessel.mass / vessel.max_thrust
        elif vertical_speed() > 0:
            vessel.control.throttle = 0.93 * 9.6 * vessel.mass / vessel.max_thrust
        else:
            vessel.control.throttle = 9.6 * vessel.mass / vessel.max_thrust
            if vessel.situation == vessel.situation.landed or vessel.situation == vessel.situation.splashed:
                vessel.control.throttle = 0
                vessel.auto_pilot.disengage()
                vessel.auto_pilot.sas = True
                break  


def __fuel_chek():
    global stage 
    stage = int()   
    while len(vessel.parts.in_stage(stage)) > 0: # calcula quantos estagios a nave tem
        stage += 1 

    engine = vessel.parts.engines[-1].has_fuel
    if engine == False and stage > 0 :
        vessel.control.throttle = 0
        vessel.control.activate_next_stage()
        sleep(3)
        vessel.control.throttle = 1
        stage -= 1


def __telemetry():
    global conn
    global vessel
    global apoastro
    global periastro
    global altitude
    global surface_altitude
    global Speed
    global vertical_speed
    global horizontal_speed

    vessel = conn.space_center.active_vessel
    veloref = vessel.orbit.body.reference_frame

    apoastro = __addStream(vessel.orbit, 'apoapsis_altitude')
    periastro = __addStream(vessel.orbit, 'periapsis_altitude')
    altitude = __addStream(vessel.flight(), 'mean_altitude')
    surface_altitude = __addStream(vessel.flight(), 'surface_altitude')
    Speed = __addStream(vessel.flight(veloref), 'speed')
    vertical_speed = __addStream(vessel.flight(veloref), 'vertical_speed')
    horizontal_speed = __addStream(vessel.flight(veloref), 'horizontal_speed')
