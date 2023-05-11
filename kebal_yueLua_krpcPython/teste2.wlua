local list = {"rabo", "pata", "orelha", "camelho", "leao"}


local a = list

a = {"bobo", "baka"}

for index, value in pairs(list) do
    print(value, index)
end