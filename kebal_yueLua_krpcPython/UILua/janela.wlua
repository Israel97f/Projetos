-- executar com wlua.exe
package.cpath = "yueLua54/win64/?.dll"

local Ui = require "yue.gui"

-- cria uma janela
local win = Ui.Window.create{}
local box = Ui.Container.create()
box:setstyle{backgroundcolor = "#091F18", flexdirection = "row", }

local subbox = Ui.Container.create()
subbox:setstyle{
    margintop = "10",
    marginbottom = "10",
    marginleft = "10",
    marginright = "0",
    width = "80",
    backgroundcolor = "#0F0F0F",
    justifycontent = "center"
}
local subbox2 = Ui.Container.create()

subbox2:setstyle{
    margintop = "10",
    marginbottom = "10",
    marginleft = "10",
    marginright = "10",
    backgroundcolor = "#FFFFFF",
    flex = "1",
    flexgrow = "1",
    minwidth = "140",
    flexshrink = "1"
}

local button1 = Ui.Button.create("connect")
button1:setstyle{style = "circular"}
local label = Ui.Label.create("texto")

box:addchildview(subbox)
box:addchildview(subbox2)
subbox:addchildview(button1)
subbox2:addchildview(label)

win.onclose = function() Ui.MessageLoop.quit() end
win:setcontentview(box)
win:setsizeconstraints({width = 400, height = 200}, {})
win:setalwaysontop(true)
win:center()
win:activate()

Ui.MessageLoop.run()
