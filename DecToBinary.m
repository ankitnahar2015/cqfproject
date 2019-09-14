function b=DecToBinary(n)
n0 = n;
i=1;
while (n0 > 0)
   n1 = floor(n0/2);
   b(i) = n0 - n1*2;
   n0=n1;
   i = i+1;
end
b=fliplr(b);
