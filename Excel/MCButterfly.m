function [P, CI] = MCButterfly(S0,r,T,sigma,NRepl,K1,K2,K3)
nuT = (r-0.5*sigma^2)*T;
siT = sigma*sqrt(T);
Veps = randn(NRepl,1);
Stocks = S0*exp(nuT + siT*Veps);
In1 = find((Stocks > K1) & (Stocks < K2));
In2 = find((Stocks >= K2) & (Stocks < K3));
Payoff = exp(-r*T)*[(Stocks(In1)-K1);  (K3-Stocks(In2)); ...
         zeros(NRepl - length(In1) - length(In2),1)];
[P, V, CI] = normfit(Payoff);
