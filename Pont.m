function rep=Pont(NbTraj,NbPas,T,x,y)
 %Function that generates many brownian bridges
 %NbTraj: Number of bridges to generate
 %NbPas: Number of steps in each bridge
 %T: Period on which the bridge is generated
 %x: Starting point of the bridge
 %y: Final point of the bridge

 DeltaT=T/NbPas;

 %Generation of the increments and bridges
 dW=[zeros(NbTraj,1),sqrt(DeltaT)*randn(NbTraj,NbPas)];
 W=cumsum(dW,2);
 Inc=[zeros(NbTraj,1),...
            repmat(DeltaT/T*(y-x-W(:,NbPas+1)),1,NbPas)];
 rep=W+x+cumsum(Inc,2);

 %Graphs of the bridges
 figure
 plot([0:DeltaT:1],rep)

 end