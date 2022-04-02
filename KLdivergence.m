function KLdiv = KLdivergence(ps,qs,range)
% Compute the Kullback-Leibler Divergence between two discrete probability
% distribution
% Input: 
%   ps: samples of a discrete randon varibale
%   qs: samples of a discrete randon varibale
%   range: the range of samples
% Output:
%   KLdiv: the Kullback-Leibler Divergence between ps and qs
if (numel(ps) ~= numel(qs) || numel(ps) ~= numel(range))
    assert(false);
    KLdiv = NaN;
    return;
end
num = numel(ps);

issmoothing = false; % is need lapalace correction
for i=1:num
    if (ps(i) == 0)
        issmoothing = true;
        break;
    end
end
if issmoothing == true
    for i=1:num
       ps(i) = ps(i)+1;
    end
end

issmoothing = false; % is need lapalace correction
for i=1:num
    if (qs(i) == 0)
        issmoothing = true;
        break;
    end
end
if issmoothing == true
    for i=1:num
       qs(i) = qs(i)+1;
    end
end

% normalizing ps and qs
dps = double(ps); % double 
dqs = double(qs); % double
nps = sum(dps);
nqs = sum(dqs);
for i=1:num 
    dps(i) = double(dps(i)/nps);
    dqs(i) = double(dqs(i)/nqs);
end

KLdiv = 0;
for i=1:num
   KLdiv = KLdiv + dps(i)*log2(dps(i)/dqs(i)); 
end

end