function TestSynthData(dtype,folder,alpha,gamma)
% Tests the data synthesized according to the paper 'Accurate Causal
% Inference on Discrete Data' (Authors: Kailash Budhathoki and Jilles
% Vreeken)
%
% Input:
%   dtype: the type of distance between two probability  distributions
%          'WAS': Wasserstein Distance
%          'KL' : Kullback-Leibler Distance
%          'BD': Bregman Distance
%   folder: the path where the data files are stored
%   alpha: the min size of an effect samples set {Y|X=xi}
%   gamma: the parameter of scaling down 

disp(['alpha = ', num2str(alpha)]);
disp(['gamma = ', num2str(gamma)]);

causeTypes = {'uniform', 'binomial', 'negativeBinomial','geometric', 'hypergeometric', 'poisson', 'multinomial'};
%causeTypes = {'negativeBinomial'};
numTypes = numel(causeTypes);
sucessRecord = zeros(numTypes,1);
errorRecord = zeros(numTypes,1);
undeifnedRecord = zeros(numTypes,1);
for i = 1:numTypes
    for j = 1:1000
        fpth = strcat(folder, '\', causeTypes{1,i}, '_', num2str(j), '_' , 'programming.txt');
        fileID = fopen(fpth,'r');
        formatSpec = '%f %f';
        msize = [2 Inf];
        samplesData = fscanf(fileID,formatSpec,msize);
        fclose(fileID);
        X = samplesData(1,:);
        Y = samplesData(2,:);
        [status,~,~] = mkdir(strcat(folder,'-DebugData','\',causeTypes{1,i}),strcat(causeTypes{1,i},'-',num2str(j)));
        assert(status == 1);       
        prepath = strcat(folder,'-DebugData','\',causeTypes{1,i},'\', causeTypes{1,i},'-',num2str(j),'\');
        
        [caudir,aveDistx2y,aveDisty2x,info] = ECD(dtype,X,Y,alpha,gamma,prepath);
        if strcmp(info,'ok') == 1
            % 判断因果方向的正确性
            if strcmp(caudir, 'X->Y') == 1
                sucessRecord(i) = sucessRecord(i)+1;
                %disp(['sucess   ', '  j = ', num2str(j),'  scorex2y = ', num2str(scorex2y), '  scorey2x = ', num2str(scorey2x)]);
            elseif strcmp(caudir, 'Y->X') == 1
                errorRecord(i) = errorRecord(i)+1;
                %disp(['error    ', '  j = ', num2str(j), '  scorex2y = ', num2str(scorex2y), '  scorey2x = ', num2str(scorey2x)]);
            elseif strcmp(caudir, 'Undeifned') == 1
                undeifnedRecord(i) = undeifnedRecord(i)+1;
                %disp(['undefined', '  j = ', num2str(j), '  scorex2y = ', num2str(scorex2y), '  scorey2x = ', num2str(scorey2x)]);
            end
        else
            errorRecord(i) = errorRecord(i)+1;
        end
    end
        
    numsucess = sucessRecord(i);
    numerror = errorRecord(i);
    numundeifned = undeifnedRecord(i);
    nums = numsucess+numerror+numundeifned;
    disp([causeTypes{1,i},':  ', 'numsucess = ', num2str(numsucess), '  accuracy = ', num2str(numsucess/nums)]);
    disp([causeTypes{1,i},':  ', 'numerror = ', num2str(numerror),  '  errorrate = ', num2str(numerror/nums)]);
    disp([causeTypes{1,i},':  ', 'numundeifned = ', num2str(numundeifned), '  undeifnedrate = ', num2str(numundeifned/nums)]);
    fprintf('\n');
end



