from fxpmath import Fxp
import numpy as np
from sympy import true
N=1
x = Fxp(-1.5,signed=True,n_frac=8,n_int=7)
y=x.hex()
# print(y)
x = Fxp('0xFE80',signed=True,n_frac=8,n_int=7)
# print(x)
my_file = open("sqnetparams/maxpool1/output/maxpoolopall.txt", "r")
content = my_file.readlines()
# print(len(content))
# print(content[len(content)-1])
x = Fxp('0x'+content[0],signed=True,n_frac=8,n_int=7)
x=np.zeros(shape=(64,55,55))
x=x.tolist()
for row in range(0,55,1):
    for column in range(0,55,1):
        for channel in range(0,64,1):
            x[channel][row][column]=Fxp('0x'+content[channel*55*55+row*55+column],signed=True,n_frac=8,n_int=7)
# print(len(x))
# print(x[0][0][0],x[0][0][0].hex())
print(x[1][0][0].hex())
my_file = open("sqnetparams/squeeze1/sq1wfall.txt", "r")
content = my_file.readlines()
sq1whts=np.zeros(shape=(16,64))
sq1whts=sq1whts.tolist()
for filter in range(0,16,1):
    for channel in range(0,64,1):
        sq1whts[filter][channel] = Fxp('0x'+content[filter*64+channel],signed=True,n_frac=8,n_int=7)
# print(sq1whts[0][0],sq1whts[0][0].hex())

my_file = open("sqnetparams/squeeze1/biases.txt", "r")
content = my_file.readlines()
sq1bias=np.zeros(shape=(16,))
sq1bias=sq1bias.tolist()
for filter in range(0,16,1):
    sq1bias[filter] = Fxp('0x'+content[filter],signed=True,n_frac=8,n_int=7)
# print(sq1bias[0],sq1bias[0].hex())

sq1out=np.zeros(shape=(16,N,N))
sq1out=sq1out.tolist()
sq1outr=[]
for filter in range(0,1,1):
    for row in range(0,N,1):
        for column in range(0,N,1):
            tmp = Fxp(sq1bias[filter],signed=True,n_frac=16,n_int=16)
            #tmp = Fxp(0,signed=True,n_frac=16,n_int=16)
            tmpf = sq1bias[filter]
            for channel in range(0,64,1):
                print("channel=",channel, Fxp(tmp,signed=True,n_frac=16,n_int=16).hex())
                mult=Fxp(x[channel][row][column],signed=True,n_frac=8,n_int=7) * Fxp(sq1whts[filter][channel],signed=True,n_frac=8,n_int=7)
                tmp = tmp+mult
                print("x=",Fxp(x[channel][row][column],signed=True,n_frac=8,n_int=7).hex())
                print("wht=",Fxp(sq1whts[filter][channel],signed=True,n_frac=8,n_int=7).hex())
                print("MultData=",mult.hex())
            print("Finalvalue=",Fxp(tmp,signed=True,n_frac=8,n_int=7).hex())   
            sq1out[filter][row][column] = Fxp(tmp,signed=True,n_frac=8,n_int=7)
            sq1outr.append(Fxp(tmp,signed=True,n_frac=8,n_int=7))


with open(r'out.txt', 'w') as fp:
    for item in sq1outr  :
        # write each item on a new line
        fp.write("%s\n" % item.hex())
    print('Done')
