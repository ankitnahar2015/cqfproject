% CournotJacScript
c = [0.6; 0.8];
eta = 1.6; 
q0 = [0.2; 0.2];
options = optimset('Jacobian', 'on', 'DerivativeCheck', 'on');
[q, fval, exitflag, output] = fsolve(@(q) cournotJac(q,c,eta), q0, options);
fprintf(1,'q1 = %d   q2 = %d\n', q(1), q(2));
fprintf(1,'number of iterations = %d\n', output.iterations);

