function VaRPortfolio(NbTraj)
 %Function computing the portfolio's value at risk.
 %Initial values of the indices and the exchange rate.
 STSX = 11675.16;
 SEuroNext = 1466.24;
 e=1.4147;
 %Computation of the indices proportions that we buy.
 NbTSX = 50000/STSX;
 NbEuroNext = 50000/(e*SEuroNext);
 %250 working days per year
 NbSteps=250;
 DeltaT=1;
 %Cholesky decomposition of the covariance matrix.
 L=chol([1,0.47424,0.09901;0.47424,1,-0.16983;0.09901,-0.16983,1])';
 %Vector keeping the simulated values for the portfolio.
 PortfolioValue=zeros(NbTraj,1);
 %Loop simulating the trajectories.
 for i=1:NbTraj
    %Re-initialization of the indices values and exchange rate.
    STSX = 11675.16;
    SEuroNext = 1466.24;
    e=1.4147;
    %Loop simulating the indices and exchange rates dynamic.
    for k=1:NbSteps
        Z=L*randn(3,1);
        STSX=STSX*(1+0.001763+0.005909*Z(1,1));
        SEuroNext = SEuroNext*(1+0.002292+0.005295*Z(2,1));
        e = e*(1+0.000794+0.005754*Z(3,1));
    end
    %Computation of the portfolio's final value.
    PortfolioValue(i,1)=NbTSX*STSX+NbEuroNext*SEuroNext*e;
 end
 %Sorting of the final value of the portfolio and computation of the
 %value at risk.
 PortfolioValue=sort(PortfolioValue);
 VaR=mean(PortfolioValue) - PortfolioValue(floor(NbTraj*0.01),1);
 disp(VaR);
 end