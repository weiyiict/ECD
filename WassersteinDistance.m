function [Wdist] = WassersteinDistance(domain,distr1,distr2)
% Computes the Wasserstein distance W_p between two 1-dimensioanl distributions. Here, p is 1.
% W_1(distr1,distr2) = Integral(|F1(t)-F2(t)|). Here, F1(t) and F2(t) are the empirical
% cumulative distribution functions of distr1 and distr2, respectively. 
% Input:
%   domain: domain of a random varibale (an incremental discrete sequence)
%   distr1,distr2: two 1-dimensioanl distributions
% Output£º
%   Wdist: W_1(distr1,distr2)

assert(numel(domain) == numel(distr1));
assert(numel(distr1) == numel(distr2));

sum1 = sum(distr1);
if sum1 <= 0
    assert(sum1 > 0);
end
distr1 = distr1/sum1; % normilization
sum2 = sum(distr2);
if sum2 <= 0
    assert(sum2 > 0);
end
distr2 = distr2/sum2; % normilization

F1 = EmpiCDF(domain,distr1); % F1(i) = P(X1 <= distr1(i))
F2 = EmpiCDF(domain,distr2); % F2(i) = P(X2 <= distr1(i))

Wdist = 0;
nums = numel(F1);
for i = 1:nums
    Wdist = Wdist + abs(F1(i) - F2(i)); 
end
Wdist = Wdist/nums; % divided by the length of integral interval
end