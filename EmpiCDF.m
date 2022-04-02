function [ecdf] = EmpiCDF(domain,distr)
% Computes an empirical cumulative distribution function
% Input: 
%   domain: domain of a random varibale (an incremental discrete sequence)
%   distr£ºdiscrete probability distribution of a random varibale
% Output: 
%   ecdf£ºthe empirical cumulative distribution function

assert(numel(domain) == numel(distr));
assert(issorted(domain));
assert(sum(distr) > 0);

distr = distr/sum(distr); % normalization
m = numel(domain);
st = domain(1);
ed = domain(m);
ecdf = zeros(ed-st+1,1);
for i = st:ed    
    index = 0;
    for j = 1:m
        if domain(j) == i
            index = j;
            break;
        end
    end 
    if index == 0
        ecdf(i-st+1) = ecdf(i-st);
    else
        if i == st
            ecdf(i-st+1) = distr(index);
        else
            ecdf(i-st+1) = ecdf(i-st)+distr(index);
        end
    end
end
end
