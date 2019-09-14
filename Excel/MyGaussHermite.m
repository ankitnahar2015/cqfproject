function [x,w] = MyGaussHermite(mu,sigma2,N)
HPoly = cell(N+1,1);
HPoly{1} = [ 1/pi^0.25 ];
HPoly{2} = [sqrt(2) / pi^0.25, 0];
for i=2:N
    HPoly{i+1} = [sqrt(2/(i)) * HPoly{i} , 0] - [0, 0, sqrt((i-1)/i)*HPoly{i-1}];
end
x1 = roots(HPoly{N+1});
w1 = zeros(N,1);
for i=1:N
    w1(i) = 1/(N)/(polyval(HPoly{N}, x1(i)))^2;
end
[x, index] = sort(x1*sqrt(2*sigma2)+mu);
w = w1(index)/sqrt(pi);
