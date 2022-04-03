function Experiments()
alpha = 7;
gamma = 2;

% do test on syhthetic datasets where the number of samples is 1000.
folder = 'SythData20210621';
disp(['TestSynthData: ',folder]);
TestSynthData('WAS',folder,alpha,gamma); % ECD
TestSynthData('KL',folder,alpha,gamma);  % EKL
TestSynthData('BD',folder,alpha,gamma);  % EBD

% do test on UCI' datasets
TestUCIData('WAS',alpha,gamma); % ECD
TestUCIData('KL',alpha,gamma);  % EKL
TestUCIData('BD',alpha,gamma);  % EBD

% do test on Tubingen's  datasets
TestTuebingenData('WAS',alpha,gamma); % ECD
TestTuebingenData('KL',alpha,gamma);  % EKL
TestTuebingenData('BD',alpha,gamma);  % EBD

end