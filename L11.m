% exercise 11, chapter 13, from Luenberger, Investment Science
function ExpPayoff = L11(premium,S0,K,r,sigma,T,N)
deltaT = T/N;
u=exp(sigma * sqrt(deltaT));
d=1/u;
p=(exp(r*deltaT) - d)/(u-d);
lattice = zeros(N+1,N+1);
for i=0:N
   if (S0*(u^i)*(d^(N-i)) >= K)
      lattice(i+1,N+1)=S0*(u^i)*(d^(N-i)) - K - premium;
   end
end
for j=N-1:-1:0
   for i=0:j
      lattice(i+1,j+1) = p * lattice(i+2,j+2) + (1-p) * lattice(i+1,j+2);
   end
end
ExpPayoff = lattice(1,1);
