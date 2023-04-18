clear
close all
clc

%% Defining parameters

%letters to be classified: A, E, I, O, U
N = 120; %total number of letters
No = 100; %the number of letters to be placed in the training set
Nt = 20; %the number of letters to be placed in the test set
numAttributes = 5; %number of features for classification
numClasses = 5;
X = zeros(numAttributes, N);
X1 = X; X2 = X; X3 = X; X4 = X; X5 = X;

%% Ucitavanje slika i predobrada slika

for i = 1:N
    %loading letters A
    x = imread(['baseA' num2str(i,'%03d') '.bmp']);
    %defining features for a letter A
    X1(:, i) = features(x);
     
    %loading letters E
    x = imread(['baseE' num2str(i,'%03d') '.bmp']);
    %defining features for a letter E
    X2(:, i) = features(x);
    
    %loading letters I
    x = imread(['baseI' num2str(i,'%03d') '.bmp']);
    %defining features for a letter I
    X3(:, i) = features(x);
    
    %loading letters O
    x = imread(['baseO' num2str(i,'%03d') '.bmp']);
    %defining features for a letter O
    X4(:, i) = features(x);
    
    %loading letters U
    x = imread(['baseU' num2str(i,'%03d') '.bmp']);
    %defining features for a letter U
    X5(:, i) = features(x);
end

%% Randomization and division of data into training and testing sets for each class individually

ind = randperm(N);

O1 = X1(:, ind(1:No)); T1 = X1(:, ind(No + 1:N));
O2 = X2(:, ind(1:No)); T2 = X2(:, ind(No + 1:N));
O3 = X3(:, ind(1:No)); T3 = X3(:, ind(No + 1:N));
O4 = X4(:, ind(1:No)); T4 = X4(:, ind(No + 1:N));
O5 = X5(:, ind(1:No)); T5 = X5(:, ind(No + 1:N));

%% Classifier design

%proposal: multiple hypothesis test, Bayesian classifier
%assumption for fgv is that they are Gaussian

M1 = mean(O1, 2); S1 = cov(O1');
M2 = mean(O2, 2); S2 = cov(O2');
M3 = mean(O3, 2); S3 = cov(O3');
M4 = mean(O4, 2); S4 = cov(O4');
M5 = mean(O5, 2); S5 = cov(O5');

%% Testing the classifier

confusionMatrix = zeros(numClasses, numClasses); %confusion matrix
for k = 1:numClasses
    if k == 1
        T = T1;
    elseif k == 2
        T = T2;
    elseif k == 3
        T = T3;
    elseif k == 4
        T = T4;
    elseif k == 5
        T = T5;
    end
    for i = 1:(Nt)
        x = T(:, i);
        f1 = 1/(2*pi*det(S1)^0.5)*exp(-0.5*(x - M1)'*S1^(-1)*(x - M1));
        f2 = 1/(2*pi*det(S2)^0.5)*exp(-0.5*(x - M2)'*S2^(-1)*(x - M2));
        f3 = 1/(2*pi*det(S3)^0.5)*exp(-0.5*(x - M3)'*S3^(-1)*(x - M3));
        f4 = 1/(2*pi*det(S4)^0.5)*exp(-0.5*(x - M4)'*S4^(-1)*(x - M4));
        f5 = 1/(2*pi*det(S5)^0.5)*exp(-0.5*(x - M5)'*S5^(-1)*(x - M5));
        maxF = max([f1 f2 f3 f4 f5]);
        if maxF == f1
            confusionMatrix(k, 1) = confusionMatrix(k, 1) + 1;
            disp(['Letter ' num2str(i) ' from class' num2str(k) ' is recognized as a letter A']);
        elseif maxF == f2
            confusionMatrix(k, 2) = confusionMatrix(k, 2) + 1;
            disp(['Letter ' num2str(i) ' from class' num2str(k) ' is recognized as a letter E']);
        elseif maxF == f3
            confusionMatrix(k, 3) = confusionMatrix(k, 3) + 1;
            disp(['Letter ' num2str(i) ' from class ' num2str(k) ' is recognized as a letter I']);
        elseif maxF == f4
            confusionMatrix(k, 4) = confusionMatrix(k, 4) + 1;
            disp(['Letter ' num2str(i) ' from class ' num2str(k) ' is recognized as a letter O']);
        elseif maxF == f5
            confusionMatrix(k, 5) = confusionMatrix(k, 5) + 1;
            disp(['Letter ' num2str(i) ' from class ' num2str(k) ' is recognized as a letter U']);
        end
    end
end

%% Display results

disp('Confusion matrix: ');
disp('     A     E     I     O     U');
disp('    ---------------------------');
disp(confusionMatrix')
error = (sum(sum(confusionMatrix)) - trace(confusionMatrix))/sum(sum(confusionMatrix));
disp(['The total classification error is: ' num2str(error)]);

