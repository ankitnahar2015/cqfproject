% CompareAsian3.m
randn('state',0)
S0 = 50;
K = 55;
r = 0.05;
sigma = 0.4;
T = 3;
NSamples = 32;
NRepl = 500000;
[P1,CI1] = AsianMC(S0,K,r,T,sigma,NSamples,NRepl)
NRepl = 30000;
PH = AsianHalton(S0,K,r,T,sigma,NSamples,NRepl)
PHB = AsianHaltonBridge(S0,K,r,T,sigma,NSamples,NRepl)