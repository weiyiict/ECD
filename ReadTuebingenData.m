function [X,Y] = ReadTuebingenData(filepath)
% Reads the Tuebingen Cause-Effect Pairs
% Input:
%  filepath: the data file is stored under filepath 
% Output:
%   X: the first column of read data in most cases 
%   Y: the second column of read data in most cases

fileID = fopen(filepath,'r');
newStr = strsplit(filepath,'\');
filename = newStr(1,2);
% There are three columns in pair0081.txt£¬pair0082.txt£¬pair0083.txt.
if strcmp(filename, 'pair0081.txt') == 1 || strcmp(filename, 'pair0082.txt') == 1 || strcmp(filename, 'pair0083.txt') ==1
    formatSpec = '%f %f %f';
    sizeA = [3 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = A(1,:);
    Y = A(2,:);
elseif strcmp(filename, 'pair0052.txt') == 1 % There are eight columns in pair0052.txt. 
    formatSpec = '%f %f %f %f %f %f %f %f';
    sizeA = [8 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = A(1:4,:);
    Y = A(5:8,:);
elseif strcmp(filename, 'pair0053.txt') == 1 % There are four columns in pair0053.txt. 
    formatSpec = '%f %f %f %f';
    sizeA = [4 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = A(1,:);
    Y = A(2:4,:);
elseif strcmp(filename, 'pair0054.txt') == 1  % There are five columns in pair0054.txt. 
    formatSpec = '%f %f %f %f %f';
    sizeA = [5 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = A(1:3,:);
    Y = A(4:5,:);
elseif strcmp(filename, 'pair0055.txt') == 1  % There are thirty-two columns in pair0055.txt. 
    formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
    sizeA = [32 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = [];%A(1:31,:);
    Y = [];%A(32,:);
elseif strcmp(filename, 'pair0071.txt') == 1 % There are eight columns in pair0071.txt. 
    formatSpec = '%f %f %f %f %f %f %f %f';
    sizeA = [8 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = A(1:6,:);
    Y = A(7:8,:);
elseif strcmp(filename, 'pair0105.txt') == 1 % There are ten columns in pair0105.txt.
    formatSpec = '%f %f %f %f %f %f %f %f %f %f';
    sizeA = [10 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = A(1:9,:);
    Y = A(10,:);
else
    % There are two columns in others
    formatSpec = '%f %f';
    sizeA = [2 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    % pick up X and Y
    X = A(1,:);
    Y = A(2,:);
end
end