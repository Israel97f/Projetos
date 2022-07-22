
package.cpath = "libYue/yue.so"
local gui = require "yue.gui"



function screen1(root)

    local panel = gui.Container.create()
    panel:setstyle{
        width = 150,
        height = 180,
        flexdirection = "column",
        justifycontent = "space evenly",
        border = 10,
    }
    --panel:justifycontent( "space evenly")
    local display = gui.Container.create()
    display:setstyle{
        width = 230
    }

    local button1 = gui.Button.create("vai")
    button1:setenabled(true)
    button1:setstyle{
        margin = 5,
        width = 150,
        height = 20
    }
    button1.onclick = function () print("oi") end

    local button2 = gui.Button.create("vai 2")
    button2:setenabled(true)
    button2:setstyle{
        margin = 5,
        width = 150,
        height = 20
    }
    button2.onclick = function () print("oi 2") end

    local button3 = gui.Button.create("vai 3")
    button3:setenabled(true)
    button3:setstyle{
        margin = 5,
        width = 150,
        height = 20
    }
    button3.onclick = function () print("oi 3") end

    panel:addchildview(button1)
    panel:addchildview(button2)
    panel:addchildview(button3)

    --display:addchildview(mensagen)

    root:addchildview(panel)
    root:addchildview(display)
end

-- cria a janela
local win = gui.Window.create{}
win.onclose = function () gui.MessageLoop.quit() end
win:settitle("kerbalua")
win:setcontentsize{width = 400, height = 200}

local root = gui.Container.create()
root:setstyle{
    padding = 10,
    flexdirection = "row",
    height = 60,
}

screen1(root)


win:setcontentview(root)
win:center()
win:activate()

gui.MessageLoop.run()