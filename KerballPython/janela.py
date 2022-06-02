from tkinter import Button, Frame, Tk, font, ttk, Text
from ttkbootstrap import Style
import lib.fases as fases
import lib.Mathe

con = 'Conectar'
def atualiza_display():
    global telemetry_channel
    list = fases.get_telemetry()
    names = ('apoastro:', 
    'periastro:', 
    'altitude:',
    'surface_altitude:',
    'Speed:',
    'vertical_speed:',
    'horizontal_speed:',
    'surface_gravity:')

    telemetry_channel.delete(*telemetry_channel.get_children())
          
    cont = 0
    for c in list:        
        telemetry_channel.insert("",
            "end", values=(names[cont], f'{c:>15.2f}')
        )

        cont +=1
    janela.update()


def update_wiget(wig, seletor):
    
    print(seletor.get())
    if seletor.get() == 'Personalizada':
        wig.configure(state='normal')
    else:
        wig.configure(state='disabled')
    janela.update()
    

def orbit(apo, type_orbt, dir, frame):
    types = (('Equatorial', 'Polar', 'Rev Equatorial','Rev Polar', 'Personalizada'),
    ("Equatorial", "Polar", "Rev_Equarorial","Rev_Polar", 'Personalizada'))
    index = int()
    screen_1(frame)
    for i in types[0]:
        if type_orbt == i:
            index = types[0].index(i)

    fases.get_parametro(atualiza_display)
    but2.configure(state='disabled')
    lib.Mathe.Contador(10)
    fases.Lauch(1000, True)
    fases.Orbitador(apo, types[1][index], dir)   
    to_disconect()
    but2.configure(state='normal')
    screen_1(frame)


def land(frame):
    fases.get_parametro(atualiza_display)
    but3.configure(state='disabled')
    fases.verticalLanding()
    to_disconect()
    but3.configure(state='normal')
    screen_1(frame)


def launch(val, frame):
    screen_1(frame)
    fases.get_parametro(atualiza_display)
    but3.configure(state='disabled')
    fases.Lauch(val, True)
    to_disconect()
    but3.configure(state='normal')
    screen_1(frame)


def to_connect (frame):
    global con
    if fases.con_state() == False:
        fases.IntConect()
        if fases.con_state() == True:
            con = 'Deconectar'
        else:
            con = 'Conectar'
            
        screen_1(frame)
    else:
        fases.Disconect()
        con = 'Conectar'
        screen_1(frame)


def to_disconect():
    con = 'Conectar'
    fases.Disconect()
    but3.configure(text=con)
    janela.update()
    

def main_frame(frame_atual=None):
    if frame_atual != None:
        frame_atual.destroy()
        
    frame = ttk.Frame()
    
    display_frame  = ttk.Frame(frame)
    display = ttk.Treeview(display_frame, columns=('nomes', 'valores'), show='tree',height=8)
    display.column('#0', minwidth=0,width=10)
    display.column('nomes', minwidth=0,width=100)
    display.column('valores', minwidth=0,width=100) 
    display.grid(row=0, column=1, padx=10, pady=10)

    painel_frame = ttk.Frame(frame)
    b1 = ttk.Button(painel_frame, text='Conectar', width=15, command= lambda: to_connect(frame))
    b1.grid(row=0, column=0, padx=10, pady=10)

    painel_frame.grid(row=0, column=0)
    display_frame.grid(row=0, column=1) 
    frame.pack()


def screen_1(frame_atual=None):
    global con
    global telemetry_channel
    global but1
    global but2
    global but3
    global but4
    if frame_atual != None:
        frame_atual.destroy()   
    
    frame = ttk.Frame()
    
    display_frame  = ttk.Frame(frame)
    display = ttk.Treeview(display_frame, columns=('nomes', 'valores'), show='tree',height=8)
    telemetry_channel = display
    display.column('#0', minwidth=0,width=10)
    display.column('nomes', minwidth=0,width=100)
    display.column('valores', minwidth=0,width=100)  
    display.grid(row=0, column=0, padx=10, pady=10)

    painel_frame = ttk.Frame(frame)
    but1 = ttk.Button(painel_frame, text='Lançar', width=15, command=lambda: screen_3(frame))
    but2 = ttk.Button(painel_frame, text='Orbitar', width=15, command=lambda: screen_2(frame))
    but3 = ttk.Button(painel_frame, text='Pousar', width=15, command= lambda: land(frame))
    but4 = ttk.Button(painel_frame, text=con, width=15, command=lambda: to_connect (frame))
    but1.grid(row=0, column=0, padx=10, pady=5)
    but2.grid(row=1, column=0, padx=10, pady=5)
    but3.grid(row=2, column=0, padx=10, pady=5)
    but4.grid(row=3, column=0, padx=10, pady=5)
    
    painel_frame.grid(row=0, column=0)
    display_frame.grid(row=0, column=1)
    
    frame.pack()
    #frame.tkraise()


