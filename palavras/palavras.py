from os import pipe, replace
import random
import leitura

arq = 'palavras.txt'
lista_sorteada = ['a', 'b']

if (not leitura.arquivoExite(arq)):
    leitura.criarArquivo(arq)

lista_de_palavras = leitura.lerArquivo(arq)
while True:
    
    n = random.randint(0, 100)
    n = int ((n/100) * len(lista_de_palavras))
    if len(lista_sorteada) == len(lista_de_palavras):
        print('Não há mais palavras')
        break

    if lista_de_palavras[n - 1] in lista_sorteada:
        continue

    lista_sorteada.append(lista_de_palavras[n - 1])
        

    print(f'{" A palavra sortiada é ":=^40}')
    print(f'{lista_de_palavras[n - 1]:^40}'.upper())
    print('~~' * 20)

    while True:
        n = str(input('Quer continuar [S/N]:')).upper().strip()
        if n in "SN":
            break
        else:
            print('comando invalido por favor digite apenas S ou N')
    if n == 'N':
        break
