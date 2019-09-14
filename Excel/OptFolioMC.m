function share = OptFolioMC(W0,S0,mu,sigma,r,T,NScen,utilf)
muT = (mu - 0.5*sigma^2)*T;
sigmaT = sigma*sqrt(T);
R = exp(r*T);
NormSamples = muT + sigmaT*randn(NScen,1);
ExcessRets = exp(NormSamples) - R;
MExpectedUtility = @(x) -mean(utilf(W0*((x*ExcessRets) + R)));
share = fminbnd(MExpectedUtility, 0, 1);