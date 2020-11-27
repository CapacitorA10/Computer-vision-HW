function output = my_kmeansYUV(image, k)

[row,col,dim] = size(image);
image2 = reshape(image,[row*col,dim]); % RGB 영역에서 kmeans를 하기 위해 이미지를 펼침
[col2, row2] = size(image2);
rand_k_Y = randi(255,[k,1]);
rand_k_U = randi([-111,111],[k,1]);
rand_k_V = randi([-156,156],[k,1]);  %각 영역별 최대값으로 k값 랜덤지정


rand_k(:,1) = rand_k_Y;
rand_k(:,2) = rand_k_U;
rand_k(:,3) = rand_k_V;


cluster_info = zeros(col2,1);

while(true)
    clust_distance = zeros(1,k);
    for i = 1 : col2
        for h = 1 : k
            clust_distance(1,h) = ((image2(i,1) - rand_k(h,1))^2 ...
                + (image2(i,2) - rand_k(h,2))^2 ...
                + (image2(i,3) - rand_k(h,3))^2);              %clust_distance 는 rand_k와의 거리를 계산한 값
        end
        cluster_info(i) = find(clust_distance == min(clust_distance),1); % 거리가 최소가 되는 순번(index) 대입
    end
    
    for g = 1 : k
        [X] = find(cluster_info == g);                                    %index로 분류된 이미지에서 각 순번별로 평균을 내기 위해 index의 index를 구함
        temp_mean = 0;
        for a = 1 : size(X,1)
            temp_mean = double(image2(X(a),:)) + temp_mean;
        end
        temp_mean(~isfinite(temp_mean))=0;
        rand_k(~isfinite(rand_k))=0;
        temp_mean = temp_mean / (size(X,1)+0.000001);
        temp_rand_k(g,:) = rand_k(g,:);
        rand_k(g,:) = temp_mean;                                            %새로운 평균값 대입
    end
    if sum(min(round(temp_rand_k) == round(rand_k)))
        break;
    end
end
result_cluster = zeros(col2, 3);
for i = 1 : col2
    for u = 1 : k
        if cluster_info(i,:) == u
            result_cluster(i,:) = rand_k(u,:);
        end
    end
end
image3 = reshape(result_cluster,[row,col,dim]);
output = image3;
end

                
