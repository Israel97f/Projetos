def IntConect():
    try:
        conn = krpc.conect()
    except:
        print('Erro ao executar a conexão')
    else:
        print('\033[32mConexão feia com sucesso\033[m')

def Lauch():
    vessel.control.activate_next_stage()
    pass
