function Greeks2
 %Function computing the coefficients Theta, Rho
 %and sensitivity to the strike price for a put option

 %Parameters' initial values
 r=0.03;
 Strike=50;
 S0=60;
 sigma=0.375;
 T=4/12;

 %Computation of di's
 d1=(log(S0/Strike)+(r+sigma^2/2)*T)/(sigma*sqrt(T));
 d2=d1-sigma*sqrt(T);

 %Computation of the sensitivity coefficients
 dK=-exp(-r*T)*normcdf(d2)
 Theta=S0*sigma/(2*sqrt(T))*normpdf(d1)+Strike*exp(-r*T)*normcdf(d2)
 Rho=T*Strike*exp(-r*T)*normcdf(d2)

 end