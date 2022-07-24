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
        local file = io.open("tempfile.data",  "w+")

        if file ~= nil then
            file:write(_data)
            --print(file:read("*a"))
            file:close()

    end
end

if test.run == true then

    for i = 0, 300 do
        test:__sleep(100)
        print(i)
        test.data = string.format([[
            velocidade:
            aceleração:
            gravidade :
            empuxo    :
            batata    :
            iterador  : %i
        ]], i)
        writeFile(test.data)

    end

end

return test