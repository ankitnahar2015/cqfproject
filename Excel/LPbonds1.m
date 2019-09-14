% SCRIPT LPBonds1.m
% BOND CHARACTERISTICS FOR SET 1
settle     = '19-Mar-2006';
maturity1  = ['15-Jun-2021' ; '02-Oct-2016' ; '01-Mar-2031' ; ...
    '01-Mar-2026' ; '01-Mar-2011'];
Face1       = [500  ;  1000  ;  250 ; 100 ; 100];
couponRate1 = [0.07 ;  0.066 ; 0.08 ; 0.06 ; 0.05];
cleanPrice1 = [ 549.42 ; 970.49 ; 264.00 ; 112.53 ; 87.93 ];
% COMPUTE YIELDS AND SENSITIVITIES
yields1 = bndyield(cleanPrice1, couponRate1, settle, maturity1, ...
           2, 0, [] , [] , [] , [], [] , Face1);
durations1 = bnddury(yields1, couponRate1, settle, maturity1, ...
            2, 0, [] , [] , [] , [], [] , Face1);
convexities1 = bndconvy(yields1, couponRate1, settle, maturity1, ...
              2, 0, [] , [] , [] , [], [] , Face1);
% SET UP AND SOLVE LP PROBLEM
A1 = [durations1'
     convexities1'
     ones(1,5)];
b = [ 10.3181 ; 157.6346 ; 1];
weights1 = linprog(-yields1,[],[],A1,b,zeros(1,5))
% BOND CHARACTERISTICS FOR SET 2
maturity2  = [maturity1 ; ...
   '15-Jan-2019' ; '10-Sep-2010' ; '01-Aug-2023' ; ...
   '01-Mar-2016' ; '01-May-2013'];
Face2       = [Face1 ; 100  ;  500  ;  200 ; 1000 ; 100];
couponRate2 = [couponRate1 ; 0.08 ;  0.07 ; 0.075 ; 0.07 ; 0.06];
cleanPrice2 = [ cleanPrice1 ; ...
        108.36 ; 519.36 ; 232.07 ; 1155.26 ; 89.29 ];
% COMPUTE YIELDS AND SENSITIVITIES
yields2 = bndyield(cleanPrice2, couponRate2, settle, maturity2, ...
          2, 0, [] , [] , [] , [], [] , Face2);
durations2 = bnddury(yields2, couponRate2, settle, maturity2, ...
             2, 0, [] , [] , [] , [], [] , Face2);
convexities2 = bndconvy(yields2, couponRate2, settle, maturity2, ...
               2, 0, [] , [] , [] , [], [] , Face2);
% SET UP AND SOLVE LP PROBLEM
A2 = [durations2'
     convexities2'
     ones(1,10)];
weights2 = linprog(-yields2,[],[],A2,b,zeros(1,10))
