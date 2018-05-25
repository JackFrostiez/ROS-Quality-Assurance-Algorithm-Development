debug = 1;
t = 0:pi/25:6*pi;
% p0 = [0, -194, 694];
% p1 = [0, -180, 396];
% p2 = [100, -280, 450];

% [x1,y1,z1] = generatePath(p0,p1,t);
% [x2,y2,z2] = generatePath(p1,p2,t);

% x_pos = [x1, x2, fliplr(x2), fliplr(x1)];
% y_pos = [y1, y2, fliplr(y2), fliplr(y1)];
% z_pos = [z1, z2, fliplr(z2), fliplr(z1)];

x_pos = 100*cos(t)+150;
y_pos = 100*sin(t)-300;
z_pos = ones(length(x_pos),1) * 450;

IC = [pi/6,pi/6,pi/6,pi/6,pi/6,pi/6]';

theta1 = zeros(length(t),1);
theta2 = theta1;
theta3 = theta1;
theta4 = theta1;
theta5 = theta1;
theta6 = theta1;

%% FK
% DH Parameters
syms th1 th2 th3 th4 th5 th6 x y z
theta = [th1 th2+pi/2 th3 th4+pi/2 th5 th6]; 
a = [0 244 213 0 0 0]; 
alpha = [pi/2 0 0 pi/2 -pi/2 0]; 
d = [152 120 -93 83 83 82]; 

% Calculate for the DH Matrix
H = eye(4);
for i = 1:length(theta)
    H = H*[cos(theta(i)) -sin(theta(i))*cos(alpha(i))  sin(theta(i))*sin(alpha(i)) a(i)*cos(theta(i));
           sin(theta(i))  cos(theta(i))*cos(alpha(i)) -cos(theta(i))*sin(alpha(i)) a(i)*sin(theta(i));
           0              sin(alpha(i))                cos(alpha(i))               d(i);
           0              0                            0                           1];
end

% Get the Last Column
translation = simplify(H(:,end));
rotation = simplify(H(1:end-1,1:end-1));
%% IK
% Get the Jacobian Matrix 
J = symfun([diff(translation(1),th1) diff(translation(1),th2) diff(translation(1),th3) diff(translation(1),th4) diff(translation(1),th5) diff(translation(1),th6)
     diff(translation(2),th1) diff(translation(2),th2) diff(translation(2),th3) diff(translation(2),th4) diff(translation(2),th5) diff(translation(2),th6)
     diff(translation(3),th1) diff(translation(3),th2) diff(translation(3),th3) diff(translation(3),th4) diff(translation(3),th5) diff(translation(3),th6)],[th1,th2,th3,th4,th5,th6]);
F = symfun([translation(1)-x; translation(2)-y; translation(3)-z],[th1,th2,th3,th4,th5,th6,x,y,z]);

% Run the IK Algorithm
disp('IK Algorithm Running');
j = 1;
for i = 1:length(x_pos)
    if debug == 1
        if mod(i,50)==0
            info = [num2str(round(i/length(x_pos) * 100)),'%%', ' Finished \n'];
            if j == 1
                fprintf(info);
            else
                for k = 1:l
                    fprintf('\b');
                end
                fprintf(info);
            end
            j = j + 1;
            l = length(info)-2;
        end
        if i == length(x_pos)
            for k = 1:l
                fprintf('\b');
            end
            fprintf('100%% Finished\n');
        end
    end
    while 1
        % Use Pseudo Inverse Function pinv()
        newIC = IC - pinv(vpa(J(IC(1),IC(2),IC(3),IC(4),IC(5),IC(6))))*vpa(F(IC(1),IC(2),IC(3),IC(4),IC(5),IC(6),x_pos(i),y_pos(i),z_pos(i)));
        if abs(norm(IC) - norm(newIC)) < 0.001
            break;
        else
            IC = newIC;
        end
    end
    theta1(i) = newIC(1);
    theta2(i) = newIC(2);
    theta3(i) = newIC(3);
    theta4(i) = newIC(4);
    theta5(i) = newIC(5);
    theta6(i) = newIC(6);

end




% daspect([1 1 1]);
% ax = gca;
% ax.Projection = 'perspective';
% xlabel('x');
% ylabel('y');
% zlabel('z');
% grid;
