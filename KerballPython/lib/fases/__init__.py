import math 
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
    global Speed_orbit
    global surface_gravity
    global time_to_apoapsis
    global gravitational_parameter
    global equatorial_radius
    global mass
    global max_thrust 

    vessel.auto_pilot.sas = False
    vessel.auto_pilot.engage()
    vessel.control.throttle = mass() * surface_gravity * 1.5 /(max_thrust())
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
        speed_orbit = math.sqrt(gravitational_parameter/(equatorial_radius + alt))
        time_burn = (speed_orbit - Speed_orbit()) / (max_thrust() / mass()) 

        frac = (- ((altitude() /45000)** 2) + (2 * altitude() /45000))
        if frac > 1 or frac < 0 or altitude() > 45000:
            frac = 1
        
        vessel.auto_pilot.target_pitch_and_heading(90 - int(90 * frac), dir)
        
        if alt > apoastro() > (alt * 0.9):
            vessel.control.throttle = mass() * surface_gravity * 1.4 /( max_thrust())

        if apoastro() > alt:
            vessel.control.throttle = 0

        if Speed_orbit() > 2000 and first_stage == 0 and altitude() > 45000:
            vessel.control.throttle = 0
            sleep(0.1)
            vessel.control.activate_next_stage()
            sleep(2)
            first_stage = 1
            vessel.control.throttle = 1

        if (time_burn / 2) <= time_to_apoapsis() and (alt - altitude()) < 4000:
            vessel.auto_pilot.target_pitch_and_heading( 0, dir)
            vessel.control.throttle = 1
            break
        atualiza_display()
        
    while True:
        __fuel_chek()
        
        if Speed_orbit() > 2000 and first_stage == 0:
            vessel.control.throttle = 0
            sleep(0.1)
            vessel.control.activate_next_stage()
            sleep(2)
            first_stage = 1
            vessel.control.throttle = 1

            
        if abs(periastro() - apoastro()) < 2000 or alt * 1.3 < apoastro():
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
    global mass
    global max_thrust


    vessel.control.throttle = 1
    sleep(1)
    vessel.auto_pilot.sas = True    
    vessel.control.throttle = 0
    
    while True:
        
        if vertical_speed() < 0:
            vessel.auto_pilot.sas_mode = vessel.auto_pilot.sas_mode.retrograde 
 
            try:
                d1 = distance_burning(Speed() - 25) + 1.0 * Speed() #((Speed() ** 2 - 625)/ (2*(max_thrust() / mass() - surface_gravity)))
                d2 = ((25 ** 2 - 25) / ( 2 * 4.9 ))
            except:
                d1 = 1000
                d2 = 500
                print(f'=============//============//================//===================//==============')
            
            if surface_altitude() <= d1 + d2 and d1 < 6000:                
                vessel.control.throttle = 1

            if surface_altitude() < 100:
                vessel.control.gear = True

            if Speed() <= 25:
                break

        sleep(0.1)
        atualiza_display()


    while True:
        try:
            d2 = (25 ** 2 - 25) / (2 * 4.9)
        except:
            d2 = 150
    
        if surface_altitude() < d2 or Speed() < 25:
            vessel.control.throttle = (4.9 / surface_gravity + 1) * surface_gravity * mass() / max_thrust()
            

        if Speed() < 5:
            pouso()
            break

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
    global retrograde_
    global mass
    global max_thrust
    global dir_vessel
    global dir_retrograde

    dire = tuple()
    vessel.auto_pilot.engage()
    vessel.auto_pilot.target_pitch_and_heading(90, 90) 
    vessel.control.gear = True
    caminho = 0
    sleep(0.1) 
    
    while True:

        if horizontal_speed() > 20:
            vessel.auto_pilot.disengage()
            vessel.auto_pilot.sas = True
            vessel.auto_pilot.sas_mode = vessel.auto_pilot.sas_mode.retrograde
            engine_angle = 0
            
        elif horizontal_speed() > 1:
            
            vessel.auto_pilot.sas = False
            vessel.control.rcs = True
            vessel.auto_pilot.engage()
            vessel.auto_pilot.target_pitch_and_heading(85, pos_retrograde() ) 
            
        else:
            vessel.auto_pilot.sas = False
            vessel.auto_pilot.engage()
            vessel.auto_pilot.target_pitch_and_heading(90, 90) 
        
        if vertical_speed() < -5.0:
            vessel.control.throttle = 1.2 * surface_gravity * mass() / max_thrust()
        elif vertical_speed() > 0:
            vessel.control.throttle = 0.9 * surface_gravity * mass() / max_thrust()
        else:
            vessel.control.throttle = 0.99 * surface_gravity * mass() / (max_thrust())
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
    global Speed_orbit
    global vertical_speed
    global horizontal_speed
    global surface_gravity
    global time_to_apoapsis
    global gravitational_parameter
    global equatorial_radius
    global retrograde_
    global mass
    global max_thrust
    global dir_retrograde
    global dir_vessel
    global ref_Surfece
    global veloref_orbit
    global tagetreft
    global SufVelReferance_frame
    global veloref
    global vet_velo
    global specific_impulse

    vessel = conn.space_center.active_vessel
    veloref = vessel.orbit.body.reference_frame
    veloref_orbit = vessel.orbit.body.orbital_reference_frame
    tagetreft = vessel.auto_pilot.reference_frame
    SufVelReferance_frame = vessel.surface_velocity_reference_frame
    ref_Surfece = vessel.surface_reference_frame
    surface_gravity = vessel.orbit.body.surface_gravity
    gravitational_parameter = vessel.orbit.body.gravitational_parameter
    equatorial_radius = vessel.orbit.body.equatorial_radius
    specific_impulse = vessel.specific_impulse

    apoastro = __addStream(vessel.orbit, 'apoapsis_altitude')
    periastro = __addStream(vessel.orbit, 'periapsis_altitude')
    time_to_apoapsis = __addStream(vessel.orbit, 'time_to_apoapsis')
    altitude = __addStream(vessel.flight(), 'mean_altitude')
    surface_altitude = __addStream(vessel.flight(), 'surface_altitude')
    Speed = __addStream(vessel.flight(veloref), 'speed')
    Speed_orbit = __addStream(vessel.flight(veloref_orbit), 'speed')
    vertical_speed = __addStream(vessel.flight(veloref), 'vertical_speed')
    horizontal_speed = __addStream(vessel.flight(veloref), 'horizontal_speed')
    mass = __addStream(vessel, 'mass')
    max_thrust = __addStream(vessel, 'max_thrust') 


    dir_retrograde = __addStream(vessel.flight(veloref), 'retrograde')
    vet_velo = __addStream(vessel.flight(veloref), 'velocity')


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


