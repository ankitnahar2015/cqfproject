function Guarantee(NbCoupons,VG,d)
 %Function simulating the guaranteed debt and debt without guarantee
 %for three firms.
 %NbCoupons: Number of coupons of the debts.
 %VG: Initial value of the guarantor.
 %d: Quasi debt ratio initial for all firms.
 %Initial parameters
 T=NbCoupons/2;
 NbSteps=NbCoupons;
 NbTraj=5000;
 DeltaT=T/NbSteps;
 %Cholesky decomposition.
 MatrixL=CreateMatrixChol(DeltaT);
 %Vectors keeping information on different
 %debts for computing the mean on all trajectories.
 DebtNoGuaranteeMean=zeros(3,1);
 DebtGuaranteeMean=zeros(3,1);
 DebtNonRiskyMean=zeros(3,1);
 %Vectors keeping information on total loss
 %expected and credit insurance.
 Es=zeros(NbTraj,1);
 Ci=zeros(NbTraj,1);
 %For each trajectories we compute the debts' values
 for j=1:NbTraj
     %We initialize to 0 the information vectors
     [r,V,Sigma,sigmaGuarant,Default,ValueDefault,...
     ValueDefaultGuarant,RateBeforeDefault,RateAfterDefault,...
     ValueDebt,ValuePaid,DebtNoGuarantee,DebtGuarantee]=InitializeToZero;
     %Simulation of brownian motion, interest rate and variance.
     dW=GenerateVariable(MatrixL,NbSteps);
     r=SimulationRates(dW,r,NbSteps,DeltaT);
     Sigma=SimulationSigma(dW,Sigma,NbSteps,DeltaT);
     %Computation of debts' value by discounting
     Debt=V*d*exp(sum(r)*DeltaT);
     %Computation of the guarantor allocated to each debt.
     alpha=ComputeAlpha(Debt);
     %Coupon rate of debts.
     Coupon=[5;5;5];
     %Initialization of the guarantor's value.
     Guarant=VG;
     %Computation of the risk free debt
     DebtNonRisky=ComputeDebtNonRisky(r,Coupon,Debt,DeltaT, ...
                                               NbSteps);
     %Addition of non risky debt to computation of the mean
     DebtNonRiskyMean=DebtNonRiskyMean+DebtNonRisky;
     %For each step, we simulate firms' defaults and store information.
     for i=1:NbSteps-1
         %Vector storing the discounting rate from time 0 until default.
         RateBeforeDefault=RateBeforeDefault+DeltaT*r(1,i) ...
                                                 *(ones(3,1)-Default);
         %Simulation of firms and guarantor's value
         V = max(V.*(1+r(1,i)*DeltaT + Sigma(1:3,i).*dW(1:3,i)),0);
         Guarant=Guarant*(1+r(1,i)*DeltaT+Sigma(4,i)*dW(4,i));
         %Temp keeps in memory firms defaulting at time
         Temp=(V<Coupon).*(1-Default);
         %Vector keeping in memory the firm's value at default time
         ValueDefault=ValueDefault+Temp.*V;
         %Vector keeping the guarantor's value when a firm defaults
         ValueDefaultGuarant=ValueDefaultGuarant+alpha.*Guarant.*Temp;
         %Vector keeping in memory which firm defaulted since time 0.
         Default=Default|Temp;
         %Vector keeping the value of remaining debt a time of default.
         ValueDebt=ValueDebt+Temp.*ComputeValueDebt(i,NbSteps,r, ...
                                            Debt,Coupon,Temp.*V,DeltaT);
         %Vector keeping the value paid by guarantor when a default occurs.
         ValuePaid=ValuePaid+min(Guarant*alpha, ValueDebt).*Temp;
         %Amount paid are deducted from the guarantor assets's value
         Guarant=Guarant-sum(ValuePaid.*Temp);
         %Computation of debt without guarantee
         DebtNoGuarantee = DebtNoGuarantee + ...
             exp(-RateBeforeDefault).*min(Coupon,V).*(1-Default+Temp);
         %Initialization of debt of the firms in default
         Debt=Debt-Debt.*Temp;
         %Computation of new alpha
         alpha=ComputeAlpha(Debt);
         %Computation of firms values when paying coupon.
         V=V-min(Coupon,V);
     end
     %For the last step, we make computation outside principal loop.
     RateBeforeDefault=RateBeforeDefault+ ...
              DeltaT*r(1,NbSteps)*(ones(3,1)-Default);
     V = max(0,V.*(1+r(1,NbSteps)*DeltaT + Sigma(1:3,NbSteps).*dW(1:3,NbSteps)));
     Guarant=Guarant*(1+r(1,NbSteps)*DeltaT+Sigma(4,NbSteps)*dW(4,NbSteps));
     Temp=(V<Coupon+Debt).*(1-Default);
     ValueDefault=ValueDefault+Temp.*V;
     ValueDefaultGuarant=ValueDefaultGuarant+Guarant.*Temp;
     Default=Default|Temp;
     DebtNoGuarantee = DebtNoGuarantee + ...
      exp(-RateBeforeDefault).*min(Coupon+Debt,V).*(1-Default+Temp);
     ValueDebt=ValueDebt+Temp.*(Coupon+Debt-V);
     ValuePaid=ValuePaid+min(Guarant*alpha, ValueDebt).*Temp;
     %Computation of guaranteed debt's value
     DebtGuarantee=DebtGuarantee+exp(-RateBeforeDefault).*ValuePaid;
     %Deducting the amounts paid from the firms' values
     V=V-min(Coupon+Debt,V);
     %Computation of expected loss and credit insurance.
     Es(j) = sum(DebtNonRisky-DebtNoGuarantee)/sum(DebtNonRisky);
     Ci(j) = sum(DebtGuarantee)/sum(DebtNonRisky);
     %Addition of the debt guarantee and debt non guarantee for the mean.
     DebtNoGuaranteeMean=DebtNoGuaranteeMean+DebtNoGuarantee;
     DebtGuaranteeMean=DebtGuaranteeMean+DebtGuarantee;
 end
 %Computation of expected loss and credit insurance for computing the mean.
 EsMoy=mean(Es)
 CiMoy=mean(Ci)
 end

 function MatrixL=CreateMatrixChol(DeltaT)
 %Function computing Cholesky decomposition of the covariance matrix.
     %Correlations
     Rho12=0.1; Rho13=0.5; Rho23=-0.3;
     Rho1G=0.2; Rho2G=0.2; Rho3G=0.2;
     Rho1r=0.1; Rho2r=0.1; Rho3r=0.1;
     RhoGr=0.1;
     %Construction of the covariance matrix
     MatrixCov=DeltaT*[1,Rho12,Rho13,Rho1G, Rho1r, 0, 0, 0, 0;
         Rho12,1,Rho23, Rho2G, Rho2r, 0, 0, 0, 0;
         Rho13,Rho23,1,Rho3G, Rho3r, 0, 0, 0, 0;
         Rho1G, Rho2G, Rho3G, 1, RhoGr, 0, 0, 0, 0;
         Rho1r, Rho2r, Rho3r, RhoGr, 1, 0, 0, 0, 0;
         0,0,0,0,0,1,0,0,0;
         0,0,0,0,0,0,1,0,0;
         0,0,0,0,0,0,0,1,0;
         0,0,0,0,0,0,0,0,1];
     %Cholesky decomposition
     MatrixL=chol(MatrixCov)';
 end

 function dW=GenerateVariable(MatrixL,NbSteps)
 %Function generating brownian motions.
 %MatrixL: Cholesky decomposition matrix
 %NbSteps: Number of time steps.
        dW=MatrixL*randn(9,NbSteps);
 end

 function  r=SimulationRates(dW,r0, NbSteps,DeltaT);
 %Function simulating the interest rate.
 %dW: Brownian motion
 %r0: Interest rate at time t=0.
 %NbSteps: Number of time steps.
 %DeltaT
     r=zeros(1,NbSteps);
     r(1,1)=r0;
     %Simulation of interest rate avoiding negative rates.
     for j=1:NbSteps-1
         r(1,j+1)=max(r(1,j)+0.02*(0.05-r(1,j))*DeltaT+ ...
                                   0.2*r(1,j)^(0.5)*dW(5,j),0);
     end
 end

 function Sigma=SimulationSigma(dW,Sigma0,NbSteps,DeltaT)
 %Function simulating the firms' volatilities.
 %dW: Brownian motions
 %Sigma0: Initial volatility
 %NbSteps: Number of time steps
 %DeltaT
     %Parameters
     nu=0.5;
     beta=Sigma0.^2;
     phi=0.15;
     rho=0.1;
     Sigma=zeros(4,NbSteps);
     Sigma(:,1)=Sigma0;
     %Simulation of volatilities avoiding negative volatilities.
     for j=1:NbSteps-1
         Sigma(:,j+1)=(max(0,Sigma(:,j).^2+nu*(beta- ...
                    Sigma(:,j).^2)*DeltaT+ ...
                    phi*Sigma(:,j).*(rho*dW(1:4,j)+ ...
                    (1-rho)^0.5*dW(6:9,j)))).^0.5;
     end
 end

 function Alpha=ComputeAlpha(Debt)
 %Function computing the guarantor's proportion allocated to each debt
 %Debt: Remaining debts vector.
     %Computation of alpha avoiding dividing by zero.
     if sum(Debt,1)~=0
         Alpha=Debt/(sum(Debt,1));
     else
         Alpha=0*Debt;
     end
 end
 function ValueDebt=ComputeValueDebt(i,NbSteps,r,Debt,Coupon,V, ...
                                              DeltaT);
 %Function computing the debt's value and remaining debt when there is
 %default before maturity.
 %i: Time of default
 %NbSteps: Number of time steps
 %r: Risk free interest rate
 %Debt: Firms debts' values
 %Coupon: Each debt coupon
 %V: Firms' values
 %DeltaT
     %The remaining debt comprises the coupon's unpaid part
     ValueDebt=Coupon-V;
     %Addition of coupons that would have been paid if there were no default.
     for j=i+1:NbSteps-1
         ValueDebt=ValueDebt+exp(-sum(r(i+1:j))*DeltaT)*Coupon;
     end
     %Addition of last payment comprises the facial value.
     ValueDebt=ValueDebt+exp(-sum(r(i+1:NbSteps))*DeltaT)*(Coupon+Debt);
 end
 function DebtNonRisky=ComputeDebtNonRisky(r,Coupon,Debt, ...
                                                      DeltaT,NbSteps)
 %Function computing the debts' value it they were risk free.
 %r: Interest rate
 %Coupon: Coupon rate
 %Debt: Face values of debts.
 %DeltaT
 %NbSteps: Number of time steps.
 %Initialization of the risk free debt.
 DebtNonRisky=zeros(3,1);
 %For each coupon, we discount at risk free rate.
 for j=1:NbSteps-1
     DebtNonRisky=DebtNonRisky+exp(-sum(r(1:j))*DeltaT)*Coupon;
 end
 %Addition of last coupon and face value of debt.
 DebtNonRisky=DebtNonRisky+ ...
                            exp(-sum(r(1:NbSteps))*DeltaT)*(Coupon+Debt);
 end
 function [r,V,Sigma,sigmaGuarant,Default,ValueDefault,...
   ValueDefaultGuarant,RateBeforeDefault,RateAfterDefault,...
   ValueDebt,ValuePaid,ValueNoGuarantee,DebtGuarantee]=InitializeToZero
 %Function initializing parameters and vectors to their initial values.
     r=0.05;
     V=[50;50;50];
     Sigma=[0.2;0.3;0.5;0.25];
     sigmaGuarant=0.25;
     Default=zeros(3,1);
     ValueDefault=zeros(3,1);
     ValueDefaultGuarant=zeros(3,1);
     RateBeforeDefault=zeros(3,1);
     RateAfterDefault=zeros(3,1);
     ValueDebt=zeros(3,1);
     ValuePaid=zeros(3,1);
     ValueNoGuarantee=zeros(3,1);
     DebtGuarantee=zeros(3,1);
 end