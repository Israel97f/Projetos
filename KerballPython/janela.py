from tkinter import Tk, ttk, Text
from ttkbootstrap import Style

def atualiza_display():
    display.configure(state='normal')
    display.delete('1.0', 'end')
    display.insert(
        '1.0',
        f'Atitude: {10:>35} \nAltitude da Superficie: {10:>10} \nApoastro:\nPeriastro:')
    display.configure(state='disabled')

style = Style()
janela = style.master
janela.title('Hall')
main_frame = ttk.Frame()
painel_frame = ttk.Frame(main_frame)
display_frame  = ttk.Frame(main_frame)
b1 = ttk.Button(painel_frame, text='B1', width=15, command=atualiza_display)
b2 = ttk.Button(painel_frame, text='B2', width=15)
b3 = ttk.Button(painel_frame, text='B3', width=15)
display = Text(display_frame, width=30, height=10, state='disabled')
b1.grid(row=0, column=0, padx=10, pady=10)
b2.grid(row=1, column=0, padx=10, pady=10)
b3.grid(row=2, column=0, padx=10, pady=10)
display.grid(row=0, column=1, padx=10, pady=10)
painel_frame.grid(row=0, column=0)
display_frame.grid(row=0, column=1)
main_frame.pack()
janela.mainloop()
