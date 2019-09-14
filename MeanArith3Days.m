function rep=MeanArith3Days
 %Function that computes the price of an option written on the mean of
 %the price of an asset. The mean is computed on days
 %75, 80 and 85 and we use brownian bridges to decrease
 %the number of necessary simulations

 %Initial parameter
 NbTraj=10000;
 NbPas=90;
 T=90/360;
 x=100;
 Strike=100;
 Traj=20;
 DeltaT=T/NbPas;

 %Generation of final values of the process
 WT=sqrt(T)*randn(NbTraj,1)+100;

 %Vector to save the arithmetic means
 A=zeros(NbTraj,1);

 for i=1:NbTraj

     %Generation of the increments to build the bridge for WT(i)
     dW=[sqrt((75-0)*DeltaT)*randn(Traj,1),...
              sqrt((80-75)*DeltaT)*randn(Traj,1),...
              sqrt((85-80)*DeltaT)*randn(Traj,1),...
              sqrt((90-85)*DeltaT)*randn(Traj,1)];
     W=cumsum(dW,2);

     %Building of the brownian bridge for all the simulations
     %between x and WT(i)
     B(:,1)=x+W(:,1)-(75*DeltaT)/T*(W(:,4)-WT(i)+x);
     B(:,2)=x+W(:,2)-(80*DeltaT)/T*(W(:,4)-WT(i)+x);
     B(:,3)=x+W(:,3)-(85*DeltaT)/T*(W(:,4)-WT(i)+x);

     %Compute the means for each of the simulations
     TheMean=mean(B,2);

     %Compute the cash flows for each of the simulations
     Payoff=max(0,TheMean-Strike);

     %Compute the mean of the simulation for
     %final value WT(i)
     A(i)=mean(Payoff,1);
 end

 %Return the mean of each scenarios
 rep=mean(A,1);

 end