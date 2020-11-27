function output = my_kmeans(image, k)
image = double(image);
[row, col] = size(image);
rand_k = randi(255,1,k);
clust_distance = zeros(1,k);
image_vct = reshape(image, [],1);   %이미지를 하나의 벡터로 펼친 후 계산
cluster_info = zeros(size(image_vct));
while(true)
    cluster_info = reshape(cluster_info, [],1);
    for i = 1 : size(image_vct, 1)
            for h = 1 : k
                clust_distance(1,h) = abs(image_vct(i,1) - rand_k(1,h)); % 거리 계산
            end
            cluster_info(i,1) = find(clust_distance == min(clust_distance),1); % 거리가 최소가 되는 순번(index) 대입
    end
    
    cluster_info = reshape(cluster_info, row, col);
    for g = 1 : k
        [X,Y] = find(cluster_info == g);                                    %index로 분류된 이미지에서 각 순번별로 평균을 내기 위해 index의 index를 구함
        temp_mean = 0;
        for a = 1 : size(X,1)
            temp_mean = double(image(X(a,1),Y(a,1))) + temp_mean;
        end
        temp_mean = temp_mean / size(X,1);
        temp_rand_k(1,g) = rand_k(1,g);
        rand_k(1,g) = temp_mean;                                            %새로운 평균값 대입
    end
    if round(temp_rand_k) == round(rand_k)
        break;
    end
    if (sum(isnan(rand_k))) && (k < 20)
        rand_k = randi(255,1,k);                                            %NaN이 떴을 경우 재시행 K는 20으로 제한, 그 이상이면 그냥 무시
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

                
