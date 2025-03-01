local lista = {'1', '2', '3',}

function mod (list)
    table.insert(list, '4')
end


mod(lista)

print(table.unpack(lista))