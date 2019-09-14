
function GrapheEuler

racine=2.5;
point=1.7;

t=0:0.01:10;
y=t.^(1/racine);
z=(t-point)/(racine*point^(1-1/racine))+point^(1/racine);

plot(t,y,t,z)

end