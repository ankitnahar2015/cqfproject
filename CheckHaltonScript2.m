% CheckHaltonScript.m
randn('state',0)
T = 5;
NSteps = 32;
Limit = NSteps;
S0 = 50;
mu = 0.1; 
sigma = 0.4;
PathsMC = AssetPaths(S0, mu, sigma, T, NSteps, 500000);
PathsH = GBMHaltonBridge(S0, mu, sigma, T, NSteps, 10000, Limit);
MeanMC = mean(PathsMC(:,2:33),2);
MeanH = mean(PathsH(:,2:33),2);
InMoneyMC = sum(MeanMC >= 55)
InMoneyH = sum(MeanH >= 55)
xx = 55:300;
for i=1:length(xx)
    AboveMC(i) = sum(MeanMC >= xx(i));
    AboveH(i) = sum(MeanH >= xx(i));
end
[xx', AboveMC'/500000, AboveH'/10000]


