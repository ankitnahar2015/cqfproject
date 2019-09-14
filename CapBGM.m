function AnsBGM=CapBGM
 %Function computing a cap's value from BGM's model.
 %Strike: The strike price.
 Strike=0.03;

 %Initial parameters
 NbStep=20;
 DeltaT=0.25;

 %Specification of a gamma function
 Gamma=[0.00, 0.00; 0.09, 0.12; 0.08, 0.05;
        0.08, 0.05; 0.23, 0.09; 0.23, 0.09;
        0.19, 0.03; 0.19, 0.03; 0.08, 0.01;
        0.08, 0.01; 0.19, 0.01; 0.19, 0.01;
        0.14, -0.01; 0.14, -0.01; 0.14, -0.01;
        0.14, -0.01; 0.09, -0.05; 0.09, -0.05;
        0.09, -0.05; 0.09, -0.05; 0.14, -0.04];

 %Forward rates' specification
 P=[1; 0.9830; 0.9652; 0.9464; 0.9271; 0.9076;
    0.8882; 0.8688; 0.8497; 0.8308; 0.8123; 0.7942;
    0.7764; 0.7596; 0.7435; 0.7274; 0.7112; 0.6954;
    0.6797; 0.6644; 0.6491];

 %Vector keeping the values of L computed.
 L=zeros(NbStep,1);

 %For each time steps, we compute the correspondent value for L
 for i=1:NbStep
    L(i,1)=(P(i,1)/P(i+1,1)-1)/DeltaT;
 end

 %Vector of computed sigma values
 Sigma=zeros(NbStep,1);

 %For each time steps, we compute the value of sigma at this moment
 for k=2:NbStep
    Sigma(k,1)=(Sigma(k-1,1)*(k-2)*DeltaT+norm(Gamma(k,:),2)^2*DeltaT)/...
                    ((k-1)*DeltaT);
 end

 %Vector keeping the values of h computed
 h=zeros(NbStep,1);

 %For each time step, we computed the corresponding values of h
 for j=1:NbStep-1
    h(j,1)=(log(L(j+1,1)/Strike)+0.5*Sigma(j+1,1)*(j*DeltaT))/...
                    sqrt(Sigma(j+1,1)*(j*DeltaT));
 end

 %Vector keeping the caplets' prices at each time t
 Caplet=zeros(NbStep,1);

 %For each time, we compute the corresponding caplet's value
 for l=2:NbStep
    Caplet(l,1)=DeltaT*P(l,1)*(L(l,1)*normcdf(h(l-1,1))-...
                Strike*normcdf(h(l-1,1)-sqrt(Sigma(l,1)*(l-1)*DeltaT)));
 end

 %Cap's value from BGM's model is the sum of caplets' values
 AnsBGM=sum(Caplet,1);

 %For comparison, we present the cap's price computed
 %from Black's model. For this, we must specify
 %a sigma, here it is chosen to be near the
 %average value of sigma computed in BGM's model
 CapletBlack=zeros(NbStep,1);
 sigma=0.15;
 for m=1:NbStep
    d1=(log(L(m,1)/Strike)+sigma^2*DeltaT*m/2)/(sigma*sqrt(m*DeltaT));
    d2=d1-sigma*sqrt(m*DeltaT);
    CapletBlack(m,1)=DeltaT*P(m+1,1)*(L(m,1)*normcdf(d1)-...
                        Strike*normcdf(d2));
 end

 %Black cap's price is equal to the sum of caplets' prices
 AnsBlack=sum(CapletBlack,1)

 end