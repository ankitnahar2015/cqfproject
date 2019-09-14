function share = OptFolioGauss(W0,S0,mu,sigma,r,T,NScen,utilf)
muT = (mu - 0.5*sigma^2)*T;
sigmaT = sigma*sqrt(T);
R = exp(r*T);
[x,w] = GaussHermite(muT,sigmaT^2,NScen);
ExcessRets = exp(x) - R;
%ExcessRets = exp(normrnd(muT,sigmaT,NScen,1)) - R;
%w = 1/NScenl
onegamma = 1-gamma;
MExpectedUtility = @(x) -dot(w,  log(W0*((x*ExcessRets) + R)));
%MExpectedUtility = @(x) -mean( (W0*((x*ExcessRets) + R).^onegamma ));
values = 0:0.01:1;
N = length(values);
utils = zeros(N,1);
for i=1:N
    utils(i)=-MExpectedUtility(values(i));
end
plot(values,utils)
share = fminbnd(MExpectedUtility, 0, 1);