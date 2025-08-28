local func = {}

function func.Delay(s)
    local i = 0
    while i < 1000000 * s do
        i = i + 1
    end
end

local audio = '/sdcard/Music/"Saveiro pega no BREU.mp3"'

fille = io.popen(string.format("mplayer %s", audio), 'r')
local cont = 0
local str = '-'
local stado = false
while fille do
    
    print(string.format("%s", str))
    str = string.rep('-', cont)
    if cont > 49 or cont < 1 then
        stado = not stado
    end
    if not stado then
        cont = cont - 1
        
    else 
        cont = cont + 1
    end
    
    func.Delay(1)
end
