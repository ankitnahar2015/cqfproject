function ComputeExpectation(NbTraj)
 %Function that computes the expectation using Halton sequence
 %in dimension 3
 %NbTraj: Number of points to generate
 %Transformation of the uniform variables into normal variables
 S=norminv([Faure(NbTraj,2,3),Faure(NbTraj,3,5),...
                 Faure(NbTraj,4,5)]);
 %Computation of cash flows given by the function maximum
 Payoff=zeros(NbTraj,1);
 for l=1:NbTraj
     temp=max(max(exp(S(l,1))-1,0),max(exp(S(l,2))-0.8,0));
     Payoff(l)=max(temp,max(exp(S(l,3))-1.3,0));
 end
 disp('Mean');
 disp(mean(Payoff));
 disp('Standard error');
 disp(std(Payoff)/sqrt(NbTraj));
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
     a=mod(MatTrans^Dim1*a,b);
     for f=1:m
         bn(l,1)=bn(l,1)+a(f,1)/b^(f);
     end
 end
 rep=bn(:,1);
 end
 %Decomposition of n in basis b
 function rep=decompose(n,b)
 temp=1;
 while n~=0
     rep(temp,1)=mod(n,b);
     n=floor(n/b);
     temp=temp+1;
 end
 end