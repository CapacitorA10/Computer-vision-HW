function node = build_tree(data)
if size(data, 1) < 1        % 밑에 더이상 원소가 없으면 리턴
    return;
elseif size(data, 1) == 1   % 원소 하나만 남았다면 노드생성
    node.data = data;
    node.left = []; node.right = [];
else                        % 두개 이상의 원소가 남았다면 split하고 좌우 child 생성
    [vector, point, dim] = find_split(data);
    splitpoint_left = data(data(:,dim) < point, :);     % split point의 차원에서 해당 값보다 작은 값 : leftnode
    splitpoint_right = data(data(:,dim) > point, :);    % split point의 차원에서 해당 값보다 큰 값 : rightnode
    node.dim = dim;
    node.point = point;
    node.vector = vector;
    node.data = data;
    if size(splitpoint_left, 1) > 0        % 밑에 더이상 원소가 없으면 자식노드생성 안함
        node.left = build_tree(splitpoint_left);
    else
        node.left = [];
    end
    if size(splitpoint_right, 1) > 0
    node.right = build_tree(splitpoint_right);
    else
        node.right = [];
    end
end 
end

function [vector, point, dim] = find_split(data)
dim = find(var(data) == max(var(data)));
if rem(size(data,1), 2) == 0
    temp = zeros(size(data)+1);
    temp(1:end-1, 1:end-1) = temp(1:end-1, 1:end-1) + data;
    point = median(temp(1:end,dim));
else
    point = median(data(:,dim));
end
vector = data(data(:,dim) == point, :);
end