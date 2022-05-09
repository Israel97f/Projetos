lista1 = (1,2,3,4,5,6)
lista2 = ('a','b','c','d','e', 'f')

cont = 0
for v in lista1:
   
    print (lista2[cont],v)
    cont += 1



def função_1():
    print('função 1 hey')

def função_2(parametro=None):
    if parametro != None:
        parametro()


função_2(função_1)



for c in range(0, 15, +1):
    print('o1')