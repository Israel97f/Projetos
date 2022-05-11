from sys import platform
from cx_Freeze import setup, Executable 

base=None
if platform == 'win32':
    base = 'win32GUI'

setup(
    name='Hall',
    version='0.8.3',
    description='Hall sistema de controle automático',
    options={'build_exe':{'includes': ['tkinter', 'ttkbootstrap', 'lib.fases', 'lib.Mathe' ]}},
    executables = [
        Executable('janela.py', base=base)
    ]
)