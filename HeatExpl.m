% HeatExpl.m
function sol = HeatExpl(deltax, deltat, tmax)
N = round(1/deltax);
M = round(tmax/deltat);
sol = zeros(N+1,M+1);
rho = deltat / (deltax)^2;
rho2 = 1-2*rho;
vetx = 0:deltax:1;
for i=2:ceil((N+1)/2)
   sol(i,1) = 2*vetx(i);
   sol(N+2-i,1) = sol(i,1);
end
for j=1:M
   for i=2:N
      sol(i,j+1) = rho*sol(i-1,j) + ...
         rho2*sol(i,j) + rho*sol(i+1,j);
   end
end

      