function [x,i] = Jacobi(A,b,x0,eps,MaxIter)
dA = diag(A);  % get elements on the diagonal of A
C = A - diag(dA);
Dinv = diag(1./dA);
B = - Dinv * C;
b1 = Dinv * b;
oldx = x0;
for i=1:MaxIter
   x = B * oldx + b1;
   if norm(x-oldx) < eps*norm(oldx) break; end
   oldx = x;       
end
