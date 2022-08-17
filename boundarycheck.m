function [u2,v2]=boundarycheck(x,y,u,v,speed)
%This function calculates the distance between the points and the boundaries
%if the distance is less than 2, it returns a new u and v component to make
%sure the individuals is kept between the boundary
%if the distance is more than 2, the velocity component remains unchanged
%Inputs
%x - x position of the individual
%y - y position of the individual
%velo - velocity of the individual
%u - x-component of the velocity
%v - y-component of the velocity
%theta - angle of the velocity with respect to horizontal line
%Output
%u2 - new x component of velocity
%v2 - new y component of velocity

distance=[x,1000-x,y,1000-y];
[mindist,idx]=min(distance);
if mindist<=2
    switch idx
        case 1
            theta=randi([-89 89]);
        case 2
            theta=randi([91 269]);
        case 3 
            theta=randi([1 179]);
        case 4
            theta=randi([181 359]);
    end
    u2=speed*cosd(theta);
    v2=speed*sind(theta);
else
    u2=u;
    v2=v;
end