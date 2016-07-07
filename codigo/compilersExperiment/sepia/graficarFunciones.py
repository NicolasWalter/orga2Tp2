    # import matplotlib.pyplot as plt
# import numpy as np

# t = np.arange(0.0, 5.0, 0.01)
# s = np.sin(2*np.pi*t)


# def lineal(m,x1,x2,b):
#   for i in range(x1,x2):
#       y=m*i+b

#   return y
# a = np.arange(0.0, 5.0, 0.01)
# b = lineal(1,0,5,0)
# plt.plot(t, s)


# plt.plot(1,b)

# plt.xlabel('Las X amigo')
# plt.ylabel('Las Y amigo')
# plt.title('Grafican2')
# # plt.grid(True)
# plt.savefig("test.png")
# plt.show()



#def graphico(formula, x_range, formula2, x_range2):  
    # x = np.array(x_range)  
    # y = eval(formula)
    # w = np.array(x_range2)
    # z = eval(formula2)
    # a=5
    # hola.plot(3,a,'bo')
    # #plt.plot(x, y)  
    # a=30
    # plt.plot(2,2,'ro')
    # plt.plot(1,10,'go')
   # plt.show()
   # plt.plot(w, z)
# for i in range(1,10):
#       hola.plot(i,i,'go')
# plt.xlabel('Las X amigo')
# plt.ylabel('Las Y amigo')
# plt.title('Grafican2')
# plt.grid(True)
# plt.savefig("test.png")
# plt.show()


#graphico('2*x',range(0,5),'3*x',range(0,5))

#!/usr/bin/python



# with open("GG.txt") as f:
#     data = f.read()

# data = data.split('\n')

# x = [row.split(' ')[0] for row in data]
# y = [row.split(' ')[1] for row in data]

# fig = plt.figure()

# ax1 = fig.add_subplot(111)

# ax1.set_title("Plot title...")    
# ax1.set_xlabel('your x label..')
# ax1.set_ylabel('your y label...')

# ax1.plot(x,y, c='r', label='the data')

# leg = ax1.legend()

# plt.show()
import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys
from matplotlib2tikz import save as tikz_save



rojo="ICCxHostO3"
verde="GCCMarchNativeO3"
azul="GCCO0"
cyan="GCCMarchNativeO0"
negro="ICCO0"

arr = np.genfromtxt(rojo)
u = [row[0] for row in arr]
v = [row[1] for row in arr]


arr2 = np.genfromtxt(verde)
x = [row[0] for row in arr2]
y = [row[1] for row in arr2]


arr3 = np.genfromtxt(azul)
w = [row[0] for row in arr3]
z = [row[1] for row in arr3]


arr4 = np.genfromtxt(cyan)
a = [row[0] for row in arr4]
b = [row[1] for row in arr4]


arr5 = np.genfromtxt(negro)
c = [row[0] for row in arr5]
d = [row[1] for row in arr5]


fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)
pylab.plot(u,v,c='r', linewidth=2, label= rojo)
pylab.plot(x,y,c='g', linewidth=2, label= verde)
pylab.plot(w,z,c='b', linewidth=2, label = azul)
pylab.plot(a,b,c='cyan', linewidth=2, label = cyan)
pylab.plot(c,d,c='black', linewidth=2, label = negro)


# pylab.plot(w,z,c='b', label = 'O3')


#pylab.plot((a),(b), c='r', label ='f(X)=1024x')
# plt.errorbar(w, z, np.std(desvio))
ax1.set_title("SEPIA")    
ax1.set_xlabel('Cantidad de pixeles de la imagen')
ax1.set_ylabel('Cantidad de ciclos de Clock')
ax1.set_yscale('log', basey=2)
ax1.set_xscale('log', basex=2)

leg = ax1.legend()
leg = plt.legend( loc = 'upper left')

#ax1.plot(np.log2(x),np.log2(y), c='r', label='EL CHACHO ARRIBAS')
# pylab.plot((x),(y), c='r', label='ASM')
# pylab.plot(w,z, c='b',label='C')

tikz_save('sepiaFULL.tex')
plt.show()