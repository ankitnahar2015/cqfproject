function Call=CalculateCall(NbTraj)
 %Function to price a call option
 %NbTraj: Number of generated points to compute the expectation

 c = 0;
 for i=1:NbTraj
     x = exp(sqrt(0.1) * randn + 5);
     c = c + max(0,x - 110);
 end
 Call = c/NbTraj;

 end