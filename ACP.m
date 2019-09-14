function ACP
 %Function extracting the principal components.
 %Empirical data (can be imported from a external file).
 Rates= [1.25, 1.75, 2.26, 3.19;
 1.34 , 1.93 , 2.45 , 3.29 ;
 1.31 , 1.91 , 2.44 , 3.27 ;
 1.24 , 1.76 , 2.27 , 3.12 ;
 1.24 , 1.74 , 2.25 , 3.07 ;
 1.19 , 1.58 , 2.00 , 2.79 ;
 1.43 , 2.07 , 2.57 , 3.39 ;
 1.78 , 2.53 , 3.10 , 3.85 ;
 2.12 , 2.76 , 3.26 , 3.93 ;
 2.10 , 2.64 , 3.05 , 3.69 ;
 2.02 , 2.51 , 2.88 , 3.47 ;
 2.12 , 2.53 , 2.83 , 3.36 ;
 2.23 , 2.58 , 2.85 , 3.35 ;
 2.50 , 2.85 , 3.09 , 3.53 ;
 2.67 , 3.01 , 3.21 , 3.60 ;
 2.86 , 3.22 , 3.39 , 3.71 ;
 3.03 , 3.38 , 3.54 , 3.77 ;
 3.30 , 3.73 , 3.91 , 4.17 ;
 3.32 , 3.65 , 3.79 , 4.00 ;
 3.33 , 3.64 , 3.72 , 3.85 ;
 3.36 , 3.64 , 3.69 , 3.77 ;
 3.64 , 3.87 , 3.91 , 3.98 ;
 3.87 , 4.04 , 4.08 , 4.12 ;
 3.85 , 3.95 , 3.96 , 4.01 ];
 %Computation of the average and standard deviation of rates.
 Average=mean(Rates,1);
 Deviation=std(Rates);
 %Normalization of the rates to get a mean of zero and
 %standard deviation of one.
 for i=1:size(Rates,1)
    Rates(i,:) = (Rates(i,:)-Average)./Deviation;
 end
 %Interest rates covariance matrix.
 CovRates=cov(Rates);
 %Determination of the eigenvalues and eigenvectors.
 [U,Lambda] = eigs(CovRates,4);
 end