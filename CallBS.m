function rep=CallBS(S0,K,T)
 %Function computing the price of a call option using
 %Black-Scholes analytical formula
 %S0: Initial price of the underlygin asset
 %K: Strike price of the option
 %T: Option's maturity

 %Parameters initial values
 sigma=0.1;
 r=0.06;
 div=0.00; %Dividend rate

 %Computation of di's
 d1=(log(S0/K)+(r-div)*T)/(sigma*sqrt(T))+sigma*sqrt(T)/2;
 d2=d1-sigma*sqrt(T);

 rep=S0*exp(-div*T)*normcdf(d1)-K*exp(-r*T)*normcdf(d2);

 end