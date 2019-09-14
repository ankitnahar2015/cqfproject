% Ripley2.m
m = 2048;
a = 65;
c = 1;
seed = 0;
U = LCG(a,c,m,seed,m);
X=sqrt(-2*log(U(1:m-2))).* cos(2*pi*U(2:m-1));
Y=sqrt(-2*log(U(1:m-2))).* sin(2*pi*U(2:m-1));
plot(X,Y,'.');
axis([-1.5 1.5 -1.5 1.5])

m = 2048;
a = 1229;
c = 1;
seed = 0;
U = LCG(a,c,m,seed,m);
X=sqrt(-2*log(U(1:m-2))).* cos(2*pi*U(2:m-1));
Y=sqrt(-2*log(U(1:m-2))).* sin(2*pi*U(2:m-1));
figure
plot(X,Y,'.');

X=sqrt(-2*log(U(2:m-1))).* cos(2*pi*U(1:m-2));
Y=sqrt(-2*log(U(2:m-1))).* sin(2*pi*U(1:m-2));
figure
plot(X,Y,'.');


