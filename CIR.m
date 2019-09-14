function CIR
 %Function simulating the term structure from model CIR

 %Parameters' initial values
 Theta = 0.05;
 Kappa = 1.3;
 Sigma = 0.2;
 T=3;
 NbSteps = 156;
 DeltaT = T / NbSteps;
 rInit = 0.05;
 Lambda = 0.3;
 Gamma = sqrt((Kappa+Lambda)^2+2*Sigma^2);
 t=0;
 r=rInit;

 %Definition of vector R to keep the simulation's results
 R = zeros(NbSteps,1);

 %For each step, we simulate the term structure for time t
 for i=1:NbSteps

    %Computation of numerators and denominators in formula of A and B
    Temp1=(Gamma+Kappa+Lambda)*(exp(Gamma*(T-t))-1)+2*Gamma;
    Temp2=2*Gamma*exp((Gamma+Kappa+Lambda)*(T-t)/2);
    Temp3=2*(exp(Gamma*(T-t))-1);

    %Computation of A and B
    A = (Temp2/Temp1)^(2*Kappa*Theta/Sigma^2);
    B = Temp3/Temp1;

    %Rates' simulation
    r = r + Kappa*(Theta-r)*DeltaT + Sigma*sqrt(r)*sqrt(DeltaT)*randn(1);

    %Term structure computation at this time
    R(i,1) = (r*B-log(A))/(T-t);
    t=t+DeltaT;
 end

 %Graph of the term structure
 plot([DeltaT:DeltaT:T], R);

 end