
local file = require "gerenciador_tmp/temporary_file_manager"


file:RecordData({6 , 98})

os.execute("python testes/teste.py")