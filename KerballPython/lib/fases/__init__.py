from math import sqrt
import krpc
from time import sleep

# experimemtal -------
param = None
def get_parametro(parametro=None):
    global param
    param = parametro


def atualiza_display():
    global param
    if param != None:
        param()
#----------------------


def IntConect():
    i = 0
    while True:
        i +=1
        try:
            global conn 
            conn = krpc.connect()   
        except:
            print(f'\033[31m{"-" * 8}Erro ao executar a conexão{"-" * 8}\033[m')
            conn = krpc.connect()   
            if i >= 1:
                break
            else:
                continue
            
        else:       
            __telemetry()
            print(f'\033[32m{"-" * 8}Conexão feita com sucesso{"-" * 8}\033[m')
            break


def con_state():
    global conn
    global Speed
    state = bool()
    try:
        conn.krpc.get_status().version
    except:
        state = False
    else:
        state = True
    
    return state


def Disconect():
    global conn
    conn.close()
    print(f'\033[32m{"-" * 8}Conexão encerrada{"-" * 8}\033[m')


def Lauch(alt=0, sas=False):
    global vessel
    global apoastro

    vessel.control.throttle = 1
    vessel.control.activate_next_stage()
    vessel.auto_pilot.sas = False
    vessel.auto_pilot.engage()
    vessel.auto_pilot.target_pitch_and_heading(90, 90)
    while True:
        if apoastro() >= alt:
            vessel.control.throttle = 0
            vessel.auto_pilot.disengage()
            break

        __fuel_chek()
        atualiza_display()

        

def Orbitador(alt=70000, type='Equatorial', dir=90):
    global vessel
    global altitude   
    global apoastro 
    global periastro 
    global Speed 
    global surface_gravity
    global time_to_apoapsis
    global gravitational_parameter
    global equatorial_radius 

    vessel.auto_pilot.sas = False
    vessel.auto_pilot.engage()
    vessel.control.throttle = vessel.mass * surface_gravity * 1.5 /( vessel.max_thrust)
    first_stage = 0

    if dir == 90:
        if type == "Equatorial":  # linha opicional
            dir = 90
        elif type == "Polar":
            dir = 0
        elif type == "Rev_Equarorial":
            dir = 270
        elif type == "Rev_Polar":
            dir = 180
        else:
            dir = 90

    while True:
        __fuel_chek()   
        speed_orbit = sqrt(gravitational_parameter/(equatorial_radius + alt))
        time_burn = (speed_orbit - Speed()) / (vessel.max_thrust / vessel.mass) 

        frac = (- ((altitude() /45000)** 2) + (2 * altitude() /45000))
        if frac > 1 or frac < 0 :
            frac = 1
        
        vessel.auto_pilot.target_pitch_and_heading(90 - int(90 * frac), dir)
        
        if alt > apoastro() > (alt * 0.9):
            vessel.control.throttle = vessel.mass * surface_gravity * 1.4 /( vessel.max_thrust)

        if apoastro() > alt:
            vessel.control.throttle = 0

        if (time_burn / 2) == time_to_apoapsis() and (alt - altitude()) < 4000:
            vessel.control.throttle = 1
            break
        atualiza_display()
        
    while True:
        __fuel_chek()
        
        if Speed() > 1900 and first_stage == 0:
            vessel.control.throttle = 0
            sleep(0.1)
            vessel.control.activate_next_stage()
            sleep(2)
            first_stage = 1
            vessel.control.throttle = 1

        print(Speed())
    
        if abs(periastro() - apoastro()) < 2000 or alt * 1.3 > apoastro():
            vessel.control.throttle = 0
            vessel.auto_pilot.disengage()
            break

        atualiza_display()


