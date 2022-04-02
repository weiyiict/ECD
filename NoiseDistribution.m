function [NoiseDomain,NoisePopuDistr,NoiseDistrArray] = NoiseDistribution(NoiseCondSamples,prepath,markstring)
% Computes the populational distribution of noise and distribution of $n$ noises accoding to the NoiseSamplesCond
% Input:
%   NoiseSamplesCond: conditional smples of noise
%   prepath: prefix name of path for saving data that processed in this function
%   markstring: postfix name of files for saving data that processed in this function
%               'X-CAU-Y¡¯represents that X causes Y.
%               'Y-CAU-X¡¯represents that Y causes X.
% Output:
%   NoisePopuDistr: populational distribution of noise 
%   NoiseDistrArray: distribution of $n$ noises
%   NosieDomain: domain of noise

%   info: the indicationo when this function exits. The default value of
%         info is 'ok'. If not, there is an error.   

% find the max and min in NoiseSamplesCond
[m,~] = size(NoiseCondSamples);
minY = Inf;
maxY = -Inf;
for i = 1:m % by row order 
    minY = min(minY,min(NoiseCondSamples{i,2}));
    maxY = max(maxY,max(NoiseCondSamples{i,2}));
end

NoiseDomain = (int32(minY:maxY))';
% Computes the populational distribution of noise 
NoisePopuDistr = int32(zeros(numel(NoiseDomain),1));
[m,~] = size(NoiseCondSamples);
for i = 1:m % by row order
    num = numel(NoiseCondSamples{i,2});
    for j = 1:num  
        index = NoiseCondSamples{i,2}(j)-minY+1;
        NoisePopuDistr(index) = NoisePopuDistr(index)+1;
    end
end

num = nnz(NoisePopuDistr); % number of the nonzero elements in NoisePopuDistr
tmpNoiseDomain = int32(zeros(num,1));
tmpNoisePopuDistr = int32(zeros(num,1));
index = 0; 
for i = 1:numel(NoisePopuDistr)
    if NoisePopuDistr(i) ~= 0
        index = index+1; 
        tmpNoiseDomain(index) = NoiseDomain(i);
        tmpNoisePopuDistr(index) = NoisePopuDistr(i);
    end
end
NoiseDomain = tmpNoiseDomain;
NoisePopuDistr = tmpNoisePopuDistr; % delete the elements whose value are zero from NoisePopuDistr

% Computes the distribution of $n$ noises
[m,~] = size(NoiseCondSamples);
num = numel(NoiseDomain);
NoiseDistrArray = zeros(num,m);
for i = 1:m
    lens = numel(NoiseCondSamples{i,2});
    for j = 1:lens
        index = 0;
        for k = 1:num
            if NoiseCondSamples{i,2}(j) == NoiseDomain(k)
                index = k;
                break;
            end
        end
        assert(index ~= 0);
        NoiseDistrArray(index,i) =  NoiseDistrArray(index,i)+1;
    end
end

% saves NoiseDomain
filepath = strcat(prepath,'NosieDomain-',markstring,'.txt'); % creates a filename
fid = fopen(filepath,'w');
[m,~] = size(NoiseDomain);
for i = 1:m
    fprintf(fid,'%+d\n', NoiseDomain(i));
end
fclose(fid);

% saves NoisePopuDistr
filepath = strcat(prepath,'NoisePopuDistr-',markstring,'.txt'); % creates a filename
fid = fopen(filepath,'w');
[m,~] = size(NoisePopuDistr);
for i = 1:m
    fprintf(fid,'%+d\n', NoisePopuDistr(i));
end
fclose(fid);

% saves NoiseDistrArray
filepath = strcat(prepath,'NoiseDistrArray-',markstring,'.txt'); % creates a filename
fid = fopen(filepath,'w');
[m,n] = size(NoiseDistrArray);
for i = 1:m
    fprintf(fid,'[%-3d]  ', NoiseDomain(i));
    fprintf(fid,'%-3d (%-3d%%) |  ', NoisePopuDistr(i),round(100*NoisePopuDistr(i)/sum(NoisePopuDistr)));
    for j = 1:n
        fprintf(fid,'%-3d (%-3d%%)  ', NoiseDistrArray(i,j),round(100*NoiseDistrArray(i,j)/sum(NoiseDistrArray(:,j))));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');

%fprintf(fid,'[%-3d]  ', NosieDomain(1));
fprintf(fid,'       ');
fprintf(fid,'%-3d (%-3d%%) |  ', sum(NoisePopuDistr),100);
for j = 1:n
    fprintf(fid,'%-3d (%-3d%%)  ',sum(NoiseDistrArray(:,j)),100);
end
fclose(fid);

end