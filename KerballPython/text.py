import krpc
conn = krpc.connect()
vessel = conn.space_center.active_vessel
masss = 1
enpuxo = vessel.max_thrust

print(masss)
print(enpuxo)