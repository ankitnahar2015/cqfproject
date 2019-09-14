set assets;             # available investment options
param initwealth;       # initial wealth
param target;   # target liability at time T
param reward;   # reward for excess wealth beyond target value
param penalty;	# shorfall penalty 

# NODE SETS
set init_node;   		# initial node
set interm_nodes;       # intermediate nodes
set term_nodes;         # terminal nodes
# immediate predecessor node
set pred{interm_nodes union term_nodes} 
            within {init_node union interm_nodes};
param prob{term_nodes};	# probability of each scenario
# return of each investment option at the end of time periods
param return{assets, interm_nodes union term_nodes};  

# DECISION VARIABLES
# amount invested in trading nodes
var invest{assets,init_node union interm_nodes} >= 0;   
var above_target{term_nodes}>=0;	     # amountt above final target
var below_target{term_nodes}>=0;	     # amountt below final target

# OBJECTIVE FUNCTION
maximize exp_value:
    sum{s in term_nodes} prob[s]*(reward*above_target[s]
        - penalty*below_target[s]);

# CONSTRAINTS
# initial wealth is allocated in the root node
subject to budget{n0 in init_node} :
    sum{k in assets} (invest[k,n0]) = initwealth;  
# portfolio rebalancing at intermediate nodes
subject to balance{n in interm_nodes, a in pred[n]} :
    (sum{k in assets} return[k,n]*invest[k,a]) =
    sum{k in assets} invest[k,n];
# check final wealth against targer
subject to scenario_value{s in term_nodes, a in pred[s]} :
    (sum{k in assets} return[k,s]*invest[k,a]) 
    - above_target[s] + below_target[s] = target;
