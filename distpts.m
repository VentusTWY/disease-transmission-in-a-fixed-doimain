function D =distpts(x1,y1,x2,y2)
%This function checks the distance between location of two individuals
%inputs:
%x1 - x position of the first individual
%y1 - y position of the first individual
%x2 - x position of the second individual
%y2 - y position of the second individual
%output:
%D - distance between the two individuals

diffx=x2-x1;
diffy=y2-y1;
D=sqrt(diffx^2+diffy^2);
end
