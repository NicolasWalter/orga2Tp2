import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys
from matplotlib2tikz import save as tikz_save

rojo="ICCxHostO3"
verde="GCCO2"
azul="GCCO0"
cyan="ICCO0"
#negro="SepiaICCxHostO3"

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


# arr5 = np.genfromtxt(negro)
# c = [row[0] for row in arrr]
# d = [row[1] for row in arrr]


fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)
pylab.plot(u,v,c='r', linewidth=2, label= rojo)
pylab.plot(x,y,c='g', linewidth=2, label= verde)
pylab.plot(w,z,c='b', linewidth=2, label = azul)
#pylab.plot(a,b,c='cyan', linewidth=2, label = cyan)
#pylab.plot(c,d,c='black', linewidth=2.0, label = negro)


# pylab.plot(w,z,c='b', label = 'O3')


#pylab.plot((a),(b), c='r', label ='f(X)=1024x')
# plt.errorbar(w, z, np.std(desvio))
ax1.set_title("LOW DYNAMIC RANGE")    
ax1.set_xlabel('Cantidad de pixeles de la imagen')
ax1.set_ylabel('Cantidad de ciclos de Clock')
ax1.set_yscale('log', basey=2)
ax1.set_xscale('log', basex=2)

leg = ax1.legend()
leg = plt.legend( loc = 'upper left')

tikz_save('ldrO0.tex')
plt.show()