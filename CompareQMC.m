function CompareQMC(NbTraj)
 %Function that computes the volume under surface
 %yz+x^2=1.
 %NbTraj: Number of points to generate.
 a=rand(NbTraj,1);
 b=rand(NbTraj,1);
 c=rand(NbTraj,1);
 disp('Evaluation with MATLAB');
 mean(b.*c+a.*a<1)
 a=Halton(NbTraj,3);
 b=Halton(NbTraj,5);
 c=Halton(NbTraj,7);
 disp('Evaluation with Halton sequence');
 mean(b.*c+a.*a<1)
 a=Faure(NbTraj,1,3);
 b=Faure(NbTraj,2,3);
 c=Faure(NbTraj,3,3);
 disp('Evaluation with Faure sequence');
 mean(b.*c+a.*a<1)
 a=SobolShuffle(NbTraj,1,2,[1;1]);
 b=SobolShuffle(NbTraj,1,3,[1;3;7]);
 c=SobolShuffle(NbTraj,2,3,[1;3;3]);
 disp('Evaluation with Sobol sequence');
 mean(b.*c+a.*a<1)
 Temp=LHS(NbTraj,3);
 a=Temp(:,1);
 b=Temp(:,2);
 c=Temp(:,3);
 disp('Evaluation with latin hypercube sequence');
 mean(b.*c+a.*a<1)
 end
 %Functions that generates Halton sequence elements
 function rep=Halton(nb, b1)
     rep=zeros(nb,1);
     for j=1:nb
         rep(j,1)=VanDerCorput(j,b1);
     end
 end
 %Function that generates elements of Faure sequence
 function rep=Faure(nb, Dim1, b)
     bn=zeros(nb,1);
     for l=1:nb
         a=decompose(l,b);
         m=size(a,1);
         MatTrans=zeros(m,m);
         for j=1:m
             for i=j:m
                 MatTrans(j,i)=nchoosek(i-1,j-1);
             end
         end
         a=mod(MatTrans^(Dim1-1)*a,b);
         for f=1:m
             bn(l,1)=bn(l,1)+a(f,1)/b^(f);
         end
     end
     rep=bn;
     function rep=decompose(n,b)
         temp=1;
         while n~=0
             rep(temp,1)=mod(n,b);
             n=floor(n/b);
             temp=temp+1;
         end
     end
 end
 %Function that generates elements of Sobol sequence
 function rep=SobolShuffle(Nb,Polynomial,Degree,M)
     %Premier pas
     m=1;
     y(1)=1;
     x=zeros(Nb,1);
     x(1,1)=y(1)/2^m;
     %Principal loop
     for n=2:Nb
         Position=Pos(n-1);
         if Position>size(M)
             M=AddM(M,Polynomial,Degree);
         end
         m=ceil(log(n+1)/log(2));
         y(n)=bitxor(2^(m==Position)*y(n-1),2^(m-Position)*M(Position));
         x(n,1)=y(n)/2^m;
     end
     rep=x;
     %Function that finds the position of the
     %rightmost zero in the decomposition
     %of k in basis two
     function rep=Pos(k)
         PosTemp=1;
         while bitand(k,1)==1
             PosTemp=PosTemp+1;
             k=bitshift(k,-1);
         end
         rep=PosTemp;
     end
     %Function that computes a new value for M
     function rep=AddM(M,Polynomial,Degree)
         Length=size(M,1);
         Temp=bitxor(2^(Degree)*M(Length+1-Degree),M(Length+1-Degree));
         i=Degree-1;
         while Polynomial~=0
             Temp=bitxor(Temp,2^(i)*mod(Polynomial,2)*M(Length+1-i));
             Polynomial=bitshift(Polynomial,-1);
             i=i-1;
         end
         rep=[M;Temp];
     end
 end
 %Function that generates element of latin hypercube sequence
 function rep = LHS(N,k)
 Matrix = rand(N,k);
 for j=1:k
     per = randperm(N);
     Matrix(:,j) = (per'-1+Matrix(:,j))/N;
 end
 rep = Matrix;
 end