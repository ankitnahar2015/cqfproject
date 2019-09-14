function X=GenerateVariables(NbSeries,NbTraj)
 %Function generating log-normal variables Xk,i
 %NbSeries: Number of batches of variables
 %NbTraj: Number of variables per batch

 X = exp(sqrt(0.1) * randn(NbSeries,NbTraj) + 5);

 end