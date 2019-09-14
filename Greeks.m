function Greeks
 %Function computing the sensitivity coefficients for
 %a call option

 %Parameters's initial values
 r=0.03;
 Strike=50;
 S0=60;
 sigma=0.375;
 T=4/12;

 %Computation of di's
 d1=(log(S0/Strike)+(r+sigma^2/2)*T)/(sigma*sqrt(T));
 d2=d1-sigma*sqrt(T);

 %Computation of the coefficients
 Delta=normcdf(d1)
 Vega=S0*sqrt(T)*normpdf(d1)
 Gamma=normpdf(d1)/(S0*sigma*sqrt(T))

 end