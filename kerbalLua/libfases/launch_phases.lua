--[[
    usando lua versão 5.1.5
]]
-- importando módulos
local krpc = require "krpc"

-- módulo launch phases
local Launch_phases = {}

-- função que tenta iniciar uma conexão
function Launch_phases:conect()
    local success, content = pcall(krpc.conect)
    if success then
        self:__Init__(content)
    else
        print("problema ao tentar conectar")
    end
end
-- realiza o encerramento da conexão
function Launch_phases:disconect ()
    Conn:close()
end
-- executa um lançamento simples
function Launch_phases:launch(_height, _sas)
    Vessel.control.throttle = 1
    Vessel.auto_pilot.sas_mode = _sas or false
    if _sas then
        Vessel.auto_pilot:engage()
        Vessel:activate_next_stage()
    end
    while true do
        if apoapsis_altitude >=_height then
            Vessel.auto_pilot:disengage()
            break
        end
    end
end
-- pilota o foguete até a orbita
function Launch_phases:orbiter(_height, _type, _direction)
    Vessel.control.throttle = mass * surface_gravity * 1.5 / max_thrust
    Vessel.auto_pilot.sas_mode = false
    Vessel.auto_pilot:engage()
    Vessel.auto_pilot:target_pitch_and_heading(90, 90)
    Vessel:activate_next_stage()
    if _direction == 90 then
        if _type == "Equatorial" then
            _direction = 90
        elseif _type == "Polar" then
            _direction = 0
        elseif _type == "Rev_Equatorial" then
            _direction = 270
        elseif _type == "Rev_Polar" then
            _direction = 180
        end
    end
    while true do
        local orbital_speed = math.sqrt(gravitational_para/(equatorial_radius + _height))
        local time_burn = (orbital_speed - speed_orbit) / (max_thrust / mass)
        local quota = (- ((height_sea_level /45000) ^ 2) + (2 * height_sea_level /45000))
        if quota > 1 or height_sea_level > 45000 then
            quota = 1
        elseif quota < 0 then
            quota = 0
        end
        if _height > apoapsis_altitude > (_height * 0.9) then
            Vessel.control.throttle = mass * surface_gravity * 1.4 / max_thrust
        elseif apoapsis_altitude > _height then
            Vessel.control.throttle = 0
        end

        if time_burn / 2 <= time_to_apoapsis and _height - height_sea_level < 4000 then
            Vessel.auto_pilot:target_pitch_and_heading( 0, _direction)
            Vessel.control.throttle = 1
            break
        end
    end
    while true do
        if math.abs(apoapsis_altitude - periapsis_altitude) < 2000 or
           apoapsis_altitude > _height * 1.3 then
            Vessel.control.throttle = 0
            Vessel.auto_pilot:disengage()
            break
        end
    end
end
-- realiza o pouso vertical
function Launch_phases:vertical_landing()
    Vessel.control.throttle = 0
    Vessel.auto_pilot.sas_mode = true
    while true do
        if vertical_speed < 0 then
            Vessel.auto_pilot.sas_mode = Vessel.auto_pilot.sas_mode.retrograde
        end
        if true then
            break
        end
    end
end
-- inicialização
function Launch_phases:__Init__(_conn)
    Conn               = _conn
    Vessel             = Conn.space_center.active_vessel
    Veloref            = Vessel.orbit.body.reference_frame
    Veloref_orbit      = Vessel.orbit.body.orbital_reference_frame

    apoapsis_altitude  = Vessel.orbit.apoapsis_altitude
    periapsis_altitude = Vessel.orbit.periapsis_altitude
    time_to_apoapsis   = Vessel.orbit.time_to_apoapsis
    mass               = Vessel.mass
    surface_gravity    = Vessel.orbit.body.surface_gravity
    max_thrust         = Vessel.max_thrust
    equatorial_radius  = Vessel.orbit.body.equatorial_radius
    gravitational_para = Vessel.orbit.body.gravitational_parameter
    speed_orbit        = Vessel.flight(Veloref_orbit).speed
    vertical_speed     = Vessel.flight(Veloref).vertical_speed
    horizontal_speed   = Vessel.flight(Veloref).horizontal_speed
    height_sea_level   = Vessel.flight(Veloref).mean_altitude
end
return Launch_phases