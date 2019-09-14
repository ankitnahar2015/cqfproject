% CompareAsianH.m
randn('state',0)
S0 = 50;
K = 55;
r = 0.05;
sigma = 0.4;
T = 4;
NSamples = 16;
NRepl = 500000;
aux = AsianMC(S0,K,r,T,sigma,NSamples,NRepl);
fprintf(1,'Extended MC %f\n', aux);
NRepl = 10000;
aux = AsianHalton(S0,K,r,T,sigma,NSamples,NRepl);
fprintf(1,'Halton %f\n', aux);
for i=1:20
    aux(i) = AsianMC(S0,K,r,T,sigma,NSamples,NRepl);
end
fprintf(1,'MC mean %f st.dev %f\n', mean(aux), sqrt(var(aux)));
Limit = 1;
for i=1:20
    aux(i) = AsianHaltonBridge(S0,K,r,T,sigma,NSamples,NRepl,Limit);
end
fprintf(1,'HB (limit: %d) mean %f st.dev %f\n', ... 
    Limit, mean(aux), sqrt(var(aux)));
Limit = 2;
for i=1:20
    aux(i) = AsianHaltonBridge(S0,K,r,T,sigma,NSamples,NRepl,Limit);
end
fprintf(1,'HB (limit: %d) mean %f st.dev %f\n', ... 
    Limit, mean(aux), sqrt(var(aux)));
Limit = 4;
for i=1:20
    aux(i) = AsianHaltonBridge(S0,K,r,T,sigma,NSamples,NRepl,Limit);
end
fprintf(1,'HB (limit: %d) mean %f st.dev %f\n', ... 
    Limit, mean(aux), sqrt(var(aux)));
Limit = 16;
aux = AsianHaltonBridge(S0,K,r,T,sigma,NSamples,NRepl,Limit);
fprintf(1,'HB (limit: %d) %f\n', Limit, aux);

