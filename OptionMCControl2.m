function OptionMCControl2(S0,K,T)
 %Function to calculate the prices of European Put and Call options
 %using Monte Carlo simulations.
 %We use the value of the sensitivity coefficient Delta as control variable.
 %S0: Initial price of the asset
 %K: Exercise price of the options
 %T: Time to maturity of the options

 %Initial parameters
 sigma=0.2;
 r=0.05;
 NbTraj=5000;
 NbPas=100;
 Tau=T;
 DeltaT=T/NbPas;

 %Price vector of the asset
 SPresent=S0*ones(NbTraj,1);
 SNext=zeros(NbTraj,1);

 %Vector of the control variables
 Y1=zeros(NbTraj,1);
 Y2=zeros(NbTraj,1);

 %Loop to simulate the paths of the asset and the control variables
 for i=1:NbPas
    dW=sqrt(DeltaT)*randn(NbTraj,1);
    if i<NbPas
        Tau=Tau-DeltaT;
        d1=(log(SPresent/K)+(r+sigma^2/2)*Tau)/(sigma*sqrt(Tau));
        Y1=Y1+(normcdf(d1)).*SPresent.*dW*sigma;
        Y2=Y2+(normcdf(d1)-1).*SPresent.*dW*sigma;
    end
    SNext=SPresent+(r)*SPresent*DeltaT+sigma*SPresent.*dW;
    SPresent=SNext;
 end

 %Using the control variates technique for the call option
 X1=exp(-r*T)*max(0,SPresent-K);
 EX1=sum(X1)/NbTraj;
 EY1=0;

 cov1=((X1-EX1)'*(Y1-EY1))/(NbTraj-1);
 var1=((Y1-EY1)'*(Y1-EY1))/(NbTraj-1);
 alpha1=-cov1/var1;

 %Calculation of the price of the call option
 PrixControl1=X1+alpha1*(Y1-EY1);
 repCall=sum(PrixControl1)/(NbTraj)

 %Using the control variates technique for the put option
 X2=exp(-r*T)*max(0,K-SPresent);
 EX2=sum(X2)/NbTraj;
 EY2=0;

 cov2=((X2-EX2)'*(Y2-EY2))/(NbTraj-1);
 var2=((Y2-EY2)'*(Y2-EY2))/(NbTraj-1);
 alpha2=-cov2/var2;

 %Calculation of the price of the put option
 PrixControl2=X2+alpha2*(Y2-EY2);
 repPut=sum(PrixControl2)/(NbTraj)

 end