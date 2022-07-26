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
    Vessel.control.sas_mode = _sas or false
    Vessel.auto_pilot:engage()
    Vessel:activate_next_stage()
    while true do
        if 5 >=_height then
            break
        end
    end
end
-- pilota o foguete até a orbita
function Launch_phases:orbiter()
    while true do
        if true then
            break
        end
    end
end

-- inicialização
function Launch_phases:__Init__(_conn)
    Conn               = _conn
    Vessel             = Conn.space_center.active_vessel
    apoapsis_altitude  = Vessel.orbit.apoapsis_altitude
end
return Launch_phases