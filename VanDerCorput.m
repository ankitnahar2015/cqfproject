function rep=VanDerCorput(n,b)
 %Function that computes the elements of the Van Der Corput sequence
 %n: Beginning point to generate the sequence
 %b: Basis of the sequence
 %The n th element in basis b
 bn=0;
 %j represents the powers of b in the decomposition of n
 j=0;

 while n~=0
     bn=bn + mod(n,b)/b^(j+1);
     n=floor(n/b);
     j=j+1;
 end

 rep=bn;
 end