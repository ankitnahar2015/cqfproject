% CallPortAllocQP.m
ExpRet = [ 0.18 0.25 0.2];
CovMat = [ 0.2 0.05 -0.01 ; 0.05 0.3 0.015 ; ...
      -0.01 0.015 0.1];
RisklessRate = 0.05;
RiskAversion = 3;

H = zeros(4,4);
H(2:4, 2:4) = CovMat*RiskAversion;
f = -[RisklessRate , ExpRet];
Aeq = ones(1,4);
beq = 1;
LB = zeros(4,1);

PWts = quadprog(H,f,[],[],Aeq,beq,LB)

