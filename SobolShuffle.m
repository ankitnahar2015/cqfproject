function rep=SobolShuffle(Nb)
 %Function that generates points of Sobol sequence
 %Nb: Number of point to simulate
 Polynomial=1; %Choice of a polynomial
 Degree=2; %Degree of chosen polynomial
 M=[1;1]; %Initial values of the M_i's
 %First step
 m=1;
 y(1)=1;
 x(1)=y(1)/2^m;
 %Principal loop for elements 2 and above
 for n=2:Nb
     Position=Pos(n-1);
     %Add an element to vector M
     if Position>size(M)
         M=AddM(M,Polynomial,Degree);
     end
     m=ceil(log(n+1)/log(2));
     y(n)=bitxor(2^(m==Position)*y(n-1),...
                    2^(m-Position)*M(Position));
     x(n)=y(n)/2^m;
 end
 rep=x;
 end

 %Function determining position of rightmost
 %zero in the decomposition in basis 2 of k
 function rep=Pos(k)
 %k: Number to decompose
 PosTemp=1;
 while bitand(k,1)==1
     PosTemp=PosTemp+1;
     k=bitshift(k,-1);
 end
 rep=PosTemp;
 end

 %Function that computes a new value M
 function rep=AddM(M,Polynomial,Degree)
 %M: actual vector
 %Polynomial: Primitive polynomial
 %Degree: Degree of the chosen polynomial (from table)
 Length=size(M,1);
 Temp=bitxor(2^(Degree)*M(Length+1-Degree),...
                M(Length+1-Degree));
 i=Degree-1;
 while Polynomial~=0
    Temp=bitxor(Temp,2^(i)*mod(Polynomial,2)*M(Length+1-i));
    Polynomial=bitshift(Polynomial,-1);
    i=i-1;
 end
 rep=[M;Temp];
 end