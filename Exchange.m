function p = Exchange(V0,U0,sigmaV,sigmaU,rho,T,r)
sigmahat = sqrt(sigmaU^2 + sigmaV^2 - 2*rho*sigmaU*sigmaV);
d1 = (log(V0/U0) + 0.5*T*sigmahat^2)/(sigmahat*sqrt(T));
d2 = d1 - sigmahat*sqrt(T);
p = V0*normcdf(d1) - U0*normcdf(d2);