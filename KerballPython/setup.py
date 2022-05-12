from sys import platform
from cx_Freeze import setup, Executable 
import lib.fases as fases
import lib.Mathe
import lib.fases.krpcLib
from time import sleep


base=None
if platform == 'win32':
    base = 'win32GUI'

build_exe_options = {"packages": ["os","tkinter", "ttkbootstrap", "time", "lib.fases", "lib.Mathe", "lib.fases.krpcLib"] }

setup(
    name='Hall',
    version='0.8.3',
    description='Hall sistema de controle automático',
    options={'build_exe': build_exe_options},
    executables = [
        Executable('test.py', base=base)
    ]
)
