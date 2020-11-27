function nearist = backtracking_kdtree(t, tree, test)


[nearist_tree(1,:), stck(1,:), t] = tree_search(t, test);   % tree 순회를 이용한 최근점 점과, 그에 대한 index를 stack에 저장한 값, 그리고 t는 그 tree
%% 최근접 이웃(Tree+Backtracking)
current_best = inf;
nearist = [];
[~, distanceT] = dsearchn(nearist_tree(1,:), test);  %tree가 분류한 최근접 점하고 k점하고의 거리 차이 계산
if distanceT < current_best
    current_best = distanceT;
    nearist = t;
end
while sum(abs(stck(1,:)))    % Backtracking, 스택을 모두 pop하면 break
    % 1부터 stck 에 저장된 leaf노드의 부모노드까지 pop 반복
    [stck(1,:), node] = pop(stck(1,:), tree);
    [~, distanceT] = dsearchn(node.vector, test);   % 스택에서 pop한 노드와 테스트하는 점과의 거리
    if distanceT < current_best
        current_best = distanceT;
        nearist = node;
    end
    [~, dot2plane] = dsearchn(node.vector(node.dim), test(node.dim)); % 테스트 벡터에서 현재 노드의 분할 평면까지의 거리
    
    
    if dot2plane < current_best % 분할 평면까지의 거리가 더 가깝다면 건너편에 더 가까운 점이 있을 가능성 있음
        %% other side node 탐색
        
        if (node.point < test(node.dim)) && ~isempty(node.left)  % 포인트보다 크므로 원래는 rightchild지만, leftchild도 탐색
            temp_nearist = backtracking_kdtree(node.left, node.left, test);
            if size(temp_nearist.data,1) == 1    % leaf노드라면 그 점 반환
                [~, d] = dsearchn(temp_nearist.data, test);                  % 반대쪽 탐색 결과, 현재 최근접 값보다 작은 값을 발견시 그 점으로 변경!
                if d < current_best
                    nearist = temp_nearist;
                    current_best = d;
                end
            else    % 중간 노드에서 최근접 점 찾았을 땐 그 점을 반환
                [~, d] = dsearchn(temp_nearist.vector, test);
                if d < current_best
                    nearist = temp_nearist;
                    current_best = d;
                end
            end
            % 이하 동문
        elseif (node.point > test(node.dim)) && ~isempty(node.right)
            temp_nearist = backtracking_kdtree(node.right, node.right, test);
            if size(temp_nearist.data,1) == 1    % leaf노드라면 그 점 반환
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
