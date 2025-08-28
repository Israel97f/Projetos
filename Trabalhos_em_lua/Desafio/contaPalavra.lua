local fille = io.open("tempfille.txt")

local function Contador (arq)
    local texto = arq:read('*a')
    local contadorCaracteres = 0
    local contadorPalavras = 0
    local repetePalavras = {}
    
    for _ in string.gmatch(texto, '[%aéêãáõíç]') do
        contadorCaracteres = contadorCaracteres + 1
    end
    
    for v in string.gmatch(texto, '[%aéêãáõíç]+') do
        if string.len( v or '') > 2 then
            contadorPalavras = contadorPalavras + 1
            repetePalavras[v] = (repetePalavras[v] or 0) + 1
        end
    end
    
    return {contadorCaracteres, contadorPalavras, repetePalavras}
end

local dados = Contador(fille)
print(dados[1], dados[2], dados[3])

for k, v in pairs(dados[3]) do
    print(k, v)
end

fille:close()