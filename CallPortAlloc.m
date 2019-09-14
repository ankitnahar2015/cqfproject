% CallPortAlloc.m
ExpRet = [ 0.18 0.25 0.2];
CovMat = [ 0.2 0.05 -0.01 ; 0.05 0.3 0.015 ; ...
      -0.01 0.015 0.1];
RisklessRate = 0.05;
BorrowRate = NaN;
RiskAversion = 3;

[PRisk, PRoR, PWts] = frontcon(ExpRet, CovMat, 100);

[RiskyRisk , RiskyReturn, RiskyWts, RiskyFraction, ...
   PortRisk, PortReturn] = portalloc(PRisk, PRoR, PWts, ...
      RisklessRate, BorrowRate, RiskAversion);
AssetAllocation = [1-RiskyFraction, RiskyFraction*RiskyWts]

