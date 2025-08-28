local pessoa = {
    nome = "joão",
    idade = 34,
    aniv = function(self) self.idade = self.idade +  1 end
}


print(pessoa.idade)
pessoa:aniv()
print(pessoa.idade)