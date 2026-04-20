local dados = {}

local function serialize (o, iden)
    iden = iden or ""
    if	type(o)	==	"number"	then
        io.write(o)
    elseif	type(o)	==	"string" then 
        io.write(string.format("%q", o))
    elseif	type(o)	==	"table"	then
        io.write(string.format("%s{\n", 
            string.sub(iden, 2)))
        for	k,v	in	pairs(o) do
            if type(k) ~= "number" then
                io.write(
                    string.format("  %s%s%s", iden, k, " = "))
            else
                io.write(" ", iden)
            end
            serialize(v, "  ")
            io.write(",\n")
        end
        io.write(string.format("%s}\n", iden))
    else
        error("cannot serialize	a " .. type(o)) 
    end
end

function dados.write(tabela)
    local fille = io.open("dados.ldf", "w")
    if fille then
        io.output(fille)
        io.write("return ")
        serialize(tabela)
        io.close(fille)
    end
end

function dados.read()
    local tabela = dofile("dados.ldf")
    return tabela
end

function dados.constroi_tabela(str)
    local tabela = {}
    for par in string.gmatch(str, "([^; ]+)") do
        local key, value = string.match(par, "([^=]+)=([^=]+)")
        if key and value then
            tabela[key] = tonumber(value) or value
        end
    end
    return tabela    
end

--dados.constroi_tabela("velocidade_orbital=0; altitude=0; tempo_para_apoastro=0; altitude_nivel_mar=0")

return dados