function [p,ci] = ExchangeMC(V0,U0,sigmaV,sigmaU,rho,T,r,NRepl)
eps1 = randn(1,NRepl);
eps2 = rho*eps1 + sqrt(1-rho^2)*randn(1,NRepl);
VT = V0*exp((r - 0.5*sigmaV^2)*T + sigmaV*sqrt(T)*eps1);
UT = U0*exp((r - 0.5*sigmaU^2)*T + sigmaU*sqrt(T)*eps2);
DiscPayoff = exp(-r*T)*max(VT-UT, 0);
[p,s,ci] = normfit(DiscPayoff);
