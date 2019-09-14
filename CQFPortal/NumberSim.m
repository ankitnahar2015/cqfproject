function [Moy,Cov]=NumberSim(a,b,c,NbTraj)
 %Function comparing the sample statistics as function of
 %the number of simulations
 %a: Standard deviation of X1
 %b: Standard deviation of X2
 %c: Correlation of X1 and X2
 %NbTraj: Number of simulations

 MatrixCovariance = [a^2,c*a*b;c*a*b,b^2];
 MatrixL = chol(MatrixCovariance)';

 X = MatrixL*randn(2,NbTraj);
 Moy=mean(X,2);
 Cov=cov(X');

 end