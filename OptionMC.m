function OptionMC(S0,K,T)
 %Function to calculate the prices of European Put and Call options
 %using Monte Carlo simulations.
 %S0: Initial price of the asset
 %K: Exercise price of the options
 %T: Time to maturity of the options

 %Initial parameters
 sigma=0.2;
 r=0.05;
 NbTraj=5000;
 NbPas=100;
 DeltaT=T/NbPas;

 %Vector of asset prices
 SPresent=S0*ones(NbTraj,1);
 SNext=zeros(NbTraj,1);

 %Loop to simulate the paths
 for i=1:NbPas
    dW=sqrt(DeltaT)*randn(NbTraj,1);
    SNext=SPresent+(r)*SPresent*DeltaT+sigma*SPresent.*dW;
    SPresent=SNext;
 end

 %Calculation of the options prices
 Call = exp(-r*T)*mean(max(0,SPresent-K))
 Put = exp(-r*T)*mean(max(0,K-SPresent))

 end