function P = StopLoss(S0,K,mu,sigma,r,T,Paths)
[NRepl,NSteps] = size(Paths);
NSteps = NSteps - 1;
Cost = zeros(NRepl,1);
dt = T/NSteps;
DiscountFactors = exp(-r*(0:1:NSteps)*dt);
for k=1:NRepl
    CashFlows = zeros(NSteps+1,1);
    if (Paths(k,1) >= K)
        Covered = 1;
        CashFlows(1) = -Paths(k,1);
    else
        Covered = 0;
    end
    for t=2:NSteps+1
        if (Covered == 1) & (Paths(k,t) < K)
            % Sell
            Covered = 0;
            CashFlows(t) = Paths(k,t);
        elseif (Covered == 0) & (Paths(k,t) > K)
            % Buy
            Covered = 1;
            CashFlows(t) = -Paths(k,t);
        end
    end
    if Paths(k,NSteps + 1) >= K
        % Option is exercised
        CashFlows(NSteps + 1) = ...
            CashFlows(NSteps + 1) + K;
    end
    Cost(k) = -dot(DiscountFactors, CashFlows);
end
P = mean(Cost);