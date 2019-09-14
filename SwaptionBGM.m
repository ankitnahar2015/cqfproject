function AnsBGM=SwaptionBGM
 %Function computing the swaption value from BGM's model

 %Initial parameters
 Strike=0.05;
 NbStep=20;
 DeltaT=0.25;
 %Already specified gamma function
 gamma = [0; 0.0750; 0.0472; 0.0472; 0.1235; 0.1235;
          0.0962; 0.0962; 0.0403; 0.0403; 0.0951; 0.0951;
          0.0702; 0.0702; 0.0702; 0.0702; 0.0515; 0.0515;
          0.0515; 0.0515];

 %Zero coupon bonds prices vector
 P=[1; 0.9830; 0.9652; 0.9464; 0.9271; 0.9076;
     0.8882; 0.8688; 0.8497; 0.8308; 0.8123; 0.7942;
     0.7764; 0.7596; 0.7435; 0.7274; 0.7112; 0.6954;
     0.6797; 0.6644; 0.6491];

 %Vector keeping the forward rates
 L=zeros(NbStep,1);

 %For each step, we computed the forward rate
 for i=1:NbStep
    L(i,1)=(P(i,1)/P(i+1,1)-1)/DeltaT;
 end

 %Vector keeping the values of di
 d=zeros(NbStep,1);
 %For each time steps, we compute the value of di
 for n=1:NbStep
    temp=0;
    for o=1:n
        temp=temp+DeltaT*L(o)/(1+DeltaT*L(o))*gamma(o);
    end
    d(n)=temp;
 end

 %Vector keeping the value of Ck computed
 C=ones(NbStep,1)*Strike*DeltaT;

 %Only the last of Ck is different
 C(NbStep,1)=1+Strike*DeltaT;


 s=fsolve(@spread,0.01);

 
 function ans=spread(s)
 %Function used in the computation of spread. We must find
 %the value of s that cancels the spread.

 %Variable keeping the sum of elements
 temp1=0;
 for k=1:NbStep
    temp2=1;
    for i=1:k
        temp2=temp2*(1+DeltaT*L(i)*exp(gamma(i)*(s+d(i))-gamma(i)^2/2));
    end
    temp1=temp1+C(k)/temp2;
 end

 %Return temp1-1 since we want to find s such that temp1=1.
 ans=temp1-1;

 end
 
 

 %Vector keeping the swaption value at each time steps
 Swaption=zeros(NbStep,1);
 %Swaption's price computation
 for p=1:n
    Swaption(p)=P(p+1)*DeltaT*(L(p)*normcdf(-s-d(p)+gamma(p))-...
                    Strike*normcdf(-s-d(p)));
 end
 %The swap's value in the sum of swaptions
 AnsBGM=sum(Swaption,1);
end
 


