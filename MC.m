function VaR=MC(NbTraj,p,alpha)
 %Function computing the value at risk of a
 %portfolio composed of two bonds.
 %NbTraj: Number of simulations.
 %p: Weight for each bond.
 %alpha: Confidence level
 %Identification of our data file
 fid=fopen('SpotRates.txt','rt');
 %Reading of the data from file SpotRates.txt
 Data=fscanf(fid, '%f %f %f %f %f %f %f %f %f');
 %Closing of source file.
 fclose(fid);
 %Partition of data into date and different rates
 M1=Data(1:9:size(Data));   %spot rate 1 month
 M3=Data(2:9:size(Data));   %spot rate 3 months
 M6=Data(3:9:size(Data));   %spot rate 6 months
 Y1=Data(4:9:size(Data));    %spot rate 1 year
 Y2=Data(5:9:size(Data));    %spot rate 2 years
 Y3=Data(6:9:size(Data));    %spot rate 3 years
 Y5=Data(7:9:size(Data));    %spot rate 5 years
 Y10=Data(8:9:size(Data));  %spot rate 10 years
 Y30=Data(9:9:size(Data));  %spot rate 30 years
 %Matrix of rates
 Data1=[M1,M3,M6,Y1,Y2,Y3,Y5,Y10,Y30];
 %Initial rates
 ActualRates=Data1(size(Data1,1),:);
 %Normalization of rates
 for i=1:9
    Average(i)=mean(Data1(:,i));
    Deviation(i)=std(Data1(:,i));
    Data1(:,i)=(Data1(:,i)-Average(i))/Deviation(i);
 end
 %The standard deviation for a one month period.
 %We want a value at risk for 10 days and we divide by
 %sqrt(3) since 1 month = 3*10 days.
 Deviation=Deviation/sqrt(3);
 %Eigenvectors and eigenvalues of the covariance matrix
 %Vector -Vi can also be returned by function
 %eigs if Vi is an eigenvector.
 [V,E]=eigs(cov(Data1),3);
 %Components determination.
 PC1=V(:,1);
 PC2=V(:,2);
 PC3=V(:,3);
 %Graph of the principal components.
 plot([1:1:9],sqrt(E(1,1))*PC1,'r',[1:1:9],sqrt(E(2,2))*PC2,'b',...
      [1:1:9],sqrt(E(3,3))*PC3,'m');
 Weight1=p;
 Weight2=1-Weight1;
 %Initial parameters
 CouponRate1=0.06;
 FaceValue1=1000;
 CouponRate2=0.08;
 FaceValue2=1000;
 coupon1=CouponRate1*FaceValue1;
 coupon2=CouponRate2*FaceValue2;
 %Vectors for quasi random variables
 u1=zeros(NbTraj,1);
 u2=zeros(NbTraj,1);
 %Simulation of quasi random numbers
 for l=1:NbTraj
    u1(l)=norminv(VanDerCorput(l,3));
    u2(l)=norminv(VanDerCorput(l,5));
 end
 %Spot rates matrix
 Rates=zeros(9,NbTraj);
 %Loop generating the interest rates
 for j=1:NbTraj
    for i=1:9
         %Computation of rates. We multiply by the sign of the first
         %element of the components to fix them positively. This will allow
         %us to replicate perfectly our results if needed.
         Rates(i,j)=ActualRates(1,i)+...
          Deviation(i)*(sqrt(E(1,1))*u1(j,1)*V(i,1)*sign(V(1,1))+...
          sqrt(E(2,2))*u2(j,1)*V(i,2)*sign(V(1,2)));
    end
 end
 %Spot rates initial values
 M6=ActualRates(1,3);   %spot rate 6 months
 Y1=ActualRates(1,4) ;  %spot rate 1 year
 Y2=ActualRates(1,5);   %spot rate 2 years
 Y3=ActualRates(1,6);   %spot rate 3 years
 Y5=ActualRates(1,7);   %spot rate 5 years
 %Linear interpolation
 Y1_5=(Y1+Y2)/2;        %spot rate 1.5 years
 Y2_5=(Y2+Y3)/2;        %spot rate 2.5 years
 Y3_5=(3*Y3+Y5)/4;      %spot rate 3.5 years
 Y4=(Y3+Y5)/2;          %spot rate 4 years
 Y4_5=(3*Y5+Y3)/4;      %spot rate 4.5 years
 %Determination of initial bonds' prices.
 price1=(coupon1/2)/(1+(M6/100))^(1/2)+(coupon1/2)/(1+(Y1/100))^1+...
      (coupon1/2)/(1+(Y1_5/100))^(3/2)+(coupon1/2)/(1+(Y2/100))^2+...
      (FaceValue1+(coupon1/2))/(1+(Y2_5/100))^(5/2);
 price2=(coupon2/2)/(1+(M6/100))^(1/2)+(coupon2/2)/(1+(Y1/100))^1+...
      (coupon2/2)/(1+(Y1_5/100))^(3/2)+(coupon2/2)/(1+(Y2/100))^2+...
      (coupon2/2)/(1+(Y2_5/100))^(5/2)+(coupon2/2)/(1+(Y3/100))^3+...
      (coupon2/2)/(1+(Y3_5/100))^(7/2)+(coupon2/2)/(1+(Y4/100))^4+...
      (coupon2/2)/(1+(Y4_5/100))^(9/2)+...
      (FaceValue2+(coupon2/2))/(1+(Y5/100))^5;
 %Portfolio's initial price.
 InitialPrice=Weight1*price1+Weight2*price2;
 %Loop computing the possible evolution of the portfolio's price.
 for k=1:NbTraj
    M6=Rates(3,k);    %Spot rate 6 months
    Y1=Rates(4,k);    %Spot rate 1 year
    Y2=Rates(5,k);    %Spot rate 2 years
    Y3=Rates(6,k);    %Spot rate 3 years
    Y5=Rates(7,k);    %Spot rate 5 years
    Y1_5=(Y1+Y2)/2;       %Spot rate 1.5 years
    Y2_5=(Y2+Y3)/2;       %Spot rate 2.5 years
    Y3_5=(3*Y3+Y5)/4;     %Spot rate 3.5 years
    Y4=(Y3+Y5)/2;         %Spot rate 4 years
    Y4_5=(3*Y5+Y3)/4;     %Spot rate 4.5 years
    %Valuation of two different bonds
    price1=(coupon1/2)/(1+(M6/100))^(1/2)+(coupon1/2)/(1+(Y1/100))^1+...
          (coupon1/2)/(1+(Y1_5/100))^(3/2)+(coupon1/2)/(1+(Y2/100))^2+...
          (FaceValue1+(coupon1/2))/(1+(Y2_5/100))^(5/2);
    price2=(coupon2/2)/(1+(M6/100))^(1/2)+(coupon2/2)/(1+(Y1/100))^1+...
          (coupon2/2)/(1+(Y1_5/100))^(3/2)+(coupon2/2)/(1+(Y2/100))^2+...
          (coupon2/2)/(1+(Y2_5/100))^(5/2)+(coupon2/2)/(1+(Y3/100))^3+...
          (coupon2/2)/(1+(Y3_5/100))^(7/2)+(coupon2/2)/(1+(Y4/100))^4+...
          (coupon2/2)/(1+(Y4_5/100))^(9/2)+...
          (FaceValue2+(coupon2/2))/(1+(Y5/100))^5;
 %Computation of the portfolio's price for this scenario
 PortfolioPrice=Weight1*price1+Weight2*price2;
 vectPrice(k,1)= PortfolioPrice;
 end
 %Sorting the prices and VaR computation.
 vectPrice=sort(vectPrice);
 VaR=(InitialPrice-vectPrice(floor(alpha/100*NbTraj)));
 end
 function rep=VanDerCorput(n,b)
 %Function generating the Van Der Corput sequence to build Halton sequence.
 %n: Index of the sequence of elements.
 %b: Basis for decomposition.
 bn=0;
 j=0;
 while n~=0
    bn=bn+mod(n,b)/b^(j+1);
    n=floor(n/b);
    j=j+1;
 end
 rep=bn;
 end