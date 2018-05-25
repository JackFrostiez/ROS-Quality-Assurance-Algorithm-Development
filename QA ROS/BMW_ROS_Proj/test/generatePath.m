function [x,y,z] = generatePath(p1,p2,t)
    x = (p1(1)-p2(1))/2*cos(t)+(p1(1)+p2(1))/2;
    y = (p1(2)-p2(2))/2*cos(t)+(p1(2)+p2(2))/2;
    z = (p1(3)-p2(3))/2*cos(t)+(p1(3)+p2(3))/2;
end