import numpy as np
##import matplotlib.pyplot as plt
import time

try:
    import vrep
except:
    print ('--------------------------------------------------------------')
    print ('"vrep.py" could not be imported. Copy the following files into')
    print ('the working directory:')
    print ('In Windows, all files in the directory (not the folder inside the directory): ')
    print ('C:\Program Files\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\python')
    print ('C:\Program Files\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\lib')
    print ('C:\Program Files\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\lib\lib\Windows\64Bit')
    print ('--------------------------------------------------------------')

def moveLinearlyToPosition(fromPosition, toPosition, stepSize):
    ## get the path
    t = np.array(np.linspace(0, np.pi, stepSize))
    x = (fromPosition[0]-toPosition[0])/2*np.cos(t)+(fromPosition[0]+toPosition[0])/2
    y = (fromPosition[1]-toPosition[1])/2*np.cos(t)+(fromPosition[1]+toPosition[1])/2
    z = (fromPosition[2]-toPosition[2])/2*np.cos(t)+(fromPosition[2]+toPosition[2])/2

    ## move to position
    for i in range(0,stepSize):
        vrep.simxSetObjectPosition(clientID, targetHandler, -1, [x[i],y[i],z[i]], vrep.simx_opmode_oneshot_wait)
        time.sleep(dt)
        
    ## return the last position
    return x[-1],y[-1],z[-1]

def gripperInteraction(objectHandler, parentHandler):
    ## to detach, parentHandler = -1
    vrep.simxSetObjectParent(clientID, objectHandler, parentHandler, True, vrep.simx_opmode_oneshot_wait)
    time.sleep(0.5)
    

print ('Program started')
vrep.simxFinish(-1) # just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19997,True,True,5000,5) # Connect to V-REP
print("Client ID")
print(clientID)

targetReturnCode, targetHandler = vrep.simxGetObjectHandle(clientID, 'Target', vrep.simx_opmode_oneshot_wait)
cupReturnCode, cupHandler = vrep.simxGetObjectHandle(clientID, 'Cup', vrep.simx_opmode_oneshot_wait)
gripperReturnCode, gripperHandler = vrep.simxGetObjectHandle(clientID, 'ROBOTIQ_85_attachPoint', vrep.simx_opmode_oneshot_wait)
secondTableReturnCode, secondTableHandler = vrep.simxGetObjectHandle(clientID, 'SecondTable', vrep.simx_opmode_oneshot_wait)

joint1RC, joint1Handler = vrep.simxGetObjectHandle(clientID, 'UR3_joint1', vrep.simx_opmode_oneshot_wait)
joint2RC, joint2Handler = vrep.simxGetObjectHandle(clientID, 'UR3_joint2', vrep.simx_opmode_oneshot_wait)
joint3RC, joint3Handler = vrep.simxGetObjectHandle(clientID, 'UR3_joint3', vrep.simx_opmode_oneshot_wait)
joint4RC, joint4Handler = vrep.simxGetObjectHandle(clientID, 'UR3_joint4', vrep.simx_opmode_oneshot_wait)
joint5RC, joint5Handler = vrep.simxGetObjectHandle(clientID, 'UR3_joint5', vrep.simx_opmode_oneshot_wait)
joint6RC, joint6Handler = vrep.simxGetObjectHandle(clientID, 'UR3_joint6', vrep.simx_opmode_oneshot_wait)

dt = 0.00001

if clientID > -1:

    initialJointAngle = [0,0,0,0,0,0]
    RC, initialJointAngle[0] = vrep.simxGetJointPosition(clientID, joint1Handler, vrep.simx_opmode_oneshot_wait)
    RC, initialJointAngle[1] = vrep.simxGetJointPosition(clientID, joint2Handler, vrep.simx_opmode_oneshot_wait)
    RC, initialJointAngle[2] = vrep.simxGetJointPosition(clientID, joint3Handler, vrep.simx_opmode_oneshot_wait)
    RC, initialJointAngle[3] = vrep.simxGetJointPosition(clientID, joint4Handler, vrep.simx_opmode_oneshot_wait)
    RC, initialJointAngle[4] = vrep.simxGetJointPosition(clientID, joint5Handler, vrep.simx_opmode_oneshot_wait)
    RC, initialJointAngle[5] = vrep.simxGetJointPosition(clientID, joint6Handler, vrep.simx_opmode_oneshot_wait)
    print("Initial Joint Angle: ")
    print(initialJointAngle)
    
    targetReturnCode, targetPosition = vrep.simxGetObjectPosition(clientID, targetHandler, -1, vrep.simx_opmode_oneshot_wait)
    targetPosition = np.array(targetPosition)
    
    cupReturnCode, cupPosition = vrep.simxGetObjectPosition(clientID, cupHandler, -1, vrep.simx_opmode_oneshot_wait)
    cupPosition = np.array(cupPosition)
    
    print("Cup Position:")
    print(cupPosition)
    
    secondTableReturnCode, secondTablePosition = vrep.simxGetObjectPosition(clientID, secondTableHandler, -1, vrep.simx_opmode_oneshot_wait)
    secondTablePosition = np.array(secondTablePosition)

    x,y,z = moveLinearlyToPosition(targetPosition, [targetPosition[0]-0.1,targetPosition[1],targetPosition[2]],100)
    print("Way point 1: ")
    print([x,y,z])
    
    x,y,z = moveLinearlyToPosition([x,y,z], [cupPosition[0]+0.1,cupPosition[1],cupPosition[2]], 100)
    print("Way point 2: ")
    print([x,y,z])

    x,y,z = moveLinearlyToPosition([x,y,z], cupPosition, 100)
    print("Way point 3: ")
    print([x,y,z])
    
    gripperInteraction(cupHandler, gripperHandler)

    x,y,z = moveLinearlyToPosition([x,y,z], [x,y,z+0.1], 100)
    print("Way point 4: ")
    print([x,y,z])

    x,y,z = moveLinearlyToPosition([x,y,z], [secondTablePosition[0],secondTablePosition[1],z], 100)
    print("Way point 5: ")
    print([x,y,z])

    x,y,z = moveLinearlyToPosition([x,y,z], [x,y,z-0.1], 100)
    print("Way point 6: ")
    print([x,y,z])

    gripperInteraction(cupHandler, -1)

    x,y,z = moveLinearlyToPosition([x,y,z], [x+0.1,y,z+0.1], 100)
    print("Way point 7: ")
    print([x,y,z])

    x,y,z = moveLinearlyToPosition([x,y,z], [cupPosition[0]+0.1,cupPosition[1],z], 100)
    print("Way point 8: ")
    print([x,y,z])

    x,y,z = moveLinearlyToPosition([x,y,z], [x,y,z-0.1], 100)
    print("Way point 9: ")
    print([x,y,z])

vrep.simxFinish(clientID);




