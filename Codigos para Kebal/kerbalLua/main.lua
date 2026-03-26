local krpc = require "krpc"


local tryed, chamada = pcall(krpc.connect, "Example")

print(tryed, chamada)
if tryed then
    local conn = chamada
    local vessel = conn.space_center.active_vessel
    vessel.control:activate_next_stage()
else
    print("falhou!")
end
