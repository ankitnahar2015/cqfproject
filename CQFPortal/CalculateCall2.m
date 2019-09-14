function Call=CalculateCall2(NbTraj)
 %Function to price a call option
 %NbTraj: Number of generated points to compute the expectation

 x = exp(sqrt(0.1) * randn(1,NbTraj) + 5);
 Call = mean( max(x - 110,0));

 end