% TryLU.m
N=2000;
A=rand(100,100);

tic
for i=1:1000
    b=rand(100,1);
    x=A\b;
end
toc

tic
[L,U,P] = lu(A);
for i=1:1000
    b=rand(100,1);
    x=U\(L\(P*b));
end
toc
