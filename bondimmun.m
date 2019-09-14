% SET BOND FEATURES (bondimmun.m)
settle     = '28-Aug-2007';
maturities   = ['15-Jun-2012' ; '31-Oct-2017' ; '01-Mar-2027'];
couponRates = [0.07 ;  0.06 ; 0.08];
yields = [0.06 ; 0.07 ; 0.075];

% COMPUTE DURATIONS AND CONVEXITIES
durations = bnddury(yields, couponRates, settle, maturities);
convexities = bndconvy(yields, couponRates, settle, maturities);

% COMPUTE PORTFOLIO WEIGHTS
A = [durations'
     convexities'
     1 1 1];
b = [ 10
     160
       1];
weights = A\b

