def arqExiste(arq):
    try:
        a = open(arq, 'rt')
        a.close()
    except FileNotFoundError:
        return False
    else:
        return True


def criArquivo(arq):
    if not arqExiste(arq):
        try:
            a = open(arq, 'wt+')
            a.close()
        except:
            print('\033[31mErro ao criar o arquivo\033[m')
        else:
            print('\033[32mArquivo criado com sucesso\033[m')


def writeAquivo(arq, lista):
    try:
        #a = open(arq, 'w')
        a = open(arq, 'wt')
        for c in lista:
            a.write(f'{c}\n')
    except:
        print('\033[31mErro ao escrever no arquivo\033[m')
    finally:
        a.close()


def readArquivo(arq):
        marc = list()
        try:
            a = open(arq, 'rt')
        except:
            print('\033[31mErro ao ler o arquivo\033[m')
        else:

            for c in a:
                marc.append(int(c.replace('\n', '')))
        finally:
            a.close()
        return marc[:]


