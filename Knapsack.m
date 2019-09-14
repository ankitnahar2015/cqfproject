% Knapsack.m
A = [2 1 6 5];
b = 7; 
c = - [10 7 25 24];
options = optimset('NodeSearchStrategy','df');
[x, value, exitflag, outputdf] = bintprog(c,A,b,[],[],[],options);
options = optimset('NodeSearchStrategy','bn');
[x, value, exitflag, outputbn] = bintprog(c,A,b,[],[],[],options);
fprintf(1,'Optimal solution: ', x');
fprintf(1,'%d ', x');
fprintf(1,'\nValue: %d\n', -value);
fprintf(1,'Nodes with depth-first: %d\n', outputdf.nodes);
fprintf(1,'Nodes with best-node: %d\n', outputbn.nodes);
