from tkinter import Frame, Tk, font, ttk, Text
from ttkbootstrap import Style
from time import sleep

def função_1(display):
    
    i = 0
    lista = list()
    while i < 1500:
        
        i += 1
        lista.append(i)
        if len(lista) > 4:
            atualiza_display(display ,lista[:])
            lista.clear()
        #display.after(10,janela.update())
        sleep(0.01)
        janela.update()
        


def função_2(disp, fra):
    fra.after(10,função_1(disp))


def atualiza_display(display, lista):
    
    list = lista[:]
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
          
    
    cont = 0
    for c in list:        
        display.insert("",
            "end", values=(names[cont], c)
        )
        print(names[cont], c)
        cont +=1
 

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
    
    b1 = ttk.Button(painel_frame, text='conectar', width=15, command= lambda:função_1(display))
    b2 = ttk.Button(painel_frame, text='Orbitar', width=15, command= lambda: função_1(display))
    b3 = ttk.Button(painel_frame, text='Pousar', width=15, command= lambda: função_2(display,frame))
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
    display = ttk.Treeview(display_frame, columns=('nomes', 'valores'), show='tree',height=8)
    display.column('#0', minwidth=0,width=10)
    display.column('nomes', minwidth=0,width=100)
    display.column('valores', minwidth=0,width=100)  
    
    b1 = ttk.Button(painel_frame, text='Lançar', width=15, command=lambda: função_1(display))
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
    
