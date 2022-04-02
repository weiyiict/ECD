function [samples] = NoiseCondSamples(EffectCondSamples,prepath,markstring)
% Computes the set of conditional samples of noise according to the set of 
% conditional samples of effect variable.
% Input:
%   EffectCondSamples£ºthe set of conditional samples of effect variable
%   prepath: prefix name of path for saving data that processed in this function
%   markstring: postfix name of files for saving data that processed in this function
%              'X-CAU-Y' represents that X causes Y.
%              'Y-CAU-X' represents that Y causes X.
% Output:
%   samples£ºthe set of conditional samples of noise

samples = EffectCondSamples;
[m,~] = size(EffectCondSamples);
for i = 1:m % by row order
    num = numel(EffectCondSamples{i,2}); 
    assert(num >= 1);
    f_mean = sum(EffectCondSamples{i,2})/num; % the mean of f(xi)   
    f_mean = round(f_mean);% rounding
    samples{i,2} = EffectCondSamples{i,2}-f_mean; % epsilon_i = y-f(xi)
end

% saves the set of conditional samples of noise
filepath = strcat(prepath,'NoiseCondSamples-',markstring,'.txt'); % create a filename
fid = fopen(filepath,'w');
[m,~] = size(samples);
for i = 1:m
    fprintf(fid,'%+d  ',samples{i,1});
    nums = numel(samples{i,2});
    for j = 1:nums
        fprintf(fid, '%+d  ', samples{i,2}(j));
    end
    fprintf(fid,'\n');
end
fclose(fid); % ¹Ø±ÕÎÄ¼þ

end