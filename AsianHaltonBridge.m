function P = AsianHaltonBridge(S0,K,r,T,sigma,NSamples,NRepl,Limit)
Payoff = zeros(NRepl,1);
Path=GBMHaltonBridge(S0,r,sigma,T,NSamples,NRepl,Limit);
Payoff = max(0, mean(Path(:,2:(NSamples+1)),2) - K);
P = mean( exp(-r*T) * Payoff);