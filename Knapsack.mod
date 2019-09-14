param NItems > 0;
param Value{1..NItems} >= 0;
param Cost{1..NItems} >= 0;
param Budget >= 0;

var x{1..NItems} binary;

maximize TotalValue: 
	sum {i in 1..NItems} Value[i]*x[i];

subject to AvailableBudget:
	sum {i in 1..NItems} Cost[i]*x[i] <= Budget;

 

