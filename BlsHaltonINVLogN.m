function Price = BlsHaltonINVLogN(S0,K,r,T,sigma,NPoints,Base)
nuT = (r - 0.5*sigma^2)*T;
siT = sigma * sqrt(T);
% Use inverse transform to generate standard normals
H = GetHalton(NPoints,Base);
VepsLogN = logninv(H,nuT,siT);
%
DiscPayoff = exp(-r*T)*max(0,S0*VepsLogN-K);
Price = mean(DiscPayoff);