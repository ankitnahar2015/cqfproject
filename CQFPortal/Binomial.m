function X=Binomial(NbBinary,p)
 %Function that simulates the binomial variable X

 X=0;
 for n=1:NbBinary
     X=X+(rand<=p);
 end

 end