% DOPutImpl.m
function price = DOPutImpl(S0,X,r,T,sigma,Sb,Smax,dS,dt)
% set up grid and adjust increments if necessary
M = round((Smax-Sb)/dS);
dS = (Smax-Sb)/M;
N = round(T/dt);
dt = T/N;
matval = zeros(M+1,N+1);
vetS = linspace(Sb,Smax,M+1)';
veti = 0:N;
vetj = vetS / dS;
% set up boundary conditions
matval(:,N+1) = max(X-vetS,0);
matval(1,:) = 0;
matval(M+1,:) = 0;
% set up the coefficients matrix
alpha = 0.25*dt*( sigma^2*(vetj.^2) - r*vetj );
beta = -dt*0.5*( sigma^2*(vetj.^2) + r );
gamma = 0.25*dt*( sigma^2*(vetj.^2) + r*vetj );
M1 = -diag(alpha(3:M),-1) + diag(1-beta(2:M)) - diag(gamma(2:M-1),1);
[L,U] = lu(M1);
M2 = diag(alpha(3:M),-1) + diag(1+beta(2:M)) + diag(gamma(2:M-1),1);
% solve the sequence of linear systems
for i=N:-1:1
   matval(2:M,i) = U \ (L \ (M2*matval(2:M,i+1)));
end
% find closest point to S0 on the grid and return price
% possibly with a linear interpolation
jdown = floor((S0-Sb)/dS);
jup = ceil((S0-Sb)/dS);
if jdown == jup
   price = matval(jdown+1,1);
else
   price = matval(jdown+1,1) + ...
      (S0 - Sb - jdown*dS)*(matval(jup+1,1) - matval(jup+1,1))/dS;
end 
 
