function SPaths = GBMHaltonBridge(S0, mu, sigma, T, NSteps, NRepl)
if round(log2(NSteps)) ~= log2(NSteps)
    fprintf('ERROR in GBMBridge: NSteps must be a power of 2\n');
    return
end
dt = T/NSteps;
nudt = (mu-0.5*sigma^2)*dt;
SPaths = zeros(NRepl, NSteps+1);
W = WienerHaltonBridge(T,NSteps,NRepl);
Increments = nudt + sigma*diff(W);
LogPath = cumsum([log(S0) , Increments]);
SPaths = exp(LogPath);
Spaths(:,1) = S0;