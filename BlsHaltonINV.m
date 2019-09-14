function Price = BlsHaltonINV(S0,X,r,T,sigma,NPoints,Base)
nuT = (r - 0.5*sigma^2)*T;
siT = sigma * sqrt(T);
% Use inverse transform to generate standard normals
H = GetHalton(NPoints,Base);
Veps = norminv(H);
%
DiscPayoff = exp(-r*T)*max(0,S0*exp(nuT+siT*Veps)-X);
Price = mean(DiscPayoff);