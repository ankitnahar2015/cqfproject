options = optimset('LargeScale', 'off', 'Simplex', 'on');
A = [2 1 6 5];
b = 7; 
c = - [10 7 25 24];
lb = zeros(4,1);
ub = ones(4,1);
[x, val] = linprog(c,A,b,[],[],lb,ub,[],options)
Aeq = [0 0 0 1];
beq = 1;
[x, val] = linprog(c,A,b,Aeq,beq,lb,ub,[],options)
Aeq = [0 0 0 1];
beq = 0;
[x, val] = linprog(c,A,b,Aeq,beq,lb,ub,[],options)
Aeq = [0 0 0 1; 1 0 0 0];
beq = [1;1];
[x, val] = linprog(c,A,b,Aeq,beq,lb,ub,[],options)
Aeq = [0 0 0 1; 1 0 0 0];
beq = [1;0];
[x, val] = linprog(c,A,b,Aeq,beq,lb,ub,[],options)

Aeq = [0 0 0 1; 1 0 0 0; 0 0 1 0];
beq = [1;0;0];
[x, val] = linprog(c,A,b,Aeq,beq,lb,ub,[],options)

Aeq = [0 0 0 1; 1 0 0 0; 0 0 1 0];
beq = [1;0;1];
[x, val] = linprog(c,A,b,Aeq,beq,lb,ub,[],options)

A1 = [2 1 6 5; 1 0 1 0; 0 0 1 1; 1 1 0 1];
b1 = [7;1;1;2]; 
c = - [10 7 25 24];
lb = zeros(4,1);
ub = ones(4,1);
[x, val] = linprog(c,A1,b1,[],[],lb,ub,[],options)
