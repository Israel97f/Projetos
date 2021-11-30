from os import pipe, replace
import random
import leitura

arq = 'palavras.txt'
n = random.randint(0, 100)
nun = n
if (not leitura.arquivoExite(arq)):
    leitura.criarArquivo(arq)
lista_de_palavras = leitura.lerArquivo(arq)
n = int ((n/100) * len(lista_de_palavras))

print(f'{" A palavra sortiada é":^40}')
print(f'{n}----{nun}----{len(lista_de_palavras)}')
print(lista_de_palavras[n - 1])
print('~~' * 20)
