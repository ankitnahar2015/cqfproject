function [Moy,Cov]=SimulationsWithRQ(a,b,c,NbTraj)
 %Function comparing the sample moments as function of
 %the number of simulations
 %a: Standard deviation of X1
 %b: Standard deviation of X2
 %c: Covariance of X1 and X2
 %NbTraj: Number of simulations


%Theoretical parameters of the variables
 MoyTheo=[0;0];
 CovTheo=[a^2,c^2;c^2,b^2];
 L=chol(CovTheo)';

 %Simulation of the random variables
 Sample=randn(2,NbTraj);
 SampleSimple=repmat(MoyTheo,1,NbTraj)+L*Sample;

 %Calling the function ReQuadratic
 XRQ=ReQuadratic(SampleSimple,MoyTheo,CovTheo);

 Moy=mean(XRQ,2);
 Cov=cov(XRQ');

 end