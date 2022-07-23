
package.cpath = "libYue/yue.so"
local gui = require "yue.gui"

local Cena = { 
    --inicial = screen1,
    secundaria = screen2
}
local screen = "inicial"


function teste23(display)
    local message = gui.TextEdit.create()
    message:setstyle{width = 100, height = 40}
    display:addchildview(message)    
    
        
    for i = 0, 1000 do
        message:settext(tostring(i))
    end
end


function Cena:screen1(root)

    local panel = gui.Container.create()
    panel:setstyle{
        width = 150,
        margin_right = 10,
        flexdirection = "column",
        justifycontent = "space-evenly",
        backgroundcolor = "#7f7f7f"
    }
    local display = gui.Container.create()
    display:setstyle{
        flex = 1,
        backgroundcolor = "#000f0f"

    }
    -- cria o 1° botão
    local button1 = gui.Button.create("vai")
    button1:setenabled(true)
    button1:setstyle{
        margin_bottom = 10,
        width = 150,
        height = 20
    }
    button1.onclick = function ()
        
        screen2(root)
        root:removechildview(panel)
        root:removechildview(display)

    end

    -- cria o 2° botão
    local button2 = gui.Button.create("vai 2")
    button2:setenabled(true)
    button2:setstyle{
        margin_bottom = 10,
        width = 150,
        height = 20
    }
    button2.onclick = function () print("oi 2") end

    -- cria o 3° botão 
    local button3 = gui.Button.create("vai 3")
    button3:setenabled(true)
    button3:setstyle{
        margin_bottom = 10,
        width = 150,
        height = 20
    }
    button3.onclick = function () print("oi 3") end

    panel:addchildview(button1)
    panel:addchildview(button2)
    panel:addchildview(button3)

    root:addchildview(panel)
    root:addchildview(display)
    return {}
end


function screen2(root)

    local panel = gui.Container.create()
    panel:setstyle{
        width = 150,
        margin_right = 10,
        flexdirection = "column",
        justifycontent = "space-evenly",
        backgroundcolor = "#ff7f7f"
    }
    local display = gui.Container.create()
    display:setstyle{
        flex = 1,
        backgroundcolor = "#f0ff0f"

    }
    -- cria o 1° botão
    local button1 = gui.Button.create("vai")
    button1:setenabled(true)
    button1:setstyle{
        margin_bottom = 10,
        width = 150,
        height = 20
    }
    button1.onclick = function () 
        teste23(display)
    end

    -- cria o 2° botão
    local button2 = gui.Button.create("vai 2")
    button2:setenabled(true)
    button2:setstyle{
        margin_bottom = 10,
        width = 150,
        height = 20
    }
    button2.onclick = function () print("oi 2") end

    -- cria o 3° botão 
    local button3 = gui.Button.create("vai 3")
    button3:setenabled(true)
    button3:setstyle{
        margin_bottom = 10,
        width = 150,
        height = 20
    }
    button3.onclick = function ()
        Cena:screen1(root)
        root:removechildview(panel)
        root:removechildview(display)
    end

    panel:addchildview(button1)
    --panel:addchildview(button2)
    panel:addchildview(button3)

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
    flex = 1,
    flexdirection = "row",
    --height = 60,
}

Cena:screen1(root)

win:setcontentview(root)
win:center()
win:activate()

gui.MessageLoop.run()