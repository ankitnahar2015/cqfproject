% ScriptGaussSeidel
A1 = [3 1 1 0; 1 5 -1 2; 1 0 3 1; 0 1 1 4];
A2 = [2.5 1 1 0; 1 4.1 -1 2; 1 0 2.1 1; 0 1 1 2.1];
A3 = [2 1 1 0; 1 3.5 -1 2; 1 0 2.1 1; 0 1 1 2.1];
b = [1 4 -2 1]';

exact1 = A1\b;
[x1,i1] = GaussSeidel(A1,b,zeros(4,1),1e-08,10000);
fprintf(1, 'Case of matrix\n');
disp(A1);
fprintf(1, 'Terminated after %d iterations\n', i1);
fprintf(1, '  Exact       GaussSeidel\n');
fprintf(1, ' % -10.5g % -10.5g \n', [exact1' ; x1']);

exact2 = A2\b;
[x2,i2] = GaussSeidel(A2,b,zeros(4,1),1e-08,10000);
fprintf(1, '\nCase of matrix\n');
disp(A2);
fprintf(1, 'Terminated after %d iterations\n', i2);
fprintf(1, '  Exact       GaussSeidel\n');
fprintf(1, ' % -10.5g % -10.5g \n', [exact2' ; x2']);

exact3 = A3\b;
[x3,i3] = GaussSeidel(A3,b,zeros(4,1),1e-08,10000);
fprintf(1, '\nCase of matrix\n');
disp(A3);
fprintf(1, 'Terminated after %d iterations\n', i3);
fprintf(1, '  Exact       GaussSeidel\n');
fprintf(1, ' % -10.5g % -10.5g \n', [exact3' ; x3']);
