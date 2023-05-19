package.cpath = "UILua/yueLua54/win64/?.dll"
local gui = require "yue.gui"

local win = gui.Window.create({})
--win:settitle("Checkbox Example")
--win:setposition("center")
--win:setcontentsize({200, 100})
--win:setresizable(false)

local checkbox = gui.Button.create({"sas", "checkbox"})
checkbox:setstyle{width = 30, height = 30}
--checkbox:setposition({10, 10})
win.onclose = function() gui.MessageLoop.quit() end
win:setsizeconstraints({width = 400, height = 200}, {})
checkbox:setchecked(true)
win:setcontentview(checkbox)
win:activate()

--win:show()
gui.MessageLoop.run()