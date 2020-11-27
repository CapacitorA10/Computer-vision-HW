function [stck, node] = pop(stck, t)
if sum(abs(stck)) == 0
    disp("Stack Underflow!");
    node = t;
else
    top = max(find(stck));  % 0이면 스택이 빔, -1 혹은 1인 부분은 스택이 차있으므로 0이 아닌 최대의 index를 반환
    stck(1,top) = 0;    % 스택의 최상위를 pop하면서 동시에 index도 변경
    j = 1;
    while(~is_leaf(t))
        if stck(1,j) == -1 % 좌측 node index를 찾으면 좌측으로 이동
            if isempty(t.left)      % 하지만 좌측에 더이상 노드가 없으면 해당 노드 리턴!
                break;
            else
                t = t.left;
            end
        elseif stck(1,j) == 1 % 1은 우측이니까
            if isempty(t.left)
                break;
            else
                t = t.right;
            end
        elseif stck(1,j) == 0
            break;
        end
        j = j + 1;
    end
    node = t;
end
end