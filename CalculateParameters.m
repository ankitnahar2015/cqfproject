function [hHat,sigmaHat]=CalculateParameters(NbSeries,NbTraj,alpha)
 %Function calculating the values of hHat and sigmaHat
 %NbSeries: Number of batches of variables
 %NbTraj: Number of variables per batch
 %alpha: The confidence level of the confidence interval

 X = exp(sqrt(0.1) * randn(NbSeries,NbTraj) + 5);

 %The mean of Z is taken with respect to the 2nd dimension (columns)
 Z = mean(max(0,X - 150),2);
 hHat = mean(Z,1);
 sigmaHat = std(Z);

 Interval=[hHat - tinv(1-alpha,NbTraj)*sigmaHat/sqrt(NbTraj),...
              hHat + tinv(1-alpha,NbTraj)*sigmaHat/sqrt(NbTraj)];

 end