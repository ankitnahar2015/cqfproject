function EulerCont(NbSeries,NbTraj,NbStep,alpha)
 %Funtion that computes the average and variance of variable X
 %using the control variables method
 %NbSeries: Number of series to simulate
 %NbTraj: Number of trajectories for each series
 %NbStep: Number of step to generate
 %alpha: Level of confidence for the error

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
    %Simulation of gaussian variables
    DeltaW = SqDelta*randn(NbTraj, NbStep);

    %Euler approximations with logarithms method
    EulerInc = log([X0*ones(NbTraj,1),ones(NbTraj,NbStep) + ...
                a*Delta*ones(NbTraj,NbStep)+b*DeltaW]);
    EulerIncCum = cumsum(EulerInc,2);
    Euler = exp(EulerIncCum);

    %Control variable
    A=Euler(:,NbStep+1);
    B=sum(DeltaW,2);
    MatrixCovariance=cov(A,B);
    correction=-MatrixCovariance(1,2)/var(B);
    A=A+correction*(B-mean(B));

    AverageSeries(i,1)=mean(A,1);
    VarSeries(i,1)=var(A,1);
 end

 %Computation of the average of averages and variances of the series
 Average = mean(AverageSeries,1);
 Variance=mean(VarSeries,1);

 %Computation of the variance of the averages and variances of series
 VarAverage = var(AverageSeries,1);
 VarVariance=var(VarSeries,1);

 %Computation of the confidence interval for the mean and variance
 DeltaAverage=tinv(alpha,NbSeries-1)*sqrt(VarAverage/NbSeries);
 DeltaVariance=tinv(alpha,NbSeries-1)*sqrt(VarVariance/NbSeries);

 IntervalAverage = [Average-DeltaAverage, Average, Average+DeltaAverage]
 IntervalVariance = [Variance-DeltaVariance, Variance, ...
                        Variance+DeltaVariance]
 end