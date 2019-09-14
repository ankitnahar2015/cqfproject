function rep = EurLik

 r=0.1;      %Risk-free rate
 k=100;      %Strike price
 sigma=0.25; %Stock return volatility
 delta=0.03; %Dividend yield
 T=0.2;      %Maturity
 S0=110;     %Initial stock price

 NStep = floor(T*365.25); %Number of time step
 Delta = 1/365.25;        %Length of a step
 NTraj = 100000;          %Number of paths

 %Simulation of paths
 dW = zeros(2*NTraj,1);
 S = S0*ones(2*NTraj,1);
 Temp =zeros(NTraj,1); dW = cat(1,Temp, -Temp);

 for i=1:NStep
    Temp = sqrt(Delta)*randn(NTraj,1);
    dW = cat(1,Temp,-Temp);
    S = S + S.*((r-delta)*Delta + sigma*dW);
 end
 %End of Simulation of paths

 %Computation of the values used in the estimators formulae
 d = (log(S/S0) - (r - delta - 0.5*sigma^2)*T)/(sigma*sqrt(T));
 ddsig= (log(S0) - log(S) + (r - delta +0.5*sigma^2)*T)/(sigma^2*sqrt(T));

 %Estimation of DELTA
 EstimDel = exp(-r*T)*max(S-k,0).*1/(S0*sigma^2*T).*(log(S/S0) -...
                 (r -delta - 0.5*sigma^2)*T);

 Del = sum(EstimDel)/(2*NTraj);
 DelError = sqrt((EstimDel -Del)'*(EstimDel - Del)/(2*NTraj))/sqrt(NTraj);

 %Printing the result for DELTA
 fprintf('\n DELTA of the option: %f', Del);
 fprintf('\n Standard error: %f', DelError);
 %End of Estimation of DELTA


 %Estimation of GAMMA
 EstimGam = exp(-r*T)*max(S-k,0).*(d.*d - d*sigma*sqrt(T) -1)/...
                (S0^2*sigma^2*T);

 Gam = sum(EstimGam)/(2*NTraj);
 GamError = sqrt((EstimGam -Gam)'*(EstimGam - Gam)/(2*NTraj))/sqrt(NTraj);

 %Printing the result for GAMMA
 fprintf('\n GAMMA of the option: %f', Gam);
 fprintf('\n Standard error: %f', GamError);
 %End of Estimation of GAMMA

 rep = 1;