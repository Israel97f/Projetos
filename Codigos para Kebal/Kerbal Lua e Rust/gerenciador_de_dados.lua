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

return dados