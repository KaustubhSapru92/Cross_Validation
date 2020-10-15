clear all
clc

[x, fs] = audioread("v1.wav");
[y, fsy] = audioread('s1.wav');

x1 = x(:,1);
y1 = y(:,1);

folds = 5; 
T = length(x1);
%%

list_Q = [500:10:1000]; %defining Q's range
%pre-allocating error variables
mse_train = zeros(folds, length(list_Q));
mse_test = mse_train;
%defining indexes that will partition the data
for i = 1:folds
    disp('Fold')
    %test data set indices
    test_index= T/folds*(i-1)+(1:round(T/folds));
    %train data set indices
    train_index = 1:T;
    train_index(test_index) = [];
    
    %training datasets
    x1train = x1(train_index);
    y1train = y1(train_index);
    
    %test datasets
    x1test = x1(test_index);
    y1test = y1(test_index);
    
    for index_Q = 1:size(list_Q, 2)
        Q = list_Q(index_Q);
        % defining the toeplitz matrix
        X1train = toeplitz(x1train,[x1train(1) zeros(1,Q)]);
        X1test = toeplitz(x1test,[x1test(1) zeros(1,Q)]);
        %Model
        b = X1train\y1train;
        %Computing the error
        etrain = y1train - X1train*b;
        etest = y1test - X1test*b;
        %msetrain(Q) = mean(etrain.^2);
        %msetest(Q) = mean(etest.^2);
        
        %Taking error for each fold
        mse_train(i, index_Q) = mean(etrain.^2);
        mse_test(i, index_Q) = mean(etest.^2);
    end
end
%averaging the errors
final_mse_train = mean(mse_train, 1);
final_mse_test = mean(mse_test, 1);
%%
%plottng the train and test errors
plot([final_mse_train' final_mse_test'])
legend({'mse train', 'mse test'});

%%
% finding the order of Q which has least test error
for i = 500: 1000
    if final_mse_test(i) == min(final_mse_test)
        min_test_error = final_mse_test(i)
        A =i
    end
end
%%
%A = min_test_error
B = toeplitz(x1,[x1(1) zeros(1,A)]);
hlse = B\y1

%Q = numel(hlse) % length of impulse response

yest =  filter(hlse,1,x1);

residual = y1 - yest;

subplot(2,2,1)
plot(x1)

ylabel('Amplitude')
subplot(2,2,2)
plot(y1)
ylabel('Amplitude')
hold on 
plot(residual)
hold off