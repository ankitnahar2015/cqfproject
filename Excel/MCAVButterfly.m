function [P, CI] = MCAVButterfly(S0,r,T,sigma,NPairs,K1,K2,K3)
nuT = (r-0.5*sigma^2)*T;
siT = sigma*sqrt(T);
Veps = randn(NPairs,1);
Stocks1 = S0*exp(nuT + siT*Veps);
Stocks2 = S0*exp(nuT - siT*Veps);
Payoff1 = zeros(NPairs,1);
Payoff2 = zeros(NPairs,1);
In = find((Stocks1 > K1) & (Stocks1 < K2));
Payoff1(In) = (Stocks1(In) - K1);
In = find((Stocks1 >= K2) & (Stocks1 < K3));
Payoff1(In) = (K3 - Stocks1(In));
In = find((Stocks2 > K1) & (Stocks2 < K2));
Payoff2(In) = (Stocks2(In) - K1);
In = find((Stocks2 >= K2) & (Stocks2 < K3));
Payoff2(In) = (K3 - Stocks2(In));
Payoff = 0.5 * exp(-r*T) * (Payoff1 + Payoff2);
[P, V, CI] = normfit(Payoff);