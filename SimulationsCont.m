function Rep=SimulationsCont
 %Function to calculate the mean of the variable Z1 using the
 %control variate technique

 NbTraj=100;
 sigma1=0.2;
 sigma2=0.5;
 rho=-0.3;

 % Theoretical parameters
 MoyTheo=[10;15];
 CovTheo=[sigma1^2,rho*sigma1*sigma2;rho*sigma1*sigma2,sigma2^2];
 L=chol(CovTheo)';

 %Simulation of random variables
 Sample=randn(2,NbTraj);
 SampleSimple=repmat(MoyTheo,1,NbTraj)+L*Sample;

 %Transformation of Xi into Zi using the function Control for
 % the control variates
 Z1Cont=Control(exp(SampleSimple(1,:)),...
                        SampleSimple(1,:),10);
 Z2Cont=Control(exp(SampleSimple(2,:)),...
                        SampleSimple(2,:),15);

 Rep=mean(Z1Cont,2);

 end

 function Rep=Control(A,B,MoyB)
 %Function using the control variates technique
 %to adjust the simulated variables.
 %A: Simulated variables
 %B: Control variables
 %MoyB: Theoretical mean of the control variables
 %Rep: Modified variables

 %Covariance between A and B
 MatrixCovEmp = cov(A,B);

 %Calculation of the parameter alpha
 alpha = - MatrixCovEmp(1,2)/MatrixCovEmp(2,2);

 Rep = A + alpha*(B - MoyB);

 end