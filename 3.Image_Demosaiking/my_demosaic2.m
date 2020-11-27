function [output] = my_demosaic2(input, sigma)

    output = zeros([size(input),3]);
    [row,col] = size(output(:,:,1));
    % ¸¶½ºÅ© »ý¼º
    maskR = kron(ones([row/2, col/2]), [1 0; 0 0]);
    maskG = kron(ones([row/2, col/2]), [0 1; 1 0]);
    maskB = kron(ones([row/2, col/2]), [0 0; 0 1]);
    
    %¸¶½ºÅ©¸¦ ÅëÇØ R, G, B¼ººÐÀ» ÃßÃâ
    valueR = input.*maskR;
    valueG = input.*maskG;
    valueB = input.*maskB;

    %% RED ¼ººÐ demosaicking 
    for j = 1 : row
        for i = 1 : col
            if (rem(j,2) == 1) && (rem(i,2) == 0) % È¦¼öÇà, Â¦¼ö¿­
                if i == col
                    valueR(j,i) = valueR(j, i-1);
                else
                valueR(j,i) = (valueR(j, i-1) + valueR(j, i+1)) / 2;
                end

            elseif (rem(j,2) == 0) && (rem(i,2) == 1) % Â¦¼öÇà, È¦¼ö¿­
                if j == row
                    valueR(j,i) = valueR(j-1,i);
                else
                valueR(j,i) = (valueR(j-1, i) + valueR(j+1, i)) / 2;
                end

            elseif (rem(j,2) == 0) && (rem(i,2) == 0) % Â¦¼öÇà, Â¦¼ö¿­
                if (i == col) && (j ~= row)
                    valueR(j,i) = (valueR(j-1, i-1) + valueR(j+1, i-1)) / 2;
                elseif (j == row) && (i ~= col)
                    valueR(j,i) = (valueR(j-1, i-1) +valueR(j-1, i+1)) / 2;
                elseif (j == row) && (i == col)
                    valueR(j,i) = valueR(j-1, i-1);
                else
                    temp = [valueR(j-1, i-1), valueR(j-1, i+1),  ...
                    valueR(j+1, i-1),  valueR(j+1, i+1)];
                    median2 = (sum(temp) - min(temp) - max(temp)) / 2;
                    gap_min = sigma * 1/((mean(temp) - min(temp))^2+1);
                    gap_max = sigma * 1/((mean(temp) - max(temp))^2+1);
                    gap_median = 1/((mean(temp) - median2)^2+0.00001);
                    
                    mi = gap_min / (gap_min + gap_max + gap_median);
                    ma = gap_max / (gap_min + gap_max + gap_median);
                    me = gap_median / (gap_min + gap_max + gap_median);
                    valueR(j,i) = me*median2 + mi*min(temp) + ma*max(temp);
                end
            end
        end
    end

    %% BLUE ¼ººÐ demoaicking 
    for j = 1 : row
        for i = 1 : col
            if (rem(j,2) == 1) && (rem(i,2) == 0) % È¦¼öÇà, Â¦¼ö¿­
                if j == 1
                    valueB(j,i) = valueB(j+1, i);
                else
                valueB(j,i) = (valueB(j+1, i) + valueB(j-1, i)) / 2;
                end

            elseif (rem(j,2) == 0) && (rem(i,2) == 1) % Â¦¼öÇà, È¦¼ö¿­
                if i == 1
                    valueB(j,i) = valueB(j,i+1);
                else
                valueB(j,i) = (valueB(j, i+1) + valueB(j, i-1)) / 2;
                end

            elseif (rem(j,2) == 1) && (rem(i,2) == 1) % È¦¼öÇà, È¦¼ö¿­
                if (i == 1) && (j == 1)
                    valueB(j,i) = valueB(j+1, i+1);
                elseif i == 1
                    valueB(j,i) = (valueB(j+1, i+1) +valueB(j-1, i+1)) / 2;
                elseif j == 1
                    valueB(j,i) = (valueB(j+1, i+1) + valueB(j+1, i-1)) / 2;
                else
                    temp = [valueB(j-1, i-1), valueB(j-1, i+1), ...
                    valueB(j+1, i-1), valueB(j+1, i+1)];
                    median2 = (sum(temp) - min(temp) - max(temp)) / 2;
                    gap_min = sigma * 1/((mean(temp) - min(temp))^2+1);
                    gap_max = sigma * 1/((mean(temp) - max(temp))^2+1);
                    gap_median = 1/((mean(temp) - median2)^2+0.00001);
                    
                    mi = gap_min / (gap_min + gap_max + gap_median);
                    ma = gap_max / (gap_min + gap_max + gap_median);
                    me = gap_median / (gap_min + gap_max + gap_median);
                    valueB(j,i) = me*median2 + mi*min(temp) + ma*max(temp);
                end
            end
        end
    end

    %% GREEN ¼ººÐ demosaicking 
    for j = 1 : row
        for i = 1 : col
            if ((rem(j,2) == 1) && (rem(i,2) == 1) || (rem(j,2) == 0) && (rem(i,2) == 0))% Â¦Â¦ or È¦È¦
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
                    temp = [valueG(j, i-1), valueG(j, i+1), ...
                    valueG(j+1, i), valueG(j-1, i)];
                    median2 = (sum(temp) - min(temp) - max(temp)) / 2;
                    gap_min = sigma * 1/((mean(temp) - min(temp))^2+1);
                    gap_max = sigma * 1/((mean(temp) - max(temp))^2+1);
                    gap_median = 1/((mean(temp) - median2)^2+0.00001);
                    
                    mi = gap_min / (gap_min + gap_max + gap_median);
                    ma = gap_max / (gap_min + gap_max + gap_median);
                    me = gap_median / (gap_min + gap_max + gap_median);
%                     disp(mi); disp(ma); disp(me);
                    valueG(j,i) = me*median2 + mi*min(temp) + ma*max(temp);
                end
            end
        end
    end
    output(:,:,1) = valueR;
    output(:,:,2) = valueG;
    output(:,:,3) = valueB;
end
