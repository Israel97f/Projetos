local function listaLetras (num)
    if num >= 1 and num <= 26 then
        local lisLetras = {}
        for i = 1, num do
            table.insert(lisLetras, string.char(i + 96))
        end
        return lisLetras
    else
        print("o numero escolhido nâo esta entre 1 e 26")
        return nil
    end
end
local list = listaLetras(28)
for l, i in ipairs(list) do
    io.write(string.format('%s  ', i))
end