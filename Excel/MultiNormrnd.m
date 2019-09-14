% MultiNormrnd.m
function Z = MultiNormrnd(mu,sigma,howmany)
n = length(mu);
Z = zeros(howmany,n);
mu = mu(:); % make sure it's a column vector
U = chol(sigma);
for i=1:howmany
   Z(i,:) = mu' + randn(1,n) * U;
end