function [x,w] = MyGaussHermite(mu,sigma2,N)
HPoly1 = [1];
HPoly2 = [2 , 0];
for i=2:N
    HPoly3 = [2*HPoly2 , 0] - [0, 0, 2*(i-1)*HPoly1];
    HPoly1 = HPoly2;
    HPoly2 = HPoly3;
end
x = roots(HPoly3);
w = 0;