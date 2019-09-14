function rep=MeanPremium
 %Function computing the average insurance premium in the case
 %of a guarantor and three firms.

 %Initial parameters
 T=1;
 NbStep=52;
 NbTraj=100000;
 r=0.05;
 mu=r;              %Instantaneous rate of return for firms
 DeltaT=T/NbStep;

 %Initial values for the firms
 V1=30*ones(NbTraj,1);
 V2=40*ones(NbTraj,1);
 V3=50*ones(NbTraj,1);

 %Initial value of guarantor
 VG=80*ones(NbTraj,1);

 %Covariance matrix construction
 Rho12=0.1;
 Rho13=0.5;
 Rho23=-0.3;
 sigma1=0.2;
 sigma2=0.3;
 sigma3=0.5;
 sigmaG=0.25;
 MatrixCov=DeltaT*[1,Rho12,Rho13,0;Rho12,1,Rho23,0;Rho13,Rho23,1,0; ...
                    0,0,0,1];
 MatrixL=chol(MatrixCov)';

 %Face values of the firms' debts
 Debt1=20;
 Debt2=30;
 Debt3=30;

 %Vector of theoretical means of the brownian motions.
 MatrixMean=zeros(4,1);

 %For each step, we simulate the firms's prices and the guarantor's value.
 for i=1:NbStep

    %Use of the quadratic resampling technique.
    Temp=MatrixL*randn(4,NbTraj);
    dW=ReQuadratic(Temp,MatrixMean,MatrixCov)';

    V1=V1.*(1+mu*DeltaT*ones(NbTraj,1)+sigma1*dW(:,1));
    V2=V2.*(1+mu*DeltaT*ones(NbTraj,1)+sigma2*dW(:,2));
    V3=V3.*(1+mu*DeltaT*ones(NbTraj,1)+sigma3*dW(:,3));
    VG=VG.*(1+mu*DeltaT*ones(NbTraj,1)+sigmaG*dW(:,4));

 end

 %Sum of losses divided by the total of debts.
 LossPayOff=(max(0,Debt1-V1)+max(0,Debt2-V2)+max(0,Debt3-V3))/ ...
                                                 (Debt1+Debt2+Debt3);
 %Discounting
 Premium=exp(-r*T)*mean(LossPayOff,1);

 rep=Premium;

 end