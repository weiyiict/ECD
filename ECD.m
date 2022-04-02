function [caudir,aveDistx2y,aveDisty2x,info] = ECD(dtype,X,Y,alpha,gamma, prepath) 
% Computes the direction of cause
% Input:
%   dtype: the type of the distance between two probability  distributions
%          'WAS': Wasserstein Distance
%          'KL' : Kullback-Leibler Distance
%          'CCD': Conditional Distribution Divergence
%   X,Y: are 1-dimensional arrays
%   alpha: the min size of an effect samples set {Y|X=xi}
%   gamma: the parameter of scaling down 
%   prepath: the prefix name of path for saving data that processed in this function
% Output:
%   caudir: the direction of cause, 'X->Y' or 'Y->X'.
%   aveDistx2y: average distance when we assume that X is casue and Y is effect
%   aveDisty2x: average distance when we assume that Y is casue and X is effect

assert(gamma > 1);

flag = 0;
while flag == 0
    markstring = 'X-CAU-Y';
    [effectSamples,info] = EffectCondSamples(X,Y,alpha,prepath,markstring);
    if strcmp(info,'ok') == 0
        disp(info);
        %tX = round(X/2);  % gamma = 2
        tX = round(X/gamma); 
        if( isequal(tX, X) == true )
            caudir = 'Error';
            aveDistx2y = 0;
            aveDisty2x = 0;
            return; % exit
        else
            X = tX;
        end
        continue;
    end
    noiseSamples = NoiseCondSamples(effectSamples,prepath,markstring);
    [NoiseDomain,NoisePopuDistr,NoiseDistrArray] = NoiseDistribution(noiseSamples,prepath,markstring);
    [aveDistx2y,flag_XCY] = AverageDistance(dtype,NoiseDomain,NoisePopuDistr,NoiseDistrArray,prepath,markstring);
    
    markstring = 'Y-CAU-X';
    [effectSamples,info] = EffectCondSamples(Y,X,alpha,prepath,markstring);
    if strcmp(info,'ok') == 0
        disp(info);
        %tY = round(Y/2); %gamma = 2
        tY = round(Y/gamma);
        if( isequal(tY, Y) == true )
            caudir = 'Error';
            aveDistx2y = 0;
            aveDisty2x = 0;
            return; % exit
        else
            Y = tY;
        end
        continue;
    end
    noiseSamples = NoiseCondSamples(effectSamples,prepath,markstring);
    [NoiseDomain,NoisePopuDistr,NoiseDistrArray] = NoiseDistribution(noiseSamples,prepath,markstring);    
    [aveDisty2x,flag_YCX] = AverageDistance(dtype,NoiseDomain,NoisePopuDistr,NoiseDistrArray,prepath,markstring);
    flag = 1;
end

% discover the direction of cause
% if flag_XCY == false || flag_YCX == false
%      caudir = 'Undeifned';
if aveDistx2y < aveDisty2x
    caudir = 'X->Y';
elseif aveDistx2y > aveDisty2x
    caudir = 'Y->X';
else
    caudir = 'Undeifned';
end

end