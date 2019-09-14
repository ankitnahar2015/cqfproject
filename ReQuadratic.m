function Rep=ReQuadratic(X,MoyTheo,CovTheo)
 %Function to perform the quadratic resampling
 %X: Sample matrix of the variables where the number of columns
 %   is equal to the number of simulations and the number of line is
 %   the dimension of the vector
 %MoyTheo: Theoretical mean vector of the random vector
 %CovTheo: Theoretical covariance matrix of the random vector
 %Rep: Sample matrix of the modified sample values

 NbTraj = size(X,2);

 %Determination of the sample parameters
 MoyEmp = mean(X,2);
 CovEmp = cov((X-repmat(MoyEmp,1,NbTraj))');
 LEmp = chol(CovEmp)';

 LTheo = chol(CovTheo)';

 Rep = LTheo*inv(LEmp)*(X-repmat(MoyEmp,1,NbTraj)) ...
          + repmat(MoyTheo,1,NbTraj);

 end