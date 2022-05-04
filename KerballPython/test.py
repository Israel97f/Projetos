from sqlite3 import connect
import lib.fases

lib.fases.IntConect()
lib.fases.Lauch(50000, True)
#lib.fases.teste()
lib.fases.Disconect()
