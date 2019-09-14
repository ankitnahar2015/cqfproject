% ButterflyScript
S0 = 60;
K1 = 55;
K2 = 60;
K3 = 65;
r = 0.1;
T = 5/12;
sigma = 0.4;
NRepl = 100000;
randn('seed',0);
ExactValue = blsprice(S0,K1,r,T,sigma) - 2*blsprice(S0,K2,r,T,sigma) + ...
    blsprice(S0,K3,r,T,sigma)
[P1, CI1] = MCButterfly(S0,r,T,sigma,NRepl,K1,K2,K3);
[P2, CI2] = MCAVButterfly(S0,r,T,sigma,NRepl/2,K1,K2,K3);
P1
Length1 = CI1(2) - CI1(1)
P2
Length2 = CI2(2) - CI2(1)
