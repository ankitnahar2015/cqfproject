param NAssets > 0, integer;
param MaxAssets > 0, integer;
param ExpRet{1..NAssets};
param CovMat{1..NAssets, 1..NAssets};
param TargetRet;

var W{1..NAssets} >= 0;
var delta{1..NAssets} binary;

minimize Risk: 
	sum {i in 1..NAssets, j in 1..NAssets} W[i]*CovMat[i,j]*W[j];

subject to SumToOne:
	sum {i in 1..NAssets} W[i] = 1;

subject to MinReturn:
	sum {i in 1..NAssets} ExpRet[i]*W[i] = TargetRet;
 
subject to LogicalLink {i in 1..NAssets}:
	W[i] <= delta[i];

subject to MaxCardinality:
	sum {i in 1..NAssets} delta[i] <= MaxAssets;

