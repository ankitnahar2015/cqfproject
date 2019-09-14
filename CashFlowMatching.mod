param NBonds >0, integer;
param TimeHorizon >0, integer;
param BondPrice{1..NBonds};
param CashFlow{1..NBonds, 1..TimeHorizon};
param Liability{1..TimeHorizon};

var x{1..NBonds} >= 0;

minimize PortfolioCost:
    sum {i in 1..NBonds} BondPrice[i]*x[i];

subject to MeetLiability {t in 1..TimeHorizon}:
    sum {i in 1..NBonds} CashFlow[i,t]*x[i] >= Liability[t];

