function KLdis = KLDistance(ps,qs,range)
% Compute the Kullback-Leibler Distance between two discrete probability
% distribution. Kullback-Leibler Divergence is defined as the average of
% two Kullback-Leibler Divergence:KLdivergence(ps,qs,range), KLdivergence(qs,ps,range)
% Input: 
%   ps: samples of a discrete randon varibale
%   qs: samples of a discrete randon varibale
%   range: the range of samples
% Output:
%   KLdis: the Kullback-Leibler Distance between ps and qs

KLdiv1 = KLdivergence(ps,qs,range);
KLdiv2 = KLdivergence(qs,ps,range);
KLdis = (KLdiv1+KLdiv2)/2.0;
end

