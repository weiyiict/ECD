function [ave_dist,flag] = AverageDistance(dtype,domain,NoisePopuDistr,NoiseDistrArray,prepath,markstring)
% Computes the average distance between the populational distribution of noise 
% and the distributions of $n$ noises.
% Input:
%   dtype: the type of the distance between two probability  distributions
%          'WAS': Wasserstein Distance
%          'KL' : Kullback-Leibler Distance
%          'BD' : Bregman Distance
%   domain: domain of a random varibale (an incremental discrete sequence)
%   NoisePopuDistr: populational distribution of noise 
%   NoiseDistrArray: distribution of $n$ noises
%   prepath: prefix name of path for saving data that processed in this function
%   markstring: postfix name of files for saving data that processed in this function
%               'X-CAU-Y¡¯represents that X causes Y.
%               'Y-CAU-X¡¯represents that Y causes X.
% Output:
%   ave_dist: average distance between the populational distribution of noise and
%   the distributions of $n$ noises
flag = true;
if strcmp(dtype,'WAS') % 
    numsPopu = sum(NoisePopuDistr);
    NormNoisePopuDistr = double(NoisePopuDistr)/numsPopu; % normalization
    [~,n] = size(NoiseDistrArray);
    Wdist = zeros(n,1); % saves $n$ Wasserstein distances
    weights = zeros(n,1);
    ave_dist = 0;
    for i = 1:n % traverses by column order
        NoiseDistr = NoiseDistrArray(:,i);
        nums = sum(NoiseDistr);
        NormNoiseDistr = NoiseDistr/nums; % normalization
        Wdist(i) = WassersteinDistance(domain,NormNoiseDistr,NormNoisePopuDistr);
        weights(i) = nums/numsPopu;
        ave_dist = ave_dist + weights(i)*Wdist(i);
    end
    
    % Saves Wasserstein distances
    filepath = strcat(prepath,'Wasserstein-dist-',markstring,'.txt');
    fid = fopen(filepath,'w');
    m = numel(Wdist);
    fprintf(fid, 'ave_dist = %f\n',ave_dist);
    fprintf(fid, 'WassDist  weight    WassDist*weight   Percent\n');
    for i = 1:m
        fprintf(fid, '%f  %f  %f          %5.2f%%\n', Wdist(i),weights(i),Wdist(i)*weights(i),100*Wdist(i)*weights(i)/ave_dist);
    end
    fclose(fid);
elseif strcmp(dtype,'KL') 
    numsPopu = sum(NoisePopuDistr);
    [~,n] = size(NoiseDistrArray);
    KLdist = zeros(n,1); % saves $n$ KL distances
    weights = zeros(n,1);
    ave_dist = 0;
    for i = 1:n % traverses by column order
        NoiseDistr = NoiseDistrArray(:,i);
        nums = sum(NoiseDistr);
        KLdist(i) = KLDistance(NoiseDistr,NoisePopuDistr,domain);
        weights(i) = nums/numsPopu;
        ave_dist = ave_dist + weights(i)*KLdist(i);
    end
    
    % Saves KL distances
    filepath = strcat(prepath,'KL-dist-',markstring,'.txt');
    fid = fopen(filepath,'w');
    m = numel(KLdist);
    fprintf(fid, 'ave_dist = %f\n',ave_dist);
    fprintf(fid, 'KLDist  weight    KLDist*weight   Percent\n');
    for i = 1:m
        fprintf(fid, '%f  %f  %f          %5.2f%%\n', KLdist(i),weights(i),KLdist(i)*weights(i),100*KLdist(i)*weights(i)/ave_dist);
    end
    fclose(fid);
elseif  strcmp(dtype,'BD')      
    numsPopu = sum(NoisePopuDistr);
    [~,n] = size(NoiseDistrArray);
    Bdist = zeros(n,1); % saves $n$ Bregman distances
    weights = zeros(n,1);
    ave_dist = 0;
    m = numel(domain); 
    ylength = sum(NoisePopuDistr);
    yarray = zeros(ylength,1);
    index = 1;
    for j =1:m
        if NoisePopuDistr(j) ~= 0
            for k = index:index+NoisePopuDistr(j)-1
                yarray(k)= double(domain(j));
            end
            index = index+NoisePopuDistr(j);
        end
    end
    for i = 1:n % traverses by column order
        NoiseDistr = NoiseDistrArray(:,i);
        xlength = sum(NoiseDistr);
        xarray =zeros(xlength,1);
        index = 1;
        for j =1:m
            if NoiseDistr(j) ~= 0
                for k = index:index+NoiseDistr(j)-1
                      xarray(k)= double(domain(j));
                end
                index = index+NoiseDistr(j);
            end
        end
        [Bdist(i),is_ok] = Bregman_distance('VN',xarray,yarray);
        if is_ok == false
            flag = false;
        else
            nums = sum(NoiseDistr);
            weights(i) = nums/numsPopu;
            ave_dist = ave_dist + weights(i)*Bdist(i);
        end
    end
    
    % Saves BD divergence
    filepath = strcat(prepath,'B-dist-',markstring,'.txt');
    fid = fopen(filepath,'w');
    m = numel(Bdist);
    fprintf(fid, 'ave_dist = %f\n',ave_dist);
    fprintf(fid, 'BDist  weight    BDist*weight   Percent\n');
    for i = 1:m
        fprintf(fid, '%f  %f  %f          %5.2f%%\n', Bdist(i),weights(i),Bdist(i)*weights(i),100*Bdist(i)*weights(i)/ave_dist);
    end
    fclose(fid);
else
    assert(false);
end