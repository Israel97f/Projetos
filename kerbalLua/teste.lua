#!/usr/bin/lua
local test = {}
test.data = nil
test.run = true

function test:__sleep(ms)
    local time = os.clock()
    while os.clock() - time <= ms / 1000 do
        -- sleep
    end
end

function writeFile(_data)
    local file = io.open("tempfile.data", "w+")
    if file ~= nil then
        for i, v in pairs(_data) do
            file:write(string.format("%-15s%s%10.2f%s", i, ":", v, "\n" ) )
            --print(file:read("*a"))
        end
        file:close()
    end
end

if test.run == true then

    for i = 0, 1200 do
        test:__sleep(50)
        --print(i)
        test.data = {
            velocidade = 0,
            altura     = 0,
            apoastro   = 0,
            periastro  = 0,
            gravidade  = 9.5,
            iterador   = i,
        }
        writeFile(test.data)

    end

end

return test