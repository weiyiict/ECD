function [sucnum,errnum]=TestTuebingenData(dtype,alpha,gamma)
% Tests the data in Tuebingen Cause-Effect benchmark.
%
% Input:
%   dtype: the type of distance between two probability  distributions
%          'WAS': Wasserstein Distance
%          'KL' : Kullback-Leibler Distance
%          'BD': Bregman Distance
%   alpha: the min size of an effect samples set {Y|X=xi}
%   gamma: the parameter of scaling down 
% Output:
%  sucnum: the number of success
%  errnum: the number of error

% create the filename of data and the path where the data is storedy
disp(['alpha = ', num2str(alpha)]);
disp(['gamma = ', num2str(gamma)]);
filepaths = cell(1,108);
for i = 1:108
    str1 = int2str(i);
    if i <= 9
        str2 = strcat('Tuebingen-Cause-Effect-Pairs\pair000',str1,'.txt');      
    elseif i >=10 && i <= 99
        str2 = strcat('Tuebingen-Cause-Effect-Pairs\pair00',str1,'.txt');
    else
        str2 = strcat('Tuebingen-Cause-Effect-Pairs\pair0',str1,'.txt');
    end 
    filepaths{1,i} = str2;
end

% set true directions
truedir = cell(1,108);
for i = 1:108
    truedir{1,i} = 'X->Y';
end

for i = 47:53
    truedir{1,i} = 'Y->X';
end

for i = 55:63
    truedir{1,i} = 'Y->X';
end

for i = 68:69
    truedir{1,i} = 'Y->X';
end   

truedir{1,73} = 'Y->X';
truedir{1,75} = 'Y->X';
truedir{1,77} = 'Y->X';
truedir{1,79} = 'Y->X';
truedir{1,80} = 'Y->X';
truedir{1,84} = 'Y->X';
truedir{1,89} = 'Y->X';
truedir{1,90} = 'Y->X';
truedir{1,92} = 'Y->X';
truedir{1,99} = 'Y->X';
truedir{1,106} = 'Y->X';
truedir{1,108} = 'Y->X';
 
errnum = 0;
sucnum = 0;
folder = 'Tuebingen-Cause-Effect-Pairs';
for i = 1:108
    if (i == 12 || i == 17 || i == 22 || i == 23 || i == 24 || i == 39 || ...
    i == 40 || i == 41 || i == 47 || i == 64 || i==68 || i == 74 || i == 75 || ...
    i == 86 || i == 99 || i == 101 || i == 102 || i == 103 || i == 104|| i == 106 )
        [X,Y] = ReadTuebingenData(filepaths{1,i});
        newStr = strsplit(filepaths{1,i},'\');
        newStr = strsplit(newStr{1,2},'.');
        filename = newStr{1,1};
        [status,~,~] = mkdir(folder,filename);
        assert(status == 1);
        prepath = strcat(folder,'\',filename,'\');
        str = clock;
        [caudir,aveDistx2y,aveDisty2x,info] = ECD(dtype,X,Y,alpha,gamma,prepath);
        cls = clock;
        if strcmp(info,'ok') == 1
            if strcmp(truedir{1,i},caudir) == 1
                sucnum = sucnum+1;
                flag = '  Success';
            else
                errnum = errnum+1;
                flag =  '  Error';
            end
            infstr = [filename,' ', caudir,'  aveDistx2y = ', num2str(round(aveDistx2y,5)), '  aveDisty2x = ',...
                num2str(round(aveDisty2x,5)),'  aveDistx2y/aveDisty2x = ', num2str(round(aveDistx2y/aveDisty2x,5)),'  ', flag];
        else
            errnum = errnum+1;
            infstr = [filename,' ',info];
        end
        disp(infstr);
        fprintf('\n');
        disp('cost of time (second):');
        disp(etime(cls,str));
    end
end

disp(['sucnum is  ',num2str(sucnum)]);
disp(['errnum is  ',num2str(errnum)]);
disp(['accuracy on TuebingenData is  ',num2str(100*sucnum/(errnum+sucnum)),'%']);
end
