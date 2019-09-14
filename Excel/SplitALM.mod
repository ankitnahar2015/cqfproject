set assets;             # set of available assets
param initwealth;       # initial wealth
param scenarios;        # number of scenarios
param T;                # number of time periods
param target;   # target value (liability) at time T
param reward;   # reward for wealth beyond target value
param penalty;  # penalty for not meeting the target
# return of each asset during each period in each scenario
param return{assets, 1..scenarios, 1..T};  
param prob{1..scenarios};	# probability of each scenario
# the indexed set points out which scenarios
# are linked at each period t in 0..T-1
set links{0..T-1} within {1..scenarios, 1..scenarios};

# DECISION VARIABLES
# amount invested in each asset at each period of time 
# in each scenario
var invest{assets,1..scenarios,0..T-1} >= 0; 
var above_target{1..scenarios}>=0;	# amount above final target
var below_target{1..scenarios}>=0;	# amount below final target

# OBJECTIVE FUNCTION
maximize exp_value:
   sum{i in 1..scenarios} prob[i]*(reward*above_target[i]
        - penalty*below_target[i]);

# CONSTRAINTS
# initial wealth is allocated at time 0
subject to budget{i in 1..scenarios}:
    sum{k in assets} (invest[k,i,0]) = initwealth;  
# portfolio rebalancing at intermediate times
subject to balance{j in 1..scenarios, t in 1..T-1} :
    (sum{k in assets} return[k,j,t]*invest[k,j,t-1]) =
    sum{k in assets} invest[k,j,t];
# check final wealth against liability
subject to scenario_value{j in 1..scenarios} :
    (sum{k in assets} return[k,j,T]*invest[k,j,T-1]) 
    - above_target[j] + below_target[j] = target;
# this makes all investments nonanticipative
subject to linkscenarios
    {k in assets, t in 0..T-1, (s1,s2) in links[t]} :
    invest[k,s1,t] = invest[k,s2,t];