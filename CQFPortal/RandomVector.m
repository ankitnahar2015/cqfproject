function rep=RandomVector(sigma1,sigma2,rho)
 %Generation of a random vector of dimension 2 and correlation rho

 MatrixL = [sigma1,0;rho*sigma2,sigma2*sqrt(1-rho^2)];
 rep = MatriceL*randn(2,1);

 end