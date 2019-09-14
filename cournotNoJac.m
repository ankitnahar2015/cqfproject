function [fval,fjac] = cournotNoJac(q,c,eta)
e = -1/eta;
qtot = sum(q);
fval = qtot^e + e*qtot^(e-1)*q - c.*q;
