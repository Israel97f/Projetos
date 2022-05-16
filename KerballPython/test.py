altitude = float()

for i in range(6000, 9000):
    altitude = i
    frac = (- ((altitude /45000)** 2) + (2 * altitude /45000))
    print(f'{90 -(90*frac):.2f}', end="|")
    if i % 19 == 0 and i != 0:
        print(" ")
