local func = "1x^2 - 4x +5"

local function RaizQuadratica (fun)
    local raizes = {}
    local a, b, c = PegaCoeficientes(fun)
    local delta = 0
    delta = b^2 - 4 * a * c
    if delta >= 0 then
        raizes[1] = (-b + math.sqrt(delta))/(2 * a)
        raizes[2] = (-b - math.sqrt(delta))/(2 * a)
    else
        print("Essa funçâo possui raizes complexas")
        raizes[1] = tostring(-b/(2 * a)) .. ' + '.. tostring((math.sqrt(-delta))/(2 * a)) .. 'i'
        raizes[2] = tostring(-b/(2 * a)) .. ' - ' .. tostring((math.sqrt(-delta))/(2 * a)) ..'i'
    end
    return raizes
end

function PegaCoeficientes (fun)
    local iteraCoeficientes = string.gmatch(fun, '%d+')
    local coeficientes = {}
    local iteraSinais = string.gmatch(fun, '[+-]')
    local sinais = {}
    
    for i = 1, 4 do
        coeficientes[i] = iteraCoeficientes()
        sinais[i] = iteraSinais()
    end
    
    table.remove(coeficientes, 2)
    
    if #sinais == 2 then
        table.insert(sinais, 1, "+")
    end
    if #sinais == 3 then
        for i = 1, #sinais do
            coeficientes[i] = tonumber(sinais[i] .. coeficientes[i])
        end
    end
    print(table.unpack(coeficientes))
    return table.unpack(coeficientes)
end


local rz = RaizQuadratica(func)

print(rz[1], rz[2])