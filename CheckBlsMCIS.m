% CheckBlsMCIS.m
S0 = 50;
K = 80;
r = 0.05;
sigma = 0.4;
T = 5/12;
NRepl = 100000;
MCError = zeros(NRepl,1);
MCISError = zeros(NRepl,1);
TruePrice = blsprice(S0,K,r,sigma,T);
randn('state',0);
for k=1:100
    MCPrice = BlsMC2(S0,K,r,sigma,T,NRepl);
    MCError = abs(MCPrice - TruePrice)/TruePrice;
end
randn('state',0);
for k=1:100
    MCISPrice = BlsMCIS(S0,K,r,sigma,T,NRepl);
    MCISError = abs(MCISPrice - TruePrice)/TruePrice;
end
fprintf(1,'Average Percentage Error:\n');
fprintf(1,' MC    = %6.3f%%\n', 100*mean(MCError));
fprintf(1,' MC+IS = %6.3f%%\n', 100*mean(MCISError));
