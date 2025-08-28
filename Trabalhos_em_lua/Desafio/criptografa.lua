local texto  = "mamaco"

local function criptografar (str)
    local cripto = ''
    for i in string.gmatch(str, '%a') do
        cripto = cripto .. tostring(string.byte(i) - 96) .. '-'
    end
    return cripto
end

local key = criptografar(texto)
print(key)