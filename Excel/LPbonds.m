settle     = '19-Mar-2000';
maturity1  = ...
   ['15-Jun-2015' ; '02-Oct-2010' ; '01-Mar-2025' ; '01-Mar-2020' ; '01-Mar-2005'];
maturity2  = [maturity1 ; ...
   '15-Jan-2013' ; '10-Sep-2004' ; '01-Aug-2017' ; '01-Mar-2010' ; '01-May-2007'];
Face1       = [500  ;  1000  ;  250 ; 100 ; 100];
Face2       = [Face1 ; 100  ;  500  ;  200 ; 1000 ; 100];
couponRate1 = [0.07 ;  0.066 ; 0.08 ; 0.06 ; 0.05];
couponRate2 = [couponRate1 ; 0.08 ;  0.07 ; 0.075 ; 0.07 ; 0.06];
yields1 = [0.06 ; 0.07 ; 0.075 ; 0.05 ; 0.08];
yields2 = [yields1 ; 0.07 ; 0.06 ; 0.06 ; 0.05 ; 0.08];

[cleanPrice, accruedInterest] = bndprice(yields1, couponRate1, settle, maturity1, ...
                                         2, 0, [] , [] , [] , [], [] , Face1);

durations = bnddury(yields, couponRate, settle, maturity, ...
                    2, 0, [] , [] , [] , [], [] , Face);

convexities = bndconvy(yields, couponRate, settle, maturity, ...
                       2, 0, [] , [] , [] , [], [] , Face);

prices  =  cleanPrice + accruedInterest;

A = [durations'
     convexities'
     ones(1,5)];

b = [ 10.3181           
     157.6346           
       1];
   
weights1 = LINPROG(-yields1,[],[],A,b,zeros(1,5))

[cleanPrice, accruedInterest] = bndprice(yields2, couponRate2, settle, maturity2, ...
                                         2, 0, [] , [] , [] , [], [] , Face2);

durations = bnddury(yields2, couponRate2, settle, maturity2, ...
                    2, 0, [] , [] , [] , [], [] , Face2);

convexities = bndconvy(yields2, couponRate2, settle, maturity2, ...
                       2, 0, [] , [] , [] , [], [] , Face2);

prices  =  cleanPrice + accruedInterest;

A = [durations'
     convexities'
     ones(1,10)];

b = [ 10.3181           
     157.6346           
       1];
   
weights2 = LINPROG(-yields2,[],[],A,b,zeros(1,10))

