def readInt(txt):
    while True:
        try:
            num = int(input(txt))
        except:
            print('\033[31mErro! digite um numero valido\033[m')
            continue
        else:
            break
    return num


def linha (tam=60):
    print('-' * tam)


def cabeç(txt):
    linha()
    print(f'{txt}'.center(60))
    linha()


def exibirCartela(lista, cor):
    cont = 0
    i = 0
    for c in lista:
        if cont >= 5:
            cont = 0
            print('')
            print('')
        if cor[i] == 0:
            print(f'{c:^12}', end='')
            cont += 1
        else:
            print(f'\033[33m{c:^12}\033[m', end='')
            cont += 1
        i += 1
    print('')
    linha()


def maarcar(lista, cor, valor=0):
    #valor = readInt('Marcar numero: ')
    if (valor * -1) in lista:
        p = lista.index(valor * -1)
        cor[p] = 0
    elif valor in lista:
        p =  lista.index(valor)
        cor[p] = 1
    return cor[:]


def clearCartela(lista):
    pad = list()
    for c in lista:
        pad.append(0)
    return pad[:]



