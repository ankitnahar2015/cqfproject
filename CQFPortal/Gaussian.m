function Gaussian(NbTraj)
 %Function that compares the different methods of generating a gaussian
 %NbTraj must be a even number

 %Method 1
 A = sum(rand(NbTraj,12),2) - 6;
 MeanA = mean(A,1);
 StdA = std(A);
 sprintf('Method 1 \n Mean: %g, Standard deviation: %g', MeanA, StdA)

 %Method 2
 U1 = rand(1,NbTraj/2);
 U2 = rand(1,NbTraj/2);
 B1 = sqrt(-2*log(U1)).*cos(2*pi*U2);
 B2 = sqrt(-2*log(U1)).*sin(2*pi*U2);
 B = [B1,B2]';
 MeanB = mean(B);
 StdB = std(B);
 sprintf('Method 2 \n Mean: %g, Standard deviation: %g', MeanB, StdB)

 %Method 3
 C = randn(NbTraj,1);
 MeanC = mean(C);
 StdC = std(C);
 sprintf('Method 3 \n Mean: %g, Standard deviation: %g', MeanC, StdC)
 end