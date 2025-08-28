local mtz1 = {}
local mtz2 = {}

for i=1, 100 do
    table.insert(mtz1, i)
    table.insert(mtz2, i*2)
end

local function SomaMatriz (mz1, mz2)
    local SomaMat = {}
    for l, i in ipairs(mz1) do
        table.insert(SomaMat, mz2[i] + i )
    end
    return SomaMat
end
local soma = SomaMatriz(mtz1, mtz2)
local cont = 0

local function imprimeMatriz (mz)
    for i = 1, #mz do
        if cont == 0 then
            io.write("|")
        end
        io.write(string.format("%4d",mz[i]))
        cont = cont + 1
        if cont == 10 then
            io.write("|")
            io.write("\n")
            cont = 0
        end
    end
end


imprimeMatriz(mtz1)
print(string.format("%20s%s%20s"," ","+"," "))
imprimeMatriz(mtz2)
print(string.format("%20s%s%20s"," ","="," "))
imprimeMatriz(soma)
