# Importar a biblioteca math
import math

# Definir os valores de T0 e PK para cada planeta
T0_Noho = 83
PK_Noho = 102.168
T0_Eve = 121
PK_Eve = 565.4
T0_Duna = 152
PK_Duna = 173.55
T0_Dres = 213
PK_Dres = 478.8
T0_Jool = 245
PK_Jool = 4305.9
T0_Eeloo = 257
PK_Eeloo = 15639.7

# Definir uma função para calcular e imprimir as datas das janelas de transferência
def transfer_window(T0, PK, planet):
  # Criar uma lista vazia para armazenar as datas
  dates = []
  # Usar um loop for para calcular as datas das primeiras dez janelas de transferência
  for n in range(10):
    # Usar a fórmula T = T0 + n * PK
    T = T0 + n * PK
    # Converter T em anos e dias
    years = math.floor(T / 426)
    days = math.floor(T % 426)
    # Adicionar a data à lista
    dates.append(f"{years} anos e {days} dias")
  # Imprimir as datas da lista
  print(f"Datas das primeiras dez janelas de transferência para {planet}:")
  for i, date in enumerate(dates):
    print(f"{i}: {date}")

# Chamar a função para cada planeta
transfer_window(T0_Noho, PK_Noho, "Moho")
transfer_window(T0_Eve, PK_Eve, "Eve")
transfer_window(T0_Duna, PK_Duna, "Duna")
transfer_window(T0_Dres, PK_Dres, "Dres")
transfer_window(T0_Jool, PK_Jool, "Jool")
transfer_window(T0_Eeloo, PK_Eeloo, "Eeloo")