function price = ExampleLS;
% this function replicates example 1 on pages 115-120 of the 
% original paper by Longstaff and Schwartz
S0 = 1; K = 1.1; r = 0.06; T = 3;
NSteps = 3;
dt = T/NSteps;
discountVet = exp(-r*dt*(1:NSteps)');
% generate sample paths
NRepl = 8;
SPaths = [
    1.09 1.08 1.34
    1.16 1.26 1.54
    1.22 1.07 1.03
    0.93 0.97 0.92
    1.11 1.56 1.52
    0.76 0.77 0.90
    0.92 0.84 1.01
    0.88 1.22 1.34
];
%
alpha = zeros(3,1); % regression parameters
CashFlows = max(0, K - SPaths(:,NSteps));
ExerciseTime = NSteps*ones(NRepl,1);
for step = NSteps-1:-1:1
    InMoney = find(SPaths(:,step) < K);
    XData = SPaths(InMoney,step);
    RegrMat = [ones(length(XData),1), XData, XData.^2];
    YData = CashFlows(InMoney).*discountVet(ExerciseTime(InMoney)-step);
    alpha = RegrMat \ YData;
    IntrinsicValue = K - XData;
    ContinuationValue = RegrMat * alpha;
    Index = find(IntrinsicValue>ContinuationValue);
    ExercisePaths = InMoney(Index);
    CashFlows(ExercisePaths) = IntrinsicValue(Index);
    ExerciseTime(ExercisePaths) = step;
end % for
price = max(K-S0, mean(CashFlows.*discountVet(ExerciseTime)));
