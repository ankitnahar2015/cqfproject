% f0transp.m
function y=f0transp(x)
if (x < -1)
   y=0;
elseif (x <= 0)
   y=x+1;
else
   y=1;
end

   