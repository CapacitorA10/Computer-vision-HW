function output = my_kmeans(image, k)
image = double(image);
[row, col] = size(image);
rand_k = randi(255,1,k);
clust_distance = zeros(1,k);
image_vct = reshape(image, [],1);   %�̹����� �ϳ��� ���ͷ� ��ģ �� ���
cluster_info = zeros(size(image_vct));
while(true)
    cluster_info = reshape(cluster_info, [],1);
    for i = 1 : size(image_vct, 1)
            for h = 1 : k
                clust_distance(1,h) = abs(image_vct(i,1) - rand_k(1,h)); % �Ÿ� ���
            end
            cluster_info(i,1) = find(clust_distance == min(clust_distance),1); % �Ÿ��� �ּҰ� �Ǵ� ����(index) ����
    end
    
    cluster_info = reshape(cluster_info, row, col);
    for g = 1 : k
        [X,Y] = find(cluster_info == g);                                    %index�� �з��� �̹������� �� �������� ����� ���� ���� index�� index�� ����
        temp_mean = 0;
        for a = 1 : size(X,1)
            temp_mean = double(image(X(a,1),Y(a,1))) + temp_mean;
        end
        temp_mean = temp_mean / size(X,1);
        temp_rand_k(1,g) = rand_k(1,g);
        rand_k(1,g) = temp_mean;                                            %���ο� ��հ� ����
    end
    if round(temp_rand_k) == round(rand_k)
        break;
    end
    if (sum(isnan(rand_k))) && (k < 20)
        rand_k = randi(255,1,k);                                            %NaN�� ���� ��� ����� K�� 20���� ����, �� �̻��̸� �׳� ����
    elseif sum(isnan(rand_k))
        break;
    end
end
result_cluster = zeros(col, row);
for i = 1 : row
    for j = 1 : col
        for u = 1 : k
            if cluster_info(i,j) == u
                result_cluster(j,i) = rand_k(1,u);
            end
        end
    end
end

output = uint8(rot90(result_cluster,3));
end

                
