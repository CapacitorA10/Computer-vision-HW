clc; clear; close all;

num = 1000;

%% MLP
err_temp = 0;
acc_temp = 0;
error_q = 0;
acc_q = 0;
w1 = 2*rand(50,400) -1;                                                    % 400개의 입력 50개의 퍼셉트론
w2 = 2*rand(50,50) -1;                                                     % 50개의 입력, 50개의 퍼셉트론
w3 = 2*rand(10,50) -1;
BIAS = 1;
bias1 = 2*rand -1;
bias2 = 2*rand -1;
eta = 0.1; %학습률

for epoch = 1 : 100
    
    Err = 0;
    %% Training
    [img, labels] = readMNIST('train_images.idx3-ubyte', ...
        'train_labels.idx1-ubyte', num, randi(50000)-num);
    img = reshape(img,1,[],[num]);
    labels = padarray(labels,[0,9],'post');
    for i = 1 : 1 : num
        switch labels(i, 1)
            case 1
                labels(i, :) = [0 0 0 0 0 0 0 0 0 1];
            case 2
                labels(i, :) = [0 0 0 0 0 0 0 0 1 0];
            case 3
                labels(i, :) = [0 0 0 0 0 0 0 1 0 0];
            case 4
                labels(i, :) = [0 0 0 0 0 0 1 0 0 0];
            case 5
                labels(i, :) = [0 0 0 0 0 1 0 0 0 0];
            case 6
                labels(i, :) = [0 0 0 0 1 0 0 0 0 0];
            case 7
                labels(i, :) = [0 0 0 1 0 0 0 0 0 0];
            case 8
                labels(i, :) = [0 0 1 0 0 0 0 0 0 0];
            case 9
                labels(i, :) = [0 1 0 0 0 0 0 0 0 0];
            case 0
                labels(i, :) = [1 0 0 0 0 0 0 0 0 0];
        end
    end
    labels = labels';
    for k = 1 : num
        x = img(:,:,k)';
        v1 = (w1 * x) + (BIAS * bias1);
        y1 = Sigmoid(v1);
        % 1st perceptron passed
        
        v2 = (w2 * y1) + (BIAS * bias2);
        y2 = Sigmoid(v2);
        % 2st perceptron passed
        
        v3 = w3 * y2;
        y3 = my_softmax(v3);
        % output layer passed
        
        % backpropagation 1
        e3 = labels(:,k) - y3;
        delta = e3;
        
        % backpropagation 2
        e2 = w3'*delta;
        delta1 = y2 .* (1-y2) .* e2;
        
        %backpropagation 3
        e1 = w2'*delta1;
        delta2 = y1 .* (1-y1) .* e1;
        
        %backpropation 1_2
        dw1 = -delta2 * x';
        w1 = w1 - eta * dw1;
        bias1 = bias1 + eta * delta2;
        
        %backpropation 2_2
        dw2 = -delta1 * y1';
        w2 = w2 - eta * dw2;
        bias2 = bias2 + eta * delta1;
        
        %backpropation 3_2
        dw3 = -delta * y2';
        w3 = w3 - eta * dw3;
        Err = Err + sum(abs(e3));
    end
    eta = eta * 0.96;
    
    %% test data
    [imgT, labelsT] = readMNIST('t10k_images.idx3-ubyte', ...
        't10k_labels.idx1-ubyte', num, randi(10000)-num);
    imgT = reshape(imgT,1,[],[num]);
    labelsT = padarray(labelsT,[0,9],'post');
    for i = 1 : 1 : num
        switch labelsT(i, 1)
            case 1
                labelsT(i, :) = [0 0 0 0 0 0 0 0 0 1];
            case 2
                labelsT(i, :) = [0 0 0 0 0 0 0 0 1 0];
            case 3
                labelsT(i, :) = [0 0 0 0 0 0 0 1 0 0];
            case 4
                labelsT(i, :) = [0 0 0 0 0 0 1 0 0 0];
            case 5
                labelsT(i, :) = [0 0 0 0 0 1 0 0 0 0];
            case 6
                labelsT(i, :) = [0 0 0 0 1 0 0 0 0 0];
            case 7
                labelsT(i, :) = [0 0 0 1 0 0 0 0 0 0];
            case 8
                labelsT(i, :) = [0 0 1 0 0 0 0 0 0 0];
            case 9
                labelsT(i, :) = [0 1 0 0 0 0 0 0 0 0];
            case 0
                labelsT(i, :) = [1 0 0 0 0 0 0 0 0 0];
        end
    end
    labelsT = labelsT';
    acc = 0; accn = 0;
    for i = 1 : num
        v1 = w1 * imgT(:,:,i)';
        y1 = Sigmoid(v1);
        v2 = w2 * y1;
        y2 = Sigmoid(v2);
        v = w3 * y2;
        y3 = softmax(v);
        [max_val, max_idx] = max(y3);
        [ans_val, ans_idx] = max(labelsT(:,i));
        
        if (max_idx == ans_idx)
            acc = acc + 1;
        else
            accn = accn + 1;
        end
    end
    acc_output = 100*(acc / (acc + accn));
    error(1,epoch) = Err;
    acc_graph(1,epoch) = acc_output;
    
    %         fprintf("%d       err: %f       accuracy for samples: %.1f%%\n", epoch, Err,acc_output);
    fprintf("%d   %d%%\n", j,epoch);
end

error_q = error_q + error;
acc_q = acc_q + acc_graph;
%% OUTPUT


plot(error_q/(num/50), 'r'); hold on;
plot(acc_q, 'k');
% title("Accuracy & Errors 200 by 200");
grid on;
legend({'error','accuracy'},'Location','southwest'); axis([0,100,0,100]); hold off;
















