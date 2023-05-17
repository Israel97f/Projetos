-- executar com wlua.exe
package.cpath = "yueLua54/win64/?.dll"
local Ui = require "yue.gui"

-----------
function ScreeInicial()
    local button1 = Ui.Button.create("")
    button1:setstyle{backgroundcolor = "#2B2B2B"}
    button1.onclick = function ()
        local path = "imagens/but2.png"
        local imagen = Ui.Image.createfrompath(path)
        button1:setimage(imagen)
        Ui.MessageLoop.postdelayedtask(100, function() ScreenChange(2) end)
        end

    local path = "imagens/but.png"
    local imagen = Ui.Image.createfrompath(path)
    button1:setimage(imagen)

    local label = Ui.Label.create("texto")
    label:setalign("start")
    label:settext("rabo de  cavalo")
    return {button1}, {label}
end

function ScreeMode()
    local button1 = Ui.Button.create("suborbital")
    button1:setstyle{backgroundcolor = "#1B4BEF"}
    button1.onclick = function () ScreenChange(3) end
    local button2 = Ui.Button.create("orbital")
    button2.onclick = function () ScreenChange(4) end
    local button3 = Ui.Button.create("aterrissar")
    button3.onclick = function () ScreenChange(5) end
    local button4 = Ui.Button.create("voltar")
    button4.onclick = function () ScreenChange(1) end

    local label = Ui.Label.create("texto")
    label:setalign("start")
    label:setcolor("#FFFFFF")
    label:setstyle{backgroundcolor = "#FFFFFF"}
    label:settext("rabo de cavalo")
    return {button1, button2, button3, button4}, {label}
end

function ScreeSubOrbital()
    local button1 = Ui.Button.create("Iniciar")
    button1:setstyle{backgroundcolor = "#1B4BEF"}
    button1.onclick = function () ScreenChange(5) end
    local button2 = Ui.Button.create("voltar")
    button2.onclick = function () ScreenChange(2) end

    local button5 = Ui.Button.create("voltar")
    button5.onclick = function () button2:enabled(false) end
    button5:setstyle{margintop = "20"}

    local selectionBox = Ui.ComboBox.create()
    for i, v in pairs({"Equatorial", "Polar", "Rev_Equarorial", "Rev_Polar"}) do selectionBox:additem(v) end
    selectionBox:setstyle{margintop = "20"}

    local selectionBox2 = Ui.ComboBox.create()
    selectionBox2:setstyle{margintop = "20"}
    for i = 0, 80 do selectionBox2:additem(tostring(70000 + 1000 * i)) end

    return {button1, button2}, {selectionBox, selectionBox2,button5}
end

function ScreeOrbital()
    local button1 = Ui.Button.create("Iniciar")
    button1:setstyle{backgroundcolor = "#1B4BEF"}
    button1.onclick = function () ScreenChange(5) end
    local button2 = Ui.Button.create("voltar")
    button2.onclick = function () ScreenChange(2) end

    local button5 = Ui.Button.create("voltar")
    button5.onclick = function () button2:enabled(false) end
    button5:setstyle{margintop = "20"}

    local selectionBox = Ui.ComboBox.create()
    for i, v in pairs({"Equatorial", "Polar", "Rev_Equarorial", "Rev_Polar"}) do selectionBox:additem(v) end
    selectionBox:setstyle{margintop = "20"}

    local selectionBox2 = Ui.ComboBox.create()
    selectionBox2:setstyle{margintop = "20"}
    for i = 0, 80 do selectionBox2:additem(tostring(70000 + 1000 * i)) end

    return {button1, button2}, {selectionBox, selectionBox2,button5}
end

function ScreenDisplay ()
    local button1 = Ui.Button.create("abortar")
    local Label = Ui.Label.create("")

    return {button1}, {Label}
end

function ScreenChange(tela)
    Index = tela
    RefreshScreen()
end

function RefreshScreen()
    local screens = {ScreeInicial, ScreeMode, ScreeSubOrbital, ScreeOrbital, ScreenDisplay}
    local panelConponents, displayComponents = screens[Index]()

    for i = 1, Subbox:childcount() do
        if Subbox:childcount() ~= 0 then
            Subbox:removechildview(Subbox:childat(1))
        end
    end

    for i = 1, Subbox2:childcount() do
        if Subbox2:childcount() ~= 0 then
            Subbox2:removechildview(Subbox2:childat(1))
        end
    end

    for i, v in ipairs(panelConponents) do
        Subbox:addchildviewat(v, i)
        Subbox:schedulepaint()
    end

    for i, v in ipairs(displayComponents) do
        Subbox2:addchildviewat(v, i)
        Subbox2:schedulepaint()
    end
end

-- cria uma janela
local win = Ui.Window.create{}
local box = Ui.Container.create()
box:setstyle{backgroundcolor = "#3B3B3B", flexdirection = "row", }

Subbox = Ui.Container.create()
Subbox:setstyle{
    margintop = "10",
    marginbottom = "10",
    marginleft = "10",
    marginright = "0",
    width = "90",
    backgroundcolor = "#2B2B2B",
    justifycontent = "center"
}

Subbox2 = Ui.Container.create()
Subbox2:setstyle{
    margintop = "10",
    marginbottom = "10",
    marginleft = "10",
    marginright = "10",
    padding = "10",
    backgroundcolor = "#181818",
    flex = "1",
    flexgrow = "1",
    minwidth = "140",
    flexshrink = "1"
}

Index = 1

RefreshScreen()

box:addchildview(Subbox)
box:addchildview(Subbox2)

win.onclose = function() Ui.MessageLoop.quit() end
win:setcontentview(box)
win:setsizeconstraints({width = 400, height = 200}, {})
win:setalwaysontop(true)
win:center()
win:activate()

Ui.MessageLoop.run()
