function p = FK_UR3(q)
    theta = [q(1)-pi/2 q(2)+pi/2 q(3) q(4)+pi/2 q(5)+pi q(6)];
    a = [0 244 213 0 0 0];
    alpha = [pi/2 pi pi pi/2 pi/2 0];
    d = [152 120 93 83 83 82];  
    
    H = eye(4);
    for i = 1:length(q)
        H = H*[cos(theta(i)) -sin(theta(i))*cos(alpha(i))  sin(theta(i))*sin(alpha(i)) a(i)*cos(theta(i));
               sin(theta(i))  cos(theta(i))*cos(alpha(i)) -cos(theta(i))*sin(alpha(i)) a(i)*sin(theta(i));
               0              sin(alpha(i))                cos(alpha(i))               d(i);
               0              0                            0                           1];
    end
    
    temp = H*[0 0 0 1]';
    p = temp(1:3);
    
    
    
    
    
    
    