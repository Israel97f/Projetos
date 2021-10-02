import krpc


def IntConect():
    i = 0
    while True:
        i +=1
        try:
            global conn 
            conn = krpc.connect()
        except:
            print(f'\033[31m{"-" * 8}Erro ao executar a conexão{"-" * 8}\033[m')
            if i > 9 :
                break
            else:
                continue
        else:
            print(f'\033[32m{"-" * 8}Conexão feita com sucesso{"-" * 8}\033[m')
            break

def Lauch():
    global conn
    vessel = conn.space_center.active_vessel
    vessel.control.throttle = 1
    vessel.control.activate_next_stage()
