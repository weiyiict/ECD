function [samples,info] = EffectCondSamples(cause,effect,alpha,prepath,markstring)
% Computes the set of conditional samples of effect variable according to 
% the cause samples and effect samples.
% Input:
%   cause: the samples of cause variable (1-dimensional array)
%   effect: the samples of effect variable (1-dimensional array)
%   alpha: the min number contained in the effect samples set {Y|X=xi}
%   prepath: the prefix name of path for saving data that processed in this function
%   markstring: the postfix name of files for saving data that processed in this function
%              'X-CAU-Y¡¯represents that X causes Y.
%              'Y-CAU-X¡¯represents that Y causes X.
% Outpt:
%   samples: the set of conditional samples of effect variable (a two dimensional cell).
%            the first colum stores the cause variable.
%            the second colum stores the noise variable.

assert(numel(cause) == numel(effect));
assert(alpha >= 2);

info = 'ok';
uCause = unique(cause,'sorted'); % select and sort
num_uCause = numel(uCause);
num_cause = numel(cause);
tSamples = cell(num_uCause,2);
for i = 1:num_uCause
    tSamples{i,1}= uCause(i); 
    num = 0;
    temp = zeros(1,num_cause);
    for j = 1:num_cause
        if uCause(i) == cause(j) 
            num = num+1;
            temp(num) = effect(j);
        end
    end
    tSamples{i,2} = temp(1:num); 
end

% check: the numbers of samples of effect in tSamples is equal to the numbers of inputted samples of effect.
num = 0;
for i = 1:num_uCause
    n = numel(tSamples{i,2});
    num = num+n;
end
error = num-num_cause;
assert(error == 0);

% if the numbers of samples of effect in set {Y|X=xi} is less than  alpha,the set {Y|X=xi} is deleted. 
samples = cell(1,2);
j = 0;
for i = 1:num_uCause
    if numel(tSamples{i,2}) >= alpha
        j = j+1;
        samples{j,1} = tSamples{i,1};
        samples{j,2} = sort(tSamples{i,2},'ascend');
    end
end

% check the size of samples
if (j < 2) %  beta = 2
    info = 'the set of conditional samples of effect variable can not be bulid!';
    %assert(false); 
    return;
end

% saves tSamples
filepath = strcat(prepath,'tSamples-',markstring,'.txt'); %  creates a filename
fid = fopen(filepath,'w');
[m,~] = size(tSamples);
for i = 1:m
    fprintf(fid,'%+d  ',tSamples{i,1});
    nums = numel(tSamples{i,2});
    for j = 1:nums
        fprintf(fid, '%+d  ', tSamples{i,2}(j));
    end
    fprintf(fid,'\n');
end
fclose(fid);

% saves samples
filepath = strcat(prepath,'samples-',markstring,'.txt'); %  creates a filename
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
fclose(fid);

end






