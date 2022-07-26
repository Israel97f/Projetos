-- caminho do yue
package.cpath = 'yue-lua-5-1/yue.so'

function test()
    cont = 1
    while true do
        cont = cont + 1
        print(cont)
        if  cont >= 100000 then
           break 
        end
    end
end

local gui = require 'yue.gui'

-- cria e exibe uma janela
local janela = gui.Window.create{}
janela.onclose = function() gui.MessageLoop.quit() end
janela:settitle("hello wold")
janela:setcontentview(gui.Label.create("meu primeiro código yue"))
janela:setcontentsize{
    width = 400,
    height = 200
}
janela:center()
janela:activate()


 -- exibe a mensagem
gui.MessageLoop.run()
test()