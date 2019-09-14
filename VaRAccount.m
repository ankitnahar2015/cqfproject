function VaR=VaRAccount(N)
 %Function computing the value at risk for one year of a bank account.
 %N: Number of simulations to do
 %Vector keeping the balance in the account for all the simulations.
 Account=zeros(N,1);
 %Initial balance in the account.
 InitialBalance=100;
 %For each simulation we compute the account's balance
 for j=1:N
    Balance=InitialBalance;
    Account(j,1)=BalanceAccount;
 end
 %Sorting of the balances
 Account=sort(Account);
 %Value at risk computation.
 VaR=mean(Account)-Account(floor(0.01*N),1);

 function rep=BalanceAccount
 %Function generating the balance in an account
    %Initial parameters
    T=1;
    NbSteps=12;
    DeltaT=T/NbSteps;
    sqDeltaT=sqrt(DeltaT);
    %Cholesky decomposition of the covariance matrix.
    CovTheo=[1,0.1,0.2;0.1,1,0.5;0.1,0.5,1];
    MatrixL=chol(CovTheo)';
    %Initial interest rates
    r0=[0.035;0.04;0.06];
    %Vector keeping the historical rates
    r=cat(2,r0,zeros(3,NbSteps));
    %Parameters of the rates' dynamic
    Speed=[0.25;0.26;0.27];
    Factor=[0.07;0.05;0.05];
    Exponent=[0.5;0.25;0.25];
    %Loop generating the interest rates for each step
    for i=1:NbSteps
        dW=MatrixL*randn(3,1);
        r(:,i+1)=max(0,r(:,i) + Speed.*(r0-r(:,i))*DeltaT +...
                  Factor.*r(:,i).^Exponent*sqDeltaT.*dW);
        Balance=max(0,Balance+Balance*(0.1+0.1/0.035*r(1,i+1)+...
                  0.05/0.04*r(2,i+1)+0.1/sqDeltaT*randn(1))*DeltaT);
    end
    rep=Balance;
 end
 end