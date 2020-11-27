function [nearist_tree, stck, t] = tree_search(t, test)
j = 1;
stck = zeros(1,100);
while(~is_leaf(t))
    if test(t.dim) < t.point
        if isempty(t.left)      % �������δ� ���� �����Ƿ�,
            break;
        else
            stck(1,j) = -1;     % stack : �����ͷ� ������ ����� ��� INDEX���� (-1:left, +1:right) �Ͽ� stackó�� Ȱ��
            t = t.left;
        end
    else
        if isempty(t.left)
            break;
        else
            stck(1,j) = 1;
            t = t.right;
        end
    end
    j = j + 1;
end
if ~(size(t.data,1) == 1)           % left Ȥ�� right child ���� �ϳ��� �ְ�, �ű�� �� �� ���� �� ���� ��� ����
    nearist_tree(1,:) = t.vector;
else
    nearist_tree(1,:) = t.data;
end
end