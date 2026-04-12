
local function sleep(n)
  if n > 0 then os.execute("ping -n " .. tonumber(n+1) .. " localhost > NUL") end
end

local function itera()
    local i = 0
    return function ()
        i = i + 1
        return i
    end
end

local contador = itera()

while true do
    local n = contador()
    print(string.format("Hello world %i", n))
    --sleep(0.1)  -- atraza mas não de forma precisa

    if n > 500 then
        break
    end
end
