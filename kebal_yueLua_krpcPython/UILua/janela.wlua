-- IIIIIIIIIII --
package.cpath = "UILua/yueLua54/win64/?.dll"
local Ui = require "yue.gui"
local file = require "gerenciador_tmp/temporary_file_manager"

-----------
function ScreeInicial()
    local button1 = Ui.Button.create("")
    local path = "UILua/imagens/but.png"
    local imagen = Ui.Image.createfrompath(path)
    button1:setimage(imagen)
    button1:setstyle{backgroundcolor = "#2B2B2B"}

    local label = Ui.Label.create("texto")
    label:setalign("start")
    label:settext("rabo de  cavalo")

    button1.onclick = function ()
        local path = "UILua/imagens/but2.png"
        local imagen = Ui.Image.createfrompath(path)
        button1:setimage(imagen)
        Ui.MessageLoop.postdelayedtask(100, function() ScreenChange(2) end)
    end

    return {button1}, {label}
end

function ScreeMode()
    local button1 = Ui.Button.create("suborbital")
    button1:setstyle{backgroundcolor = "#1B4BEF"}

    local button2 = Ui.Button.create("orbital")

    local button3 = Ui.Button.create("aterrissar")

    local button4 = Ui.Button.create("voltar")


    local label = Ui.Label.create("texto")
    label:setalign("start")
    label:setcolor("#FFFFFF")
    label:setstyle{backgroundcolor = "#FFFFFF"}
    label:settext("rabo de cavalo")

    button1.onclick = function () ScreenChange(3) end
    button2.onclick = function () ScreenChange(4) end
    button3.onclick = function () ScreenChange(5) end
    button4.onclick = function () ScreenChange(1) end

    return {button1, button2, button3, button4}, {label}
end

function ScreeSubOrbital()
    local button1 = Ui.Button.create("Iniciar")
    button1:setstyle{backgroundcolor = "#1B4BEF"}

    local button2 = Ui.Button.create("voltar")

    local selectionBox = Ui.ComboBox.create()
    for i, v in pairs({"Equatorial", "Polar", "Rev_Equarorial", "Rev_Polar"}) do selectionBox:additem(v) end
    selectionBox:setstyle{margintop = "20"}

    local selectionBox2 = Ui.Button.create{"SAS", "checkbox"}
    selectionBox2:setstyle{width = "30", height = "30", backgroundcolor = "#3B3B3B"}

    local label = Ui.Label.create("SAS")
    label:setstyle{color = "#ffffff", height = 25}
    local box = Ui.Container.create()
    box:setstyle{
        width = 50,
        height = 70,
        margintop = "10",
        backgroundcolor = "#3B3B3B",
        padding = "5",
        justifyContent = 'center',
        alignItems ='center',
    }

    local imagenTrue = Ui.Image.createfrompath("UILua/imagens/checkboxTrue@3x.png")
    local imagenFalse = Ui.Image.createfrompath("UILua/imagens/checkboxFalse@3x.png")

    selectionBox2:setimage(imagenFalse)
    selectionBox2:setchecked(false)

    box:addchildview(label)
    box:addchildview(selectionBox2)

    button1.onclick = function ()
        local data_ = {"SubOrbital", selectionBox:gettext(), selectionBox2:ischecked()}
        file:RecordData(data_); os.execute("python ControladorPython/iniciar.py")
        ScreenChange(5)
    end
    button2.onclick = function () ScreenChange(2) end

    selectionBox2.onclick = function ()
        selectionBox2:setchecked(not selectionBox2:ischecked())
        if selectionBox2:ischecked() then
            selectionBox2:setimage(imagenTrue)
        else
            selectionBox2:setimage(imagenFalse)
        end
        file:Write(tostring(selectionBox2:ischecked())) 
    end

    return {button1, button2}, {selectionBox, box}
end

function ScreeOrbital()
    local button1 = Ui.Button.create("Iniciar")
    button1:setstyle{backgroundcolor = "#1B4BEF"}

    local button2 = Ui.Button.create("voltar")

    local button5 = Ui.Button.create("voltar")
    button5.onclick = function () button2:enabled(false) end

    local selectionBox = Ui.ComboBox.create()
    for i, v in pairs({"Equatorial", "Polar", "Rev_Equarorial", "Rev_Polar"}) do selectionBox:additem(v) end
    selectionBox:setstyle{margintop = "20"}

    local selectionBox2 = Ui.ComboBox.create()
    selectionBox2:setstyle{margintop = "20"}
    for i = 0, 80 do selectionBox2:additem(tostring(70000 + 1000 * i)) end

    button1.onclick = function ()
        local data_ = {"Orbital", selectionBox:gettext(), selectionBox2:gettext()}
        file:RecordData(data_); os.execute("python ControladorPython/iniciar.py")
        ScreenChange(5) 
    end
    button2.onclick = function () ScreenChange(2) end
    button5:setstyle{margintop = "20"}

    return {button1, button2}, {selectionBox, selectionBox2,button5}
end

function ScreenDisplay ()
    local button1 = Ui.Button.create("abortar")
    Label = Ui.Label.create("")
    local font = Ui.Font.createfrompath("UILua/fonte/Azeret_Mono/AzeretMono-VariableFont_wght.ttf", 14)
    Label:setstyle{color = "#FFFFFF", backgroundcolor = "#0F0F0F"}
    Label:settext(file:Read())
    Label:setfont(font)
    Loop()
    return {button1}, {Label}
end

function UpdateDisplay ()
    Label:settext(file:Read())
    Subbox2:schedulepaint()
end

function Loop()
    UpdateDisplay()
    Ui.MessageLoop.postdelayedtask( 33,function () Loop() end)
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
