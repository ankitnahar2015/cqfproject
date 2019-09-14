function Rep=ArithOptCall(I)
 %Function to calculate the price of the Asian option on arithmetic average.
 %I: Number of days used to calculate the average
 %Rep: Price of the option
 I=5;

 %Initial parameters
 S0=100;
 r=0.03;
 sigma=0.3;
 Strike=100;
 T=1;
 NbStep=250;
 DeltaT=T/NbStep;
 NbTraj=50000;

 %Number of days used to calculate the average
 NbDaysAverage=I;

 %Number of days between two days to calculate the average
 DaysBetween = NbStep/NbDaysAverage;

 %Vector used to keep the values needed to calculate the average
 A=zeros(NbTraj,1);

 %We compute each path
 for cptTraj=1:NbTraj
    Path=GenerePaths(S0,r,sigma,1,NbStep,DeltaT);

    %For each day used to calculate the average, we keep the price of the asset
    for cptStep = DaysBetween:DaysBetween:NbStep
        A(cptTraj,1)=A(cptTraj,1) + Path(1,cptStep);
    end

    %Calculation of the arithmetic average
    A(cptTraj,1)=A(cptTraj,1)/NbDaysAverage;
 end

 %Calculation of the cash flows, the average and the standard deviation
 Payoff=exp(-r*T)*max(A-Strike,0);
 std(Payoff)/sqrt(NbTraj)
 Rep=mean(Payoff,1);

 end

 function Rep=GenerePaths(S0,r,sigma,NbTraj,NbStep,DeltaT)
 %Function to generate the paths.
 %S0: Initial price of the asset
 %r: Risk-free rate
 %sigma: Volatility
 %NbTraj: Number of simulated paths
 %NbStep: Number of time steps per paths
 %DeltaT: Delta T

 NuT = (r - sigma*sigma/2)*DeltaT;
 SqDelta = sqrt(DeltaT);
 DeltaW = SqDelta*randn(NbTraj, NbStep);
 Increments = NuT + sigma*DeltaW;
 LogPaths = cumsum(cat(2,log(S0)*ones(NbTraj,1) , Increments) , 2);
 Rep = exp(LogPaths);

 end