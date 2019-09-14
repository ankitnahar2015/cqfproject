function rep=PutBS(S0,K,T)
 %Function computing the price of a put option using
 %Black-Scholes analytical formula
 %S0: Underlying asset initial price
 %K: Option's strike price
 %T: Option's maturity

 %Parameters initial values
 sigma=0.2;
 r=0.05;
 div=0.00; %Dividend rate

 %Computation of di's
 d1=(log(S0/K)+(r-div)*T)/(sigma*sqrt(T))+sigma*sqrt(T)/2;
 d2=d1-sigma*sqrt(T);

 rep=K*exp(-r*T)*normcdf(-d2)-S0*exp(-div*T)*normcdf(-d1);

 end