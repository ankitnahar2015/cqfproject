% ScriptJacobiBIS
A1 = [3 1 1 0; 1 5 -1 2; 1 0 3 1; 0 1 1 4];
A2 = [2.5 1 1 0; 1 4.1 -1 2; 1 0 2.1 1; 0 1 1 2.1];
A3 = [2 1 1 0; 1 3.5 -1 2; 1 0 2.1 1; 0 1 1 2.1];
b = [1 4 -2 1]';
hold on
[x1,i1] = JacobiBIS(A1,b,zeros(4,1),1e-08,10000);
pause(3);
[x2,i2] = JacobiBIS(A2,b,zeros(4,1),1e-08,10000);
pause(3);
[x3,i3] = JacobiBIS(A3,b,zeros(4,1),1e-08,10000);
pause(3);
axis([1 100 0 2])