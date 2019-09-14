function Rep=Binomial(N,u,d,r,S0,Strike,T)
 %Function using binomial trees in order to compute
 %a call option's value.
 %N: Number of periods
 %u: Increasing rate
 %d: Decreasing rate
 %r: Risk free interest rate
 %S0: Stock's initial value
 %Strike: Option's strike price
 %T: Maturity

 %Computation of the interest rate per period
 InterestRate=(1+r)^(T/N)-1;

 %Probability of a up movement
 p=(InterestRate-d)/(u-d);

 a=ceil(log(Strike/(S0*(1+d)^N))/(log((1+u)/(1+d))));

 %Computation of expected payoffs at maturity
 ExpectedPayoffs=0;
 for j=a:N
    inc=nchoosek(N,j)*p^(j)*(1-p)^(N-j)*((1+u)^(j)*...
                        (1+d)^(N-j)*S0-Strike);
    ExpectedPayoffs=ExpectedPayoffs+inc;
 end

 Rep=ExpectedPayoffs/(1+InterestRate)^N;

 end