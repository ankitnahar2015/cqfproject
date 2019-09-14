function rep=OptionIntVolStoch(S0,Strike,T,gamma)
 %Function to calculate the prices of the European call and put options
 %using Monte Carlo simulations with stochastic interest rate and stochastic volatility.
 %S0: Initial asset price
 %K: Exercise price of the options
 %T: Time to maturity of the options
 %gamma: Parameter of the interest rate
 %Initial parameters
 NbStep=100;
 DeltaT=T/NbStep;
 NbTraj=5000;
 rho=-0.2;
 %Parameters of the stochastic interest rate
 kappa=0.25;
 theta=0.05;
 sigmaR=0.05;
 r0=0.05;
 %Parameters of the stochastic volatility
 nu=1.25;
 beta=0.04;
 sigma0=0.2;
 sigmaSigma=0.2;
 rho2=-0.5;
 rho3=rho*rho2;
 %Vectors of spot interest rates and discounted rates
 r = r0*ones(NbTraj,1);
 rAct = zeros(NbTraj,1);
 %Vectors of asset and  volatility values
 S = S0*ones(NbTraj,1);
 sigma = sigma0*ones(NbTraj,1);
 %Choleski Factorization
 L=chol([DeltaT,rho*DeltaT,rho2*DeltaT;rho*DeltaT,DeltaT,rho3*DeltaT;...
          rho2*DeltaT,rho3*DeltaT,DeltaT])';
 %Simulation of the paths
 for cptpas=1:NbStep
     DeltaZ = randn(3,NbTraj);
     DeltaZ = ReQuadratic(DeltaZ,zeros(3,1),eye(3));
     DeltaW = L*DeltaZ;
     S = S.*(1+r*DeltaT+sigma.*DeltaW(1,:)');
     r = r+kappa*(theta-r)*DeltaT+sigmaR*(r.^gamma).*DeltaW(2,:)';
     sigma = (sigma.^2+nu*(beta-sigma.^2)*DeltaT+...
               sigmaSigma*sigma.*DeltaW(3,:)').^(0.5);
     rAct = rAct + r*DeltaT;
 end
 %Calculation of the prices of the European call and put options
 PrixCall = mean(max(0,S-Strike).*exp(-rAct));
 PrixPut = mean(max(0,Strike-S).*exp(-rAct));
 end
 function Rep=ReQuadratic(Sample, MoyTheo,CovTheo)
 %Function performing the quadratic resampling
 %Sample: Simulated sample
 %MoyTheo: Theoretical mean of the variables
 %CovTheo: Theoretical covariance matrix of the variables
 %Calculation of the parameters of the sample distribution
 CovEmp=cov(Sample');
 MoyEmp=mean(Sample,2);
 LEmp=chol(CovEmp)';
 %Resampling based on the theoretical covariance matrix
 LTheo=chol(CovTheo)';
 Sample=LTheo*inv(LEmp)*(Sample-repmat(MoyEmp,1,size(Sample,2)))+repmat(MoyTheo,1,size(Sample,2));
 Rep=Sample;
 end