function [stck, node] = pop(stck, t)
if sum(abs(stck)) == 0
    disp("Stack Underflow!");
    node = t;
else
    top = max(find(stck));  % 0�̸� ������ ��, -1 Ȥ�� 1�� �κ��� ������ �������Ƿ� 0�� �ƴ� �ִ��� index�� ��ȯ
    stck(1,top) = 0;    % ������ �ֻ����� pop�ϸ鼭 ���ÿ� index�� ����
    j = 1;
    while(~is_leaf(t))
        if stck(1,j) == -1 % ���� node index�� ã���� �������� �̵�
            if isempty(t.left)      % ������ ������ ���̻� ��尡 ������ �ش� ��� ����!
                break;
            else
                t = t.left;
            end
        elseif stck(1,j) == 1 % 1�� �����̴ϱ�
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