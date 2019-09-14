function Graphs
 %Function plotting the credit spread and the debt's volatility
 %as a function of different factors.

 %ta is the vector of time steps where we want to
 %compute the spread and the volatility.
 ta=0.1:.1:3;

 %Initial parameters.
 d0=0.8;
 sigma=0.2;
 V=1;
 r=0.05;

 %Computation of the spread and volatility with d=0.8.
 Rmro=RiskPremium(ta,d0,V,sigma,r);
 SigmaYo=VolatilityDebt(ta,d0,V,sigma,r);

 %Computation of the spread and volatility with d=1.0.
 d0=1;
 Rmr=RiskPremium(ta,d0,V,sigma,r);
 SigmaY=VolatilityDebt(ta,d0,V,sigma,r);

 %Computation of the spread and volatility with d=1.2.
 d0=1.2;
 Rmrs=RiskPremium(ta,d0,V,sigma,r);
 SigmaYs=VolatilityDebt(ta,d0,V,sigma,r);

 %Then we plot the graphs.
 figure 
 hold on
 plot(ta,Rmrs,'k',ta,Rmr,'k--',ta,Rmro,'k*');
 xlabel('Time to maturity');
 ylabel('R-r: Spread');
 legend('d>1', 'd=1','d<1');
 hold off

 figure hold on
 plot(ta,SigmaYs,'k',ta,SigmaY,'k--',ta,SigmaYo,'k*');
 ylabel('\sigma_y: debt''s volatility');
 xlabel('Time to maturity');
 legend('d>1','d=1','d<1');
 hold off

 end