--[[
    Esse código imprime todos as fomas de organizar os elementos de um array

]]
-- Function to print all distinct combinations of length `k`
function FindCombinations (A, k, subarrays, out, i)
    i = i or 0
    out = out or {}
    -- invalid input
    if #A == 0 or k > #A then
        return
    end

    -- base case: combination size is `k`
    if k == 0 then
        table.insert(subarrays, out)
        return
    end

    -- start from the next index till the last index
    for j = i + 1, #A do
        -- add current element `A[j]` to the solution and recur for next index
        -- `j+1` with one less element `k-1`
        local conc = ConcatTable(out, {A[j]})
        FindCombinations(A, k - 1, subarrays, conc, j )
    end
end

-- concatena duas ou mais tabelas
function ConcatTable (...)
    local tables = {...}
    local out = {}
    for _, v in ipairs(tables) do
        for __, u in ipairs(v) do
            table.insert(out, u)
        end
    end
    return out
end

-- recebe uma tabela e retorna as variacões da tabela recebida 
function Variants (table_, subtable)
    subtable = subtable or {}
    local out = {}

    if #table_ <= 0 then
        table.insert(out, subtable)
        return out
    end

    for i = 1, #table_ do
        local rest = {table.unpack(table_)}
        if #rest >= i then
            table.remove(rest, i)
        end

        out = ConcatTable(out, Variants(rest, ConcatTable(subtable, {table_[i]})))

    end
    return out
end

-- gera uma tabela com todas as organizções posiveis apartir de um gruppo de elementos
function Permutations (table)
    local out = {}
    local subarrays = {}
    for i = 1, #table do
        FindCombinations(table, i, subarrays)
    end
    for _, v in ipairs(subarrays) do
        out = ConcatTable(out, Variants(v))
    end
    return out
end

A = {"a", "b", "c", "d"}--, "e", "f", "g"}

-- imprime o retorno da função Permutations
for index, value in ipairs(Permutations(A)) do
    print(table.unpack(value))
end
