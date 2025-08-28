streserva = {false, true,false, false, true, false, true}
reserv = {2, 4, 7, 9,5 ,23, 12}

local function reservar (stresv, resv)
    local stateDaReserva = true
    local diponiveis = {}
    local cont = 0
    for i, v in ipairs(resv) do
        for id = 1, v do
            if stresv[id] == nil then
                cont = cont + 1
                stresv[id] = false
            end
        end
        if stresv[v] then
            stateDaReserva = false
        end
    end
    if not stateDaReserva then
        print('falha ao reservar essa sequencia de cadeiras')
        for i=1, #stresv do
            if stresv[i] ~= true then
                table.insert(diponiveis, i)
            end
        end
        return diponiveis
    else
        for i, v in ipairs(resv) do
            stresv[v] = true
        end
    end
    
    print("Sucesso na reserva")
    return stresv
end

streserva = reservar(streserva, reserv)
for i = 1, #streserva do
    print(i, streserva[i])
end
--print(table.unpack(streserva))