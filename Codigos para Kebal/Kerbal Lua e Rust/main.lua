local controle = require "controle_de_nave"

local conn = controle.inicia_conexao()
controle.aterrisar(conn)
