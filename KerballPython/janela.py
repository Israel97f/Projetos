from sqlite3 import connect
from tkinter import Frame, Tk, font, ttk, Text
from ttkbootstrap import Style
import lib.fases as fases
import lib.Mathe


connected = bool()
con = 'Conectar'

def atualiza_display(display):
    list = fases.get_telemetry()
    display.configure(state='normal', font=('Roboto', '10'))
    display.delete('1.0', 'end')
    display.insert(
        '1.0',
        f'{"Altitude:":<15}{list[2]:>20.2f}\n{"Altitude_S:":<15}{list[3]:>20.2f}\n{"Apoastro:":<15}{list[0]:>20.2f}\n{"Periastro:":<15}{list[1]:>20.2f}\n{"Velocidade:":<15}{list[4]:>20.2f}')
    display.configure(state='disabled')


def state_b():
    pass


def orbit(but):
    but.configure(state='disabled')
    lib.Mathe.Contador(10)
    fases.Lauch(1000, True)
    fases.Orbitador(80000)
    fases.Disconect()    
    print('Tudo ok')


def land(but):
    but.configure(state='normal')
    fases.Lauch(7000, True)
    fases.verticalLanding()
    fases.Disconect()
    print('ok')


def to_connect (but, display):
    global connected
    global con
    if connected == False:
        fases.IntConect()
        con = 'Deconectar'
        connected = True
    else:
        fases.Disconect()
        con = 'Conectar'
        connected = False

    but['text'] = con
    
    atualiza_display(display)
    print(fases.get_telemetry())
    

def main_frame(frame_atual=None):
    if frame_atual != None:
        frame_atual.destroy()

    frame = ttk.Frame()
    painel_frame = ttk.Frame(frame)
    display_frame  = ttk.Frame(frame)
    display = Text(display_frame, width=30, height=10, state='disabled')
    b1 = ttk.Button(painel_frame, text=con, width=15, command= lambda: to_connect(b1, display))
    b2 = ttk.Button(painel_frame, text='Orbitar', width=15, command= lambda: screen_1(frame))
    b3 = ttk.Button(painel_frame, text='Pousar', width=15, command= lambda: land())
    b1.grid(row=0, column=0, padx=10, pady=10)
    b2.grid(row=1, column=0, padx=10, pady=10)
    b3.grid(row=2, column=0, padx=10, pady=10)
    display.grid(row=0, column=1, padx=10, pady=10)
    painel_frame.grid(row=0, column=0)
    display_frame.grid(row=0, column=1)
    frame.pack()


def screen_1(frame_atual=None):
    if frame_atual != None:
        frame_atual.destroy()
        
    frame = ttk.Frame()
    painel_frame = ttk.Frame(frame)
    display_frame  = ttk.Frame(frame)
    display = Text(display_frame, width=30, height=10, state='disabled')
    b1 = ttk.Button(painel_frame, text='Lançar', width=15, command=lambda: orbit(b1))
    b2 = ttk.Button(painel_frame, text='voltar', width=15, command=lambda: main_frame(frame))
    #b3 = ttk.Button(painel_frame, text='B3', width=15, command=tela1)
    b1.grid(row=0, column=0, padx=10, pady=10)
    b2.grid(row=1, column=0, padx=10, pady=10)
    #b3.grid(row=2, column=0, padx=10, pady=10)
    display.grid(row=0, column=1, padx=10, pady=10)
    painel_frame.grid(row=0, column=0)
    display_frame.grid(row=0, column=1)
    frame.pack()



style = Style()
janela = style.master
janela.title('Hall')
main_frame()
janela.mainloop()
