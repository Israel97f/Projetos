#!/usr/bin/lua
local test = {}
test.data = nil

function test:__sleep(ms)
    local time = os.clock()
    while os.clock() - time <= ms / 1000 do
        -- sleep
    end
end


for i = 0, 3 do
    test:__sleep(1000)
    print(i)
    test.data = i
end

return test