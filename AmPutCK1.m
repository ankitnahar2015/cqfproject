% AmPutCK1.m
function price = AmPutCK1(S0,X,r,T,sigma,Smax,dS,dt,omega,tol)
M = round(Smax/dS); dS = Smax/M; % set up grid 
N = round(T/dt); dt = T/N;
oldval = zeros(M-1,1); % vectors for Gauss-Seidel update
newval = zeros(M-1,1);
vetS = linspace(0,Smax,M+1)';
veti = 0:N; vetj = 0:M;
% set up boundary conditions
payoff = max(X-vetS(2:M),0);
pastval = payoff; % values for the last layer
boundval = X*exp(-r*dt*(N-veti)); % boundary values
% set up the coefficients and the right hand side matrix
alpha = 0.25*dt*( sigma^2*(vetj.^2) - r*vetj );
beta = -dt*0.5*( sigma^2*(vetj.^2) + r );
gamma = 0.25*dt*( sigma^2*(vetj.^2) + r*vetj );
M2 = diag(alpha(3:M),-1) + diag(1+beta(2:M)) + diag(gamma(2:M-1),1);
% solve the sequence of linear systems by SOR method
aux = zeros(M-1,1);
for i=N:-1:1
   aux(1) = alpha(2) * (boundval(1,i) + boundval(1,i+1));
   % set up right hand side and initialize
   rhs = M2*pastval(:) + aux;
   oldval = pastval;
   error = REALMAX;
   while tol < error
      newval(1) = max ( payoff(1), ...
         oldval(1) + omega/(1-beta(2)) * (...
         rhs(1) - (1-beta(2))*oldval(1) + gamma(2)*oldval(2)));
      for k=2:M-2
         newval(k) = max ( payoff(k), ...
            oldval(k) + omega/(1-beta(k+1)) * (...
            rhs(k) + alpha(k+1)*newval(k-1) - ...
            (1-beta(k+1))*oldval(k) + gamma(k+1)*oldval(k+1)));
      end
      newval(M-1) = max( payoff(M-1),...
         oldval(M-1) + omega/(1-beta(M)) * (...
         rhs(M-1) + alpha(M)*newval(M-2) - ...
         (1-beta(M))*oldval(M-1)));
      error = norm(newval - oldval);
      oldval = newval;
   end
   pastval = newval;
end
% find closest point to S0 on the grid and return price
% possibly with a linear interpolation
newval = [boundval(1) ; newval ; 0]; % add missing values
jdown = floor(S0/dS);
jup = ceil(S0/dS);
if jdown == jup
   price = newval(jdown+1,1);
else
   price = newval(jdown+1,1) + ...
      (S0 - jdown*dS)*(newval(jup+1,1) - newval(jup+1,1))/dS;
end 
 
