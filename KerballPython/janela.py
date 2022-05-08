from tkinter import Frame, Tk, font, ttk, Text
from ttkbootstrap import Style
import lib.fases as fases
import lib.Mathe


connected = bool()
con = 'Conectar'

def atualiza_display(display):
    list = [0,1,3,4,5]#fases.get_telemetry()
    names = ('apoastro:', 
    'periastro:', 
    'altitude:',
    'surface_altitude:',
    'Speed:',
    'vertical_speed:',
    'horizontal_speed:',
    'surface_gravity:')

    treeSelect = (display.identify('item', 0, 20),
    display.identify('item', 0, 25),
    display.identify('item', 0, 45),
    display.identify('item', 0, 65),
    display.identify('item', 0, 85))
    for c in treeSelect:
        if c != '':
            display.delete(c)
          
    print(treeSelect)
    cont = 0
    for c in list:        
        display.insert("",
            "end", values=(names[cont], c)
        )
        cont +=1
    

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
        #fases.IntConect()
        con = 'Deconectar'
        connected = True
    else:
        #fases.Disconect()
        con = 'Conectar'
        connected = False

    but['text'] = con
    
    atualiza_display(display)
    #print(fases.get_telemetry())
    

def main_frame(frame_atual=None):
    if frame_atual != None:
        frame_atual.destroy()
        
    frame = ttk.Frame()
    painel_frame = ttk.Frame(frame)
    display_frame  = ttk.Frame(frame)
    display = ttk.Treeview(display_frame, columns=('nomes', 'valores'), show='tree',height=8)
    display.column('#0', minwidth=0,width=10)
    display.column('nomes', minwidth=0,width=100)
    display.column('valores', minwidth=0,width=100)  
    
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
    display = ttk.Treeview(display_frame,  width=35, height=10, state='disabled')
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
    #frame.tkraise()



style = Style()
janela = style.master
#janela.geometry('350x190')
janela.title('Hall')
main_frame()
janela.mainloop()
