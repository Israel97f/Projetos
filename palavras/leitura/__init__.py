#import io
def arquivoExite(arq):
    try:
        a = open(arq, 'rt')
        a.close()
    except FileNotFoundError:
        #print('\033[31mArquivo não encontrado\033[m')
        return False
    else:
        return True


def criarArquivo(arq):
    try:
        a = open(arq, 'wt+')
        a.close()
    except:
        print('\033[31mOuve um probllema ao criar o arquivo\033[m')
    else:
        print(f'\033[32mSucesso ao criar o arquivo\033[m')


def lerArquivo(arq):
    palavras = list()
    try:
        a = open(arq, 'rt', encoding="utf8") # io.open(arq, 'rt', encoding="utf8") para quando a linha for um comando
    except:
        print('\033[31mOuve um probllema ao ler o arquivo\033[m')
    else:
        for linha in a:
            palavras.append(linha)
    finally:
        a.close()
        return palavras[:]


def escreverArquivo(arq, nome='<desconhecido>', idade=0):
    try:
        a = open(arq, 'at')
    except:
        print('\033[31mOuve um probllema ao abri arquivo\033[m')
    else:
        try:
            a.write(f'{nome};{idade}\n')
        except:
            print('\033[31mOuve um probllema ao escrever dados no arquivo\033[m')
        else:
            print('\033[32mPessoa cadastrada com sucesso\033[m')
    finally:
        a.close()