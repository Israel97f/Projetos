local gui = require "yue.gui"
local janela = gui.Window.create()
janela.onclose = gui.MessageLoop.quit
janela:settitle("meu primeiro código yue")
janela:setcontentsize{
    width = 400,
    height = 600
}
janela:center()
janela:actvate()
gui.MessageLoop.run()