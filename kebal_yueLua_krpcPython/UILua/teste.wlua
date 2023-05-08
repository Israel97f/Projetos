-- Specify where to find yue.gui module.
package.cpath = "yueLua54/win64/?.dll"

local gui = require('yue.gui')

-- Create window and show it.
local win = gui.Window.create{}
win.onclose = function() gui.MessageLoop.quit() end
win:setcontentview(gui.Label.create('Content View'))
win:setcontentsize{width=400, height=400}
win:center()
win:activate()

-- Enter message loop.
gui.MessageLoop.run()