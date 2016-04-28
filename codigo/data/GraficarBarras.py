import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys

# arr = np.genfromtxt("./data/ldrASM")
# x = [row[0] for row in arr]
# y = [row[1] for row in arr]

w=[1, 2, 3]
x= np.genfromtxt(sys.argv[1])
# y=np.genfromtxt("./data/LDRlena")
# z=np.genfromtxt("./data/LDRblanca")

# a= [x,y,z]
# r= [row[0] for row in z]
# y=[row[0] for row in r]
#[10040616.000, 10383474.000, 10604027.000]

fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)

LABELS = ["Negra", "Lena", "Blanca"]

plt.bar(w, x, align='center')
plt.xticks(w, LABELS)

ax1.set_title(sys.argv[1])    
#ax1.set_xlabel('Cantidad de pixeles de la imagen')
ax1.set_ylabel('Cantidad de ciclos de Clock')


leg = ax1.legend()

leg = plt.legend( loc = 'upper left')

plt.show()
