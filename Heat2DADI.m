function U = Heat2DADI(dt, dx, dy, Tmax, Tsnap, value, bounds)
% make sure steps are consistent
Nx = round(1/dx);
dx = 1/Nx;
Ny = round(1/dy);
dy = 1/Ny;
Nt = round(Tmax/dt);
dt = Tmax/Nt;
rhox = dt/dx^2;
rhoy = dt/dy^2;

Layers = zeros(2, 1+Nx, 1+Ny);
Auxlayer = zeros(1+Nx, 1+Ny);
tpast = 1;
tnow = 2;
iTsnap = Tsnap/dt;
[X, Y] = meshgrid(0:dx:1, 0:dy:1);
% set up initial conditions
Layers(tpast, (1+round(bounds(1)/dx)):(1+round(bounds(2)/dx)), ...
    (1+round(bounds(3)/dy)):(1+round(bounds(4)/dy))) = value;
U = shiftdim(Layers(tpast,:,:));
figure;
surf(X,Y,U);        
title('t=0','Fontsize',12);
% Prepare matrices and LU decomposition
Matrix1 = diag((1+rhox)*ones(Nx-1,1)) + ...
    diag(-rhox/2*ones(Nx-2,1),1) + ...
    diag(-rhox/2*ones(Nx-2,1),-1);
[L1, U1] = lu(Matrix1);
Matrix2 = diag((1+rhoy)*ones(Ny-1,1)) + ...
    diag(-rhoy/2*ones(Ny-2,1),1) + ...
    diag(-rhoy/2*ones(Ny-2,1),-1);
[L2, U2] = lu(Matrix2);
Rhs1 = zeros(Nx-1,1);
Rhs2 = zeros(Ny-1,1);
% Carry out iterations
for t=1:Nt
    % first half step 
    for j=1:Ny-1
        % set up right hand side
        for i=1:Nx-1
            Rhs1(i) = rhoy/2*Layers(tpast,i+1,j) + ...
                (1-rhoy)*Layers(tpast,i+1,j+1) + ...
                rhoy/2*Layers(tpast,i+1,j+2);
        end
        % solve
        Auxlayer(2:Nx,j+1) = U1 \ (L1 \ Rhs1);
    end
    % second half step
    for i=1:Nx-1
        % set up right hand side
        for j=1:Ny-1
            Rhs2(j) = rhox/2*Auxlayer(i,j+1) + ...
                (1-rhox)*Auxlayer(i+1,j+1) + ...
                rhox/2*Auxlayer(i+2,j+1);
        end
        % solve
        Layers(tnow, i+1,2:Ny) = (U2 \ (L2 \ Rhs2))';
    end
    % plot if necessary
    if find(iTsnap == t)
        U = shiftdim(Layers(tnow,:,:));
        figure;
        surf(X,Y,U);        
        title(['t=', num2str(Tsnap(1)) ],'Fontsize',12);
        Tsnap(1) = [];
    end
    % swap layers
    tnow = 1+mod(t+1,2);
    tpast = 1+mod(t,2);
end
