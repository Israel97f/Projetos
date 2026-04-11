package.cpath = package.cpath .. ";./lua_ui_bridge/target/debug/?.dll;./lua_ui_bridge/target/release/?.dll;?.dll"
local lua_ui_bridge = require("lua_ui_bridge")
local krpc = require("controle_de_nave")

local proc = nil

local frames = {
    controles = {
        window = { width = 450, height = 250 },
        button_size = { width = 160, height = 45 },
        buttons = {
            { label = "Lançamento", callback = function() lua_ui_bridge.mudar_frame("lancamento") end },
            { label = "Orbitar", callback = function() lua_ui_bridge.mudar_frame("Orbitar") end },
            { label = "Aterrisagem", callback = function() lua_ui_bridge.mudar_frame("Aterrisagem") end },
            { label = "Encerrar conexão", callback = function()  end },
        },
    },
    lancamento = {
        window = { width = 450, height = 250 },
        button_size = { width = 160, height = 45 },
        buttons = {
            { label = "Iniciar lançamento", callback = function ()
                os.execute('start /B lua fases.lua lancamento')
            end },
            { label = "Voltar", callback = function() lua_ui_bridge.mudar_frame("controles")
                if proc then
                    proc:close()
                end
             end },
        },
    },
    Orbitar = {
        window = { width = 450, height = 250 },
        button_size = { width = 160, height = 45 },
        buttons = {
            { label = "Iniciar órbita", callback = function ()
                os.execute('start /B lua fases.lua orbitar')
            end },
            { label = "Voltar", callback = function() lua_ui_bridge.mudar_frame("controles")
                if proc then
                    proc:close()
                end
             end },
        },
    },
    Aterrisagem = {
        window = { width = 450, height = 250 },
        button_size = { width = 160, height = 45 },
        buttons = {
            { label = "Iniciar aterrissagem", callback = function ()
                os.execute('start "" /B lua fases.lua aterrissagem')
            end },
            { label = "Voltar", callback = function() lua_ui_bridge.mudar_frame("controles") 
                if proc then
                    proc:close()
                end
            end },
        },
    },
}

lua_ui_bridge.abrir_janela({
    frames = frames,
    initial_frame = "controles",
    always_on_top = true,
})