def verticalLanding():
    global vessel
    global Speed
    global vertical_speed 
    global surface_altitude
    global surface_gravity

    vessel.control.throttle = 1
    sleep(1)
    vessel.auto_pilot.sas = True    
    vessel.control.throttle = 0
    
    while True:
        
        if vertical_speed() < 0:
            vessel.auto_pilot.sas_mode = vessel.auto_pilot.sas_mode.retrograde            
            try:
                d = ((Speed() ** 2 - 2500)/ (2*(vessel.max_thrust / vessel.mass - surface_gravity))) + 100
            except:
                d = 1000
            
            if surface_altitude() <= d and d < 6000:                
                vessel.control.throttle = 1
                break
        sleep(0.1)
        atualiza_display()


    while True:
        try:
            delta = ((3 ** 2 - 50 ** 2) / ((-2) * (((vessel.max_thrust / vessel.mass ) * 0.8) - (surface_gravity))))
        except:
            delta = 250
    
        if surface_altitude() < (delta + 50):
            pouso()
            break
        
        if Speed() <= 50.00 and vertical_speed() < 0:
            vessel.control.throttle = 0.99 * surface_gravity * vessel.mass / vessel.max_thrust
        atualiza_display()


def  __addStream(classe, metodo):
    global conn
    return conn.add_stream(getattr, classe, metodo )


def pouso():
    global vessel
    global surface_altitude   
    global vertical_speed 
    global horizontal_speed 
    global surface_gravity

    vessel.auto_pilot.engage()
    vessel.auto_pilot.target_pitch_and_heading(90, 90) 
    vessel.control.gear = True
    sleep(0.1) 
    
    while True:

        if horizontal_speed() > 10:
            vessel.auto_pilot.disengage()
            vessel.auto_pilot.sas = True
            vessel.auto_pilot.sas_mode = vessel.auto_pilot.sas_mode.retrograde 
        else:
            vessel.auto_pilot.sas = False
            vessel.auto_pilot.engage()
            vessel.auto_pilot.target_pitch_and_heading(90, 90) 
        
        if vertical_speed() < -5.0:
            vessel.control.throttle = 0.8 #2.17 * 9.6 * vessel.mass / vessel.max_thrust
        elif vertical_speed() > 0:
            vessel.control.throttle = 0.93 * surface_gravity * vessel.mass / vessel.max_thrust
        else:
            vessel.control.throttle = surface_gravity * vessel.mass / vessel.max_thrust
            if vessel.situation == vessel.situation.landed or vessel.situation == vessel.situation.splashed:
                vessel.control.throttle = 0
                vessel.auto_pilot.disengage()
                vessel.auto_pilot.sas = True
                break 
        atualiza_display()


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
    global surface_gravity
    global time_to_apoapsis
    global gravitational_parameter
    global equatorial_radius

    vessel = conn.space_center.active_vessel
    veloref = vessel.orbit.body.reference_frame
    surface_gravity = vessel.orbit.body.surface_gravity
    gravitational_parameter = vessel.orbit.body.gravitational_parameter
    equatorial_radius = vessel.orbit.body.equatorial_radius

    apoastro = __addStream(vessel.orbit, 'apoapsis_altitude')
    periastro = __addStream(vessel.orbit, 'periapsis_altitude')
    time_to_apoapsis = __addStream(vessel.orbit, 'time_to_apoapsis')
    altitude = __addStream(vessel.flight(), 'mean_altitude')
    surface_altitude = __addStream(vessel.flight(), 'surface_altitude')
    Speed = __addStream(vessel.flight(veloref), 'speed')
    vertical_speed = __addStream(vessel.flight(veloref), 'vertical_speed')
    horizontal_speed = __addStream(vessel.flight(veloref), 'horizontal_speed')
    


def get_telemetry():
    global apoastro
    global periastro
    global altitude
    global surface_altitude
    global Speed
    global vertical_speed
    global horizontal_speed
    global surface_gravity

    return [ apoastro(), 
    periastro(), 
    altitude(),
    surface_altitude(),
    Speed(),
    vertical_speed(),
    horizontal_speed(),
    surface_gravity]


def test(altt):
    global time_to_apoapsis
    global gravitational_parameter
    global equatorial_radius 
    global vessel

    global Speed 

    speed_orb = sqrt(gravitational_parameter/(equatorial_radius + altt))
    time_burn = (speed_orb - Speed())/ (vessel.max_thrust / vessel.mass)

    if time_burn / 2 == time_to_apoapsis():
        pass