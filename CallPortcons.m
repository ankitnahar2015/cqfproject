% CallPortcons.m
NAssets = 5;
AssetMin = NaN;
AssetMax = [0.35 0.3 0.3 0.4 0.5];
Groups = [1 1 0 0 0 ; 0 0 1 1 1];
GroupMin = [ 0.2 0.3 ];
GroupMax = [ 0.6 0.7 ];

ConstrMatrix = portcons('Default', NAssets, ...
   'AssetLims', AssetMin, AssetMax, NAssets, ...
   'GroupLims', Groups, GroupMin, GroupMax)
