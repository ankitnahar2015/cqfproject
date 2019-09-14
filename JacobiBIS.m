function [x,i] = JacobiBIS(A,b,x0,eps,MaxIter)
TrueSol = A\b;
aux = norm(TrueSol);
Error = zeros(MaxIter,1);
dA = diag(A);  % get elements on the diagonal of A
C = A - diag(dA);
Dinv = diag(1./dA);
B = - Dinv * C;
b1 = Dinv * b;
oldx = x0;
for i=1:MaxIter
   x = B * oldx + b1;
   Error(i) = norm(x-TrueSol)/aux;
   if norm(x-oldx) < eps*norm(oldx) break; end
   oldx = x;       
end
plot(1:i,Error(1:i))