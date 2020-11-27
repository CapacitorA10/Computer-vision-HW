function output = my_kmeans5d(image, k, dt)
image = double(image);
[row,col,dim] = size(image);
x = (1:row)';
x = repmat(x, col,1);      %��ǥ ����
y = (1:col)';
y = repelem(y, row, 1);

image2 = zeros(row*col,dim+2);
image2(:,1:3) = reshape(image,[row*col,dim]); % RGB �������� kmeans�� �ϱ� ���� �̹����� ��ħ
image2(:,4) = x;
image2(:,5) = y;                              % ��ǥ�� ����

[col2, row2] = size(image2);
rand_k = randi(255,[k,3]);
rand_k(:,4) = randi(row,[k,1]);
rand_k(:,5) = randi(col,[k,1]);
cluster_info = zeros(col2,1);
clust_distance = zeros(1,k);
while(true)
    
    for i = 1 : col2
        for h = 1 : k
            clust_distance(1,h) = (((image2(i,1)) - rand_k(h,1))^2 ...
                + ((image2(i,2)) - rand_k(h,2))^2 ...
                + ((image2(i,3)) - rand_k(h,3))^2 ...
                + dt*((image2(i,4)) - rand_k(h,4))^2 ...
                + dt*((image2(i,5)) - rand_k(h,5))^2);              %clust_distance �� rand_k���� �Ÿ��� ����� ��
        end
        cluster_info(i) = find(clust_distance == min(clust_distance),1); % �Ÿ��� �ּҰ� �Ǵ� ����(index) ����
    end
    
    for g = 1 : k
        [X] = find(cluster_info == g);                                    %index�� �з��� �̹������� �� �������� ����� ���� ���� index�� index�� ����
        temp_mean = 0;
        for a = 1 : size(X,1)
            temp_mean = double(image2(X(a),:)) + temp_mean;
        end
        temp_mean(~isfinite(temp_mean))=0;
        rand_k(~isfinite(rand_k))=0;
        temp_mean = temp_mean / (size(X,1)+0.000001);                       %NaN ����
        temp_rand_k(g,:) = rand_k(g,:);
        rand_k(g,:) = temp_mean;                                            %���ο� ��հ� ����
    end
    if round(temp_rand_k) == round(rand_k)
        break;
    end
end
result_cluster = zeros(col2, 3);
for i = 1 : col2
    for u = 1 : k
        if cluster_info(i,:) == u
            result_cluster(i,:) = rand_k(u,1:3);
        end
    end
end
image3 = reshape(result_cluster,[row,col,dim]);
output = uint8(image3);
end

                
