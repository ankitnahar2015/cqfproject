% HeatImpl.m
function sol = HeatImpl(deltax, deltat, tmax)
N = round(1/deltax);
M = round(tmax/deltat);
sol = zeros(N+1,M+1);
rho = deltat / (deltax)^2;
B = diag((1+2*rho) * ones(N-1,1)) - ...
   diag(rho*ones(N-2,1),1) - diag(rho*ones(N-2,1),-1);
vetx = 0:deltax:1;
for i=2:ceil((N+1)/2)
   sol(i,1) = 2*vetx(i);
   sol(N+2-i,1) = sol(i,1);
end
for j=1:M
   sol(2:N,j+1) = B \ sol(2:N,j);   
end
