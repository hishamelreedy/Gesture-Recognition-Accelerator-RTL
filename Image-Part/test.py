from fxpmath import Fxp

data = Fxp("0x000015C4",signed=True,n_word=32,n_frac=16)
data = data + Fxp("0x000016BC",signed=True,n_word=32,n_frac=16)
data = data + Fxp("0x000012C0",signed=True,n_word=32,n_frac=16)

print(data.hex())
print(data)

data = Fxp("0x00d0",signed=True,n_word=16,n_frac=7)
data = data + Fxp("0x0146",signed=True,n_word=16,n_frac=7)
data = data + Fxp("0x00a5",signed=True,n_word=16,n_frac=7)
print(data.hex())