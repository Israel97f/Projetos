
package.cpath = "libYue/lua_yue_lua_5.1_v0.11.0_win_x64/yue.dll" --"libYue/yue.so"
local gui = require "yue.gui"
--local test = require "teste"
local labelAtual = nil


function writesOnDisplay(_data)
    if _data ~= nil and type(_data) == "string" and _data ~= '' then
        labelAtual:setalign("start")
        labelAtual:settext(_data)
    end
end

function updateDisplay()
    local text = readfile()
    if text ~= nil then
        writesOnDisplay(text)
    end
end

function readfile()
    local data = nil
        local file = io.open("tempfile.data", "r")
        if file ~= nil then
            data = file:read("*a")
            file:close()
        end
    return data
end

function screen1(root)

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
        backgroundcolor = "#000f0f",
        padding = 20

    }
    -- cria um label
    local mens = gui.Label.create("1")
    mens:setstyle{
        flex = 1
    }
    labelAtual = mens
    mens:settext("hi")
    display:addchildview(mens)

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
        backgroundcolor = "#00D998"
    }
    local display = gui.Container.create()
    display:setstyle{
        flex = 1,
        backgroundcolor = "#091F18",
        padding = 20

    }
    -- cria um label
    local mens = gui.Label.create("1")
    mens:setstyle{
        flex = 1
    }
    labelAtual = mens
    display:addchildview(mens)

    -- cria o 1° botão
    local button1 = gui.Button.create("vai")
    button1:setenabled(true)
    button1:setstyle{
        margin_bottom = 10,
        width = 150,
        height = 20
    }
    button1.onclick = function ()  --teste23(display)
        --test.run = true
        _ = io.popen("lua teste.lua", "r")
        --des(display, mens)
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
        screen1(root)
        root:removechildview(panel)
        root:removechildview(display)
    end

    panel:addchildview(button1)
    --panel:addchildview(button2)
    panel:addchildview(button3)

    root:addchildview(panel)
    root:addchildview(display)
end
-- função loop
i = 0
function __loop(ms)
    i = i + 1
    --writesOnDisplay(tostring(i).. "\n".. tostring(readfile()))
    updateDisplay()
    --print(readfile())
    gui.MessageLoop.postdelayedtask(ms, function() __loop(ms) end)
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

screen1(root)

win:setcontentview(root)
win:center()
win:activate()

print("1-")


gui.MessageLoop.posttask(function () print("---") end)
local ms = 33
gui.MessageLoop.postdelayedtask(ms, function () __loop(ms) end)


gui.MessageLoop.run()
print("2-")