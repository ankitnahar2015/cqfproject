function RatesGenerate
 %Function generating interest rates for $3$ months, $1$ year
 %and 5 years satisfying the specific correlation.

 %Initial parameters
 T=3;
 NbSteps=36;
 DeltaT=T/NbSteps;
 sqDeltaT=sqrt(DeltaT);

 %Cholesky decompostion of the covariance matrix.
 CovTheo=[1,0.1,0.2;0.1,1,0.5;0.1,0.5,1];
 MatrixL=chol(CovTheo)';

 %Initial rates
 r0=[0.035;0.04;0.06];

 %Vector storing the historical rates
 r=cat(2,r0,zeros(3,NbSteps));

 %Rates dynamic parameters
 Speed=[0.25;0.26;0.27];
 Factor=[0.07;0.05;0.05];
 Exponent=[0.5;0.25;0.25];

 %Loop simulating the rates for each time
 for i=1:NbSteps
     dW=MatrixL*randn(3,1);
     r(:,i+1)=r(:,i) + Speed.*(r0-r(:,i))*DeltaT + ...
                 Factor.*r(:,i).^Exponent*sqDeltaT.*dW;
 end

 %We plot the graphs for the rates.
 plot([0:DeltaT:T],r)

 end