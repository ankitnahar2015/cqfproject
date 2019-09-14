function samples = EmpiricalDrnd(values, probs, howmany)
% get cumulative probabilities
cumprobs = cumsum(probs);
N = length(probs);
samples = zeros(howmany,1);
for k=1:howmany
    loc=sum(rand*cumprobs(N) > cumprobs) +1;
    samples(k)=values(loc);
end
