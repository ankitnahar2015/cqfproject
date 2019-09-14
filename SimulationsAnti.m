function Rep=SimulationsAnti
 %Function to calculate the mean of the variable Z1 using the
 %antithetic variables technique.
 %Rep: Mean of the variable Z1.

 NbTraj=100;
 sigma1=0.2;
 sigma2=0.5;
 rho=-0.3;

 %Theoretical parameters
 MoyTheo=[10;15];
 CovTheo=[sigma1^2,rho*sigma1*sigma2;rho*sigma1*sigma2,sigma2^2];
 L=chol(CovTheo)';

 %Simulation of the random variables.
 Sample=randn(2,NbTraj);
 SampleSimple=repmat(MoyTheo,1,NbTraj)+L*Sample;

 %Introduction of the antithetic variables
 XAnti=cat(2,SampleSimple,2*repmat(MoyTheo,1,NbTraj)-...
                    SampleSimple);

 %Transformation of Xi into Zi
 Z1Anti=exp(XAnti(1,:));
 Z2Anti=exp(XAnti(2,:));

 Rep=mean(Z1Anti,2);

 end