function node = build_tree(data)
if size(data, 1) < 1        % �ؿ� ���̻� ���Ұ� ������ ����
    return;
elseif size(data, 1) == 1   % ���� �ϳ��� ���Ҵٸ� ������
    node.data = data;
    node.left = []; node.right = [];
else                        % �ΰ� �̻��� ���Ұ� ���Ҵٸ� split�ϰ� �¿� child ����
    [vector, point, dim] = find_split(data);
    splitpoint_left = data(data(:,dim) < point, :);     % split point�� �������� �ش� ������ ���� �� : leftnode
    splitpoint_right = data(data(:,dim) > point, :);    % split point�� �������� �ش� ������ ū �� : rightnode
    node.dim = dim;
    node.point = point;
    node.vector = vector;
    node.data = data;
    if size(splitpoint_left, 1) > 0        % �ؿ� ���̻� ���Ұ� ������ �ڽĳ����� ����
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