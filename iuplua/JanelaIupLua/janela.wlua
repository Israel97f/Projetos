
local iup = require "iuplua"

local btn = iup.button{title = "Ok", bgcolor = "0 255 0", size = "50x20", border = "yes"}
local lb = iup.label{title = "Dados", border="YES", bordercolor="0 255 0"}
local dl = iup.dialog{
    title = "janela simples",
    size = "240x120",
    iup.vbox{
        lb,
        btn,
        margin = "10x10",
        gap = "10"
    }
}


dl:show()

if iup.MainLoopLevel() == 0 then
    iup.MainLoop()
end
