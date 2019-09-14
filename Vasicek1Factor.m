function Vasicek1Factor
 %Function simulating the term structure using
 %Vasicek model

 %Parameters initial valus for one factor Vasicek model
 alpha=1.3;
 gamma=0.05;
 rho=0.06;
 q=0.1;
 Maturity=3;
 rInit=0.05;
 NbStep=1000;
 DeltaT=Maturity/NbStep;

 %Interest rates simulation
 r=SimulRates(alpha,gamma,rho,q,DeltaT,NbStep,rInit);

 %Parameters of model to rate R.
 RInfinity=RInf(alpha,gamma,rho,q);

 %Vector of time steps
 t=[0:1:NbStep-1]*DeltaT;

 %Computation of rates for the points represented in vector r
 R=RInfinity + ...
    (r-RInfinity).*(1-exp(-alpha*(Maturity-t)))./(alpha*(Maturity-t))+ ...
    rho^2.*((1-exp(-alpha*(Maturity-t))).^2)./(4*alpha^3*(Maturity-t));

 %Graph of the interest rate as function of maturity
 plot([t,Maturity],[R,rInit]);

 end

 function rep=RInf(alpha,gamma,rho,q)
 %Simple function computing parameter R(infinity) of
 %Vasicek model

 rep=gamma+rho*q/alpha-rho^2/(2*alpha^2);

 end

 function rep=SimulRates(alpha,gamma,rho,q,DeltaT,NbStep,rInit)
 %Fonction simulating the interest rates for Vasicek model
 %alpha, gamma, rho, q: Model parameters
 %DeltaT: Time step
 %NbStep: Number of steps
 %rInit: Initial value of interest rate at time t=0.

 %Initialisation of the answer vector
 rep=zeros(1,NbStep);
 rep(1)=rInit;

 %For each step, we simulate the rate following the model
 for i=2:NbStep
     rep(i)=rep(i-1)+alpha*(gamma-rep(i-1))*DeltaT+ ...
             rho*sqrt(DeltaT)*randn(1);
 end

 end