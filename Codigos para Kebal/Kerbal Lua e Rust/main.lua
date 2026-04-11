package.cpath = package.cpath .. ";./lua_ui_bridge/target/debug/?.dll;./lua_ui_bridge/target/release/?.dll;?.dll"
local lua_ui_bridge = require("lua_ui_bridge")

function itera()
    local i = 0
    return function ()
        i = i + 1
        return i
    end
end

local contador = itera()

local proc = nil

local frames = {
    controles = {
        window = { width = 450, height = 320 },
        button_size = { width = 160, height = 45 },
        display_size = { width = 270, height = 60 },
        display_position = "right",
        displays = {
            { label = "Velocidade", value = "0 m/s" },
            { label = "Altitude", value = "0 m" },
        },
        buttons = {
            { label = "Lançamento", callback = function() lua_ui_bridge.mudar_frame("lancamento") end },
            { label = "Orbitar", callback = function() lua_ui_bridge.mudar_frame("Orbitar") end },
            { label = "Aterrisagem", callback = function() lua_ui_bridge.mudar_frame("Aterrisagem") end },
            { label = "Atualizar dados", callback = function()
                lua_ui_bridge.definir_display("controles", "Velocidade", "1500 m/s")
                lua_ui_bridge.definir_display("controles", "Altitude", tostring(contador()) .. " m")
            end },
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

--lua_ui_bridge.definir_display("controles", "Velocidade", "1500 m/s")
--lua_ui_bridge.definir_display("controles", "Altitude", "1850 m")