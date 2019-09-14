% CallPortopt.m
CallPortcons;
ExpRet = [0.03 0.06 0.13 0.14 0.15];
CovMat = [
    0.01       0       0       0       0
       0    0.04   -0.05       0       0
       0   -0.05    0.30       0       0
       0       0       0    0.40    0.20
       0       0       0    0.20    0.40 ];
[PRisk, PRoR, PWts] = portopt(ExpRet, CovMat, 10, [], ConstrMatrix);
[PRoR, PRisk]
PWts