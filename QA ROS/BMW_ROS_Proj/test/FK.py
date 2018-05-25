import numpy as np
np.set_printoptions(formatter={'float': lambda x: "{0:6.3f}".format(x)})

def FK_UR3(q):
    theta = np.array([q[0], q[1]+np.pi/2, q[2], q[3]+np.pi/2, q[4], q[5]])
    a = np.array([0, 244, 213, 0, 0, 0])
    alpha = np.array([np.pi/2, 0, 0, np.pi/2, -np.pi/2, 0])
    d = np.array([152, 120, -93, 83, 83, 82]);
    
    H = np.identity(4)
    for i in range(0,np.size(q)):
        H = H.dot([[np.cos(theta[i]), -np.sin(theta[i])*np.cos(alpha[i]), np.sin(theta[i])*np.sin(alpha[i]), a[i]*np.cos(theta[i])], [np.sin(theta[i]), np.cos(theta[i])*np.cos(alpha[i]), -np.cos(theta[i])*np.sin(alpha[i]), a[i]*np.sin(theta[i])], [0, np.sin(alpha[i]), np.cos(alpha[i]), d[i]], [0, 0, 0, 1]])
    
    temp = H.dot(np.array([[0, 0, 0, 1]]).T)
    p = temp[0:3]
    return p

q = np.array([0,np.pi/2,0,0,0,0])
print(FK_UR3(q))
