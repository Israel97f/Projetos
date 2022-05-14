tuple_ = ((1, 3, 4, 8, 6 , 9), (2, 3, 8, 8, 9 , 4))

for c in range(0, len(tuple_)):
    for i in range(0, len(tuple_[0])):
        print(f'{tuple_[c][i]})' , end=' ')
    print(f'{""}', end=' ')