def pos_retrograde():
    global veloref
    global ref_Surfece
    global vet_velo
    global conn

    w = conn.space_center.transform_position(vet_velo(), veloref, ref_Surfece)

    dir_h = (-w[1], -w[2])

    angle = math.degrees(math.atan2(dir_h[1], dir_h[0]))

    if angle < 0:
        angle *= -1
        angle = 360 - angle

    return angle


def distance_burning(dv=0.0):
    global specific_impulse
    global surface_gravity
    global surface_altitude
    global mass
    global Speed
    global horizontal_speed
    global vertical_speed
    

    k = vessel.max_thrust / (vessel.specific_impulse * 5 * 9.8)

    speed_variation = dv + abs(math.sqrt(2 * surface_gravity * surface_altitude()))
    burning_time = (1 - 1 / math.e ** (speed_variation / (specific_impulse * 5 * 9.8 ) ) ) * mass() / k
    acceleration = speed_variation / burning_time

    distance = (Speed() ** 2 - 25) / (2 * acceleration) * math.sin(math.atan(- vertical_speed() / horizontal_speed()))

    print(max_thrust()/mass())
    print(acceleration)
    print(distance)
    print('========//===========//========')


    return distance



def test(altt=0):
    global specific_impulse
    global vessel
    a = specific_impulse
    b = vessel.parts.engines
    k = 0
    for c in b:
        if c.active:
            k += c.max_thrust / (5 * c.specific_impulse * 9.8)
            print(f'{c.max_thrust} -- {c.specific_impulse}')

    print(max_thrust())

    print(mass())

    print(k)
    print(a)
    print(b)
    