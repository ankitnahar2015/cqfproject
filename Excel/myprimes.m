function p = myprimes(N)
found = 0;
trynumber = 2;
p = [];
while (found < N)
   if isprime(trynumber)
      p = [p , trynumber];
      found = found + 1;
   end
   trynumber = trynumber + 1;
end
