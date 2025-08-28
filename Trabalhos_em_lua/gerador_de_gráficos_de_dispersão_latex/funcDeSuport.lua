function CalcDesvioPadrao (fille)
    fille:seek('set') -- move o cursor para o inicio do arquivo
    --print(fille:read())
    local dados = LerAmostras(fille)
    local soma = 0
    local variancia = 0
    local desvio = 0
    for i = 1, #dados, 2 do
        soma = soma + dados[i]
    end
    for i = 1, #dados, 2 do
        variancia = variancia + (tonumber(dados[i]) - 2* soma/#dados )^2
    end
    variancia = 2 * variancia/(#dados - 1)
    desvio = (variancia)^(1/2)
    --print(desvio)
    return desvio
end

function LerAmostras (fille)
    local dados = {}
    local arqui = ""
    for i in fille:lines() do
        arqui = string.gmatch(i, '(%d+.%d+)')
        table.insert(dados, arqui())
        table.insert(dados, arqui())
        --print(dados[#dados -1], dados[#dados])
    end
    return dados
end


--[[
local fille = io.open("dados.txt")
CalcDesvioPadrao(fille)
fille:close()
--]]
 return CalcDesvioPadrao