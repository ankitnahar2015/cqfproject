function rep=Retrieval
 %Function to retrieve the volatility of a financial instrument
 %based on the method proposed by Cvitanic et al.
 %Here, the financial instrument is a call option.

 %Initial parameters
 S0 = 100;
 Sig0 = 0.1;
 R0 = 0.06;
 T = 0.3;
 NbTraj=10000;
 NbStep=100;
 NbTrajSim2=100; %Value of M in the theory
 DeltaT=T/NbStep;

 %Calculation of the price of the option at time t=0.
 PriceZero=PriceCall(T,NbTraj,NbStep,S0,R0,Sig0,DeltaT);

 %Simulation of the first time step to find the values of the option
 %at time t=DeltaT
 Temp=sqrt(DeltaT)*randn(NbTraj,1);
 dW1 = cat(1,Temp,-Temp);
 SOne = S0 + S0.*(R0*DeltaT+Sig0.*dW1);
 rOne = R0 + 0.0824*(0.06 - R0)*DeltaT - 0.0364*sqrt(R0).*dW1;
 sigmaOne = Sig0 + 0.695*(0.1 - Sig0)*DeltaT + 0.21*dW1;

 %Vector to store the option prices at time t=DeltaT
 PriceOne=zeros(2*NbTraj,1);

 %Calculation of the prices at time t=DeltaT
 for j=1:2*NbTraj
    PriceOne(j,1)=PriceCall(T-DeltaT,NbTrajSim2,NbStep-1,SOne(j,1),...
                          rOne(j,1),sigmaOne(j,1),DeltaT);
 end

 %Calculation of the volatility using the method presented.
 rep=mean((PriceOne-PriceZero).*dW1,1)/(DeltaT);

 end



function rep=PriceCall(T,NbTraj,NbStep,S,r,sigma, DeltaT)
 %Simple function to calculate the value of an European call option.
 %T: Maturity
 %NbTraj: Number paths to simulate
 %NbStep: Number of time steps by path
 %S: Initial price of the stock
 %r: Risk-free interest rate
 %sigma: Volatility of the underlying stock price
 %DeltaT: Time step

 %Initial parameters
 K=90;
 S = S*ones(2*NbTraj,1);
 r = r*ones(2*NbTraj,1);
 sigma = sigma*ones(2*NbTraj,1);

 %Loop to simulate the paths at each time step
 for i=1:NbStep
     Temp = sqrt(DeltaT)*randn(NbTraj,1);
     dW = cat(1,Temp,-Temp);
     S = S + S.*(r*DeltaT+sigma.*dW);
     r = r + 0.0824*(0.06-r)*DeltaT - 0.0364*sqrt(r).*dW;
     sigma = sigma + 0.695*(0.1-sigma)*DeltaT + 0.21*dW;
 end

 %Calculation of the option price
 Price = exp(-r*DeltaT*NbStep).*max(S - K,0);
 rep=mean(Price,1);

 end