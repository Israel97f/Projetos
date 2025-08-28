local hora = "12:00:00"

local function convHora (hr)
    local totalSegundos = 0
    for i in string.gmatch(hr, '%d+') do
        totalSegundos = (totalSegundos + tonumber(i)) * 60
    end
    return totalSegundos / 60
end

local function convHora2 (hr)
    local capHora = string.gmatch(hr, '%d+')
    return capHora() * 3600 + capHora() * 60 + capHora()
end

local horsec = convHora(hora)
local horsec2 = convHora2(hora)

print(horsec)
print(horsec2)