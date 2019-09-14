function Jump
 %Function that simulates a stochastic process with jumps

 %Initial parameters
 X0=100;
 mu=0.05;
 Div=0.00;
 Lambda= 3;
 sigma=0.3;
 muJ=0.02;
 sigmaJ=0.10;
 T=5;
 NbStep=50; %Number of step per year
 DeltaT=1/NbStep;
 NbDays=T*NbStep;
 k=exp(-muJ)-1;

 %Simulation of Poisson and gaussian variables
 PoissonZ=poissrnd(Lambda/NbStep,1,NbDays);
 DeltaW=randn(1,NbDays);
 PoissonJumps=zeros(1,NbDays);

 %Determination of jumps for the Poisson process
 for i=1:NbDays
    PoissonJumpss(1,i)=sum(randn(PoissonZ(1,i),1));
 end

 %Building of the increments
 IncrementsJumps=(mu-Div-Lambda*k-0.5*sigma^2)*DeltaT*...
                ones(1,NbDays)+sigma*sqrt(DeltaT)*DeltaW+...
                (muJ-0.5*sigmaJ^2)*PoissonZ+sigmaJ*...
                PoissonJumps;
 Increments=(mu-Div-0.5*sigma^2)*DeltaT*ones(1,NbDays)+...
                sigma*sqrt(DeltaT)*DeltaW;
 SolJumps=exp(cumsum([log(X0),IncrementsJumps],2));
 Sol=exp(cumsum([log(X0),Increments],2));

 %Graph of the trajectories with and without jumps
 figure
 hold on
 plot(0:1:NbDays,SolJumps,0:1:NbDays,Sol);
 legend('With jumps','Without jump');
 hold off

 end
