function [dist,flag] = Bregman_distance(type_div,x_array,y_array)
% Compute the Bregman distance between two discrete probability
% distribution
% This method and some code refer to the paper: Measuring the Discrepancy between Conditional Distributions:
% Methods, Properties and Applications. Shujian Yu, et al. IJCAI 2021.
% Input: 
%   type_div : type of the divergence
%             'VN': von-Neumann divergence
%             'LD': LogDet divergence
%   x_array: samples of a discrete randon varibale
%   y_array: samples of a discrete randon varibale
% Output:
%   dist:  Bregman distance between x_array and y_array 
if (max(x_array)-min(x_array)) == 0 % all elements in x_array are same
    dist = NaN;
    flag = false;
    return;
else
    kernelSize_x =  ComputingKernelSize(x_array);
    x_corren_matrix = center_correntropy_matrix(x_array,kernelSize_x);
end

if (max(y_array)-min(y_array)) == 0 % all elements in y_array are same
    dist = NaN;
    flag = false;
    return;
else
    kernelSize_y =  ComputingKernelSize(y_array);
    y_corren_matrix = center_correntropy_matrix(y_array,kernelSize_y);
end

if strcmp('VN',type_div) % von-Neumann divergence
    d1 = VN_divergence(x_corren_matrix,y_corren_matrix);
    d2 = VN_divergence(y_corren_matrix,x_corren_matrix);
    dist = (d1+d2)/2; % symmetrization
elseif  strcmp('LD',type_div) % LogDet divergence
    d1 = LD_divergence(x_corren_matrix,y_corren_matrix);
    d2 = LD_divergence(y_corren_matrix,x_corren_matrix);
    dist = (d1+d2)/2; % symmetrization
else
    assert(false);
end
 flag = true;
end

function kernelSize = ComputingKernelSize(data) %Silverman's rule of thumb
d_std = std(data);
kernelSize = 1.06*d_std*power(numel(data),-1/5);
end

function D = VN_divergence(rho,sigma)
% von-Neumann divergence 
D = trace(rho*(logm(rho)-logm(sigma)) - rho + sigma); % (Eq. (2)in Shujian Yu, et al. IJCAI 2021.)
end

function D = LD_divergence(rho,sigma)
% LogDet divergence
D = trace(rho*inv(sigma)) - log(det(rho*inv(sigma))) - size(rho,1); % (Eq. (3) in Shujian Yu, et al. IJCAI 2021.)
end

function corren_matrix = center_correntropy_matrix(data,kernelSize)
% input: data of size n x d, n is number of sample, d is dimension; kernel size
% output: a d x d (symmetric) center correntropy matrix
dim = size(data,2);
corren_matrix = zeros(dim,dim);

for i=1:dim
    for j=1:i
        corren_matrix(i,j) = sample_center_correntropy(data(:,i),data(:,j),kernelSize);
        % comment: compute sample estimator of center correntropy (Eq.(9) in Shujian Yu, et al. IJCAI 2021.)
    end
end
end

function corren = sample_center_correntropy(X,Y,kSize)
% input: vector X, vector Y, kernel size
% output: center correntropy between X and Y
n = size(X,1);
twokSizeSquare = 2*kSize^2;

% compute the second term in Eq.(9), which requires quadratic complexity
bias = 0;
for i=1:n
    for j=1:n
        bias = bias + exp(-(X(i) - Y(j))^2/twokSizeSquare);
    end
end
bias = bias/n^2;

% return sample center correntropy (i.e., Eq.(9))
corren = (1/n)*sum(exp(-(X - Y).^2/twokSizeSquare)) - bias;
end