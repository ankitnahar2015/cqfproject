function rep=Euler(NbSeries,NbTraj,NbStep,alpha)
 %Function that computes the approximations error when we use
 %the Euler discretization and present the confidence interval
 %NbSeries: Number of series to simulate
 %NbTraj: Number of trajectories by series
 %NbStep: Number of step to simulate
 %alpha: Confidence level for the error

 %Initial parameters
 X0=100;
 a=0.05;
 b=0.20;
 T=1;
 Delta = 1/NbStep;
 SqDelta = sqrt(Delta);

 %Vector of average epsilons for each series
 EpsilonSeries = zeros(NbSeries,1);

 %For each series we simulate the analytical solutions and
 %the approximations
 for i=1:NbSeries

    %Simulation of the gaussian variables
    DeltaW = SqDelta*randn(NbTraj, NbStep);

    %Construction of real solutions
    Increments = (a-b*b/2)*Delta + b*DeltaW;
    LogPaths=cumsum([log(X0)*ones(NbTraj,1),Increments],2);
    SPaths = exp(LogPaths);

    %Construction of Euler approximations
    EulerInc = log([X0*ones(NbTraj,1),ones(NbTraj,NbStep) +...
                    a*Delta*ones(NbTraj,NbStep)+b*DeltaW]);
    EulerIncCum = cumsum(EulerInc,2);
    Euler = exp(EulerIncCum);

    %Temporary variable to store the approximation errors
    temp=0;
    for j=1:NbTraj
        temp=temp+abs(Euler(j,NbStep+1) - SPaths(j,NbStep+1));
    end;

    %Computation of the average of the errors for series
    EpsilonSeries(i,1)=temp/NbTraj;
 end;

 %Computation of the average and variance of error for all series
 Epsilon = mean(EpsilonSeries,1);
 Var = var(EpsilonSeries);

 %Computation of the confidence interval
 DeltaEpsilon = tinv(alpha,NbSeries-1)*sqrt((Var/NbSeries));

 %Confidence interval at level alpha%
 rep=[Epsilon-DeltaEpsilon, Epsilon, Epsilon+DeltaEpsilon];