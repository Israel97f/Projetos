-- executar com wlua.exe
package.cpath = "yueLua54/win64/?.dll"

local Ui = require "yue.gui"

-- cria uma janela
local win = Ui.Window.create{}
local box = Ui.Container.create()
box:setstyle{backgroundcolor = "#091F18"}
box:addchildview(Ui.Label.create("oi"))


win.onclose = function() Ui.MessageLoop.quit() end
win:setcontentview(box)
win:setcontentsize{width = 400, height = 200}
win:center()
win:activate()

Ui.MessageLoop.run()
