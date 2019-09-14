function SPaths=HaltonPaths(S0,mu,sigma,T,NSteps,NRepl)
dt = T/NSteps;
nudt = (mu-0.5*sigma^2)*dt;
sidt = sigma*sqrt(dt);
% Use inverse transform to generate standard normals
NormMat = zeros(NRepl, NSteps);
Bases = myprimes(NSteps);
for i=1:NSteps
   H = GetHalton(NRepl,Bases(i));
   RandMat(:,i) = norminv(H);
end
Increments = nudt + sidt*RandMat;
LogPaths = cumsum([log(S0)*ones(NRepl,1) , Increments] , 2);
SPaths = exp(LogPaths);
SPaths(:,1) = S0;
