function nearist = backtracking_kdtree(t, tree, test)


[nearist_tree(1,:), stck(1,:), t] = tree_search(t, test);   % tree ��ȸ�� �̿��� �ֱ��� ����, �׿� ���� index�� stack�� ������ ��, �׸��� t�� �� tree
%% �ֱ��� �̿�(Tree+Backtracking)
current_best = inf;
nearist = [];
[~, distanceT] = dsearchn(nearist_tree(1,:), test);  %tree�� �з��� �ֱ��� ���ϰ� k���ϰ��� �Ÿ� ���� ���
if distanceT < current_best
    current_best = distanceT;
    nearist = t;
end
while sum(abs(stck(1,:)))    % Backtracking, ������ ��� pop�ϸ� break
    % 1���� stck �� ����� leaf����� �θ������ pop �ݺ�
    [stck(1,:), node] = pop(stck(1,:), tree);
    [~, distanceT] = dsearchn(node.vector, test);   % ���ÿ��� pop�� ���� �׽�Ʈ�ϴ� ������ �Ÿ�
    if distanceT < current_best
        current_best = distanceT;
        nearist = node;
    end
    [~, dot2plane] = dsearchn(node.vector(node.dim), test(node.dim)); % �׽�Ʈ ���Ϳ��� ���� ����� ���� �������� �Ÿ�
    
    
    if dot2plane < current_best % ���� �������� �Ÿ��� �� �����ٸ� �ǳ��� �� ����� ���� ���� ���ɼ� ����
        %% other side node Ž��
        
        if (node.point < test(node.dim)) && ~isempty(node.left)  % ����Ʈ���� ũ�Ƿ� ������ rightchild����, leftchild�� Ž��
            temp_nearist = backtracking_kdtree(node.left, node.left, test);
            if size(temp_nearist.data,1) == 1    % leaf����� �� �� ��ȯ
                [~, d] = dsearchn(temp_nearist.data, test);                  % �ݴ��� Ž�� ���, ���� �ֱ��� ������ ���� ���� �߽߰� �� ������ ����!
                if d < current_best
                    nearist = temp_nearist;
                    current_best = d;
                end
            else    % �߰� ��忡�� �ֱ��� �� ã���� �� �� ���� ��ȯ
                [~, d] = dsearchn(temp_nearist.vector, test);
                if d < current_best
                    nearist = temp_nearist;
                    current_best = d;
                end
            end
            % ���� ����
        elseif (node.point > test(node.dim)) && ~isempty(node.right)
            temp_nearist = backtracking_kdtree(node.right, node.right, test);
            if size(temp_nearist.data,1) == 1    % leaf����� �� �� ��ȯ
                [~, d] = dsearchn(temp_nearist.data, test);
                if d < current_best
                    nearist = temp_nearist;
                    current_best = d;
                end
            else
                [~, d] = dsearchn(temp_nearist.vector, test);
                if d < current_best
                    nearist = temp_nearist;
                    current_best = d;
                end
            end
        end
    end

end
end
