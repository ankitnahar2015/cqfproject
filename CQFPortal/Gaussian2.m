function [X,Y]=Gaussian2
 %Function that generates two gaussian variable method 2

 U1=rand;
 U2=rand;
 X=sqrt(-2*log(U1))*cos(2*pi*U2);
 Y=sqrt(-2*log(U1))*sin(2*pi*U2);

 end