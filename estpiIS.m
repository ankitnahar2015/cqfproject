function z=estpiIS(m,L)
% define left end-points of sub-intervals
s= (0:(1/L):(1-1/L)) + 1/(2*L);
hvals = sqrt(1 - s.^2);
% get cumulative probabilities
cs=cumsum(hvals);
for j=1:m
   % locate sub-interval
   loc=sum(rand*cs(L) > cs) +1;
   % sample uniformly within sub-interval
   x=(loc-1)/L + rand/L;
   p=hvals(loc)/cs(L);
   est(j) = sqrt(1 - x.^2)/(p*L);
end
z = 4*sum(est)/m;

