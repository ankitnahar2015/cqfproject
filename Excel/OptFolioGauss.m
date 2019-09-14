function share = OptFolioGauss(W0,S0,mu,sigma,r,T,NScen,utilf)
muT = (mu - 0.5*sigma^2)*T;
sigmaT = sigma*sqrt(T);
R = exp(r*T);
[x,w] = GaussHermite(muT,sigmaT^2,NScen);
ExcessRets = exp(x) - R;
MExpectedUtility = @(x) -dot(w,  utilf(W0*((x*ExcessRets) + R)));
share = fminbnd(MExpectedUtility, 0, 1);