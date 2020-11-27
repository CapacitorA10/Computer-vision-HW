clear; clc; close all;

datasize = 16383;
ksize = 500;
dataset = rand(datasize,3);
kdataset = rand(ksize,3);
tree = build_tree(dataset);   
%% 최근접 점 찾기 (유클리드 거리)
tic
dist = ones(1,datasize);
index_k = zeros(1,ksize);
for i = 1 : ksize
    for j = 1 : datasize
        dist(j) = norm(kdataset(i,:) - dataset(j,:));
    end
    index_k(i) = find(dist == min(dist));
end
nearist_dot = dataset(index_k,:); 
disp("벡터 노름 이용하여 계산 : "); toc
%% 최근접 이웃 탐색
tic
nearist_tree = zeros(ksize,3);
for i = 1 : ksize
    [nearist_tree(i,:)] = tree_search(tree, kdataset(i,:)); % tree를 이용한 최근접 점
end
disp("Tree 순전파 이용하여 계산 : "); toc

tic
nearist_bt = zeros(ksize,3);
for i = 1 : ksize
    bt_result = backtracking_kdtree(tree, tree, kdataset(i,:)); % backtracking을 이용한 최근접 점
    if size(bt_result.data, 1) > 1
        nearist_bt(i,:) = bt_result.vector;
    else
        nearist_bt(i,:) = bt_result.data;
    end
end
disp("Tree Backtracking 이용하여 계산 : "); toc

tree_dist = mean(abs(nearist_dot - nearist_tree));
bt_dist = mean(abs(nearist_dot - nearist_bt));

correct_tree = size(find(sum(nearist_dot - nearist_tree, 2)),1);
correct_bt = size(find(sum(nearist_dot - nearist_bt, 2)),1);
accu_tr = (ksize - correct_tree) / ksize
accu_bt = (ksize - correct_bt) / ksize

%% Tree 플롯하기

datasetLLLL = tree.left.left.left.left.data;
datasetLLLR = tree.left.left.left.right.data;
datasetLLRL = tree.left.left.right.left.data;
datasetLLRR = tree.left.left.right.right.data;
datasetLRLL = tree.left.right.left.left.data;
datasetLRLR = tree.left.right.left.right.data;
datasetLRRL = tree.left.right.right.left.data;
datasetLRRR = tree.left.right.right.right.data;

datasetRRRR = tree.right.right.right.right.data;
datasetRRRL = tree.right.right.right.left.data;
datasetRRLR = tree.right.right.left.right.data;
datasetRRLL = tree.right.right.left.left.data;
datasetRLRR = tree.right.left.right.right.data;
datasetRLRL = tree.right.left.right.left.data;
datasetRLLR = tree.right.left.left.right.data;
datasetRLLL = tree.right.left.left.left.data;



scatter3(datasetLLLL(:,1), datasetLLLL(:,2), datasetLLLL(:,3) ); hold on;
scatter3(datasetLLLR(:,1), datasetLLLR(:,2), datasetLLLR(:,3) ); 
scatter3(datasetLLRL(:,1), datasetLLRL(:,2), datasetLLRL(:,3) ); 
scatter3(datasetLLRR(:,1), datasetLLRR(:,2), datasetLLRR(:,3) ); 
scatter3(datasetLRLL(:,1), datasetLRLL(:,2), datasetLRLL(:,3) ); 
scatter3(datasetLRLR(:,1), datasetLRLR(:,2), datasetLRLR(:,3) ); 
scatter3(datasetLRRL(:,1), datasetLRRL(:,2), datasetLRRL(:,3) ); 
scatter3(datasetLRRR(:,1), datasetLRRR(:,2), datasetLRRR(:,3) ); 

scatter3(datasetRRRR(:,1), datasetRRRR(:,2), datasetRRRR(:,3) ); 
scatter3(datasetRRRL(:,1), datasetRRRL(:,2), datasetRRRL(:,3) ); 
scatter3(datasetRRLR(:,1), datasetRRLR(:,2), datasetRRLR(:,3) ); 
scatter3(datasetRRLL(:,1), datasetRRLL(:,2), datasetRRLL(:,3) ); 
scatter3(datasetRLRR(:,1), datasetRLRR(:,2), datasetRLRR(:,3) ); 
scatter3(datasetRLRL(:,1), datasetRLRL(:,2), datasetRLRL(:,3) ); 
scatter3(datasetRLLR(:,1), datasetRLLR(:,2), datasetRLLR(:,3) ); 
scatter3(datasetRLLL(:,1), datasetRLLL(:,2), datasetRLLL(:,3) ); 








