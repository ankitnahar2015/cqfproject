function RiskPremium=RiskPremium(tau,d,V,sigma,r)
 %Function computing the risk premium for a risky bond
 %Tau: Time to maturity.
 %d: Quasi debt ratio.
 %V: Initial value of the firm's assets.
 %Sigma: Volatility of the firm's assets.
 %r: Risk free interest rate.

 %Computing debt with given parameters.
 B = d.*V.*exp(r*tau);

 %Computation of parameter x1.
 x1 = (log(V./B)+(r+sigma.^2/2).*tau)./(sigma.*sqrt(tau));

 %Computation of risk premium.
 RiskPremium = -(1./tau).*log(normcdf(x1-sigma.*sqrt(tau))+ ...
                 (1./d).*normcdf(-x1));

 end