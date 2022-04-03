function [sucnum, errnum]= TestUCIData(dtype,alpha,gamma)
% Tests the data used in UCI. These data is used by the paper 'Accurate Causal Inference on Discrete Data'
% (Authors: Kailash Budhathoki and Jilles Vreeken)
%
% Input:
%   dtype: the type of distance between two probability  distributions
%          'WAS': Wasserstein Distance
%          'KL' : Kullback-Leibler Distance
%          'BD': Bregman Distance
%   alpha: the min sums of numbers in the populational distribution of noise 
%   gamma: the parameter of scaling down 
% Output:
%  sucnum: the number of success
%  errnum: the number of error

disp(['alpha = ', num2str(alpha)]);
disp(['gamma = ', num2str(gamma)]);
sucnum = 0;
errnum = 0;
% processes Abalone.dat
fileID = fopen('UCIData\Abalone.dat','r');
sizeA = [4 Inf];
formatSpec = '%f %f %f %f';
abaloneData = fscanf(fileID,formatSpec,sizeA);

% discretization
X = round(abaloneData(1,:));
Y1 = round(1000*abaloneData(2,:));
Y2 = round(1000*abaloneData(3,:));
Y3 = round(1000*abaloneData(4,:));

%format short g; 

prepath = 'UCIData\abalone1\';
str = clock;
[caudir,aveDistx2y,aveDisty2x,info] = ECD(dtype,X,Y1,alpha,gamma,prepath);
cls = clock;
if strcmp(info,'ok') == 1
    if strcmp('X->Y',caudir) == 1
        sucnum = sucnum +1;
        flag = '  Success';
    else errnum = errnum +1;
        flag =  '  Error';
    end
else
    errnum = errnum +1;
    flag =  '  Error';
end

infstr = ['Abalone001',' ', caudir,'  aveDistx2y = ', num2str(round(aveDistx2y,5)), '  aveDisty2x = ',...
                num2str(round(aveDisty2x,5)),'  aveDistx2y/aveDisty2x = ', num2str(round(aveDistx2y/aveDisty2x,5)),'  ', flag];
disp(infstr);  

disp('cost of time (second):');
disp(etime(cls,str));

prepath = 'UCIData\abalone2\';
str = clock;
[caudir,aveDistx2y,aveDisty2x,info] = ECD(dtype,X,Y2,alpha,gamma,prepath);
cls = clock;
if strcmp(info,'ok') == 1
    if strcmp('X->Y',caudir) == 1
        sucnum = sucnum +1;
        flag = '  Success';
    else errnum = errnum +1;
        flag =  '  Error';
    end
else
    errnum = errnum +1;
    flag =  '  Error';
end
infstr = ['Abalone002',' ', caudir,'  aveDistx2y = ', num2str(round(aveDistx2y,5)), '  aveDisty2x = ',...
                num2str(round(aveDisty2x,5)),'  aveDistx2y/aveDisty2x = ', num2str(round(aveDistx2y/aveDisty2x,5)),'  ', flag];
disp(infstr);  
disp('cost of time (second):');
disp(etime(cls,str));

prepath = 'UCIData\abalone3\';
str = clock;
[caudir,aveDistx2y,aveDisty2x,info] = ECD(dtype,X,Y3,alpha,gamma,prepath);
cls = clock;
if strcmp(info,'ok') == 1
  if strcmp('X->Y',caudir) == 1
        sucnum = sucnum +1;
        flag = '  Success';
    else errnum = errnum +1;
        flag =  '  Error';
    end
else
    errnum = errnum +1;
    flag =  '  Error';
end
infstr = ['Abalone003',' ', caudir,'  aveDistx2y = ', num2str(round(aveDistx2y,5)), '  aveDisty2x = ',...
                num2str(round(aveDisty2x,5)),'  aveDistx2y/aveDisty2x = ', num2str(round(aveDistx2y/aveDisty2x,5)),'  ', flag];
disp(infstr);  
disp('cost of time (second):');
disp(etime(cls,str));

% processes HorseColic.dat
fileID = fopen('UCIData\HorseColic.dat','r');
sizeA = [2 Inf];
formatSpec = '%f %f';
horseColicData = fscanf(fileID,formatSpec,sizeA);
X = horseColicData(1,:);
Y = horseColicData(2,:);
prepath = 'UCIData\HorseColic\';
str = clock;
[caudir,aveDistx2y,aveDisty2x,info] = ECD(dtype,X,Y,alpha,gamma,prepath);
cls = clock;
if strcmp(info,'ok') == 1
    if strcmp('X->Y',caudir) == 1
        sucnum = sucnum +1;
        flag = '  Success';
    else errnum = errnum +1;
        flag =  '  Error';
    end
else
    errnum = errnum +1;
    flag =  '  Error';
end
infstr = ['HorseColic',' ', caudir,'  aveDistx2y = ', num2str(round(aveDistx2y,5)), '  aveDisty2x = ',...
                num2str(round(aveDisty2x,5)),'  aveDistx2y/aveDisty2x = ', num2str(round(aveDistx2y/aveDisty2x,5)),'  ', flag];
disp(infstr);  

disp('cost of time (second):');
disp(etime(cls,str));

end