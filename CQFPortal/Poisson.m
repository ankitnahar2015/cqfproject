function X=Poisson(lambda)
 %Function that generates a Poisson variable X

 X=0;
 U=rand;
 while (U>exp(-lambda))
     X=X+1;
     U=U*rand;
 end

 end