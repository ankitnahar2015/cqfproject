function LSM
 %Function to calculate the price of an American option
 %using the Least-Squares method.

 T=1; %Maturity
 TimePresent=T; %Time to maturity
 NbStep=50; %Number of steps.
 K=40; %Exercise price
 sigma=0.2; %Volatility of the asset
 NbTraj=50000; %Number of paths
 DeltaT=T/NbStep;
 SqDeltaT=sqrt(DeltaT);
 r=0.06;
 SBegin=36; %Initial price of the asset

 %To increase the precision of the regression,
 %we use an initial price of 1
 %and we decrease the exercise price consequently
 S0=1; %
 Strike=K/SBegin;

 %We generate the paths of the asset price
 S=GeneratePaths(NbTraj,NbStep,DeltaT,SqDeltaT,r,sigma,S0);

 %Payoff is a vector formed of the largest cash flows
 %using the optimal strategy
 Payoff=zeros(2*NbTraj,1);
 Payoff(:,1)=max(0,Strike-S(:,NbStep+1));

 %Loop for backwardation by step from the maturity
 for cptStep=1:NbStep-1
    %Discounting of the payoff vector
    Payoff=exp(-r*DeltaT)*Payoff;

    TimePresent=TimePresent-DeltaT;

    %Calculation of the new payoff vector by deciding if it is optimal
    %to exercise the option immediately.
    Payoff=BackwardStep(Payoff,Strike,TimePresent,NbTraj,r,DeltaT,...
                         S(:,NbStep+1-cptStep));
 end

 %Calculation of the option price
 Price=mean(exp(-r*DeltaT)*Payoff);

 %Calculation of the option price with the initial price of the asset
 disp(Price*SBegin);

 end

 function S=GeneratePaths(NbTraj,NbStep,DeltaT,SqDeltaT,r,sigma,S0);
 %Function to simulate the paths of the asset price

    dW=SqDeltaT*randn(NbTraj,NbStep);
    dW=cat(1,dW,-dW);

    Increments=(r-(sigma^2)/2)*DeltaT+sigma*dW;
    LogPaths=cumsum([log(S0)*ones(2*NbTraj,1),Increments],2);
    S=exp(LogPaths);
 end

 function Payoff=BackwardStep(Payoff,Strike, TimePresent, NbTraj,r, ...
                              DeltaT,S)
 %Function using the Least-Squares method to determine
 %if it is preferable to exercise immediately the option.
 %Payoff: Old vector of Payoff at time t+1
 %Strike: Exercise price of the option
 %TimePresent: time t
 %NbTraj: Number of paths
 %r: interest rate
 %DeltaT
 %S: Vector of asset prices at time t

    %Vector containing the paths where the price of the asset is lower than
    %the exercise price (otherwise it is preferable to exercise)
    SelectedPaths=(Strike>S);

    %Matrix of regressors
    X=[ones(2*NbTraj,1).*SelectedPaths,(S.*SelectedPaths),(S.*SelectedPaths).^2];

    %Vector of expected payoffs
    Y=Payoff.*SelectedPaths;

    %Regression to determine the coefficients
    A=inv(X'*X)*X'*Y;

    %Calculation of the payoffs values when the option is not exercised
    Continuation=(X*A).*SelectedPaths;

    %Values when the option is exercised immediately
    Exercise=max(0,Strike-S);

    %Paths, exercise decision and update of the Payoff vector.
    for i=1:(2*NbTraj)
        if ((Exercise(i,1)>0)&(Exercise(i,1)>Continuation(i,1)))
            Payoff(i,1)=Exercise(i,1);
        end
    end

 end