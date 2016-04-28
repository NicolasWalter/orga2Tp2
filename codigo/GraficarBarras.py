import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys

# arr = np.genfromtxt("./data/ldrASM")
# x = [row[0] for row in arr]
# y = [row[1] for row in arr]

w=[1, 2, 3]
stN= np.genfromtxt("DesvioNegraLdr")
stL= np.genfromtxt("DesvioLenaLdr")
stB =np.genfromtxt("DesvioBlancaLdr")
#np.std(x)
standards =[np.std(stN), np.std(stL), np.std(stB)]


# y=np.genfromtxt("./data/LDRlena")
# z=np.genfromtxt("./data/LDRblanca")

# a= [x,y,z]
# r= [row[0] for row in z]
# y=[row[0] for row in r]
#x= [10040616.000, 10383474.000, 10604027.000]
x=[np.mean(stN), np.mean(stL), np.mean(stB)]

fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)

LABELS = ["Negra", "Lena", "Blanca"]
plt.bar(w[0], x[0], color='darkseagreen', yerr=standards[0], align= 'center', ecolor='k')
plt.bar(w[1], x[1], color='lightsteelblue', yerr=standards[1], align= 'center', ecolor='k')
plt.bar(w[2], x[2], color='darksalmon', yerr=standards[2], align= 'center', ecolor='k')

plt.xticks(w, LABELS)

ax1.set_title("LDR")    


# ax1.set_title(sys.argv[1])    
# #ax1.set_xlabel('Cantidad de pixeles de la imagen')
ax1.set_ylabel('Cantidad de ciclos de Clock')


# leg = ax1.legend()

# leg = plt.legend( loc = 'upper left')
plt.show()
