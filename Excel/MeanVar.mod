param NAssets > 0;
param ExpRet{1..NAssets};
param CovMat{1..NAssets, 1..NAssets};
param TargetRet;

var W{1..NAssets} >= 0;

minimize Risk: 
	sum {i in 1..NAssets, j in 1..NAssets} W[i]*CovMat[i,j]*W[j];

subject to SumToOne:
	sum {i in 1..NAssets} W[i] = 1;

subject to MinReturn:
	sum {i in 1..NAssets} ExpRet[i]*W[i] = TargetRet;
 

