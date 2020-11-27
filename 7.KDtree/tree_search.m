function [nearist_tree, stck, t] = tree_search(t, test)
j = 1;
stck = zeros(1,100);
while(~is_leaf(t))
    if test(t.dim) < t.point
        if isempty(t.left)      % 그쪽으로는 갈일 없으므로,
            break;
        else
            stck(1,j) = -1;     % stack : 포인터로 구현이 힘들어 대신 INDEX저장 (-1:left, +1:right) 하여 stack처럼 활용
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
if ~(size(t.data,1) == 1)           % left 혹은 right child 둘중 하나만 있고, 거기로 갈 일 없을 때 지금 노드 대입
    nearist_tree(1,:) = t.vector;
else
    nearist_tree(1,:) = t.data;
end
end