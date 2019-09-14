function Y=GaussianVector(n,Lambda,mu)
 %Function that generates a gaussian random vector
 %n: Vector's dimension
 %Lambda: Covariance matrix
 %mu: Vector of means

 Y = chol(Lambda)'*randn(n,1) + mu;

 end