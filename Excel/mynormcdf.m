function z = mynormcdf(x)
c = [ 0.31938153 , -0.356563782 , 1.781477937 , ...
      -1.821255978 , 1.330274429 ];
gamma = 0.2316419;
vx = abs(x); 
k = 1./(1+gamma.*vx);
n = exp(-vx.^2./2)./sqrt(2*pi);
matk = ones(5,1) * k;
matexp = (ones(length(x),1)*(1:5))';
matv = matk.^matexp;
z = 1 - n.*(c*matv);
i = find(x < 0);
z(i) = 1-z(i);

  