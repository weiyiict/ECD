function Experiments()
alpha = 7;
gamma = 2;
% do test on UCI' datasets
TestUCIData('WAS',alpha,gamma); % ECD
TestUCIData('KL',alpha,gamma);  % EKL
TestUCIData('BD',alpha,gamma);  % EBD

% do test on Tubingen's  datasets
TestTuebingenData('WAS',alpha,gamma); % ECD
TestTuebingenData('KL',alpha,gamma);  % EKL
TestTuebingenData('BD',alpha,gamma);  % EBD

end