# no seu código principal
import multiprocessing # importa o módulo multiprocessing
import run_script # importa o módulo run_script

if __name__ == '__main__':
    p = multiprocessing.Process(target=run_script.run_script, args=("teste.py",)) # cria um processo filho que executa a função run_script com o argumento teste.py
    p.start() # inicia o processo filho
    print("ok")
    # faz outras coisas enquanto o processo filho está rodando
    #p.join() # espera o processo filho terminar