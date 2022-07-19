-- caminho do yue
package.cpath = 'yue-lua-5-1/yue.so'

local gui = require 'yue.gui'

-- cria e exibe uma janela
local janela = gui.Window.create{}
janela.onclose = function() gui.MessageLoop.quit() end
janela:settitle("hello wold")
janela:setcontentview(gui.Label.create("meu primeiro código yue"))
janela:setcontentsize{
    width = 400,
    height = 600
}
janela:center()
janela:activate()

 -- exibe a mensagem
gui.MessageLoop.run()