function H = MyHilbV(N)
H = zeros(N,N);
for i=1:N
    H(i,:) = 1./(i:(i+N-1));
end