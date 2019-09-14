function I=IntegralMC(N)
 %Function to calculate the integral I by the Monte Carlo method
 %N: Number of simulated points to approximate the integral

 X = rand(N,1);
 I = mean(cos(2*pi*X));

 end