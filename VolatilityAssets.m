function VolAssets = VolatilityAssets(y)
 %Function used in solving the non linear equation to
 %estimate the volatility and firm's assets value.
 %y(1,1): Assets' value.
 %y(2,1): Assets' volatility.

 %Extraction to input parameters
 V = y(1,1);
 sigmaV = y(2,1);

 %Initial parameters
 E = 100;
 sigmaE = 0.3;
 r = 0.03;
 B = 60;
 tau = 1;

 %Computation of parameters x.
 x = (log(V/B)+(r+sigmaV^2/2)*tau)/(sigmaV*sqrt(tau));

 %Determination of outputs.
 VolAssets(1,1) = E-V*normcdf(x)+B*exp(-r*tau)* ...
                         normcdf(x-sigmaV*sqrt(tau));
 VolAssets(2,1) = sigmaV-sigmaE*E/(V*normcdf(x));

 end