% ScriptSOR
A2 = [2.5 1 1 0; 1 4.1 -1 2; 1 0 2.1 1; 0 1 1 2.1];
b = [1 4 -2 1]';
omega = 0:0.1:2;
N = length(omega);
NumIterations = zeros(N,1);
for i=1:N
    [x,k] = SORGaussSeidel(A2,b,zeros(4,1),omega(i),1e-08,1000);
    NumIterations(i) = k;
end
plot(omega,NumIterations)
grid on