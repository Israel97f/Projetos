from time import sleep

def Contador (num):
    for i in range(num, 0, -1):
        print(f'{i}', end=' ', flush=True)
        sleep(1)
    print(f'\033[32mGol for Lauch\033[m')
