--gerdor de graficos de disperçâo 
local DesvPadrao = require ("funcDeSuport")
local filleName = "dados.txt"

fille = io.open("dados.txt", "r")
Codigo = io.open("Cod.tex", "w")
--print(fille:lines())
if fille then
    print("sucesso ao abri o arquivo")
    Codigo:write([[
\\begin{frame}{Grafico de dispersão}
    \\centering
    \\begin{tikzpicture}
        \\begin{axis}[
            xlabel=tempo ($s$),
            ylabel=posição ($m$),
            legend style={
            at={(0.05,0.95)},
            anchor=north west,
            font=\tiny,
            draw=none,
            fill=none
            }
        ]
            \\addplot[
                only marks,
                mark=diamond,
                mark size=1pt,
                error bars/.cd,
                y dir=both, y explicit, 
                error bar style={line width=1pt, red}
            ] coordinates{
            ]])
local coord = ""
local desv = DesvPadrao(fille)
fille:seek('set') -- move o cursor para o
for i in fille:lines() do
    coord = string.format([[
                ( %s ) +- (0, %s)]] .. '\n', i, desv)
    Codigo:write(coord)
end
Codigo:write([[
            };

            \\addplot[mark=none, domain={0:4}]{8.584*x^2 - 0.1956*x + 0.2478};
            \\addlegendentry{$y = 8.58x^2 - 0.20x + 0.25,\quad \chi^2=0.5134$} \% Equação e qui-quadrado no gráfico

        \\end{axis}
    \\end{tikzpicture}
\\end{frame}]])
--print(DesvPadrao(fille))
fille:close()
Codigo:close()
else
    print("falha ao abri o arquivo")
end
