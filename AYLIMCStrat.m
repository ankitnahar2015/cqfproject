function [Price, CI] = AYLIMCStrat(S0,K,r,T1,T2,sigma,NRepl,NStrata)
% Care needed if NRepl,NStrata are not coherent
NSamplesPerStratum = ceil(NRepl/NStrata);
NSamples = NSamplesPerStratum * NStrata;
Samples = zeros(NSamples,1);
for i=1:NStrata
    UnifRands = (rand(NSamplesPerStratum,1) + i - 1)/NStrata;
    Rows =  ((i-1)*NSamplesPerStratum + 1): i*NSamplesPerStratum;
    Samples(Rows,:) = norminv(UnifRands);
end
PriceT1 = S0*exp((r-sigma^2/2)*T1 + sigma*sqrt(T1)*Samples);
[calls, puts] = blsprice(PriceT1,K,r,T2-T1,sigma);
Values = exp(-r*T1)*max(calls, puts);
[Price, dummy, CI] = normfit(Values);
