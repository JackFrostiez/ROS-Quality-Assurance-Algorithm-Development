debug = 1;
%% Introduce the path of V-REP APIs to matlab
if ismac
    addpath('/Applications/V-REP_PRO_EDU_V3_5_0_Mac/programming/remoteApiBindings/matlab/matlab');
    addpath('/Applications/V-REP_PRO_EDU_V3_5_0_Mac/programming/remoteApiBindings/lib');
    addpath('/Applications/V-REP_PRO_EDU_V3_5_0_Mac/programming/remoteApiBindings/lib/lib/Mac');
elseif ispc
    addpath('C:\Program Files\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\matlab\matlab');
    addpath('C:\Program Files\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\lib');
    addpath('C:\Program Files\V-REP3\V-REP_PRO_EDU\programming\remoteApiBindings\lib\lib\64Bit');
end

%% Begin the program  by connecting to V-REP using remote api and clientID
vrep = remApi('remoteApi'); % get the main programming object to work with V-REP
disp('Program started')

vrep.simxFinish(-1); % close any previous connection just in case

% connect to V-REP running on the local machine with IP (='127.0.0.1') on the port (=19999)
clientID = vrep.simxStart('127.0.0.1',19997,true,false,10000,5); 
if debug == 1
    disp(['Client ID: ',num2str(clientID)]);
end

%% Get handles for Cylinder or any objects 
[joint1ReturnCode, joint1Handler] = vrep.simxGetObjectHandle(clientID, 'UR3_joint1', vrep.simx_opmode_oneshot_wait);
[joint2ReturnCode, joint2Handler] = vrep.simxGetObjectHandle(clientID, 'UR3_joint2', vrep.simx_opmode_oneshot_wait);
[joint3ReturnCode, joint3Handler] = vrep.simxGetObjectHandle(clientID, 'UR3_joint3', vrep.simx_opmode_oneshot_wait);
[joint4ReturnCode, joint4Handler] = vrep.simxGetObjectHandle(clientID, 'UR3_joint4', vrep.simx_opmode_oneshot_wait);
[joint5ReturnCode, joint5Handler] = vrep.simxGetObjectHandle(clientID, 'UR3_joint5', vrep.simx_opmode_oneshot_wait);
[joint6ReturnCode, joint6Handler] = vrep.simxGetObjectHandle(clientID, 'UR3_joint6', vrep.simx_opmode_oneshot_wait);

if debug == 1
    disp(['UR3_joint1 Handle : ', num2str(joint1Handler)]);
    disp(['UR3_joint2 Handle : ', num2str(joint2Handler)]);
    disp(['UR3_joint3 Handle : ', num2str(joint3Handler)]);
    disp(['UR3_joint4 Handle : ', num2str(joint4Handler)]);
    disp(['UR3_joint5 Handle : ', num2str(joint5Handler)]);
    disp(['UR3_joint6 Handle : ', num2str(joint6Handler)]);
end

%% Execute the Movement
if clientID > -1
    
    for i = 1:length(theta1)
        vrep.simxSetJointPosition(clientID, joint1Handler, theta1(i), vrep.simx_opmode_oneshot);
        vrep.simxSetJointPosition(clientID, joint2Handler, theta2(i), vrep.simx_opmode_oneshot);
        vrep.simxSetJointPosition(clientID, joint3Handler, theta3(i), vrep.simx_opmode_oneshot);
        vrep.simxSetJointPosition(clientID, joint4Handler, theta4(i), vrep.simx_opmode_oneshot);
        vrep.simxSetJointPosition(clientID, joint5Handler, theta5(i), vrep.simx_opmode_oneshot);
        vrep.simxSetJointPosition(clientID, joint6Handler, theta6(i), vrep.simx_opmode_oneshot);
        pause(1/60);
    end
end

%% Close the connection with V-REP
vrep.simxFinish(clientID); % disconnect from the V-REP software
vrep.delete(); % call the destructor to delete vrep object!
