local file = {}

function file:Read()
    local _file =  io.open("temp_file.txt")
    if _file then
        local data = _file:read("a")
        _file:close()
        return data
    else
        print("Nao foi possivel ler o arquivo")
    end
end

function file:Write(string)
    local _file = io.open("temp_file.txt", "w+")
    if _file then
        _file:write(string)
        _file:close()
    else
        print("não foi possivel inserir dados no arquivo")
    end
end

function file:RecordData(table)
    local string = ""
    for k, v in pairs(table) do
        string = string .. tostring(v) .. ", "
    end
    file:Write(string)
end

return file