function pv = mypvvar(cf,r)
% get number of periods
n = length(cf);
% get vector of discount factors
df = 1./(1+r).^(0:n-1);
% compute result 
pv = dot(cf,df);