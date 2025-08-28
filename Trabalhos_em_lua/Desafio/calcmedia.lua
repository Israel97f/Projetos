---[[
local alunos = {
    [ "Andre" ] = {8.0, 6.0, 9.5},
    [ "João"  ] = {8.0, 2.0, 9.5},
    [ "Maris" ] = {7.0, 6.0, 9.5},
    [ "Luana" ] = {10.0, 10.0, 9.5},
    ["Andreia"] = {4.0, 6.0, 9.5},
    ["Brenda" ] = {9.0, 9.0, 9.5},
    [ "Lucas" ] = {4.0, 6.0, 0.0}
} --]]

local function CalculaMedia(dict)
    local aprova = {}
    for k, v in pairs(dict) do
        if ((v[1] + v[2] + v[3]) / 3) >= 7 then
            aprova[k] = "Aprovado"
        else
            aprova[k] = "Reprovado"
        end
    end
    return aprova
end

local listAprov = CalculaMedia(alunos)
for k, v in pairs(listAprov) do
    print(k, v)
end