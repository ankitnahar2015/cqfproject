% RungeScript.m
% define inline function
runge = inline('1./(1+25*x.^2)');
% use equispaced nodes
EquiNodes = -5:5;
peq = polyfit(EquiNodes,runge(EquiNodes),10);
x=-5:0.01:5;
figure
plot(x,runge(x));
hold on
plot(x,polyval(p10,x));
% use Chebyshev nodes
ChebNodes = 5*cos(pi*(11 - (1:11) + 0.5)/11);
pcheb = polyfit(ChebNodes,runge(ChebNodes),10);
figure
plot(x,runge(x));
hold on
plot(x,polyval(pcheb,x));
