function rep = AsiPath

 r=0.1;         %Risk-free rate
 k=100;         %Strike price
 sigma=0.25;    %Stock return volatility
 delta=0.03;    %Dividend yield
 T=0.2;         %Maturity (years)
 S0=90;         %Stock initial value

 %DELTA and GAMMA estimations for an Asian arithmetic option
 %with pathwise derivatives estimates

NStep = floor(T*365.25); %Number of time step
 Delta = 1/365.25;        %Length of a step
 NTraj = 100000;          %Number of paths
 m = 30; %Number of days used to calculate the arithmetic average
 Si = zeros(2*NTraj,m);% Storage of the values
 SAve = zeros(2*NTraj,1);% Average values

 %Parameters initialization
 dW = zeros(2*NTraj,1);
 S = S0*ones(2*NTraj,1);
 dW=sqrt(Delta)*randn(NTraj,NStep);
 dW=cat(1,dW,-dW);
 %End of parameters initialization

 %Storing the simulation values
 j=1;
    for i=1:NStep
        S = S + S.*((r-delta)*Delta + sigma*dW(:,i));
        if i > NStep - m
            Si(:,j) = S;
            j=j+1;
        end
    end
 %End of Storing the simulation values

 %Computing the average value
 SAve = sum(Si,2)/m;

 %Estimation of DELTA
 EstimDel = exp(-r*T)*(SAve>=k).*SAve/S0;

 Del = sum(EstimDel)/(2*NTraj);
 DelError = sqrt((EstimDel -Del)'*(EstimDel - Del)/(2*NTraj))/sqrt(NTraj);

 %Printing the result for DELTA
 fprintf('\n Option''s DELTA: %f', Del);
 fprintf('\n Standard error: %f', DelError);
 %End of Estimation of DELTA

 %Estimation of GAMMA
 d = zeros(2*NTraj,1);
 g = zeros(2*NTraj,1);
 w = m*(k - SAve) + Si(:,m);
 for i=1:2*NTraj
    if (w(i,1)>0)
        d(i,1) = (log(w(i,1)/Si(i,m-1)) - (r - delta - 0.5*sigma^2)*Delta)/...
                    (sigma*sqrt(Delta));
        g(i,1) = normpdf(d(i,1))/(w(i,1)*sigma*sqrt(Delta));
    end
 end
 EstimGam = exp(-r*T)*(k/S0)^2*m*g;

 Gam = sum(EstimGam)/(2*NTraj);
 GamError = sqrt((EstimGam -Gam)'*(EstimGam - Gam)/(2*NTraj))/sqrt(NTraj);

 % Printing the result for GAMMA
 fprintf('\n Option''s GAMMA: %f', Gam);
 fprintf('\n Standard error: %f', GamError);
 %End of Estimation of GAMMA

 rep = 1;