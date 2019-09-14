function SSA
 %Function to calculate the price of an American option
 %underwritten on 3 underlying assets and
 %using the dynamic programming technique of Barraquand and Martineau.
 %T: Maturity
 T=1/12;
 %Strike: Exercise price
 Strike=35;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Initial parameters %%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 k=100;                 %Number of cells
 NbTraj=100000;         %Number of paths
 NbStep=10;              %Number of time steps
 n=3;                   %Number of underlying assets
 mu=ones(n,1)*0.00;     %Dividend yield on the underlying assets
 r=0.05;                %Risk-free rate
 DeltaT=T/NbStep;        %Time step
 sqDeltaT=sqrt(DeltaT);

 %The vector partition keeps in memory the cell containing the asset
 %The first column indicates the cell at time t and
 %the second column indicates the cell at time t+1.
 %partition is initialized as a vector of un, meaning that
 %the 3 underlying assets start in cell P1(0).
 partition=[ones(NbTraj,1),zeros(NbTraj,1)];

 %The vector payoff stores the cash flows if the option is exercised.
 payoff=zeros(NbTraj,1);

 %The vectors a, b and gamma represent the parameters of the
 %Barraquand and Martineau technique, we need to calculate them.
 a=zeros(k,NbStep);
 b=zeros(k,k,NbStep);
 gamma=zeros(k,NbStep);

 v=diag([0.2,0.3,0.5]);     %Matrix of the standard deviations
 kappa=v*(v');              %variance-covariance matrix
                            %(independent assets)

 %x0 is the vector of initial values of the assets
 %(40 is the initial value)
 x0=40*ones(NbTraj,n);

 %x1 is the vector of the assets values at time t and x2 at time t+1
 x1=x0;
 x2=zeros(NbTraj,n);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the initialization %%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Calculation of a, b and gamma for the time t=0%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %a_1(0) = M, the others are zero since there is only one cell
 aInit=NbTraj;
 %Calculation of gamma_1(0) alone since a_1(0) is the only non null element
 gammaInit=exp(-r*DeltaT)*sum(Payoff(x1,NbTraj,Strike,DeltaT,r));
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the calculation of a, b and gamma for t=0%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Loop for each time step%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for cptStep=1:NbStep

     %Calculation of x2 by simulating one time step
     x2=NextStep(x1,kappa,v,sqDeltaT,DeltaT,mu,NbTraj,n,r);

     %Calculation of the cash flows if the option is exercised immediately
     payoff=Payoff(x2,NbTraj,Strike,DeltaT,r);

     %Determination of the partition and classification of the paths
     %with respect to the cash flows
     partition(:,2)=Partition(payoff,NbTraj,k);

     %Calculation of the values of a, b and c to determine the probabilities
     [a(:,cptStep),b(:,:,cptStep),gamma(:,cptStep)]=...
                            Prob(partition,NbTraj,k,payoff,r,DeltaT);

     %The new partition and the x2 become the old
     %partition and the old x for the next time step
     partition(:,1)=partition(:,2);
     x1=x2;

 end

 %Initialization of the Ci
 C1=zeros(k,1);
 C2=zeros(k,1);

 %We initialize C2 and avoid the division by zero
 C2=gamma(:,NbStep)./max(1,a(:,NbStep));

 %Loop starting at the maturity and proceeding backward by the time step
 for cptStep=1:NbStep-1

     %Calculation of C1 and no division by zero
     C1=max(gamma(:,NbStep-cptStep),b(:,:,NbStep-cptStep+1)*C2)./...
             max(1,a(:,NbStep-cptStep));

     %The new C1 becomes the old C2 coming back by one step
     C2=C1;

 end

 %Calculation of the option price
 Prix=max(gammaInit,b(:,:,1)*C2)/aInit;
 cssap=Prix(1)

 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the main program%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Function to simulate the one time step %%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function x2=NextStep(x1,kappa,v,sqDeltaT,DeltaT,mu,NbTraj,n,r)
 %x1: Values of the assets at time t
 %kappa: Variance-covariance matrix
 %v: Matrix of the standard deviation
 %spDeltaT: Square root of DeltaT
 %DeltaT: Time step
 %mu: Dividend yield
 %NbTraj: Number of simulated paths
 %n: Number of underlying assets
 %r: Risk-free rate
 %x2: Values of assets at time t+1

     %Initialization of x2
     x2=zeros(NbTraj,n);

     %Loop to simulate the assets prices at time t+1.
     for cptTraj=1:NbTraj
         x2(cptTraj,:)= SimUnderly(x1(cptTraj,:),kappa,v,sqDeltaT, ...
                                   DeltaT,mu,n,r);
     end

 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the simulation%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Function to simulate the underlying assets%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function x2=SimUnderly(x1,kappa,v,sqDeltaT,DeltaT,mu,n,r)
 %Same parameters as the previous function but for the paths

     z=randn(n,1);
     temp=v*sqDeltaT*z;

     %Initialization of x2 and simulation for each underlying asset
     x2=zeros(1,n);
     for cptUnderly=1:n
         x2(1,cptUnderly)=x1(1,cptUnderly)*exp((r-mu(cptUnderly,1)-...
          kappa(cptUnderly,cptUnderly)/2)*DeltaT + temp(cptUnderly,1));
     end

 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the simulation of the underlying assets%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Function to calculate the payoffs%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function payoff=Payoff(x2,NbTraj,strike,DeltaT,r)
 %x2: Values of the assets
 %NbTraj: Number of paths
 %Strike: Exercise price
 %DeltaT
 %r: Risk-free rate

     payoff=zeros(NbTraj,1);

     %For each path, we calculate the payoff is the option is exercised
     for cptTraj=1:NbTraj
         payoff(cptTraj,1)=exp(-r*DeltaT)*max(0,max(x2(cptTraj,:))-strike);
     end

 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the payoffs calculations%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Function to classify the paths%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function partition=Partition(payoff,NbTraj,k)
 %Function determining the partitioning of the cells and
 %classify the path in the partition it belongs
 %payoff: Vector of cash flows if the option is exercised immediately
 %NbTraj: Number of paths
 %k: Number of cells

     partition=zeros(NbTraj,1);

     %Ordering the payoffs to obtain the distribution
     temp=sort(payoff);

     %Keep only the non null elements
     tempNonZero=nonzeros(temp);

     %Calculation of the factor A to classify the payoffs
     %(take the 0.1 percentile)
     %The function max is used to avoid a zero
     A=tempNonZero(max(1,floor(0.001*size(tempNonZero,1))));

     %Inscription of the number 1 for the paths in the first cell
     partition=partition+1*(payoff<=A);

     %Determination of the factor B to classify the payoffs
     %(take the 99.9 percentile)
     B=log(temp(floor(0.999*NbTraj)-1)/A)/(k-2);

     %Inscription of the number k for the paths in the last cell
     partition=partition+k*(payoff>A*exp(B*(k-2)));

     %Inscription of the appropriate number for the other paths
     %by checking all the possible cells
     for cptPartition=2:k-1
         partition = partition + ...
             cptPartition*(payoff>A*exp(B*(cptPartition-2))).* ...
                            (payoff<=A*exp(B*(cptPartition-1)));
     end

 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the classification of the paths%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Function to calculate the probabilities a,b,gamma%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function [a,b,gamma]=Prob(partition,NbTraj,k,payoff,r,DeltaT)
 %partition: Table indicating in which cell is located
 %          the paths at time t and t+1
 %NbTraj: Number of paths
 %k: Number of cells
 %payoff: Vector the cash flows if the option is exercised
 %r: Risk-free rate
 %DeltaT
 %a, b and gamma: The numbers used to calculate the probabilities
 %                 to move from one cell to another

     %Initialization of a, b and gamma
     a=zeros(k,1);
     b=zeros(k,k);
     gamma=zeros(k,1);

     %Discounting factor computed once
     act=exp(-r*DeltaT);

     %All the paths and incrementing the counters
     %a, b and gamma highlighted.
     for cptTraj=1:NbTraj
         a(partition(cptTraj,2),1)=a(partition(cptTraj,2),1)+1;
         b(partition(cptTraj,1),partition(cptTraj,2))=...
              b(partition(cptTraj,1),partition(cptTraj,2))+act;
         gamma(partition(cptTraj,2),1)=gamma(partition(cptTraj,2),1)+ ...
                                        act*payoff(cptTraj,1);
     end

 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %End of the calculation of the probabilities %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%