def screen_2(frame_atual=None):
    if frame_atual != None:
        frame_atual.destroy()   
        
    frame = ttk.Frame()
    
    display_frame  = ttk.Frame(frame)
    entrada_frame = ttk.Frame(display_frame)
    spbox = ttk.Spinbox(entrada_frame, from_=70000, to=200000, increment=100)
    spbox2 = ttk.Spinbox(entrada_frame, from_=0, to=359, increment=1, state="disable", text='oi')
    combox = ttk.Combobox(entrada_frame, values=('Equatorial', 'Polar', 'Rev Equatorial','Rev Polar', 'Personalizada'))
    spbox.set('80000')
    spbox2.set('90')
    combox.set('Equatorial')
    combox.bind("<<ComboboxSelected>>", lambda _: update_wiget(spbox2, combox))
    labeltext = ttk.Label(entrada_frame, text='apoastro em m')
    labeltext2 = ttk.Label(entrada_frame, text='tipo de orbita')
    spbox.grid(row=1, column=0, padx=10, pady=2)
    spbox2.grid(row=4, column=0, padx=10, pady=2)
    combox.grid(row=3, column=0, padx=10, pady=2)
    labeltext.grid(row=0, column=0, padx=10, pady=2)  
    labeltext2.grid(row=2, column=0, padx=10, pady=2)  

    entrada_frame.grid(row=0, column=0, padx=10, pady=8)

    painel_frame = ttk.Frame(frame)
    b1 = ttk.Button(painel_frame, text='tudo pronto', width=15, command=lambda: orbit(int(spbox.get()), combox.get(), int(spbox2.get()), frame))
    b2 = ttk.Button(painel_frame, text='volta', width=15, command=lambda: screen_1(frame))
    b1.grid(row=0, column=0, padx=10, pady=10)
    b2.grid(row=1, column=0, padx=10, pady=10)
    
    painel_frame.grid(row=0, column=0)
    display_frame.grid(row=0, column=1)
    frame.pack()
    #frame.tkraise()


def screen_3(frame_atual=None):
    if frame_atual != None:
        frame_atual.destroy()   
        
    frame = ttk.Frame()

    display_frame  = ttk.Frame(frame)
    entrada_frame = ttk.Frame(display_frame)
    spbox = ttk.Spinbox(entrada_frame, from_=1000, to=200000, increment=100)
    spbox.set('8000')
    labeltext = ttk.Label(entrada_frame, text='apoastro em m')
    spbox.grid(row=1, column=0, padx=10, pady=2)
    labeltext.grid(row=0, column=0, padx=10, pady=2)  

    display = ttk.Treeview(display_frame, columns=('nomes', 'valores'), show='tree',height=4)
    display.column('#0', minwidth=0,width=10)
    display.column('nomes', minwidth=0,width=100)
    display.column('valores', minwidth=0,width=100)
    entrada_frame.grid(row=0, column=0, padx=10, pady=8)
    display.grid(row=1, column=0, padx=10, pady=10)

    painel_frame = ttk.Frame(frame)
    b1 = ttk.Button(painel_frame, text='tudo pronto', width=15, command=lambda: launch(b1,  display, int(spbox.get()), frame))
    b2 = ttk.Button(painel_frame, text='volta', width=15, command=lambda: screen_1(frame))
    b1.grid(row=0, column=0, padx=10, pady=10)
    b2.grid(row=1, column=0, padx=10, pady=10)
    
    painel_frame.grid(row=0, column=0)
    display_frame.grid(row=0, column=1)
    frame.pack()


style = Style()
janela = style.master
janela.geometry('370x184')
janela.title('Hall')
main_frame()

janela.mainloop()
