function B=Binary(p)
 %B takes value 1 with probability p
 %B takes value 0 with probability 1-p

 U = rand;
 B=(U<=p);

 end