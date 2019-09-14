function Least2
 %Function to calculate the price of an American call option
 %using the Least-Squares method.
 %Here the underlying asset is a basket of assets.
 %SBegin: Vector of initial prices
 SBegin=40;
 %T: Maturity of the option
 T=0.25;
 %K: Exercise price of the option
 K=38;   
 
 %Initial parameters
 TimePresent=T;
 NbStep=12;
 NbTraj=100000;
 DeltaT=T/NbStep;
 SqDeltaT=sqrt(DeltaT);
 r=0.05;
 S0=1;
 Strike=K/SBegin;

 %Vectors to store the paths of then three underlying assets
 S1=GeneratePaths(NbTraj,NbStep,DeltaT,SqDeltaT,r,0.2,S0);
 S2=GeneratePaths(NbTraj,NbStep,DeltaT,SqDeltaT,r,0.3,S0);
 S3=GeneratePaths(NbTraj,NbStep,DeltaT,SqDeltaT,r,0.4,S0);


 %Payoff is a vector formed by the highest cash flows
 %using the optimal strategy
 Payoff=zeros(2*NbTraj,1);
 Payoff(:,1)=max([S1(:,NbStep+1)-Strike,S2(:,NbStep+1)-Strike,...
                  S3(:,NbStep+1)-Strike,zeros(2*NbTraj,1)]')';

 %Loop for the backwardation by steps starting from the maturity
 for cptStep=1:NbStep-1
    %Discounting of the vector Payoff
    Payoff=exp(-r*DeltaT)*Payoff;

    TimePresent=TimePresent-DeltaT;

    %Calculation of the new vector Payoff with respect to the exercise decision.
    Payoff=BackwardStep(Payoff,Strike,TimePresent,NbTraj,r,DeltaT,...
                      S1(:,NbStep+1-cptStep),S2(:,NbStep+1-cptStep),...
                      S3(:,NbStep+1-cptStep));
 end

 %Calculation of the price and the standard deviation
 std(exp(-r*DeltaT)*Payoff);
 Price=mean(exp(-r*DeltaT)*Payoff);

 %Calculation of the option price with the departure value of the asset
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

 function Payoff=BackwardStep(Payoff,Strike, TimePresent, NbTraj,...
                            r,DeltaT,S1,S2,S3)
 %Function using the Least-Squares method to determine
 %if it is preferable to exercise immediately.
 %Payoff: Old vector Payoff at time t+1
 %Strike: Exercise price of the option
 %TimePresent: Time t
 %NbTraj: Number of paths
 %r: Interest rate
 %DeltaT
 %S1 S2 S3: Vectors of assets prices at time t

    %Vector containing the paths where the asset price is less than
    %the exercise price (otherwise it is not preferable to exercise the option)
    SelectedPaths=(max([S1-Strike,S2-Strike,S3-Strike]')'>0);
    S1Temp=S1.*SelectedPaths;
    S2Temp=S2.*SelectedPaths;
    S3Temp=S3.*SelectedPaths;

    %Matrix of regressors
    X=[ones(2*NbTraj,1).*SelectedPaths,S1Temp,S1Temp.^2,S1Temp.^3,S2Temp,...
        S2Temp.^2,S2Temp.^3,S3Temp,S3Temp.^2,S3Temp.^3,S1Temp.*S2Temp,...
        S1Temp.*S3Temp,S2Temp.*S3Temp,S1Temp.^2.*S2Temp,S1Temp.^2.*S3Temp,...
        S2Temp.^2.*S1Temp,S2Temp.^2.*S3Temp,S3Temp.^2.*S1Temp,S3Temp.^2.*S2Temp,...
        S1Temp.^4,S2Temp.^4,S3Temp.^4,S1Temp.^3.*S2Temp,S1Temp.^3.*S3Temp,...
        S2Temp.^3.*S1Temp,S2Temp.^3.*S3Temp,S3Temp.^3.*S1Temp,S3Temp.^3.*S2Temp,...
        S1Temp.^2.*S2Temp.^2,S1Temp.^2.*S3Temp.^2,S2Temp.^2.*S3Temp.^2];

    %Vector of expected values
    Y=Payoff.*SelectedPaths;

    %Regression to find the coefficients
    A=inv(X'*X)*X'*Y;

    %Calculation of the expected values when the option is not exercised
    Continuation=(X*A).*SelectedPaths;

    %Values when the option is exercised immediately
    Exercise=max([zeros(2*NbTraj,1),S1-Strike,S2-Strike,S3-Strike]')';

    %Paths, exercise decision and updating of the vector Payoff.
    for i=1:(2*NbTraj)
        if ((Exercise(i,1)>0)&(Exercise(i,1)>Continuation(i,1)))
            Payoff(i,1)=Exercise(i,1);
        end
    end

 end