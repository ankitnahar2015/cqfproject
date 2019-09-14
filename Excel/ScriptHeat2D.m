dt = 0.0001;
dx = 0.05;
dy = 0.05;
value = 10;
bounds = [0.7, 0.9, 0.1, 0.9];
Tmax = 0.1;
Tsnap = [0.01, 0.02, 0.03, 0.04, 0.05, 0.06];
U = Heat2D(dt, dx, dy, Tmax, Tsnap, value, bounds);
