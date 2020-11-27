function [output] = my_demosaic(input)

    output = zeros([size(input),3]);
    [row,col] = size(output(:,:,1));
    % ����ũ ����
    maskR = kron(ones([row/2, col/2]), [1 0; 0 0]);
    maskG = kron(ones([row/2, col/2]), [0 1; 1 0]);
    maskB = kron(ones([row/2, col/2]), [0 0; 0 1]);
    
    %����ũ�� ���� R, G, B������ ����
    valueR = input.*maskR;
    valueG = input.*maskG;
    valueB = input.*maskB;

    %% RED ���� demosaicking 
    for j = 1 : row
        for i = 1 : col
            if (rem(j,2) == 1) && (rem(i,2) == 0) % Ȧ����, ¦����
                if i == col
                    valueR(j,i) = valueR(j, i-1);
                else
                valueR(j,i) = (valueR(j, i-1) + valueR(j, i+1)) / 2;
                end

            elseif (rem(j,2) == 0) && (rem(i,2) == 1) % ¦����, Ȧ����
                if j == row
                    valueR(j,i) = valueR(j-1,i);
                else
                valueR(j,i) = (valueR(j-1, i) + valueR(j+1, i)) / 2;
                end

            elseif (rem(j,2) == 0) && (rem(i,2) == 0) % ¦����, ¦����
                if (i == col) && (j ~= row)
                    valueR(j,i) = (valueR(j-1, i-1) + valueR(j+1, i-1)) / 2;
                elseif (j == row) && (i ~= col)
                    valueR(j,i) = (valueR(j-1, i-1) +valueR(j-1, i+1)) / 2;
                elseif (j == row) && (i == col)
                    valueR(j,i) = valueR(j-1, i-1);
                else
                    valueR(j,i) = (valueR(j-1, i-1) + valueR(j-1, i+1) + ...
                    valueR(j+1, i-1) + valueR(j+1, i+1)) / 4;
                end
            end
        end
    end

    %% BLUE ���� demoaicking 
    for j = 1 : row
        for i = 1 : col
            if (rem(j,2) == 1) && (rem(i,2) == 0) % Ȧ����, ¦����
                if j == 1
                    valueB(j,i) = valueB(j+1, i);
                else
                valueB(j,i) = (valueB(j+1, i) + valueB(j-1, i)) / 2;
                end

            elseif (rem(j,2) == 0) && (rem(i,2) == 1) % ¦����, Ȧ����
                if i == 1
                    valueB(j,i) = valueB(j,i+1);
                else
                valueB(j,i) = (valueB(j, i+1) + valueB(j, i-1)) / 2;
                end

            elseif (rem(j,2) == 1) && (rem(i,2) == 1) % Ȧ����, Ȧ����
                if (i == 1) && (j == 1)
                    valueB(j,i) = valueB(j+1, i+1);
                elseif i == 1
                    valueB(j,i) = (valueB(j+1, i+1) +valueB(j-1, i+1)) / 2;
                elseif j == 1
                    valueB(j,i) = (valueB(j+1, i+1) + valueB(j+1, i-1)) / 2;
                else
                    valueB(j,i) = (valueB(j-1, i-1) + valueB(j-1, i+1) + ...
                    valueB(j+1, i-1) + valueB(j+1, i+1)) / 4;
                end
            end
        end
    end

    %% GREEN ���� demosaicking 
    for j = 1 : row
        for i = 1 : col
            if ((rem(j,2) == 1) && (rem(i,2) == 1) || (rem(j,2) == 0) && (rem(i,2) == 0))% ¦¦ or ȦȦ
                if (i == 1) && (j == 1)
                    valueG(j,i) = (valueG(j+1, i) + valueG(j, i+1)) / 2;
                elseif i == 1
                    valueG(j,i) = (valueG(j+1, i) +valueG(j-1, i) + valueG(j, i+1)) / 3;
                elseif j == 1
                    valueG(j,i) = (valueG(j+1, i) + valueG(j, i+1) + valueG(j, i-1)) / 3;
                elseif i == col && j == row
                    valueG(j,i) = (valueG(j-1, i) + valueG(j, i-1)) / 2;
                elseif i == col
                    valueG(j,i) = (valueG(j-1, i) + valueG(j+1, i) + valueG(j, i-1)) / 3;
                elseif j == row
                    valueG(j,i) = (valueG(j, i-1) + valueG(j, i+1) + valueG(j-1, i)) / 3;
                else
                    valueG(j,i) = (valueG(j, i-1) + valueG(j, i+1) + ...
                    valueG(j+1, i) + valueG(j-1, i)) / 4;
                end
            end
        end
    end

    output(:,:,1) = valueR;
    output(:,:,2) = valueG;
    output(:,:,3) = valueB;
end
