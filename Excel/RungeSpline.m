% RungeSpline.m
% define inline function
runge = inline('1./(1+25*x.^2)');
% use 11 equispaced nodes
EquiNodes11 = -5:5;
ppeq11 = spline(EquiNodes11,runge(EquiNodes11));
x=-5:0.01:5;
subplot(3,1,1)
plot(x,runge(x));
hold on
plot(x,ppval(ppeq11,x));
axis([-5 5 -0.15 1])
title('11 equispaced points');
% use 20 equispaced nodes
EquiNodes20 = linspace(-5,5,20);
ppeq20 = spline(EquiNodes20,runge(EquiNodes20));
subplot(3,1,2)
plot(x,runge(x));
hold on
plot(x,ppval(ppeq20,x));
axis([-5 5 -0.15 1])
title('20 equispaced points');
% use 21 equispaced nodes
EquiNodes21 = linspace(-5,5,21);
ppeq21 = spline(EquiNodes21,runge(EquiNodes21));
subplot(3,1,3)
plot(x,runge(x));
hold on
plot(x,ppval(ppeq21,x));
axis([-5 5 -0.15 1])
title('21 equispaced points');
