function OptionIntStoch(S0,K,T,gamma)
 %Function to calculate the prices of the European call and put options
 %using Monte Carlo simulation  and stochastic interest rate.
 %S0: Initial price of the asset
 %K: Exercise price of the options
 %T: Time to maturity of the options
 %gamma: Parameter of the interest rate

 %Initial parameters
 NbPas=100;
 DeltaT=T/NbPas;
 NbTraj=5000;
 sigma=0.2;

 %Parameters of the interest rate
 kappa=0.25;
 theta=0.05;
 sigmaR=0.05;
 r0=0.05;
 rho=-0.2;

 %Vectors of the interest rate values and the discount rates
 r = r0*ones(NbTraj,1);
 rAct = zeros(NbTraj,1);

 %Vector of the asset price
 S = S0*ones(NbTraj,1);

 %Choleski Factorization of the covariance matrix
 L = chol([DeltaT,rho*DeltaT;rho*DeltaT,DeltaT])';

 %Loop to simulate the steps
 for cptPas=1:NbPas
     DeltaZ = randn(2,NbTraj);
     DeltaZ = ReQuadratic(DeltaZ,zeros(2,1),eye(2));
     DeltaW = L*DeltaZ;
     S = S.*(1+r*DeltaT+sigma*DeltaW(1,:)');
     r = r + kappa*(theta-r)*DeltaT + sigmaR*(r.^gamma).*DeltaW(2,:)';
     rAct = rAct + r*DeltaT;
 end
 %Calculation of the price of the options
 PriceCall = mean(max(0,S-K).*exp(-rAct));
 PricePut = mean(max(0,K-S).*exp(-rAct));
 end

 function Rep=ReQuadratic(Sample, MoyTheo,CovTheo)
 %Function performing the quadratic resampling.
 %Sample: Simulated sample
 %MoyTheo: Theoretical mean of the variables
 %CovTheo: Theoretical covariance matrix of the variables

 %Calculation of the sample distribution
 CovEmp=cov(Sample');
 MoyEmp=mean(Sample,2);
 LEmp=chol(CovEmp)';

 %Resampling based on the theoretical covariance matrix
 LTheo=chol(CovTheo)';
 Sample=LTheo*inv(LEmp)*(Sample-...
                repmat(MoyEmp,1,size(Sample,2)))+...
                repmat(MoyTheo,1,size(Sample,2));
 Rep=Sample;
 end