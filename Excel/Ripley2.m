% Ripley2.m
m = 2048;
a = 1229;
c = 1;
N = m-2;
seed = 0;
U = LCG(a,c,m,seed,N);
U1 = U(1:2:N-1);
U2 = U(2:2:N);
X=sqrt(-2*log(U1)).* cos(2*pi*U2);
Y=sqrt(-2*log(U1)).* sin(2*pi*U2);
figure
subplot(2,1,1)
plot(X,Y,'.');

X=sqrt(-2*log(U2)).* cos(2*pi*U1);
Y=sqrt(-2*log(U2)).* sin(2*pi*U1);
subplot(2,1,2)
plot(X,Y,'.');


