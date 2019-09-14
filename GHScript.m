% GHScript.m
N = [5, 10, 15, 20];
mu = 4;
sigma2 = 4;
TrueValue = exp(mu+0.5*sigma2);
for i=1:length(N)
    [x,w] = GaussHermite(mu,sigma2,N(i));
    ApproxValue = dot(w,exp(x));
    fprintf(1,'N=%2d True=%g Approx=%g PercError=%g \n', N(i), TrueValue,...
        ApproxValue, abs(TrueValue-ApproxValue)/TrueValue);
end
