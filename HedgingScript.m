% HedgingScript.m
S0 = 50;
K = 52;
mu = 0.1;
sigma = 0.4;
r = 0.05;
T = 5/12;
NRepl =10000;
NSteps = 10;
C = blsprice(S0,K,r,T, sigma);
fprintf(1, '%s %f\n', 'true price = ', C);
%
randn('state',0);
Paths=AssetPaths(S0,mu,sigma,T,NSteps,NRepl);
SL = StopLossV(S0,K,mu,sigma,r,T,Paths);
fprintf(1, 'cost of stop/loss (S) = %f\n', SL);
DC = DeltaHedging(S0,K,mu,sigma,r,T,Paths);
fprintf(1, 'cost of delta-hedging = %f\n', DC);
%
NSteps = 100;
randn('state',0);
Paths=AssetPaths(S0,mu,sigma,T,NSteps,NRepl);
SL = StopLossV(S0,K,mu,sigma,r,T,Paths);
fprintf(1, 'cost of stop/loss (S) = %f\n', SL);
DC = DeltaHedging(S0,K,mu,sigma,r,T,Paths);
fprintf(1, 'cost of delta-hedging = %f\n', DC);

