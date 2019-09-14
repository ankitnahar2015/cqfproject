function X=GenerateVariable(p1,p2,Delta1,Delta2)
 %X takes value Delta1 with probability p1
 %X takes value Delta2 with probability p2
 %X takes value 0 with probability 1-p1-p2

 U = rand; %Uniform variable
 X=Delta1 * (U<=p1)-Delta2 * (p1<U) * (p1+p2 >= U);

 end