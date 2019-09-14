function X=Binomial2(NbBinary,p)
 %Function that simulate the binomial variable X

 X=sum(rand(1,NbBinary)<=p);

 end