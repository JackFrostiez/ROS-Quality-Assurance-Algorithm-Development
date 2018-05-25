import numpy as np
import matplotlib.pyplot as plt

def generatePath(p1, p2, t):
    x = (p1[0]-p2[0])/2*np.cos(t)+(p1[0]+p2[0])/2
    y = (p1[1]-p2[1])/2*np.cos(t)+(p1[1]+p2[1])/2
    return x,y

x,y = generatePath(p1 = [0,0],p2 = [1,2],t = np.arange(start = 0, stop = 4*3.1415926, step = 0.01))
plt.plot(x,y)
plt.show()
