% Ripley 1
m = 2048;
a = 65;
c = 1;

X0 = 0;
U = zeros(m,1);
for k=1:2048
    X1 = mod(a*X0+c,m);
    U(k) = X1/m;
    X0 = X1;
end
plot(U(1:m-1), U(2:m), '.');

figure
plot(U(1:511), U(2:512), '.');

a=1365;
c=1;
U = zeros(m,1);
for k=1:2048
    X1 = mod(a*X0+c,m);
    U(k) = X1/m;
    X0 = X1;
end
figure
plot(U(1:m-1), U(2:m), '.');

