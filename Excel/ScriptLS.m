% CheckLS.m
S0 = 50;
K = 50;
r = 0.05;
sigma = 0.4;
T = 1;
NSteps = 50;
NRepl = 10000;
randn('state',0)
fhandles = {@(x)ones(length(x),1), @(x)x, @(x)x.^2};
price = GenericLS(S0,K,r,T,sigma,NSteps,NRepl,fhandles)
[LatS, LatPrice]=binprice(S0,K,r,T,T/NSteps,sigma,0);
LatPrice(1,1)