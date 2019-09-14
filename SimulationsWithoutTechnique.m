function Moy=SimulationsWithoutTechnique
 %Function to calculate the mean of the variable Z1 without using
 %a simulations improving quality technique

 NbTraj=100; %Number of simulations
 sigma1=0.2; %Standard deviation of X1
 sigma2=0.5; %Standard deviation of X1
 rho=-0.3;   %Correlation between X1 and X2

 %Theoretical mean and covariance of the variables X1 and X2.
 MoyTheo=[10;15];
 CovTheo=[sigma1^2,rho*sigma1*sigma2;rho*sigma1*sigma2,sigma2^2];

 Sample=randn(2,NbTraj); %Simulation of the Gaussian variables
 L=chol(CovTheo)';       %Cholesky factorization

 %Simulation of the variables X1 and X2
 SampleSimple=repmat(MoyTheo,1,NbTraj)+L*Sample;

 %Transformation of the variables X1 and X2 into Z1 and Z2
 Z1Simple=exp(SampleSimple(1,:));
 Z2Simple=exp(SampleSimple(2,:));

 Moy=mean(Z1Simple,2);

 end