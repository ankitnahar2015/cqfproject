% CheckHaltonScript.m
randn('state',0)
NRepl = 10000;
T = 5;
NSteps = 16;
Limit = NSteps;
S0 = 50;
mu = 0.1; 
sigma = 0.4;
Paths = AssetPaths(S0, mu, sigma, T, NSteps, NRepl);
PercErrors1 = CheckGBMPaths(S0, mu, sigma, T, Paths);
Paths = HaltonPaths(S0, mu, sigma, T, NSteps, NRepl);
PercErrors2 = CheckGBMPaths(S0, mu, sigma, T, Paths);
Paths = GBMHaltonBridge(S0, mu, sigma, T, NSteps, NRepl, Limit);
PercErrors3 = CheckGBMPaths(S0, mu, sigma, T, Paths);
[PercErrors1(:,1), PercErrors2(:,1), PercErrors3(:,1), ...
    PercErrors1(:,2), PercErrors2(:,2), PercErrors3(:,2)]

