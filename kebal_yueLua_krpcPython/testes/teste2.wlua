package.cpath = "UILua/yueLua54/win64/?.dll"
local gui = require "yue.gui"

local win = gui.Window.create({})

local checkbox = gui.Button.create({"sas", "checkbox"})
checkbox:setstyle{width = "10", height = "10", backgroundcolor = "#aaaaaa"}
local imagen1 = gui.Image.createfrompath("UILua/imagens/checkboxTrue@3x.png")
local imagen2 = gui.Image.createfrompath("UILua/imagens/checkboxFalse@3x.png")

checkbox:setimage(imagen2)

win.onclose = function() gui.MessageLoop.quit() end
win:setsizeconstraints({width = 400, height = 200}, {})
checkbox:setchecked(false)

local label = gui.Label.create("filfil")
label:setstyle{backgroundcolor = "#cfcfcf", color = "#000000", width = 80, height = 30}

checkbox.onclick = function ()
    checkbox:setchecked(not checkbox:ischecked())
    label:settext(tostring(checkbox:ischecked()))
    if checkbox:ischecked() then
        checkbox:setimage(imagen1)
    else
        checkbox:setimage(imagen2)
    end
end

local conteiner = gui.Container.create()
conteiner:addchildview(checkbox)
conteiner:addchildview(label)
win:setcontentview(conteiner)
win:activate()

gui.MessageLoop.run()