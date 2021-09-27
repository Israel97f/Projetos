from lib import utilis
from lib import arquivo
from time import sleep
import os


#Programa principal
numeros = [2, 9, 12, 19, 21
        , 29, 31, 36, 42, 49
        , 55, 56, 61, 70, 72]
arq = 'banco de cores'

if not arquivo.arqExiste(arq):
        arquivo.criArquivo(arq)


cor = arquivo.readArquivo(arq)
tem = list()
if len(cor) != len(numeros):
        for i in range(0, len(numeros)):
                cor.append(0)


while True:
        os.system('cls')
        utilis.cabeç('Cartela')
        utilis.exibirCartela(numeros, cor)
        utilis.cabeç('Sair - 999    Limpar - 998    desmarcar número - "- número"')
        num = utilis.readInt('Marcar numero: ')
        if num == 999:
                arquivo.writeAquivo(arq, cor)
                break
        elif num == 998:
                tem = utilis.clearCartela(cor)
        else:
                tem = utilis.maarcar(numeros, cor, num)
        cor.clear()
        cor = tem[:]
        sleep(0.5)
print(cor)
