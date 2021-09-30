import Krpc
import lib.fases

# Inicinado a conexão
conn = krpc.conect()
vessel = conn.space_center.active_vessel
flight_info = vessel.flight()

