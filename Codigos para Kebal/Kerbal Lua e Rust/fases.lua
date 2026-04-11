package.cpath = package.cpath .. ";./lib_rust/target/release/?.dll;./lib_rust/target/debug/?.dll;?.dll"
local krpc = require("controle_de_nave")


local argumentos = arg or {}
local client = krpc.inicia_conexao()

if argumentos[1] == "lancamento" then
    krpc.lancamento(client)
elseif argumentos[1] == "orbitar" then
    krpc.lancamento(client)
    krpc.orbitar(client)
elseif argumentos[1] == "aterrissagem" then
    krpc.aterrissar(client)
end
