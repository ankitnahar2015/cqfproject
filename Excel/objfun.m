function fval = objfun(x)
fval = exp(x(1)) * ( 4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1);
