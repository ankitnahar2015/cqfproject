function [xout, yout] = samplefile(x,y)
% a simple m-file to do some pointless computations
% this comment is printed by issuing the help samplefile
% command
[m,n] = size(x);
[p,q] = size(y);
z = rand(10,m)*x*rand(n,10) + rand(10,p)*y*rand(q,10);
xout = sum(z);
yout = sin(z);