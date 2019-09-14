function EulerAnti(NbSeries,NbTraj,NbStep,alpha)
 %Function that computes the average and variance of variable X
 %using the antithetic variable technique
 %NbSeries: Number of series to generate
 %NbTraj: Number of trajectories for each series
 %NbStep: Number of steps to generate
 %alpha: Confidence level for the error

 %Initial parameters
 X0=100;
 a=0.05;
 b=0.20;
 Delta = 1/NbStep;
 T=1;
 SqDelta = sqrt(Delta);

 %Averages and variances vector
 AverageSeries = zeros(NbSeries,1);
 VarSeries=zeros(NbSeries,1);

 for i=1:NbSeries

    %Generation of random variables and antithetic variables
    DeltaW = SqDelta*randn(NbTraj, NbStep);
    DeltaW=[DeltaW;-DeltaW];

    %Euler approximations with logarithms method
    EulerInc = log([X0*ones(2*NbTraj,1),ones(2*NbTraj,NbStep) + ...
                a*Delta*ones(2*NbTraj,NbStep)+b*DeltaW]);
    EulerIncCum = cumsum(EulerInc,2);
    Euler = exp(EulerIncCum);

    AverageSeries(i,1)=mean(Euler(:,NbStep+1),1);
    VarSeries(i,1)=var(Euler(:,NbStep+1),1);

 end

 %Computation of the average of averages and variances of series
 Average = mean(AverageSeries,1);
 Variance=mean(VarSeries,1);

 %Computation of the variance of averages and variances of series
 VarAverage = var(AverageSeries,1);
 VarVariance=var(VarSeries,1);

 %Computation of the confidence interval for average and variance
 DeltaAverage=tinv(alpha,NbSeries-1)*sqrt(VarAverage/NbSeries);
 DeltaVariance=tinv(alpha,NbSeries-1)*sqrt(VarVariance/NbSeries);

 IntervalAverage = [Average-DeltaAverage, Average, Average+DeltaAverage]
 IntervalVariance = [Variance-DeltaVariance, Variance, ...
                        Variance+DeltaVariance]

 end