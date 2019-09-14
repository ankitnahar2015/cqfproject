function Faure(nb, Dim1, b)
 %Function that generates Faure sequence elements
 %nb: Number of elements to generate
 %Dim1: First dimension of the random points
 %          we plot this dimension and the following.
 %b: Basis

 bn=zeros(nb,2);

 for l=1:nb
     %We decompose l in basis b
     a=decompose(l,b);
     m=size(a,1);

     %Transition matrix between dimensions
     MatTrans=zeros(m,m);
     for j=1:m
         for i=j:m
             MatTrans(j,i)=nchoosek(i-1,j-1);
         end
     end

     %Computation of vector a and for next iteration
     a=mod(MatTrans^(Dim1-1)*a,b);
     aplus1=mod(MatTrans*a,b);

     %Computations of points bn
     for f=1:m
         bn(l,1)=bn(l,1)+a(f,1)/b^(f);
         bn(l,2)=bn(l,2)+aplus1(f,1)/b^(f);
     end
 end

 %We plot the points we got
 figure
 plot(bn(:,1),bn(:,2),'.')
 end

 %Function that decomposes a number in the given basis
 function rep=decompose(n,b)
 %n: Number to decompose
 %b: Basis of the decomposition

 temp=1;
 while n~=0
     rep(temp,1)=mod(n,b);
     n=floor(n/b);
     temp=temp+1;
 end
 end