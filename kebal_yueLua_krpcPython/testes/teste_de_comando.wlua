local file  = require "gerenciador_tmp/temporary_file_manager"

function Sleep (ms)
    local t = os.clock() * 1000
    while (os.clock() * 1000) - t < ms do  end
end


for i = 0, 500 do
    local str = "Iterador:    " .. tostring(i)
    file:Write(str)
    Sleep(100)
end