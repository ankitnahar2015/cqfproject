function DownAndInCall
 %Function to calculate the value of an exotic call option Down And In.

 S0=100;
 Strike = 100;
 Barrier = 90;
 InterestRate = 0.05;
 Dividend = 0.02;
 T = 1;
 sigma = 0.30;
 NbTraj = 1000000;
 Mu = InterestRate-Dividend;

 %Simulation of the final value of the paths.
 Paths = exp(log(S0)+(Mu-sigma*sigma/2)*T+ ...
                       randn(NbTraj,1)*sigma*sqrt(T));

 %Calculation of the value x in the article of El Babsiri and Noel.
 x=log(Paths/S0);

 %Simulation of the minimum of the paths
 Uniform = rand(NbTraj,1);
 Minimum=(x-sqrt(x.*x-2*sigma^2*T*log(Uniform)))/2;

 %Calculation of the payoffs at the maturity
 PayoffPV=exp(-InterestRate*T)*max(Paths-Strike,0).* ...
               (Minimum<log(Barrier/S0));

 %Presentation of the mean and the standard deviation of the payoffs.
 disp('Estimation');
 disp(mean(PayoffPV,1));
 disp('Error');
 disp(std(PayoffPV)/sqrt(NbTraj));
 end