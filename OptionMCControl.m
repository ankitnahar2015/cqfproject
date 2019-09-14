function OptionMCControl(S0,K,T)
 %Function to calculate the prices of European Put and Call options
 %using Monte Carlo simulations with control variates.
 %S0: Initial price of the underlying asset
 %K: Exercise price of the options
 %T: Time to maturity of the options

 %Initial parameters
 sigma=0.2;
 r=0.05;
 NbTraj=5000;
 NbPas=100;
 DeltaT=T/NbPas;

 %Price vector of the asset
 SPresent=S0*ones(NbTraj,1);
 SNext=zeros(NbTraj,1);

 %Loop to simulate the paths
 for i=1:NbPas
    dW=sqrt(DeltaT)*randn(NbTraj,1);
    SNext=SPresent+(r)*SPresent*DeltaT+sigma*SPresent.*dW;
    SPresent=SNext;
 end

 %Using the control variates technique for the call option
 X1=exp(-r*T)*max(0,SPresent-K);
 EX1=mean(X1);
 Y=SPresent;
 EY=S0*exp(r*T);

 cov1=((X1-EX1)'*(Y-EY))/(NbTraj-1);
 var=((Y-EY)'*(Y-EY))/(NbTraj-1);
 alpha1=-cov1/var;

 %Calculation of the price of the call option
 PriceControl1=X1+alpha1*(Y-EY);
 repCall=sum(PriceControl1)/(NbTraj)

%Using the control variates technique for the put option
 X2=exp(-r*T)*max(0,K-SPresent);
 EX2=mean(X2);
 Y=SPresent;
 EY=S0*exp(r*T);

 cov2=((X2-EX2)'*(Y-EY))/(NbTraj-1);
 alpha2=-cov2/var;

 %Calculation of the price of the put option
 PriceControl2=X2+alpha2*(Y-EY);
 repPut=sum(PriceControl2)/(NbTraj)

 end