function price = SmartEurLattice(S0,K,r,T,sigma,N)
% Precompute invariant quantities
deltaT = T/N;
u=exp(sigma * sqrt(deltaT));
d=1/u;
p=(exp(r*deltaT) - d)/(u-d);
discount = exp(-r*deltaT);
p_u = discount*p;
p_d = discount*(1-p);
% set up S values
SVals = zeros(2*N+1,1);
SVals(1) = S0*d^N;
for i=2:2*N+1
    SVals(i) = u*SVals(i-1);
end
% set up terminal CALL values
CVals = zeros(2*N+1,1);
for i=1:2:2*N+1
    CVals(i) = max(SVals(i)-K,0);
end
% work backwards
for tau=1:N
    for i= (tau+1):2:(2*N+1-tau)
        CVals(i) = p_u*CVals(i+1) + p_d*CVals(i-1);
    end
end
price = CVals(N+1);