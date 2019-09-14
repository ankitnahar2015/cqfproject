function VolDebt = VolatilityDebt(tau,d,V,sigma,r)
 %Function computing the risky debt volatility
 %Tau: Time before maturity.
 %d: Quasi debt ratio.
 %V: Firm's assets initial value.
 %Sigma: Firm's assets volatility.
 %r: Risk free interest rate.

 %Determination of the debt value from initial parameters.
 B = d.*V.*exp(r*tau);

 %Computation of parameters x1.
 x1 = (log(V./B)+(r+sigma.^2/2).*tau)./(sigma.*sqrt(tau));

 %Computation of debt volatility.
 VolDebt = sigma.*normcdf(-x1)./(norm(-x1)+ ...
                         d.*normcdf(x1-sigma.*sqrt(tau)));

 end