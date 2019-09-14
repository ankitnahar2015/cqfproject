function price = AmSpreadLattice(S10,S20,K,r,T,sigma1,sigma2,rho,q1,q2,N)
% Precompute invariant quantities
deltaT = T/N;
nu1 = r - q1 - 0.5*sigma1^2;
nu2 = r - q2 - 0.5*sigma2^2;
u1 = exp(sigma1*sqrt(deltaT));
d1 = 1/u1;
u2 = exp(sigma2*sqrt(deltaT));
d2 = 1/u2;
discount = exp(-r*deltaT);
p_uu = discount*0.25*(1 + sqrt(deltaT)*(nu1/sigma1 + nu2/sigma2) + rho);
p_ud = discount*0.25*(1 + sqrt(deltaT)*(nu1/sigma1 - nu2/sigma2) - rho);
p_du = discount*0.25*(1 + sqrt(deltaT)*(-nu1/sigma1 + nu2/sigma2) - rho);
p_dd = discount*0.25*(1 + sqrt(deltaT)*(-nu1/sigma1 - nu2/sigma2) + rho);
% set up S values
S1vals = zeros(2*N+1,1);
S2vals = zeros(2*N+1,1);
S1vals(1) = S10*d1^N;
S2vals(1) = S20*d2^N;
for i=2:2*N+1
    S1vals(i) = u1*S1vals(i-1);
    S2vals(i) = u2*S2vals(i-1);
end
% set up terminal values
Cvals = zeros(2*N+1,2*N+1);
for i=1:2:2*N+1
    for j=1:2:2*N+1
        Cvals(i,j) = max(S1vals(i)-S2vals(j)-K,0);
    end
end
% roll back
for tau=1:N
    for i= (tau+1):2:(2*N+1-tau)
        for j= (tau+1):2:(2*N+1-tau)
            hold = p_uu * Cvals(i+1,j+1) + p_ud * Cvals(i+1,j-1) + ...
                p_du * Cvals(i-1,j+1) + p_dd * Cvals(i-1,j-1);
            Cvals(i,j) = max(hold, S1vals(i) - S2vals(j) - K);
        end
    end
end
price = Cvals(N+1,N+1);

