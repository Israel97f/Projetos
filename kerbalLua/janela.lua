package.cpath = "libYue/yue.so"
local gui = require "yue.gui"

local win = gui.Window.create{}
win.onclose = function () gui.MessageLoop.quit() end
win:settitle("kerbalua")
win:setcontentview(gui.Label.create("oi"))
win:setcontentsize{width = 400, height = 200}

win:center()
win:activate()

gui.MessageLoop.run()